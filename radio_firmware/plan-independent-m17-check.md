# Plan: an independent M17 check for the firmware transmit route (2026-10-24)

**Owner:** IIMacGyverII. **Executes:** Grok Build on the bench, Claude Code for reviews. **Status:** plan; nothing below is done unless marked ✅.

## 1. Why, and what "independent" means

Every M17 decode figure so far (R4b–R4r) comes from `tools/m17-research/m17.py`, the modem we wrote from the specification. A sign, symbol-map, interleaver or randomizer convention error would pass that test and fail every real M17 radio. There is no M17 radio here yet; the owner's friend has one, remote, and an AtomXL is on order (same HR-C7000, not an official M17 radio either). So the reference for now is software that we did not write, and the HackRF is its antenna.

Two code families exist outside this repo: the Mobilinkd family (`m17-cxx-demod`, `m17-mod`; SDRangel's M17 plugins are built on it) and the M17 project's `libm17` (OpenRTX, Module17, the CS7000-M17 firmware). Passing the Mobilinkd decoder is a real independent check of the framing, codes and symbol conventions. The friend's radio later closes the libm17 side on the air.

**Licences.** `m17-cxx-demod` and `m17-mod` are GPL-3.0, `libm17` GPL-2.0-only. They run here as bench tools only. Nothing from either is read for, or ported into, SignalDeck (GPL-3) or the firmware stubs; SignalDeck's M17 encoder stays spec-written. This is the same rule the route list already states for `libm17`.

## 2. Facts that shape the plan (checked 2026-10-24)

| Fact | Consequence |
|---|---|
| SDRangel's M17 demodulator and modulator plugins are **Linux-only** (plugin readme: "This plugin is available only on Linux") | No SDRangel M17 on this Windows machine as installed. Needs WSL2 or a Linux box |
| SDRangel's REST report for the M17 demodulator carries only channel power, sample rates and squelch state; the callsigns, type, sync state, frame and BER data live in the GUI and its status log | SDRangel is the human-visible live view and a scripted **device controller**, not a scripted pass/fail source. The scriptable pass/fail is `m17-demod`'s text output |
| `m17-demod` reads a 48 kHz 16-bit mono **discriminator** stream from stdin and prints the link setup (`-l`: source, destination, type, nonce, CRC) and per-frame diagnostics (`-d`: DCD, EVM, deviation, offset, lock, clock, sample point, Viterbi cost; in BERT mode also BER and bits received); it writes 8 kHz audio to stdout | Our bench already produces the discriminator stream from the HackRF IQ (the `txan.py` / results pipeline). Decoded stream length = audio samples ÷ 320 per 40 ms frame. **BERT mode gives a bit error rate from an independent decoder**, the best quantitative figure we can get without a radio |
| `m17-mod` encodes 8 kHz 16-bit mono audio into M17 baseband (48 kHz 16-bit) or, with `-b`, a bitstream; `-S` sets the source callsign | An independent **encoder**, usable with no RF at all: its output through our decoder checks our decoder; our encoder's output through `m17-demod` checks our encoder |
| WSL is **not installed** here (`wsl --status`); `m17-cxx-demod` also offers a Windows build (VS 2019 + conda-forge codec2/boost/gtest, `win_build.bat`) | Environment choice below, owner action needed for WSL |
| HackRF tools live at `C:\Users\Joshua\tools\hackrf\` (not on PATH); captures are kept under `/tmp/fw1718/caps/*.iq` as int8 IQ at 2.4 MS/s with the signal 240 kHz above centre; the research modem already knows the BERT sync word (`SYNC_BER = 0xDF55`) but has no BERT frame generator | Phase 2 needs a converter and a BERT generator, both small |

## 3. Environment: pick one, in this order

- **A. WSL2 + Ubuntu (recommended).** One admin command (`wsl --install -d Ubuntu`), a **PC** restart (the phone is not touched), then `apt install build-essential cmake git libcodec2-dev libboost-program-options-dev libgtest-dev` and build `m17-cxx-demod` (minutes). Gives `m17-demod`, `m17-mod`, and later SDRangel from the Ubuntu package or the release `.deb` with WSLg for the GUI. The HackRF can be attached to WSL with `usbipd-win` when a live SDRangel view is wanted; the capture path can also stay on Windows and only the decode run in WSL (`wsl m17-demod` reads stdin across the boundary). **Owner action:** run the install command as administrator and restart the PC.
- **B. Native Windows build of `m17-cxx-demod`** via conda-forge if WSL is not wanted. Visual Studio 18 is installed; the upstream recipe names VS 2019 and may need small fixes. No SDRangel M17 this way.
- **C. A Linux machine or Raspberry Pi with the HackRF**, if one exists. Same software, no WSL.
- **D. Not suitable:** SDRangel on Windows (no M17 plugin). SDR++'s M17 decoder module on Windows is a visual check only (no API, no text output) and is left as a nice-to-have.

## 4. Phases

### Phase 1 — tools in place (no radio, no RF) — environment A or B

1. Build `m17-cxx-demod`; run its own `make test`. Record versions and commit hashes in `results.md`.
2. **Decoder cross-check:** `m17-mod -S <bench callsign>` on 2 s of 8 kHz audio (a 1 kHz tone is fine), baseband out; resample 48 → 8 kHz and run it through `m17.py`'s receiver. Pass: LSF CRC true, the callsign decodes, stream frame numbers consecutive, Golay error 0. This proves our **decoder** reads Mobilinkd's framing.
3. **Encoder cross-check:** take our modem's baseband for the R4r body (link setup + 3 stream frames + end), render at 48 kHz 16-bit, pipe into `m17-demod -l -d`. Pass: the `-l` line shows our source and destination callsigns with CRC OK, `-d` shows lock, and the audio output length is 3 × 320 samples (three frames). This proves our **encoder** is read by Mobilinkd's decoder, before anything touches the air. Any failure here is a convention error in `m17.py` and is fixed before Phase 2.
4. Add a BERT frame generator to `m17.py` (spec: BERT sync word, PRBS9 payload, 40 ms frames) and a `--bert` option in the table/symbol generators. Cross-check it the same way: our BERT stream into `m17-demod` must report a BER of 0 and a rising bit count.

Deliverables: `tools/m17-research/xcheck/` with the scripts (`iq2disc.py`: int8 IQ → 48 kHz discriminator PCM with the +240 kHz offset and a gain argument; `run_m17demod.sh`: pipe + parse `-l`/`-d`/BER into one JSON line), a note in `tools/m17-research/README.md`, results in `results.md`.

### Phase 2 — the kept captures (no radio)

1. `iq2disc.py` on `/tmp/fw1718/caps/r4r0_key.iq` and the R4k capture, then `m17-demod -l -d`. Calibrate the discriminator gain once so `-d` reports a deviation near 2400 Hz and an offset near the known +1 kHz; keep that gain in the script.
2. Pass: R4r gives the bench callsigns with CRC OK and three frames of audio; R4k gives the callsigns and a frame count that matches ours within the window the runner uses. Report both numbers side by side in `results.md`: "ours N / m17-demod M".
3. If `m17-demod` fails where ours passes, that is the finding this whole plan exists for. Diagnose with `-d`: a steady EVM with no lock points at sync or symbol-map conventions; a lock with a bad CRC at the randomizer, interleaver or puncturing; a sign error shows as "Unlocked" with a mirrored constellation. Fix `m17.py` or the table generator, then re-run Phase 1 step 3 until both agree.

### Phase 3 — every bench key gets the independent number

1. Extend the bench runner: after each key's capture, run `iq2disc.py | m17-demod` and append its JSON next to our decoder's line. One table row per key: tag, our LSF/frames, m17-demod LSF/frames or BER/bits, p99 deviation.
2. **BERT on the air.** With R4s (symbol streaming) use the BERT generator for the quality runs: a 10 s BERT stream per key, low power, 467.625 MHz, the usual stop rules. Pass for the §6 acceptance becomes "BER ≤ 1 × 10⁻³ over ≥ 40 000 bits on three keys" from the independent decoder, next to the "≥ 85 of 90 stream frames" figure from ours. Both are reported; the independent one is the one that counts.
3. Voice stays our decoder plus listening until an M17 radio is on the bench.

### Phase 4 — SDRangel, when a live view or an independent transmitter is wanted (WSL only)

1. Install SDRangel in WSL; attach the HackRF with `usbipd-win`; confirm the M17 plugins load (channel list in the GUI or the API's `/sdrangel/channels` report).
2. **Live receive view** of bench keys: HackRF input at 467.385 MHz, M17 demodulator at +240 kHz, FM deviation 2400, status log on. This is for eyes, not for the runner; the runner keeps Phase 3.
3. **Independent transmitter for the receive side:** the M17 modulator with the HackRF as sink, source/destination callsigns set through the API, voice from a file. This is a **HackRF transmission** and therefore an owner-present session under the standing rules (never from the outdoor antenna; keep the HackRF away from the phone when the phone keys; a dummy burst first). It feeds the receive-side work (R-C, the adaptive equalizer) with a waveform our modem did not make.
4. Device control through the REST API is scriptable end to end (device set, frequency, gains, start/stop, channel settings); only the decode results are not, see §2.

### Phase 5 — the friend's radio, later

What to send: the SignalDeck APK, the firmware image with its tag and SHA-256, the restore image, and a one-page procedure (tune, load, check `0x34`, key a BERT stream and a voice stream on an agreed simplex frequency at low power, record what the radio shows). What to ask back: whether the radio opens on the link setup, the callsigns it displays, whether voice is intelligible, and a phone recording of the audio. The friend's own Armor 26 lets him run the same build on his side, so phone-to-phone voice can be tried at the same time. This phase has no date; it starts when Phase 3 passes on BERT.

## 5. Pass criteria, in one place

| Phase | Pass |
|---|---|
| 1.2 | our decoder reads `m17-mod` output: LSF CRC, callsign, consecutive frames, Golay 0 |
| 1.3 | `m17-demod` reads our baseband: callsigns + CRC OK, lock, 3 frames of audio |
| 1.4 | our BERT stream → `m17-demod` BER 0 |
| 2 | R4r and R4k captures: callsigns + CRC OK in `m17-demod`; frame counts reported side by side |
| 3 | three on-air BERT keys, BER ≤ 1 × 10⁻³ over ≥ 40 000 bits each, from `m17-demod` |

## 6. Rules that do not change

467.625 MHz, low power, HackRF receive only unless the owner is present for a Phase 4 transmit session; the ±5 kHz stop; stubs gated on a host key and silent at boot; `git pull --rebase` before every load; no code from GPL M17 implementations into SignalDeck or the stubs; the phone is never rebooted or uninstalled by the bench. A PC restart for WSL is fine.

## 7. Owner actions

1. Decide the environment (A recommended). For A: run `wsl --install -d Ubuntu` as administrator and restart the PC once.
2. Later: one bench session present for the Phase 4 HackRF transmit tests.
3. Phase 5 when ready: the friend's radio and frequency.
