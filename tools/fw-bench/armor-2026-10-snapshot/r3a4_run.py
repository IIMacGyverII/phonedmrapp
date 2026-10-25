# R3a4: the R3a3 stub at A = 512. One 3 s silence key.
# Phone TX only on 467.625 MHz, low power. HackRF receive only.
# The boot capture closes on its sample count before the key capture opens.
# Does not call vfo_off. Does not raise A again. A steady |deviation|
# at or above 5 kHz restores the factory image and stops.
import json, sys, time

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import factory_boot
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R3a4.V022.bin"
TAG = "DMR003.R3a4.V022"
BOOT_S = 180.0
KEY_S = 12.0
CAP = camp.CAP
HERE = camp.HERE


def finish_capture(proc, hlog, seconds):
    try:
        proc.wait(timeout=seconds + 30)
    finally:
        if proc.poll() is None:
            proc.wait(timeout=seconds + 30)
        hlog.close()


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R3a4 image missing or wrong size")
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    r3a3_run.devices_ok()
    wav = r3a3_silence.write_silence()
    camp.install_wav(wav, "silence")
    if not r3a3_silence.probe():
        time.sleep(3)
        if camp.hackrf_running() or not r3a3_silence.probe():
            raise SystemExit("hackrf is not transferring; not loading and not keying")
    camp.adb("shell", "input", "keyevent", "224")
    camp.tune()
    started = False
    stop = False
    try:
        boot_iq = CAP / "r3a4_boot.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(boot_iq, BOOT_S)
        try:
            time.sleep(1.5)
            size = boot_iq.stat().st_size if boot_iq.exists() else 0
            camp.say("boot capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the load; not loading")
            started = True
            loaded = camp.load_image(IMAGE)
            camp.say("loaded %s" % loaded)
            if loaded != TAG:
                raise RuntimeError("version %s is not %s" % (loaded, TAG))
        finally:
            finish_capture(proc, hlog, BOOT_S)
        info = factory_boot.analyze(1.5, boot_iq)
        (HERE / "r3a4_boot.json").write_text(json.dumps(info, indent=2), encoding="utf-8")
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        if info["peak_db"] >= 6.0 or info["above_10db_s"] >= 0.2:
            raise RuntimeError("boot radiated; not keying")
        time.sleep(3)
        camp.tune()
        iq = CAP / "r3a4_silence.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(iq, KEY_S)
        try:
            time.sleep(1.5)
            size = iq.stat().st_size if iq.exists() else 0
            camp.say("key capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the key; not transmitting")
            rc, bout = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
            camp.say("txwav rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
            finish_capture(proc, hlog, KEY_S)
        except Exception:
            if proc.poll() is None:
                finish_capture(proc, hlog, KEY_S)
            raise
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
        (HERE / "r3a4_silence.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "bench wav" in ln or "module DMR" in ln or "cmd=0x26" in ln or "cmd=0x36" in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-160:] for h in hits[-8:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        result = r3a3_silence.steady_fft(iq)
        (HERE / "r3a4_silence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        camp.say("silence keyed %.2f s snr %.1f clip %.4f offset %+.0f steady_p99 %s click_p99 %s STOP %s" % (
            result["carrier"].get("keyed_s", 0), result["carrier"].get("snr_db", 0),
            result["carrier"].get("clip_frac", 0), result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("click_p99_hz"), result.get("STOP")))
        camp.say("lines " + json.dumps(st.get("lines")))
        stop = bool(result.get("STOP"))
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if started:
            r3a3_silence.restore_factory()
            camp.say("R3a4 finished, factory image, VFO 467.625")
    if stop:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
