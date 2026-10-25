from pathlib import Path

p = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\HANDOFF.md")
t = p.read_bytes().decode("utf-8")
if "\r" in t:
    raise SystemExit("cr")
a = t.find("**Stream end and stack.**")
b = t.find("\n\n**After that, in this order**")
if a < 0 or b < a:
    raise SystemExit("task %s %s" % (a, b))
block = (
    "**R-G firmware is reported** (`results.md`, tag `RG10`). A 64-sample render returned "
    "`sr=0` from `0x4AE00`. The first receive half is in phase with the rest (steps within 0.13 degrees). "
    "One 90-frame low-power key: steady p99 2794–2913 Hz, 90 payload-exact frames. "
    "Op 7 and `drop_ptt` are in the image; this key still used op 1, so the self-unkey was not the path taken. "
    "RG10 stays loaded.\n\n"
    "**R-G host (SignalDeck), next:** (a) the data-receive state: op 6 variant 3 on when an M17 or other "
    "raw-discriminator decoder starts, re-sent after every channel, VFO and tone write, action 0 when it stops, "
    "offered only when `0x34` reports a stub tag; (b) the held-path M17 front end: the Armor's 41 taps from "
    "`rf/taps.json`, applied before the sync search at symbol spacing, threshold 0.95, then the existing frame "
    "decoder and Codec 2; the DFE path stays for the plain state; (c) a host test over the 18 saved R-F clips: "
    "link-setup CRC on all 18, payload-exact at least 95 percent on each and at least 98 percent at −87/−93 dBm; "
    "(d) one device run: HackRF M17 at −87 dBm with the hold on, the M17 page shows the callsigns and the frame count, "
    "then the plain state as control.\n"
)
t = t[:a] + block + t[b:]
old = "and the 500 Hz dip is in the phone audio while the receive RAM stays flat."
add = old + " RG10: the render reply is off the stack, the first receive half matches the others, and one 90-frame key stayed at 2794–2913 Hz with 90 payload-exact frames."
if t.count(old) != 1:
    raise SystemExit("route %d" % t.count(old))
t = t.replace(old, add, 1)
i = t.find("R-F. No new image.")
j = t.find("\n\n## Owner question", i)
if i < 0 or j < i:
    raise SystemExit("last")
newlast = (
    "R-G, tag RG10. Boot peak 0.10 dB. `0x34` at 19:02:08.580. Render 128 bytes `sr=0`. "
    "1 kHz phase steps within 0.13 degrees, including the first half. "
    "One 90-frame key, steady p99 2794–2913 Hz, 90 payload-exact frames. "
    "The phone key was low power. RG10 stays loaded. VFO 467.625 at 19:04:17."
)
t = t[:i] + newlast + t[j:]
p.write_bytes(t.encode("utf-8"))
print("ok")
