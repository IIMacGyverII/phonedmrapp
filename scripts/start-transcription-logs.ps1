# Wait for device and start fresh logging
Write-Host "`n⏳ Waiting for device..." -ForegroundColor Cyan
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" wait-for-device
Start-Sleep -Seconds 2

Write-Host "📋 Clearing logcat..." -ForegroundColor Yellow
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" logcat -c

Write-Host "🔍 Monitoring transcription service logs..." -ForegroundColor Green
Write-Host "Watching for: Service creation, thread start, model loading, exceptions`n" -ForegroundColor Gray

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" logcat -s "TranscriptionService:*" "WhisperTranscriber:*" "AndroidRuntime:E" "System.err:*"
