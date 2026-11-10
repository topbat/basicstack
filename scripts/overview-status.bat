@echo off
rem =========================================================================
rem overview-status.bat - Snapshot "docker compose ps" into
rem                       overview-status.json for the overview page
rem                       served by the local nginx web root.
rem
rem Output: %SITE_DIR%\overview-status.json
rem   { "generatedAt": ISO8601, "services": [ { name, state, health, ports } ] }
rem
rem Exits with code 1 when docker is unavailable, compose fails, or the
rem output cannot be parsed. Accepts both JSON Lines and a single JSON
rem array from "docker compose ps --format json". Empty output (no running
rem containers) is a valid state and yields an empty services array.
rem =========================================================================
setlocal
set "REPO=D:\local\basic-service"
set "COMPOSE_FILE=%REPO%\docker-compose.yml"
set "SITE_DIR=D:\local\basic-service-data\nginx\html"

docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] docker is not available in PATH. Start Docker Desktop first.
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { [Console]::OutputEncoding=[System.Text.Encoding]::UTF8 } catch { }; $compose='%COMPOSE_FILE%'; $out='%SITE_DIR%\overview-status.json'; $lines=@(& docker compose -f $compose ps --format json); if ($LASTEXITCODE -ne 0) { [Console]::Error.WriteLine('docker compose ps failed with exit code ' + $LASTEXITCODE + '. Check the docker daemon and the compose file.'); exit 1 }; $text=[string]::Join([char]10, @($lines)).Trim(); $objs=@(); try { $objs=@((ConvertFrom-Json $text -ErrorAction Stop) | ForEach-Object { $_ }) } catch { $objs=@() }; if (-not $objs) { foreach ($ln in @($lines)) { $t=('' + $ln).Trim(); if (-not $t) { continue }; try { $objs += @((ConvertFrom-Json $t -ErrorAction Stop) | ForEach-Object { $_ }) } catch { } } }; if ($text.Length -gt 0 -and -not $objs) { [Console]::Error.WriteLine('Unable to parse docker compose ps output as JSON.'); exit 1 }; $services=@(); foreach ($o in @($objs)) { if ($null -eq $o) { continue }; $ports=''; $health=''; if ($o.PSObject.Properties.Name -contains 'Ports' -and $o.Ports) { $ports=[string]$o.Ports } elseif ($o.PSObject.Properties.Name -contains 'Publishers' -and $o.Publishers) { $parts=@(); foreach ($pp in @($o.Publishers)) { $parts += ([string]$pp.Published + ':' + [string]$pp.Target) }; $ports=($parts -join ', ') }; if ($o.PSObject.Properties.Name -contains 'Health' -and $o.Health) { $health=[string]$o.Health }; $services += ,[pscustomobject]@{ name=[string]$o.Name; state=[string]$o.State; health=$health; ports=$ports } }; $doc=[pscustomobject]@{ generatedAt=(Get-Date).ToUniversalTime().ToString('o'); services=@($services) }; $json=ConvertTo-Json -InputObject $doc -Depth 4; $dir=Split-Path -Parent $out; if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }; Set-Content -LiteralPath $out -Value $json -Encoding utf8; Write-Host ('overview-status.json written: ' + @($services).Count + ' services'); exit 0"
if errorlevel 1 (
    echo [ERROR] Failed to collect compose status into "%SITE_DIR%\overview-status.json".
    exit /b 1
)

echo Done. Open http://127.0.0.1/overview.html to view the service status.
endlocal
exit /b 0
