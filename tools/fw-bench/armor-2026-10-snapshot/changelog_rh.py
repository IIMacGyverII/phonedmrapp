# Splice the R-H changelog entry into the committed changelog, and remember how to
# put the other agent's W6 notes back afterwards. LF, no BOM.
from pathlib import Path

p = Path(r"D:\Documents\code\personal\SignalDeck\CHANGELOG.md")
text = p.read_text(encoding="utf-8")
mark = "## 2026-10-24 — Custom ROMs"
i = text.index(mark)
header = text[: text.index("## ")]
w6 = text[text.index("## ") : i]
rest = text[i:]
entry = """## 2026-10-24 — M17 live receiver keeps one contact for the whole transmission

| Backlog | Change | Files | Test |
|---|---|---|---|
| R-H | The held-path receiver searches every sync chain in the audio it has, skips audio the module is still muting, and opens a contact only from a link-setup CRC or six LICH chunks. It keeps that audio until the call ends, then drops it, so the same transmission is not listed again. Releasing the push-to-talk sends the voice-filter hold again. The earlier phone run (13 of 30 frames, empty callsigns, and the plain-state control repeating the held callsigns) was partial. | `HeldPath.java`, `HeldPathReceiver.java`, `HeldPathTest.java`, `RadioService.java`, `HelpView.java` | Host: `HeldPathTest`. Each of the 18 saved clips, with 3 s of its muted head in front, fed in 64 ms blocks and decoded again while the clip was still arriving: one contact, the right callsigns, and the reference frame count (18 on the short clip, 73–77 on the others). The batch decoder's exact counts are unchanged. Device, Wi-Fi adb, RG10, 467.625 MHz, HackRF VGA 20, raw RSSI `0x43`: three 30-frame transmissions with a 1.6 s lead gave `K6M17 → W9LAB` 28, `W5RF → N6EQ` 28, and `N5TST → K6DEC` 27, and no listing without callsigns. The plain-state control with the lead listed `W1RF → N2EQ`, 27 frames. |

"""
commit = header + entry + rest
restore = header + w6 + entry + rest
Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\changelog_restore.md").write_text(restore, encoding="utf-8", newline="\n")
p.write_text(commit, encoding="utf-8", newline="\n")
print("commit bytes", len(commit.encode()), "w6 starts", w6.splitlines()[0])
