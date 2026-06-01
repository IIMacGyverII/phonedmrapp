# Firmware Patch Testing Results

## Problem Statement
Group calls are filtered despite contactType=2 (RECEIVE_ALL). Private calls work, groups don't.
UI shows group ID as 16777215 (0xFFFFFF) instead of actual group ID (e.g., 11904).

## Patches Tested (All Failed)

### Batch 1: CMD 0x22 Handler Location (0x0800AC76)
**Hypothesis**: Bug in SET_RX_GROUP_LIST command processing

- **Patch 1** (0xAC7A, 0xAC88): NOP conditional branches (BGT, BMI) → ❌ FAILED
- **Patch 2** (0xAC7A): Force BGT unconditional → ❌ FAILED  
- **Patch 3** (0xAC76, 0xAC7A, 0xAC88): NOP CMP and all branches → ❌ FAILED

### Batch 2: Second CMD 0x22 Location (0x0801035A)
- **Patch 4** (0x1035A): NOP CMP r7,#0x22 → ❌ FAILED

### Batch 3: ContactType=2 Checks in Receive Path
**Hypothesis**: Bug in contactType filtering during call receive

Locations with `cmp r2, #2` (contactType comparison):
- 0x08018F26
- 0x080392C9  
- 0x080490E2
- 0x080524E0
- 0x080524FA

- **Patch 5** (0x18F26): NOP single location → ❌ FAILED
- **Patch 6** (0x490E2): NOP single location → ❌ FAILED
- **Patch 7** (0x524E0, 0x524FA): NOP both locations → ❌ FAILED
- **Patch 8a** (0x18F26): Individual test → ❌ FAILED
- **Patch 8b** (0x490E2): Individual test → ❌ FAILED
- **Patch 8c** (ALL 5 locations): Nuclear option → ❌ FAILED

## Key Discovery
UI shows group ID **16777215 (0xFFFFFF)** during receive, not actual group ID (11904).

**This means**:
1. Firmware IS receiving the call (UI shows activity)
2. Firmware reports group ID as 0xFFFFFF to Android app
3. Firmware **doesn't extract actual group ID** from DMR frame when contactType=2
4. It then filters 0xFFFFFF because it's not in RX group list

## Root Cause Hypothesis
Bug is NOT in filtering logic - it's in **DMR frame parsing**.

When contactType=2, the firmware either:
1. Doesn't parse the target ID field from incoming DMR frames
2. Parses it but doesn't populate the group ID field  
3. Leaves group ID as 0xFFFFFF (uninitialized/broadcast)

Then normal filtering rejects 0xFFFFFF because it's not in the RX group list.

## Next Steps
**Deep Ghidra Analysis** to trace:
1. DMR frame receive interrupt handler
2. Frame parsing code that extracts target ID
3. Where contactType affects group ID extraction
4. Why it works for private calls but not group calls

## Testing Method Used
- Deploy via: `adb push firmware_patchX.bin /sdcard/DMR/DMRDEBUG.bin`
- Reboot device
- App loads patched firmware via YModem
- Test with group call (ID 11904)
- Remove: `adb shell rm /sdcard/DMR/DMRDEBUG.bin`
- Zero hardware risk (just delete file, reverts to normal firmware)

## Time Investment
- Ghidra setup: 30 minutes
- Initial analysis: 60 minutes  
- Patch creation/testing (8 patches): 180 minutes
- **Total**: ~4.5 hours
- **Success**: 0/8 patches worked

## Conclusion
Empirical patching exhausted. Need to reverse engineer DMR frame parsing logic to find exact bug location.
