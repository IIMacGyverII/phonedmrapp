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

T1 continues. R4c (tag `R4c0`) polled `FM_ADDR_SW` inside the gated `0x26` key. The ack was held 358 ms and `SEND_START` came 7 ms after the ack, so the poll finished before the carrier and the air looped the zero tail. Do not reload `R4c0`. Do not stay inside `on_key` until the table ends. The next image returns from `on_key` at once with the first 512 samples still in both TX-RAM halves, sets a flag that is clear at boot, and enables mask bit 15 (`0x1100039C`) only for that key. A hook at the service task `+0x18A70` copies the next half while that flag is set, and does nothing when the flag is clear. Peak stored count at or below 6451. Same four `0x26` sites. If that hook cannot be gated so the boot stays silent, do not load the image. The PIC slot for `+0x54BB0` is still not a stored pointer. Do not write the ES8311 node. `0x3D` still waits. T4 stays closed.

## Goal and route list (owner, 2026-10-23: "discover every possible way we can get M17 to work")

Work the routes in this order. Each step ends in a report (`STATUS: REVIEW`). The next step is the next open item on this list. A route is closed only by a measurement or a firm reading, written up in `results.md`.

**Transmit (the hard part: the FM audio path cuts below ~250 Hz, phone-side analog, ch. 19 §19)**
- **T1: TX RAM through the C7000 FM modulator.** R3a3 through R3a7 put a square on the air through the DMR modulator. Silence leaves the square and drops the codec tone. Through A = 1024 the flat-top median tracked about 0.41 Hz per count. At A = 4096 the 40 Hz low-pass rms was 2266 Hz (0.55 Hz per count), the median was 1462 Hz, and the steady p99 was 3700 Hz. Another doubling of the square is predicted past the ±5 kHz stop, so A = 8192 is not an image. R3a8 put a 1 kHz sine at peak count 2048 on the air: the 1 kHz line was 923 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 27 Hz, and the steady p99 was 1217 Hz. R3a9 put the same sine at peak count 4096 on the air: the 1 kHz line was 1923 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 26 Hz, and the steady p99 was 2186 Hz. R3a10 (tag `R3b0`; the version field is four characters) put the same sine at peak count 5120 on the air: the 1 kHz line was 2261 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 14 Hz, and the steady p99 was 2674 Hz. The tone is 6% under ±2.4 kHz and the steady p99 is 11% over it. The sine scale compressed (1.18× for a 1.25× peak). R4a (tag `R4a0`) put a fixed RRC α = 0.5 pattern on the same path, every sample at or below count 5120. Steady p99 2774 Hz. The stored 10-sample shape is inverted on the air, −0.54 Hz per count, median r² 0.96 on 10 ms stretches. The 1 kHz line is 17 Hz. Four held symbol levels are absent. The long-term line is 796.875 Hz because the last two samples repeat the first two. R4b (tag `R4b0`) put one link-setup frame in that loop: 108 symbols of `0x77`, the 192-symbol LSF, sign flipped, peak count 6451. Steady p99 3148 Hz. The plain decoder accepted 43 of 43 loops, sync 0.999, aimed-waveform r² 0.81 and gain 0.79. A stream frame does not fit behind it in 512 samples. The UART command `0x3D` still needs a SignalDeck sender, which is outside the standing approval, so it waits. The FM refill interrupt was read on 2026-10-24. It is bit 15 of `SYS_INTERP_LIST`. The normal path blocks it. The task at `+0x18A70` clears it and does not copy samples. R4c (tag `R4c0`) was that poll. The `0x26` ack was held 358 ms and `SEND_START` came 7 ms after the ack. The carrier was unmodulated: steady p99 371 Hz, burst p99 346 Hz, 64 ms correlation 0.021, aimed-waveform r² 0. The poll walked the table before the modulator started, and the air looped the zero tail. The peak was not raised. The next image returns from `on_key` at once, with the first 512 samples still loaded, and refills from the service task `+0x18A70` only while a host key has set a flag and mask bit 15 is enabled. This is the main line.
- **T2: the C7000 DMR modem as a raw 4FSK source.**
  - `WORK_MODE` `0x22` is the built-in BER test. Read 2026-10-24: byte 3 of `0x34808` is 1 only when flag `0x324D7` is 1. Command `0x3F` sets that flag for the Hongrui pattern and for O.153 (strings at file `+0x38444` and `+0x38454`); the OEM BER screen sends O.153, and both values store the flag as 1. Byte 4 stays 0. The flag==2 arm is in the image and unused by the writers that name the flag. A normal channel leaves both bytes 0, and the first setup stores `0x6A` or `0x6E`. The helpers at `+0x18218`, `+0x186BC`, `+0x28904` and `+0x19438` write modem control words and status bytes. They fill no symbol buffer. No `0x22` image was built.
  - `RF_MODE` bit 7 and the filter controls, read 2026-10-24. The only full-word immediate store is the FM key-up at `+0x3EDDA`: `movi r3, 135; lsli r3, 5` = `0x10E0` (bits 12, 7, 6, and 5 set). Bits 6:5 are two-point. Bit 7 set is Document 2's sign inversion of the same ±1944/±648 Hz map, so +3 maps to −1944 Hz. ±2400 Hz is not on that map. Bit 12 is set and unnamed. `FM_BANDWIDTH` and `FM_DEV_COEF` are never stored, so they stay at reset. No RRC coefficient is written. The α = 0.5 that was on the air was the R4a host fill. The `0x22` path still writes neither `RF_MODE` nor `FM_BANDWIDTH`. No image.
  - Symbol buffer, read 2026-10-24. `+0x2A18` is 23 constant-length copies into modem RAM. The lengths are 2, 4, 9, 24, 27, and 36. The three 27-byte copies land at `0x16000030` and write `0x4D49E + n*27` once. Nothing fills a 256-sample half, and nothing holds PTT while a buffer drains. The only store of PTT = 1 is the FM key-up. No host symbol FIFO. No image.
- **T3: the AT1846S itself.** Read 2026-10-24. The asked registers are FM setup scalars. Programming Guide 1.4 register 30h bit 10 (`direct_reg`, "1=enable direct_reg", no further definition) is clear in every immediate, and no read-modify-write sets it. Guide section 5 `3aH[14:12]` is 000 (Tx nothing) or 100 (microphone) in every stored value, including both bandwidth-profile rows. The OpenRTX web table puts the voice source on `0x3C[15:14]`; the stores are `0x0407` and the 25 kHz profile's `0x1930`, both with bits 15:14 = 00 (microphone). `0x35` and `0x36` are never written. `0x41`, `0x42`, `0x43` and `0x44` are single gain, threshold, or deviation words. No host-symbol path. No image.
- **T4: a hybrid.** Only if T1–T3 all fail: what plain-M17 decode rate a standard receiver gets from the UVm6 path with the best pre-shaping (measured, not assumed). This is the fallback number.

**Receive (works today with the calibrated DFE; these aim at plain or simpler decoding)**
- **R-A: C7000 DMR demodulator symbols.** Read 2026-10-24. The only multi-byte read that starts at `0x160004E0` is the BER scorer's 36-byte snapshot (`+0x27E50`, called from `+0xAD64`). Thirty-three bytes are compared on the MCU. The UART output is a 6-byte score on command `0x21` subcommand 34, and the OEM dispatcher does not register `0x21`. The 27-byte records stay unnamed at `0x4D3AD`. No host symbol FIFO and no discriminator-sample buffer. No image.
- **R-B: the ES8311 ADC high-pass** (receive side, phone kernel). Reading registers with count 0 is a read, but it is still a write to a debug node, so ask the owner first (`STATUS: OWNER`).

**Vocoder and protocol (SignalDeck side, later):** Codec 2 3200 already encodes (DIAG `m17 --es enc`). Full M17 voice TX needs the frames (LSF, stream frames, CRC, Golay, convolutional code, puncturing, interleaving and randomising), written from the M17 spec. libm17 is GPL-2.0-only: never port it.

**Shared working copy.** Both AIs use the same folder (`D:\Documents\code\personal\phonedmrapp`). Commit only the files you changed (`git add <paths>`, never `git add -A` or `commit -a`). Never stash, reset or check out the other's uncommitted files.

## Last report

R4c, tag `R4c0`, one 3 s silence key at 467.625 MHz, low power. The `0x26` ack was held 358 ms and `SEND_START` followed it by 7 ms, so the poll finished before the carrier. Steady p99 371 Hz, burst p99 346 Hz, no 64 ms loop, aimed-waveform r² 0. The key-up click is not a stop. Factory restored: `0x34` `DMR003.UV4T.V022` at 05:27:02.250, VFO 467.625 at 05:27:04.069, no `DMRDEBUG.bin`. §6 is not met.

## Owner question

R-B is still unanswered. Transmit work continued on the instruction to keep going on M17 transmit. This question is not approved. T4 stays closed, because the TX-RAM path (T1) has not failed. `0x3D` still waits on a SignalDeck sender, which is already outside this approval, so that wait is unchanged.

May I write one count-0 value to `/sys/bus/i2c/devices/7-0018/es8311_debug/es8311` so the kernel log prints the ES8311 ADC high-pass registers? The 2026-10-23 reading of `es8311_store` says bits 23:16 = 0 reads registers and does not call `snd_soc_component_write`. Any other count would write the codec, and I would not send one. The node has not been written.
