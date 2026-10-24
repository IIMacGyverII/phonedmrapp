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
| **FW14** ✅ | Version-string round trip (load, verify, power-cycle, verify) — the first proof (B2). Done 2026-10-23 through the stock updater (§14): load proven, persists across power-cycle and reboot | S | yes | — |
| **FW15** ✅ | Persistence research (B3): answered by FW14 + §13, loads persist in SPI flash, restore = factory load | M | yes | FW14 |
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

End state: factory image. The tone-key restore's first `0x34` poll was empty after `onSuccess` 00:48:48.703; a later start of SignalDeck printed the banner at 00:51:13.856 and `DMR003.UV4T.V022` at 00:51:14.167. The silence-key restore did the same: `onSuccess` 01:01:45.469, no version on the first poll, banner 01:02:57.784 and `0x34` `DMR003.UV4T.V022` at 01:02:58.095 after a second start. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:02:58.648, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The ES8311 debug node was not written.

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
