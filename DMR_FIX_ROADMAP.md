# DMR Group Call Fix - Implementation Roadmap

**Status:** Hardware rejects ALL mode - need alternative approaches  
**Priority:** HIGH - Affects core DMR functionality

---

## Summary of Findings

We successfully inject `contactType=2` into hardware packets, **BUT** the DMR module firmware **rejects ALL mode** and reverts to broken GROUP mode. The hardware only implements:
- `contactType=0`: PERSON (private calls only)
- `contactType=1`: GROUP (broken - ignores RX group list)
- ~~`contactType=2`: ALL mode~~ ❌ NOT SUPPORTED

---

## Viable Workarounds (Ranked by Feasibility)

### 🟢 Option 1: Firmware Extraction & Patching (RECOMMENDED)

**Goal:** Patch DMR module firmware to either support ALL mode OR fix broken GROUP filtering

**Phase 1: Firmware Extraction**

1. **Search device partitions:**
```bash
adb shell su -c "cat /proc/mtd"
adb shell su -c "ls -la /dev/block/platform/*/by-name/*"
adb shell su -c "find /system /vendor /firmware -name '*dmr*' -o -name '*radio*'"
```

2. **Monitor firmware update mechanism:**
   - App has update functionality: `prize.intent.action.update.dmr.firmware`
   - Capture update file when available
   - Reverse engineer update protocol

3. **UART sniffing for chipset ID:**
   - Log all /dev/ttyS0 traffic
   - Analyze packet headers for chipset signatures
   - Check FCC ID database for Ulefone Armor 26 Ultra

**Phase 2: Analysis**

4. **Disassemble firmware:**
   - Use Ghidra/IDA Pro (likely ARM Cortex-M or MIPS)
   - Search for contactType validation: `CMP r0, #2` or similar
   - Find group list filtering logic
   - Locate RX packet acceptance code

5. **Patch targets:**
   - **Option A:** Remove contactType validation (accept values 0-2)
   - **Option B:** Fix GROUP mode filtering to actually use RX group list
   - **Option C:** Make contactType=1 behave like contactType=2

**Phase 3: Flash**

6. **Flash modified firmware:**
   - Use app's update mechanism if protocol is documented
   - Direct UART flash if bootloader accessible
   - May require hardware debugger (JTAG/SWD)

**Risks:**
- ⚠️ Device brick if flash fails (need backup/recovery method)
- ⚠️ Warranty void
- ⚠️ May require device teardown

**Tools Needed:**
- Ghidra or IDA Pro
- Logic analyzer or USB-UART adapter (for sniffing)
- Possibly: JTAG/SWD debugger (J-Link, ST-Link, etc.)

**Time Estimate:** 2-4 weeks

---

###🟡 Option 2: Software RX Bypass (COMPLEX)

**Goal:** Intercept hardware RX decisions and override filtering in software

**Hypothesis:** Hardware receives all DMR traffic but firmware filters it before sending RECEIVE_START event to app

**Implementation:**

1. **Hook serial packet receiver:**
```java
XposedHelpers.findAndHookMethod(
    "com.pri.prizeinterphone.serial.MessageDispatcher",
    "onReceive",
    Packet.class,
    SerialPort.class,
    new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            Packet packet = (Packet) param.args[0];
            
            // Intercept RECEIVE_* commands from hardware
            if (packet.cmd == RECEIVE_START || packet.cmd == RECEIVE_STOP) {
                // Analyze packet.body for caller DMR ID / TG number
                // Force acceptance even if hardware says "no"
            }
        }
    }
);
```

2. **Inject fake RECEIVE_START events:**
   - When hardware receives a group call (but rejects it)
   - Hardware might send a different event (e.g., "call ignored")
   - Intercept that event and convert it to RECEIVE_START
   - Route audio to PCMReceiveManager

3. **Challenge:** Audio might not be decoded if hardware rejects call
   - Hardware may stop DMR demodulation entirely
   - May not be possible to recover audio in software

**Feasibility:** Medium-Low (depends on hardware behavior)

**Time Estimate:** 1-2 weeks

---

### 🟡 Option 3: Serial Protocol Reverse Engineering

**Goal:** Fully document UART protocol and discover hidden commands

**Approach:**

1. **Hook Serial.java to log all traffic:**
```java
XposedHelpers.findAndHookMethod(
    "com.pri.prizeinterphone.serial.Serial",
    "getOutputStream",
    new XC_MethodHook() {
        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            FileOutputStream fos = (FileOutputStream) param.getResult();
            // Wrap in logging proxy
        }
    }
);
```

2. **Analyze packet structure:**
   - Current knowledge: Packet has `cmd`, `body`, `sr` (status)
   - Look for undocumented commands
   - Search for "debug mode" or "engineering mode" commands

3. **Test with custom commands:**
   - Send crafted packets to hardware
   - Look for responses to unknown command codes
   - May find hidden ALL mode or promiscuous mode

**Feasibility:** Medium (time-consuming but methodical)

**Time Estimate:** 1-3 weeks

---

### 🔴 Option 4: Hardware Module Replacement (HARDWARE MOD)

**Goal:** Replace DMR module with one that supports ALL mode

**Requirements:**
- Compatible UART protocol (57600 baud, same command structure)
- Physical compatibility (connector type, dimensions, power)
- Firmware that supports contactType=2

**Candidates to research:**
- Ailunce HD1 DMR module
- TYT MD-UV380 module  
- Hytera modules
- Motorola MOTOTRBO modules (expensive)

**Steps:**
1. Teardown Ulefone to identify current module
2. Document connector pinout
3. Reverse engineer protocol compatibility
4. Source compatible replacement
5. Physical swap and testing

**Feasibility:** Low (requires hardware expertise + protocol compatibility)

**Cost:** $50-$200 for module + tools

**Time Estimate:** 2-4 weeks

---

### 🔴 Option 5: External DMR Transceiver (WORKAROUND, NOT FIX)

**Goal:** Use Ulefone as display/control, external radio for actual DMR

**Approach:**
- Connect external DMR radio via Bluetooth or USB
- App controls external radio instead of internal module
- External radio handles all RF and group filtering

**Pros:**
- No firmware modification needed
- Can use high-quality radio (Anytone, TYT, etc.)

**Cons:**
- Defeats purpose of integrated DMR phone
- Expensive ($200-$500 for good DMR radio)
- Bulky setup

**Feasibility:** High (but not a real solution)

---

## Recommended Implementation Plan

### Phase 1: Quick Wins (1 week)

1. **Serial protocol logging** (Option 3)
   - Implement comprehensive UART traffic logging
   - Document all packet types during normal operation
   - Look for undocumented commands in packet captures

### Phase 2: Firmware Analysis (2-3 weeks)

2. **Firmware extraction** (Option 1)
   - Search device for firmware blobs
   - Monitor update mechanism
   - Intercept firmware file if update becomes available

3. **Firmware disassembly** (Option 1)
   - Identify chipset (critical for correct disassembly)
   - Load in Ghidra
   - Find contactType validation and group filtering code

### Phase 3: Implementation (1-2 weeks)

4. **Choose approach based on findings:**
   - **If firmware is patchable:** Patch and flash (Option 1)
   - **If hidden commands found:** Use alternate command (Option 3)
   - **If software bypass possible:** Implement RX override (Option 2)
   - **If all fail:** Document bug for manufacturer escalation

---

## Technical Requirements

### Software:
- ✅ Android Studio (have)
- ✅ LSPosed Framework (installed)
- ✅ ADB tools (have)
- ⬜ Ghidra or IDA Pro (need for firmware analysis)
- ⬜ Python + pyserial (for UART analysis)
- ⬜ Wireshark (for protocol analysis)

### Hardware:
- ✅ Ulefone Armor 26 Ultra (have)
- ✅ USB cable for ADB (have)
- ⬜ USB-UART adapter (optional, for hardware sniffing)
- ⬜ Logic analyzer (optional, for protocol capture)
- ⬜ JTAG/SWD debugger (optional, for firmware debugging)

### Skills Needed:
- ✅ Java/Android (have)
- ✅ LSPosed hooking (have)
- ⬜ ARM/MIPS assembly (need for firmware analysis)
- ⬜ Binary reverse engineering (need basics)
- ⬜ Hardware debugging (optional)

---

## Risk Assessment

| Approach | Brick Risk | Time | Complexity | Success Probability |
|----------|-----------|------|------------|---------------------|
| Firmware patch | Medium | 3-4w | High | 70% |
| Software bypass | None | 1-2w | Medium | 30% |
| Protocol RE | None | 2-3w | Medium | 50% |
| Hardware swap | Low | 2-4w | High | 40% |

---

## Success Criteria

**Minimum Viable Fix:**
- Receive group calls to TG 64067 and 55301
- No regression on private call reception
- Stable operation (no crashes or radio glitches)

**Ideal Solution:**
- Full ALL mode support (receive all traffic on CC/TS)
- OR: Fixed GROUP mode (proper RX group list filtering)
- Firmware can be reflashed to stock if needed

---

## Fallback Plan

If all technical approaches fail:

1. **Document the bug professionally:**
   - Create detailed technical report
   - Include packet captures showing contactType rejection
   - Demonstrate that database/app are correct but hardware ignores

2. **Contact manufacturer:**
   - Ulefone support (likely unhelpful)
   - PRI/Prize Electronics (app developer - may have firmware access)
   - DMR module manufacturer (if identifiable)

3. **Community escalation:**
   - Post to r/dmr, r/amateurradio
   - DMR-MARC forums
   - Ulefone user forums
   - May find others with same issue

4. **Alternative use cases:**
   - Use as private call-only DMR radio
   - Use analog FM mode (unaffected)
   - Repurpose as DMR hotspot controller

---

## Next Immediate Steps (Priority Order)

1. **[TODAY]** Implement UART logging hook
   - Capture all /dev/ttyS0 traffic for 24h
   - Parse packet structure
   - Identify any unknown commands

2. **[THIS WEEK]** Search for firmware:
   - Check all /system, /vendor, /firmware directories
   - Monitor logcat for firmware paths
   - Check app's update mechanism

3. **[NEXT WEEK]** Begin Ghidra analysis:
   - If firmware found: Start disassembly
   - Learn ARM Cortex-M basics if needed
   - Create searchable database of protocol commands

4. **[ONGOING]** Research DMR chipsets:
   - Common chips: Beken BK4819, Auctus A7139, AT1846S
   - Find datasheets
   - Check if any support ALL mode in hardware

---

## Files & Documentation

- [MONITORING_MODE_INVESTIGATION.md](MONITORING_MODE_INVESTIGATION.md) - Full investigation report
- [MainHook.java v1.8.9](DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java) - Current implementation
- [Status logs](logs/) - Packet captures and test results

---

## Learning Resources

### Firmware Reverse Engineering:
- Ghidra quickstart: https://ghidra-sre.org/CheatSheet.html
- ARM Cortex-M assembly: https://developer.arm.com/documentation
- Firmware extraction guide: https://github.com/ReFirmLabs/binwalk

### DMR Protocol:
- ETSI TS 102 361 (DMR standard)
- DMR firmware analysis: https://github.com/russelltadams/DMR
- Amateur DMR wiki: https://www.dmr-marc.net/

### Serial Protocol Analysis:
- pyserial documentation: https://pyserial.readthedocs.io/
- UART protocol basics: https://learn.sparkfun.com/tutorials/serial-communication

---

**Last Updated:** February 27, 2026  
**Status:** Investigation complete, firmware analysis phase ready to begin
