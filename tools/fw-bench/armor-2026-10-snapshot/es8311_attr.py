"""Read the printk strings and the sysfs attribute that points at es8311_store."""
import struct

data = open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\kernel.img", "rb").read()
BASE = 0xFFFFFF8008080000

def cstr(off):
    end = data.find(b"\x00", off)
    return data[off:end].decode("ascii", "replace")

vas = {
    "show_fmt": 0xFFFFFF80096B9701,
    "show_func": 0xFFFFFF80096925F6,
    "read_banner": 0xFFFFFF80095F3EEF,
    "read_line": 0xFFFFFF800952D7F3,
    "write_banner": 0xFFFFFF8009607E5A,
    "write_line": 0xFFFFFF8009590792,
}
for name, va in vas.items():
    off = va - BASE
    print(f"{name} file {off:#x}: {cstr(off)!r}")

store = struct.pack("<Q", 0xFFFFFF8008E18F6C)
show = struct.pack("<Q", 0xFFFFFF8008E18EE8)
print("store hits", [hex(i) for i in range(len(data)) if data.startswith(store, i)][:8])
idx = 0
while True:
    i = data.find(store, idx)
    if i < 0:
        break
    window = data[max(0, i - 32):i + 8]
    print(f"\nstore ptr at file {i:#x}")
    print(window.hex())
    # name pointer is often 24 bytes before store (show at -8, mode/name before that)
    for back in (24, 32, 40, 16):
        if i >= back:
            name_va = struct.unpack_from("<Q", data, i - back)[0]
            if BASE <= name_va < BASE + len(data) + 0x2000000:
                noff = name_va - BASE
                if 0 <= noff < len(data):
                    print(f"  -{back} -> {cstr(noff)!r}")
    idx = i + 1

# attribute group name
name = b"es8311_debug\x00"
j = data.find(name)
print("\ndebug name file", hex(j) if j >= 0 else None)
ptr = struct.pack("<Q", BASE + j) if j >= 0 else b""
if ptr:
    k = 0
    n = 0
    while n < 6:
        i = data.find(ptr, k)
        if i < 0:
            break
        print(f"name ptr at {i:#x} next 24 {data[i:i+24].hex()}")
        k = i + 1
        n += 1
