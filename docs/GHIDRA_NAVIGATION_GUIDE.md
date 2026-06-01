# Ghidra Analysis Guide - Finding the DMR Bug

**Date**: March 1, 2026
**Status**: ✅ Firmware successfully analyzed and ready to explore!

## Project Information

**Location**: `C:\Users\Joshua\Documents\android\phonedmrapp\ghidra_decompiled\project\DMR_Firmware`
**Binary**: DMR003.UV4T.V022.bin (378,620 bytes)
**Base Address**: 0x08000000
**Architecture**: ARM Cortex-M Thumb (32-bit, Little Endian)
**Analysis**: Complete with auto-analysis and data type archives

## Opening the Project

### Step 1: Launch Ghidra
```batch
C:\ghidra_12.0.3_PUBLIC\ghidraRun.bat
```

### Step 2: Open Project
1. File > Open Project
2. Navigate to: `C:\Users\Joshua\Documents\android\phonedmrapp\ghidra_decompiled\project`
3. Select project: **DMR_Firmware**
4. Click Open

### Step 3: Open Binary
- In the project window, double-click: **DMR003.UV4T.V022.bin**
- CodeBrowser window will open with the firmware

## Key Addresses (Already Analyzed)

### Location 1: 0x08018F26 ❌ (NOT the bug - Patches 9, 11, 12 failed)
```assembly
08018F26: CMP r2, #2          ; contactType check
08018F28: CBZ r0, +16         ; Skip if r0==0
08018F2A: LDR r3, [r4, #120]
08018F2C: BLS 0x08018F4C      ; Skip if contactType≤2
```
**What we tried**: NOPed both CBZ and BLS → No effect
**Conclusion**: This code is NOT in the DMR receive path

### Location 3: 0x080490E2 ❌ (NOT the bug - Patch 10 failed)
```assembly
080490E2: CMP r2, #2          ; contactType check
080490E6: BGT 0x08049176      ; Branch if contactType > 2
```
**What we tried**: NOPed BGT → No effect
**Conclusion**: This code is also NOT in the DMR receive path

## Navigation Strategy

### 1. Start at Known Locations
Press **G** (Go to Address) and enter these addresses:
- `08018F26` (Location 1)
- `080490E2` (Location 3)

### 2. Find Function Names
- Look at the top of the window for the function name
- Example: `FUN_08018f00` or similar
- Ghidra auto-generates these names

### 3. Trace Callers
**Method A: References**
1. Click on the function name
2. Right-click → **References** → **Find References to [function]**
3. Results show WHERE this function is called FROM
4. Double-click each reference to navigate

**Method B: Function Call Graph**
1. Window → **Function Call Graph**
2. Shows visual tree of who calls whom
3. Navigate UP to find parent functions

**Method C: Function Call Trees**
1. Window → **Function Call Trees**
2. Shows complete hierarchy
3. Can expand/collapse branches

### 4. Find the Root Handler
Keep tracing backwards until you find:
- A function called from an interrupt handler
- A function with "task" or "receive" in decompiled code
- A function that processes DMR frame data
- The TOP-LEVEL receive handler (DMR protocol entry point)

## Search Features

### Search for CMP r2, #2 Pattern
1. Search → **Memory**
2. Format: **Hex**
3. Enter: `02 2A` (little-endian bytes)
4. Click **Search All**
5. Results show ALL contactType comparisons
6. We already found 5, but there may be more!

### Search for 0xFFFFFF Constants
1. Search → **Memory**
2. Format: **Hex**
3. Enter: `FF FF FF`
4. Results show where this value appears
5. Look for CODE sections (not data tables)

### Search for Strings (Debug Messages)
1. Window → **Defined Strings**
2. Look for DMR-related strings like:
   - "DMR"
   - "Group"
   - "Contact"
   - "UART" or "USART"
   - "Frame" or "SYNC"
3. Double-click string → See what code uses it

### Search for Functions by Name Pattern
1. Window → **Symbol Table**
2. Filter: Type in search box
3. Look for functions with relevant names (if any)

## Using the Decompiler

### Enable Decompiler Window
1. Window → **Decompile** (or press Ctrl+E)
2. Appears on right side of CodeBrowser
3. Shows C pseudocode for selected function

### Reading Decompiled Code
When you click on a function, decompiler shows pseudo-C:

**What to look for:**
```c
// contactType checks
if (param_2 == 2) { ... }
if (contactType > 2) { ... }

// Group ID initialization
groupId = 0xFFFFFF;
groupId = 0x00FFFFFF;

// Structure field access
*(int *)(someStruct + 0x78) = something;

// Conditional skips
if (something == 0) return;
if (contactType <= 2) goto LAB_08018F4C;

// Function calls that might process ID
parse_dmr_frame(buffer);
extract_target_id(data, offset);
```

### Decompiler Tips
- **Rename variables**: Right-click variable → Rename
- **Retype variables**: Right-click → Retype Variable
- **Add comments**: Right-click → Set Comment
- **Create structures**: Data Type Manager (if you find patterns)

## Analysis Workflow

### Phase 1: Understand Location 1 Context (30 min)
1. Navigate to `08018F26`
2. Read decompiled function
3. Find what calls this function
4. Trace back 2-3 levels
5. Understand the PURPOSE of this code
6. **Question**: Is this transmit setup? Configuration? Something else?

### Phase 2: Understand Location 3 Context (30 min)
1. Navigate to `080490E2`
2. Read decompiled function
3. Find what calls this function
4. Trace back 2-3 levels
5. Compare with Location 1 - same call tree?

### Phase 3: Find DMR Receive Handler (1-2 hours)
**Strategies:**

**A. Bottom-up from UART**
1. Search for UART register addresses (0x40004xxx or similar)
2. Find UART read functions
3. Trace BACKWARDS to what processes received bytes
4. Find DMR frame parser

**B. Top-down from Interrupts**
1. Look at vector table (addresses 0x08000000-0x080001FF)
2. Find interrupt handlers (addresses stored in table)
3. Look for USART_IRQHandler or similar
4. Trace FORWARD to frame processing

**C. Find Frame Structure**
DMR frame has specific structure:
- Byte 0-1: SYNC pattern
- Byte 2-4: Slot/frame type
- **Byte 5-7: Target ID** (24-bit, this is what we need!)
- Search for code that accesses offset +5, +6, +7

**D. Find 0xFFFFFF Usage**
1. Search for `FF FF FF`
2. Look for code sections (not data tables)
3. Find where it's ASSIGNED to a variable
4. Trace back - why is this value being used?

### Phase 4: Identify Exact Bug (30 min - 1 hour)
Once you find the receive handler:
1. Look for contactType checks
2. Find where group ID is extracted
3. Identify the SKIP or CONDITIONAL that causes 0xFFFFFF
4. Understand WHY contactType=2 triggers this path

### Phase 5: Create Patch (30 min)
1. Identify exact instruction to modify
2. Create firmware_patch14.bin
3. Test with established process

## Common Patterns to Recognize

### uC/OS-III Task Pattern
```c
void DMR_Receive_Task(void *param) {
    while(1) {
        // Wait for semaphore/queue
        OSQPend(...);
        
        // Process frame
        process_dmr_frame(buffer);
    }
}
```

### Frame Parsing Pattern
```c
groupId = (frame[5] << 16) | (frame[6] << 8) | frame [7];
// OR
groupId = frame[5];
groupId = (groupId << 8) | frame[6];
groupId = (groupId << 8) | frame[7];
```

### Bug Pattern (likely)
```c
if (contactType <= 2) {
    // Skip ID extraction!
    groupId = 0xFFFFFF;  // Default/unset value
    return;
}
// Normal ID extraction
groupId = extract_target_id(frame);
```

## Expected Findings

### What Success Looks Like
You should be able to answer:
1. **What is the root DMR receive handler?** (function name/address)
2. **What is Location 1 actually used for?** (transmit? config?)
3. **What is Location 3 actually used for?** (transmit? config?)
4. **Where does group ID extraction happen?** (function/address)
5. **What contactType check causes the skip?** (exact address)
6. **Why does it report 0xFFFFFF?** (default value? uninitialized?)

### Create the Final Patch
Once you identify the bug:
```powershell
# Example: NOP a skip at address 0x0804ABCD
$fw = [IO.File]::ReadAllBytes("app\src\main\assets\DMR003.UV4T.V022.bin")
$offset = 0x4ABCD  # Address - base (0x0804ABCD - 0x08000000)
$fw[$offset] = 0x00
$fw[$offset+1] = 0xBF  # NOP instruction
[IO.File]::WriteAllBytes("firmware_patch14_final.bin", $fw)
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| **G** | Go to address |
| **Ctrl+E** | Open decompiler window |
| **L** | Rename label/variable |
| **;** | Add comment |
| **Ctrl+F** | Find in listing |
| **Alt+Left** | Navigate back |
| **Alt+Right** | Navigate forward |
| **Ctrl+Shift+E** | Edit function signature |
| **Ctrl+L** | Clear highlight |

## Troubleshooting

### Can't Find Function
- Try searching in Symbol Table (Window → Symbol Table)
- Look at address directly (press G)
- Function might not be auto-detected - create manually

### Decompiler Shows Errors
- Some code may not decompile cleanly
- Look at disassembly instead (left side)
- Try "Edit Function" → adjust boundaries

### Too Many Search Results
- Narrow search with more context bytes
- Filter by memory region (RAM vs Flash)
- Look at each result methodically

## Next Steps After Finding Bug

1. **Document findings** in a new markdown file
2. **Create targeted patch** (firmware_patch14.bin)
3. **Test patch** using established DMRDEBUG.bin process
4. **Verify** MON mode shows correct group ID (11904 not 16777215)
5. **Celebrate** if it works! 🎉

## Questions to Ask While Exploring

- Is Location 1 in the same function as Location 3?
- Do they share a common caller?
- What's the call depth to root handler? (2 levels? 5 levels?)
- Are there OTHER contactType checks we missed?
- Does the code use switch/case or if/else?
- Is there a dispatch table or state machine?

## Resources

**Ghidra Documentation**:
- https://ghidra-sre.org/CheatSheet.html
- https://ghidra.re/ (community wiki)

**ARM Reference**:
- ARM Thumb instruction set reference
- Cortex-M3/M4 programming manual

**This Project**:
- [FILE_INDEX.md](FILE_INDEX.md) - All project files
- [SESSION_SUMMARY.md](SESSION_SUMMARY.md) - Previous session details
- [arm_disasm.py](arm_disasm.py) - Our custom disassembler
- [firmware_disasm_output.txt](firmware_disasm_output.txt) - Locations 1-5 dump

---

**Created**: March 1, 2026 - Morning
**Status**: Ghidra project ready, firmware analyzed
**Next**: Open Ghidra GUI and start exploration!
**Goal**: Find actual DMR receive handler and identify why groupId = 0xFFFFFF when contactType=2
