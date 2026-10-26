#!/usr/bin/env python3
"""The module bench regression runner (stage 5 of radio_firmware/plan-port-automation.md).

  python bench.py --serial <adb serial> tag                  # what the module reports
  python bench.py boot                                       # silent-boot capture across a module restart (no key)
  python bench.py --arm tone [--ms 10000] [--power 1]        # one 1 kHz test tone under a HackRF capture
  python bench.py --arm stream [--frames 1125]               # the long M17 stream through command 0x40, decoded
  python bench.py --arm heat [--seconds 45] [--power 1]      # zones and battery around a key, with the stops
  python bench.py --arm receive                              # a HackRF FM tone into the radio, the phone's clip judged
  python bench.py --arm all                                  # boot, tone, stream, receive, heat in that order
  python bench.py --load <image.bin> boot                    # load an image through SignalDeck's loader first

Defaults are the Armor 26 Ultra bench (467.625 MHz low power, the HackRF offset capture, the gains the results
entries name). Each run appends a JSON record under <out>/results/<tag>/ and rebuilds summary.md there, with the
Armor reference next to every test. Nothing keys the radio or transmits from the HackRF without --arm; the
HackRF must not be on the outdoor antenna when --arm is used. SignalDeck's Diagnostics flag must be on.
"""
import argparse
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from common import Config          # noqa: E402
from phone import Phone            # noqa: E402
import hackrf                      # noqa: E402
import report                      # noqa: E402
import tests                       # noqa: E402

KEYING = {"tone", "stream", "heat", "receive", "all"}


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0], formatter_class=argparse.RawDescriptionHelpFormatter, epilog=__doc__)
    ap.add_argument("test", choices=["tag", "boot", "tone", "stream", "heat", "receive", "all"])
    ap.add_argument("--serial"); ap.add_argument("--adb"); ap.add_argument("--hackrf"); ap.add_argument("--out")
    ap.add_argument("--freq", type=int, dest="freq_hz", help="bench frequency in Hz (default 467625000)")
    ap.add_argument("--arm", action="store_true", help="allow keying the radio and transmitting from the HackRF")
    ap.add_argument("--load", help="an image file to load through SignalDeck's loader before the test")
    ap.add_argument("--ms", type=int, default=10000); ap.add_argument("--power", type=int, default=0)
    ap.add_argument("--frames", type=int, default=1125); ap.add_argument("--seconds", type=int, default=45)
    a = ap.parse_args()
    cfg = Config(serial=a.serial, adb=a.adb, hackrf=a.hackrf, out=a.out, freq_hz=a.freq_hz)
    if a.test in KEYING and not a.arm:
        raise SystemExit("%s keys the radio or transmits: add --arm (and make sure the HackRF is on the bench antenna, not the outdoor one)" % a.test)
    if hackrf.running():
        raise SystemExit("hackrf_transfer is already running: a stuck one must be power-cycled before any capture")
    ph = Phone(cfg)
    if not ph.ok():
        raise SystemExit("no adb device at %s" % cfg.serial)
    ph.wake()
    if a.load:
        img = Path(a.load)
        if not img.is_file():
            raise SystemExit("no such image: %s" % img)
        remote = ph.push_download(img, img.name)
        cfg.say("loading %s through SignalDeck" % img.name)
        ph.fw_load(remote)
        t0 = time.time()
        while time.time() - t0 < 420:
            text = ph.logcat(60)
            if "fwload ok(" in text or "fwload done" in text:
                break
            if "fwload " in text and ("refused" in text or "aborted" in text or "failed" in text):
                raise SystemExit("load failed: see logcat")
            time.sleep(5)
    tag = ph.tag(25)
    cfg.say("module tag %s" % (tag or "(not seen in logcat yet)"))
    if a.test == "tag":
        print(tag); return
    order = ["boot", "tone", "stream", "receive", "heat"] if a.test == "all" else [a.test]
    pre_ap = None
    for t in order:
        if t in ("tone", "stream", "heat") and pre_ap is not None:
            # A shorter key waits until mtktsAP is back within 1 C of the previous key's start, or 10 minutes.
            t0 = time.time()
            while time.time() - t0 < 600:
                cur = (ph.zones().get("zones") or {}).get("mtktsAP")
                if cur is None or cur <= pre_ap + 1.0:
                    break
                cfg.say("cool mtktsAP %.2f (pre-key %.2f)" % (cur, pre_ap))
                time.sleep(20)
        if t in ("tone", "stream", "heat"):
            pre_ap = (ph.zones().get("zones") or {}).get("mtktsAP")
        cfg.say("== %s" % t)
        try:
            if t == "boot": rec = tests.boot(cfg, ph)
            elif t == "tone": rec = tests.tone(cfg, ph, a.ms, a.power)
            elif t == "stream": rec = tests.stream(cfg, ph, a.frames)
            elif t == "heat": rec = tests.heat(cfg, ph, a.seconds, a.power)
            else: rec = tests.receive(cfg, ph)
        except Exception as e:
            rec = {"verdict": "ERROR " + str(e)[:200], "numbers": ""}
        path = report.record(cfg, tag, t, rec)
        cfg.say("%s: %s  (%s)" % (t, rec["verdict"], rec.get("numbers", "")))
        cfg.say("   recorded %s" % path)
        if rec["verdict"].startswith("STOP"):
            cfg.say("stop rule hit: not continuing"); break
    cfg.say("summary: %s" % report.summary(cfg, tag))


if __name__ == "__main__":
    main()
