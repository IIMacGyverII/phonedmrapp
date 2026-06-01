# Contact Type Location Analysis

## All 5 ContactType=2 Comparison Locations

### Location 1: 0x08018F26
**Instruction**: `cmp r2, #2`
**File Offset**: 0x18F26
**Bytes**: `02 2A`

**Context Before** (looking for r2 load):
- 0x08018ED8: Potential data manipulation
- Need to trace backwards to find structure access

**Context After**:
- 0x08018F28: `40 B3` - CBZ (conditional branch if zero)
- Likely has conditional logic based on contactType

### Location 2: 0x080392C9
**Instruction**: `cmp r2, #2`
**File Offset**: 0x392C9
**Bytes**: `02 2A`

**Analysis Needed**:
- What function is this in?
- What happens if contactType == 2?

### Location 3: 0x080490E2  
**Instruction**: `cmp r2, #2`
**File Offset**: 0x490E2
**Bytes**: `02 2A`

**Context** (from earlier scan):
- Surrounded by LDR instructions (loading data)
- 0x080490B6: `8B 74` - STRB (store byte)
- 0x080490C2: `1F 6C` - LDR r7
- This looks like data structure manipulation

### Location 4: 0x080524E0
**Instruction**: `cmp r2, #2`  
**File Offset**: 0x524E0
**Bytes**: `02 2A`

**Note**: This and location 5 are only 26 bytes apart (0x1A bytes)
- Might be in same function
- Could be duplicate check or loop

### Location 5: 0x080524FA
**Instruction**: `cmp r2, #2`
**File Offset**: 0x524FA  
**Bytes**: `02 2A`

**Note**: Very close to location 4
- Possible nested conditional
- Or checking multiple structure instances

## Ghidra Tasks for Each Location

For EACH of the 5 locations, document:

1. **Function Name** (if Ghidra identified it)
2. **Function Start Address**
3. **Where r2 is loaded from** (structure offset)
4. **What happens after comparison**:
   - If contactType == 0 (private)
   - If contactType == 1 (group with list)
   - If contactType == 2 (receive all) ← **KEY**
5. **Any function calls nearby** (especially parsing/frame functions)

## Key Questions to Answer

### Question 1: Which location is the RECEIVE path?
- Not all 5 are necessarily in receive code
- Some might be in transmit setup
- Some might be in config/settings

**How to identify receive path**:
- Look for interrupt handler characteristics
- Look for references to RF/radio hardware registers  
- Look for frame buffer processing
- Cross-reference with functions that access 0xFFFFFF

### Question 2: Where is the call data structure?
```c
struct CurrentCall {
    uint8_t contactType;     // r2 loaded from here
    // ... other fields ...
    uint32_t groupId;        // SHOULD contain 11904, actually contains 0xFFFFFF
    // ... other fields ...
};
```

**How to find**:
- Look at LDR instruction that loads r2
- Example: `ldr r2, [r0, #4]` means contactType at offset +4
- Document the base register (r0, r3, sp, etc)
- Trace where base register comes from

### Question 3: Where is group ID extracted from frame?
**Expected pattern**:
```assembly
; Load bytes from DMR frame buffer
ldr r0, [frame_buffer_ptr]
ldrb r1, [r0, #5]          ; byte 5 of frame
ldrb r2, [r0, #6]          ; byte 6 of frame
ldrb r3, [r0, #7]          ; byte 7 of frame

; Combine into 24-bit ID
lsl r2, r2, #8             ; shift byte1 << 8
orr r1, r1, r2             ; combine
lsl r3, r3, #16            ; shift byte2 << 16
orr r1, r1, r3             ; final ID in r1

; Store to CurrentCall.groupId
str r1, [call_struct, #offset]
```

**Search strategy**:
- Look 100-200 instructions BEFORE contactType check
- Look for multiple LDRB with incrementing offsets
- Look for LSL #8 or LSL #16 (bit shifts)
- Look for ORR (logical OR to combine bytes)

### Question 4: Is there a conditional that skips parsing?
**Pattern A - Skip on contactType==2**:
```assembly
ldr r2, [r0, #contactType_offset]
cmp r2, #2
beq skip_parsing           ; ← BUG: If RECEIVE_ALL, skip extraction
bl extract_group_id_from_frame
b continue
skip_parsing:
; groupId field stays 0xFFFFFF (uninitialized)
continue:
```

**Pattern B - Only parse on contactType!=2**:
```assembly
cmp r2, #2
bne do_parsing             ; only parse if NOT receiveall
b skip_parsing
do_parsing:
bl extract_group_id_from_frame
skip_parsing:
```

## Priority Analysis Order

1. **Start with Location 3 (0x080490E2)** - most promising based on surrounding LDR/STR activity
2. Then Location 1 (0x08018F26) - first discovery
3. Then Locations 4 & 5 (0x080524E0/FA) - being close together suggests related logic
4. Then Location 2 (0x080392C9) - if others don't pan out

## Success Criteria

We've found the bug when we can document:
1. ✅ The memory structure holding current call data
2. ✅ The offset of contactType field
3. ✅ The offset of groupId field  
4. ✅ The function that SHOULD extract groupId from DMR frame
5. ✅ The conditional branch that prevents extraction when contactType==2
6. ✅ The exact instruction(s) to patch

Then create firmware_patch9_parser_fix.bin and test.
