#!/usr/bin/env pwsh
# Iterative testing: rebuild, install, test until success
# Usage: .\iterate-until-success.ps1

param(
    [string]$ExpectedText = "one two three four five",
    [int]$MaxIterations = 20,
    [switch]$SkipBuild
)

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

function Build-APK {
    Write-Host "🔨 Building APK..." -ForegroundColor Cyan
    cd DMRTranscriptionService
    $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
    .\gradlew assembleDebug -q 2>&1 | Out-Null
    cd ..
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Build successful" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ Build failed!" -ForegroundColor Red
        return $false
    }
}

function Install-APK {
    Write-Host "📱 Installing APK..." -ForegroundColor Cyan
    & $adb install -r DMRTranscriptionService\app\build\outputs\apk\debug\app-debug.apk 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Installed" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ Install failed!" -ForegroundColor Red
        return $false
    }
}

function Test-Transcription {
    param([string]$Expected)
    
    Write-Host "🧪 Testing transcription..." -ForegroundColor Cyan
    
    # Stop services and clear logs
    & $adb shell "am force-stop com.mac.dmr ; am force-stop com.macdmr.transcription" 2>&1 | Out-Null
    & $adb logcat -c 2>&1 | Out-Null
    
    Write-Host "📢 SAY NOW: '$Expected'" -ForegroundColor Yellow -BackgroundColor DarkBlue
    Write-Host "   (Open MacDMR, click TXT, say the phrase)" -ForegroundColor Yellow
    Write-Host "`n⏳ Listening for 15 seconds...`n" -ForegroundColor Gray
    
    # Wait and collect logs
    Start-Sleep -Seconds 15
    
    $logs = & $adb logcat -d -s "WhisperTranscriber:I" "TranscriptionService:I" 2>&1
    
    # Check for expected text
    $transcriptionLine = $logs | Select-String "final transcription:|decoded:|result:" | Select-Object -Last 1
    
    if ($transcriptionLine) {
        Write-Host "📝 Result: $transcriptionLine" -ForegroundColor Cyan
        
        if ($transcriptionLine -match [regex]::Escape($Expected)) {
            Write-Host "✅ MATCH! Found: '$Expected'" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ No match. Expected: '$Expected'" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️  No transcription output found" -ForegroundColor Yellow
    }
    
    # Show errors if any
    $errors = $logs | Select-String "error|Error|ERROR|ORT_|failed" | Select-Object -First 3
    if ($errors) {
        Write-Host "`n⚠️  Errors:" -ForegroundColor Red
        $errors | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
    }
    
    # Show input stats
    $stats = $logs | Select-String "Input stats:" | Select-Object -Last 1
    if ($stats) {
        Write-Host "`n📊 $stats" -ForegroundColor Gray
    }
    
    return $false
}

# Main iteration loop
Write-Host "`n=== Iterative Transcription Testing ===" -ForegroundColor Cyan
Write-Host "Expected text: '$ExpectedText'" -ForegroundColor White
Write-Host "Max iterations: $MaxIterations" -ForegroundColor White
Write-Host "Skip build: $SkipBuild`n" -ForegroundColor White

$iteration = 0
$success = $false

while ($iteration -lt $MaxIterations -and -not $success) {
    $iteration++
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "Iteration $iteration / $MaxIterations" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor DarkGray
    
    # Build (unless skipped)
    if (-not $SkipBuild) {
        if (-not (Build-APK)) {
            Write-Host "`nBuild failed, check errors and fix code`n" -ForegroundColor Red
            Write-Host "Press Enter to continue or Ctrl+C to abort..." -ForegroundColor Yellow
            $null = Read-Host
            continue
        }
        
        if (-not (Install-APK)) {
            Write-Host "`nInstall failed, check device connection`n" -ForegroundColor Red
            Write-Host "Press Enter to continue or Ctrl+C to abort..." -ForegroundColor Yellow
            $null = Read-Host
            continue
        }
    }
    
    # Test
    $success = Test-Transcription -Expected $ExpectedText
    
    if (-not $success) {
        Write-Host "`n❌ Attempt $iteration failed`n" -ForegroundColor Red
        
        if ($iteration -lt $MaxIterations) {
            Write-Host "Options:" -ForegroundColor Yellow
            Write-Host "  [Enter]  - Try again" -ForegroundColor White
            Write-Host "  [e]      - Edit code first, then rebuild & test" -ForegroundColor White
            Write-Host "  [s]      - Skip build, just test again" -ForegroundColor White
            Write-Host "  [q]      - Quit" -ForegroundColor White
            
            $choice = Read-Host "`nChoice"
            
            if ($choice -eq "q") {
                Write-Host "`nAborted by user" -ForegroundColor Yellow
                exit 1
            } elseif ($choice -eq "e") {
                Write-Host "`n📝 Edit code now, then press Enter to rebuild..." -ForegroundColor Cyan
                $null = Read-Host
                $SkipBuild = $false
            } elseif ($choice -eq "s") {
                $SkipBuild = $true
            }
        }
    }
}

if ($success) {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host "🎉 SUCCESS after $iteration iteration(s)!" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    Write-Host "❌ Failed after $MaxIterations iterations" -ForegroundColor Red
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Red
    exit 1
}
