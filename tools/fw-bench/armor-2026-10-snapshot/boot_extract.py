"""Extract the gzip kernel from boot_a and note es8311 strings. Read-only."""
import gzip
import struct

src = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\boot_a.img"
dst = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\kernel.img"
blob = open(src, "rb").read()
print("boot", len(blob), blob[:8])
kernel_size = struct.unpack_from("<I", blob, 8)[0]
print("kernel_size", kernel_size, hex(kernel_size))
chunk = blob[2048:2048 + kernel_size]
print("chunk_head", chunk[:8].hex(), "chunk_len", len(chunk))
data = gzip.decompress(chunk)
open(dst, "wb").write(data)
print("decomp", len(data))
print("arm64_magic", data[0x38:0x3C])
text_offset, image_size, flags = struct.unpack_from("<QQQ", data, 8)
print("text_offset", hex(text_offset), "image_size", hex(image_size), "flags", hex(flags))
for name in (b"es8311_store", b"es8311_show", b"es8311_debug", b"kallsyms_names"):
    positions = []
    start = 0
    while True:
        i = data.find(name, start)
        if i < 0 or len(positions) >= 8:
            break
        positions.append(i)
        start = i + 1
    print(name.decode(), positions)
