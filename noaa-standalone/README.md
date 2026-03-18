# NOAA APT Standalone Decoder

Standalone Python decoder for NOAA weather satellite APT (Automatic Picture Transmission) images.

Parallel to `sstv-standalone/` — used for algorithm development and testing before Android integration.

## Quick Start

```bash
pip install -r requirements.txt
python noaa_apt_decoder.py noaa1.wav
```

Output files (same directory as input):
- `noaa1_channelA.png` — Channel A (visible light or near-IR)
- `noaa1_channelB.png` — Channel B (thermal IR)
- `noaa1_combined.png` — Both channels side-by-side (1818×N px)

## NOAA Satellites

| Satellite | Frequency   | Status (2025) |
|-----------|-------------|---------------|
| NOAA-15   | 137.620 MHz | Active        |
| NOAA-18   | 137.9125 MHz| Active        |
| NOAA-19   | 137.100 MHz | Most active   |

## APT Signal Format

The VHF radio receives FM audio.  That audio contains a 2400 Hz AM subcarrier
carrying image data at 2 lines/second.

```
Line structure (2080 samples @ 4160 Hz):
  [Sync A 39][Space A 47][Image A 909][Telem A 45]
  [Sync B 39][Space B 47][Image B 909][Telem B 45]
```

## Test Recording

`noaa1.wav` — Real NOAA-18 or NOAA-19 pass, 11025 Hz mono, ~900 seconds.

## Options

```
python noaa_apt_decoder.py noaa1.wav --global-norm    # global not per-line normalisation
python noaa_apt_decoder.py noaa1.wav --no-combine     # no combined PNG
python noaa_apt_decoder.py noaa1.wav -o my_pass       # custom output prefix
```
