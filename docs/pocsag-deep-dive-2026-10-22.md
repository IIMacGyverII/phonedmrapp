# POCSAG on the Ulefone Armor 26 Ultra radio — deep dive (2026-10-22)

Follow-up to the 2026-10-20 measurement ("not decodable from this radio's audio", 6–24 % bit errors). Bench: owner's
Armor on a VFO at 467.625 MHz (wide), HackRF at about 5 ft (receive tests), phone transmitting at low power (transmit
tests), SignalDeck bench commands `rxclip` (raw receive audio), `rxvol`, `txwav`. All scripts, trained
equalizers and our bench recordings are kept in `tools/pocsag-research/` (README: how to repeat it on another device). Third-party sample recordings provided by the owner were used for
decoder checks only and are not kept in any repository.

## Receive: decodable, with conditions

The receive audio is AC-coupled and band-limited, so NRZ data shows long-tailed inter-symbol interference
("baseline wander"); at high deviation the receiver's internal limiter also compresses it. The audio is not destroyed,
it is distorted in a fixed, learnable way.

| Decoder | Bit errors (unseen data) |
|---|---|
| Plain slicer | 21–23 % |
| Linear least-squares equalizer (61 taps) | 1.5–3.7 % (same recording) |
| Feed-forward (±5 bits, T/2) + decision-feedback (250 bits), true past bits fed back ("genie") | 0.6 % at 2.5 kHz deviation, 2.5 % at 4.5 kHz |
| Same, own decisions fed back | 3.5–4 % at 2.5 kHz, 6–12 % at 4.5 kHz (error propagation ≈ ×6) |
| **Same, with BCH(31,21) correction inside the feedback loop** (each codeword corrected before its bits are fed back; sync and idle words rewritten exactly) | **0 errors** — blind decode (timing and polarity searched, no reference) of an independent reception at 2.5 kHz with an equalizer trained only on a separate random-bit calibration: 96 of 96 codewords |

Conditions found:
- **Deviation:** at the standard POCSAG/DAPNET ±4.5 kHz the receiver's limiter compresses (4.5 kHz arrives only 1.15×
  as loud as 2.5 kHz instead of 1.8×; the module volume byte acts after the limiter, so it cannot help). Even with
  non-linear (cubic, |x|x, x⁵) feed-forward terms and a smoothed transmitter, the error floor stays ≈ 1–2 %; whole-page
  decoding was partial (3 of 6 pages found, damaged text).
- **Transmitter shape:** the equalizer learns the transmitter's waveform too. One trained on unfiltered NRZ failed on a
  Gaussian-filtered signal, and real-world transmitter recordings retransmitted through the radio did not decode with
  equalizers trained on HackRF signals.
- Clock drift between the phone's audio clock and the transmitter is negligible (≈ 15 ppm).
- Bit rate matters little to the method; 512 baud carries more low-frequency content (worse), 2400 less.

What a usable receiver would still need: multi-condition training (several deviations and transmitter filters) and
adaptation during reception using the codewords the error correction confirms; it would work best on transmitters at
reduced deviation. Promising but not finished; no SignalDeck feature yet. **Another phone or module may do better** (a flatter
audio path or no limiter): the tools are kept for that.

## Transmit: not feasible for real pagers

The phone's transmit audio path pre-emphasises (≈ +30 dB from 50 Hz to 2 kHz) and cuts low frequencies: raw POCSAG
audio arrives at a flat (pager-like) discriminator with **16.7–17.2 % bit errors**. A regularised inverse
("pre-distortion") filter fitted to a 24 000-bit calibration would bring a plain slicer to ≈ 0.4 % in simulation, but
needs **13–20× more drive than the audio input accepts** (PCM peaks of 270 000–400 000 for 2–3 kHz deviation; 63–71 %
would clip). At a deviation low enough to fit, real pagers would not receive it reliably. Not pursued further.
