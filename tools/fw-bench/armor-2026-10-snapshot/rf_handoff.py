from pathlib import Path

p = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\HANDOFF.md")
b = p.read_bytes()
if b.count(b"\r"):
    raise SystemExit("cr")
t = b.decode("utf-8")
a = t.find("**R-F next")
c = t.find("**Then: stream end and stack.**")
if a < 0 or c < a:
    raise SystemExit("markers %s %s" % (a, c))
reported = (
    "**R-F is reported** (`results.md`). The fixed equaliser trained on the R-E loop "
    "does not meet the independent-data pass: at ±2.4 kHz and VGA 20 the locked clips "
    "are Golay 0 on 57/75 and 46/75 frames, and the third does not stay on the stream. "
    "The 500 Hz dip is −9.6 dB on the phone and −0.2 dB in the receive RAM, so it is the ES8311. "
    "RE10 stays loaded. Do not key it.\n\n"
    "**Stream end and stack.**"
)
t = t[:a] + reported + t[c + len("**Then: stream end and stack.**"):]
old = (
    "and a variant-3 restore alone returns the plain 100 Hz level."
)
add = (
    old
    + " R-F: those taps on new callsigns and random payloads reach 57/75 Golay 0 at ±2.4 kHz and VGA 20, "
    "and the 500 Hz dip is in the phone audio while the receive RAM stays flat."
)
if t.count(old) != 1:
    raise SystemExit("route %d" % t.count(old))
t = t.replace(old, add, 1)
prefix = "R-E. Held phone path locks M17 sync and frames 0/1, no CRC, no Golay 0."
i = t.find(prefix)
j = t.find("\n\n## Owner question", i)
if i < 0 or j < i:
    raise SystemExit("last %s %s" % (i, j))
newlast = (
    "R-F. No new image. Independent M17 at ±2.4 kHz VGA 20 is Golay 0 on 57/75 and 46/75, "
    "and one clip does not lock. RSSI raw 66 is −87 dBm; VGA 0 is −99 dBm. "
    "Phone 500 Hz is −9.6 dB; receive RAM is −0.2 dB. "
    "POCSAG 1200 baud is 0.24 errors per codeword plain, 0.039 behind the taps. "
    "The phone was not keyed. RE10 stays loaded. VFO 467.625 at 18:31:55."
)
t = t[:i] + newlast + t[j:]
p.write_bytes(t.encode("utf-8"))
print("ok", p.read_bytes().count(b"\r"))
