"""One results table per image: every run appends a JSON record under results/<tag>/ and the summary is rebuilt.

The Armor reference numbers (radio_firmware/results.md) sit next to each test so a port shows at a glance where it
differs from the phone the bench was built on.
"""
import json
import time
from pathlib import Path

from common import write_json, now_iso

# What the Armor 26 Ultra measured, for the summary's reference column.
ARMOR_REFERENCE = {
    "boot": "peak under 0.1 dB, no run at or over 10 dB (FW14 onward)",
    "tone": "10 s 1 kHz low power: carrier 10.8 s, body p99 about 2.8 kHz, 1 kHz line, no slice at 5 kHz",
    "stream": "1125 of 1125 payload-exact, end bit, EOT, carrier 45.3 s, p99 about 2.9-3.0 kHz, clip 0 (FW20+)",
    "heat": "30 s low power: mtktsAP about +1 C, battery about +0.2 C; 45 s low power a small rise; no stop (battery 45 C, AP or modem-PA 60 C, +2 C in 10 s). The +11.3 C figure is the separate 120 s high-power key",
    "receive": "idle 0x32 about -108 dBm; a HackRF 1 kHz FM tone opens the squelch and shows a 1 kHz line in the clip",
}


def record(cfg, tag, test, doc):
    d = cfg.out / "results" / (tag or "unknown"); d.mkdir(parents=True, exist_ok=True)
    doc = dict(doc); doc.update({"test": test, "tag": tag, "at": now_iso()})
    path = d / ("%s-%s.json" % (time.strftime("%Y%m%d-%H%M%S"), test))
    write_json(path, doc)
    summary(cfg, tag)
    return path


def summary(cfg, tag):
    d = cfg.out / "results" / (tag or "unknown")
    rows = []
    for p in sorted(d.glob("*.json")):
        try:
            doc = json.loads(p.read_text(encoding="utf-8"))
        except Exception:
            continue
        rows.append(doc)
    lines = ["# Bench results: %s" % tag, "", "| When | Test | Verdict | Key numbers | Armor reference |", "|---|---|---|---|---|"]
    for r in rows:
        lines.append("| %s | %s | %s | %s | %s |" % (r.get("at", ""), r.get("test", ""), r.get("verdict", ""), r.get("numbers", ""), ARMOR_REFERENCE.get(r.get("test", ""), "")))
    (d / "summary.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return d / "summary.md"
