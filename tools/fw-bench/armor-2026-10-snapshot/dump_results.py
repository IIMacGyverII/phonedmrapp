"""Print the FW17/FW18 numbers from state.json. Read-only."""
import json, math
from pathlib import Path

st = json.loads(Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\state.json").read_text(encoding="utf-8"))
print("image", st.get("image"))
print("gain", st.get("gain"))
print("factory_hz_per_pcm", st.get("factory_hz_per_pcm"))
print("factory_emph", st.get("factory_emph"))
print("tags", list(st["results"]))

def db(v, ref):
    if v is None or ref is None or v <= 0.5 or ref <= 0.5:
        return None
    return 20 * math.log10(v / ref)

for tag, rec in st["results"].items():
    print("\n====", tag, "====")
    p = rec.get("probe") or {}
    rows = {r["hz"]: r for r in p.get("rows") or []}
    if rows:
        print("probe amp", p.get("amp"), "db", p.get("db"), "lag", round(p.get("lag_s", -1), 3),
              "worst", round(p.get("worst_hz", 0)),
              "1k", round(rows.get(1000, {}).get("peak_hz", 0)),
              "3k5", round(rows.get(3500, {}).get("peak_hz", 0)))
        c = p.get("carrier") or {}
        print("  carrier mag", round(c.get("mean_mag", 0), 1), "snr", round(c.get("snr_db", 0), 1),
              "off", round(c.get("offset_hz", 0)), "clip", c.get("clip_frac"), "keyed", round(c.get("keyed_s", 0), 2))
    for sw in rec.get("sweep") or []:
        rs = sw.get("rows") or []
        ref = next((r["peak_hz"] for r in rs if r["hz"] == 1000), None)
        print("sweep db", sw.get("db"), "amp", sw.get("amp"), "lag", round(sw.get("lag_s", -1), 3),
              "worst", round(sw.get("worst_hz", 0)))
        c = sw.get("carrier") or {}
        print("  carrier mag", round(c.get("mean_mag", 0), 1), "snr", round(c.get("snr_db", 0), 1),
              "off", round(c.get("offset_hz", 0)), "lna note clip", c.get("clip_frac"))
        for r in rs:
            d = db(r["peak_hz"], ref)
            print("   %5g  %7.1f Hz  %s" % (r["hz"], r["peak_hz"], "" if d is None else "%+.1f dB" % d))
    print("sweep_note", rec.get("sweep_note"))
    for lim in rec.get("limiter") or []:
        if lim.get("skipped"):
            print("lim", lim.get("db"), "SKIP", lim["skipped"])
            continue
        row = (lim.get("rows") or [{}])[0]
        c = lim.get("carrier") or {}
        print("lim db", lim.get("db"), "amp", lim.get("amp"), "peak", round(row.get("peak_hz", 0)),
              "lag", round(lim.get("lag_s", -1), 3), "mag", round(c.get("mean_mag", 0), 1),
              "off", round(c.get("offset_hz", 0)))
    m = rec.get("m17") or {}
    if m:
        print("m17 amp", m.get("amp"), "level", m.get("level"), "lag", round(m.get("lag_s", -1), 3),
              "p95", round(m.get("p95_hz", 0)), "p995", round(m.get("p995_hz", 0)),
              "outer", round(m.get("outer_hz", 0)), "slope", round(m.get("slope", 0), 4),
              "note", m.get("note"))
        for pol in ("plain", "inverted"):
            d = m.get(pol) or {}
            print(" ", pol, "found", d.get("found"), "exact", d.get("exact"), "sent", d.get("sent"), "lsf", d.get("lsf"))
        c = m.get("carrier") or {}
        print("  carrier mag", round(c.get("mean_mag", 0), 1), "snr", round(c.get("snr_db", 0), 1),
              "off", round(c.get("offset_hz", 0)), "clip", c.get("clip_frac"))
    for poc in rec.get("pocsag") or []:
        c = poc.get("carrier") or {}
        print("poc baud", poc.get("baud") or (poc.get("rows") and ""), "amp", poc.get("amp"), "level", poc.get("level"),
              "lag", round(poc.get("lag_s", -1), 3), "p995", round(poc.get("p995_hz", 0)),
              "mag", round(c.get("mean_mag", 0), 1), "snr", round(c.get("snr_db", 0), 1),
              "off", round(c.get("offset_hz", 0)))
        # baud may live only in the stimulus; print keys once if missing
        if "baud" not in poc:
            print("  keys", sorted(poc.keys()))
        for pol in ("plain", "inverted"):
            d = poc.get(pol) or {}
            print(" ", pol, "err", d.get("bit_errors"), "/", d.get("bits"), "pages", d.get("pages"), "decoded", d.get("decoded"))
    v = rec.get("voice") or {}
    if v:
        c = v.get("carrier") or {}
        print("voice amp", v.get("amp"), "lag", round(v.get("lag_s", -1), 3),
              "p995", round(v.get("p995_hz", 0)), "rms", round(v.get("rms_hz", 0)),
              "demod", v.get("demod"), "mag", round(c.get("mean_mag", 0), 1),
              "snr", round(c.get("snr_db", 0), 1), "off", round(c.get("offset_hz", 0)))
