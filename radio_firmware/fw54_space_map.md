# FW54 tail space map

Image `DMR003.FW54.V022`. Tail `0x5AEFC` through the end of the file. There is no 16-byte run of `0x00` or `0xFF` in it. A range is free only when nothing reaches it.

## Roots

Thirteen XIP pointers (`0x0301A000 + offset`), every 2-byte-aligned word of the image in `0x03074EFC`–`0x030766FB`:

| Literal | Target | What |
|---|---|---|
| `0x382B8` | `0x5AEFC` | command `0x40` handler |
| `0x5B3FC` | `0x5B6A0` | M17 symbol level table (`03 01 FD FF`) |
| `0x5B4A4` | `0x5B6A4` | pulse-shape table |
| `0x5BDD8` | `0x5BE00` | restore hook |
| `0x5BDDC` | `0x5AFC8` | |
| `0x5BDE4` | `0x5B65A` | module-end drop. `0x5BD98` does `jsr` through this pointer |
| `0x5BE24` | `0x5AF52` | |
| `0x5BE34` | `0x5C464` | |
| `0x5C45C` | `0x5C200` | |
| `0x5C58C`–`0x5C598` | `0x5B2CC`, `0x5B2AC`, `0x5B2FA`, `0x5B308` | four dispatcher targets |

Plus every `bsr` / `br` / `bt` / `bf` from outside the tail. The pitch helper `0x5B700`–`0x5B71F` has no pointer and no branch. FW50 overwrote it and FT8 moved to 7500 Hz, so it stays live.

## Not free

`0x5B65A` is the drop function, not a hole. `0x5B6A0` is the symbol level table, not a hole. FW56 wrote both and is rejected. Do not load it.

## Dead, with the proof

`0x5BFB2`–`0x5BFFE` (76 bytes). In FW29 the call at `0x5BCC4` was a `bsr` to `0x5BFB2`. FW30 retargeted that call to `refuse` at `0x5BD74`, and FW54 still does. No branch from outside this range and no XIP pointer lands in it. The halfword before it, at `0x5BFB0`, is `pop r15`, so nothing falls through. The function returns at `0x5BFF0`. The next halfword, `0x5BFFE`, is a different routine.

76 bytes is not enough for the tone-aware gate, which links to 102 bytes. Nothing else in the tail is proven dead. Opcode 13 and opcode 18 were not considered.

## How a tone-only key reaches `on_key`

`0x4DAAC` is set by opcode 1. A tone-queue key (FT8, RTTY, MCW, POCSAG through opcodes 8–11) does not set it. `fw22_gate` in `stubs/fw22_ext.S` arms when:

- the ring count at `0x4A3E8` is below the base at `0x4A3E4`, or
- `0x4B014` equals the tone magic `0x47572102` and either the halfword at `0x4B030` or the word at `0x4B02C` is not zero.

A gate that tests only `0x4DAAC` sends those keys to stock `0xE9C`, and the queue never plays.
