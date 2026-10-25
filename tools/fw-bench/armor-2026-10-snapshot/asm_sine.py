"""Assemble c7000_txram_dmr_sine.S, fill the bsr placeholders, print the stub."""
import struct
import subprocess
from pathlib import Path

BIN = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin")
AS = BIN / "csky-elfabiv2-as.exe"
LD = BIN / "csky-elfabiv2-ld.bfd.exe"
OBJDUMP = BIN / "csky-elfabiv2-objdump.exe"
SRC = Path(r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch\stubs\c7000_txram_dmr_sine.S")
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\sine")
BASE = 0x5B000
PLACE = bytes.fromhex("00e00000")
TARGETS = [0xE9C, 0xFD011220, 0xFD011220, 0xFD011220, 0xE9C, 0xFD011220, 0xFD011220]


def encode_bsr(at, target):
    disp = (target - at) & 0xFFFFFFFF
    sdisp = disp - 0x100000000 if disp >= 0x80000000 else disp
    if sdisp < -(1 << 26) or sdisp >= (1 << 26) or sdisp & 1:
        raise SystemExit(f"bsr at {at:#x} -> {target:#x} disp {sdisp:#x} out of range")
    field = (sdisp >> 1) & 0x3FFFFFF
    word = 0xE0000000 | field
    hi = (word >> 16) & 0xFFFF
    lo = word & 0xFFFF
    return hi.to_bytes(2, "little") + lo.to_bytes(2, "little")


def text_span(data: bytes):
    if data[:4] != b"\x7fELF":
        raise SystemExit("not an elf")
    e_shoff = struct.unpack_from("<I", data, 32)[0]
    e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHH", data, 46)

    def shdr(i):
        off = e_shoff + i * e_shentsize
        return struct.unpack_from("<IIIIIIIIII", data, off)

    str_off = shdr(e_shstrndx)[4]
    for i in range(e_shnum):
        name_off, _, _, addr, off, size = shdr(i)[:6]
        name = data[str_off + name_off:data.index(b"\x00", str_off + name_off)].decode()
        if name == ".text":
            return addr, off, size
    raise SystemExit("no .text")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    obj = OUT / "sine.o"
    elf = OUT / "sine.elf"
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(obj), str(SRC)])
    subprocess.check_call([str(LD), "-Ttext=0x5B000", "-o", str(elf), str(obj)])
    raw = bytearray(elf.read_bytes())
    addr, file_off, size = text_span(raw)
    if addr != BASE:
        raise SystemExit(f".text at {addr:#x}")
    code = bytearray(raw[file_off:file_off + size])
    found = []
    i = 0
    while True:
        j = code.find(PLACE, i)
        if j < 0:
            break
        found.append(j)
        i = j + 4
    if len(found) != len(TARGETS):
        raise SystemExit(f"placeholders {len(found)} != {len(TARGETS)}")
    for off, tgt in zip(found, TARGETS):
        code[off:off + 4] = encode_bsr(BASE + off, tgt)
    # The measured R3a3 encodings must fall out of the same encoder.
    known = {
        0x5B002: 0xE9C,
        0x5B04E: 0xFD011220,
        0x5B08A: 0xE9C,
        0x5B0A2: 0xFD011220,
    }
    import sys
    sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
    import build
    from test_patches import bsr32_disp, bsr32_target
    img, _ = build.build(["c7000-txram-dmr"], "R3a3", build.load())
    for at, tgt in known.items():
        enc = encode_bsr(at, tgt)
        if img[at:at + 4] != enc:
            raise SystemExit(f"encoder mismatch at {at:#x}: {enc.hex()} != {img[at:at+4].hex()}")
    for off, tgt in zip(found, TARGETS):
        at = BASE + off
        # check via a throwaway image slice
        probe = bytes(code)
        if bsr32_target(probe, off) != tgt and bsr32_target(probe, off) != (tgt & 0xFFFFFFFF):
            # bsr32_target uses the offset inside the buffer as the PC.
            # Our buffer starts at BASE, so pass a padded view.
            pass
    padded = bytearray(BASE) + code
    for off, tgt in zip(found, TARGETS):
        got = bsr32_target(padded, BASE + off)
        if got != tgt:
            raise SystemExit(f"decoded {got:#x} != {tgt:#x} at {BASE+off:#x}")
    raw[file_off:file_off + size] = code
    elf.write_bytes(raw)
    (OUT / "sine.bin").write_bytes(code)
    (OUT / "sine.hex").write_text(code.hex(), encoding="ascii")
    print("len", len(code), "end", hex(BASE + len(code)))
    print("placeholders", [hex(BASE + o) for o in found])
    print(code.hex())
    subprocess.check_call([str(OBJDUMP), "-d", str(elf)])


if __name__ == "__main__":
    main()
