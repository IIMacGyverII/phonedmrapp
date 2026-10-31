# The 23:29 steps on the FW57 already in the module. No image load.
# Does not write the hotspot configuration.
#
# python tools/fw-bench/fw_ritual_rows.py --grant
import re
import shutil
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_ch49_now as ch49  # noqa: E402
import fw_full_rows as fr  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import numpy as np  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402
import fm  # noqa: E402

fr.OUT_NAME = "fw_ritual_rows.json"
HZ = 467625000
PWD = "/sys/devices/platform/dmr009/pwd"
KEEP = ("cmd=0x26", "cmd=0x36", "PTT", "TX watchdog", "SEND_", "RECEIVE_", "module power", "transmission ended")


def redact(text):
    return re.sub(r"\d{6,}", "#", text)


def tx_excerpt(phone):
    _, out = phone.adb("shell", "logcat", "-d", "-t", "4000", "-s", "RadioService:I", timeout=40)
    kept = []
    for line in out.splitlines():
        if "cmd=0x22" in line or "cmd=0x23" in line:
            continue
        if any(k in line for k in KEEP):
            kept.append(redact(line)[-220:])
    return kept[-80:]


def status_view(st):
    ch = st.get("channel") or {}
    return {
        "transmitting": bool(st.get("transmitting")),
        "hearing": bool(st.get("hearing")),
        "ready": bool(st.get("ready")),
        "monitor": bool(st.get("monitor")),
        "promiscuous": bool(st.get("promiscuous")),
        "vfo": bool(st.get("vfo")),
        "txInhibited": bool(st.get("txInhibited")),
        "webTx": bool(st.get("webTx")),
        "rssi": st.get("rssi"),
        "number": ch.get("number"),
        "slot": ch.get("slot"),
        "cc": ch.get("cc"),
        "power": ch.get("power"),
        "digital": bool(ch.get("digital")),
        "rxFreq": ch.get("rxFreq"),
    }


def low_band(cfg, iq_path):
    """40-250 Hz against 300-3000 Hz, and the 20-30 Hz peak of that band's envelope."""
    dev, info = fm.demod(cfg, str(iq_path))
    fs = info["fs"]
    i0, i1 = info["i0"], info["i1"]
    out = {
        "keyed_s": round(info["keyed_s"], 2),
        "carrier_db": info.get("carrier_db"),
        "no_carrier": bool(info.get("no_carrier")),
        "p99_hz": None,
        "low_vs_voice_db": None,
        "env_hz": None,
        "env_db": None,
    }
    if i1 <= i0 + fs:
        return out
    seg = np.asarray(dev[i0:i1], dtype=np.float64)
    out["p99_hz"] = round(float(np.percentile(np.abs(seg), 99)), 1)
    spec = np.fft.rfft(seg * np.hanning(len(seg)))
    freqs = np.fft.rfftfreq(len(seg), 1.0 / fs)
    power = np.abs(spec) ** 2

    def band(lo, hi):
        m = (freqs >= lo) & (freqs < hi)
        return float(np.sum(power[m]))

    voice = band(300, 3000)
    low = band(40, 250)
    if voice > 0 and low > 0:
        out["low_vs_voice_db"] = round(10.0 * np.log10(low / voice), 1)
    mask = ((freqs >= 40) & (freqs < 250)).astype(np.float64)
    bp = np.fft.irfft(spec * mask, n=len(seg))
    specb = np.fft.fft(bp)
    h = np.zeros(len(bp))
    h[0] = 1
    h[1:(len(bp) + 1) // 2] = 2
    if len(bp) % 2 == 0:
        h[len(bp) // 2] = 1
    env = np.abs(np.fft.ifft(specb * h))
    env = env - float(np.mean(env))
    espec = np.abs(np.fft.rfft(env * np.hanning(len(env)))) ** 2
    ef = np.fft.rfftfreq(len(env), 1.0 / fs)
    look = (ef >= 20) & (ef <= 30)
    near = ((ef >= 5) & (ef < 15)) | ((ef > 35) & (ef <= 50))
    if look.any() and near.any() and float(np.median(espec[near])) > 0:
        i = int(np.argmax(espec[look]))
        out["env_hz"] = round(float(ef[look][i]), 2)
        out["env_db"] = round(10.0 * np.log10(float(espec[look][i]) / float(np.median(espec[near]))), 1)
    return out


def on_channel_49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(2.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)
    ch = web.call("/api/channel?number=49").get("channel") or {}
    if int(ch.get("rxFreq") or 0) != HZ or ch.get("power") != 0 or not ch.get("digital"):
        raise SystemExit("channel 49 is not 467.625 low-power digital")
    fr.say(cfg, "channel 49 slot %s cc %s" % (ch.get("slot"), ch.get("cc")))
    return ch


def restart_app(cfg, phone):
    phone.adb("shell", "am", "force-stop", phone.cfg.package)
    time.sleep(2.0)
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(6.0)
    web = None
    st = {}
    for _ in range(15):
        try:
            web = fr.open_web(phone)
            st = web.call("/api/status")
            if st.get("ready"):
                break
        except Exception as exc:
            fr.say(cfg, "web not up %s" % type(exc).__name__)
        time.sleep(2.0)
    if web is None:
        raise SystemExit("web did not return")
    fr.say(cfg, "after restart ready %s transmitting %s tag %s" % (
        bool(st.get("ready")), bool(st.get("transmitting")), phone.tag()))
    return web, status_view(st)


def power_cycle(cfg, phone):
    phone.adb("shell", "su -c 'echo 0 > %s'" % PWD, timeout=20)
    _, off = phone.adb("shell", "su -c cat %s" % PWD, timeout=20)
    fr.say(cfg, "pwd off %s" % redact(off.strip().replace("\n", " "))[:40])
    time.sleep(15.0)
    phone.adb("shell", "su -c 'echo 1 > %s'" % PWD, timeout=20)
    time.sleep(3.0)
    _, on = phone.adb("shell", "su -c cat %s" % PWD, timeout=20)
    fr.say(cfg, "pwd on %s" % redact(on.strip().replace("\n", " "))[:40])
    return "0" in off and "1" in on


def vfo_rows(cfg, phone, web, doc):
    web.call("/api/vfo", gaps.vfo_body())
    time.sleep(gaps.base.SETTLE_S)
    problems = gaps.vfo_ok(web.call("/api/vfo"))
    fr.say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9"))
    if problems:
        raise SystemExit("vfo refused")
    heard = ch49.row(cfg, phone, web, doc, "tg9", "vfoR", "1")
    if not heard["plays"]:
        fr.say(cfg, "vfo tg9 quiet; out-of-list rows not run")
        return
    ch49.row(cfg, phone, web, doc, "tg99", "vfoR", "1")
    ch49.row(cfg, phone, web, doc, "allcall", "vfoR", "1")


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("ritual rows\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "before_header": ""}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("not on FW57; this run does not load an image")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2.0)
        web = fr.open_web(phone)
        st = web.call("/api/status")
        doc["status_before"] = status_view(st)
        doc["log_before"] = tx_excerpt(phone)
        fr.say(cfg, "before transmitting %s vfo %s ready %s log %s" % (
            doc["status_before"]["transmitting"], doc["status_before"]["vfo"],
            doc["status_before"]["ready"], len(doc["log_before"])))
        src = cfg.cap("stream.iq")
        kept = cfg.cap("stream_2311.iq")
        if src.is_file() and not kept.is_file():
            shutil.copy2(src, kept)
        if kept.is_file():
            try:
                doc["lowband_2311"] = low_band(cfg, kept)
            except Exception as exc:
                doc["lowband_2311"] = {"error": type(exc).__name__}
            fr.say(cfg, "2311 low band %s" % doc["lowband_2311"])
            fr.save(cfg, doc)
        gaps.base.heat_ok(cfg, phone)
        on_channel_49(cfg, web)
        ch49.row(cfg, phone, web, doc, "tg9", "as", "1")
        web, doc["status_after_restart"] = restart_app(cfg, phone)
        on_channel_49(cfg, web)
        played = ch49.row(cfg, phone, web, doc, "tg9", "app", "1")
        if played["plays"]:
            vfo_rows(cfg, phone, web, doc)
        import tests
        gaps.base.heat_ok(cfg, phone)
        try:
            doc["stream"] = tests.stream(cfg, phone, frames=250)
        except Exception as exc:
            doc["stream"] = {"verdict": "ERROR", "error": redact(str(exc))[:160]}
            fr.say(cfg, "stream error %s" % doc["stream"]["error"])
        fresh = cfg.cap("stream.iq")
        if fresh.is_file():
            shutil.copy2(fresh, cfg.cap("stream_restart10.iq"))
            doc["lowband_restart"] = low_band(cfg, cfg.cap("stream_restart10.iq"))
            fr.say(cfg, "restart low band %s" % doc["lowband_restart"])
        if not played["plays"]:
            if not power_cycle(cfg, phone):
                fr.say(cfg, "power cycle readback was not off then on")
            web, doc["status_after_power"] = restart_app(cfg, phone)
            if phone.tag() != fr.FW57_TAG:
                raise SystemExit("tag after power cycle is not FW57")
            on_channel_49(cfg, web)
            again = ch49.row(cfg, phone, web, doc, "tg9", "pwr", "1")
            if again["plays"]:
                vfo_rows(cfg, phone, web, doc)
        web = fr.open_web(phone)
        tx = bool(web.call("/api/status").get("transmitting"))
        doc["transmitting"] = tx
        doc["end_tag"] = phone.tag()
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        fr.save(cfg, doc)
        if tx or phone.tag() != fr.FW57_TAG:
            raise SystemExit("end state")
    finally:
        if phone is not None:
            try:
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                fr.say(cfg, "unkey failed %s" % type(exc).__name__)
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception as exc:
            fr.say(cfg, "busy clear failed %s" % type(exc).__name__)


if __name__ == "__main__":
    main()
