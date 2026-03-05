@echo off
echo ==========================================
echo    Claude Cowork WSL/Virtiofs Reset
echo ==========================================
echo.
echo Stopping all Claude background processes...
taskkill /F /IM Claude.exe /T >nul 2>&1

echo.
echo Shutting down Windows Subsystem for Linux (WSL) to clear the mount...
wsl --shutdown

echo.
echo Reset complete! You can now safely relaunch Claude.
timeout /t 5 >nul