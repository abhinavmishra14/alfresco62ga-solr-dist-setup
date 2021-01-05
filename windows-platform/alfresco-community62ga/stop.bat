@echo off

ECHO ################ Stopping ACS, DB and Solr Services ##############
ECHO.

SET ALF_INSTALL_PATH=%1
SET SOLR_INSTALL_PATH=%2
SET POSTGRES_INSTALL_PATH=%3

:init
	IF "%~1" == "" (
	   SET ALF_INSTALL_PATH=C:\alfresco-community62ga
	)
	
	IF "%~2" == "" (
		SET SOLR_INSTALL_PATH=C:\alfresco-search-services
	)
	
	IF "%~3" == "" (
		SET POSTGRES_INSTALL_PATH=C:\PostgreSQL\11
	)
	
	goto stopACS

:stopACS
	echo.
	echo Stopping ACS from %ALF_INSTALL_PATH% ...
	SET CATALINA_HOME=%ALF_INSTALL_PATH%\tomcat
	start /MIN /WAIT cmd /c %ALF_INSTALL_PATH%\tomcat\bin\catalina.bat stop
	if errorlevel 1 (goto end) else (goto stopDB)

:stopDB
	echo.
	echo Stopping DB from %POSTGRES_INSTALL_PATH% ...
	:: Using the windows service to stop the db.
	:: net stop postgresql-x64-11
	REM You can also use this command, if there is any issue with permission elevation on windows
	%POSTGRES_INSTALL_PATH%\bin\pg_ctl.exe stop -D "%POSTGRES_INSTALL_PATH%\data"
	if errorlevel 1 (goto end) else (goto stopSolr)
	
:stopSolr
	echo.
	echo Stopping SOLR from %SOLR_INSTALL_PATH% ...
	%SOLR_INSTALL_PATH%\solr\bin\solr.cmd stop -all
	if errorlevel 1 (goto end)

:end
	echo.
    echo Exiting..
	timeout 10