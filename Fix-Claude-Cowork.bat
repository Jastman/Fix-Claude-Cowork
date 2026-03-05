@echo off
setlocal enabledelayedexpansion
net session >nul 2>&1
if !errorLevel! neq 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo    Claude Cowork Ultimate Reset Tool
echo ==========================================
echo.

:: --- NEW: PLAN9 MOUNT FLUSH ---
echo 1. Flushing orphaned virtiofs mounts...
taskkill /F /IM Claude.exe /T >nul 2>&1
:: This clears the temporary mount handshake folder
powershell -Command "Remove-Item -Path \"$env:LOCALAPPDATA\Packages\Claude_*\LocalCache\Local\claude-desktop\workspaces\*\" -Recurse -Force" >nul 2>&1

echo.
echo 2. Scanning for WSL/Network conflicts...
set "CONFLICTS="tailscale.exe" "zerotier-one.exe" "openvpn.exe" "wireguard.exe" "ollama.exe" "ollama app.exe" "lmstudio.exe" "Docker Desktop.exe" "Rainway.exe" "parsecd.exe""
set "ACTIVE_CONFLICTS="
set "FOUND_COUNT=0"

for %%P in (%CONFLICTS%) do (
    tasklist /FI "IMAGENAME eq %%~P" 2>NUL | find /I /N "%%~P">NUL
    if "!ERRORLEVEL!"=="0" (
        set "ACTIVE_CONFLICTS=!ACTIVE_CONFLICTS! "%%~P""
        set /a FOUND_COUNT+=1
    )
)

if !FOUND_COUNT! equ 0 goto :StandardReset

echo Found !FOUND_COUNT! potential conflicts.
for %%A in (!ACTIVE_CONFLICTS!) do (
    echo ------------------------------------------------
    choice /C YNS /M "Detected: %%~A - Do you want to stop this app? (Y=Yes, N/S=Skip)"
    if !errorlevel! equ 1 (
        echo Stopping %%~A...
        taskkill /F /IM "%%~A" /T >nul 2>&1
        if /I "%%~A"=="tailscale.exe" net stop Tailscale >nul 2>&1
        
        echo Resetting services...
        wsl --shutdown
        net stop CoworkVMService >nul 2>&1
        net start CoworkVMService

        echo ==========================================
        echo TEST IT NOW: Launch your Cowork workspace.
        echo ==========================================
        choice /C YN /M "Did that fix the Plan9 mount error?"
        if !errorlevel! equ 1 (
            echo Awesome! Exiting.
            timeout /t 5 >nul
            exit /b
        )
    )
)

:StandardReset
wsl --shutdown
net stop CoworkVMService >nul 2>&1
net start CoworkVMService
echo Reset complete! Try opening Claude now.
pause