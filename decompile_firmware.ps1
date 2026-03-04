# ════════════════════════════════════════════════════════════════
# AUTOMATED GHIDRA FIRMWARE DECOMPILATION SCRIPT
# ════════════════════════════════════════════════════════════════
# Purpose: Completely decompile DMR firmware using Ghidra headless
# Target: DMR003.UV4T.V022.bin (ARM Cortex-M Thumb)
# Output: Full C pseudocode, assembly, function lists, xrefs
# ════════════════════════════════════════════════════════════════

param(
    [string]$FirmwarePath = "app\src\main\assets\DMR003.UV4T.V022.bin",
    [string]$OutputDir = "ghidra_decompiled",
    [string]$GhidraInstallDir = "C:\ghidra",
    [switch]$SkipInstall = $false
)

$ErrorActionPreference = "Stop"

Write-Host "`n════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  AUTOMATED GHIDRA FIRMWARE DECOMPILATION" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════
# STEP 1: Check Java JDK (Ghidra requires Java 17+)
# ═══════════════════════════════════════════════════════════════
Write-Host "[1/7] Checking Java JDK..." -ForegroundColor Cyan

try {
    $javaVersion = (java -version 2>&1) | Select-String "version" | ForEach-Object { $_.ToString() }
    if ($javaVersion -match '(\d+)\.') {
        $majorVersion = [int]$matches[1]
        if ($majorVersion -ge 17) {
            Write-Host "  ✓ Java $majorVersion found" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Java $majorVersion too old (need 17+)" -ForegroundColor Red
            Write-Host "`nPlease install Java 17+ from:" -ForegroundColor Yellow
            Write-Host "  https://adoptium.net/temurin/releases/" -ForegroundColor White
            exit 1
        }
    }
} catch {
    Write-Host "  ✗ Java not found" -ForegroundColor Red
    Write-Host "`nInstalling Java 21 (Eclipse Temurin)..." -ForegroundColor Yellow
    
    # Download Java 21 JDK installer
    $javaUrl = "https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
    $javaInstaller = "$env:TEMP\temurin-21-jdk.msi"
    
    Write-Host "  Downloading Java 21 JDK..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $javaUrl -OutFile $javaInstaller -UseBasicParsing
    
    Write-Host "  Installing Java (may require admin)..." -ForegroundColor Yellow
    Start-Process msiexec.exe -ArgumentList "/i `"$javaInstaller`" /quiet /norestart" -Wait
    
    # Refresh environment
    $machPath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path","User")
    $env:Path = "$machPath;$userPath"
    
    Write-Host "  ✓ Java 21 installed" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════════════
# STEP 2: Check/Install Ghidra
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[2/7] Checking Ghidra installation..." -ForegroundColor Cyan

$ghidraFound = $false
$ghidraVersions = @(
    "C:\ghidra",
    "C:\ghidra_11.2.1_PUBLIC",
    "C:\ghidra_11.1_PUBLIC", 
    "C:\ghidra_11.0_PUBLIC",
    "$env:USERPROFILE\ghidra",
    "C:\Program Files\ghidra"
)

foreach ($path in $ghidraVersions) {
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

if (-not $ghidraFound -and -not $SkipInstall) {
    Write-Host "  ✗ Ghidra not found - downloading..." -ForegroundColor Yellow
    
    # Download latest Ghidra (11.2.1 as of Feb 2026)
    $ghidraUrl = "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.2.1_build/ghidra_11.2.1_PUBLIC_20241105.zip"
    $ghidraZip = "$env:TEMP\ghidra.zip"
    
    Write-Host "  Downloading Ghidra 11.2.1 (~540 MB)..." -ForegroundColor Cyan
    Write-Host "  This may take 5-10 minutes..." -ForegroundColor Yellow
    
    # Use .NET WebClient for progress
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($ghidraUrl, $ghidraZip)
    
    Write-Host "  ✓ Download complete" -ForegroundColor Green
    Write-Host "  Extracting Ghidra..." -ForegroundColor Cyan
    
    Expand-Archive -Path $ghidraZip -DestinationPath "C:\" -Force
    $GhidraInstallDir = "C:\ghidra_11.2.1_PUBLIC"
    
    Remove-Item $ghidraZip -Force
    Write-Host "  ✓ Ghidra installed to: $GhidraInstallDir" -ForegroundColor Green
}

if (-not (Test-Path $GhidraInstallDir)) {
    Write-Host "`n✗ ERROR: Ghidra not found at $GhidraInstallDir" -ForegroundColor Red
    Write-Host "Please install Ghidra manually or specify correct path with -GhidraInstallDir" -ForegroundColor Yellow
    exit 1
}

# ═══════════════════════════════════════════════════════════════
# STEP 3: Prepare workspace and firmware
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[3/7] Preparing workspace..." -ForegroundColor Cyan

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
    Remove-Item $OutputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$projectDir = Join-Path $OutputDir "ghidra_project"
New-Item -ItemType Directory -Path $projectDir -Force | Out-Null

Write-Host "  ✓ Workspace ready: $OutputDir" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# STEP 4: Create Ghidra import script
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[4/7] Creating import script..." -ForegroundColor Cyan

$importScript = @"
// Ghidra Headless Import Script for ARM Cortex-M Firmware
// @category Import

import ghidra.app.util.bin.format.elf.ElfException;
import ghidra.app.util.opinion.BinaryLoader;
import ghidra.program.model.listing.Program;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.address.Address;

public class ImportFirmware extends GhidraScript {
    @Override
    public void run() throws Exception {
        println("=== Importing ARM Cortex-M Firmware ===");
        
        Program program = currentProgram;
        Memory memory = program.getMemory();
        
        // Set base address to 0x08000000 (STM32/GD32 flash)
        Address baseAddr = toAddr(0x08000000);
        println("Base address: " + baseAddr);
        
        // Mark entry point (typical Cortex-M vector table)
        // Reset vector is at offset 0x04
        Address resetVector = toAddr(0x08000004);
        println("Marking reset vector at: " + resetVector);
        
        // Create entry point function
        createFunction(resetVector, "Reset_Handler");
        
        println("✓ Import configured for ARM Cortex-M Thumb mode");
    }
}
"@

$importScriptPath = Join-Path $OutputDir "import_script.java"
Set-Content -Path $importScriptPath -Value $importScript -Encoding UTF8
Write-Host "  ✓ Import script created" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# STEP 5: Create Ghidra analysis script
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[5/7] Creating analysis script..." -ForegroundColor Cyan

$analysisScript = @"
// Ghidra Headless Analysis Script for DMR Firmware
// @category Analysis

import ghidra.program.model.listing.*;
import ghidra.program.model.address.*;
import ghidra.app.decompiler.*;
import java.io.*;

public class AnalyzeFirmware extends GhidraScript {
    @Override
    public void run() throws Exception {
        println("=== Starting Firmware Analysis ===");
        
        Program program = currentProgram;
        Listing listing = program.getListing();
        
        // Find all contactType comparisons (CMP r2, #2)
        println("\\nSearching for contactType comparisons...");
        findContactTypeChecks();
        
        // Decompile all functions
        println("\\nDecompiling all functions...");
        decompileAllFunctions();
        
        println("\\n✓ Analysis complete!");
    }
    
    private void findContactTypeChecks() throws Exception {
        Program program = currentProgram;
        Memory memory = program.getMemory();
        
        // Search for CMP r2, #2 pattern (02 2A in little-endian)
        byte[] pattern = {(byte)0x02, (byte)0x2A};
        
        Address start = toAddr(0x08000000);
        Address end = toAddr(0x08000000 + 0x5C000); // Search ~370 KB
        
        Address found = memory.findBytes(start, pattern, null, true, monitor);
        int count = 0;
        
        while (found != null && found.compareTo(end) < 0) {
            println("Found CMP r2, #2 at: " + found);
            count++;
            
            // Continue searching
            found = memory.findBytes(found.add(2), pattern, null, true, monitor);
        }
        
        println("Total contactType checks found: " + count);
    }
    
    private void decompileAllFunctions() throws Exception {
        Program program = currentProgram;
        FunctionManager funcMgr = program.getFunctionManager();
        DecompInterface decompiler = new DecompInterface();
        
        try {
            decompiler.openProgram(program);
            
            int funcCount = 0;
            int decompiled = 0;
            
            FunctionIterator functions = funcMgr.getFunctions(true);
            for (Function func : functions) {
                funcCount++;
                
                DecompileResults results = decompiler.decompileFunction(func, 30, monitor);
                if (results.decompileCompleted()) {
                    decompiled++;
                    
                    if (funcCount % 100 == 0) {
                        println("Decompiled " + decompiled + " / " + funcCount + " functions...");
                    }
                }
            }
            
            println("Successfully decompiled " + decompiled + " / " + funcCount + " functions");
            
        } finally {
            decompiler.dispose();
        }
    }
}
"@

$analysisScriptPath = Join-Path $OutputDir "analysis_script.java"
Set-Content -Path $analysisScriptPath -Value $analysisScript -Encoding UTF8
Write-Host "  ✓ Analysis script created" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# STEP 6: Run Ghidra headless analysis
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[6/7] Running Ghidra headless analysis..." -ForegroundColor Cyan
Write-Host "  This will take 10-20 minutes for complete analysis..." -ForegroundColor Yellow

$analyzeHeadless = Join-Path $GhidraInstallDir "support\analyzeHeadless.bat"
$absProjectDir = Resolve-Path $projectDir
$absFirmwarePath = Resolve-Path $FirmwarePath

Write-Host "`n  Ghidra command:" -ForegroundColor Gray
Write-Host "  analyzeHeadless $absProjectDir DMR_Firmware" -ForegroundColor Gray
Write-Host "    -import $absFirmwarePath" -ForegroundColor Gray
Write-Host "    -processor ARM:LE:32:Cortex" -ForegroundColor Gray
Write-Host "    -cspec default" -ForegroundColor Gray
Write-Host "    -scriptPath $OutputDir" -ForegroundColor Gray
Write-Host "    -postScript analysis_script.java" -ForegroundColor Gray

Write-Host "`n════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  STARTING ANALYSIS - Please wait..." -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Yellow

# Run Ghidra analyzeHeadless
& $analyzeHeadless `
    $absProjectDir `
    "DMR_Firmware" `
    -import $absFirmwarePath `
    -processor "ARM:LE:32:Cortex" `
    -cspec "default" `
    -loader "BinaryLoader" `
    -loader-baseAddr "0x08000000" `
    -loader-fileOffset "0x0" `
    -loader-length "0x5C5CC" `
    -scriptPath $OutputDir `
    -postScript "analysis_script.java" `
    -overwrite `
    -deleteProject

Write-Host "`n✓ Ghidra analysis complete!" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# STEP 7: Export decompiled code
# ═══════════════════════════════════════════════════════════════
Write-Host "`n[7/7] Exporting decompiled code..." -ForegroundColor Cyan

$exportScript = @"
// Export all decompiled code to files
// @category Export

import ghidra.program.model.listing.*;
import ghidra.app.decompiler.*;
import java.io.*;

public class ExportDecompiled extends GhidraScript {
    @Override
    public void run() throws Exception {
        println("=== Exporting Decompiled Code ===");
        
        Program program = currentProgram;
        FunctionManager funcMgr = program.getFunctionManager();
        DecompInterface decompiler = new DecompInterface();
        
        File outputDir = new File("$($OutputDir.Replace('\','\\'))");
        File decompiledDir = new File(outputDir, "decompiled_functions");
        decompiledDir.mkdirs();
        
        File allFunctionsFile = new File(outputDir, "all_functions_decompiled.c");
        PrintWriter allWriter = new PrintWriter(allFunctionsFile);
        
        try {
            decompiler.openProgram(program);
            
            int exported = 0;
            FunctionIterator functions = funcMgr.getFunctions(true);
            
            for (Function func : functions) {
                DecompileResults results = decompiler.decompileFunction(func, 30, monitor);
                
                if (results.decompileCompleted()) {
                    String code = results.getDecompiledFunction().getC();
                    
                    // Write to individual file
                    String funcName = func.getName().replaceAll("[^a-zA-Z0-9_]", "_");
                    File funcFile = new File(decompiledDir, funcName + ".c");
                    PrintWriter funcWriter = new PrintWriter(funcFile);
                    funcWriter.println("// Function: " + func.getName());
                    funcWriter.println("// Address: " + func.getEntryPoint());
                    funcWriter.println();
                    funcWriter.println(code);
                    funcWriter.close();
                    
                    // Append to combined file
                    allWriter.println("// ═══════════════════════════════════════");
                    allWriter.println("// " + func.getName() + " @ " + func.getEntryPoint());
                    allWriter.println("// ═══════════════════════════════════════");
                    allWriter.println(code);
                    allWriter.println();
                    allWriter.println();
                    
                    exported++;
                    
                    if (exported % 50 == 0) {
                        println("Exported " + exported + " functions...");
                    }
                }
            }
            
            println("\\nSuccessfully exported " + exported + " functions");
            
        } finally {
            allWriter.close();
            decompiler.dispose();
        }
    }
}
"@

$exportScriptPath = Join-Path $OutputDir "export_script.java"
Set-Content -Path $exportScriptPath -Value $exportScript -Encoding UTF8

Write-Host "  Running export..." -ForegroundColor Cyan

& $analyzeHeadless `
    $absProjectDir `
    "DMR_Firmware" `
    -process "DMR003.UV4T.V022.bin" `
    -scriptPath $OutputDir `
    -postScript "export_script.java" `
    -noanalysis

Write-Host "`n✓ Export complete!" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# FINAL SUMMARY
# ═══════════════════════════════════════════════════════════════
Write-Host "`n════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  DECOMPILATION COMPLETE!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Output files in: $OutputDir" -ForegroundColor Yellow
Write-Host "`nGenerated files:" -ForegroundColor Cyan

if (Test-Path (Join-Path $OutputDir "all_functions_decompiled.c")) {
    $allFunctions = Get-Item (Join-Path $OutputDir "all_functions_decompiled.c")
    Write-Host "  ✓ all_functions_decompiled.c ($([math]::Round($allFunctions.Length/1MB, 2)) MB)" -ForegroundColor Green
}

$decompiledDir = Join-Path $OutputDir "decompiled_functions"
if (Test-Path $decompiledDir) {
    $funcCount = (Get-ChildItem $decompiledDir -Filter "*.c").Count
    Write-Host "  ✓ decompiled_functions\ ($funcCount individual function files)" -ForegroundColor Green
}

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Search all_functions_decompiled.c for 'contactType' references" -ForegroundColor White
Write-Host "  2. Look for functions that check 'param_2 == 2' or similar" -ForegroundColor White
Write-Host "  3. Find group ID extraction (0xFFFFFF initialization/comparison)" -ForegroundColor White
Write-Host "  4. Trace receive path from DMR frame handlers`n" -ForegroundColor White

Write-Host "════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
