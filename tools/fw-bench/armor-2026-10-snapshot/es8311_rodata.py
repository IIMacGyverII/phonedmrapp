"""Interpret the es8311 sysfs rodata as pointers and strings."""
import struct

data = open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\kernel.img", "rb").read()
BASE = 0xFFFFFF8008080000

def cstr(off):
    if not 0 <= off < len(data):
        return None
    end = data.find(b"\x00", off)
    raw = data[off:end]
    if not raw or any(b < 32 or b > 126 for b in raw) or len(raw) > 80:
        return None
    return raw.decode("ascii")

start = 0x1A09300
end = 0x1A0A080
for off in range(start, end, 8):
    va = struct.unpack_from("<Q", data, off)[0]
    note = ""
    if va == 0:
        note = "NULL"
    elif BASE <= va < BASE + len(data):
        s = cstr(va - BASE)
        note = f"-> {s!r}" if s else f"-> file {va-BASE:#x}"
    elif 0 < va < 0x10000:
        note = f"imm {va:#x} mode {oct(va) if va < 0x1000 else ''}"
    else:
        note = "code/other"
    if note == "NULL" and off % 32 != 0:
        continue
    print(f"{off:#x} {va:#018x} {note}")
