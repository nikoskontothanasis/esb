@echo off
setlocal

set VMARGS=-Dfile.encoding=Cp1253 -Xms1024m -Xmaxf0.1 -Xminf0.05 -Xmx2046m -Xmnx1024m -Xgcpolicy:gencon -Xscmx96m -Xshareclasses:singleJVM,keep -XX:MaxPermSize=2048M -Xss2048k -Dorg.eclipse.jdt.core.javamodelcache.ratio=0.0625 %VMARGS%

REM set JAVA_HOME=%INTEGRATION_DESIGNER_DIR%\eclipse\jdk
REM Use newer jre
set JAVA_HOME=%INTEGRATION_DESIGNER_DIR%\runtimes\bi_v75_stub\java
@if not exist "%JAVA_HOME%\jre\bin" set JAVA_HOME=%INTEGRATION_DESIGNER_DIR%\jdk
@if not exist "%JAVA_HOME%\jre\bin" echo ERROR: JAVA_HOME must point to Java installation containing jre\bin
@if not exist "%JAVA_HOME%\jre\bin" goto done

:startup
set STARTUP_JAR="%INTEGRATION_DESIGNER_DIR%\startup.jar"
@if exist "%INTEGRATION_DESIGNER_DIR%\eclipse.exe" goto im

for /f "delims= tokens=1" %%c in ('dir /B /S /OD "%INTEGRATION_DESIGNER_DIR%\eclipse\plugins\org.eclipse.equinox.launcher_*.jar"') do set STARTUP_JAR=%%c
goto checkstartup

:im
for /f "delims= tokens=1" %%c in ('dir /B /S /OD "%INTEGRATION_DESIGNER_DIR%\plugins\org.eclipse.equinox.launcher_*.jar"') do set STARTUP_JAR=%%c

:checkstartup
@if not exist "%STARTUP_JAR%" echo ERROR: Unable to locate Eclipse startup.jar
@if not exist "%STARTUP_JAR%" goto done


:workspace
if not $"%WORKSPACE%"$==$""$ goto check
REM #######################################################
REM ##### you must edit the "WORKSPACE" setting below #####
REM #######################################################
REM *********** The location of your workspace ************
set WORKSPACE=C:\Users\nkontotha\Documents\DevOps\ESB\workspace2

:check
REM ************* The location of your workspace *****************
if not exist "%WORKSPACE%" echo ERROR: incorrect workspace=%WORKSPACE%
if not exist "%WORKSPACE%" goto done


:run
@echo on
"%JAVA_HOME%\jre\bin\java.exe" %VMARGS% -Dwtp.autotest.noninteractive=true -cp "%STARTUP_JAR%" org.eclipse.core.launcher.Main -application com.ibm.wbit.comptest.ant.RunAntWid -data "%WORKSPACE%"  %*
@if %ERRORLEVEL% EQU 0 goto done
@if %ERRORLEVEL% EQU 13 echo runAntWid BUILD FAILED.
@if %ERRORLEVEL% EQU 13 goto done
@if %ERRORLEVEL% EQU 15 echo WORKSPACE is already BEING USED.
@if %ERRORLEVEL% EQU 15 goto done
@if %ERRORLEVEL% EQU 23 echo totally clean (UNINITIALIZED) workspace, it is now setup.  will rerun...
@if %ERRORLEVEL% EQU 23 goto run
@echo runAntWid FAILED? (return code %ERRORLEVEL%)
:pause
@pause

:done
exit %ERRORLEVEL%