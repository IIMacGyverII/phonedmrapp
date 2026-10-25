# Silent watcher for r4k0_run.py. Prints one line: DONE or FAILED.
import sys
import time
from pathlib import Path

LOG = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4k0_run.log")
FAIL = (
    "Traceback (most recent call last)",
    "boot radiated",
    "STOP True",
    "STOP burst",
    "not the built image",
    "hackrf stalled",
    "is not DMR003.R4k0.V022",
    "hackrf is not transferring",
    "USB phone not ready",
    "image missing",
    "banner missing",
    "factory restore failed",
)
DONE = (
    "R4k0 stays loaded",
    "R4k0 finished, factory image",
)


def main():
    deadline = time.time() + 1200
    while time.time() < deadline:
        text = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
        for needle in FAIL:
            if needle in text:
                print("FAILED: " + needle, flush=True)
                return 1
        for needle in DONE:
            if needle in text:
                print("DONE: " + needle, flush=True)
                return 0
        time.sleep(20)
    print("FAILED: watcher timeout", flush=True)
    return 1


if __name__ == "__main__":
    sys.exit(main())
