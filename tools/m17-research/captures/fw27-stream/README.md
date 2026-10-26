# FW27 plain-stream captures

Raw 16-bit little-endian mono, 8000 Hz. No header.

Image `DMR003.FW27.V022` (`e552549c…b2dc`). HackRF at 467.625 MHz, VGA 20, amp off, 2 MS/s. The phone was not keyed. The file is the bench 30-frame transmission (bench callsign, CAN 7, 1.6 s unmodulated lead, 0.5 s tail).

| File | What it is |
|---|---|
| `stream-1552.s16` | Plain RAM stream, period 8, 15:52. The body the plain decoder scored at 4 payload-exact frames. |
| `stream-1636.s16` | The same file into the stream again, 16:36. 3 payload-exact frames. |
| `channel56.s16` | Channel 56, hold `action=1 sr=0`, the same file, recorded 16:51. The 15:55 channel-56 pass was a listing only, so this file is that recording. |
| `stream-dev40.s16` | Same file, plain stream, deviation scaled to 40 percent (±0.96 kHz), 17:05. |
| `stream-dev60.s16` | 60 percent (±1.44 kHz). |
| `stream-dev80.s16` | 80 percent (±1.92 kHz). |
| `stream-dev100.s16` | 100 percent (±2.4 kHz). |
