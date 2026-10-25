# Silent watcher for one R4i0 bench. Stdout is only DONE or FAILED.
# Diagnostics go to watch_r4i_diag.log. A sha256 line is not a failure.
import subprocess
import time
from pathlib import Path

LOG = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4i0_run.log")
DIAG = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\watch_r4i_diag.log")
FAILS = (
    "Traceback",
    "boot radiated",
    "not loading",
    "not transmitting",
    "not keying",
    "stopped answering",
    "is not the built",
    "is not R4i0",
    "hackrf stalled",
    "hackrf already",
    "hackrf is not",
    "STOP True",
    "STOP burst",
    "SystemExit",
)
LIMIT_S = 20 * 60


def alive():
    r = subprocess.run(
        ["powershell", "-NoProfile", "-Command",
         "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*r4i0_run.py*' } | Select-Object -ExpandProperty ProcessId"],
        capture_output=True, text=True)
    return bool(r.stdout.strip())


def main():
    t0 = time.time()
    seen = 0
    while True:
        time.sleep(30)
        text = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
        hit = next((p for p in FAILS if p in text), None)
        running = alive()
        DIAG.write_text(
            "elapsed %.0f bytes %d running %s hit %s\n" % (
                time.time() - t0, len(text), running, hit),
            encoding="utf-8")
        if hit:
            print("FAILED: %s" % hit, flush=True)
            return 1
        if "R4i0 finished" in text and not running:
            print("DONE", flush=True)
            return 0
        if not running and time.time() - t0 > 90 and "R4i0 finished" not in text and len(text) == seen:
            if len(text) > 0 or time.time() - t0 > 180:
                print("FAILED: runner exited without finish", flush=True)
                return 1
        seen = len(text)
        if time.time() - t0 > LIMIT_S:
            print("FAILED: stalled", flush=True)
            return 1


if __name__ == "__main__":
    raise SystemExit(main())
