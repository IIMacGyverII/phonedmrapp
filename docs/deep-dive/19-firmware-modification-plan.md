# 19 — Firmware modification plan: finish the reverse engineering, load and verify a modified image, open the transmit audio path for digital modes

**Date:** 2026-10-23. **Owner:** IIMacGyverII. **Status:** plan; nothing in it is done unless marked ✅.

**Question.** We hold the Armor 26 Ultra's radio-module firmware (`DMR003.UV4T.V022`, 378,620 B, C-SKY V2, link base 0), a working way to push an image into the module, and a partial disassembly. How do we (1) finish understanding the image, (2) load a modified image reliably, know whether it persists, and tell the user which firmware is running, (3) test changes quickly and safely, and (4) change the transmit audio path so M17, POCSAG and other digital modes that the current firmware filters away can be transmitted on amateur allocations?

**Scope and rules (fixed, not up for re-planning).**

- Modifications target the **transmit audio processing** (high-pass, pre-emphasis, compression, deviation limiting) and operator-side settings (time-out timer). **The band limits (136–174 / 400–480 MHz), transmit power settings and any RF-regulatory protection stay untouched and are out of scope.** Transmitting is the operator's responsibility under their licence; every bench transmission stays on 467.625 MHz at low power into the HackRF, as for every previous bench.
- **RAM-load only** until persistence is understood. A power-cycle restores the factory image. No flash erase/write command is ever sent on a hunch. *(Superseded by §14, 2026-10-23: loads are written to flash by the module bootloader and persist; restore = load the factory image. The rule that stays: only the documented YModem update path is used, never a raw flash command.)*
- Nothing from the decompiled stock app or the firmware is copied into SignalDeck (public repo); SignalDeck gets a loader written from the protocol description in ch. 07 and a verifier, nothing more.
- Every firmware change is one named patch with the original bytes recorded, applied by a script, and verified by a measurable on-air result before it is kept.

---

## 1. Where we are (reviewed 2026-10-23)

What the earlier chapters established, with the source to read for detail:

| Area | State | Source |
|---|---|---|
| Image | 378,620 B (MD5 `44260353…9e268e0`), plaintext, no compiler banner, **C-SKY V2** (T-Head), link base **0**; 1,057 functions in Ghidra; objdump listing regenerable; **the last 1,788 B are zero padding** (room for a small added routine at the same file size) | `11` §9, §12, §13 |
| Protocol anchor | Checksum `+0x7D94`, reply builder `+0x90B0`, UART RX task `+0x7C48`, phone-protocol dispatcher `+0xAA3C` with `switch(cmd−0x22)` over 35 cases; digital unpack `+0x9310` (0x22), analog unpack `+0x9A2C` (0x23), readback 0x24/0x25 implemented and verified on the device | `11` §10–§16 |
| Second protocol family | `0x21` sub-commands (35 entries, jump table in RAM `0x030520D8`), MCU emits `68 21 …` event frames the app drops; unexplored | `11` §14.1 |
| Memory map | This image at 0; **~25 call targets at `0xFCFF6000–0xFD014690` are not in the file** (kernel uC/OS-III, memcpy-class helpers, the RF-register read-modify-write pair `0xFD01125C`/`0xFD011220`); SRAM at `0x0302xxxx–0x0305xxxx`. The jump tables live in RAM, filled by the external component | `11` §12–§13.3 |
| Receive path | Group list stored as a 32-entry table and matched on receive; all-call `bmaski 24`; 0x2B reply builder `+0xA808`. Closed from both sides | `11` §19–§20 |
| Loader | Stock app = YModem **sender** over `/dev/ttyS0` @57600 after a GPIO knock on `dmr009` (`pwd↓ 50 ms, ptt↓ 50 ms, pwd↑ 1000 ms, ptt↑`); nonstandard hello `"1"` → `C`; 128-B header `name\0size\0`; 1024-B STX blocks + CRC-16 CCITT; EOT; empty END block; 15 s/block, 6 retries. No signature, no image checksum, no size rejection | `07` §1–§2 |
| Persistence | Loaded image **reverts on power-cycle** (high confidence, five loads); the "RAM not flash" explanation is inferred, not proven; the only flash probe hit EACCES on the **wrong UART** (ttyS1) | `07` §3, `18` §6, `10` |
| TX audio path (measured, not in code yet) | Below ~250 Hz ≈ −60 dB, pre-emphasis, compression, deviation limited at ≈ ±4.5 kHz; receive path also loses everything below ~250 Hz. This is what breaks M17 (±2.4 kHz 4-FSK with sub-audio content) and POCSAG transmit | `docs/m17-deep-dive-2026-10-22.md`, `docs/pocsag-deep-dive-2026-10-22.md`, CLAUDE.md §3 |
| Transmit length | The `0x3B` handler stores the byte. There is no `min(tot, 30)`. The timer is 100 wakes per unit, about 1 s. FW19 writes 120 for a byte of 0 or above 120. Measured 2026-10-24: a low-power stream ran 45.12 s | CLAUDE.md §3 |
| Tooling | `csky-elfabiv2-objdump`, Ghidra 12.1.3 + C-SKY module, `scripts/fw1_ghidra_csky.ps1`, `radio_firmware/ghidra_scripts/FwCskySeed.java`/`FwCskyStats.java`, `scripts/fw1_ctcss_table.py` | `11` §12, memory `csky-disassemblers-installed` |
| Dead ends to not repeat | 14 ARM-Thumb patches at an unverified base (all addresses `0x0800xxxx` are void); `cmd_handler.c` / `firmware_decompiled.c` are wrong-architecture output; `PATCH14.bin` does nothing and is no longer shipped | `18` §4, `07` §5 |

**What is missing, in one sentence:** the external code region, the transmit set-up path (`0x26` and friends), the loader's end-of-transfer behaviour, and a loader/verifier of our own. (The RF IC identity and its register programming were settled on 2026-10-23: an **AT1846S**, see §10 and `11` §21.)

---

## 2. Plan overview

```
A. Finish understanding the image ──► D. Design the TX-path change
B. Load + verify + persistence ──────► C. Test harness ──► D (measure) ──► E. Ship (opt-in)
```

Phases A, B and C run in parallel; D needs A (where the filters are) and C (how to measure); E needs B (how it loads, how the user knows).

---

## 3. Phase A — finish the disassembly and understand the firmware

Goal: a named map of everything the transmit path touches, plus the memory map, written into the Ghidra project **and** exported to the repo so names survive.

### A1. Symbol persistence (first, small) — ✅ 2026-10-23
- Add `radio_firmware/ghidra_scripts/FwCskyExportSymbols.java` (post-script) that writes every user-named function/label to `radio_firmware/symbols.csv` (`offset,name,comment`), and `FwCskyImportSymbols.java` (pre-script) that re-applies them. Commit the CSV. Today the names live only in the gitignored project.
- Seed the CSV with everything already named in `11` §10–§20 (checksum, reply builder, RX task, dispatcher, the 35 case stubs, unpack functions, readback, 0x2B builder, CTCSS table, task creator).

### A2. Name every dispatcher case
- Walk the 35 inline cases `+0xAAC8…+0xABF2` and name each handler by the command byte it serves (cmd = case index + 0x22). The stock app's command table (ch. 01) gives the expected semantics; confirm each with its body length and reply length. Priority order for this plan: **0x26 LAUNCH (PTT), 0x2A MIC, 0x2E VOLUME, 0x3C SPK_EN, 0x3B TOT, 0x30 SQUELCH, 0x33 RELAY, 0x31 PWR-SAVE, 0x2F MONITOR**, then the rest.
- Device confirmation where cheap: SignalDeck's `/api` and DIAG already drive every command; the UART logger shows the reply. (Replaces the module-era `SEND_DEBUG_PACKET`.)

### A3. The 0x21 family and the "events"
- Decode the 35 sub-commands of `+0x8BE4` and the emitted `68 21 <sub> <01|FF>` frames. They may carry PTT/RX start-stop events, calibration or **debug/memory access**. A memory-read sub-command would be the key to A5. Capture the live `0x21` traffic with SignalDeck's UART log during key-up, channel change and the YModem knock.

### A4. The transmit path (the heart of the plan) — RF IC ✅ AT1846S, H1 confirmed for emphasis and voice high-pass (`11` §21); compression/limiter still open
Hypotheses, to be settled by reading, not guessing:
- **H1 — the filters are in the RF IC, set by registers.** The module's analog chain (pre-emphasis, ~300 Hz high-pass, 3 kHz low-pass, compander, deviation limiter) matches what single-chip FM transceivers (AT1846S/RDA1846-class) implement in hardware, each switchable by register bits. The external call pair `0xFD01125C`/`0xFD011220` with argument `68` (`11` §14.2) looks like a register read-modify-write; the "volume/squelch/mic" 1-byte commands go through it. **Test:** find the register initialisation tables in the image (runs of 16-bit register/value pairs, written in a loop through that pair), map them against the AT1846S register description, and look for the TX-filter/pre-emphasis/compander/deviation fields. If this holds, the change is a **table edit**, no code patch.
- **H2 — the filters are firmware DSP on the PCM before the modulator.** Then the transmit audio task is in this image (or partly external): look for FIR/IIR loops (multiply-accumulate on 16-bit samples, coefficient pools), the ±4.5 kHz clamp as a saturating compare, and the PCM source. Tracing from `0x26 LAUNCH` and from the audio-in interrupt will find it.
- **H3 — part of the chain is in the external region** (the kernel/ROM side). Then only the register path (H1) is editable from this image, and the plan narrows to what the registers allow.
- Identify the RF IC for real: (a) the `dmr009` kernel driver and device tree on the phone (`/sys/devices/platform/dmr009`, `/proc/device-tree`, `dmesg` at boot — read-only pulls), (b) the register init table's shape (AT1846S has a well-known init sequence), (c) vendor strings in the image, (d) if still unknown, a photo of the module is the last resort (the owner's call; no disassembly of the phone in this plan).
- Receive side gets the same treatment for free (the RX ~250 Hz cut is the same chip/table), which would also lift the M17 and POCSAG **receive** equalizer workaround.

### A5. The external region
- We cannot read `0xFCFF6000–0xFD014690` from the file. Options, in order of cost: a memory-read in the `0x21` family (A3); a bootloader-side read command on ttyS0 after the knock (B2, read-only); the YModem loader itself might echo or expose it. If none exists, the plan proceeds with H1/H2 inside the image only; what we need (register tables, the TX set-up) is most likely in the application image, since it is what the vendor updates.

### A6. The loader end-of-transfer and the boot path
- Find what runs after the YModem END block (in-image or external): where the received image is written (RAM at 0? copied from a staging buffer?), whether a flash-commit exists, and what the boot ROM does at power-up (copy flash→RAM? run flash in place?). The first words of the image (`0xC001112C 0x11EC6420`) are not an ARM vector table — decode them as C-SKY (reset vector / header) and compare with the knock behaviour.

**Deliverable A:** `symbols.csv`, an updated `11` chapter (§21+) with the dispatcher table completed, the RF IC named with evidence, the transmit chain described end to end, and a one-page memory map.

---

## 4. Phase B — loading, verification, persistence, and telling the user

### B1. A loader of our own in SignalDeck (opt-in, behind a warning) — ✅ ships before any patch is tested
SignalDeck owns the UART now, so the stock app's updater cannot be used while SignalDeck runs. Implement `FirmwareLoader` from the ch. 07 protocol description (not from the decompiled Java):
1. Stop everything (RX audio, modes, scanning), hold a lock.
2. GPIO knock on the profile's lines (Armor: `dmr009` `pwd`/`ptt` exactly as ch. 07 §2.1; the profile carries the node names and timings).
3. YModem send on the control port: hello `"1"` → wait `C` (timeout, retries), header block (name, size), 1024-B blocks with CRC-16 CCITT, ACK per block, EOT, END; 15 s per block, 6 retries, CAN aborts.
4. After END: wait for the boot banner, query `0x34`, compare with the **version string embedded in the image being loaded** (read from the file at `+0x38464`), re-apply the channel, restart audio.
5. Report every step in the history; keep a full log file for the device report.

Safety in the UI: Device → **Firmware (experimental)**: shows "Factory firmware DMR003.UV4T.V022" or "Modified firmware <name> loaded at <time>"; **Load…** picks a file from `Download/DMR/Firmware/`, refuses any file not exactly 378,620 B or without a `DMR003.UV4T.` version string, shows the warning (stays in the radio until restored — §14 — and your licence), requires a second confirmation; **Restore factory** = load the factory image + version check (a power-cycle does not restore, §14). Nothing loads automatically unless the user has turned on **Reload at start-up** for a named image, and that setting is shown on the intercom as a chip.

### B2. Version string as the ground truth
Every modified image carries its own version string, e.g. `DMR003.UV4T.V022m03` (same length rules as the factory one; the field is NUL-terminated inside a fixed slot, to be confirmed in A6). `0x34` then tells the app, the web page and the device report which firmware is running — after a load, after a module restart (the watchdog), after a phone reboot. Loss is detected the moment the version query answers with the factory string: history line, notification, and the Reload offer.

**This is also the first round-trip test (replaces FW3's CTCSS edit):** change only the version string, load, read `0x34`, power-cycle, read `0x34` again. Zero RF effect, legal, verifiable in seconds, and it tells us in one go whether the loader works from SignalDeck and whether the image persists.

### B3. Persistence research (read-only until understood)
1. Does the image survive a **module power-off** (the power GPIO, Exit SignalDeck) but not a phone reboot, or neither? Measure with B2; this separates "RAM image" from "flash image restored by the ROM at phone boot".
2. Inventory `/sys/devices/platform/dmr009/*` (names, current values, the `debug` node) and the kernel driver/device tree, read-only.
3. On ttyS0 after the knock, before sending the hello: listen for a banner or prompt from the loader; try only the hello and the documented YModem bytes. Any bootloader "Get"/"Read" style probing is limited to commands that cannot write, and only after A6 has shown what the loader understands.
4. Decide persistence from evidence: either (a) a commit command exists → document it, implement it **only** behind a separate "Make permanent" step with the factory image kept on the phone and a proven restore path; or (b) no commit → the product is "reload at start-up", which B1 already provides and which is adequate (the module starts in about a second).

### B4. The second phone (arrives 2026-10-24)
Its module may share the firmware family. Use it for the loader bring-up **only after** the Armor round-trip works, never as the first target; its profile is unverified.

---

## 5. Phase C — a good, simple test loop

### C1. Patch definition and build (host, no device) — ✅ 2026-10-23
`tools/fw-patch/` (phonedmrapp, public): `patches.toml` listing named patches — `offset`, `original` bytes, `replacement` bytes, `why`, `measured_by`; `build.py` applies a chosen set to `ORIGINAL.bin`, verifies every `original` matches before writing, sets the version string marker, writes `DMR003.UV4T.V022m<N>.bin` plus a `.sha256`; `check.py` diffs two images and prints the named patches. A host unit test asserts every patch's `original` bytes are present in the factory image (a patch that no longer matches fails the build).

### C2. Load and measure (device)
- `bench/fwtest.sh <image> <test>`: push the image, DIAG `fwload`, wait for `0x34` = expected marker, run `<test>`, DIAG `fwrestore` (module power-cycle), wait for `0x34` = factory, print PASS/FAIL. Fails closed: if the marker never appears, the test does not run.
- Tests reuse the existing bench tooling: `tools/m17-research/txan.py` (TX frequency response, deviation, M17 frame decode from a HackRF capture), the POCSAG analysers in `tools/pocsag-research/`, `scratchpad/txsteps.sh`-style tone sweeps, and SignalDeck's DIAG `testtone`/`txwav` on **467.625 MHz low power** only.
- Standard measurements, recorded per image in `radio_firmware/results.md`: (1) TX audio response 50 Hz–3.5 kHz at −20 dBFS (10 tones), (2) deviation vs input level (limiter knee), (3) M17 frames decoded /90 with the plain research decoder (no equalizer), (4) POCSAG 512/1200 decoded by `multimon-ng` and our decoder, (5) a voice sample for ear-check (the mode must not make plain FM voice worse), (6) the factory image re-measured after restore (proves the restore).

### C3. Keep it boring
- One patch per image, one image per bench run, results before the next patch. The CTCSS table edit (FW3) stays available as a second sanity check of the loader on the receive side.
- `radio_firmware/README.md` gets the procedure; stale paths in it are fixed (`/sdcard/DMR/DMRDEBUG.bin` only).

---

## 6. Phase D — the transmit-path change for digital modes

Target behaviour: on an analog channel, in a "digital audio" transmit mode that SignalDeck selects explicitly, the transmit chain is **flat from ~20 Hz to ~3.5 kHz, no pre-emphasis, no compander, no sub-audio cut, deviation proportional to input up to the mode's design deviation (M17 ±2.4 kHz, POCSAG ±4.5 kHz), within the channel's existing bandwidth**. Plain FM voice keeps the factory processing.

Design, depending on A4's outcome:
- **If H1 (registers):** the change is a register table variant selected at run time. Preferred implementation: do **not** patch the table in place; instead find the handler that applies the table (or the 1-byte register command path) and add a new command or a value of an existing enum command (for example a `0x3C SPK_EN`-style byte, or an unused value of `0x2A MIC`) that SignalDeck sends before keying a digital-mode transmission and clears after. A patch that only adds a case is small, reversible and leaves voice untouched; new code goes into the 1,788-byte zero tail of the image, so the file size and every existing offset stay the same. If the dispatcher's jump table lives in RAM (it does, `11` §14.2), hooking a case means patching the *handler body* of an existing command to branch on an extra value — the plan is to pick one with a spare byte range.
- **If H2 (DSP in firmware):** bypass the filter stages behind the same run-time flag; the limiter is kept as a safety clamp at the channel's maximum deviation.
- **TOT:** measured 2026-10-24 (FW19). The `0x3B` handler stores the body byte and, when the byte is 0, clears the enable flag. There is no `min(tot, 30)`. The radio task counts 100 wakes per stored unit, and a unit is one second. The 2026-10-16 "30 s" keys were that timer plus the phone app's own countdown. The FW19 stub writes 120 when the byte is 0 or above 120, then calls the stock handler. SignalDeck's voice watchdog stays 28 s. **Loader (Phase E, 2026-10-25): SignalDeck's own YModem sender (`fw/YModemSender.java`, SignalDeck `4fc1989d`) passed five proof loads including an interrupted-transfer recovery; the page per `radio_firmware/plan-loader-safety.md` passed its own pass list the same day (five page loads, two refusals, the wrong-tag restore, help); the signed catalogue (AndroidRadio_Firmware_Project) and the owner's unlisted-images switch are the open sub-steps.** Review (2026-10-24): a byte of 0 turns the stock timer off (the OEM app and SignalDeck's handshake both send 0; the firmware's own start-up value is 120), so SignalDeck is to send 120; the 30 s of 2026-10-16 was the apps' countdowns; op 7's `drop_ptt` leaves the TX state flagged and the timer fired `SEND_STOP` at key-on + 120 s (FW20). Bench 2026-10-25: the module ended a 130 s high-power stream at 120.33 s (status 4, no status 6); a 40 s plain FM tone was not ended by the module; 120 s high power raised `mtktsAP` 11.3 °C, back in ~17 min; after op 7 without an unkey the module is deaf until the timer fires (FW20's receive criterion). FW20, loaded 2026-10-25: eight more TX-RAM halves, then `drop_ptt`, then the stock unkey at `+0xE9C` while the TX bits are still set, then those bits and the count are cleared. 1125 of 1125 with the end bit and the EOT, no timer status inside 130 s, and a following 70.35 s stream was not cut. Clearing the bits before that unkey left the receiver at raw 6 until a channel write; the loaded image does the unkey first (`results.md`).
- **Receive:** the same flag can lift the RX ~250 Hz cut for M17/POCSAG receive; the calibrated equalizer then becomes optional.

Acceptance (per C2): flat response within ±2 dB, limiter at the set deviation ±10 %, ≥ 85/90 M17 frames decoded by the plain decoder across three transmissions, POCSAG 100 % at 512 and 1200 bd, voice unchanged with the flag off, factory image unchanged after restore.

**Status 2026-10-24:** the M17 part is met by the TX-RAM route (T1 in `radio_firmware/HANDOFF.md`), not by a change to the audio chain: symbols streamed over UART command `0x40` into a ring, RRC shaped in the module, played through the HR-C7000 DMR modulator from TX RAM; R4t decoded 90/90 frames at Golay error 0 on each of three transmissions with our decoder, steady p99 2.79–2.90 kHz, boot silent (`radio_firmware/results.md`, `reviews.md`). The flat-response and limiter items do not apply to this route (the audio chain is bypassed, the phone-side analog cut cannot be opened, §19). Open: an independent decoder (`plan-independent-m17-check.md`), POCSAG through the same engine. The time-out ceiling is FW19 (2026-10-24). **Receive (R-C, RC40, 2026-10-24): the C7000 FM receive RAM holds a flat baseband once the same three writes are made on receive (`WORK_MODE` `0x80`, `FM_BANDWIDTH` bits 4+6 clear, AT1846S `0x58` = `0xBCFD`); the §6 'same flag lifts the RX cut' sentence is proven. R-D (RD10): the phone's own receive audio is flat (50 Hz–3.8 kHz within ±1.8 dB) with the single AT1846S write `0x58` = `0xBCFD` held, cleared by any channel write; so the first receive design is that write plus the existing phone audio path (R-E, 2026-10-24: the held path is linear; a fixed ±20-symbol equaliser decodes the R-E clips at 0 symbol errors, LSF CRC 13/13, Golay 0 25/25; receive design final after R-F: on 18 independent transmissions the fixed per-model taps applied before acquisition give LSF CRC on every clip and 98–100 % payload-exact frames at −87/−93 dBm, ~95 % at −99 dBm; the 500 Hz dip is the ES8311, the receive RAM is flat; SignalDeck has the hold, the Armor taps and, since `943e4ec2` (R-H), a live receiver that lists one transmission once with its callsigns; long calls, buffer-edge frames and sync coasting are R-I), the RAM stream second (230400 baud reachable at +0.160 %; RAM plain decode at ~10 % raw symbol errors, under diagnosis).**

---

## 7. Phase E — shipping it (opt-in only)

- SignalDeck: Device → Firmware (experimental) as in B1; the modified image is a **separate download** from the SignalDeck releases page with its own SHA-256 and release note listing every patch; never bundled in the APK, never auto-loaded by default. Help topic "Modified firmware" explains what changes, that it is RAM-only (or how persistence works, per B3), the licence responsibility, and how to restore.
- M17 TX and POCSAG TX in SignalDeck are enabled only when `0x34` reports a firmware marker that advertises the digital-audio mode; otherwise the buttons say what is missing.
- The phonedmrapp repo keeps the patch definitions, the build tool and the measurements (public, documented); the images are built from the user's own factory copy — the factory image is already in this repo as the OEM asset, so this is a formality, but the build-from-factory path keeps the provenance clean.

---

## 8. Backlog (FW-series continued; FW0–FW7 are in ch. 18 §9)

| # | Item | Effort | Device | Depends |
|---|---|---|---|---|
| **FW8** ✅ | Symbol export/import scripts + `symbols.csv` seeded from `11` §10–§20 (A1) | S | no | — |
| **FW9** | Name the 35 dispatcher cases; TX-side commands first (A2) | M | some | FW8 |
| **FW10** | 0x21 family decoded; live capture of its frames (A3) | M | yes | FW8 |
| **FW11** ◐ | RF IC identified (✅ AT1846S); register writes mapped (✅); transmit chain described (compression/limiter open) (A4) | L | some | FW9 |
| **FW12** | Loader end-of-transfer + boot path read; the first image words decoded (A6) | M | no | FW8 |
| **FW13** | SignalDeck `FirmwareLoader` + Device → Firmware page + version-marker verification + reload-at-start-up (B1, B2) | L | yes | — |
| **FW14** ✅ | Version-string round trip (load, verify, power-cycle, verify) — the first proof (B2). Done 2026-10-23 through the stock updater (§14): load proven, persists across power-cycle and reboot | S | yes | — |
| **FW15** ✅ | Persistence research (B3): answered by FW14 + §13, loads persist in SPI flash, restore = factory load | M | yes | FW14 |
| **FW16** ✅ | `tools/fw-patch` build/check + host test (C1) | S | no | — |
| **FW17** | `bench/fwtest.sh` + the standard TX measurements, factory baseline recorded (C2) | M | yes | FW13, FW16 |
| **FW18** ◐ | Digital-audio transmit mode patch (D) measured to acceptance — **M17 met 2026-10-24 via the TX-RAM symbol engine (R4t, own decoder)**; POCSAG and the independent decoder open | L | yes | FW11, FW17 |
| **FW19** ✅ | TOT ceiling patch (D). Measured 2026-10-24: no `min(tot, 30)`; stub ceiling 120 s; a 45.12 s low-power stream self-unkeys. High-power 45 s and 120 s keys not run (battery still +0.5 °C after 12 min) | S | yes | FW9, FW17 |
| **FW20** ✅ | The op 7 drop: eight TX RAM halves after the drain, `drop_ptt`, the stock unkey while the TX bits are still set, then the time-out state cleared. Measured 2026-10-25: 1125/1125 with the EOT, no stale timer, receiver back, a second stream not cut. (The receive-side flat mode this row first held is met by op 6 variant 3, RD10.) | S | yes | FW19 |
| **FW21** ✅ | Generic waveform engines, ops 8–11 (item 3). Measured 2026-10-25: renders exact; POCSAG 1200, MCW, RTTY 45.45 and FT8 decoded; op 3 then 90/90 M17; 1125/1125 unchanged. (Phase E's shipping and gating need no image of their own; the gating exists.) | M | yes | FW20 |
| **FW22** ✅ | `on_key` arms the TX RAM path for a non-empty tone queue (gated on the tone mode word); opcode 12 flash read. Measured 2026-10-25: empty-ring 700 Hz key played; 378,620 bytes read back equal to the file; 1125/1125 unchanged | S | yes | FW21 |

---

## Item 3 — generic waveform opcode space (design, 2026-10-25)

Not built. Command `0x40` already uses body byte 0 as the opcode. The symbol stub rejects opcode 0 with `sr=1` and does not key. The assigned opcodes, read from `c7000_cmd40_sym.S`, are:

| Opcode | What it does | Keys? |
|---|---|---|
| 0 | Rejected, `sr=1` | no |
| 1 | Append packed symbols, clear the end flag | no |
| 2 | Ring status | no |
| 3 | Reset the ring | no |
| 4 | Render at most 240 samples, no PTT | no |
| 5 | Receive-RAM capture | no |
| 6 | Hold or release the voice filter (variants 3 and 4) | no |
| 7 | Append packed symbols and arm the end | no |
| 8 and above | Rejected, `sr=1` | no |

Opcodes 1 and 7 pack four 2-bit symbols per byte. The wake's pulse, the four levels, and the samples per symbol are the M17 ones. FW20's drop (eight more halves, `drop_ptt`, the stock unkey, then the timer clear) stays the only end. Nothing in this design changes ops 0–7, `0x3D`, band limits, or power.

Opcodes 8–11 are the generic engines. Each one answers `sr=1` and does not touch PTT when the body is the wrong length. None of them keys, and none of them runs at boot.

**Op 8, waveform.** The TX RAM runs at 8 kHz. The M17 wake already advances 3/5 of a symbol per sample, so the clock is that rational advance, not an integer samples per symbol. The body is: shaping (0 = hold the current symbol, no table; 1 = the polyphase table), number of levels (2 or 4), then a uint16 numerator and a uint16 denominator, then that many little-endian int16 amplitudes in TX-RAM counts, clamped to the existing sample cap. The accumulator adds the numerator every sample and consumes one symbol, subtracting the denominator, whenever the count reaches the denominator. M17 is 3/5 (4800 baud). POCSAG 2400 is 3/10, 1200 is 3/20, and 512 is 8/125. A binary fraction is not used. Packing stays four 2-bit values per byte, so a 2-level mode uses symbol values 0 and 1 only. Shaping 0 is the POCSAG path.

**Op 9, polyphase pulse.** The body is P phases (1–16) and T taps (odd, 1–15), then P×T little-endian int16 taps. The phase is floor(fraction × P), applied to the last T symbols, which is the M17 path with P = 5 and T = 9. An even T, or a P or T outside that range, answers `sr=1` and changes nothing. Shaping 0 ignores the table.

**Op 10, tones, more following. Op 11, tones, then the end.** Frequency is a uint16 in eighths of a hertz (0–8191 Hz; FT8's 6.25 Hz is 50). A phase accumulator runs across pairs, so the phase is continuous. A 0 Hz pair holds the phase and writes zero. Every op 10/11 body starts with an int16 amplitude in the same TX-RAM counts (R3a5: 0.41 Hz of deviation per count at the flat top). Duration stays milliseconds (1–10000); RTTY's 22.0 ms and FT8's 160 ms fit. The module holds at least 64 pairs. A body that does not fit answers `sr=1` and queues nothing. Op 2 with a following byte of 1 returns the pairs still queued, in the field the host already reads as the ring fill; op 2 with no extra byte is unchanged. The host paces on that number. Op 11 arms FW20's end when the queue drains, not when the body arrives.

**Op 3 also restores the M17 waveform.** Advance 3/5, the four M17 levels, and an empty tone queue with the phase cleared. The M17 path keeps its own fixed five-phase, nine-tap pulse. Op 9 and the shaping flag apply only while a generic waveform (op 8) or a tone queue (op 10/11) is in use. Op 3 clears that flag, so the next M17 stream is the built-in pulse whether or not an op 9 was ever sent. A POCSAG or tone transmission cannot leak into the next M17 stream. The host still keys with `0x26` and still sends the unkey after the first status byte 4.

Small state stays at `0x4B014` through `0x4B074` (accumulator, advance, levels, amplitude, tone phase, queue counters). The factory image names `0x4B078` and does not name `0x4B014`–`0x4B074`. The polyphase table and the 64-pair queue sit at `0x4B080` through `0x4B360`: the factory image names `0x4B078` and next `0x4B398`, and nothing between. The words already used below that are `0x4B000` (saved work mode), `0x4B004` (saved bandwidth), `0x4B008` (hold flag), `0x4B00C` (end flag), and `0x4B010` (FW20 countdown). The build checks every byte of both spans is still unnamed before it writes.

The 2050-byte symbol stub is full: it ends at file `+0x5B6FE`, and the time-out stub starts at `+0x5B700`. Ops 8–11 are not added inside it. The unknown-opcode reply (the block that answers `sr=1`) gains one branch: opcode 8 or above goes to an extension placed after the FW20 gate, which ends at file `+0x5B794`. The free zeros run from there to `+0x5C6FC`. An opcode the extension does not implement still answers `sr=1`.

What each mode costs the host, and nothing more: POCSAG is op 8 (two levels, its advance, shaping 0) and then ops 1 and 7. A shaped pager adds op 9. CW, RTTY, and FT8 are ops 10 and 11. M17 keeps sending ops 1, 3, and 7 and never sends 8–11.

Corrected 2026-10-25 from the review of this design (`reviews.md`). The image is FW21, sha256 `f726056aa3e62db4399d45ee6cf5df4e29756083761c1651ce734d4c08d477ed`, loaded 2026-10-25. The sine table is addressed at `0x0301A000` plus its file offset, and the phase remainder is zero-extended. Renders match: hold at 3/20, a 1 kHz sine 32 of 32, a 700 Hz sine 64 of 64, and op 3 then zeros. On the air, low power, 467.625 MHz (`results.md`): POCSAG 1200 `HI` at body p99 4061 Hz (±7600 counts) and 4138 Hz (±8400; the air compressed and did not reach 4.5 kHz or 5 kHz); MCW 700 Hz at 20 wpm decoded `HI`; op 3 then 90 of 90 M17; the 1125-frame op 7 stream 1125 of 1125 with the end bit and the EOT. A tone key has to leave one symbol in the ring, because `on_key` takes the TX-RAM path only then. RTTY 45.45 baud at a 170 Hz shift decoded `HI` with SignalDeck's RTTY decoder, and one FT8 message decoded `CQ N0CALL` with SignalDeck's FT8 decoder. FW22 (sha256 `38f900a0df169c0101f9e6183fe8ec8d2e9cdca74169f034f5571b04aa988d6a`) arms a tone key with an empty ring and reads the image back through opcode 12; the read matched all 378620 bytes and the 1125-frame stream was unchanged. The ±5 kHz stop stays in force.

## 9. First steps (this week)

1. **FW8** (an afternoon, no device): symbols into the repo, so nothing found is lost again.
2. **FW13 + FW14** (the loader and the version-string round trip): the single most valuable result, because it answers "can we load from SignalDeck" and "does it persist" at the same time with no RF risk.
3. **FW11** in parallel on the host: find the register tables; if H1 holds, FW18 becomes a table edit and the whole plan shortens.
4. **FW16/FW17** so that the first real patch is measured, not eyeballed.

Things not to do: no flash writes; no edits to band limits or power; no patch built on the old `0x0800xxxx` addresses; no bench transmission off 467.625 MHz low power; no loader test during an ISS pass.

---

## 10. Progress log

**2026-10-28 — The five extra hooks are not why FW3E's key is unlistened.** Restoring setend, the UART pend, or the promiscuous sites still left a 3 s key with status 3 and 4 and no relay listing. Details in `results.md`.

**2026-10-28 — FW3F gates the FM setup on `0x4B378` and the bench-ID key is still unlistened.** A plain key does not set that word. Status 3 and 4, no relay listing. Details in `results.md`.

**2026-10-28 — Skipping the FM setup makes the bench-ID key heard.** FW3G returns at `0x5B58E`. The relay listed the call. A bss word no stock literal names, `0x4BE64`, is the candidate flag. Details in `results.md`.

**2026-10-28 — FW3H's flag at `0x4BE64` did not keep the bench-ID key heard.** Three keys had status 3 and 4 and no relay listing. Details in `results.md`.

**2026-10-28 — Forcing the skip path makes the key heard again, with no host `0x40`.** FW3I lost the call at 2.2 s, as FW3G did. Details in `results.md`.

**2026-10-28 — FW3H's gate reads the flag word, and FW3J is loaded.** The two stores of that flag are nops. The key was not sent: the hotspot does not answer. Details in `results.md`.

**2026-10-28 — FW3E boots and decodes DMR.** The FM setup runs only when the ring is armed. A 3 s key had status 3 and 4 and was not listed by the relay. Details in `results.md`.

**2026-10-28 — FW3D boots and decodes DMR.** The 3 s key had status 3 and 4 and was not listed by the relay. The key wrapper differs from F30F at `0x5B58E` only. Details in `results.md`.

**2026-10-28 — RAM literals alone hang after the banner; the op 16/17 refusal alone boots.** `B3G1` came back as FW29. `B3G2` stayed up as itself. A key on `B3G2` got status 3 and 4, and the relay listed no call. Details in `results.md`.

**2026-10-28 — FW3B (`731641cd…`) prints the boot banner and does not stay up.** The packed block ends at `0x4F39C`. After the load the module was silent, and the power cycle came back as FW29. Details in `results.md`.

**2026-10-28 — FW29 boots; FW3A (`8653c32c…`) does not.** The control load reported `DMR003.FW29.V022`. FW3A transferred 370/370 and was silent for 9 s, then the module came back as FW29. No key. Details in `results.md`.

**2026-10-28 — FW30 (`58ece263…`) transfers and the module stays on F30F.** Two YModem loads, 370/370 and the closing packet acked, tag read back `DMR003.F30F.V022`. The phone's copy of the file matches the image. No key. Details in `results.md`.

**2026-10-28 — FW30 has nowhere to put the F30F stub.** FW29's free run at `0x5B718` is 8 bytes; the stub is 104. Details in `results.md`.

**2026-10-28 — `F30F` hotspot bench.** DMR both ways passed. A CAN 7 stream was 1127 frames and closed on timeout. Receive stayed at RMS 1.3 and the return calls were not decoded. The runner stream capture was p99 8186 Hz. Details in `results.md`.

**2026-10-28 — `F30F` decodes the DMR recording with `0x18B5C` left stock.** Status 1 three times. The close guard has to start after the prologue saves `r15`. Details in `results.md`.

**2026-10-28 — byte 0 of `0x34808` is 1 after an analog channel write and 0 after a digital one.** The refill goes on `0x18B68`. Details in `results.md`.

**2026-10-28 — a no-stack clear path at `0x18B5C` is still deaf.** F19B2 (`7df6e32f…`) at HackRF level 20: status 1 = 0. Factory decoded the same recording before and after. The site stays stock. Details in `results.md`.

**2026-10-28 — the DMR receive break is the hook at `0x18B5C`.** Tag, stub bytes, the `0x40` slot, `0xAB18` and `0x18B68` all decode the recording. Details in `results.md`.

**2026-10-28 — F19M and F19R stay silent on a recording the factory image decodes.** Same file, HackRF level 20. F19R is still silent at 47. Details in `results.md`.

**2026-10-28 — F19M's RAM is above the stock heap.** The first gap was under an interrupt stack at `0x4EAB0`. The block is now `0x4F2C0`–`0x4F6F4`. Details in `results.md`.

**2026-10-28 — the FW19 stub's RAM is in zeroed bss, and the symbol flag is set only when a ring's end is below its start.** Stock DMR code does not name the flag. Details in `results.md`.

**2026-10-28 — the three FW19 pass-throughs do not change what the stock callee reads while the symbol flag is clear.** `0x3D20` is not even called. Details in `results.md`.

**2026-10-28 — command `0x40` is the dispatch slot at `0x382B8`.** Stock it is the shared empty pop at `0xAA54`. FW19 points it at the stub. DMR receive does not go through that slot. Details in `results.md`.

**2026-10-28 — stock `0x3D20` is `jmp r15`.** Skipping it does not change a digital channel. MMDVMHost was not restarted: the bench SSH key was refused. Details in `results.md`.

**2026-10-28 — the receive bisect had no carrier, including on the factory image.** F19T and F19R2 stayed at −107 dBm with no status 1. A factory reload did the same while the hotspot reported 62 bursts. Details in `results.md`.

**2026-10-28 — FW19's four `0x26` launch sites are not the whole DMR break.** Putting them back (`DMR003.F19R.V022`) left channel 49 silent: the hotspot sent 62 bursts, the signal stayed −108 dBm, and a 3 s key was not heard. Details in `results.md`.

**2026-10-28 — image 6 clears bit 3 of `0x38908` and the mute still wins.** `0x30` is `70A6` by 0.37 s on three keys, `0x58` ends at `BCF5`, and the level stays 1.3. The one-shot skip does not fit in the save stub. Details in `results.md`.

**2026-10-28 — image 5 calls `0x7A30` after `cmd23`'s delay and the mute still wins.** `0x30` is `7026` at status 4 and `70A6` by 0.33 s, three times. The level stays 1.3. `0x58` ends at the saved `BCFD`, so the stub did finish. No 1125-frame stream. Details in `results.md`.

**2026-10-28 — the stored channel apply is `0x7A30`.** It ends in `at1846_tune` and, on a wide channel, writes `0x30` = `0x7026`. The 176-byte block is `0x38B5C`. The `0x25` record is `0x38C70`. Image 5 waits with `cmd23`'s own delay, then calls `0x7A30`. Details in `results.md`.

**2026-10-28 — opcode 14 did not see the close-path state.** `0x30` still went `7026` / `70A6` / `7026`. Nothing in `0x18000820` or `0x18006E00` changed with it. `0x38908` is outside that window. No image 5. Details in `results.md`.

**2026-10-28 — the `0x70A6` write is the receive-close path.** `0x037F4` calls the selector at `0x03190`. A nonzero argument while `0x38908` bit 3 is set stores `0x70A6` on a wide channel. The periodic task at `0x0399C` is what calls it. The `0x58` bit-3 clear is `0x032E4` and has no branch to it. Details in `results.md`.

**2026-10-27 (23:53) — FW30 image 4 still mutes when the host sends no `0x26` off.** The first `0x30` read after status 4 is `7026`. By 0.33 s it is `70A6`, and `0x58` is `BCF5`. The level falls to about 1. A control key with the host unkey does the same. Details in `results.md`.

**2026-10-27 (23:39) — FW30 image 4 saves the four registers and the receive audio stays muted.** The save is at the start of `on_key` and the restore is the last step of the drop. After three 75-frame keys, `0x41` and `0x59` match the pre-key values and `0x30`/`0x58` stay at the muted values `70A6`/`BCF5`. The level is 1.3. `0x30` is already `70A6` when the host logs the unkey. The 1125-frame stream reached the hotspot (1118 frames, end bit). Details in `results.md`.

**2026-10-27 (22:59) — FW30 image 3c reads the AT1846S and names four restore rows.** Opcode 18 calls IRAM `0x2B25C`. The image banners. A 75-frame symbol key drops the receive level from 5607 to 1.4, and the next channel write brings it back to 5583. The rows that write puts back are `0x30` (`7026`/`70A6`/`7026`), `0x41`, `0x58` and `0x59`. Image 4 is not built. Details in `results.md`.

**2026-10-27 (22:25) — FW30 image 3b boots; opcode 18 does not return.** The read stub is in retired opcode 17, not the data-table tail. The image banners and channel 56 reads level 5651. Three register reads produce no reply, and opcode 6 stays silent until a module restart. Details in `results.md`.

**2026-10-27 (21:39) — FW30 image 3 does not boot.** The read opcode was placed in the 128-byte table tail at `0x35F64`. The transfer completed and the module never bannered or answered `0x34`. Opcode 18 was sent and got no reply. Factory is restored and answers `DMR003.UV4T.V022`. Details in `results.md`.

**2026-10-27 (21:05) — FW30 image 2, quiet retest.** With the phone and the hotspot otherwise idle, the 1125-frame stream reaches the relay (1119 frames, 44.76 s, end bit) and the receive level is 1.3 at 3 s. Three shorter keys fall to 1.3 by about 4 s. Storing `WORK_MODE` `0x6E` does not hold the audio. Details in `results.md`.

**2026-10-27 (20:34) — FW30 does not restore receive.** The `0x30` edge alone leaves the APRS level at 1.3 after a symbol key. Storing `WORK_MODE` `0x6E` from the eight-byte hole did not hold the level across three keys (5614, then 902, then a clip at 2.9). The 1125-frame stream on the first image reached the hotspot relay through the end bit (1118 frames, 44.72 s). Details in `results.md`.

**2026-10-27 (15:33) — FW29.** The three stale callers no longer enter the restored exit. `0x5B2BE` is FW26's value compare again, and `0x5C564` and `0x5BCAE` branch to the sr=1 tail. Runner `all` passes, one page is Hamming 0, and `[6,6,1]` answers `sr=1`. Op 17 start and stop answer, and no half was logged at 57600. The phone is back on FW26. Details in `results.md`.

**2026-10-27 (14:56) — FW28.** Variant 6's bytes at `0x5B81A`–`0x5B875` are FW26's again, and the op 13 redirect at `0x5B816` stays. A branch into that range is reported on FW27 and not on FW28. Runner `all` passes, and one POCSAG page is Hamming 0. Op 17 start did not answer at 57600. Details in `results.md`.

**2026-10-27 (14:03) — POCSAG part B on FW26.** The browser page and the browser M17 text both keyed on `DMR003.FW26.V022`. The page is RIC 1001, "FW26 PAGE", Hamming 0 on the flat deviation. The M17 text decodes from the start of its 0.45 s carrier. Op 8 answers on this image. Details in `results.md`.

**2026-10-27 (13:31) — POCSAG page send did not key.** Phone-path and browser sends both stop after the waveform command. Op 3 is answered; op 8 is sent eight times with no reply. The symbol stream on the same FW27 image is 1125/1125, so the factory-key rule was not applied. An M17 text was on the air for 0.45 s and was not decoded. Details in `results.md`.

**2026-10-27 (13:12) — POCSAG web pager.** Chrome opened the Pager page. A HackRF page was in the browser list after 1 s. The M17 text box listed its text. Monitor and the radio-module card answered. The browser's own page send was filed and was not heard by the HackRF (no page-key line; the channel is high power and narrow, so the send hops). Details in `results.md`.

**2026-10-27 (12:16) — POCSAG padding run.** The 17-bit pad fits τ = 7.6 ms. Restore uses 7.5 ms and the preamble mean. Text ends at NUL or EOT, and a 512 baud run holds its bit across a quarter of the eye. Host clips and the air check are payload-exact: three 512 baud texts and one each at 1200 and 2400, corrected 0. Part A closes. Details in `results.md`.

**2026-10-27 (11:57) — POCSAG tail on the air.** The padded file is 7,375,000 samples; the transfer sends 7,602,176. The new clip has a hole at bits 806–822 and full level again from bit 824. Texts are still short. Decoder unchanged. Details in `results.md`.

**2026-10-27 (11:30) — POCSAG bit clock.** RESTORE B clip, before the tracker: 0, 0, 2, 2, 7, 10, 13 raw errors per word. After: 0, 0, 0, 0, 0, 0, 8. The last word still fails its check. Not aired. Details in `results.md`.

**2026-10-27 (11:15) — POCSAG sync cadence and leaky restore.** Later batches in one transmission are read again (`three_rics_in_one_transmission` passes). A 100 ms leak empties the ALPHA clip; 250 ms does not recover the full RESTORE B text. Padded 512 baud on the air was 1 of 3 exact. Details in `results.md`.

**2026-10-27 (10:58) — POCSAG false pages and the tail.** A page needs a preamble, and an address or message word repaired by two bits is not used. Sixty seconds of noise opens no page. Lengths 1–40 round-trip. Padded 512 baud was 1 of 3 exact on the air. After a measured 0.8 s retune settle the monitor dwell is 2.5 s, and both texts were exact. Details in `results.md`.

**2026-10-27 (10:31) — POCSAG 512 baud droop.** A 1.6 ms high-pass inverse, used only when the preamble measures 512 baud. The clip then decodes as RIC 1001. 1200 and 2400 stay on the held-path taps and were payload-exact once each on the air. Two of the 512 baud texts were exact and two lost the last character. Details in `results.md`.

**2026-10-27 (09:26) — POCSAG 512 threshold.** One threshold per batch. The generator file at 8 kHz decodes as RIC 1001. On the air, 512 baud still returned RIC 123617. Details in `results.md`.

**2026-10-27 (09:00) — POCSAG parity and 512.** Even parity is checked after the BCH repair. 512 baud on the held path still returned RIC 123617. A signed page filed under the callsign and a bare page under the RIC. Stock receive is refused. Details in `results.md`.

**2026-10-27 (08:31) — POCSAG receive.** Held path, 2.5 kHz: 1200 and 2400 baud 3/3 payload-exact. 512 baud listed one text with the wrong RIC. Hold off changed the RIC of a 1200 baud page. Details in `results.md`.

**2026-10-26 (23:24) — Two-frame M17 SMS.** A 26-byte text, three times each way, on `7126749f…b779`: counters 0 then 5, CRC good, and the phone listed the HackRF copies 3/3. A failed packet CRC writes "M17: frames lost" and does not list the text. Details in `results.md`.

**2026-10-26 (23:10) — M17 SMS, app only.** On `7126749f…b779`, after a factory key (channel 4, status body 03 then 04) and a runner `stream` of 1125/1125 (p99 2896 Hz), the phone received 9/9 SMS from the HackRF and its own three texts decoded with the CRC good. Details in `results.md`.

**2026-10-26 (21:25) — The symbol stream is back.** Reloading `7126749f…b779` after the factory image gave runner `stream` 1125/1125, carrier 45.41 s, p99 2862 Hz, clip 0. The 15 s power-off, the digital tune and the FW26 load had not done that. The log's tail is `sym done bytes=54144`, status 4, `0x26` off `sr=0`, `sym unkey`.

**2026-10-26 (21:10) — The symbol stream still has no status 3.** A 15 s `dmr009` power-off, a digital tune through channel 4, and FW26 `71949d24…a34e` each left the runner `stream` with no carrier. The factory image's own PTT on channel 4 did radiate: status 3, then 4, HackRF ratio 3.38. `HANDOFF.md` is `STATUS: STUCK`.

**2026-10-26 (20:50) — The symbol stream is silent on variant 6 as well.** Loaded `7126749f…b779` (boot peak 0.054 dB). Runner `stream` had no carrier (5.4 dB above the quietest second). A channel-2 write and `restartmodule` each left the next stream the same. A tone on that image passed, carrier 10.85 s, p99 2705 Hz. `HANDOFF.md` is `STATUS: STUCK`.

**2026-10-26 (20:34) — Variant 7 writes AT1846S `0x44` bits 7:4.** Wi-Fi ADB sticks at `192.168.1.125:5555` (`persist.adb.tcp.port` `5555`) after the panel is opened; USB is unplugged. The FM tune constants `0x42` and `0x43` are not a level. DAC gain is the field, bits 11:8 held at `0xA`. Image `ab726955…9a52` branched to XIP+`0x2B220` and hung; `restartmodule` recovered the tag. Loaded image `f8298581…3ef8` calls IRAM `0x2B220`. `0x81` matches the stock deviation curve and `0x41` doubles it, ceiling included, so 2.4 kHz stays at about 0.46 of the straight line. Channel 56 drops 19.6 dB and 25.1 dB and keeps the 9.5 dB dip at 500 Hz. No 30-frame file. The route is closed on this phone. Runner: boot 0.073 dB, tone p99 2490 Hz, receive −19.0 dBFS, heat 38.7 to 39.6 °C. The symbol stream accepted `0x40` and sent status 4 with no carrier, twice.

**2026-10-26 (19:28) — Variant 6 writes bits 15:8 of `FM_DEV_COEF`.** The hole's `lrw`s in the image that hung were 32-bit and pointed at the right words. Image A acked without touching the register. Image B read `0x000F1010`. The loaded image `7126749f…b779` replies with the stored word. `0x08` doubles the 16:53 curve and `0x04` quadruples it at 0.5 kHz; both are on a ceiling by 2.4 kHz, so no 30-frame decode was run. Channel 56 is unchanged (500 Hz 424, 1000 Hz 1280, the same 9.6 dB dip). Runner `all` passed, boot peak 0.06 dB. A byte read of `0x180000A0` through opcode 14 stalls.

**2026-10-26 (18:24) — Variant 6 is loaded and does not answer.** The stream trailer is gone (514-byte op 5 body). The opcode-6 handler sends a value other than 0 or 1 to the general dispatcher; that branch now enters the trampoline. `[6, 5, 1]` acks. `[6, 6, 0x08]` gets no reply within 800 ms, and `restartmodule` recovers. No sweep. `HANDOFF.md` is `STATUS: STUCK`.

**2026-10-26 (17:20) — Variant 6 does not fit.** The tail after `WRAP_END` `0x5C6EC` is 16 bytes. The low spare is 4 bytes and the high piece ends on opcode 14. `regsend` at `0x5C590` is called from `0x5C032`. No image loaded. `HANDOFF.md` is `STATUS: STUCK`.

**2026-10-26 (17:12) — A 300 Hz tone hits the same deviation ceiling.** The 0.5–4.0 kHz sweep with a 300 Hz tone matches the 1 kHz-tone curve: both are 1.58 times the 0.5 kHz amplitude by 1.0 kHz, and both sit near 6000 counts from 2.4 kHz up. `FM_BANDWIDTH` bit 1 is the 12.5/25 kHz receive select, reset to 25 kHz. The curves say the ceiling is not that filter, and the stub cannot hold the read-modify-write, so variant 6 was not loaded. Tables: `radio_firmware/results.md`.

**2026-10-26 (17:05) — At 1 kHz deviation the stream is flat, and 40 percent deviation decodes 21 of 30.** The 100 Hz–3.5 kHz sweep at 1.0 kHz deviation stays within 0.2 dB to 2.5 kHz. Channel 56 still dips 9.6 dB at 500 Hz. The 30-frame file scores 21, 8, 4 and 3 payload-exact frames at 40, 60, 80 and 100 percent deviation. The receive coefficient is `FM_DEV_COEF` bits 15:8, reset `0x10`; the same word holds the transmit limiter, and the stub has no room for a read-modify-write, so variant 6 was not loaded. Tables: `radio_firmware/results.md`.

**2026-10-26 (16:53) — Carrier offset does not move the stream mean, and deviation flattens by 2.4 kHz.** A ±1000 Hz move of the HackRF centre leaves the steady mean near +7 counts. A 1 kHz tone's amplitude leaves the straight line by 1 kHz of deviation and sits at about 6030 counts from 2.4 kHz to 4.0 kHz. The two stream captures and a channel-56 recording are in `tools/m17-research/captures/fw27-stream/`. The stop frame is `68 40 01 01 75 BC 00 02 11 00 10`, sent with no wait after the last half. Tables: `radio_firmware/results.md`.

**2026-10-26 (16:37) — The stream is flat, and the audio path is not.** From 100 to 3500 Hz the stream stays within 0.5 dB. Channel 56, hold on, is 9.6 dB down at 500 Hz and rises toward 2.5 kHz. Idle stream DC is +5 and rms is 55. The symbol eye is centred near ±1 and ±3 with a wide +3 cloud. A 41-tap fit did not train: the frames do not match the transmitted symbols closely enough. Sequence-only misses on the 13.3 s and 50.5 s runs are 0. Tables: `radio_firmware/results.md`.

**2026-10-26 (16:13) — The stream clock is 8000 Hz, and the 1.5 s hole is gone.** A 1 kHz tone already on the air reads as 1000.00 Hz, so 31.250 halves/s, with 0 identical halves. The miss counter added 18 in 13.3 s and 47 in 50.5 s; the amplitude stays flat from the first half. The plain stream listed 30 frames, 46 percent clean. Channel 56 with mode 5 off listed 30 frames, 96 percent clean, at −87 dBm. Runner `all` passed: tone 10.539 s at p99 2532 Hz, stream 1125/1125. Tables: `radio_firmware/results.md`.

**2026-10-26 (15:25) — Stop path acks, and the stream clock is 8103 Hz.** A host guard flags an `lrw` whose literal a patch overwrites; the shipped FW23–FW27 images are clean, and painting the key pool is not. The stream loop now acks the frame that ends it. `[17, 0]` acked, `0x34` answered at 230400, `[16, 0]` acked, `0x34` answered at 57600, `[6, 5, 0]` acked. A 1 kHz tone in the stream reads as 987.25 Hz at an 8 kHz assumption (31.65 halves/s), with 0 identical consecutive halves. The 45 s quiet run and (c) are not repeated yet. Tables: `radio_firmware/results.md`.

**2026-10-26 (14:46) — FW27 keys. The literal pool was the hang.** `0x5BBE2` loads from `0x5BE60`, and the old stub overwrote that pool, so `0x26` never returned. The stub is split around the pool (sha256 `152358b0…b4ad`). Down acked in 10 ms with status 3; up acked with status 4. Runner `all` passed, including a 10.565 s tone at p99 2541 Hz and 1125/1125 frames. A floor capture now says NO CARRIER. Tables: `radio_firmware/results.md`.

**2026-10-26 (14:01) — FW27 does not answer the key.** Same HackRF, no power cycle. FW26: status 3 and 4, RMS −17.4 dBFS, line 2570 Hz. FW27: `0x26` sent and released 10.4 s later, no ack, no status 3 or 4, RMS −38.3 dBFS flat. FW26 again: line 2427 Hz, RMS −14.1 dBFS. The stub's RAM is in the gap after the tone queue. Tables: `radio_firmware/results.md`.

**2026-10-26 (13:28) — FW26's tone is the old number. FW27's capture is not a carrier.** FW26: p99 2533 Hz, line 2430 Hz, SNR 61 dB. FW27: SNR 0.4 dB, line 25 Hz. The stub overwrites opcode 13's playback, and that playback's only callers are the dispatcher the image skips. Tables: `radio_firmware/results.md`.

**2026-10-26 (13:02) — Storing `WORK_MODE` re-arms the capture.** A store every 1, 2, 4 and 8 halves keeps the 1 kHz line in every residue class (median about 11990). Period 8 is the one the host asks for. A 45 s stream at that period reported 0 misses and ran 52 s. The regression tone stopped the runner at p99 22389 Hz. Tables: `radio_firmware/results.md`.

**2026-10-26 (12:30) — Op 16 keeps the line. The stream's first half is noise with mode 5 still set.** After op 16 at 230400, op 5's two halves are 1 kHz amplitude 23510 and 23529. Mode 5 then op 17 at 57600 saved no samples during the tone. On image `ab7a809d…4d20` the first stream frame carries `WORK_MODE` `0x80`, `FM_BANDWIDTH` `0x0F`, and 0 at `0x3A81C`, and half 0 is amplitude 396. The send was not moved. Tables: `radio_firmware/results.md`.

**2026-10-26 (12:05) — The saved stream has no 1 kHz line in half 0.** Goertzel amplitude at 1000 Hz on the 11:49 capture: half 0 is 286 (rms 3096), half 1 is 583, half 32 is 292. The strongest half in the file is 867. The predicted rise-and-decay is not there, so the send was not moved into the main loop. Tables: `radio_firmware/results.md`.

**2026-10-26 (11:50) — Op 5 has the line, the stream does not.** With mode 5 held and the UART at 57600, op 5 mode 0 during a 1 kHz tone returned halves at rms 8957, lag-1 0.57, peak 1000 Hz. The stream, after its copy was pointed at the same half op 5 uses (`FM_ADDR_SW` 1 → `0x160004E0`), was rms 3147, lag-1 0.16, peak 281 Hz, 344 halves, 2 missed. Tables: `radio_firmware/results.md`.

**2026-10-26 (11:25) — FW27 stream is not the 1 kHz line.** Mode 5 returns `sr=0`. A 10 s tone produced 346 halves in 11.1 s with 1 missed and rms 3099, and the samples are not a sine (lag-1 correlation 0.21). The speaker is silent while mode 5 is on. With mode 5 off the same tone is rms 7142, peak 1129 Hz. Section 4 (c) and (d) were not run. Tables: `radio_firmware/results.md`.

**2026-10-26 (10:40) — FW27 mode 5 is rejected.** `[6, 5, 1]` and `[6, 5, 0]` return `sr=1` in about 5 ms. `[6, 4, 1]` returns `sr=0`. The 1 kHz stream was not started. Mode 4 was turned back off. Tables: `radio_firmware/results.md`.

**2026-10-26 (10:32) — FW27 bench (a) passes.** The divisor write waits until the UART is idle and checks DLAB with a read-back. `0x34` answered `DMR003.FW27.V022` at 230400, again at 57600 after 35 s of silence, and the knock at 230400 was not accepted (`00 00`). Tag after the power cycle is unchanged. The sequence byte stays 0..5. Tables: `radio_firmware/results.md`.

**2026-10-26 (10:06) — FW27 loaded, UART rate switch is silent.** Tag `DMR003.FW27.V022`, sha256 `400c7cc8…fd70`, 378620 bytes, opcode 13 retired, opcodes 12 and 14 kept. Op 5's reply is 514 bytes: samples 0..511, sequence 512 (wraps at 6), half id 513. Op 16 rate 1 acks at 57600, then neither 230400 nor a 35 s fallback answers. Power cycle restores the tag. Section 4 not run. Phone not keyed.

**2026-10-26 — FW27 stub does not fit.** Control stub 324 bytes, 108 left in the 432-byte tail; the half-copy with its checks is 164 bytes. `0x35F64` is not free. No image loaded.

**2026-10-26 (08:20) — Receive-RAM stream design.** `radio_firmware/plan-rx-ram-stream.md`: op 6 mode 5 holds the bypass and `WORK_MODE` `0x80` together, op 16 switches the UART with a 30 s fallback to 57600, and op 17 pushes sequenced halves. No image and no phone. FW27 waits for the review.

**2026-10-26 (06:10) — Hotspot arrival runbook.** The setup session is written in `radio_firmware/plan-independent-m17-check.md`: the M17 community fork of WPSD, the phone's own channel frequencies, the five independent checks, the promiscuous rows with must-confirm 0 first, and the second-station self-cal. No phone and no key.

**2026-10-26 (05:50) — Cold-boot regression resumed over USB.** Starting SignalDeck took the radio in 7.2 s (FW26, stock app disabled). The runner's boot was silent (peak 0.108 dB) and its receive clip carried the 1 kHz line. Channel 56 listed one 30-frame call, 27 clean. MON on channel 4 echoed flag 1, then 0. With Own-the-radio-at-boot on, a second reboot brought SignalDeck up by itself at 47.9 s; the setting was turned off again. Tables: `radio_firmware/results.md`.

**2026-10-26 (02:50) — Cold boot stopped at adb.** The phone rebooted at 02:42 with tag `DMR003.FW26.V022` and the installed APK sha256 `c54cf9ad…c088`. Eight minutes later port 5555 still refused the connection, with no USB device and no mDNS adb service. The rest of the regression was not run. Tables: `radio_firmware/results.md`.

**2026-10-26 (02:23) — Independent pager decoder.** multimon-ng 1.6.2 on the bench PC decoded the saved 512, 1200 and 2400 pages: RIC 1000001, function 3, and the three-RIC page on 1000001, 1000002 and 1000003. Inverted polarity was not needed. The phone was not keyed. The runner's tone JSON key is `line1k_dev_Hz`. Tables: `radio_firmware/results.md`.

**2026-10-26 (01:41) — Receive-RAM stream closed on FW26.** A 1 kHz tone at −89 dBm is 1000.00 Hz on the phone audio and is absent from op 5's RAM (rms about 10). Opcode 14 cannot read `0x160004E0`. At 57600 a half takes 89 ms and covers 32 ms, so a continuous dump would drop most halves. No new stub. Tables: `radio_firmware/results.md`.

**2026-10-26 (01:19) — Bench runner accepted on FW26.** `bench.py all` passed boot, tone, the 1125-frame stream, receive and heat. A 30 s low-power key raised `mtktsAP` 1.0 °C. Tables: `tools/fw-bench/results/DMR003.FW26.V022/` and `radio_firmware/results.md`.

**2026-10-26 (00:30) — R-I live receiver.** A 30 s HackRF transmission was one listing of 750 frames, the same count `HeldPath.decode` got on that recording. A transmission with a one-second gap was one listing of 200 frames. SignalDeck PR 13, `0465553e`. Tables: `radio_firmware/results.md`.

**2026-10-25 (23:55) — FW26 held-path re-run.** The 22:42 40-frame clip at VGA 20 listed 40 frames, 37 clean, at −89 dBm. On FW25 that clip listed 40 and 39. Not the 19-of-30 result. Tables: `radio_firmware/results.md`.

**2026-10-25 (23:35–23:41) — FW26, promiscuous receive, flag off until a command.** Tag `DMR003.FW26.V022`, sha256 `71949d24…a34e`. Built on the FW25 image. Free tail after FW25 is 664 bytes from `0x5C464`; the four stubs use 232. Boot peak 0.056 dB. Op 15 `[15, 1]` echoes 1 and the `0x2B` body grows from 9 bytes to 11; `[15, 2]` is `sr` 1 and the length stays; `[15, 0]` echoes 0 and the body is 9 again. `0x1832e` extracts bit 22 and bits 21:20, not colour code or slot, so the appended bytes use the spec masks (bits 7:4 and bit 19). One 1 kHz key, body p99 3626 Hz, peak 1000.1 Hz. One 40-frame M17 key, 40/40, p99 2873 Hz. One 1200-baud page, p99 3761 Hz. Held-path receive listed 19 frames, 84 percent clean. The hotspot A/B rows are still open. Tables: `radio_firmware/results.md`.

**2026-10-25 — Item 7 bench.** A 40-frame call at −90 dBm made a 31-frame fit. A second call at −99 dBm locked on the new taps but scored 18 clean frames against 19 for the shipped table, so the fit was not kept. PR 12, `87a6a503`. Tables: `radio_firmware/results.md`.

**2026-10-25 — Item 7 design.** Receive self-calibration fits the held-path taps on a decoded M17 call and keeps them only after a second transmission. No image. `radio_firmware/plan-rx-selfcal.md`.

**2026-10-25 — Item 8 levels.** Counts 4600 / 6500 / 7000. Worst half-second 4230 Hz at 512, 4493 Hz on the three-address 1200 page, 4417 Hz at 2400. The 2400 page is 16 of 16 with one idle word after the batch. `mtktsAP` 47.1 to 47.7 °C. Tables: `radio_firmware/results.md`.

**2026-10-25 — Item 8 device pass, POCSAG page.** A 0 bit is the negative count, because a positive count deviates low. Confirming 1200-baud page: polarity +1, 16 of 16, body p99 4123 Hz. Three RICs in one key, and 512 and 2400 baud, decoded. A page at 467.550 MHz returned to channel 2. The 512-baud slices reached 6281 Hz and one three-RIC slice 5086 Hz, over 5 kHz; the level was not changed. Tables: `radio_firmware/results.md`.

**2026-10-25 — Item 6 device pass.** M17 channel 56 on FW25: wide FM, squelch 0, hold accepted. One 10 s web Talk key, body p99 2883.7 Hz, link-setup CRC, type `0x0385`, 249/249 Golay 0, end bit and EOT. Receive at −95 dBm listed 30/30; at −100 dBm the live count was 26/30. Two −97 dBm clips are 30/30 payload-exact on the held-path decoder. Backup restore keeps type, CAN, destination, band 1 and squelch 0 after the row-width fix (`1cad336b`). Channel 2, that build installed. Tables: `radio_firmware/results.md`.

**2026-10-25 — FW25, the vocoder buffer is not what the phone hears in FM.** A 500 Hz then 2 kHz square at ±8192 was written at `0x180000A0` and was still there afterwards. Irq 27's flag stayed 0 (count 0). The phone clip stayed near 320 Hz at −15.7 dBFS. The flag word is not another buffer address. Decision (c) is final. The 1125-frame stream was 1125/1125. Tables: `radio_firmware/results.md`.

**2026-10-25 — FW24, opcode 13 does not reach the phone.** The DMR-channel playback was digital silence (−88 dBFS). The analog playback with `STANDBY_LO` bit 31 already clear was open-squelch noise at −13.7 dBFS and no chirp. The review then asked for FW25 before calling (c) final. The 1125-frame stream on the image that stayed loaded was 1125/1125. Tables: `radio_firmware/results.md`.

**2026-10-23 — FW8, FW16 done; FW11 largely done on the host.**

- **FW8:** `radio_firmware/symbols.csv` (`offset,kind,name,comment`, 44 rows, 3 external) plus `FwCskyImportSymbols.java` / `FwCskyExportSymbols.java`, wired into `scripts/fw1_ghidra_csky.ps1` (import after analysis, export last to the gitignored `symbols.export.csv`). Headless run: 36 functions + 4 labels applied, 40 exported back, exit 0.
- **FW11 (A4):** the RF IC is an **AT1846S**. `0xFD011220`/`0xFD01125C` are its register write/read; `+0x2BAC` is the AT1846S init sequence. Register `0x58` (the audio filter switch) is `0x8405` on analog (pre/de-emphasis on, voice high-pass active) and `0xBCFD` on DMR (emphasis and voice low-pass bypassed; the voice high-pass field is `01` on both, see §11). **H1 holds for emphasis and the sub-audio cut**: they are 16-bit immediates in this image. Still open: whether the compression and the ±4.5 kHz limit come from the AT1846S (`0x59`/`0x43`/`0x41`) or from DSP in the module's CPU (H2). An option **H4** (route the phone's PCM to the DMR modulator) was raised; the review in §11 folds it into the flat-FM work. Tool: `scripts/fw_at1846_regmap.py`. Details: `11` §21.
- **B2 correction:** `0x34` is answered from RAM `0x03052464`, which the resident code fills, **not** from the string at `+0x38464`. A string edit alone would never show. The marker patch `version-from-image` redirects the handler's pool word (`+0xA9E8`) to the image's string. The tag replaces the `UV4T` field (`DMR003.UVm1.V022`) so the OEM and SignalDeck version parsers still see `V022`. Corollary: **no image load has ever been proven** (the 2026-03 loads were judged by patches that did nothing). FW14 is the first real proof.
- **FW16:** `tools/fw-patch/` — `patches.toml` (factory MD5 pinned; `version-from-image` ready; `fm-flat-58` experimental: `0x58 = 0x840F` on the five no-tone sites + the `+0x333A` mask made a no-op), `build.py --tag`, `check.py`, `test_patches.py` (5 tests pass). Built and disassembly-checked: `DMR003.UVm1.V022` (marker only) and `DMR003.UVm2.V022` (marker + flat FM). Output in `radio_firmware/build/` (gitignored).
- **Next, on the device (owner's go-ahead; not during an ISS pass):** FW14 with `UVm1` — through the stock app's `DMRDEBUG.bin` path (ch. 07 §6, SignalDeck stopped) or SignalDeck's own loader once FW13 exists. Then `UVm2` against the factory baseline (FW17 measurements (1), (3), (5)).

**2026-10-23 (later) — review follow-ups (§12) done; recovery settled (§13).**

- `11` §21 corrected: §21.0 memory map (HR-C7000, XIP `0x0301A000`, IRAM from `+0x39408`, SRAM from `+0x322E0`; §13.3 marked superseded), the `0x58` bit layout from the OpenRTX driver (bit 6 voice HPF, bit 7 emphasis; `0x8405` all on, `0xBCFD` all bypassed), `0x34` reads the image's own string, and `+0x2B14` is the 12.5/25 kHz bandwidth profile (`at1846_apply_bw_profile`), not calibration. `symbols.csv` updated to match: the `ext` rows are replaced by the IRAM functions `at1846_i2c_write` `+0x54628`, `at1846_i2c_read` `+0x54664` and `OSTaskCreate` `+0x3C390`.
- `tools/fw-patch`: `version-from-image` dropped; a tag-only build is the marker. `fm-flat-58` is now `0x84C5` on the five no-tone sites (mask site dropped). New `c7000-fm-flat` (experimental): `+0x3074` `bsr` redirected to a 32-byte stub at `+0x5B000` (`stubs/c7000_fm_flat.S`) that does the original AT1846S write, then `FM_BANDWIDTH 0x11000500 = 0x0F` (band-pass and pre-emphasis off) and `FM_DEV_COEF 0x11000504` = pool word `+0x5B01C` (reset `0x000F1010` as built; `tr_sig_lim` = bits 23:16 for a bench series). 8 host tests pass, including "tag-only differs from factory only in the version string" (2 bytes) and the stub's branch targets.
- The zero tail is **6,144 B from `+0x5AEFC`** (right after the IRAM copy), not 1,788 B as §1 said.
- `radio_firmware/build/`: the b8ee26df images moved to `superseded/` (`*.SUPERSEDED-bin`, README: do not load). `DMR003.UVm1.V022.bin` rebuilt tag-only (sha256 `f2390a04…484f5c`).
- Ghidra re-imported as three regions (§13.4).
- §13: the YModem receiver is the flash bootloader below `0x0301A000`, not in the image; loads go to flash and very likely **persist**; recovery after a bad load is possible. FW14 cleared to run with the tag-only image.

**2026-10-23 (13:37–13:53) — FW14 done on the Armor (§14).** Tag-only `DMR003.UVm1.V022` loaded through the stock updater, then read back via `0x34`:
- `UVm1` after a module power-cycle, after DIAG `restartmodule`, and after a full phone reboot.
- The factory image loaded back, which restored `DMR003.UV4T.V022`.

**First proven load; loads persist in flash; restore = load the factory image.** No transmission. Bench helpers: `tools/fw-patch/bench/`.

**2026-10-23 (14:33–15:17) — FW17 baseline and FW18 flat-FM images measured on the air.** HackRF receive only, phone at 467.625 MHz low power. Factory first (already `DMR003.UV4T.V022`), then UVm2 (`fm-flat-58` only), UVm3 (`c7000-fm-flat` only), UVm4 (both), each confirmed by `0x34` before the measurement. Factory loaded back at 15:17:01 and `0x34` read `DMR003.UV4T.V022`. Full tables: `radio_firmware/results.md`.

**No image meets the §6 acceptance.** The pre-emphasis is the AT1846S `0x58` bit 7: UVm2 and UVm4 bring 300 Hz–3 kHz to within about ±2 dB of 1 kHz, and 3.5 kHz is still −2.6 dB (UVm2) and −4.0 dB (UVm4). The cut below about 250 Hz is still there on every image, including both patches together (50–200 Hz about −40 dB or lower). UVm3 matches the factory curve, so the HR-C7000 `FM_BANDWIDTH` / `FM_DEV_COEF` stub does not change the audio the HackRF hears, and adding it on top of `0x58` (UVm4) matches UVm2 alone. Mid-band gain is unchanged (0.20–0.22 Hz per PCM count at 1 kHz).

Plain M17, one 90-frame transmission each, no equalizer: **0 exact / 90** on every image, spec polarity and inverted. UVm2 and UVm4 were the standard ±2.4 kHz scaling (measured p99.5 3397 and 3411 Hz). POCSAG 1200 and 512 baud: **0 / 3 pages** on every image, both polarities. UVm2 and UVm4 were the standard ±4.5 kHz scaling (measured p99.5 about 3.0–3.4 kHz; bit errors 23–31%). The limiter was still linear at −6 dBFS (about 3.1–3.3 kHz); 0 dBFS predicted over ±5 kHz and was not sent, so the ceiling was not re-measured. Voice demods are in `radio_firmware/results/`; the lows are gone (under 1% of the power below 250 Hz) and they were not listened to. Receive harshness was not compared.

At 15:17 the cut below about 250 Hz was still unexplained. The follow-up the same evening is the next entry. The product remains a run-time digital-audio mode; these images are bench-only. End state of that run: factory image verified, SignalDeck owns the radio, Weather zone channel 36 (NOAA WX4), no `DMRDEBUG.bin`.

**2026-10-23 (16:06–16:21) — UVm5, UVm6, and the C7000 canary UVm7.** HackRF receive only, 467.625 MHz, low power. `0x34` was `DMR003.UV4T.V022` before the first load. Each image was confirmed by `0x34` before it was measured. Factory loaded back at 16:21:10 (`DMR003.UV4T.V022`). Tables: `radio_firmware/results.md`.

The no-tone VFO `0x23` does run `at1846_set_ctcss_dcs`. `apply_analog_config` calls the flash FM tune (the `0x58` immediate, and the `+0x3074` branch) and then, because struct byte 0 is 0, the IRAM tune, which is the only caller of `at1846_set_ctcss_dcs`. With `rxType` 0 that function read-modify-writes register `0x58` with mask `0xFFF7` and clears bit 3. UVm5 and UVm6 change the immediate at `+0x333A` from `0xFFF7` to `0xFFFF`, so the write-back stores the register unchanged. UVm5 is `0x58` = `0x84DD` (UVm2 plus bits 3 and 4) at the five sites plus that mask. UVm6 is `0x84FD` (bit 5 as well) plus the same mask.

**The cut below 250 Hz is not explained.** 50–200 Hz stays about −40 dB or lower at −30 dBFS on both images, and the same tones at −24 and −18 dBFS stay on the noise floor while 300 Hz scales (UVm5: 186 → 362 → 733 Hz). Bits 3 and 4, kept through that read-modify-write, do not open the bottom octave. Bit 5 does not either. Bit 5 does lift 3.5 kHz, from −4.0 dB on UVm5 to −1.0 dB on UVm6, so 300 Hz–3.5 kHz on UVm6 is within ±2 dB of 1 kHz. Plain M17 was 0/90 and POCSAG was 0/3 pages on both, at the standard ±2.4 kHz and ±4.5 kHz scaling. The low end was not flat, so the −3 dBFS step, the extra M17 transmissions and the voice clip were not sent.

UVm7 is the C7000 stub with `tr_sig_lim` lowered from `0x0F` to `0x02`, and no `0x58` patch. One 1 kHz tone at −12 dBFS measured **1829 Hz**, against 1827 Hz on the factory image. The lowered limiter did not move this tone. `+0x3074` is on the flash FM tune and that tune runs on this `0x23`; the null means the new limiter value did not affect this stimulus. End state: factory image verified, SignalDeck owns the radio, Weather zone channel 36 (NOAA WX4, active), no `DMRDEBUG.bin`.

**2026-10-23 (16:41–16:50) — UVm8 stub self-proof and UVm9 (`0xBCFD`).** HackRF receive only, 467.625 MHz, low power. `0x34` was `DMR003.UV4T.V022` before the first load. Each image was confirmed by `0x34` before it was measured. Factory loaded back at 16:50:43 (`DMR003.UV4T.V022`). Tables: `radio_firmware/results.md`.

UVm8 keeps the C7000 FM writes and, in the stub only, writes AT1846S `0x58` = `0x84C5`. The five factory `0x8405` immediates stay. The −36 dBFS probe is 1 kHz **111.5 Hz** and 3.5 kHz **70.5 Hz**, **−4.0 dB**, against the factory probe's +6.8 dB. Pre-emphasis is gone, so the stub runs on the keyed path. UVm3 and UVm7 are real results: the C7000 `FM_BANDWIDTH` / `FM_DEV_COEF` writes, including the limiter canary, are not what the HackRF hears. Bits 6 and 7 survived the `0xFFF7` read-modify-write, which UVm8 does not patch.

UVm9 is `0x58` = `0xBCFD` at the five analog sites plus `ctcss-hpf-keep`. The DMR site is left as it is. Against UVm6 this adds bits 11–13. Probe: 1 kHz 106 Hz, 3.5 kHz 100 Hz (−0.5 dB). At −30 / −24 / −18 dBFS, 300 Hz is 166 / 354 / 708 Hz and 50–200 Hz stays on the floor (best −40.9 dB at −30). The low end did not open, so the sweep, M17 and POCSAG were not sent. Register `0x58` is exhausted for this cut.

The phone check was read-only. `tinymix` is not installed, and no mixer control was written. tinyserver, which receives SignalDeck's PCM, names I2S route controls (`I2S1_CH1 DL8_CH1`, `UL2` ↔ `I2S2`) and `DAC DEM MUTE`. None is a high-pass. In the module, FM setup (`+0x3ECC0`) and boot codec init (`+0x647C`) enable the codec ADC (`AICR_ADC` = `0xC0`). `FCR_ADC` (`0x160009D7`, `adc_hpf` and the wind-noise filter, reset off, mode 3 = 235 Hz) has no literal and no byte store. The phone plays PCM out on I2S1; the image's FM source is the codec ADC.

**The bottom octave is outside software reach.** It is not a firmware register this image can set, and it is not a high-pass control on the phone route this app uses. What remains is the analog coupling between that I2S playback and the codec ADC input. §16's fallback stands and is not implemented: run-time pre-shaping and a receive equalizer on the UVm6 curve (flat from 300 Hz to 3.5 kHz). End state: factory image verified, SignalDeck owns the radio, Weather zone channel 36 (NOAA WX4, 162.425 MHz, low power, active), no `DMRDEBUG.bin`.

**2026-10-23 (17:33–17:44) — UVm10, the ADC-gain canary.** HackRF receive only, 467.625 MHz, low power. The version field is four characters, so the flash tag is `Vm10` and `0x34` reads `DMR003.Vm10.V022`. The bench name stays UVm10. `0x34` was read before each transmission. Factory loaded back at 17:44:13 (`DMR003.UV4T.V022`). Tables: `radio_firmware/results.md`.

`FCR_ADC` is codec base `0x160009C0` + `0x17`, which is the same address as `0x16000900` + `0xD7`. The factory image has no literal of that address. The only two registers that ever hold `0x160009C0` are the end pointers of a halfword copy that stops before it (`r8` at `+0x67DC`, `r9` at `+0x6980`); both are reloaded from the stack and nothing is stored through them. The codec init's gain stores are offsets `0xDF`, `0xE3` and `0xE5` from `0x16000900`. No store hits `FCR_ADC`. `adc_hpf` and the wind-noise filter stay at the off reset.

UVm10 is the UVm8 stub without the `0x58` write, plus `GCR_ADCL` lowered by 6 dB from the value the analog `0x23` path leaves. Codec init writes `0x8B` (11 dB). `0x61F4` then rewrites it, and on this path the RAM flag it tests is 1, so the factory air numbers were taken at `0x89` (9 dB). A stub-only store is overwritten by that function. The image changes the three `0x61F4` immediates by six counts (`0x8B`/`0x88`/`0x89` become `0x85`/`0x82`/`0x83`) and the stub stores `0x83`. The 0 dB floor (`0x80`) is unchanged. The five factory `0x8405` immediates stay. The guide's step is 1 dB per count, so 6 counts is half the amplitude.

It did not halve. The −36 dBFS probe is 1 kHz **109 Hz** and 3.5 kHz **237 Hz** (+6.7 dB), against the factory probe's 115 Hz and 250 Hz (+6.8 dB). The −12 dBFS 1 kHz tone is **1740 Hz**, against 1827 Hz. All three are about 0.5 dB down. Half would have been about 57 Hz, 125 Hz and 914 Hz. Pre-emphasis is still on, which is the factory `0x58` this image does not touch. The C7000 FM stores in the stub are the same ones UVm7 already showed do not move a −12 dBFS tone.

**The codec ADC gain is not in the radiated path.** The branch this `0x23` takes was lowered; the unchanged 0 dB floor is the other branch. `FCR_ADC` staying at reset agrees with the scan and does not, by itself, place the cut. The guide's FM transmit source when `0x11000080[0]` is 0 is that ADC's PCM, which is the setting this image programs, and the air did not follow its gain. `sel_i2s` (bit 2 of the same register) is the baseband-test I2S enable, and the codec init forces the ADC interface to parallel, not I2S. The other source the guide names is TX RAM (`0x11000080[0]` = 1). The gain the air has already followed is the AT1846S: `0x58` bit 7 removes the pre-emphasis (UVm8), and register `0x44` bits 11:8 are its TX mic gain (`set_tx_gain_reg44`, ch. 11 §21). The FM tune writes `0x44` = `0x0AD1` (that nibble is `0xA`). The OEM mic-gain command uses the same field in 4 dB steps, body 0–5 = 0/4/8/12/16/20 dB, and SignalDeck sends body 4 only in the boot handshake, not on a DIAG VFO tune.

The next image, not built and not loaded: lower that nibble by two counts (`0xA` → `0x8`, 8 dB if the labeled step still applies) at the FM-tune store, and apply the same two counts in `set_tx_gain_reg44`, so a later `0x2A` cannot put the old gain back. Same two stimuli. A drop of about half means the audio enters the AT1846S microphone gain. No drop means it does not. §6 is not met. Pre-shaping and a receive equalizer are not implemented. UVm6 stays the candidate curve for modes that fit 300 Hz–3.5 kHz. End state: factory image verified, SignalDeck owns the radio, Weather zone channel 36 (NOAA WX4, 162.425 MHz, low power, active), no `DMRDEBUG.bin`.

**2026-10-23 (18:28–19:18) — UVm11, the DAC-gain canary, and the receive cross-check.** HackRF receive only, 467.625 MHz, low power. The flash tag is `Vm11` and `0x34` reads `DMR003.Vm11.V022`. `0x34` was read before each transmission. The factory image was loaded back at 18:31:56, and again after the receive clips (19:15:37). The final `0x34`, at 19:18:07, is `DMR003.UV4T.V022`. Tables: `radio_firmware/results.md`.

`GCR_DACL` is codec base `0x160009C0` + `0x1F`. `godl` is not a linear count: bit 5 clear is 0 to −31 dB, and bit 5 set is +1 to +32 dB with the code counting backwards. The live byte is one of ten table slots at file `+0x36ED0`. The init immediate `0xAB` (+21 dB) does not survive. The leaf at `+0xAD0` has no caller. PTT does not store the register. A stub at `+0x3074` runs before `0x61A8` and would be overwritten, so the image lowers all ten slots by 6 dB and uses no stub. `FCR_DAC` is the sample rate only, the image never stores it, and the guide has no DAC high-pass, DC-block, or de-pop bit. `GCR_MIXDACL` and `CR_DAC_AGC` are never stored. `dac_agc_en` stays 0.

The air did not follow the 6 dB. The −36 dBFS probe is 1 kHz **111.9 Hz** and 3.5 kHz **249.7 Hz** (+7.0 dB), against the factory probe's 115 Hz and 250 Hz. The −12 dBFS 1 kHz tone is **1733 Hz**, against 1827 Hz. The ratios are 0.973, 0.999 and 0.949. Half would have been about 57 Hz, 125 Hz and 914 Hz. Pre-emphasis is still on.

**The codec DAC gain is not in the radiated path.** The phone's audio still reaches the AT1846S: UVm8 removed the pre-emphasis through register `0x58`. That path does not include `GCR_DACL`, and UVm10 already showed it does not include `GCR_ADCL`. When byte 0 of the copied channel struct is not 1, `0x61A8` writes AT1846S register `0x44` from the table at `0x03050EE4` and leaves the boot `GCR_DACL` byte alone. That `0x44` image was not built. `0x58` already places the audio in the AT1846S. The other sources the guide names are the codec-ADC FM path, which UVm10 measured, and TX RAM (`0x11000080[0]` = 1) or a converter this DAC register does not control. No follow-up image was loaded.

The receive check transmitted nothing and used no HackRF. Ten seconds of open-squelch audio on 467.625 MHz, squelch 0, with the transmit frequency left at 162.425 MHz: UVm10 is −15.55 dBFS and the factory image is −15.61 dBFS, a difference of **+0.06 dB**. About 6 dB quieter on UVm10 would have meant the codec ADC is the receive path. The clips are noise on both images (zero fraction 0.0001, spectral peak about 12 times the median). **The codec ADC gain is not in the receive path.**

§6 is not met. Pre-shaping and a receive equalizer are not implemented. UVm6 stays the candidate curve for modes that fit 300 Hz–3.5 kHz. End state: factory image verified, SignalDeck owns the radio, Weather zone channel 36 (NOAA WX4, 162.425 MHz, squelch 5, low power, active), no `DMRDEBUG.bin`.

**2026-10-23 (19:47–19:50) — R1, the DMR 4FSK rails, and the TX-RAM reading.** HackRF receive only, 467.625 MHz, low power. No firmware was loaded. `0x34` was `DMR003.UV4T.V022` at 19:47:36, before the one key-up, and again at 19:50:37 and 19:50:49. Tables: `radio_firmware/results.md`.

The bench channel was digital, CC1, timeslot 1, talkgroup 9999, low power, with no contact row. DIAG `testtone` keyed it for 2000 ms. One 8 s capture, LNA 24 / VGA 38, clip fraction 0, SNR 51.0 dB, carrier offset +864 Hz, keyed 2.83 s. The row was deleted afterwards.

The envelope repeats every **60.00 ms** (correlation 0.894): one slot of a direct-mode transmission, 47 bursts of 26.1 ms. Symbol centers are 4800 per second. The first and last 1 ms of each burst are left out of the level measurement, so the power ramp is not counted as deviation. The outer-symbol median is **+7346 Hz / −7049 Hz**. The early, middle and late thirds are 7252, 7111 and 7168 Hz, ratio **0.981**. A held outer symbol does not sag across the burst. About 7.2% of the 0–4 kHz power inside the burst is below 250 Hz. The 99.5 percentile of the raw window, 23132 Hz, is the ramp and the symbol transitions. With the ramps left in, the 54 / 24 / 54 symbol shoulders around the sync are +7572 / −7440 Hz and the pre/sync/post ratio is 0.956. The guide's ±1944 Hz table (`RF_MODE[7]` = 0) is the baseband symbol map. The air rail is about 3.8 times that map. The same demodulator read about 1800 Hz on a −12 dBFS 1 kHz tone earlier the same day, and +864 Hz matches that day's crystal offset.

**The DMR modulator path holds a level across a burst.** The outer rail is above the ±5 kHz stop, so the TX-RAM image was not assembled and nothing further was transmitted.

R2 is Document 2 plus the factory image. `scripts/fw_at1846_regmap.py` for `0x30`, `0x43`, `0x44` and `0x58` matches ch. 11 §21.2. `at1846_tune` (`+0x2DD8`) writes `0x30` = `0x4046` and then splits. The DMR side writes `0x43` = `0x00BB`, `0x44` = `0x0AD1`, `0x30` = `0x4006` / `0x4026`, and `0x58` = `0xBCFD` (`+0x2E92`). The FM side (`+0x2FF2`) writes `0x43` = `0x0100`, the same `0x44` = `0x0AD1`, `0x30` = `0x4006` / `0x4026` or `0x7006` / `0x7026` on the 25 kHz path, and `0x58` = `0x8405` (`+0x3052`). `0xBCFD` bypasses the AT1846S voice filters. `0x8405` leaves them on.

Channel setup writes `WORK_MODE` (`0x11000100`) as `0x22`, `0x6A`, `0x6E` or `0x73` (guide Table 27, page 92). FM key-up (`+0x3ECC0`) stores `RF_MODE` = `0x10E0` (bits 6:5 = 11, two-point; bit 7 = 0, so +3 maps to +1944 Hz; bit 10 = 0, so the built-in 40 Hz square stays off), `WORK_MODE` = `0x80`, and PTT (`0x11000560`) = 1. That `0x10E0` is the only full-word immediate store of `RF_MODE` found. The same key-up clears `0x11000080[0]` (`tx_voice_source`) at `+0x3EDF8`, so a handheld analog transmission uses the codec source. Three copies (`+0x1788E`, `+0x17CB6`, `+0x19682`) set that bit when byte `0x12` of the struct at `0x34808` is 2 or 3, or when the flag at `0x4D404+0xF8` is nonzero, and clear it when the byte is neither and the flag is 0. The copy at `+0x195DA` runs only while that flag is 1, then sets the bit for byte 2 or 3 and clears it otherwise. Bit 4 of the same register is `ahb_wr_voice_en` (set at `+0x3E0A8`, clear at `+0x3E080`).

TX RAM is `0x16000030`–`0x1600042F`: two halves of 512 bytes, 256 samples of 16-bit PCM, 32 ms at 8 kHz, high byte at the low address (Document 2 §7.2.2.1.2 and page 340). `FM_ADDR_SW` (`0x1100056C`) reads 1 for the low half and 2 for the high half. `FM_TX_INTERP` is the refill interrupt. This image has no store into that RAM and no handler that fills it. The CPU touch at `+0x3EEEC` reads one sample from each half and returns it. `FM_BANDWIDTH` (`0x11000500`) and `FM_DEV_COEF` (`0x11000504`) are never stored, so FM pre-emphasis (bit 4) and the FM band-pass (bit 6) stay on at reset, and `fm_dev_coef_t` stays `0x10`. The guide gives no Hz per PCM count. The 27-byte DMR voice payload starts at the same `0x16000030`. A later TX-RAM stub would have to start at a small PCM amplitude, clear `FM_BANDWIDTH` bit 4, and keep that 27-byte payload out of the PCM half. That pre-emphasis is a different path from the DMR modulator R1 measured.

**R4 stays a design.** Command byte `0x3D`, after a check that the image's own compare does not already use it (the OEM table leaves `0x3D` and `0x3E` undefined). The frame stays `68 | cmd | rw | sr | cksum | len | body | 10` at 57600 baud. The body is a kind byte (1 = M17 dibits, 2 = POCSAG bits), a count, and the packed symbols. One ping-pong half is 32 ms. M17 at 4800 symbols/s is 154 dibits, 39 bytes packed four dibits per byte, 41 with the header, a 50-byte frame. One frame per half is about 1600 bytes/s, about 27% of a 5760 byte/s line. POCSAG at 1200 bit/s is one 32-bit codeword, 4 bytes plus the 2-byte header. Firmware would set `WORK_MODE` = `0x80`, `tx_voice_source` = 1, `ahb_wr_voice_en` = 1 and PTT, shape into the half `FM_ADDR_SW` names, and clear `fmpreemphasison`. M17 is a root-raised-cosine at 5/3 samples per symbol. POCSAG is a Gaussian at 20/3 samples per bit. The coefficient tables are under 200 bytes each and the shaper is a few hundred bytes, inside the existing 378620-byte image. Deviation starts from a small PCM amplitude. §6 (plain M17 85/90, POCSAG 100%) is the bar if that command is ever built. It was not built, and §6 is not met.

End state: factory image, `0x34` = `DMR003.UV4T.V022`. SignalDeck owns the radio. Channel 36 is NOAA WX4, 162.425 MHz, squelch 5, power low, active. The temporary digital row is gone. The screen showed 162.425 MHz. Zone 4, `zoneLast_4` 36. `PATCH14_BACKUP.bin` was not touched. No `DMRDEBUG.bin`.

**2026-10-23 — `es8311_store`, read from the boot image, nothing written.** `boot_a` is 67108864 bytes. The gzip kernel is at offset 2048 and decompresses to a 4.19.191 aarch64 Image (`Linux version 4.19.191`, built 2024-12-11). Kallsyms has 58046 symbols. `kptr_restrict` was not changed, and nothing was written to `es8311_debug`.

The file `/sys/bus/i2c/devices/7-0018/es8311_debug/es8311` is mode `0664`. Its attribute group is named `es8311_debug`, the attribute is named `es8311`, show is `es8311_show` (`ffffff8008e18ee8`) and store is `es8311_store` (`ffffff8008e18f6c`). A read calls `es8311_show`, which reads codec register 0 through `snd_soc_component_read` and returns `es8311_show(): get 0x0000=0x%04x`. A write parses one hexadecimal integer with `simple_strtol` (base 16). Bits 7:0 are a value, bits 15:8 are the start register, and bits 23:16 are a count. When the count is 0, it reads the low byte's worth of registers from the start register (a low byte of 0 still reads one) and prints each line to the kernel log. Otherwise it writes that same value byte to that many consecutive registers through `snd_soc_component_write`, and prints those lines to the kernel log. The store returns the number of bytes it was given. The printks do not come back through the sysfs file. Any write of this node remains the owner's decision.

**2026-10-23 (20:51–21:09) — R1b revises the factory DMR outer symbol to ±3.3 kHz. The R3 image does not boot.** No new transmission. HackRF was not started. The second look uses the 19:47 capture. Tables: `radio_firmware/results.md`.

The +7346 / −7049 Hz median was a phase lock onto the discriminator tail (raw window 99.5 percentile 23132 Hz). The same pass's symbol-centre |deviation| median was already 3179 Hz. On the same IQ the 99 % occupied bandwidth of a burst is **10546.875 Hz** (edges −4414 Hz and +6133 Hz, carrier at the edge midpoint **+859 Hz**, 20 kHz low-pass, 46 spectra). A ±7.3 kHz 4FSK would occupy about 18–20 kHz. The four symbol centres, open eye, are **−3344.7 / −1068.9 / +1219.2 / +3344.7 Hz** (counts 1070 / 1644 / 2395 / 1288, within-cluster rms 403 Hz). Inner/outer is **0.342**. Early / middle / late outer symbols are 3340 / 3361 / 3322 Hz, late/early **0.995**. The transition phase reads a lower outer (2676 Hz), so ±3.3 kHz is the held symbol. The 9 kHz demodulator, re-run with the same cluster method, reads outer ±3172 Hz. The guide's ±1944 / ±648 Hz table (`RF_MODE[7]` = 0) stays the nominal map. The air outer is about 1.7 times ±1944 Hz. This pass does not say why. The share of 0–4 kHz power below 250 Hz on the wide IF is **0.177** (the 0.072 figure was the spiked trace). Both sit far above the FM path's under 1 %, so the DMR modulator still passes the low end.

R3 (`c7000-txram-square`, tag `R3a0`, `DMR003.R3a0.V022`, MD5 `442c5cad026a361009da79e1034c7a3e`) was built and loaded. The image differs from factory at the tag, at six bytes `+0x3EDFC` (`bsr +0x5B000` plus `movi r0, 0`, the PTT store), and at a 76-byte stub at `+0x5B000`. The clear of `tx_voice_source` at `+0x3EDF8` stays. The stub sets `0x11000080[0]` only: Document 2 §7.2.2.1.2 does not mention `ahb_wr_voice_en`, so bit 4 stays clear. It clears `FM_BANDWIDTH` bits 4 and 6, fills the ping-pong with +256 / −256 (16-bit big-endian, a 15.625 Hz square at A = 256), then stores PTT. Two YModem loads (`onSuccess` 20:51:28 and 21:02:22) each left an empty `0x34` line. The loader exits 0 on that empty line; the tag check is the logcat version line, and there was none. Each load printed the ten ASCII bytes `0x29050000` and then failed two power cycles with no boot banner. Nothing was keyed. The square was not measured, and A was not raised.

Those ten bytes are a `%#x` rendering of `0x29050000`. The only such formats in the image are the SDMMC lines at file `+0x36A94` and the SCR line at `+0x36D02`. The printer at `+0x4DE4` uses the `+0x36A94` string and returns 41. The banner string at `+0x3653C` was not patched. The factory image, loaded by the same script between the two attempts and again after the second, prints the banner and answers `0x34`. UVm8 wrote the same tail and a version tag and did print the banner, so the remaining R3 difference is the six-byte hook. The only `bsr` of key-up `+0x3ECC0` is at `+0x3D710`, and boot's call at `+0xDA6` is `bsr +0x3D68`, a different function. The direct calls do not reach the stub from boot, which leaves the missing banner unexplained. A third load of the same image was not started. There is no air result, so the DMR-register image (two-point `RF_MODE`, `0x58` = `0xBCFD`) was not proposed as a next build and was not built. R4 was not built. §6 is not met.

End state: factory image, banner at 21:09:08, `0x34` = `DMR003.UV4T.V022` at 21:09:08.783, factory MD5 `4426035392262ca54583c230c9e268e0`. The module acked channel 36 (162.425 MHz, squelch 5, low power, `RX cmd=0x23 rw=0 sr=0`) and the app announced NOAA WX4. SignalDeck owns the radio. No `DMRDEBUG.bin`. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written.

**2026-10-23 (22:35–23:02) — the IRAM copy has no whole-block check. A padding byte boots. The corrected R3 branch was not loaded.** No transmission. HackRF was not started. Tables: `radio_firmware/results.md`.

The words at file `+0xC4` are copy records: destination, end, source. SRAM is `0x18000800`, `0x18004404`, `0x0304C2E0`. IRAM is `0x00010000`, `0x00031AF4`, `0x03053408` (file `+0x39408`). The length is end minus destination, `0x21AF4` bytes. The loop is a word copy. It then stores zero from `0x31AF4` to `0x0004DAB0`. The `bsr` at file `+0x74` lands at IRAM `0x0002AEB4` (file `+0x542BC`), which creates the task at file `+0xD5C`. Sum32 `0xA23B52E7`, xor `0xC3293F1F`, crc32 `0x388809B7` and byte sum `0x00D1692C` of the copied block do not occur as words outside it. No word in the image is the IRAM or XIP address of key-up, of the hook at IRAM `0x159F4`, or of `+0x3D688`.

The copied range has no log string. Its ASCII names are uC/OS-III type words. Tag `R300` changed the `TICK` immediate at `+0x3ACEB` (`0x4B434954` → `0x4A434954`), which `+0x3AC42` compares. YModem `onSuccess` at 22:37:37.274. Two power cycles left no banner and an empty `0x34`. That is a missed compare, so `build.py` gained no checksum. The `TICK` edit is not in the tree.

Tag `R301` (`c7000-iram-padbyte`) changes the padding at `+0x3EE16` (`00` → `58`), after key-up's `jmp r15` and before the pool at `+0x3EE18`. sha256 `5c4ef9621f5c542db8bf6ca249fc791cce88f49881e2e930ce326a0969373356`. Banner `开机初始化完成` at 22:50:31.055. `0x34` at 22:50:31.365 is `DMR003.R301.V022`. The module acked channel 36. A changed byte inside the copy boots. The R3a0 failure is the six hook bytes.

`+0x3D688` calls key-up at `+0x3D710` and unkey at `+0x3D73C`. Nothing `bsr`s `+0x3D688`. Boot at `+0xDA6` calls `+0x3D68`. UVm8 wrote the same tail and booted, and R301 wrote the nearby padding and booted, so those six bytes run before the banner. `R3a1` encodes the `bsr` from IRAM PC `0x159F4` to XIP `0x03075000` (`82e106fb0030`, displacement `0x0305F60C`). `test_txram_square_fills_after_the_voice_source_clear` checks that runtime target. Image sha256 `7404d19b001eccb08867da97e8524a80788bdbed6763b71b9a8b8b81ab48c690`. It was not loaded. The stub stores PTT = 1 and returns to `+0x3EE02`; `+0x3D688` then calls unkey. A boot would key, and then unkey, before SignalDeck sends `0x23`, on the frequency already programmed. That frequency was channel 36, 162.425 MHz. This request did not confirm a transmission, so the A = 256 measurement was not run. IRAM can take a patch. The flash-resident hook was not built.

The R1 bench row stored `band` = 1. The DMR branch of `at1846_tune` (struct byte 0 == 1) calls `at1846_apply_bw_profile` with `r0` = 0, the 12.5 kHz table, then writes `0x30` = `0x4006` and `0x30` = `0x4026`. `0x4026` is the last write. `0x4046` is an earlier write on the common path, overwritten on this branch. The 25 kHz pair `0x7006` / `0x7026` is the FM branch, when byte 1 == 1. The DMR branch overwrites byte 1 at `+0x2E5E` before that compare. R1's capture is 4FSK, so it took the DMR branch. The analog `0x23` unpack is the path that stores 0 in byte 0 and the body's band byte in byte 1. The ±3.3 kHz outer symbol is the radio's 12.5 kHz DMR scale. A 12.5 kHz re-check would repeat this path.

End state: factory image, YModem `onSuccess` 23:02:14.530, banner at 23:02:30.787, `0x34` = `DMR003.UV4T.V022` at 23:02:31.098, factory MD5 `4426035392262ca54583c230c9e268e0`. The module acked channel 36 (162.425 MHz, band 1, squelch 5, low power, `RX cmd=0x23 rw=0 sr=0`) and the app announced NOAA WX4. SignalDeck owns the radio. No `DMRDEBUG.bin`. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. §6 is not met.

**2026-10-23 (23:28–23:42) — R3a2 boots, and a host key still radiates the codec tone.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

The factory boot, with the VFO already on 467.625, does not radiate there. DIAG `restartmodule` at 23:28:39.407, power cycle 23:28:40.474, banner 23:28:43.631, `0x34` `DMR003.UV4T.V022` at 23:28:43.943, then the same `0x23` again. A 24 s capture (LNA 24, VGA 38) has its hottest 100 ms bin +0.11 dB over the pre-restart floor, clip 0, and no bin at +3 dB. The power is the whole 2.4 MHz window.

Cmd `0x26` is handled at file `+0x9264` (table `+0x38240`, thunk `+0xABCA`). Launch 1 is `+0x92B2`, launch 2 is `+0x929C`. The flag is the unreferenced `.bss` word `0x4DAAC`. `R3a2` keeps the IRAM-to-XIP hook `82e106fb0030`. The stub does the factory PTT store when the flag is zero, and the TX-RAM square only when it is set. Launch 1 sets the word; launch 2 clears it and reloads `r3` with `0x38874`. sha256 `74a47c45e4e52a65fbdc5b3e07d9ceefe41f6b5f53be9961a178735e07e28f64`. Nineteen tests pass. YModem `onSuccess` 23:35:33.629. Banner 23:35:49.317. `0x34` `DMR003.R3a2.V022` at 23:35:49.627. The 162.8 s capture of that boot peaks at +0.13 dB, clip 0. Nothing at 467.625 beyond the factory boot. After the banner the takeover programmed channel 36.

One 3 s key on the 467.625 VFO, low power: `0x26` launch 1 acked, `0x36` body `03`, 24000 samples, launch 2, `0x36` body `04`. The deviation is a 999.5 Hz sine, rms 1.47 kHz, amplitude about ±2.1 kHz, clip 0. The 15.625 Hz fundamental is 0.2 Hz. The air is the phone's codec tone. A was not raised. The stub did not supply the modulation. The only static caller of key-up is still `+0x3D710`.

The next image is not built. It would put the DMR modulator around the same square: two-point `RF_MODE`, AT1846S `0x58` = `0xBCFD`, and the DMR `0x30` sequence (common path `0x4006` then `0x4046`, then the DMR branch `0x4006` then `0x4026`, left at `0x4026`, profile `r0` = 0). The FM pair `0x7006` / `0x7026` stays unused. This radio's 12.5 kHz DMR outer symbol, `0x30` left at `0x4026`, is ±3.3 kHz, about 1.7× ±1944 Hz, and the BTECH 6X2 still decodes it. That scale is now in `radio_firmware/HANDOFF.md` on the DMR route. §6 is not met.

End state: factory image, YModem `onSuccess` 23:41:58.545, banner 23:42:14.584, `0x34` = `DMR003.UV4T.V022` at 23:42:14.894, factory MD5 `4426035392262ca54583c230c9e268e0`. The module acked channel 36 (162.425 MHz, band 1, squelch 5, low power) and the app announced NOAA WX4. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (00:36–01:03) — R3a3 puts the TX-RAM square on the air. Silence leaves the square and drops the codec tone.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr`, tag `R3a3`, sha256 `667cfd127d3b403192066da8e67c3633905875a7370a56a4fc379f861d43ea40`, MD5 `e247b7b428e3635e71ef2a3f65ee9670`. The four `bsr 0xe9c` sites in the flash `0x26` handler call `on_key` / `on_unkey` at file `+0x5B000`. `on_key` sets two-point `RF_MODE` `0x10E0`, `WORK_MODE` `0x80`, TX-RAM bit 0, clears `FM_BANDWIDTH` bits 4 and 6, fills +256/−256, writes AT1846S `0x30` = `0x4006` then `0x4026` and `0x58` = `0xBCFD`, and stores PTT. Bit 4 stays clear. `+0x3074` and `+0x3EDFC` stay factory. Twenty tests pass.

Boot capture 143.5 s from 00:36:50, VFO already on 467.625. YModem `onSuccess` 00:39:00.214. `0x34` `DMR003.R3a3.V022` at 00:39:12.867. Hottest bin +0.11 dB, clip 0. The stub does not run at boot. The capture that followed that boot was empty because the HackRF had just been closed; nothing was measured from it. Factory restored (`onSuccess` 00:41:43.451, `0x34` 00:41:56.109).

Second load, same bytes. `onSuccess` 00:46:07.979. `0x34` 00:46:21.386. One 3 s `testtone`: `0x26` launch 1 at 00:46:28.923, `0x36` body `03`, 24000 samples, launch 2, `0x36` body `04`. Carrier 3.45 s, SNR 39.8 dB, clip 0, offset +1028 Hz. Steady window (drop the first 1.0 s): 999.9 Hz sine, amplitude 2399 Hz, rms 1738 Hz, p99 2727 Hz, and the square under it (15.625 Hz fundamental 133 Hz, 3rd 50 Hz, 5th 32 Hz). At 0.1 s the tone is absent (1 kHz line 0.7 Hz) and the square is already there. The first 100 ms is a key-up click, p99 22974 Hz. That click is not the stimulus. A was not raised.

Third load, same bytes, for a silence key. `onSuccess` 00:59:04.301. Banner 00:59:17.881. `0x34` 00:59:18.196. `txwav` of 3 s of zeros: `0x26` launch 1 at 00:59:25.658, `0x36` body `03`, `played 24000 samples`, launch 2, `0x36` body `04` at 00:59:29.395. Carrier 3.44 s, SNR 39.6 dB, clip 0, offset +1022 Hz. Fundamental 129 Hz, 3rd 47 Hz, 5th 30 Hz, evens about 3 Hz. A 40 Hz low-pass of the steady window has rms 104 Hz and median absolute deviation 103 Hz, so the tops are about ±104 Hz, 0.40 Hz per count. The 1 kHz line is 1.2 Hz. Raw p99 469 Hz is the square's edges. From 0.1 s on, the 1 kHz line stays under 5 Hz. The codec path added the sine on the tone key. It does not create the square.

A = 512 is the next image, one 6 dB step, still a silence key. M17 samples wait until that step shows the deviation scaled and still under ±5 kHz. §6 is not met.

**2026-10-24 (01:10–01:16) — R3a4 doubles the square.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-a512` is the R3a3 stub with two immediates changed: `movi r1, 2` (+512) and `movi r1, 254` (−512). sha256 `244cd6b25bb834930df88d57a60bdb4cffc0a49283e6a26e8cde6c30fde755f7`, MD5 `531b07ea6e6781622373894a77d39965`. Twenty-one tests pass. The built file differs from R3a3 at those two bytes and at the tag.

Boot capture 180 s from 01:10:16, VFO already on 467.625. YModem `onSuccess` 01:12:27.557. Banner 01:12:41.438. `0x34` `DMR003.R3a4.V022` at 01:12:41.749. Hottest bin +0.14 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 01:13:43.338, `0x36` body `03`, 24000 samples, launch 2 at 01:13:46.751, `0x36` body `04` at 01:13:47.077. Carrier 3.46 s, SNR 39.6 dB, clip 0, offset +1024 Hz. Fundamental 284 Hz (2.20× the A = 256 fundamental of 129 Hz). Third harmonic 101 Hz, fifth 55 Hz. A 40 Hz low-pass has rms 212 Hz and median absolute deviation 211 Hz, against 104 Hz and 103 Hz at A = 256. The tops doubled. The 1 kHz line is 0.6 Hz. Steady p99 578 Hz, against 469 Hz at A = 256: the edges did not double. The key-up click is again about 23 kHz and is not the stimulus. A was not raised again.

The slope on the tops is 0.41 Hz per count at both amplitudes. ±2.4 kHz would be about 5900 counts if that slope holds, which is inside the ±5 kHz stop and is not yet measured. The next image is A = 1024. §6 is not met.

End state: factory image. YModem `onSuccess` 01:16:03.289. Banner 01:16:16.520. `0x34` `DMR003.UV4T.V022` at 01:16:16.831. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:16:18.712, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (01:22–01:29) — R3a5 doubles the square again.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-a1024` is the R3a4 stub with two immediates changed: `movi r1, 4` (+1024) and `movi r1, 252` (−1024). sha256 `07a76c84abce64ff159fb233499a4090bf52365288dce78b4f46d839f8b07ca5`, MD5 `9b30d2e935e49c4c07608edcfde7bf92`. Twenty-two tests pass. The built file differs from R3a4 at those two bytes and at the tag.

Boot capture 180 s from 01:23:01, VFO already on 467.625. YModem `onSuccess` 01:25:11.158. Banner 01:25:25.191. `0x34` `DMR003.R3a5.V022` at 01:25:25.512. Hottest bin +0.12 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 01:26:27.156, `0x36` body `03`, 24000 samples, launch 2 at 01:26:30.560, `0x36` body `04` at 01:26:30.887. Carrier 3.45 s, SNR 39.3 dB, clip 0, offset +953 Hz. Fundamental 537 Hz. Third harmonic 193 Hz, fifth 122 Hz. A 40 Hz low-pass has rms 438 Hz and median absolute deviation 422 Hz, against 212 Hz and 211 Hz at A = 512. The median doubled. 422 / 1024 = 0.41 Hz per count. The fundamental matches `4A/π` for that plateau. The 1 kHz line is 0.3 Hz. Steady p99 846 Hz, against 578 Hz at A = 512: the edges rose and still did not double. The key-up click is again about 23 kHz and is not the stimulus. A was not raised again.

Three amplitudes now agree at about 0.41 Hz per count on the flat top. ±2.4 kHz would be about 5900 counts if that slope holds, and the edge p99 is still rising, so that count is not the next image. The next image is A = 2048. §6 is not met.

End state: factory image. YModem `onSuccess` 01:28:47.284. Banner 01:28:59.080. `0x34` `DMR003.UV4T.V022` at 01:28:59.395. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:29:01.242, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (01:33–01:39) — R3a6, the rms grows and the flat top lags.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-a2048` is the R3a5 stub with two immediates changed: `movi r1, 8` (+2048) and `movi r1, 248` (−2048). sha256 `57e712c0ab97f438aded0a733f1502f4120a55b8b3b0ed49c30ff704bf3118df`, MD5 `1b9c2c4f8f0b5a9f2320f4cf3bcec479`. Twenty-three tests pass. The built file differs from R3a5 at those two bytes and at the tag.

Boot capture 180 s from 01:33:47, VFO already on 467.625. YModem `onSuccess` 01:35:56.936. Banner 01:36:10.932. `0x34` `DMR003.R3a6.V022` at 01:36:11.242. Hottest bin +0.11 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 01:37:13.013, `0x36` body `03`, 24000 samples, launch 2 at 01:37:16.438, `0x36` body `04` at 01:37:16.768. Carrier 3.47 s, SNR 39.2 dB, clip 0. Median of the keyed deviation +479 Hz; the VFO log still reads 467.625. Fundamental 1213 Hz. Third harmonic 383 Hz, fifth 214 Hz. A 40 Hz low-pass has rms 967 Hz and median absolute deviation 741 Hz, against 438 Hz and 422 Hz at A = 1024. The rms rose by 2.21 (0.47 Hz per count). The median rose by 1.75 (0.36 Hz per count), so the flat top is a smaller part of the cycle. The 1 kHz line is 0.3 Hz. Steady p99 1729 Hz, double the 846 Hz at A = 1024. The key-up click is again about 23 kHz and is not the stimulus. A was not raised again.

The deviation is still growing, and the steady window stayed under ±2 kHz. ±2.4 kHz is not measured. The next image is A = 4096. If these ratios repeat, the low-pass rms would be about 2.1 kHz and the steady p99 about 3.5 kHz. §6 is not met.

End state: factory image. YModem `onSuccess` 01:39:32.773. Banner 01:39:45.065. `0x34` `DMR003.UV4T.V022` at 01:39:45.383. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:39:47.195, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (01:43–01:49) — R3a7, A = 4096, still under the stop.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-a4096` is the R3a6 stub with two immediates changed: `movi r1, 16` (+4096) and `movi r1, 240` (−4096). sha256 `50f8e78986a4efafd288b8d61811e289055ed1aba570278e14e2c6347a2c1354`, MD5 `1b0da45c4510840aa7ac58e9b6cbd601`. Twenty-four tests pass. The built file differs from R3a6 at those two bytes and at the tag.

Boot capture 180 s from 01:43:22, VFO already on 467.625. YModem `onSuccess` 01:45:31.701. Banner 01:45:43.796. `0x34` `DMR003.R3a7.V022` at 01:45:44.107. Hottest bin +0.13 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 01:46:47.552, `0x36` body `03`, 24000 samples, launch 2 at 01:46:50.959, `0x36` body `04` at 01:46:51.288. Carrier 3.45 s, SNR 39.3 dB, clip 0. Median of the keyed deviation −331 Hz; the VFO log still reads 467.625. Fundamental 2227 Hz. Third harmonic 808 Hz, fifth 490 Hz. A 40 Hz low-pass has rms 2266 Hz and median absolute deviation 1462 Hz, against 967 Hz and 741 Hz at A = 2048. The rms rose by 2.34 (0.55 Hz per count). The median rose by 1.97 (0.36 Hz per count). The 1 kHz line is 0.5 Hz. Steady p99 3700 Hz, 2.14× the 1729 Hz at A = 2048. The key-up click is again about 23 kHz and is not the stimulus. A was not raised again.

Another doubling is predicted past the ±5 kHz stop, so A = 8192 was not built. The next image is a 1 kHz sine at peak count 2048. §6 is not met.

End state: factory image. YModem `onSuccess` 01:49:07.225. Banner 01:49:19.335. `0x34` `DMR003.UV4T.V022` at 01:49:19.648. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:49:21.452, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (02:02–02:08) — R3a8, a 1 kHz sine at peak count 2048.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-sine1k` fills the same TX RAM with eight samples, immediates 0, 6, 8, 6, 0, 250, 248, 250, repeated 64 times. sha256 `8436ac95064e9643f034dfdc867dacccdb283752bf705c858f180187c2928147`, MD5 `83b443d97cab5a7757f74da83b69dea6`. Twenty-five tests pass. `on_unkey` is at `+0x5B0A0`. No `+0x3074`, no `+0x3EDFC`, bit 4 clear.

Boot capture 180 s from 02:02:24, VFO already on 467.625. YModem `onSuccess` 02:04:33.673. Banner 02:04:45.784. `0x34` `DMR003.R3a8.V022` at 02:04:46.094. Hottest bin +0.11 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 02:05:49.837, `0x36` body `03`, 24000 samples, launch 2 at 02:05:53.246, `0x36` body `04` at 02:05:53.575. Carrier 3.45 s, SNR 39.1 dB, clip 0. Median of the keyed deviation +1039 Hz; the VFO log still reads 467.625. The 1 kHz line is 923 Hz. The 15.625 Hz line is 3 Hz. The 3 kHz line is 27 Hz, 2.9% of the tone, which is the third harmonic of this 8-sample cycle. A 40 Hz cutoff leaves rms 5 Hz. Steady p99 1217 Hz. The key-up click is again about 23 kHz and is not the stimulus. The peak was not raised.

The sine is on the air and it is not yet near ±2.4 kHz. A linear doubling, peak count 4096, predicts a tone near 1850 Hz and a steady p99 near 2400 Hz. §6 is not met.

End state: factory image. YModem `onSuccess` 02:08:09.502. Banner 02:08:21.899. `0x34` `DMR003.UV4T.V022` at 02:08:22.214. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 02:08:24.024, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (02:12–02:19) — R3a9, the same sine at peak count 4096.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-sine1k-p4096` is the R3a8 stub with six sample immediates changed: 0, 11, 16, 11, 0, 245, 240, 245. sha256 `ebe8144f22e9eb3c7ad9956ac6911b0356592927cfeec1937adb767f8fc28013`, MD5 `ccab6930545b0d35fa38279e7e48bd72`. Twenty-six tests pass. `on_unkey` stays at `+0x5B0A0`. No `+0x3074`, no `+0x3EDFC`, bit 4 clear.

Boot capture 180 s from 02:12:53, VFO already on 467.625. YModem `onSuccess` 02:15:02.396. The first version poll was empty (`0x29050000`); the loader's second start printed the banner at 02:16:12.953 and `0x34` `DMR003.R3a9.V022` at 02:16:13.265. Hottest bin +0.12 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 02:16:39.276, `0x36` body `03`, 24000 samples, launch 2 at 02:16:42.677, `0x36` body `04` at 02:16:43.009. Carrier 3.45 s, SNR 39.0 dB, clip 0. Median of the keyed deviation +1047 Hz; the VFO log still reads 467.625. The 1 kHz line is 1923 Hz, 2.08× the 923 Hz at peak count 2048. The 15.625 Hz line is 3 Hz. The 3 kHz line is 26 Hz and did not grow. Steady p99 2186 Hz, 1.80× the 1217 Hz at half the peak. The key-up click is again about 23 kHz and is not the stimulus. The peak was not raised.

The tone tracked the doubling and is still short of ±2.4 kHz. Peak count 5120 (immediate 20) scales this tone to about 2400 Hz and this p99 to about 2700 Hz, under the stop. §6 is not met.

End state: factory image. YModem `onSuccess` 02:18:59.822. Banner 02:19:11.565. `0x34` `DMR003.UV4T.V022` at 02:19:11.875, on the first poll. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 02:19:13.726, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (02:26–02:32) — R3a10, the same sine at peak count 5120. Tag `R3b0`.** The version field holds four characters, so the tag is not `R3a10`. HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-sine1k-p5120` is the R3a9 stub with six sample immediates changed: 0, 14, 20, 14, 0, 242, 236, 242. sha256 `0861b82a6e82ffd8316e7155c55f566006b0f13f0c5990fe3c726b9fc70e7e39`, MD5 `d72f17a6c5be609311d995ddf71d836e`. Twenty-seven tests pass. `on_unkey` stays at `+0x5B0A0`. No `+0x3074`, no `+0x3EDFC`, bit 4 clear.

Boot capture 180 s from 02:26:21, VFO already on 467.625. YModem `onSuccess` 02:28:30.684. Banner 02:28:44.605. `0x34` `DMR003.R3b0.V022` at 02:28:44.915, on the first poll. Hottest bin +0.16 dB, clip 0.

One 3 s silence key. `0x26` launch 1 at 02:29:46.509, `0x36` body `03`, 24000 samples, launch 2 at 02:29:49.919, `0x36` body `04` at 02:29:50.245. Carrier 3.46 s, SNR 39.1 dB, clip 0. Median of the keyed deviation +1036 Hz; the VFO log still reads 467.625. The 1 kHz line is 2261 Hz, 1.18× the 1923 Hz at peak count 4096, short of the 1.25× rise in the peak. The 15.625 Hz line is 3 Hz. The 3 kHz line fell to 14 Hz. Steady p99 2674 Hz, 1.22× the 2186 Hz at the previous peak. The key-up click is again about 23 kHz and is not the stimulus. The peak was not raised.

The tone is 6% under ±2.4 kHz and the steady p99 is 11% over it. The sine is smooth. The next fill keeps every sample at or below count 5120, the peak whose steady p99 was 2674 Hz. §6 is not met.

End state: factory image. YModem `onSuccess` 02:32:06.360. Banner 02:32:18.323. `0x34` `DMR003.UV4T.V022` at 02:32:18.633, on the first poll. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 02:32:20.450, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (02:48–03:01) — R4a, a fixed RRC 4FSK pattern at peak count 5120. Tag `R4a0`.** HackRF receive only, 467.625 MHz, low power. Tables: `radio_firmware/results.md`.

`c7000-txram-dmr-rrc` keeps the sine's host-key path. The stub is 180 bytes at `+0x5B000` (`on_unkey` at `+0x5B080`) and the fill is 512 halfwords at `+0x5C000`. sha256 `9271b363eeda6e6ad6625007e98bd25795eb05c1f3e22c23bac1fc6951fac653`, MD5 `049ff4ed685179c3392a5931b9ca5e9b`. Twenty-eight tests pass. No `+0x3074`, no `+0x3EDFC`, bit 4 clear. The symbols, repeated, are +3, +1, −1, −3, +3, −1, shaped with RRC α = 0.5 at 4800 symbols/s and 8 kHz. The ten-sample period's signed immediates are 19, 12, 2, −2, −12, −20, 7, 20, −7, 1, so the aired peak is ±5120. Samples 510 and 511 repeat samples 0 and 1.

Boot capture 180 s from 02:48:57, VFO already on 467.625. YModem `onSuccess` 02:51:06.463. Banner 02:51:20.359. `0x34` `DMR003.R4a0.V022` at 02:51:20.671, on the first poll. Hottest bin +0.18 dB, clip 0. That bin is spread across ±24 kHz.

One 3 s silence key. `0x26` launch 1 at 02:52:22.179, `0x36` body `03`, 24000 samples, launch 2 at 02:52:25.579, `0x36` body `04` at 02:52:25.911. Carrier 3.44 s, SNR 39.5 dB, clip 0. Median of the keyed deviation +908 Hz; the VFO log still reads 467.625. The 1 kHz line is 17 Hz. The 15.625 Hz line is 11 Hz. Steady p99 2774 Hz. The key-up click is again about 23 kHz and is the edge, and the steady window stayed under the ±5 kHz stop. The peak was not raised.

The half-second alignment in the capture log does not lock. The extra pair walks the phase, and the long-term line is 796.875 Hz (1152 Hz), with the 800.0 Hz bin at 1 Hz. On the first 0.25 s the autocorrelation is 0.96 at a lag of 60 samples. Ten-millisecond stretches follow the stored shape inverted: median r² 0.96, 36 of 43 at or above 0.95, gain −0.54 Hz per count. A positive gain reaches median r² 0.14. A zero-order hold of the ten levels reaches median r² 0.84, and no stretch reaches 0.95, so four held levels are absent. §6 is not met.

End state: factory image, on the second restore. The first YModem ended `Received CAN` at 02:53:09.509 and the next two waits returned no `0x34`. The second load's `onSuccess` was 02:59:49.055. `0x34` `DMR003.UV4T.V022` at 03:00:58.517, after the loader's second SignalDeck start. The tool log has no banner line for this restore. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 03:00:59.876, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 — T2, `WORK_MODE` 0x22, read only.** No image, no key. Tables: `radio_firmware/results.md`.

The stores at `+0x179C8` and `+0x17D54` write `WORK_MODE` (`0x11000100`) = `0x22` when byte 3 of the struct at `0x34808` is nonzero, and the byte-4 path starts the same store. The first copy then writes `0x1100039c` = `0x1800`, `0x11000400` = `0x40`, `0x11000408` = `0x41` and returns. The second writes `0x1100039c` = `0x800` and the same `0x40` / `0x41`. The first copy's byte-4 path writes `0x22`, `0x11000400` = `0x82`, and `0x11000408` = 1. When both bytes are zero the first copy stores `0x6A` if byte 2 is 4, otherwise `0x6E`. None of these paths write a symbol buffer, `RF_MODE`, or `FM_BANDWIDTH`. The sibling HR-C7000 notes name no raw-symbol register and no RRC coefficient; `RF_MODE[7]` stays the deviation-map bit, and the only full-word `RF_MODE` store on record is `0x10E0`. Bytes 3 and 4 are unnamed (the literal `0x34808` occurs 141 times), so it is unread whether a normal channel takes the `0x22` path. T2 does not, on this reading, accept host symbols. It is not closed, and no `0x22` image was built. §6 is not met. The radio was left as the R4a restore left it.

**2026-10-24 — T2, bytes 3 and 4 of `0x34808`.** No image, no key. Tables: `radio_firmware/results.md`.

Byte 3 is the BER-test select and byte 4 stays 0. The initializer at `+0x11E0` is the only writer of the pair: flag `0x324D7` = 1 writes byte 3 = 1 and byte 4 = 0, flag 2 would write the opposite, and every other value writes both 0. The flag has five references and none of them stores 2. Command `0x3F` (`TEST_BIT_ERROR_RATE`) sets the flag to 1 for body byte 1 (`宏睿误码率测试`, file `+0x38444`) and for body byte 2 (`o.153误码率测试`, file `+0x38454`); the OEM BER screen sends 2. Both channel setups call `+0x11E0` first. The flag lives in the zeroed range `0x31AF4`–`0x4DAB0`, so a normal channel leaves both bytes 0 and the first setup stores `WORK_MODE` `0x6A` or `0x6E`. The helpers `+0x18218`, `+0x186BC`, `+0x28904` and `+0x19438` write control registers and status bytes and return. No symbol buffer is filled on either path. A FIFO the CPU never touches is still unnamed. T2 is closed. No `0x22` image. §6 is not met. The radio was left as the R4a restore left it.

**2026-10-24 — T3, AT1846S registers, read only.** No image, no key. Tables: `radio_firmware/results.md`.

Every `bsr 0xFD011220` was checked. One write does not take its register number from `movi`: `at1846_apply_bw_profile` at `+0x2B30`, and of the asked set that table carries only `0x3A` (`0x00C3` at 12.5 kHz, `0x04C3` at 25 kHz). `0x35` and `0x36` have no access. Programming Guide 1.4 register 30h bit 10 is `direct_reg` ("1=enable direct_reg", with no further definition; the same page uses that wording for an override of `tx_adc_reset` and of `dsp_resetn`). Bit 10 is clear in every `0x30` immediate, and the read-modify-writes set tail-elim, tx, rx, or chip power. Guide section 5 `3aH[14:12]` is 000 (Tx nothing) or 100 (microphone) in every stored value, including the profile rows; the `+0x31E4` AND with `0x8FFF` clears those three bits and then restores the saved halfword. The OpenRTX web table instead puts the voice source on `0x3C[15:14]`. The image's `0x3C` stores are `0x0407` (init, tune, and the 12.5 kHz profile) and `0x1930` (25 kHz profile); both have bits 15:14 = 00, the table's microphone setting, not the inner sine and not GPIO `code_in`. `0x41` bits 6:0 are a caller byte or the constants 15, 48, and 5 (the guide calls them `voice_gain_tx`; the OpenRTX table calls the whole register a VOX threshold). `0x42` is only `0x1036` and `0x1052` (OpenRTX: VOX close; the guide does not list the register). `0x43` is the `0x00BB` / `0x0100` pair already in §11. `0x44` writes are one gain word, and the image uses bits 11:8, which the guide calls `gain_tx`. No stored value is a sample input or a tone path. T3 is closed. No image. §6 is not met. `0x3D` still waits. The radio was left as the R4a restore left it.

**2026-10-24 — R-A, C7000 receive symbols, read only.** No image, no key. Tables: `radio_firmware/results.md`.

`+0x2A4C` is the byte copy from `r0 + 0x160004B0`. Twenty-six calls, every `r0` a constant. The copies of 12, 9, and 5 bytes, and the 12/18/24-byte arm at `+0x1E1CA`, end before `0x160004E0`. The one copy that starts there is 36 bytes, inside `+0x27E50`, and both callers are the BER scorer `+0xAD64`. That function XORs 33 of the bytes (264 bits) against the ROM patterns at file `+0x38488` and `+0x384AC` and, every 100 calls or once the count passes 119, emits a 6-byte score through `family21_emit` with subcommand 34 (`68 21`). The payload stays on the MCU. The scorer runs from flag value 8 of `0x37744` in the task at `+0xC084`; command `0x3F` selects the pattern and does not call it. The OEM dispatcher registers command 63 and does not register `0x21`. The 27-byte records copied from inside the same window land at `0x4D3AD + n*27` and then at `0x4D49E`; the image does not name them, and they are not a `reply_build` argument. `+0x2A18` writes 27-byte records the other way, into modem RAM (`+0x2AAB2` uses offset 48, so `0x16000030`). `+0xBFE8`, `+0xC010`, and the command-14 loop at `+0xC040` have no caller and no XIP pointer. No `lrw` names `0x160004E0` or `0x160008DF`. The modem words that were opened (`0x11000390`, `0x11000394`, `0x1100041C`, `0x11000104`) are single control or status words. R-A is closed: this image has no host symbol FIFO and no discriminator-sample buffer on the UART. No image. §6 is not met. `0x3D` still waits. The radio was left as the R4a restore left it.

**2026-10-24 — T2, `RF_MODE` and the filter controls, read only.** No image, no key. Tables: `radio_firmware/results.md`.

The only full-word immediate store of `RF_MODE` (`0x11000104`) is the FM key-up at `+0x3EDDA`: `movi r3, 135; lsli r3, 5`, which is `0x10E0`. The key-up saves the previous word to SRAM `0x32520` at `+0x3ECCC`, and the restore at `+0x3EE74` writes it back. The bits set are 12, 7, 6, and 5. Bits 6:5 are two-point. Bit 10 is clear, so the built-in 40 Hz square stays off. Bit 9 is clear (Document 2's 1.65 V ramp start). Bit 7 is set. Document 2 names that bit `rf_transiq_mode`: 0 keeps the sign (+3 → +1944 Hz, +1 → +648 Hz) and 1 reverses it (+3 → −1944 Hz, +1 → −648 Hz). The magnitudes stay ±1944 and ±648. The guide lists the bit's reset as 1, and this store writes 1. The guide's physical-layer TX example is `0x60`; this image stores `0x10E0` and does not store `0x60`. M17's ±2400 Hz outer is not a value on that map. Bit 12 is set and unnamed. The same function stores `WORK_MODE` = `0x80`; that bit 7 is the FM select on a different register. An earlier paragraph reads bit 7 of this `0x10E0` as clear; the store sets it, and that paragraph is left as written. The `0x22` path still writes neither `RF_MODE` nor `FM_BANDWIDTH`. Channel setup does not store `RF_MODE`, so the measured DMR outer of about ±3.3 kHz is not this word. No literal and no constructed address reaches `FM_BANDWIDTH` (`0x11000500`) or `FM_DEV_COEF` (`0x11000504`). They stay at reset (`0x5F`, band-pass and pre-emphasis on; `fm_dev_coef_t` = `0x10`). UVm3, UVm7, and UVm8 already showed those writes do not shape the HackRF audio. No RRC coefficient is stored. The α = 0.5 pattern that was on the air was the R4a host PCM fill. `0x11000560` stored as 1 at `+0x3EE00` is PTT, saved and restored with `RF_MODE`. The symbol-map and filter question is closed. No image. §6 is not met. `0x3D` still waits. The radio was left as the R4a restore left it.

**2026-10-24 — T2, symbol buffer, read only.** No image, no key. Tables: `radio_firmware/results.md`.

`+0x2A18` copies `r2` bytes from the caller's pointer to `r0 + 0x16000000`. Twenty-three calls, every offset and every length a constant. The lengths are 36, 24, 9, 4, 2, and 27. Four pairs write 36 bytes at offset 0 and again at offset 36; three of those pairs fill the source with `0x5F` first, and the pair at `+0x8148` copies the stack buffer when the byte at `(r5, 0x19)` is 4. Three calls write 24 bytes at offset 0 from the pointer at `(r8−4)` plus 5. Six calls write 9 bytes at offset 0 from `0x4D43E`, `0x4D486`, or `0x4D435`. Two calls write 4 bytes from `0x4D411` at offset 41, and one writes two zero bytes there, selected by byte `0x12` of `0x34808`. The three 27-byte calls (`+0x2AAB2`, `+0x2ABAE`, `+0x2ADB0`) use offset 48, so the destination is `0x16000030`, and the source is `0x4D49E + n*27`. That is the unnamed record R-A already read, written once. The 36-byte copy at offset 36 also covers the first 24 bytes of the TX window. No length is 256, 512, or 1024, and no call repeats. No `lrw` names `0x16000030` or `FM_ADDR_SW`. The only literal of PTT (`0x11000560`) is the FM key-up's save, its store of 1 at `+0x3EE00`, and the restore. Nothing holds that bit while a buffer drains. T2 is closed: this image has no host symbol FIFO. No image. §6 is not met. `0x3D` still waits. The radio was left as the R4a restore left it.

**2026-10-24 — R4b, one M17 link-setup frame, tag `R4b0`.** The R4a stub is unchanged. The table at `+0x5C000` is 108 symbols of the `0x77` preamble, the 192-symbol link-setup frame, and six symbols of filter tail. Stored counts are `-round(Hz / 0.54)`, peak count 6451, linear prediction 3548 Hz at 0.55 Hz per count. Silent boot. One 3 s silence key, low power, 467.625 MHz. Steady p99 3148 Hz. The aired wave matches the aimed waveform at r² 0.81, gain 0.79, polarity positive. The plain decoder accepted that frame on 43 of 43 loops. No stream frame follows it: the 512-sample loop is 64 ms, and a stream frame needs the next sync at 40 ms. §6 is not met. `0x3D` still waits. End state: factory image, banner 04:43:02.951, `0x34` `DMR003.UV4T.V022` at 04:43:03.271, VFO 467.625 / 467.625 FM at 04:43:05.143, low power, no `DMRDEBUG.bin`.

**2026-10-24 — FM refill interrupt, read only.** No image, no key. `fm_tx_interp` is bit 15 of `SYS_INTERP_LIST` (`0x11000398`). Mask bit 15 at `0x1100039C` blocks when it is 0. The normal path stores `0x1007F`, so bit 15 is blocked. The service task is file `+0x18A70` (entry `0x03032A70`, created at `+0x1C92`). It clears the bit and dispatches bits 0–6, 11, 12, and 16. It does not copy TX RAM. The poster of its semaphore is `+0x54BB0`, and that address is not a stored pointer, so the PIC slot is still unnamed. A host-key stub can refill without that slot: poll `FM_ADDR_SW` during the gated `0x26` key and copy the next half from the zero tail past `+0x5AEFC`. The first image should be that poll, at or below the R4b peak count of 6451, and should not hook `+0x18A70`. §6 is not met. The radio was left as the R4b restore left it.

**2026-10-24 — R4c, tag `R4c0`, the gated poll returns before the carrier.** The stub at `+0x5B000` copies the first 512 samples, sets PTT, then polls `FM_ADDR_SW` until the 2430-sample table and two zero halves are written. Peak count 6451, linear prediction 3548 Hz. Silent boot (peak 0.12 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 at 05:24:23.199, ack at 05:24:23.557 (358 ms), `SEND_START` at 05:24:23.564. R4b's same launch acked in 5 ms and the prefill then looped. Here the carrier (3.11 s, SNR 38.7 dB, clip 0, offset +1049 Hz) was unmodulated: steady p99 371 Hz, burst p99 346 Hz, 64 ms correlation 0.021, aimed-waveform r² 0. The key-up click p99 is 23084 Hz and is not a stop. The poll finished before the modulator started, so the air looped the zero tail. The first 512 samples never reached the air. The peak was not raised. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 05:27:02.250, VFO 467.625 / 467.625 FM at 05:27:04.069, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4d, tag `R4d0`, the wake refill plays one M17 stream.** `on_key` copies the first 512 samples, sets PTT, stores a cursor at IRAM `0x4DAAC`, sets mask bit 15, and returns. The cursor is 0 at boot. The hooks are the per-wake calls at file `+0x18B5C` and `+0x18B68`. The task entry `+0x18A70` is unchanged. A set cursor copies 256 samples into the half `FM_ADDR_SW` names, then two zero halves. Peak count 6451, linear prediction 3548 Hz. Silent boot (peak 0.13 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 06:12:41.314, 5 ms after the wav log, `SEND_START` at 06:12:41.319. The carrier (3.47 s, SNR 39.0 dB, clip 0, offset +1049 Hz) carries the 304 ms table once: 20 ms slices from 0.04 s through 0.30 s have p99 2892–3321 Hz, and from 0.34 s the carrier is the zero tail. Steady p99 408 Hz is that tail. The key-up click p99 is 22776 Hz and is not a stop. There is no 64 ms loop (correlation −0.023). A decode of the whole carrier locks the click (score 0.946 at 15 ms, frame number 31643, CRC false). A decode of 0.04–0.40 s accepts the link setup, both callsigns match the research modem's bench callsign, and the frames are 0, 1, 2, 3, 4, and `0x8005`, Golay error 0. The aimed-waveform fit on 0.04–0.36 s is r² 0.877, polarity +1, gain 0.825. The peak was not raised. The table already fills the file, so the next image wraps the stream-frame cursor until unkey. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 06:15:20.787, VFO 467.625 / 467.625 FM at 06:15:22.616, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4e, tag `R4e0`, the wake refill loops the M17 stream until unkey.** Same four `0x26` sites and the same two wake sites as R4d. `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The stub is 368 bytes at `+0x5B000`. The cursor still lives at IRAM `0x4DAAC` and is 0 at boot. A wake copies 256 samples. At sample 2420, the six-symbol tail, the cursor wraps to sample 500, the first stream frame, inside the same half. There are no zero halves. The task entry `+0x18A70` is unchanged. The table is the R4d stream, peak count 6451, linear prediction 3548 Hz. Silent boot (peak 0.11 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 06:41:16.829, 4 ms after the wav log, `SEND_START` at 06:41:16.835. The carrier (3.45 s, SNR 39.3 dB, clip 0, offset +1383 Hz) stays modulated: steady p99 3075 Hz, and every 100 ms slice from 0.1 s through 3.3 s has p99 2959–3168 Hz. The 240 ms autocorrelation is 0.993. The key-up click p99 is 22987 Hz and is not a stop. A decode of 0.04–1.20 s accepts the link setup, both callsigns match the research modem's bench callsign, and 27 stream frames, Golay error 0, payloads zero. A decode from 1.0 s accepts 53 stream frames, Golay error 0, payloads zero. Frame numbers are only 0, 1, 2, 3, 4, and `0x8005`. The aimed-waveform fit on 0.04–1.20 s is r² 0.888, polarity +1, gain 0.83. The peak was not raised. The end-of-transmission frame repeats every loop, so the next image loops frames 0–4 only. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 06:43:56.776, VFO 467.625 / 467.625 FM at 06:43:58.625, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4f, tag `R4f0`, the wake refill loops frames 0–4 until unkey.** Same four `0x26` sites and the same two wake sites as R4e. `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The stub is 368 bytes at `+0x5B000`. The cursor still lives at IRAM `0x4DAAC` and is 0 at boot. A wake copies 256 samples. At sample 2100, the six-symbol tail, the cursor wraps to sample 500, the first stream frame, inside the same half. There are no zero halves. The task entry `+0x18A70` is unchanged. The table is the preamble, the link setup, and frames 0–4, 2110 samples, peak count 6451, linear prediction 3548 Hz. There is no frame `0x8005`. Silent boot (peak 0.15 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 07:01:24.234, 4 ms after the wav log, `SEND_START` at 07:01:24.240. The carrier (3.45 s, SNR 39.3 dB, clip 0, offset +1393 Hz) stays modulated: steady p99 3095 Hz, and every 100 ms slice from 0.1 s through 3.3 s has p99 2974–3210 Hz. The 200 ms autocorrelation is 0.991. The key-up click p99 is 22918 Hz and is not a stop. A decode of 0.04–1.20 s accepts the link setup, both callsigns match the research modem's bench callsign, and 27 stream frames, Golay error 0, payloads zero. A decode from 1.0 s accepts 53 stream frames, Golay error 0, payloads zero. Frame numbers are only 0, 1, 2, 3, and 4. The aimed-waveform fit on 0.04–1.20 s is r² 0.886, polarity +1, gain 0.83. The peak was not raised. The 16-byte payloads are zeros, so the next image sets them to the bytes 0 through 15. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 07:04:04.105, VFO 467.625 / 467.625 FM at 07:04:05.920, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4g, tag `R4g0`, the wake refill loops frames 0–4 with payload bytes 0 through 15.** Same four `0x26` sites and the same two wake sites as R4f. The stub instructions match R4f. `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The stub is 368 bytes at `+0x5B000`. The cursor still lives at IRAM `0x4DAAC` and is 0 at boot. A wake copies 256 samples. At sample 2100, the six-symbol tail, the cursor wraps to sample 500, the first stream frame, inside the same half. There are no zero halves. The task entry `+0x18A70` is unchanged. The table is the preamble, the link setup, and frames 0–4, 2110 samples, peak count 6451, linear prediction 3548 Hz. The 16 payload bytes are 0 through 15. There is no frame `0x8005`. Silent boot (peak 0.11 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 07:19:29.457, 7 ms after the wav log, `SEND_START` at 07:19:29.463. The carrier (3.45 s, SNR 47.4 dB, clip 0, offset +1124 Hz) stays modulated: steady p99 2886 Hz, and every 100 ms slice from 0.1 s through 3.3 s has p99 2880–2957 Hz. The 200 ms autocorrelation is 0.997. The key-up click p99 is 22905 Hz and is not a stop. A decode of 0.04–1.20 s accepts the link setup, both callsigns match the research modem's bench callsign, and 27 stream frames, Golay error 0. Every 16-byte payload is the bytes 0 through 15. A decode from 1.0 s accepts 53 stream frames, Golay error 0, with those same payload bytes. Frame numbers are only 0, 1, 2, 3, and 4. The aimed-waveform fit on 0.04–1.20 s is r² 0.886, polarity +1, gain 0.83. The peak was not raised. LICH part 5 is still absent, so the next image adds frame 5 with the end bit clear. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 07:22:13.197, VFO 467.625 / 467.625 FM at 07:22:14.810, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4h, tag `R4h0`, the wake refill loops frames 0–5 with the end bit clear.** Same four `0x26` sites and the same two wake sites as R4g. The stub instructions match R4g except the wrap address. `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The stub is 368 bytes at `+0x5B000`. The cursor still lives at IRAM `0x4DAAC` and is 0 at boot. A wake copies 256 samples. At sample 2420, the six-symbol tail, the cursor wraps to sample 500, the first stream frame, inside the same half. There are no zero halves. The task entry `+0x18A70` is unchanged. The table is the preamble, the link setup, and frames 0–5, 2430 samples, peak count 6451, linear prediction 3548 Hz. Frame 5 carries LICH part 5, and its end bit is clear. The 16 payload bytes are 0 through 15. There is no frame `0x8005`. Silent boot (peak 0.15 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 07:39:28.328, 6 ms after the wav log, `SEND_START` at 07:39:28.334. The carrier (3.47 s, SNR 49.4 dB, clip 0, offset +1096 Hz) stays modulated: steady p99 2909 Hz, and every 100 ms slice from 0.1 s through 3.3 s has p99 2896–3014 Hz. The 240 ms autocorrelation is 0.995. The key-up click p99 is 22976 Hz and is not a stop. A decode of 0.04–1.20 s accepts the link setup, both callsigns match the research modem's bench callsign, and 27 stream frames, Golay error 0. Every 16-byte payload is the bytes 0 through 15. A decode from 1.0 s accepts 54 stream frames, Golay error 0, with those same payload bytes. Frame numbers are 0, 1, 2, 3, 4, and 5. The aimed-waveform fit on 0.04–1.20 s is r² 0.889, polarity +1, gain 0.83. The peak was not raised. The loop never sets the end bit, so the next image sends one frame with the end bit set when the key ends, and that frame is not in the loop. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 07:42:11.962, VFO 467.625 / 467.625 FM at 07:42:13.659, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4i, tag `R4i0`, the end frame waits inside the unkey handler.** Same four `0x26` sites and the same two wake sites as R4h. The loop table and peak count 6451 are unchanged. The end frame is 320 samples at file `+0x5B170`, peak count 6337, and it is not in the loop. `on_unkey` sets bit 31 of the cursor and waits in `play_eot` until the cursor is 0. Silent boot (peak 0.13 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 08:51:27.962, 5 ms after the wav log, `SEND_START` at 08:51:27.968. The unkey ack is at 08:51:32.228, 867 ms after the unkey command, the full 1200-tick wait, and `SEND_STOP` is 11 ms later. The carrier is up for 4.30 s, SNR 30.3 dB, steady p99 3257 Hz. The key-up click p99 is 23024 Hz and is not a stop. Slices from 0.1 s through 4.1 s stay at the stream deviation, p99 2898–3635 Hz. A decode of 0.04–1.20 s accepts the link setup, both callsigns match the research modem's bench callsign, and 27 stream frames, Golay error 0, payload bytes 0 through 15. A decode from 1.0 s accepts 61 such frames and then one frame 0 with Golay error 7. There is no `0x8005`. From 3.54 s the half-second windows accept nothing. The handler had not returned, so the wake stopped filling and the last half held the deviation until the timeout. The aimed-waveform fit on 0.04–1.20 s is r² 0.864, polarity +1, gain 0.83. The peak was not raised. The next image sets the end bit and returns from `on_unkey`, and the wake drops PTT when the cursor reaches 0. §6 is not met. `0x3D` still waits. End state: factory image, `0x34` `DMR003.UV4T.V022` at 08:54:12.828, VFO 467.625 / 467.625 FM at 08:54:14.595, low power, no `DMRDEBUG.bin`.

**2026-10-24 — R4j, tag `R4j0`, the end frame is on the air after `on_unkey` returns.** Same four `0x26` sites and the same two wake sites as R4i. The loop table and peak count 6451 are unchanged. The end frame is 320 samples at file `+0x5B170`, peak count 6337, and it is not in the loop. `on_unkey` sets bit 31 of the cursor and returns. It does not call `0xE9C`. When the cursor reaches 0, `drop_ptt` clears PTT, the voice bit, and mask bit 15, and restores the two AT1846S words. The stub stays 368 bytes. Silent boot (peak 0.13 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 09:25:26.147, 5 ms after the wav log, `SEND_START` at 09:25:26.153. The unkey ack is at 09:25:29.539, 5 ms after the unkey command. The log has no `SEND_STOP`. The carrier is up for 3.76 s, SNR 43.1 dB, and falls 0.39 s after that command. Steady p99 2914 Hz. Slices from 0.1 s through 3.3 s stay at the stream deviation, p99 2886–2996 Hz, and 50 ms slices from 2.80 s through 3.65 s stay at 2910–3066 Hz. The key-up click p99 is 22781 Hz and the drop click at 3.70 s is 23392 Hz. Neither is a stop. A decode of 0.04–1.20 s accepts the link setup, both callsigns match the research modem's bench callsign, and 27 stream frames, Golay error 0, payload bytes 0 through 15. A decode from 1.0 s accepts 61 such frames, Golay error 0. A sync search finds one frame `0x8005` at 3.685 s, score 0.997, Golay error 0, the same payload bytes, immediately after frame 5. The runner's last-0.8 s window locked a sync at score 0.911 and did not report it. The aimed-waveform fit on 0.04–1.20 s is r² 0.889, polarity +1, gain 0.83. The peak was not raised. §6 is not met. `0x3D` still waits. End state: R4j0 stays loaded, VFO 467.625 / 467.625 FM at 09:25:49.264, low power, no `DMRDEBUG.bin`.

The owner asked for the factory image after that key. It was loaded over R4j0. Banner at 09:45:33.282. `0x34` `DMR003.UV4T.V022` at 09:45:33.593. VFO 467.625 / 467.625 FM at 09:45:35.253, low power. No `DMRDEBUG.bin`. Nothing was keyed.

**2026-10-24 — R4k, tag `R4k0`, the wake posts the transmit-stop status.** Same image as R4j, plus one call. `drop_ptt` posts status byte 4 through file `+0x7E08` after it clears PTT. That function stores the byte at RAM `0x38EF2` and wakes the sender at file `+0x7BC0`, which emits `0x36` with that body. It does not call `0xE9C`. Silent boot (peak 0.16 dB). One 3 s silence key, 467.625 MHz, low power. Launch 1 ack at 10:49:34.630, 5 ms after the wav log, `SEND_START` at 10:49:34.636. The unkey ack is at 10:49:38.032, 5 ms after the unkey command. `SEND_STOP` is at 10:49:38.344, 312 ms later. The carrier is up for 3.76 s, SNR 56.9 dB, steady p99 2922 Hz. The key-up click p99 is 23040 Hz and the drop click is 23160 Hz. Neither is a stop. A decode from 0.04 s accepts 27 stream frames, Golay error 0, and the window from 1.0 s accepts 61. A sync search finds one frame `0x8005` at 3.686 s, score 0.999, Golay error 0, payload bytes 0 through 15. The peak was not raised. §6 is not met. `0x3D` still waits. End state: R4k0 stays loaded, VFO 467.625 / 467.625 FM at 10:49:54.172, low power.

**2026-10-24 — R4l, tag `R4l0`, command `0x40` placed in a data table.** The dispatch index is `cmd - 0x22`. `0x3D` already has a handler at file `+0xAAFE` and was left alone. `0x40` was an empty pop. The table slot was pointed at a 20-byte ack thunk written into the zeros at `+0x35F64`. Those zeros follow a run of `0x01` bytes and are part of that table. YModem `onSuccess` at 11:21:50.172. No `0x34` answer. Factory restored: `0x34` `DMR003.UV4T.V022` at 11:27:03.083, VFO 467.625 at 11:27:05.024. Nothing was keyed. Do not reload this image. §6 is not met.

**2026-10-24 — R4m, tag `R4m0`, command `0x40` acks from the unused gap.** Same 20-byte thunk, linked at file `+0x5AEFC`. The dispatch word at `+0x382B8` is runtime `0x03074EFC`. The thunk calls file `+0x8E7C` with `r1 = 0` and does not key. `0x3D` is unchanged. No HackRF capture. VFO 467.625 at 11:32:56.669 before the load. YModem `onSuccess` at 11:35:09.348. The first `0x34` had no answer and the loader power-cycled the module. Banner `开机初始化完成` at 11:35:21.611. `0x34` `DMR003.R4m0.V022` at 11:35:21.922. The loader wrote channel 36, and the VFO was put back at 11:35:23.839. One command `0x40`, body byte 1, at 11:35:27.838. The reply at 11:35:27.844 is `rw=0 sr=0 len=0`, 6 ms later. The log has no `0x26` and no `0x36`. The image stays loaded. VFO 467.625 / 467.625 FM at 11:35:29.955, low power. §6 is not met.

**2026-10-24 — R4n, tag `R4n0`, command `0x40` echoes its first body byte.** A 62-byte handler at file `+0x5AEFC` reads frame offset 8, checksums a 10-byte reply through file `+0x8E5C`, and sends it through file `+0x7DE8`. It does not key. `0x3D` is unchanged. No HackRF capture. VFO 467.625 at 11:46:07.739 before the load. YModem `onSuccess` at 11:48:20.093. The first `0x34` had no answer and the loader power-cycled the module. Banner `开机初始化完成` at 11:48:33.212. `0x34` `DMR003.R4n0.V022` at 11:48:33.523. The loader wrote channel 36, and the VFO was put back at 11:48:35.181. Body `01` at 11:49:16.920 came back `len=1 [01]` at 11:49:16.925. Body `5A` at 11:49:18.480 came back `len=1 [5A]` at 11:49:18.486. The log has no `0x26` and no `0x36`. The image stays loaded. VFO 467.625 / 467.625 FM at 11:49:20.082, low power. §6 is not met.

**2026-10-24 — R4o, tag `R4o0`, command `0x40` stores samples and the wake plays them.** The handler at `+0x5AEFC` copies little-endian int16 samples into RAM `0x4A800`, clamps them to ±6451, and does not set PTT. A clear cursor at `0x4DAAC` makes the wake return. Boot peak 0.28 dB, no +10 dB run. YModem `onSuccess` at 12:04:30.609. `0x34` `DMR003.R4o0.V022` at 12:04:43.863. One command stored 64 samples of a 1 kHz sine at count 2048 and echoed count 64 at 12:05:08.396. It did not key. One 3 s silence key, low power, 467.625 MHz. The ack returned in 6 ms and `SEND_START` followed in 5 ms. The unkey ack returned in 5 ms and `SEND_STOP` followed 323 ms later. The click, 0–40 ms, is not a stop. The tone window, 60–100 ms, has p99 4495 Hz and a 1 kHz line, under 5 kHz. From 120 ms the p99 is about 100 Hz. The IQ clip fraction is 0.42. The peak was not raised. The image stays loaded. VFO 467.625 / 467.625 FM at 12:05:19.439, low power. §6 is not met.

**2026-10-24 — R4p, tag `R4p0`, command `0x40` stores an M17 waveform in pieces.** The body is a sample offset and then int16 samples, clamped to ±6451, written at RAM `0x4A400`. It does not key. A host key plays the buffer once and the wake writes zero halves after it. Boot peak 0.42 dB. YModem `onSuccess` at 12:24:57.394. `0x34` `DMR003.R4p0.V022` at 12:25:11.041. Four pieces stored 1470 samples: preamble, one link setup, three stream frames, and a short tail. Peak count 6451, linear prediction 3548 Hz. The first 500 samples match the canned table. One silence key at that peak: the ack returned in 7 ms, and from 60 ms through 220 ms the p99 is about 4500 Hz, then about 95 Hz. A second key at peak count 4096 aired the same 4500 Hz reading. Clip fraction 0 on both. The plain decoder does not accept a link setup. The aimed-wave fit is r² 0.31. The peak was not raised. The image stays loaded. VFO 467.625 / 467.625 FM at 12:30:21.974, low power. §6 is not met.

**2026-10-24 — R4q, tag `R4q0`, command `0x40` stores samples in TX-RAM byte order.** The R4o handler, with the store loop changed: the signed sample is clamped to ±6451, then the high byte is written at the low address. It does not key. Boot peak 0.06 dB, no +10 dB run. YModem `onSuccess` at 12:42:03.985. Banner `开机初始化完成` at 12:42:17.294. `0x34` `DMR003.R4q0.V022` at 12:42:17.604. One command stored 64 samples of a 1 kHz sine at count 2048 and echoed count 64 at 12:42:42.355. It did not key. One 3 s silence key, low power, 467.625 MHz. The ack returned in 6 ms and `SEND_START` followed in 6 ms. The unkey ack returned in 6 ms and `SEND_STOP` followed 319 ms later. The click, 0–40 ms, is not a stop. The 60 ms slice is a 970 Hz line and p99 1106 Hz. The 80 ms slice is a 972 Hz line and p99 1040 Hz. Both are inside 15 percent of the R3a8 923 Hz line and 1217 Hz p99. From 120 ms the p99 is about 100 Hz. Clip fraction 0. The peak was not raised. The image stays loaded. VFO 467.625 / 467.625 FM at 12:42:53.391, low power. §6 is not met.

**2026-10-24 — R4r, tag `R4r0`, the R4p body stored in TX-RAM byte order.** The piece store is unchanged except the sample loop, which clamps the signed value and writes the high byte at the low address. It does not key. Boot peak 0.05 dB, no +10 dB run. YModem `onSuccess` at 12:50:27.733. Banner `开机初始化完成` at 12:50:41.448. `0x34` `DMR003.R4r0.V022` at 12:50:41.759. Four pieces stored 1470 samples and echoed counts 398, 796, 1194, and 1470. One 3 s silence key, low power, 467.625 MHz. The ack returned in 6 ms and `SEND_START` followed in 5 ms. The unkey ack returned in 5 ms and `SEND_STOP` followed 327 ms later. The click, 0–40 ms, is not a stop. From 60 ms through 220 ms the p99 is 2817–3086 Hz. From 240 ms the p99 is 91 Hz. Clip fraction 0. The link-setup sync at 70 ms scores 0.998 and its CRC passes. Both callsigns match the research modem's bench callsign. Frames 0, 1, and 2 with the end bit set follow, Golay error 0, payload bytes 0 through 15. The plain decoder's returned link-setup flag stays false because a later sync at 230 ms, score 0.675, overwrites that slot. The peak was not raised. The image stays loaded. VFO 467.625 / 467.625 FM at 12:51:21.985, low power. §6 is not met.

**2026-10-24 — R-H host, SignalDeck `943e4ec2`, the live receiver.** No new firmware image. RG10 stayed loaded. The receiver searches every sync chain, skips audio the module is still muting, and opens a contact only from a link-setup CRC or six LICH chunks. It holds the audio until the call ends, then drops it, so one transmission is one listing. The voice-filter hold is sent again when the app releases PTT. `HeldPathTest` gives the reference frame count on all 18 saved clips, including 18 on the short one, with one contact and the right callsigns; the batch counts are unchanged. On the phone, HackRF FM at 467.625 MHz, VGA 20, ±2.4 kHz, a 1.6 s lead, raw `0x43` (−86.5 dBm): `K6M17 → W9LAB` 28 frames (25 clean), `W5RF → N6EQ` 28 (25), `N5TST → K6DEC` 27 (23). No listing without callsigns. The 27 is one under the 28 bar. The plain-state control with the lead listed `W1RF → N2EQ`, 27 frames. VFO 467.625 / 467.625 FM at 20:41:11, low power. M17 was stopped. No `DMRDEBUG.bin`.

**2026-10-24 — R-G host, SignalDeck, the held voice filter and the fixed taps.** No new firmware image. RG10 stayed loaded. Starting M17 on a stub tag (`DMR003.XXXX.V022`, not `UV4T`) sends command `0x40` op 6 variant 3, and the same write is sent again after a channel, VFO or tone write. Stopping M17 sends action 0. The Armor 26 Ultra's 41 taps run on the matched-filter audio before the sync search (threshold 0.95); the calibrated decision-feedback equalizer remains the plain state. `HeldPathTest` reproduces the research decoder's frame counts on all 18 R-F clips. One −99 dBm clip is 71 of 77 payload-exact. `m17_d2400_v10_1` locks 18 frames, all exact. The other −87/−93 dBm clips are 98.6–100 %. On the phone, HackRF FM at 467.625 MHz, VGA 20, ±2.4 kHz, raw `0x41` (−87.5 dBm): the hold returned `sr=0`, and the M17 list showed `K6M17 → W9LAB`, 13 frames, 12 of them clean. A second transmission, `W1RF → N2EQ`, with the hold released and the calibrated equalizer, was not the callsign pair the list added. VFO 467.625 / 467.625 FM, low power. No `DMRDEBUG.bin`.

**2026-10-24 — R-G firmware, tag `RG10`, stream end, the render reply, and the live receive half.** Op 7 arms `0x4B00C`; the wake calls `drop_ptt` (PTT clear, `0x58` = `0x8405`, status byte 4 through `+0x7E08`) when that flag is set and the ring has drained. The installed stream command still sends op 1, so this key did not take that path. Op 4 builds its reply at `0x4AE00` and accepts at most 240 samples. Op 5 copies from the second `FM_ADDR_SW` change. YModem `onSuccess` at 19:01:55.805. `0x34` `DMR003.RG10.V022` at 19:02:08.580. Boot peak 0.10 dB. A 64-sample render returned 128 bytes, `sr=0`, and did not key. A 1 kHz HackRF tone, op 5 mode 4, six halves: phase steps −0.09, +0.08, +0.02, −0.13, −0.06 degrees, including the first boundary. One low-power key on 467.625, 90 frames: steady p99 from 80 ms through 3600 ms is 2794–2913 Hz, link-setup CRC passes, 90 payload-exact frames. The click, 0–40 ms, is about 23 kHz and is not a stop. The 60 ms slice is 3134 Hz. Underrun 4748 is the host holding PTT after the symbols ended. The phone's one key was low power. No `DMRDEBUG.bin`. RG10 stays loaded. VFO 467.625 / 467.625 FM at 19:04:17, low power.

**2026-10-24 — R-F, RE10 already loaded, independent equaliser, the dip, and one POCSAG page.** No new image. `0x34` `DMR003.RE10.V022` at 18:29:05. The phone was not keyed. The ±20-symbol taps trained on the R-E `N0CALL` loop still decode that loop (LSF CRC 13/13, Golay 0 25/25 on the second clip). Eighteen new transmissions, other callsigns and random payloads, preamble and EOT, ±2.4 kHz and ±1.9 kHz, HackRF VGA 20, 10 and 0: at ±2.4 kHz and VGA 20 the `0x32` reading is raw 65–67 (−87.5 to −86.5 dBm) and the locked clips are Golay 0 on 57/75 and 46/75 stream frames, with the third clip's walker not staying on the stream. Every Golay 0 frame carries the payload that was sent. VGA 10 is about −93 dBm and a similar fraction; VGA 0 is about −99 dBm and almost no frames. The held phone path is −9.6 dB at 500 Hz against 1 kHz. Op 5 mode 4, with the first half dropped, is −0.23 dB at 500 Hz, so the dip is the ES8311. One 1200 baud POCSAG page at ±3500 Hz is 0.24 raw bit errors per codeword on the plain clip and 0.039 after the M17 taps. The independent pass is not met, and the taps were not wired into SignalDeck. RE10 stays loaded. VFO 467.625 / 467.625 FM at 18:31:55, low power. No `DMRDEBUG.bin`.

**2026-10-24 — R-E, tags `RD10` and `RE10`, the held phone path and the receive-RAM capture.** On RD10, op 6 variant 3, the phone's 8 kHz clip is digital silence for about 1.1 s after the HackRF starts (the module squelch holds the PCM at a peak of 5 counts) and then the held tone. The loud tail of a 100 Hz tone is 7291 counts before the M17 loop and the tail rms after three loops is 5162, the same as the held 100 Hz rms from R-D, so the hold survives the squelch opening. A VFO write drops that tail to 387 counts, and applying the hold again returns 7258. Three 3 s recordings of a link setup plus frames 0 and 1, decoded on the loud part with plain `m17.py` and no equaliser, lock sync near 0.95 and return frame numbers 0 and 1; none has a link-setup CRC or a Golay 0 frame. The plain-state control does not lock. Six-half variant-4 captures alternate half ids. Five 1 kHz captures peak at 999.99–1000.00 Hz, so the receive sample rate is 8 kHz, and the 1 kHz phase is continuous across the later half boundaries. A 310 Hz tone advances about −29 degrees per half, which is 9.92 cycles at 8 kHz; the large sample step sits inside the first half, not on a boundary. Three M17 loops from those bins, sliced on the known symbols, have raw symbol-error rates 0.32, 0.66 and 0.21, spread through the frame and not piled on the half boundaries. `uart_put` writes each byte into the UART before it returns, so the in-place reply is not overwritten in flight and the replies were not moved. RE10 saves the hold at `0x4B000` and `0x4B004`, with flag `0x484F4C44` at `0x4B008`. YModem `onSuccess` at 18:00:21.251. `0x34` `DMR003.RE10.V022` at 18:00:35.934. Boot peak 0.20 dB. The phone was not keyed. Op 5 during the hold returns `sr=1` and no body, and the HackRF peak is 0.03 dB. A variant-3 restore writes `0x8405` only and the 100 Hz line goes from 7299 to 387. The image stays loaded. VFO 467.625 / 467.625 FM at 18:02:46, low power. No `DMRDEBUG.bin`. The plain-decode pass is not met.

**2026-10-24 — R-D, tag `RD10`, phone path, the top of the receive RAM, and the UART clock.** Op 6 holds variant 3 (`0x58` = `0xBCFD`) or variant 4 (that write plus `WORK_MODE` `0x80` and `FM_BANDWIDTH` bits 4 and 6 clear) without copying RAM, and op 5 can return six halves. YModem `onSuccess` at 17:15:07.427. `0x34` `DMR003.RD10.V022` at 17:15:21.429. Boot peak 0.15 dB. The phone was not keyed. HackRF FM at 467.625 MHz, TX VGA 20, deviation 2.5 kHz, recorded on the phone at 8 kHz before the app squelch. Against 1 kHz the plain path is 50 Hz −27.6 dB, 100 Hz −24.5 dB, 300 Hz +5.7 dB, 2 kHz −4.0 dB, 3.5 kHz −12.1 dB, 3.8 kHz −17.0 dB. `0x58` = `0xBCFD` alone lifts 100 Hz to +1.2 dB and 3.8 kHz to +1.7 dB, and variant 4 matches it within 0.1 dB, so the phone hears the AT1846S filter and not the C7000 one. A VFO write to the same channel, without re-applying the hold, puts 100 Hz back to −24.5 dB. Variant-4 receive RAM, four halves, is 2 kHz +4.7 dB, 3 kHz +2.6 dB, 3.5 kHz +4.7 dB and 3.8 kHz +2.2 dB against its 1 kHz line. Eight 192 ms captures of a looped link setup plus two stream frames locked sync and often returned frame number 1; none had a link-setup CRC or a Golay 0 frame (Golay errors 8–14). The UART at `0x14090000` is a DesignWare block; init at file `+0x5DEC` sets `divisor = (*0x32F90 >> 4) / 57600` with no fractional register. The clock word is 6, 42 or 48 MHz; only 48 MHz fits the working 57600 link (actual 57692 Hz, +0.160%), and 230400 on that clock is divisor 13, 230769 Hz, the same +0.160%. SignalDeck already passes a profile baud into the serial JNI, and the Xplore 1 profile opens a UART at 230400. The image stays loaded. VFO 467.625 / 467.625 FM at 17:20:44, low power. No `DMRDEBUG.bin`.

**2026-10-24 — R-C step 4, tag `RC40`, 128 ms line levels.** Op 5 holds `WORK_MODE` `0x80` and copies four consecutive halves with `ld.b` into `0x4A400`, then restores and returns 2048 bytes in four replies. A module restart for the boot capture peaked at 0.08 dB. Banner `开机初始化完成` at 16:01:03.522. `0x34` `DMR003.RC40.V022` at 16:01:03.835. HackRF FM at TX VGA 20, deviation 2.5 kHz, three captures per tone. Median line against 1 kHz: plain path 300 Hz +11.1 dB, 100 Hz −42.1 dB, 50 Hz −46.1 dB. Bandwidth bits 4 and 6 cleared: 100 Hz −22.4 dB. AT1846S `0x58` = `0xBCFD` alone: 100 Hz −19.3 dB. Both together: 100 Hz +0.3 dB and 50 Hz −0.3 dB, three captures each, half-boundary steps up to 8 times the median sample step and not what sets the line. The phone was not keyed. R-C and R-B close. The receive design stays the audio-path equaliser. The image stays loaded. VFO 467.625 / 467.625 FM at 16:06:43.569, low power. No `DMRDEBUG.bin`.

**2026-10-24 — R-C step 3, tag `RC30`, both halves copied a byte at a time.** Op 5 still stores `WORK_MODE` `0x80` and restores it. The copy is `ld.b` of all 512 bytes of each half, returned as two replies of 256 big-endian int16 plus `FM_SQL`. Variant 2 clears `FM_BANDWIDTH` bits 6 and 4 for the capture. Variant 3 writes AT1846S `0x58` as `0xBCFD` and writes `0x8405` back. Variant 4 does both. Boot peak 0.10 dB. Banner `开机初始化完成` at 15:34:42.050. `0x34` `DMR003.RC30.V022` at 15:34:42.361. A quiet op 5 returned 256 samples per half, idle rms 4–17, no `HH 00 00 00` run, receive peak 0.06 dB. The phone was not keyed. HackRF FM at VGA 20, deviation 2.5 kHz: 1 kHz is the line on both halves (rms about 6900). 300 Hz is +11 dB relative to that. 100 Hz is −32 dB on the plain variant, −22 dB on the best half with the band-pass cleared, and −18 dB with both writes, and that last half has a seam. 50 Hz on the plain variant is −30 dB. The sweep tracks from about 750 Hz through 2600 Hz. No variant puts 100 Hz within 6 dB of 1 kHz. R-C closes. The receive side stays the audio-path equaliser. The image stays loaded. VFO 467.625 / 467.625 FM at 15:38:49.337, low power. No `DMRDEBUG.bin`.

**2026-10-24 — R-C step 2, tag `RC20`, one FM receive half over command `0x40`.** Op 5 saves `WORK_MODE`, stores `0x80`, waits until `FM_ADDR_SW` has changed twice, copies the half that register is not pointing at into `0x4AC00`, restores `WORK_MODE`, and returns the 512 bytes from a frame built at `0x4AE00`. It does not write PTT. Boot peak 0.07 dB. Banner `开机初始化完成` at 15:09:50.664. `0x34` `DMR003.RC20.V022` at 15:09:50.975. One quiet op 5 returned 512 bytes and the receive peak was 0.09 dB. The phone was not keyed. HackRF FM at 467.625 MHz, deviation 2.5 kHz, amp off: TX VGA 6, 12, and 20 put a 1 kHz line 37 dB, 44 dB, and 48 dB over the median of the 128 audio slots. VGA 0 did not. A 100 Hz tone at VGA 20 is 7 dB and does not stand out. A sweep is weak near 300 Hz, full at about 720 Hz, 1220 Hz, and 1690 Hz, and folds above 2 kHz. Of the 256 int16 slots, 128 carry the audio in the high byte and the slots between them are zero. `0x16A` was not sent. The image stays loaded. VFO 467.625 / 467.625 FM at 15:11:19.770, low power. No `DMRDEBUG.bin`.

**2026-10-24 — R4t, tag `R4t0`, the tap load is sign-extended.** `ld.hs` replaces `ld.h` in `one_sample`. Op 4 rendered 106 samples of a 64-symbol pattern with no key; all 106 match the integer model. Boot peak 0.06 dB. Banner `开机初始化完成` at 14:39:53.631. `0x34` `DMR003.R4t0.V022` at 14:39:53.952. One 50-frame key accepts the link setup and 50 frames at Golay error 0; p99 2788–3082 Hz. Three 90-frame keys each accept the link setup and 90 frames at Golay error 0. The printed slices from 80 ms sit between 2792 Hz and 2895 Hz. The 60 ms slice reaches 3110 Hz. No slice from 60 ms on is at or over 5 kHz. Underrun 5004 on every key is the carrier tail, the same count on the short stream and the long one. The image stays loaded. VFO 467.625 / 467.625 FM at 14:43:44.020, low power. The independent decoder is still waiting on the Ubuntu box.

**2026-10-24 — R4s, tag `R4s0`, symbols over command `0x40` and the RRC in the wake.** The ring holds 2048 symbols. Op 0 answers `sr=1`. An underrun emits a zero and does not advance the read pointer. Boot peak 0.08 dB. YModem `onSuccess` at 14:05:19.716. Banner `开机初始化完成` at 14:05:32.761. `0x34` `DMR003.R4s0.V022` at 14:05:33.072. One low-power key on 467.625. The symbol file, 2475 bytes, was sent by 14:06:00.827. From 60 ms through 2000 ms the p99 is 3660–4109 Hz, then about 80 Hz. No slice from 60 ms on is at or over 5 kHz. The click p99 is 22045 Hz and is not a stop. The plain decoder accepts nothing. One sync scores 0.939 and the tracker loses the next one. The fit to the integer RRC model is r = −0.34. The underrun count 19340 is the tail of the 4 s key after the 2.06 s of symbols. The image stays loaded. VFO 467.625 / 467.625 FM at 14:06:08.335, low power. §6 is not met.

End state: factory image. The tone-key restore's first `0x34` poll was empty after `onSuccess` 00:48:48.703; a later start of SignalDeck printed the banner at 00:51:13.856 and `DMR003.UV4T.V022` at 00:51:14.167. The silence-key restore did the same: `onSuccess` 01:01:45.469, no version on the first poll, banner 01:02:57.784 and `0x34` `DMR003.UV4T.V022` at 01:02:58.095 after a second start. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:02:58.648, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

**2026-10-24 (21:43–22:47) — FW19, the `0x3B` ceiling is 120 s.** The handler stores the byte it is sent. A byte of 0 clears the enable flag. There is no `min(tot, 30)`. The timer counts 100 wakes per unit, about one second. The stub at file `+0x5B700` writes 120 when the byte is 0 or above 120 and then calls the stock handler. YModem `onSuccess` at 21:43:41.610. `0x34` `DMR003.FW19.V022`. Boot peak 0.17 dB. Two low-power streams of 1125 frames ran 45.12 s. The host did not unkey. The last chunk was op 7, and the module sent status byte 4. The first capture decoded 1124 frames, 1123 payload-exact. Body p99 stayed under 3 kHz. The slices at or over 5 kHz are the drop click. One 30 s high-power carrier at HackRF LNA 0 / VGA 0 was clip 0, peak 13 of 127, body p99 199 Hz, battery +0.6 °C. The battery was still +0.5 °C twelve minutes later, so the 45 s and 120 s high-power keys were not run. After a silence unkey the 100 Hz line was about 71 dB below 1 kHz, so the `0x58` hold does not survive PTT. Tables: `radio_firmware/results.md`. End state: FW19 stays loaded, VFO 467.625 low power, no `DMRDEBUG.bin`.

**2026-10-25 (00:01–00:27) — FW19 ceiling, 40 s tone, op-7 timer.** High power, 3250 frames, no end bit, HackRF LNA 0 / VGA 0: status byte 4 at 120.33 s, carrier 120.35 s, clip 0, peak 11, body p99 3241 Hz. `mtktsAP` 47.9 to 59.2 °C, battery 40.2 to 41.9 °C, no stop; back within 1 °C in about 17 minutes. A 40 s low-power 1 kHz tone ended by the host at 40.40 s, status byte 4 at 40.73 s, carrier 40.75 s. The op-7 stream dropped at 45.03 s and, with no unkey, sent status byte 4 again at key + 120.34 s. A gain-0 HackRF carrier did not move `0x32` during that window (raw 6 to 5) and did move the idle radio from −104.5 to −96.5 dBm. FW19 stays loaded. VFO 467.625, low power.

**2026-10-25 (02:03–02:14) — FW20, the op-7 drop.** Tag `DMR003.FW20.V022`, sha256 `31ecdd30…87296`. Boot peak 0.06 dB. Low power, 467.625. Eight TX-RAM halves after the drain, then `drop_ptt`, then the stock unkey at `+0xE9C`, then the timer bits and the count. One 1125-frame stream: carrier 45.30 s, 1125 of 1125, end bit set, EOT score 0.999, body p99 3041 Hz, body peak 106. A second status byte 4 follows 0.33 s later. No timer status inside the next 130 s. The gain-0 carrier reads raw 47, the same as the idle radio, and the squelch opens (status 1 at 2.60 s). A query at 0.15 s still saw raw 6, before that unkey returned. A 1750-frame stream keyed 10 s after the drop runs 70.35 s and is not cut at the first key's +120 s. Steady p99 3018–3074 Hz. An image that cleared the bits before the unkey kept `0x32` at raw 6 until a VFO write; it was replaced. FW20 stays loaded. VFO 467.625, low power.

**2026-10-25 (02:43) — spoken microphone check on FW20.** Ten seconds on the microphone path, low power, 467.625. 247 of 247 frames, the last with the end bit, EOT score 0.978, body p99 2947 Hz. The host unkey is 13 ms after the first status byte 4; the stock unkey sends status byte 4 at 0.32 s. Codec 2 output is 9.88 s of speech. FW20 stays loaded.

**2026-10-25 — item 3, opcode space, corrected before the build.** The review's four fixes are in the item 3 section: a rational symbol clock (M17 3/5, POCSAG 8/125, 3/20, 3/10), a polyphase pulse with a hold mode for the pager, tone frequency in eighths of a hertz with continuous phase and an amplitude, and a queue of 64 pairs that op 11 ends when it drains. Not built.

**2026-10-24 (23:47) — FW19 high-power 45 s stream, stopped on the heat rule.** Same 1125-frame file, power byte 1, HackRF LNA 0 / VGA 0. Op 7 at 44.72 s, status byte 4 at 45.03 s. Carrier 45.05 s, clip 0, peak 13 of 127, body p99 3131 Hz. Battery 39.2 to 39.5 °C. `mtktsAP` 48.7 to 51.4 °C, and +1.03 °C in the last 10 s, which is the written stop. The unkey went out 1.3 s after status byte 4. The 120 s key and the 40 s tone were not run. The heat rule is not rewritten. FW19 stays loaded. VFO 467.625, low power.

**2026-10-24 (23:21) — SignalDeck M17 voice on FW19.** Hold to talk encodes Codec 2 3200 and streams the link setup and stream frames on `0x40`. It keys after eight chunks, sets the end bit, ends the last chunk with op 7, and sends `0x26` off after status byte 4. The handshake sends `setTot(120)`. One 1.5 s 1 kHz tone at 467.625 MHz, low power, HackRF LNA 16 / VGA 16: carrier 1.63 s, SNR 66.7 dB, clip 0, body p99 3206 Hz. Link setup [callsign] → `@ALL`, CRC ok. Frames 0–35 payload-exact. Codec 2 decode of those frames peaks at 1003 Hz. Frame 36 and the end frame were not locked. Status byte 4 at 1.54 s, then the unkey. FW19 stays loaded. VFO 467.625 low power.

---

## 11. Review of the 2026-10-23 findings (FW8/FW11/FW16, commit `b8ee26df`)

Reviewed the same day; the register values were re-checked with `python scripts/fw_at1846_regmap.py --reg 0x58` (identical to `11` §21.3).

**Holds up.**
- **AT1846S identification:** the `+0x2BAC` start-up sequence matches the known AT1846S init register for register, and the 196/28-site external calls are its register write/read.
- **Register `0x58` values:** `0x8405` at the five analog no-tone sites, `0x8404` with a CTCSS tone, `0xBCFD` at the one DMR site, all 16-bit immediates in the image, so they are editable.
- **The `0x34` correction is the most important result:** the version reply comes from resident RAM, not from the image string. So no image load has ever been proven, and FW14 with the `version-from-image` marker is the right first device test.

**H4 (the DMR path) does not stand as a separate route.**
1. **The high-pass is not bypassed in DMR mode.** `0xBCFD` has the voice high-pass field `01`, the same as `0x8405`. DMR mode bypasses emphasis and the voice low-pass, not the high-pass. If `01` already means "partly bypassed", the measured −60 dB transmit cut below ~250 Hz comes from something else: a coupling capacitor in front of the AT1846S microphone input (hardware, not fixable by registers) or processing in the module CPU (H2). The `fm-flat-58` result is therefore less certain than §10 implied; it is still the right experiment.
2. **DMR is TDMA.** The module sends DMR as 30 ms bursts, also in simplex. M17 and POCSAG need a continuous carrier, so any "DMR path" transmission would be an ordinary FM transmission with DMR-like register settings, which is the flat-FM line of work.
3. **The deciding question is unanswered: where does transmit audio enter the module, and what generates the DMR 4FSK?** If a DMR baseband chip builds the symbols from vocoder frames, the phone's PCM never reaches the modulator in DMR mode and there is no path to borrow. Tracing the TX PCM source in the image (from `0x26` LAUNCH and the audio-in interrupt) settles it; this joins FW11.
4. **The waveforms differ.** M17 and DMR share 4800 symbols/s 4FSK, but M17 uses ±2400 Hz outer deviation (DMR ±1944 Hz) and a different pulse shape; POCSAG is 2-level FSK at ±4.5 kHz. Even a raw symbol interface would not produce standard M17 or POCSAG without deviation and filter changes.

**Kept from H4:** the DMR branch's other settings, notably `0x43` (`0x00BB` on DMR vs `0x0100` on FM), are candidates for the digital-mode FM configuration's deviation, next to `0x59`/`0x41`.

**Other notes.**
- **`fm-flat-58` changes normal voice too.** `0x58` governs transmit and receive, so at all five analog sites it removes de-emphasis on receive (harsh received audio) and pre-emphasis on transmit (dull transmitted voice). That is fine for a bench comparison; the product must be a run-time digital-audio mode (§6). The patch entry now says so.
- **Still unexplained:** the compression before the modulator and the ±4.5 kHz limit. They, not the emphasis, are what break POCSAG at full deviation, so they need the same register-or-DSP analysis.
- **Next steps unchanged:** UVm1 (marker only) first, then UVm2 (marker + flat FM) against a measured factory baseline, on 467.625 MHz at low power, never during an ISS pass, with the owner's go-ahead.


---

## 12. Reply to the review (2026-10-23, read-only: nothing loaded, transmitted or patched)

Two facts change the picture, so they come first.

**A. The `0x58` bit layout used by both `b8ee26df` and §11 is wrong.** It came from the OpenRTX *web* register table (`openrtx.github.io/at1846_registers.md`). OpenRTX's *driver* (`platform/drivers/baseband/AT1846S_GDx.cpp`, `setOpMode`) documents a different layout:

| Bit | Function (OpenRTX driver comments) |
|---|---|
| 0 | CTCSS LPF bandwidth to 250 Hz |
| 3 | bypass CTCSS HPF |
| 4 | bypass CTCSS LPF |
| 5 | bypass voice LPF |
| 6 | bypass voice HPF |
| 7 | bypass pre/de-emphasis |
| 11 / 12 / 13 | bypass VOX HPF / VOX LPF / RSSI LPF |

Everything we can check agrees with the driver layout:
- OpenGD77 comments `0xBC05` as "enable … de-emphasis / pre-emphasis / high and low pass filters" and `0xBCFD` as "disable all filters in DMR mode"; the two differ in exactly bits 3–7.
- The HG-UV98 reconstruction (`agamez/hg-uv98-firmware`, `rf.c`) labels `0x840D` "250 Hz CTCSS path".
- Our own firmware: the CTCSS function toggles **bit 0** (tone `0x8404` / no tone `0x8405`), and its read-modify-write at `+0x3332…+0x3342` clears **bit 3** (enable CTCSS HPF). Both are CTCSS bits, which fits the driver layout and makes no sense under the web table.

Decoded with the driver layout:
- `0x8405` (analog, 5 sites): bit 0 = 1, bits 3–7 = 0. **Voice HPF, voice LPF, emphasis and both CTCSS filters are all enabled.**
- `0xBCFD` (DMR, `+0x2E92`): bits 3–7 = 1. **Voice HPF, voice LPF, emphasis and both CTCSS filters are all bypassed.**
- Bits 1:0 are not a high-pass field. Bit 1 is 0 in every value written. Bit 2 is set in all of them, and neither source documents it.

**B. The memory map in `11` §13.3/§21 is wrong; the "external region" is in our file.** The image has the HR-C7000 header used by the sibling module documented in M17-Project/AtomXL-reverse-engineering (`DMR006.U4A.V076`, `atomxl-re-docs/dmr-firmware-notes.md`): the same `68…10` frames and `switch(cmd−0x22)`, an AT1846S, and HR-C7000 = C-SKY CK803S with an integrated DMR/FM modem, vocoder and codec, running XIP from SPI NOR.

The copy descriptors at `+0xC4` are `(dst, dst_end, src)`:
- `(0x18000800, 0x18004404, 0x0304C2E0)`: SRAM, from file `+0x322E0`
- `(0x00010000, 0x00031AF4, 0x03053408)`: IRAM, from file `+0x39408`

The main code runs at `0x0301A000 + file offset`. Our "external" `bsr` targets are an artefact of mapping the file flat: target + `0x0301A000` = an IRAM address.

The evidence:
- 14 of the 22 targets with ≥10 callers land exactly on a `push` prologue.
- `0xFD011220` → IRAM `0x2B220` = file `+0x54628`. It is an I²C write to device byte `0xE2` (7-bit `0x71`, the AT1846S address AtomXL reports) of `[reg, hi, lo]`.
- `0xFD01125C` → `+0x54664` (read). `0xFCFF8F88` (`OSTaskCreate`) → `+0x3C390`.
- String pointers vote for this base: `0x0301A000 + off` finds pool words for `PttTask`, the Idle task and the version string; base 0 finds none of them.

### 12.1 Point 1, the high-pass claim: disagree with both versions

`python scripts/fw_at1846_regmap.py --reg 0x58` gives the same values as `11` §21.3 (`0x8405` ×5 at `+0x2C90`/`+0x3054`/`+0x344E`/`+0x34F2`/`+0x3640`, `0x8404` ×3, `0xBCFD` ×1). What changes is the decoding:
- **`0xBCFD` does bypass the voice high-pass (bit 6).** §11's "the DMR setting keeps the voice high-pass" does not hold.
- **No direction is "already bypassed" on analog:** `0x8405` enables every audio filter, so the AT1846S voice HPF is active on analog TX and RX.
- Neither layout gives a per-direction (TX vs RX) bit: emphasis is one "pre/de" bit, and the filters have no direction split.

**Consequence for `tools/fw-patch` (reported, not changed):**
- `fm-flat-58` writes `0x840F`. That sets bits 1–3: CTCSS-HPF bypass plus an undocumented bit 1. It **touches neither the voice HPF (bit 6) nor emphasis (bit 7)**, so a bench run would measure nothing useful.
- The `+0x333A` mask change only stops the CTCSS function re-enabling the CTCSS HPF.
- A meaningful candidate is `0x84C5` (bits 6 + 7: voice HPF and emphasis bypassed, voice LPF kept), or `0x84E5` with the voice LPF also bypassed.

### 12.2 Point 2, H4 / the DMR path: agree, with the code evidence

DMR offers no separate route.
- The SoC is an HR-C7000, which has its own vocoder and DMR modem (AtomXL notes). Our image drives that modem block at `0x1100xxxx`:
  - `WORK_MODE 0x11000100` is set to `0x22`/`0x6A`/`0x6E` at `+0x179C8`/`+0x17A44`/`+0x17A60` (addresses built with `movih 0x1100; bseti 8`, which is why no literal shows up).
  - `0x11000400`/`0x11000408` are written at `+0x8188…+0x87A0` and `+0x179DA…`.
  - `RF_MODE 0x11000104` is set to `0x10E0` (bits 6:5 = 11, two-point modulation in AtomXL's reading) by the save/set/restore routine at `+0x3ECC4…+0x3EEB0`.
  - The 8 kHz codec register `0x160009C0`/`0x160009D2` is accessed at `+0x6844`, `+0x6AC0` and `+0x3ED08`.
- So in DMR the phone's PCM goes to the vocoder, and the C7000 itself builds the 4FSK symbols and drives the modulator. The audio never reaches the modulator directly.
- §11's other arguments also hold: TDMA 30 ms bursts, and different deviation and pulse shape (M17 ±2.4 kHz, DMR ±1.944 kHz, POCSAG ±4.5 kHz 2-FSK).
- §11's argument 1 (the DMR value keeps the high-pass) falls with A. It isn't needed for the conclusion.
- Where FM TX audio enters, read 2026-10-23 (the §10 entry at 16:41): the FM setup at `+0x3ECC0` and the boot codec init at `+0x647C` enable the codec ADC. `FCR_ADC` (`0x160009D7`) is never stored. That address is codec base `0x160009C0` + `0x17` and also `0x16000900` + `0xD7`. The factory image has no literal of it. The only registers that hold `0x160009C0` (`r8` at `+0x67DC`, `r9` at `+0x6980`) are end pointers of a copy that stops before that address, and nothing is stored through them. The codec init's gain stores use offsets `0xDF`, `0xE3` and `0xE5` from `0x16000900`. So `adc_hpf` and the wind-noise filter stay at the off reset. UVm10 then showed the ADC gain itself is not what the HackRF hears (§10, 17:33). The `WORK_MODE` writers at `+0x179C8` and `+0x17D54` select `0x22` / `0x6A` / `0x6E` from struct `0x34808` and are not the PTT key. UVm8 shows the C7000 `FM_BANDWIDTH` stub does run, and it is not this cut.

### 12.3 Point 3, other explanations for the −60 dB cut below 250 Hz: yes, the review misses one

**The HR-C7000 has its own FM audio chain.** AtomXL documents two of its registers:
- `FM_BANDWIDTH 0x11000500`, reset value `0x5F`: band-pass (bit 6) and emphasis (bit 4) **on**.
- `FM_DEV_COEF 0x11000504`: the TX limiter `tr_sig_lim`, reset `0x0F`.

AtomXL's firmware never writes either one. **Ours doesn't either:**
- No literal pool word `0x11000500`/`0x11000504`.
- No built-base access. The `movih 0x1100` scan finds only `0x100`, `0x400`, `0x408`, `0x50C`, `0x510`, `0x51C` and `0x568`; the only other `0x110005xx` literal is `0x11000560`.

So both chips may filter the transmit audio:
- the AT1846S voice HPF and pre-emphasis, enabled by `0x8405`;
- the C7000 band-pass and emphasis, at reset;
- plus the C7000 limiter.

If both filters are in the path, two cascaded high-passes would explain a −60 dB stop-band better than one. The C7000 limiter is also the first candidate for the measured compression and the ±4.5 kHz limit.

A coupling capacitor before the AT1846S mic input remains possible but untestable from the listing.

The test design follows from this: a flat-FM bench run needs **both** `0x58` (bits 6/7) **and** a write to `0x11000500` (band-pass/emphasis off), with the limiter at `0x11000504` as the next variable. Otherwise a null result can't be attributed to either chip.

### 12.4 Point 4, factual and citation errors

| Where | Error | Correct |
|---|---|---|
| `11` §21.3 table and both wordings; §10; §11 H4 point 1; `patches.toml` `fm-flat-58`; `symbols.csv` comments at `+0x2E92`/`+0x3052` | Web-table bit layout (voice HPF = bits 1:0, emphasis = bit 3) | Driver layout (A): voice HPF bit 6, emphasis bit 7; `0x8405` all on, `0xBCFD` all bypassed |
| `11` §21.4, §10 "B2 correction", §11 "most important result", `patches.toml` `version-from-image` (status `ready`) | `0x03052464` called resident RAM; redirect to `0x00038464` | `0x03052464 = 0x0301A000 + 0x38464` is the **XIP address of the image's own string**. The original handler already reports the image string, so the tag edit alone is the marker. `0x00038464` lies in IRAM .bss (initialised IRAM ends at `0x332F4`), so the patch would make `0x34` reply with RAM contents. **Don't load `UVm1`/`UVm2` as built.** "No load proven" stays true for the ch. 18 reason (the 2026-03 loads were judged by patches that did nothing) |
| `11` §13.3, §21.1–§21.2, `symbols.csv` `ext_*` rows, ch. 19 A5 | Kernel/AT1846S routines "not in the file" | They are in the IRAM part (B): write `+0x54628`, read `+0x54664`, `OSTaskCreate` `+0x3C390`. A5 mostly dissolves |
| `11` §21.2 `at1846_apply_cal_table`, `symbols.csv` | "per-unit calibration", "`0x18000808` likely memory-mapped flash" | `0x18000808` is SRAM (copied from file `+0x322E8`: registers `15 32 3A 3C 3F 48 60 62 65 66 7F 06…0F 12 7F`). The values come from flash `0x03050608` = file `+0x36608` (`0x1100, 0x4495, 0x00C3, 0x0407, 0x28D0…`): the stock AT1846S 12.5 kHz bandwidth profile (`r0 = 1`: the 25 kHz one), not calibration |
| `11` §21.4 | "the image runs at address 0; handlers read live data inside the image range (`0x38C70`, `0x38E4C`, `0x38908`)" | Those are IRAM .bss addresses that happen to fall in the file's numeric range. The channel images are still in RAM (`11` §14.2 stands), but this is no evidence for base 0 |

**Correct in §11:** the AT1846S identification; the `0x58` *values* and their sites; `0x43` = `0x00BB` (DMR, `+0x2E3C`) vs `0x0100` (FM, `+0x302E`); the DMR, M17 and POCSAG deviation numbers; and the conclusion that `fm-flat-58` must stay bench-only because `0x58` acts on TX and RX together.

**Suggested next steps** (the owner's call; nothing changed here):
1. Correct `11` §13.3/§21 and `symbols.csv`.
2. Drop `version-from-image` and keep the tag edit.
3. Replace the `fm-flat-58` value and drop its mask site.
4. Add a C7000 `FM_BANDWIDTH` write as a separate experimental patch.
5. Re-import the image into Ghidra as three regions (flash `0x0301A000`, IRAM `0x10000` from `+0x39408`, SRAM `0x18000800` from `+0x322E0`), as AtomXL's `MapDmrMemory.java` does, before naming more functions.

---

## 13. Recovery before any load: where the loader lives and where it writes (2026-10-23, read-only)

**Question.** The version reply reads a flash address (`11` §21.4), so a loaded image may be written to flash and survive a power-cycle. If so, is re-loading the factory image always possible after a bad load?

### 13.1 The YModem receiver is not in the application image

| Check (file `DMR003.UV4T.V022-ORIGINAL.bin`) | Result |
|---|---|
| CRC-16/CCITT lookup table (first 8 entries, LE16/BE16/LE32) | absent |
| Strings `Download`, `Upload`, `IAP`, `flash`, `YMODEM`, `Image`, `Waiting`, `boot`, `update`, `erase` | absent (only `abort` inside the newlib errno table) |
| The application's only UART receive loop (`+0x7C48`, ch. 11 §14.1) | accepts frames starting `0x68` only; `0x20`/`0x0F` are discarded, `0x21` goes to the second family, everything else to the dispatcher. No `'1'` hello handling, no `SOH`/`STX`/`EOT` |
| Anything sending `'C'` (`0x43`) | none: the `movi r?, 67` sites are AT1846S register `0x43` writes (`+0x2C26`, `+0x2E3A`, `+0x302A`, IRAM `+0x547EC`/`+0x548FC`) |
| The one `0x1021` constant (`+0x2D76A`) | a bitwise CRC inside a protocol routine (selected by a flag next to `0x1020`), not a loader |

The sibling HR-C7000 firmware (M17-Project/AtomXL-reverse-engineering, `atomxl-re-docs/firmware-update.md`) has the same picture. A **bootloader occupies the first `0x1A000` of the module's SPI flash**, outside the application image. It runs an ST AN2557-style IAP menu, is entered by **holding PTT during power-up**, and takes `'1'` → `'C'` → YModem-1K. Our stock app does exactly that knock: `dmr009` power off 50 ms, PTT down 50 ms, power on, wait 1000 ms, PTT up; then the `"1"` hello and YModem (ch. 07 §2). So the receiver is the flash bootloader, and it runs before any application code. The HR-C7000's mask ROM (CPU boots from `bootrom`, user guide p. 58) and UART0 "boot upgrade" pins (pins T9/P10) are a further fallback, but their protocol is undocumented and they need hardware access.

### 13.2 Where the blocks go: flash at `0x0301A000`, so a load persists

- The image is linked to run **XIP at `0x0301A000`**. The copy descriptors at `+0xC4` name absolute flash sources (`0x0304C2E0`, `0x03053408`), the version reply reads `0x03052464`, and the three-region Ghidra import resolves string cross-references that a flat import cannot (§13.4).
- The HR-C7000 has no RAM that could hold the image there. IRAM is `0x10000…0x50000` (256 KB) and the image is 370 KB; `0x03000000` is the SPI flash window (user guide §4.5.3).
- So the bootloader must program the image into **SPI flash at `0x0301A000`** (= flash `0x03000000 + 0x1A000`, directly above itself), or the module would not run it. The image ends at `0x030766FC`. The transfer never covers `0x03000000…0x03019FFF`.
- **Consequence: a loaded image very likely persists across power-cycles and phone reboots.** The ch. 07 §3 belief "RAM-only, reverts on power-cycle" rested on patches that did nothing (ch. 18 §4), so it was never evidence. It also means **the module may still be running whatever was last loaded in 2026-03** (the PATCH-series images carried the same `V022` string). FW14 settles both points, and the factory reload at its end normalises the module.

### 13.3 Write-protect and verify

- **Image verification:** none that we know of. The app sends per-block CRC-16 and the size in block 0, but no MD5 (ch. 07 §1.5). The image has no checksum field that we know of, and AtomXL found none either. The bootloader may check more; that is unknown. Whether the bootloader validates before jumping to the application is unknown; it does not affect recovery.
- **Bootloader protection:** unknown whether its flash sectors are write-protected. The transfer does not address them either way: an AN2557-style IAP erases and writes from its fixed application address up, and every factory update image is linked for `0x0301A000`, so a loader that wrote anywhere else would brick every unit it updated.

### 13.4 Ghidra three-region import (done)

`scripts/fw1_ghidra_csky.ps1` now imports the file at `0x0301A000`. The new pre-script `FwCskyMapRegions.java` reads the `+0xC4` descriptors, cuts the IRAM part off the flash block and maps it at `0x10000` with .bss to `0x50000`. It maps SRAM at `0x18000800` (plus `0x18000000…`), and adds uninitialised `modem` `0x11000000`, `modem_buffer` `0x16000000` and `apb` `0x14000000` blocks. Seed, import, stats and export translate file offsets (`symbols.csv` stays in file offsets).

| | Flat base 0 (old) | Three regions (new) |
|---|---|---|
| Functions / instructions | 1,058 / 83,090 | **1,213 / 114,099** |
| xrefs to the version string | 0 | 2 (`cmd34_version_reply` + its pool) |
| xrefs to `PttTask` / Idle task / `encrypt` | 0 / 0 / 0 | 2 / 2 / 2 |
| `symbols.csv` applied / exported | 36 fn + 4 labels (+3 external skipped) / 40 | 40 fn + 4 labels / 44 |

Project `radio_firmware/ghidra_project_fw0/DMR003_UV4T_V022_c7000` (gitignored). The flat project is kept for comparison.

### 13.5 Verdict: re-loading the factory image is possible after a bad load

The receiver is independent of the loaded image: it lives in a flash region the transfer never writes, and it runs on the PTT-held power-up before the application. An application that crashes, hangs or never answers therefore cannot block a re-load. The same applies to an interrupted transfer that leaves the application half-written: the knock still reaches the bootloader, and the factory image can be sent again. The stock app holds the factory image as its asset, and our copy is `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin`.

What would break this: a bootloader that erases its own sectors, or a dead `dmr009` power/PTT GPIO path. Neither is plausible for a loader that every factory update goes through. Also not covered: hardware damage, which a load can't cause. The remaining unknowns (bootloader write protection, image validation) don't change the verdict.

**Recovery is therefore treated as safe for FW14 with the tag-only image.** That image differs from the factory one in two bytes of the version string (`4T` → `m1` at `+0x3846D`).

---

## 14. FW14 — the version-string round trip on the device (2026-10-23, Armor 26 Ultra; no transmission)

**Image:** `DMR003.UVm1.V022.bin`, tag-only: it differs from the factory image in 2 bytes of the version string (`+0x3846D`; sha256 `f2390a04…484f5c`, MD5 `47ac14ce…805c6f`). **Path:** SignalDeck → Device → Hand back; `adb push` to `/sdcard/DMR/DMRDEBUG.bin`; stock app started with `am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity`. Its `YModemManager` starts the transfer by itself when the file exists. The file was deleted right after `onSuccess`. SignalDeck → Take over, then the version is read from SignalDeck's start-up `0x34` (`RadioService: module …`). Helpers: `tools/fw-patch/bench/fwload_stock.sh` + `ui.sh`.

> The action-only start (`am start -a prize.intent.action.update.dmr.firmware`) opens a chooser on this phone, because the old rebuilt app `com.macgyver.dmr` also claims the action. Use the explicit stock component as above.

| Time (CDT) | Step | `0x34` answer |
|---|---|---|
| 13:37 | Baseline (SignalDeck, DIAG `restartmodule`) | `DMR003.UV4T.V022` |
| 13:38–13:40:40 | UVm1 load, 2 min 5 s, `onSuccess`; dialog "Update successfully" | — |
| 13:41:58 | Take over (SignalDeck power-cycles the module first, 13:41:54) | **`DMR003.UVm1.V022`** |
| 13:42:09 | DIAG `restartmodule` (module power off/on) | **`DMR003.UVm1.V022`** |
| 13:42–13:44:42 | Factory image loaded (`onSuccess`) | — |
| 13:45:09 | Take over | `DMR003.UV4T.V022` |
| 13:47:44 | UVm1 loaded again (`onSuccess`) | `DMR003.UVm1.V022` (13:48:04) |
| 13:48 | **Phone reboot** (`adb reboot` over USB, owner's go-ahead) | — |
| 13:49:30 | SignalDeck start after boot (module power on) | **`DMR003.UVm1.V022`** |
| 13:52:01 | Factory image loaded (`onSuccess`) | — |
| 13:52:21 | Take over | **`DMR003.UV4T.V022`** |

**Results.**
1. **First proven image load.** The radio answers with the loaded image's own string. The stock path works with any image the same size as the factory one, and the module ran normally on the tagged image (boot message, channel set-up, receive).
2. **Loads persist.** The tagged image survived two module power-cycles and a full phone reboot. **The "RAM-only, reverts on power-cycle" belief (ch. 07 §3) is wrong**: the bootloader writes the image to SPI flash (§13.2). A patch stays in the radio until another image is loaded.
3. **Restore works:** loading the factory image brings back `DMR003.UV4T.V022`, tested twice. Four loads in total, all `onSuccess` first time.
4. Corollary: the 2026-03 PATCH-series loads also persisted. Whatever was in the module before today (the `V022` string can't tell them apart) has now been replaced by the byte-exact factory image (MD5 `44260353…9e268e0` pushed and loaded at 13:52).

**State left:**
- SignalDeck owns the radio, and the stock app is disabled, as at the start.
- Weather zone, channel 36 (NOAA WX4).
- ISS SSTV mode running: the intercom shows "next pass 03:16". The "Following the ISS again" log line wasn't captured, because the test's `logcat -c` calls cleared it.
- No `DMRDEBUG.bin` on the phone (`PATCH14_BACKUP.bin` from 2026-03 is still there, untouched).
- Wi-Fi adb re-enabled after the reboot (`adb tcpip 5555`).

Nothing was transmitted, and no image with a functional change was loaded.

**What this changes in the plan.**
- **B3 (persistence research) is answered** without any flash probing: loads persist; there is no separate "make permanent" step; restore = load the factory image.
- **B1/E:** "Reload at start-up" isn't needed. A loaded modification stays until the user restores, so SignalDeck's firmware page must show the running image (via `0x34`) and always offer **Restore factory** as a real load, not a power-cycle.
- **C2:** `fwtest.sh` must end with a factory load, not a power-cycle.
- **Every patched image changes the radio until it is replaced.** Keep the tag-in-version-string rule, so `0x34` always tells what is in the flash.

## 15. Review of the FW17/FW18 bench run (2026-10-23, commit `d363048b`)

Reviewed the same evening against `radio_firmware/results.md`, `tools/fw-patch/patches.toml` and `11` §21.3.

**Holds up.** The run kept every rule: one frequency, low power, the HackRF receive-only, a stop on the predicted deviation, a tag check before each measurement, and the factory image restored and verified. Three results are solid:
- `0x58` bit 7 is the pre-emphasis. UVm2 and UVm4 are flat within about ±2 dB from 300 Hz to 3 kHz.
- `0x58` bit 6 (voice high-pass bypass) does **not** open 50–200 Hz. The value was written (bit 7 in the same word took effect), so this is a real negative result.
- Mid-band gain is the same on all four images.

**The next candidate is in the same register: the CTCSS high-pass.** In the driver layout, bits 3 and 4 bypass the CTCSS high-pass and low-pass. They are `0` in `0x8405` and also in `0x84C5`, so the CTCSS high-pass was **on in every image measured**. Its job on transmit is to clear the sub-audio band below ~250 Hz for the tone, and bit 0 sets its corner to 250 Hz. That is exactly the measured cut. The DMR value `0xBCFD` sets bits 3 and 4, which fits a DC-coupled DMR path. The firmware's CTCSS code also points at it: `+0x3332…+0x3342` read-modify-writes `0x58 & 0xFFF7`, which clears bit 3. Before blaming a coupling capacitor or the module CPU, test:
- **UVm5** = tag + `0x58` = **`0x84DD`** (UVm2 plus bits 3 and 4) at the same five sites;
- **UVm6** = tag + **`0x84FD`** (also bit 5, the voice low-pass bypass; this is the DMR value's low byte, and it should lift the 3.5 kHz roll-off).

If the CTCSS routine runs on a no-tone VFO tune, its `& 0xFFF7` re-enables the high-pass after the patched write. Check that first and neutralise it in the same image. A bench image without CTCSS needs no CTCSS.

**UVm3 is inconclusive, not negative.** "UVm3 = factory curve" fits two explanations: the HR-C7000 FM chain is not in the transmit path, or the stub never ran. Nothing in the run tells them apart. Before more C7000 work, give the stub a visible canary, for example a much lower `tr_sig_lim` in `FM_DEV_COEF` at `+0x5B01C`. If the 1 kHz deviation at −12 dBFS drops, the stub runs and the C7000 chain is in the path. If nothing changes, either the stub isn't reached (check the `+0x3074` branch on a VFO `0x23` tune) or the chain is bypassed.

**Smaller points.**
- The −20 dBFS sweeps read low near the bottom edge: the factory 500 Hz tone at 184 Hz where about 390 Hz was expected, and UVm2's 300 Hz tone at 264 Hz where about 570 Hz was expected. The −30 dBFS rows were used without saying why. A level-dependent loss at the band edge would fit the compression seen before. Re-take one of these tones at three levels before trusting either row.
- The limiter ceiling can be measured within the stop rule: −3 dBFS predicts about 4.5 kHz at 1 kHz. Only take this step on UVm5/UVm6 if they turn out flat.
- The voice clips were not listened to, and receive was not compared. Both checks belong to the image that passes the response test, not to every one.

**Conclusion.** FW18 is not finished. The cut below 250 Hz has one cheap untested candidate left in the same register, so this run does not yet show that the cut is hardware. Next on the bench: UVm5, then UVm6, with the same measurements (1), (3) and (4), and the C7000 canary as a separate image.

## 16. Review of UVm5–UVm7 (2026-10-23, commit `47df3bf4`)

**My §15 hypothesis was wrong.** The CTCSS high-pass (`0x58` bits 3/4) is not the cut. The test was a fair one: the no-tone read-modify-write was found and neutralised, and 50–200 Hz stayed closed at three levels while 300 Hz scaled linearly. Bit 5 explains the 3.5 kHz roll-off, so **UVm6 (`0x84FD` + `ctcss-hpf-keep`) is flat within ±2 dB from 300 Hz to 3.5 kHz**: the best transmit curve so far, short only of the bottom octave.

**Both C7000 results are still unproven.** UVm7's null has the same two readings as UVm3: the stub doesn't run, or `FM_DEV_COEF` isn't in this signal's path. Neither run proves the stub executes. Let the stub show it ran by itself: in the stub, write `0x58 = 0x84C5`, leave the factory `0x8405` immediates in place, and keep the C7000 writes.
- **If the pre-emphasis disappears,** the stub runs on the keyed path. UVm3 then shows that the C7000 FM band-pass and pre-emphasis are not in the transmit chain, and UVm7 shows the same for its limiter.
- **If it doesn't disappear,** the redirect at `+0x3074` is not the write that holds.

**What is left for the cut below 250 Hz:**
1. **The rest of `0x58`.** The DMR value's upper byte (`0xBC`, bits 11–13: VOX high-pass, VOX low-pass, RSSI low-pass) has not been tried on analog. Writing the exact DMR value `0xBCFD` at the five sites + `ctcss-hpf-keep` is one image, and it exhausts this register.
2. **The phone side, before the module.** Every transmit test feeds PCM through PrizeTinyService into the phone's audio codec. A codec uplink/downlink high-pass, or an AC-coupled analog line to the module's microphone input, would cut exactly this octave, and no module image can change that. This is read-only to check: the codec's mixer controls (`tinymix` as root, list only) for HPF / DC-block switches on the route TinyService uses, and the stock app's or tinyserver's audio route.
3. **Where transmit audio enters the module** (§12.2, still unread): digital into the HR-C7000 (then its ADC/audio front end, independent of `FM_BANDWIDTH`) or analog into the AT1846S microphone pin. If it is analog with a coupling capacitor, the cut is hardware.

**Next:** the stub self-proof image, the `0xBCFD` image, and the read-only codec survey. If all three come back negative, the bottom octave is outside software reach. The fallback is then the run-time pre-shaping and receive-equalizer route (the M17/POCSAG deep dives), now on a flat 300 Hz–3.5 kHz path (UVm6) instead of the factory one.

## 17. Review of UVm8–UVm9 (2026-10-23, commit `25c0a4cd`)

**Settled:**
- **The stub runs on the keyed path.** UVm8 removed the pre-emphasis from inside it. So UVm3 and UVm7 are real negatives: the HR-C7000 `FM_BANDWIDTH` and `FM_DEV_COEF` writes do not shape what is transmitted.
- **Register `0x58` is exhausted.** The DMR value `0xBCFD` on analog leaves 50–200 Hz at about −40 dB.

**Not yet shown: "outside software reach."** That conclusion rests on two inferences that no measurement backs:
1. **That transmit audio passes through the HR-C7000 codec ADC at all.** The image programs the ADC as the FM source, but the phone plays the PCM out on **I2S1, a digital bus**. If I2S1 reaches the module digitally, the ADC (and any capacitor in front of it) is not in the path, and the cut is a digital stage, which is software. Nothing in the run tells these apart. A positive control does, in the stub style of UVm8: **lower the codec ADC gain** (`GCR_ADCL`, codec base `0x160009C0` + `0x25`) by about 6 dB.
   - If the 1 kHz probe drops from about 111 Hz to about 55 Hz, the ADC is in the path. With `adc_hpf` at reset, the cut is then before the ADC: analog coupling, which is hardware. The conclusion holds.
   - If it does not drop, the audio enters some other way. The next reading is the C7000's PCM/I2S input path and its filters.
2. **That `FCR_ADC` is never written.** The search covered the literal and offset `0xD7` from `0x16000900`. The codec init addresses its registers from base `0x160009C0` (`+0x09` `AICR_ADC`, `+0x1F`, `+0x23`, `+0x25` gains), so the store to look for is a byte store at offset **`0x17`** from that base. Check it before relying on "reset = off".

**Product view, whatever the result.** A −40 dB hole cannot be pre-shaped away: earlier work found POCSAG needed 13–20× more drive than the input accepts. So standard M17 and POCSAG TX to ordinary radios depends on the bottom octave being software-reachable. If the ADC canary says hardware, close the TX side of this track. Keep UVm6 (flat 300 Hz–3.5 kHz) as a candidate run-time mode for digital modes that fit that band (AFSK, FT8, SSTV and SignalDeck-to-SignalDeck links). On receive the M17/POCSAG equalizers already work.

## 18. Review of UVm10 (2026-10-23, commit `2dfc7804`)

**Settled:**
- The canary was built properly: `0x61F4` overwrites `GCR_ADCL`, the live branch was found and lowered, and the floor branch was ruled out. The air stayed within 0.5 dB, so **the codec ADC is not in the transmit path.**
- `FCR_ADC` is never stored.

**A different reading of where the audio goes.** The phone sends PCM on I2S1 (digital), and the audio does reach the AT1846S (UVm2 and UVm8 changed it through `0x58`). The AT1846S microphone input is analog, so a DAC sits between the two. On this module the obvious DAC is the **HR-C7000 codec's own DAC**, the very converter §10 set aside as "receive/sidetone". A symmetric layout fits everything measured:
- **TX:** phone I2S → C7000 codec DAC → AT1846S microphone input.
- **RX:** AT1846S audio out → C7000 codec ADC → I2S → phone.

It also explains why receive loses the same octave (the M17 deep dive: −25…−37 dB below 250 Hz): there would be one coupling point, or one DAC/ADC filter setting, per direction.

**So the `0x44` image proposed in §10 adds little.** `0x58` already proves the audio passes through the AT1846S. The informative tests are on the DAC side:
1. **TX DAC canary (UVm11):** lower `GCR_DACL` (codec base + `0x1F`, written by the codec init; find any later rewriter, as with `0x61F4`) by 6 dB. Same two stimuli. If the air halves, the C7000 DAC feeds the transmitter.
2. **A DAC high-pass:** if the canary drops, read the codec's DAC-side filter and control registers in the user guide (the `FCR_DAC` counterpart of `FCR_ADC`, a DAC DC-block or de-pop high-pass) and where the image writes them. A software-set DAC filter would be the last firmware candidate for the cut. If there is none, the cut is the analog coupling between that DAC and the AT1846S microphone pin: hardware.
3. **Receive cross-check without transmitting:** UVm10's lowered `GCR_ADCL` should make received audio about 6 dB quieter if the ADC is the RX path. SignalDeck `rxclip` on open-squelch noise (sq 0, quiet channel), factory against UVm10. No RF needed.

## 19. Review of UVm11 and the receive check (2026-10-23, commit `6f8c0904`)

**Settled.** The HR-C7000 codec is in **neither** audio path:
- **Transmit:** its DAC gain (UVm11, all ten table slots, with no later rewriter) and its ADC gain (UVm10) leave the air within 0.5 dB.
- **Receive:** its ADC gain leaves open-squelch receive within 0.06 dB.

The audio does pass through the AT1846S (UVm2/UVm8). My §18 reading (phone I2S → C7000 DAC → AT1846S) is therefore wrong as well.

**What fits instead.** The converters are on the **phone side**. tinyserver plays transmit PCM out on I2S1 (`I2S1_CH1 DL8_CH1`) and takes receive audio in from I2S2 (`UL2_CH1 I2S2_CH1`). Some DAC/ADC outside the module's own codec (an external codec chip, or the MT6359 through those I2S links) turns them into analog lines to and from the AT1846S microphone and audio pins. Any coupling capacitor, or a converter's own high-pass, sits there. That fits the matching low-frequency loss on both directions: about −40 dB TX, −25…−37 dB RX.

**Consequence: module firmware cannot open the bottom octave.** Every module-side control that could have shaped it has now been ruled out by measurement:
- AT1846S `0x58`, all bits;
- the C7000 FM band-pass, pre-emphasis and limiter;
- the C7000 codec ADC and DAC.

For the transmit cut, close the firmware track here.

**One read-only check is left, on the phone, no transmission:** identify the converter on I2S1/I2S2. Look at the I²C device names (`/sys/bus/i2c/devices/*/name`), `/proc/asound/cards`, the kernel log lines about codec probes, and the vendor audio XML or route files that name I2S1/I2S2. If it is a codec chip with a programmable high-pass (many have a DC-blocking HPF, typically 3–200 Hz), that is the last software candidate, at the phone's kernel or ALSA level and outside this module's firmware. Changing it would be a system audio setting, so the owner decides. If it is plain coupling capacitors, the octave is hardware.

**What the firmware work still gives the product.** UVm6 (`0x84FD` + `ctcss-hpf-keep`) is flat from 300 Hz to 3.5 kHz on transmit. The digital modes SignalDeck already ships (AFSK, FT8, SSTV, DTMF, SAME) work on the factory path. A run-time flat mode would gain them margin, not new capability, and it needs a firmware command to switch `0x58` per transmission, because the register also sets receive de-emphasis. Standard M17/POCSAG TX to ordinary radios stays infeasible on this phone. RX for both already works with the equalizers.

**Phone-side check, done the same evening (read-only, Armor 26 Ultra, root; nothing written).**
- **The phone's own codec is an Everest ES8311.** `/sys/bus/i2c/devices/7-0018` has name `es8311`, driver `es8311`. The ALSA card is `mt6885-mt6359`. When SignalDeck's audio starts, the kernel log shows I2S1 and I2S2 enabled at **8000 Hz** with MCLK 1.024 MHz, and `es8311_pcm_hw_params … lrck = 8000`. So the ES8311 is the converter between the phone's PCM and the radio module's analog lines. The speaker amplifier (`aw883xx`, 6-0034) is a separate path.
- **Its registers can't be read without writing.** The driver exposes `es8311_debug/es8311` (root, rw). Reading it returns one register (`0x0000=0x0080`); other registers are chosen by writing to the node, which was not done. There is no regmap debugfs.
- **What to check (ES8311 datasheet).** The ADC has a digital DC-removal high-pass with programmable coefficients (the `ADC_HPF` / `HPFS` fields, around registers `0x1B`/`0x1C`). That is on the **receive** direction (module → phone), so it is a candidate for part of the receive loss below 250 Hz. On the **transmit** direction (phone → ES8311 DAC → module), check whether the datasheet lists any DAC-side high-pass. If there is none, the transmit cut is the analog coupling to the AT1846S: hardware.
- **Who changes it.** Any ES8311 change is a phone-kernel audio setting, outside the module firmware, so it is the owner's decision. Reading registers through `es8311_debug` needs its write format (select-only versus write) worked out from the driver first. Never guess it.

## 20. Chasing every remaining route (owner, 2026-10-23: "chase every chance we have")

**Checked on the phone the same evening (read-only, nothing transmitted, nothing written to any audio setting).**
- **The ES8311 is on both links.** The kernel strings say `es8311 find, i2s1 codec dai_link` and `… i2s2 codec dai_link`.
- **It exposes no high-pass control.** Its ALSA controls (kernel strings) are `DAC SDP MUTE` / `ROUTE` / `SRC MUX`, `DAC DSM MUTE`, `DAC DEM MUTE`, `DAC OFFSET`, `DAC RAMP RATE`, `MIC PGA GAIN`, `ADC SCALE`, `ADC RAMP RATE`, `ADC INVERTED`, `ADC SDP MUTE` / `ROUTE`, `ADC FS MODE`, `ADC DATA TO DAC TEST MODE`, the `ALC …` and `DRC …` set, and `ADC/DAC RAM CLR`. The ES8311's DC-removal high-pass sits on the ADC (receive) side and is register-only. Nothing on the DAC (transmit) side looks like a high-pass. **The transmit cut is therefore most likely the analog coupling between the ES8311 output and the module's microphone input**: hardware.
- **`/dev/ttyS1` on the Armor carries no audio.** The Xplore 1 module streams PCM on a second UART at 230400. On the Armor, `ttyS1` (SELinux `mt6825muxd_device`) took the speed setting, but with monitor on and receive audio flowing (RMS 5405 through TinyService), it received **0 bytes** in 6 s (`/proc/tty/driver`: rx 0, no framing errors). That path is not wired, or not enabled, on this module.

**The route that avoids the analog line entirely: let the HR-C7000 make the modulation.** DMR transmits correctly from this radio, and DMR's 4FSK needs a usable low end. The C7000 builds that signal itself and drives the modulator, with no phone audio involved. The user guide (Document 2, §7.2.2.1) gives analog FM a second source, **TX RAM** (`0x11000080[0]` = 1, ping-pong at `0x16000030`–`0x1600042F`). If FM from TX RAM leaves through the same modulator path as DMR, then a firmware patch could:
1. take M17 or POCSAG **symbols** over the control UART (M17 is 9600 bit/s and POCSAG 1200 bit/s, both well inside 57600 baud, so no PCM transfer is needed);
2. shape them in the module (RRC for M17, NRZ/Gaussian for POCSAG);
3. write the samples to TX RAM.

That bypasses the ES8311, the coupling capacitor and the AT1846S microphone path.

Steps, cheapest first:
- **R1 (no firmware change): is the DMR modulation path DC-capable?** Transmit DMR at low power on 467.625 MHz (a bench digital channel, CC1, TS1, a test talkgroup) and capture it with the HackRF. FM-demodulate it and check, inside each 27.5 ms burst, that the 4FSK outer levels stay flat (no droop between sync and payload), and how much spectrum sits below 250 Hz. Flat levels mean the C7000 modulator path passes the low end.
- **R2 (host reading): how analog FM reaches the RF in each mode.** `WORK_MODE` / `RF_MODE` (two-point modulation) in DMR mode against FM mode; what TX RAM FM needs (the source bit, the ping-pong refill interrupt, sample format and rate, and the deviation scaling); and which AT1846S registers DMR mode changes so that it accepts the C7000 modulation (`0x30`, `0x43`/`0x44`, `0x58` = `0xBCFD`).
- **R3 (first image): FM from TX RAM with a fixed pattern.** A stub selects the TX RAM source on FM and fills the ping-pong with a slow square wave at a deliberately small amplitude. Measure whether a 15–60 Hz fundamental comes out with flat tops. Raise the amplitude only once the scale is known (±5 kHz stop as always).
- **R4: a symbol-stream command.** A new UART command (an unused command byte) carries M17/POCSAG symbols; firmware shapes them into TX RAM under PTT. SignalDeck gets a matching sender. Measure against §6 (plain M17 decode 85/90, POCSAG 100 %).

**Receive side, optional.** Reading or writing ES8311 registers needs the `es8311_debug` write format, from `es8311_store` in the kernel. The symbols are hidden (`kptr_restrict`), and changing that is a security setting, so it stays off. Recover the symbol table offline from the boot image's kernel instead, then disassemble `es8311_store`. Any ES8311 write is the owner's decision. Receive M17/POCSAG already works with the equalizers.

## 21. Review of R1, R2, R4 and the `es8311_store` reading (2026-10-23, commits `7262c739`, `d56fdb84`)

**R1 is the first positive result of this track.** The DMR modulator path carries the low end:
- **7.2 %** of the burst's 0–4 kHz power sits below 250 Hz. A random-symbol RRC 4FSK at 4800 sym/s puts about 8–9 % there. The FM path measured under 1 %.
- A held outer symbol keeps its level across the burst (ratio 0.981).

So the C7000-made modulation does not go through the coupling that cuts FM audio. That is the condition for the TX-RAM route.

**The ±7.3 kHz rail needs a second look before anyone acts on it.** The DMR outer symbol should be ±1944 Hz, and the BTECH 6X2 decoded this radio on air. 3.8× too much deviation would put a ~20 kHz-wide signal in a 12.5 kHz channel. Either the radio's DMR really is over-deviated (then worth knowing, and worth reporting), or the symbol-centre reading is off (timing, or the transitions leaking into the window). Check it two independent ways from the same capture:
- **Occupied bandwidth straight from the IQ:** the 99 % power bandwidth of the burst. About 8–9 kHz means ±1944; about 18–20 kHz means ±7 kHz.
- **The symbol histogram:** the 4FSK levels should show as four peaks, with inner/outer = 1/3.

**The stop rule was applied to the wrong thing.** The ±5 kHz stop is for **our** stimuli: it guards against over-driving a patched path. R1's figure is the factory DMR modulation, a measurement, not something we sent, and R3's deviation does not follow from it. R3 sets its own deviation through the PCM amplitude. That rule wording was mine and was ambiguous. **R3 should go ahead**, starting at a very small PCM amplitude (the guide gives no Hz per count) and raising it in 6 dB steps, with the stop on the measured R3 deviation.

**R2 adds what the R3 stub needs:**
- The FM key-up at `+0x3EDF8` clears `tx_voice_source`, so the stub must set it **after** that store.
- The ping-pong is 2 × 256 samples, big-endian. Nothing in the image refills it, so a static fill repeats: low half `+A`, high half `−A` gives a **15.6 Hz square wave** (64 ms period).
- Clear `FM_BANDWIDTH` bit 4 (pre-emphasis) and bit 6 (band-pass) in the same stub. UVm8 showed that stub path runs.
- Flat tops on the HackRF mean the TX-RAM route is DC-capable. A drooping square (an exponential decay towards zero) gives the corner frequency of whatever high-pass is left.
- If nothing radiates beyond a bare carrier, the C7000 FM output is not what drives the RF in analog mode. In that case, the next step is the DMR-mode modulation registers (two-point `RF_MODE` with the AT1846S set to `0xBCFD`).

**R4 design: sound.** The rate budget (27 % of the line) and the shaper size fit. Build it only after R3.

**`es8311_store`:** a write with count 0 is a **register read**: the value goes to the kernel log, and nothing is written to the codec. That is safe to use for reading the ADC high-pass registers (`0x1B`/`0x1C`) for the receive side, but it is still a write to a debug node, so the owner decides. Never use a non-zero count without the owner's approval: that path writes the codec.

## 22. Review of R1b and the R3 boot failure (2026-10-23, commit `096d797c`)

**R1b is settled and keeps the route alive.**
- The factory DMR outer symbol is **±3.3 kHz**: 99 % bandwidth 10.5 kHz, four clusters, inner/outer 0.342.
- **17.7 %** of the power is below 250 Hz (the FM path: under 1 %).
- Held symbols are flat (0.995).

The ±7.3 kHz figure was a measurement artefact. Open question: ±3.3 kHz is about 1.7× the DMR standard's ±1944 Hz. Check whether the bench digital channel was programmed as 25 kHz (wide). The AT1846S DMR tune writes `0x30` = `0x4026` against `0x4006` for 12.5 kHz. If it was, re-check on a 12.5 kHz DMR channel, since SignalDeck's DMR channels should never go out wide. If it wasn't, the radio over-deviates DMR, which is worth knowing but is no part of this track.

**R3 most likely failed because its hook sits in code that runs from IRAM.** The memory map (`11` §21.0, ch. 19 §14) copies file `+0x39408`–`+0x5AEFC` to IRAM `0x00010000`–`0x00031AF4` at boot. The FM key-up `+0x3ECC0`, and the hook at `+0x3EDFC`, are inside that copy and execute at IRAM `0x159F4`. The zero tail at `+0x5AEFC` and the stub at `+0x5B000` are **not** copied and exist only in XIP flash, at `0x03075000`. Every earlier patch was outside the copied block: flash code `+0x3074`, `+0x3332`, `+0x61F4`, data `+0x36ED0`, the tag at `+0x3846B`. So R3 is the first image that changes IRAM-copied bytes, and two things follow:
1. **The `bsr` was encoded as a file-offset distance** (`+0x1C204`). From IRAM `0x159F4` that lands at `0x31BF8`, in IRAM .bss past the initialised end `0x31AF4`. The correct target is the stub's XIP address `0x03075000`, a displacement of `0x0305F60C`. That fits the 32-bit `bsr` range (±64 MB), but it must be computed from the runtime PC.
2. **The missing banner points to a check before the banner.** A wrong branch would only fault at key-up, yet the module never reached the banner. So early boot probably verifies the IRAM copy (a checksum or CRC in the copy descriptors at `+0xC4`, or a check in the start-up copy loop), or a pointer table calls the key-up code early. Read the copy descriptors and the start-up copy loop for any verification field.

**Next, in this order:**
- **R3-0 (no RF needed, boot only):** change one harmless IRAM-copied byte, for example a character in a log string inside the copied range, with no code change. If it doesn't boot, the IRAM block is checked. Find the check value, recompute it in `build.py`, and confirm with a second image that boots.
- **R3a1:** the same stub with the `bsr` computed from the IRAM PC to `0x03075000` (plus any check value). Then the R3 measurement as planned.
- If IRAM can't be patched at all, move the hook into flash code. Use a flash-resident caller on the key-up path, or re-set `tx_voice_source` from a flash routine that runs after key-up. Leave the IRAM code untouched.

## 23. Review of R3-0 (2026-10-23, commit `6e09cd51`)

**Settled.**
- **IRAM can be patched.** The copy records at `+0xC4` are plain (destination, end, source), the loop is a word copy, and nothing checks the whole block. R301, one padding byte, booted and reported its tag.
- R300's failure was a changed `TICK` compare, not a check.
- R3a0's six hook bytes run **before** the banner. So the FM key-up path executes during boot (key, then unkey through `+0x3D688`), probably the module's own TX/RX start-up cycle.
- The R1 channel took the 12.5 kHz DMR branch (`0x30` = `0x4026` last). So ±3.3 kHz is this radio's real narrow-band DMR outer deviation, about 1.7× the standard ±1944 Hz. Note it in the DMR docs (other radios still decode it on air: the BTECH 6X2). It is not part of this track.

**Not loading R3a1 was right.** As built, the stub would select TX RAM, fill a square and set PTT **during every module boot**, before SignalDeck sends any `0x23`, on whatever frequency the module comes up on. The last channel was 162.425 MHz, a NOAA weather frequency, where we must never transmit. **Rule from now on:** any stub on the key-up path must be **gated on a host-requested transmission** and must do nothing at boot.

**How to gate it:**
- **Preferred: a flag set by the host's PTT command.** Patch the flash-resident handler of the UART key command (`0x26` LAUNCH / SEND_START; find it in the command dispatch) to set a word in unused IRAM .bss. The memory map gives the .bss range: the boot loop zeroes `0x31AF4`–`0x4DAB0`; pick a word nothing references. The key-up stub then acts only when that word is set, and the unkey path clears it. At boot the word is zero, so boot behaves as factory.
- **Belt and braces:** also require that the module has had a `0x23` since boot (a second flag set in the `0x23` handler), and that the stub's TX-RAM part runs only while both flags are set. The PTT store itself stays the factory behaviour.
- **One-time factory check (receive only, factory image):** with the HackRF on 467.625 MHz, tune the VFO there, then run DIAG `restartmodule` and record. This shows whether the factory boot cycle radiates at all, and for how long. If it does, that is stock behaviour, but it tells us what a boot on another frequency would do.

**Next.**
1. The factory boot-radiation check.
2. Find the `0x26` key handler and a free .bss word, then build **R3a2** (gated stub + flag setter + flag clear on unkey). Host tests: boot path with flags zero leaves the factory PTT behaviour, and decoded branch targets in runtime addresses.
3. Before loading, tune 467.625 MHz so any unexpected key lands on the bench frequency. Load, check banner and tag, then the R3 measurement (A = 256, 3 s key, tops flat / drooping / bare carrier, 6 dB steps under the ±5 kHz stop).
