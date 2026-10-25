import sys
from pathlib import Path

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17_stream_table
import m17

six = m17_stream_table.counts()
five = m17_stream_table.counts_loop5()
p6 = m17_stream_table.prediction(six)
p5 = m17_stream_table.prediction(five)
print("six", p6, "len", len(six))
print("five", p5, "len", len(five))
# Where the two prefixes diverge.
n = min(len(six), len(five))
diff = next((i for i in range(n) if int(six[i]) != int(five[i])), None)
print("first_diff", diff)
print("five_peak_at", int(abs(five).argmax()), "six_peak_at", int(abs(six).argmax()))
base = 0x03075400
print("tail_addr", hex(base + m17_stream_table.LOOP5_TAIL * 2))
print("stream_addr", hex(base + 500 * 2))
print("end_addr", hex(base + len(five) * 2))

idx = list(range(512))
cursor = 512
while len(idx) < 16000:
    if cursor >= 2100:
        cursor = 500
    idx.append(cursor)
    cursor += 1
print("played_2100", 2100 in idx, "count_500", idx.count(500))
played = five[idx]
air = -m17_stream_table.HZ_PER_COUNT * played.astype(float)
got = m17.decode_transmission(air, 8000, verbose=False)
fns = [f[0] for f in got["frames"]]
print("lsf", None if got["lsf"] is None else got["lsf"][2], "n", len(fns))
print("fn_set", sorted(set(fns)))
print("fn_head", fns[:15])
print("payloads", all(f[1] == bytes(16) for f in got["frames"]),
      "lerr", all(f[2] == 0 for f in got["frames"]))
print("has_eot", any(f & 0x8000 for f in fns))
