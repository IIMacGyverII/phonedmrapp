# HackRF ground truth for one relay replay. Does not key the phone and does not
# write the hotspot config. The voice-LC source is printed only when it is 9,
# 99, or 16777215; any longer ID is "other".
#
# python tools/fw-bench/fw58_air.py --grant
import argparse
import socket
import struct
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_gaps as gaps  # noqa: E402
from common import Config  # noqa: E402
from hackrf import Capture  # noqa: E402

IQAN = HERE.parents[1] / "tools" / "dmr-replay" / "iqan_tx.py"


def show_id(n):
    if n in (0, 9, 99, 16777215):
        return str(n)
    if n >= 100000:
        return "other"
    return "short-%d" % n


def reload_only(cfg):
    dest = "%s:~/claude-bench/dmr_last.bin" % gaps.base.PI
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(gaps.base.TG99), dest],
        capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp")
    local = cfg.out / "reload_relay.py"
    local.write_text(gaps.RELOAD, encoding="ascii")
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local),
         "%s:/tmp/reload_relay.py" % gaps.base.PI],
        capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp reload")
    gaps.base.ssh(cfg, "python3 /tmp/reload_relay.py")


def queue():
    s = socket.create_connection((gaps.base.PI.split("@")[1], 8080), 8)
    try:
        s.sendall(b"Q" + struct.pack(">I", 0))
    finally:
        s.close()


def report(path):
    r = subprocess.run(
        [sys.executable, str(IQAN), str(path), "--fs", "2400000", "--off", "240000", "--dmr"],
        capture_output=True, timeout=180)
    text = (r.stdout or b"").decode("utf-8", "replace")
    kept = []
    for ln in text.splitlines():
        if ln.startswith(("samples ", "carrier ", "no carrier", "best sync ", "sync bursts:", "burst spacing")):
            kept.append(ln)
        if "FLCO" in ln and "dst" in ln:
            parts = ln.split()
            # t+ N ms NAME colour code C, TYPE FLCO F, dst D, src S
            try:
                flco = int(parts[parts.index("FLCO") + 1].rstrip(","))
                dst = int(parts[parts.index("dst") + 1].rstrip(","))
                src = int(parts[parts.index("src") + 1])
                cc = parts[parts.index("code") + 1].rstrip(",")
                kind = ln.split(",")[1].strip().split(" FLCO")[0]
                kept.append("LC cc %s %s FLCO %d dst %s src %s" % (cc, kind, flco, show_id(dst), show_id(src)))
            except (ValueError, IndexError):
                kept.append("LC line unparsed")
    return kept


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--grant", action="store_true")
    p.add_argument("--lna", type=int, default=16)
    p.add_argument("--vga", type=int, default=16)
    args = p.parse_args()
    if not args.grant:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    reload_only(cfg)
    cap = Capture(cfg, "fw58_tg99_air", 10, args.lna, args.vga)
    time.sleep(0.3)
    queue()
    iq = cap.wait()
    for ln in report(iq):
        print(ln, flush=True)


if __name__ == "__main__":
    main()
