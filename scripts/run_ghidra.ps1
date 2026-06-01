# Simple Ghidra Firmware Analysis Script
# Requires: Java 17+ and Ghidra 11+ already installed

$ErrorActionPreference = "Stop"

Write-Host "`n════════════════════════════════════════════════════════"
Write-Host "  GHIDRA FIRMWARE ANALYSIS"
Write-Host "════════════════════════════════════════════════════════`n"

# Configuration
$firmwarePath = "app\src\main\assets\DMR003.UV4T.V022.bin"
$outputDir = "ghidra_decompiled"
$projectName = "DMR_Firmware"

# Check firmware exists
if (-not (Test-Path $firmwarePath)) {
    Write-Host "ERROR: Firmware not found at $firmwarePath" -ForegroundColor Red
    exit 1
}

Write-Host "[1/4] Checking Java..." -ForegroundColor Cyan
try {
    $javaVer = java -version 2>&1 | Select-Object -First 1
    Write-Host "  Found: $javaVer" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Java not found. Install from https://adoptium.net/" -ForegroundColor Red
    exit 1
}

Write-Host "`n[2/4] Locating Ghidra..." -ForegroundColor Cyan
$ghidraPaths = @("C:\ghidra_11.2.1_PUBLIC", "C:\ghidra_11.2_PUBLIC", "C:\ghidra_11.1_PUBLIC", "C:\ghidra")
$ghidraDir = $null

foreach ($path in $ghidraPaths) {
    $ahPath = Join-Path $path "support\analyzeHeadless.bat"
    if (Test-Path $ahPath) {
        $ghidraDir = $path
        break
    }
}

if (-not $ghidraDir) {
    Write-Host "  ERROR: Ghidra not found. Install from https://ghidra-sre.org/" -ForegroundColor Red
    Write-Host "  Extract to C:\ghidra_11.2.1_PUBLIC" -ForegroundColor Yellow
    exit 1
}

Write-Host "  Found: $ghidraDir" -ForegroundColor Green

Write-Host "`n[3/4] Preparing workspace..." -ForegroundColor Cyan
if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$projectDir = Join-Path $outputDir "project"
New-Item -ItemType Directory -Path $projectDir -Force | Out-Null
Write-Host "  Workspace: $outputDir" -ForegroundColor Green

Write-Host "`n[4/4] Running Ghidra analysis (15-20 min)..." -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Yellow

$analyzeHeadless = Join-Path $ghidraDir "support\analyzeHeadless.bat"
$absProject = (Resolve-Path $projectDir).Path
$absFirmware = (Resolve-Path $firmwarePath).Path

& $analyzeHeadless $absProject $projectName -import $absFirmware -processor "ARM:LE:32:Cortex" -cspec "default" -loader "BinaryLoader" -loader-baseAddr "0x08000000" -overwrite

Write-Host "`n════════════════════════════════════════════════════════"
Write-Host "  ANALYSIS COMPLETE!"
Write-Host "════════════════════════════════════════════════════════`n"
Write-Host "Project location: $absProject" -ForegroundColor Yellow
Write-Host "`nTo view:`n  1. Open Ghidra`n  2. File > Open Project > $projectName`n  3. Double-click DMR003.UV4T.V022.bin`n"
