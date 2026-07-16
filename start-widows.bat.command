@echo off
setlocal

cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-windows.ps1"

if errorlevel 1 (
    echo.
    echo WalletWise could not be started.
    pause
)

endlocal