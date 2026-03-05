@echo off
setlocal enabledelayedexpansion
:: Request Administrator privileges automatically
net session >nul 2>&1
if !errorLevel! neq 0 (
    echo Requesting Administrator privileges to reset the VM service...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo    Claude Cowork Interactive Reset Tool
echo ==========================================
echo.
echo Scanning for known background tools that block WSL networks...

:: Define the list of known conflicting executables (quoted to handle spaces)
set "CONFLICTS="tailscale.exe" "zerotier-one.exe" "openvpn.exe" "wireguard.exe" "ollama.exe" "ollama app.exe" "lmstudio.exe" "Docker Desktop.exe" "Rainway.exe" "parsecd.exe""

set "ACTIVE_CONFLICTS="
set "FOUND_COUNT=0"

:: Check which apps are actually running
for %%P in (%CONFLICTS%) do (
    tasklist /FI "IMAGENAME eq %%~P" 2>NUL | find /I /N "%%~P">NUL
    if "!ERRORLEVEL!"=="0" (
        set "ACTIVE_CONFLICTS=!ACTIVE_CONFLICTS! "%%~P""
        set /a FOUND_COUNT+=1
    )
)

if !FOUND_COUNT! equ 0 (
    echo.
    echo No known conflicting apps detected. 
    echo Proceeding with a standard Claude and WSL reset...
    goto :StandardReset
)

echo.
echo Found !FOUND_COUNT! conflicting app(s) running.
echo We will go through them one by one so you don't kill everything at once.
echo.

:: Loop through the active conflicts one by one
for %%A in (!ACTIVE_CONFLICTS!) do (
    echo ------------------------------------------------
    choice /C YNS /M "Detected: %%~A - Do you want to stop this app? (Y=Yes, N/S=Skip)"
    if !errorlevel! equ 1 (
        echo.
        echo Stopping %%~A...
        taskkill /F /IM "%%~A" /T >nul 2>&1
        
        :: Handle associated headless services if applicable
        if /I "%%~A"=="tailscale.exe" net stop Tailscale >nul 2>&1
        if /I "%%~A"=="zerotier-one.exe" net stop ZeroTierOneService >nul 2>&1

        echo.
        echo Resetting Claude and WSL...
        taskkill /F /IM Claude.exe /T >nul 2>&1
        wsl --shutdown
        net stop CoworkVMService >nul 2>&1
        net start CoworkVMService

        echo.
        echo ==========================================
        echo TEST IT NOW!
        echo 1. Open Claude.
        echo 2. Launch your Cowork workspace.
        echo ==========================================
        
        choice /C YN /M "Did that fix the issue and let Cowork load?"
        if !errorlevel! equ 1 (
            echo.
            echo Awesome! The issue is fixed. Exiting without killing any more apps.
            timeout /t 5 >nul
            exit /b
        ) else (
            echo.
            echo Darn, okay. Let's check the next app on the list...
        )
    ) else (
        echo Skipping %%~A...
    )
)

echo.
echo ------------------------------------------------
echo We have gone through all detected conflicting apps. 
echo If it's still not working, a full PC reboot might be needed.
pause
exit /b

:StandardReset
echo Stopping all Claude background processes...
taskkill /F /IM Claude.exe /T >nul 2>&1
wsl --shutdown
net stop CoworkVMService >nul 2>&1
net start CoworkVMService
echo.
echo Reset complete! Try opening Claude now.
pause