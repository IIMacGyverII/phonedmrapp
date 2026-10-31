# Trim tonight's full-file HackRF captures to one call and put the carrier at 0 Hz,
# so a replay at 467.625 MHz does not keep the hotspot's frequency error.
# No radio. Does not transmit.
#
# python tools/dmr-replay/prepare_fullfile.py
import json
import subprocess
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
CAPS = Path.home() / "AppData/Local/Temp/fw-bench/caps"
LIB = HERE / "library"
FS = 2_400_000
OFF = 240_000
PAD = 0.25
SOURCES = {
    "tg9": ["full_ch49_tg9_off1.iq", "full_vfoA_tg9_off1.iq", "full_A_tg9_off1.iq"],
    "tg99": ["full_A_tg99_off1.iq", "full_B_tg99_off1.iq", "full_fw57_tg99_off.iq"],
    "allcall": ["full_A_allcall_off1.iq", "full_B_allcall_off1.iq", "full_fw57_allcall_off.iq"],
}
WANT = {"tg9": 9, "tg99": 99, "allcall": 16777215}


def pick(names):
    for name in names:
        path = CAPS / name
        if path.is_file():
            return path
    raise SystemExit("missing " + ", ".join(names))


def carrier(iq):
    """Same carrier window and residual as iqan_tx.py at --off 240000."""
    n = len(iq)
    z = iq * np.exp(-2j * np.pi * OFF * np.arange(n) / FS)
    dec = int(FS // 48000)
    bb = np.convolve(z, np.ones(dec) / dec, "same")[::dec]
    f2 = FS / dec
    pw = np.abs(bb) ** 2
    win = int(f2 * 0.05)
    pws = np.convolve(pw, np.ones(win) / win, "same")
    floor = np.percentile(pws, 10)
    on = pws > floor * 100
    if not on.any():
        raise SystemExit("no carrier")
    idx = np.where(on)[0]
    t0, t1 = idx[0] / f2, idx[-1] / f2
    inst = np.angle(bb[1:] * np.conj(bb[:-1])) * f2 / (2 * np.pi)
    seg = inst[idx[0] + int(0.2 * f2): idx[-1] - int(0.2 * f2)]
    seg = seg[np.abs(seg) < 15000]
    return t0, t1, float(np.mean(seg))


def run_check(path, off):
    peek = subprocess.run([sys.executable, str(HERE / "iqpeek.py"), str(path)], capture_output=True, text=True)
    iqan = subprocess.run(
        [sys.executable, str(HERE / "iqan_tx.py"), str(path), "--fs", str(FS), "--off", str(off), "--dmr"],
        capture_output=True, text=True)
    text = iqan.stdout + iqan.stderr
    dests = []
    for line in text.splitlines():
        if "voice LC header" not in line or "FLCO 0" not in line:
            continue
        parts = line.split()
        dests.append(int(parts[parts.index("dst") + 1].rstrip(",")))
    offset = None
    span = None
    clip = None
    for line in text.splitlines():
        if line.startswith("carrier offset"):
            offset = int(line.split()[2])
        if line.startswith("carrier ") and " s to " in line:
            span = line
        if line.startswith("samples "):
            clip = line
    verdict = ""
    for line in peek.stdout.splitlines():
        if line.startswith("verdict") or line.startswith("peak"):
            verdict += line + " "
    return {
        "peek": verdict.strip(),
        "clip": clip,
        "span": span,
        "offset_hz": offset,
        "voice_dests": sorted(set(dests)),
        "voice_n": len(dests),
    }


def main():
    LIB.mkdir(parents=True, exist_ok=True)
    manifest = {"tx_hz": 467625000, "fs": FS, "carrier_at_hz": 0, "vga": {"minus85": 18, "minus95": 8}}
    for kind, names in SOURCES.items():
        src = pick(names)
        iq = np.fromfile(src, dtype=np.int8).astype(np.float32)
        z = iq[0::2] + 1j * iq[1::2]
        t0, t1, residual = carrier(z)
        a = max(0, int((t0 - PAD) * FS))
        b = min(len(z), int((t1 + PAD) * FS))
        seg = z[a:b]
        shift = OFF + residual
        seg = seg * np.exp(-2j * np.pi * shift * np.arange(len(seg)) / FS)
        out = np.empty(2 * len(seg), np.int8)
        out[0::2] = np.clip(np.round(seg.real), -127, 127).astype(np.int8)
        out[1::2] = np.clip(np.round(seg.imag), -127, 127).astype(np.int8)
        dest = LIB / ("full_%s.iq" % kind)
        dest.write_bytes(out.tobytes())
        check = run_check(dest, 0)
        if check["voice_dests"] != [WANT[kind]]:
            raise SystemExit("%s dests %s" % (kind, check["voice_dests"]))
        if "CLIPPING" in check["peek"] or "NEAR-SILENT" in check["peek"]:
            raise SystemExit("%s %s" % (kind, check["peek"]))
        manifest[kind] = {
            "source": src.name,
            "removed_hz": round(residual, 1),
            "seconds": round(len(seg) / FS, 2),
            "check": check,
        }
        print("%s %s removed %+.0f Hz %s dest %s" % (
            kind, src.name, residual, check["peek"], check["voice_dests"]))
    (LIB / "fullfile_manifest.json").write_text(json.dumps(manifest, indent=1), encoding="utf-8")
    print("wrote", LIB / "fullfile_manifest.json")


if __name__ == "__main__":
    main()
