"""Tie dev_attr_es8311 to the es8311_debug attribute group."""
import struct

data = open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\kernel.img", "rb").read()
BASE = 0xFFFFFF8008080000
attr = BASE + 0x1A09FD0
needle = struct.pack("<Q", attr)
print("attr va", hex(attr))
idx = 0
while True:
    i = data.find(needle, idx)
    if i < 0:
        break
    print(f"attr ptr at file {i:#x}")
    # print a few following pointers
    for k in range(0, 24, 8):
        va = struct.unpack_from("<Q", data, i + k)[0]
        print(f"  +{k} {va:#x}")
    idx = i + 1

# Who points at an array that starts with this attr? Search nearby qwords after each hit.
# Also dump the attribute_group candidates that reference es8311_debug's address.
name_va = BASE + 0x16396F4
name_ptr = struct.pack("<Q", name_va)
idx = 0
print("debug-name va", hex(name_va))
while True:
    i = data.find(name_ptr, idx)
    if i < 0:
        break
    nxt = struct.unpack_from("<QQ", data, i + 8)
    print(f"name ptr file {i:#x} then {nxt[0]:#x} {nxt[1]:#x}")
    idx = i + 1
