# ════════════════════════════════════════════════════════════════
# AUTOMATED GHIDRA FIRMWARE DECOMPILATION - SIMPLIFIED VERSION
# ════════════════════════════════════════════════════════════════
# Purpose: Completely decompile DMR firmware using Ghidra headless
# Target: DMR003.UV4T.V022.bin (ARM Cortex-M Thumb)
# ════════════════════════════════════════════════════════════════

param(
    [string]$FirmwarePath = "app\src\main\assets\DMR003.UV4T.V022.bin",
    [string]$OutputDir = "ghidra_decompiled",
    [string]$GhidraInstallDir = "",
    [switch]$SkipInstall = $false
)

$ErrorActionPreference = "Continue"

Write-Host "`n════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  AUTOMATED GHIDRA FIRMWARE DECOMPILATION" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════
# STEP 1: Check Java JDK
# ═══════════════════════════════════════════════════════════════
Write-Host "[1/5] Checking Java JDK..." -ForegroundColor Cyan

$javaOk = $false
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "  Java found: $javaVersion" -ForegroundColor Green
    $javaOk = $true
} catch {
    Write-Host "  ✗ Java not found" -ForegroundColor Red
    Write-Host "  Please install Java 17+ from: https://adoptium.net/" -ForegroundColor Yellow
    Write-Host "  After installing, restart PowerShell and run again.`n" -ForegroundColor Yellow
    exit 1
}

# ═══════════════════════════════════════════════════════════════
# STEP 2: Find Ghidra
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[2/5] Checking Ghidra installation..." -ForegroundColor Cyan

$ghidraFound = $false
$searchPaths = @(
    "C:\ghidra_11.2.1_PUBLIC",
    "C:\ghidra_11.2_PUBLIC",
    "C:\ghidra_11.1_PUBLIC",
    "C:\ghidra_11.0_PUBLIC",
    "C:\ghidra_10.4_PUBLIC",
    "C:\ghidra",
    "$env:USERPROFILE\ghidra",
    "C:\Program Files\ghidra"
)

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $analyzeHeadless = Join-Path $path "support\analyzeHeadless.bat"
        if (Test-Path $analyzeHeadless) {
            $GhidraInstallDir = $path
            $ghidraFound = $true
            Write-Host "  ✓ Ghidra found at: $GhidraInstallDir" -ForegroundColor Green
            break
        }
    }
}

if (-not $ghidraFound) {
    Write-Host "  ✗ Ghidra not found" -ForegroundColor Red
    Write-Host "`n  Please install Ghidra:" -ForegroundColor Yellow
    Write-Host "  1. Download from: https://ghidra-sre.org/" -ForegroundColor White
    Write-Host "  2. Extract to C:\ghidra_11.2.1_PUBLIC" -ForegroundColor White
    Write-Host "  3. Re-run this script`n" -ForegroundColor White
    
    Write-Host "  Or specify path with: -GhidraInstallDir 'C:\your\path'`n" -ForegroundColor Cyan
    exit 1
}

# ═══════════════════════════════════════════════════════════════
# STEP 3: Prepare workspace
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[3/5] Preparing workspace..." -ForegroundColor Cyan

if (-not (Test-Path $FirmwarePath)) {
    Write-Host "  ✗ Firmware not found: $FirmwarePath" -ForegroundColor Red
    exit 1
}

$firmwareInfo = Get-Item $FirmwarePath
Write-Host "  Firmware: $($firmwareInfo.Name)" -ForegroundColor White
Write-Host "  Size: $($firmwareInfo.Length) bytes" -ForegroundColor White

# Create output directory
if (Test-Path $OutputDir) {
    Write-Host "  Cleaning previous output..." -ForegroundColor Yellow
    Remove-Item $OutputDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$projectDir = Join-Path $OutputDir "ghidra_project"
New-Item -ItemType Directory -Path $projectDir -Force | Out-Null

Write-Host "  ✓ Workspace ready: $OutputDir" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# STEP 4: Run Ghidra headless analysis
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[4/5] Running Ghidra analysis..." -ForegroundColor Cyan
Write-Host "  This will take 15-20 minutes..." -ForegroundColor Yellow
Write-Host "  Analyzing ~378 KB firmware...`n" -ForegroundColor Cyan

$analyzeHeadless = Join-Path $GhidraInstallDir "support\analyzeHeadless.bat"
$absProjectDir = (Resolve-Path $projectDir).Path
$absFirmwarePath = (Resolve-Path $FirmwarePath).Path

Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  GHIDRA ANALYSIS STARTING..." -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Yellow

# Run Ghidra analyzeHeadless
$ghidraArgs = @(
    $absProjectDir
    "DMR_Firmware"
    "-import"
    $absFirmwarePath
    "-processor"
    "ARM:LE:32:Cortex"
    "-cspec"
    "default"
    "-loader"
    "BinaryLoader"
    "-loader-baseAddr"
    "0x08000000"
    "-loader-fileOffset"
    "0x0"
    "-overwrite"
    "-analysisTimeoutPerFile"
    "0"
)

Write-Host "Running: $analyzeHeadless" -ForegroundColor Gray
Write-Host "  Project: $absProjectDir" -ForegroundColor Gray
Write-Host "  Binary: $absFirmwarePath" -ForegroundColor Gray
Write-Host "  Base Address: 0x08000000" -ForegroundColor Gray
Write-Host "  Processor: ARM Cortex-M Thumb`n" -ForegroundColor Gray

& $analyzeHeadless @ghidraArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n✗ Ghidra analysis failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

Write-Host "`n✓ Ghidra analysis complete!" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# STEP 5: Check results
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[5/5] Checking analysis results..." -ForegroundColor Cyan

$projectFiles = Get-ChildItem $projectDir -Recurse -File
Write-Host "  Generated files: $($projectFiles.Count)" -ForegroundColor White

$repFile = Get-ChildItem $projectDir -Filter "*.rep" -Recurse -File | Select-Object -First 1
if ($repFile) {
    Write-Host "  ✓ Ghidra project created successfully" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Warning: Project files may be incomplete" -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════
Write-Host "`n════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ANALYSIS COMPLETE!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Ghidra project location:" -ForegroundColor Yellow
Write-Host "  $absProjectDir`n" -ForegroundColor White

Write-Host "To open in Ghidra GUI:" -ForegroundColor Cyan
Write-Host "  1. Launch Ghidra" -ForegroundColor White
Write-Host "  2. File > Open Project" -ForegroundColor White
Write-Host "  3. Navigate to: $absProjectDir" -ForegroundColor White
Write-Host "  4. Open DMR_Firmware project" -ForegroundColor White
Write-Host "  5. Double-click DMR003.UV4T.V022.bin`n" -ForegroundColor White

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  • Search for 'contactType' in decompiled code" -ForegroundColor White
Write-Host "  • Navigate to addresses 0x08018F26, 0x080490E2" -ForegroundColor White
Write-Host "  • Find DMR frame receive handlers" -ForegroundColor White
Write-Host "  • Trace group ID extraction logic`n" -ForegroundColor White

Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
