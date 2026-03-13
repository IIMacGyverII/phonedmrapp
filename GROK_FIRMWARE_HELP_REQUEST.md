# Firmware Decompilation Help Request for Grok

**Date**: March 5, 2026  
**Project**: DMRModHooks - Ulefone Armor 26 Ultra DMR Radio Firmware Reverse Engineering  
**Status**: Need complete firmware decompilation strategy

---

## 🎯 What We're Trying to Achieve

Fix a firmware bug where **DMR group calls in "All" mode (contactType=2) report groupId as 0xFFFFFF instead of the actual group ID**. This causes Android app to filter valid calls, resulting in no audio playback.

---

## 📡 Firmware Details

### File Information
- **Filename**: `DMR003.UV4T.V022.bin`
- **Size**: 378,620 bytes (369.75 KB)
- **Format**: Raw binary (no encryption, no compression)
- **Entropy**: 5.4 bits/byte (confirms plaintext)
- **MD5**: `4426035392262CA54583C230C9E268E0`

### Architecture & Platform
- **CPU**: ARM Cortex-M (exact model unknown, likely STM32 or GD32)
- **Instruction Set**: ARM Thumb (16-bit instructions)
- **Endianness**: Little-endian
- **Base Address**: 0x08000000 (standard ARM Cortex-M flash base)
- **RTOS**: uC/OS-III (Micrium commercial real-time operating system)

### Communication Protocol
- **Interface**: UART serial (`/dev/ttyS0` on Android)
- **Baud Rate**: 57600
- **Protocol**: Custom binary protocol with structured packets
- **Packet Format**: 
  ```
  0x68 [length] [CMD byte] [body bytes] [checksum] 0x16
  ```

### Known Strings in Firmware
We've identified these task names and system components:
- `uC/OS-III Idle Task`
- `uC/OS-III ISR Queue Task`
- `uC/OS-III Tick Task`
- `uC/OS-III Stat Task`
- `uC/OS-III Timer Task`
- `timer10ms` - Custom 10ms timer task
- `task init` - Initialization task
- `cpchanscan` - Channel scanning task
- Semaphores: `encrec_sem`, `decrec_sem`, `play_sem`
- Error handling: Full errno implementation (171+ POSIX error codes)

---

## 🐛 The Specific Bug

### What Happens
When Android sends `CMD 0x22 (SET_RX_GROUP_LIST)` with `contactType=2`:
```
Outgoing packet:
  contactType: 2 (RECEIVE_ALL mode)
  txContact: 16777215 (0xFFFFFF - promiscuous)
  
Incoming DMR call from group 11904:
  CMD 0x2B response shows:
  groupId: 16777215 (0xFFFFFF)  ← WRONG! Should be 11904
  
Result: Android filters call as invalid → No audio plays
```

### What We Think is Happening
Firmware has code that checks `contactType` value and conditionally extracts group ID from DMR frame:

**Expected pattern** (pseudocode):
```c
if (contactType == 0) {
    // PERSON mode - extract DMR ID
    dmrId = (frame[5] << 16) | (frame[6] << 8) | frame[7];
} else if (contactType == 1) {
    // GROUP mode - extract group ID
    groupId = (frame[5] << 16) | (frame[6] << 8) | frame[7];
} else if (contactType == 2) {
    // ALL mode - SKIP extraction (BUG!)
    groupId = 0xFFFFFF;  // Uninitialized or default
}
```

**Expected ARM Thumb assembly**:
```assembly
cmp r2, #2              ; Compare contactType with 2
beq skip_extraction     ; If equal, branch past extraction
bls skip_extraction     ; OR: If <= 2, branch past

; Group ID extraction code (we want this to execute)
ldrb r0, [r3, #5]       ; Load byte 5 (group ID high)
ldrb r1, [r3, #6]       ; Load byte 6 (group ID mid)
ldrb r2, [r3, #7]       ; Load byte 7 (group ID low)
lsl  r0, #16            ; Shift high byte
lsl  r1, #8             ; Shift mid byte
orr  r0, r1             ; Combine
orr  r0, r2             ; Final 24-bit group ID

skip_extraction:
; Continue with groupId (either extracted or 0xFFFFFF)
```

---

## 🔬 What We've Tried (13 Failed Patches + 6 Ghidra Investigations)

### Patch Attempts
1. **Patches 1-4**: NOPed CMD 0x22 handler branches → Failed (wrong code path)
2. **Patches 5-8**: NOPed contactType checks → Failed (doesn't add extraction logic)
3. **Patch 9**: Changed BLS to BLO at 0x08018F2C → Failed
4. **Patches 10-11**: NOPed BLS branch → Failed (CBZ still skips)
5. **Patch 12**: NOPed both CBZ+BLS at 0x08018F26 → Failed (most comprehensive attempt)
6. **Patch 13**: NOPed BGT at Location 3 → Failed

### Ghidra Analysis Attempts
Imported firmware into Ghidra 12.0.3 with:
- Language: ARM Cortex (Thumb mode)
- Base address: 0x08000000
- All analyzers enabled

**Locations investigated**:
1. **0x08018F26** - Has `cmp r2, #2` + CBZ + BLS pattern, confirmed real code
   - Problem: Branch targets jump to undefined regions (data?)
   - Patch 12 NOPed both branches → Still failed
   
2. **0x080392C9** - Found `02 2A` bytes → Ghidra shows as data table (bit masks)

3. **0x080524E0** - Found `02 2A` bytes → Ghidra shows "Bad instruction" warnings

4. **0x08052CEA** - Branch target → Undefined bytes, malformed region

5. **0x08034CAE** - LDRB search result → Ghidra shows as `float 40357.492` (data)

6. **0x08034DC2** - LDRB search result → Ghidra shows as `float -6.4057227E+23` (data)

### Why Ghidra Auto-Analysis is Struggling
- No debug symbols or DWARF info
- No function names or entry points documented
- Code and data intermixed (lookup tables near functions)
- Compiler optimizations obscure patterns
- Many regions show as "??" (undisassembled) or floats (false data interpretation)

---

## 🆘 Questions for Grok

### 1. Complete Decompilation Strategy
**How do we get a COMPLETE decompilation of this ARM Cortex-M firmware binary?**

Specific needs:
- Identify ALL functions (not just what auto-analysis finds)
- Distinguish code from data tables accurately
- Find the CMD 0x2B (QUERY_DIGITAL_AUDIO_RECEIVE_INFO) handler function
- Trace control flow from UART message reception → DMR frame processing → group ID extraction

Tools we have:
- Ghidra 12.0.3 (free, open source)
- Binary Ninja Personal (if needed)
- IDA Pro evaluation (if needed)
- Custom Python scripts

### 2. uC/OS-III Signature Application
**Can we use uC/OS-III FLIRT signatures or known patterns to help Ghidra identify functions?**

Since we know it's uC/OS-III:
- Standard task creation patterns (`OSTaskCreate()`)
- Semaphore patterns (`OSSemPost()`, `OSSemPend()`)
- Queue patterns
- Timer patterns

Where can we get these signatures? Can we create them?

### 3. UART Command Handler Discovery
**How do we find the dispatch table for UART command handlers?**

We know there's a command dispatcher that routes:
- CMD 0x21 (READ_RX_GROUP_LIST)
- CMD 0x22 (SET_RX_GROUP_LIST)
- CMD 0x2B (QUERY_DIGITAL_AUDIO_RECEIVE_INFO) ← This is what we need
- CMD 0x3F (TEST_BIT_ERROR_RATE)
- And 20+ other commands

Likely implemented as:
- Switch statement with jump table
- Function pointer array indexed by CMD byte
- Binary search tree

How do we locate this in Ghidra?

### 4. Byte Pattern Search Limitations
**Why are our byte pattern searches (e.g., `02 2A` for `cmp r2, #2`) finding so many false positives?**

Findings:
- 27 occurrences of `FF FF FF` (most in data regions)
- 12 occurrences of LDRB #5/#6/#7 patterns (all show as data in Ghidra)
- 5+ occurrences of `02 2A` (mix of data and code)

Is there a better search strategy:
- Context-aware search (only in code regions)?
- Cross-reference analysis from known entry points?
- String reference tracing (find "receive", "dmr", "group")?

### 5. DMR Frame Buffer Location
**How do we find where the firmware stores incoming DMR frame data?**

We know from reverse engineering Android app that:
- DMR frame is minimum 12 bytes
- Byte 0: Frame type
- Bytes 1-4: Various flags/counters
- **Bytes 5-7: Target ID (what we need!)**
- Bytes 8-11: Source ID

The firmware must store this somewhere in RAM before processing. Can we:
- Search for buffer allocation patterns?
- Find memcpy() or DMA operations that populate this?
- Trace from UART RX interrupt handler?

### 6. Alternative Analysis Approaches

**Option A: Dynamic Analysis**
- Can we use OpenOCD + JTAG to:
  - Set breakpoints at suspected locations?
  - Trace execution during actual DMR call reception?
  - Dump memory regions to find frame buffer?
  
- Requirements: Physical JTAG access to DMR module PCB

**Option B: Firmware Comparison**
- Find working DMR radio firmware (OpenGD77, MD-380, etc.)
- Compare known-good implementations
- Identify similar patterns in our firmware

**Option C: Community/Vendor Assistance**
- Contact Ulefone for SDK/documentation
- Post on DMR development forums
- Reach out to Prize Telecom (OEM manufacturer)

### 7. ARM Cortex-M Specific Techniques
**Are there ARM Cortex-M specific analysis techniques we should use?**

Considerations:
- Vector table usually at 0x08000000 (contains reset handler, interrupts)
- Can we identify interrupt handlers from vector table?
- UART RX interrupt would be prime target
- Stack analysis (register preservation patterns)
- Calling convention (r0-r3 for parameters, r4-r11 preserved)

### 8. Scripting Ghidra Analysis
**Can we write a Ghidra script to automate finding the bug?**

Pseudocode:
```python
# Find all CMP r2, #2 instructions
cmp_locations = find_instructions("cmp r2, #2")

for loc in cmp_locations:
    # Check if followed by conditional branch
    next_instr = get_instruction_after(loc)
    if is_conditional_branch(next_instr):
        # Check branch target
        target = get_branch_target(next_instr)
        
        # Check if code AFTER branch has LDRB patterns
        code_after_branch = get_instructions_after(next_instr, count=20)
        if has_ldrb_pattern(code_after_branch, offsets=[5, 6, 7]):
            print(f"FOUND CANDIDATE AT: {loc}")
```

Is this feasible? What Ghidra API calls would we need?

### 9. Hardware Identification
**Can we identify the exact DMR chipset to find datasheets/SDKs?**

Candidate chipsets:
- Beken BK4819 (common in Quansheng radios)
- Auctus A7139 (DMR transceiver)
- ADF7021 (Analog Devices DMR IC)
- HR-C6000 (TYT DMR chipset)

If we knew the exact chip:
- Get datasheet with register maps
- Find example code or SDKs
- Understand DMR frame format exactly

How to identify:
- FCC ID database lookup (Ulefone Armor 26 Ultra)
- PCB photos/teardowns
- Firmware string searches for chip identifiers

### 10. Last Resort: Binary Diffing
**Should we create our own patched firmware from scratch?**

Instead of finding the bug:
1. Take original firmware
2. Replace suspected function entirely with custom implementation
3. Test on device

Requirements:
- Understand firmware update mechanism
- Know function boundaries
- Maintain compatibility with rest of firmware

---

## 📊 Current Status Summary

**What Works**:
- ✅ Analog MON button (v3.0.2) - production ready
- ✅ All v1.x features (transcription, recording, location, RSSI, CSV)
- ✅ Complete 489-line XDA announcement written
- ✅ Professional documentation

**What Doesn't Work**:
- ❌ DMR Monitor Mode (contactType=2 groupId extraction bug)
- ❌ 13 firmware patches failed
- ❌ 6 Ghidra investigations found only data/false positives
- ❌ Cannot locate actual bug in firmware

**Options**:
1. **Release v3.0.2 now** with DMR limitation documented (honest, professional)
2. **Continue with better tools/strategy** (your recommendations)
3. **Wait for community help** after XDA post (may attract firmware experts)

---

## 💡 What We Need from Grok

**Primary Request**: **A complete, step-by-step strategy to fully decompile this ARM Cortex-M / uC/OS-III firmware and locate the contactType=2 group ID extraction bug.**

**Specific Deliverables**:
1. Tool recommendations (Ghidra scripts, IDA plugins, custom tools)
2. Analysis workflow (entry points → UART handlers → DMR processing)
3. Pattern identification techniques (how to find the exact code section)
4. Alternative approaches if static analysis insufficient
5. Links to resources, tutorials, similar projects

**Secondary Request**: If complete decompilation isn't feasible without hardware debugging, help us understand:
- What minimum information we'd need from vendor
- What hardware tools are required (JTAG adapters, etc.)
- Whether firmware replacement rather than patching is more practical

---

## 🎯 Success Criteria

We'll know we've succeeded when:
1. Ghidra can show us the decompiled C code of the CMD 0x2B handler
2. We can see where `if (contactType == 2)` skips group ID extraction
3. We create a 2-4 byte patch that forces extraction for contactType=2
4. Deploy patch → DMR call with TG 11904 shows groupId=11904 instead of 0xFFFFFF
5. Android app receives call → Plays audio successfully

---

## 📁 Files Available for Analysis

We can provide:
- Original firmware binary (378,620 bytes)
- 13 patched firmware variants (all failed but documented)
- Ghidra project file with current analysis state
- Android app decompilation (Java source showing expected protocol)
- UART packet captures showing the bug in action
- Complete documentation (25+ markdown files with analysis)

---

## 🙏 Thank You!

This firmware bug is the only thing preventing full DMR functionality in our Xposed module. Any guidance on:
- Complete decompilation strategies
- uC/OS-III analysis techniques  
- ARM Cortex-M reverse engineering workflows
- Automated discovery scripts for Ghidra

...would be incredibly valuable.

**Ready to provide any additional information or files needed!** 📻

---

**Project**: [DMRModHooks on GitHub](https://github.com/IIMacGyverII/phonedmrapp)  
**Current Version**: v3.0.2 (analog features complete, DMR pending)  
**Developer**: IIMacGyverII
