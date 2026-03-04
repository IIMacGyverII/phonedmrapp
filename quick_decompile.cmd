@echo off
REM Quick launcher for automated firmware decompilation
REM No parameters needed - fully automated!

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║  AUTOMATED FIRMWARE DECOMPILATION                      ║
echo ║  This will take 15-25 minutes                          ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo What this does:
echo   • Checks/installs Java JDK 21 if needed
echo   • Downloads/installs Ghidra 11.2.1 if needed (~540 MB)
echo   • Imports firmware with ARM Cortex-M settings
echo   • Runs complete auto-analysis
echo   • Exports all decompiled C code
echo.
echo Press Ctrl+C to cancel, or
pause

powershell.exe -ExecutionPolicy Bypass -File decompile_firmware.ps1

echo.
echo ════════════════════════════════════════════════════════
echo   DONE! Check the ghidra_decompiled folder
echo ════════════════════════════════════════════════════════
echo.
pause
