# FW54 tail space map

Image `DMR003.FW54.V022`. Tail `0x5AEFC` through `0x5C6FC`. Built from `tools/fw-patch/tailmap.py` (XIP pointers, outside branches, then a walk). There is no 16-byte run of `0x00` or `0xFF`.

## Live roots

| Literal or branch | Target | What |
|---|---|---|
| `0x382B8` | `0x5AEFC` | command `0x40` |
| `0x5B3FC` | `0x5B6A0` | symbol level table, 4 bytes `03 01 FD FF` |
| `0x5B4A4` | `0x5B6A4` | 5-phase × 9-tap RRC, through `0x5B6FD` |
| `0x5BDD8` | `0x5BE00` | restore hook |
| `0x5BDDC` | `0x5AFC8` | |
| `0x5BDE4` | `0x5B65A` | module-end drop, `jsr` from `0x5BD98` |
| `0x5BE24` | `0x5AF52` | |
| `0x5BE34` | `0x5C464` | |
| `0x5C45C` | `0x5C200` | sine table through `0x5C42B`, indexed at `0x5C1E6` |
| `0x5C58C`–`0x5C598` | `0x5B2CC`, `0x5B2AC`, `0x5B2FA`, `0x5B308` | dispatcher |
| `bsr` at `0x18B68`, `0x92C8`, `0x92AA`, `0x37F8`, `0x7C56`, `0xC1BA`, `0xA890`, `0x17E26` | the same entries tailmap prints | |

`0x5B700`–`0x5B71F` is inside the unreached old RF_MODE save. It is not the pitch helper. FW50's 7.5 kHz FT8 came from the gate sending a tone-queue key to stock `0xE9C`.

## Dead, with the proof

| Range | Bytes | Proof |
|---|---|---|
| `0x5B6FE`–`0x5B71F` | 34 | Old RF_MODE save. FW44 moved it. tailmap leaves `0x5B6A8`–`0x5B71F` unreached; the table occupies through `0x5B6FD`, so only the tail of that gap is dead. |
| `0x5BF9E`–`0x5C03F` | 162 | Opcode 16 body at `0x5BFB2` and its helpers. FW29's `bsr` at `0x5BCC4` targeted `0x5BFB2`. FW30 retargeted it to `refuse`. No outside branch or XIP pointer remains. |
| `0x5C088`–`0x5C097` | 16 | Pool of that dead copy. |
| `0x5C59C`–`0x5C6FB` | 352 | Half sender. Its only caller was the dead copy at `0x5C032`. |
| `0x5BE38`–`0x5BE87` | 80 | Unreached. Not identified, so not in `space_map.FREE`. |

Opcode 13 and opcode 18 were not considered.

## The eight-byte fix is not free space

`0x5BDF4`–`0x5BDFB` is the live analog wrapper. FW57 overwrites it in place. `space_map.RETARGET` allows that write. It is not a hole.
