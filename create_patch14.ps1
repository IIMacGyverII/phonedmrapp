# Firmware Patch 14 - NOP Single BLS Branch
# Target: DMR contactType=2 group ID extraction bug
# Strategy: NOP only the BLS instruction at 0x08018F2C
# 
# Analysis from detailed_location_analysis.ps1:
# - Location 1 (0x08018F26) scored 12/11 - HIGHEST confidence
# - Has BLS (branch if r2 <= 2) at +6 bytes (0x08018F2C)
# - Disassembly confirmed extraction code at 0x08018F2E
# 
# Ghidra verification:
# - 0x08018F2C: BLS branches to LAB_08018f4c when r2 <= 2
# - 0x08018F2E: FUN_08018f2e contains extraction code (LDRB, bit shifts)
# - This extraction code is SKIPPED for contactType=2!
#
# Why this differs from Patch 12:
# - Patch 12 NOPed BOTH CBZ (0x08018F28) + BLS (0x08018F2C)
# - We're NOPing ONLY the BLS at 0x08018F2C
# - Leave CBZ intact (might check frame validity via r0)

$original_file = "C:\Users\Joshua\Documents\android\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
$patched_file = "C:\Users\Joshua\Documents\android\phonedmrapp\radio_firmware\DMR003.UV4T.V022-PATCH14.bin"

Write-Host "=" * 80
Write-Host "FIRMWARE PATCH 14 - NOP BLS at 0x08018F2C"
Write-Host "=" * 80
Write-Host ""

# Read original firmware
$bytes = [System.IO.File]::ReadAllBytes($original_file)
Write-Host "[1/5] Loaded original firmware: $($bytes.Length) bytes"
Write-Host ""

# Verify we're patching the right location
$patch_offset = 0x18F2C
$expected_bytes = @(0x0E, 0xD9)  # BLS opcode

Write-Host "[2/5] Verifying patch location..."
$actual_byte1 = $bytes[$patch_offset]
$actual_byte2 = $bytes[$patch_offset + 1]

if ($actual_byte1 -eq $expected_bytes[0] -and $actual_byte2 -eq $expected_bytes[1]) {
    Write-Host "   ✓ Confirmed BLS instruction (0E D9) at offset 0x$($patch_offset.ToString('X'))"
} else {
    Write-Host "   ✗ ERROR: Expected 0E D9, found {0:X2} {1:X2}" -f $actual_byte1, $actual_byte2
    Write-Host "   Firmware may be different version! ABORTING."
    exit 1
}
Write-Host ""

# Show context
Write-Host "[3/5] Context (±10 bytes):"
Write-Host "   Address      Bytes        Instruction"
Write-Host "   --------     --------     -----------"

$context_start = $patch_offset - 10
$context_end = $patch_offset + 10

for ($i = $context_start; $i -le $context_end; $i += 2) {
    $addr = $i + 0x08000000
    $b0 = $bytes[$i]
    $b1 = $bytes[$i + 1]
    
    $marker = if ($i -eq $patch_offset) { ">>>" } else { "   " }
    $change = if ($i -eq $patch_offset) { " <- WILL CHANGE TO: 00 BF (NOP)" } else { "" }
    
    $instr = "..."
    if ($i -eq 0x18F26) { $instr = "cmp r2, #2" }
    elseif ($i -eq 0x18F28) { $instr = "cbz r0, <...>" }
    elseif ($i -eq 0x18F2A) { $instr = "ldr r3, [r4, #28]" }
    elseif ($i -eq 0x18F2C) { $instr = "bls <LAB_08018f4c>" }
    elseif ($i -eq 0x18F2E) { $instr = "movs r0, #0" }
    elseif ($i -eq 0x18F30) { $instr = "asrs r1, r0, #16" }
    elseif ($i -eq 0x18F32) { $instr = "ldrb r4, [r7, #0]" }
    
    Write-Host ("{0} 0x{1:X8}   {2:X2} {3:X2}       {4}{5}" -f $marker, $addr, $b0, $b1, $instr, $change)
}
Write-Host ""

# Apply patch
Write-Host "[4/5] Applying patch..."
$bytes[$patch_offset] = 0x00      # NOP instruction
$bytes[$patch_offset + 1] = 0xBF  # NOP (ARM Thumb encoding)

Write-Host "   Changed offset 0x$($patch_offset.ToString('X')): 0E D9 → 00 BF (NOP)"
Write-Host "   Effect: Execution will fall through to extraction code at 0x08018F2E"
Write-Host ""

# Write patched firmware
[System.IO.File]::WriteAllBytes($patched_file, $bytes)
Write-Host "[5/5] Saved patched firmware: $patched_file"
Write-Host ""

# Verify patch
$verify_bytes = [System.IO.File]::ReadAllBytes($patched_file)
if ($verify_bytes[$patch_offset] -eq 0x00 -and $verify_bytes[$patch_offset + 1] -eq 0xBF) {
    Write-Host "✓ PATCH VERIFIED"
} else {
    Write-Host "✗ PATCH VERIFICATION FAILED!"
    exit 1
}

Write-Host ""
Write-Host "=" * 80
Write-Host "PATCH SUMMARY"
Write-Host "=" * 80
Write-Host ""
Write-Host "Patch Location: 0x08018F2C (file offset 0x18F2C)"
Write-Host "Original bytes: 0E D9 (bls LAB_08018f4c)"
Write-Host "Patched bytes:  00 BF (nop)"
Write-Host ""
Write-Host "What this fixes:"
Write-Host "- Before: When contactType=2, BLS branches away, skips extraction"
Write-Host "- After:  NOP does nothing, execution continues to 0x08018F2E"
Write-Host "- Result: Group ID extraction code at 0x08018F2E now executes!"
Write-Host ""
Write-Host "Expected behavior:"
Write-Host "- Incoming DMR call with TG 11904 on contactType=2 channel"
Write-Host "- Firmware extracts group ID from frame bytes [5-7]"
Write-Host "- CMD 0x2B response reports groupId=11904 (not 0xFFFFFF)"
Write-Host "- Android app receives valid group ID, plays audio"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Copy patched firmware to radio:"
Write-Host "   adb push `"$patched_file`" /sdcard/Download/DMRDEBUG.bin"
Write-Host ""
Write-Host "2. Trigger firmware reload (power cycle or command)"
Write-Host ""
Write-Host "3. Test with DMR call on TG 11904 with contactType=2"
Write-Host ""
Write-Host "4. Monitor UART logs to verify groupId extraction"
Write-Host ""
Write-Host "=" * 80
Write-Host ""
Write-Host "PATCH 14 COMPLETE!"
Write-Host "Patched file ready: $patched_file"
Write-Host "=" * 80
