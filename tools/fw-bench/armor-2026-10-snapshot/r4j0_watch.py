# Silent watcher for r4j0_run.py. Prints one line: DONE or FAILED.
# A sha256 line is not a failure. Failure phrases are checked before the
# finished line. Debug goes to r4j0_watch.log.
import sys
import time
from pathlib import Path

LOG = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4j0_run.log")
DEBUG = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4j0_watch.log")
FAIL = (
    "Traceback (most recent call last)",
    "boot radiated",
    "STOP True",
    "STOP burst",
    "not the built image",
    "hackrf stalled",
    "is not DMR003.R4j0.V022",
    "hackrf is not transferring",
    "USB phone not ready",
    "image missing",
    "banner missing",
    "factory restore failed",
)
DONE = (
    "R4j0 stays loaded",
    "R4j0 finished, factory image",
)


def main():
    deadline = time.time() + 1200
    seen = 0
    DEBUG.write_text("", encoding="utf-8")
    while time.time() < deadline:
        text = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
        new = text[seen:]
        seen = len(text)
        if new:
            DEBUG.write_text(text[-4000:], encoding="utf-8")
        # A sha256 digest is not a failure phrase. The needles below do not match one.
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
