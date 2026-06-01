# UART Bootloader Entry Attempt Script
# Safe patterns to try entering bootloader/ISP mode

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "`n=== UART BOOTLOADER ENTRY ATTEMPTS ===" -ForegroundColor Cyan
Write-Host "Testing common MCU bootloader entry sequences`n" -ForegroundColor Yellow

# Clear logs
& $adb logcat -c

# Pattern 1: Repeated 0xFF (common ISP entry, STM8, STC MCUs)
Write-Host "[1/5] Pattern: 0xFF repeated (20x)" -ForegroundColor White
Write-Host "      Used by: STM8, STC, some ARM bootloaders" -ForegroundColor Gray
for ($i = 1; $i -le 20; $i++) {
    & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 255 --ei RW 1 --ei SR 1 --es BODY 'FF'" | Out-Null
    Start-Sleep -Milliseconds 50
}
Start-Sleep -Seconds 1

# Pattern 2: 0x7F repeated (STM32 bootloader)
Write-Host "[2/5] Pattern: 0x7F repeated (20x)" -ForegroundColor White
Write-Host "      Used by: STM32 UART bootloader" -ForegroundColor Gray
for ($i = 1; $i -le 20; $i++) {
    & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 127 --ei RW 1 --ei SR 1 --es BODY '7F'" | Out-Null
    Start-Sleep -Milliseconds 50
}
Start-Sleep -Seconds 1

# Pattern 3: 0x55 0xAA alternating (common sync pattern)
Write-Host "[3/5] Pattern: 0x55 0xAA alternating (20x)" -ForegroundColor White
Write-Host "      Used by: Many UART bootloaders as sync" -ForegroundColor Gray
for ($i = 1; $i -le 20; $i++) {
    if ($i % 2 -eq 0) {
        & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 85 --ei RW 1 --ei SR 1 --es BODY '55'" | Out-Null
    } else {
        & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 170 --ei RW 1 --ei SR 1 --es BODY 'AA'" | Out-Null
    }
    Start-Sleep -Milliseconds 50
}
Start-Sleep -Seconds 1

# Pattern 4: 0x00 repeated (NULL sequence, some ISP modes)
Write-Host "[4/5] Pattern: 0x00 repeated (20x)" -ForegroundColor White
Write-Host "      Used by: Some firmware update modes" -ForegroundColor Gray
for ($i = 1; $i -le 20; $i++) {
    & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 0 --ei RW 1 --ei SR 1 --es BODY '00'" | Out-Null
    Start-Sleep -Milliseconds 50
}
Start-Sleep -Seconds 1

# Pattern 5: Magic sequence (0xAA, 0x55 specific to some DMR bootloaders)
Write-Host "[5/5] Pattern: 0xAA 0x55 sequence" -ForegroundColor White
Write-Host "      Bootloader init sequence" -ForegroundColor Gray
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 170 --ei RW 1 --ei SR 1 --es BODY 'AA55'" | Out-Null
Start-Sleep -Milliseconds 100
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 170 --ei RW 1 --ei SR 1 --es BODY 'AA55AA55'" | Out-Null

Write-Host "`n✓ All bootloader sequences sent!" -ForegroundColor Green
Write-Host "Waiting for possible responses...`n"
Start-Sleep -Seconds 3

# Pull and check logs
Write-Host "Pulling UART logs..." -ForegroundColor Cyan
& $adb pull /sdcard/DMR/uart_logs/ .\bootloader_test\ | Out-Null

$latest = Get-ChildItem .\bootloader_test\ -Filter "uart_*.txt" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1

Write-Host "Analyzing: $($latest.Name)`n" -ForegroundColor Cyan

# Check for unusual RX responses
Write-Host "Looking for RX responses during bootloader attempts..." -ForegroundColor Yellow
$currentTime = Get-Date
$hour = $currentTime.Hour
$minute = $currentTime.Minute

$rxCount = (Select-String -Path $latest.FullName -Pattern "RX @ 2026-02-28 $($hour.ToString('00')):$($minute.ToString('00'))").Count

if ($rxCount -gt 0) {
    Write-Host "✓ Found $rxCount RX responses!" -ForegroundColor Green
    Write-Host "`nShowing responses..." -ForegroundColor Cyan
    Select-String -Path $latest.FullName -Pattern "RX @ 2026-02-28 $($hour.ToString('00')):$($minute.ToString('00'))" -Context 0,10 | Select-Object -First 5
} else {
    Write-Host "✗ No RX responses detected" -ForegroundColor Red
}

Write-Host "`n=== BOOTLOADER TEST COMPLETE ===" -ForegroundColor Cyan
Write-Host "Note: If no responses, bootloader entry requires hardware signals (BOOT pin, reset, etc.)" -ForegroundColor Yellow
