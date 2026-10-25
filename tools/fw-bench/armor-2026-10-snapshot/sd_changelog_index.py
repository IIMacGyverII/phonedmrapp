"""Stage SignalDeck CHANGELOG as HEAD plus the FW19 eot entry, without the W6 notes."""
import subprocess
from pathlib import Path

repo = Path(r"D:\Documents\code\personal\SignalDeck")
head = subprocess.check_output(["git", "show", "HEAD:CHANGELOG.md"], cwd=repo)
entry = """## 2026-10-24 — Bench symbol stream keys itself and ends on op 7

| Backlog | Change | Files | Test |
|---|---|---|---|
| FW19 | DIAG `cmdsym` with `--ez eot` streams a packed-symbol file, keys once with the launch command after eight chunks (no 28 s watchdog, no microphone), and marks the last chunk op 7 so the module drops PTT. It does not send the unkey. A `cmdsym` without `eot` still does not key. Hidden bench extra; the in-app guide is unchanged. | `DiagReceiver.java`, `RadioService.java` | Device, Wi-Fi adb, FW19, 467.625 MHz, low power: two 45.12 s streams, last chunk op 7, module status byte 4, host did not send the unkey. The first capture decoded 1124 frames, 1123 payload-exact. |

""".encode("utf-8")
needle = b"CHANGELOG_DRAFT.md).\n\n"
at = head.find(needle)
if at < 0:
    raise SystemExit("anchor missing")
blob = head[: at + len(needle)] + entry + head[at + len(needle) :]
out = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\sd_changelog_index.md")
out.write_bytes(blob)
print(out, len(blob))
