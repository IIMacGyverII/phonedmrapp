# Headless Ghidra import of DMR003.UV4T.V022-ORIGINAL.bin as C-SKY v2 (FW1).
# Needs the community C-SKY processor module installed under
# <Ghidra>\Ghidra\Extensions\C-SKY (taligentx/ghidra_csky_WinnerMicro v0.2,
# extension.properties pinned to the installed Ghidra version).
# Does not patch or flash. Requires JDK 21 and Ghidra 12.1.3.
param(
    [string]$BaseAddr = "0x00000000",
    [string]$Processor = "CSKY_V2:LE:32:default",
    [string]$ProjectName = "DMR003_UV4T_V022_csky",
    [string]$GhidraHome = "C:\Users\Joshua\tools\ghidra_12.1.3_PUBLIC",
    [string]$JavaHome = "C:\Users\Joshua\tools\jdk-21.0.12.1+1"
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $PSScriptRoot
$Firmware = Join-Path $Repo "radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
$ScriptDir = Join-Path $Repo "radio_firmware\ghidra_scripts"
$ProjectDir = Join-Path $Repo "radio_firmware\ghidra_project_fw0"
$Log = Join-Path $Repo "radio_firmware\ghidra_fw1_csky.log"

if (-not (Test-Path $Firmware)) { throw "missing $Firmware" }
if (-not (Test-Path (Join-Path $GhidraHome "support\analyzeHeadless.bat"))) {
    throw "analyzeHeadless.bat not under $GhidraHome"
}
if (-not (Test-Path (Join-Path $GhidraHome "Ghidra\Extensions\C-SKY\data\languages\csky_v2.ldefs"))) {
    throw "C-SKY processor module not installed under $GhidraHome\Ghidra\Extensions\C-SKY"
}
if (-not (Test-Path (Join-Path $JavaHome "bin\java.exe"))) { throw "JDK not at $JavaHome" }

$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$env:PATH"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null

$headless = Join-Path $GhidraHome "support\analyzeHeadless.bat"
$args = @(
    $ProjectDir,
    $ProjectName,
    "-import", $Firmware,
    "-overwrite",
    "-processor", $Processor,
    "-cspec", "default",
    "-loader", "BinaryLoader",
    "-loader-baseAddr", $BaseAddr,
    "-scriptPath", $ScriptDir,
    "-preScript", "FwCskySeed.java",
    "-postScript", "FwCskyStats.java",
    "-analysisTimeoutPerFile", "2400",
    "-max-cpu", "4",
    "-log", $Log
)

Write-Host "JAVA_HOME=$JavaHome"
Write-Host "Ghidra=$GhidraHome"
Write-Host "base=$BaseAddr processor=$Processor project=$ProjectName"
Write-Host "Running analyzeHeadless..."
& $headless @args
$code = $LASTEXITCODE
Write-Host "analyzeHeadless exit $code"
Write-Host "log: $Log"
exit $code
