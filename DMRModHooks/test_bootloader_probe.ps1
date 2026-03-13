# Quick Bootloader Probe Test
# Tests if STM32 bootloader is accessible on HR_C6000 radio module
# Run time: ~5 minutes
# Risk: None (read-only test)

Write-Host "==================================" -ForegroundColor Cyan
Write-Host " UART Bootloader Probe Test" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This test will determine if we can permanently flash the patch." -ForegroundColor Yellow
Write-Host "Testing for STM32-style bootloader on radio module UART..." -ForegroundColor Yellow
Write-Host ""

# Step 1: Check if device is connected
Write-Host "[1/6] Checking device connection..." -ForegroundColor Green
$deviceCheck = adb devices | Select-String "device$"
if (-not $deviceCheck) {
    Write-Host "ERROR: No device connected!" -ForegroundColor Red
    Write-Host "Please connect device and enable USB debugging." -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Device connected" -ForegroundColor Gray
Write-Host ""

# Step 2: Check if app is installed
Write-Host "[2/6] Checking if DMRModHooks is installed..." -ForegroundColor Green
$appCheck = adb shell pm list packages | Select-String "com.pri.prizeinterphone"
if (-not $appCheck) {
    Write-Host "ERROR: PriInterPhone app not installed!" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ App installed" -ForegroundColor Gray
Write-Host ""

# Step 3: Build APK with probe code
Write-Host "[3/6] Building APK with bootloader probe..." -ForegroundColor Green
Push-Location "C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks"

$buildOutput = .\gradlew assembleDebug 2>&1 | Out-String

if ($buildOutput -match "BUILD SUCCESSFUL") {
    Write-Host "  ✓ Build successful" -ForegroundColor Gray
} else {
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    Write-Host $buildOutput
    Pop-Location
    exit 1
}
Pop-Location
Write-Host ""

# Step 4: Install APK
Write-Host "[4/6] Installing updated module..." -ForegroundColor Green
$installOutput = adb install -r "C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks\app\build\outputs\apk\debug\app-debug.apk" 2>&1 | Out-String

if ($installOutput -match "Success") {
    Write-Host "  ✓ Module installed" -ForegroundColor Gray
} else {
    Write-Host "WARNING: Install may have issues" -ForegroundColor Yellow
    Write-Host $installOutput
}
Write-Host ""

# Step 5: Restart app to trigger probe
Write-Host "[5/6] Restarting app to trigger bootloader probe..." -ForegroundColor Green
adb shell am force-stop com.pri.prizeinterphone
Start-Sleep -Seconds 2
adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity | Out-Null
Write-Host "  ✓ App restarted" -ForegroundColor Gray
Write-Host ""
Write-Host "  Waiting 10 seconds for probe to complete..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host ""

# Step 6: Check probe results
Write-Host "[6/6] Analyzing probe results..." -ForegroundColor Green
Write-Host ""

$probeLog = adb logcat -d | Select-String "BootloaderProbe"

if ($probeLog.Count -eq 0) {
    Write-Host "⚠️  WARNING: No probe logs found!" -ForegroundColor Yellow
    Write-Host "   -> Module may not have loaded correctly" -ForegroundColor Yellow
    Write-Host "   -> Check LSPosed app and enable DMRModHooks" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Recent module logs:" -ForegroundColor Gray
    adb logcat -d | Select-String "DMRModHooks" | Select-Object -Last 10
    exit 1
}

Write-Host "==================================" -ForegroundColor Cyan
Write-Host " PROBE RESULTS" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Display probe log
$probeLog | ForEach-Object {
    $line = $_.Line
    
    if ($line -match "ACK received") {
        Write-Host $line -ForegroundColor Green
    } elseif ($line -match "NACK|timeout|No response") {
        Write-Host $line -ForegroundColor Red
    } elseif ($line -match "Write Memory.*SUPPORTED|Erase.*SUPPORTED") {
        Write-Host $line -ForegroundColor Magenta
    } else {
        Write-Host $line -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host " RESULT ANALYSIS" -ForeGroupColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Analyze result
$hasACK = $probeLog | Where-Object { $_.Line -match "ACK received" }
$hasWriteSupport = $probeLog | Where-Object { $_.Line -match "Write Memory.*SUPPORTED" }
$hasEraseSupport = $probeLog | Where-Object { $_.Line -match "Erase.*SUPPORTED" }
$hasNACK = $probeLog | Where-Object { $_.Line -match "NACK|timeout|No response" }

if ($hasACK -and $hasWriteSupport -and $hasEraseSupport) {
    Write-Host "🎉🎉🎉 SUCCESS! 🎉🎉🎉" -ForegroundColor Green
    Write-Host ""
    Write-Host "Bootloader IS accessible!" -ForegroundColor Green
    Write-Host "Write Memory (0x31) and Erase (0x43) commands are supported!" -ForegroundColor Green
    Write-Host ""
    Write-Host "✅ PERMANENT FLASH IS POSSIBLE!" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Review INTEGRATION_GUIDE.md Phase 1B (Permanent Flash)" -ForegroundColor Yellow
    Write-Host "2. Implement Write Memory + Erase commands" -ForegroundColor Yellow
    Write-Host "3. Test permanent flash with backup" -ForegroundColor Yellow
    Write-Host "4. Verify persistence across reboot" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "⚠️  CAUTION: Flash write operations are medium risk" -ForegroundColor Yellow
    Write-Host "   -> Always backup original sector first" -ForegroundColor Yellow
    Write-Host "   -> Have factory firmware ready for recovery" -ForegroundColor Yellow
    Write-Host "   -> Test on single device before public release" -ForegroundColor Yellow
    
} elseif ($hasACK) {
    Write-Host "⚠️  PARTIAL SUCCESS" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Bootloader responded to sync, but:" -ForegroundColor Yellow
    if (-not $hasWriteSupport) {
        Write-Host "  ❌ Write Memory (0x31) not available" -ForegroundColor Red
    }
    if (-not $hasEraseSupport) {
        Write-Host "  ❌ Erase (0x43) not available" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Cannot perform permanent flash." -ForegroundColor Red
    Write-Host "Proceeding to Plan B: Reload Button" -ForegroundColor Yellow
    
} else {
    Write-Host "❌ BOOTLOADER NOT ACCESSIBLE" -ForegroundColor Red
    Write-Host ""
    Write-Host "The radio module bootloader did not respond." -ForegroundColor Red
    Write-Host "Permanent flash via UART is not possible." -ForegroundColor Red
    Write-Host ""
    Write-Host "Proceeding to Plan B: One-Tap Reload Button" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Review INTEGRATION_GUIDE.md Phase 2 (Reload Button)" -ForegroundColor Yellow
    Write-Host "2. Embed PATCH14.bin in APK assets" -ForegroundColor Yellow
    Write-Host "3. Hook Information screen to add button" -ForegroundColor Yellow
    Write-Host "4. Test reload workflow" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Save full log
Write-Host "Full probe log saved to: bootloader_probe_results.txt" -ForegroundColor Gray
adb logcat -d | Select-String "BootloaderProbe|DMRModHooks" | Out-File -FilePath "bootloader_probe_results.txt"

Write-Host ""
Write-Host "Test complete!" -ForegroundColor Green
