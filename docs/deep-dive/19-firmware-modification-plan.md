# 19 — Firmware modification plan: finish the reverse engineering, load and verify a modified image, open the transmit audio path for digital modes

**Date:** 2026-10-23. **Owner:** IIMacGyverII. **Status:** plan; nothing in it is done unless marked ✅.

**Question.** We hold the Armor 26 Ultra's radio-module firmware (`DMR003.UV4T.V022`, 378,620 B, C-SKY V2, link base 0), a working way to push an image into the module, and a partial disassembly. How do we (1) finish understanding the image, (2) load a modified image reliably, know whether it persists, and tell the user which firmware is running, (3) test changes quickly and safely, and (4) change the transmit audio path so M17, POCSAG and other digital modes that the current firmware filters away can be transmitted on amateur allocations?

**Scope and rules (fixed, not up for re-planning).**

- Modifications target the **transmit audio processing** (high-pass, pre-emphasis, compression, deviation limiting) and operator-side settings (time-out timer). **The band limits (136–174 / 400–480 MHz), transmit power settings and any RF-regulatory protection stay untouched and are out of scope.** Transmitting is the operator's responsibility under their licence; every bench transmission stays on 467.625 MHz at low power into the HackRF, as for every previous bench.
- **RAM-load only** until persistence is understood. A power-cycle restores the factory image. No flash erase/write command is ever sent on a hunch.
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
| Transmit length | Firmware ends every keyed TX at 30 s; `0x3B SET_TOTO` is `min(tot,30)` | CLAUDE.md §3 |
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

Safety in the UI: Device → **Firmware (experimental)**: shows "Factory firmware DMR003.UV4T.V022" or "Modified firmware <name> loaded at <time>"; **Load…** picks a file from `Download/DMR/Firmware/`, refuses any file not exactly 378,620 B or without a `DMR003.UV4T.` version string, shows the warning (RAM-only, reverts on power-cycle, your licence), requires a second confirmation; **Restore factory** = module power-cycle (the loader's own restart) + version check. Nothing loads automatically unless the user has turned on **Reload at start-up** for a named image, and that setting is shown on the intercom as a chip.

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
- **TOT:** the `0x3B` handler's `min(tot,30)` clamp. M17 voice and longer digital transmissions need more than 30 s. Change the ceiling to a value the app enforces anyway (SignalDeck keeps its own watchdog, today 28 s; it would be raised to the new ceiling, never above 120 s). Operator-set, documented, legal.
- **Receive:** the same flag can lift the RX ~250 Hz cut for M17/POCSAG receive; the calibrated equalizer then becomes optional.

Acceptance (per C2): flat response within ±2 dB, limiter at the set deviation ±10 %, ≥ 85/90 M17 frames decoded by the plain decoder across three transmissions, POCSAG 100 % at 512 and 1200 bd, voice unchanged with the flag off, factory image unchanged after restore.

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
| **FW14** | Version-string round trip (load, verify, power-cycle, verify) — the first proof (B2) | S | yes | FW13 |
| **FW15** | Persistence research, read-only (B3) | M | yes | FW14 |
| **FW16** ✅ | `tools/fw-patch` build/check + host test (C1) | S | no | — |
| **FW17** | `bench/fwtest.sh` + the standard TX measurements, factory baseline recorded (C2) | M | yes | FW13, FW16 |
| **FW18** | Digital-audio transmit mode patch (D) measured to acceptance | L | yes | FW11, FW17 |
| **FW19** | TOT ceiling patch (D) | S | yes | FW9, FW17 |
| **FW20** | Receive-side flat mode (D) | M | yes | FW18 |
| **FW21** | Opt-in shipping, help, SignalDeck gating on the marker (E) | M | yes | FW18 |

---

## 9. First steps (this week)

1. **FW8** (an afternoon, no device): symbols into the repo, so nothing found is lost again.
2. **FW13 + FW14** (the loader and the version-string round trip): the single most valuable result, because it answers "can we load from SignalDeck" and "does it persist" at the same time with no RF risk.
3. **FW11** in parallel on the host: find the register tables; if H1 holds, FW18 becomes a table edit and the whole plan shortens.
4. **FW16/FW17** so that the first real patch is measured, not eyeballed.

Things not to do: no flash writes; no edits to band limits or power; no patch built on the old `0x0800xxxx` addresses; no bench transmission off 467.625 MHz low power; no loader test during an ISS pass.

---

## 10. Progress log

**2026-10-23 — FW8, FW16 done; FW11 largely done on the host.**

- **FW8:** `radio_firmware/symbols.csv` (`offset,kind,name,comment`, 44 rows, 3 external) plus `FwCskyImportSymbols.java` / `FwCskyExportSymbols.java`, wired into `scripts/fw1_ghidra_csky.ps1` (import after analysis, export last to the gitignored `symbols.export.csv`). Headless run: 36 functions + 4 labels applied, 40 exported back, exit 0.
- **FW11 (A4):** the RF IC is an **AT1846S**. `0xFD011220`/`0xFD01125C` are its register write/read; `+0x2BAC` is the AT1846S init sequence. Register `0x58` (the audio filter switch) is `0x8405` on analog (pre/de-emphasis on, voice high-pass active) and `0xBCFD` on DMR (filters bypassed). **H1 holds for emphasis and the sub-audio cut**: they are 16-bit immediates in this image. Still open: whether the compression and the ±4.5 kHz limit come from the AT1846S (`0x59`/`0x43`/`0x41`) or from DSP in the module's CPU (H2). New option **H4**: the DMR path does not use the voice filters at all, so routing the phone's PCM to the DMR modulator would be DC-coupled. Tool: `scripts/fw_at1846_regmap.py`. Details: `11` §21.
- **B2 correction:** `0x34` is answered from RAM `0x03052464`, which the resident code fills, **not** from the string at `+0x38464`. A string edit alone would never show. The marker patch `version-from-image` redirects the handler's pool word (`+0xA9E8`) to the image's string. The tag replaces the `UV4T` field (`DMR003.UVm1.V022`) so the OEM and SignalDeck version parsers still see `V022`. Corollary: **no image load has ever been proven** (the 2026-03 loads were judged by patches that did nothing). FW14 is the first real proof.
- **FW16:** `tools/fw-patch/` — `patches.toml` (factory MD5 pinned; `version-from-image` ready; `fm-flat-58` experimental: `0x58 = 0x840F` on the five no-tone sites + the `+0x333A` mask made a no-op), `build.py --tag`, `check.py`, `test_patches.py` (5 tests pass). Built and disassembly-checked: `DMR003.UVm1.V022` (marker only) and `DMR003.UVm2.V022` (marker + flat FM). Output in `radio_firmware/build/` (gitignored).
- **Next, on the device (owner's go-ahead; not during an ISS pass):** FW14 with `UVm1` — through the stock app's `DMRDEBUG.bin` path (ch. 07 §6, SignalDeck stopped) or SignalDeck's own loader once FW13 exists. Then `UVm2` against the factory baseline (FW17 measurements (1), (3), (5)).
