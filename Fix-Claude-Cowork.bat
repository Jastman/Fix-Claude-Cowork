@echo off
:: 1. Request Administrator privileges automatically
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges to reset the VM service...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo    Claude Cowork Ultimate Reset Tool
echo ==========================================
echo.
echo Stopping all Claude background processes...
taskkill /F /IM Claude.exe /T >nul 2>&1

echo.
echo Shutting down WSL to clear virtiofs mounts...
wsl --shutdown

echo.
echo Restarting the Cowork VM Service...
net stop CoworkVMService >nul 2>&1
net start CoworkVMService

echo.
echo Reset complete! You can now safely relaunch Claude.
timeout /t 5 >nul