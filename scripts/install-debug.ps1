# DMR App Installation and Debugging Script
# Run this in PowerShell

$ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$APK = "C:\Users\Joshua\Documents\phonedmrapp\app-debug.apk"
$PACKAGE = "com.pri.prizeinterphone"
$ACTIVITY = "com.pri.prizeinterphone.activity.InterPhoneHomeActivity"

Write-Host "=== DMR App Installer & Debugger ===" -ForegroundColor Cyan
Write-Host ""

# Check if ADB exists
if (-not (Test-Path $ADB)) {
    Write-Host "ERROR: ADB not found at $ADB" -ForegroundColor Red
    Write-Host "Please install Android SDK Platform Tools" -ForegroundColor Yellow
    exit 1
}

# Check for connected devices
Write-Host "Checking for connected devices..." -ForegroundColor Yellow
& $ADB devices

$devices = & $ADB devices | Select-String "device$"
if ($devices.Count -eq 0) {
    Write-Host ""
    Write-Host "No devices found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Connect your phone via USB"
    Write-Host "2. Enable USB Debugging:"
    Write-Host "   - Go to Settings > About Phone"
    Write-Host "   - Tap 'Build Number' 7 times to enable Developer Options"
    Write-Host "   - Go to Settings > Developer Options"  
    Write-Host "   - Enable 'USB Debugging'"
    Write-Host "3. Check your phone for authorization prompt and tap 'Allow'"
    Write-Host "4. Run this script again"
    Write-Host ""
    Write-Host "Waiting for device connection (press Ctrl+C to cancel)..." -ForegroundColor Yellow
    & $ADB wait-for-device
}

Write-Host ""
Write-Host "Device connected!" -ForegroundColor Green
Write-Host ""

# Uninstall old version if exists
Write-Host "Removing old version (if exists)..." -ForegroundColor Yellow
& $ADB uninstall $PACKAGE 2>$null

# Install APK
Write-Host "Installing APK..." -ForegroundColor Yellow
& $ADB install -r $APK

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "APK installed successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Grant permissions
    Write-Host "Granting permissions..." -ForegroundColor Yellow
    & $ADB shell pm grant $PACKAGE android.permission.READ_CONTACTS
    & $ADB shell pm grant $PACKAGE android.permission.WRITE_CONTACTS
    & $ADB shell pm grant $PACKAGE android.permission.RECORD_AUDIO
    & $ADB shell pm grant $PACKAGE android.permission.READ_EXTERNAL_STORAGE
    & $ADB shell pm grant $PACKAGE android.permission.WRITE_EXTERNAL_STORAGE
    & $ADB shell pm grant $PACKAGE android.permission.CAMERA
    
    Write-Host ""
    Write-Host "Launching app..." -ForegroundColor Yellow
    & $ADB shell am start -n "$PACKAGE/.$ACTIVITY"
    
    Write-Host ""
    Write-Host "Starting realtime debug log..." -ForegroundColor Cyan
    Write-Host "Monitoring for: prize, interphone, crashes, errors" -ForegroundColor Gray
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Clear log and start monitoring
    & $ADB logcat -c
    & $ADB logcat | Select-String -Pattern "prize|interphone|AndroidRuntime|FATAL|ERROR|crash" -CaseSensitive:$false
    
} else {
    Write-Host ""
    Write-Host "Installation failed!" -ForegroundColor Red
    Write-Host "Error code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}
