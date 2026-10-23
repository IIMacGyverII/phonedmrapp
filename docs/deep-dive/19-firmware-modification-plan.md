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

What is still limiting is that high-pass. It is outside both sites these images patch. The next reading is where FM transmit audio actually enters (§12.2). The product remains a run-time digital-audio mode; these images are bench-only. End state: factory image verified, SignalDeck owns the radio, Weather zone channel 36 (NOAA WX4), no `DMRDEBUG.bin`.

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
- Still unread: where FM TX audio enters. It is either the C7000 FM chain into the AT1846S microphone input or the C7000's two-point modulator. Next to read: `+0x179C8…+0x17AB0` and `+0x17D54…`, the `WORK_MODE` writers.

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
