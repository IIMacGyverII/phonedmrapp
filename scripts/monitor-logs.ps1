# DMR App Log Monitor
# Run this in PowerShell to monitor app logs in realtime

$ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$PACKAGE = "com.pri.prizeinterphone"

Write-Host "=== DMR App Realtime Log Monitor ===" -ForegroundColor Cyan
Write-Host "Monitoring package: $PACKAGE" -ForegroundColor Gray
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if device is connected
$devices = & $ADB devices | Select-String "device$"
if ($devices.Count -eq 0) {
    Write-Host "No device connected! Please connect your phone." -ForegroundColor Red
    exit 1
}

# Clear existing logs
& $ADB logcat -c

# Monitor logs with color coding
& $ADB logcat | ForEach-Object {
    if ($_ -match "FATAL|crash|exception" -and ($_ -match "prize|interphone")) {
        Write-Host $_ -ForegroundColor Red
    } elseif ($_ -match "ERROR" -and ($_ -match "prize|interphone")) {
        Write-Host $_ -ForegroundColor Yellow
    } elseif ($_ -match "prize|interphone") {
        Write-Host $_ -ForegroundColor White
    } elseif ($_ -match "AndroidRuntime.*FATAL") {
        Write-Host $_ -ForegroundColor Magenta
    }
}
