"""POCSAG bench tools.
  python -P pocsag.py gen <prefix> [--baud 1200] [--dev 3500] [--ric 1234567] [--msg TEXT] [--repeat 3] [--pad 0.5]
      writes <prefix>.wav (48 kHz NRZ baseband) and <prefix>.iq (2 MS/s FM for hackrf_transfer -t)
  python -P pocsag.py rx <wav> [--baud 1200]    decode a recording (8 kHz or any rate), both polarities
"""
import math, sys, wave, numpy as np

SYNC = 0x7CD215D8; IDLE = 0x7A89C197; G = 0x769

def bch(data21):
    r = data21 << 10
    for i in range(30, 9, -1):
        if r & (1 << i): r ^= G << (i - 10)
    return r & 0x3FF

def codeword(data21):
    cw = (data21 << 10) | bch(data21)
    return (cw << 1) | (bin(cw).count('1') & 1)

def address_cw(ric, func):
    return codeword(((ric >> 3) << 2) | func)           # bit 31 (message flag) = 0

def message_cws(text):
    bits = []
    for ch in text: v = ord(ch); bits += [(v >> i) & 1 for i in range(7)]   # 7-bit ASCII, LSB first
    while len(bits) % 20: bits.append(0)
    out = []
    for i in range(0, len(bits), 20):
        d = 0
        for b in bits[i:i + 20]: d = (d << 1) | b
        out.append(codeword((1 << 20) | d))
    return out

def transmission(ric, func, text):
    words = [address_cw(ric, func)] + message_cws(text)
    frame = ric & 7
    batch_words = [IDLE] * (frame * 2) + words
    bits = [1, 0] * 288                                   # 576-bit preamble
    i = 0
    while i < len(batch_words) or i == 0:
        chunk = batch_words[i:i + 16]; chunk += [IDLE] * (16 - len(chunk))
        for cw in [SYNC] + chunk: bits += [(cw >> (31 - k)) & 1 for k in range(32)]
        i += 16
    return bits

def check(cw):
    data = cw >> 1
    r = data
    for i in range(30, 9, -1):
        if r & (1 << i): r ^= G << (i - 10)
    return (r & 0x3FF) == 0 and (bin(cw).count('1') % 2 == 0)

def decode_bits(bits):
    out = []
    n = len(bits); i = 0
    while i + 32 <= n:
        w = 0
        for b in bits[i:i + 32]: w = (w << 1) | b
        if w == SYNC:
            words = []
            for k in range(16):
                s = i + 32 + 32 * k
                if s + 32 > n: break
                c = 0
                for b in bits[s:s + 32]: c = (c << 1) | b
                words.append(c)
            out.append(words); i += 32 * 17
        else: i += 1
    return out

def rx(path, baud):
    w = wave.open(path); fs = w.getframerate(); ch = w.getnchannels()
    x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float)
    if ch > 1: x = x[::ch]
    x = x - np.convolve(x, np.ones(int(fs / 50)) / int(fs / 50), mode='same')   # remove the slow baseline
    spb = fs / baud
    best = None
    for pol in (1, -1):
        for ph in np.linspace(0, spb, 8, endpoint=False):
            idx = np.arange(ph + spb / 2, len(x) - 1, spb).astype(int)
            bits = [1 if pol * x[k] < 0 else 0 for k in idx]           # a lower frequency (negative audio) is a 1
            batches = decode_bits(bits)
            good = sum(check(c) for b in batches for c in b)
            if best is None or good > best[0]: best = (good, pol, ph, batches)
    good, pol, ph, batches = best
    print("polarity", pol, "phase %.1f" % ph, "batches", len(batches), "valid codewords", good, "of", sum(len(b) for b in batches))
    for bi, b in enumerate(batches):
        for k, c in enumerate(b):
            if c == IDLE: continue
            ok = check(c)
            if (c >> 31) == 0: print(" batch %d frame %d address RIC %d func %d %s" % (bi, k // 2, (((c >> 13) & 0x3FFFF) << 3) | (k // 2), (c >> 11) & 3, "ok" if ok else "BAD"))
            else: print(" batch %d word %d message data %05x %s" % (bi, k, (c >> 11) & 0xFFFFF, "ok" if ok else "BAD"))
    # messages: an address word, then message words, possibly running on into the next batch(es)
    for ric, func, txt in messages(batches): print(" page RIC %d func %d: %r" % (ric, func, txt))

def messages(batches):
    out = []; cur = None
    for b in batches:
        for k, c in enumerate(b):
            if c == IDLE or not check(c):
                if cur: out.append(cur); cur = None
                continue
            if (c >> 31) == 0:
                if cur: out.append(cur)
                cur = [(((c >> 13) & 0x3FFFF) << 3) | (k // 2), (c >> 11) & 3, []]
            elif cur is not None: cur[2] += [((c >> 11) >> (19 - i)) & 1 for i in range(20)]
    if cur: out.append(cur)
    res = []
    for ric, func, bits in out:
        if func == 0:   # numeric (BCD, 4 bits LSB first)
            digs = '0123456789*U -)('; txt = ''.join(digs[sum(bits[i + j] << j for j in range(4))] for i in range(0, len(bits) - 3, 4)).rstrip()
        else: txt = ''.join(chr(sum(bits[i + j] << j for j in range(7))) for i in range(0, len(bits) - 6, 7)).rstrip(chr(0))
        res.append((ric, func, txt))
    return res

if __name__ == '__main__':
    a = sys.argv[1:]
    def opt(k, d): return type(d)(a[a.index(k) + 1]) if k in a else d
    if a[0] == 'gen':
        pre = a[1]; baud = opt('--baud', 1200); dev = opt('--dev', 3500.0); ric = opt('--ric', 1234567); msg = opt('--msg', 'DAPNET BENCH TEST 123'); rep = opt('--repeat', 3); pad = opt('--pad', 0.5)
        bits = []
        for r in range(rep): bits += transmission(ric, 3, msg)
        # hackrf_transfer -n drops up to about 260 ms at the end of the file. Idle words there keep the last message word.
        for _ in range(int(math.ceil(pad * baud / 32.0)) if pad > 0 else 0):
            bits += [(IDLE >> (31 - k)) & 1 for k in range(32)]
        fs = 48000; spb = fs / baud
        x = np.concatenate([np.zeros(fs // 2)] + [np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)] + [np.zeros(fs // 2)])
        ww = wave.open(pre + '.wav', 'wb'); ww.setnchannels(1); ww.setsampwidth(2); ww.setframerate(fs); ww.writeframes((x * 20000).astype('<i2').tobytes()); ww.close()
        import importlib.util
        spec = importlib.util.spec_from_file_location('g', 'apt_gen.py'); g = importlib.util.module_from_spec(spec); spec.loader.exec_module(g)
        g.fm_iq(pre + '.iq', x, fs, 2000000, dev)
        print("wrote", pre + ".wav/.iq", "%.1f s" % (len(x) / fs), len(bits), "bits")
    else:
        rx(a[1], opt('--baud', 1200))
