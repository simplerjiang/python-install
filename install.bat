REM Install application on system with Python 3.6.2

:: Set environment (PROD for production, DEV for development)
SET install_env=%1

:: Verify Python version
FOR /F "delims=" %%i IN ('python --version /t') DO SET pyversion=%%i
if "%pyversion%"=="Python 3.6.2" (
	:: Create virtualenv
	IF NOT EXIST "./venv/Scripts/activate.bat". (
		virtualenv venv
	)
	
	:: Install dependencies inside virtualenv
	venv\Scripts\activate.bat & (
		IF "%install_env%"=="PROD" (
			IF NOT EXIST "prod_requirements.txt" (
				ECHO [Production] Missing dependencies file
			) ELSE (
				pip install -r prod_requirements.txt
			)
		) ELSE (
			IF %install_env%=="DEV" (
				IF NOT EXIST "dev_requirements.txt" (
					ECHO [Development] Missing dependencies file
				) ELSE (
					pip install -r dev_requirements.txt
				)
			) ELSE (
				ECHO Invalid installation environment: %install_env%
			)
		)
	)
	
	if %ERRORLEVEL%==0 (
		ECHO Installation succeeded
	) ELSE (
		ECHO Installation failed
	)
	
	:: Leave virtualenv
	venv\Scripts\deactivate.bat
) ELSE (
	:: NOTICE: Install the correct version of Python
	ECHO Currently installed: %pyversion%
	ECHO Please upgrade to Python 3.6.2.
)

SET /p DUMMY=Press ENTER to continue...