# FW54 tail space map

Image `DMR003.FW54.V022`. The tail is file `0x5AEFC` through the end of the image. A byte is live if a walk reaches it from a root, or if a bench result showed that overwriting it changes behaviour.

Roots:

- `0x5AEFC`, the command `0x40` handler, from the dispatch word at `0x382B8`
- branches from outside the tail: `0x5B4D0`, `0x5B580`, `0x5B614`, `0x5BDAA`, `0x5C040`, `0x5C4C8`, `0x5C4E2`, `0x5C518`
- `0x5B700`, the tone-queue pitch helper. No branch names it. FW50 overwrote it and FT8 moved to 7500 Hz, so it is live

The walk follows fall-through and branches. It stops at an unconditional branch or a `pop` of `r15`.

## Free for a new stub

| Range | Bytes | Why it is free |
|---|---|---|
| `0x5B65A`–`0x5B690` | 54 | No branch and no literal pool lands here. It sits after the `pop` at `0x5B658`. FW50–FW52 wrote a gate at `0x5B65C` and the radio still booted and keyed. Stop before the flag literal at `0x5B690`. |
| `0x5B6A0`–`0x5B6F8` | 88 | No branch and no literal pool lands here. The next live instruction is the pitch helper at `0x5B700`. Not yet overwritten on the bench. FW56's arm uses the first 24 bytes only. |

## Not free

`0x5B700`–`0x5B71F` is the pitch helper and its literals. `0x5B720`–`0x5B77A` is the tone-end task, including the live unkey at `0x5B74C`. The rest of the tail is reached from the roots above. A gap the walk does not enter is not free if a branch from reached code lands inside it.
