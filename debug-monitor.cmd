@echo off
REM DMR InterPhone Realtime Debug Monitor

set ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe

echo ========================================
echo === DMR INTERPHONE REALTIME DEBUGGER ===
echo ========================================
echo.
echo Device: 
%ADB% devices | findstr "device"
echo.
echo App: com.pri.prizeinterphone (System)
echo Monitoring: Crashes, errors, and app activity
echo.
echo Press Ctrl+C to stop logging
echo ========================================
echo.

REM Clear logcat
%ADB% logcat -c

REM Start monitoring
%ADB% logcat | findstr /I "prize interphone fatal crash exception"
