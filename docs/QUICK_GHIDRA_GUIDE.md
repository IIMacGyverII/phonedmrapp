# Quick Ghidra GUI Analysis Guide

The automated script needs to run in Ghidra GUI for best results. Here's the quickest path forward:

## Option 1: Open Ghidra GUI (5 minutes manual exploration)

Since automated pattern matching didn't find instructions (binary wasn't fully loaded in headless mode), let's do focused manual analysis:

### Step 1: Open Project
```
C:\ghidra_12.0.3_PUBLIC\ghidra Run.bat
```
- File → Open Project → `DMR_Firmware`
- Double-click `DMR003.UV4T.V022.bin`

### Step 2: Navigate to Untested Locations

**Location 2: 0x080392C9** (Never tested)
1. Press **G** → type `080392C9` → Enter
2. Look at decompiler window (right side)
3. Check if function extracts group ID from frame bytes
4. Look for branches that skip extraction

**Location 4: 0x080524E0** (Never tested)
1. Press **G** → type `080524E0` → Enter
2. Same analysis

**Location 5: 0x080524FA** (Never tested)  
1. Press **G** → type `080524FA` → Enter
2. Same analysis

### What to Look For

**In Assembly (left panel)**:
```assembly
CMP r2, #2           ;  contactType check
B<condition>          ← Branch that might skip code
; [Code that extracts ID]
LDRB r0, [rX, #5]    ← Loading byte 5
LDRB r1, [rX, #6]    ← Loading byte 6
LDRB r2, [rX, #7]    ← Loading byte 7
```

**In Decompiler (right panel)**:
```c
if (contactType == 2) {
    return;  // ← SKIP extraction!
}
// Normal extraction
groupId = (frame[5] << 16) | (frame[6] << 8) | frame[7];
```

### Step 3: Report What You Find

For each location, note:
- Is there a branch right after CMP r2, #2?
- What instruction? (BLS, BGT, BEQ, BNE, CBZ, CBNZ?)
- Does it skip code that looks like 24-bit extraction?
- What does decompiler show?

---

## Option 2: Simple Search in GUI

Instead of going to specific locations:

1. **Search → Memory → Pattern**
2. Enter: `02 2A` (hex for CMP r2, #2)
3. Click "Search All"
4. Visit each result
5. Look for one with extraction code after it

---

## Option 3: Use Call Trees

1. Navigate to Location 1: `08018F26`
2. Right-click function name
3. **References → Show References to**
4. Find what CALLS this function
5. Navigate UP the call tree
6. Find the root receive handler
7. Analyze that instead

---

## Most Likely Bug Location

Based on Grok's analysis of similar firmwares (Tytera MD380, TYT MD-UV380):

**Hypothesis**: Bug is in UART RX interrupt handler or the task that processes decoded frames.

**Search Strategy**:
1. Window → Defined Strings
2. Search for: `decrec_sem` or `encrec_sem` (RTOS semaphore names)
3. Find references to that string
4. Navigate to function using it
5. **That's likely the DMR receive task**
6. Look for contactType checks in that function

---

##Results to Share

When you find something interesting:
1. Take screenshot of decompiler (right panel)
2. Note the address
3. Note what branch instruction is there
4. I'll help create the patch

---

## Estimated Time

- **Focused search**: 15-30 minutes
- **Complete analysis**: 1-2 hours

Much faster than the 13 failed patches we've already tried! The decompiler will make the bug obvious once you find the right function.

**Ready to dive in?** 🔍
