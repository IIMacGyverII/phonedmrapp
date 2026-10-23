# POCSAG research tools (2026-10-20 / 2026-10-22)

Everything used for the POCSAG deep dive on the Ulefone Armor 26 Ultra, kept so it can be repeated on another phone
or radio module, where the audio path may be kinder (a flatter receive response, no internal limiter, or a transmit path
with less pre-emphasis). Findings: `docs/pocsag-deep-dive-2026-10-22.md`; summary row in `CLAUDE.md` §3.

Only our own bench material is here (HackRF test signals and what the Armor made of them). Third-party sample
recordings used for decoder checks are not included.

## What is here

| Path | What |
|---|---|
| `pocsag.py` | POCSAG encoder/decoder: `gen` (pages → 48 kHz NRZ wav + FM IQ for `hackrf_transfer -t`), `rx` (plain decode, both polarities; pages across batches; numeric and alphanumeric) |
| `apt_gen.py` | `fm_iq()` — audio to 2 MS/s int8 FM IQ (used by the generators) |
| `pocsag_train.py`, `pocsag_eq.py`, `pocsag_pll.py` | 2026-10-20 linear equalizer / PLL attempts (6–24 % bit errors) |
| `rx/make_prbs.py` | calibration signal: 576-bit preamble + N pseudo-random bits (fixed seed), optional Gaussian pre-modulation filter (BT) |
| `rx/make_pages.py` | six test pages (valid RICs, different texts), optional Gaussian filter |
| `rx/dfe.py`, `rx/dfe2.py` | first analyses: alignment, channel taps, plain / linear / DFE comparison |
| `rx/dfe3.py` | **trainer**: fractionally spaced feed-forward + decision-feedback equalizer fitted on known bits; env `FF` (half-bit taps each side), `FB` (feedback bits), `TRAIN` (blocks of 1664 bits used for training), `NL` (0 linear, 1 +x³, 2 +|x|x and x⁵, 3 + neighbour products), `GENIE=1` (feed back true bits: the model's error floor), `SAVE=eq.npy` |
| `rx/blind.py` | blind decode with a frozen equalizer (timing and polarity searched) |
| `rx/blind2.py` | two-pass self-training (did not help: overfits the repetitive certain bits) |
| `rx/blind3.py` | **the decoder that works**: DFE with BCH(31,21) correction inside the feedback loop |
| `rx/blindber.py`, `rx/drift.py` | bit-error scoring against the reference; clock-drift measurement |
| `rx/equalizers/` | trained equalizers for the Armor (`eqcal2500` = 2.5 kHz random-bit calibration; `eqg4500` = 4.5 kHz Gaussian BT 0.5, NL 2) |
| `rx/recordings-armor26/` | the Armor's receive audio (8 kHz, SignalDeck `rxclip`) of the HackRF signals below |
| `tx/` | transmit side: `mk8k.py` (8 kHz test audio for the phone), `cap2wav.py` (HackRF capture → flat discriminator audio), `txan.py` (plain-slicer errors, droop), `txfit.py` (transmit-path fit + regularised inverse), `mkpre.py` (pre-distorted pages), `prefilters/`, `recordings-armor26/` (what the HackRF received from the phone) |

The recordings' source signals are rebuilt exactly by the generators (fixed seeds):
`rx_cal2500/4500` ← `rx/make_prbs.py cal2500 2500 20000` (and 4500); `rx_calg4500` ← `make_prbs.py calg4500 4500 20000 0.5`;
`rx_p*` ← `pocsag.py gen p2500 --dev 2500 --repeat 4` (RIC 1234567, "DAPNET BENCH TEST 123"); `rx_q*` ←
`pocsag.py gen q2500 --dev 2500 --repeat 3 --ric 2345678 --msg "SECOND SESSION 456 ABC"` (that RIC is above the POCSAG
maximum, so its address word decodes as a message word: a test-data mistake, harmless for bit scoring);
`rx_pg*` ← `rx/make_pages.py pg2500 2500 0.5` (and 4500).

## Repeating it on another device

1. **Receive capture.** Tune the radio (VFO, analog, squelch open) to a quiet frequency the HackRF can transmit on; play
   a generated `.iq` with `hackrf_transfer -t <file>.iq -f <Hz> -s 2000000 -x <gain> -a 0` (send a short dummy first:
   the first transmission after a pause is often silent) while recording the radio's raw receive audio for longer
   than the signal (SignalDeck: DIAG `rxclip --ei ms N --es name X`, file in the app cache).
2. **Model floor.** `GENIE=1 FF=10 FB=250 TRAIN=7 python -P rx/dfe3.py <rx.wav> <source.wav>` on a random-bit
   calibration: if the error floor on the untrained blocks is ≲ 0.6 %, the BCH-in-the-loop decoder should work.
3. **Train and decode.** `FF=10 FB=250 TRAIN=12 SAVE=eq.npy python -P rx/dfe3.py ...`, then
   `python -P rx/blind3.py <a different reception>.wav eq.npy [ric msg]`.
4. **Things to check first on a new device:** the 4.5 vs 2.5 kHz loudness ratio (1.8 = linear, the Armor gives 1.15:
   a limiter), whether a plain slicer already works (`pocsag.py rx`), and the receive/transmit frequency response.
5. **Transmit.** `tx/mk8k.py prbs tx_cal.wav 12000` → transmit it from the phone (SignalDeck DIAG `txwav`, ≤ 28 s) while
   capturing with the HackRF (`hackrf_transfer -r ... -f <Hz-240000> -s 2400000`), `tx/cap2wav.py`, then `tx/txan.py`
   and `tx/txfit.py`: transmit is feasible when the inverse filter's drive fits the audio input (`tx/mkpre.py` reports
   the PCM peak; the Armor needs 13–20× too much).

Scripts were run with Python 3.14 + NumPy from their own folder (`rx/` scripts import `../pocsag.py`); run `make_prbs.py`
from this folder (it loads `apt_gen.py` from the working directory).
