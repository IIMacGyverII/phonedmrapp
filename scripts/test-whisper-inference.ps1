# Wait for device after reboot
Write-Host "`n⏳ Waiting for device to come back online..." -ForegroundColor Cyan
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" wait-for-device
Start-Sleep -Seconds 5

Write-Host "✅ Device ready!" -ForegroundColor Green
Write-Host "📋 Clearing logs..." -ForegroundColor Yellow
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" logcat -c

Write-Host "`n🔍 Starting real-time log monitoring..." -ForegroundColor Cyan
Write-Host "Watching for:" -ForegroundColor Gray
Write-Host "  - Model loading" -ForegroundColor White
Write-Host "  - Mel spectrogram computation" -ForegroundColor White
Write-Host "  - TFLite inference execution" -ForegroundColor White
Write-Host "  - Token decoding" -ForegroundColor White
Write-Host "  - Final transcription result`n" -ForegroundColor White

Write-Host "🧪 Open MacDMR, enable TXT, and receive audio...`n" -ForegroundColor Yellow

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" logcat -s "TranscriptionService:*" "WhisperTranscriber:*" "DMRModHooks:*" "AndroidRuntime:E"
