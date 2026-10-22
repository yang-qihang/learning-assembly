@ECHO OFF

REM ==========================================
REM BUILD.BAT - MASM 5.00 + LINK 3.60
REM Usage: BUILD filename
REM Example: BUILD CH07_01
REM ==========================================

REM Validate arguments.
IF "%1"=="" GOTO USAGE
IF NOT "%2"=="" GOTO USAGE

REM Check whether the source file exists.
IF NOT EXIST %1.ASM GOTO NO_SOURCE

REM Remove previous build artifacts.
IF EXIST %1.OBJ DEL %1.OBJ
IF EXIST %1.OBJ GOTO CLEAN_ERROR

IF EXIST %1.EXE DEL %1.EXE
IF EXIST %1.EXE GOTO CLEAN_ERROR

REM Assemble.
ECHO.
ECHO Assembling %1.ASM...
MASM %1.ASM,%1.OBJ;
IF ERRORLEVEL 1 GOTO ASM_ERROR
IF NOT EXIST %1.OBJ GOTO ASM_ERROR

REM Link.
ECHO.
ECHO Linking %1.OBJ...
LINK %1.OBJ,%1.EXE;
IF ERRORLEVEL 1 GOTO LINK_ERROR
IF NOT EXIST %1.EXE GOTO LINK_ERROR

REM Success.
ECHO.
ECHO Build successful: %1.EXE
GOTO END

:USAGE
ECHO.
ECHO Usage: BUILD filename
ECHO Example: BUILD CH07_01
ECHO Specify the filename WITHOUT .ASM.
GOTO END

:NO_SOURCE
ECHO.
ECHO ERROR: Source file %1.ASM not found.
ECHO Check your filename and directory.
GOTO END

:CLEAN_ERROR
ECHO.
ECHO ERROR: Cannot remove previous build files.
ECHO Check file permissions.
GOTO END

:ASM_ERROR
ECHO.
ECHO ERROR: Assembly failed.
ECHO Linking skipped.
GOTO END

:LINK_ERROR
ECHO.
ECHO ERROR: Linking failed.
GOTO END

:END