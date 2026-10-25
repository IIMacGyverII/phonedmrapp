"""Write the Armor held-path tap asset and the expected payloads for the 18 R-F clips."""
import json
import sys
from pathlib import Path

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import numpy as np
import m17

RF = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rf")
ASSET = Path(r"D:\Documents\code\personal\SignalDeck\app\src\main\assets\m17\held_ulefone-armor26ultra.txt")
taps = json.loads((RF / "taps.json").read_text())["taps"]
if len(taps) != 41:
    raise SystemExit("taps %d" % len(taps))
ASSET.write_bytes(("\n".join("%.17g" % v for v in taps) + "\n").encode("utf-8"))

NFRAMES = 80
PAIRS = [("W1RF", "N2EQ"), ("K3M17", "W4LAB"), ("N5TST", "K6DEC"), ("W7RF", "N8EQ"), ("K9M17", "W2LAB"), ("N3TST", "K4DEC"),
         ("W5RF", "N6EQ"), ("K7M17", "W8LAB"), ("N9TST", "K2DEC"), ("W3RF", "N4EQ"), ("K5M17", "W6LAB"), ("N7TST", "K8DEC"),
         ("W9RF", "N1EQ"), ("K1M17", "W3LAB"), ("N4TST", "K5DEC"), ("W2RF", "N3EQ"), ("K6M17", "W9LAB"), ("N8TST", "K3DEC")]
clips = []
for p in sorted(RF.glob("m17_d*_v*_*.wav")):
    name = p.stem
    rng = np.random.default_rng(10007 + sum(ord(c) for c in name) * 17)
    src, dst = PAIRS[sum(ord(c) for c in name) % len(PAIRS)]
    payloads = rng.integers(0, 256, size=(NFRAMES, 16))
    frames = []
    for i, row in enumerate(payloads):
        fn = i | (0x8000 if i == NFRAMES - 1 else 0)
        frames.append({"fn": int(fn), "hex": bytes(int(v) for v in row).hex()})
    clips.append({"name": name, "src": src, "dst": dst, "frames": frames})
out = RF / "expected.json"
out.write_bytes(json.dumps({"clips": clips}, separators=(",", ":")).encode("utf-8"))
print("asset", ASSET, "clips", len(clips), "bytes", out.stat().st_size)
