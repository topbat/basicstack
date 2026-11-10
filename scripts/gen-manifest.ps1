# =====================================================================
# gen-manifest.ps1 - Generate site-manifest.json for BasicStack.
#
# Whitelist-based recursive collector: only the files/directories listed
# below are included, and only when they actually exist on disk. The
# output file itself (site-manifest.json) is excluded from its own list.
#
# Field names follow the consumer page site/publish.html EXACTLY:
#   - files[].path   : repo-relative path, "/" separators
#   - files[].bytes  : size in bytes (this is the field publish.html reads)
#   - files[].group  : docs / site / config / scripts / brand
#   - "size" is also emitted as an alias of "bytes" for other tooling
#   - top-level "version" is parsed from the first "## [x.y.z]" heading
#     in CHANGELOG.md (fallback: v1.0.0)
#
# ASCII-only on purpose: Windows PowerShell 5.1 may misread non-ASCII
# string literals depending on the active code page. Keep this file
# pure ASCII (comments included).
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File gen-manifest.ps1
# =====================================================================

$ErrorActionPreference = 'Stop'

# Repo root = parent directory of scripts/ (where this file lives).
$repoRoot = Split-Path -Parent $PSScriptRoot
$outPath  = Join-Path $repoRoot 'site-manifest.json'

# ---- Whitelist: single files (collected only when they exist) ----
$singleFiles = @(
    'docker-compose.yml',
    'README.md',
    'CHANGELOG.md',
    'LICENSE',
    '.gitignore',
    'milvus/embedEtcd.yaml',
    'pgadmin/servers.json',
    'mineru/Dockerfile'
)

# ---- Whitelist: directories (recursed, only when they exist) ----
$whitelistDirs = @(
    'site',
    'assets/brand',
    'scripts',
    'docs',
    '.github',
    'nginx/conf.d',
    'mysql/init',
    'postgres/init',
    'clickhouse/config.d'
)

# ---- Hard exclusions: never collected, even inside whitelisted dirs ----
$excludeNames = @(
    'agent-evolution-ppt',
    'projects',
    'diagram-plugin-mcp-skill',
    'render.py',
    '.mimosa',
    '.git',
    'data',
    'node_modules'
)

# Output file excluded from itself.
$outputFileName = 'site-manifest.json'

function Test-Excluded([string] $relPath) {
    if ($relPath -eq $outputFileName) { return $true }
    foreach ($name in $excludeNames) {
        if ($relPath -eq $name) { return $true }
        if ($relPath -like ($name + '/*')) { return $true }
    }
    return $false
}

# Group mapping matches the GROUP_LABELS keys used by site/publish.html.
function Get-Group([string] $relPath) {
    if ($relPath -like 'assets/brand/*') { return 'brand' }
    if ($relPath -like 'scripts/*')      { return 'scripts' }
    if ($relPath -like 'docs/*')         { return 'docs' }
    if (@('README.md', 'CHANGELOG.md', 'LICENSE') -contains $relPath) { return 'docs' }
    foreach ($prefix in @('nginx/', 'mysql/', 'postgres/', 'clickhouse/', 'milvus/', 'pgadmin/', 'mineru/')) {
        if ($relPath.StartsWith($prefix)) { return 'config' }
    }
    # docker-compose.yml, site/, .github/ and anything else -> site
    return 'site'
}

$script:collected = @()

function Add-FileEntry([string] $fullPath) {
    $rel = $fullPath.Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')
    if ($rel.Length -eq 0) { return }
    if (Test-Excluded $rel) { return }
    $size = (Get-Item -LiteralPath $fullPath).Length
    $script:collected += , ([pscustomobject]@{
        path  = $rel
        size  = $size
        bytes = $size
        group = (Get-Group $rel)
    })
}

foreach ($rel in $singleFiles) {
    $p = Join-Path $repoRoot ($rel.Replace('/', '\'))
    if (Test-Path -LiteralPath $p -PathType Leaf) { Add-FileEntry $p }
}

foreach ($dir in $whitelistDirs) {
    $p = Join-Path $repoRoot ($dir.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $p -PathType Container)) { continue }
    Get-ChildItem -LiteralPath $p -Recurse -File |
        ForEach-Object { Add-FileEntry $_.FullName }
}

# Sort the file array by path using ORDINAL (byte-wise) comparison,
# so the JSON order matches plain code-point sorting in any consumer.
$entriesByPath = @{}
foreach ($e in $script:collected) { $entriesByPath[[string]$e.path] = $e }
$sortedPaths = @($entriesByPath.Keys)
[System.Array]::Sort($sortedPaths, [System.StringComparer]::Ordinal)
$files = @($sortedPaths | ForEach-Object { $entriesByPath[$_] })

# Version from the first "## [major.minor.patch]" heading in CHANGELOG.md.
$version = 'v1.0.0'
$changelogPath = Join-Path $repoRoot 'CHANGELOG.md'
if (Test-Path -LiteralPath $changelogPath -PathType Leaf) {
    $headLines = @(Get-Content -LiteralPath $changelogPath -TotalCount 40)
    foreach ($line in $headLines) {
        if ($line -match '^##\s*\[([0-9]+\.[0-9]+\.[0-9]+)\]') {
            $version = 'v' + $Matches[1]
            break
        }
    }
}

$manifest = [pscustomobject]@{
    manifestVersion = 1
    name            = 'basic-service'
    version         = $version
    generatedAt     = (Get-Date).ToUniversalTime().ToString('o')
    files           = @($files)
}

$json = ConvertTo-Json -InputObject $manifest -Depth 4

# Write UTF-8 WITHOUT BOM (PowerShell 5.1's Out-File/Set-Content utf8 adds a BOM).
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($outPath, $json + "`n", $utf8NoBom)

$totalBytes = ($files | Measure-Object -Property bytes -Sum).Sum
if ($null -eq $totalBytes) { $totalBytes = 0 }
Write-Host ('Manifest written: ' + $files.Count + ' files, ' + $totalBytes + ' bytes total')
