# Armor 26 Ultra radio-module firmware: reference

Everything we know about the radio module's firmware (`DMR003.UV4T.V022`: HR-C7000 SoC, C-SKY CK803S, AT1846S RF IC, with the phone's ES8311 codec), with sources, as of 2026-10-30. Four chapters were written in parallel and reviewed by the managing agent.

**Evidence labels:**
- **V** = verified, with a bench run, a listing of the factory image, or code cited;
- **I** = inferred;
- **S** = superseded.

**Precedence:** where the sources disagree, the code and the latest bench result win. Each chapter has its own "Where the sources disagree" table.

| Chapter | Covers |
|---|---|
| [01 Hardware, memory map, boot](01-hardware-memory-boot.md) | The chips and their registers (the HR-C7000 modem at `0x11000xxx`, the AT1846S register by register, `0x58` bit by bit, the ES8311); file↔XIP↔IRAM↔SRAM address arithmetic; the file layout; the free tail `0x5AEFC–0x5C6FB` (6144 B); RAM variables (factory and ours); reset, `main`, the init task, the task list, the vector table and ISR; the loader (knock, YModem, flash persistence, restore); the toolchain and `symbols.csv` |
| [02 UART commands and handlers](02-uart-commands-and-handlers.md) | The host↔module frame format and checksum; the full dispatch table (every case named from the image); one block per command (0x22 … 0x8A) with body layout, handler, measured behaviour and gotchas; channel writes and the busy byte `0x32457`; transmit (`0x26`, `tx_launch` `0xE9C`, `0xE64`, key state, semaphore); receive admission; status codes; host start-up |
| [03 Our patches and images](03-our-patches-and-images.md) | The patch system (`patches.toml`, `build.py`, the per-image scripts, `literal_guard`, and what it misses); command `0x40` opcodes 1–18; the key path we built (`on_key`/`on_unkey`, the FW20 drain, `drop_ptt`, the saves); every image FW0–FW56 with its source, change, result and sha256; the four `0x26` call sites per image; the provisional tail map with the 13 XIP pointers |
| [04 Measured behaviour and modes](04-measured-behaviour-and-modes.md) | The transmit and receive audio paths with numbers (`0x58` and UVm tables, the held path, the receive-RAM stream); every mode's state and feasibility (FM, CTCSS, DMR, M17, POCSAG, APRS, FT8/RTTY/MCW, SSTV, NOAA, SAME, DTMF); timing and limits (time-out, heat, tuning range, settle times); bench methods and their pitfalls |

**Related:**
- `docs/firmware-agent-onboarding.md`: the firmware agent's role and working rules;
- `radio_firmware/HANDOFF.md`, `reviews.md`, `results.md`: the live bench record;
- `docs/deep-dive/19-firmware-modification-plan.md`: the plan and progress log;
- `docs/grok-deep-dive/11-firmware-fw0-results.md`: the original reverse engineering.

## Findings that change earlier documents (fix these at the source)

| Topic | Correct statement | Stale in | Chapter |
|---|---|---|---|
| Free tail size | 6144 B (`0x5AEFC–0x5C6FB`), not 1788 B | `radio_firmware/README.md`, ch. 19 §1/§6, `symbols.csv` `zero_tail`, ch. 11 §1 | 01 §6 |
| Dispatch tables | In the image, in XIP flash (`+0x38240` phone table, `+0x380D8` 0x21 table), not RAM-only | ch. 11 §14.1–14.2, ch. 19 §1 | 01, 02 |
| "External region" / "ROM" targets | IRAM code copied from the file, not outside it and not ROM | ch. 11 §12–13, ch. 19 §1, results FW44, HANDOFF | 01 §6 |
| `0x1924` | A semaphore **post**, not a take (uC/OS-III error codes) | results/HANDOFF FW44–45 | 01 §6 |
| `0x5B700–0x5B71F` | In FW46/54/55 it holds FW37's uncalled RF_MODE save/restore. The "live pitch helper" label rests only on the FW50 correlation, and FW50 also overwrote `drop_ptt` | fw53–55 headers, the space map, rev:2816 | 03 §3, §7 |
| "Free" tail ranges | `0x5B65A` is `drop_ptt` (reached through the XIP pointer at `0x5BDE4`), and `0x5B6A0` is the dibit table (`01 03 FF FD`) plus the RRC taps. FW49–52 and FW56 overwrote them; the guards missed it | old space map, rev:2853 | 03 §6 |
| FW54 phone-audio failure | The firmware agent's root cause: since FW3F the analog wrapper at `0x5BDEC` calls `fw22_gate` with an extra `push r15`, so the skip path unbalances the stack on every analog key with nothing queued. FW57 = FW54 plus an 8-byte in-place fix | (new, 2026-10-30) | 03 §8 (the same open item) |
| Tone-queue "waiting" test | `0x4B014 == 0x47572102` and (`0x4B030` ≠ 0 or `0x4B02C` ≠ 0), read at FW54 `0x5BBE2` | rev:2853 item 4 open | 03 §3 |
| Image sources | FW51–FW54 are built from FW46; FW55 from FW54; FW40, FW41 and FW44 from FW37 (re-applying FW38); the accepted FW30 is FW3K retagged | assorted results headers | 03 §4 |
| Tags vs hashes | The FW27/30/31/32 tags cover several different images, so cite the sha256. FW20's sidecar hash is stale | `.sha256` sidecars | 03 §4 |
| Receive status sites `0xC1BA`/`0xC244` | Getter `0x2404` chooses status 1/2 vs 10/11. It is not a "groups match → admit or mute" decision, which may bear on the FW26+ DMR deafness | `docs/promiscuous-rx-patch-spec-2026-10-24.md` Patch A | 02 §11 |
| Command numbers | `+0xAAD8` is 0x8A (TX gain, register 0x44), not 0x2A. `+0xABF2` is 0x89 (no reply). `+0xAB3E` is the 0x36 host ack | ch. 11 §14.2/§21.2, `symbols.csv` comments | 02 §11 |
| Time-out | FW36 removed FW19's 120 s clamp, and HANDOFF says never add a TX timer. The stock `0x3B` stores the byte (0 = off). SignalDeck's `bootHandshake` already sends 120 | CLAUDE.md §3 "Transmit length", SignalDeck `RE.ptt` javadoc (30 s) | 04 §6, 02 §11 |
| Checksum | The dispatcher computes the checksum and then overwrites it (`+0xAA96`), so a bad checksum is not refused (listing reading, not bench-tested) | — | 02 §11 |
| Ops 16/17 refuse stub | On FW30+ it does an absolute `jsr` to `0x8E7C`, which looks like a wild jump. The host must not send ops 16/17 (SignalDeck PR 14 ramstream) until confirmed | — | firmware agent note |

The full lists are in each chapter: 01 §6 (13 rows), 02 §11 (19 rows), 03 §7 (24 rows) and 04 §6 (15 rows).

## Open questions

Each chapter ends with its own list: 01 §7, 02 §12, 03 §8 and 04 §7. The ones that most affect the current work (FW57 and after):
1. **The FW54 stack imbalance at `0x5BDEC` → `0x5BBE2`.** The firmware agent has the root cause, and FW57 is in progress.
2. **The first-key group slot 0 fault and the busy byte `0x32457`.** The sources disagree on when the `0x22` success path clears it (02 §11 rows 8–9); measure it on factory and on our image.
3. **What the receive status getter `0x2404` (byte `0x38B5C+0xAF`) means**, and whether it explains the DMR deafness on bench images.
4. **The CTCSS table off-by-one:** 50 entries from `+0x366B2` against the OEM's 51 from 62.5 Hz.
5. **Whether `0x22` accepts 480–520 MHz** on the Armor (its literals say 400–520, but the bench `0x23` range is 400–480; never tested above 480).

## Maintenance

These chapters are a snapshot. The firmware agent owns them from here: when an image or bench result changes a fact, update the chapter and its sources table in the same commit. No owner callsign or DMR ID anywhere; examples use N0CALL, DMRTST-7, 1234567 and TG 9.
