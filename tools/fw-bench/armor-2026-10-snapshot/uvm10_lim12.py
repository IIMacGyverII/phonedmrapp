"""Second UVm10 transmission: 1 kHz at -12 dBFS only. The probe already ran.

HackRF receive only. 467.625 MHz, low power. Restores the factory image afterwards.
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import uvm10_bench as u
import camp

OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\uvm10_result.json")
PRIOR = json.loads(OUT.read_text(encoding="utf-8"))


def main():
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running")
    meta_img = u.check_image()
    st = camp.load_state()
    st["gain"] = [24, 38]
    camp.take_gain(st)
    rec = {
        "image": meta_img,
        "probe": PRIOR.get("probe"),
        "probe_error_note": PRIOR.get("error"),
        "lim12": None,
        "error": None,
    }
    attempted = False
    try:
        attempted = True
        ver = camp.load_image(u.IMG)
        camp.expect_version(ver, "DMR003.Vm10.V022")
        rec["loaded"] = ver
        samples, meta = camp.build_limiter(12)
        if meta["amp"] != 8231 or meta["db"] != 12:
            raise RuntimeError("limiter stimulus amp %s db %s" % (meta["amp"], meta["db"]))
        rec["lim12"] = u.measured("Vm10_lim12", samples, meta)
        lim = rec["lim12"]["rows"][0]["peak_hz"]
        rec["lim_ratio_vs_1827"] = lim / u.FACTORY_LIM
        camp.say("lim12 peak %.1f Hz  x%.3f of 1827" % (lim, rec["lim_ratio_vs_1827"]))
    except Exception as e:
        rec["error"] = str(e)
        camp.say("BENCH ERROR: %s" % e)
        raise
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if attempted:
            rec["factory_restored"] = camp.restore_factory(st)
            try:
                rec["end"] = u.end_state()
            except Exception as e:
                rec["end_error"] = str(e)
                camp.say("END STATE ERROR: %s" % e)
        OUT.write_text(json.dumps(rec, indent=2), encoding="utf-8")
        camp.say("wrote %s" % OUT)


if __name__ == "__main__":
    main()
