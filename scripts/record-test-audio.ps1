#!/usr/bin/env pwsh
# Record test audio directly from device (requires root or specific permissions)

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "`n📱 Recording Audio from Device" -ForegroundColor Cyan
Write-Host "Duration: 3 seconds" -ForegroundColor White
Write-Host "`n📢 Say now: 'one two three four'`n" -ForegroundColor Yellow

# Try to record (may require special permissions)
& $adb shell "tinycap /sdcard/test_recording.wav -D 0 -d 0 -c 1 -r 8000 -b 16 -t 3" 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Recording complete!" -ForegroundColor Green
    & $adb pull /sdcard/test_recording.wav .
    Write-Host "Pulled to: test_recording.wav" -ForegroundColor Cyan
} else {
    Write-Host "`n⚠️  Direct recording requires root or special permissions" -ForegroundColor Yellow
    Write-Host "Please record on PC instead using Sound Recorder" -ForegroundColor Gray
}
