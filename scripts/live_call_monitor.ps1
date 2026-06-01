# Live Call Fuzzing Monitor
# Run this BEFORE starting the fuzzing test to capture any state changes

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "=== LIVE CALL FUZZING MONITOR ===" -ForegroundColor Cyan
Write-Host "Instructions:" -ForegroundColor Yellow
Write-Host "1. Start transmission on group 11904 (not in RX list)"
Write-Host "2. Verify NO audio on Ulefone (baseline)"
Write-Host "3. While still transmitting, run: python quick_fuzzer_auto.py"
Write-Host "4. Watch for ANY change below"
Write-Host ""
Write-Host "Monitoring for:" -ForegroundColor Green
Write-Host "  - RECEIVE_START packets (call accepted)"
Write-Host "  - PCMReceiveManager.start (audio begins)"
Write-Host "  - FUZZING log entries (commands sent)"
Write-Host "  - Any RX packets from firmware"
Write-Host ""
Write-Host "Press Ctrl+C when test complete" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host ""

# Clear logs
& $adb logcat -c

# Monitor for key events
& $adb logcat | Select-String "FUZZING|RECEIVE_START|PCMReceiveManager.*start|RX @.*CMD.*0x[0-9A-F]{2}"
