# FW62 bench. Factory image and one key before F62P, again before FW62,
# and again before FW57. The Armor is not keyed except the factory key,
# the runner, and the one channel-49 key at the end.
# W6Plus keying is key.sh for 3000 ms. Stop on the first unexpected row.
#
# python tools/fw-bench/fw_fw62_rows.py --self-check
# python tools/fw-bench/fw_fw62_rows.py --grant
import hashlib
import json
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_f62d_rows as prev  # noqa: E402
import fw_full_rows as fr  # noqa: E402
import fw_fw60_rows as ram  # noqa: E402
import fw_promisc_rows as prom  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw_w6_listen as listen  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import fw58_steps as steps  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

ROOT = HERE.parents[1]
BUILD = ROOT / "radio_firmware" / "build"
F62P = BUILD / "DMR003.F62P.V022.bin"
FW62 = BUILD / "DMR003.FW62.V022.bin"
F62P_TAG = "DMR003.F62P.V022"
FW62_TAG = "DMR003.FW62.V022"
F62P_SHA = "2f16bc09bf1fe51652a1cd07c77ac5d973d138e8509861a55bd3298b2369b944"
FW62_SHA = "9a59307585c8b0d9caedef60e03cfd2dffff49a5533b42622d4de63766436dac"
CLIP_S = 8
TONE_DB = 6.0
LEASE_END = (13, 25)


def self_check():
    for path, sha, tag in ((F62P, F62P_SHA, F62P_TAG), (FW62, FW62_SHA, FW62_TAG)):
        if not path.is_file():
            raise SystemExit("missing %s" % path.name)
        blob = path.read_bytes()
        if hashlib.sha256(blob).hexdigest() != sha:
            raise SystemExit("sha %s" % path.name)
        if blob[0x38464:0x38474] != tag.encode("ascii"):
            raise SystemExit("tag bytes %s" % path.name)
    if not prev.KEY_WIN.is_file():
        raise SystemExit("key.sh missing")
    print("self-check ok")


def lease_open():
    now = time.localtime()
    return (now.tm_hour, now.tm_min) < LEASE_END


def uart_quiet(text):
    last_tx = last_rx = None
    for i, line in enumerate(text.splitlines()):
        if "TX cmd=0x32" in line:
            last_tx = i
        if "RX cmd=0x32" in line or "RX cmd=0x2B" in line or "RX cmd=0x36" in line:
            last_rx = i
    return last_tx is not None and (last_rx is None or last_tx > last_rx)


def bodies(status):
    return [s["body"].replace(" ", "") for s in status]


def voice_status(status):
    return [b for b in bodies(status) if b in ("01", "02", "0A", "0B")]


def tone_on(audio):
    """A noise-floor bin ratio can clear 6 dB while the sample RMS stays near 2.
    A real 1 kHz call in these clips sits near RMS 2000."""
    db = (audio or {}).get("line_db")
    rms = (audio or {}).get("rms") or 0
    return db is not None and db >= TONE_DB and rms >= 50


def has_target(reports, want):
    for row in reports:
        if row.get("type") == 1 and str(row.get("target")) == str(want) and row.get("len", 0) >= 9:
            return True
    return False


def fast_ram(cfg, phone, remote, addr):
    """Op 14 of a body already in the app cache. Sleep matches the read that returned a full dump."""
    phone.broadcast("raw40", "--es", "path", remote)
    time.sleep(0.7)
    local = cfg.out / ("ram_%X.bin" % addr)
    phone.pull_app("/data/data/%s/cache/raw40.bin" % phone.cfg.package, local)
    return local.read_bytes() if local.is_file() else b""


def call_up(text):
    for line in text.splitlines():
        if "RX cmd=0x36" in line and ("[0A]" in line or "[01]" in line):
            return True
    return False


def w6_row(cfg, phone, label, key_name, with_ram, query):
    if prev.phone_tx(phone):
        raise SystemExit("armor is transmitting")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    steps.heat_ok(cfg, phone)
    gate_remote = table_remote = None
    if with_ram:
        gate_remote = gaps.base.push_body(phone, gaps.base.op14(0x4C7BC, 20), "op14_4C7BC.bin")
        table_remote = gaps.base.push_body(phone, gaps.base.op14(0x4D318, 64), "op14_4D318.bin")
    phone.adb("shell", "logcat", "-c")
    log_path = cfg.out / (label + ".log")
    handle = open(log_path, "w", encoding="utf-8", errors="replace", buffering=1)
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    t0 = time.time()
    phone.rx_clip(label, CLIP_S * 1000)
    proc = subprocess.Popen(
        [listen.BASH, listen.KEY, listen.NAMES[key_name], "3000"],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    seen = None
    try:
        if with_ram or query:
            deadline = time.time() + 12
            while time.time() < deadline and proc.poll() is None:
                if call_up(phone.logcat(2)):
                    # No logcat -c here: that wipe drops the status line the file still needs.
                    # Beta.25 does not ask for 0x2B on its own.
                    phone.broadcast("cmdbyte", "--ei", "b", "43", "--ei", "d", "1")
                    if with_ram:
                        gate = fast_ram(cfg, phone, gate_remote, 0x4C7BC)
                        table = fast_ram(cfg, phone, table_remote, 0x4D318)
                        seen = ram.slot_view(gate, table)
                    break
                time.sleep(0.05)
        out, _ = proc.communicate(timeout=40)
    finally:
        if proc.poll() is None:
            proc.kill()
    lines = prev.redact(out or "").strip().splitlines()
    fr.say(cfg, "key %s rc %s %s" % (key_name, proc.returncode, (lines[-1] if lines else "")[-120:]))
    remain = CLIP_S - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    log_proc.terminate()
    try:
        log_proc.wait(timeout=3)
    except Exception:
        log_proc.kill()
    handle.close()
    text = log_path.read_text(encoding="utf-8", errors="replace")
    wav = cfg.out / (label + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_clip.wav" % phone.cfg.package, wav)
    audio = {"rms": 0, "line_db": None}
    if wav.is_file():
        try:
            audio = listen.tone_line(wav)
        except Exception:
            audio = {"rms": 0, "line_db": None}
    clip = wav.is_file() and wav.stat().st_size > 1000 and audio.get("line_db") is not None
    row = {
        "label": label,
        "key": key_name,
        "rc": proc.returncode,
        "status": prom.rx_status(text),
        "reports": prom.reports(text)[:8],
        "audio": audio,
        "ram": seen,
        "clip": clip,
        "quiet": uart_quiet(text),
    }
    fr.say(cfg, "%s status %s tone %s reports %s ram %s clip %s quiet %s" % (
        label, voice_status(row["status"]), audio.get("line_db"),
        [(r.get("len"), r.get("type"), r.get("target")) for r in row["reports"]],
        seen, clip, row["quiet"]))
    return row


def expect_silent(row):
    return (row.get("clip") and not voice_status(row["status"])
            and not tone_on(row["audio"]) and not row["quiet"])


def expect_flag(row, start, stop, target, tone):
    got = voice_status(row["status"])
    ok = row.get("clip") and start in got and stop in got and not row["quiet"]
    if target is not None:
        ok = ok and has_target(row["reports"], target)
    if tone:
        ok = ok and tone_on(row["audio"])
    else:
        ok = ok and not tone_on(row["audio"])
    return ok


def set_flag(cfg, phone, value, label):
    got = prom.raw40(cfg, phone, [15, value], label)
    reply = got.get("reply") or []
    if not reply or reply[0] != value:
        return got, "flag reply %s" % reply
    return got, None


def run_rows(cfg, phone, tag, with_ram):
    doc = {"tag": tag, "rows": []}
    prom.cmdbyte(cfg, phone, 0x2F, 2)
    flagged, why = set_flag(cfg, phone, 0, tag + "_off")
    doc["flag_off"] = flagged
    if why:
        doc["stopped"] = why
        return doc
    plan = (
        ("off_tg99", "tg99", None, "silent"),
        ("on_tg99", "tg99", 1, "on99"),
        ("on_tg9", "tg9", None, "on9"),
        ("off_tg99b", "tg99", 0, "silent"),
        ("off_tg9", "tg9", None, "off9"),
    )
    for label, key_name, flag, kind in plan:
        if not lease_open():
            doc["stopped"] = "lease clock"
            return doc
        full = "%s_%s" % (tag, label)
        if flag is not None:
            flagged, why = set_flag(cfg, phone, flag, full)
            doc["flag_%s" % label] = flagged
            if why:
                doc["stopped"] = why
                return doc
        row = w6_row(cfg, phone, full, key_name, with_ram and kind == "on99",
                     kind in ("on99", "on9", "off9"))
        doc["rows"].append(row)
        if row["quiet"]:
            doc["stopped"] = "uart quiet during " + full
            return doc
        if not row.get("clip"):
            doc["stopped"] = "clip missing " + full
            return doc
        if kind == "silent":
            ok = expect_silent(row)
        elif kind == "on99":
            ok = expect_flag(row, "0A", "0B", 99, True)
            ramv = row.get("ram") or {}
            if with_ram and (str(ramv.get("word")) != "99" or ramv.get("match14") != 1):
                ok = False
                doc["ram_bad"] = ramv
        elif kind == "on9":
            ok = expect_flag(row, "0A", "0B", 9, True)
        else:
            # Reviews row 4 asks for 01/02 and the tone. The report is recorded either way.
            ok = expect_flag(row, "01", "02", None, True)
        if not ok:
            doc["stopped"] = "unexpected " + full
            return doc
    return doc


def runner_all(cfg):
    proc = subprocess.run(
        [sys.executable, str(HERE / "runner" / "bench.py"), "--arm", "all", "--serial", cfg.serial],
        cwd=str(HERE / "runner"), text=True, timeout=2400,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return {"rc": proc.returncode, "tail": (proc.stdout or "")[-1500:]}


def main():
    if "--self-check" in sys.argv:
        self_check()
        return
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    self_check()
    cfg = Config()
    if cfg.serial != "192.168.1.125:5555" or cfg.freq_hz != 467625000:
        raise SystemExit("bench target")
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("fw62 rows\n", encoding="ascii")
    phone = None
    doc = {"images": []}
    try:
        phone = Phone(cfg)
        if not phone.ok():
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        if prev.phone_tx(phone):
            raise SystemExit("armor is transmitting")
        images = (
            (F62P, F62P_TAG, F62P_SHA, True),
            (FW62, FW62_TAG, FW62_SHA, False),
        )
        if "--fw62-only" in sys.argv:
            images = ((FW62, FW62_TAG, FW62_SHA, False),)
        for image, tag, sha, ram_ok in images:
            if not lease_open():
                doc["stopped"] = "lease clock before " + tag
                break
            web = prev.load_after_factory(cfg, phone, image, tag)
            if phone.tag() != tag:
                doc["stopped"] = "tag is not " + tag
                break
            if web.call("/api/status").get("transmitting"):
                web.call("/api/ptt", {"down": False})
                time.sleep(0.5)
            steps.heat_ok(cfg, phone)
            rr.enter_vfo(cfg, web)
            part = run_rows(cfg, phone, tag, ram_ok)
            part["sha"] = sha
            doc["images"].append(part)
            if part.get("stopped"):
                doc["stopped"] = part["stopped"]
                break
            if tag == FW62_TAG and not lease_open():
                doc["runner"] = "not started, clock"
            elif tag == FW62_TAG and lease_open():
                now = time.localtime()
                if (now.tm_hour, now.tm_min) >= (13, 15):
                    doc["runner"] = "not started, clock"
                    doc["m17_rx"] = "not run, no M17 source on this lease"
                    continue
                try:
                    web.call("/api/vfo/exit", {})
                except Exception:
                    pass
                time.sleep(1.0)
                doc["runner"] = runner_all(cfg)
                web = fr.open_web(phone)
                web.select(steps.CH56)
                time.sleep(steps.SETTLE_S)
                doc["m17"] = [steps.m17(cfg, phone, True), steps.m17(cfg, phone, False)]
                doc["op6"] = gaps.op6_triple(cfg, phone, "fw62")
                web.select(gaps.base.CH49)
                time.sleep(gaps.base.SETTLE_S)
                doc["ch49"] = gaps.dmr_key(cfg, phone, web)
        got = prev.restore(cfg, phone)
        doc["end"] = {
            "tag": got,
            "transmitting": prev.phone_tx(phone),
            "heat": steps.heat_ok(cfg, phone),
        }
    finally:
        if hackrf_running():
            import hackrf
            hackrf.kill()
        if phone is not None and doc.get("end") is None:
            try:
                got = prev.restore(cfg, phone)
                doc["end"] = {"tag": got, "transmitting": prev.phone_tx(phone), "cleanup": True}
            except BaseException as exc:
                fr.say(cfg, "cleanup failed %s" % type(exc).__name__)
        try:
            (cfg.out / "fw_fw62_rows.json").write_text(
                json.dumps(doc, indent=1, default=str), encoding="utf-8")
        except Exception:
            pass
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception:
            pass
    end = doc.get("end") or {}
    if end.get("transmitting") or end.get("tag") not in (None, fr.FW57_TAG):
        raise SystemExit("end state")


if __name__ == "__main__":
    main()
