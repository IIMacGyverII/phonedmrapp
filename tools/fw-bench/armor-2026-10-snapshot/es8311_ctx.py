"""Dump the bytes around the es8311 rodata / symbol strings."""
data = open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\kernel.img", "rb").read()

def dump(off, n=256):
    print(f"\n==== {off:#x} ====")
    chunk = data[off:off + n]
    for i in range(0, len(chunk), 32):
        row = chunk[i:i + 32]
        text = "".join(chr(b) if 32 <= b < 127 else "." for b in row)
        print(f"{off+i:08x}  {text}")

dump(0x16125C0, 192)
dump(0x1639680, 160)
dump(0x15EA3C0, 128)
dump(0x1485A40, 96)
