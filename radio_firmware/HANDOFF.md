# Firmware bench handoff (Claude Code ↔ Grok Build)

STATUS: REVIEW

This file is the mailbox between the two AIs working on ch. 19. Read it at the start of every session and after every push.

**Owner, 2026-10-24:** Claude Code is out of this loop. Do not wait on `STATUS: REVIEW`. After the report is pushed, take the next step on the route list. `STATUS: OWNER` still stops the work.

## Protocol

- **`STATUS: BENCH`**: Grok Build's turn. Do the task under "Current task", within the standing rules below.
  - Write results as before: `radio_firmware/results.md`, plus the ch. 19 §10 progress log.
  - Then edit this file: set `STATUS: REVIEW`, and replace "Last report" with 2–5 lines (what was done, the key numbers, the end state).
  - Commit and push. Always `git pull --rebase` before pushing.
- **`STATUS: REVIEW`**: Claude Code's turn. It reviews the push and writes the review in `radio_firmware/reviews.md`, puts the next task under "Current task", sets `STATUS: BENCH` and pushes.
  - Grok Build: while the status is `REVIEW`, wait and re-check this file every few minutes (`git pull --rebase`). Do not start new bench work.
- **`STATUS: OWNER`**: someone needs the owner (a decision, or anything outside the standing approval). Write the question under "Owner question", push, and stop until the owner answers.
- **Stop and set `STATUS: OWNER`, without guessing,** if anything is unclear, a stop condition triggers, or a step would need something outside the standing approval.

## Standing approval (owner, 2026-10-23, until the owner says otherwise)

**Bench setup:** the phone and the HackRF are next to each other **inside the Faraday cage** and stay there. The bench setup does **not** need to be re-confirmed before each run.

**Allowed without asking:**
- Phone transmissions on **467.625 MHz, low power only**, keyed by SignalDeck DIAG.
- HackRF **receive only**.
- Loading test images built by `tools/fw-patch` and restoring the factory image.

**Never:**
- any other transmit frequency;
- high power;
- any HackRF transmission;
- a write to the ES8311 debug node;
- `adb uninstall`;
- rebooting the phone;
- band-limit or power patches.

Any of these needs `STATUS: OWNER`.

**Every test image:**
- **Gate stubs on the key-up path.** Any stub on the FM key-up path must act only on a host-requested transmission and do nothing at module boot (ch. 19 §23).
- **Tune first.** Tune the VFO to 467.625 MHz before a load.
- **Check after loading:** the banner, and the tag via `0x34`.
- **Stop rule:** ±5 kHz on the deviation of what we transmit.

**End state after a run:**
- factory image verified by `0x34` (`DMR003.UV4T.V022`);
- SignalDeck owns the radio;
- no `DMRDEBUG.bin`.

The radio may **stay on 467.625 MHz, low power**: there is no need to return to the NOAA channel.

## Current task

T3, read only. No image, no key, no SignalDeck edit, no write to the ES8311 node.

The AT1846S is already identified. Its register write is `0xFD011220`, its read is `0xFD01125C`, and the init sequence is `+0x2BAC`. Register `0x58` is `0x8405` on analog and `0xBCFD` on DMR. DMR leaves `0x30` at `0x4026`. Do not re-derive those.

1. In the factory image, list every store of AT1846S registers `0x3A`, `0x30`, `0x41`, `0x42`, `0x43`, `0x44`, `0x35` and `0x36`. For each, give the file offset, the value written, and the function it sits in. `scripts/fw_at1846_regmap.py` is the existing map.
2. Say whether any stored value is a direct or DC modulation mode, or a test-tone path that can take arbitrary data instead of a fixed tone. Use a public AT1846S register description and cite it.
3. Write the reading in `results.md` and one §10 paragraph. If a register stays unnamed, say so. Do not build an image.

## Goal and route list (owner, 2026-10-23: "discover every possible way we can get M17 to work")

Work the routes in this order. Each step ends in a report (`STATUS: REVIEW`). The next step is the next open item on this list. A route is closed only by a measurement or a firm reading, written up in `results.md`.

**Transmit (the hard part: the FM audio path cuts below ~250 Hz, phone-side analog, ch. 19 §19)**
- **T1: TX RAM through the C7000 FM modulator.** R3a3 through R3a7 put a square on the air through the DMR modulator. Silence leaves the square and drops the codec tone. Through A = 1024 the flat-top median tracked about 0.41 Hz per count. At A = 4096 the 40 Hz low-pass rms was 2266 Hz (0.55 Hz per count), the median was 1462 Hz, and the steady p99 was 3700 Hz. Another doubling of the square is predicted past the ±5 kHz stop, so A = 8192 is not an image. R3a8 put a 1 kHz sine at peak count 2048 on the air: the 1 kHz line was 923 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 27 Hz, and the steady p99 was 1217 Hz. R3a9 put the same sine at peak count 4096 on the air: the 1 kHz line was 1923 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 26 Hz, and the steady p99 was 2186 Hz. R3a10 (tag `R3b0`; the version field is four characters) put the same sine at peak count 5120 on the air: the 1 kHz line was 2261 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 14 Hz, and the steady p99 was 2674 Hz. The tone is 6% under ±2.4 kHz and the steady p99 is 11% over it. The sine scale compressed (1.18× for a 1.25× peak). R4a (tag `R4a0`) put a fixed RRC α = 0.5 pattern on the same path, every sample at or below count 5120. Steady p99 2774 Hz. The stored 10-sample shape is inverted on the air, −0.54 Hz per count, median r² 0.96 on 10 ms stretches. The 1 kHz line is 17 Hz. Four held symbol levels are absent. The long-term line is 796.875 Hz because the last two samples repeat the first two. The UART command `0x3D` is the next item on this line. It needs a SignalDeck sender, which is outside the standing approval, so it waits. This is the main line.
- **T2: the C7000 DMR modem as a raw 4FSK source.**
  - `WORK_MODE` `0x22` is the built-in BER test. Read 2026-10-24: byte 3 of `0x34808` is 1 only when flag `0x324D7` is 1. Command `0x3F` sets that flag for the Hongrui pattern and for O.153 (strings at file `+0x38444` and `+0x38454`); the OEM BER screen sends O.153, and both values store the flag as 1. Byte 4 stays 0. The flag==2 arm is in the image and unused by the writers that name the flag. A normal channel leaves both bytes 0, and the first setup stores `0x6A` or `0x6E`. The helpers at `+0x18218`, `+0x186BC`, `+0x28904` and `+0x19438` write modem control words and status bytes. They fill no symbol buffer. No `0x22` image was built.
  - Read the symbol map and filter controls: `RF_MODE[7]` gives two deviation maps; is there an RRC roll-off or filter-bypass setting? The `0x22` path writes neither `RF_MODE` nor `FM_BANDWIDTH`. The sibling notes name no RRC register. M17 needs ±2400 Hz outer and RRC α = 0.5; DMR uses ±1944 Hz and α = 0.2. This radio's narrow-band (12.5 kHz) DMR outer symbol is ±3.3 kHz, with AT1846S `0x30` left at `0x4026`. That is about 1.7× the standard ±1944 Hz, and the BTECH 6X2 still decodes it.
  - If the modem can hold PTT continuously and take symbols from RAM, M17 could be generated with no shaper of our own. That buffer is not shown.
- **T3: the AT1846S itself.** Does it have a direct/DC modulation input or a TX test-tone generator with arbitrary data (registers `0x3A`, `0x30`, `0x41`–`0x44`, the tone generator `0x35`/`0x36`)? Read only.
- **T4: a hybrid.** Only if T1–T3 all fail: what plain-M17 decode rate a standard receiver gets from the UVm6 path with the best pre-shaping (measured, not assumed). This is the fallback number.

**Receive (works today with the calibrated DFE; these aim at plain or simpler decoding)**
- **R-A: C7000 DMR demodulator symbols.** In DMR receive, the C7000 slices 4FSK itself. Read whether raw symbols or a demodulator output can be read (RX RAM, registers) and passed over the UART. That would bypass the ES8311 high-pass on receive.
- **R-B: the ES8311 ADC high-pass** (receive side, phone kernel). Reading registers with count 0 is a read, but it is still a write to a debug node, so ask the owner first (`STATUS: OWNER`).

**Vocoder and protocol (SignalDeck side, later):** Codec 2 3200 already encodes (DIAG `m17 --es enc`). Full M17 voice TX needs the frames (LSF, stream frames, CRC, Golay, convolutional code, puncturing, interleaving and randomising), written from the M17 spec. libm17 is GPL-2.0-only: never port it.

**Shared working copy.** Both AIs use the same folder (`D:\Documents\code\personal\phonedmrapp`). Commit only the files you changed (`git add <paths>`, never `git add -A` or `commit -a`). Never stash, reset or check out the other's uncommitted files.

## Last report

T2 naming was read only. Nothing was keyed. Byte 3 of `0x34808` is the BER-test select: command `0x3F` sets flag `0x324D7` to 1, and the initializer copies that into byte 3. Byte 4 stays 0. A normal channel leaves both bytes 0 and takes `WORK_MODE` `0x6A` or `0x6E`. Neither path fills a symbol buffer. No `0x22` image. The radio is still the R4a factory restore: `0x34` `DMR003.UV4T.V022`, VFO 467.625, no `DMRDEBUG.bin`. §6 is not met.

## Owner question

(none)
