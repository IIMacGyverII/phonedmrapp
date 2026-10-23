"""NOAA APT signal generator (PC side) for bench-testing the module's NOAAReceiver with a HackRF.

Usage: python -P apt_gen.py <out_prefix> [--secs 60] [--iq] [--dev 17000] [--rate 2000000] [--img a.png b.png]
Writes <out_prefix>.wav (8 kHz mono APT audio, the radio's RX audio rate) and, with --iq, <out_prefix>.iq
(int8 interleaved IQ, FM-modulated at <rate>, +/-<dev> Hz peak deviation) for hackrf_transfer -t.

APT line (2080 words @ 4160 Hz, 2 lines/s): SyncA 39 (1040 Hz square) | SpaceA 47 | ImageA 909 | TelemA 45 |
SyncB 39 (832 Hz pulses) | SpaceB 47 | ImageB 909 | TelemB 45. Telemetry: 16 wedges x 8 lines (128-line frame),
wedges 1..8 = 31,63,...,255 (modulation steps), 9 = zero, 10..16 = calibration (arbitrary here).
The 0..255 word values AM-modulate a 2400 Hz subcarrier (modulation index ~0.87 like the real thing).
"""
import sys, wave, numpy as np
from PIL import Image, ImageDraw, ImageFont

APT_RATE = 4160; LINE = 2080; W = 909
SYNC, SPACE, TELEM = 39, 47, 45

def test_image(h, label):
    """Synthetic 909xh test picture: gradient, bars, circles, text — enough structure to judge a decode."""
    im = Image.new('L', (W, h), 0); d = ImageDraw.Draw(im)
    # horizontal gradient band
    for x in range(W): d.line([(x, 0), (x, h // 5)], fill=int(255 * x / (W - 1)))
    # 8 gray bars
    for i in range(8): d.rectangle([i * W // 8, h // 5, (i + 1) * W // 8 - 1, 2 * h // 5], fill=int(255 * i / 7))
    # "coastline": a big filled polygon plus circles (cloud blobs)
    d.polygon([(0, 2 * h // 5), (300, 2 * h // 5 + 20), (420, 3 * h // 5), (200, 4 * h // 5), (0, h)], fill=90)
    for cx, cy, r, v in [(600, 3 * h // 5, 60, 230), (720, 3 * h // 5 + 40, 35, 200), (820, 4 * h // 5, 50, 255)]:
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=v)
    try: f = ImageFont.truetype("arial.ttf", 48)
    except Exception: f = ImageFont.load_default()
    d.text((20, h - 70), label, fill=255, font=f)
    return np.asarray(im, dtype=np.float64)

def build_words(secs, imgs):
    lines = int(secs * 2)
    out = np.zeros((lines, LINE))
    # sync A: 7 cycles of 1040 Hz square (4 samples/cycle) inside 39: 4 low, 7x(2 hi 2 lo), 7 low
    syncA = np.zeros(SYNC);
    for c in range(7): syncA[4 + c * 4: 4 + c * 4 + 2] = 255
    # sync B: 7 pulses of 832 Hz (5 samples/cycle): 4 low, 7x(3 hi 2 lo), 0 left
    syncB = np.zeros(SYNC)
    for c in range(7): syncB[4 + c * 5: 4 + c * 5 + 3] = 255
    wedge_vals = [31, 63, 95, 127, 159, 191, 223, 255, 0, 60, 120, 180, 240, 128, 64, 200]
    for ln in range(lines):
        wv = wedge_vals[(ln // 8) % 16]
        p = 0
        out[ln, p:p + SYNC] = syncA; p += SYNC
        out[ln, p:p + SPACE] = 0; p += SPACE                   # space A black (visible IR space: white; keep 0)
        out[ln, p:p + W] = imgs[0][ln % imgs[0].shape[0]]; p += W
        out[ln, p:p + TELEM] = wv; p += TELEM
        out[ln, p:p + SYNC] = syncB; p += SYNC
        out[ln, p:p + SPACE] = 255; p += SPACE                 # space B white (IR convention)
        out[ln, p:p + W] = imgs[1][ln % imgs[1].shape[0]]; p += W
        out[ln, p:p + TELEM] = wv; p += TELEM
    return out.reshape(-1)

def words_to_audio(words, fs=8000):
    """Upsample the 4160 Hz word stream to fs (linear) and AM-modulate a 2400 Hz carrier."""
    n_out = int(len(words) * fs / APT_RATE)
    t_w = np.arange(len(words)) / APT_RATE; t_o = np.arange(n_out) / fs
    base = np.interp(t_o, t_w, words) / 255.0            # 0..1
    m = 0.87                                              # modulation index
    env = (1 - m) + m * base                              # 0.13..1.0
    aud = env * np.cos(2 * np.pi * 2400.0 * t_o)
    return (aud / np.max(np.abs(aud)) * 0.9), fs

def write_wav(path, x, fs):
    w = wave.open(path, 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(fs)
    w.writeframes((np.clip(x, -1, 1) * 32767).astype('<i2').tobytes()); w.close()

def fm_iq(path, x, fs_in, rate, dev):
    """Narrow-ish FM: interpolate audio to `rate`, integrate phase, write int8 IQ in 10 s chunks."""
    chunk = fs_in * 10; phase = 0.0
    with open(path, 'wb') as f:
        for s in range(0, len(x), chunk):
            seg = x[s:s + chunk]
            n_out = int(len(seg) * rate / fs_in)
            t_i = np.arange(len(seg)) / fs_in; t_o = np.arange(n_out) / rate
            a = np.interp(t_o, t_i, seg)
            dphi = 2 * np.pi * dev * a / rate
            ph = phase + np.cumsum(dphi); phase = ph[-1] % (2 * np.pi)
            iq = np.empty(2 * n_out, dtype=np.int8)
            iq[0::2] = np.round(110 * np.cos(ph)).astype(np.int8); iq[1::2] = np.round(110 * np.sin(ph)).astype(np.int8)
            f.write(iq.tobytes())

if __name__ == '__main__':
    a = sys.argv[1:]; pre = a[0]
    secs = float(a[a.index('--secs') + 1]) if '--secs' in a else 60
    dev = float(a[a.index('--dev') + 1]) if '--dev' in a else 17000
    rate = int(a[a.index('--rate') + 1]) if '--rate' in a else 2000000
    lines = int(secs * 2)
    if '--img' in a:
        i = a.index('--img'); imgs = [np.asarray(Image.open(a[i + k]).convert('L').resize((W, lines)), dtype=np.float64) for k in (1, 2)]
    else:
        imgs = [test_image(lines, "APT CH-A  DMRMod bench"), test_image(lines, "APT CH-B")]
    words = build_words(secs, imgs)
    Image.fromarray(np.concatenate([imgs[0], imgs[1]], 1).astype(np.uint8)).save(pre + '_ref.png')
    aud, fs = words_to_audio(words)
    write_wav(pre + '.wav', aud, fs); print("wrote", pre + '.wav', "%.1f s" % (len(aud) / fs))
    if '--iq' in a:
        fm_iq(pre + '.iq', aud, fs, rate, dev); print("wrote", pre + '.iq', "dev=%.0f Hz rate=%d" % (dev, rate))
