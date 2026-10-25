"""Wake only on an R4e bench failure, a deviation stop, or a finished restore."""
import time
from pathlib import Path

LOG = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4e0_run.log")
seen = 0


def read_log():
    raw = LOG.read_bytes()
    if raw[:2] == b"\xff\xfe":
        return raw.decode("utf-16")
    return raw.decode("utf-8", errors="replace")


def interesting(line):
    if "STOP False" in line:
        return False
    keys = (
        "Traceback",
        "RuntimeError",
        "SystemExit",
        "not loading",
        "not keying",
        "not transmitting",
        "boot radiated",
        "hackrf stalled",
        "is not the built",
        "STOP True",
        "STOP burst",
        "R4e0 finished",
    )
    return any(k in line for k in keys)


def main():
    global seen
    while not LOG.exists():
        time.sleep(5)
    while True:
        text = read_log()
        new = text[seen:]
        seen = len(text)
        hit_done = False
        hit_fail = False
        for line in new.splitlines():
            if not interesting(line):
                continue
            if "R4e0 finished" in line:
                hit_done = True
            elif "STOP True" in line or "STOP burst" in line:
                print("ACTION_REQUIRED: " + line.strip(), flush=True)
            else:
                hit_fail = True
                print("FAILED: " + line.strip(), flush=True)
        if hit_done and not hit_fail:
            print("DONE: R4e0 finished", flush=True)
            return
        if hit_fail and hit_done:
            print("FAILED: run ended after an error", flush=True)
            return
        time.sleep(30)


if __name__ == "__main__":
    main()
