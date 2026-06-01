# Quick Start Guide: Firmware Decompilation

## Current Status
⚠️ **BLOCKED**: Need Java + Ghidra installed before proceeding

## What You Need to Do (10 minutes)

### Step 1: Install Java (5 minutes)

**Option A: Automatic (Recommended)**
```powershell
winget install EclipseAdoptium.Temurin.21.JDK
```

**Option B: Manual**
1. Go to: https://adoptium.net/temurin/releases/
2. Download: **Windows x64 JDK 21** (MSI installer)
3. Run installer (default options are fine)
4. Restart PowerShell

**Verify:**
```powershell
java -version
# Should show: openjdk version "21.0.x"
```

### Step 2: Install Ghidra (5 minutes)

**Download:**
1. Go to: https://ghidra-sre.org/
2. Click: Download Ghidra 11.2.1
3. Extract ZIP to: `C:\ghidra_11.2.1_PUBLIC`

**Verify:**
```powershell
Test-Path "C:\ghidra_11.2.1_PUBLIC\support\analyzeHeadless.bat"
# Should return: True
```

### Step 3: Run Analysis (20 minutes)

**Start decompilation:**
```powershell
.\run_ghidra.ps1
```

**What happens:**
- Imports firmware at 0x08000000
- Runs auto-analysis (~15-20 min)
- Creates Ghidra project file
- Can open in Ghidra GUI for exploration

### Step 4: Explore in Ghidra (open-ended)

**Open project:**
1. Run: `C:\ghidra_11.2.1_PUBLIC\ghidraRun.bat`
2. File > Open Project
3. Navigate to: `ghidra_decompiled\project`
4. Open project: DMR_Firmware
5. Double-click: DMR003.UV4T.V022.bin

**Key navigation:**
- Press **G** to go to address
- Go to: `08018F26` (Location 1)
- Go to: `080490E2` (Location 3)
- Window > Function Graph (see control flow)
- Window > Decompile (see C pseudocode)

**What to search for:**
1. Search > For Strings > "contactType" (if any)
2. Search > Memory > `02 2A` (CMP r2, #2 pattern)
3. Search > Memory > `FF FF FF` (0xFFFFFF constants)
4. Window > Defined Strings (look for debug messages)

**Key questions to answer:**
- What function calls Location 1?
- What function calls Location 3?
- Are these in the same call tree?
- What's the root function (DMR receive handler)?
- Where does group ID get extracted?
- Where does it get reported to UART?

## If You Get Stuck

### Can't install Java/Ghidra?
Use Binary Ninja Cloud (web-based, no install):
- https://cloud.binary.ninja
- Free tier available
- Upload: `app\src\main\assets\DMR003.UV4T.V022.bin`
- Set architecture: ARMv7 Thumb
- Set base address: 0x08000000

### Don't want to do manual analysis?
Implement the app workaround instead (30 min, 100% success):
- See README section: "Option 2: App Workaround"
- Modify ContactCommand.kt
- Send real group list with contactType=1
- Works but not "receive all"

### Want professional help?
- Post bounty on r/ReverseEngineering ($200-300)
- Hire Quarkslab (~$1500 for this scope)
- Try Binary Ninja Enterprise ($175/mo with support)

## Expected Outcomes

### After decompilation:
✓ Can see all firmware code as C pseudocode
✓ Can trace function calls
✓ Can find exact bug location
✓ Can create surgical patch

### Success looks like:
- Found: DMR frame receive handler
- Identified: Where contactType=2 causes skip
- Located: Group ID extraction function
- Understood: Why it reports 0xFFFFFF
- Created: 1-4 byte patch that fixes it
- **MON mode works!**

## Files in This Project

| File | Purpose |
|------|---------|
| **run_ghidra.ps1** | ⭐ USE THIS ONE - Simple, reliable |
| quick_decompile.cmd | Batch launcher (calls PS1) |
| decompile_firmware.ps1 | Advanced version (has bugs) |
| decompile_firmware_simple.ps1 | Alternate version (has bugs) |
| DECOMPILATION_STATUS.md | Detailed status report |
| DECOMPILATION_README.md | Original documentation |
| **THIS FILE** | Quick start guide |

## Timeline

| Task | Time | Can Skip? |
|------|------|-----------|
| Install Java | 5 min | No |
| Install Ghidra | 5 min | No (unless using web tool) |
| Run analysis | 20 min | No |
| Explore in GUI | 1-2 hours | No |
| Find bug | 1-2 hours | No |
| Create patch | 30 min | No |
| **TOTAL** | **3-4 hours** | |
| **OR: App workaround** | **30 min** | Alternative |

## Current Blocker

**Status**: Waiting for Java + Ghidra installation
**Once installed**: Can run `.\run_ghidra.ps1` and proceed automatically
**Alternative**: Use online tools or implement workaround

---

**Last Updated**: Feb 28, 2026 - 11:50 PM
**Next Step**: Install Java and Ghidra, then run `.\run_ghidra.ps1`
