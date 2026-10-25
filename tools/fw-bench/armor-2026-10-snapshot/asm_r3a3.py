# Assemble c7000_txram_dmr.S, fill the raw bsr halfwords, print the image hex.
# Host only. Does not load or transmit.
import struct, subprocess, sys
from pathlib import Path

BIN = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin")
AS = BIN / "csky-elfabiv2-as.exe"
LD = BIN / "csky-elfabiv2-ld.exe"
OBJCOPY = BIN / "csky-elfabiv2-objcopy.exe"
NM = BIN / "csky-elfabiv2-nm.exe"
OBJDUMP = BIN / "csky-elfabiv2-objdump.exe"
SRC = Path(r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch\stubs\c7000_txram_dmr.S")
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
FAC = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin")
LINK = 0x5B000
AT1846 = 0xFD011220
E9C = 0xE9C

# (symbol, flat target that bsr32_target(file_pc) must return)
CALLS = [
    ("b_e9c_key", E9C),
    ("b_at_4006", AT1846),
    ("b_at_4026", AT1846),
    ("b_at_bcfd", AT1846),
    ("b_e9c_unkey", E9C),
    ("b_at_8405", AT1846),
    ("b_at_7026", AT1846),
]


def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        sys.stderr.write(r.stdout + r.stderr)
        raise SystemExit("failed: " + " ".join(str(c) for c in cmd))
    return r.stdout


def encode_bsr(pc, target):
    disp = (target - pc) & 0xFFFFFFFF
    sdisp = disp - 0x100000000 if disp & 0x80000000 else disp
    if sdisp % 2 or not -(1 << 26) <= sdisp < (1 << 26):
        raise SystemExit("disp out of range pc=0x%X tgt=0x%X sdisp=%d" % (pc, target, sdisp))
    field = (sdisp >> 1) & 0x3FFFFFF
    word = (0b111000 << 26) | field
    return struct.pack("<HH", (word >> 16) & 0xFFFF, word & 0xFFFF)


def bsr32_target(buf, at):
    hi, lo = struct.unpack_from("<HH", buf, at)
    word = (hi << 16) | lo
    if word >> 26 != 0b111000:
        raise SystemExit("not a bsr at 0x%X: %08X" % (at, word))
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    return (at + off) & 0xFFFFFFFF


def main():
    # The proof stub's known encoding, from file 0x5B002.
    proof = encode_bsr(0x5B002, AT1846)
    if proof != bytes.fromhex("7de20fb1"):
        raise SystemExit("encoder mismatch: " + proof.hex())
    fac = FAC.read_bytes()
    if bsr32_target(fac, 0x3074) != AT1846:
        raise SystemExit("factory 0x3074 is not the AT1846S write")
    for site in (0x92AA, 0x92C8, 0x92E0, 0x92FA):
        if bsr32_target(fac, site) != E9C:
            raise SystemExit("factory 0x%X is not bsr 0xe9c" % site)

    o = HERE / "r3a3.o"
    elf = HERE / "r3a3.elf"
    raw = HERE / "r3a3.bin"
    run([str(AS), "-mcpu=ck803", "-o", str(o), str(SRC)])
    run([str(LD), "-Ttext=0x%X" % LINK, "-o", str(elf), str(o)])
    run([str(OBJCOPY), "-O", "binary", "-j", ".text", str(elf), str(raw)])
    text = run([str(NM), "-n", str(elf)])
    sym = {}
    for line in text.splitlines():
        parts = line.split()
        if len(parts) >= 3:
            sym[parts[2]] = int(parts[0], 16)
    print(text)
    blob = bytearray(raw.read_bytes())
    print("objcopy len", len(blob), "on_key", hex(sym["on_key"]))
    base = sym["on_key"]
    if base != LINK:
        raise SystemExit("on_key linked at 0x%X" % base)
    # objcopy may prefix zeros up to the VMA. The linked VMA is the file offset.
    if len(blob) > 0x800 and blob[:16] == bytes(16):
        code = blob[base:]
        origin = base
    else:
        code = blob
        origin = base
    if origin != LINK or code[:2] == bytes(2):
        # Accept either layout, but the first halfword must be the push.
        pass
    # If the binary starts at VMA 0, code is blob[LINK:]. If it starts at the
    # section, code is blob and addresses are LINK + index.
    if len(blob) >= LINK + 4 and blob[LINK:LINK + 2] != bytes(2):
        image_at = LINK  # index == file offset
        code = blob
    else:
        image_at = 0  # index 0 == file offset LINK
        code = blob
        if sym["on_key"] != LINK:
            raise SystemExit("unexpected link")
    def at(name):
        addr = sym[name]
        if image_at == LINK:
            return addr
        return addr - LINK

    stub = bytearray(code if image_at == 0 else code[LINK:])
    # Re-slice cleanly.
    if image_at == LINK:
        stub = bytearray(blob[LINK:LINK + (max(sym.values()) - LINK + 64)])
        # trim later; we only own the linked text. Use the whole tail of blob.
        stub = bytearray(blob[LINK:])
        def file_off(name):
            return sym[name]
        def idx(name):
            return sym[name] - LINK
    else:
        stub = bytearray(blob)
        def file_off(name):
            return sym[name]
        def idx(name):
            return sym[name] - LINK

    for name, tgt in CALLS:
        i = idx(name)
        pc = file_off(name)
        stub[i:i + 4] = encode_bsr(pc, tgt)
        got = bsr32_target(stub, i) if image_at == 0 else bsr32_target(stub, i)
        # bsr32_target treats the buffer index as the PC. Our stub buffer
        # starts at file offset LINK, so decode with a prefix of LINK zeros
        # only when the buffer itself is the tail. Do it on a full image view.
    view = bytearray(fac)
    # place stub at LINK for decoding
    # trim stub to the last symbol's pool: nm max may be a pool word.
    # Use the objcopy length.
    if image_at == LINK:
        placed = blob[LINK:]
    else:
        placed = bytes(stub)
    # The calls were patched into `stub`, which aliases `placed` only if we
    # patched the same object. Rebuild view from stub.
    view[LINK:LINK + len(stub)] = stub
    for name, tgt in CALLS:
        pc = file_off(name)
        got = bsr32_target(view, pc)
        if got != tgt:
            raise SystemExit("%s pc=0x%X decoded 0x%X wanted 0x%X" % (name, pc, got, tgt))
        print("%s pc=0x%X -> 0x%X" % (name, pc, got))

    # Handler sites.
    on_unkey = sym["on_unkey"]
    sites = {0x92C8: LINK, 0x92E0: LINK, 0x92AA: on_unkey, 0x92FA: on_unkey}
    for pc, tgt in sites.items():
        enc = encode_bsr(pc, tgt)
        got = bsr32_target(enc, 0)
        # decode with PC = 0 is wrong. Check by planting into view.
        view[pc:pc + 4] = enc
        got = bsr32_target(view, pc)
        if got != tgt:
            raise SystemExit("site 0x%X -> 0x%X wanted 0x%X" % (pc, got, tgt))
        print("site 0x%X factory %s -> %s target 0x%X" % (pc, fac[pc:pc + 4].hex(), enc.hex(), got))

    end = max(sym[n] for n, _ in CALLS) + 4
    # include the trailing pool: first non-text is whatever objdump says.
    # Take bytes from LINK through the end of the objcopy image.
    if image_at == LINK:
        text_len = len(blob) - LINK
    else:
        text_len = len(blob)
    # Drop trailing zeros that are past the real pool, but keep pool zeros
    # that are inside. The factory tail is already zero, so the patch length
    # is the distance from LINK to the last nonzero byte, rounded up to cover
    # the pool. Use objdump to see the size.
    dump = run([str(OBJDUMP), "-d", str(elf)])
    (HERE / "r3a3.dis").write_text(dump, encoding="utf-8")
    last = LINK
    for line in dump.splitlines():
        line = line.strip()
        if not line or line.startswith("Disassembly") or line.endswith(":"):
            continue
        try:
            addr = int(line.split(":")[0], 16)
        except ValueError:
            continue
        last = max(last, addr)
    # The last instruction is 2 or 4 bytes, then the pool follows it. The pool
    # is in the binary. Find the last nonzero stub byte.
    stub_bytes = bytes(view[LINK:LINK + text_len])
    last_nz = max(i for i, b in enumerate(stub_bytes) if b) + 1
    # Pools are word aligned and may end with a nonzero literal. Include it.
    # Round up to a halfword.
    if last_nz & 1:
        last_nz += 1
    stub_bytes = stub_bytes[:last_nz]
    if any(b != 0 for b in fac[LINK:LINK + last_nz]):
        raise SystemExit("factory tail at 0x%X is not zero" % LINK)
    if LINK + last_nz > len(fac):
        raise SystemExit("stub does not fit")
    print("stub bytes", last_nz, "on_unkey", hex(on_unkey))
    print(stub_bytes.hex())
    (HERE / "r3a3_stub.bin").write_bytes(stub_bytes)
    # 3AA4 is bseti r2, 4 and must not appear.
    if b"\xa4\x3a" in stub_bytes:
        raise SystemExit("bit 4 set is in the stub")
    print("no bseti bit 4")


if __name__ == "__main__":
    main()
