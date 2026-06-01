# Firmware Patch 14 - NOP Single BLS Branch
# Target: 0x08018F2C - BLS instruction that skips group ID extraction for contactType=2

$original_file = "C:\Users\Joshua\Documents\android\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
$patched_file = "C:\Users\Joshua\Documents\android\phonedmrapp\radio_firmware\DMR003.UV4T.V022-PATCH14.bin"

Write-Host ("=" * 80)
Write-Host "FIRMWARE PATCH 14 - NOP BLS at 0x08018F2C"
Write-Host ("=" * 80)
Write-Host ""

# Read original firmware
$bytes = [System.IO.File]::ReadAllBytes($original_file)
Write-Host "[1/5] Loaded original firmware: $($bytes.Length) bytes"
Write-Host ""

# Verify we're patching the right location
$patch_offset = 0x18F2C
$expected_bytes = @(0x0E, 0xD9)

Write-Host "[2/5] Verifying patch location..."
$actual_byte1 = $bytes[$patch_offset]
$actual_byte2 = $bytes[$patch_offset + 1]

if ($actual_byte1 -eq $expected_bytes[0] -and $actual_byte2 -eq $expected_bytes[1]) {
    Write-Host "   [+] Confirmed BLS instruction (0E D9) at offset 0x$($patch_offset.ToString('X'))"
} else {
    Write-Host "   [X] ERROR: Expected 0E D9, found {0:X2} {1:X2}" -f $actual_byte1, $actual_byte2
    Write-Host "   Firmware may be different version! ABORTING."
    exit 1
}
Write-Host ""

# Show context
Write-Host "[3/5] Context around patch location:"
Write-Host ""
Write-Host "   0x08018F26: 02 2A  cmp r2, #2          (check contactType)"
Write-Host "   0x08018F28: 40 B3  cbz r0, ...         (branch if r0=0)"
Write-Host "   0x08018F2A: A3 6F  ldr r3, [r4, #28]   (load data)"
Write-Host "   0x08018F2C: 0E D9  bls ...             [PATCH TARGET - will NOP this]"
Write-Host "   0x08018F2E: 00 20  movs r0, #0         (extraction code starts here)"
Write-Host "   0x08018F30: 01 14  asrs r1, r0, #16"
Write-Host "   0x08018F32: 3C 78  ldrb r4, [r7, #0]"
Write-Host ""

# Apply patch
Write-Host "[4/5] Applying patch..."
$bytes[$patch_offset] = 0x00
$bytes[$patch_offset + 1] = 0xBF

Write-Host "   Changed offset 0x$($patch_offset.ToString('X')): 0E D9 -> 00 BF (NOP)"
Write-Host "   Effect: Execution falls through to extraction code at 0x08018F2E"
Write-Host ""

# Write patched firmware
[System.IO.File]::WriteAllBytes($patched_file, $bytes)
Write-Host "[5/5] Saved patched firmware"
Write-Host ""

# Verify patch
$verify_bytes = [System.IO.File]::ReadAllBytes($patched_file)
if ($verify_bytes[$patch_offset] -eq 0x00 -and $verify_bytes[$patch_offset + 1] -eq 0xBF) {
    Write-Host "[+] PATCH VERIFIED - File written correctly"
} else {
    Write-Host "[X] PATCH VERIFICATION FAILED!"
    exit 1
}

Write-Host ""
Write-Host ("=" * 80)
Write-Host "PATCH SUMMARY"
Write-Host ("=" * 80)
Write-Host ""
Write-Host "Patch Location: 0x08018F2C (file offset 0x18F2C)"
Write-Host "Original bytes: 0E D9 (bls - branch if lower or same)"
Write-Host "Patched bytes:  00 BF (nop - no operation)"
Write-Host ""
Write-Host "What this fixes:"
Write-Host "  Before: When contactType=2, BLS branches away, skips extraction"
Write-Host "  After:  NOP does nothing, execution continues to 0x08018F2E"
Write-Host "  Result: Group ID extraction code now executes for contactType=2"
Write-Host ""
Write-Host "Expected behavior after patching:"
Write-Host "  1. Incoming DMR call with TG 11904 on contactType=2 channel"
Write-Host "  2. Firmware extracts group ID from frame bytes [5-7]"
Write-Host "  3. CMD 0x2B response reports groupId=11904 (not 0xFFFFFF)"
Write-Host "  4. Android app receives valid group ID, plays audio"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Deploy patched firmware:"
Write-Host "     adb push radio_firmware\DMR003.UV4T.V022-PATCH14.bin /sdcard/Download/DMRDEBUG.bin"
Write-Host ""
Write-Host "  2. Trigger firmware reload (power cycle radio)"
Write-Host ""
Write-Host "  3. Test with DMR call on TG 11904 with contactType=2"
Write-Host ""
Write-Host "  4. Monitor UART logs to verify groupId extraction"
Write-Host ""
Write-Host ("=" * 80)
Write-Host ""
Write-Host "[SUCCESS] PATCH 14 COMPLETE!"
Write-Host "Patched file: $patched_file"
Write-Host ("=" * 80)
