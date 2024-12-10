@echo off
REM ************************************************************************
REM
REM                     Copyright (c) 2015
REM                     Siemens Industry Software.
REM                     All Rights Reserved
REM
REM File name
REM     nxacis.bat  
REM
REM Description
REM     Sets variables and runs the product
REM
REM Input
REM     %1% - Product installation directory
REM     %2% - UG installation directory
REM
REM Output
REM     None
REM
REM  
setlocal
set t=%1
set TARGET=%t:"=%
set UGII_NXACIS_DIR=%TARGET%
set base=%2
set BASE_DIR=%base:"=%
set PRODUCT=NXACIS
if not exist "%BASE_DIR%\nxbin" goto no_ug_installed
set PATH=%BASE_DIR%\nxbin;%PATH%
if "%DISPLAY%" == "" set DISPLAY=LOCALPC:0.0
if "%TARGET%" == "" "%BASE_DIR%\TRANSLATORS\%PRODUCT%\%PRODUCT%.exe"
if not "%TARGET%" == "" "%TARGET%\%PRODUCT%.exe"
goto S999_END
:no_ug_installed
echo.
echo You could not run %PRODUCT% because the NX install directory could
echo not be found.  Please install NX before attempting to run
echo this product.  If NX is installed, make sure to pass the
echo proper arguments to the batch script.
echo.
pause
:S999_END
endlocal
@echo on
