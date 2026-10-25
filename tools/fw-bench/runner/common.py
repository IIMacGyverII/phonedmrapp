"""Shared configuration for the bench runner (stage 5 of radio_firmware/plan-port-automation.md).

Everything that was a hard-coded path or serial in the Armor snapshot is an option here, with the Armor values as
defaults so the runner reproduces the Armor results unchanged. Nothing in this module touches the phone or the
HackRF; see phone.py and hackrf.py.
"""
import json
import os
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]

DEFAULTS = {
    "serial": os.environ.get("BENCH_SERIAL", "192.168.1.125:5555"),
    "adb": os.environ.get("BENCH_ADB", str(Path(os.environ.get("LOCALAPPDATA", "")) / "Android" / "Sdk" / "platform-tools" / "adb.exe")),
    "hackrf": os.environ.get("BENCH_HACKRF", r"C:\Users\Joshua\tools\hackrf\hackrf_transfer.exe"),
    "out": os.environ.get("BENCH_OUT", str(Path(os.environ.get("LOCALAPPDATA", "")) / "Temp" / "fw-bench")),
    "package": "com.macdmr.radio",
    # the bench frequency and the HackRF offset that keeps the carrier off the HackRF's DC spike
    "freq_hz": 467_625_000,
    "capture_hz": 467_385_000,
    "fs_iq": 2_400_000,
    "offset_hz": 240_000,
    "dec": 50,                       # 2.4 MS/s / 50 = 48 kHz audio-rate deviation
    "lna_key": 16, "vga_key": 16,    # a key at low power, 5 ft
    "lna_boot": 24, "vga_boot": 38,  # the silent-boot capture
    "stop_hz": 5000.0,               # a 0.5 s slice at or over this deviation ends the step
    "bench_call": "N0CALL",
}

# Heat rules (CLAUDE.md, HANDOFF.md): battery over 45 C, AP or modem-PA zone over 60 C, or +2 C inside 10 s, stops a key.
HEAT_BAT_STOP_C = 45.0
HEAT_ZONE_STOP_C = 60.0
HEAT_RISE_STOP_C = 2.0
HEAT_ZONES = ("mtktsAP", "mtktsbtsmdpa", "mtktspa", "mtktsbattery")


class Config:
    def __init__(self, **over):
        d = dict(DEFAULTS); d.update({k: v for k, v in over.items() if v is not None})
        self.__dict__.update(d)
        self.fs_a = self.fs_iq // self.dec
        self.out = Path(self.out); self.out.mkdir(parents=True, exist_ok=True)
        (self.out / "caps").mkdir(exist_ok=True)
        self.log = open(self.out / "bench.log", "a", encoding="utf-8", buffering=1)

    def say(self, m):
        line = time.strftime("%H:%M:%S ") + str(m)
        print(line, flush=True)
        self.log.write(line + "\n")

    def cap(self, name):
        return self.out / "caps" / name


def write_json(path, doc):
    Path(path).write_text(json.dumps(doc, indent=1, default=str), encoding="utf-8")


def now_iso():
    return time.strftime("%Y-%m-%dT%H:%M:%S")
