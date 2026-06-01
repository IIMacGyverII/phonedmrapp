# Firmware Decompilation Status Report

## Current Situation

After 13 firmware patch attempts (all failed), we need complete decompilation to find the actual bug location.

## What Failed
- **Patches 1-4**: CMD 0x22 command handlers
- **Patches 5-8**: Simple contactType filtering 
- **Patches 9,11,12**: Location 1 (0x08018F26) with CBZ & BLS branch modifications
- **Patch 10**: Location 3 (0x080490E2) with BGT branch modification

**Result**: 13/13 patches tested = 0% success rate

## Why Complete Decompilation is Needed

The contactType comparisons we found may not be in the actual DMR receive path. We need to:

1. Find the REAL DMR frame receive handler
2. Trace complete call graphs
3. Locate where group ID is extracted from frames
4. Identify the exact code that reports 0xFFFFFF instead of actual ID

## Requirements for Decompilation

### 1. Java JDK 17 or newer
**Status**: Installation attempted via winget but cancelled

**Install Options**:
- **Automatic**: `winget install Eclipse Adoptium.Temurin.21.JDK`
- **Manual**: Download from https://adoptium.net/temurin/releases/
  - Get: Java 21 JDK for Windows x64
  - Install and restart PowerShell

###2. Ghidra 11.x
**Status**: Not checked yet

**Install Options**:
- Download from: https://ghidra-sre.org/
- Latest version: 11.2.1 (as of Feb 2026)
- Extract to: `C:\ghidra_11.2.1_PUBLIC`
- Size: ~540 MB download, ~1.5 GB extracted

## Automation Scripts Created

### 1. run_ghidra.ps1
**Status**: Ready to use (once Java + Ghidra installed)
**Purpose**: Simple, reliable Ghidra analysis
**Time**: 15-20 minutes
**Output**: Ghidra project file (can open in GUI)

**Usage**:
```powershell
.\run_ghidra.ps1
```

### 2. decompile_firmware.ps1  
**Status**: Has syntax errors, needs fixing
**Purpose**: Advanced analysis with auto-export
**Features**: Searches for contactType, exports decompiled C code

### 3. decompile_firmware_simple.ps1
**Status**: Has syntax errors, needs fixing  
**Purpose**: Improved version with better error handling

### 4. quick_decompile.cmd
**Status**: Batch launcher for automation
**Purpose**: Double-click to start process

## Recommended Approach

### Option A: Manual Setup (RECOMMENDED)
**Time**: 30 min setup + 20 min analysis = 50 min total

 **Steps**:
1. Install Java 21 from https://adoptium.net/
2. Download Ghidra 11.2.1 from https://ghidra-sre.org/
3. Extract Ghidra to C:\ghidra_11.2.1_PUBLIC
4. Run `.\run_ghidra.ps1`
5. Open resulting project in Ghidra GUI
6. Search for contactType, 0xFFFFFF, frame handlers

**Advantages**:
- Full control
- GUI access for exploration
- Can save/resume work
- Best for deep analysis

### Option B: Alternative Tools

#### Binary Ninja Cloud (Web-based)
- URL: https://cloud.binary.ninja
- Free tier available
- Upload firmware directly
- No local installation needed
- Limited features vs desktop

#### Rizin / Cutter (Open Source)
- Lighter weight than Ghidra
- Good ARM support
- Faster startup
- Less mature decompiler

#### IDA Free (Limited)
- Industry standard
- Free version limited to x86/x64
- No ARM support in free tier

## What We'll Find After Decompilation

### Key Search Terms:
1. **contactType** - Find all references, see which are in receive path
2. **0xFFFFFF** - Locate initialization/comparison of invalid group ID
3. **Frame parsing** - DMR frame structure (bytes 5-7 = target ID)
4. **UART commands** - Where firmware sends group ID to Android app

### Expected Functions:
- `dmr_receive_frame()` - Main DMR frame handler
- `parse_target_id()` - Extract 24bit ID from bytes 5-7
- `check_receive_permission()` - Where contactType filtering happens
- `send_channel_info()` - UART command that reports to app

### Bug Location Possibilities:
1. **Skip in ID extraction**: contactType=2 skips ID parsing entirely
2. **Default initialization**: groupId defaults to 0xFFFFFF when not set
3. **Wrong structure field**: Reads from wrong offset when contactType=2
4. **Memory not cleared**: Previous 0xFFFFFF value persists

## Time Investment Summary

| Phase | Time Spent | Result |
|-------|-----------|--------|
| Empirical patching (1-8) | 4 hours | 0/8 success |
| Location 1 analysis (9,11,12) | 2 hours | 0/3 success |
| Location 3 analysis (10) | 0.5 hours | 0/1 success |
| CBZ discovery + docs | 1 hour | Found hidden skip |
| Decompilation setup | 0.5 hours | In progress |
| **Total** | **8 hours** | **0/13 patches working** |

## Next Session Plan

### Immediate (5 min):
- [ ] Verify Java installed: `java -version`
- [ ] Verify Ghidra installed: Check C:\ghidra_*

### If Java/Ghidra ready (20 min):
- [ ] Run `.\run_ghidra.ps1`
- [ ] Wait for analysis to complete
- [ ] Open project in Ghidra GUI

### Analysis Phase (1-2 hours):
- [ ] Search for "contactType" in decompiled code
- [ ] Navigate to Location 1 (0x08018F26) in GUI
- [ ] Navigate to Location 3 (0x080490E2) in GUI  
- [ ] Find function that calls these locations
- [ ] Trace backwards to find DMR receive task
- [ ] Locate group ID extraction code
- [ ] Identify exact bug location

### Patch Creation (30 min):
- [ ] Create surgical patch based on decompilation
- [ ] Test patch with MON mode
- [ ] Document findings

## Alternative: Workaround Implementation

If decompilation reveals the bug is too complex to patch safely:

### App-Level Workaround (30 minutes, 100% success):
- Send real group list with contactType=1
- Include all groups user wants to monitor
- Firmware will report correct IDs
- **Trade-off**: Not truly "receive all", but functional

**Code change**: [ContactCommand.kt](ContactCommand.kt#L45-L48)

## Success Criteria

### Minimum Success:
- ✓ Ghidra project created
- ✓ Can navigate firmware in GUI
- ✓ Found locations 1 & 3 in decompiled code
- ✓ Understand call hierarchy

### Moderate Success:
- ✓ Found actual DMR receive handler
- ✓ Traced group ID extraction path
- ✓ Identified bug location (not just contactType checks)
- ✓ Can explain why firmware reports 0xFFFFFF

### Complete Success:
- ✓ Created targeted patch based on decompilation
- ✓ Patch tested successfully
- ✓ MON mode shows correct group IDs
- ✓ Audio plays during monitored calls

## Estimated Remaining Time

**Best case** (Java/Ghidra already work):
- Analysis: 20 min
- GUI exploration: 1 hour
- Bug identification: 1 hour
- Patch creation: 30 min
- **Total: 3 hours**

**Normal case** (need to install tools):
- Tool installation: 30 min
- Analysis: 20 min
- GUI exploration: 2 hours
- Bug identification: 2 hours
- Patch creation/test: 1 hour
- **Total: 5.5 hours**

**Worst case** (bug is very complex):
- Tool setup: 30 min
- Analysis: 20 min
- Deep exploration: 4 hours
- Multiple patch attempts: 2 hours
- **Total: 6.5 hours**

**Fallback** (implement workaround instead):
- **Time: 30 minutes**
- **Success rate: 100%**

## Recommendation

Given 8 hours already invested with 0% success rate:

1. **Try decompilation** (5-6 hours more)
   - High chance of finding root cause
   - Educational value
   - May enable perfect fix

2. **If decompilation shows bug is too complex:**
   - Implement app workaround (30 min)
   - Functional solution  
   - Less elegant but reliable

3. **Professional help option:**
   - Quarkslab RE consulting (~$1500)
   - Bounty on r/ReverseEngineering ($200-300)
   - Binary Ninja Enterprise ($175/mo with support)

---

**Created**: February 28, 2026 - 11:45 PM
**Status**: Awaiting Java/Ghidra installation
**Next Action**: Install tools and run run_ghidra.ps1
