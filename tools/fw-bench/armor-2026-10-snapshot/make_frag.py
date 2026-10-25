from pathlib import Path

h = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r3a3_hex.txt").read_text().strip()
z = "00" * (len(h) // 2)
assert len(z) == len(h) == 376
frag = """# R3a3. Not the IRAM key-up hook: a host 0x26 never calls +0x3ECC0, so R3a2's
# flag stayed clear and the key radiated the codec tone. This stub is called
# from the four bsr 0xe9c sites inside the flash 0x26 handler. The boot
# self-test does not send 0x26. Exclusive with every other stub at +0x5B000.
[patches.c7000-txram-dmr]
why = \"\"\"R3a3. Replace both launch=1 bsr 0xe9c sites (+0x92C8, +0x92E0) with on_key
and both launch=2 sites (+0x92AA, +0x92FA) with on_unkey, at XIP 0x03075000.
Each entry pushes r4-r8, r15, calls 0xe9c with the handler's r0/r1, then uses
only r0-r3. on_key stores RF_MODE 0x10E0 and WORK_MODE 0x80, sets 0x11000080
bit 0 (bit 4 stays clear), clears FM_BANDWIDTH bits 4 and 6, fills 0x16000030
with +256 for 256 samples and -256 for the next 256, writes AT1846S 0x30 =
0x4006 then 0x4026 and 0x58 = 0xBCFD, and stores PTT = 1. on_unkey stores
PTT = 0, clears bit 0, and writes 0x58 = 0x8405 and 0x30 = 0x7026. The five
factory 0x8405 immediates, the tune redirect at +0x3074, and the IRAM key-up
bytes at +0x3EDFC are not patched. A = 256. Bench only.\"\"\"
measured_by = "R3a3: one 3 s key on the 467.625 VFO, low power, HackRF receive, after a silent-boot check"
status = "experimental"
sites = [
  { offset = 0x92C8, original = "ffe3eabd", replacement = "02e09c8e", note = "0x26 launch=1, byte 0x38874 == 0: bsr on_key (was bsr 0xe9c)" },
  { offset = 0x92E0, original = "ffe3debd", replacement = "02e0908e", note = "0x26 launch=1, byte 0x38874 != 0: bsr on_key (was bsr 0xe9c)" },
  { offset = 0x92AA, original = "ffe3f9bd", replacement = "02e0ef8e", note = "0x26 launch=2, r7 == 0: bsr on_unkey (was bsr 0xe9c)" },
  { offset = 0x92FA, original = "ffe3d1bd", replacement = "02e0c78e", note = "0x26 launch=2, r7 != 0: bsr on_unkey (was bsr 0xe9c)" },
  { offset = 0x5B000, original = "%s", replacement = "%s", note = "stub (stubs/c7000_txram_dmr.S, as -mcpu=ck803, ld.bfd -Ttext=0x5B000): on_key, on_unkey" },
]
""" % (z, h)
Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r3a3_toml_frag.txt").write_text(frag, encoding="utf-8")
print("frag", len(frag))
