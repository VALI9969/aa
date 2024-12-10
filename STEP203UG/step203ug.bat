@echo off
rem
rem File Name:  STEP203UG.BAT  
rem 
rem ************************************************************************
rem
rem This script will set the appropriate variables and then run the product 
rem in question.
rem
rem Copyright (c) 1997-2001
rem Unigraphics Solutions, Cypress, CA 90630
rem All Rights Reserved
rem
rem Input Parameters:
rem
rem %1% - Parameter for where product is installed.
rem %2% - Where UG is installed.
rem %3% - Parameter for running from icon (either "auto" or blank).
rem
rem ************************************************************************
rem Revision History:
rem
rem REV   AUTHOR      DATE      COMMENT
rem ===   ======      =======   =======
rem 001   B. King     22May97   Initial V13.0 version for Windows NT.
rem 002   B. King     01Aug97   Modified to work if not installed under
rem                             UGII_BASE_DIR. 
rem 003   R. King     21Oct99   Changed order of %PATH% variable. 
rem 004   R. King     28Jan00   Initial V17.0 version. 
rem 005   K. Hafen    10Jan01   Support spaces in directories
rem 006   Ed King    1121268    03Jan02   Pass UGII_BASE_DIR (%2) to the translator cmd file
rem 007   Ed King     25Jan02   Put double quotes arround %2 passed to cmd file, 
rem                             needed when UG has space in the directory name
rem 005   K. Hafen    10Jan01   Support spaces in directories
rem 008   A. Kanaskar 11May15   ARCH11323: change to nxbin structure
rem ************************************************************************
rem
setlocal
set t=%1
set TARGET=%t:"=%
set base=%2
set BASE_DIR=%base:"=%
set PRODUCT=STEP203ug
if not exist "%BASE_DIR%\ugii" goto no_ug_installed
set PATH=%BASE_DIR%\nxbin;%PATH%
if "%3%" == "" goto no_auto
cd /d %HOMEDRIVE%%HOMEPATH%
:no_auto
if "%DISPLAY%" == "" set DISPLAY=LOCALPC:0.0
if "%TARGET%" == "" set STEP203UG_DIR=%BASE_DIR%\%PRODUCT%\
if not "%TARGET%" == "" set STEP203UG_DIR=%TARGET%\
if "%TARGET%" == "" "%BASE_DIR%\%PRODUCT%\%PRODUCT%.cmd" "%BASE_DIR%"
if not "%TARGET%" == "" "%TARGET%\%PRODUCT%.cmd" "%BASE_DIR%"
goto S999_END
:no_ug_installed
echo.
echo You could not run %PRODUCT% because the UG install directory could
echo not be found.  Please install Unigraphics before attempting to run
echo this product.  If Unigraphics is installed, make sure to pass the
echo proper arguments to the batch script.
echo.
pause
:S999_END
endlocal
@echo on
