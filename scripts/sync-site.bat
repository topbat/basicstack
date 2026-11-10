@echo off
rem =========================================================================
rem sync-site.bat - Build the manifest and sync the BasicStack site files
rem                 to the local nginx web root.
rem
rem Steps:
rem   1. Run gen-manifest.ps1 to regenerate site-manifest.json (repo root).
rem   2. Copy site\*.html into the nginx html root.
rem   3. Copy assets\brand into the nginx html root (recursive).
rem   4. Copy site-manifest.json into the nginx html root.
rem
rem After sync, open:
rem   http://127.0.0.1/overview.html
rem   http://127.0.0.1/publish.html
rem =========================================================================
setlocal
set "REPO=D:\local\basic-service"
set "SITE_DIR=D:\local\basic-service-data\nginx\html"

echo [1/4] Generating site-manifest.json ...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0gen-manifest.ps1"
if errorlevel 1 (
    echo [ERROR] gen-manifest.ps1 failed. Sync aborted.
    exit /b 1
)

if not exist "%SITE_DIR%\" (
    mkdir "%SITE_DIR%"
)

echo [2/4] Copying site HTML pages ...
xcopy /Y "%REPO%\site\*.html" "%SITE_DIR%\" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy site HTML pages to "%SITE_DIR%".
    exit /b 1
)

echo [3/4] Copying brand assets ...
xcopy /E /I /Y "%REPO%\assets\brand" "%SITE_DIR%\assets\brand" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy brand assets to "%SITE_DIR%\assets\brand".
    exit /b 1
)

echo [4/4] Copying site-manifest.json ...
copy /Y "%REPO%\site-manifest.json" "%SITE_DIR%\" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy site-manifest.json to "%SITE_DIR%".
    exit /b 1
)

echo.
echo Sync done. Open http://127.0.0.1/overview.html and http://127.0.0.1/publish.html
endlocal
exit /b 0
