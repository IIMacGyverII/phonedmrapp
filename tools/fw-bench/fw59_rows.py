# F59D receive rows, then the raw op 6 guard and the channel 49 key.
# Stops on the first row that is not on the air or goes against the grant.
# Does not write the hotspot configuration.
#
# python tools/fw-bench/fw59_rows.py --grant
import json
import subprocess
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
import sys
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_air  # noqa: E402
import fw58_bisect as bisect  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
from common import Config  # noqa: E402
from hackrf import Capture, running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

TAG = "DMR003.F59D.V022"
IMAGE = HERE.parents[1] / "radio_firmware" / "build" / "DMR003.F59D.V022.bin"
FILES = {"tg99": gaps.base.TG99, "allcall": gaps.base.ALLCALL, "tg9": gaps.base.TG9}
WANT = {"tg99": "99", "allcall": "16777215", "tg9": "9"}

MODEM_PY = r"""
import glob, os, re
files = sorted(glob.glob("/var/log/pi-star/MMDVM-2026-10-*.log"), key=os.path.getmtime)
path = files[-1] if files else ""
text = open(path, errors="replace").read() if path else ""
close_at = text.rfind("Closing DMR Network")
open_at = text.rfind("Opening DMR Network")
def line_at(i):
    if i < 0:
        return "none"
    start = text.rfind("\n", 0, i) + 1
    end = text.find("\n", i)
    return text[start:end if end >= 0 else start + 180]
def scrub(s):
    return re.sub(r"\d{6,}", "#", s)[:180]
print("log", os.path.basename(path))
print("open_after_close", 1 if open_at > close_at else 0)
print("opening", scrub(line_at(open_at)))
print("closing", scrub(line_at(close_at)))
"""


def say(cfg, text):
    cfg.say(gaps.base.redact(text))


def ssh(remote):
    r = subprocess.run(
        ["ssh", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes",
         "pi-star@192.168.1.194", remote],
        capture_output=True, timeout=40)
    text = (r.stdout or b"").decode("utf-8", "replace").strip()
    if r.returncode != 0:
        err = (r.stderr or b"").decode("utf-8", "replace")[-200:]
        raise SystemExit("ssh rc %s %s" % (r.returncode, gaps.base.redact(err)))
    return text


def modem_state(cfg):
    local = cfg.out / "modem_state.py"
    local.write_text(MODEM_PY, encoding="ascii")
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local),
         "pi-star@192.168.1.194:/tmp/modem_state.py"],
        capture_output=True, timeout=40)
    if r.returncode != 0:
        raise SystemExit("scp modem")
    text = ssh("python3 /tmp/modem_state.py")
    say(cfg, text.replace("\n", " | "))
    out = {}
    for line in text.splitlines():
        if " " in line:
            k, v = line.split(" ", 1)
            out[k] = v
    out["open"] = out.get("open_after_close") == "1"
    return out


def file_dst():
    return ssh(
        "python3 -c \"import os,struct;b=open(os.path.expanduser('~/claude-bench/dmr_last.bin'),'rb').read();"
        "n=struct.unpack('>IH',b[:6])[1];d=b[6:6+n];dst=int.from_bytes(d[8:11],'big');"
        "print('99' if dst==99 else ('9' if dst==9 else ('16777215' if dst==16777215 else 'other')))\"")


def restart_modem(cfg):
    before = modem_state(cfg)
    say(cfg, ssh("sudo -n systemctl restart mmdvmhost; echo rc $?"))
    for _ in range(50):
        time.sleep(1)
        now = modem_state(cfg)
        if now.get("open") and now.get("opening") != before.get("opening"):
            return now
    raise SystemExit("modem did not open")


def arm(cfg, kind):
    """Point the relay at the file. Restart the modem only after a relay restart."""
    want = WANT[kind]
    state = modem_state(cfg)
    if file_dst() == want and state.get("open"):
        say(cfg, "relay file already %s and the modem is open" % want)
        return
    if file_dst() != want:
        dest = "%s:~/claude-bench/dmr_last.bin" % gaps.base.PI
        r = subprocess.run(
            ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(FILES[kind]), dest],
            capture_output=True, timeout=60)
        if r.returncode != 0:
            raise SystemExit("scp")
        local = cfg.out / "restart_relay.py"
        local.write_text(bisect.RESTART, encoding="ascii")
        r = subprocess.run(
            ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local),
             "%s:/tmp/restart_relay.py" % gaps.base.PI],
            capture_output=True, timeout=60)
        if r.returncode != 0:
            raise SystemExit("scp restart")
        say(cfg, ssh("python3 /tmp/restart_relay.py"))
        if file_dst() != want:
            raise SystemExit("file is not " + want)
        restart_modem(cfg)
        return
    restart_modem(cfg)


HEADER_PY = r"""
import glob, os, re
files = sorted(glob.glob("/var/log/pi-star/MMDVM-2026-10-*.log"), key=os.path.getmtime)
path = files[-1] if files else ""
lines = open(path, errors="replace").read().splitlines() if path else []
hit = [ln for ln in lines if "network voice header" in ln]
print(re.sub(r"\d{6,}", "#", hit[-1])[-160:] if hit else "none")
"""


def last_header(cfg):
    local = cfg.out / "last_header.py"
    local.write_text(HEADER_PY, encoding="ascii")
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local),
         "pi-star@192.168.1.194:/tmp/last_header.py"],
        capture_output=True, timeout=40)
    if r.returncode != 0:
        raise SystemExit("scp header")
    return gaps.base.redact(ssh("python3 /tmp/last_header.py"))


def header_matches(kind, header):
    if kind == "tg99":
        return "TG 99" in header
    if kind == "allcall":
        return "TG ALL" in header or "16777215" in header
    if kind == "tg9":
        return "TG 9" in header and "TG 99" not in header
    return False


def one(cfg, phone, web, kind, mon, before_header):
    gaps.base.heat_ok(cfg, phone)
    if hackrf_running():
        raise SystemExit("hackrf already running")
    phone.adb("shell", "logcat", "-c")
    web.monitor(mon)
    time.sleep(0.6)
    name = "f59d_%s_%s" % (kind, "on" if mon else "off")
    phone.broadcast("rxclip", "--ei", "ms", "20000", "--es", "name", name)
    clip_t0 = time.time()
    cap = Capture(cfg, name, 12, 24, 24)
    time.sleep(0.3)
    fw58_air.queue()
    time.sleep(4.0)
    log = phone.logcat(20)
    during = bisect.read_pair(cfg, phone)
    iq = cap.wait()
    remain = 21.0 - (time.time() - clip_t0)
    if remain > 0:
        time.sleep(remain)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = gaps.clip_levels(wav)
    header = last_header(cfg)
    ratio = bisect.carrier_ratio(iq)
    fresh = header != before_header and header_matches(kind, header)
    row = {
        "name": name, "kind": kind, "mon": mon,
        "rms": round(rms, 1), "peak": peak, "loud_s": bisect.loud_seconds(wav),
        "during": during, "header": header, "header_fresh": fresh,
        "carrier_ratio": round(ratio, 1), "carrier": ratio >= 10.0,
        "iq": str(iq),
        "reports": gaps.frames_2b(log),
    }
    say(cfg, "%s MON %s rms %.1f peak %s loud %.2f s carrier %.1f fresh %s" % (
        kind, "on" if mon else "off", row["rms"], peak, row["loud_s"], ratio, fresh))
    say(cfg, "header " + header[-140:])
    if not fresh or ratio < 10.0:
        row["verdict"] = "not on air"
        return row
    if row["rms"] >= 400 or row["loud_s"] >= 1.0:
        row["verdict"] = "loud"
    else:
        row["verdict"] = "muted"
    return row


def stop(cfg, doc, why):
    out = cfg.out / "fw59_f59d.json"
    out.write_text(json.dumps(doc, indent=1, default=str), encoding="utf-8")
    say(cfg, "STOP %s" % why)
    say(cfg, "wrote %s" % out)
    raise SystemExit(why)


def main():
    import argparse
    p = argparse.ArgumentParser()
    p.add_argument("--grant", action="store_true")
    args = p.parse_args()
    if not args.grant:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    cfg.out.mkdir(parents=True, exist_ok=True)
    phone = Phone(cfg)
    if not phone.ok():
        raise SystemExit("no phone")
    if phone.cfg.serial != "192.168.1.125:5555":
        raise SystemExit("wrong phone")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    for path in FILES.values():
        if not path.is_file():
            raise SystemExit("missing %s" % path.name)
    if not IMAGE.is_file():
        raise SystemExit("image missing")
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    gaps.base.heat_ok(cfg, phone)
    if phone.tag() != TAG:
        bisect.load(cfg, phone, IMAGE, TAG)
    say(cfg, "tag %s" % phone.tag())
    if phone.tag() != TAG:
        raise SystemExit("tag")
    gaps.base.heat_ok(cfg, phone)
    web = gaps.base.Web(phone)
    web.call("/api/vfo", gaps.vfo_body())
    time.sleep(gaps.base.SETTLE_S)
    problems = gaps.vfo_ok(web.call("/api/vfo"))
    say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9 low power"))
    if problems:
        raise SystemExit("vfo refused")
    doc = {"tag": TAG, "rows": []}
    before = last_header(cfg)
    plan = [("tg99", False, "muted"), ("allcall", False, "loud"),
            ("tg99", True, "loud"), ("tg9", False, "loud")]
    for kind, mon, expect in plan:
        arm(cfg, kind)
        row = one(cfg, phone, web, kind, mon, before)
        if kind == "tg99" and not mon and row.get("carrier") and row.get("iq"):
            row["lc"] = fw58_air.report(row["iq"])
            for ln in row["lc"]:
                say(cfg, ln)
            if not any("dst 99" in ln for ln in row["lc"]):
                doc["rows"].append(row)
                stop(cfg, doc, "voice LC destination is not 99")
        doc["rows"].append(row)
        before = row["header"]
        if row["verdict"] != expect:
            stop(cfg, doc, "%s MON %s is %s, expected %s" % (
                kind, "on" if mon else "off", row["verdict"], expect))
        time.sleep(2)
    web.call("/api/vfo/exit", {})
    time.sleep(2.0)
    web.select(gaps.base.CH49)
    time.sleep(gaps.base.SETTLE_S)
    ch = web.call("/api/channel?number=%d" % gaps.base.CH49).get("channel") or {}
    if ch.get("power") != 0:
        stop(cfg, doc, "channel 49 power is not low")
    say(cfg, "channel 49 digital %s power %s slot %s cc %s" % (
        ch.get("digital"), ch.get("power"), ch.get("slot"), ch.get("cc")))
    doc["op6"] = gaps.op6_triple(cfg, phone, "f59d")
    doc["key"] = gaps.dmr_key(cfg, phone, web)
    out = cfg.out / "fw59_f59d.json"
    out.write_text(json.dumps(doc, indent=1, default=str), encoding="utf-8")
    say(cfg, "wrote %s transmitting %s" % (out, doc["key"].get("transmitting")))
    if doc["key"].get("transmitting"):
        raise SystemExit("still transmitting")


if __name__ == "__main__":
    main()
