# Bisect rows for F58A and F58B. Does not write the hotspot configuration.
# A row counts only with a new MMDVMHost voice header and a HackRF carrier.
#
# python tools/fw-bench/fw58_bisect.py --grant --tag DMR003.F58B.V022 --rows tg99,allcall
import argparse
import json
import subprocess
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
import sys
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_air  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
from common import Config  # noqa: E402
from hackrf import Capture  # noqa: E402
from phone import Phone  # noqa: E402

ROOT = HERE.parents[1]
BUILD = ROOT / "radio_firmware" / "build"
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
FILES = {"tg99": gaps.base.TG99, "allcall": gaps.base.ALLCALL}


def say(cfg, text):
    cfg.say(gaps.base.redact(text))


def ssh(remote):
    r = subprocess.run(
        ["ssh", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes",
         "pi-star@192.168.1.194", remote],
        capture_output=True, timeout=40)
    return (r.stdout or b"").decode("utf-8", "replace").strip()


def last_header():
    return gaps.base.redact(ssh(
        "python3 -c \"import re;lines=open('/var/log/pi-star/MMDVM-2026-10-30.log',errors='replace').read().splitlines();"
        "hit=[ln for ln in lines if 'network voice header' in ln];"
        "print(re.sub(r'\\\\d{6,}','#',hit[-1])[-160:] if hit else 'none')\""))


def file_dst():
    return ssh(
        "python3 -c \"import os,struct;b=open(os.path.expanduser('~/claude-bench/dmr_last.bin'),'rb').read();"
        "n=struct.unpack('>IH',b[:6])[1];d=b[6:6+n];dst=int.from_bytes(d[8:11],'big');"
        "print('99' if dst==99 else ('16777215' if dst==16777215 else 'other'))\"")


RESTART = r"""
import os, signal, time
def pids():
    out = []
    for name in os.listdir("/proc"):
        if not name.isdigit():
            continue
        try:
            cmd = open("/proc/" + name + "/cmdline", "rb").read()
        except OSError:
            continue
        if b"m17relay.py" in cmd:
            out.append(int(name))
    return out
old = pids()
for p in old:
    try:
        os.kill(p, signal.SIGTERM)
    except OSError:
        pass
time.sleep(6)
print("fresh", len(pids()))
"""


def last_open():
    return ssh("grep 'Opening DMR Network' /var/log/pi-star/MMDVM-2026-10-30.log | tail -1")


def wait_open(previous):
    for _ in range(40):
        now = last_open()
        if now and now != previous:
            return True
        time.sleep(1)
    return False


def arm(cfg, kind):
    """Make the relay's in-memory call the requested file, and the modem open."""
    want = "99" if kind == "tg99" else "16777215"
    if file_dst() == want:
        say(cfg, "relay file already " + want)
        return
    dest = "%s:~/claude-bench/dmr_last.bin" % gaps.base.PI
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(FILES[kind]), dest],
        capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp")
    local = cfg.out / "restart_relay.py"
    local.write_text(RESTART, encoding="ascii")
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local),
         "%s:/tmp/restart_relay.py" % gaps.base.PI],
        capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp restart")
    say(cfg, ssh("python3 /tmp/restart_relay.py"))
    previous = last_open()
    say(cfg, ssh("sudo -n systemctl restart mmdvmhost; echo rc $?"))
    if not wait_open(previous):
        raise SystemExit("modem did not open")
    say(cfg, "modem open, file " + file_dst())


def load(cfg, phone, image, tag):
    remote = "/sdcard/Download/DMR/Firmware/" + Path(image).name
    rc, _out = phone.adb("push", str(image), remote, timeout=180)
    if rc != 0:
        raise SystemExit("push")
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("fwload", "--es", "file", remote)
    t0 = time.time()
    while time.time() - t0 < 360:
        time.sleep(15)
        got = phone.tag(wait_s=5)
        say(cfg, "loading %s" % (got or "no tag yet"))
        if got == tag:
            return
        log = phone.logcat(6)
        if "fwload refused" in log or "fwload io-error" in log or "fwload bad" in log:
            raise SystemExit("fwload failed")
    raise SystemExit("fwload timed out")


def words(blob):
    out = []
    for i in range(0, len(blob) - 3, 4):
        out.append(gaps.base.show_word(int.from_bytes(blob[i:i + 4], "little")))
    return out


def describe(blob):
    return {
        "len": len(blob),
        "b2": blob[2] if len(blob) > 2 else None,
        "gate": blob[0x13] if len(blob) > 0x13 else None,
        "words": words(blob),
    }


def read_pair(cfg, phone):
    a, _ = gaps.base.read_ram(cfg, phone, 0x4C7BC, 20)
    b, _ = gaps.base.read_ram(cfg, phone, 0x4D318, 64)
    return {"c7bc": describe(a), "d318": describe(b)}


def carrier_ratio(path):
    import numpy as np
    x = np.fromfile(path, dtype=np.int8).astype("float32")
    fs = 2.4e6
    n = len(x) // 2
    iq = (x[0::2] + 1j * x[1::2]) * np.exp(-2j * np.pi * 240e3 * np.arange(n) / fs)
    win = int(0.2 * fs)
    pwr = [float(np.mean(np.abs(iq[i * win:(i + 1) * win]) ** 2)) for i in range(n // win)]
    floor = sorted(pwr)[max(0, len(pwr) // 5)]
    return (max(pwr) / floor) if floor else 0.0


def loud_seconds(path):
    import wave
    from array import array
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    w.close()
    s = array("h")
    s.frombytes(raw[:len(raw) - (len(raw) % 2)])
    win = 400
    loud = 0
    for i in range(0, len(s) - win, win):
        chunk = s[i:i + win]
        rms = (sum(x * x for x in chunk) / len(chunk)) ** 0.5
        if rms > 400:
            loud += 1
    return round(loud * 0.05, 2)


def one(cfg, phone, web, name, before_header):
    phone.adb("shell", "logcat", "-c")
    web.monitor(False)
    time.sleep(0.6)
    before = read_pair(cfg, phone)
    phone.broadcast("rxclip", "--ei", "ms", "20000", "--es", "name", name)
    clip_t0 = time.time()
    cap = Capture(cfg, name, 12, 24, 24)
    time.sleep(0.3)
    fw58_air.queue()
    time.sleep(3.4)
    during = read_pair(cfg, phone)
    iq = cap.wait()
    remain = 21.0 - (time.time() - clip_t0)
    if remain > 0:
        time.sleep(remain)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = gaps.clip_levels(wav)
    header = last_header()
    ratio = carrier_ratio(iq)
    fresh = header != before_header and ("TG 99" in header or "TG ALL" in header or "16777215" in header)
    row = {
        "name": name, "rms": round(rms, 1), "peak": peak, "loud_s": loud_seconds(wav),
        "before": before, "during": during, "header": header, "header_fresh": fresh,
        "carrier_ratio": round(ratio, 1), "carrier": ratio >= 10.0,
    }
    say(cfg, "%s rms %.1f loud %.2f s carrier %.1f fresh %s b2 %s->%s gate %s->%s" % (
        name, row["rms"], row["loud_s"], ratio, fresh,
        before["c7bc"]["b2"], during["c7bc"]["b2"],
        before["c7bc"]["gate"], during["c7bc"]["gate"]))
    say(cfg, "header " + header[-140:])
    if not fresh or ratio < 10.0:
        raise SystemExit("row not on air")
    return row


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--grant", action="store_true")
    p.add_argument("--tag", required=True)
    p.add_argument("--rows", required=True)
    p.add_argument("--load-factory", action="store_true")
    args = p.parse_args()
    if not args.grant:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    phone = Phone(cfg)
    if not phone.ok():
        raise SystemExit("no phone")
    if args.load_factory:
        load(cfg, phone, FACTORY, "DMR003.UV4T.V022")
        say(cfg, "factory loaded")
        return
    image = BUILD / (args.tag + ".bin")
    if not image.is_file():
        raise SystemExit("image missing")
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    if phone.tag() != args.tag:
        load(cfg, phone, image, args.tag)
    gaps.base.heat_ok(cfg, phone)
    web = gaps.base.Web(phone)
    web.call("/api/vfo", gaps.vfo_body())
    time.sleep(gaps.base.SETTLE_S)
    problems = gaps.vfo_ok(web.call("/api/vfo"))
    say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9"))
    if problems:
        raise SystemExit("vfo refused")
    rows = []
    before = last_header()
    for kind in args.rows.split(","):
        arm(cfg, kind)
        rows.append(one(cfg, phone, web, args.tag[-4:] + "_" + kind, before))
        before = rows[-1]["header"]
        time.sleep(2)
    web.call("/api/vfo/exit", {})
    out = cfg.out / ("fw58_bisect_%s.json" % args.tag[-4:])
    out.write_text(json.dumps(rows, indent=1), encoding="utf-8")
    say(cfg, "wrote %s" % out)


if __name__ == "__main__":
    main()
