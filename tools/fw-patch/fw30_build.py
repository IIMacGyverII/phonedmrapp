# Build DMR003.FW30.V022 from FW29. The file does not grow.
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
# Image 3 adds opcode 18, a read of one AT1846S register, in the 128-byte
# hole at 0x35F64. The gate's upper compare becomes 19 and the old
# opcode-17 call branches here first.
import hashlib
import struct
from pathlib import Path

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
# Opcode 18 lives in the old data-table pad. Nothing branches there and
# nothing loads it. The gate compare is the byte that was cmphsi r3, 18.
READ_AT = 0x35F64
GATE_CMP = 0x5BCBC
GATE_CALL = 0x5BCCA
READ_STUB = bytes.fromhex(
    "513b040801e0062f3c78098724eaae04884cc7381e0800e075f3436d683120a4"
    "218721a4003122a423a424a425a426a4023127a4a8a4284d29a410312aa40b30"
    "536cfee35b97136c0b31fee31d8f3c78683120a4218721a4003122a4013123a4"
    "003124a425a426a427a4103128a40930536cfee34397136c0931fee3058f3c78"
)


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


def encode_lrw_r3(at, target):
    base = (at + 2 + 3) & ~3
    imm = (target - base) // 4
    if not 0 <= imm <= 31:
        raise SystemExit("lrw from %X to %X" % (at, target))
    return struct.pack("<H", 0x1061 + imm)


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
    if len(READ_STUB) != 128 or base[READ_AT:READ_AT + 128] != b"\x00" * 128:
        raise SystemExit("read stub hole")
    if base[GATE_CMP:GATE_CMP + 2] != bytes.fromhex("113b"):
        raise SystemExit("gate compare")
    # cmphsi r3, 19. Opcode 18 falls into the old opcode-17 call.
    base[GATE_CMP:GATE_CMP + 2] = bytes.fromhex("123b")
    base[GATE_CALL:GATE_CALL + 4] = encode_bsr(GATE_CALL, READ_AT)
    base[READ_AT:READ_AT + 128] = READ_STUB
    if bsr_target(base, GATE_CALL) != READ_AT:
        raise SystemExit("read call")
    base[TAG.start:TAG.stop] = b"DMR003.FW30.V022"
    DEST.write_bytes(base)
    print(DEST)
    print(hashlib.sha256(base).hexdigest())
    return bytes(base)


if __name__ == "__main__":
    build()
