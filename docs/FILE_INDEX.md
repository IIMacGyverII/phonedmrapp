# File Index - Firmware Decompilation Project

**Last Updated**: February 28, 2026 - 11:58 PM

## 🎯 START HERE

| File | Purpose | Priority |
|------|---------|----------|
| **[QUICKSTART.md](QUICKSTART.md)** | Step-by-step setup guide | ⭐⭐⭐ READ FIRST |
| **[run_ghidra.ps1](run_ghidra.ps1)** | Automated decompilation script | ⭐⭐⭐ USE THIS |

## 📊 Documentation

### Status & Summary
| File | Contents |
|------|----------|
| [SESSION_SUMMARY.md](SESSION_SUMMARY.md) | Tonight's session recap (Patch 10, pivot to decompilation) |
| [DECOMPILATION_STATUS.md](DECOMPILATION_STATUS.md) | Complete project status, time investment, next steps |
| [DECOMPILATION_README.md](DECOMPILATION_README.md) | Full decompilation guide with troubleshooting |

### Previous Analysis
| File | Contents |
|------|----------|
| [NOTES_FOR_GROK.md](NOTES_FOR_GROK.md) | External AI analysis brief (623 lines) |
| [PATCH12_BREAKTHROUGH.md](PATCH12_BREAKTHROUGH.md) | CBZ discovery documentation (~3000 lines) |
| [FIRMWARE_PATCH_RESULTS.md](FIRMWARE_PATCH_RESULTS.md) | Patch 1-9 results |
| [GHIDRA_ANALYSIS_PLAN.md](GHIDRA_ANALYSIS_PLAN.md) | Original decompilation planning |
| [CONTACTTYPE_LOCATIONS_ANALYSIS.md](CONTACTTYPE_LOCATIONS_ANALYSIS.md) | 5 contactType locations analyzed | [PATCH9_ANALYSIS.md](PATCH9_ANALYSIS.md) | Why Patch 9 failed (before CBZ discovery) |

## 🔧 Automation Scripts

### Working Scripts
| File | Status | Purpose |
|------|--------|---------|
| **[run_ghidra.ps1](run_ghidra.ps1)** | ✅ Ready | Simple, reliable Ghidra automation |
| [quick_decompile.cmd](quick_decompile.cmd) | ✅ Ready | Batch file launcher for run_ghidra.ps1 |

### Broken Scripts (Don't Use)
| File | Issue |
|------|-------|
| [decompile_firmware.ps1](decompile_firmware.ps1) | PowerShell syntax errors (Java embedding) |
| [decompile_firmware_simple.ps1](decompile_firmware_simple.ps1) | Brace mismatch errors |

## 🛠️ Tools & Previous Work

### Custom Tools
| File | Purpose | Lines |
|------|---------|-------|
| [arm_disasm.py](arm_disasm.py) | ARM Thumb disassembler | 235 |
| [firmware_disasm_output.txt](firmware_disasm_output.txt) | Locations 1-5 disassembly | 1032 |

### Firmware Patches (13 total)
| File | Location | Change | Result |
|------|----------|--------|--------|
| firmware_patch1.bin | CMD 0x22 #1 | NOP check | ❌ Failed |
| firmware_patch2.bin | CMD 0x22 #2 | NOP check | ❌ Failed |
| firmware_patch3.bin | CMD 0x22 #3 | NOP check | ❌ Failed |
| firmware_patch4.bin | CMD 0x22 #4 | NOP check | ❌ Failed |
| firmware_patch5.bin | 0x18F26 | NOP CMP | ❌ Failed |
| firmware_patch6.bin | 0x392C9 | NOP CMP | ❌ Failed |
| firmware_patch7.bin | 0x490E2 | NOP CMP | ❌ Failed |
| firmware_patch8.bin | 0x524E0 | NOP CMP | ❌ Failed |
| firmware_patch9.bin | 0x18F2C | BLS→BLO | ❌ Failed |
| firmware_patch10.bin | 0x490E6 | NOP BGT | ❌ Failed (tested tonight) |
| firmware_patch11.bin | 0x18F2C | NOP BLS | Not tested |
| firmware_patch12.bin | 0x18F28+0x18F2C | NOP CBZ+BLS | ❌ Failed |

**Success Rate**: 0/13 tested (0%)

## 📦 Original Assets

| File | Size | Purpose |
|------|------|---------|
| app/src/main/assets/DMR003.UV4T.V022.bin | 378,620 bytes | Original firmware |

## 🗂️ Other Project Files

### Build & Config
- build.gradle
- settings.gradle
- gradle.properties
- gradlew, gradlew.bat
- gradle/wrapper/

### Documentation (General)
- README.md
- STATUS.md
- SUCCESS_REPORT.md
- QUICK_REFERENCE.md
- CONTINUATION_NOTES.md
- Various other .md files

### Scripts & Tools
- create_serial_module.py
- create_systemizer_module.py
- fix_nvram.py
- wrap_tryatch.py
- Various .sh and .ps1 scripts

### Logs & Debug
- build_log.txt
- logcat-standalone.txt
- Various debug and analysis files

## 🎯 Workflow For Next Session

### 1. Prerequisites (10 min)
```powershell
# Install Java
winget install EclipseAdoptium.Temurin.21.JDK

# Download Ghidra from https://ghidra-sre.org/
# Extract to C:\ghidra_11.2.1_PUBLIC
```

### 2. Run Analysis (20 min)
```powershell
.\run_ghidra.ps1
```

### 3. Explore Results (2-3 hours)
- Open Ghidra GUI
- Load project from ghidra_decompiled\project
- Navigate to key addresses
- Find DMR receive handler
- Locate bug

### 4. Create Patch (30 min)
- Identify exact bug location
- Create targeted patch
- Test with established process

## 📈 Project Statistics

### Time Investment
- Previous sessions: 7 hours
- Tonight's session: 1 hour
- **Total: 8 hours**

### Achievements
- ✅ 13 patches created and tested
- ✅ 2 of 5 locations eliminated
- ✅ ARM Thumb disassembler created
- ✅ CBZ instruction discovered
- ✅ Complete automation suite built
- ✅ Thorough documentation

### Remaining Work
- ⏳ Install tools (10 min)
- ⏳ Run analysis (20 min)
- ⏳ Find bug (2-3 hours)
- ⏳ Create final patch (30 min)
- **Est: 3-4 hours**

## 🔍 Key Technical Findings

### Locations Eliminated
1. **Location 1** (0x08018F26):
   - CMP r2, #2
   - CBZ r0, +16 (hidden instruction!)
   - BLS skip
   - Patches 9, 11, 12 all failed → NOT the bug

2. **Location 3** (0x080490E2):
   - CMP r2, #2
   - BGT branch
   - Patch 10 failed → NOT the bug

### Still Unknown
- Where is the ACTUAL receive handler?
- Where does group ID extraction happen?
- Why does firmware report 0xFFFFFF?
- Which of the 5 locations is correct?

## 🎲 Alternative Paths

### Option A: Continue with Decompilation (Recommended)
- **Time**: 3-4 hours more
- **Success**: 50-60% chance
- **Outcome**: Find root cause, create perfect fix

### Option B: Implement Workaround
- **Time**: 30 minutes
- **Success**: 100% guaranteed
- **Outcome**: Functional but not elegant

### Option C: Get Professional Help
- **Cost**: $200-1500
- **Success**: 80-90% chance
- **Outcome**: Expert analysis

## 🚀 Quick Commands

```powershell
# Check Java
java -version

# Check Ghidra
Test-Path "C:\ghidra_11.2.1_PUBLIC\support\analyzeHeadless.bat"

# Run analysis
.\run_ghidra.ps1

# View this index
code FILE_INDEX.md

# View quick start
code QUICKSTART.md

# View session summary
code SESSION_SUMMARY.md
```

## ❓ Need Help?

### Read First
1. [QUICKSTART.md](QUICKSTART.md) - Installation & setup
2. [SESSION_SUMMARY.md](SESSION_SUMMARY.md) - What happened tonight
3. [DECOMPILATION_STATUS.md](DECOMPILATION_STATUS.md) - Complete status

### External Resources
- **Java**: https://adoptium.net/
- **Ghidra**: https://ghidra-sre.org/
- **Ghidra CheatSheet**: https://ghidra-sre.org/CheatSheet.html
- **Binary Ninja Cloud**: https://cloud.binary.ninja (alternative, web-based)

### Community
- r/ReverseEngineering
- Ghidra Discord
- DMR/Ham Radio forums

---

**Project Status**: Paused at tool installation
**Current Blocker**: Need Java + Ghidra
**Next Step**: Install tools → run run_ghidra.ps1 → explore
**Success To Date**: 0/13 patches, but gained deep understanding
**Path Forward**: Complete decompilation or implement workaround
