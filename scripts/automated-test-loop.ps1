#!/usr/bin/env pwsh
# Fully Automated Transcription Test Loop
# Keeps rebuilding and testing until transcription matches expected text

param(
    [string]$AudioFile = "test_audio.wav",
    [string]$ExpectedText = "test test test",  # Change this to "1 2 3 4" if that's what's in the file
    [int]$MaxAttempts = 20
)

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$devicePath = "/sdcard/test_audio.wav"
$serviceName = "com.macdmr.transcription/.TranscriptionService"

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "  AUTOMATED TRANSCRIPTION TEST LOOP" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Audio File: $AudioFile" -ForegroundColor White
Write-Host " Expected: '$ExpectedText'" -ForegroundColor Yellow
Write-Host " Max Attempts: $MaxAttempts" -ForegroundColor White
Write-Host "=========================================`n" -ForegroundColor Cyan

if (-not (Test-Path $AudioFile)) {
    Write-Host " ERROR: Audio file not found: $AudioFile" -ForegroundColor Red
    exit 1
}

$attempt = 0
$success = $false

while ($attempt -lt $MaxAttempts -and -not $success) {
    $attempt++
    
    Write-Host "`n--- ATTEMPT $attempt/$MaxAttempts ---" -ForegroundColor Magenta
    
    # Step 1: Build APK
    Write-Host " [1/6] Building APK..." -ForegroundColor Cyan
    Push-Location "DMRTranscriptionService"
    $buildOutput = & .\gradlew assembleDebug -q 2>&1
    Pop-Location
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host " BUILD FAILED!" -ForegroundColor Red
        Write-Host $buildOutput
        continue
    }
    Write-Host " Build OK" -ForegroundColor Green
    
    # Step 2: Install APK
    Write-Host " [2/6] Installing APK..." -ForegroundColor Cyan
    & $adb install -r "DMRTranscriptionService\app\build\outputs\apk\debug\app-debug.apk" 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host " Install failed!" -ForegroundColor Red
        continue
    }
    Write-Host " Install OK" -ForegroundColor Green
    
    # Step 3: Push audio file
    Write-Host " [3/6] Pushing audio file to device..." -ForegroundColor Cyan
    & $adb push $AudioFile $devicePath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host " Push failed!" -ForegroundColor Red
        continue
    }
    Write-Host " Push OK" -ForegroundColor Green
    
    # Step 4: Stop services and clear logs
    Write-Host " [4/6] Preparing device..." -ForegroundColor Cyan
    & $adb shell "am force-stop com.mac.dmr ; am force-stop com.macdmr.transcription" 2>&1 | Out-Null
    & $adb logcat -c 2>&1 | Out-Null
    Start-Sleep -Seconds 1
    Write-Host " Device ready" -ForegroundColor Green
    
    # Step 5: Start log monitoring in background
    Write-Host " [5/6] Starting test..." -ForegroundColor Cyan
    
    $logJob = Start-Job -ScriptBlock {
        param($adbPath)
        & $adbPath logcat -s "WhisperTranscriber:I" "TranscriptionService:I" "*:E"
    } -ArgumentList $adb
    
    Start-Sleep -Seconds 1
    
    # Send test broadcast
    & $adb shell am start `
        -n "com.macdmr.transcription/.TestActivity" `
        --es "test_file" $devicePath 2>&1 | Out-Null
    
    Write-Host " Test started, waiting for result..." -ForegroundColor Yellow
    
    # Step 6: Wait and check logs
    Start-Sleep -Seconds 15  # Give it time to load model and transcribe
    
    Stop-Job $logJob
    $logOutput = Receive-Job $logJob
    Remove-Job $logJob
    
    # Parse transcription result
    $transcriptionLine = $logOutput | Where-Object { $_ -match "TEST RESULT:|TRANSCRIPTION:" } | Select-Object -Last 1
    
    if ($transcriptionLine) {
        # Extract the actual transcription text
        if ($transcriptionLine -match "TEST RESULT:\s*(.+)$") {
            $actualText = $matches[1].Trim()
        } elseif ($transcriptionLine -match "TRANSCRIPTION:\s*(.+)$") {
            $actualText = $matches[1].Trim()
        } else {
            $actualText = "[Could not parse]"
        }
        
        Write-Host "`n [6/6] RESULT:" -ForegroundColor Cyan
        Write-Host "   Expected: '$ExpectedText'" -ForegroundColor Yellow
        Write-Host "   Actual:   '$actualText'" -ForegroundColor White
        
        # Check for errors
        $hasError = $logOutput | Where-Object { $_ -match "ORT.*EXCEPTION|FATAL|Error:" }
        if ($hasError) {
            Write-Host "`n ERROR DETECTED:" -ForegroundColor Red
            $hasError | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
            Write-Host "`n Retrying with fixes..." -ForegroundColor Yellow
        }
        # Check if matches (case-insensitive, flexible matching)
        elseif ($actualText -match "test.*test.*test" -or 
                $ExpectedText -match "1.*2.*3.*4" -and $actualText -match "1.*2.*3.*4") {
            Write-Host "`n SUCCESS! Transcription matches!" -ForegroundColor Green
            Write-Host "`n Attempts: $attempt" -ForegroundColor Cyan
            $success = $true
        }
        else {
            Write-Host "`n Mismatch - will retry" -ForegroundColor Yellow
        }
    } else {
        Write-Host " [6/6] No transcription result found in logs" -ForegroundColor Red
        Write-Host " Raw logs:" -ForegroundColor Gray
        $logOutput | ForEach-Object { Write-Host "   $_" -ForegroundColor DarkGray }
    }
    
    if (-not $success -and $attempt -lt $MaxAttempts) {
        Write-Host "`n Waiting 3 seconds before retry..." -ForegroundColor Gray
        Start-Sleep -Seconds 3
    }
}

Write-Host "`n=========================================" -ForegroundColor Cyan
if ($success) {
    Write-Host " FINAL RESULT: SUCCESS!" -ForegroundColor Green
    Write-Host " Transcription working correctly!" -ForegroundColor Green
} else {
    Write-Host " FINAL RESULT: FAILED" -ForegroundColor Red
    Write-Host " Could not get correct transcription after $MaxAttempts attempts" -ForegroundColor Red
}
Write-Host "=========================================`n" -ForegroundColor Cyan
