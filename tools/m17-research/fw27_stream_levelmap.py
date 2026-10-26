"""FW27 receive-RAM stream (2026-10-26): can a memoryless level map recover the M17 frames the plain decode loses?

The stream is a limited discriminator (results.md "FW27 carrier offset and deviation"): a 1 kHz tone reads 2774 counts
at 0.5 kHz deviation, 4377 at 1.0, 5445 at 1.5, 5888 at 2.0, 5980 at 2.4 and about 6030 from 3.0 kHz up. M17 puts its
+-3 symbols at +-2.4 kHz, on the ceiling. This script scores the committed captures three ways:

  A. plain: sync-normalised linear slicing on the raw stream, as the app does today (sync threshold 0.85, the
     R-F scorer's value, on the loud part of the file);
  B. knee inverse: a soft limiter y = A x / (1 + |x/x0|^p)^(1/p) fitted to the deviation table (fundamental of the
     limited sine against the measured amplitude), inverted sample by sample before the matched filter;
  C. fitted map: the transmitted waveform regenerated from the known payloads (RandomState(7), 30 frames, the link
     setup taken from the channel-56 decode), aligned to the capture, a monotone raw->deviation map binned from the
     pair, inverted and applied before the matched filter; scored on the same capture and on the other one.

The channel-56 reference (audio path, hold on) is decoded equalise-first with the shipped 41 taps, as the app does.
Payload-exact = decoded stream frames whose 16 payload bytes equal the transmitted ones for that frame number.

usage: python fw27_stream_levelmap.py [captures dir]   (default tools/m17-research/captures/fw27-stream)
"""
import sys
from pathlib import Path
import numpy as np
import m17

HERE = Path(__file__).resolve().parent
CAP = Path(sys.argv[1]) if len(sys.argv) > 1 else HERE / "captures" / "fw27-stream"
TAPS = HERE.parents[2] / "SignalDeck" / "app" / "src" / "main" / "assets" / "m17" / "held_ulefone-armor26ultra.txt"
FS = 8000.0; L = 20; THRESH = 0.85
TABLE_KHZ = np.array([0.5, 1.0, 1.5, 2.0, 2.4, 3.0, 3.5, 4.0])
TABLE_AMP = np.array([2774, 4377, 5445, 5888, 5980, 6017, 6034, 6032], float)


def load(name):
    x = np.fromfile(CAP / name, dtype="<i2").astype(np.float64)
    return x - np.median(x)


def loud(x, thresh=800.0):
    """The file from 0.25 s after its rms first exceeds thresh (the R-F scorer's trim), mean removed."""
    w = 400
    r = np.array([np.sqrt(np.mean((x[i:i + w] - x[i:i + w].mean()) ** 2)) for i in range(0, x.size - w, 80)])
    on = np.flatnonzero(r > thresh); i0 = on[0] * 80 + int(0.25 * FS) if on.size else 0
    x = x[i0:]; return x - x.mean()


def payloads():
    rng = np.random.RandomState(7)
    pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(30)]
    return {i | (0x8000 if i == 29 else 0): p for i, p in enumerate(pay)}


WANT = payloads()


def equalise_first(y, sps, w):
    ye = np.zeros_like(y)
    for i, t in enumerate(w):
        sh = (L - i) * sps
        if sh >= 0: ye[:y.size - sh] += t * y[sh:]
        else: ye[-sh:] += t * y[:y.size + sh]
    return ye


def track(y, sps):
    """Like m17.find_frames, but the first sync is the best-scoring position in the whole file (the link setup's sync
    occurs once and strongly; a first-above-threshold search locks on noise in the 1.6 s lead), then every 192 symbols
    with a +-sps/2 re-acquisition, until the score falls under 0.6."""
    n = y.size; idx = np.arange(0, n - 8 * sps)
    best = (-1.0, None, None)
    for k in ("lsf", "str"):
        s = m17.SYNC_SYMS[k]
        V = np.stack([y[idx + m * sps] for m in range(8)], 1)
        sc = V @ s / (np.sqrt(np.dot(s, s) * np.sum(V * V, 1)) + 1e-12)
        b = int(np.argmax(sc))
        if sc[b] > best[0]: best = (float(sc[b]), b, k)
    if best[1] is None or best[0] < THRESH: return []
    pos, kind = best[1], best[2]
    # walk back frame by frame in case the best sync was not the first frame
    while pos - 192 * sps >= 0:
        cands = [(m17.sync_score(y, sps, k, pos - 192 * sps + d), pos - 192 * sps + d, k) for d in range(-(sps // 2), sps // 2 + 1) for k in ("lsf", "str")]
        sc, p2, k2 = max(cands)
        if sc < 0.6: break
        pos, kind = p2, k2
    out = []
    while pos + 192 * sps <= n + 8 * sps:
        out.append((pos + 8 * sps, kind, m17.sync_score(y, sps, kind, pos), pos))
        nxt = pos + 192 * sps
        cands = [(m17.sync_score(y, sps, k, nxt + d), nxt + d, k) for d in range(-(sps // 2), sps // 2 + 1) for k in ("str", "lsf")]
        sc, p2, k2 = max(cands)
        if sc < 0.6: break
        pos, kind = p2, k2
    return out


def score(dev, label, taps=None, want_lsf=False):
    """Sync-normalised slicing frame by frame; returns (frames, clean, exact, lsf_ok, lsf_bytes)."""
    y, sps = m17.demod(dev, FS)
    if taps is not None: y = equalise_first(y, sps, taps)
    frames = []; lsf_ok = False; lsf_bytes = None; first = None
    for start, kind, sc, j in track(y, sps):
        sy = y[j:j + 8 * sps:sps]
        g, off = np.linalg.lstsq(np.vstack([m17.SYNC_SYMS[kind], np.ones(8)]).T, sy, rcond=None)[0]
        pay = (y[start:start + 184 * sps:sps] - off) / g
        if pay.size < 184: break
        if first is None: first = sc
        if kind == "lsf":
            b, ok = m17.decode_lsf(pay)
            if ok and not lsf_ok: lsf_ok = True; lsf_bytes = bytes(b)
        else:
            fn, p, lich, lerr = m17.decode_stream(pay); frames.append((int(fn), bytes(p), lerr))
    exact = sum(1 for fn, p, _ in frames if WANT.get(fn) == p)
    clean = sum(1 for _, _, lerr in frames if lerr <= 2)
    print("  %-40s first sync %.3f  frames %2d  clean %2d  payload-exact %2d  LSF CRC %s" % (label, first or 0, len(frames), clean, exact, "ok" if lsf_ok else "bad"))
    return frames, clean, exact, lsf_ok, lsf_bytes


# ---- B: a soft limiter with a knee, fitted to the tone table
def limiter(x, A, x0, p):
    return A * x / (1.0 + np.abs(x / x0) ** p) ** (1.0 / p)


def fundamental(A, x0, p, d_hz):
    th = np.linspace(0, 2 * np.pi, 2048, endpoint=False)
    y = limiter(d_hz * np.sin(th), A, x0, p)
    return 2 * np.abs(np.mean(y * np.exp(-1j * th)))


def fit_limiter():
    best = None
    for p in (1.5, 2.0, 2.5, 3.0, 4.0, 6.0, 8.0):
        for A in np.linspace(4.0, 7.0, 31):                     # counts per Hz in the linear part
            for x0 in np.linspace(600, 1800, 25):
                err = sum((fundamental(A, x0, p, k * 1000) - a) ** 2 for k, a in zip(TABLE_KHZ, TABLE_AMP))
                if best is None or err < best[0]: best = (err, A, x0, p)
    return best[1:]


def limiter_inverse(y, A, x0, p):
    """x from y = A x / (1 + |x/x0|^p)^(1/p): |x| = |y|/A / (1 - (|y|/(A x0))^p)^(1/p), clamped below the ceiling."""
    s = np.sign(y); r = np.minimum(np.abs(y) / (A * x0), 0.985)
    return s * (np.abs(y) / A) / (1.0 - r ** p) ** (1.0 / p)


# ---- C: a map fitted from the capture against the regenerated transmission
def regenerate(lsf_bytes):
    syms = [3, -3] * 96 + list(m17.encode_lsf(lsf_bytes))
    pay = payloads()
    for i in range(30):
        fn = i | (0x8000 if i == 29 else 0)
        syms += list(m17.encode_stream(lsf_bytes, fn, pay[fn], i % 6))
    syms += [3, 3, 3, 3, 3, 3, -3, 3] * 24
    return m17.deviation(np.array(syms, float), FS)          # instantaneous frequency in Hz at 8 kHz


def align(raw, ref):
    n = min(raw.size, ref.size + int(4 * FS))
    a = raw[:n] - raw[:n].mean(); b = ref - ref.mean()
    c = np.correlate(a, b, "valid")
    k = int(np.argmax(np.abs(c)))
    return k, (1.0 if c[k] >= 0 else -1.0), float(np.abs(c[k]) / (np.linalg.norm(a[k:k + b.size]) * np.linalg.norm(b) + 1e-9))


def fitted_map(raw, ref, lag, sign):
    x = sign * raw[lag:lag + ref.size]; d = ref[:x.size]
    edges = np.linspace(-2700, 2700, 55)                                 # 100 Hz bins of true deviation
    idx = np.digitize(d, edges)
    cd, cx = [], []
    for b in range(1, edges.size):
        m = idx == b
        if m.sum() < 20: continue
        cd.append(float(d[m].mean())); cx.append(float(x[m].mean()))
    cd = np.array(cd); cx = np.array(cx)
    order = np.argsort(cx); cx = cx[order]; cd = cd[order]
    cx = np.maximum.accumulate(cx) + 1e-3 * np.arange(cx.size)           # strictly increasing for interp
    return cx, cd


def apply_map(raw, sign, cx, cd):
    return np.interp(sign * raw, cx, cd)


# ---- diagnostics: is the distortion static, or does it move during the burst?
def per_frame_levels(raw, ref, lag, sign, sps_ref=FS / 4800.0):
    """For each 40 ms frame of the aligned pair: the mean raw value at the samples where the transmitted deviation is
    near each of the four levels (+-800, +-2400 Hz), and the frame's raw mean. Shows a transient or drift."""
    x = sign * raw[lag:lag + ref.size]; d = ref[:x.size]
    n = int(round(192 * sps_ref))
    rows = []
    for f in range(x.size // n):
        xs = x[f * n:(f + 1) * n]; ds = d[f * n:(f + 1) * n]
        row = [f, float(xs.mean())]
        for lv in (-2400, -800, 800, 2400):
            m = np.abs(ds - lv) < 150
            row.append(float(xs[m].mean()) if m.sum() >= 5 else float("nan"))
        rows.append(row)
    return rows


def dc_track(x, win):
    """x minus its running mean over win samples (a short high-pass that follows an AFC-like drift)."""
    k = np.ones(win) / win
    return x - np.convolve(x, k, "same")


# ---- F/G: a filter with memory fitted on the aligned pair (the R-E idea, fitted by alignment instead of per-frame matching)
def lagged(x, half):
    """Rows of x[n-half..n+half] for every n (edges zero-padded)."""
    xp = np.concatenate([np.zeros(half), x, np.zeros(half)])
    return np.stack([xp[k:k + x.size] for k in range(2 * half + 1)], 1)


def fit_filter(raw, ref, lag, sign, half, cubic, skip_s=0.3):
    """Least-squares taps from the stream (scaled to about +-1) to the transmitted deviation; the first skip_s seconds
    of the burst (the onset transient) are left out of the fit. Returns a function raw -> deviation estimate."""
    x = sign * raw[lag:lag + ref.size] / 4000.0; d = ref[:x.size]
    X = lagged(x, half)
    if cubic: X = np.hstack([X, X ** 3])
    X = np.hstack([X, np.ones((X.shape[0], 1))])
    s0 = int(skip_s * FS)
    w = np.linalg.lstsq(X[s0:], d[s0:], rcond=None)[0]
    fit_err = float(np.sqrt(np.mean((X[s0:] @ w - d[s0:]) ** 2)))

    def apply(r):
        z = sign * r / 4000.0; Z = lagged(z, half)
        if cubic: Z = np.hstack([Z, Z ** 3])
        return np.hstack([Z, np.ones((Z.shape[0], 1))]) @ w
    return apply, fit_err


if __name__ == "__main__":
    A, x0, p = fit_limiter()
    print("limiter fit: %.2f counts/Hz, knee x0=%.0f Hz, p=%.1f, ceiling %.0f  (fundamentals: %s)" % (
        A, x0, p, A * x0, " ".join("%.0f" % fundamental(A, x0, p, k * 1000) for k in TABLE_KHZ)))
    taps = np.array([float(t) for t in TAPS.read_text().split()]) if TAPS.exists() else None
    print("channel56 (audio path, hold on, %s):" % ("shipped taps" if taps is not None else "no taps found"))
    ref56 = loud(load("channel56.s16"))
    _, _, _, ok56, lsf_bytes = score(-ref56, "equalise-first, sign -", taps)
    if not ok56:
        _, _, _, ok56, lsf_bytes = score(ref56, "equalise-first, sign +", taps)
    names = sys.argv[2:] if len(sys.argv) > 2 else ["stream-1552.s16", "stream-1636.s16"]
    for name in names:
        raw = loud(load(name))
        print(name + ":")
        for sign, lab in ((1.0, "+"), (-1.0, "-")):
            score(sign * raw, "A plain, sign " + lab)
        score(limiter_inverse(raw, A, x0, p), "B knee inverse")
        if lsf_bytes is not None:
            ref = regenerate(lsf_bytes)
            lag, sign, corr = align(raw, ref)
            cx, cd = fitted_map(raw, ref, lag, sign)
            print("  fitted map: lag %d, sign %+.0f, corr %.3f, %d bins, raw %.0f..%.0f -> dev %.0f..%.0f Hz" % (lag, sign, corr, cx.size, cx[0], cx[-1], cd[0], cd[-1]))
            score(apply_map(raw, sign, cx, cd), "C fitted map (same capture)")
            other = "stream-1636.s16" if name == "stream-1552.s16" else "stream-1552.s16"
            score(apply_map(loud(load(other)), sign, cx, cd), "C map from %s on %s" % (name[7:11], other[7:11]))
            print("  per-frame levels (frame, raw mean, raw at -2400/-800/+800/+2400 Hz):")
            for row in per_frame_levels(raw, ref, lag, sign):
                if row[0] < 6 or row[0] % 6 == 0 or row[0] >= 30:
                    print("    %2d  %7.0f   %7.0f %7.0f %7.0f %7.0f" % tuple(row))
        else:
            print("  (no CRC-valid link setup from the audio path; method C skipped)")
        for win in (int(0.05 * FS),):
            score(dc_track(raw, win), "D running-mean removed, %d ms" % (1000 * win / FS))
        if lsf_bytes is not None:
            # Is the time base continuous? The best local lag of each 256-sample half against the reference.
            x = sign * raw[lag - 64:lag + ref.size + 64]; d = ref
            print("  per-half best lag (samples) against the transmitted waveform, halves of the burst:")
            lags = []
            # the half grid of the file: halves start at multiples of 256 from the file start; lag is in file samples
            first_half = (lag // 256 + 1) * 256
            for h0 in range(first_half, lag + ref.size - 256, 256):
                seg = sign * raw[h0:h0 + 256]
                best = (-1e30, 0)
                for dl in range(-40, 41):
                    r0 = h0 - lag + dl
                    if r0 < 0 or r0 + 256 > ref.size: continue
                    c = float(np.dot(seg - seg.mean(), ref[r0:r0 + 256] - ref[r0:r0 + 256].mean()))
                    if c > best[0]: best = (c, dl)
                lags.append(best[1])
            print("    " + " ".join("%+d" % v for v in lags))
            other = "stream-1636.s16" if name == "stream-1552.s16" else "stream-1552.s16"
            oraw = loud(load(other))
            for half, cubic, lab in ((16, False, "F linear FIR, 33 taps"), (32, False, "F linear FIR, 65 taps"),
                                     (16, True, "G FIR + cubic, 33 taps"), (32, True, "G FIR + cubic, 65 taps")):
                fn_apply, err = fit_filter(raw, ref, lag, sign, half, cubic)
                print("  %s: fit rms error %.0f Hz on the training burst" % (lab, err))
                score(fn_apply(raw), "  %s, same capture" % lab)
                score(fn_apply(oraw), "  %s, on %s" % (lab, other[7:11]))
