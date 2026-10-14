# Headless Ghidra import of DMR003.UV4T.V022-ORIGINAL.bin (FW-A1c).
# Does not patch or flash. Requires JDK 21 and Ghidra 12.1.3.
param(
    [string]$BaseAddr = "0x08000000",
    [string]$Processor = "ARM:LE:32:Cortex",
    [string]$GhidraHome = "C:\Users\Joshua\tools\ghidra_12.1.3_PUBLIC",
    [string]$JavaHome = "C:\Users\Joshua\tools\jdk-21.0.12.1+1"
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $PSScriptRoot
$Firmware = Join-Path $Repo "radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
$ScriptDir = Join-Path $Repo "radio_firmware\ghidra_scripts"
$ProjectDir = Join-Path $Repo "radio_firmware\ghidra_project_fw0"
$Log = Join-Path $Repo "radio_firmware\ghidra_fw0_headless.log"

if (-not (Test-Path $Firmware)) { throw "missing $Firmware" }
if (-not (Test-Path (Join-Path $GhidraHome "support\analyzeHeadless.bat"))) {
    throw "analyzeHeadless.bat not under $GhidraHome"
}

if (-not $JavaHome) {
    $candidates = @(
        $env:JAVA_HOME,
        "C:\Program Files\Eclipse Adoptium\jdk-21.0.8.9-hotspot",
        "C:\Program Files\Eclipse Adoptium\jdk-21.0.12.1-hotspot",
        "C:\Program Files\Eclipse Adoptium\jdk-21.0.12+7-hotspot"
    )
    Get-ChildItem "C:\Program Files\Eclipse Adoptium" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $candidates += $_.FullName
    }
    foreach ($c in $candidates) {
        if ($c -and (Test-Path (Join-Path $c "bin\java.exe"))) {
            $JavaHome = $c
            break
        }
    }
}
if (-not $JavaHome) { throw "JDK 21 not found. Install Temurin 21 or pass -JavaHome" }

$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$env:PATH"
& "$JavaHome\bin\java.exe" -version

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null

$headless = Join-Path $GhidraHome "support\analyzeHeadless.bat"
$args = @(
    $ProjectDir,
    "DMR003_UV4T_V022_fw0",
    "-import", $Firmware,
    "-overwrite",
    "-processor", $Processor,
    "-cspec", "default",
    "-loader", "BinaryLoader",
    "-loader-baseAddr", $BaseAddr,
    "-scriptPath", $ScriptDir,
    "-preScript", "Fw0SetThumb.java",
    "-postScript", "Fw0Identify.java",
    "-postScript", "Fw0Dump.java",
    "-analysisTimeoutPerFile", "1800",
    "-max-cpu", "4",
    "-log", $Log
)

Write-Host "JAVA_HOME=$JavaHome"
Write-Host "Ghidra=$GhidraHome"
Write-Host "base=$BaseAddr processor=$Processor"
Write-Host "Running analyzeHeadless..."
& $headless @args
$code = $LASTEXITCODE
Write-Host "analyzeHeadless exit $code"
Write-Host "log: $Log"
exit $code
