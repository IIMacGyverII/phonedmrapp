# Payload Variation Tester for CMD 0x88
# Tests different payload patterns to elicit firmware responses

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "`n=== PAYLOAD VARIATION TESTING ===" -ForegroundColor Cyan
Write-Host "Target: CMD 0x88 (only responsive command)" -ForegroundColor Yellow
Write-Host "Method: Test different body data patterns`n"

# Clear logs
& $adb logcat -c

# Test cases: different payload patterns
$testCases = @(
    @{Name="No payload (default)"; Body=$null; Description="Empty body"},
    @{Name="Single 0x00"; Body="00"; Description="NULL byte"},
    @{Name="Single 0x01"; Body="01"; Description="Our default"},
    @{Name="Single 0x02"; Body="02"; Description="Alternative"},
    @{Name="Single 0xFF"; Body="FF"; Description="All bits set"},
    @{Name="Two bytes 0x00 0x00"; Body="0000"; Description="Double NULL"},
    @{Name="Two bytes 0x01 0x02"; Body="0102"; Description="Sequence"},
    @{Name="Two bytes 0xFF 0xFF"; Body="FFFF"; Description="All set"},
    @{Name="Four bytes 0x00 0x01 0x02 0x03"; Body="00010203"; Description="Sequential"},
    @{Name="Four bytes 0xFF 0xFF 0xFF 0xFF"; Body="FFFFFFFF"; Description="Max"}
)

$testNum = 0
foreach ($test in $testCases) {
    $testNum++
    Write-Host "[$testNum/10] Testing: $($test.Name)" -ForegroundColor White
    Write-Host "         $($test.Description)" -ForegroundColor Gray
    
    if ($test.Body) {
        & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1 --es BODY '$($test.Body)'" | Out-Null
    } else {
        & $adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 136 --ei RW 1 --ei SR 1" | Out-Null
    }
    
    Start-Sleep -Milliseconds 800
}

Write-Host "`n✓ All payload tests sent!" -ForegroundColor Green
Write-Host "`nNow checking for responses...`n"

Start-Sleep -Seconds 2

# Pull and analyze UART logs
Write-Host "Pulling UART logs..." -ForegroundColor Cyan
& $adb pull /sdcard/DMR/uart_logs/ .\payload_test_logs\ | Out-Null

$latestLog = Get-ChildItem .\payload_test_logs\* -Include "uart_*.txt" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestLog) {
    Write-Host "Analyzing: $($latestLog.Name)`n" -ForegroundColor Cyan
    
    # Get current time for filtering
    $currentTime = Get-Date
    $searchPattern = $currentTime.ToString("2026-02-28 HH:") + "[0-5][0-9]"
    
    Write-Host "Searching for RX responses..." -ForegroundColor Yellow
    $rxResponses = Select-String -Path $latestLog.FullName -Pattern "RX.*CMD: 0x88" -Context 0,10
    
    if ($rxResponses) {
        Write-Host "✓ Found $($rxResponses.Count) response(s) from CMD 0x88!" -ForegroundColor Green
        $rxResponses | ForEach-Object { $_.Context.PostContext }
    } else {
        Write-Host "✗ No responses from CMD 0x88" -ForegroundColor Red
    }
    
    # Check for any RX with data
    Write-Host "`nChecking for ANY responses with data..." -ForegroundColor Yellow
    $content = Get-Content $latestLog.FullName -Raw
    $timePattern = $currentTime.ToString("yyyy-MM-dd HH:")
    $rxWithData = [regex]::Matches($content, "RX @ $timePattern[0-5][0-9][\s\S]*?Length: (\d+) bytes") | Where-Object { $_.Groups[1].Value -ne "0" }
    
    if ($rxWithData) {
        Write-Host "✓ Found responses with data:" -ForegroundColor Green
        $rxWithData | ForEach-Object { Write-Host $_.Value }
    } else {
        Write-Host "✗ All responses had Length: 0 bytes" -ForegroundColor Red
    }
}

Write-Host "`n=== PAYLOAD TEST COMPLETE ===" -ForegroundColor Cyan
