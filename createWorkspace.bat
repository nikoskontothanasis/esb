echo off
setlocal

SET EXEC_DIR=%~dp0

REM Set the ant home if not already set in an environment variable.
REM Ant versions 1.9 or later can be used.
SET ANT_HOME=C:\apache-ant-1.10.6

REM Set the java home if not already set in an environment variable.
REM Use a java version that is compatible with the used ant version (e.g. for ant 1.10.3, java 1.8 is required)
SET JAVA_HOME=C:\Java\jdk1.8.0_162

REM integration.designer.dir: Give the Integration Designer's directory
SET INTEGRATION_DESIGNER_DIR=C:\Users\nkontotha\Documents\DevOps\ESB\IntegrationDesigner\v7.5
REM PROJECTS_DIR: Give the directory where the projects are checked-out. This directory will be used as workspace
REM e.g.: SET PROJECTS_DIR=D:\IBM\workspaces\ws_ant
SET PROJECTS_DIR=%~1

REM ECLIPSE_WORKSPACE_DIR: The workspace dir where the .metadata will be placed
REM e.g.: SET ECLIPSE_WORKSPACE_DIR=D:\temp\Build_ESB\workspace
SET ECLIPSE_WORKSPACE_DIR=%~2

REM PROJECT_NAMES: Comma-separated list of projects to import.
REM e.g.: SET PROJECT_NAMES=HOLBillingEventsLibrary,HOLCallForwardingLibrary
SET PROJECT_NAMES=%~3

IF "%PROJECTS_DIR%"=="" (
  GOTO INVALID_ARGUMENTS
)

IF "%ECLIPSE_WORKSPACE_DIR%"==""  (
  GOTO INVALID_ARGUMENTS
)

REM echo The following values will be used, insert "y" to accept them:
REM echo PROJECTS_DIR=%PROJECTS_DIR%
REM echo ECLIPSE_WORKSPACE_DIR=%ECLIPSE_WORKSPACE_DIR%
REM echo PROJECT_NAMES=%PROJECT_NAMES%
REM SET /P VALUES_ACCEPTED=Waiting for user input...
REM echo %VALUES_ACCEPTED%
REM IF NOT "%VALUES_ACCEPTED%"=="y" (
  REM GOTO USER_ABORTED
REM )

IF "%PROJECT_NAMES%"=="" (
  SET PROJECT_NAMES_ARG=
) ELSE (
  SET PROJECT_NAMES_ARG=-Dproject.names="%PROJECT_NAMES%"
)

echo on
"%ANT_HOME%\bin\ant" -file "%EXEC_DIR%\build.xml" -Dintegration.designer.dir=%INTEGRATION_DESIGNER_DIR% -Dprojects.dir=%PROJECTS_DIR% -Declipse.workspace.dir=%ECLIPSE_WORKSPACE_DIR% %PROJECT_NAMES_ARG% import_dependencies
echo off
GOTO :eof

:INVALID_ARGUMENTS
echo Set the following arguments: projects_dir eclipse_workspace_dir [project_names (Double quoted, comma-separated list without spaces, e.g. "project1,project2". Leave empty to process all projects)]
EXIT /b 1

:USER_ABORTED
echo "User aborted"
