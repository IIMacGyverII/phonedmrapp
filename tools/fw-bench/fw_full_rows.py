# Full-LC rows for the 20:28 lease. The relay files are the rebuilt ones,
# where every embedded LC is the one destination. Does not write hotspot
# config. A row counts with a new MMDVMHost header, a HackRF carrier, and
# that capture's embedded LC decoded to the one destination.
#
# python tools/fw-bench/fw_full_rows.py --grant
import json
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import full_lc  # noqa: E402
import fw58_air  # noqa: E402
import fw58_bisect as bisect  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import fw59_rows as rows  # noqa: E402
from common import Config  # noqa: E402
from hackrf import Capture, running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

ROOT = HERE.parents[1]
BUILD = ROOT / "radio_firmware" / "build"
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
FACTORY_TAG = "DMR003.UV4T.V022"
FW57 = BUILD / "DMR003.FW57.V022.bin"
FW57_TAG = "DMR003.FW57.V022"
F59D = BUILD / "DMR003.F59D.V022.bin"
F59D_TAG = "DMR003.F59D.V022"
FULL99 = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\dmr_tg99_full.bin")
FULLALL = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\dmr_allcall_full.bin")
TG9 = gaps.base.TG9
BUSY = gaps.base.BUSY
OUT_NAME = "fw_full_rows.json"

rows.FILES = {"tg99": FULL99, "allcall": FULLALL, "tg9": TG9}

SYNCS = {
    "BS voice": 0x755FD7DF75F7, "BS data": 0xDFF57D75DF5D,
    "MS voice": 0x7F7D5DD57DFD, "MS data": 0xD5D7F77FD757,
}


def say(cfg, text):
    rows.say(cfg, text)


def open_web(phone):
    """The prefs file is rewritten while the session list grows; one read can miss the pin."""
    last = None
    for _ in range(6):
        try:
            return gaps.base.Web(phone)
        except SystemExit as exc:
            last = exc
            time.sleep(1.0)
    raise last


def verify_files():
    expect = ((FULL99, "99"), (FULLALL, "16777215"), (TG9, "9"))
    for path, want in expect:
        if not path.is_file():
            raise SystemExit("missing %s" % path.name)
        found, headers = full_lc.decode_file(path)
        dests = sorted({full_lc.show(fields[3]) for _ms, fields in found})
        flcos = sorted({fields[0] for _ms, fields in found})
        if dests != [want] or flcos != [0] or not found:
            raise SystemExit("verify failed %s dests %s" % (path.name, dests))
        if any(d not in (1, 2) for d in headers):
            raise SystemExit("verify failed %s data type" % path.name)
    return "verified 99 / 16777215 / 9, one destination each"


def load_image(cfg, phone, image, tag):
    if not image.is_file():
        raise SystemExit("missing %s" % image.name)
    if phone.tag() == tag:
        say(cfg, "already %s" % tag)
        return
    bisect.load(cfg, phone, image, tag)
    if phone.tag() != tag:
        raise SystemExit("tag is not %s" % tag)


def factory_key(cfg, phone, web):
    """3 s stock PTT on channel 49. The row counts only when status 3 is seen."""
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(2.0)
    web.select(gaps.base.CH49)
    time.sleep(gaps.base.SETTLE_S)
    ch = web.call("/api/channel?number=%d" % gaps.base.CH49).get("channel") or {}
    if not ch.get("digital") or ch.get("power") != 0:
        raise SystemExit("channel 49 is not a low-power digital channel")
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    web.call("/api/ptt", {"down": True})
    time.sleep(0.4)
    early = phone.logcat(8)
    held = bool(web.call("/api/status").get("transmitting"))
    time.sleep(2.6)
    web.call("/api/ptt", {"down": False})
    time.sleep(0.8)
    statuses = gaps.status_bytes(early + "\n" + phone.logcat(8))
    tx = bool(web.call("/api/status").get("transmitting"))
    say(cfg, "factory key statuses %s held %s transmitting %s" % (statuses, held, tx))
    if tx:
        web.call("/api/ptt", {"down": False})
        time.sleep(1.0)
        tx = bool(web.call("/api/status").get("transmitting"))
    if 3 not in statuses or not held or tx:
        raise SystemExit("factory key did not show status 3")
    return statuses


def factory_then(cfg, phone, image, tag):
    """Factory image, one digital key, then the bench image. The new rule."""
    load_image(cfg, phone, FACTORY, FACTORY_TAG)
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    web = open_web(phone)
    factory_key(cfg, phone, web)
    load_image(cfg, phone, image, tag)
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    return open_web(phone)


def enter_vfo(cfg, web):
    web.call("/api/vfo", gaps.vfo_body())
    time.sleep(gaps.base.SETTLE_S)
    problems = gaps.vfo_ok(web.call("/api/vfo"))
    say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9 low power"))
    if problems:
        raise SystemExit("vfo refused")


def one(cfg, phone, web, kind, mon, before_header, image_tag):
    gaps.base.heat_ok(cfg, phone)
    if hackrf_running():
        raise SystemExit("hackrf already running")
    phone.adb("shell", "logcat", "-c")
    web.monitor(mon)
    time.sleep(1.0)
    st = web.call("/api/status")
    mon_now = bool(st.get("monitor"))
    say(cfg, "status monitor %s promiscuous %s vfo %s" % (mon_now, bool(st.get("promiscuous")), bool(st.get("vfo"))))
    if mon_now != bool(mon):
        raise SystemExit("monitor did not take")
    name = "full_%s_%s_%s" % (image_tag, kind, "on" if mon else "off")
    if (cfg.out / "caps" / (name + ".iq")).exists():
        name = name + "b"
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
    header = rows.last_header(cfg)
    ratio = bisect.carrier_ratio(iq)
    fresh = header != before_header and rows.header_matches(kind, header)
    row = {
        "name": name, "kind": kind, "mon": mon, "image": image_tag,
        "rms": round(rms, 1), "peak": peak, "loud_s": bisect.loud_seconds(wav),
        "during": during, "header": header, "header_fresh": fresh,
        "carrier_ratio": round(ratio, 1), "carrier": ratio >= 10.0,
        "iq": str(iq),
        "reports": gaps.frames_2b(log),
        "monitor": mon_now,
    }
    say(cfg, "%s %s MON %s rms %.1f peak %s loud %.2f s carrier %.1f fresh %s" % (
        image_tag, kind, "on" if mon else "off", row["rms"], peak, row["loud_s"], ratio, fresh))
    say(cfg, "header " + header[-140:])
    if not fresh or ratio < 10.0:
        row["verdict"] = "not on air"
        return row
    row["verdict"] = "loud" if (row["rms"] >= 400 or row["loud_s"] >= 1.0) else "muted"
    return row


def sym_of(bits48):
    import numpy as np
    s = []
    for i in range(23, -1, -1):
        d = (bits48 >> (2 * i)) & 3
        s.append({1: 3, 0: 1, 2: -1, 3: -3}[d])
    return np.array(s, float)


def slice_bits(seq, ab):
    a, b = float(ab[0]), float(ab[1])
    if abs(a) < 1e-6:
        a = 1.0
    out = []
    for v in seq:
        u = (float(v) - b) / a
        q = 3 if u > 2 else 1 if u > 0 else -1 if u > -2 else -3
        out.extend({3: (0, 1), 1: (0, 0), -1: (1, 0), -3: (1, 1)}[q])
    return out


def pack_burst(symbols, i, ab):
    i = int(i)
    if i < 54 or i + 78 > len(symbols):
        return None
    bits = (slice_bits(symbols[i - 54:i], ab) + slice_bits(symbols[i:i + 24], ab)
            + slice_bits(symbols[i + 24:i + 78], ab))
    if len(bits) != 264:
        return None
    return _bytes_of(bits)


def _bytes_of(bits):
    out = bytearray()
    for i in range(0, len(bits), 8):
        v = 0
        for bit in bits[i:i + 8]:
            v = (v << 1) | (1 if bit else 0)
        out.append(v)
    return bytes(out)


def centre_bits(burst):
    bits = []
    for byte in burst:
        for k in range(7, -1, -1):
            bits.append((byte >> k) & 1)
    return _bytes_of(bits[108:156])


def symbols_of(path):
    """Carrier symbols, polarity already chosen. Same slicer the voice-LC tool uses."""
    import numpy as np
    x = np.fromfile(path, dtype=np.int8).astype(np.float32)
    fs = 2.4e6
    iq = (x[0::2] + 1j * x[1::2]) / 128.0
    n = len(iq)
    iq = iq * np.exp(-2j * np.pi * 240e3 * np.arange(n) / fs)
    dec = int(fs // 48000)
    bb = np.convolve(iq, np.ones(dec) / dec, "same")[::dec]
    f2 = fs / dec
    pw = np.abs(bb) ** 2
    win = int(f2 * 0.05)
    pws = np.convolve(pw, np.ones(win) / win, "same")
    floor = np.percentile(pws, 10)
    on = pws > floor * 100
    if not on.any():
        return None, []
    idx = np.where(on)[0]
    inst = np.angle(bb[1:] * np.conj(bb[:-1])) * f2 / (2 * np.pi)
    seg = inst[idx[0] + int(0.2 * f2): idx[-1] - int(0.2 * f2)]
    seg = seg[np.abs(seg) < 15000]
    mean = float(np.mean(seg)) if len(seg) else 0.0
    sps = f2 / 4800.0
    step = int(round(sps))
    fm = np.convolve(inst, np.ones(step) / step, "same")[idx[0]:idx[-1]] - mean
    refs = {k: sym_of(v) for k, v in SYNCS.items()}

    def ncc(sym, r):
        num = np.correlate(sym, r, "valid")
        e = np.convolve(sym * sym, np.ones(len(r)), "valid")
        return num / (np.sqrt(e) * np.linalg.norm(r) + 1e-9)

    best = None
    for pol in (1, -1):
        for ph in range(step):
            sym = pol * fm[ph::step]
            for name, r in refs.items():
                m = float(ncc(sym, r).max())
                if best is None or m > best[0]:
                    best = (m, pol, ph, name)
    _m, pol, ph, _name = best
    s = pol * fm[ph::step]
    hits = []
    for name, r in refs.items():
        c = ncc(s, r)
        for i in np.where(c > 0.85)[0]:
            hits.append((int(i), name, float(c[i])))
    hits.sort()
    merged = []
    for h in hits:
        if merged and h[0] - merged[-1][0] < 60:
            if h[2] > merged[-1][2]:
                merged[-1] = h
        else:
            merged.append(h)
    return s, merged


def fit_level(symbols, i, name):
    import numpy as np
    ref = sym_of(SYNCS[name])
    A = np.vstack([ref, np.ones(24)]).T
    return np.linalg.lstsq(A, symbols[i:i + 24], rcond=None)[0]


def embedded_lc(path):
    """Embedded LC destinations in one capture. Sources are not returned."""
    symbols, hits = symbols_of(path)
    voice = [h for h in hits if h[1].endswith("voice")]
    if symbols is None or len(voice) < 2:
        return {"sync_ok": False, "n_voice": len(voice), "dests": [], "n": 0, "gaps": []}
    voice.sort()
    ab = fit_level(symbols, voice[0][0], voice[0][1])
    probe = pack_burst(symbols, voice[0][0], ab)
    sync_ok = False
    if probe is not None and voice[0][1] in SYNCS:
        got = centre_bits(probe)
        sync_ok = got == SYNCS[voice[0][1]].to_bytes(6, "big")
    gaps = []
    found = []
    flcos = []
    lcss_seen = []
    for a, b in zip(voice, voice[1:]):
        gap = b[0] - a[0]
        if len(gaps) < 8:
            gaps.append(int(gap))
        steps = gap / 288.0
        # One voice sync per superframe is 6 slot periods (1728 symbols).
        # Two syncs per superframe is 5. The four LC fragments sit between them.
        if 4.6 <= steps <= 5.4:
            n_between = 4
        elif 5.6 <= steps <= 6.4:
            n_between = 5
        else:
            continue
        step = gap / steps
        level = fit_level(symbols, a[0], a[1])
        raw = []
        state = None
        for k in range(1, n_between + 1):
            burst = pack_burst(symbols, int(round(a[0] + k * step)), level)
            if burst is None:
                state = None
                raw = []
                continue
            emb = full_lc.emb_of(burst)
            if emb is None:
                state = None
                raw = []
                continue
            _cc, _pi, lcss = emb
            if len(lcss_seen) < 24:
                lcss_seen.append(lcss)
            frag = full_lc.fragment_bits(burst)
            if lcss == 1:
                raw = list(frag)
                state = "first"
            elif lcss == 3 and state == "first":
                raw = raw + list(frag)
                state = "second"
            elif lcss == 3 and state == "second":
                raw = raw + list(frag)
                state = "third"
            elif lcss == 2 and state == "third":
                nine = full_lc.decode_raw(raw + list(frag))
                if nine is not None:
                    flco, _fid, _opt, dst, _src = full_lc.lc_fields(nine)
                    found.append(full_lc.show(dst))
                    flcos.append(flco)
                state = None
                raw = []
            else:
                state = None
                raw = []
    return {
        "sync_ok": sync_ok, "n_voice": len(voice), "dests": found,
        "flcos": flcos, "n": len(found), "gaps": gaps, "lcss": lcss_seen,
    }


def dest_ok(kind, doc):
    want = {"tg99": "99", "allcall": "16777215", "tg9": "9"}[kind]
    dests = doc.get("dests") or []
    if not doc.get("sync_ok") or not dests:
        return False
    return all(d == want for d in dests)


def save(cfg, doc):
    out = cfg.out / OUT_NAME
    out.write_text(json.dumps(doc, indent=1, default=str), encoding="utf-8")
    say(cfg, "wrote %s" % out.name)


def finished(doc, image, kind, mon):
    want = {"tg99": "99", "allcall": "16777215", "tg9": "9"}[kind]
    for row in doc["rows"]:
        if row.get("image") != image or row.get("kind") != kind or bool(row.get("mon")) != bool(mon):
            continue
        if row.get("verdict") == "not on air" or not row.get("carrier"):
            continue
        dests = (row.get("embedded") or {}).get("dests") or []
        if dests and all(d == want for d in dests):
            return row
    return None


def run_row(cfg, phone, web, doc, kind, mon, expect, image_tag):
    hit = finished(doc, image_tag, kind, mon)
    if hit is not None:
        say(cfg, "keep %s %s" % (hit.get("name"), hit.get("verdict")))
        return
    """expect is 'muted', 'loud', or None when either result is the measurement."""
    rows.arm(cfg, kind)
    before = doc["before_header"]
    row = one(cfg, phone, web, kind, mon, before, image_tag)
    doc["before_header"] = row["header"]
    if row["verdict"] == "not on air":
        doc["rows"].append(row)
        save(cfg, doc)
        raise SystemExit("%s MON %s not on air" % (kind, "on" if mon else "off"))
    row["embedded"] = embedded_lc(row["iq"])
    row["lc"] = fw58_air.report(row["iq"])
    for ln in row["lc"]:
        say(cfg, ln)
    emb = row["embedded"]
    say(cfg, "embedded n %s dests %s sync %s" % (
        emb.get("n"), sorted(set(emb.get("dests") or [])), emb.get("sync_ok")))
    if not dest_ok(kind, emb):
        doc["rows"].append(row)
        save(cfg, doc)
        raise SystemExit("%s embedded LC is not the one destination" % kind)
    doc["rows"].append(row)
    save(cfg, doc)
    if expect is not None and row["verdict"] != expect:
        raise SystemExit("%s MON %s is %s, expected %s" % (
            kind, "on" if mon else "off", row["verdict"], expect))
    time.sleep(2)


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    cfg.out.mkdir(parents=True, exist_ok=True)
    import tests  # the stream import has to succeed before the radio is used
    del tests
    BUSY.parent.mkdir(parents=True, exist_ok=True)
    BUSY.write_text("fw full rows\n", encoding="ascii")
    phone = None
    doc = {"verified": verify_files(), "rows": []}
    say(cfg, doc["verified"])
    prior = cfg.out / OUT_NAME
    if prior.is_file():
        old = json.loads(prior.read_text(encoding="utf-8"))
        doc["rows"] = old.get("rows") or []
        for row in doc["rows"]:
            emb = row.get("embedded") or {}
            if row.get("iq") and not emb.get("n") and row.get("carrier"):
                row["embedded"] = embedded_lc(row["iq"])
                emb = row["embedded"]
                say(cfg, "redecoded %s n %s dests %s" % (
                    row.get("name"), emb.get("n"), sorted(set(emb.get("dests") or []))))
        save(cfg, doc)
    try:
        phone = Phone(cfg)
        if not phone.ok():
            raise SystemExit("no phone")
        if phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("wrong phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        for image in (FACTORY, FW57, F59D, FULL99, FULLALL, TG9):
            if not image.is_file():
                raise SystemExit("missing %s" % image.name)
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        gaps.base.heat_ok(cfg, phone)
        tag = phone.tag()
        say(cfg, "tag %s" % (tag or "none"))
        fw57_plan = (("tg99", False), ("allcall", False), ("allcall", True), ("tg9", False))
        fw57_done = all(finished(doc, "fw57", k, m) for k, m in fw57_plan)
        if tag != FW57_TAG and not fw57_done:
            factory_then(cfg, phone, FW57, FW57_TAG)
            tag = phone.tag()
        if not fw57_done and tag != FW57_TAG:
            raise SystemExit("not on FW57")
        web = open_web(phone)
        enter_vfo(cfg, web)
        doc["tag"] = FW57_TAG
        doc["before_header"] = rows.last_header(cfg)
        if doc["rows"]:
            doc["before_header"] = doc["rows"][-1].get("header") or doc["before_header"]
        # Record each row. TG 9 being quiet is a result, not a reason to stop:
        # the first pass already measured it on the air.
        run_row(cfg, phone, web, doc, "tg99", False, None, "fw57")
        run_row(cfg, phone, web, doc, "allcall", False, None, "fw57")
        run_row(cfg, phone, web, doc, "allcall", True, None, "fw57")
        run_row(cfg, phone, web, doc, "tg9", False, None, "fw57")
        web = factory_then(cfg, phone, F59D, F59D_TAG)
        say(cfg, "tag %s" % phone.tag())
        enter_vfo(cfg, web)
        doc["f59d_tag"] = phone.tag()
        doc["before_header"] = rows.last_header(cfg)
        run_row(cfg, phone, web, doc, "allcall", False, None, "f59d")
        web = factory_then(cfg, phone, FW57, FW57_TAG)
        say(cfg, "restored %s" % phone.tag())
        doc["end_tag"] = phone.tag()
        web2 = open_web(phone)
        tx = bool(web2.call("/api/status").get("transmitting"))
        doc["transmitting_before_stream"] = tx
        if tx:
            web2.call("/api/ptt", {"down": False})
            time.sleep(1.0)
        gaps.base.heat_ok(cfg, phone)
        import tests
        doc["stream"] = tests.stream(cfg, phone)
        say(cfg, "stream %s" % doc["stream"].get("verdict"))
        tx = bool(open_web(phone).call("/api/status").get("transmitting"))
        doc["transmitting"] = tx
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        save(cfg, doc)
        if tx:
            raise SystemExit("still transmitting")
        if phone.tag() != FW57_TAG:
            raise SystemExit("end tag is not FW57")
    finally:
        if phone is None:
            if BUSY.exists():
                BUSY.unlink()
        else:
            try:
                web = open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
                    say(cfg, "unkeyed in cleanup")
            except Exception as exc:
                say(cfg, "unkey failed %s" % type(exc).__name__)
            try:
                if phone.tag() not in ("", FW57_TAG):
                    say(cfg, "restoring FW57 after a stop")
                    factory_then(cfg, phone, FW57, FW57_TAG)
            except Exception as exc:
                say(cfg, "restore failed %s" % type(exc).__name__)


def confirm():
    """Two rows on the FW57 that was just factory-keyed, to separate leftover state."""
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    BUSY.parent.mkdir(parents=True, exist_ok=True)
    BUSY.write_text("fw full confirm\n", encoding="ascii")
    phone = Phone(cfg)
    if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
        raise SystemExit("no phone")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    if phone.tag() != FW57_TAG:
        raise SystemExit("not on FW57")
    doc = json.loads((cfg.out / OUT_NAME).read_text(encoding="utf-8"))
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    gaps.base.heat_ok(cfg, phone)
    web = open_web(phone)
    if web.call("/api/status").get("transmitting"):
        web.call("/api/ptt", {"down": False})
        time.sleep(1)
    enter_vfo(cfg, web)
    # The modem can report itself open and still drop the queued call.
    say(cfg, rows.ssh("python3 /tmp/restart_relay.py"))
    rows.restart_modem(cfg)
    doc["before_header"] = rows.last_header(cfg)
    run_row(cfg, phone, web, doc, "allcall", False, None, "fw57c")
    run_row(cfg, phone, web, doc, "tg9", False, None, "fw57c")
    tx = bool(open_web(phone).call("/api/status").get("transmitting"))
    doc["confirm_transmitting"] = tx
    doc["confirm_tag"] = phone.tag()
    doc["confirm_heat"] = gaps.base.heat_ok(cfg, phone)
    save(cfg, doc)
    if tx or phone.tag() != FW57_TAG:
        raise SystemExit("confirm end state")


if __name__ == "__main__":
    if "--confirm" in sys.argv:
        confirm()
    else:
        main()
