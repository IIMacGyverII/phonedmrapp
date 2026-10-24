# Firmware bench handoff (Claude Code ↔ Grok Build)

STATUS: BENCH

This file is the mailbox between the two AIs working on ch. 19. Read it at the start of every session and after every push.

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

R3a2, from ch. 19 §23 (Claude Code's review of R3-0):

1. **Factory boot-radiation check** (factory image, receive only):
   - Tune the VFO to 467.625 MHz.
   - Start a HackRF capture there.
   - Run DIAG `restartmodule` and record through the boot.
   - Report whether the factory boot cycle radiates at all: duration, level, any modulation.
2. **Host:**
   - Find the flash-resident handler of the UART key command (`0x26` / SEND_START) in the command dispatch, and the unkey path.
   - Find a word in IRAM .bss (`0x31AF4`–`0x4DAB0`) that nothing references.
3. **R3a2:**
   - The key handler sets the flag word; the unkey path clears it.
   - The key-up stub (branch from IRAM PC `0x159F4` to XIP `0x03075000`, as in R3a1) does its TX-RAM setup, fill and filter clears only while the flag is set. Otherwise it does exactly the factory PTT store.
   - Host tests: with the flag zero, the stub reduces to the factory behaviour; every branch target is checked in runtime addresses.
4. **Load and measure:**
   - Tune the VFO to 467.625 before loading, and keep the HackRF recording on 467.625 through the load and the first boot.
   - Check the banner and the tag, and that nothing radiated at boot beyond the factory behaviour from step 1.
   - Then the R3 measurement: A = 256, a 3 s key; report whether the square's tops are flat, drooping or a bare carrier.
   - Raise A in 6 dB steps, under the ±5 kHz stop.
5. **Docs:** add the ±3.3 kHz narrow DMR outer deviation (1.7× the standard) to the DMR notes.

## Last report

(none yet under this protocol; previous results: `radio_firmware/results.md`, R3-0)

## Owner question

(none)
