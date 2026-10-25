# R4t: sign-extended taps, then a no-key render. A mismatch does not key.
import hashlib
import sys
import threading
import time
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import factory_boot
import m17_rrc
import r3a3_run
import r3a3_silence
import r4p0_run as r

IMAGE = camp.BUILD / "DMR003.R4t0.V022.bin"
TAG = "DMR003.R4t0.V022"
EXPECT = "c571018f704cc8aa4faa023a56efaf70f3b267d9a1d1befc34b924880be8e1b9"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
SYM = HERE / "r4t_pat.sym"


def pattern():
    return [3] * 8 + [-3] * 8 + [3, -3] * 24


def unswap(body):
    out = []
    for i in range(0, len(body) - 1, 2):
        v = ((body[i] & 0xFF) << 8) | (body[i + 1] & 0xFF)
        if v >= 32768:
            v -= 65536
        out.append(v)
    return out


def install_sym(raw):
    SYM.write_bytes(raw)
    remote = "/data/local/tmp/m17.sym"
    rc, out = camp.adb("push", str(SYM), remote, timeout=60)
    if rc != 0:
        raise RuntimeError("push " + out)
    cmd = (
        "cp %s /data/data/com.macdmr.radio/cache/m17.sym && "
        "chown %s:%s /data/data/com.macdmr.radio/cache/m17.sym && "
        "chmod 600 /data/data/com.macdmr.radio/cache/m17.sym && "
        "rm -f /data/data/com.macdmr.radio/cache/render.bin"
    ) % (remote, camp.UID, camp.UID)
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        raise RuntimeError("cache " + out)


def pull_render():
    cmd = (
        "cp /data/data/com.macdmr.radio/cache/render.bin /data/local/tmp/render.bin && "
        "chmod 644 /data/local/tmp/render.bin"
    )
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        raise RuntimeError("copy render " + out)
    dest = HERE / "r4t_render.bin"
    rc, out = camp.adb("pull", "/data/local/tmp/render.bin", str(dest), timeout=60)
    if rc != 0:
        raise RuntimeError("pull " + out)
    return dest.read_bytes()


def main():
    syms = pattern()
    if len(syms) != 64:
        raise SystemExit("pattern")
    want = [int(v) for v in m17_rrc.integer_counts(syms)]
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4t0")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    box = {}

    def load():
        try:
            box["loaded"] = camp.load_image(IMAGE)
        except Exception as exc:
            box["error"] = exc

    thr = threading.Thread(target=load)
    thr.start()
    t0 = time.time()
    while time.time() - t0 < 240 and "loaded" not in box and "error" not in box:
        text = camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]
        if "onSuccess" in text:
            break
        time.sleep(1)
    ym = camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]
    if "error" in box and "onSuccess" not in ym:
        thr.join(30)
        raise box["error"]
    camp.say("onSuccess seen, recording the boot")
    boot = camp.CAP / "r4t0_boot.iq"
    proc, hlog = r.recv(boot, 30, 24, 38)
    thr.join(120)
    r.finish_recv(proc, hlog, boot, 30)
    if box.get("error"):
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    camp.say("loaded " + str(loaded))
    if loaded != TAG:
        r3a3_silence.restore_factory()
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (HERE / "r4t_load.log").write_text(text, encoding="utf-8", errors="replace")
    if "开机初始化完成" not in text and "module booted" not in text:
        r3a3_silence.restore_factory()
        raise SystemExit("banner missing")
    info = factory_boot.analyze(8.0, str(boot))
    camp.say("boot floor %.2f peak %.2f runs %d above10 %.2f" % (
        info["floor_db"], info["peak_db"], len(info["runs"]), info["above_10db_s"]))
    if info["peak_db"] >= 10 or any(run["peak_db"] >= 10 for run in info["runs"]):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    install_sym(m17_rrc.pack_symbols(syms))
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(["--es", "cmd", "cmdsym", "--es", "op", "render",
                              "--es", "path", "/data/data/com.macdmr.radio/cache/m17.sym",
                              "--ei", "n", str(len(want))])
    camp.say("render rc=%d n=%d" % (rc, len(want)))
    got_log = ""
    t0 = time.time()
    while time.time() - t0 < 8:
        got_log = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=20)[1]
        if "render bytes=" in got_log or "render " in got_log and "failed" in got_log:
            break
        time.sleep(0.3)
    (HERE / "r4t_render.log").write_text(got_log, encoding="utf-8", errors="replace")
    if "render bytes=" not in got_log:
        camp.tune()
        camp.say("STOP render did not answer; no key")
        return
    body = pull_render()
    got = unswap(body)
    n = min(len(got), len(want))
    bad = [(i, got[i], want[i]) for i in range(n) if got[i] != want[i]]
    camp.say("render samples %d model %d mismatches %d" % (len(got), len(want), len(bad)))
    for i, a, b in bad[:8]:
        camp.say("mismatch %d got %d want %d" % (i, a, b))
    if len(got) != len(want) or bad:
        camp.tune()
        camp.say("STOP render is not the model; no key")
        return
    camp.say("render bit-exact")
    camp.tune()
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:120]))
    camp.say("R4t0 stays loaded; no key")


if __name__ == "__main__":
    main()
