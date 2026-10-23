# M17 research tools (2026-10-22)

Scripts and our own bench recordings from the M17 deep dive on the Ulefone Armor 26 Ultra (findings:
`docs/m17-deep-dive-2026-10-22.md`). Python 3 + NumPy; run from this folder.

| File | What |
|---|---|
| `m17.py` | research M17 modem following the M17 specification: LSF / stream frames / EOT, Golay(24,12) LICH, K=5 convolutional code with the P1/P2 puncturing, the QPP interleaver, randomizer, RRC 4FSK deviation signal; receiver with sync search + frame cadence, soft Viterbi, CRC. Checked against the specification's vectors (CRC "123456789" = 0x772B, "N0CALL" = 00 00 4B 13 D1 06, Golay(0x0D78) = 0x0D7880F) and a clean loopback |
| `sounding.py`, `sounding2.py` | receive soundings for the HackRF (2 MS/s int8 FM IQ): a 20 Hz – 3.8 kHz chirp and M17 at 100/60/40 %; four independent M17 transmissions (seeds 1–4, 100/100/80/100 %) |
| `analyze.py` | aligns a received sounding with what was sent; receive-path response; plain M17 decode |
| `eq.py`, `eqdecode.py`, `eq2.py` | DFE studies: genie and decision-fed symbol error rates; train on one transmission, decode others (timing tracking per frame, full M17 decode) |
| `txan.py`, `txdfe.py`, `txpre_an.py` | transmit side: HackRF capture → FM discriminator → transmit-path response, plain decode, DFE fit; pre-compensated attempt |
| `recordings-armor26/` | `rx_sounding1.wav`, `rx_sounding2.wav` (the phone's raw receive audio, DIAG `rxclip`, with the `*_parts.json` timing of what was sent); `tx_m17snd.wav` / `tx_m17pre.wav` (the 8 kHz audio the phone transmitted, DIAG `txwav`) with their `.json`; `tx_capture_m17snd_dev48.npy` (the HackRF-demodulated deviation of the first transmit test, 48 kHz, aligned); `tx_response.npy` (transmit response, Hz of deviation per PCM unit vs frequency) |

Repeating it on another device: the receive soundings need the radio on a quiet frequency the HackRF can transmit on
(here 467.625 MHz) with the HackRF sending `sounding*.iq` (`hackrf_transfer -t … -s 2000000 -x 47 [-a 1]`, a short
dummy transmission first) while `rxclip` records; then `python analyze.py <rx.wav>` and `python eq2.py <rx.wav> <train
part> 8 24 2`. Transmit: put the `tx_*.wav` in the app cache, `txwav` at low power while the HackRF records at
f − 240 kHz, 2.4 MS/s, then `txan.py` / `txpre_an.py`. Raw IQ captures are not kept (100–150 MB each).
