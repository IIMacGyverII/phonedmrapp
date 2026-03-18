#!/usr/bin/env pwsh
# Quick build and install script for DMR Mod Hooks
# 
# WARNING: Always use this script to install updates!
# Uses -r (replace) and -t (test package) flags to preserve LSPosed module state.
# 
# The build.gradle is configured so debug and release use the SAME signing key.
# This prevents signature mismatches that would force user to re-enable in LSPosed.
# DO NOT change the debug signingConfig without coordinating install method!

Write-Host "Building APK..." -ForegroundColor Cyan
.\gradlew assembleDebug

if ($LASTEXITCODE -eq 0) {
    Write-Host "Installing APK..." -ForegroundColor Cyan
    & "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r -t app\build\outputs\apk\debug\app-debug.apk
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] Installation complete! LSPosed module state preserved." -ForegroundColor Green
        Write-Host "Rebooting phone to ensure module changes take effect..." -ForegroundColor Cyan
        & "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" reboot
    } else {
        Write-Host "[FAILED] Installation failed!" -ForegroundColor Red
        Write-Host "If you see signature mismatch error, you may need to uninstall first:" -ForegroundColor Yellow
        Write-Host "  adb uninstall com.dmrmod.hooks" -ForegroundColor Gray
        Write-Host "  Then run this script again." -ForegroundColor Yellow
    }
} else {
    Write-Host "[FAILED] Build failed!" -ForegroundColor Red
}
