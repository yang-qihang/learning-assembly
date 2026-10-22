@echo off
setlocal
rem Open VS Code and DOSBox-X from any directory, including by double-clicking.
pushd "%~dp0" || exit /b 1

rem Open this repository in VS Code. Prefer the command-line entry point.
rem CALL is important: code.cmd is a batch file, and control must return here.
set "CODE_CLI="
where code.cmd >nul 2>&1 && set "CODE_CLI=code.cmd"
if not defined CODE_CLI if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd" set "CODE_CLI=%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd"
if not defined CODE_CLI if exist "%ProgramFiles%\Microsoft VS Code\bin\code.cmd" set "CODE_CLI=%ProgramFiles%\Microsoft VS Code\bin\code.cmd"
if not defined CODE_CLI if exist "%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd" set "CODE_CLI=%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd"

if defined CODE_CLI (
    call "%CODE_CLI%" .
    if errorlevel 1 echo Warning: VS Code could not be opened. Continuing with DOSBox-X.
) else (
    echo Warning: VS Code's code.cmd was not found. Continuing with DOSBox-X.
    echo To enable auto-opening VS Code, install it and add its bin directory to PATH.
)

rem If DOSBOX_X names an executable, use it. Otherwise, check PATH.
set "EMU="
if defined DOSBOX_X set "EMU=%DOSBOX_X%"
if not defined EMU (
    where dosbox-x.exe >nul 2>&1 && set "EMU=dosbox-x.exe"
)

rem These are convenience fallbacks; Windows installations can use other paths.
if not defined EMU if exist "%ProgramFiles%\DOSBox-X\dosbox-x.exe" set "EMU=%ProgramFiles%\DOSBox-X\dosbox-x.exe"
if not defined EMU if exist "%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe" set "EMU=%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe"

if not defined EMU (
    echo DOSBox-X was not found.
    echo Add dosbox-x.exe to PATH, or set DOSBOX_X to its full path.
    echo Example from PowerShell:
    echo   $env:DOSBOX_X = 'C:\Tools\DOSBox-X\Release SDL2\dosbox-x.exe'
    popd
    exit /b 1
)

"%EMU%" -conf "%CD%\dosbox-x.conf"
set "STATUS=%errorlevel%"
popd
exit /b %STATUS%
