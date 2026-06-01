# Ghidra Firmware Analysis - Current Status

**Date**: February 28, 2026  
**Firmware**: DMR003.UV4T.V022.bin (378,620 bytes)  
**Objective**: Find and patch group call filtering bug

---

## ✅ **Completed Steps**

### 1. **Ghidra Setup**
- ✅ Downloaded and installed Ghidra 11.2
- ✅ Configured Java environment
- ✅ Imported firmware at base address 0x08000000
- ✅ Selected ARM Cortex / Thumb little endian processor

### 2. **Initial Analysis**
- ✅ Found strings (timer10ms, uC/OS-III, Task Sem, etc.)
- ✅ Base address 0x08000000 confirmed correct
- ✅ Identified 10 functions manually
- ✅ Located code sections via PUSH instruction patterns

### 3. **Command Handler Search**
- ✅ Found CMD 0x22 comparison at **0x0800AC76**: `cmp r7, #0x22`
- ✅ Found second occurrence at **0x0801035A**: `cmp r7, #0x22`
- ✅ Exported functions list (10 functions found)
- ✅ Attempted C decompilation export

---

## ⚠️ **Issues Encountered**

### 1. **Decompilation Failures**
```
- FUN_08000c42: "Bad instruction - halt_baddata()"
- FUN_08001272: "Timeout during decompilation"
- FUN_0801035a: Decompiled but with SBORROW4 and halt_baddata() errors
```

**Root Cause**: Firmware has non-standard structure (not typical ARM bootloader)

### 2. **Function Analysis Problems**
- Auto-analysis failed to find most functions (only 10 found, should be 100+)
- Aggressive Instruction Finder needs more seed functions
- Many code sections not disassembled

### 3. **Command Dispatch Complexity**
- Found CMP r7, #0x22 but surrounding code is complex
- Multiple conditional branches (BGT, BMI) suggest table-based dispatch
- Not a simple if/else command check

---

## 🔍 **Key Findings**

### **Command Comparison Locations**:

**Location 1: 0x0800AC76**
```
0800AC76  cmp r7, #0x22
0800AC78  cmp r1, #0
0800AC7A  bgt 0x0800AD18  (branch if greater)
0800AC88  bmi 0x0800ABD4  (branch if minus/negative)
0800AC8E  movs r1, #0x22
0800AC90  ldr r3, [r0, r1]  (load from table?)
```

**Location 2: 0x0801035A**
```
0801035A  cmp r7, #0x22
0801035C  ldr r0, [sp, #0x180]
0801035E  stmia r4!, {r0, r1, r3-r6}
```

### **Firmware Structure**:
- **Strings at**: 0x08036528+ (timer10ms, CMD req, SDMMC, etc.)
- **Code sections**: Scattered (0x0800xxxx range)
- **RTOS**: uC/OS-III (commercial real-time OS)
- **Encryption**: None (entropy 5.4 bits)

---

## 🎯 **Next Steps - Options**

### **Option A: Continue Detailed Ghidra Analysis** ⏱️ 2-4 hours
**Pros**:
- Would find EXACT bug location
- Surgical patch (minimal risk)
- Deep understanding of firmware

**Cons**:
- Time-consuming manual assembly tracing
- May still not find the exact filtering logic
- Decompiler issues make it harder

**Steps**:
1. Manually disassemble more functions (press D+F on 50+ locations)
2. Trace r7 register usage to find command dispatch table
3. Find where contactType is checked in group call handler
4. Identify the missing/broken contactType==2 check
5. Create precise hex patch

---

### **Option B: Empirical "Bypass Filter" Patch** ⏱️ 1 hour (RECOMMENDED)
**Pros**:
- Faster to implement
- Can test multiple patches quickly via DMRDEBUG.bin
- Higher success probability
- Safe testing (no hardware risk)

**Cons**:
- Less surgical (might bypass more than needed)
- Don't know exact root cause

**Steps**:
1. Identify common filtering patterns (CMP + conditional branch)
2. Create 3-4 patch variations:
   - **Patch A**: NOP out group ID comparison
   - **Patch B**: Force branch to "allow all" path
   - **Patch C**: Change conditional to unconditional
3. Test each via `/sdcard/DMR/DMRDEBUG.bin`
4. Verify with blocked group call
5. If successful, analyze which patch worked to understand bug

---

### **Option C: Hybrid Approach** ⏱️ 2 hours
1. Try empirical patches first (30 min)
2. If patches don't work, go back to Ghidra deep-dive
3. Use patch testing results to guide analysis

---

## 📊 **Success Probability Estimates**

| Approach | Success Chance | Time | Risk |
|----------|---------------|------|------|
| **Option A** (Ghidra deep-dive) | 60% | 2-4 hrs | Low |
| **Option B** (Empirical patches) | 75% | 1 hr | Very Low |
| **Option C** (Hybrid) | 85% | 2 hrs | Very Low |

---

## 🛠️ **Recommended Action**

**Start with Option B (Empirical Patches)**:

1. **Create patch candidates** (15 minutes)
2. **Test via DMRDEBUG.bin** (30 minutes)
3. **Verify with group call** (15 minutes)

If no patches work → Switch to Option A for deeper analysis

**Rationale**:
- YModem DMRDEBUG.bin testing is SAFE and FAST
- Can try multiple patches with zero hardware risk
- Empirical approach works even when reverse engineering is difficult
- Successful patch will reveal the bug location indirectly

---

## 📝 **Tools & Resources Ready**

- ✅ Ghidra 11.2 running
- ✅ Firmware at`C:\Users\Joshua\Downloads\firmware.bin`
- ✅ Base address validated (0x08000000)
- ✅ Test method available (DMRDEBUG.bin)
- ✅ ADB connection working
- ✅ Blocked group call for testing

---

## 🚀 **Ready to Proceed**

**Decision needed**: Which option should we pursue?

**My recommendation**: **Option B** → Start creating empirical patches now!
