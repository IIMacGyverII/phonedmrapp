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
- SignalDeck owns the radio;
- no `DMRDEBUG.bin`;
- the test image may stay loaded. Owner, 2026-10-24: do not flash the factory image after every test. Load the next test image over the one already in the module. Flash the factory image (`0x34` `DMR003.UV4T.V022`) when there is a reason: a stop, a bad banner or tag, an unknown image, boot radiation, or leaving a known-good radio at the end of a session.

The radio may **stay on 467.625 MHz, low power**: there is no need to return to the NOAA channel.

## Current task

T1 continues. R4j (tag `R4j0`) is done. Do not reload it. The owner asked for the factory image. It is loaded: `0x34` `DMR003.UV4T.V022` at 09:45:33.593, banner at 09:45:33.282, VFO 467.625 at 09:45:35.253, no `DMRDEBUG.bin`. The next step is a read, not an image: find where `0x36` body `04` is produced after the stock unkey path, and build an image only if that status is a call the wake can make after `drop_ptt` without holding the `0x26` handler and without calling `0xE9C` if that call would key or drop the carrier a second time. Same loop. Same end frame. Same peak count 6451. Do not add a lead-in. Do not raise the peak. The next test image loads over the factory image. Restore the factory image again for a stop, a bad banner or tag, or boot radiation. §6 is not met by one transmission. The PIC slot for `+0x54BB0` is still not a stored pointer. Do not write the ES8311 node. `0x3D` still waits. T4 stays closed.

## Goal and route list (owner, 2026-10-23: "discover every possible way we can get M17 to work")

Work the routes in this order. Each step ends in a report (`STATUS: REVIEW`). The next step is the next open item on this list. A route is closed only by a measurement or a firm reading, written up in `results.md`.

**Transmit (the hard part: the FM audio path cuts below ~250 Hz, phone-side analog, ch. 19 §19)**
- **T1: TX RAM through the C7000 FM modulator.** R3a3 through R3a7 put a square on the air through the DMR modulator. Silence leaves the square and drops the codec tone. Through A = 1024 the flat-top median tracked about 0.41 Hz per count. At A = 4096 the 40 Hz low-pass rms was 2266 Hz (0.55 Hz per count), the median was 1462 Hz, and the steady p99 was 3700 Hz. Another doubling of the square is predicted past the ±5 kHz stop, so A = 8192 is not an image. R3a8 put a 1 kHz sine at peak count 2048 on the air: the 1 kHz line was 923 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 27 Hz, and the steady p99 was 1217 Hz. R3a9 put the same sine at peak count 4096 on the air: the 1 kHz line was 1923 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 26 Hz, and the steady p99 was 2186 Hz. R3a10 (tag `R3b0`; the version field is four characters) put the same sine at peak count 5120 on the air: the 1 kHz line was 2261 Hz, the 15.625 Hz line was 3 Hz, the 3 kHz line was 14 Hz, and the steady p99 was 2674 Hz. The tone is 6% under ±2.4 kHz and the steady p99 is 11% over it. The sine scale compressed (1.18× for a 1.25× peak). R4a (tag `R4a0`) put a fixed RRC α = 0.5 pattern on the same path, every sample at or below count 5120. Steady p99 2774 Hz. The stored 10-sample shape is inverted on the air, −0.54 Hz per count, median r² 0.96 on 10 ms stretches. The 1 kHz line is 17 Hz. Four held symbol levels are absent. The long-term line is 796.875 Hz because the last two samples repeat the first two. R4b (tag `R4b0`) put one link-setup frame in that loop: 108 symbols of `0x77`, the 192-symbol LSF, sign flipped, peak count 6451. Steady p99 3148 Hz. The plain decoder accepted 43 of 43 loops, sync 0.999, aimed-waveform r² 0.81 and gain 0.79. A stream frame does not fit behind it in 512 samples. The UART command `0x3D` still needs a SignalDeck sender, which is outside the standing approval, so it waits. The FM refill interrupt was read on 2026-10-24. It is bit 15 of `SYS_INTERP_LIST`. The normal path blocks it. The task at `+0x18A70` clears it and does not copy samples. R4c (tag `R4c0`) was that poll. The `0x26` ack was held 358 ms and `SEND_START` came 7 ms after the ack. The carrier was unmodulated: steady p99 371 Hz, burst p99 346 Hz, 64 ms correlation 0.021, aimed-waveform r² 0. The poll walked the table before the modulator started, and the air looped the zero tail. The peak was not raised. R4d (tag `R4d0`) returned from `on_key` in 5 ms. The hooks are the per-wake sites `+0x18B5C` and `+0x18B68`. The task entry `+0x18A70` is unchanged. `SEND_START` followed the ack by 5 ms. The 304 ms table played once: a decode of 0.04–0.40 s accepted the link setup and frames 0, 1, 2, 3, 4, and `0x8005`, Golay error 0. Steady p99 408 Hz is the zero tail. Burst p99 2758 Hz. The key-up click is not a stop. The peak was not raised. The table already fills the file. R4e (tag `R4e0`) wrapped that cursor. Silent boot. One low-power key on 467.625. The `0x26` ack returned in 4 ms and `SEND_START` followed by 6 ms. Steady p99 3075 Hz, so the carrier stayed modulated. The 240 ms correlation is 0.993. A decode from 0.04 s accepted the link setup and 27 stream frames, Golay error 0, and the window from 1.0 s accepted 53, Golay error 0. Frame numbers are only 0, 1, 2, 3, 4, and `0x8005`. Click p99 22987 Hz is not a stop. The peak was not raised. The end-of-transmission frame repeats every loop. R4f (tag `R4f0`) dropped that frame. Silent boot. One low-power key on 467.625. The `0x26` ack returned in 4 ms and `SEND_START` followed by 6 ms. Steady p99 3095 Hz. The 200 ms correlation is 0.991. A decode from 0.04 s accepted the link setup and 27 stream frames, Golay error 0, and the window from 1.0 s accepted 53, Golay error 0. Frame numbers are only 0, 1, 2, 3, and 4. Click p99 22918 Hz is not a stop. The peak was not raised. The 16-byte payloads are zeros. R4g (tag `R4g0`) set those bytes to 0 through 15. Silent boot. One low-power key on 467.625. The `0x26` ack returned in 7 ms and `SEND_START` followed by 6 ms. Steady p99 2886 Hz. The 200 ms correlation is 0.997. A decode from 0.04 s accepted the link setup and 27 stream frames, Golay error 0, and the window from 1.0 s accepted 53, Golay error 0. Every 16-byte payload is the bytes 0 through 15. Frame numbers are only 0, 1, 2, 3, and 4. Click p99 22905 Hz is not a stop. The peak was not raised. There is no end-of-transmission frame. R4h (tag `R4h0`) adds frame 5 with the end bit clear. Silent boot. One low-power key on 467.625. The `0x26` ack returned in 6 ms and `SEND_START` followed by 6 ms. Steady p99 2909 Hz. The 240 ms correlation is 0.995. A decode from 0.04 s accepted the link setup and 27 stream frames, Golay error 0, and the window from 1.0 s accepted 54, Golay error 0. Every 16-byte payload is the bytes 0 through 15. Frame numbers are 0, 1, 2, 3, 4, and 5. There is no `0x8005`. Click p99 22976 Hz is not a stop. The peak was not raised. The next image sends one frame with the end bit set when the key ends, and that frame is not in the loop. R4i (tag `R4i0`) stored that frame and waited for it inside `on_unkey`. Silent boot. One low-power key on 467.625. The key ack returned in 5 ms and `SEND_START` followed by 6 ms. The unkey ack returned in 867 ms, the full 1200-tick wait, and `SEND_STOP` followed by 11 ms. Steady p99 3257 Hz. The 240 ms correlation from 1.0 s is 0.940. A decode from 0.04 s accepted the link setup and 27 stream frames, Golay error 0, and the window from 1.0 s accepted 61, Golay error 0, then one frame 0 with Golay error 7. Every good 16-byte payload is the bytes 0 through 15. Frame numbers are 0, 1, 2, 3, 4, and 5. There is no `0x8005`. The carrier stayed at the stream deviation through 4.1 s because the wake stopped filling while the handler waited. Click p99 23024 Hz is not a stop. The peak was not raised. The next image sets the end bit and returns from `on_unkey`, and the wake drops PTT when the cursor reaches 0. R4j (tag `R4j0`) does that. Silent boot. One low-power key on 467.625. The key ack returned in 5 ms and `SEND_START` followed by 6 ms. The unkey ack returned in 5 ms. There is no `SEND_STOP`. The carrier is up for 3.76 s and falls 0.39 s after the unkey command. Steady p99 2914 Hz. The 240 ms correlation is 0.996. A decode from 0.04 s accepted the link setup and 27 stream frames, Golay error 0, and the window from 1.0 s accepted 61, Golay error 0. A sync search finds one frame `0x8005` at 3.685 s, score 0.997, Golay error 0, payload bytes 0 through 15, after frame 5. The fixed last-0.8 s window locked a sync at score 0.911 and missed it. Click p99 22781 Hz and the drop click p99 23392 Hz are not a stop. The peak was not raised. The test image stayed loaded until the owner asked for the factory image. That load is `0x34` `DMR003.UV4T.V022` at 09:45:33.593, VFO 467.625 at 09:45:35.253. This is the main line.
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

Owner request: the factory image was loaded over R4j0. Banner `开机初始化完成` at 09:45:33.282. `0x34` `DMR003.UV4T.V022` at 09:45:33.593. VFO 467.625 / 467.625 FM at 09:45:35.253, low power. No `DMRDEBUG.bin`. Nothing was keyed.

## Owner question

R-B is still unanswered. Transmit work continued on the instruction to keep going on M17 transmit. This question is not approved. T4 stays closed, because the TX-RAM path (T1) has not failed. `0x3D` still waits on a SignalDeck sender, which is already outside this approval, so that wait is unchanged.

May I write one count-0 value to `/sys/bus/i2c/devices/7-0018/es8311_debug/es8311` so the kernel log prints the ES8311 ADC high-pass registers? The 2026-10-23 reading of `es8311_store` says bits 23:16 = 0 reads registers and does not call `snd_soc_component_write`. Any other count would write the codec, and I would not send one. The node has not been written.
