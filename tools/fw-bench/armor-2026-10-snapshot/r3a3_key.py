# R3a3 key only. The boot of this image is already measured (r3a3_boot.json:
# 143 s, peak +0.11 dB, clip 0). Phone TX only on 467.625 MHz, low power.
# HackRF receive only. One 3 s key. Restore the factory image and leave the
# VFO on 467.625. Does not call vfo_off. Does not start a capture until the
# previous HackRF process has closed on its own.
import sys, time
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3a3_run

IMAGE = camp.BUILD / "DMR003.R3a3.V022.bin"
TAG = "DMR003.R3a3.V022"
KEY_S = 12.0
TONE_MS = 3000
CAP = camp.CAP


def probe():
    path = CAP / "r3a3_probe.iq"
    proc, hlog, _ = r3a3_run.hackrf_recv(path, 2.0)
    try:
        proc.wait(timeout=15)
    finally:
        hlog.close()
    size = path.stat().st_size if path.exists() else 0
    tail = Path(str(path) + ".hackrf.log").read_text(encoding="utf-8", errors="replace")[-300:]
    camp.say("hackrf probe %d bytes %s" % (size, tail.replace("\n", " ")[-180:]))
    return size > 1_000_000


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R3a3 image missing or wrong size")
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    r3a3_run.devices_ok()
    if not probe():
        time.sleep(3)
        if not probe():
            raise SystemExit("hackrf is not transferring; not loading and not keying")
    camp.adb("shell", "input", "keyevent", "224")
    camp.tune()
    started = False
    try:
        started = True
        loaded = camp.load_image(IMAGE)
        camp.say("loaded %s" % loaded)
        if loaded != TAG:
            raise RuntimeError("version %s is not %s" % (loaded, TAG))
        camp.tune()
        iq = CAP / "r3a3.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(iq, KEY_S)
        try:
            time.sleep(1.5)
            size = iq.stat().st_size if iq.exists() else 0
            camp.say("key capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the key; not transmitting")
            rc, bout = camp.broadcast(["--es", "cmd", "testtone", "--ei", "ms", str(TONE_MS)])
            camp.say("testtone rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
            proc.wait(timeout=KEY_S + 25)
        finally:
            if proc.poll() is None:
                proc.wait(timeout=KEY_S + 25)
            hlog.close()
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I")[1]
        (camp.HERE / "r3a3_key.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "test tone" in ln or "played " in ln or "TX " in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-180:] for h in hits[-8:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        if iq.stat().st_size < 1_000_000:
            raise RuntimeError("key capture too small: %d" % iq.stat().st_size)
        result = r3a3_run.analyze_key(iq)
        (camp.HERE / "r3a3.json").write_text(
            __import__("json").dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        camp.say("key class %s keyed %.2f s snr %.1f clip %.4f offset %+.0f p99 %s f15 %s f1k %s STOP %s" % (
            result["square"].get("class"), result["carrier"].get("keyed_s", 0),
            result["carrier"].get("snr_db", 0), result["carrier"].get("clip_frac", 0),
            result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("f15_hz"), st.get("f1k_hz"), st.get("STOP")))
        camp.say("peaks " + __import__("json").dumps(st.get("peaks")))
        camp.say("slices " + __import__("json").dumps(st.get("slices")))
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if started:
            try:
                r3a3_run.restore_factory()
                camp.say("R3a3 key finished, factory image, VFO 467.625")
            except Exception as exc:
                camp.say("FACTORY RESTORE FAILED: %s" % exc)
                raise


if __name__ == "__main__":
    main()
