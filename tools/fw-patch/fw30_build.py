# Build DMR003.FW30.V022 from FW29. The file does not grow.
# Image 4 adds the save and restore on top of image 3c.
#
# A symbol-engine key leaves the AT1846S at 0x30 = 0x4026 (bit 5 already
# set) and drop_ptt then writes only 0x30 = 0x7026. The analog channel
# tune writes 0x7006 and then 0x7026, so bit 5 falls and rises. That edge
# is what at1846_rx_on does (set bit 5) after at1846_rx_off clears it.
# RSSI keeps moving without it; the phone's receive audio does not.
# The 0x58 write that used to sit in those bytes is dropped: the key
# already stored 0xBCFD, which is the value an M17 channel holds, and a
# lone 0x58 rewrite was measured not to bring the audio back.
# WORK_MODE stays 0x80 after that edge, and the first image (the 0x30
# pair only) left receive audio muted. The stock voice unkey writes the
# saved WORK_MODE back; this path never saved it. The drop keeps the
# address of the TX-RAM bit (0x11000080) in r4, which the i2c write and
# the status post preserve, and the eight free bytes at 0x5B718 add 0x80
# and store 0x6E at 0x11000100, the analog channel's WORK_MODE.
# Image 3b adds opcode 18, a read of one AT1846S register. The 128 zero
# bytes at 0x35F64 are the tail of a live data table (image 3 did not
# boot). The stub sits at the start of opcode 17. Opcodes 16 and 17
# answer sr=1, so FW30 drops the parked receive-RAM stream. The gate's
# upper compare becomes 19. The literal pool at 0x5BE34 stays.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw23_build

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "radio_firmware" / "build"
FW29 = BUILD / "DMR003.FW29.V022.bin"
DEST = BUILD / "DMR003.FW30.V022.bin"
TAG = range(0x38464, 0x38474)
# drop_ptt's 0x58 = 0x8405 write, immediately before 0x30 = 0x7026.
PAIR = 0x5B66A
# Eight zero bytes between the time-out clamp and the symbol-engine gate.
HOLE = 0x5B718
# The literal 0x1100039C. The lrw that names it shifts by two bytes.
POOL_39C = 0x5B694
# Opcode 18 replaces the start of opcode 17. The pool the gate and the
# mode-5 path load begins at 0x5BE34, so the stub has to end before it.
READ_AT = 0x5BD74
POOL = 0x5BE34
GATE_CMP = 0x5BCBC
GATE_OP = 0x5BCC0
DONE = 0x5BCD6
# The read path only. Each path used to end with jmp r15, but r15 is the
# return from the send, so that jmp never left the stub. Return through r6,
# which the dispatcher saved before it called the gate. The two checksum
# and send calls in the failure path shift by the two bytes inserted on
# the success path.
_READ_PATH = bytes.fromhex(
    "098724eaae04884cc7381e0800e075f3436d683120a4218721a4003122a423a4"
    "24a425a426a4023127a4a8a4284d29a410312aa40b30536cfee35b97136c0b31"
    "fee31d8f3c78683120a4218721a4003122a4013123a4003124a425a426a427a4"
    "103128a40930536cfee34397136c0931fee3058f3c78"
)
# The 4 bytes at offset 0x0C are not a bsr. They become lrw r1 / jsr r1,
# and the literal is the IRAM entry of the read (file +0x54664).
_READ_CALLS = ((0x38, 0x8E5C), (0x40, 0x7DE8), (0x6A, 0x8E5C), (0x72, 0x7DE8))
IRAM_READ = 0x0002B25C
IRAM_WRITE = 0x0002B220
READ_POOL = 0x5BDFC
# Four words the factory image does not name, after the stream bytes at
# 0x4B380 and before the next named word at 0x4B398.
SAVE_RAM = 0x4B388
# on_key's stock call. The save runs first and then makes this call.
STOCK_KEY = 0xE9C
SAVE_HOOK = 0x5B582
SAVE_AT = 0x5BFA0
# The two timeout stores and the following pop stay the end of the drop.
RESTORE_HOOK = 0x5B76E
RESTORE_AT = 0x5BE00
# 0x5BE34 is a live literal pool. 0x5BFF2 is a branch target of code this
# image still contains, so the save stub stops before it.
SAVE_END = 0x5BFF2
RESTORE_END = 0x5BE34
AS = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-as.exe")
LD = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-ld.bfd.exe")
_SAVE_ASM = """
	.text
	.global	save4
save4:
	push	r4-r6, r15
	mov	r4, r0
	mov	r5, r1
	lrw	r6, 0x2b25c
	movi	r0, 48
	jsr	r6
	lrw	r1, 0x4b388
	st.w	r0, (r1, 0)
	movi	r0, 65
	jsr	r6
	lrw	r1, 0x4b388
	st.w	r0, (r1, 4)
	movi	r0, 88
	jsr	r6
	lrw	r1, 0x4b388
	st.w	r0, (r1, 8)
	movi	r0, 89
	jsr	r6
	lrw	r1, 0x4b388
	st.w	r0, (r1, 12)
	mov	r0, r4
	mov	r1, r5
	.short	0xE000, 0x0E9C
	pop	r4-r6, r15
"""
_RESTORE_ASM = """
	.text
	.global	restore4
restore4:
	st.b	r2, (r4, 4)
	st.b	r2, (r4, 5)
	push	r4-r6, r15
	lrw	r6, 0x2b220
	lrw	r5, 0x4b388
	movi	r0, 48
	ld.w	r1, (r5, 0)
	jsr	r6
	movi	r0, 65
	ld.w	r1, (r5, 4)
	jsr	r6
	movi	r0, 88
	ld.w	r1, (r5, 8)
	jsr	r6
	movi	r0, 89
	ld.w	r1, (r5, 12)
	jsr	r6
	pop	r4-r6, r15
"""


def bsr_target(blob, at):
    hi, lo = struct.unpack_from("<HH", blob, at)
    disp = ((hi << 16) | lo) & 0x3FFFFFF
    if disp & (1 << 25):
        disp -= 1 << 26
    return at + (disp << 1)


def encode_bsr(at, target):
    disp = (target - at) >> 1
    word = (0b111000 << 26) | (disp & 0x3FFFFFF)
    return struct.pack("<HH", (word >> 16) & 0xFFFF, word & 0xFFFF)


def encode_lrw_r1(at, pool):
    # r1's lrw is based at the instruction. r3's, in encode_lrw_r3, is not.
    if at & 3:
        raise SystemExit("lrw r1 at %X" % at)
    imm = (pool - at) // 4
    if not 0 <= imm <= 31 or at + imm * 4 != pool:
        raise SystemExit("lrw r1 from %X to %X" % (at, pool))
    return struct.pack("<H", 0x1020 + imm)


def encode_br(at, target):
    disp = (target - at) >> 1
    if not -32768 <= disp <= 32767:
        raise SystemExit("br from %X to %X" % (at, target))
    return struct.pack("<HH", 0xE800, disp & 0xFFFF)


def read_stub():
    stub = bytearray(_READ_PATH)
    ends = [i for i in range(len(stub) - 1) if stub[i:i + 2] == bytes.fromhex("3c78")]
    if ends != [0x44, 0x74]:
        raise SystemExit("return sites %s" % [hex(i) for i in ends])
    for i in reversed(ends):
        stub[i:i] = bytes.fromhex("db6f")
    # The failure path starts two bytes later once the success return grew.
    stub[0x0A:0x0C] = bytes.fromhex("1f08")
    for off, dest in _READ_CALLS:
        stub[off:off + 4] = encode_bsr(READ_AT + off, dest)
    call = READ_AT + 0x0C
    stub[0x0C:0x0E] = encode_lrw_r1(call, READ_POOL)
    stub[0x0E:0x10] = bytes.fromhex("c57b")  # jsr r1
    return bytes(stub)


def refuse_stub(at):
    """Opcodes 16 and 17: sr=1 through the normal ack, then the dispatcher's return."""
    body = bytearray(bytes.fromhex("01870131"))
    body += encode_bsr(at + 4, 0x8E7C)
    body += bytes.fromhex("db6f3c78")
    return bytes(body)


def encode_lrw_r3(at, target):
    base = (at + 2 + 3) & ~3
    imm = (target - base) // 4
    if not 0 <= imm <= 31:
        raise SystemExit("lrw from %X to %X" % (at, target))
    return struct.pack("<H", 0x1061 + imm)


def _linked(asm, base, name):
    out = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30")
    out.mkdir(parents=True, exist_ok=True)
    src = out / ("%s.S" % name)
    src.write_text(asm, encoding="utf-8")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(out / ("%s.o" % name)), str(src)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % base, "-o", str(out / ("%s.elf" % name)),
                           str(out / ("%s.o" % name))])
    code, addr = fw23_build.text_of((out / ("%s.elf" % name)).read_bytes())
    if addr != base:
        raise SystemExit("%s linked at %X" % (name, addr))
    return code


def save_restore():
    save = _linked(_SAVE_ASM, SAVE_AT, "save4")
    token = bytes.fromhex("00e09c0e")
    at = save.find(token)
    if at < 0 or save.find(token, at + 4) >= 0:
        raise SystemExit("stock call placeholder")
    save[at:at + 4] = encode_bsr(SAVE_AT + at, STOCK_KEY)
    restore = _linked(_RESTORE_ASM, RESTORE_AT, "restore4")
    if SAVE_AT + len(save) > SAVE_END:
        raise SystemExit("save stub reaches %X" % (SAVE_AT + len(save)))
    if RESTORE_AT + len(restore) > RESTORE_END:
        raise SystemExit("restore stub reaches %X" % (RESTORE_AT + len(restore)))
    return save, restore


def build():
    base = bytearray(FW29.read_bytes())
    if base[TAG.start:TAG.stop] != b"DMR003.FW29.V022":
        raise SystemExit("FW29 tag")
    if base[HOLE:HOLE + 8] != b"\x00" * 8:
        raise SystemExit("hole not empty")
    # movi r0, 48; movi r1, 0x7006. The following instructions write 0x7026.
    base[PAIR:PAIR + 2] = bytes.fromhex("3030")
    base[PAIR + 2:PAIR + 6] = bytes.fromhex("01ea0670")
    # r3 is 0x11000080 here, before the calls. Keep it in r4 (callee-saved).
    # The two padding bytes after the pop absorb the shift, so the pool stays.
    i2c = bsr_target(base, 0x5B670)
    i2c2 = bsr_target(base, 0x5B67A)
    status = bsr_target(base, 0x5B688)
    if i2c != i2c2:
        raise SystemExit("i2c targets differ")
    chunk = bytes(base[PAIR:0x5B68E])
    base[PAIR:PAIR + 2] = bytes.fromhex("0f6d")          # mov r4, r3
    base[PAIR + 2:0x5B690] = chunk
    # The shifted calls name the same places.
    base[0x5B672:0x5B676] = encode_bsr(0x5B672, i2c)
    base[0x5B67C:0x5B680] = encode_bsr(0x5B67C, i2c)
    base[0x5B680:0x5B682] = encode_lrw_r3(0x5B680, POOL_39C)
    base[0x5B68A:0x5B68E] = encode_bsr(0x5B68A, status)
    # br to the hole, which adds 0x80 and stores WORK_MODE 0x6E, then returns.
    base[0x5B68E:0x5B690] = bytes.fromhex("4504")
    base[HOLE:HOLE + 8] = bytes.fromhex("7f246e3240b49414")
    if bsr_target(base, 0x5B672) != i2c or bsr_target(base, 0x5B68A) != status:
        raise SystemExit("bsr retarget")
    stub = read_stub()
    if READ_AT + len(stub) > POOL:
        raise SystemExit("read stub hits the pool")
    if base[GATE_CMP:GATE_CMP + 2] != bytes.fromhex("113b"):
        raise SystemExit("gate compare")
    if base[GATE_OP:GATE_OP + 2] != bytes.fromhex("503b"):
        raise SystemExit("gate opcode compare")
    kept = bytes(base[0x35DF4:0x35FE4])
    # cmphsi r3, 19. Opcode 18 reads. Opcodes 16 and 17 ack sr=1.
    # 0x5C584 is not that ack: it calls the dispatcher again.
    refuse_at = READ_AT + len(stub)
    refuse = refuse_stub(refuse_at)
    if refuse_at + len(refuse) > POOL:
        raise SystemExit("refuse stub hits the pool")
    base[GATE_CMP:GATE_CMP + 2] = bytes.fromhex("123b")
    op = bytearray()
    op += bytes.fromhex("523b0408")
    op += encode_bsr(GATE_OP + 4, READ_AT)
    op += bytes.fromhex("0704")
    op += encode_br(GATE_OP + 10, refuse_at)
    if len(op) != 14:
        raise SystemExit("gate op %d" % len(op))
    base[GATE_OP:GATE_OP + 14] = op
    base[READ_AT:READ_AT + len(stub)] = stub
    base[refuse_at:refuse_at + len(refuse)] = refuse
    if READ_POOL < refuse_at + len(refuse) or READ_POOL + 4 > POOL:
        raise SystemExit("read literal")
    base[READ_POOL:READ_POOL + 4] = struct.pack("<I", IRAM_READ)
    if bsr_target(base, GATE_OP + 4) != READ_AT:
        raise SystemExit("read call")
    if bsr_target(base, refuse_at + 4) != 0x8E7C:
        raise SystemExit("refuse ack")
    if base[0x35DF4:0x35FE4] != kept:
        raise SystemExit("data table was written")
    save, restore = save_restore()
    base[SAVE_AT:SAVE_AT + len(save)] = save
    base[RESTORE_AT:RESTORE_AT + len(restore)] = restore
    base[SAVE_HOOK:SAVE_HOOK + 4] = encode_bsr(SAVE_HOOK, SAVE_AT)
    base[RESTORE_HOOK:RESTORE_HOOK + 4] = encode_bsr(RESTORE_HOOK, RESTORE_AT)
    if bsr_target(base, SAVE_HOOK) != SAVE_AT:
        raise SystemExit("save hook")
    if bsr_target(base, RESTORE_HOOK) != RESTORE_AT:
        raise SystemExit("restore hook")
    base[TAG.start:TAG.stop] = b"DMR003.FW30.V022"
    DEST.write_bytes(base)
    print(DEST)
    print(hashlib.sha256(base).hexdigest())
    return bytes(base)


if __name__ == "__main__":
    build()
