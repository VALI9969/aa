@echo off
rem ========================================================================= *
rem                                                                           *
rem       Copyright (c) 2005-2006 Unigraphics Solutions, Inc.
rem                  Unpublished - All rights reserved                        *
rem                                                                           *
rem ========================================================================= *
rem
rem File Name:  portal.bat
rem 
rem ========================================================================= 
rem
rem This script will set the appropriate variables and then launch Knowledge
rem Fusion Interactive Class Editor.
rem
rem Input Parameters:
rem
rem     None.
rem
rem
rem ========================================================================= 
rem  
rem
rem =========================================================================
rem
rem

REM This batch file will run Process Studio Authoring tool in stand-alone mode
REM
REM This assumes that you have the following environment setup
REM 
REM 1) JDK1.7 and above
REM

REM To avoid double double quotes later, remove any quotes that 
REM are part of the environment variable now
set UGII_BASE_DIR=%*
set UGII_BASE_DIR=%UGII_BASE_DIR:"=%

REM
REM  Check if UGII_BASE_DIR is installed.
REM
if EXIST "%UGII_BASE_DIR%" (
   echo NX path established. UGII_BASE_DIR=%UGII_BASE_DIR%
   echo.
) ELSE (
   echo NX path could not be established.  UGII_BASE_DIR not set.
   goto ERROR_EXIT
)
   
REM
REM Check if UGII_BASE_DIR really points to a valid directory.
REM
if not EXIST "%UGII_BASE_DIR%\nxbin" (
    echo UGII_BASE_DIR set to invalid NX install.
    goto ERROR_EXIT
)

REM
REM Check for NX license server
REM
if not defined SPLM_LICENSE_SERVER (
  echo ERROR: SPLM_LICENSE_SERVER is not defined.
  echo        Current Setting: %SPLM_LICENSE_SERVER%
  echo        Check:  SPLM_LICENSE_SERVER=28000@<server>.
  goto ERROR_EXIT
)


REM  

if not defined UGII_JAVA_HOME (
@for /f "tokens=*" %%I in (' "%UGII_BASE_DIR%\nxbin\env_print" UGII_JAVA_HOME') do set UGII_JAVA_HOME=%%I
)

if defined UGII_JAVA_HOME (
"%UGII_JAVA_HOME%\bin\java" -jar "%UGII_BASE_DIR%\nxbin\VerifyJava.jar" external "%UGII_JAVA_HOME%"
) else (
echo UGII_JAVA_HOME must be defined
goto ERROR_EXIT
)
if errorlevel 1 (
echo Java version is not supported
goto ERROR_EXIT
) else (
echo Java version is supported
set JAVA_COMMAND="%UGII_JAVA_HOME%\bin\java"
set JAVAW_COMMAND="%UGII_JAVA_HOME%\bin\javaw"
)


set PATH=%UGII_BASE_DIR%\nxbin;%PATH%
set CLASSPATH=".;../nxbin/NXOpen.jar;processstudio.jar;portal.jar;fscjavaclientproxy.jar;ugstudioplugin.jar;TcSoaClient.jar;TcSoaCommon.jar;TcSoaCoreStrong.jar;TcSoaCoreTypes.jar;TcSoaSampleStrong.jar;TcSoaSampleTypes.jar;TcSoaStrongModel.jar;TcSoaTools.jar;commons-httpclient-2_0_2.jar;fccjavaclientproxy.jar;fmsclientcache.jar;fmsutil.jar;jax-qname.jar;jaxb-api.jar;jaxb-impl.jar;jaxb-libs.jar;jaxb-xjc.jar;log4j-1.2.8.jar;namespace.jar;relaxngDatatype.jar;resolver.jar;xercesImpl.jar;xml-apis.jar;xmlParserAPIs.jar;xsdlib.jar;commons-logging.jar"

@echo Starting Process Studio...
set JAVA_COMMAND_LINE=%JAVA_COMMAND% -classpath %CLASSPATH% com.eds.plm.StudioApp.ProcessStudioMain  %1 %2 %3 %4 %5 %6 %7 %8 %9
REM set JAVA_COMMAND_LINE=%JAVA_COMMAND% -classpath %CLASSPATH% com.eds.plm.StudioApp.ProcessStudioMain  %1 %2 %3 %4 %5 %6 %7 %8 %9
@echo %JAVA_COMMAND_LINE%
%JAVA_COMMAND_LINE% 
goto END

:ERROR_EXIT
@echo.
@echo ERROR: Unable to launch Process Studio Author
@echo.

:END

