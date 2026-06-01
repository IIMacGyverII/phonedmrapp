# Test ONNX transcription with test_audio.wav
Write-Host "🧪 Testing ONNX Whisper Base Transcription" -ForegroundColor Cyan
Write-Host ""

# Start test activity with correct file path
Write-Host "Starting test... " -NoNewline
adb shell am start -n com.macdmr.transcription/.TestActivity `
    --es test_file "/data/data/com.macdmr.transcription/test_audio.wav" 2>&1 | Out-Null

Start-Sleep -Seconds 2
Write-Host "✅" -ForegroundColor Green

# Monitor logs for 30 seconds  
Write-Host "Monitoring logs (30 seconds)..." -ForegroundColor Yellow
Write-Host ""

$startTime = Get-Date
$timeout = 30

while (((Get-Date) - $startTime).TotalSeconds -lt $timeout) {
    $logs = adb logcat -d -v time | Select-String -Pattern "WhisperTranscriber|TestActivity|TranscriptionService"
    $logs | Select-Object -Last 20 | ForEach-Object { Write-Host $_ }
    
    # Check if transcription completed
    if ($logs -match "📝 Transcription result:") {
        Write-Host ""
       Write-Host "✅ Transcription completed!" -ForegroundColor Green
        break
    }
    
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "Test finished." -ForegroundColor Cyan
