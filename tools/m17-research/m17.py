"""M17 research modem (Python, for the radio feasibility study). Follows the M17 specification as implemented in
libm17 (frame layout, Golay(24,12) LICH, K=5 convolutional code with puncturing, QPP interleaver, randomizer, RRC 4FSK
at 4800 symbols/s, +-2.4 kHz). Encoder: LSF + stream frames + EOT. Decoder: works on the FM discriminator signal
(deviation in Hz at any sample rate): matched RRC, sync search, soft Viterbi, CRC/LICH checks."""
import numpy as np

SYM_RATE = 4800
DEV_PER_UNIT = 800.0                                         # symbol +3 -> +2400 Hz
SYMBOL_MAP = [+1, +3, -1, -3]                                # dibit -> symbol
SYNC_LSF, SYNC_STR, SYNC_PKT, SYNC_BER, EOT = 0x55F7, 0xFF5D, 0x75FF, 0xDF55, 0x555D
P1 = [1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1] + [1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1] * 2 + [1,0,1,1,1,0,1,1,1,0,1,1]
P2 = [1] * 11 + [0]
P3 = [1] * 7 + [0]
RAND = bytes([0xD6, 0xB5, 0xE2, 0x30, 0x82, 0xFF, 0x84, 0x62, 0xBA, 0x4E, 0x96, 0x90, 0xD8, 0x98, 0xDD, 0x5D, 0x0C, 0xC8, 0x52, 0x43, 0x91, 0x1D, 0xF8,
              0x6E, 0x68, 0x2F, 0x35, 0xDA, 0x14, 0xEA, 0xCD, 0x76, 0x19, 0x8D, 0xD5, 0x80, 0xD1, 0x33, 0x87, 0x13, 0x57, 0x18, 0x2D, 0x29, 0x78, 0xC3])
RAND_BITS = np.unpackbits(np.frombuffer(RAND, np.uint8))     # 368
INTRL = np.array([(45 * i + 92 * i * i) % 368 for i in range(368)])
GOLAY_ENC = [0x8eb, 0x93e, 0xa97, 0xdc6, 0x367, 0x6cd, 0xd99, 0x3da, 0x7b4, 0xf68, 0x63b, 0xc75]
CHARS = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-/."
assert len(P1) == 61

def crc16(data):
    crc = 0xFFFF
    for b in data:
        crc ^= b << 8
        for _ in range(8):
            crc <<= 1
            if crc & 0x10000: crc = (crc ^ 0x5935) & 0xFFFF
    return crc

def callsign(s):
    if s.upper() == '@ALL':
        return (0xFFFFFFFFFFFF).to_bytes(6, 'big')
    v = 0
    for ch in reversed(s.upper()):
        v = v * 40 + (CHARS.index(ch) if ch in CHARS else 0)
    return v.to_bytes(6, 'big')

def decode_callsign(b):
    v = int.from_bytes(b, 'big')
    if v == 0xFFFFFFFFFFFF: return '@ALL'
    if v >= 40 ** 9: return '#?'
    out = ''
    while v: out += CHARS[v % 40]; v //= 40
    return out

def golay(data12):
    c = 0
    for i in range(12):
        if data12 & (1 << i): c ^= GOLAY_ENC[i]
    return (data12 << 12) | c

def golay_decode_hard(cw):
    """Nearest of the 4096 codewords (exhaustive, research code)."""
    best, bd = None, 99
    for d in range(4096):
        e = bin(golay(d) ^ cw).count('1')
        if e < bd: bd, best = e, d
    return best, bd
_GOLAY_TABLE = np.array([golay(d) for d in range(4096)], dtype=np.uint32)
def golay_decode(cw):
    x = _GOLAY_TABLE ^ np.uint32(cw)
    w = np.array([bin(int(v)).count('1') for v in x]) if False else np.unpackbits(x.view(np.uint8).reshape(-1, 4), axis=1).sum(1)
    d = int(np.argmin(w)); return d, int(w[d])

def conv_encode(bits, punct):
    sr = 0; out = []; p = 0
    for b in list(bits) + [0, 0, 0, 0]:
        g1 = b ^ ((sr >> 2) & 1) ^ ((sr >> 3) & 1)
        g2 = b ^ (sr & 1) ^ ((sr >> 1) & 1) ^ ((sr >> 3) & 1)
        sr = ((sr << 1) | b) & 0xF
        for g in (g1, g2):
            if punct[p]: out.append(g)
            p = (p + 1) % len(punct)
    return np.array(out, np.uint8)

def bytes_bits(b): return np.unpackbits(np.frombuffer(bytes(b), np.uint8))

def frame_symbols(sync, type2_bits):
    """Sync + 184 payload symbols from 368 type-2 bits (interleave + randomize as libm17 does)."""
    syms = [SYMBOL_MAP[(sync >> (14 - 2 * i)) & 3] for i in range(8)]
    b = type2_bits[INTRL] ^ RAND_BITS
    for i in range(184): syms.append(SYMBOL_MAP[b[2 * i] * 2 + b[2 * i + 1]])
    return syms

def lsf_bytes(src, dst, typ=0x0005, meta=bytes(14)):
    d = callsign(dst) + callsign(src) + typ.to_bytes(2, 'big') + meta
    return d + crc16(d).to_bytes(2, 'big')

def encode_lsf(lsf): return frame_symbols(SYNC_LSF, conv_encode(bytes_bits(lsf), P1))

def encode_stream(lsf, fn, payload16, lich_cnt):
    lich = lsf[5 * lich_cnt:5 * lich_cnt + 5] + bytes([lich_cnt << 5])
    lb = int.from_bytes(lich, 'big')
    enc = []
    for k in range(4):
        enc.extend(np.unpackbits(np.frombuffer(golay((lb >> (36 - 12 * k)) & 0xFFF).to_bytes(3, 'big'), np.uint8)))
    t2 = np.concatenate([np.array(enc, np.uint8), conv_encode(bytes_bits(fn.to_bytes(2, 'big') + bytes(payload16)), P2)])
    assert len(t2) == 368, len(t2)
    return frame_symbols(SYNC_STR, t2)

def packet_bits(chunk, eof, counter):
    raw = bytes(chunk).ljust(25, b'\x00')[:25]
    bits = list(np.unpackbits(np.frombuffer(raw, np.uint8)))
    meta = ((1 if eof else 0) << 5) | (counter & 31)
    bits += [(meta >> (5 - i)) & 1 for i in range(6)]
    return np.array(bits, np.uint8)

def encode_packet_frame(chunk, eof, counter):
    t2 = conv_encode(packet_bits(chunk, eof, counter), P3)
    if len(t2) != 368: raise AssertionError(len(t2))
    return frame_symbols(SYNC_PKT, t2)

def sms_payload(text):
    raw = b'\x05' + text.encode('utf-8') + b'\x00'
    return raw + crc16(raw).to_bytes(2, 'big')

def encode_packet_transmission(src, dst, data, can=0):
    """Preamble, a packet-mode LSF, the packet frames, and the end marker."""
    lsf = lsf_bytes(src, dst, (can & 15) << 7)
    syms = [3, -3] * 96 + encode_lsf(lsf)
    frame = 0; off = 0
    while off < len(data) and frame < 33:
        n = min(25, len(data) - off); last = off + n >= len(data)
        syms += encode_packet_frame(data[off:off + n], last, n if last else frame)
        off += n
        if not last: frame += 1
    syms += [3, 3, 3, 3, 3, 3, -3, 3] * 24
    return np.array(syms, float), lsf

def decode_packet_frame(sym):
    bits, _m = viterbi(symbols_to_soft(sym), P3, 206)
    chunk = np.packbits(bits[:200]).tobytes()
    meta = 0
    for b in bits[200:206]: meta = (meta << 1) | int(b)
    return bool(meta & 32), meta & 31, chunk

def transmission(src, dst, payloads, eot=True):
    """Preamble, LSF, stream frames (16-byte payloads, last one with the end bit), EOT: a symbol list."""
    lsf = lsf_bytes(src, dst)
    syms = [+3, -3] * 96 + encode_lsf(lsf)
    for i, p in enumerate(payloads):
        fn = i | (0x8000 if i == len(payloads) - 1 else 0)
        syms += encode_stream(lsf, fn, p, i % 6)
    if eot: syms += [+3, +3, +3, +3, +3, +3, -3, +3] * 24
    return np.array(syms, float), lsf

def rrc(alpha, span, sps):
    t = np.arange(-span * sps / 2, span * sps / 2 + 1) / sps
    h = np.zeros_like(t)
    for i, x in enumerate(t):
        if abs(x) < 1e-9: h[i] = 1 - alpha + 4 * alpha / np.pi
        elif abs(abs(4 * alpha * x) - 1) < 1e-9: h[i] = alpha / np.sqrt(2) * ((1 + 2 / np.pi) * np.sin(np.pi / (4 * alpha)) + (1 - 2 / np.pi) * np.cos(np.pi / (4 * alpha)))
        else: h[i] = (np.sin(np.pi * x * (1 - alpha)) + 4 * alpha * x * np.cos(np.pi * x * (1 + alpha))) / (np.pi * x * (1 - (4 * alpha * x) ** 2))
    return h / np.sqrt(np.sum(h ** 2))

def deviation(syms, fs):
    """Frequency deviation in Hz at sample rate fs: RRC-shaped symbols, a long run of +3 = +2400 Hz."""
    sps = 10; h = rrc(0.5, 8, sps)
    x = np.zeros(len(syms) * sps); x[::sps] = syms
    y = np.convolve(x, h, 'full')[len(h) // 2:][:len(x)]
    run = np.zeros(400 * sps); run[::sps] = 3; yr = np.convolve(run, h, 'full')[len(h) // 2:][:len(run)]
    y = y / yr[len(yr) // 2] * 3 * DEV_PER_UNIT
    f0 = SYM_RATE * sps
    if fs == f0: return y
    t = np.arange(int(len(y) * fs / f0)) * f0 / fs
    return np.interp(t, np.arange(len(y)), y)

# ---- receiver -----------------------------------------------------------------------------------

def viterbi(soft, punct, n_in):
    """Soft-decision Viterbi for the K=5 code; soft = values in [-1,1] (+1 = bit 1); punctured positions get 0."""
    full = []; p = 0; it = iter(soft)
    total = (n_in + 4) * 2
    for k in range(total):
        if punct[p]: full.append(next(it, 0.0))
        else: full.append(0.0)
        p = (p + 1) % len(punct)
    full = np.array(full).reshape(-1, 2)
    INF = 1e9; metric = np.full(16, INF); metric[0] = 0
    prev = np.zeros((len(full), 16), np.int16); bits = np.zeros((len(full), 16), np.uint8)
    # precompute outputs per (state, input)
    outs = np.zeros((16, 2, 2))
    for s in range(16):
        for b in range(2):
            g1 = b ^ ((s >> 2) & 1) ^ ((s >> 3) & 1); g2 = b ^ (s & 1) ^ ((s >> 1) & 1) ^ ((s >> 3) & 1)
            outs[s, b] = [2 * g1 - 1, 2 * g2 - 1]
    for t, (r1, r2) in enumerate(full):
        new = np.full(16, INF)
        for s in range(16):
            if metric[s] >= INF: continue
            for b in range(2):
                ns = ((s << 1) | b) & 0xF
                m = metric[s] - (outs[s, b, 0] * r1 + outs[s, b, 1] * r2)
                if m < new[ns]: new[ns] = m; prev[t, ns] = s; bits[t, ns] = b
        metric = new
    s = 0; out = []
    for t in range(len(full) - 1, -1, -1):
        out.append(bits[t, s]); s = prev[t, s]
    out = out[::-1][:n_in]
    return np.array(out, np.uint8), float(metric[0])

def symbols_to_soft(sym):
    """184 payload symbols (normalized so +-3 are the outer levels) -> 368 soft bits after de-randomize/de-interleave."""
    s = np.clip(np.asarray(sym, float) / 2.0, -1.5, 1.5)          # +-1 inner (at +-0.5), +-3 outer (at +-1.5)
    b1 = np.clip(-s, -1, 1)                                         # first bit: 1 for negative symbols (-1, -3)
    b0 = np.clip(np.abs(s) * 2 - 2, -1, 1)                          # second bit: 1 for outer symbols (+-3)
    soft = np.empty(368); soft[0::2] = b1; soft[1::2] = b0
    rnd = 1 - 2 * RAND_BITS.astype(float)                           # randomizer flips: multiply by -1
    soft = soft * rnd
    out = np.empty(368); out[INTRL] = soft
    return out

def decode_lsf(sym):
    soft = symbols_to_soft(sym)
    bits, m = viterbi(soft, P1, 240)
    b = np.packbits(bits).tobytes()
    return b, crc16(b[:28]) == int.from_bytes(b[28:30], 'big')

def decode_stream(sym):
    soft = symbols_to_soft(sym)
    lich_bits = (soft[:96] > 0).astype(np.uint8)
    lich = 0; lerr = 0
    for k in range(4):
        cw = int(''.join(map(str, lich_bits[24 * k:24 * k + 24])), 2); d, e = golay_decode(cw); lich = (lich << 12) | d; lerr += e
    bits, m = viterbi(soft[96:], P2, 144)
    b = np.packbits(bits).tobytes()
    return int.from_bytes(b[:2], 'big'), b[2:18], lich.to_bytes(6, 'big'), lerr

SYNC_SYMS = {k: np.array([SYMBOL_MAP[(v >> (14 - 2 * i)) & 3] for i in range(8)], float) for k, v in (('lsf', SYNC_LSF), ('str', SYNC_STR), ('pkt', SYNC_PKT), ('ber', SYNC_BER))}

def demod(dev, fs, eq=None):
    """Discriminator signal (Hz) at fs -> symbol-rate samples at the best timing (matched RRC filter)."""
    sps = fs / SYM_RATE
    h = rrc(0.5, 8, int(round(sps)) if abs(sps - round(sps)) < 1e-6 else 10)
    if abs(sps - round(sps)) > 1e-6:                                # resample to 10 samples/symbol first
        t = np.arange(int(len(dev) * 48000 / fs)) * fs / 48000; dev = np.interp(t, np.arange(len(dev)), dev); fs = 48000; sps = 10
    sps = int(round(sps))
    y = np.convolve(dev, h, 'same')
    return y, sps

def sync_score(y, sps, kind, i):
    """Normalized correlation of the 8 sync symbols starting at sample i (symbol k at i + k*sps)."""
    s = SYNC_SYMS[kind]; v = y[i:i + 8 * sps:sps]
    if len(v) < 8: return -1.0
    return float(np.dot(v, s) / (np.sqrt(np.dot(s, s) * np.dot(v, v)) + 1e-12))

def find_frames(y, sps, first_kinds=('lsf', 'str'), thresh=0.9, follow=('str', 'lsf')):
    """The first sync (best of LSF / stream above thresh), then every 192 symbols: re-acquire within +-sps/2 samples."""
    out = []; n = len(y)
    s_l = SYNC_SYMS['lsf']; s_s = SYNC_SYMS['str']
    # vectorised scan for the first sync
    idx = np.arange(0, n - 8 * sps)
    best = (-1, None, None)
    for k in first_kinds:
        s = SYNC_SYMS[k]
        V = np.stack([y[idx + m * sps] for m in range(8)], 1)
        sc = V @ s / (np.sqrt(np.dot(s, s) * np.sum(V * V, 1)) + 1e-12)
        above = np.nonzero(sc > thresh)[0]
        if len(above):
            a = above[0]; b = a + int(np.argmax(sc[a:a + sps])); 
            if best[1] is None or b < best[1]: best = (sc[b], b, k)
    if best[1] is None: return out
    pos, kind = best[1], best[2]
    while pos + 192 * sps <= n + 8 * sps:
        out.append((pos + 8 * sps, kind, sync_score(y, sps, kind, pos), pos))
        nxt = pos + 192 * sps
        cands = [(sync_score(y, sps, k, nxt + d), nxt + d, k) for d in range(-(sps // 2), sps // 2 + 1) for k in follow]
        sc, p2, k2 = max(cands)
        if sc < 0.6: break                                           # end of the transmission (EOT, or lost)
        pos, kind = p2, k2
    return out

def decode_transmission(dev, fs, verbose=True):
    y, sps = demod(dev, fs)
    frames = find_frames(y, sps)
    res = {'lsf': None, 'frames': []}
    held_score = -1.0
    for start, kind, score, j in frames:
        sy = y[j:j + 8 * sps:sps]                                   # sync symbols at the found timing: level and offset
        ref = SYNC_SYMS[kind]
        A = np.vstack([ref, np.ones(8)]).T; g, off = np.linalg.lstsq(A, sy, rcond=None)[0]
        pay = (y[start:start + 184 * sps:sps] - off) / g
        if len(pay) < 184: break
        if kind == 'lsf':
            b, ok = decode_lsf(pay)
            new = (decode_callsign(b[6:12]), decode_callsign(b[0:6]), ok)
            # A later weak or failed sync must not replace a CRC-valid link setup.
            old = res['lsf']
            if old is not None and old[2] and (not ok or score < held_score):
                if verbose: print('LSF at %.3f s ignored (score %.3f)' % (j / (sps * SYM_RATE), score))
            else:
                res['lsf'] = new
                held_score = score
                if verbose: print('LSF at %.3f s  src %s dst %s  CRC %s' % (j / (sps * SYM_RATE), new[0], new[1], 'ok' if ok else 'BAD'))
        else:
            fn, p, lich, lerr = decode_stream(pay); res['frames'].append((fn, p, lerr))
    return res

def decode_packet_transmission(dev, fs, verbose=False):
    """A packet transmission: the link setup, the joined payload when the CRC checks, and the SMS text."""
    y, sps = demod(dev, fs)
    frames = find_frames(y, sps, first_kinds=('lsf', 'pkt'), follow=('pkt', 'lsf'))
    res = {'lsf': None, 'frames': [], 'body': None, 'text': None, 'crc': False}
    parts = []
    for start, kind, score, j in frames:
        sy = y[j:j + 8 * sps:sps]
        ref = SYNC_SYMS[kind]
        A = np.vstack([ref, np.ones(8)]).T
        g, off = np.linalg.lstsq(A, sy, rcond=None)[0]
        pay = (y[start:start + 184 * sps:sps] - off) / g
        if len(pay) < 184: break
        if kind == 'lsf':
            b, ok = decode_lsf(pay)
            res['lsf'] = (decode_callsign(b[6:12]), decode_callsign(b[0:6]), ok, int.from_bytes(b[12:14], 'big'))
        elif kind == 'pkt':
            eof, counter, chunk = decode_packet_frame(pay)
            res['frames'].append((eof, counter, chunk))
            parts.append(chunk[:counter if eof else 25])
            if eof:
                allb = b''.join(parts)
                ok = len(allb) >= 3 and crc16(allb[:-2]) == int.from_bytes(allb[-2:], 'big')
                res['crc'] = ok
                if ok:
                    res['body'] = allb[:-2]
                    if allb[0] == 5:
                        res['text'] = allb[1:-2].split(b'\x00', 1)[0].decode('utf-8', 'replace')
                parts = []
    return res
