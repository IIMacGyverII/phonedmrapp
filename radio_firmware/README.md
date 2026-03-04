# Radio Firmware Files

This folder contains the DMR radio module firmware for the Ulefone PriInterPhone/Armor 26 Ultra.

## Files

### DMR003.UV4T.V022-ORIGINAL.bin
**Original factory firmware** (378,620 bytes)

- **Version**: DMR003.UV4T.V022
- **MD5**: `4426035392262CA54583C230C9E268E0`
- **Architecture**: ARM Cortex-M (Thumb mode, mixed 16/32-bit instructions)
- **Base Address**: `0x08000000` (STM32/GD32 flash memory map)
- **RTOS**: uC/OS-III (Micrium commercial real-time OS)
- **Status**: Unmodified factory firmware as shipped with device

**Source Location**: Also available at `app/src/main/assets/DMR003.UV4T.V022.bin` (bundled with app for updates)

## Testing Modified Firmware

The app supports loading custom firmware via the **DMRDEBUG.bin** mechanism:

### Quick Test Procedure

```powershell
# 1. Create modified firmware (example: patch at offset 0x18F2C)
$fw = [IO.File]::ReadAllBytes("radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin")
$fw[0x18F2C] = 0x00  # NOP instruction byte 1
$fw[0x18F2D] = 0xBF  # NOP instruction byte 2
[IO.File]::WriteAllBytes("test_patch.bin", $fw)

# 2. Deploy to device
adb push test_patch.bin /sdcard/DMR/DMRDEBUG.bin

# 3. Restart app (will auto-update with test firmware, ~2 min)
adb shell am force-stop com.macgyver.dmr

# 4. Test functionality

# 5. Remove test firmware to restore original
adb shell rm /sdcard/DMR/DMRDEBUG.bin
```

### Safety Notes

- ✅ **Firmware loads to module RAM** - Changes are not permanent until power cycle
- ✅ **Fully reversible** - Remove DMRDEBUG.bin to restore factory firmware
- ✅ **No hardware risk** - App won't flash corrupted firmware (size/checksum validated)
- ⚠️ **Check both locations**: App checks `/sdcard/DMRDEBUG.bin` AND `/sdcard/DMR/DMRDEBUG.bin`

## Firmware Analysis

**Ghidra Project**: `ghidra_decompiled/project/DMR_Firmware`

Complete firmware decompilation available with:
- Full disassembly (all 378KB analyzed)
- Function identification and call graphs
- C pseudocode for all functions
- Cross-references computed

See [GHIDRA_NAVIGATION_GUIDE.md](../GHIDRA_NAVIGATION_GUIDE.md) for analysis instructions.

## Known Issues Under Investigation

**Monitor Mode Bug** (contactType=2, RECEIVE_ALL):
- **Problem**: Firmware reports group ID as `0xFFFFFF` (16777215) instead of actual ID
- **Impact**: Group calls get filtered, no audio plays in monitor mode
- **Status**: 13 patch attempts failed, full decompilation analysis underway
- **Details**: See [NOTES_FOR_GROK.md](../NOTES_FOR_GROK.md)

## Version History

| Version | Date | Status | Notes |
|---------|------|--------|-------|
| DMR003.UV4T.V022 | Feb 22, 2026 | ✅ Current Factory | Original firmware from device |

## References

- [DMR Protocol Specification](https://www.etsi.org/deliver/etsi_ts/102300_102399/10236101/01.02.01_60/ts_10236101v010201p.pdf) - ETSI TS 102 361
- [ARM Cortex-M Instruction Set](https://developer.arm.com/documentation/ddi0337/e/Introduction/About-the-Cortex-M3-instruction-set) - ARM Architecture Reference
- [Ghidra Documentation](https://ghidra-sre.org/CheatSheet.html) - Reverse engineering tool
