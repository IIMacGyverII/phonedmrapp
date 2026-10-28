# One FW3B change group on the accepted FW29 image.
# Groups: ram, refuse, op7, setend, guard, refill.
import hashlib
import struct
from pathlib import Path

import fw30_build
import fw30_port

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "radio_firmware" / "build"
FW29 = BUILD / "DMR003.FW29.V022.bin"
TAG = range(0x38464, 0x38474)
STUB = 0x5BD74
XIP = 0x0301A000
ARM29 = 0x4B00C
FLAG29 = 0x4DAAC

GROUPS = ("ram", "refuse", "op7", "setend", "guard", "refill")


def _tag(name):
    n = GROUPS.index(name) + 1
    text = ("DMR003.B3G%d.V022" % n).encode()
    if len(text) != 16:
        raise SystemExit("tag %s" % text)
    return text


def _base():
    img = bytearray(FW29.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW29.V022":
        raise SystemExit("FW29 tag")
    return img


def _put(img, asm, name):
    code = fw30_build._linked(asm, STUB, name)
    if STUB + len(code) > 0x5BE34:
        raise SystemExit("%s spills %d" % (name, len(code)))
    img[STUB:STUB + len(code)] = code
    return code


def build(name):
    if name not in GROUPS:
        raise SystemExit(name)
    img = _base()
    if name == "ram":
        fw30_port.relocate(img)
    elif name == "refuse":
        _put(img, """
	.text
	.global refuse
refuse:
	push	r15
	ld.b	r0, (r7, 1)
	movi	r1, 1
	lrw	r4, 0x8E7C
	jsr	r4
	pop	r15
""", "b3refuse")
        img[0x5BCC4:0x5BCC8] = fw30_build.encode_bsr(0x5BCC4, STUB)
        img[0x5BCCA:0x5BCCE] = fw30_build.encode_bsr(0x5BCCA, STUB)
    elif name == "op7":
        _put(img, """
	.text
	.global op7
op7:
	lrw	r4, 0x34808
	ld.b	r4, (r4, 0)
	bez	r4, reject
	lrw	r4, 0x%x
	movi	r1, 1
	st.w	r1, (r4, 0)
	lrw	r4, 0x%x
	jmp	r4
reject:
	lrw	r4, 0x%x
	jmp	r4
""" % (ARM29, XIP + 0x5AF52, XIP + 0x5AFC8), "b3op7")
        img[0x5AF4C:0x5AF50] = fw30_build.encode_bsr(0x5AF4C, STUB)
        img[0x5AF50:0x5AF52] = b"\x00\x00"
    elif name == "setend":
        _put(img, """
	.text
	.global setend
setend:
	push	r4, r15
	lrw	r3, 0x%x
	movi	r2, 1
	st.b	r2, (r3, 0)
	movi	r2, 165
	st.b	r2, (r3, 1)
	lrw	r4, 0x%x
	jsr	r4
	pop	r4, r15
""" % (FLAG29, XIP + 0x5B65A), "b3setend")
        img[0x5B748:0x5B74C] = fw30_build.encode_bsr(0x5B748, STUB)
    elif name == "guard":
        _put(img, """
	.text
	.global guard
guard:
	lrw	r3, 0x%x
	ld.b	r2, (r3, 0)
	cmpnei	r2, 1
	bt	cont
	ld.b	r2, (r3, 1)
	cmpnei	r2, 165
	bt	cont
	cmpnei	r0, 1
	bt	cont
	movi	r2, 0
	st.b	r2, (r3, 0)
	st.b	r2, (r3, 1)
	movi	r0, 0
cont:
	zextb	r4, r0
	mov	r0, r14
	lrw	r3, 0x%x
	jmp	r3
""" % (FLAG29, XIP + 0x37FC), "b3guard")
        img[0x37F8:0x37FC] = fw30_build.encode_bsr(0x37F8, STUB)
    elif name == "refill":
        code = fw30_build._linked("""
	.text
	.global clear
	.global pre
clear:
	push	r4, r15
	subi	r14, r14, 16
	st.w	r0, (r14, 0)
	st.w	r1, (r14, 4)
	st.w	r2, (r14, 8)
	st.w	r3, (r14, 12)
	lrw	r2, 0x%x
	ld.w	r3, (r2, 0)
	lrw	r1, 0x%x
	cmpne	r3, r1
	bf	.Ldone
	lrw	r3, 0x%x
.Lzero:
	movi	r4, 0
	st.w	r4, (r3, 0)
	addi	r3, 4
	cmphs	r3, r2
	bf	.Lzero
	st.w	r1, (r2, 0)
.Ldone:
	ld.w	r0, (r14, 0)
	ld.w	r1, (r14, 4)
	ld.w	r2, (r14, 8)
	ld.w	r3, (r14, 12)
	addi	r14, r14, 16
	pop	r4, r15
pre:
	push	r15
	.long	0xA5A5A5A1
	.long	0xA5A5A5A2
	pop	r15
""" % (fw30_port.MAGIC_AT, fw30_port.CLEAR_MAGIC, fw30_port.CLEAR_LO), STUB, "b3refill")
        if STUB + len(code) > 0x5BE34:
            raise SystemExit("refill spills")
        img[STUB:STUB + len(code)] = code
        syms = fw30_port._symbols("b3refill")
        pre = syms["pre"]
        img[pre + 2:pre + 6] = fw30_build.encode_bsr(pre + 2, syms["clear"])
        img[pre + 6:pre + 10] = fw30_build.encode_bsr(pre + 6, 0x5B4D0)
        img[0x18B68:0x18B6C] = fw30_build.encode_bsr(0x18B68, pre)
    img[TAG.start:TAG.stop] = _tag(name)
    if img[0x35F64:0x35FE4] != _base()[0x35F64:0x35FE4]:
        raise SystemExit("data table")
    blob = bytes(img)
    dest = BUILD / ("DMR003.B3G%d.V022.bin" % (GROUPS.index(name) + 1))
    dest.write_bytes(blob)
    print(name, dest.name, hashlib.sha256(blob).hexdigest())
    return blob


ONESHOT = 0x4B376  # only op 17's lrw at 0x5BDC0 names this word


def build_fw3d():
    """FW29 plus the five fixes. No RAM move and no zeroing."""
    fac = (ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
    img = _base()
    code = fw30_build._linked("""
	.text
	.global refuse
	.global op7
	.global setend
	.global guard
refuse:
	push	r15
	ld.b	r0, (r7, 1)
	movi	r1, 1
	lrw	r4, 0x8E7C
	jsr	r4
	pop	r15
op7:
	lrw	r4, 0x34808
	ld.b	r4, (r4, 0)
	bez	r4, reject
	lrw	r4, 0x%x
	movi	r1, 1
	st.w	r1, (r4, 0)
	lrw	r4, 0x%x
	jmp	r4
reject:
	lrw	r4, 0x%x
	jmp	r4
setend:
	push	r4, r15
	lrw	r3, 0x%x
	movi	r2, 1
	st.b	r2, (r3, 0)
	movi	r2, 165
	st.b	r2, (r3, 1)
	lrw	r4, 0x%x
	jsr	r4
	pop	r4, r15
guard:
	lrw	r3, 0x%x
	ld.b	r2, (r3, 0)
	cmpnei	r2, 1
	bt	cont
	ld.b	r2, (r3, 1)
	cmpnei	r2, 165
	bt	cont
	cmpnei	r0, 1
	bt	cont
	movi	r2, 0
	st.b	r2, (r3, 0)
	st.b	r2, (r3, 1)
	movi	r0, 0
cont:
	zextb	r4, r0
	mov	r0, r14
	lrw	r3, 0x%x
	jmp	r3
""" % (ARM29, XIP + 0x5AF52, XIP + 0x5AFC8, ONESHOT, XIP + 0x5B65A,
       ONESHOT, XIP + 0x37FC), STUB, "fw3d")
    if STUB + len(code) > 0x5BE34:
        raise SystemExit("fw3d spills %d" % len(code))
    img[STUB:STUB + len(code)] = code
    syms = fw30_port._symbols("fw3d")
    img[0x5BCC4:0x5BCC8] = fw30_build.encode_bsr(0x5BCC4, syms["refuse"])
    img[0x5BCCA:0x5BCCE] = fw30_build.encode_bsr(0x5BCCA, syms["refuse"])
    img[0x5AF4C:0x5AF50] = fw30_build.encode_bsr(0x5AF4C, syms["op7"])
    img[0x5AF50:0x5AF52] = b"\x00\x00"
    img[0x5B748:0x5B74C] = fw30_build.encode_bsr(0x5B748, syms["setend"])
    img[0x37F8:0x37FC] = fw30_build.encode_bsr(0x37F8, syms["guard"])
    img[0x18B5C:0x18B60] = fac[0x18B5C:0x18B60]
    if img[0x37F4:0x37F8] != fac[0x37F4:0x37F8]:
        raise SystemExit("prologue")
    if img[0x18B68:0x18B6C] != FW29.read_bytes()[0x18B68:0x18B6C]:
        raise SystemExit("refill hook changed")
    if img[0x35F64:0x35FE4] != _base()[0x35F64:0x35FE4]:
        raise SystemExit("data table")
    img[TAG.start:TAG.stop] = b"DMR003.FW3D.V022"
    blob = bytes(img)
    if struct.pack("<I", ONESHOT) not in blob[STUB:STUB + len(code)]:
        raise SystemExit("one-shot missing")
    dest = BUILD / "DMR003.FW3D.V022.bin"
    dest.write_bytes(blob)
    print("fw3d", len(code), hashlib.sha256(blob).hexdigest())
    return blob


def build_fw3c():
    """FW3B with 0x18B68 restored to FW29's direct refill call."""
    import fw30_port
    fw30_port.build()
    img = bytearray((BUILD / "DMR003.FW3B.V022.bin").read_bytes())
    fw29 = FW29.read_bytes()
    img[0x18B68:0x18B6C] = fw29[0x18B68:0x18B6C]
    if fw30_build.bsr_target(img, 0x18B68) != 0x5B4D0:
        raise SystemExit("refill not restored")
    img[TAG.start:TAG.stop] = b"DMR003.FW3C.V022"
    blob = bytes(img)
    dest = BUILD / "DMR003.FW3C.V022.bin"
    dest.write_bytes(blob)
    print("fw3c", hashlib.sha256(blob).hexdigest())
    return blob


def build_fw3e():
    """FW3D with the FM setup called only when the ring is armed."""
    src = BUILD / "DMR003.FW3D.V022.bin"
    if not src.is_file():
        build_fw3d()
    img = bytearray(src.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW3D.V022":
        raise SystemExit("FW3D tag")
    if fw30_build.bsr_target(img, 0x5B58E) != 0x5BBE2:
        raise SystemExit("setup call moved")
    gate_at = 0x5BDEC
    code = fw30_build._linked("""
	.text
	.global gate
gate:
	lrw	r2, 0x4A3E4
	ld.w	r3, (r2, 0)
	ld.w	r1, (r2, 4)
	cmphs	r1, r3
	bt	empty
	push	r15
	.long	0xA5A5A5A1
	pop	r15
empty:
	pop	r4-r7, r15
""", gate_at, "fw3egate")
    if gate_at + len(code) > 0x5BE34:
        raise SystemExit("gate spills")
    img[gate_at:gate_at + len(code)] = code
    slot = gate_at + code.find(bytes.fromhex("a1a5a5a5"))
    img[slot:slot + 4] = fw30_build.encode_bsr(slot, 0x5BBE2)
    img[0x5B58E:0x5B592] = fw30_build.encode_bsr(0x5B58E, gate_at)
    if fw30_build.bsr_target(img, 0x5B58E) != gate_at:
        raise SystemExit("gate not called")
    if fw30_build.bsr_target(img, slot) != 0x5BBE2:
        raise SystemExit("setup not called")
    img[TAG.start:TAG.stop] = b"DMR003.FW3E.V022"
    blob = bytes(img)
    dest = BUILD / "DMR003.FW3E.V022.bin"
    dest.write_bytes(blob)
    print("fw3e", len(code), hashlib.sha256(blob).hexdigest())
    return blob


def build_tx_group(name):
    """FW3E with one extra-hook group restored. E3G1 setend, E3G2 UART pend, E3G3 promiscuous."""
    groups = {
        "E3G1": (("fw29", (0x5B748,)),),
        "E3G2": (("fac", (0x7C56,)),),
        "E3G3": (("fac", (0xA890, 0xC1BA, 0xC244, 0x17E26)),),
    }
    if name not in groups:
        raise SystemExit(name)
    src = BUILD / "DMR003.FW3E.V022.bin"
    if not src.is_file():
        build_fw3e()
    fac = (ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
    fw29 = FW29.read_bytes()
    img = bytearray(src.read_bytes())
    pools = {"fac": fac, "fw29": fw29}
    for which, sites in groups[name]:
        for at in sites:
            img[at:at + 4] = pools[which][at:at + 4]
    text = ("DMR003.%s.V022" % name).encode()
    if len(text) != 16:
        raise SystemExit("tag len")
    img[TAG.start:TAG.stop] = text
    blob = bytes(img)
    dest = BUILD / ("DMR003.%s.V022.bin" % name)
    dest.write_bytes(blob)
    print(name, hashlib.sha256(blob).hexdigest())
    return blob


# Word only the op 17 tail named (its saved return at 0x5BE0C). The one-shot
# uses the two bytes at 0x4B376. Startup zeroes this word, so a plain key
# sees it clear until a symbol or tone op sets it.
FLAG3F = 0x4B378
APPEND_XIP = XIP + 0x5AF52


def build_fw3f():
    """FW3E, but the FM setup runs only when the stub's own flag is set."""
    src = BUILD / "DMR003.FW3E.V022.bin"
    if not src.is_file():
        build_fw3e()
    img = bytearray(src.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW3E.V022":
        raise SystemExit("FW3E tag")
    if fw30_build.bsr_target(img, 0x5B58E) != 0x5BDEC:
        raise SystemExit("gate call moved")
    code = fw30_build._linked("""
	.text
	.global gate
	.global empty
	.global armst
	.global setjmp
	.global setpop
	.global clrunkey
gate:
	lrw	r2, 0x4b378
	ld.w	r3, (r2, 0)
	bez	r3, empty
	push	r15
	.long	0xA5A5A5A1
	pop	r15
empty:
	pop	r4-r7, r15
armst:
	st.w	r1, (r4, 0)
setjmp:
	lrw	r4, 0x4b378
	movi	r1, 1
	st.w	r1, (r4, 0)
	lrw	r4, 0x3074f52
	jmp	r4
setpop:
	lrw	r4, 0x4b378
	movi	r3, 1
	st.w	r3, (r4, 0)
	movi	r0, 0
	pop	r15
clrunkey:
	lrw	r4, 0x4b378
	movi	r2, 0
	st.w	r2, (r4, 0)
	lrw	r2, 0x4daac
	ld.w	r2, (r2, 0)
	jmp	r15
""", 0x5BDEC, "fw3f")
    end = 0x5BDEC + len(code)
    if end > 0x5BE34:
        raise SystemExit("fw3f spills to %X" % end)
    syms = fw30_port._symbols("fw3f")
    slot = 0x5BDEC + code.find(bytes.fromhex("a1a5a5a5"))
    code = bytearray(code)
    code[slot - 0x5BDEC:slot - 0x5BDEC + 4] = fw30_build.encode_bsr(slot, 0x5BBE2)
    img[0x5BDEC:end] = code
    if fw30_build.bsr_target(img, slot) != 0x5BBE2:
        raise SystemExit("setup call")
    if end < 0x5BE34:
        img[end:0x5BE34] = bytes(0x5BE34 - end)
    # Op 7's FM accept jumps here, which sets the flag and then appends.
    img[0x5BDD8:0x5BDDC] = struct.pack("<I", XIP + syms["setjmp"])
    def plant(at, expect, dest):
        if img[at:at + len(expect)] != expect:
            raise SystemExit("site %X is %s" % (at, img[at:at + len(expect)].hex()))
        img[at:at + 4] = fw30_build.encode_bsr(at, dest)
    # Op 1 already has r4 = 0x4B00C and r1 = 0. armst stores that, then sets
    # the flag and joins the append. Op 7 sets the flag via its new jump.
    plant(0x5AF44, bytes.fromhex("20b40604"), syms["armst"])
    for at in (0x5B91C, 0x5B97C, 0x5BA52):
        plant(at, bytes.fromhex("00309014"), syms["setpop"])
    plant(0x5B616, bytes.fromhex("5f104092"), syms["clrunkey"])
    # The drop at 0x5B65A does not come through this unkey. Its clear would
    # need a pool past the live literals at 0x5BE34. The host's 0x26 unkey
    # follows the drop and clears the flag there.
    if img[0x5BE34:0x5BE3C] != src.read_bytes()[0x5BE34:0x5BE3C]:
        raise SystemExit("live pool")
    if struct.pack("<I", APPEND_XIP) not in img[0x5BDEC:0x5BE34]:
        raise SystemExit("append literal")
    if struct.pack("<I", FLAG3F) not in img[0x5BDEC:0x5BE34]:
        raise SystemExit("flag literal")
    img[TAG.start:TAG.stop] = b"DMR003.FW3F.V022"
    blob = bytes(img)
    dest = BUILD / "DMR003.FW3F.V022.bin"
    dest.write_bytes(blob)
    print("fw3f", len(code), hashlib.sha256(blob).hexdigest())
    return blob


FLAG3H = 0x4BE64


def build_fw3h():
    """FW3F with the flag word moved to 0x4BE64."""
    src = BUILD / "DMR003.FW3F.V022.bin"
    if not src.is_file():
        build_fw3f()
    img = bytearray(src.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW3F.V022":
        raise SystemExit("FW3F tag")
    pool = 0x5BE20
    if img[pool:pool + 4] != struct.pack("<I", FLAG3F):
        raise SystemExit("flag pool")
    img[pool:pool + 4] = struct.pack("<I", FLAG3H)
    # 0x5BE48 still holds 0x4B378 for the op 17 tail this image overwrote.
    if img[0x5BE48:0x5BE4C] != struct.pack("<I", FLAG3F):
        raise SystemExit("orphan moved")
    img[TAG.start:TAG.stop] = b"DMR003.FW3H.V022"
    blob = bytes(img)
    dest = BUILD / "DMR003.FW3H.V022.bin"
    dest.write_bytes(blob)
    print("fw3h", hashlib.sha256(blob).hexdigest())
    return blob


def build_fw3j():
    """FW3H with the stub's two flag sets removed."""
    src = BUILD / "DMR003.FW3H.V022.bin"
    if not src.is_file():
        build_fw3h()
    img = bytearray(src.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW3H.V022":
        raise SystemExit("FW3H tag")
    nop = bytes.fromhex("036c")
    if img[0x5BE04:0x5BE06] != bytes.fromhex("20b4"):
        raise SystemExit("setjmp store")
    if img[0x5BE0E:0x5BE10] != bytes.fromhex("60b4"):
        raise SystemExit("setpop store")
    img[0x5BE04:0x5BE06] = nop
    img[0x5BE0E:0x5BE10] = nop
    img[TAG.start:TAG.stop] = b"DMR003.FW3J.V022"
    blob = bytes(img)
    dest = BUILD / "DMR003.FW3J.V022.bin"
    dest.write_bytes(blob)
    print("fw3j", hashlib.sha256(blob).hexdigest())
    return blob


def build_fw3i():
    """FW3H whose gate always takes the skip path."""
    src = BUILD / "DMR003.FW3H.V022.bin"
    if not src.is_file():
        build_fw3h()
    img = bytearray(src.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW3H.V022":
        raise SystemExit("FW3H tag")
    # br from 0x5BDEC to the skip pop at 0x5BDFC. Same encoding as the
    # stock br at 0x5AF46 (displacement in halfwords, opcode 0x04).
    dest = 0x5BDFC
    disp = (dest - 0x5BDEC) >> 1
    img[0x5BDEC:0x5BDEE] = bytes((disp & 0xFF, 0x04))
    img[TAG.start:TAG.stop] = b"DMR003.FW3I.V022"
    blob = bytes(img)
    out = BUILD / "DMR003.FW3I.V022.bin"
    out.write_bytes(blob)
    print("fw3i", hashlib.sha256(blob).hexdigest())
    return blob


def build_fw3g():
    """FW3E whose key wrapper returns and never calls the FM setup."""
    src = BUILD / "DMR003.FW3E.V022.bin"
    if not src.is_file():
        build_fw3e()
    img = bytearray(src.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW3E.V022":
        raise SystemExit("FW3E tag")
    if img[0x5B5EE:0x5B5F0] != bytes.fromhex("9414"):
        raise SystemExit("pop encoding")
    # F30F's empty ring falls into this pop. Two of them, so a fall-through
    # still returns and the writes at 0x5B592 do not run.
    img[0x5B58E:0x5B592] = bytes.fromhex("94149414")
    img[TAG.start:TAG.stop] = b"DMR003.FW3G.V022"
    blob = bytes(img)
    dest = BUILD / "DMR003.FW3G.V022.bin"
    dest.write_bytes(blob)
    print("fw3g", hashlib.sha256(blob).hexdigest())
    return blob


if __name__ == "__main__":
    for name in ("E3G1", "E3G2", "E3G3"):
        build_tx_group(name)
