# Plan: porting the module work to the next phone, as automated as it can be

Owner, 2026-10-24: **do not alter the Armor work in progress.** This plan prepares the next phone (first
candidate: the Unihertz Atom XL, `docs/multi-device-atomxl-findings.md`) so the port starts fresh from a ready
state, and it names the pieces that get built as we go, during bench waits or after the Armor route list in
`HANDOFF.md` is done. Nothing here is a current task unless `HANDOFF.md` says so.

## What the Armor cost, and what a port should cost

| Stage | Armor (2026-10) | Next phone, with this plan |
|---|---|---|
| Understanding the module (HR-C7000 + AT1846S, TX/RX RAM, filters, time-out, FM key-up) | weeks | **done**: chip facts, not firmware facts |
| Image reverse engineering (addresses of handlers, I²C routines, RAM constants, stub space) | days per item | hours: `tools/fw-port/find_symbols.py` proposes `symbols.csv`, a human checks |
| Patch build (tagged image from patch file + stubs) | exists (`tools/fw-patch`) | same tool, stubs relinked from `symbols.csv` instead of fixed offsets |
| Load and recovery proof | proven once (YModem over UART) | **per vendor, manual**: capture the stock loader, prove the factory restore first |
| Bench regression (response, M17 key + decode, receive clips, time-out, heat) | one ad-hoc script per test | one runner, one results table per image |
| Receive calibration (tone sweep → taps → SignalDeck asset) | by hand | one command |
| SignalDeck transport + profile | engine exists | the new transport layer (e.g. USB envelope) + a profile |
| Root, sepolicy, PTT keys, power | per phone | per phone, manual |

The rate limiter after this is **having the phone on the bench**; the loader proof is the step that can stretch.

## Stages, inputs and outputs

### 0. Preserve the Armor bench (done 2026-10-24)
The bench scripts the Armor work used lived only in a temporary folder. A snapshot of them is in
`tools/fw-bench/armor-2026-10-snapshot/` (read-only record; Grok keeps using its working copies). The runner in
stage 5 is distilled from them. Shared helpers in that snapshot: `camp.py` (phone over adb, DIAG extras,
status log), `r3_capture.py` / `r3a3_run.py` (HackRF capture and FM analysis), `factory_boot.py` (load,
boot capture, restore), `rc20_run.py` (tones, RSSI, HackRF TX), `rd10_run.py` (hold + receive clips),
`fw19_run.py` (streams, heat log), `m17.py` / `m17_stream_table.py` / `m17_rrc.py` (frames and shaping).

### 1. Phone survey
- **Have:** SignalDeck → Run all checks (device report).
- **Gaps the Atom XL showed:** no look at `/dev/ttyACM*` / `ttyUSB*` or at ports a HAL holds; no USB device list;
  no vendor HAL binaries; the probe left a serial port's speed changed.
- **Build:** those four additions, and a one-screen verdict at the end of the report: module family (from the
  `0x34` string), transport (UART direct / HAL / USB), audio path (TinyService, UART PCM, HAL PCM, ALSA), loader
  present (`updateDmr`-style HAL method or stock-app YModem), root state.
- **Owner's rule stands:** nothing with a callsign, passcode or location leaves the phone in the report.

### 2. Image analysis — `tools/fw-port/find_symbols.py`
- **Input:** one module image. **Output:** JSON with the version string, the command dispatch entries, the
  time-out timer and its struct, handlers identified by behaviour (0x3B writes the time-out struct, 0x34
  references the version string), free flash runs for stubs, and a comparison with a `symbols.csv`.
- **Status:** v0 validated on the Armor image (2026-10-24): version string, 26 dispatch entries (8 land exactly on
  `symbols.csv` rows), the timer at `+0x208` with struct `0x38C64`, the `0x3B` handler `+0xA308`, the `0x34`
  handler `+0xA7E8`, the 6 KiB free run at `+0x5AEFC` that the stubs already use.
- **Next:** identify more handlers by behaviour (0x23 analog = the one calling the AT1846S tune; 0x26 PTT = the
  FM key-up store `movi r3, 135; lsli r3, 5`; 0x40 slot = the empty case), the I²C write/read routines (the
  `0x58` register writes), the TX RAM and receive RAM constants (`0x16000000`, `0x160004E0` as literals), the
  UART task stack; emit a candidate `symbols.csv` in the existing format with a confidence per row. **The second
  image is the test**: the Atom XL's `DMR006.U4A.V082`, once dumped, must be found by anchors, not by memory.
- **Rule:** the script proposes, a human confirms every row before a stub is linked against it.

### 3. Patch build — `tools/fw-patch`
- **Have:** `build.py` (factory image + named patches → tagged image + sha256, refuses on any mismatch),
  `check.py` (attributes every changed byte), `test_patches.py`.
- **Build:** `patches.toml` sites and stub `bsr` markers expressed as symbol names resolved from a per-image
  `symbols.csv` (today they are Armor file offsets); the factory-image hash and the version-string layout per
  image; a `--image <name>` switch. The patch *designs* port unchanged: the `0x40` symbol ring and RRC shaping,
  op 6 hold, op 7 self-unkey (with the FW20 fix), the time-out floor.

### 4. Load and verify
- **Have:** SignalDeck DIAG load over the stock YModem path; the checks are fixed: `0x34` tag, boot capture on
  the HackRF under the radiation threshold, tag again after a module power-cycle.
- **Build:** one script that runs the three checks and writes the result row. The loader itself is per vendor
  (the Atom XL has `updateDmr` inside a HAL; the first job there is capturing how the stock app uses it and
  proving the factory restore, with the factory image saved before anything else).

### 5. Bench regression — `tools/fw-bench/` (to be distilled from the snapshot)
- One runner, one results table per image, one JSON per test, pass/fail against the written criteria:
  1. tone-table response, plain and held (R-D/R-E method), against the per-image reference;
  2. the 90-frame M17 key through TX RAM, captured and scored payload-exact (R4t criteria);
  3. the receive clips with the fixed taps, payload-exact score at two levels (R-F criteria);
  4. the time-out key: byte stored, ceiling honoured, status byte at expiry, no stray stop after op 7 (FW19/FW20);
  5. the heat log around a 30 s and a 45 s key (battery + `mtktsAP`-class zones; stop conditions from `HANDOFF.md`);
  6. the plain control.
- Every new image on any phone runs the same suite. **It is also the Armor's regression guard**, which is why it
  is the first piece worth building when the bench next waits.
- Rules the runner enforces: a dummy HackRF burst first; never a backgrounded `-R`; `-n` transmissions padded
  with 0.5 s of carrier; HackRF gain out of clipping (clip fraction reported); the ±5 kHz deviation stop.

### 6. Receive calibration
- **Have:** `tools/m17-research/heldpath_eq.py` (fit), `heldpath_rf_score.py` (score), SignalDeck asset format
  `assets/m17/held_<profile>.txt`.
- **Build:** one command: sweep → fit → score on held-out clips → write the asset → run the SignalDeck host test.

### 7. SignalDeck transport and profile
- **Have:** `RadioEngine` (protocol) + `DeviceProfile` (ports, audio backend, GPIOs, PTT keys, sepolicy).
- **Build for the Atom XL:** a framed transport (`7E 96 69 | route | cmd | rw | len | body | checksum | 81`, Internet
  checksum over route…body) under the same command set; the HAL or raw `ttyACM0` port; a 48 kHz stereo HAL audio
  backend; the time-out byte 120 as on the Armor.

## What stays manual, on purpose
Getting the factory image and the loader capture; root and policy on the phone; the physical bench; reading an
anomaly; owner approvals (`STATUS: OWNER`). The runner reports, a person decides.

## Order of building (does not change the Armor order in `HANDOFF.md`)
1. **Now (done):** the snapshot, `find_symbols.py` v0, this plan.
2. **When the bench next waits:** the regression runner from the snapshot (stage 5), test by test, each one
   checked against the result it reproduced on the Armor.
3. **When the Atom XL image is in hand:** `find_symbols.py` against it (stage 2), then the symbol-named patch
   build (stage 3).
4. **With the Atom XL on the bench:** stages 1, 4, 6, 7 in that order; the loader proof before any test image.
