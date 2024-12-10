@echo off
REM
REM   step203ug.cmd - Shell script to invoke the Unigraphics STEP AP203
REM               executable with the correct environment settings.
REM
REM   NOTE :  This script assumes that UG and STEP203UG have both been 
REM           installed AND that the following UG environment variables
REM           are defined :
REM
REM   Possible arg1 actions
REM     ARG1           ACTION
REM     ----           ------
REM     null           Set BASE_DIR from the env and call the JAVA UI
REM     UGII_BASE_DIR  Set BASE_DIR from arg1 and call the JAVA UI
REM     part file      Set BASE_DIR from the env and call the command line UI
REM
rem ************************************************************************
rem Revision History:
rem
rem REV   AUTHOR      PR        DATE      COMMENT
rem ===   ======      ========  =======   =======
rem 001   Ed King     1121268   03Jan02   Process first arg as null, ugii_base_dir 
rem                                       or part name
rem 002   Ed King               22Jan02   Fix the case where the first arg contains a
rem                                       space (ie c:\Program Files)
rem 003   Ed King               21Mar02   Fix the " on STEP203UG_DIR
rem 004   Ed King     4480848   05Apr02   add -DSTEP203UG_DIR to java call
rem       S. Niblack  4541710   25Jun02   Check for new iMAN & Portal command
rem                                       line options.
rem       Ed King     1254682   18Dec03   Change ' to " on corba test
rem       Ed King               07Mar04   Allow trailing backslash on First arg
rem       Ed King               07Mar04   Allow trailing backslash on First arg
rem       Ed King               10Sep05   Relocate JRE and JAR
rem       Jim Jenkins 5023132   24Aug06   Novell system fix (evidently %user%
rem                                       might be defined on a Novell system
rem                                       so switched to tmp_user, tmp_passwd
rem                                       and tmp_group)
rem       Anil        5889219   12Feb08   Check for new Portal command line 
rem                                       options when SOA is enabled.
rem       Anil                  10Nov09   Add new arguments-sso_login_url & 
rem                                       -sso_app_id
rem       Anil                  13May11   Add new arguments-tccs_env_name 
rem       Anil                  19Mar12   Add new arguments -http_url & -http_vmid
rem       Anil Suryawanshi      18May12   Add code check JRE version
rem       Anil Suryawanshi      27Jun12   Use BASE_DIR for VerifyJava.jar
rem       Chintan Shah          21Feb14   Set UGII_TMP_DIR and pass it to xlatorui.
rem       Chintan Shah          07Oct14   Set UGII_CSHELP_DOCS and pass it to xlatorui.
rem       Anil Suryawanshi      12Mar15   Add support for -pf argument
rem		  Sagar Dhongade 7334359 01Apr15  Replaced UGII_BASE_DIR with BASE_DIR in 
rem										  :JREERROR to print appropriate error msg
rem       Ajaya Sutar           16Apr15   ARCH11323: Changed env_print and VerifyJava path to nxbin
rem       Rahul Jawalge         22May15   ARCH11323: changes for loading STEP library from NXbin
rem ************************************************************************
rem

REM set a default in case the first arg is not UGII_BASE_DIR
set BASE_DIR=%UGII_BASE_DIR%

REM remove the double quotes from the first arg if present
set arg1=%1
set ARG1_WITHOUT_QUOTES=%arg1:"=%

REM If first arg is UGII_BASE_DIR reset BASE_DIR
if exist "%ARG1_WITHOUT_QUOTES%\ugii" set BASE_DIR=%ARG1_WITHOUT_QUOTES%

if "%STEP203UG_DIR%" == "" set STEP203UG_DIR=%BASE_DIR%\step203ug\


set ROSE_DB=%STEP203UG_DIR%\
set ROSE=%STEP203UG_DIR%\

REM If first arg is UGII_BASE_DIR process as java gui
if exist "%ARG1_WITHOUT_QUOTES%\ugii" goto JAVA_GUI

REM If the first arg is null process as java gui
if {%1} == {} goto JAVA_GUI

REM  Process all of the input parameters.  NT removes the = from the
REM  o=value part of the input so we have to rebuild it.
REM  DOS is stupid so have to account for lower and UPPER case input
:Loop
if '%1'=='' goto PARMDONE
if '%1'=='o' goto OUT
if '%1'=='O' goto OUT
if '%1'=='l' goto LOG
if '%1'=='L' goto LOG
if '%1'=='d' goto DEF
if '%1'=='D' goto DEF
if '%1'=='m' goto MODE
if '%1'=='M' goto MODE
if '%1'=='s' goto STEP
if '%1'=='S' goto STEP
if '%1'=='i' goto INDIV
if '%1'=='I' goto INDIV
if '%1'=='-pim' goto PIM1
if '%1'=='-pim:yes' goto PIM2
if '%1'=='-corba_ior_file' goto CORBA1
if '%1'=='-u' goto USER
if '%1'=='-p' goto PASSWD
if '%1'=='-pf' goto PASSWD
if '%1'=='-g' goto GROUP
if '%1'=='-soa_iiop_string' goto SOASTRING
if '%1'=='-corba_soa_ior_file' goto SOACORBA1
if '%1'=='-sso_login_url' goto SSOLOGINURL
if '%1'=='-sso_app_id' goto SSOAPPID
if '%1'=='-tccs_env_name' goto TCCSENVNAME
if '%1'=='-http_url' goto HTTPURL
if '%1'=='-http_vmid' goto HTTPVMID

REM <WSNiblack 25Jun02> PR 4541710
REM One more check for the -corba_ior_file.  It sometimes comes in wrapped
REM in double quotes so that it doesn't get separated from it's file name.
REM Here we need to strip the double quotes and strip of the "=<filename>."
REM Then we can make another test for the -corba_ior_file.
REM <Anil Suryawanshi> 12Feb08 PR 5889219
REM Need to make same changes for soa_iiop_string & corba_soa_ior_file
REM <Anil Suryawanshi> 19Mar12 PR 6681524 
REM add support for -http_url and -http_vmid

set arg1=%1
set ARG1_WITHOUT_QUOTES=%arg1:"=%
set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,15%
if "%ARG1_WITHOUT_FILE%"=="-corba_ior_file" goto CORBA2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,16%
if "%ARG1_WITHOUT_FILE%"=="-soa_iiop_string" goto SOASTRING2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,19%
if "%ARG1_WITHOUT_FILE%"=="-corba_soa_ior_file" goto SOACORBA2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,14%
if "%ARG1_WITHOUT_FILE%"=="-sso_login_url" goto SSOLOGINURL2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,11%
if "%ARG1_WITHOUT_FILE%"=="-sso_app_id" goto SSOAPPID2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,14%
if "%ARG1_WITHOUT_FILE%"=="-tccs_env_name" goto TCCSENVNAME2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,9%
if "%ARG1_WITHOUT_FILE%"=="-http_url" goto HTTPURL2

set ARG1_WITHOUT_FILE=%ARG1_WITHOUT_QUOTES:~0,10%
if "%ARG1_WITHOUT_FILE%"=="-http_vmid" goto HTTPVMID2

REM Handle any other char=param parameters as invalid input

for %%v in (a b c e f g h j k m n p q r t u v w x y z) do if '%1'=='%%v' goto Invalid

for %%v in (A B C E F G H J K M N P Q R T U V W X Y Z) do if '%1'=='%%v' goto Invalid

REM otherwise default to this being the input file parameter

goto INPUT

REM Commands to build the o=outputfile parameter

:OUT
set out=%1
shift
set outval=%1
set fullout=''
if '%outval%'=='' goto NextParm
set fullout=%out%=%outval%
goto NextParm

REM Commands to build the l=logfile parameter

:LOG
set out=%1
shift
set logval=%1
set fulllog=''
if '%logval%'=='' goto NextParm
set fulllog=%out%=%logval%
goto NextParm

REM Commands to build the d=deffile parameter

:DEF
set out=%1
shift
set defval=%1
set fulldef=''
if '%defval%'=='' goto NextParm
set fulldef=%out%=%defval%
goto NextParm

REM Commands to build the m=mode parameter

:MODE
set out=%1
shift
set modeval=%1
set fullmode=''
if '%modeval%'=='' goto NextParm
set fullmode=%out%=%modeval%
goto NextParm

REM Commands to pass the inputfile parameter

:INPUT
set input=%1
goto NextParm

REM <WSNiblack 25Jun02> PR 4541710
REM -pim, -corba_ior_file, -u, -p, and -g are iMAN and Portal
REM options that need to be passed onto UF_UGMGR_initialize.

:PIM1
set out=%1
shift
set outval=%1
set pim=''
if '%outval%'=='' goto NextParm
set pim=%out%=%outval%
goto NextParm

:PIM2
set pim=%1
goto NextParm

:CORBA1
set out=%1
shift
set outval=%1
set corba=''
if '%outval%'=='' goto NextParm
set corba=%out%=%outval%
goto NextParm

:CORBA2
set corba=%1
goto NextParm

:USER
set out=%1
shift
set outval=%1
set tmp_user=''
if '%outval%'=='' goto NextParm
set tmp_user=%out%=%outval%
goto NextParm

:PASSWD
set out=%1
shift
set outval=%1
set tmp_passwd=''
if '%outval%'=='' goto NextParm
set tmp_passwd=%out%=%outval%
goto NextParm

:GROUP
set out=%1
shift
set outval=%1
set tmp_group=''
if '%outval%'=='' goto NextParm
set tmp_group=%out%=%outval%
goto NextParm

:SOASTRING
set out=%1
shift
set outval=%1
set soastring=''
if '%outval%'=='' goto NextParm
set soastring=%out%=%outval%
goto NextParm

:SOASTRING2
set soastring=%1
goto NextParm

:SOACORBA1
set out=%1
shift
set outval=%1
set soacorba=''
if '%outval%'=='' goto NextParm
set soacorba=%out%=%outval%
goto NextParm

:SOACORBA2
set soacorba=%1
goto NextParm

:SSOLOGINURL
set out=%1
shift
set outval=%1
set sssologinurl=''
if '%outval%'=='' goto NextParm
set sssologinurl=%out%=%outval%
goto NextParm

:SSOLOGINURL2
set sssologinurl=%1
goto NextParm

:SSOAPPID
set out=%1
shift
set outval=%1
set ssoappid=''
if '%outval%'=='' goto NextParm
set ssoappid=%out%=%outval%
goto NextParm

:SSOAPPID2
set ssoappid=%1
goto NextParm

:TCCSENVNAME
set out=%1
shift
set outval=%1
set tccsenvname=''
if '%outval%'=='' goto NextParm
set tccsenvname=%out%=%outval%
goto NextParm

:TCCSENVNAME2
set tccsenvname=%1
goto NextParm

:HTTPURL
set out=%1
shift
set outval=%1
set httpurl=''
if '%outval%'=='' goto NextParm
set httpurl=%out%=%outval%
goto NextParm

:HTTPURL2
set httpurl=%1
goto NextParm

:HTTPVMID
set out=%1
shift
set outval=%1
set httpvmid=''
if '%outval%'=='' goto NextParm
set httpvmid=%out%=%outval%
goto NextParm

:HTTPVMID2
set httpvmid=%1
goto NextParm

REM point to the next parameter and start all over

:NextParm
shift
goto Loop

REM the STEP and INDIV targets will be implemented for IMAN integration
REM otherwise this is any other char=value input param.  Done here to
REM prevent overwritting the input file parameter

:STEP
:INDIV
:Invalid
shift
shift
goto Loop

:JAVA_GUI
set PATH=%BASE_DIR%\NXBIN;%PATH%

REM allow the user to use their own JRE or JAR
if "%UGII_DEX_JAR%" == "" set UGII_DEX_JAR=%BASE_DIR%\NXBIN
if "%UGII_DEX_JRE%" == "" goto CHECKHOME

REM Check if the jave.exe exist at location defined by UGII_DEX_JRE
@if not exist "%UGII_DEX_JRE%\bin\java.exe" goto CHECKHOME
@goto CHECKJRE

REM UGII_DEX_JRE is not defined, check for UGII_JAVA_HOME
:CHECKHOME
@if "%UGII_JAVA_HOME%" == "" goto SETJRE
@if not exist "%UGII_JAVA_HOME%\bin\java.exe" goto SETJRE
@set UGII_DEX_JRE=%UGII_JAVA_HOME%
@goto CHECKJRE

REM UGII_JAVA_HOME is not defined, check if it is set by ugii env.
:SETJRE
@for /f "tokens=*" %%I in (' "%BASE_DIR%\nxbin\env_print" UGII_JAVA_HOME') do set UGII_JAVA_HOME=%%I

REM check the JRE version
:CHECKJRE
if defined UGII_JAVA_HOME (
@if not exist "%UGII_JAVA_HOME%\bin\java.exe" goto JREERROR
"%UGII_JAVA_HOME%\bin\java" -jar "%BASE_DIR%\nxbin\VerifyJava.jar" external "%UGII_JAVA_HOME%"
) else (
echo UGII_JAVA_HOME must be defined
goto JREERROR
)
if errorlevel 1 (
goto OK
) else (
set UGII_DEX_JRE=%UGII_JAVA_HOME%
)
@goto CHECKTMPDIR



:JREERROR
@Echo The Java Runtime Enviroment (JRE) was not found.
@Echo     Install your own JRE and set UGII_JAVA_HOME 
@Echo     in %BASE_DIR%\ugii\ugii_env.dat 
@Echo     to the directory containing the bin and 
@Echo     lib directories.
@pause
@goto OK

REM check for UGII_TMP_DIR
:CHECKTMPDIR
@if "%UGII_TMP_DIR%" == "" goto SETTMPDIR
@goto CHECKCSHELPDOCS

REM UGII_TMP_DIR is not defined, check if it is set by ugii env.
:SETTMPDIR
@for /f "tokens=*" %%I in (' "%BASE_DIR%\nxbin\env_print" UGII_TMP_DIR') do set UGII_TMP_DIR=%%I

REM check for UGII_CSHELP_DOCS
:CHECKCSHELPDOCS
@if "%UGII_CSHELP_DOCS%" == "" goto SETCSHELPDOCS
@goto STARTUI

REM UGII_CSHELP_DOCS is not defined, check if it is set by ugii env.
:SETCSHELPDOCS
@for /f "tokens=*" %%I in (' "%BASE_DIR%\nxbin\env_print" UGII_CSHELP_DOCS') do set UGII_CSHELP_DOCS=%%I

:STARTUI 
@call "%UGII_DEX_JRE%\bin\java" -classpath "%UGII_DEX_JAR%\dex.jar" -DUGII_BASE_DIR="%BASE_DIR% " -DSTEP203UG_DIR="%STEP203UG_DIR% " -DUGII_TMP_DIR="%UGII_TMP_DIR%" -DUGII_CSHELP_DOCS="%UGII_CSHELP_DOCS%" com.dex.splash.STEP203SplashScreen
@IF not %ERRORLEVEL% == 0 pause
GOTO OK

:PARMDONE
@call "%BASE_DIR%\nxbin\step203ug.exe" %input% %fullout% %fulllog% %fulldef% %fullmode% %pim% %corba% %soastring% %soacorba% %tmp_user% %tmp_passwd% %tmp_group% %sssologinurl% %ssoappid% %tccsenvname% %httpurl% %httpvmid%
@IF not %ERRORLEVEL% == 0 pause

:OK
@ECHO Translator exiting .....
