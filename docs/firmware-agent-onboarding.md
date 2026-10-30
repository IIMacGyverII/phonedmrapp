# Firmware agent onboarding (Armor 26 Ultra radio module)

Written 2026-10-30 by the managing Claude agent (phonedmrapp-06) for the new **firmware Claude agent**. The owner set up the split:
- You direct Grok Build on the firmware.
- You review its work, confirm results and help engineer the patches.
- Grok does the hands-on work: builds, loads, bench runs.

You own nothing outside firmware. Read this whole page, then the sources in §2, before your first review.

---

## 1. Your role and the boundaries

| Area | Who |
|---|---|
| Grok's tasks, reviews, nudges, acceptance verdicts (`radio_firmware/HANDOFF.md`, `reviews.md`) | **you** (from the handover line in HANDOFF, the managing agent stops writing there) |
| Firmware design, the build chain, the space map, the guards | **you** design and review, **Grok** builds |
| Loading images, keying the Armor, HackRF captures, bench runs | **Grok** (through HANDOFF tasks) |
| **HackRF schedule** (shared by Grok, the Atom XL agent, the W6 DMR agent and the managing agent) | **managing agent.** Ask it for slots. Grok has priority, so you get it unless a lease is mid-run. Grants to Grok go as the **first bold line under `STATUS:`**; Grok's `wait_slot.py` reads only that line. |
| The Armor phone | yours (Grok's bench), except one managing-agent APRS check (SignalDeck PR 93) that it will book with you |
| SignalDeck PRs that depend on firmware (PR 94 `claude/fw37-unkey`, PR 74 `promisc-host`, the host side of FW56) | **you** review and approve. The **managing agent merges** (it holds the merge workspace and runs the suite). |
| Releasing an image to the firmware home repo | **the owner decides.** You prepare (manifest, provenance, results). |
| Owner questions | Put them in HANDOFF `STATUS: OWNER`, or ask the owner directly in your session |

Reach the managing agent with SendMessage to **`phonedmrapp-06`**. The other agents are `phonedmrapp-0a` (Atom XL; can act as a **second receiver** for DMR/M17 rows, receive only, with its own lease line) and `phonedmrapp-de` (W6 phones, in a second cage on 434 MHz).

## 2. Read first, in this order

1. `CLAUDE.md` (repo root), the **MCU firmware RE** row in §1 and the **M17**, **POCSAG** and **Transmit length** rows in §3. These are the dense verified facts.
2. `radio_firmware/HANDOFF.md`: Protocol, Standing approval (the equipment-protection, scope and measurement rules), Current task, route list.
3. `radio_firmware/reviews.md`: at least the last ~10 reviews, **especially "Firmware state brief (Claude, 2026-10-30 08:30)"**.
4. `radio_firmware/results.md`: FW45 → FW55 (search "FW45", "FW50", "FW52 acceptance", "FW54 acceptance", "FW55").
5. `docs/deep-dive/19-firmware-modification-plan.md`: the plan, phases A–E, the progress log, §13 (the loader and flash), §14 (persistence), §23 (stubs on the key-up path run at boot).
6. `docs/grok-deep-dive/11-firmware-fw0-results.md` §12–§14 and §21: the memory map and the AT1846S register map.
7. `tools/fw-patch/`:
   - `fw30_build.py` (the base helpers `bsr_target`, `encode_bsr`, `encode_br`, the lrw encoders, `_linked`);
   - `fw44_build.py` … `fw55_build.py` (the current lineage);
   - `literal_guard.py`;
   - `stubs/c7000_cmd40_sym.S` (the symbol engine, `on_key`/`on_unkey`, op map);
   - `stubs/c7000_fw20_gate.S`;
   - `test_patches.py` (the 0x26-site tests from line ~480).
8. `radio_firmware/plan-loader-safety.md` (the loader contract), `radio_firmware/symbols.csv`, `tools/fw-bench/README.md` + `runner/` (the regression runner `bench.py`, rows `boot`, `tone`, `stream`, `heat`, `receive`, `all`).
9. Memory notes (the managing agent's; useful background): `firmware-at1846s-and-version-reply`, `armor-fw-key-path-architecture`, `m17-deep-dive`, `firmware-patch-priority`, `hotspot-not-sole-receiver`, `firmware-bench-handoff`.

## 3. The hardware, in one page

**Module:** DMR003, firmware `DMR003.UV4T.V022` (the factory image is `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin`).

**SoC:**
- HR-C7000, **C-SKY V2 (CK803S), not ARM.** Never use the old `0x08xxxxxx` ARM addresses.
- The DMR/FM baseband, codec, and TX/RX RAM sit at `0x11000xxx` and `0x16000xxx`.

**Memory map (file offset → runtime):**
- Flash code runs XIP at **`0x0301A000 + file offset`**.
- IRAM `0x10000..` is copied from file `+0x39408`.
- SRAM `0x18000800..` is copied from `+0x322E0`.
- The free tail is **`+0x5AEFC..+0x5C6FB`** (6144 B). **Never write past `0x5C6FC`** (owner rule).
- The version string is at `+0x38464`, and every image carries its tag there, so `0x34` answers with it. That is how you know what is in flash.

**RF IC: AT1846S** (I²C write `+0x54628`, read `+0x54664`):
- **Register `0x58`** holds the filter bits:
  - `0x8405` = analog, all filters on;
  - `0xBCFD` = DMR, bypassed;
  - bit 7 = TX pre-emphasis;
  - bit 6 = voice HPF;
  - bit 5 = 3.5 kHz voice LPF;
  - bits 3 and 4 = CTCSS filters.
- Register `0x30` is the TX/RX enable; bit 5 is the receive-on edge.

**Codec:** the phone-side converter is an **Everest ES8311** (I2S at 8 kHz). Module firmware cannot open the bottom octave (TX cut closed, ch. 19 §19).

**Loading:**
- Update mode is the `dmr009` GPIO knock with PTT held, then the byte `0x31`, then **plain YModem-1K** (no MD5 or signature).
- A load takes about 150 s at block pause 0.
- **Loads go to flash and persist** across power-cycles and reboots.
- **Restore = load the factory image again**; SignalDeck's Module firmware page has Restore.
- Opcode 12 on our images is a flash read-back (971 s for the whole image).

**Bench:**
- The Armor and the HackRF sit side by side in a Faraday cage; anything that cannot damage equipment is allowed.
- Defaults are **467.625 MHz, low power** (for comparable numbers, not a limit).
- adb is over Wi-Fi.
- SignalDeck owns the radio.
- Grok's working directory is `C:\Users\Joshua\AppData\Local\Temp\fw1718` (`fw30/` holds its scripts and captures).
- Disassembler: `C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe` (plus `-as`, `-ld.bfd`, `-nm`). Ghidra C-SKY: `scripts/fw1_ghidra_csky.ps1`.

## 4. How the transmit path works (read this twice)

**The host keys with command `0x26`.** Its handler has four call sites that, in the factory image, all `bsr 0xE9C` (`tx_launch`, the stock key/unkey):
- **body 1 (key):** `0x92C8`, `0x92E0`;
- **body 2 (unkey):** `0x92AA`, `0x92FA`.

Inside `0xE9C`:
- it stores `r1` into the key-state byte `0x38875` when `0xE64` returns 0;
- `0xE64` reports busy from channel byte `0x38B5C+0xAE` and the bits of `0x38908`;
- it takes the semaphore at `0x390D4`.

**Two `0xE9C` calls for one key leak that semaphore** (fixed in FW45).

**Command `0x40` is ours (`stubs/c7000_cmd40_sym.S`, linked at `+0x5AEFC`), and it never keys.**
- Ops 1 and 7 append M17 symbols to a 2048-byte ring at `0x4A400` (count `0x4A3E4`, base `0x4A3E8`).
- Op 3 resets the ring.
- Op 5 captures FM receive halves.
- Op 6 is the receive-filter hold (variant 3 = `0x58`=`0xBCFD`, held; the hold marker at `0x4B008` = `0x484F4C44`).
- Ops 8–11 are the generic engines (2- or 4-level symbols, polyphase, and a 64-pair tone queue for FT8, RTTY, MCW and POCSAG).
- Op 12 reads flash.
- Op 13 plays the DAC.
- Op 14 reads a RAM window.
- Op 15 is the promiscuous flag.
- Ops 16 and 17 were the receive-RAM stream; FW30 made them answer sr=1.
- Op 18 reads one AT1846S register.

The op map is in the stub header. Check it there, not here.

**The symbol ring and tone queue play only through `on_key`.** The host's 0x26 body 1 reaches `on_key`, which:
1. calls the stock `0xE9C` first;
2. **only if** the ring or a tone queue is waiting, arms TX RAM: RF_MODE `0x11000104` = `0x10E0`, WORK_MODE `0x11000100` = `0x80`, TX-RAM bit `0x11000080` bit 0, AT1846S `0x30` and `0x58` = `0xBCFD`, `0x11000560` = 1, the flag `0x4DAAC` = 1.

**`on_unkey`** clears all of that, but only when `0x4DAAC` is set.

The symbol-end task runs the drop (`0x5BD98`), the TX-bit clear, and a countdown at `0x4B010`. FW20 learned that **the stock unkey must run while the TX bits are still set**, or the receiver stays off.

**Where the four sites point in each image** (read with `fw30_build.bsr_target`):

| Image | body 1 | body 2 | Consequence |
|---|---|---|---|
| factory | 0xE9C | 0xE9C | no M17/tone queue |
| FW46, FW54 | 0x5B580 (pre_key save, then on_key) | 0x5B614 (0x5BE14 save/restore, then on_unkey) | plain unkey diverges from stock; FW54 phone-audio keys (test tone, SSTV) radiate nothing |
| FW50–FW52 | gate 0x5B65C | gate 0x5B660 | correct design (our path only while a symbol transfer is active), but bytes collided (below) |
| **FW55** | 0xE9C | 0xE9C | phone audio fine; **M17, POCSAG, FT8, RTTY cannot key at all** (untested in its proof) |

**Lineage trap:** FW53, FW54 and FW55 were all built from **FW46**, not FW52, so the FW50 gate is in none of them. Always check `SRC` in a build script before reasoning about what an image contains.

**Byte collisions that cost a night:**
- FW50 wrote over **`0x5B700–0x5B71F`**, the tone-queue pitch helper: FT8 came out at 7.5 kHz.
- FW52 wrote over **`0x5B74C–0x5B755`**, the live unkey: group slot 0 went silent.

The literal and branch guards in `literal_guard.py` (`covered_loads`, `covered_branches`, `never_written`) did not see these, because they are reached in ways the guard doesn't trace.

**Earlier rule from FW27:** a reclaimed range must contain no literal that code outside it loads through a PC-relative `lrw`.

## 5. Where things stand (2026-10-30 08:30)

**Worked on at least one image tonight** (the HackRF as second receiver):
- plain FM key/unkey/key ×3;
- a module-ended symbol key followed by a tone that radiates;
- two early host unkeys in a row (FW52);
- the 10 min soak (FW52: 27 cycles; FW54: 116 keys);
- POCSAG 16/16 (FW52);
- CTCSS 67.0 Hz both ways (FW52), and the tone on transmit (FW55);
- M17 TX 1125/1125 payload-exact with the end bit (runner `all`), and M17 RX 19/20 even right after a symbol key (FW52);
- DMR TX: group slot 1 and private on both slots, with the bench ID and CC1;
- FT8 decoded and released, RTTY text (FW54);
- SSTV Robot 8 decoded (FW52, FW55);
- the promiscuous flag on/off (FW54).

**Open:**
1. **No image has every row at once.** Each fix broke something an earlier image passed: the FW46 tone hold, the FW50 pitch, FW52 slot 0, FW54 phone audio, FW55 symbol keying.
2. **The first DMR group slot 0 key after one channel write** has a carrier but no sync. The factory image decodes it, and a second write or a second key decodes. Grok's offline finding (results 07:58) is the **busy flag `0x32457`**: the `0x22` handler sets it, and the idle task clears it only when the countdown at `0x38908+0xB` reaches 100, byte `+0xA` is non-zero and `0x32458` is 0. A write arriving while it is set doesn't change the mode. Next: read those three bytes after a stock unkey and after the first `0x22`, on factory and on our image, and find what of ours holds the flag.
3. **DMR receive is unproven.** HackRF replays reached only −108 and −105 dBm. **Use the hotspot as the DMR transmitter** (allowed for receive rows, with a lease line), or ask the managing agent for the W6Plus DMR. Then promiscuous on/off with real out-of-list calls.
4. SignalDeck PRs waiting on a stable image: **94** (`claude/fw37-unkey`, `fb1f89e0`, "0x26 off and one channel write after a symbol key") and **74** (promiscuous MON host side, merge once promiscuous passes).

**The plan the managing agent left** (reviews.md, 08:30 brief):
1. **The space map.** Write `radio_firmware/fw54_space_map.md`: every range of the tail (and anything else we write), its owner, and everything that reaches it (bsr/br/jsr targets, lrw pools, computed jumps, dispatcher tables). Only unreferenced bytes are free, and our own old stubs are live until a trace proves them dead. Then add a check to `literal_guard.py`: new bytes must fall in the map's free ranges, or the build refuses.
2. **FW56 = FW54 + the FW50 gate, placed only in mapped free bytes.** While a symbol transfer is active (the ring is queued, a tone queue is live, or `0x4DAAC` is set), body 1 goes to `on_key` and body 2 to `on_unkey`. Otherwise both bodies call the stock `0xE9C` once. Carry over FW51's single stock unkey per symbol key and FW52's early-unkey clear (`0x4DAAC` to 0, the countdown to 0, the refuse latch `0x4D900`, cleared by op 3).
3. **The FW56 proof, M17 first:**
   - M17 TX payload-exact, with one module-ended and one early host unkey;
   - then FM ×3;
   - FT8 decoded and released;
   - RTTY;
   - CTCSS tone and SSTV (phone audio);
   - POCSAG;
   - DMR group and private on both slots.
4. The slot 0 busy-flag fix, or a bisect of that single test across factory → FW20 → FW26 → FW30 → FW37 → FW44 → FW46 (about 150 s per load).
5. **The full acceptance pass** (§6), then merges of PRs 94 and 74 through the managing agent, then the owner's release decision.

## 6. The acceptance pass (owner's order: any fix gets the full pass on the same image)

**Every row:**
1. plain FM key/unkey/key ×3;
2. FM + CTCSS both ways;
3. DMR group and private, both slots, both ways;
4. M17 TX and RX payload-exact, plus M17 RX right after a symbol key;
5. POCSAG decoded and scored;
6. FT8 and RTTY decoded, and the key released;
7. SSTV decoded;
8. promiscuous on/off;
9. runner `all`;
10. a 10 min soak alternating symbol, FM and DMR keys, with heat logged;
11. heat.

**Rules:**
- **Every row needs a second receiver:** the HackRF with our own decoder, or the Atom XL. **The hotspot alone never fails a test.** It may *transmit* for receive rows.
- **A row needs a decode, not just a carrier.**
- **Every image runs every row.** Keep a **regression table** (rows × images) in `results.md`, so each change shows what it fixed and what it broke.
- Firmware priority (owner): **M17 > DMR promiscuous > TX time-out.** **Never add a TX timer.** The 120 s time-out ceiling is approved and stays.

## 7. Rules that are not optional

- **Scope:** no band-limit, power or RF-regulatory patches. Only the YModem path, never a raw flash command. Stubs on the key-up path act only on a host-requested transmission and do nothing at boot.
- **Equipment:**
  - **HackRF:**
    - the receive front end stays under its damage level (low power, or distance or an attenuator);
    - never key the phone while the HackRF transmits next to it;
    - send a dummy burst first after a pause;
    - **never a backgrounded `-R`**;
    - files ≤ 60 s;
    - timeout from the file length;
    - a stuck transfer means power-cycling the PortaPack.
  - **ES8311:** register writes only when the effect and the reset path are written down first.
  - **The phone:** **no `adb uninstall`**; a reboot is the last resort.
- **The ±5 kHz deviation stop** on anything we transmit.
- **Measurement discipline:** tune first; check the banner and the `0x34` tag after every load; a boot capture on every image; `git pull --rebase` before every load.
- **Recovery for a silent module, in order:** DIAG `restartmodule` + `0x34`; a module power-cycle; Restore (factory). **After any image that hung, held PTT or took a wild branch: load factory and key it once before the next bench image.**
- **Identity:** on air, bench IDs only (N0CALL, DMRTST-7, the bench DMR ID). **Never the owner's callsign or DMR ID** in a repo, log or capture name. Never print the SignalDeck web PIN.
- **The phone and the hotspot only with a pushed lease line.** Leases go into all three mailboxes (`radio_firmware/HANDOFF.md`, `docs/atomxl-status.md`, `docs/w6-dmr-status.md`) through the managing agent.
- **Git:**
  - commit only your own paths;
  - the shared phonedmrapp checkout often carries another agent's uncommitted edits, so never stash-and-drop them;
  - **never `git reset --hard`**;
  - never `git checkout -- <file>` on a file with someone's uncommitted work;
  - a bare `git pull --rebase` errors here ("Cannot rebase onto multiple branches"), so use `git fetch -q origin && git rebase -q --autostash origin/main`.
- **Code:** no GPL code into SignalDeck.

## 8. Driving Grok (what worked overnight)

- **The protocol is in HANDOFF:**
  - `STATUS: BENCH` = Grok's turn; it starts at once on a task it has not reported.
  - `REVIEW` = yours: review into `reviews.md`, then the next item under Current task **ending "Start now."**, then `STATUS: BENCH`, then push.
  - `STUCK` = answer with a concrete move.
  - `OWNER` = the owner's.
- **A review that names a next step is the go-ahead.** Be explicit: what to build, the proof rows, the report format.
- **Grok stalls.** Overnight it went idle five times (about 30–40 min after a push, each time without a report). Each time a dated nudge line, pushed as the first bold line under `STATUS:` with the explicit next step and "Start now.", got it going within minutes.
  - **Watch:** commits on origin/main, mtimes in `…\Temp\fw1718` and `fw30\`, `tools/fw-patch` build files, and Grok's watcher log `handoff_watch_9am30_<pid>.log` ("skip working" = busy). `grok.exe` in `tasklist` = alive.
  - **Rule of thumb:** 20+ min with no file activity and no commit → nudge; a second nudge that does nothing → tell the owner (Esc + "continue" in Grok's window).
- **Grok's watcher scripts** are `C:\Users\Joshua\.grok\handoff_watch_*.ps1`, each with a deadline; extending a watch = copying one with a new deadline and log name and telling Grok in HANDOFF to start it. **The owner's overnight watch ran until 09:00 2026-10-30**; ask the owner what cadence they want from here.
- **Keep your own Monitor** on origin/main for `STATUS: REVIEW/STUCK/OWNER` and commit subjects with "lease ended" or "HackRF wanted". Answer at once.
- **Make Grok prove, not describe.** Ask for the sha256 and tag, captures with numbers (carrier length, p99 deviation, decoded text or frames), and the end state (what is loaded, transmitting or not, heat).
- **Make Grok state its base.** Every image report should name its source image, every byte range it writes, and the space-map entry each range uses.

## 9. Lessons from FW45 → FW55 (so they aren't relearned)

1. **Fix one cause at a time, then run every row.** Partial proofs passed images that broke untested modes (FW55: no M17 row).
2. **Read `SRC` before reasoning about an image.** FW53–55 descended from FW46, so the FW50–52 gate fixes weren't in them.
3. **"Free" bytes in the tail aren't free.** Map reachability first; the guards don't see every path.
4. **`r1` into `0xE9C` is not an on/off flag.** The stock body 2 passes 1 too, and FW49's `r1`=0 hung via `0x12920`.
5. **One key-off per key.** Two `0xE9C` calls leak the semaphore at `0x390D4` (FW45), and the stock unkey must run while the TX bits are still set (FW20).
6. **Plain key/unkey is a first-class row.** F48L showed our 0x26 hook broke a plain FM key → unkey → key, which is why FW50 sends non-symbol traffic down the untouched stock path.
7. **A soak stop can be the bench harness, not the app.** 00:31: `pin()` read `web.xml` mid-rewrite; the crash buffer was empty. Retry reads, and never print the PIN.
8. **HackRF DMR replays are weak** (−105 dBm even with the amp on and drive 47). Use a real DMR transmitter for receive rows.
9. **M17 receive design and limits:** the held path plus the fixed 41-tap per-model equaliser. The receive-RAM stream route is closed on the Armor (it saturates above ±1 kHz). Details in `CLAUDE.md` §3 M17 and the `m17-deep-dive` memory note.

## 10. Handover checklist (first hour)

- [ ] Read §2 items 1–7.
- [ ] Push a line in HANDOFF: "Firmware agent (session name) now directs Grok; reviews and tasks from here." The managing agent stops writing reviews there.
- [ ] Arm a Monitor on HANDOFF (`STATUS:` changes, lease lines) and a 20–30 min heartbeat.
- [ ] Check Grok's state (it was told at 08:12 to work **offline**, because the HackRF is with the Atom XL agent for a longer block): the space map, the guard, FW56 built and unit-tested, the busy-flag reading planned.
- [ ] Ask `phonedmrapp-06` for the next HackRF slot when FW56 is ready for its proof.
- [ ] Agree the watch cadence with the owner.
