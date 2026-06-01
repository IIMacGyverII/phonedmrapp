# Wait for device and monitor FFT performance
Write-Host "`n⏳ Waiting for device..." -ForegroundColor Cyan
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" wait-for-device
Start-Sleep -Seconds 5

Write-Host "✅ Device ready!" -ForegroundColor Green
Write-Host "📋 Clearing logs..." -ForegroundColor Yellow
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" logcat -c

Write-Host "`n🔍 Monitoring FFT performance..." -ForegroundColor Cyan
Write-Host "Watching for:" -ForegroundColor Gray
Write-Host "  - Mel spectrogram timing" -ForegroundColor White
Write-Host "  - Inference timing" -ForegroundColor White
Write-Host "  - Token output & decoding" -ForegroundColor White
Write-Host "  - Total processing time`n" -ForegroundColor White

Write-Host "🧪 Open MacDMR, enable TXT, receive audio...`n" -ForegroundColor Yellow

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" logcat -s "WhisperTranscriber:I" "TranscriptionService:I" "AndroidRuntime:E"
