# HackRF bench guide

How this project uses a HackRF One (with PortaPack) as a signal source and as a receiver against the radio module
built into an Android phone. The bench phone so far is the Ulefone Armor 26 Ultra, driven by SignalDeck (and, before
it, the DMRModHooks LSPosed module). Written 2026-10-27 from the private bench notes, `CLAUDE.md` §3, the bench tools
and `radio_firmware/results.md`. If a figure here and a newer `results.md` entry disagree, the newer entry wins.

For an agent on a different phone: every number below was measured on the Armor. The method carries over; the
levels, offsets and audio-path facts have to be measured again on the new phone.

---

## 1. Equipment and setup

### 1.1 Hardware

| Item | What we know |
|---|---|
| HackRF One + PortaPack | Has its own battery. A USB replug does not power it down; a full power-off of the PortaPack does (this matters for the recoveries in §3). |
| Bench PC | Windows. HackRF tools at `C:\Users\Joshua\tools\hackrf\hackrf_transfer.exe` (not on PATH; the runner default, override with `BENCH_HACKRF`). The device is WinUSB-bound; no Zadig step was needed. Early sessions used a PothosSDR extract of the same tools. No WSL (owner's rule). |
| Phone | Ulefone Armor 26 Ultra, radio module `DMR003` (HR-C7000 + AT1846S). Bench frequency 467.625 MHz, low power, unless a test says otherwise. |
| Faraday cage | Since 2026-10-24 the phone and the HackRF sit next to each other inside the cage and stay there (`radio_firmware/HANDOFF.md`, "Bench setup"). |
| Antennas | HackRF on its own (telescopic) antenna. Earlier benches ran at about 5 ft indoors with the telescopic antenna retracted. An outdoor dual-band mag-mount was on the HackRF once (2026-10-22, paging survey); see the receive-only rule in §2. |
| Decoders on the PC | direwolf 1.8.1 (`atest`, `gen_packets`, `decode_aprs`). multimon-ng 1.6.2, built with MSYS2 MinGW, kept outside the repository (`results.md`, "Independent pager decoder (2026-10-26, 02:23)"). |
| Coming | An Ubuntu box with the HackRF in the cage, worked over ssh (`radio_firmware/plan-independent-m17-check.md` §3), and an AURSINC duplex MMDVM hotspot ordered 2026-10-25 as the independent M17/POCSAG/DMR station (same plan, "Update 2026-10-25" and "Arrival-day runbook"). Neither is on the bench as of this guide. |

### 1.2 Frequencies and the capture offset

| Setting | Value | Why |
|---|---|---|
| Bench frequency | 467.625 MHz (`tools/fw-bench/runner/common.py`, `freq_hz`) | Default for comparability, not a limit inside the cage. |
| Capture centre | 467.385 MHz (`capture_hz`), i.e. the signal 240 kHz above centre | Keeps the carrier off the HackRF's DC spike. |
| Capture rate | 2.4 MS/s (`fs_iq`), decimate by 50 to 48 kHz deviation | Used by the runner, `txan.py` and most `results.md` entries. |
| Transmit rate | 2 MS/s int8 IQ | Every generator in the repo writes 2 MS/s. |
| DMR replay | 438 MHz default, 2 MS/s (`tools/dmr-replay/env.sh`) | A frequency the hotspot, the HackRF and the module all accept. |
| Radio's own range | 136.000–174.000 and 400.000–480.000 MHz (`CLAUDE.md` §3) | Outside it the module refuses the write and stays on the old frequency. |

### 1.3 Levels and gains that worked

hackrf_transfer gains: `-l` LNA 0–40 in steps of 8, `-g` VGA 0–62 in steps of 2, `-x` TX VGA 0–47, `-a` amp
0/1 (about +11 dB on TX, per `env.sh`).

**Capturing the phone's transmission (HackRF `-r`):**

| Situation | LNA / VGA | Source |
|---|---|---|
| Phone low power, 5 ft, a key | 16 / 16 | runner `lna_key`/`vga_key` |
| Long M17 stream key | 8 / 8 | runner `stream()` |
| Silent-boot capture (looking for stray RF) | 24 / 38 | runner `lna_boot`/`vga_boot` |
| Phone high power beside the HackRF | 0 / 0 (clip fraction 0, peak 13–14 of 127) | `HANDOFF.md`, heat rule |
| 2 m capture (VHF couples about 5× weaker than UHF at the HackRF) | 16 / 16 for 2 m, 8 / 8 for 70 cm | APRS bench note |
| Aim | mean \|x\| about 0.2–0.3 of full scale; 0.5 and above overloads | APRS bench note |

**Transmitting into the phone (HackRF `-t`):**

| Situation | Setting | Level at the radio |
|---|---|---|
| Inside the cage, beside the phone (2026-10-24 on) | `-x 20 -a 0` | about −88 dBm (`0x32` raw `0x40`, `results.md` 23:40 held-path entry) |
| 2 m SSTV, inches apart, before the cage | `-x 47 -a 0` | −73 dBm; `-x 20` was below the radio's ~−90 dBm squelch |
| NOAA APT bench at the placement of 2026-10-17 | `-x 47` | about −66 dBm |
| Phone outside on a big antenna, HackRF indoors (2026-10-22) | `-x 47 -a 1` | about −94 dBm |

The DMR replay harness says the same thing in its own words: start the TX VGA low and raise it until the radio opens
cleanly; too hot overloads the radio's front end and it does not decode.

---

## 2. Safety and hard rules

| Rule | Detail |
|---|---|
| The cage is the bench | Owner principle (2026-10-24, `HANDOFF.md`): inside the cage anything that cannot damage the equipment is allowed. 467.625 MHz and low power are defaults for comparability, not limits. |
| Outdoor antenna = receive only | While the HackRF is on an outdoor antenna, never run `hackrf_transfer -t` or any bench TX script. Bench signals were designed for a short indoor path; through an outdoor antenna they would really transmit on FRS/GMRS/ham frequencies with no licence context for the HackRF. Confirm with the owner that the HackRF is back on its own antenna before any `-t`. |
| On-air transmissions outside the cage | The on-air APRS and ISS work (2 m APRS on 144.390 MHz, `CLAUDE.md` §3) was the owner's station. An agent asks the owner before anything leaves the cage. |
| HackRF receive input | Keep it well under its damage level. The phone keyed close by already clips the IQ at low power and LNA 24 (clip fraction 0.3–0.4). High power at close range only with a documented margin: an attenuator, distance, or minimum gains with clip fraction near 0. Say which in the report. |
| Never key the phone while the HackRF transmits next to it | `HANDOFF.md`, equipment rules. |
| HackRF transmit gain | The lowest gain that gives the level the test needs. |
| Phone TX | Low power by default; the ±5 kHz deviation stop on anything we transmit (a 0.5 s slice at or over 5 kHz ends the step, runner `stop_hz`); the heat rule in `HANDOFF.md` for long keys. |
| Band | No transmitting outside the radio's allowed bands. The module enforces 136–174 / 400–480 MHz itself; no band-limit or power patches (owner's scope rule). |
| Identity in files | Bench callsigns only (`N0CALL`, `DMRTST-7`), test RICs only, no owner location, no passcodes, PINs, IMEIs or serials in scripts, logs or reports. |
| Owner's own data on the phone | Clean up exactly what a test created (coverage DB, test passwords, bench files by exact name). |

---

## 3. Pitfalls and recoveries

| # | Symptom | Cause | Fix |
|---|---|---|---|
| 1 | `hackrf_transfer -r` prints `streaming stopped (-1003)` within a second of the radio's `SEND_START`; afterwards every capture reads only the noise floor (mean \|x\| about 0.017, NOAA 162.500 and FM broadcast invisible), while TX still works and the device still enumerates | The phone keying at close range knocks the HackRF receiver out (seen 3 times on 2026-10-16/17; not every key does it) | Full PortaPack power-off and on. A USB replug is not enough (the battery keeps it up). Prevent with distance or attenuation. If a capture reads about 0.017 with the radio keyed, do not debug software. |
| 2 | Every later TX silently does nothing; `hackrf_info` still finds the device; or `hackrf_open()` fails with −1000; a `hackrf_transfer` stays in `tasklist` after taskkill reports success; the HackRF may keep radiating its last buffer (once an 88.5 Hz tone on 467.625 for 7+ minutes) | A transfer killed mid-USB-transfer (always a backgrounded `-R` repeat, 2026-10-18 and 2026-10-20) wedged in the WinUSB driver | Physical HackRF power-cycle. Prevent: never use `-R`, never background a transfer and kill it. For a long signal, concatenate the IQ file and let the process exit by itself. Before a run, `tasklist \| grep -i hackrf_transfer` must be empty. The runner refuses to start while one is running. |
| 3 | The first `-t` after a pause (or after an RX capture) produces no carrier at the radio (no `RECEIVE_START`); the identical second run works | Not understood; observed repeatedly from 2026-10-17 | Send a short dummy first. The runner sends 0.4 s of 1 kHz FM (`hackrf.dummy`); `dmrplay.sh` sends a 0.2 s zero-IQ primer; the Winlink gateway sends a dummy before each reply. |
| 4 | Separately from 3, the HackRF-to-radio link was silent on 2 of 4 or 2 of 5 runs on some days (APRS 2026-10-17, SAME) with identical files | Recorded as a HackRF hiccup; the notes do not pin the cause | Treat a silent run as the link, not the decoder: check 2 and 3, then power-cycle. |
| 5 | The last few hundred ms of a transmission never arrive (M17 device counts 27–28 of 30 frames; POCSAG damage in the last codeword) | `hackrf_transfer -n` cancels its in-flight USB transfers at the end, up to about 260 ms at 2 MS/s (six M17 frames) | Pad every bench transmission with 0.5 s of unmodulated carrier after the end (after the M17 EOT, `pocsag.py gen --pad 0.5`). Since 2026-10-27 the bench transfer also refuses an `-n` shorter than the file and rounds it up to a multiple of 262144 samples, repeating the last IQ sample (`results.md`, "POCSAG tail on the air"). `-n` is a sample count, not bytes. |
| 6 | A carrier measured about +800 Hz off | The radio's and the HackRF's crystal errors together; not separable without a reference (`CLAUDE.md` §3, fine tuning). The HackRF alone was calibrated at +3.55 ppm on NOAA 162.500 (FT8 note, 2026-10-22) | Remove the carrier offset in the demodulator (subtract the median deviation over the keyed part, as `txan.py` does). For DMR replay, record and replay on the same HackRF at the same rate so its error cancels. |
| 7 | RSSI (`0x32`) 15–20 dB low after a retune | The module needs about 0.7 s after a `0x23` retune; it answers only when its next reading is ready (about 0.52–0.60 s), and readings near 0.62 s are low | Never trust RSSI sooner than 0.7 s after a retune. Band scope steps are about 0.7 s. |
| 8 | Receiver deaf on VHF after a mode change: no `RECEIVE_START` even at −73 dBm | Channel byte `band=0` on a VHF frequency (also −92 dBm instead of −72 dBm on the same carrier at 162.500) | Use `band=1` on VHF. An app restart did not recover it; a phone reboot did. |
| 9 | A transmission cut about 2.7 s in after a retune | The stock channel-change transaction completes about 3 s after a retune and stops a transmission in progress | Wait at least 3.5 s after a retune before keying (`RETUNE_SETTLE_MS`). |
| 10 | The phone reports `SEND_START`/`SEND_STOP` normally but the HackRF sees no RF | Two channel-write paths sent back-to-back (`syncChannelInfoWithData` plus a direct `AnalogMessage`), stock-app era, 2026-10-17 | Single-path channel writes only; recover with any single-path write. |
| 11 | A bench firmware image stops radiating with unchanged bytes, or the symbol stream goes silent after an image that hung | State left by a wild branch (2026-10-26); image reloads, restart and power-off did not clear it | Load the factory image and key it once, then the next bench image (`CLAUDE.md` §3, M17 row). |
| 12 | The phone's USB connection drops about 1.5 s into a key | RF into the USB cable on some frequencies (144.770 MHz high power did it, 146.370 did not) | Not a HackRF or app fault; see `CLAUDE.md` §3 "TX vs. USB cable". |
| 13 | A write outside 136–174 / 400–480 MHz "tunes" but the HackRF signal is not heard | The module refuses it (`sr=1`) and keeps its previous frequency | Stay in band; the app's display is not the radio. |
| 14 | `Access denied` or `not found` when starting a transfer | Another process holds the HackRF (for example the Winlink test gateway's Java process or a leftover RX) | Stop that process, wait for its `hackrf_transfer` to exit, check `tasklist`. |
| 15 | hackrf_transfer prints "amplitude -inf dBfs" | Normal on this setup (APRS bench note) | Ignore. |

---

## 4. Standard recipes

Many generators and analysers from 2026-10-16 to 10-22 lived in session scratchpads (`scratchpad/...`) and are not in
the repository; they are named below so the method is clear, and marked "scratchpad". The repository copies are in
`tools/`.

### 4.1 Generating FM IQ from audio

The pattern everywhere: deviation signal in Hz, phase = 2π · cumulative sum of deviation / sample rate, int8 I/Q at
amplitude 110 (of 127), 2 MS/s.

| Tool (repo) | Use |
|---|---|
| `tools/fw-bench/runner/hackrf.py` `fm_iq(fs, seconds, dev_hz, tone=…, f0=…, f1=…)` | FM tone or linear sweep, 8-bit IQ |
| `tools/pocsag-research/apt_gen.py` | APT generator; its `fm_iq()` turns any audio into 2 MS/s int8 FM IQ and the POCSAG generators use it |
| `tools/pocsag-research/pocsag.py gen <prefix> [--baud 1200] [--dev 3500] [--ric …] [--msg …] [--repeat 3] [--pad 0.5]` | POCSAG pages: 48 kHz NRZ WAV + 2 MS/s IQ |
| `tools/pocsag-research/rx/make_prbs.py`, `rx/make_pages.py` | Random-bit calibration and six test pages |
| `tools/m17-research/sounding.py`, `sounding2.py` | Receive soundings: 1 s carrier, 20 Hz–3.8 kHz chirp at ±1.5 kHz, M17 at 100/60/40 %; or four independent M17 transmissions |

Scratchpad generators (rebuild if needed): `sstv_tx.py iq <wav> <iq> --dev 2500 --lead 1.5`, `same_gen.py <prefix>
--iq --dev 4000`, direwolf `gen_packets` → `apt_gen.fm_iq` at 3 kHz deviation for APRS.

### 4.2 Transmitting into the radio

```sh
# dummy first (pitfall 3), then the real file; finite file, never -R
hackrf_transfer -t dummy.iq -f 467625000 -s 2000000 -x 20 -a 0
hackrf_transfer -t signal.iq -f 467625000 -s 2000000 -x 20 -a 0
```

- Pad the file with 0.5 s of carrier after the end (pitfall 5).
- Before the cage: 2 m SSTV needed `-x 47` (`-f 144500000`). In the cage `-x 20 -a 0` is the usual level.
- Link check: a plain FM tone, then watch for `RECEIVE_START` / the RSSI on the phone.
- Record what the phone heard: SignalDeck DIAG `rxclip --ei ms N --es name X` (8 kHz WAV in the app cache), or in
  the module era `APRS_TX_TEST --es mode rxdump --ei secs N` (`Download/DMR/rxdump.raw`, 8 kHz stereo, take every other
  sample).

### 4.3 Capturing the radio's transmission and demodulating it

```sh
# 240 kHz below the signal, 2.4 MS/s, finite sample count, started before the key
hackrf_transfer -r key.iq -f 467385000 -s 2400000 -l 16 -g 16 -n 19200000   # 8 s
```

Demodulation (as in `tools/m17-research/txan.py`, `tools/pocsag-research/tx/cap2wav.py`, `tools/fw-bench/runner/fm.py`):

1. Mix down by 240 kHz, average blocks of 50 to 48 kHz, low-pass.
2. Discriminator: deviation = angle(z[n] · conj(z[n−1])) · 48000 / 2π, in Hz.
3. Find the keyed part from the power envelope; subtract the median deviation there (crystal offset, pitfall 6).
4. Report the body p99 (or p99.5) deviation and the clip fraction. The ±5 kHz stop applies.

Earlier scratchpad equivalents: `tx_capture.sh`, `msg_capture.sh` (pass the signal Hz as argument 8), `hackrf_fm.py`.

### 4.4 Tone, deviation and frequency sweeps

| Measurement | How | Source |
|---|---|---|
| Phone TX tone and deviation | `python runner/bench.py --arm tone [--ms 10000] [--power 1]`: body p99 and the 1 kHz line's deviation (`line1k_dev_Hz`, not a frequency) | `tools/fw-bench/README.md` |
| HackRF tone into the phone | `bench.py --arm receive`: 1 kHz FM at 2.5 kHz deviation, `-x 20`, a dummy first; the phone clip must carry the line | `runner/tests.py` `receive()` |
| Receive response | Chirp sounding (`sounding.py`) + `rxclip`, then `analyze.py <rx.wav>`; or tone tables, each tone captured three times, Goertzel line against the median 1 kHz line | `tools/m17-research/README.md`, `results.md` RC/RD entries |
| Synthesizer steps | DIAG `vfo --ei hz N` (low power unless `--ei power 1`) + `testtone --ei ms 2000`, carrier = mean FM instantaneous frequency; scratchpad `txsteps.sh` + `freqsteps.py`. Result: 500 Hz steps within 3 Hz | `CLAUDE.md` §3 |
| RSSI vs time after retune | Band scope DIAG `scope --ei settle N` with a HackRF CW carrier | `CLAUDE.md` §3 |

Two lessons: a tone table with no tone between 300 Hz and 1 kHz read "flat" across a 9 dB dip at 500 Hz, and a 1 kHz
tone cannot show dropped or stale 32 ms halves. Use a chirp or a dense tone list, and a known random signal for
timing.

### 4.5 APRS

- **RX into the phone:** direwolf `gen_packets` → FM IQ at 3 kHz deviation → HackRF at 144.390 MHz. Module era: `kissstart
  --ei freqhz 144390000` (without `freqhz` it does not retune), `adb forward tcp:8001`, scratchpad `kiss_rx_client.py`:
  6/6 frames. Passive decode: `tune --ei freqhz 144390000`, vectors, 12/12.
- **TX from the phone:** HackRF capture (LNA/VGA 16/16 on 2 m, 8/8 on 70 cm), demodulate, `atest`. 3/3 valid FCS on the
  first proof (2026-10-16, 467.375 MHz centre, 2 MS/s).
- The radio needs a 1.6 s lead-in before the frame; a frame at key-up never decodes. Lead-in bench (2026-10-20, 252
  packets): length decides, not kind; the bench link itself loses about 1 packet in 10.
- Python on Windows writes CRLF into packet text files; use `newline='\n'`.
- Decoder benchmark without RF: `AfskBenchTest` / `AfskSweepTest`, resources in `app/src/test/resources/aprs` (SignalDeck).

### 4.6 SSTV

- Generate: scratchpad `sstv_tx.py` (`refimage`, `encode <png> robot36|robot24c|martin1 <wav>`, `iq … --dev 2500 --lead 1.5`).
  Robot YCbCr is full range (Y 0..255 ↔ 1500..2300 Hz); a studio-swing encoder looks about 8 % low in contrast.
- Transmit: `hackrf_transfer -t file.iq -f 144500000 -s 2000000 -x 47 -a 0` (pre-cage placement). The channel must be
  `band=1` on VHF (pitfall 8).
- Score off-air captures with scratchpad `sstv_rx.py <wav> <png> --ref ref.png`. It needs the audio band-limited to
  800–2800 Hz before the Hilbert transform; FM hiss otherwise breaks VIS detection.
- Phone TX is limited to Robot 24 Color / Robot 12 BW / Robot 8 BW by the apps' 28 s watchdog (`CLAUDE.md` §3,
  transmit length).

### 4.7 NOAA APT

- The NOAA APT satellites were all switched off in 2025. The bench exists only for the decoder.
- `tools/pocsag-research/apt_gen.py <prefix> --iq --dev 17000` (synthetic pass, 8 kHz WAV + IQ). Scratchpad
  `noaa_bench.sh`, `apt_rx.py`/`apt_proto.py` scored by correlation with a reference image.
- At ±5 kHz the audio is clean (corr 0.99); at the real ±17 kHz the radio's narrow discriminator aliases harmonics to
  800/3200 Hz (corr 0.88, about 0.94 with the envelope notches).

### 4.8 SAME weather alerts

- Scratchpad `same_gen.py <prefix> --iq --dev 4000` (header ×3, 8 s tone, EOM ×3), module DIAG `wxstart --ei freqhz
  162500000`, HackRF `-t` at 162.5 MHz `-x 47`, `wxstop`.
- With `band=1` the radio reads the carrier at −72 dBm; `band=0` gives −92 dBm.

### 4.9 ISS and Doppler

- SignalDeck DIAG `sattest --es key iss-sstv|iss-aprs --el len` fakes a pass a minute out (nothing is keyed).
- With the radio fixed on 437.550 MHz, Robot 36 from the HackRF decoded clean at +3 and +6 kHz offset, speckled but
  decoded at +10 kHz; a retune mid-picture costs one thin line.
- Only the APRS and SSTV decoders may run below the squelch; the Morse decoder invents text from noise.
- The owner said on 2026-10-23 that ISS passes are not a priority.

### 4.10 FT8

- RX without RF: `Ft8BenchWav` → app cache → DIAG `inject` at a slot boundary, fired from a phone-side script.
- TX: DIAG `vfo 467625000` (low power), HackRF `-r` at f − 240 kHz, scratchpad `survey/ft8tx.py` cuts the window, decode
  with `Ft8RecordingsTest`. `txLatencyMs` = 320 gave DT −0.02 s. Restore with DIAG `ft8 --ez on false` and `vfooff`.
- The phone's `sh` is 32-bit: split `date "+%s %N"`. Wrap the whole `am broadcast … --es msg 'A B'` in one quoted string.
- SSB FT8 survey script (scratchpad `ft8survey/ssbft8.py`) needs an outdoor antenna, so receive only (§2).

### 4.11 Winlink test gateway

- Scratchpad `fakecms/FakeCms.java` (telnet CMS on loopback, `adb reverse tcp:8772 tcp:8772`, DIAG `wlbench --ei port 8772`).
- Scratchpad `rmsgw/RmsGateway.java`: half-duplex RMS `TEST-10` on 467.625 MHz, centre 467.385, 2.4 MS/s, decimate 50 to
  48 kHz, carrier squelch, its own decoder; sends a dummy TX before each reply. Modes `selftest`, `decode <iq>`, `txui <n>`.
- Stop its Java process before any other HackRF use (pitfall 14). Clear the test password afterwards and delete bench
  `.b2f` files by exact name. Real CMS/RMS stay untested on purpose.

### 4.12 Coverage maps

- GPS test provider: `appops set com.android.shell android:mock_location allow`, `cmd location providers add-test-provider
  gps`, `set-test-provider-enabled gps true`, `set-test-provider-location gps --location LAT,LON --accuracy 5` every
  about 2 s. Use unrelated coordinates, never the owner's area.
- HackRF carrier at different `-x` gains per position.
- Afterwards, always: remove the test provider, appops back to `default`, reset the channel's lat/lon, delete
  `coverage.db*` and `shared_prefs/coverage.xml`, delete any test export.
- Key-up paths were not bench-tested because a key near the HackRF kills it (pitfall 1).

### 4.13 POCSAG

- RX procedure (any phone): `tools/pocsag-research/README.md`, "Repeating it on another device". Generate with
  `pocsag.py gen` or `rx/make_prbs.py`, `hackrf_transfer -t <file>.iq -f <Hz> -s 2000000 -x <gain> -a 0` after a dummy,
  record with `rxclip`, then `rx/dfe3.py` (with `GENIE=1` for the model floor) and `rx/blind3.py`.
- TX from the phone: HackRF `-r` at f − 240 kHz, 2.4 MS/s, `tx/cap2wav.py`, `tx/txan.py`, `tx/txfit.py`.
- Through the firmware symbol engine (FW21 on), pages were decoded by our decoder and then by **multimon-ng as the
  independent check** (2026-10-26): demodulated 48 kHz WAV resampled to 22050 Hz signed 16-bit, `-a POCSAG512/1200/2400`,
  `-P auto`; `-P normal` decoded and `-P inverted` printed no address. The pass is the printed address and text; the BCH
  counters run over the whole file and are not a bit-error rate.
- Bench fact: a positive TX-RAM count deviates low on this radio.
- `pocsag.py rx` removes a 20 ms mean, which suits phone audio but damages the last word of a HackRF discriminator
  capture; use the codeword check for captures (`reviews.md`, PR 27 note).
- Test RICs only (the bench used 1000001–1000008 and 1234567).

### 4.14 M17

- **Our decoder:** `tools/m17-research/m17.py` (spec-written modem). Receive: soundings + `rxclip`, `analyze.py`,
  `eq2.py <rx.wav> <train part> 8 24 2`; held path `heldpath_eq.py`, `heldpath_rf_score.py`. Transmit: `txan.py`,
  `txdfe.py`, `txpre_an.py` on a capture at f − 240 kHz, 2.4 MS/s. FW27 receive-RAM stream: `fw27_stream_levelmap.py`
  on `captures/fw27-stream`.
- **Pass measure:** payload-exact frames, never "Golay 0" (that is zero raw LICH errors).
- A bench M17 file that worked (`results.md`, 2026-10-25): 1.6 s unmodulated lead, 30 stream frames, bench callsign to
  bench callsign, 0.5 s carrier tail; checked on the host before sending (lead p99 0 Hz, body p99 3165 Hz). HackRF at
  467.625 MHz, amp off, 2 MS/s, a dummy first. Pitfall from the same entry: an interpolator whose source axis was not in
  seconds compressed the files into one second and the phone listed nothing.
- Long-stream regression: `bench.py --arm stream [--frames 1125]` (1125/1125 payload-exact on FW26).
- **Independent check:** not done yet. Plan: `radio_firmware/plan-independent-m17-check.md` (m17-cxx-demod
  `m17-demod`/`m17-mod` on the Ubuntu box, then the MMDVM hotspot). GPL M17 code is a bench tool only, never ported into
  SignalDeck or the stubs.

### 4.15 DMR record and replay

`tools/dmr-replay/` (README there): `dmrcap.sh <name> [secs]` records a clip, `iqpeek.py` checks it is not clipped or
silent, `dmrplay.sh <name> [reps] [gap]` replays it one-shot with a zero-IQ primer and no `-R`, `dmrtest.sh [fw_tag]`
replays the library and writes a CSV run log for an A/B between images. Defaults: 438 MHz, 2 MS/s, capture LNA 24 /
VGA 20, amp off; replay TX VGA 20, amp off. Score from the radio side (un-mute, `0x2B` caller info). The clips to
record are in `capture-matrix.csv`; the slot rows need the duplex hotspot.

### 4.16 Firmware regression runner

`tools/fw-bench/runner/bench.py` wraps the guards above (`hackrf.py`: stuck-process refusal, a finite `-n`, a 0.4 s
dummy, kill on stall). Nothing keys or transmits without `--arm`. Every new image runs `all` first; results per image
go to `tools/fw-bench/results/<tag>/`. Trust it on another phone only after that phone's run is compared with its hand
measurements.

---

## 5. Where the results live

| What | Where |
|---|---|
| Firmware bench log, every capture's settings and numbers | `radio_firmware/results.md` |
| Reviews and accepted findings | `radio_firmware/reviews.md`; older ones in `docs/deep-dive/19-firmware-modification-plan.md` §11–§23 |
| Current bench task, standing approval, equipment rules | `radio_firmware/HANDOFF.md` |
| Runner results per image | `tools/fw-bench/results/<tag>/` (JSON + `summary.md`) |
| Archived Armor bench scripts (read-only) | `tools/fw-bench/armor-2026-10-snapshot/` |
| M17 | `docs/m17-deep-dive-2026-10-22.md`, `tools/m17-research/README.md`, `CLAUDE.md` §3 M17 row |
| POCSAG | `docs/pocsag-deep-dive-2026-10-22.md`, `tools/pocsag-research/README.md`, `docs/plan-pocsag-receive-and-web.md` |
| Independent checks | `radio_firmware/plan-independent-m17-check.md` |
| Range test plan (two radios) | `docs/plan-range-test.md` |
| Hard facts (tuning range, steps, RSSI settle, TX timing, USB cable) | `CLAUDE.md` §3 |

---

## 6. Not confirmed

- **Why the first transmission after a pause is silent** (pitfall 3) and why some days the link failed on 2 of 5
  runs (pitfall 4). The notes record the workaround, not the cause.
- **The HackRF's input damage level** in dBm. The rule is stated in `HANDOFF.md` without a number.
- **Attenuator values.** `HANDOFF.md` names an inline attenuator as one way to keep a margin; no source says which
  attenuator, if any, is on the bench.
- **The licence position.** No source in the repo states the owner's licence; §2 says only what the sources say (the
  on-air work was the owner's station, and agents ask before transmitting outside the cage).
- **Current cage placement and distance.** `HANDOFF.md` says "next to each other"; no measured distance or path loss
  is written down. The −88 dBm figure at `-x 20` is from one entry.
- **Scratchpad tools** (`sstv_tx.py`, `sstv_rx.py`, `same_gen.py`, `hackrf_fm.py`, `RmsGateway.java`, etc.) were in
  session scratchpads; they may no longer exist and would have to be rebuilt.
