#!/usr/bin/env pwsh
# test_all_modes.ps1 — Convert SSTV test MP3s to WAV and decode + auto-detect all modes.
#
# Usage:  cd sstv-standalone ; .\test_all_modes.ps1

$ErrorActionPreference = "Continue"

$scriptDir  = $PSScriptRoot
$audioDir   = Join-Path $scriptDir "..\sstv test\audio"
$wavDir     = Join-Path $scriptDir "..\sstv test\wav"
$outputDir  = Join-Path $scriptDir "..\sstv test\output"

# Create directories if needed
New-Item -ItemType Directory -Force -Path $wavDir   | Out-Null
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

# ------------------------------------------------------------------
# Step 1: Compile the decoder
# ------------------------------------------------------------------
Write-Host "`n=== Compiling SSTVStandaloneDecoder ===" -ForegroundColor Cyan
Push-Location $scriptDir
$compileResult = javac SSTVStandaloneDecoder.java 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "COMPILE FAILED:" -ForegroundColor Red
    $compileResult | Write-Host
    Pop-Location ; exit 1
}
Write-Host "Compile OK" -ForegroundColor Green
Pop-Location

# ------------------------------------------------------------------
# Step 2: Convert each MP3 to mono 22050 Hz 16-bit WAV
# ------------------------------------------------------------------
Write-Host "`n=== Converting MP3s to WAV ===" -ForegroundColor Cyan
$mp3Files = Get-ChildItem -Path $audioDir -Filter "*.mp3" | Sort-Object Name
if ($mp3Files.Count -eq 0) {
    Write-Host "No MP3 files found in: $audioDir" -ForegroundColor Yellow
    exit 1
}

foreach ($mp3 in $mp3Files) {
    $wavPath = Join-Path $wavDir ($mp3.BaseName + ".wav")
    if (Test-Path $wavPath) {
        Write-Host "  SKIP (exists): $($mp3.Name)"
    } else {
        Write-Host "  Converting: $($mp3.Name) -> $($mp3.BaseName).wav"
        $ffResult = & ffmpeg -i $mp3.FullName -ac 1 -ar 22050 -sample_fmt s16 $wavPath -y 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  ffmpeg FAILED for $($mp3.Name)" -ForegroundColor Red
        }
    }
}

# ------------------------------------------------------------------
# Step 3: Decode each WAV — output PNG goes alongside the WAV
# ------------------------------------------------------------------
Write-Host "`n=== Decoding all WAV files ===" -ForegroundColor Cyan

$wavFiles = Get-ChildItem -Path $wavDir -Filter "*.wav" | Sort-Object Name
$results  = @()

foreach ($wav in $wavFiles) {
    Write-Host "`n--- $($wav.Name) ---" -ForegroundColor Yellow
    Push-Location $scriptDir
    $output = java SSTVStandaloneDecoder $wav.FullName 2>&1
    Pop-Location

    $output | Write-Host

    # Parse key info from output
    $detMatch  = $output | Select-String "DETECTED:"  | Select-Object -Last 1
    $lineMatch = $output | Select-String "Lines decoded:" | Select-Object -Last 1
    $savedMatch= $output | Select-String "SAVED:"     | Select-Object -Last 1
    $detected  = if ($detMatch)   { ($detMatch.ToString()  -replace '.*DETECTED: *','').Trim() } else { "UNKNOWN" }
    $lines     = if ($lineMatch)  { ($lineMatch.ToString() -replace '.*Lines decoded: *','').Trim() } else { "?" }
    $saved     = if ($savedMatch) { "Yes" } else { "No" }

    $results += [PSCustomObject]@{
        File     = $wav.Name
        Detected = $detected
        Lines    = $lines
        Saved    = $saved
    }

    # Copy output PNG to output dir
    $pngSrc = Join-Path $wavDir ($wav.BaseName + "_decoded.png")
    if (Test-Path $pngSrc) {
        Copy-Item -Force $pngSrc (Join-Path $outputDir ($wav.BaseName + "_decoded.png"))
    }
}

# ------------------------------------------------------------------
# Step 4: Summary
# ------------------------------------------------------------------
Write-Host "`n=== RESULTS SUMMARY ===" -ForegroundColor Cyan
$results | Format-Table -AutoSize

Write-Host "`nDecoded PNGs in: $outputDir" -ForegroundColor Green

# Open output directory in Explorer
Start-Process explorer.exe $outputDir
