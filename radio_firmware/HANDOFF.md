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

R3a4. Same DMR-modulator stub as R3a3 (`c7000-txram-dmr`), with the square amplitude raised one 6 dB step, A = 512. The big-endian halfword for +512 is `movi r1, 2`; for −512 it is `movi r1, 254`. Nothing else in the stub changes. Do not patch `+0x3074` or `+0x3EDFC`. Bit 4 of `0x11000080` stays clear.

1. Host-check the image: the four `0x26` sites still call `on_key` / `on_unkey`, and the fill halfwords are 512 / −512.
2. Tune the VFO to 467.625 before the load. Record the HackRF through the load and the first boot. Do not key if that boot radiates (peak ≥ 6 dB, or 0.2 s at +10 dB). Confirm the banner and the `0x34` tag.
3. One 3 s silence key (`txwav` of zeros), low power. Report the 15.625 Hz fundamental, the flat-top deviation, and the steady-window p99. The ±5 kHz stop applies to that steady window. The key-up click is a transient and is not a stop.
4. Restore the factory image. Leave the VFO on 467.625, low power. Do not raise A again in this image. Do not send M17 samples until this step says the deviation scaled and stayed under the stop.

## Goal and route list (owner, 2026-10-23: "discover every possible way we can get M17 to work")

Work the routes in this order. Each step ends in a report (`STATUS: REVIEW`). The next step is the next open item on this list. A route is closed only by a measurement or a firm reading, written up in `results.md`.

**Transmit (the hard part: the FM audio path cuts below ~250 Hz, phone-side analog, ch. 19 §19)**
- **T1: TX RAM through the C7000 FM modulator.** R3a3 puts an A = 256 square on the air through the DMR modulator; a silence key leaves the square and drops the codec tone. R3a4 is the 6 dB step. R4, a UART symbol command `0x3D` with the RRC shaper, waits until the deviation scale is measured and still under the stop. This is the main line.
- **T2: the C7000 DMR modem as a raw 4FSK source.**
  - `WORK_MODE` `0x22` is "physical layer" (guide Table 27): read whether it transmits raw symbols, continuously or only in bursts, and from where (TX RAM / registers).
  - Read the symbol map and filter controls: `RF_MODE[7]` gives two deviation maps; is there an RRC roll-off or filter-bypass setting? M17 needs ±2400 Hz outer and RRC α = 0.5; DMR uses ±1944 Hz and α = 0.2. This radio's narrow-band (12.5 kHz) DMR outer symbol is ±3.3 kHz, with AT1846S `0x30` left at `0x4026`. That is about 1.7× the standard ±1944 Hz, and the BTECH 6X2 still decodes it.
  - If the modem can hold PTT continuously and take symbols from RAM, M17 could be generated with no shaper of our own.
- **T3: the AT1846S itself.** Does it have a direct/DC modulation input or a TX test-tone generator with arbitrary data (registers `0x3A`, `0x30`, `0x41`–`0x44`, the tone generator `0x35`/`0x36`)? Read only.
- **T4: a hybrid.** Only if T1–T3 all fail: what plain-M17 decode rate a standard receiver gets from the UVm6 path with the best pre-shaping (measured, not assumed). This is the fallback number.

**Receive (works today with the calibrated DFE; these aim at plain or simpler decoding)**
- **R-A: C7000 DMR demodulator symbols.** In DMR receive, the C7000 slices 4FSK itself. Read whether raw symbols or a demodulator output can be read (RX RAM, registers) and passed over the UART. That would bypass the ES8311 high-pass on receive.
- **R-B: the ES8311 ADC high-pass** (receive side, phone kernel). Reading registers with count 0 is a read, but it is still a write to a debug node, so ask the owner first (`STATUS: OWNER`).

**Vocoder and protocol (SignalDeck side, later):** Codec 2 3200 already encodes (DIAG `m17 --es enc`). Full M17 voice TX needs the frames (LSF, stream frames, CRC, Golay, convolutional code, puncturing, interleaving and randomising), written from the M17 spec. libm17 is GPL-2.0-only: never port it.

**Shared working copy.** Both AIs use the same folder (`D:\Documents\code\personal\phonedmrapp`). Commit only the files you changed (`git add <paths>`, never `git add -A` or `commit -a`). Never stash, reset or check out the other's uncommitted files.

## Last report

R3a3 is done. Boot of `DMR003.R3a3.V022` was silent (143.5 s, peak +0.11 dB, clip 0; sha256 `667cfd127d3b403192066da8e67c3633905875a7370a56a4fc379f861d43ea40`). A 3 s codec-tone key radiated the 999.9 Hz sine at ±2.4 kHz and the TX-RAM square together (15.625 Hz fundamental 133 Hz). A 3 s silence key kept the square (fundamental 129 Hz, tops about ±104 Hz, 0.40 Hz per count) and the 1 kHz line was 1.2 Hz. A was not raised. The steady window stayed under ±5 kHz. Factory restored: `0x34` at 01:02:58.095 is `DMR003.UV4T.V022`, VFO 467.625, no `DMRDEBUG.bin`. §6 is not met.

## Owner question

(none)
