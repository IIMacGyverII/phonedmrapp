# Zero runs and the command jump table. Read only.
from pathlib import Path

img = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
# Also look at the built R4k image for caves that survived.
built = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\build\DMR003.R4k0.V022.bin").read_bytes()

def runs(buf, need):
    out = []
    i = 0
    n = len(buf)
    while i < n:
        if buf[i] != 0:
            i += 1
            continue
        j = i
        while j < n and buf[j] == 0:
            j += 1
        if j - i >= need:
            out.append((i, j - i))
        i = j
    return out

print("factory caves >= 48")
for off, ln in runs(img, 48):
    print("  0x%X %d" % (off, ln))
print("r4k caves >= 32 outside the loop")
for off, ln in runs(built, 32):
    if off < 0x5B400 or off >= 0x5C6FC:
        print("  0x%X %d" % (off, ln))

base = 0x38240
print("table words from +0x38240")
for i in range(32):
    w = int.from_bytes(img[base + 4 * i:base + 4 * i + 4], "little")
    print("  idx %2d cmd 0x%02X word 0x%08X" % (i, 0x22 + i, w))
