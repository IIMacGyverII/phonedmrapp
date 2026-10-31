# Rebuild a DMR relay file so the voice header, every embedded LC and the
# terminator carry one destination. The decoder does not call the encoder.
#
# python tools/fw-bench/full_lc.py
import struct
import sys
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30")
import dmr_lc
import lc_check

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30")
ALL = 16777215

# QR(16,7) codewords, index = the 7 information bits. From MMDVM QR1676.
QR = (
    0x0000, 0x0273, 0x04E5, 0x0696, 0x09C9, 0x0BBA, 0x0D2C, 0x0F5F,
    0x11E2, 0x1391, 0x1507, 0x1774, 0x182B, 0x1A58, 0x1CCE, 0x1EBD,
    0x21B7, 0x23C4, 0x2552, 0x2721, 0x287E, 0x2A0D, 0x2C9B, 0x2EE8,
    0x3055, 0x3226, 0x34B0, 0x36C3, 0x399C, 0x3BEF, 0x3D79, 0x3F0A,
    0x411E, 0x436D, 0x45FB, 0x4788, 0x48D7, 0x4AA4, 0x4C32, 0x4E41,
    0x50FC, 0x528F, 0x5419, 0x566A, 0x5935, 0x5B46, 0x5DD0, 0x5FA3,
    0x60A9, 0x62DA, 0x644C, 0x663F, 0x6960, 0x6B13, 0x6D85, 0x6FF6,
    0x714B, 0x7338, 0x75AE, 0x77DD, 0x7882, 0x7AF1, 0x7C67, 0x7E14,
    0x804F, 0x823C, 0x84AA, 0x86D9, 0x8986, 0x8BF5, 0x8D63, 0x8F10,
    0x91AD, 0x93DE, 0x9548, 0x973B, 0x9864, 0x9A17, 0x9C81, 0x9EF2,
    0xA1F8, 0xA38B, 0xA51D, 0xA76E, 0xA831, 0xAA42, 0xACD4, 0xAEA7,
    0xB01A, 0xB269, 0xB4FF, 0xB68C, 0xB9D3, 0xBBA0, 0xBD36, 0xBF45,
    0xC151, 0xC322, 0xC5B4, 0xC7C7, 0xC898, 0xCAEB, 0xCC7D, 0xCE0E,
    0xD0B3, 0xD2C0, 0xD456, 0xD625, 0xD97A, 0xDB09, 0xDD9F, 0xDFEC,
    0xE0E6, 0xE295, 0xE403, 0xE670, 0xE92F, 0xEB5C, 0xEDCA, 0xEFB9,
    0xF104, 0xF377, 0xF5E1, 0xF792, 0xF8CD, 0xFABE, 0xFC28, 0xFE5B,
)


def show(n):
    if n in (0, 9, 99, ALL):
        return str(n)
    return "other"


def bits_be(byte):
    return [((byte >> k) & 1) == 1 for k in range(7, -1, -1)]


def byte_be(bits):
    v = 0
    for bit in bits:
        v = (v << 1) | (1 if bit else 0)
    return v


def ham16(d):
    """Correct a Hamming(16,11) row in place. False if it cannot."""
    c0 = d[0] ^ d[1] ^ d[2] ^ d[3] ^ d[5] ^ d[7] ^ d[8]
    c1 = d[1] ^ d[2] ^ d[3] ^ d[4] ^ d[6] ^ d[8] ^ d[9]
    c2 = d[2] ^ d[3] ^ d[4] ^ d[5] ^ d[7] ^ d[9] ^ d[10]
    c3 = d[0] ^ d[1] ^ d[2] ^ d[4] ^ d[6] ^ d[7] ^ d[10]
    c4 = d[0] ^ d[2] ^ d[5] ^ d[6] ^ d[8] ^ d[9] ^ d[10]
    n = 0
    n |= 0x01 if c0 != d[11] else 0
    n |= 0x02 if c1 != d[12] else 0
    n |= 0x04 if c2 != d[13] else 0
    n |= 0x08 if c3 != d[14] else 0
    n |= 0x10 if c4 != d[15] else 0
    fix = {0x01: 11, 0x02: 12, 0x04: 13, 0x08: 14, 0x10: 15,
           0x19: 0, 0x0B: 1, 0x1F: 2, 0x07: 3, 0x0E: 4, 0x15: 5,
           0x1A: 6, 0x0D: 7, 0x13: 8, 0x16: 9, 0x1C: 10, 0x00: None}
    if n not in fix:
        return False
    if fix[n] is not None:
        d[fix[n]] = not d[fix[n]]
    return True


def emb_of(burst):
    e0 = ((burst[13] << 4) & 0xF0) | ((burst[14] >> 4) & 0x0F)
    e1 = ((burst[18] << 4) & 0xF0) | ((burst[19] >> 4) & 0x0F)
    word = (e0 << 8) | e1
    best, dist = 0, 99
    for i, code in enumerate(QR):
        gap = bin(word ^ code).count("1")
        if gap < dist:
            best, dist = i, gap
    if dist > 3:
        return None
    return (best >> 3) & 0xF, (best >> 2) & 1, best & 3


def fragment_bits(burst):
    raw = []
    for b in burst[14:19]:
        raw.extend(bits_be(b))
    return raw[4:36]


def put_fragment(burst, raw32, cc, lcss):
    bits = [False] * 40
    bits[4:36] = raw32
    out = [byte_be(bits[i:i + 8]) for i in range(0, 40, 8)]
    burst[14] = (burst[14] & 0xF0) | (out[0] & 0x0F)
    burst[15] = out[1]
    burst[16] = out[2]
    burst[17] = out[3]
    burst[18] = (burst[18] & 0x0F) | (out[4] & 0xF0)
    value = ((cc & 0xF) << 3) | (0 << 2) | (lcss & 3)
    code = QR[value]
    e0, e1 = (code >> 8) & 0xFF, code & 0xFF
    burst[13] = (burst[13] & 0xF0) | ((e0 >> 4) & 0x0F)
    burst[14] = (burst[14] & 0x0F) | ((e0 << 4) & 0xF0)
    burst[18] = (burst[18] & 0xF0) | ((e1 >> 4) & 0x0F)
    burst[19] = (burst[19] & 0x0F) | ((e1 << 4) & 0xF0)


def encode_raw(nine):
    """128 column-packed bits for one LC. Encoder side."""
    data = []
    for byte in nine:
        data.extend(bits_be(byte))
    total = sum(nine) % 31
    block = [False] * 128
    b = 0
    spans = ((0, 11), (16, 27), (32, 42), (48, 58), (64, 74), (80, 90), (96, 106))
    for a0, a1 in spans:
        for a in range(a0, a1):
            block[a] = data[b]
            b += 1
    for bit, at in ((1, 106), (2, 90), (4, 74), (8, 58), (16, 42)):
        block[at] = (total & bit) != 0
    for a in range(0, 112, 16):
        d = block[a:a + 16]
        d[11] = d[0] ^ d[1] ^ d[2] ^ d[3] ^ d[5] ^ d[7] ^ d[8]
        d[12] = d[1] ^ d[2] ^ d[3] ^ d[4] ^ d[6] ^ d[8] ^ d[9]
        d[13] = d[2] ^ d[3] ^ d[4] ^ d[5] ^ d[7] ^ d[9] ^ d[10]
        d[14] = d[0] ^ d[1] ^ d[2] ^ d[4] ^ d[6] ^ d[7] ^ d[10]
        d[15] = d[0] ^ d[2] ^ d[5] ^ d[6] ^ d[8] ^ d[9] ^ d[10]
        block[a:a + 16] = d
    for a in range(16):
        block[a + 112] = block[a] ^ block[a + 16] ^ block[a + 32] ^ block[a + 48] ^ block[a + 64] ^ block[a + 80] ^ block[a + 96]
    raw = [False] * 128
    b = 0
    for a in range(128):
        raw[a] = block[b]
        b += 16
        if b > 127:
            b -= 127
    return raw


def decode_raw(raw):
    """9 LC bytes, or None. Does not call encode_raw."""
    data = [False] * 128
    b = 0
    for a in range(128):
        data[b] = raw[a]
        b += 16
        if b > 127:
            b -= 127
    for a in range(0, 112, 16):
        if not ham16(data[a:a + 16]):
            return None
        # ham16 mutates a copy; write it back
    # ham16 was given a slice copy. Re-do in place.
    for a in range(0, 112, 16):
        row = data[a:a + 16]
        if not ham16(row):
            return None
        data[a:a + 16] = row
    for a in range(16):
        parity = data[a] ^ data[a + 16] ^ data[a + 32] ^ data[a + 48] ^ data[a + 64] ^ data[a + 80] ^ data[a + 96] ^ data[a + 112]
        if parity:
            return None
    payload = []
    for a0, a1 in ((0, 11), (16, 27), (32, 42), (48, 58), (64, 74), (80, 90), (96, 106)):
        payload.extend(data[a0:a1])
    crc = 0
    if data[42]:
        crc += 16
    if data[58]:
        crc += 8
    if data[74]:
        crc += 4
    if data[90]:
        crc += 2
    if data[106]:
        crc += 1
    nine = bytes(byte_be(payload[i:i + 8]) for i in range(0, 72, 8))
    if sum(nine) % 31 != crc:
        return None
    return nine


def lc_fields(nine):
    flco = nine[0] & 0x3F
    fid = nine[1]
    options = nine[2]
    dst = int.from_bytes(nine[3:6], "big")
    src = int.from_bytes(nine[6:9], "big")
    return flco, fid, options, dst, src


def burst_of(packet):
    if len(packet) < 53 or packet[:4] != b"DMRD":
        return None
    return bytearray(packet[20:53])


def is_data(burst):
    sync = lc_check.bytes_of(lc_check.bits_of(burst)[108:156])
    return sync == lc_check.MS_DATA


def decode_file(path):
    pkts = lc_check.load(path)
    raw = []
    state = None
    found = []
    headers = []
    for ms, packet in pkts:
        burst = burst_of(packet)
        if burst is None or is_data(burst):
            if burst is not None and is_data(burst):
                _cc, dtype = lc_check.slot_dtype(burst)
                headers.append(dtype)
            state = None
            raw = []
            continue
        emb = emb_of(burst)
        if emb is None:
            state = None
            raw = []
            continue
        _cc, _pi, lcss = emb
        frag = fragment_bits(burst)
        if lcss == 1:
            raw = frag
            state = "first"
        elif lcss == 3 and state == "first":
            raw = raw + frag
            state = "second"
        elif lcss == 3 and state == "second":
            raw = raw + frag
            state = "third"
        elif lcss == 2 and state == "third":
            nine = decode_raw(raw + frag)
            if nine is not None:
                found.append((ms, lc_fields(nine)))
            state = None
            raw = []
        else:
            state = None
            raw = []
    return found, headers


def fragments_for(dst, src):
    nine = dmr_lc.group_lc(dst, src)
    # group_lc is 9 bytes with the source in the last three.
    raw = encode_raw(nine)
    out = []
    for n, lcss in enumerate((1, 3, 3, 2)):
        out.append((raw[n * 32:(n + 1) * 32], lcss))
    return out


def rewrite(src_path, dest_path, dst):
    pkts = lc_check.load(src_path)
    src = None
    for _ms, packet in pkts:
        if len(packet) >= 11 and packet[:4] == b"DMRD":
            src = int.from_bytes(packet[5:8], "big")
            break
    if src is None:
        raise SystemExit("no source")
    frags = fragments_for(dst, src)
    # Check the encoder against the decoder before touching the file.
    check = decode_raw(b"".join(bits for bits, _lcss in frags) if False else sum((list(bits) for bits, _ in frags), []))
    if check is None or lc_fields(check)[3] != dst:
        raise SystemExit("encoder did not round-trip inside the builder")
    built = bytearray()
    used = 0
    state = None
    idx = {"first": 0, "second": 1, "third": 2}
    for ms, packet in pkts:
        packet = bytearray(packet)
        burst = burst_of(packet)
        if burst is None:
            built += struct.pack(">IH", ms, len(packet)) + bytes(packet)
            continue
        if is_data(burst):
            _cc, dtype = lc_check.slot_dtype(burst)
            info = None
            if dtype == 1:
                info = dmr_lc.header_bits(dst, src)
            elif dtype == 2:
                info = dmr_lc.terminator_bits(dst, src)
            if info is not None:
                burst = bytearray(lc_check.splice(bytes(burst), info))
            state = None
        else:
            emb = emb_of(bytes(burst))
            lcss = None if emb is None else emb[2]
            which = None
            if lcss == 1:
                which = 0
                state = "first"
            elif lcss == 3 and state == "first":
                which = 1
                state = "second"
            elif lcss == 3 and state == "second":
                which = 2
                state = "third"
            elif lcss == 2 and state == "third":
                which = 3
                state = None
            else:
                state = None
            if which is not None:
                bits, lc = frags[which]
                put_fragment(burst, bits, 1, lc)
                used += 1
        if packet[:4] == b"DMRD" and len(packet) >= 11:
            packet[8:11] = dst.to_bytes(3, "big")
            packet[20:53] = burst
        built += struct.pack(">IH", ms, len(packet)) + bytes(packet)
    dest_path.write_bytes(built)
    return used, show(src)


def report(path):
    found, headers = decode_file(path)
    dests = {}
    flcos = {}
    for _ms, (flco, _fid, _opt, dst, _src) in found:
        key = show(dst)
        dests[key] = dests.get(key, 0) + 1
        flcos[flco] = flcos.get(flco, 0) + 1
    print(path.name, "embedded", len(found), "dests", dests, "flco", flcos, "data-types", headers)


def main():
    if len(QR) != 128:
        raise SystemExit("qr table %d" % len(QR))
    print("before")
    report(HERE / "dmr_tg99.bin")
    report(HERE / "dmr_allcall.bin")
    n99, _ = rewrite(HERE / "dmr_tg99.bin", HERE / "dmr_tg99_full.bin", 99)
    nall, _ = rewrite(HERE / "dmr_allcall.bin", HERE / "dmr_allcall_full.bin", ALL)
    # Same recording and source as the talkgroup 99 file, destination 9.
    n9, _ = rewrite(HERE / "dmr_tg99.bin", HERE / "dmr_tg9_full.bin", 9)
    print("rewrote fragments", n99, nall, n9)
    print("after")
    report(HERE / "dmr_tg99_full.bin")
    report(HERE / "dmr_allcall_full.bin")
    report(HERE / "dmr_tg9_full.bin")


if __name__ == "__main__":
    main()
