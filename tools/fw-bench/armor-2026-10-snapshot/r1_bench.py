"""R1: is the DMR modulator DC-capable?

No firmware change. One temporary digital channel at 467.625 MHz, low power,
CC1, TS1, talkgroup 9999, no contact row. One DIAG testtone, HackRF receive
only. Then the bench row is deleted and Weather channel 36 is active again.

Prints a single stdout token: R1_DONE or R1_FAILED. Detail goes to r1_status.txt.
"""
import json
import sqlite3
import subprocess
import sys
import time
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
STATUS = HERE / "r1_status.txt"
RESULT = HERE / "r1_result.json"
DB = "/data/data/com.macdmr.radio/databases/radio.db"
PREFS = "/data/data/com.macdmr.radio/shared_prefs/radio.xml"
BENCH_NAME = "R1 BENCH"
BENCH_HZ = 467625000
TG = 9999
EXPECT = "DMR003.UV4T.V022"

edited = False
before_path = HERE / "radio_r1_before.db"


def status(msg):
    line = time.strftime("%H:%M:%S ") + str(msg)
    with STATUS.open("a", encoding="utf-8") as f:
        f.write(line + "\n")


def su(cmd, timeout=40):
    rc, out = camp.adb(
        "shell", 'su --mount-master --context u:r:magisk:s0 -c "%s"' % cmd, timeout=timeout)
    status("su %s -> %s" % (cmd[:80], out.strip().replace("\n", " ")[:160]))
    return rc, out


def wake():
    camp.adb("shell", "input", "keyevent", "224")
    time.sleep(0.3)
    camp.adb("shell", "wm", "dismiss-keyguard")
    camp.adb("shell", "input", "keyevent", "82")
    time.sleep(0.5)


def ui_dump():
    env = dict(**{k: v for k, v in __import__("os").environ.items()})
    env["DEV"] = camp.SER
    env["MSYS_NO_PATHCONV"] = "1"
    r = subprocess.run(
        [camp.BASH, "tools/fw-patch/bench/ui.sh", "dump"],
        cwd=str(camp.REPO), env=env, capture_output=True, text=True, timeout=70)
    text = r.stdout or ""
    keep = []
    for ln in text.splitlines():
        if any(s in ln for s in ("467.625", "162.425", "NOAA", "R1 BENCH", "DMR", "LOW", "WX")):
            keep.append(ln.strip()[:140])
    status("ui " + " | ".join(keep[:12]))
    return text


def tap(label):
    env = dict(**{k: v for k, v in __import__("os").environ.items()})
    env["DEV"] = camp.SER
    env["MSYS_NO_PATHCONV"] = "1"
    subprocess.run(
        [camp.BASH, "tools/fw-patch/bench/ui.sh", "tap", label],
        cwd=str(camp.REPO), env=env, capture_output=True, text=True, timeout=70)


def log_hits():
    _, out = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)
    keys = ("module DMR", "MCU rejected", "The radio refused", "testtone",
            "1 kHz test tone", "TX blocked", "receive-only", "VFO 467")
    hits = [ln.strip()[-180:] for ln in out.splitlines() if any(k in ln for k in keys)]
    for h in hits[-12:]:
        status("log " + h)
    return hits


def latest_version(timeout=30):
    deadline = time.time() + timeout
    while time.time() < deadline:
        hits = [h for h in log_hits() if "module DMR" in h]
        if hits:
            ver = hits[-1].split("module ")[-1].strip()
            status("0x34 " + ver)
            return ver
        time.sleep(1)
    raise RuntimeError("no 0x34 answer")


def pull_db(tag):
    local = HERE / ("radio_%s.db" % tag)
    for p in (local, Path(str(local) + "-wal"), Path(str(local) + "-shm")):
        if p.exists():
            p.unlink()
    rc, out = camp.adb(
        "shell", "su --mount-master --context u:r:magisk:s0 -c cp %s /sdcard/r1_%s.db" % (DB, tag),
        timeout=30)
    if rc != 0:
        raise RuntimeError("db copy failed " + out)
    camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c cp %s-wal /sdcard/r1_%s.db-wal" % (DB, tag), timeout=30)
    rc, out = camp.adb("pull", "/sdcard/r1_%s.db" % tag, str(local), timeout=60)
    if rc != 0 or not local.exists() or local.stat().st_size < 1000:
        raise RuntimeError("pull db failed " + out)
    camp.adb("pull", "/sdcard/r1_%s.db-wal" % tag, str(local) + "-wal", timeout=60)
    con = sqlite3.connect(str(local))
    con.row_factory = sqlite3.Row
    try:
        con.execute("PRAGMA wal_checkpoint(FULL)")
    except sqlite3.DatabaseError as e:
        status("checkpoint " + str(e))
    return con, local


def install_db(local):
    rc, out = camp.adb("push", str(local), "/sdcard/r1_edit.db", timeout=60)
    if rc != 0:
        raise RuntimeError("push db failed " + out)
    for extra in ("-wal", "-shm", "-journal"):
        su("rm -f %s%s" % (DB, extra))
    rc, out = su("cp /sdcard/r1_edit.db %s" % DB)
    if rc != 0:
        raise RuntimeError("install db failed " + out)
    su("chown 10200:10200 %s" % DB)
    su("chmod 660 %s" % DB)
    su("restorecon %s" % DB)
    rc, out = su("ls -l %s" % DB)
    if "u0_a200" not in out and "10200" not in out:
        raise RuntimeError("db owner " + out)


def finish_db(con, local):
    con.commit()
    con.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    con.commit()
    con.close()
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    again = sqlite3.connect(str(local))
    again.row_factory = sqlite3.Row
    return again


def prefs_snapshot():
    rc, out = camp.adb(
        "shell", "su --mount-master --context u:r:magisk:s0 -c cp %s /sdcard/r1_radio.xml" % PREFS,
        timeout=30)
    if rc != 0:
        status("prefs copy failed " + out.strip()[:120])
        return {}
    dest = HERE / "r1_radio.xml"
    camp.adb("pull", "/sdcard/r1_radio.xml", str(dest), timeout=30)
    camp.adb("shell", "rm", "-f", "/sdcard/r1_radio.xml")
    if not dest.exists():
        return {}
    root = ET.parse(str(dest)).getroot()
    got = {}
    for el in root:
        if el.attrib.get("name") in ("zone", "zoneLast_4", "issRepeat", "stay"):
            got[el.attrib["name"]] = el.attrib.get("value")
    # zone name is in the db; record the two ints we must not lose
    status("prefs " + json.dumps(got))
    if not (HERE / "r1_prefs_before.xml").exists():
        (HERE / "r1_prefs_before.xml").write_bytes(dest.read_bytes())
    return got


def ch36(con):
    return con.execute("SELECT * FROM channels WHERE _id=36").fetchone()


def assert_noaa(row, active_required):
    if row is None:
        raise RuntimeError("no channel _id 36")
    if row["name"] != "NOAA WX4" or row["rxFreq"] != 162425000 or row["txFreq"] != 162425000:
        raise RuntimeError("channel 36 is not NOAA WX4 at 162.425")
    if row["sq"] != 5 or row["power"] != 0 or row["rxOnly"] != 0:
        raise RuntimeError("channel 36 sq/power/rxOnly changed: %s %s %s" % (row["sq"], row["power"], row["rxOnly"]))
    if active_required and row["active"] != 1:
        raise RuntimeError("channel 36 is not active")


def insert_bench():
    global edited
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = pull_db("before")
    row = ch36(con)
    assert_noaa(row, True)
    nactive = con.execute("SELECT COUNT(*) FROM channels WHERE active=1").fetchone()[0]
    if nactive != 1:
        raise RuntimeError("%d active channels" % nactive)
    cols = [r[1] for r in con.execute("PRAGMA table_info(channels)")]
    # a previous crash may have left this row; remove only that exact signature
    con.execute(
        "DELETE FROM channels WHERE name=? AND type=0 AND rxFreq=? AND txFreq=? AND power=0 AND rxOnly=0",
        (BENCH_NAME, BENCH_HZ, BENCH_HZ))
    numbers = [r[0] for r in con.execute("SELECT number FROM channels")]
    num = max(numbers) + 1
    for zname, znums in con.execute("SELECT name, numbers FROM zones"):
        parts = [p.strip() for p in (znums or "").split(",") if p.strip()]
        if str(num) in parts:
            raise RuntimeError("bench number collides with zone " + str(zname))
    contact = con.execute("SELECT COUNT(*) FROM contacts WHERE number=?", (TG,)).fetchone()[0]
    status("tg %d already in contacts: %d (no contact row will be added)" % (TG, contact))
    fields = {
        "number": num, "name": BENCH_NAME, "type": 0,
        "rxFreq": BENCH_HZ, "txFreq": BENCH_HZ, "power": 0, "band": 1, "sq": 0,
        "rxType": 0, "rxSubCode": 0, "txType": 0, "txSubCode": 0, "relay": 2, "mode": 0,
        "cc": 1, "inSlot": 0, "outSlot": 0, "contactType": 1, "txContact": TG,
        "encryptSw": 2, "encryptKey": "", "interrupt": 2, "groups": str(TG),
        "active": 1, "location": "", "lat": 0, "lon": 0, "elev": 0,
        "softSq": 0, "softSqLevel": 5, "notes": "", "rxOnly": 0,
    }
    use = [k for k in fields if k in cols]
    con.execute("UPDATE channels SET active=0")
    con.execute(
        "INSERT INTO channels (%s) VALUES (%s)" % (",".join(use), ",".join("?" for _ in use)),
        [fields[k] for k in use])
    again = finish_db(con, local)
    bench = again.execute(
        "SELECT number, name, type, rxFreq, txFreq, power, cc, inSlot, outSlot, contactType, txContact, groups, active, rxOnly FROM channels WHERE name=?",
        (BENCH_NAME,)).fetchone()
    noaa = ch36(again)
    nbench = again.execute("SELECT COUNT(*) FROM channels WHERE name=?", (BENCH_NAME,)).fetchone()[0]
    again.close()
    if nbench != 1 or bench["rxFreq"] != BENCH_HZ or bench["txFreq"] != BENCH_HZ or bench["power"] != 0:
        raise RuntimeError("bench row did not stick")
    if bench["cc"] != 1 or bench["inSlot"] != 0 or bench["outSlot"] != 0 or bench["txContact"] != TG:
        raise RuntimeError("bench channel fields wrong")
    if bench["rxOnly"] != 0 or bench["active"] != 1:
        raise RuntimeError("bench not active or receive-only")
    if noaa["active"] != 0 or noaa["rxFreq"] != 162425000 or noaa["txFreq"] != 162425000:
        raise RuntimeError("channel 36 moved")
    before_path.write_bytes(local.read_bytes())
    install_db(local)
    edited = True
    status("bench channel number %d installed, channel 36 inactive but still NOAA" % num)
    return num


def start_app():
    camp.adb("shell", "logcat", "-G", "16M", timeout=20)
    camp.adb("shell", "logcat", "-c", timeout=20)
    wake()
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")


def confirm_bench(number):
    ver = latest_version(30)
    if ver != EXPECT and not ver.startswith(EXPECT):
        raise RuntimeError("flash is not factory before the measurement: " + ver)
    time.sleep(2)
    wake()
    tap("Intercom")
    time.sleep(1.0)
    text = ui_dump()
    hits = log_hits()
    refused = any("MCU rejected" in h or "The radio refused" in h or "VFO 467" in h for h in hits)
    blocked = any("TX blocked" in h or "receive-only" in h for h in hits)
    if refused or blocked:
        raise RuntimeError("channel was refused or a VFO was tuned")
    if "467.625" not in text:
        raise RuntimeError("intercom does not show 467.625")
    if "R1 BENCH" not in text and "BENCH" not in text:
        status("name not on the intercom yet; frequency is")
    # the channel write follows the version query; wait out the retune settle from here
    status("settle 6 s before key, bench number %d" % number)
    time.sleep(6)
    hits = log_hits()
    if any("MCU rejected" in h or "The radio refused" in h for h in hits):
        raise RuntimeError("refused during settle")
    return ver


def capture(name, ms, seconds):
    if camp.hackrf_running():
        raise RuntimeError("hackrf_transfer already running")
    n = int(camp.FS_IQ * seconds)
    path = camp.CAP / (name + ".iq")
    if path.exists():
        path.unlink()
    status("capture %s n=%d l=%d g=%d" % (name, n, camp.gain_l, camp.gain_g))
    hlog = open(camp.CAP / (name + ".hackrf.log"), "w", encoding="utf-8", errors="replace")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000",
         "-l", str(camp.gain_l), "-g", str(camp.gain_g), "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    time.sleep(0.8)
    if proc.poll() is not None:
        hlog.close()
        raise RuntimeError("hackrf exited before key-up")
    rc, bout = camp.broadcast(["--es", "cmd", "testtone", "--ei", "ms", str(ms)])
    status("testtone rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:160]))
    try:
        proc.wait(timeout=seconds + 25)
    except subprocess.TimeoutExpired:
        proc.kill()
        hlog.close()
        camp.kill_hackrf()
        raise RuntimeError("hackrf stalled")
    hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()
        raise RuntimeError("hackrf still running after capture")
    if not path.exists() or path.stat().st_size < n * 2 * 0.8:
        raise RuntimeError("capture short")
    time.sleep(0.8)
    hits = log_hits()
    if not any("1 kHz test tone" in h or "testtone" in h for h in hits):
        status("no testtone log line")
    if any("TX blocked" in h or "receive-only" in h or "MCU rejected" in h for h in hits):
        raise RuntimeError("tone was blocked or the MCU rejected the channel")
    return path


def fix_zone_prefs():
    """While SignalDeck is stopped: put zone and zoneLast_4 back if the bench start changed them."""
    before = HERE / "r1_prefs_before.xml"
    if not before.exists():
        return
    old = {}
    for el in ET.parse(str(before)).getroot():
        if el.attrib.get("name") in ("zone", "zoneLast_4"):
            old[el.attrib["name"]] = el.attrib.get("value")
    now = prefs_snapshot()
    changed = [k for k in old if now.get(k) != old[k]]
    if not changed:
        status("zone prefs unchanged")
        return
    live = HERE / "r1_radio.xml"
    import re
    text = live.read_text(encoding="utf-8")
    for name in changed:
        text2, n = re.subn(
            r'(<int name="%s" value=")[^"]*(")' % name,
            lambda m, v=old[name]: m.group(1) + v + m.group(2),
            text, count=1)
        if n != 1:
            raise RuntimeError("could not patch pref " + name)
        text = text2
    live.write_text(text, encoding="utf-8")
    rc, out = camp.adb("push", str(live), "/sdcard/r1_radio.xml", timeout=30)
    if rc != 0:
        raise RuntimeError("prefs push failed " + out)
    su("cp /sdcard/r1_radio.xml %s" % PREFS)
    su("chown 10200:10200 %s" % PREFS)
    su("chmod 660 %s" % PREFS)
    su("restorecon %s" % PREFS)
    camp.adb("shell", "rm", "-f", "/sdcard/r1_radio.xml")
    status("zone prefs restored: " + ",".join(changed))


def restore_prefs_if_needed():
    now = prefs_snapshot()
    dest = HERE / "r1_radio.xml"
    if not dest.exists() or not now:
        return
    # prefs_snapshot overwrote the file with the live copy. Re-pull is the live one;
    # the values we care about are compared against what main() stored in the result
    # only after the fact. The pre-edit copy was not kept, so leave prefs alone here.
    status("prefs now " + json.dumps(now))


def install_backup():
    """Put the pre-edit database back. It has channel 36 active and no bench row."""
    global edited
    if not before_path.exists():
        raise RuntimeError("no pre-edit database to fall back to")
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    install_db(before_path)
    edited = False
    status("pre-edit database restored")


def restore():
    """Delete the bench row and make channel 36 active. Channel 36's NOAA fields are put back if a write changed them."""
    global edited
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    try:
        con, local = pull_db("restore")
    except Exception:
        install_backup()
        raise
    row = ch36(con)
    if row is None:
        raise RuntimeError("channel 36 missing at restore")
    # only the fields this bench is allowed to have touched, plus the known NOAA values
    con.execute("DELETE FROM channels WHERE name=? AND type=0 AND rxFreq=? AND txFreq=?", (BENCH_NAME, BENCH_HZ, BENCH_HZ))
    con.execute("UPDATE channels SET active=0")
    con.execute(
        "UPDATE channels SET active=1, sq=5, rxFreq=162425000, txFreq=162425000, rxOnly=0, power=0 WHERE _id=36 AND name='NOAA WX4'")
    again = finish_db(con, local)
    got = ch36(again)
    left = again.execute("SELECT COUNT(*) FROM channels WHERE rxFreq=?", (BENCH_HZ,)).fetchone()[0]
    again.close()
    if got["name"] != "NOAA WX4" or got["rxFreq"] != 162425000 or got["txFreq"] != 162425000:
        install_backup()
        raise RuntimeError("restore left channel 36 wrong; pre-edit database put back")
    if got["sq"] != 5 or got["rxOnly"] != 0 or got["power"] != 0 or got["active"] != 1 or left:
        install_backup()
        raise RuntimeError("restore flags or leftover 467.625 row; pre-edit database put back")
    install_db(local)
    edited = False
    status("channel 36 restored")
    camp.adb("shell", "logcat", "-c", timeout=20)
    wake()
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    ver = latest_version(30)
    time.sleep(2)
    wake()
    tap("Intercom")
    time.sleep(1.0)
    text = ui_dump()
    if "162.425" not in text or "467.625" in text:
        raise RuntimeError("intercom after restore does not show 162.425 alone")
    # re-read the live db
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = pull_db("final")
    got = ch36(con)
    left = con.execute("SELECT COUNT(*) FROM channels WHERE name=? OR rxFreq=?", (BENCH_NAME, BENCH_HZ)).fetchone()[0]
    con.close()
    assert_noaa(got, True)
    if left:
        raise RuntimeError("bench row still present after the final read")
    fix_zone_prefs()
    wake()
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    status("final 0x34 " + ver)
    return ver


def analyze(path):
    import numpy as np
    dev, info = camp.demod(path)
    status("demod keyed %.2f s snr %.1f offset %.1f clip %.5f mag %.1f" % (
        info["keyed_s"], info["snr_db"], info["offset_hz"], info["clip_frac"], info["mean_mag"]))
    if info["clip_frac"] > 0.0005:
        return {"clip": True, "info": info}
    if info["keyed_s"] < 0.4 or info["snr_db"] < 8:
        return {"weak": True, "info": info}
    fs = camp.FS_A
    i0, i1 = camp.carrier_bounds(info, len(dev))
    seg = dev[i0:i1]
    # 1 ms smoother on |deviation| to separate slot bursts from the gaps
    w = max(8, int(0.001 * fs))
    sm = np.convolve(np.abs(seg), np.ones(w) / w, "same")
    # period: autocorrelation of the smoother, 20–70 ms
    step = 4
    s = sm[::step]
    s = s - s.mean()
    best = (0.0, int(0.030 * fs))
    lo = int(0.020 * fs) // step
    hi = int(0.070 * fs) // step
    # correlate against a short template of the start so this stays cheap
    n = min(len(s), int(2.0 * fs) // step)
    a = s[:n]
    for lag in range(lo, hi):
        m = n - lag
        if m < 100:
            break
        c = float(np.dot(a[:m], a[lag:lag + m]) / (m * (np.std(a) + 1e-9) ** 2))
        if c > best[0]:
            best = (c, lag * step)
    period = best[1]
    status("burst period %.2f ms corr %.3f" % (period / fs * 1000, best[0]))
    # fold |dev| and find the high region inside one period
    p = int(period)
    if p < int(0.02 * fs):
        p = int(0.030 * fs)
    fold = np.zeros(p)
    counts = np.zeros(p)
    for off in range(0, len(sm) - p, p):
        fold += sm[off:off + p]
        counts += 1
    fold /= np.maximum(counts, 1)
    thr = 0.45 * np.percentile(fold, 90) + 0.55 * np.percentile(fold, 10)
    on = fold > thr
    # longest on-run, allowing the run to wrap
    doubled = np.concatenate([on, on])
    best_run = (0, 0, 0)
    i = 0
    while i < len(on):
        if not doubled[i]:
            i += 1
            continue
        j = i
        while j < len(doubled) and doubled[j] and j - i < p:
            j += 1
        if j - i > best_run[0]:
            best_run = (j - i, i % p, j)
        i = j if j > i else i + 1
    run_len, run_at, _ = best_run
    status("burst window %.2f ms at %.2f ms into the period" % (run_len / fs * 1000, run_at / fs * 1000))
    # collect bursts: each period, the window, dropped if it is short
    bursts = []
    win = run_len
    for off in range(0, len(seg) - p, p):
        a = off + run_at
        b = a + win
        if b > len(seg) or b - a < int(0.015 * fs):
            continue
        piece = seg[a:b]
        if np.percentile(np.abs(piece), 80) < 400:
            continue
        bursts.append(piece)
    status("bursts %d" % len(bursts))
    if len(bursts) < 8:
        return {"weak_bursts": True, "n": len(bursts), "period_ms": p / fs * 1000, "info": {k: info[k] for k in info}}
    # symbol timing: 4800 sym/s -> 10 samples. Search phase on the first long bursts.
    sym = fs / 4800.0
    centers = []
    outer_pos = []
    outer_neg = []
    regions = {"pre": [], "sync": [], "post": []}
    run_slopes = []
    used = 0
    for piece in bursts[:40]:
        best_ph = None
        for ph in range(int(sym)):
            idx = ph + np.arange(0, int((len(piece) - ph) / sym)) * sym
            idx = idx.astype(int)
            idx = idx[idx < len(piece)]
            if len(idx) < 80:
                continue
            samples = piece[idx]
            # four cluster centers from percentiles, then mean distance
            qs = np.percentile(samples, [12.5, 37.5, 62.5, 87.5])
            dist = np.min(np.abs(samples[:, None] - qs[None, :]), axis=1).mean()
            if best_ph is None or dist < best_ph[0]:
                best_ph = (dist, samples, qs)
        if best_ph is None:
            continue
        samples, qs = best_ph[1], best_ph[2]
        # keep a 132-symbol slice from the densest part: the whole piece if it is about one burst
        if len(samples) > 140:
            samples = samples[:132]
        if len(samples) < 100:
            continue
        used += 1
        span = max(abs(qs[0]), abs(qs[3]), 1.0)
        outer_cut = 0.62 * span
        for k, s in enumerate(samples):
            if abs(s) < outer_cut:
                continue
            if k < 54:
                regions["pre"].append(abs(s))
            elif k < 78:
                regions["sync"].append(abs(s))
            else:
                regions["post"].append(abs(s))
            if s > 0:
                outer_pos.append(s)
            else:
                outer_neg.append(s)
        # droop on runs of the same outer symbol (4 or more)
        signs = np.where(np.abs(samples) >= outer_cut, np.sign(samples), 0)
        k = 0
        while k < len(signs):
            if signs[k] == 0:
                k += 1
                continue
            j = k
            while j < len(signs) and signs[j] == signs[k]:
                j += 1
            if j - k >= 4:
                run = samples[k:j]
                run_slopes.append(float(run[-1] - run[0]))
            k = j
        centers.append(samples)
    def med(xs):
        return float(np.median(xs)) if xs else None
    pre, sync, post = med(regions["pre"]), med(regions["sync"]), med(regions["post"])
    levels = [v for v in (pre, sync, post) if v]
    ratio = (min(levels) / max(levels)) if len(levels) >= 2 and max(levels) else None
    # spectrum of the burst windows only, below 250 Hz
    cat = np.concatenate([b for b in bursts[:40]])
    cat = cat - np.mean(cat)
    spec = np.abs(np.fft.rfft(cat * np.hanning(len(cat)))) ** 2
    freqs = np.fft.rfftfreq(len(cat), 1 / fs)
    def band(f0, f1):
        m = (freqs >= f0) & (freqs < f1)
        return float(spec[m].sum())
    p_low = band(0, 250)
    p_mid = band(250, 4000)
    worst = float(np.percentile(np.abs(cat), 99.5))
    out = {
        "info": {k: (float(info[k]) if isinstance(info[k], (float, np.floating)) else int(info[k]) if isinstance(info[k], (int, np.integer)) else info[k]) for k in ("keyed_s", "snr_db", "offset_hz", "clip_frac", "mean_mag")},
        "period_ms": p / fs * 1000,
        "window_ms": win / fs * 1000,
        "n_bursts": len(bursts),
        "n_measured": used,
        "outer_pos_hz": med(outer_pos),
        "outer_neg_hz": med(outer_neg),
        "outer_abs_pre_hz": pre,
        "outer_abs_sync_hz": sync,
        "outer_abs_post_hz": post,
        "flat_ratio": ratio,
        "run_slope_median_hz": med(run_slopes),
        "run_slope_n": len(run_slopes),
        "power_below_250": p_low,
        "power_250_to_4000": p_mid,
        "fraction_below_250": p_low / (p_low + p_mid + 1e-12),
        "worst_hz": worst,
        "stop": worst > camp.STOP_HZ,
        "gain": [camp.gain_l, camp.gain_g],
    }
    status("outer +%.0f / %.0f Hz  pre %.0f sync %.0f post %.0f  ratio %s  low-frac %.3f  worst %.0f" % (
        out["outer_pos_hz"] or -1, out["outer_neg_hz"] or -1,
        pre or -1, sync or -1, post or -1,
        ("%.3f" % ratio) if ratio else "n/a",
        out["fraction_below_250"], worst))
    return out


def main():
    STATUS.write_text("", encoding="utf-8")
    before_prefs = HERE / "r1_prefs_before.xml"
    if before_prefs.exists():
        before_prefs.unlink()
    if camp.hackrf_running():
        raise RuntimeError("hackrf_transfer is already running")
    rc, out = camp.adb("get-state", timeout=15)
    if "device" not in out:
        raise RuntimeError("phone not online: " + out.strip())
    _, stay = camp.adb("shell", "settings", "get", "system", "stay_on_while_plugged_in", timeout=15)
    status("stay_on " + stay.strip())
    prefs_before = prefs_snapshot()
    number = insert_bench()
    start_app()
    ver = confirm_bench(number)
    camp.gain_l, camp.gain_g = 24, 38
    path = capture("r1_dmr", 2000, 8.0)
    result = analyze(path)
    if result.get("clip"):
        status("clipped; one recapture at lower gain")
        camp.gain_l, camp.gain_g = 16, 32
        path = capture("r1_dmr_g2", 2000, 8.0)
        result = analyze(path)
        if result.get("clip"):
            raise RuntimeError("still clipping at 16/32")
    if result.get("weak") or result.get("weak_bursts"):
        raise RuntimeError("carrier or bursts too weak to measure")
    if result.get("stop"):
        status("STOP deviation above 5 kHz; no further transmission")
    result["version_before"] = ver
    result["bench_number"] = number
    result["stay_on_before"] = stay.strip()
    result["prefs_before"] = prefs_before
    RESULT.write_text(json.dumps(result, indent=2), encoding="utf-8")
    status("analysis written")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "analyze":
        import numpy as np  # noqa: F401
        r = analyze(Path(sys.argv[2]))
        RESULT.write_text(json.dumps(r, indent=2, default=str), encoding="utf-8")
        print("R1_ANALYZED", flush=True)
        raise SystemExit(0)
    err = None
    try:
        main()
    except Exception as e:
        err = e
        status("ERROR " + str(e))
    finally:
        if edited:
            try:
                restore()
            except Exception as e2:
                status("RESTORE ERROR " + str(e2))
                print("R1_FAILED restore: %s (bench error: %s)" % (e2, err), flush=True)
                raise SystemExit(1)
    if err:
        print("R1_FAILED %s" % err, flush=True)
        raise SystemExit(1)
    print("R1_DONE", flush=True)
