# Deep Ghidra Analysis Plan

## Objective
Find where DMR frame parsing fails to extract target group ID when contactType=2.

## What We Know
1. **UI shows group ID as 16777215 (0xFFFFFF)** instead of actual transmitted group ID (e.g., 11904)
2. **0xFFFFFF = broadcast/invalid ID** (all bits set, DMR standard)
3. **Firmware IS receiving** the call (UI shows activity)
4. **Private calls work** (contactType=0) - so parsing works in that path
5. **Bug is group-call specific** when contactType=2 (RECEIVE_ALL)

## Root Cause Hypothesis
When contactType=2:
- Firmware receives DMR frame over RF ✅
- Firmware **fails to extract target group ID** from frame bytes ❌
- Group ID field stays 0xFFFFFF (uninitialized/default)
- Firmware filters 0xFFFFFF (not in RX group list)
- Audio never plays

## Key Firmware Addresses

### ContactType Comparison Locations (5 total)
Functions that check `if (contactType == 2)`:
- **0x08018F26** - cmp r2, #2
- **0x080392C9** - cmp r2, #2
- **0x080490E2** - cmp r2, #2
- **0x080524E0** - cmp r2, #2
- **0x080524FA** - cmp r2, #2

### CMD 0x22 Handler Locations
SET_RX_GROUP_LIST command dispatcher:
- **0x0800AC76** - command setup logic
- **0x0801035A** - secondary location

### Other Important Offsets
- **0x08000000** - firmware base address
- **0x08036528** - "timer10ms" string (address validation)

## Ghidra Analysis Steps

### Step 1: Find Current Call Data Structure (30 min)
**Goal**: Locate the RAM structure that holds current call information

1. Open Ghidra project (should already have firmware loaded at 0x08000000)
2. Navigate to **contactType comparison at 0x08018F26**
3. Look at surrounding code - find where contactType value is loaded from
   - Look for: `ldr r2, [r0, #offset]` or similar
   - The address `r0 + offset` points to contactType field
4. The same structure probably has fields like:
   ```c
   struct CurrentCall {
       uint8_t contactType;     // offset ?? (contains 2 when MON enabled)
       uint8_t channelType;     // offset ??
       uint32_t groupId;        // offset ?? (contains 0xFFFFFF - THIS IS THE BUG)
       uint32_t privateId;      // offset ??
       uint8_t colorCode;       // offset ??
       ...
   }
   ```
5. Document the structure layout and base address

### Step 2: Find Where 0xFFFFFF is Initialized (20 min)
**Goal**: Find where groupId field is set to 0xFFFFFF (default/broadcast)

1. Search for code that writes 0xFFFF or 0xFFFFFF
   - Instruction patterns:
     - `mvn r0, #0` (move NOT 0 = 0xFFFFFFFF)
     - `movw r0, #0xFFFF; movt r0, #0xFF` (load 24-bit 0xFFFFFF)
     - `mov r0, #0xFF; orr r0, r0, lsl #8; orr r0, r0, lsl #8` (shift-or pattern)
2. Find stores to groupId field offset in CurrentCall structure
3. This might be in initialization function (called at startup or before receive)

### Step 3: Find DMR Frame Parser (60-90 min) **← CRITICAL**
**Goal**: Locate code that extracts target ID from received DMR frame bytes

**DMR Frame Structure** (for reference):
```
DMR frame has target ID in specific bytes:
- Private call: Target ID in bytes 5-7 of CACH header
- Group call: Target ID in bits of EMB LC (Embedded Link Control)
- Format: 24-bit value (byte2<<16 | byte1<<8 | byte0)
```

**Search Strategy**:
1. Look for byte-load sequences near contactType checks:
   ```assembly
   ldrb r0, [r3, #5]    ; load byte 5
   ldrb r1, [r3, #6]    ; load byte 6
   ldrb r2, [r3, #7]    ; load byte 7
   lsl r1, r1, #8       ; shift byte1 << 8
   orr r0, r0, r1       ; combine
   lsl r2, r2, #16      ; shift byte2 << 16
   orr r0, r0, r2       ; final 24-bit ID
   ```

2. Search for patterns that might indicate frame buffer access:
   - Multiple LDRB (load byte) instructions with incrementing offsets
   - LSL (left shift) by 8 or 16
   - ORR (logical OR) to combine bytes

3. **Trace backwards from contactType checks**:
   - Start at 0x08018F26 (first contactType check)
   - Look 50-100 instructions BEFORE the comparison
   - Find where call data is being set up
   - Look for function calls that might do the parsing

4. **Look for conditional skipping**:
   - Find branch around parsing code based on contactType
   - Example:
     ```assembly
     cmp r2, #2           ; check if contactType == 2
     beq skip_parse       ; if RECEIVE_ALL, skip parsing ← BUG HERE
     bl extract_target_id ; normal path: extract ID
     skip_parse:
     ```

### Step 4: Compare with Private Call Path (30 min)
**Goal**: Understand why private calls work but group calls don't

1. Find private call handling (contactType=0)
   - Should have similar frame parsing
   - But it WORKS - so this is the reference implementation
2. Compare group call path (contactType=1 or 2)
   - Look for differences in code paths
   - Identify missing calls or skipped code

### Step 5: Identify the Exact Bug (30 min)
**Possible Bug Patterns**:

**Pattern A: Missing Function Call**
```assembly
cmp r2, #0              ; if contactType == 0 (private)
bne check_group
bl extract_private_id   ; ← this works
b done
check_group:
cmp r2, #1              ; if contactType == 1 (group with list)
bne done                ; ← BUG: contactType==2 falls through without parsing
bl extract_group_id     ; ← this only runs for contactType==1
done:
```
**Fix**: Change `bne done` to `beq skip` so contactType==2 also calls extract_group_id

**Pattern B: Wrong Condition**
```assembly
cmp r2, #1              ; check if contactType == 1
beq extract_group_id    ; only extract if exact match
                        ; ← BUG: contactType==2 skipped
```
**Fix**: Change to `cmp r2, #0; beq skip_group` (skip only private)

**Pattern C: Early Return**
```assembly
cmp r2, #2              ; check if contactType == 2
beq early_return        ; ← BUG: RECEIVE_ALL exits before parsing
bl extract_group_id
early_return:
```
**Fix**: NOP the `beq early_return` branch

### Step 6: Create Surgical Patch (15 min)
Once bug is identified:

1. Determine exact instruction(s) to modify
2. Calculate file offset: `file_offset = address - 0x08000000`
3. Create patch:
   ```powershell
   $fw = "app\src\main\assets\DMR003.UV4T.V022.bin"
   $bytes = [System.IO.File]::ReadAllBytes($fw)
   
   # Example: NOP a bad branch at 0x08018F30
   $offset = 0x18F30
   $bytes[$offset] = 0x00
   $bytes[$offset+1] = 0xBF
   
   [System.IO.File]::WriteAllBytes("firmware_patch9_parser_fix.bin", $bytes)
   ```
4. Test via DMRDEBUG.bin

## Ghidra Commands Reference

### Navigation
- **G** - Go to address (e.g., "08018F26")
- **Ctrl+F** - Search for bytes/text
- **Ctrl+Shift+E** - Search for specific values
- **F** - Follow pointer/reference
- **←** - Go back in navigation history

### Analysis  
- **D** - Disassemble at cursor
- **L** - Add label
- **;** - Add comment
- **Right-click → References → Show References to Address** - Find all calls to function
- **Right-click → References → Show References from Address** - Find what function calls

### Views
- **Window → Defined Strings** - List all strings
- **Window → Function Call Trees** - Show call hierarchy
- **Window → Data Type Manager** - Create struct definitio

ns

## Expected Time Investment
- Step 1: 30 minutes (find call data structure)
- Step 2: 20 minutes (find initialization)
- Step 3: 60-90 minutes (find parser - hardest part)
- Step 4: 30 minutes (compare with working path)
- Step 5: 30 minutes (identify exact bug)
- Step 6: 15 minutes (create patch)

**Total**: 3-4 hours

**Success Probability**: 50-60%
- **If successful**: Group calls work with contactType=2, UI shows correct group ID
- **If unsuccessful**: May need IDA Pro, or accept Option 2 workaround

## Fallback Plans
If parser can't be found after 4 hours:
1. **Option 2 Workaround**: Modify Android app to populate RX group list with all codeplug groups
2. **External Tool**: Try IDA Pro disassembler (better ARM Thumb support)
3. **Hardware Analysis**: Logic analyzer on UART to see raw DMR frames
4. **Accept Limitation**: Document as firmware bug requiring source code
