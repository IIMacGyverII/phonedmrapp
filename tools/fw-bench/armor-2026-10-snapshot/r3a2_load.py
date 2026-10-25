# Load R3a2 while the HackRF records 467.625. Receive only. No test tone here.
# The VFO is tuned first. HackRF is killed once the loader returns and the
# version line has been read, so a failed hand-back does not leave it running.
import subprocess, sys, time
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

IMAGE = camp.BUILD / "DMR003.R3a2.V022.bin"
CAP_S = 260.0
IQ = camp.CAP / "r3a2_boot.iq"
HLOG = camp.CAP / "r3a2_boot.hackrf.log"
LLOG = camp.HERE / "r3a2_load.logcat.txt"


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R3a2 image missing or wrong size")
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    camp.adb("shell", "input", "keyevent", "224")
    time.sleep(0.3)
    camp.tune()
    if IQ.exists():
        IQ.unlink()
    t0 = time.time()
    hlog = open(HLOG, "w", encoding="utf-8")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(IQ), "-f", "467385000", "-s", "2400000",
         "-l", "24", "-g", "38", "-n", str(int(CAP_S * camp.FS_IQ))],
        stdout=hlog, stderr=subprocess.STDOUT)
    deadline = time.time() + 4
    while time.time() < deadline:
        if proc.poll() is not None:
            hlog.close()
            raise SystemExit("hackrf exited early: " + HLOG.read_text(encoding="utf-8", errors="replace")[-400:])
        if camp.hackrf_running():
            break
        time.sleep(0.05)
    else:
        proc.kill()
        hlog.close()
        raise SystemExit("hackrf did not start")
    camp.say("hackrf recording, loader starting at +%.2f s" % (time.time() - t0))
    lf = open(LLOG, "w", encoding="utf-8")
    lc = subprocess.Popen(
        [camp.ADB, "-s", camp.SER, "logcat", "-v", "time", "-s",
         "RadioService:I", "YModemManager:I", "DiagReceiver:I"],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors="replace")
    lines = []

    def pump():
        for line in lc.stdout:
            lines.append(line)
            lf.write(line)
            lf.flush()

    import threading
    threading.Thread(target=pump, daemon=True).start()
    ver = None
    try:
        ver = camp.load_image(IMAGE)
        camp.say("loader version token %s at +%.1f s" % (ver, time.time() - t0))
        if "R3a2" not in ver:
            camp.say("token is not R3a2; one restartmodule while still recording")
            camp.broadcast(["--es", "cmd", "restartmodule"])
            end = time.time() + 25
            while time.time() < end and not any("R3a2" in ln for ln in lines):
                time.sleep(0.5)
            hit = [ln.strip() for ln in lines if "R3a2" in ln or "module booted" in ln or "module DMR" in ln]
            camp.say("after restart: " + " | ".join(hit[-6:]))
    finally:
        time.sleep(2.0)
        camp.say("stopping hackrf at +%.1f s, file %d" % (
            time.time() - t0, IQ.stat().st_size if IQ.exists() else 0))
        if proc.poll() is None:
            camp.kill_hackrf()
            try:
                proc.wait(timeout=15)
            except subprocess.TimeoutExpired:
                proc.kill()
        hlog.close()
        lc.terminate()
        lf.close()
    camp.say("DONE version %s hackrf_rc %s" % (ver, proc.returncode))


if __name__ == "__main__":
    main()
