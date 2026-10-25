# Who names the status mailbox at RAM 0x38ef0.
from pathlib import Path

img = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
for word, name in ((0x38EF0, "base"), (0x38EF2, "body"), (0x38EF1, "count")):
    pat = word.to_bytes(4, "little")
    at = 0
    sites = []
    while True:
        i = img.find(pat, at)
        if i < 0:
            break
        sites.append(i)
        at = i + 2
    print(name, " ".join("0x%X" % s for s in sites))
