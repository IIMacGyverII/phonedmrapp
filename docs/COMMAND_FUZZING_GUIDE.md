# DMR Module v3.0.1 - Undocumented Command Discovery

## Overview

v3.0.1 introduces **hardware-level command fuzzing** to discover undocumented firmware commands that might bypass the contactType=2 group call filtering bug.

## Command Space Analysis

**Documented Commands:** 29 commands (0x22-0x3F, 0xAA)
**Undocumented Commands:** 227 commands to test

### Interesting Ranges:
- **0x00-0x21** (34 commands): System/initialization commands
- **0x3D-0x3E** (2 commands): Between standard and test commands  
- **0x40-0xA9** (106 commands): **Largest gap - likely diagnostic/debug range**
- **0xAB-0xFF** (85 commands): Post-initialization commands

## Usage

### 1. Quick Test (Priority Commands)

```bash
cd C:\Users\Joshua\Documents\android\phonedmrapp
python quick_fuzzer_auto.py
```

This tests 25 high-priority command codes in ~5 seconds.

### 2. Full Scan (All 227 Undocumented Commands)

```bash
python command_fuzzer_executor.py
```

Takes ~35 seconds to test all undocumented commands.

### 3. Manual Command Testing

```bash
# Test specific command (e.g., 0x4D = 77 decimal)
adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 77 --ei RW 1 --ei SR 1"

# With custom body payload (hex string)
adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 77 --ei RW 1 --ei SR 1 --es BODY '01020304'"
```

### 4. Analyze Results

```bash
# Pull UART logs containing responses
adb pull /sdcard/DMR/uart_logs/ ./uart_fuzzing_results/

# Check logcat for successful transmissions
adb logcat -d | Select-String "FUZZING|Debug packet"
```

## What to Look For

**In UART logs:**
- Non-error responses (CMD with RW=0, SR=0, non-empty body)
- Commands that return data instead of just ACK
- Error responses with SR=1 (FAIL) vs SR=2 (checksum error) - SR=1 means command recognized!

**Target Discovery:**
Look for commands that might:
1. **Override RX filtering** - Accept calls regardless of group list
2. **Force promiscuous mode** - Bypass all validation
3. **Debug/diagnostic modes** - Enable hidden features
4. **Configuration resets** - Clear restrictive settings

## Implementation Details

**MainHook.java Changes (v3.0.1):**
- Added `registerDebugPacketReceiver()` - Listens for broadcast intents
- Added `handleDebugPacket()` - Constructs and sends UART packets
- Added `hexStringToByteArray()` - Supports custom payloads
- **Permission**: RECEIVER_EXPORTED for ADB access

**Broadcast Intent Format:**
```
Action: com.dmrmod.SEND_DEBUG_PACKET
Extras:
  - CMD (int): Command code 0-255
  - RW (int): 0=Query response, 1=Query/Set
  - SR (int): 0=Success, 1=Set/Request
  - BODY (string, optional): Hex payload e.g., "0102AABBCCDD"
```

## Next Steps After Fuzzing

1. **Identify Responsive Commands**: Any command that returns non-trivial data
2. **Test with Payloads**: Send body data to discovered commands
3. **Reverse Engineer Responses**: Decode meaning of returned bytes
4. **Test During Calls**: Send commands while group call is incoming
5. **Document Bypass Commands**: Commands that override filtering

## Command Categories (Hypothesis)

Based on typical firmware design:

| Range | Likely Purpose |
|-------|---------------|
| 0x00-0x0F | System control (reset, init, status) |
| 0x10-0x1F | Hardware config (GPIO, registers) |
| 0x20-0x21 | Undocumented user commands |
| 0x3D-0x3E | Test/calibration commands |
| 0x40-0x7F | **Diagnostic/debug interface** ← HIGH PRIORITY |
| 0x80-0xA9 | Extended diagnostic features |
| 0xAB-0xFF | Factory/engineering commands |

## Success Criteria

**Discovery of ANY of:**
- Command to disable RX group list filtering
- Command to force accept all DMR traffic
- Command to override contactType validation
- Command to enter debug/promiscuous mode
- Command to dump internal state/registers

Even ONE such command would bypass the firmware bug!

## Safety Notes

- All commands sent with RW=1 (query/read mode) initially
- Firmware likely ignores invalid commands (returns error or nothing)
- UART logging captures all responses for analysis
- Device can be rebooted if issues occur

---

**Status**: Infrastructure complete, ready for systematic discovery
**Version**: 3.0.1
**Date**: February 28, 2026
