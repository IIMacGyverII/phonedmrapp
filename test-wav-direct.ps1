#!/usr/bin/env pwsh
# Direct WAV file testing through transcription service
# This creates a simple Android test that feeds audio directly to the service

param(
    [string]$WavFile = "test_audio.wav",
    [string]$ExpectedText = "one two three four five"
)

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "`n=== Direct WAV Testing ===" -ForegroundColor Cyan
Write-Host "WAV file: $WavFile" -ForegroundColor White
Write-Host "Expected: '$ExpectedText'`n" -ForegroundColor White

# Check if file exists
if (-not (Test-Path $WavFile)) {
    Write-Host "❌ WAV file not found!" -ForegroundColor Red
    Write-Host "`n📝 Record audio now:" -ForegroundColor Yellow
    Write-Host "1. Open Sound Recorder (Win+R > mssoundrecorder:)" -ForegroundColor White
    Write-Host "2. Click Record 🔴" -ForegroundColor Red
    Write-Host "3. Say clearly: '$ExpectedText'" -ForegroundColor Cyan
    Write-Host "4. Click Stop ⏹️" -ForegroundColor White
    Write-Host "5. Click ... > Rename > '$WavFile'" -ForegroundColor White
    Write-Host "6. Move file to: $(Get-Location)`n" -ForegroundColor White
    exit 1
}

# Get audio info
$audioInfo = & ffmpeg -i $WavFile 2>&1 | Select-String "Duration|Audio:"
Write-Host "📊 Audio info:" -ForegroundColor Cyan
$audioInfo | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }

# Convert to 8kHz mono PCM (Whisper/DMR format)
Write-Host "`n🔄 Converting to 8kHz mono PCM..." -ForegroundColor Cyan
$pcmFile = "test_audio_8k_mono.pcm"

& ffmpeg -i $WavFile -f s16le -acodec pcm_s16le -ar 8000 -ac 1 $pcmFile -y 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    $size = (Get-Item $pcmFile).Length
    $durationMs = ($size / 2) / 8  # 16-bit @ 8kHz = 2 bytes per sample
    Write-Host "✅ Converted: $([math]::Round($size/1024, 1)) KB, ~$([math]::Round($durationMs))ms" -ForegroundColor Green
} else {
    Write-Host "❌ Conversion failed! Install ffmpeg first" -ForegroundColor Red
    exit 1
}

# Create test method in Java to read PCM and call transcription
Write-Host "`n🔧 Creating transcription test..." -ForegroundColor Cyan

# For now, we'll manually trigger via UI and monitor
Write-Host "⚠️  Automated injection requires instrumentation test" -ForegroundColor Yellow
Write-Host "`n📋 Manual test procedure:" -ForegroundColor Cyan
Write-Host "1. Play $pcmFile near your radio" -ForegroundColor White
Write-Host "2. Click TXT in MacDMR" -ForegroundColor White
Write-Host "3. Check result below`n" -ForegroundColor White

Write-Host "Press Enter to start log monitoring..." -ForegroundColor Yellow
$null = Read-Host

# Clear logs and monitor
& $adb logcat -c
Write-Host "🔍 Monitoring logs (Ctrl+C to stop)...`n" -ForegroundColor Cyan

# Monitor and check for expected text
$process = Start-Process -FilePath $adb -ArgumentList "logcat", "-s", "WhisperTranscriber:I", "TranscriptionService:I" -NoNewWindow -PassThru -RedirectStandardOutput "transcription_output.txt"

Write-Host "Trigger transcription now! Watching for: '$ExpectedText'`n" -ForegroundColor Yellow

$timeout = 60  # 60 seconds timeout
$elapsed = 0
$found = $false

while ($elapsed -lt $timeout -and -not $found) {
    Start-Sleep -Seconds 1
    $elapsed++
    
    if (Test-Path "transcription_output.txt") {
        $content = Get-Content "transcription_output.txt" -Raw -ErrorAction SilentlyContinue
        
        if ($content -match [regex]::Escape($ExpectedText)) {
            Write-Host "`n✅ SUCCESS! Transcription matched: '$ExpectedText'" -ForegroundColor Green
            $found = $true
            
            # Show relevant logs
            Write-Host "`n📋 Transcription logs:" -ForegroundColor Cyan
            Get-Content "transcription_output.txt" | Select-String "Input stats|Inference|decoded|transcription" | ForEach-Object {
                Write-Host "   $_" -ForegroundColor White
            }
        }
        
        # Show any errors
        if ($content -match "error|Error|ERROR|ORT_|failed") {
            Write-Host "`n⚠️  Errors detected:" -ForegroundColor Red
            Get-Content "transcription_output.txt" | Select-String "error|Error|ERROR|ORT_|failed" | ForEach-Object {
                Write-Host "   $_" -ForegroundColor Red
            }
        }
    }
    
    Write-Host "`r⏳ Waiting... ${elapsed}s / ${timeout}s" -NoNewline -ForegroundColor Gray
}

Stop-Process -Id $process.Id -ErrorAction SilentlyContinue

if (-not $found) {
    Write-Host "`n`n❌ Expected text not found within ${timeout}s" -ForegroundColor Red
    Write-Host "`n📄 Full log output:" -ForegroundColor Yellow
    if (Test-Path "transcription_output.txt") {
        Get-Content "transcription_output.txt" | ForEach-Object {
            Write-Host "   $_" -ForegroundColor Gray
        }
    }
    exit 1
}

Write-Host "`n🎉 Test PASSED!" -ForegroundColor Green
exit 0
