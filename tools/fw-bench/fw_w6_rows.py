# W6Plus DMR keys talkgroup 9 and 99 into the Armor.
# Bench id only. Low power, 467.625. The Armor listens. FW57.
#
# python tools/fw-bench/fw_w6_rows.py --grant
import json
import sys
import time
import urllib.request

HERE = __import__("pathlib").Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

W6 = "192.168.1.133:5555"
BENCH_ID = 1234567
ID_FILE = __import__("pathlib").Path(__import__("os").environ["TEMP"]) / "fw1718" / "w6_id.txt"


class Api:
    def __init__(self, phone, port):
        phone.adb("forward", "tcp:%d" % port, "tcp:8080")
        phone.broadcast("web", "--ez", "on", "true")
        rc, xml = phone.adb("shell", "su -c cat /data/data/com.macdmr.radio/shared_prefs/web.xml", timeout=20)
        i = xml.find('<string name="pin">')
        if i < 0:
            raise SystemExit("web pin missing")
        secret = xml[i + len('<string name="pin">'):xml.find("</string>", i)].strip()
        req = urllib.request.Request(
            "http://127.0.0.1:%d/api/login" % port, data=json.dumps({"pin": secret}).encode(), method="POST")
        req.add_header("Content-Type", "application/json")
        del secret
        with urllib.request.urlopen(req, timeout=8) as resp:
            self.cookie = (resp.headers.get("Set-Cookie") or "").split(";")[0]
        self.port = port

    def call(self, path, doc=None):
        data = None if doc is None else json.dumps(doc).encode()
        req = urllib.request.Request(
            "http://127.0.0.1:%d%s" % (self.port, path), data=data, method="GET" if doc is None else "POST")
        req.add_header("Content-Type", "application/json")
        if self.cookie:
            req.add_header("Cookie", self.cookie)
        with urllib.request.urlopen(req, timeout=15) as resp:
            return json.loads(resp.read().decode())


def dmr_id(api):
    for row in api.call("/api/settings").get("settings") or []:
        if row.get("key") == "dmrId":
            return int(row.get("value"))
    raise SystemExit("no dmr id setting")


def set_id(api, value):
    api.call("/api/settings", {"key": "dmrId", "value": int(value)})


def vfo_digital(api, tg):
    api.call("/api/vfo", {
        "type": 0, "rxMHz": 467.625, "txMHz": 467.625, "power": 0,
        "cc": 1, "slot": 1, "contactType": 1, "txContact": str(tg), "groups": "1,9",
    })


def key(api, seconds):
    api.call("/api/ptt", {"down": True})
    time.sleep(seconds)
    api.call("/api/ptt", {"down": False})
    time.sleep(0.8)


def listen(phone, seconds):
    phone.adb("shell", "logcat", "-c")
    time.sleep(seconds)
    return phone.logcat(8)


def summary(text):
    status = []
    targets = []
    for line in text.splitlines():
        if "RX cmd=0x36" in line and "[01]" in line:
            status.append(1)
        elif "RX cmd=0x36" in line and "[02]" in line:
            status.append(2)
        elif "RX cmd=0x2B" in line and "len=9" in line:
            # target is bytes 5..8; the log shows the first bytes in the bracket
            i = line.find("[")
            j = line.find("]", i + 1)
            raw = bytes.fromhex(line[i + 1:j]) if i >= 0 and j > i else b""
            if len(raw) >= 9:
                targets.append((raw[0], int.from_bytes(raw[5:9], "little")))
    return {"status": status, "targets": targets}


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    w6cfg = Config(serial=W6)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("w6 rows\n", encoding="ascii")
    phone = None
    w6 = None
    saved = None
    api = None
    doc = {"rows": []}
    try:
        phone = Phone(cfg)
        w6 = Phone(w6cfg)
        if not phone.ok() or not w6.ok():
            raise SystemExit("phone missing")
        if hackrf_running():
            raise SystemExit("hackrf running")
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("not on FW57")
        phone.wake()
        w6.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        w6.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        web = fr.open_web(phone)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
        api = Api(w6, 18081)
        if api.call("/api/status").get("transmitting"):
            api.call("/api/ptt", {"down": False})
            time.sleep(1)
        saved = dmr_id(api)
        ID_FILE.parent.mkdir(parents=True, exist_ok=True)
        ID_FILE.write_text(str(saved), encoding="ascii")
        set_id(api, BENCH_ID)
        now = dmr_id(api)
        if now != BENCH_ID:
            raise SystemExit("bench id did not take")
        fr.say(cfg, "bench id set")
        gaps.base.heat_ok(cfg, phone)
        web.monitor(False)
        time.sleep(0.3)
        rr.enter_vfo(cfg, web)
        for tg in (9, 99):
            vfo_digital(api, tg)
            time.sleep(2)
            phone.adb("shell", "logcat", "-c")
            key(api, 3)
            doc["rows"].append({"state": "closed", "tg": tg, **summary(phone.logcat(8))})
            fr.say(cfg, "closed tg %s %s" % (tg, doc["rows"][-1]))
        phone.adb(
            "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
            "--es", "cmd", "cmdbyte", "--ei", "b", "48", "--ei", "d", "0")
        time.sleep(0.6)
        phone.adb(
            "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
            "--es", "cmd", "cmdbyte", "--ei", "b", "47", "--ei", "d", "2")
        time.sleep(0.6)
        for tg in (9, 99):
            vfo_digital(api, tg)
            time.sleep(2)
            phone.adb("shell", "logcat", "-c")
            key(api, 3)
            doc["rows"].append({"state": "open", "tg": tg, **summary(phone.logcat(8))})
            fr.say(cfg, "open tg %s %s" % (tg, doc["rows"][-1]))
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
    finally:
        if api is not None and saved is not None:
            try:
                if api.call("/api/status").get("transmitting"):
                    api.call("/api/ptt", {"down": False})
                    time.sleep(0.5)
                set_id(api, saved)
                back = dmr_id(api)
                api.call("/api/vfo", {
                    "type": 1, "rxMHz": 467.625, "txMHz": 467.625, "power": 0, "band": 1, "sq": 2,
                })
                time.sleep(2)
                api.call("/api/m17", {"on": True})
                fr.say(cfg, "w6 id restored %s m17 on" % (back == saved))
            except Exception as exc:
                fr.say(cfg, "w6 restore failed %s" % type(exc).__name__)
        if phone is not None:
            try:
                web = fr.open_web(phone)
                web.call("/api/vfo/exit", {})
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
                doc["end_tag"] = phone.tag()
                doc["transmitting"] = bool(web.call("/api/status").get("transmitting"))
            except Exception as exc:
                fr.say(cfg, "armor restore failed %s" % type(exc).__name__)
        if hackrf_running():
            hackrf.kill()
        try:
            (cfg.out / "fw_w6_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
        except Exception:
            pass
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception:
            pass
        if doc.get("transmitting") or doc.get("end_tag") not in (None, fr.FW57_TAG):
            raise SystemExit("end state")


if __name__ == "__main__":
    main()
