@echo off
setlocal EnableExtensions
rem Open VS Code and DOSBox-X for this repository on Windows.
rem Keep all project-specific configuration in the repository.

pushd "%~dp0" || exit /b 1
set "REPO_DIR=%CD%"

rem VS Code's code.cmd uses its own path to locate Code.exe.
rem Always CALL an absolute code.cmd path, never just "code.cmd".
set "VSCODE_CLI="
for /f "delims=" %%F in ('where.exe code.cmd 2^>nul') do (
    if not defined VSCODE_CLI if exist "%%~dpF..\Code.exe" set "VSCODE_CLI=%%~fF"
)
if not defined VSCODE_CLI if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd" set "VSCODE_CLI=%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd"
if not defined VSCODE_CLI if exist "%ProgramFiles%\Microsoft VS Code\bin\code.cmd" set "VSCODE_CLI=%ProgramFiles%\Microsoft VS Code\bin\code.cmd"
if not defined VSCODE_CLI if exist "%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd" set "VSCODE_CLI=%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd"

rem Fallback: launch Code.exe directly if its CLI wrapper is unavailable.
set "VSCODE_EXE="
if not defined VSCODE_CLI if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe" set "VSCODE_EXE=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
if not defined VSCODE_CLI if not defined VSCODE_EXE if exist "%ProgramFiles%\Microsoft VS Code\Code.exe" set "VSCODE_EXE=%ProgramFiles%\Microsoft VS Code\Code.exe"
if not defined VSCODE_CLI if not defined VSCODE_EXE if exist "%ProgramFiles(x86)%\Microsoft VS Code\Code.exe" set "VSCODE_EXE=%ProgramFiles(x86)%\Microsoft VS Code\Code.exe"

if defined VSCODE_CLI (
    call "%VSCODE_CLI%" "%REPO_DIR%"
    if errorlevel 1 echo Warning: VS Code CLI failed to open the repository.
) else if defined VSCODE_EXE (
    start "" "%VSCODE_EXE%" "%REPO_DIR%"
) else (
    echo Warning: VS Code was not found. Continuing with DOSBox-X.
)

rem DOSBox-X is installed on each host; its location can vary.
rem DOSBOX_X can point to its absolute executable path.
set "EMU="
if defined DOSBOX_X if exist "%DOSBOX_X%" set "EMU=%DOSBOX_X%"
if not defined EMU for /f "delims=" %%F in ('where.exe dosbox-x.exe 2^>nul') do if not defined EMU set "EMU=%%~fF"

rem Common locations for installer and extracted portable versions.
if not defined EMU if exist "%ProgramFiles%\DOSBox-X\dosbox-x.exe" set "EMU=%ProgramFiles%\DOSBox-X\dosbox-x.exe"
if not defined EMU if exist "%ProgramFiles%\DOSBox-X\Release SDL2\dosbox-x.exe" set "EMU=%ProgramFiles%\DOSBox-X\Release SDL2\dosbox-x.exe"
if not defined EMU if exist "%ProgramFiles%\DOSBox-X\Release\dosbox-x.exe" set "EMU=%ProgramFiles%\DOSBox-X\Release\dosbox-x.exe"
if not defined EMU if exist "%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe" set "EMU=%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe"
if not defined EMU if exist "%ProgramFiles(x86)%\DOSBox-X\Release SDL2\dosbox-x.exe" set "EMU=%ProgramFiles(x86)%\DOSBox-X\Release SDL2\dosbox-x.exe"
if not defined EMU if exist "%LOCALAPPDATA%\Programs\DOSBox-X\dosbox-x.exe" set "EMU=%LOCALAPPDATA%\Programs\DOSBox-X\dosbox-x.exe"

if not defined EMU (
    echo.
    echo DOSBox-X was not found. Its installation directory may not be on PATH.
    echo Find the actual dosbox-x.exe and run these commands in PowerShell:
    echo   $env:DOSBOX_X = 'C:\path\to\dosbox-x.exe'
    echo   .\run-dosbox-x.bat
    echo.
    echo DOSBox-X download: https://dosbox-x.com/
    popd
    exit /b 1
)

"%EMU%" -conf "%REPO_DIR%\dosbox-x.conf"
set "STATUS=%errorlevel%"
popd
exit /b %STATUS%
