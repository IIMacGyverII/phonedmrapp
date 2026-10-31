# F59E rows. Restores the released FW57 afterwards, including after a stop.
# Does not write the hotspot configuration.
#
# python tools/fw-bench/fw59e_rows.py --grant
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_bisect as bisect  # noqa: E402
import fw59_rows as rows  # noqa: E402
from common import Config  # noqa: E402
from phone import Phone  # noqa: E402

ROOT = HERE.parents[1]
FW57 = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
FW57_TAG = "DMR003.FW57.V022"


def restore():
    cfg = Config()
    phone = Phone(cfg)
    if not phone.ok():
        raise SystemExit("no phone for the FW57 restore")
    if phone.tag() != FW57_TAG:
        bisect.load(cfg, phone, FW57, FW57_TAG)
    rows.say(cfg, "restored %s" % phone.tag())
    if phone.tag() != FW57_TAG:
        raise SystemExit("FW57 did not load")


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    rows.TAG = "DMR003.F59E.V022"
    rows.IMAGE = ROOT / "radio_firmware" / "build" / "DMR003.F59E.V022.bin"
    try:
        rows.main()
    finally:
        restore()


if __name__ == "__main__":
    main()
