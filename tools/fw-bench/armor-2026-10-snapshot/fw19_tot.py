"""Assemble the 0x3B ceiling stub and append c7000-tot-120 to patches.toml."""
import struct
import subprocess
from pathlib import Path

BIN = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin")
AS, LD, OD = (BIN / "csky-elfabiv2-as.exe", BIN / "csky-elfabiv2-ld.bfd.exe",
              BIN / "csky-elfabiv2-objdump.exe")
SRC = Path(r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch\stubs\c7000_tot120.S")
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw19")
FAC = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin")
TOML = Path(r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch\patches.toml")
XIP = 0x0301A000
BASE = 0x5B700
THUNK = 0xAB18
HANDLER = 0xA308
MARKER = bytes.fromhex("00e008a3")


def text_of(data, base):
    e_shoff = struct.unpack_from("<I", data, 32)[0]
    e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHH", data, 46)

    def shdr(i):
        return struct.unpack_from("<IIIIIIIIII", data, e_shoff + i * e_shentsize)

    str_off = shdr(e_shstrndx)[4]
    for i in range(e_shnum):
        name_off, _, _, addr, off, size = shdr(i)[:6]
        name = data[str_off + name_off:data.index(b"\x00", str_off + name_off)].decode()
        if name == ".text":
            if addr != base:
                raise SystemExit("text at 0x%X" % addr)
            return bytearray(data[off:off + size])
    raise SystemExit("no text")


def encode_bsr(file_at, runtime_target):
    disp = (runtime_target - (XIP + file_at)) & 0xFFFFFFFF
    if disp >= 0x80000000:
        disp -= 0x100000000
    word = (0b111000 << 26) | ((disp >> 1) & 0x3FFFFFF)
    return ((word >> 16) & 0xFFFF).to_bytes(2, "little") + (word & 0xFFFF).to_bytes(2, "little")


def landed(code, at, file_at):
    hi = int.from_bytes(code[at:at + 2], "little")
    lo = int.from_bytes(code[at + 2:at + 4], "little")
    word = (hi << 16) | lo
    if word >> 26 != 0b111000:
        raise SystemExit("not a bsr at +%X: %08X" % (at, word))
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    return (file_at + off) & 0xFFFFFFFF


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "tot.o"), str(SRC)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % BASE, "-o", str(OUT / "tot.elf"), str(OUT / "tot.o")])
    code = text_of((OUT / "tot.elf").read_bytes(), BASE)
    j = code.find(MARKER)
    if j < 0 or code.count(MARKER) != 1:
        raise SystemExit("marker %s" % code.hex())
    code[j:j + 4] = encode_bsr(BASE + j, XIP + HANDLER)
    if landed(code, j, BASE + j) != HANDLER:
        raise SystemExit("handler bsr -> 0x%X" % landed(code, j, BASE + j))
    fac = FAC.read_bytes()
    if fac[BASE:BASE + len(code)] != bytes(len(code)):
        raise SystemExit("gap at 0x%X is not %d zeros" % (BASE, len(code)))
    thunk = encode_bsr(THUNK, XIP + BASE)
    if landed(thunk, 0, THUNK) != BASE:
        raise SystemExit("thunk bsr -> 0x%X" % landed(thunk, 0, THUNK))
    orig = fac[THUNK:THUNK + 4]
    # Stock bsr at the thunk must still be the one that calls +0xA308.
    if landed(orig, 0, THUNK) != HANDLER:
        raise SystemExit("factory thunk does not call the handler: %s" % orig.hex())
    raw = TOML.read_bytes()
    if b"\r" in raw or b"c7000-tot-120" in raw:
        raise SystemExit("toml")
    at = raw.find(b"\n# R3-0.")
    if at < 0:
        raise SystemExit("no R3-0 marker")
    block = (
        "\n# FW19. Command 0x3B stores 120 when the body is 0 or above 120, then the stock handler.\n"
        "[patches.c7000-tot-120]\n"
        "why = \"\"\"The 0x3B handler stores the body byte and, when the byte is 0, clears the enable\n"
        "flag. It does not clamp. The radio task stops a transmission after 100 wakes per stored\n"
        "unit, and a unit is one second. This stub writes 120 into a body of 0 or of more than 120\n"
        "and then calls that handler, so the ceiling is 120 s and a 0 still arms it. It does not key\n"
        "at boot. 0x3D is not changed.\"\"\"\n"
        "measured_by = \"not measured\"\n"
        "status = \"experimental\"\n"
        "sites = [\n"
        "  { offset = 0x%X, original = \"%s\", replacement = \"%s\", note = \"0x3B thunk bsr: ceiling stub at +0x%X\" },\n"
        "  { offset = 0x%X, original = \"%s\", replacement = \"%s\", note = \"0x3B ceiling stub (stubs/c7000_tot120.S)\" },\n"
        "]\n"
    ) % (THUNK, orig.hex(), thunk.hex(), BASE, BASE, bytes(len(code)).hex(), code.hex())
    if b"\r" in block.encode():
        raise SystemExit("block cr")
    TOML.write_bytes(raw[:at] + block.encode() + raw[at:])
    listing = subprocess.check_output([str(OD), "-d", "-m", "csky", "-EL", str(OUT / "tot.elf")], text=True, errors="replace")
    (OUT / "tot.lst").write_text(listing, encoding="utf-8")
    print("stub %d bytes at 0x%X" % (len(code), BASE))
    print(code.hex())
    print(listing)


if __name__ == "__main__":
    main()
