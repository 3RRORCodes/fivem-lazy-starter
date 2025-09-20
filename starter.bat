@echo off
setlocal EnableDelayedExpansion

:: Configuration
set "FXSERVER_PATH=C:\path\to\your-server\FXServer.exe"
set "XAMPP_PATH=C:\xampp\xampp-control.exe"
set "TXDATA_DATA=C:\path\to\your-server\txData"
set "TXADMIN_PORT=40120"

:: Helper function for error handling
goto :main
:error_exit
powershell -Command "Write-Host 'ERROR: %~1' -ForegroundColor Red"
echo.
echo Press any key to exit...
pause >nul
exit /b 1

:: Helper function for process checking
:check_process
tasklist /FI "IMAGENAME eq %~1" 2>nul | find /I "%~1" >nul
exit /b %ERRORLEVEL%

:main
:: Step 1: Validate paths
if "%FXSERVER_PATH%"=="C:\path\to\your-server\FXServer.exe" (
    call :error_exit "Please configure the FXSERVER_PATH in the script configuration section."
    goto :eof
)
if "%TXDATA_DATA%"=="C:\path\to\your-server\txData" (
    call :error_exit "Please configure the TXDATA_DATA path in the script configuration section."
    goto :eof
)

if not exist "%FXSERVER_PATH%" (
    call :error_exit "FXServer.exe not found at: %FXSERVER_PATH%"
    goto :eof
)
if not exist "%XAMPP_PATH%" (
    call :error_exit "XAMPP Control not found at: %XAMPP_PATH%"
    goto :eof
)
if not exist "%TXDATA_DATA%" (
    mkdir "%TXDATA_DATA%" 2>nul || (
        call :error_exit "Could not create txAdmin data folder at: %TXDATA_DATA%"
        goto :eof
    )
)

:: Step 2: Check/Start XAMPP
call :check_process "xampp-control.exe"
if %ERRORLEVEL% neq 0 (
    powershell -Command "Start-Process '%XAMPP_PATH%' -Verb RunAs" 2>nul || (
        call :error_exit "Failed to start XAMPP with administrator privileges."
        goto :eof
    )
    timeout /t 8 /nobreak >nul
)

:: Step 3: Verify MySQL
:mysql_check
call :check_process "mysqld.exe"
if %ERRORLEVEL% equ 0 (
    echo MySQL service verified successfully.
    goto :start_fxserver
)

powershell -Command "Write-Host 'ERROR: MySQL service is not running. Please start MySQL in XAMPP Control Panel.' -ForegroundColor Red"
echo.
echo Press ENTER once you have started MySQL service, or press CTRL+C to exit...
pause >nul

:: Re-check MySQL after user confirmation
call :check_process "mysqld.exe"
if %ERRORLEVEL% neq 0 (
    powershell -Command "Write-Host 'ERROR: MySQL service is still not running.' -ForegroundColor Red"
    echo Retrying MySQL verification...
    echo.
    goto :mysql_check
)
echo MySQL service verified successfully.

:start_fxserver

:: Step 4: Start FXServer
start "FiveM Server" /D "%TXDATA_DATA%" "%FXSERVER_PATH%" +set TXHOST_DATA_PATH=%TXDATA_DATA% +set TXHOST_TXA_PORT=%TXADMIN_PORT% || (
    call :error_exit "Failed to start FXServer."
    goto :eof
)
