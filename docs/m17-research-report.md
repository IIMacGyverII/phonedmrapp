# M17 on a phone's built-in radio module: methods and results

**Project:** SignalDeck (an Android app that drives the radio module built into some rugged phones) and the
phonedmrapp research repository. **Device:** Ulefone Armor 26 Ultra. **Period:** 2026-10-22 to 2026-10-27.
**Status:** draft, to be shared once the hotspot and Atom XL checks are done. Receive and transmit work on this phone; every decode figure below comes from our own decoder, and the
independent cross-check (an MMDVM hotspot and the Mobilinkd decoder) is still open. Section 9 says exactly what is and
is not proven.

This report is written for the M17 Project. It describes the hardware, what blocks M17 on it, the two routes that got
around those blocks, the measurements, and the code. Everything here was measured on one phone, on the bench, inside a
Faraday cage, at low power on 467.625 MHz, with a bench callsign (`N0CALL`).

---

## 1. Summary

| Direction | Through the phone's normal audio path | Through our firmware changes |
|---|---|---|
| **Receive** | **Works** with an equaliser. The receive audio loses everything below ~250 Hz (−25 to −37 dB). A plain M17 demodulator decodes nothing. A decision-feedback equaliser trained once per phone decodes 100/100 frames at ±2.4 kHz. Works on unmodified (stock) module firmware. | **Works better.** One register write held in the RF chip (AT1846S `0x58` = `0xBCFD`) makes the receive audio flat from 50 Hz to 3.8 kHz. A fixed 41-tap linear equaliser per phone model then gives **98–100 % payload-exact frames at −87/−93 dBm** and ~95 % at −99 dBm on 18 independent transmissions. |
| **Transmit** | **Not possible** for standard M17 receivers. The transmit audio path removes everything below ~250 Hz (~−60 dB), pre-emphasises, and limits deviation at ~±4.5 kHz. 0 of 90 frames decoded, even with pre-shaped audio. | **Works.** Symbols are sent over the module's serial link into a ring buffer, RRC-shaped inside the module, and played through the transceiver chip's own DMR 4FSK modulator, bypassing the audio path. **1125/1125 frames payload-exact** on a 45 s transmission; spoken voice with Codec 2 3200 decoded as speech; SMS (packet mode) round trips. |

What made the difference was a mix of signal processing (equalisers that rebuild the missing low band) and reverse
engineering the module's firmware (to hold a filter open on receive, and to feed the modulator directly on transmit).

## 2. The hardware

The phone carries a UHF/VHF analog and DMR radio module. The parts that matter:

| Part | Role | What we learned |
|---|---|---|
| **HR-C7000** (C-SKY V2 core) | The module's SoC: runs the module firmware, the DMR baseband, and an FM path with transmit and receive sample RAMs | Firmware image 378 620 bytes, XIP at `0x0301A000`. Loaded over YModem from the phone and kept in flash. |
| **AT1846S** | RF transceiver: FM modulator and discriminator | Register `0x58` holds the voice filters: bit 6 voice high-pass, bit 7 TX pre-emphasis, bit 5 the 3.5 kHz low-pass. `0x8405` = all on (analog default), `0xBCFD` = all bypassed (what DMR mode uses). |
| **Everest ES8311** | The *phone's* audio codec, 8 kHz I2S in and out | Phone-side, outside the module. It shapes receive audio (a ~9 dB dip near 500 Hz on this phone) and is not reachable from module firmware. |
| UART | Phone ↔ module control at 57600 baud, a framed command protocol (`68 … 10`) | The only data link to the module. Audio does not cross it in stock firmware. |

Audio in stock operation: receive audio comes out of the module as analog audio into the phone's codec and reaches
apps as 8 kHz PCM. Transmit audio goes the other way. For FM voice that is fine. For M17 it is the problem, because
M17's 4FSK has a lot of energy below 300 Hz, and both directions filter that away.

## 3. Receive through the stock audio path (no firmware change)

**Method.** A HackRF One sent a 20 Hz to 3.8 kHz chirp and real M17 transmissions (link setup, 100 stream frames,
end-of-transmission marker; random payloads; 40/60/80/100 % of the standard deviation) to the phone, which recorded
its receive audio. The recording was aligned against what was sent.

**Receive response, relative to 1 kHz:** below 250 Hz −25 to −37 dB (a steep high-pass, most likely the sub-audible
tone filter), 300 Hz to 3 kHz within about 6 dB, noise above about 3.2 kHz. A plain M17 demodulator (matched filter
and slicer) decoded **0 of 100 frames** at every level.

**The fix: a decision-feedback equaliser (DFE).** Feed-forward over ±4 symbols at two samples per symbol, 16 to 48
past symbol decisions fed back (these rebuild the missing low frequencies), plus cubic and |x|·x terms for the
receiver's compression at full deviation. Trained once on one known transmission, then run blind on other independent
transmissions with its own decisions and per-frame timing tracking (the phone's audio clock drifts about 15 ppm).

| Test transmission (independent payloads) | Symbol errors | Decode |
|---|---|---|
| ±1.2 kHz, ±0.96 kHz (40–60 %) | 0.01 % | LSF CRC good, 100/100 frames |
| ±1.9 kHz (80 %) | 0.01–0.24 % | LSF CRC good, 100/100 |
| ±2.4 kHz (standard), two transmissions | 0.60–0.71 % | LSF CRC good, 100/100 each |

**Limits.** The equaliser is calibrated per phone, and how well a calibration transfers depends on the training
recording (86–98/100 with another full-deviation recording). Signal about −94 dBm at the phone. This is the receiver
SignalDeck uses on phones whose module still runs stock firmware.

## 4. Receive with the voice filter held open (one register)

Reverse engineering the module firmware showed the analog channel write stores AT1846S `0x58` = `0x8405` (all voice
filters on), while DMR mode uses `0xBCFD` (all bypassed). A small firmware addition (a host command that writes
`0xBCFD` and holds it until the next channel write) was enough:

| | 50 Hz | 100 Hz | 500 Hz | 3.8 kHz |
|---|---|---|---|---|
| Plain receive audio, vs 1 kHz | −27.6 dB | −24.5 dB | | −17.0 dB |
| With `0x58` = `0xBCFD` held | −0.6 dB | +1.2 dB | ~−9 dB dip (the phone's codec) | +1.7 dB |

On the held path the channel is **linear**: plain decoding still fails (~19 % symbol errors) because of a long linear
distortion (the 500 Hz dip and the AC coupling's group delay), but the symbol levels are exact ±1/±3. So a **fixed
linear equaliser** is enough: 41 taps, ±20 symbols, fitted by least squares on one recording, applied to the
matched-filter output before sync acquisition.

**Result on 18 independent HackRF transmissions** (other callsigns, random payloads, ±2.4 and ±1.9 kHz): every clip
locks with a good LSF CRC; payload-exact stream frames **98–100 % at −87 and −93 dBm, ~95 % at −99 dBm.**

Two lessons for anyone repeating this:
- **Score payload-exact frames, not "Golay 0".** Zero raw LICH errors says little about the payload.
- **The taps are per phone model, not per radio.** The dip belongs to the phone's codec, so the table ships per model.
  SignalDeck now also **self-calibrates**: after a clean call of 20+ frames it re-encodes the decoded frames, fits new
  taps on them (rejecting a frame whose re-encoded symbols disagree with the sliced ones on more than 5 %), and keeps the
  fit only if a later call, 6 dB weaker or from another station, decodes at least as well.

**A route we closed: streaming the transceiver's receive RAM.** The HR-C7000 has an FM receive sample RAM that holds a
flat, DC-coupled 8 kHz baseband once three registers are set. We streamed it to the phone over the UART at 230400
baud (gapless, 45 s with no missed halves). It turned out to be a **limited discriminator**: linear to about ±1 kHz of
deviation, then flat at a ceiling, so M17's outer symbols (±2.4 kHz) sit on the ceiling. A 30-frame transmission
decoded 4/30 payload-exact there against 96 % through the equalised audio path. No register we found moves the knee. The stream is
kept as a bench tool for modes inside ±1 kHz and for phones whose audio path cannot be made flat.

## 5. Transmit through the audio path: why it cannot work

**Method.** The phone transmitted M17 as audio; the HackRF captured it and an FM discriminator measured the deviation.

**Transmit response (PCM in → deviation):** below 250 Hz about −60 dB (hard high-pass), 400 Hz to 1 kHz flat,
pre-emphasis above 1.5 kHz (+5 dB at 2 kHz, +10 dB at 2.4 kHz), a **deviation limiter at about ±4.5 kHz** that the
pre-emphasised transitions hit even at low audio levels, compression before the modulator, and inverted polarity.

| Attempt | Result |
|---|---|
| M17 audio at three levels | 0/90 frames |
| Equaliser trained on the exact transmission | Cannot fit (MSE 0.65 against 0.02 on receive): the limiter destroys information |
| Audio pre-shaped (pre-emphasis removed, cut above 2.8 kHz) | Deviation still peaked at 4.1–4.4 kHz, nothing decoded |

Opening the filters from module firmware got the response flat from 300 Hz to 3.5 kHz, but the cut below ~250 Hz
stayed: the converters sit on the phone side (the ES8311), outside anything module firmware can change.

## 6. Transmit through the transceiver's modulator (firmware symbol engine)

The HR-C7000 has a transmit sample RAM (two halves of 256 samples, 32 ms each at 8 kHz) that feeds its modulator
directly, the path its own DMR mode uses. We added a small engine to the module firmware:

1. **Symbols over the UART.** The phone sends 4FSK symbols with a framed command (`0x40`) into a 2048-symbol ring in
   the module. An underrun emits zero and does not advance.
2. **Shaping in the module.** Each 8 kHz output sample advances 3/5 of a symbol (4800/8000). A polyphase root-raised-
   cosine table (5 phases × 9 taps) shapes the last 9 symbols. The integer model and the module's output match sample for
   sample.
3. **Into the TX RAM.** The refill interrupt writes the shaped samples, high byte at the low address. The phone's audio
   path is not involved at all.
4. **Ending cleanly.** The end command drains the ring, plays eight more half-buffers so the last frames and the EOT
   marker reach the air, then drops PTT and runs the stock unkey while the transmit state is still set. (Clearing the
   state first left the receiver off until the next channel write: a bug we hit and fixed.)

| Test | Result (our decoder) |
|---|---|
| 3 transmissions × 90 frames | link setup good, 90/90 frames each, Golay 0; deviation p99 2.79–2.90 kHz |
| 45 s transmission (the bench regression, run on every image) | **1125/1125 frames payload-exact**, end bit set, p99 ~2.85–2.90 kHz, no clipping |
| Spoken voice, 10 s, phone microphone → Codec 2 3200 → our encoder → engine | 247/247 frames, end bit, EOT; the decoded Codec 2 output is speech |
| M17 SMS (packet mode), 1, 5, 15 and 26-byte texts | transmit: CRC good, payload-exact, 3/3; receive (HackRF → phone): 9/9 and 3/3; a ping/pong both ways |

The same engine also gained generic opcodes (2- or 4-level symbols at any rational rate, a hold or polyphase pulse,
and a phase-continuous tone queue). Through them POCSAG, RTTY, MCW and FT8 transmit too. The transmit time-out is
120 s.

## 7. The software

All M17 code in SignalDeck is **written from the M17 specification**. We did not read or port libm17 (GPL-2.0-only)
or m17-cxx-demod; those are allowed only as independent bench tools (section 9).

| Piece | Where | Notes |
|---|---|---|
| Research modem (Python + NumPy) | `tools/m17-research/m17.py` | LSF, stream and packet frames, EOT; Golay(24,12) LICH; K=5 convolutional code with P1/P2/P3 puncturing; QPP interleaver; randomizer; RRC 4FSK; sync search, soft Viterbi, CRC. Checked against the spec's vectors: CRC("123456789") = `0x772B`, "N0CALL" = `00 00 4B 13 D1 06`, Golay(`0x0D78`) = `0x0D7880F`. |
| Receive studies | `tools/m17-research/` | `sounding*.py` (HackRF test signals), `analyze.py`, `eq.py`/`eq2.py`/`eqdecode.py` (DFE), `heldpath_eq.py` and `heldpath_rf_score.py` (fixed taps, the 18-transmission score), `fw27_stream_levelmap.py` (the receive-RAM ceiling). Our receive recordings are in `recordings-armor26/`. |
| Transmit studies | `tools/m17-research/` | `txan.py`, `txdfe.py`, `txpre_an.py`: capture → discriminator → response, DFE fit, pre-compensation. |
| App frame code | SignalDeck `ham/M17.java` | Encoder and soft-decision decoder, packet mode, from the spec. |
| App receivers | SignalDeck `ham/M17Receiver.java` (DFE, stock firmware), `ham/HeldPathReceiver.java` + `ham/HeldPath.java` (held path, fixed taps, live call following, self-calibration) | Taps per model in `assets/m17/held_<profile>.txt`. |
| Voice | Codec 2 3200 | The upstream C library (LGPL-2.1) built from source with the Android NDK. |
| Firmware patches | `tools/fw-patch/` | Patch builder, C-SKY stubs, the symbol engine; a build guard rejects any image that branches into or loads literals from a range it changed. |
| Bench runner | `tools/fw-bench/runner/` | `bench.py all`: boot, tone, the 1125-frame stream, receive, heat. Every image runs it before use. |

The repositories are public: <https://github.com/IIMacGyverII/SignalDeck> (the app, GPL-3.0-or-later) and
<https://github.com/IIMacGyverII/phonedmrapp> (research, tools, firmware notes).

## 8. Test method (so others can repeat it)

- **RF:** HackRF One (PortaPack) as the reference transmitter and receiver, 2 MS/s int8 IQ, FM at the M17 deviation,
  inside a Faraday cage, at low power on 467.625 MHz. A short dummy transmission first (the first HackRF burst after a
  pause is often silent), and 0.5 s of carrier after the EOT (`hackrf_transfer -n` cancels in-flight USB transfers).
- **Phone side:** the app's diagnostics record raw receive audio (`rxclip`) and send arbitrary transmit audio or
  symbol files, triggered over adb.
- **Scoring:** payload-exact frames against what was sent; LSF CRC; for the stream, the end bit and the EOT. Deviation
  as the 99th percentile of the discriminator over the frame body.
- **Firmware loop:** every image carries a tag in its version string, read back over the UART, so the phone always
  knows what is in the flash; the factory image restores the module.
- The HackRF bench procedures and pitfalls are collected in `docs/hackrf-bench-guide.md`.

## 9. What is proven, and what is not

**Proven on this phone, by our decoder:** the receive figures in sections 3 and 4, the transmit figures in section 6,
SMS both ways, and the Codec 2 voice path.

**Not yet proven:**
- **Interoperability.** Every decode so far is our own spec-written code on both ends. A shared convention error (symbol
  map, interleaver, randomizer, puncturing) would pass our tests and fail real M17 radios. An independent check is
  planned and waiting for hardware: an MMDVM duplex hotspot in the cage (M17 to and from a reflector), and the
  Mobilinkd `m17-demod`/`m17-mod` tools as decoder and encoder cross-checks
  (`radio_firmware/plan-independent-m17-check.md`). We would welcome the M17 Project's test vectors or a check with a
  real M17 radio.
- **A second phone.** The Atom XL, a phone with a different radio module family, is the next device to check against.
- **Other phones.** The equaliser taps are measured for the Armor 26 Ultra. Other phones with the same module family are
  expected to work on receive after their own calibration; transmit needs the firmware engine ported to their module image.
- **Weak signals below about −99 dBm** were not measured.

## 10. Questions we would like the M17 Project's view on

1. Is a receiver that equalises a high-passed FM discriminator (rather than requiring a flat one) of interest for other
   M17 hardware, for example handhelds whose audio path has a sub-audible filter?
2. Are there official test vectors for whole transmissions (LSF + stream + EOT, and packet mode) we should check against
   before the hotspot test?
3. Is the packet-mode reading in our SMS work right: P3 puncturing `[1,1,1,1,1,1,1,0]`, a 6-bit frame metadata field,
   protocol byte `0x05`, a null-terminated UTF-8 text, CRC-16 (`0x5935`, init `0xFFFF`) over type byte and payload?
