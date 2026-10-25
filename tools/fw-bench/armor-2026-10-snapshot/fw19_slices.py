"""Where the 45 s capture crossed 5 kHz, and where modulation ended. No key."""
import json
import sys

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import fw19_run

dev, info = camp.demod(str(camp.CAP / "fw19_45.iq"))
rows = fw19_run.slices(dev, int(info["i0"]), info["keyed_s"] + 0.25)
over = [(ms, val) for ms, val in rows if ms >= 60 and val >= camp.STOP_HZ]
mod = [(ms, val) for ms, val in rows if ms >= 80 and val > 1500]
print("keyed_s", round(info["keyed_s"], 3), "clip", info["clip_frac"], "snr", round(info["snr_db"], 1))
print("over_count", len(over))
print("over_first", over[:8])
print("over_last", over[-8:])
print("mod_last", mod[-12:])
# Body of the key, away from the key-up click and the drop.
body = [(ms, val) for ms, val in rows if 500 <= ms <= int(info["keyed_s"] * 1000) - 400]
hi = max(body, key=lambda r: r[1]) if body else None
print("body_max", hi)
print("body_over", sum(1 for _, v in body if v >= camp.STOP_HZ))
out = {
    "keyed_s": info["keyed_s"],
    "over": over,
    "mod_last": mod[-12:],
    "body_max": hi,
    "body_over": sum(1 for _, v in body if v >= camp.STOP_HZ),
}
(fw19_run.HERE / "fw19_slices.json").write_text(json.dumps(out), encoding="utf-8")
print("wrote fw19_slices.json")
