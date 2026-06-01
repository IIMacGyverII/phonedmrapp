#!/usr/bin/env pwsh
# Quick test: Record on PC and test transcription
# Usage: .\quick-test.ps1

$expectedText = "one two three four"
$audioFile = "test_audio.wav"
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "`n=== Quick Transcription Test ===" -ForegroundColor Cyan
Write-Host "Expected: '$expectedText'`n" -ForegroundColor White

# Check if audio exists
if (-not (Test-Path $audioFile)) {
    Write-Host "📝 Record audio now:" -ForegroundColor Yellow
    Write-Host "   1. Windows Sound Recorder opened (or open manually)" -ForegroundColor White
    Write-Host "   2. Click Record 🔴" -ForegroundColor Red
    Write-Host "   3. Say clearly: '$expectedText'" -ForegroundColor Cyan
    Write-Host "   4. Click Stop ⏹️" -ForegroundColor White
    Write-Host "   5. Save as: $audioFile in current folder`n" -ForegroundColor White
    
    # Try to open Sound Recorder
    try {
        Start-Process "ms-soundrecorder:" -ErrorAction SilentlyContinue
    } catch {
        Write-Host "   (Open Sound Recorder manually: Win+R > ms-soundrecorder:)" -ForegroundColor Gray
    }
    
    Write-Host "`nPress Enter when audio file is ready..." -ForegroundColor Yellow
    $null = Read-Host
    
    if (-not (Test-Path $audioFile)) {
        Write-Host "❌ File still not found: $audioFile" -ForegroundColor Red
        exit 1
    }
}

# File exists, proceed with test
$fileInfo = Get-Item $audioFile
Write-Host "✅ Audio file: $($fileInfo.Name) ($([math]::Round($fileInfo.Length/1024, 1)) KB)" -ForegroundColor Green

# Setup monitoring
Write-Host "`n🔧 Setting up test..." -ForegroundColor Cyan
& $adb shell "am force-stop com.mac.dmr ; am force-stop com.macdmr.transcription" 2>&1 | Out-Null
& $adb logcat -c 2>&1 | Out-Null

Write-Host "`n📱 Manual steps:" -ForegroundColor Yellow
Write-Host "   1. Play $audioFile on your PC speakers" -ForegroundColor White
Write-Host "   2. Hold phone microphone near speaker" -ForegroundColor White
Write-Host "   3. Open MacDMR and click TXT button" -ForegroundColor White
Write-Host "`nPress Enter when ready to start monitoring..." -ForegroundColor Yellow
$null = Read-Host

# Start monitoring
Write-Host "`n🔍 Monitoring logs..." -ForegroundColor Cyan
Write-Host "Listening for: '$expectedText'`n" -ForegroundColor Gray

$startTime = Get-Date
$timeout = 30
$found = $false

while (((Get-Date) - $startTime).TotalSeconds -lt $timeout -and -not $found) {
    Start-Sleep -Seconds 2
    
    $logs = & $adb logcat -d -s "WhisperTranscriber:I" "TranscriptionService:I" 2>&1
    
    # Check for the phrase
    if ($logs -match "one.*two.*three.*four" -or $logs -match "1.*2.*3.*4") {
        Write-Host "`n✅ SUCCESS! Found transcription!" -ForegroundColor Green
        $found = $true
        
        # Show relevant logs
        $logs | Select-String "Input stats|Inference|decoded|transcription" | ForEach-Object {
            Write-Host "   $_" -ForegroundColor Cyan
        }
        break
    }
    
    # Show progress
    $elapsed = [math]::Round(((Get-Date) - $startTime).TotalSeconds)
    Write-Host "`r⏳ Waiting... ${elapsed}s / ${timeout}s" -NoNewline -ForegroundColor Gray
    
    # Check for errors
    if ($logs -match "error|Error|ORT_|failed") {
        Write-Host "`n`n⚠️  Error detected:" -ForegroundColor Red
        $logs | Select-String "error|Error|ORT_" -CaseSensitive:$false | Select-Object -First 3 | ForEach-Object {
            Write-Host "   $_" -ForegroundColor Red
        }
    }
}

if (-not $found) {
    Write-Host "`n`n❌ Transcription not found within ${timeout}s" -ForegroundColor Red
    Write-Host "`n📋 Recent logs:" -ForegroundColor Yellow
    & $adb logcat -d -s "WhisperTranscriber:I" "TranscriptionService:I" | Select-Object -Last 20 | ForEach-Object {
        Write-Host "   $_" -ForegroundColor Gray
    }
    exit 1
}

Write-Host "`n🎉 Test completed successfully!" -ForegroundColor Green
exit 0
