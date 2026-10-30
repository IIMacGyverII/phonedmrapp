# F58D or factory rows for the 18:08 grant. Does not restart the relay.
# A row counts only when MMDVMHost logs a network voice header and the HackRF
# sees a carrier. The voice-LC source is never printed.
#
# python tools/fw-bench/fw58_ab.py --grant
import argparse
import re
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_air  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
from common import Config  # noqa: E402
from hackrf import Capture  # noqa: E402
from phone import Phone  # noqa: E402

SSH = [
    "ssh", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes",
    "pi-star@192.168.1.194",
    "python3 -c \"import re;lines=open('/var/log/pi-star/MMDVM-2026-10-30.log',errors='replace').read().splitlines();hit=[ln for ln in lines if 'network voice header' in ln];print(re.sub(r'\\\\d{6,}','#',hit[-1])[-160:] if hit else 'none')\"",
]


def say(cfg, text):
    cfg.say(gaps.base.redact(text))


def last_header():
    r = subprocess.run(SSH, capture_output=True, timeout=25)
    return gaps.base.redact((r.stdout or b"").decode("utf-8", "replace").strip())


def carrier(path):
    import numpy as np
    x = np.fromfile(path, dtype=np.int8).astype("float32")
    fs = 2.4e6
    n = len(x) // 2
    iq = (x[0::2] + 1j * x[1::2]) * np.exp(-2j * np.pi * 240e3 * np.arange(n) / fs)
    win = int(0.2 * fs)
    pwr = [float(np.mean(np.abs(iq[i * win:(i + 1) * win]) ** 2)) for i in range(n // win)]
    floor = sorted(pwr)[max(0, len(pwr) // 5)]
    ratio = (max(pwr) / floor) if floor else 0.0
    return ratio


def one(cfg, phone, web, name, mon, before_header):
    phone.adb("shell", "logcat", "-c")
    web.monitor(mon)
    time.sleep(0.6)
    phone.broadcast("rxclip", "--ei", "ms", "20000", "--es", "name", name)
    clip_t0 = time.time()
    time.sleep(0.3)
    cap = Capture(cfg, name, 12, 24, 24)
    time.sleep(0.3)
    fw58_air.queue()
    time.sleep(6.0)
    early = gaps.dump_log(phone)
    a, _ = gaps.base.read_ram(cfg, phone, 0x4C59C, 20)
    b, _ = gaps.base.read_ram(cfg, phone, 0x4C7A0, 16)
    iq = cap.wait()
    remain = 21.0 - (time.time() - clip_t0)
    if remain > 0:
        time.sleep(remain)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = gaps.clip_levels(wav)
    reports = gaps.frames_2b(early + "\n" + gaps.dump_log(phone))
    header = last_header()
    ratio = carrier(iq)
    fresh = header != before_header and "TG 99" in header
    row = {
        "name": name, "mon": mon, "rms": round(rms, 1), "peak": peak,
        "c59c": gaps.base.show_word(gaps.base.word_at(a, 0xC)),
        "c7a0": gaps.base.show_word(gaps.base.word_at(b, 4)),
        "reports": reports[:4],
        "status": gaps.status_bytes(early),
        "header": header, "header_fresh": fresh,
        "carrier_ratio": round(ratio, 1),
        "carrier": ratio >= 10.0,
    }
    say(cfg, "%s MON %s rms %.1f peak %d word %s target %s carrier %.1f fresh %s" % (
        name, "on" if mon else "off", rms, peak, row["c59c"], row["c7a0"], ratio, fresh))
    for rep in reports[:4]:
        say(cfg, "0x2B len %d type %d target %s caller %s [%s]" % (
            rep["len"], rep["type"], rep["target"], rep["caller"], rep["body"]))
    say(cfg, "header " + header[-140:])
    if not fresh or ratio < 10.0:
        raise SystemExit("row not on air")
    return row


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--grant", action="store_true")
    p.add_argument("--tag", default="DMR003.F58D.V022")
    p.add_argument("--prefix", default="f58d")
    args = p.parse_args()
    if not args.grant:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    phone = Phone(cfg)
    if not phone.ok():
        raise SystemExit("no phone")
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    tag = phone.tag()
    say(cfg, "tag %s" % (tag or "none"))
    if tag != args.tag:
        raise SystemExit("tag is not " + args.tag)
    gaps.base.heat_ok(cfg, phone)
    web = gaps.base.Web(phone)
    say(cfg, web.call("/api/vfo", gaps.vfo_body()).get("message", "vfo"))
    time.sleep(gaps.base.SETTLE_S)
    problems = gaps.vfo_ok(web.call("/api/vfo"))
    say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9"))
    if problems:
        raise SystemExit("vfo refused")
    before = last_header()
    say(cfg, "header before " + before[-120:])
    rows = []
    rows.append(one(cfg, phone, web, args.prefix + "_off", False, before))
    before = rows[-1]["header"]
    time.sleep(2.0)
    rows.append(one(cfg, phone, web, args.prefix + "_on", True, before))
    web.call("/api/vfo/exit", {})
    import json
    out = cfg.out / ("fw58_ab_%s.json" % args.prefix)
    out.write_text(json.dumps(rows, indent=1), encoding="utf-8")
    say(cfg, "wrote %s" % out)


if __name__ == "__main__":
    main()
