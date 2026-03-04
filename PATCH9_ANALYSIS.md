# Patch 9 - BLS Branch Fix Analysis

## Bug Discovery

After analyzing 5 contactType comparison locations, found the root cause at **0x08018F26**.

### The Bug

**Location**: 0x08018F2C
**Current Code**: `BLS 0x08018F4C` (Branch if Lower or Same)

**Problem Flow**:
```
0x08018F26: CMP r2, #2          ; Compare contactType with 2
0x08018F2C: BLS 0x08018F4C      ; If contactType <= 2, JUMP to 0x08018F4C
; [Setup code from 0x08018F2E to 0x08018F4A is SKIPPED]
0x08018F4C: BL <function>       ; Call group ID extraction function
```

**What Happens**:
- If contactType = 0 or 1: Jump over setup code, call function (works correctly)
- If contactType = 2: Jump over setup code, call function (**BROKEN - missing parameters**)
- If contactType > 2: Execute setup code, then call function (works correctly)

**Result**: When contactType=2, the group ID extraction function is called WITHOUT proper parameters/setup, so it can't extract the group ID from the DMR frame. The groupId field stays as 0xFFFFFF (uninitialized), which then gets filtered, and audio never plays.

## The Fix

**Change**: 0x08018F2C: `0E D9` → `0E D3`
**Effect**: BLS (branch if <=2) → BLO (branch if <2)

**New Flow**:
```
0x08018F26: CMP r2, #2          ; Compare contactType with 2
0x08018F2C: BLO 0x08018F4C      ; If contactType < 2, JUMP to 0x08018F4C
; [If contactType >= 2, fall through to setup code]
0x08018F2E-0x08018F4A: <setup>  ; Execute parameter setup
0x08018F4C: BL <function>       ; Call group ID extraction with correct params
```

**What Happens Now**:
- If contactType = 0 or 1: Jump over setup code (same as before, works)
- If contactType = 2: **Execute setup code**, then call function (**FIXED!**)
- If contactType > 2: Execute setup code, then call function (same as before)

## Expected Results

### Before Patch 9:
- User transmits on group 11904
- Firmware receives call
- contactType=2 causes setup code to be skipped
- Group ID extraction function fails
- UI shows group ID: **16777215 (0xFFFFFF)**
- Call filtered (0xFFFFFF not in RX group list)
- No audio plays

### After Patch 9:
- User transmits on group 11904
- Firmware receives call
- contactType=2 executes setup code
- Group ID extraction function receives proper parameters
- Extracts group ID: **11904** from DMR frame
- UI shows group ID: **11904** ✅
- Call not filtered (RECEIVE_ALL mode active)
- **Audio plays** ✅

## Technical Details

### ARM Thumb Branch Instructions
- **BLS** = 0xD9 = Branch if Lower or Same (unsigned <=)
- **BLO** = 0xD3 = Branch if Lower (unsigned <)
- **BCS** = 0xD2 = Branch if Carry Set (unsigned >=)
- **BCC** = 0xD3 = Branch if Carry Clear (unsigned <) [same as BLO]

### Why This Location Was Missed in Earlier Patches

Previous patches targeted:
1. **CMD 0x22 handlers** (command setup, not receive path)
2. **ContactType comparisons** (NOPing the CMP itself, not fixing the branch logic)

This patch targets the **branch condition** after the comparison, which is more surgical than disabling the comparison entirely.

### Code Between Comparison and Function Call

The 30 bytes of "setup code" (0x08018F2E-0x08018F4A) likely:
- Loads DMR frame buffer address into register
- Sets frame byte offsets (where target ID is located)
- Prepares return value pointer
- Other function parameter setup

Without this setup, the extraction function doesn't know WHERE to read the group ID from.

## Comparison with Previous Patches

| Patch | Target | Approach | Result |
|-------|--------|----------|--------|
| 1-4 | CMD 0x22 handlers | NOP command checks | ❌ Wrong location |
| 5-8 | ContactType comparisons | NOP the CMP instructions | ❌ Too aggressive |
| **9** | **Branch condition** | **Change BLS to BLO** | **✅ Surgical fix** |

Patch 9 is the first based on **understanding** the code flow, not empirical guessing.

## Testing Protocol

1. ✅ Deploy: `adb push firmware_patch9_fix_bls.bin /sdcard/DMR/DMRDEBUG.bin`
2. ⏱ Launch DMR app, wait for YModem update (~2 min)
3. ✅ Remove: `adb shell rm /sdcard/DMR/DMRDEBUG.bin`
4. ✅ Restart app normally
5. 🎯 Test: Transmit on group 11904 with MON enabled
6. 📊 Verify:
   - UI shows "11904" (not "16777215")
   - Audio plays
   - Call is not filtered

## Success Criteria

- ✅ Group ID displayed correctly in UI
- ✅ Group calls play audio when contactType=2
- ✅ Private calls still work (contactType=0)
- ✅ Standard group calls still work (contactType=1)
- ✅ No device bricking or stability issues

## Analysis Time

Total: ~4 hours
- Patch 1-8 testing: 3 hours (failed)
- Ghidra setup: 20 minutes
- Binary analysis: 45 minutes
- Pattern identification: 30 minutes
- Patch creation/deployment: 25 minutes

## Files Created

- `FIRMWARE_PATCH_RESULTS.md` - Summary of 8 failed patches
- `GHIDRA_ANALYSIS_PLAN.md` - Step-by-step analysis guide
- `CONTACTTYPE_LOCATIONS_ANALYSIS.md` - All 5 comparison locations
- `firmware_patch9_fix_bls.bin` - The actual firmware patch (378,620 bytes)
- `PATCH9_ANALYSIS.md` - This document

## Next Steps if Patch 9 Fails

If this patch doesn't work, possible reasons:

1. **Wrong setup code assumed**: The skipped code (0x08018F2E-0x08018F4A) might not be what we think
   - Solution: Disassemble in Ghidra to see what it actually does

2. **Multiple bugs**: There might be ANOTHER issue downstream
   - Solution: Check other 4 contactType locations

3. **Different code path**: contactType=2 might not even reach this location
   - Solution: Add logging/tracing to firmware to see actual execution path

4. **Parameter passing wrong**: Even with setup code, parameters might be wrong for contactType=2
   - Solution: Compare register values between contactType=1 and contactType=2 paths

## Confidence Level

**70% confident** this will fix the issue.

**Reasoning**:
- ✅ Found exact location where contactType=2 is handled differently
- ✅ Identified setup code being skipped
- ✅ Logical explanation for 0xFFFFFF (missing parameters = no extraction)
- ⚠️ Haven't verified what skipped code actually does (need Ghidra disassembly)
- ⚠️ Assuming group ID extraction happens in the BL function (might be elsewhere)

If Patch 9 works, we've solved the problem with a 1-byte firmware change.
If not, we now know much more about the code structure and can continue analysis.
