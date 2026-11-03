@echo off
setlocal
cd /d "%~dp0"

echo.
echo === Maritime English - deploy ===

rem --- find mkdocs: PATH first, then tools.json (portable Python)
set "MKDOCS="
for /f "delims=" %%i in ('where mkdocs 2^>nul') do if not defined MKDOCS set "MKDOCS=%%i"

if not defined MKDOCS (
  del "%TEMP%\mkdocs_path.txt" 2>nul
  powershell -NoProfile -Command "$py=(Get-Content -Raw ($env:USERPROFILE + '\tools\tools.json') | ConvertFrom-Json).paths.python; if($py){$m=Join-Path $py 'mkdocs.exe'; if(Test-Path $m){[IO.File]::WriteAllText(($env:TEMP + '\mkdocs_path.txt'), $m)}}"
  if exist "%TEMP%\mkdocs_path.txt" set /p MKDOCS=<"%TEMP%\mkdocs_path.txt"
  del "%TEMP%\mkdocs_path.txt" 2>nul
)

if not defined MKDOCS (
  echo [ERROR] mkdocs not found.
  echo         Install it: pip install mkdocs
  echo.
  pause
  exit /b 1
)

echo mkdocs: %MKDOCS%
echo.

rem --- build site and push gh-pages branch
"%MKDOCS%" gh-deploy
if errorlevel 1 (
  echo.
  echo [ERROR] gh-deploy failed.
  echo.
  pause
  exit /b 1
)

echo.
echo === Checking git status ===
set "DIRTY="
for /f "delims=" %%i in ('git status --porcelain 2^>nul') do set "DIRTY=1"
if defined DIRTY (
  echo [WARN] Uncommitted changes detected.
  echo        Site was built from working copy, master is behind:
  echo.
  git status --short
) else (
  echo [OK] Working tree is clean.
)

echo.
echo Done. Branch gh-pages updated.
echo Pages source: branch gh-pages, folder /.
echo.
pause
