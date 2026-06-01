# Simple Payload Variation Tester for CMD 0x88

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "`n=== PAYLOAD VARIATION TESTING ===" -ForegroundColor Cyan
Write-Host "Target: CMD 0x88 (only responsive command)`n"

# Clear logs
& $adb logcat -c

# Test different payloads
Write-Host "[1/10] No payload (default)" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[2/10] Single 0x00 (NULL)" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '00'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[3/10] Single 0x01 (default)" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '01'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[4/10] Single 0x02" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '02'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[5/10] Single 0xFF (all bits)" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY 'FF'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[6/10] Two bytes 0x00 0x00" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '0000'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[7/10] Two bytes 0x01 0x02" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '0102'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[8/10] Two bytes 0xFF 0xFF" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY 'FFFF'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[9/10] Four bytes 0x00 0x01 0x02 0x03" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '00010203'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "[10/10] Four bytes 0xFF 0xFF 0xFF 0xFF" -ForegroundColor White
& $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY 'FFFFFFFF'" | Out-Null
Start-Sleep -Milliseconds 800

Write-Host "`n✓ All payload tests sent!" -ForegroundColor Green
Write-Host "Waiting for responses...`n"
Start-Sleep -Seconds 2

# Pull UART logs
Write-Host "Pulling UART logs..." -ForegroundColor Cyan
& $adb pull /sdcard/DMR/uart_logs/ .\payload_test_logs\ | Out-Null

$latestLog = Get-ChildItem .\payload_test_logs\ -Filter "uart_*.txt" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1

Write-Host "Analyzing: $($latestLog.Name)`n" -ForegroundColor Cyan

# Search for RX responses with CMD 0x88
Write-Host "Searching for CMD 0x88 responses..." -ForegroundColor Yellow
$rxCount = (Select-String -Path $latestLog.FullName -Pattern "RX.*CMD: 0x88").Count
Write-Host "Found $rxCount response(s) from CMD 0x88" -ForegroundColor $(if ($rxCount -gt 0) {"Green"} else {"Red"})

# Check if any had data
Write-Host "`nChecking response sizes..." -ForegroundColor Yellow
Select-String -Path $latestLog.FullName -Pattern "RX.*CMD: 0x88" -Context 0,6 | ForEach-Object {
    $lengthLine = $_.Context.PostContext | Where-Object {$_ -match "Length: (\d+) bytes"}
    if ($lengthLine -match "Length: (\d+) bytes") {
        $length = $matches[1]
        if ([int]$length -gt 0) {
            Write-Host "✓ Response with data: $length bytes" -ForegroundColor Green
        }
    }
}

Write-Host "`n=== PAYLOAD TEST COMPLETE ===" -ForegroundColor Cyan
