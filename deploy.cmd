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

rem --- warn if root copies have local edits (they will be overwritten)
set "ROOTCHG="
for /f "delims=" %%i in ('git status --porcelain -- Unit-1 Unit-2 2^>nul') do set "ROOTCHG=1"
if defined ROOTCHG (
  echo.
  echo [WARN] Root Unit copies have local changes:
  git status --short -- Unit-1 Unit-2
  echo        docs/ is the source of truth. These changes will be overwritten.
  echo        Press any key to continue, or close this window to abort.
  pause >nul
)

rem --- sync root copies from docs
echo.
echo === Sync root copies ===
for /d %%d in (docs\Unit-*) do (
  if exist "%%d" (
    if exist "%%~nxd" rd /s /q "%%~nxd"
    xcopy /e /i /y /q "%%d" "%%~nxd" >nul
    echo   synced %%~nxd
  )
)
if errorlevel 2 (
  echo [ERROR] copy failed.
  echo.
  pause
  exit /b 1
)

rem --- commit everything
echo.
echo === Commit ===
git add -A
git diff --cached --quiet >nul 2>&1
if errorlevel 1 (
  git commit -m "chore: update lessons and sync copies"
  if errorlevel 1 (
    echo [ERROR] commit failed.
    echo.
    pause
    exit /b 1
  )
) else (
  echo [OK] Nothing to commit.
)

rem --- build site and push gh-pages branch
echo.
echo === Deploy ===
"%MKDOCS%" gh-deploy
if errorlevel 1 (
  echo.
  echo [ERROR] gh-deploy failed.
  echo.
  pause
  exit /b 1
)

echo.
echo Done. Last commit:
git log --oneline -1
echo.
echo Push to GitHub when you are ready:  git push
echo.
pause
