#!/usr/bin/env pwsh
# Automated transcription testing script
# Usage: .\test-transcription-auto.ps1 -AudioFile "test_audio.wav" -ExpectedText "one two three four five"

param(
    [string]$AudioFile = "test_audio.wav",
    [string]$ExpectedText = "one two three four five",
    [int]$MaxAttempts = 10
)

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$devicePath = "/sdcard/test_transcription.pcm"

Write-Host "`n=== Automated Transcription Test ===" -ForegroundColor Cyan
Write-Host "Audio file: $AudioFile" -ForegroundColor White
Write-Host "Expected: '$ExpectedText'" -ForegroundColor White
Write-Host "Max attempts: $MaxAttempts`n" -ForegroundColor White

# Check if audio file exists
if (-not (Test-Path $AudioFile)) {
    Write-Host "❌ Audio file not found: $AudioFile" -ForegroundColor Red
    Write-Host "`nPlease record audio first:" -ForegroundColor Yellow
    Write-Host "1. Use Windows Voice Recorder or Audacity" -ForegroundColor White
    Write-Host "2. Record: '$ExpectedText'" -ForegroundColor Cyan
    Write-Host "3. Save as: $AudioFile" -ForegroundColor White
    Write-Host "4. Format: WAV, 16kHz, Mono, 16-bit" -ForegroundColor Gray
    exit 1
}

# Convert WAV to PCM if needed (simplified - assume ffmpeg available)
Write-Host "📂 Converting audio to PCM format..." -ForegroundColor Cyan
$pcmFile = "test_audio.pcm"

# Try to convert using ffmpeg
try {
    & ffmpeg -i $AudioFile -f s16le -acodec pcm_s16le -ar 8000 -ac 1 $pcmFile -y 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Audio converted to 8kHz mono PCM" -ForegroundColor Green
    } else {
        throw "ffmpeg failed"
    }
} catch {
    Write-Host "⚠️  ffmpeg not found, trying direct copy..." -ForegroundColor Yellow
    Copy-Item $AudioFile $pcmFile
}

# Push audio to device
Write-Host "📤 Pushing audio to device..." -ForegroundColor Cyan
& $adb push $pcmFile $devicePath 2>&1 | Out-Null
Write-Host "✅ Audio on device: $devicePath" -ForegroundColor Green

# Create test app on device (Java code to trigger transcription)
$testCode = @"
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import java.io.FileInputStream;

public class TranscriptionTest {
    public static void main(String[] args) {
        String audioPath = "$devicePath";
        // Read PCM file
        FileInputStream fis = new FileInputStream(audioPath);
        byte[] audio = new byte[fis.available()];
        fis.read(audio);
        fis.close();
        
        // Call transcription service
        // Note: This would need proper Android context
        System.out.println("Audio size: " + audio.length + " bytes");
    }
}
"@

Write-Host "`n⚠️  Direct service call requires an Android app." -ForegroundColor Yellow
Write-Host "Instead, we'll use logcat to monitor transcription results.`n" -ForegroundColor Yellow

Write-Host "📋 Manual steps:" -ForegroundColor Cyan
Write-Host "1. Open MacDMR on your device" -ForegroundColor White
Write-Host "2. Go to Settings > Record audio file: $AudioFile" -ForegroundColor White
Write-Host "3. Or play the audio near the radio and click TXT`n" -ForegroundColor White

Write-Host "Press Enter when ready to start monitoring..." -ForegroundColor Yellow
$null = Read-Host

# Monitor logs for transcription result
Write-Host "🔍 Monitoring transcription logs..." -ForegroundColor Cyan
Write-Host "Waiting for transcription result...`n" -ForegroundColor Gray

$attempt = 0
$found = $false

while ($attempt -lt $MaxAttempts -and -not $found) {
    $attempt++
    Write-Host "[$attempt/$MaxAttempts] Checking logs..." -ForegroundColor Gray
    
    # Get recent transcription logs
    $logs = & $adb logcat -d -s "WhisperTranscriber:I" "TranscriptionService:I" | Select-String -Pattern "transcription|result|decoded" -CaseSensitive:$false
    
    foreach ($log in $logs) {
        Write-Host $log -ForegroundColor DarkGray
        
        # Check if expected text appears
        if ($log -match [regex]::Escape($ExpectedText)) {
            Write-Host "`n✅ SUCCESS! Found expected text: '$ExpectedText'" -ForegroundColor Green
            $found = $true
            break
        }
    }
    
    if (-not $found) {
        Start-Sleep -Seconds 2
    }
}

if (-not $found) {
    Write-Host "`n❌ Expected text not found after $MaxAttempts attempts" -ForegroundColor Red
    Write-Host "Check logs for actual output" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n🎉 Test PASSED!" -ForegroundColor Green
exit 0
