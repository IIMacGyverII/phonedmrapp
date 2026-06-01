# Automated Firmware Decompilation

## Quick Start

**Just double-click:** `quick_decompile.cmd`

That's it! The script will:
- ✓ Auto-install Java 21 if needed
- ✓ Auto-download Ghidra 11.2.1 if needed (~540 MB)
- ✓ Import firmware with correct ARM Cortex-M settings
- ✓ Run complete analysis (10-20 minutes)
- ✓ Export all decompiled C code

## Output

After completion, check `ghidra_decompiled/` folder:

- **all_functions_decompiled.c** - All functions in one file
- **decompiled_functions/** - Individual function files
- Every function decompiled to C pseudocode

## What to Search For

Once decompiled, search for:

1. **contactType checks**: Functions with `param_2 == 2` or `param_2 > 2`
2. **0xFFFFFF constants**: Group ID initialization or comparison
3. **DMR frame processing**: Functions with byte array access patterns
4. **Group ID extraction**: 24-bit value assembly from 3 bytes

## Manual Options

**PowerShell script:**
```powershell
.\decompile_firmware.ps1
```

**With custom paths:**
```powershell
.\decompile_firmware.ps1 -FirmwarePath "path\to\firmware.bin" -OutputDir "my_output"
```

**Skip auto-install (if you have Ghidra already):**
```powershell
.\decompile_firmware.ps1 -GhidraInstallDir "C:\your\ghidra\path" -SkipInstall
```

## Requirements

- **Windows 10/11** (or Linux/Mac with modifications)
- **~2 GB disk space** (Ghidra + Java + output)
- **Internet connection** (for downloads if needed)
- **15-25 minutes** (first run with downloads)

## After Decompilation

Use VS Code or any editor to search through `all_functions_decompiled.c`:

1. Search for "contactType" references
2. Look for functions near addresses we've already analyzed:
   - 0x08018F26 (Location 1)
   - 0x080490E2 (Location 3)
3. Find the actual DMR receive handler
4. Trace complete call path for group ID extraction

## Troubleshooting

**Java install fails:**
- Manually download from: https://adoptium.net/temurin/releases/
- Install Java 17 or newer
- Re-run script

**Ghidra download slow:**
- Direct link: https://github.com/NationalSecurityAgency/ghidra/releases
- Extract to C:\ghidra_11.2.1_PUBLIC
- Re-run script

**Analysis crashes:**
- Check RAM (needs ~4 GB free)
- Close other applications
- Re-run script (it will resume)

## Success Criteria

After decompilation completes:
- ✓ `all_functions_decompiled.c` exists (several MB)
- ✓ `decompiled_functions/` has hundreds of .c files
- ✓ Can search for "contactType" and find references
- ✓ Can navigate to specific addresses (0x08018F26, etc.)

Now you have the complete firmware in readable C pseudocode! 🎉
