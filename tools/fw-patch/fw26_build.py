# Build DMR003.FW26.V022 on the FW25 image. FW25 is not rebuilt from source:
# this pass only retargets five sites and fills the zero tail FW25 left.
#
# Free tail, measured on DMR003.FW25.V022 before any byte here was written:
# file length 0x5C6FC (378620), last nonzero byte at 0x5C462, 664 bytes free
# from 0x5C464 through 0x5C6FB. The old 1,788-byte zero_tail at 0x05AEFC is
# already the M17 and FW21-FW25 stubs. 664 bytes holds the four stubs below.
#
# Static confirms, read from fw1_csky_objdump.txt and checked against the
# FW25 image before the patch:
#   Gates 0xC1BA and 0xC244 are still bsr 0x2404. 0xA890 is still bsr 0x90b0.
#   The exact-match store is still andi r2,15 at 0x17E26 and st.w at 0x17E2A.
#   0x1832e loads 0x11000390 and extracts bit 22 (lsri 22, andi 1) and bits
#   21:20 (lsri 20, andi 3) into the sync accumulator at 0x4C7BC. It does not
#   extract colour code or slot. No load of that register extracts bits 7:4
#   or bit 19. Bits 3:2 are extracted at 0x2628E, which matches the manual's
#   recv_sync_type. Patch D therefore uses the spec's own masks: colour code
#   (word >> 4) & 15, slot (word >> 19) & 1.
#
# The flag byte is IRAM 0x4B364. Startup zeroes IRAM from 0x31AF4 to 0x4DAB0,
# and 0x4B364 sits in the unnamed gap after the tone queue (0x4B080-0x4B360)
# and before the next factory name (0x4B398). It is 0 at boot, so every stub
# is the stock path until op 15 writes it. Nothing here keys, and nothing
# runs at boot beyond the redirected calls, which return the stock result
# while the flag is 0.
import struct
import subprocess
from pathlib import Path

import fw23_build

AS = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-as.exe")
LD = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-ld.bfd.exe")
NM = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe")
HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw26")
BASE = 0x5C464
FILE_END = 0x5C6FC
FLAG = 0x4B364
GATE_PATCH = 0x5B7DE
GATE_BYTES = bytes.fromhex("0e3b5108")  # cmphsi r3, 15; bt .Lpass
ADMIT_SITES = (0xC1BA, 0xC244)
FINISH_SITE = 0xA890
CC_SITE = 0x17E26
CC_STORE = 0x17E2A


def encode_bsr(at, target):
    return fw23_build.encode_bsr(at, target)


def decode_bsr(at, word):
    hi, lo = struct.unpack_from("<HH", word)
    raw = (hi << 16) | lo
    disp = raw & 0x3FFFFFF
    if disp & 0x2000000:
        disp -= 0x4000000
    return at + (disp << 1)


ASM = r"""
	.text
	.global	fw26_gate
	.global	fw26_admit
	.global	fw26_finish
	.global	fw26_ccbit

/* Replaces cmphsi r3, 15; bt .Lpass inside fw21_ops. r3 is the opcode,
 * r6 is the return into the sr=1 prologue, r7 is the frame, r15 returns
 * to cmpnei r3, 8. Opcode 15 answers itself. Anything above 15 takes the
 * same sr=1 path the old branch took. */
fw26_gate:
	cmphsi	r3, 16
	bt	.Lpass
	cmphsi	r3, 15
	bf	.Lback
	ld.b	r0, (r7, 6)
	ld.b	r1, (r7, 7)
	lsli	r0, r0, 8
	or	r0, r1
	cmpnei	r0, 2
	bt	.Lreject
	ld.b	r0, (r7, 9)
	cmpnei	r0, 0
	bf	.Lok
	cmpnei	r0, 1
	bt	.Lreject
.Lok:
	lrw	r4, 0x4b364
	st.b	r0, (r4, 0)
	lrw	r4, 0x4ae00
	movi	r1, 104
	st.b	r1, (r4, 0)
	ld.b	r1, (r7, 1)
	st.b	r1, (r4, 1)
	movi	r1, 0
	st.b	r1, (r4, 2)
	st.b	r1, (r4, 3)
	st.b	r1, (r4, 4)
	st.b	r1, (r4, 5)
	st.b	r1, (r4, 6)
	movi	r1, 1
	st.b	r1, (r4, 7)
	st.b	r0, (r4, 8)
	movi	r1, 16
	st.b	r1, (r4, 9)
	movi	r0, 10
	mov	r1, r4
	.short	0xE000, 0x8E5C
	mov	r0, r4
	movi	r1, 10
	.short	0xE000, 0x7DE8
	addi	r14, 4
	pop	r4-r7, r15
.Lreject:
	ld.b	r0, (r7, 1)
	mov	r15, r6
	jmp	r15
.Lpass:
	ld.b	r0, (r7, 1)
	mov	r15, r6
	jmp	r15
.Lback:
	jmp	r15

/* The two admit gates. r0 comes back from the real getter. A zero becomes
 * 1 only while the flag is on. r3 is already dead across that call. */
fw26_admit:
	push	r15
	.short	0xE000, 0x2404
	cmpnei	r0, 0
	bt	.Lkeep
	lrw	r3, 0x4b364
	ld.b	r3, (r3, 0)
	cmpnei	r3, 1
	bt	.Lzero
	movi	r0, 1
	br	.Lkeep
.Lzero:
	movi	r0, 0
.Lkeep:
	pop	r15

/* Replaces the bsr reply_build at 0xA890. r0 cmd, r1 sr, r2 body, r3 is
 * already 9 and the nine body bytes are already stored. Append colour
 * code and slot only while the flag is on, then tail through reply_build. */
fw26_finish:
	lrw	r12, 0x4b364
	ld.b	r12, (r12, 0)
	cmpnei	r12, 1
	bt	.Lgo
	lrw	r12, 0x11000390
	ld.w	r12, (r12, 0)
	lsri	r13, r12, 4
	andi	r13, r13, 15
	st.b	r13, (r2, 9)
	lsri	r12, r12, 19
	andi	r12, r12, 1
	st.b	r12, (r2, 10)
	movi	r3, 11
.Lgo:
	/* Tail call. reply_build's pop jumps to the r15 it saved, so a bsr
	 * here would return onto the next instruction with r15 already equal
	 * to that instruction. A jmp keeps the caller's return address. */
	lrw	r12, 0x030230b0
	jmp	r12

/* Replaces andi r2, r2, 15 at the exact-match LOCAL_CC store. The st.w
 * that follows is left in place and stores whatever r2 this returns. */
fw26_ccbit:
	subi	r14, 4
	st.w	r12, (r14, 0)
	andi	r2, r2, 15
	lrw	r12, 0x4b364
	ld.b	r12, (r12, 0)
	cmpnei	r12, 1
	bt	.Lout
	bseti	r2, 8
.Lout:
	ld.w	r12, (r14, 0)
	addi	r14, 4
	jmp	r15

	.align	2
	.literals
"""


def assemble():
    OUT.mkdir(parents=True, exist_ok=True)
    src = OUT / "fw26.S"
    src.write_text(ASM, encoding="utf-8")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "fw26.o"), str(src)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % BASE, "-o", str(OUT / "fw26.elf"), str(OUT / "fw26.o")])
    code, addr = fw23_build.text_of((OUT / "fw26.elf").read_bytes())
    if addr != BASE:
        raise SystemExit("linked at %X" % addr)
    names = subprocess.check_output([str(NM), str(OUT / "fw26.elf")], text=True)
    sym = {}
    for line in names.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[1] in ("T", "t"):
            sym[parts[2]] = int(parts[0], 16)
    placeholders = (
        ("getter", bytes.fromhex("00e00424"), 0x2404, 1),
        ("cksum", bytes.fromhex("00e05c8e"), 0x8E5C, 1),
        ("uart", bytes.fromhex("00e0e87d"), 0x7DE8, 1),
    )
    for label, token, target, expect in placeholders:
        at = 0
        n = 0
        while True:
            found = code.find(token, at)
            if found < 0:
                break
            code[found:found + 4] = encode_bsr(BASE + found, target)
            n += 1
            at = found + 4
        if n != expect:
            raise SystemExit("%s patched %d, expected %d" % (label, n, expect))
    if BASE + len(code) > FILE_END:
        raise SystemExit("stubs use %d, free %d" % (len(code), FILE_END - BASE))
    return code, sym


def main():
    fw23_build.main()
    fw25 = (ROOT / "radio_firmware" / "build" / "DMR003.FW25.V022.bin").read_bytes()
    stock = (ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
    if fw25[0x38464:0x38474] != b"DMR003.FW25.V022":
        raise SystemExit("FW25 tag " + fw25[0x38464:0x38474].decode())
    if len(fw25) != FILE_END:
        raise SystemExit("FW25 length %X" % len(fw25))
    if fw25[GATE_PATCH:GATE_PATCH + 4] != GATE_BYTES:
        raise SystemExit("ops gate is %s" % fw25[GATE_PATCH:GATE_PATCH + 4].hex())
    for off in ADMIT_SITES:
        if fw25[off:off + 4] != stock[off:off + 4]:
            raise SystemExit("gate %X moved" % off)
        if decode_bsr(off, fw25[off:off + 4]) != 0x2404:
            raise SystemExit("gate %X is not bsr 0x2404" % off)
    if fw25[FINISH_SITE:FINISH_SITE + 4] != stock[FINISH_SITE:FINISH_SITE + 4]:
        raise SystemExit("0xA890 moved")
    if decode_bsr(FINISH_SITE, fw25[FINISH_SITE:FINISH_SITE + 4]) != 0x90B0:
        raise SystemExit("0xA890 is not reply_build")
    if fw25[CC_SITE:CC_SITE + 4] != stock[CC_SITE:CC_SITE + 4]:
        raise SystemExit("0x17E26 moved")
    if fw25[CC_STORE:CC_STORE + 2] != stock[CC_STORE:CC_STORE + 2]:
        raise SystemExit("0x17E2A moved")
    if fw25[BASE:FILE_END] != bytes(FILE_END - BASE):
        raise SystemExit("tail is not empty")
    if FLAG.to_bytes(4, "little") in fw25:
        raise SystemExit("flag address already named")
    code, sym = assemble()
    img = bytearray(fw25)
    img[0x38464:0x38474] = b"DMR003.FW26.V022"
    img[GATE_PATCH:GATE_PATCH + 4] = encode_bsr(GATE_PATCH, sym["fw26_gate"])
    for off in ADMIT_SITES:
        img[off:off + 4] = encode_bsr(off, sym["fw26_admit"])
    img[FINISH_SITE:FINISH_SITE + 4] = encode_bsr(FINISH_SITE, sym["fw26_finish"])
    img[CC_SITE:CC_SITE + 4] = encode_bsr(CC_SITE, sym["fw26_ccbit"])
    img[BASE:BASE + len(code)] = code
    if struct.pack("<I", 0x11000560) in code:
        raise SystemExit("stubs mention PTT")
    if img[CC_STORE:CC_STORE + 2] != fw25[CC_STORE:CC_STORE + 2]:
        raise SystemExit("exact-match store was overwritten")
    dest = ROOT / "radio_firmware" / "build" / "DMR003.FW26.V022.bin"
    dest.write_bytes(img)
    import hashlib
    print("stubs", len(code), "free", FILE_END - BASE, "end", hex(BASE + len(code)))
    for name in ("fw26_gate", "fw26_admit", "fw26_finish", "fw26_ccbit"):
        print(name, hex(sym[name]))
    print(dest)
    print(hashlib.sha256(img).hexdigest())
    return dest


if __name__ == "__main__":
    main()
