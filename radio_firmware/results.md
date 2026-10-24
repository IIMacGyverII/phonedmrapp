# FW17 / FW18 — transmit-path measurements (2026-10-23)

HackRF receive only, phone transmitting. Ulefone Armor 26 Ultra, SignalDeck DIAG, Faraday cage. One frequency: **467.625 MHz, low power**. Nothing in this run was sent at high power, and the HackRF was never told to transmit.

The factory image was already `DMR003.UV4T.V022` before the first transmission (`0x34` at 14:33, again at 14:44, and again at 14:57 after a load that failed before any byte was written). Each later image was loaded with `tools/fw-patch/bench/fwload_stock.sh`, and `0x34` was read before any measurement of that image. After UVm4 the factory file was loaded back. `0x34` at 15:17:01 was `DMR003.UV4T.V022`. The pushed factory MD5 is `4426035392262ca54583c230c9e268e0`.

| Image | What it changes | `0x34` | File MD5 | Loaded |
|---|---|---|---|---|
| Factory | `DMR003.UV4T.V022-ORIGINAL.bin`, measured before any load | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | already in flash |
| UVm2 | tag + `fm-flat-58` only (AT1846S `0x58` = `0x84C5` at the five analog sites) | `DMR003.UVm2.V022` | `a0efdeae96bfa4ad92b05a5cfef57db8` | 15:00:39 |
| UVm3 | tag + `c7000-fm-flat` only (HR-C7000 `FM_BANDWIDTH` / `FM_DEV_COEF` stub) | `DMR003.UVm3.V022` | `63db613ff1569f1ba2f373b3a67da734` | 15:06:16 |
| UVm4 | tag + both of those patches | `DMR003.UVm4.V022` | `48ae76d0fec53a19375ce4288c12e80e` | 15:11:34 |
| Factory again | same original file | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 15:17:01 |

Host MD5 of each `radio_firmware/build/DMR003.UVm*.V022.bin` and of `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` matches the MD5 the loader printed after the push. Image size 378620 bytes.

## How the numbers were taken

HackRF One, `hackrf_transfer -r` only: `-f 467385000 -s 2400000`, finite `-n`, no `-R` and no `-t`. That parks the signal 240 kHz above the tuner center. The capture started first; the phone was keyed about 0.8 s later. Gain was set on the probe and then left alone for that image: factory LNA 32 / VGA 20; UVm2 and UVm3 LNA 32 / VGA 32; UVm4 LNA 24 / VGA 32 after the first probe sat at magnitude 73. No kept capture clipped (fraction of raw samples at full scale was 0). Mean baseband magnitude on the kept captures was about 6 to 35, except UVm2's M17, 1200-baud page and voice (magnitude 68–74) and one UVm3 limiter step (magnitude 95), all still unclipped.

The carrier sat about +760 to +840 Hz from the dial (the HackRF crystal). The demodulator mixes by exactly 240 kHz, decimates to 48 kHz, and subtracts the median during the keyed region. Tone deviation is the Goertzel fundamental of a window that lies inside the keyed carrier. M17, POCSAG and voice use the 99.5th percentile of the absolute instantaneous deviation over the aligned audio, with the key-up click left outside that window. Two earlier readings from this session, 11096 Hz on a sweep and 13937 Hz on factory M17, were that click and off-air discriminator noise. They are not measurements and those captures were not repeated.

Every file starts with 2.0 s of silence, because this radio passes audio only about 1.5 s after key-up. The phone was tuned with `vfo --ei hz 467625000` and not keyed until the log showed `VFO 467.625` and at least 4 s had passed. Low power is the DIAG default; `--ei power 1` was never sent. The 1 kHz `testtone` command was not used: at the factory gain a full test tone is a linear prediction past ±5 kHz. The probe is a −36 dBFS pair (1 kHz then 3.5 kHz, amplitude 519) instead.

A step whose linear prediction was over about 4700 Hz was not sent. 0 dBFS was not sent on any image. The hottest aligned deviation that was actually transmitted was 3411 Hz (UVm4 M17).

M17 is 90 frames, seed 1718, `N0CALL` to `N0CALL`, standard ±2.4 kHz outer-symbol scaling when the prediction allowed it, decoded with the plain decoder and no equalizer. The headline count is spec polarity. POCSAG is three short pages (`BENCH PAGE ONE/TWO/THREE`, RICs 1234567 / 200001 / 777777) at 1200 and 512 baud, rectangular NRZ scaled for ±4.5 kHz when the prediction allowed it. The headline polarity is lower frequency = 1. Voice is the sentence "Testing the transmit audio path. One. Two. Three. Four. Five." It was not listened to. The demodulated files are `radio_firmware/results/*_voice_demod.wav` (48 kHz, ±5000 Hz mapped to full scale).

## Factory — `DMR003.UV4T.V022`

Probe, −36 dBFS: 1 kHz **115 Hz** (0.221 Hz per PCM count), 3.5 kHz **250 Hz** (+6.8 dB). Pre-emphasis is present.

Frequency response at **−30 dBFS** (amplitude 1036). This is the shape table. Deviation and level relative to the 1 kHz tone:

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 Hz | 0 Hz | — |
| 100 Hz | 0 Hz | — |
| 150 Hz | 0 Hz | — |
| 200 Hz | 0 Hz | — |
| 300 Hz | 56 Hz | −12.4 dB |
| 500 Hz | 122 Hz | −5.7 dB |
| 1000 Hz | 234 Hz | 0 dB |
| 2000 Hz | 472 Hz | +6.1 dB |
| 3000 Hz | 654 Hz | +8.9 dB |
| 3500 Hz | 510 Hz | +6.8 dB |

The same sweep at −20 dBFS (amplitude 3277) scales the 300 Hz and 1–3.5 kHz tones by about 10 dB (1 kHz 627 Hz, 3 kHz 1874 Hz). The 500 Hz row at −20 dBFS reads 184 Hz and is not a flat plateau, so the −30 dBFS row is the one to use for 500 Hz.

Limiter, 1 kHz, separate files, low to high. Still linear. 0 dBFS was not sent (linear prediction 6513 Hz).

| Level | Deviation |
|---:|---:|
| −30 dBFS | 219 Hz |
| −24 dBFS | 468 Hz |
| −18 dBFS | 868 Hz |
| −12 dBFS | 1827 Hz |
| −6 dBFS | 3264 Hz |
| 0 dBFS | not sent |

M17 was held at outer-symbol amplitude 4312 PCM counts (file peak 6274; the standard scaling is 10841 and predicted 8548 Hz on this image's hottest tone). Aligned p95 2279 Hz, p99.5 **3070 Hz**. Regression against the unfiltered reference gives an outer-symbol figure of 60 Hz, because the high-pass removes the waveform. Plain decoder: **0 exact / 90** (0 frames found). Inverted: 0 exact / 90 (1 candidate, link-setup CRC failed).

POCSAG was held at 2694 PCM counts (standard 20326 predicted well over 5 kHz with the margin used for this image). This is not a ±4.5 kHz test.

| Baud | p99.5 | Plain bit errors | Inverted bit errors | Pages |
|---:|---:|---:|---:|---|
| 1200 | 1439 Hz | 1231 / 3904 | 1249 / 3904 | 0 / 3 |
| 512 | 1205 Hz | 1378 / 3904 | 1403 / 3904 | 0 / 3 |

Voice peak held to 4492 PCM counts. Aligned p99.5 **343 Hz**, rms 65 Hz. Of the demodulated power, 1.1% is below 250 Hz.

## UVm2 — AT1846S `0x58` = `0x84C5` only

Probe, −36 dBFS: 1 kHz **111 Hz** (0.215 Hz per PCM count), 3.5 kHz **70 Hz** (−4.0 dB). The 1 kHz gain matches the factory. The 3.5 kHz boost is gone.

Frequency response at **−30 dBFS**:

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 Hz | 0 Hz | — |
| 100 Hz | 1 Hz | −43 dB |
| 150 Hz | 0 Hz | — |
| 200 Hz | 2 Hz | −42 dB |
| 300 Hz | 179 Hz | −0.6 dB |
| 500 Hz | 222 Hz | +1.3 dB |
| 1000 Hz | 191 Hz | 0 dB |
| 2000 Hz | 218 Hz | +1.2 dB |
| 3000 Hz | 209 Hz | +0.8 dB |
| 3500 Hz | 142 Hz | −2.6 dB |

From 300 Hz to 3 kHz the response is within about ±1.3 dB of 1 kHz. 3.5 kHz is −2.6 dB. 50–200 Hz is still absent. The −20 dBFS sweep agrees at 500 Hz and above (1 kHz 611 Hz). Its 300 Hz row reads 264 Hz, where a linear scale of the −30 dBFS tone would be about 570 Hz, so the −30 dBFS row is the one to use for 300 Hz.

Limiter, 1 kHz, still linear. 0 dBFS was not sent (prediction 6445 Hz): −30 → 227 Hz, −24 → 450, −18 → 893, −12 → 1791, −6 → **3230 Hz**.

M17 was sent at the standard scaling (outer-symbol amplitude 10841, file peak 15772). p95 2932 Hz, p99.5 **3397 Hz**, regression outer 62 Hz. Plain **0 exact / 90**. Inverted **0 exact / 90**. Each polarity produced one candidate frame whose link-setup CRC failed.

POCSAG was sent at the standard ±4.5 kHz scaling (20326 PCM counts).

| Baud | p99.5 | Plain bit errors | Inverted bit errors | Pages |
|---:|---:|---:|---:|---|
| 1200 | 3392 Hz | 1099 / 3904 | 1091 / 3904 | 0 / 3 |
| 512 | 3044 Hz | 879 / 3904 | 907 / 3904 | 0 / 3 |

Voice at −14 dBFS (peak 6538). p99.5 **507 Hz**, rms 90 Hz. 0.5% of the demodulated power is below 250 Hz.

## UVm3 — HR-C7000 FM band-pass and pre-emphasis stub only

Probe, −36 dBFS: 1 kHz **114 Hz** (0.219 Hz per PCM count), 3.5 kHz **247 Hz** (+6.7 dB). Same 1 kHz gain, and the pre-emphasis is still there.

Frequency response at **−30 dBFS**:

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 Hz | 0 Hz | — |
| 100 Hz | 0 Hz | — |
| 150 Hz | 0 Hz | — |
| 200 Hz | 1 Hz | −47 dB |
| 300 Hz | 54 Hz | −10.8 dB |
| 500 Hz | 112 Hz | −4.6 dB |
| 1000 Hz | 189 Hz | 0 dB |
| 2000 Hz | 436 Hz | +7.2 dB |
| 3000 Hz | 603 Hz | +10.1 dB |
| 3500 Hz | 471 Hz | +7.9 dB |

This is the factory shape: the bottom octave is absent, and 2–3.5 kHz is boosted. The −20 dBFS sweep scales the same way (1 kHz 720 Hz, 3 kHz 2018 Hz, 50–200 Hz still under 1 Hz). The stub did not change the audio the HackRF received.

Limiter, 1 kHz, still linear. 0 dBFS was not sent (prediction 6504 Hz): −30 → 214 Hz, −24 → 439, −18 → 939, −12 → 1876, −6 → **3260 Hz**. Hottest tone on this image 0.616 Hz per PCM count (the 3 kHz tone).

M17 was held at outer-symbol amplitude 5455 (file peak 7937; standard 10841 predicted 8346 Hz). p95 2737 Hz, p99.5 **3352 Hz**, regression outer 0 Hz. Plain **0 exact / 90**. Inverted **0 exact / 90**. One candidate frame each, link-setup CRC failed.

POCSAG was held at 6819 PCM counts (standard 20326 predicted 12520 Hz).

| Baud | p99.5 | Plain bit errors | Inverted bit errors | Pages |
|---:|---:|---:|---:|---|
| 1200 | 2828 Hz | 1696 / 3904 | 1159 / 3904 | 0 / 3 |
| 512 | 2618 Hz | 1191 / 3904 | 1228 / 3904 | 0 / 3 |

Voice peak held to 4600 PCM counts. p99.5 **357 Hz**, rms 65 Hz. 0.7% of the demodulated power is below 250 Hz.

## UVm4 — both patches

Probe, −36 dBFS: 1 kHz **106 Hz** (0.205 Hz per PCM count), 3.5 kHz **68 Hz** (−3.9 dB). Same story as UVm2.

Frequency response at **−30 dBFS**:

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 Hz | 0 Hz | — |
| 100 Hz | 1 Hz | −45 dB |
| 150 Hz | 0 Hz | — |
| 200 Hz | 2 Hz | −43 dB |
| 300 Hz | 180 Hz | −1.7 dB |
| 500 Hz | 216 Hz | −0.1 dB |
| 1000 Hz | 219 Hz | 0 dB |
| 2000 Hz | 222 Hz | +0.1 dB |
| 3000 Hz | 206 Hz | −0.5 dB |
| 3500 Hz | 137 Hz | −4.0 dB |

The −20 dBFS sweep confirms it, including 300 Hz (571 Hz, the linear scale of the −30 dBFS tone). 300 Hz to 3 kHz is within ±2 dB of 1 kHz. 3.5 kHz is −4.0 dB at both levels. 50–200 Hz is still absent. Adding the C7000 stub on top of `0x58` leaves the curve where `0x58` alone put it.

Limiter, 1 kHz, still linear. 0 dBFS was not sent (prediction 6137 Hz): −30 → 223 Hz, −24 → 453, −18 → 859, −12 → 1711, −6 → **3076 Hz**.

M17 at the standard scaling (10841 / file peak 15772). p95 2941 Hz, p99.5 **3411 Hz**, regression outer 15 Hz. Plain **0 exact / 90**. Inverted **0 exact / 90**. One candidate frame each, link-setup CRC failed.

POCSAG at the standard ±4.5 kHz scaling (20326 PCM counts).

| Baud | p99.5 | Plain bit errors | Inverted bit errors | Pages |
|---:|---:|---:|---:|---|
| 1200 | 3400 Hz | 1119 / 3904 | 1135 / 3904 | 0 / 3 |
| 512 | 3040 Hz | 1219 / 3904 | 1023 / 3904 | 0 / 3 |

Voice at −14 dBFS (peak 6538). p99.5 **510 Hz**, rms 91 Hz. 0.3% of the demodulated power is below 250 Hz.

## What §6 asked for

Acceptance in `docs/deep-dive/19-firmware-modification-plan.md` §6: flat within ±2 dB from about 20 Hz to 3.5 kHz, limiter at the set deviation within ±10%, at least 85 of 90 M17 frames on the plain decoder across three transmissions, POCSAG 100% at 512 and 1200 baud, voice unchanged with the flag off, factory image unchanged after restore.

| Check | Factory | UVm2 | UVm3 | UVm4 |
|---|---|---|---|---|
| Flat ±2 dB, ~20 Hz–3.5 kHz | no | no | no | no |
| Limiter at the set deviation | not reached | not reached | not reached | not reached |
| M17 plain, exact frames | 0 / 90 | 0 / 90 | 0 / 90 | 0 / 90 |
| POCSAG pages, both bauds | 0 / 3 | 0 / 3 | 0 / 3 | 0 / 3 |
| Factory image after restore | yes | — | — | — |

No image reached 80 exact M17 frames, so the extra two 90-frame transmissions were not made. **No image meets the §6 acceptance.**

What the curves do say:

- AT1846S register `0x58` bit 7 is the pre-emphasis. UVm2 and UVm4 take the +6 to +10 dB boost from 2–3.5 kHz off. From 300 Hz to 3 kHz those two images sit within about ±2 dB of 1 kHz. 3.5 kHz is still −2.6 dB (UVm2) and −4.0 dB (UVm4).
- The cut below about 250 Hz is still in the path on every image, including both patches together. 50–200 Hz is about −40 dB or lower against 1 kHz. Mid-band gain is the same on all four (0.20–0.22 Hz per PCM count at 1 kHz). `0x58` bit 6, the voice high-pass bit in the OpenRTX layout, did not open that octave. The HR-C7000 stub did not either: UVm3 matches the factory curve, and UVm4 matches UVm2.
- That hole is why the standard-level M17 and POCSAG files on UVm2 and UVm4 still fail a plain decode. Those two were the ±2.4 kHz and ±4.5 kHz stimuli. Measured p99.5 stayed near 3.0–3.4 kHz, under the ±5 kHz stop. Bit errors on the pages stayed 23–31% of 3904 bits, and no page completed. The outer-symbol regression against the unfiltered M17 reference collapses (15–62 Hz) because the low-frequency part of the waveform is gone.
- The limiter ceiling was not measured. A 1 kHz tone was still linear at −6 dBFS (3076–3264 Hz). The 0 dBFS step predicted 6100–6500 Hz and was not sent. The earlier ±4.5 kHz ceiling was not re-measured in this run.
- Voice on the flat images is a few hundred hertz of deviation (p99.5 about 510 Hz) with well under 1% of the power below 250 Hz. Judged from that spectrum, not by ear.
- Receive was not compared. Register `0x58` also changes receive, and these images were not left loaded to listen. Weather channel 36 was at the noise floor, and the HackRF was not used to transmit.

The factory image is back in flash and `0x34` reads `DMR003.UV4T.V022`. SignalDeck owns the radio. The active channel is **36, NOAA WX4, 162.425 MHz**, in the Weather zone. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. These four images are bench comparisons. The product path is still a run-time digital-audio mode, not one of these files.

# UVm5 / UVm6 / UVm7 — CTCSS bits and the C7000 canary (2026-10-23, 16:06–16:21)

Same rules as the run above. HackRF receive only. Phone at **467.625 MHz, low power**. `0x34` at 16:06:48, before the first load, was `DMR003.UV4T.V022`. Each later image was loaded with `fwload_stock.sh`, and `0x34` was read before any transmission on that image. The factory file was loaded back at the end. `0x34` at 16:21:10 was `DMR003.UV4T.V022`. The pushed factory MD5 is `4426035392262ca54583c230c9e268e0`.

The host reading before these images: a no-tone analog `0x23` does run `at1846_set_ctcss_dcs`. `apply_analog_config` calls the flash FM tune (the `0x58` immediate at `+0x3054`, then the branch at `+0x3074`) and then, because the analog struct's first byte is 0, the IRAM tune. That tune is the only caller of `at1846_set_ctcss_dcs`. The diag VFO sends `rxType` 0, so the function takes the read-modify-write at `+0x3332`: it reads register `0x58`, masks with `0xFFF7`, and writes it back. That clears bit 3 after the patched immediate. UVm5 and UVm6 change the immediate halfword at `+0x333A` from `0xFFF7` to `0xFFFF`. The opcode halfword is unchanged. The write-back then stores `0x58` as it was.

| Image | What it changes | `0x34` | File MD5 | Loaded |
|---|---|---|---|---|
| UVm5 | tag + `0x58` = `0x84DD` at the five sites + mask `0xFFFF` at `+0x333A` | `DMR003.UVm5.V022` | `1723fa40729deb7d945cdcf5363bf99f` | 16:09:29 |
| UVm6 | tag + `0x58` = `0x84FD` at the five sites + the same mask | `DMR003.UVm6.V022` | `3f22fcc98cf280512439aab9c646b97a` | 16:13:50 |
| UVm7 | tag + C7000 stub, `tr_sig_lim` `0x02` (`FM_DEV_COEF` `0x00021010`). No `0x58` change | `DMR003.UVm7.V022` | `d5c2dde1b66262a9485d726b9193f085` | 16:18:12 |
| Factory again | `DMR003.UV4T.V022-ORIGINAL.bin` | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 16:21:10 |

`0x84DD` is UVm2's `0x84C5` plus bits 3 and 4 (CTCSS high-pass and low-pass bypass). `0x84FD` also sets bit 5 (voice low-pass bypass). The DMR immediate `0xBCFD` was not patched. Host MD5 of each built file matches the MD5 the loader printed after the push.

HackRF gain was LNA 24 / VGA 32 for all three images, taken from the previous run and not changed: the probe magnitude was 12–15 and nothing clipped. Carrier offset on the kept captures was +801 to +837 Hz. No step predicted past the stop, and none measured past it. The hottest aligned deviation transmitted was 3397 Hz (UVm5 M17).

The −30 dBFS sweep is the shape table (amplitude 1036). The 50/100/200/300 Hz rows were then repeated at −24 dBFS (amplitude 2067) and −18 dBFS (amplitude 4125). Neither image was flat down to 50 Hz, so the −3 dBFS limiter step, the two extra M17 transmissions and the voice clip were not sent.

## UVm5 — `0x84DD` and the mask kept

Probe, −36 dBFS: 1 kHz **110 Hz** (0.213 Hz per PCM count), 3.5 kHz **70 Hz** (−3.9 dB). Same shape as UVm2.

Frequency response at **−30 dBFS**, deviation and level relative to the 1 kHz tone:

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 Hz | 0 Hz | — |
| 100 Hz | 2 Hz | −40 dB |
| 150 Hz | 0 Hz | — |
| 200 Hz | 2 Hz | −43 dB |
| 300 Hz | 186 Hz | −1.6 dB |
| 500 Hz | 220 Hz | −0.1 dB |
| 1000 Hz | 223 Hz | 0 dB |
| 2000 Hz | 227 Hz | +0.2 dB |
| 3000 Hz | 213 Hz | −0.4 dB |
| 3500 Hz | 140 Hz | −4.0 dB |

300 Hz to 3 kHz is within ±2 dB of 1 kHz. 3.5 kHz is −4.0 dB, as on UVm4. 50–200 Hz is still absent.

The same four low tones at the two higher levels. 300 Hz tracks the level (186 Hz at −30, then 362 and 733; linear would be about 372 and 744). 50, 100 and 200 Hz do not rise off the floor.

| Level | 50 Hz | 100 Hz | 200 Hz | 300 Hz |
|---:|---:|---:|---:|---:|
| −30 dBFS | 0 Hz | 2 Hz | 2 Hz | 186 Hz |
| −24 dBFS | 1 Hz | 3 Hz | 3 Hz | 362 Hz |
| −18 dBFS | 2 Hz | 6 Hz | 7 Hz | 733 Hz |

M17 at the standard scaling (10841 / file peak 15772). p95 2926 Hz, p99.5 **3397 Hz**, regression outer 49 Hz. Plain **0 exact / 90**, no frame found. Inverted **0 exact / 90**, one candidate, link-setup not accepted. Under 80 exact, so the two repeats were not sent.

POCSAG at the standard ±4.5 kHz scaling (20326 PCM counts).

| Baud | p99.5 | Plain bit errors | Inverted bit errors | Pages |
|---:|---:|---:|---:|---|
| 1200 | 3394 Hz | 1728 / 3904 | 1022 / 3904 | 0 / 3 |
| 512 | 3040 Hz | 1283 / 3904 | 1339 / 3904 | 0 / 3 |

## UVm6 — `0x84FD` and the mask kept

Probe, −36 dBFS: 1 kHz **115 Hz** (0.221 Hz per PCM count), 3.5 kHz **101 Hz** (−1.1 dB). The 3.5 kHz tone is no longer down 4 dB.

Frequency response at **−30 dBFS**:

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 Hz | 0 Hz | — |
| 100 Hz | 2 Hz | −42 dB |
| 150 Hz | 0 Hz | — |
| 200 Hz | 2 Hz | −42 dB |
| 300 Hz | 181 Hz | −1.6 dB |
| 500 Hz | 215 Hz | −0.1 dB |
| 1000 Hz | 217 Hz | 0 dB |
| 2000 Hz | 218 Hz | 0.0 dB |
| 3000 Hz | 206 Hz | −0.4 dB |
| 3500 Hz | 193 Hz | −1.0 dB |

300 Hz through 3.5 kHz is within ±2 dB of 1 kHz. That is the voice low-pass bit. The bottom octave is unchanged.

| Level | 50 Hz | 100 Hz | 200 Hz | 300 Hz |
|---:|---:|---:|---:|---:|
| −30 dBFS | 0 Hz | 2 Hz | 2 Hz | 181 Hz |
| −24 dBFS | 1 Hz | 3 Hz | 4 Hz | 378 Hz |
| −18 dBFS | 2 Hz | 6 Hz | 8 Hz | 757 Hz |

300 Hz again tracks the level (181 Hz, then 378 and 757; linear would be about 362 and 724). At −18 dBFS, 200 Hz is 8 Hz beside a 757 Hz tone one octave up.

M17 at the standard scaling (10841 / file peak 15772). p95 2974 Hz, p99.5 **3069 Hz**, regression outer 4 Hz. Plain **0 exact / 90**. Inverted **0 exact / 90**, one candidate, link-setup not accepted. Not repeated.

POCSAG at the standard ±4.5 kHz scaling (20326 PCM counts).

| Baud | p99.5 | Plain bit errors | Inverted bit errors | Pages |
|---:|---:|---:|---:|---|
| 1200 | 3093 Hz | 1153 / 3904 | 1068 / 3904 | 0 / 3 |
| 512 | 3098 Hz | 1192 / 3904 | 980 / 3904 | 0 / 3 |

## UVm7 — limiter canary

Not combined with a `0x58` patch. One transmission: 1 kHz at −12 dBFS. Deviation **1829 Hz** (offset +821 Hz, magnitude 24, no clipping). The factory image at this level was 1827 Hz, and UVm3 (the same stub with `tr_sig_lim` left at `0x0F`) was 1876 Hz. The drop the canary was built to produce is not there.

`+0x3074` is on the flash FM branch, and that tune runs on this `0x23` before the CTCSS call. A lower `tr_sig_lim` in the stub's pool word did not change this tone. The stub's limiter write is not what set the deviation of this stimulus.

## What this adds to §6

| Check | UVm5 | UVm6 | UVm7 |
|---|---|---|---|
| Flat ±2 dB down to 50 Hz | no | no | not swept |
| 300 Hz–3.5 kHz within ±2 dB | no (3.5 kHz is −4.0 dB) | yes | — |
| Limiter at −3 dBFS | not sent (low end closed) | not sent | canary only, see above |
| M17 plain, exact frames | 0 / 90 | 0 / 90 | not sent |
| POCSAG pages, both bauds | 0 / 3 | 0 / 3 | not sent |
| Factory image after restore | — | — | yes |

**The cut below 250 Hz is not explained.** Bits 3 and 4 of register `0x58` were set, and the read-modify-write that would have cleared bit 3 was neutralized in the image that was measured. 50–200 Hz stayed closed at three levels, so it is not a weak-tone artifact and it is not the CTCSS high-pass those bits control. Bit 5, the voice low-pass bypass, does account for the 3.5 kHz roll-off left by UVm2: UVm6 is within ±2 dB from 300 Hz to 3.5 kHz. It does not open the bottom octave. The C7000 limiter canary did not move a −12 dBFS 1 kHz tone (1829 Hz against the factory 1827 Hz). No image meets the §6 acceptance. No voice clip was saved, because neither UVm5 nor UVm6 was flat to 50 Hz. Receive was not compared.

The factory image is back in flash and `0x34` reads `DMR003.UV4T.V022`. SignalDeck owns the radio. The active channel is **36, NOAA WX4, 162.425 MHz**, power low, in the Weather zone. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched.

# UVm8 / UVm9 — stub self-proof and the rest of register `0x58` (2026-10-23, 16:41–16:50)

Same rules as the runs above. HackRF receive only. Phone at **467.625 MHz, low power**. `0x34` at 16:41:13, before the first load, was `DMR003.UV4T.V022`. Each later image was loaded with `fwload_stock.sh`, and `0x34` was read before any transmission on that image. The factory file was loaded back at the end. `0x34` at 16:50:43 was `DMR003.UV4T.V022`. The pushed factory MD5 is `4426035392262ca54583c230c9e268e0`.

UVm8 is the C7000 stub with one extra AT1846S write. The branch at `+0x3074` goes to a 44-byte stub (`stubs/c7000_fm_proof.S`) that does the redirected register `0x3A` write, then the same `FM_BANDWIDTH` / `FM_DEV_COEF` stores as UVm3 (limiter left at `0x0F`), then register `0x58` = `0x84C5`. The five factory `0x8405` immediates are unchanged, and `ctcss-hpf-keep` is not in this image. UVm9 writes the DMR value `0xBCFD` at those five analog sites and includes `ctcss-hpf-keep`. The DMR site at `+0x2E94` is already `0xBCFD` and is not written again. Against UVm6's `0x84FD`, `0xBCFD` adds bits 11, 12 and 13 (VOX high-pass, VOX low-pass, RSSI low-pass). The two images were not combined.

| Image | What it changes | `0x34` | File MD5 | Loaded |
|---|---|---|---|---|
| UVm8 | tag + C7000 stub, then `0x58` = `0x84C5` from the stub. Factory `0x8405` immediates left in place | `DMR003.UVm8.V022` | `d7329a190a02af7de6cbb103e22f81dd` | 16:43:57 |
| UVm9 | tag + `0x58` = `0xBCFD` at the five sites + mask `0xFFFF` at `+0x333A` | `DMR003.UVm9.V022` | `7c069f6f8ce111736785aa0098abeed2` | 16:47:07 |
| Factory again | `DMR003.UV4T.V022-ORIGINAL.bin` | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 16:50:43 |

Host MD5 of each built file matches the MD5 the loader printed after the push. sha256 is `0f99aace5e842962f6dffb774fffaa95d3fb6bd78c2c0c6f8aa3ef8bcdc169d1` (UVm8) and `185207d3a587e005365f895ab086690ee7a52114cf0cd5f525e3167361a2ba87` (UVm9).

The first UVm8 capture, at the previous run's LNA 24 / VGA 32, had magnitude 6.6, so the harness raised VGA to 38 and repeated the probe. Every kept capture is LNA 24 / VGA 38. Clip fraction is 0. Carrier offset on the kept captures is +809 to +827 Hz. No step predicted past the stop, and none measured past it. The hottest aligned deviation transmitted was 708 Hz (UVm9, 300 Hz at −18 dBFS).

## UVm8 — the stub writes `0x58`

Probe only, −36 dBFS (amplitude 519). 1 kHz **111.5 Hz** (0.215 Hz per PCM count), 3.5 kHz **70.5 Hz**, **−4.0 dB**. The factory probe was +6.8 dB (115 Hz and 250 Hz). This is the UVm2 / UVm5 shape: pre-emphasis gone, 3.5 kHz still about 4 dB down, which is the voice low-pass bit 5 still clear.

The stub's `0x58` write held on the keyed path. Bits 6 and 7 of `0x84C5` are still there after the no-tone read-modify-write (`0x58 & 0xFFF7`), which this image does not patch. The redirect at `+0x3074` is the write that runs.

UVm3 and UVm7 are therefore real results. The same stub writes `FM_BANDWIDTH` and `FM_DEV_COEF`. UVm3 matched the factory curve, and UVm7's lowered limiter left a −12 dBFS 1 kHz tone at 1829 Hz against the factory 1827 Hz. Those C7000 FM registers are not what sets the audio the HackRF hears. No sweep, M17 or POCSAG was sent on UVm8.

## UVm9 — `0xBCFD` and the mask kept

Probe, −36 dBFS: 1 kHz **106 Hz** (0.204 Hz per PCM count), 3.5 kHz **100 Hz** (−0.5 dB). The 3.5 kHz tone is up with bit 5, as on UVm6.

The low tones at three levels. 300 Hz tracks the level (166 Hz, then 354 and 708; doubling the amplitude would give about 332 and 664). 50, 100 and 200 Hz stay on the floor. At −30 dBFS the best of those three is **−40.9 dB** against the probe's 1 kHz scaled to that level.

| Level | 50 Hz | 100 Hz | 200 Hz | 300 Hz |
|---:|---:|---:|---:|---:|
| −30 dBFS | 1 Hz | 2 Hz | 2 Hz | 166 Hz |
| −24 dBFS | 2 Hz | 3 Hz | 4 Hz | 354 Hz |
| −18 dBFS | 3 Hz | 5 Hz | 7 Hz | 708 Hz |

The low end did not open, so the sweep, M17 and POCSAG were not sent. Bits 11, 12 and 13 do not open the bottom octave. With UVm2, UVm5 and UVm6, that exhausts register `0x58` on this path, including the DMR value and the CTCSS mask.

## Phone route, read only

`tinymix` is not on the phone (`tinymix: inaccessible or not found`). No mixer control was written. The only `tiny*` binary under `/system/bin` is `/system/bin/tinyserver`. The ALSA card is `mt6885-mt6359`. tinyserver links tinyalsa (`mixer_open`, `mixer_ctl_set_enum_by_string`, `pcm_write`) and names these controls: `I2S1_HD_Mux`, `I2S1_Out_Mux`, `I2S1_CH1 DL8_CH1`, `UL2_CH1 I2S2_CH1`, `UL2_CH2 I2S2_CH2`, and `DAC DEM MUTE`. Those are I2S route enums and a DAC mute. None is a high-pass, a DC block, or an uplink or downlink filter. SignalDeck's transmit path writes 8 kHz PCM through `PrizeTinyService.writeFrame` into that daemon, and the daemon's playback route is DL8 onto I2S1. `/sys/kernel/debug/asoc` was empty, so the live value of any other MT6359 control was not read. The files under `/vendor/etc/audio_param` (Record FIR, Speech, UplinkConfiguration, and the rest) are the Android voice-call parameter set. tinyserver opens its own PCM device.

## Where FM audio enters the module

The HR-C7000 user guide (Connect Systems Document 2, §7.2.2.1) selects the codec ADC as the analog FM source when `0x11000080[0]` is 0, with `WORK_MODE` bit 7 set and PTT in `0x11000560`. The image's FM setup at `+0x3ECC0` (called from `+0x3D710`) writes `WORK_MODE` = `0x80`, PTT = 1, and `AICR_ADC` (`0x160009C9`) = `0xC0`: ADC master, ADC on, parallel PCM. Boot (`+0xDE4`) calls the codec init at `+0x647C`, which writes that ADC enable and also `AICR_DAC`, the mic and DAC/ADC control bytes, sleep and clock, DAC gain (`GCR_DACL`, offset `0x1F`), mic gain (`GCR_MIC1`, offset `0x23`) and ADC gain (`GCR_ADCL`, offset `0x25`).

`FCR_ADC` is codec base `0x160009C0` + `0x17` = `0x160009D7`. Bit 6 is `adc_hpf` and bits 5:4 are the wind-noise filter `adc_wnf`. The guide's reset for both is off. Wind-noise mode 3 is a 235 Hz corner. The image has no literal `0x160009D7` and no literal `0x16000017`, and it has no byte store at offset `0xD7` from base `0x16000900`. The halfword copy at `+0x67D0` fills `0x16000980` up to, and not including, `0x160009C0`. This firmware leaves the ADC high-pass and the wind-noise filter at reset.

The phone daemon plays PCM out on I2S1. The module path this image programs is the codec ADC. The junction between that I2S playback and the codec microphone input is not a register this image writes.

## What this adds to §6

| Check | UVm8 | UVm9 |
|---|---|---|
| Flat ±2 dB down to 50 Hz | not swept (probe only) | no |
| 300 Hz–3.5 kHz within ±2 dB | probe only: 3.5 kHz is −4.0 dB, matching `0x84C5` | probe only: 3.5 kHz is −0.5 dB; 300 Hz at −30 dBFS is −2.1 dB vs the scaled 1 kHz |
| Limiter at −3 dBFS | not sent | not sent (low end closed) |
| M17 plain, exact frames | not sent | not sent |
| POCSAG pages | not sent | not sent |
| Factory image after restore | — | yes |

**The bottom octave is outside software reach.** The stub runs, so the C7000 FM band-pass, pre-emphasis and limiter are not the cut. Register `0x58`, through the DMR value `0xBCFD`, is not the cut. The phone route this app uses names no high-pass, and the module codec's ADC high-pass and wind-noise filter stay at their off reset. What remains is the analog coupling between the phone's I2S playback and the codec ADC input. §16's fallback stands, and it is not implemented here: run-time pre-shaping and a receive equalizer, on the UVm6 curve (flat from 300 Hz to 3.5 kHz). No image meets the §6 acceptance. No voice clip was saved. Receive was not compared.

The factory image is back in flash and `0x34` reads `DMR003.UV4T.V022`. SignalDeck owns the radio. The active channel is **36, NOAA WX4, 162.425 MHz**, power low, in the Weather zone. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched.

# UVm10 — codec ADC gain (2026-10-23, 17:33–17:44)

Same rules. HackRF receive only. Phone at **467.625 MHz, low power**. The version field is four characters, so the flash tag is `Vm10` and `0x34` reads `DMR003.Vm10.V022`. The bench name stays UVm10. `0x34` before the first load was `DMR003.UV4T.V022`. Each transmission below was on `DMR003.Vm10.V022`, confirmed by `0x34` before that transmission. The −12 dBFS tone is a second load of the same file: after the probe, the log buffer had wrapped past the version line, the check raised `no 0x34 answer`, and the factory image was loaded back and verified (`0x34` `DMR003.UV4T.V022` at 17:37:05, same pushed MD5) before `Vm10` was loaded again. The final factory load is 17:44:13. `PATCH14_BACKUP.bin` was not touched.

## `FCR_ADC` is never stored

`FCR_ADC` is codec base `0x160009C0` + `0x17`, which is the same address as `0x16000900` + `0xD7` (`0x160009D7`). The factory image has no little-endian literal of either `0x160009D7` or `0x16000017`. The only literals of `0x160009C0` are at `+0x6844` and `+0x6AC0`. They are loaded by `+0x67DC` (`lrw r8`) and `+0x6980` (`lrw r9`) as the end compare of a halfword copy that starts at `0x16000980` and steps by 2. The copy stops before `0x160009C0`; the highest address it writes is `0x160009BE`. Both pointers are then reloaded from the stack, and nothing is stored through them. No 32-bit `st.b` uses displacement `0x17` or `0xD7`. The 16-bit `st.b` sites at displacement `0x17` use other bases; the only registers that ever hold `0x160009C0` are `r8` and `r9`, and both are clobbered before any store. Codec stores from base `0x16000900` use offsets `0xC8`, `0xC9`, `0xCB`, `0xCC`, `0xCD`, `0xCF`, `0xD2`, `0xD3`, `0xDF`, `0xE3` and `0xE5` only. The init's gain stores are `0xDF`, `0xE3` and `0xE5`. PTT (`+0x3ECC0`) and its unkey restore do not write `FCR_ADC` or `GCR_ADCL`. `adc_hpf` and the wind-noise filter stay at the guide reset, which is off. The wind-noise filter (mode 3 = 235 Hz) is not on.

## What the image changes

A stub-only store of `GCR_ADCL` at the UVm8 hook does not survive. The `0x23` success path is straight from `+0x9CF6` (`bsr 0x7A30`, the stub site) through a second `+0x9DA6` (`bsr 0x7A30`) to `+0x9DB8` (`bsr 0x61F4`). `0x61F4` rewrites `GCR_ADCL` after both applies. The guide step is 1 dB per count of `gidl` (bits 5:0), with a 0 dB floor. Codec init writes `0x8B` (11 dB) and is left unchanged, because `0x61F4` overwrites it on this path. `0x61F4(0)` stores `0x88` (8 dB), then stores `0x89` (9 dB) when RAM `0x38b5c+3` is 1. The same `0x23` path sets that byte to 1 before the copy into `0x38b5c`, so the factory air numbers were taken at 9 dB. Six counts under `0x89` is `0x83` (3 dB), half the amplitude (`10^(-6/20) ≈ 0.50`). Six counts under the init's `0x8B` would be `0x85`, only 4 dB under the live value, and `0x61F4` would overwrite it.

| Site | Factory | This image | Byte stored |
|---|---|---|---|
| `+0x61FE` (`r0 != 0`) | `subi` 117 | `subi` 123 | `0x8B` → `0x85` (11 dB → 5 dB) |
| `+0x620C` (first store, `r0 == 0`) | `subi` 120 | `subi` 126 | `0x88` → `0x82` (8 dB → 2 dB) |
| `+0x6228` (byte == 1) | `subi` 119 | `subi` 125 | `0x89` → `0x83` (9 dB → 3 dB) |
| `+0x6238` (0 dB floor) | `subi` 128 | unchanged | `0x80` |
| `+0x6540` (codec init) | `subi` 117 | unchanged | `0x8B` |

The analog success path is the `0x89` → `0x83` row. The other two branches are lowered by the same six counts so the result does not depend on the flag being exactly 1. The floor cannot go lower and is not patched. The stub (`stubs/c7000_fm_adcgain.S`, 48 bytes at `+0x5B000`) does the redirected register `0x3A` write, the same `FM_BANDWIDTH` `0x0F` and `FM_DEV_COEF` `0x000F1010` stores as UVm8, and then stores `GCR_ADCL` = `0x83`. It does not write register `0x58`. The five factory `0x8405` immediates stay. UVm7 already showed those C7000 stores alone leave a −12 dBFS 1 kHz tone at 1829 Hz against the factory 1827 Hz, so they are not what would move these tones. `lrgid` stays 1. `+0xAAE8` also copies a byte into `GCR_ADCL`, from a jump-table struct after a `cmpnei r3, 104` (frame sync `0x68`). That store is not on the DIAG VFO path that was traced, and PTT does not write `GCR_ADCL`. The value on the air after a `0x23` tune is the one `0x61F4` left.

| Image | What it changes | `0x34` | File MD5 | Loaded |
|---|---|---|---|---|
| UVm10, probe | tag `Vm10` + stub + the three `0x61F4` immediates | `DMR003.Vm10.V022` | `bf8a842d3497b9e520f350c9af258a15` | 17:33:59 |
| Factory between the two tones | `DMR003.UV4T.V022-ORIGINAL.bin` | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 17:37:05 |
| UVm10, −12 dBFS | the same built file, loaded again | `DMR003.Vm10.V022` | `bf8a842d3497b9e520f350c9af258a15` | 17:41:16 |
| Factory again | `DMR003.UV4T.V022-ORIGINAL.bin` | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 17:44:13 |

Host MD5 of the built file matches the MD5 the loader printed after both pushes. sha256 is `17fe8d7f18a2e918bea3904795d6c172cfabddad4b8cca2c7a6b4d9318c35059`. The file is 378620 bytes.

Both kept captures are LNA 24 / VGA 38. Clip fraction is 0. Carrier offset is +832 Hz on the probe and +833 Hz on the −12 dBFS tone. No step predicted past the ±5 kHz stop, and none measured past it. The hottest aligned deviation transmitted was 1740 Hz.

## The tones

| Stimulus | Factory | UVm10 | UVm10 / factory |
|---|---|---|---|
| −36 dBFS, 1 kHz (amplitude 519) | 115 Hz | **109 Hz** | 0.95 |
| −36 dBFS, 3.5 kHz (amplitude 519) | 250 Hz | **237 Hz** | 0.95 |
| −12 dBFS, 1 kHz (amplitude 8231) | 1827 Hz | **1740 Hz** | 0.95 |

3.5 kHz over 1 kHz is +6.7 dB (237 / 109). The factory probe's 250 / 115 is the same ratio, written as +6.8 dB in the earlier table. Pre-emphasis is still on. Half the factory deviation would have been about 57 Hz, 125 Hz and 914 Hz. Each tone is about 0.5 dB down, which is the run-to-run spread (UVm9's 1 kHz probe was 106 Hz). Probe capture: magnitude 35.6, SNR 48.5 dB, keyed about 4.65 s, lag 1.32 s. The −12 dBFS capture: magnitude 22.4, SNR 44.8 dB, keyed about 3.82 s, lag 1.37 s.

**The codec ADC gain is not in the radiated path.** The branch this `0x23` takes was lowered from `0x89` to `0x83`. The unchanged 0 dB floor is the other branch, so this is not a canary that could not drop. `FCR_ADC` staying at reset agrees with the scan. It does not, by itself, place the cut below 250 Hz.

## Where the PCM goes, and the next image

The user guide (Document 2, §7.2.2.1) gives analog FM two sources. The codec-ADC source is `0x11000080[0]` = 0, `0x11000100[7]` = 1, PTT in `0x11000560`, and `AICR_ADC` (`0x160009C9`) master, ADC on, parallel PCM. This image writes `AICR_ADC` = `0xC0`, which is that setup, and the stream is supposed to reach the FM modulator with no CPU copy. The TX-RAM source is `0x11000080[0]` = 1, into the ping-pong at `0x16000030`–`0x1600042F`. `sel_i2s` (bit 2 of `0x11000080`) is the baseband-test I2S enable. The codec init forces the ADC interface to parallel. Nothing in the DIAG VFO path was shown filling TX RAM from the phone. The phone plays PCM out on I2S1. UVm10 lowered the gain on the codec ADC and the air did not follow, so the source the guide selects is not what the HackRF hears.

The gain the radiated audio has followed is the AT1846S. UVm8 removed the pre-emphasis by writing `0x58` from the stub. `set_tx_gain_reg44` (`+0x8E0C`) writes the `0x2A` body into register `0x44` bits 11:8 and forces the low byte to `0xFF`. The FM branch of `at1846_tune` writes `0x44` = `0x0AD1`, so those bits are `0xA`. The OEM labels for that field are 4 dB per count at body 0–5 (0/4/8/12/16/20 dB). `0xA` is outside that labeled list. SignalDeck sends `setMic(4)` only in the boot handshake, not on a DIAG VFO tune, so after this tune the last `0x44` writer on the traced path is `0x0AD1`.

The next image is not built and was not loaded. Lower that nibble by two counts (`0xA` → `0x8`, 8 dB if the labeled step still applies that far up) at the FM-tune store of `0x44`, and apply the same two counts inside `set_tx_gain_reg44`, so a later `0x2A` cannot put the old gain back. Same −36 dBFS probe and the same −12 dBFS 1 kHz tone. A drop of about half means the audio enters the AT1846S microphone gain. No drop means it does not. Do not also flip `tx_voice_source` to RAM in that image. `GCR_DACL` is the DAC playback gain, for receive and sidetone, not this transmit source.

No sweep, M17, POCSAG or voice was sent. §6 is not met. Pre-shaping and a receive equalizer are not implemented. UVm6 stays the candidate curve for a mode that fits 300 Hz–3.5 kHz.

The factory image is back in flash and `0x34` reads `DMR003.UV4T.V022` (17:44:13). The pushed factory MD5 is `4426035392262ca54583c230c9e268e0`. SignalDeck owns the radio. The active channel is **36, NOAA WX4, 162.425 MHz**, power low, in the Weather zone. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched.

# UVm11 — codec DAC gain (2026-10-23, 18:28–19:18)

Same rules. HackRF receive only for the two transmissions. Phone at **467.625 MHz, low power**. The version field is four characters, so the flash tag is `Vm11` and `0x34` reads `DMR003.Vm11.V022`. The bench name stays UVm11. `0x34` was `DMR003.Vm11.V022` immediately before each transmission (18:28:41 and 18:28:55). The factory image was loaded back at 18:31:56. The receive check, with no HackRF and no transmission, reloaded the UVm10 file and then the factory image. The final `0x34` is `DMR003.UV4T.V022` at 19:18:07. `PATCH14_BACKUP.bin` was not touched.

## Where `GCR_DACL` is written

`GCR_DACL` is codec base `0x160009C0` + `0x1F`, the same address as `0x16000900` + `0xDF`. Guide §6.5.2.25: bit 7 is `lrgod`, and `godl` (bits 5:0) is not a linear count. Bit 5 clear is 0 to −31 dB. Bit 5 set is +1 to +32 dB, with the low five bits counting backwards (`32 − (godl & 0x1F)`). Subtracting 6 from a byte in that upper half raises the gain, so the replacement bytes below were computed from the dB value.

Every live value comes from the ten halfword slots at file `+0x36ED0` (XIP `0x03050ED0`). The low byte is the gain and the high byte is 0. The four stores of firmware offset `0xDF` are:

| Store | What it writes | On the keyed path |
|---|---|---|
| init `+0x653C` | immediate `0xAB` (+21 dB) | overwritten by the init's own call to `0x61A8`, then again by boot |
| boot `+0xE1A` | table slot 3 (byte offset 6) | yes, until a later codec-branch `0x61A8` |
| `0x61A8` at `+0x61EC` | `table[index << 1]`, only when the copied struct's byte 0 is 1 | the analog `0x23` success path calls it at `+0x9DB2`; the volume command calls it at `+0xA5BC` |
| leaf `+0xAE2` | the same table | no call site |

PTT (`+0x3ECC0`) and unkey (`+0x3EE6C`) do not store `GCR_DACL`. A stub at `+0x3074` runs before `0x61A8` on the analog path, so it would be overwritten. This image uses no stub and does not touch `+0x3074` or `+0x5B000`.

`FCR_DAC` is firmware offset `0xD4` (guide `+0x14`). Its only field is `dac_freq` (bits 3:0; `0000` = 8 kHz). The guide has no DAC high-pass, DC-block, or de-pop bit, and the image never stores `FCR_DAC`. It also never stores `GCR_MIXDACL` (offset `0xE7`) or `CR_DAC_AGC` (offset `0xEB`). `CR_DAC_AGC` stays at reset, so `dac_agc_en` is 0. AGC did not put the 6 dB back.

## What the image changes

Each of the ten low bytes is 6 dB under the factory byte. `lrgod` stays set. Slot 3 wraps `0xBC` (+4 dB) to `0x82` (−2 dB).

| Slot | Factory | dB | This image | dB |
|---|---|---|---|---|
| 0 | `0x80` | 0 | `0x86` | −6 |
| 1 | `0x88` | −8 | `0x8E` | −14 |
| 2 | `0x82` | −2 | `0x88` | −8 |
| 3 | `0xBC` | +4 | `0x82` | −2 |
| 4 | `0xB7` | +9 | `0xBD` | +3 |
| 5 | `0xB4` | +12 | `0xBA` | +6 |
| 6 | `0xB0` | +16 | `0xB6` | +10 |
| 7 | `0xAE` | +18 | `0xB4` | +12 |
| 8 | `0xAA` | +22 | `0xB0` | +16 |
| 9 | `0xA8` | +24 | `0xAE` | +18 |

Boot leaves slot 3. A `0x23` that takes the codec branch of `0x61A8` before any volume command leaves slot 0. After the volume command (this app's analog setup uses index 8) it leaves slot 8. Each of those is 6 dB down, so the air result does not depend on which slot was live. The init immediate `0xAB` is not patched. The three `zextb r2` sites stay. The five factory `0x8405` immediates stay. The UVm10 ADC-gain sites stay. This image is not combined with a `0x58` patch.

| Image | What it changes | `0x34` | File MD5 | Loaded |
|---|---|---|---|---|
| UVm11, both tones | tag `Vm11` + the ten `GCR_DACL` slots | `DMR003.Vm11.V022` | `9d1e9668d740bffdb492634ea573f131` | 18:28:40 |
| Factory after the tones | `DMR003.UV4T.V022-ORIGINAL.bin` | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 18:31:56 |
| UVm10, receive clip | the UVm10 file again; no transmission | `DMR003.Vm10.V022` | `bf8a842d3497b9e520f350c9af258a15` | 19:12:27 |
| Factory, receive clip | `DMR003.UV4T.V022-ORIGINAL.bin` | `DMR003.UV4T.V022` | `4426035392262ca54583c230c9e268e0` | 19:15:37 |

Host MD5 of the built UVm11 file matches the MD5 the loader printed. sha256 is `dbbf43d38982928549c9880c121997ce83a7da4488a587806037fd4ecc392f6d`. The file is 378620 bytes.

Both transmissions are LNA 24 / VGA 38. Clip fraction is 0. Carrier offset is +830 Hz on the probe and +820 Hz on the −12 dBFS tone. No step predicted past the ±5 kHz stop, and none measured past it. The hottest aligned deviation transmitted was 1733 Hz.

## The tones

| Stimulus | Factory | UVm11 | UVm11 / factory |
|---|---|---|---|
| −36 dBFS, 1 kHz (amplitude 519) | 115 Hz | **111.9 Hz** | 0.973 |
| −36 dBFS, 3.5 kHz (amplitude 519) | 250 Hz | **249.7 Hz** | 0.999 |
| −12 dBFS, 1 kHz (amplitude 8231) | 1827 Hz | **1733 Hz** | 0.949 |

3.5 kHz over 1 kHz is +6.98 dB (249.7 / 111.9). Pre-emphasis is still on. Half the factory deviation would have been about 57 Hz, 125 Hz and 914 Hz. Probe capture: magnitude 45.4, SNR 51.3 dB, keyed 4.65 s, lag 1.00 s. The −12 dBFS capture: magnitude 41.2, SNR 49.8 dB, keyed 3.81 s, lag 1.42 s, p99 1883 Hz.

**The codec DAC playback gain is not in the radiated path.** The ratios sit in the same run-to-run spread as UVm10 (about 0.95). `GCR_MIXDACL` is not the reason: the image never stores it. AGC is not the reason: `dac_agc_en` stays 0.

## What can still carry the phone's audio into the AT1846S

UVm8 still stands. Writing register `0x58` from the stub removes the pre-emphasis, so the audio does go through the AT1846S. UVm11 shows that path does not include `GCR_DACL`. UVm10 already showed it does not include `GCR_ADCL`. There is no DAC filter bit to clear: `FCR_DAC` is the sample rate only, and it is never stored.

Three candidates remain. None of them was built or loaded.

1. The other branch of `0x61A8`. Byte 0 of the copied channel struct selects it. When that byte is not 1, `0x61A8` writes AT1846S register `0x44` from the table at XIP `0x03050EE4` (file `+0x36EE4`, the halfwords immediately after the DAC table) and leaves the boot `GCR_DACL` byte in place. The `0x44` image was skipped. `0x58` already places the audio in the AT1846S.
2. The guide's codec-ADC FM source (`0x11000080[0]` = 0). UVm10 lowered that gain and the radiated deviation stayed at 0.95 of the factory tones.
3. TX RAM (`0x11000080[0]` = 1), or a converter that this DAC register does not control.

## Receive check

No HackRF and no transmission. Channel 36 was parked on 467.625 MHz with hardware squelch 0. Its transmit frequency stayed 162.425 MHz, so the app still treated the row as receive-only. Each clip is 10.0 s of 8 kHz mono, 80000 samples, taken from the audio the module delivered and before the app squelch. `0x34` was read before each clip.

| Image | RMS | dBFS | Zero fraction | Peak / median |
|---|---|---|---|---|
| UVm10 (`GCR_ADCL` 6 dB down) | 5470 | **−15.55** | 0.0001 | 11.4 |
| Factory | 5431 | **−15.61** | 0.0001 | 12.6 |

UVm10 minus factory is **+0.06 dB**. A codec ADC on the receive path would have put UVm10 about 6 dB quieter. Both clips have essentially no digital zeros, and the spectral peak is only about 12 times the median, so this is the open-squelch noise floor on both images. **The codec ADC gain is not in the receive path.**

No sweep, M17, POCSAG or voice was sent. §6 is not met. Pre-shaping and a receive equalizer are not implemented. UVm6 stays the candidate curve for a mode that fits 300 Hz–3.5 kHz.

The factory image is back in flash and `0x34` reads `DMR003.UV4T.V022` (19:18:07). The pushed factory MD5 is `4426035392262ca54583c230c9e268e0`. SignalDeck owns the radio. The active channel is **36, NOAA WX4, 162.425 MHz**, squelch 5, power low, receive-only flag off, in the Weather zone. The screen shows 162.425 MHz. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. `stay_on_while_plugged_in` is 0.

# R1–R3 — DMR modulator flatness, TX RAM not loaded (2026-10-23, 19:47–19:50)

No firmware was built or loaded. HackRF receive only. One transmission, at **467.625 MHz, low power**, on a temporary digital channel (CC1, timeslot 1, talkgroup 9999, no contact row). `0x34` was `DMR003.UV4T.V022` at 19:47:36, before the key-up. The DIAG test tone was 2000 ms. The capture is one 8 s file, LNA 24 / VGA 38, clip fraction 0, magnitude 31.9, SNR 51.0 dB, carrier offset +864 Hz, keyed 2.83 s. The bench row was then deleted. The newest `RadioService` version line is still `DMR003.UV4T.V022` (19:50:49).

## R1 — the DMR 4FSK rails

The envelope repeats every **60.00 ms** (correlation 0.894) with a **26.1 ms** burst, 47 bursts. That is one slot of a direct-mode transmission. Symbol centers are 4800 per second, and the first and last 1 ms of each burst are left out of the level measurement so the power ramp is not counted as deviation.

| Quantity | Value |
|---|---|
| Outer-symbol median | **+7346 Hz / −7049 Hz** |
| Early / middle / late third of the burst | 7252 / 7111 / 7168 Hz |
| Early-to-late ratio | **0.981** |
| Share of 0–4 kHz power that is below 250 Hz | **0.072** |
| 99.5 percentile of the raw burst window | 23132 Hz |

The three thirds stay within 2% of each other, so a held outer symbol does not sag from the start of the burst to the end. The 23 kHz figure is the ramp and the symbol transitions. The same pass with the ramps included, splitting each burst into the 54 / 24 / 54 symbol shoulders around the sync, gave +7572 / −7440 Hz and a pre/sync/post ratio of 0.956. Both readings say the rails are flat.

The guide's ±1944 / ±648 Hz table (Document 2, two-point modulation, `RF_MODE[7]` = 0) is the baseband symbol map. The air outer rail is about 3.8 times that map. The demodulator is the same one that read about 1800 Hz on a −12 dBFS 1 kHz tone earlier the same day, and the +864 Hz offset matches that day's crystal offset, so the ±7.3 kHz rail is the radiated deviation.

**The DMR modulator path holds a level across a burst.** The outer rail is above the ±5 kHz stop, so nothing further was transmitted.

## R2 — how DMR and FM drive the RF

Document 2 and the factory image, re-read this session. `scripts/fw_at1846_regmap.py` for `0x30`, `0x43`, `0x44` and `0x58` matches ch. 11 §21.2.

`at1846_tune` (`+0x2DD8`) writes `0x30` = `0x4046` and then splits. The DMR side writes `0x43` = `0x00BB`, `0x44` = `0x0AD1`, `0x30` = `0x4006` / `0x4026`, and `0x58` = `0xBCFD` (`+0x2E92`). The FM side (`+0x2FF2`) writes `0x43` = `0x0100`, the same `0x44` = `0x0AD1`, `0x30` = `0x4006` / `0x4026` or `0x7006` / `0x7026` on the 25 kHz path, and `0x58` = `0x8405` (`+0x3052`). `0xBCFD` is the setting that bypasses the AT1846S voice filters. `0x8405` leaves them on. `at1846_rx_on` / `at1846_rx_off` only change `0x30` bits 2, 5 and 6.

On the C7000, channel setup writes `WORK_MODE` (`0x11000100`) as `0x22` (physical layer), `0x6A` (layer-2 direct), `0x6E` (layer-2 repeater) or `0x73` (layer-3 direct). Those are the guide's Table 27 values (page 92). FM key-up (`+0x3ECC0`) saves `RF_MODE`, `WORK_MODE` and `0x11000080`, then stores `RF_MODE` = `0x10E0` (bits 6:5 = 11, two-point; bit 7 = 0, so +3 maps to +1944 Hz in the guide's table; bit 10 = 0, so the built-in 40 Hz square stays off), `WORK_MODE` = `0x80`, and PTT (`0x11000560`) = 1. The only full-word immediate store of `RF_MODE` found is that `0x10E0`.

`0x11000080[0]` is `tx_voice_source` (guide page 97 and §7.2.2.1). 0 is the codec or the vocoder. 1 is MCU RAM, the layer-2 base-station source. Three copies (`+0x1788E` / `+0x17914`, `+0x17CB6` / `+0x17D24`, `+0x19682` / `+0x1969A`) set bit 0 when byte `0x12` of the struct at `0x34808` is 2 or 3, or when the flag at `0x4D404+0xF8` is nonzero, and clear it when the byte is neither and the flag is 0. The copy at `+0x195DA` / `+0x195F2` runs only while that flag is 1, then sets the bit for byte 2 or 3 and clears it otherwise. FM key-up then clears bit 0 at `+0x3EDF8`. A handheld analog transmission is forced onto the codec source. Bit 4 of the same register is `ahb_wr_voice_en`; the image has a set leaf at `+0x3E0A8` and a clear leaf at `+0x3E080`. Bit 3 is the sidetone enable and is only toggled during init. Bit 7 is the ringtone path (`+0x6BC4` / `+0x6C0C`).

TX RAM for FM is `0x16000030`–`0x1600042F`, two halves of 512 bytes, 256 samples of 16-bit PCM, 32 ms at 8 kHz (Document 2 §7.2.2.1.2 and page 340). The low address of each sample is the high byte. `FM_ADDR_SW` (`0x1100056C`, bits 1:0, read-only) is 1 for the low half and 2 for the high half. `FM_TX_INTERP` is the FM transmit data interrupt, level-triggered, cleared by writing 1 to the matching `SYS_INTERP_CLEAR` bit (pages 94 and 339). The image has no literal and no built address of `0x1100056C`, and no store into `0x16000030`–`0x1600042F`. The only CPU touch of that RAM is `+0x3EEEC`, which reads one sample from each half (`0x16000032`/`33` and `0x16000232`/`33`, high byte first) and returns them. The `SYS_INTERP` handler at `+0x18A70` copies `0x11000398` into `0x110003A0` until the status reads 0. It does not fill the voice buffer. `FM_BANDWIDTH` (`0x11000500`) and `FM_DEV_COEF` (`0x11000504`) are never stored, so FM pre-emphasis (`fmpreemphasison`, bit 4) and the FM band-pass (bit 6) stay at the reset default, on, and `fm_dev_coef_t` stays `0x10`. The guide gives no Hz per PCM count.

The 27-byte DMR voice payload also starts at `0x16000030`. Vocoder frames are `0x16000960`–`0x1600097A`. Those are not the 512-byte FM ping-pong.

## R3 — not built

R1's rails are flat, and the outer deviation is above 5 kHz. The ±5 kHz stop ends the experiment before a TX-RAM image. No square-wave stub was assembled or loaded. A later image, if one is authorized, would still have to start at a small PCM amplitude, and it would have to clear `FM_BANDWIDTH` bit 4: that pre-emphasis is on at reset, this image never writes it, and it is a different path from the DMR modulator R1 measured.

## R4 — design only, not built

A new UART command would carry symbols. The OEM command table leaves `0x3D` and `0x3E` undefined (deep dive 01). The proposal is `0x3D`, after a check that the firmware's own compare does not already use it. The frame stays the existing one (`68 | cmd | rw | sr | cksum | len | body | 10`) at 57600 baud.

Body: one kind byte (1 = M17 dibits, 2 = POCSAG bits), one count, then the packed symbols. One ping-pong half is 32 ms, 256 samples at 8 kHz. M17 at 4800 symbols/s is 154 dibits in that half, 39 bytes packed 4 dibits per byte, 41 bytes with the header. The frame is 50 bytes. At one frame per half that is about 1600 bytes/s, about 27% of a 5760 byte/s line. POCSAG at 1200 bit/s is one 32-bit codeword, 4 bytes plus the 2-byte header, well under the line rate.

In the module the command would set `WORK_MODE` = `0x80`, `tx_voice_source` = 1, `ahb_wr_voice_en` = 1 and PTT, shape the symbols into the half `FM_ADDR_SW` names, and clear `fmpreemphasison` so the shaper is what radiates. M17 needs a root-raised-cosine onto 8 kHz (5/3 samples per symbol). POCSAG needs a Gaussian onto 8 kHz (20/3 samples per bit). The coefficient tables are under 200 bytes each and the shaper code is a few hundred bytes, on the order of the FM stubs already used, inside the existing 378620-byte image. Deviation starts from a small PCM amplitude: `fm_dev_coef_t` is `0x10` at reset, and the guide publishes no Hz per count. The DMR air rail shows the guide's ±1944 Hz map is not the on-air scale. The stub must not write the 27-byte vocoder payload into the same base address as the PCM half.

§6 (plain M17 85/90, POCSAG 100%) is the measurement bar if that command is ever built. It was not built, and §6 is not met.

## End state

Factory image, `0x34` = `DMR003.UV4T.V022` at 19:47:36 and again at 19:50:37 and 19:50:49. No new image was loaded. SignalDeck owns the radio. Channel 36 is NOAA WX4, 162.425 MHz, squelch 5, power low, active. The temporary digital row is gone. The screen showed 162.425 MHz and did not show 467.625. Zone 4, `zoneLast_4` 36. `PATCH14_BACKUP.bin` was not touched. `/sdcard/DMR/DMRDEBUG.bin` is absent.

# R1b — factory DMR outer symbols are ±3.3 kHz; the R3 image does not boot (2026-10-23, 20:51–21:09)

No new transmission. R1b uses the 19:47 capture only (one 8 s file, tune 467.385 MHz, the signal 240 kHz above the tune, 2.4e6 samples/s, LNA 24 / VGA 38, clip fraction 0). HackRF was not started. The ±5 kHz stop applies to the deviation of a test image. It was not reached: the R3 image never keyed.

## R1b — occupied bandwidth and the four symbol levels

The outer-symbol median in the section above (+7346 / −7049 Hz) came from locking the symbol phase to the samples' own quartiles. This capture's discriminator has a heavy tail (the raw burst window's 99.5 percentile is 23132 Hz, the ramps and the symbol transitions), and that lock sat on the tail. The same pass already had a symbol-centre |deviation| median of 3179 Hz.

Re-measured on the same IQ, 46 bursts, period 59.99 ms.

The 99 % occupied bandwidth of a burst, after a 20 kHz low-pass (bin 39.0625 Hz, 46 spectra): **10546.875 Hz**. The edges are −4414 Hz and +6133 Hz. The midpoint of the edges is the carrier, **+859 Hz**, the same crystal offset as the other captures that day. A ±7.3 kHz 4FSK would occupy about 18–20 kHz, so 10.55 kHz rejects that rail. The bandwidth alone does not separate the guide's ±1944 Hz map from a somewhat wider constellation. The histogram does.

Symbol centres, at the phase with the smallest within-cluster rms, recentred on the midpoint of the two outer cluster means. The power centroid sits 371 Hz above that midpoint, so it is not used as the carrier.

| Symbol | Centre |
|---|---|
| −3 | **−3344.7 Hz** |
| −1 | **−1068.9 Hz** |
| +1 | **+1219.2 Hz** |
| +3 | **+3344.7 Hz** |

Counts 1070 / 1644 / 2395 / 1288. Within-cluster rms 403 Hz. Inner mean 1144 Hz, outer 3345 Hz, inner/outer **0.342** (4FSK's 1/3). These four means sit 1052 Hz rms from the guide's ±1944 / ±648 Hz map, and 2977 Hz rms from ±7346 / ±2449 Hz. The early, middle and late thirds of the outer symbols are 3340 / 3361 / 3322 Hz, late/early **0.995**.

Forty symbol phases were tried. The open-eye phases (12.08, 12.50 and 12.92 samples) read an outer of 3338–3345 Hz. The best is phase 12.5, rms 403 Hz, the same four counts. The transition phase (4.58 samples) reads a lower outer, 2676 Hz. ±3.3 kHz is the open eye.

The 9 kHz demodulator that produced the ±7.3 kHz figure, run on this same IQ with the cluster method, reads outer ±3172 Hz, inner ±1046 Hz, ratio 0.330, 99 % bandwidth 10312.5 Hz, edge midpoint +844 Hz. A wide boxcar with no low-pass reads outer ±3311 Hz, ratio 0.342, bandwidth 10507.8 Hz. The ±7.3 kHz number is the tail method. These spectra do not contain it.

**The factory DMR outer symbol is about ±3.3 kHz, about 1.7 times the guide's ±1944 Hz map** (`RF_MODE[7]` = 0). The inner symbols are −1069 Hz and +1219 Hz. The guide table stays the nominal map. This pass does not say why the air scale is 1.7 times that map. On the wide IF, the share of 0–4 kHz power below 250 Hz is **0.177** (wide boxcar 0.178, 9 kHz path 0.172). The 0.072 figure above was the spiked trace. Both are far above the FM path's under 1 %. The DMR modulator still passes the low end, and a held outer symbol is still flat (0.995 on these levels).

## R3 — built, loaded twice, no boot banner

`c7000-txram-square`, tag `R3a0`, version string `DMR003.R3a0.V022`. MD5 `442c5cad026a361009da79e1034c7a3e`, sha256 `14390583de8f641acd7f54dc108191c268fb2d653d9044e46650b45bd810ef4a`. Against the factory image the file differs at the tag (`+0x3846B`, four bytes), the six-byte hook (`+0x3EDFC`), and the 76-byte stub at `+0x5B000`. Zeros inside the stub match the factory tail, so a raw byte diff splits the stub into short ranges. The image is 378620 bytes. `build.py` does not add a checksum.

The hook replaces the PTT store at `+0x3EDFC` (`6b10013240b3`) with `bsr +0x5B000` and `movi r0, 0` (`00e002e10030`). The clear of `tx_voice_source` at `+0x3EDF8` is unchanged, and so is `movi r0, 50` at `+0x3EE02`. The `bsr` uses the same high-halfword-first encoding as the factory `bsr` at `+0x3D710` (`00e0d80a` targets `+0x3ECC0`). `00e002e1` targets `+0x5B000`.

The stub sets `0x11000080[0]` and leaves bit 4 clear. Document 2 §7.2.2.1.2 names bit 0 as the TX-RAM source and does not mention `ahb_wr_voice_en`. It clears `FM_BANDWIDTH` bits 4 and 6 in place, fills `0x16000030` with +256 for 256 samples and −256 for the next 256 (16-bit big-endian, stored halfwords `0x0001` and `0x00FF`), stores PTT = 1, and returns. Nothing in this image refills the ping-pong, so the 64 ms pattern would repeat as a 15.625 Hz square. A = 256 counts. The patch test (`test_txram_square_fills_after_the_voice_source_clear`) checks the hook target, both fills, the bit clears, and that the stub does not set bit 4.

Loaded twice, the same bytes. YModem `onSuccess` at 20:51:28 and at 21:02:22. Both times the loader printed an empty `0x34` line and exited 0. An empty line is not a version. The tag check is the logcat line `module DMR003.…`. Logcat shows the version query, then the ten ASCII bytes `0x29050000`, then two power cycles, each logged as no boot banner. A DIAG `restartmodule` after the first load power-cycled again and also found no banner. The module did not answer `0x34` or the channel write. Nothing was keyed. The square was not measured, and A was not raised.

Those ten bytes are not a literal in the image. They are what `%#x` prints for the value `0x29050000`. The only `%#x` formats in the factory image are the SDMMC lines at file `+0x36A94` (`CMD req:SDMMC_RINTSTS=%#x,SDMMC_STATUS = %#x,timeout=0x%x`) and the SCR line at `+0x36D02`. The printer at `+0x4DE4` loads the `+0x36A94` string, calls the print, then `movi r0, 41` / `pop r15`. The print runs when bits of the status word are set, or when the counter in r3 is above 65535, and then it returns. The captured chunk is one field of that line. The rest of the line was not in the log, so which field it is stays unknown. It is not an image checksum. The same ten bytes appeared on both R3 loads (the second at 21:02:36.635 and 21:02:38.720).

The banner string was not patched. Early init prints `开机初始化完成` from file `+0x3653C` by the call at `+0xE2A`. The factory image, loaded by the same script between the two R3 loads and again after the second, prints that banner (20:59:23 and 21:09:08) and answers `0x34` with `DMR003.UV4T.V022`. On the final takeover the first version query still saw one `0x29050000` (21:09:02), while the previous image was powered (`module already powered`). The power cycle after that printed the banner. The R3 power cycles did not.

UVm8 wrote a stub at the same `+0x5B000`, changed two bytes of the version tag, and changed four bytes at `+0x3074`. That image printed the banner. A tail write and a tag change do not, by themselves, stop the boot print. R3's remaining difference is the six bytes at `+0x3EDFC`.

Those six bytes are a normal `bsr`, and no direct call reaches them from boot. The only `bsr` of the FM key-up entry `+0x3ECC0` is at `+0x3D710`. Nothing `bsr`s `+0x3D688`, `+0x3D710` or `+0x3D5D8`. Boot at `+0xDA6` calls `+0x3D68`, a different function. That removes the account in which boot calls key-up and the stub then faults on `0x16000030`. It does not say why the banner is missing. The cause stays open. A third load of this same image was not started.

## The bare-carrier follow-up was not reached

A bare carrier, or the phone's 1 kHz codec tone, would have been the air result that points at the DMR-mode modulation registers: two-point `RF_MODE`, AT1846S `0x58` = `0xBCFD`, and the `0x30` values the DMR tune writes (`0x4006` / `0x4046` / `0x4026`). R2 already lists those stores. There is no air result, so that image was not proposed as a next build and was not built. R4 was not built. §6 is not met. No pre-shaping and no receive equalizer.

## End state

Factory image restored after the second R3 load. YModem `onSuccess` at 21:08:52. Banner `开机初始化完成` at 21:09:08.473. `0x34` at 21:09:08.783 is `DMR003.UV4T.V022`. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The takeover wrote analog `0x23` for 162.425 MHz, bandwidth wide, power low, squelch 5 (body `A8 68 AE 09 A8 68 AE 09 01 00 05 …`), and the module acked it (`RX cmd=0x23 rw=0 sr=0` at 21:09:08.858). The app announced channel 36, NOAA WX4. SignalDeck owns the radio: the stock app is paused and the UART is open. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. No HackRF capture and no key-up in this pass. The ES8311 debug node was not written.

# R3-0 / R3a1 — the IRAM copy, the runtime branch, and the R1 bandwidth (2026-10-23, 22:35–23:02)

No transmission. HackRF was not started. The ±5 kHz stop was not reached: R3a1 was not loaded, and nothing keyed.

## The copy at boot

Reset is file offset 0. The literals from `+0xC4` are three-word copy records, destination, end, source:

| Copy | Destination | End | Source |
|---|---|---|---|
| SRAM | `0x18000800` | `0x18004404` | `0x0304C2E0` (file `+0x322E0`) |
| IRAM | `0x00010000` | `0x00031AF4` | `0x03053408` (file `+0x39408`) |

The IRAM length is `0x21AF4` bytes (137972). There is no separate length field and no checksum field. The loop is `ld.w` / `st.w` / add 4 until the destination reaches the end (`+0x46`–`+0x5A`). BSS is then filled with zero from `0x31AF4` to `0x0004DAB0` (`+0x5C`–`+0x72`). The next instruction, the `bsr` at file `+0x74` (`e2808720`), has runtime target IRAM `0x0002AEB4`, which is file `+0x542BC`. That function's `bsr` at `+0x5431A` creates a task with entry `0x0301AD5C` (file `+0xD5C`). The banner string stays at file `+0x3653C`.

The copied block's sum32 is `0xA23B52E7`, its xor is `0xC3293F1F`, its zlib crc32 is `0x388809B7`, and its byte sum is `0x00D1692C`. None of those values occurs as a little-endian word outside the block. An unaligned search found no word equal to key-up's IRAM address `0x158B8` or its XIP address `0x03058CC0`, the hook's IRAM address `0x159F4` or its XIP address `0x03058DFC`, or `+0x3D688` as a file offset, as IRAM `0x14280`, or as XIP `0x03057688`.

Later `lrw`s of the literal `0x31AF4` load the first word of that zeroed BSS and compare it with 100. They do not walk the copied image.

## R300 — the TICK byte, no banner

The copied range contains no log string. The readable ASCII names in it are the uC/OS-III type words `TMSG TRES TSUS QUEU FLAG TSIG SEMA TICK` at file `+0x3ACCC`, and `NONE` stored into OS objects at `+0x3AE30`. The function at `+0x3ABC4` compares a struct word with those eight constants. The `TICK` compare is the `lrw` at `+0x3AC42`.

`DMR003.R300.V022.bin`, 378620 bytes, sha256 `dfe1cf30cf7f5f10e76ba12259101dd6fda8ee26006a2f166fa3692dda4f7e58`, pushed MD5 `0274598c4c93707fa3a90d6a018961e6`. It changed one byte of that `TICK` immediate, `+0x3ACEB` `0x4B` → `0x4A`, plus the version tag. YModem `onSuccess` at 22:37:37.274. The loader printed an empty `0x34` line and exited 0. After take-over: 22:37:50.260 module already powered, 22:37:53.281 version query failed (1 of 2), power cycle 22:37:54.305, 22:38:09.628 version query failed (2 of 2), power cycle 22:38:10.651. No banner. Nothing keyed.

A whole-block check would have rejected R301 as well. `build.py` does not recompute a checksum. The `TICK` site is no longer a patch in the tree.

## R301 — one padding byte, banner and tag

`c7000-iram-padbyte`, tag `R301`, version `DMR003.R301.V022`. sha256 `5c4ef9621f5c542db8bf6ca249fc791cce88f49881e2e930ce326a0969373356`, pushed MD5 `0a834f7cf3bf48d1f63d0c4dec0e25a5`. The only non-tag difference is `+0x3EE16` `00` → `58`. Factory bytes there are `3c 78 00 00 04 01 00 11`: `jmp r15` at `+0x3EE14`, then this halfword, then the pool word `0x11000104` at `+0x3EE18`. Nothing in the disassembly references `+0x3EE16`. The byte is inside the copied range. The type words and the key-up hook bytes stay factory. `test_iram_padbyte_changes_the_halfword_after_keyup_returns` checks that diff.

YModem `onSuccess` at 22:50:10.989. The first version query still saw `0x29050000` at 22:50:25.078 and restarted the module once (22:50:26.865, power cycle 22:50:27.889). After that cycle: banner `开机初始化完成` at 22:50:31.055, `0x34` body `44 4D 52 30 30 33 2E 52 33 30 31 2E 56 30 32 32 00`, `module DMR003.R301.V022` at 22:50:31.365. Analog `0x23` for 162.425 MHz, band 1, power 0, squelch 5, acked `RX cmd=0x23 rw=0 sr=0` at 22:50:31.438. Voice: Channel 36, NOAA WX4. A one-byte change of copied data boots. The R3a0 failure is the six hook bytes, or the branch they encode.

## R3a1 — runtime `bsr`, built, not loaded

`c7000-txram-square` now encodes the hook from the runtime PC. File `+0x3EDFC` executes at IRAM `0x159F4`. The stub remains at file `+0x5B000`, XIP `0x03075000`, outside the copy. Displacement `0x03075000 − 0x159F4 = 0x0305F60C`. The six bytes are `82 e1 06 fb 00 30`: `bsr` to `0x03075000`, then `movi r0, 0`. The file-offset decode of those same bytes is `0x03098308`, which is why the test adds the displacement to `0x159F4` and checks the result is `0x03075000`. The clear at `+0x3EDF8` and `movi r0, 50` at `+0x3EE02` stay. The 76-byte stub is unchanged: bit 0 only, clear `FM_BANDWIDTH` bits 4 and 6, +256 / −256, then PTT = 1. Nineteen patch tests pass. The image is `DMR003.R3a1.V022.bin`, 378620 bytes, sha256 `7404d19b001eccb08867da97e8524a80788bdbed6763b71b9a8b8b81ab48c690`, file MD5 `aee09d8a0f911245aafd58bca702f5e5`. It was not pushed.

`+0x3D688` is inside the copy. After three null checks it calls `+0x3F15C`, `+0x3F518`, key-up at `+0x3ECC0` (`+0x3D710`), then later unkey at `+0x3EE6C` (`+0x3D73C`). No instruction `bsr`s `+0x3D688`. The boot call at `+0xDA6` is `bsr +0x3D68`. UVm8 wrote this same tail and a version tag and booted. R301 wrote `+0x3EE16` and booted. R3a0's remaining difference, the six hook bytes, is what stopped the banner, so those bytes execute before the banner.

The `bsr` returns to `+0x3EE02`. The stub has already stored PTT = 1. `+0x3D688` then reaches unkey, which clears PTT. A boot of R3a1 would key and then unkey before SignalDeck sends `0x23`. The module's last successful program, on R301, was channel 36 at 162.425 MHz, low power. This request did not confirm a transmission. R3a1 stayed in `radio_firmware/build/`. The A = 256 capture was not started, and A was not raised.

R301 shows the copied block can differ from the factory bytes and still banner. The flash-resident hook was not designed as a replacement and was not built.

## The R1 digital channel was the 12.5 kHz path

The temporary digital row stored `band` = 1 (the column the exporter calls 25 kHz). `at1846_tune` (`+0x2DD8`) reads struct byte 0 into `r4` and byte 1 into `r5`.

The common path writes `0x30` = `0x4006` at `+0x2DE4` and `0x30` = `0x4046` at `+0x2E22`, then splits on `r4` at `+0x2E2A`. The DMR branch (`r4` == 1) writes `0x42` = `0x1036`, `0x43` = `0x00BB`, and calls `at1846_apply_bw_profile` (`+0x2B14`) with `r0` = 0. That is the 12.5 kHz table (46 bytes per bandwidth from file `+0x36608`; `r0` = 1 is 25 kHz). It then overwrites `r5` at `+0x2E5E`, writes `0x30` = `0x4006` at `+0x2E74` and `0x30` = `0x4026` at `+0x2E7E`, then `0x44` = `0x0AD1` and `0x58` = `0xBCFD`. `0x4026` is the last `0x30` write on this branch. Byte 1 is not consulted after `+0x2E5E`.

The FM branch (`+0x2FF2`) writes `0x58` = `0x8405`. When byte 1 == 1 it writes `0x30` = `0x7006` then `0x30` = `0x7026` and calls the profile with `r0` = 1. Otherwise it writes `0x4006` then `0x4026` and calls the profile with `r0` = 0.

The analog `0x23` unpack sets struct byte 0 to 0 (`+0x9A56`) and stores body byte 8, the band byte, in struct byte 1 (`+0x9A7A`, `+0x9C72`). R1's capture is 4FSK, so that transmission took the DMR branch. The stored `band` = 1 did not select `0x7026`. The measurement is the 12.5 kHz DMR programming, with `0x30` left at `0x4026`. The outer symbol of ±3.3 kHz against the guide's ±1944 Hz is the radio's own DMR scale. A later 12.5 kHz re-check would be this same path. No retransmission was made.

## End state

Factory image restored over R301. YModem `onSuccess` at 23:02:14.530. The first version query still printed `0x29050000` at 23:02:25.205 while the previous image was powered, then one restart (23:02:26.595, power cycle 23:02:27.621). Banner `开机初始化完成` at 23:02:30.787. `0x34` at 23:02:31.098 is `DMR003.UV4T.V022` (body `44 4D 52 30 30 33 2E 55 56 34 54 2E 56 30 32 32 00`). Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The takeover wrote analog `0x23` for 162.425 MHz, band 1, power low, squelch 5 (body `A8 68 AE 09 A8 68 AE 09 01 00 05 …`), acked `RX cmd=0x23 rw=0 sr=0` at 23:02:31.175. Voice: Channel 36, NOAA WX4. SignalDeck owns the radio: the stock app is paused and the UART is open. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. No HackRF capture and no key-up. The ES8311 debug node was not written. §6 is not met.

# R3a2 — gated TX-RAM square; the host key still radiates the codec tone (2026-10-23, 23:28–23:42)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. Phone transmissions were the factory boot cycle, the R3a2 boot, and one 3 s low-power key on the 467.625 VFO. Nineteen patch tests pass.

## Factory boot, receive only

The flash image was `DMR003.UV4T.V022`. VFO 467.625 / 467.625 FM, low power, at 23:28:33.859 (`0x23` body `28 64 DF 1B … 01 00 02`, acked `sr=0`). DIAG `restartmodule` at 23:28:39.407. Power cycle 23:28:40.474. Banner `开机初始化完成` at 23:28:43.631. `0x34` at 23:28:43.943 is `DMR003.UV4T.V022`. The same 467.625 `0x23` was written again at 23:28:43.987 and acked at 23:28:44.011.

The capture is 24.0 s (115200000 bytes) and starts 1.5 s before the restart. Power is the mean square of the int8 IQ, so a carrier anywhere in 466.185–468.585 MHz would raise it. The pre-restart median is 6.80. The hottest 100 ms bin is +0.11 dB, at 14.2 s. No bin reaches +3 dB. Clip fraction 0. The hottest half-second's spectrum fills ±24 kHz. The factory boot cycle does not radiate at 467.625. The self-test runs before the post-boot `0x23`, and that window is inside the capture.

## The flag and the image

Cmd `0x26` is index 4 of the jump table at file `+0x38240` (XIP `0x03052240`). The thunk at `+0xABCA` branches to the handler at `+0x9264`. Launch 1 enters at `+0x92B2` (factory `17 6c 57 6c`). Launch 2 enters at `+0x929C` (factory `83 ea a2 00`). Both then call `+0xE9C`, which posts an event, and ack through `+0x8E7C`. The handler does not branch to key-up.

The flag word is IRAM `.bss` `0x4DAAC`. Boot zeroes `0x31AF4`–`0x4DAB0`. The factory image has no little-endian literal of `0x4DAAC`. The highest referenced word below the BSS end is `0x4DAA8`.

`DMR003.R3a2.V022.bin`, 378620 bytes, sha256 `74a47c45e4e52a65fbdc5b3e07d9ceefe41f6b5f53be9961a178735e07e28f64`, file and pushed MD5 `fd8e6b19d0672b808dd1e162856bf26c`. The hook at `+0x3EDFC` stays `82 e1 06 fb 00 30` (runtime `bsr` from IRAM `0x159F4` to XIP `0x03075000`). The stub at `+0x5B000` is 124 bytes. With the flag zero it does the factory PTT store (`lrw r3, 0x11000560; movi r2, 1; st.w; jmp r15`) and returns before any TX-RAM store. With the flag set it sets `0x11000080[0]`, clears `FM_BANDWIDTH` bits 4 and 6, fills +256 / −256, then stores PTT. `+0x92B2` is `bsr` to `set_flag` (`+0x5B04C`), which stores 1 and then `movi r0, 1; movi r1, 1`. `+0x929C` is `bsr` to `clear_flag` (`+0x5B058`), which stores 0 and reloads `r3` with `0x38874`. One flag. The second, `0x23`-since-boot, flag was not added.

## R3a2 boot

YModem `onSuccess` at 23:35:33.629. Take-over at 23:35:42.114 found the module already powered. The version query printed `0x29050000` at 23:35:42.939 and 23:35:44.988, then one restart (23:35:45.136, power cycle 23:35:46.162). Banner `开机初始化完成` at 23:35:49.317. `0x34` body `44 4D 52 30 30 33 2E 52 33 61 32 2E 56 30 32 32 00`, `module DMR003.R3a2.V022` at 23:35:49.627. The takeover then wrote channel 36, 162.425 MHz, band 1, power 0, squelch 5 (body `A8 68 AE 09 … 01 00 05`), acked at 23:35:49.704. Voice: Channel 36, NOAA WX4. The VFO did not survive the stock app's ownership.

The HackRF file covers 162.8 s from 23:33:10, through that boot. Floor 6.82, hottest bin +0.13 dB, clip 0, no bin at +3 dB. Same noise as the factory boot. Nothing radiated at 467.625 beyond the factory baseline.

## The 3 s key

VFO 467.625 again at 23:37:15.869, low power, the same `0x23` body as the factory tune. DIAG `testtone` 3000 ms at 23:37:20.665. `0x26` launch 1 at 23:37:20.713, acked `sr=0` at 23:37:20.718. `0x36` body `03` (SEND_START) at 23:37:20.724. `played 24000 samples` at 23:37:24.120. Launch 2 at 23:37:24.121, acked, then `0x36` body `04` (SEND_STOP) at 23:37:24.453.

Carrier 3.77 s, SNR 37.6 dB, clip 0, crystal offset +848 Hz. Over the steady 2.97 s the deviation is a sine at 999.5 Hz. Its rms is 1.47 kHz, so the sine amplitude is about ±2.1 kHz. The 99th percentile of `|deviation|` on the whole keyed window is 2.8 kHz. The 15.625 Hz square fundamental is 0.2 Hz, and the 0–100 Hz band is a few hertz. The air is the phone's 1 kHz codec tone. A was not raised. The ±5 kHz stop was not reached.

The host key is real: the MCU acknowledged launch and sent SEND_START. The modulator still radiated the codec waveform, so the gated FM key-up stub did not supply the modulation. The only static caller of key-up remains `+0x3D710` inside `+0x3D688`. `+0xE9C` posts an event and does not branch there.

## Proposed next image, not built

Program the DMR modulator around the same square. Two-point `RF_MODE`. AT1846S `0x58` = `0xBCFD`. The `0x30` sequence the DMR tune writes: common path `0x4006` then `0x4046`, then the DMR branch `0x4006` then `0x4026`, so the register is left at `0x4026`, and the bandwidth profile is called with `r0` = 0 (12.5 kHz). That is the DMR branch. The FM pair `0x7006` / `0x7026` stays unused. No bit-4 image. R4 was not built. §6 is not met.

This radio's narrow-band DMR outer symbol, 12.5 kHz with `0x30` left at `0x4026`, is ±3.3 kHz, about 1.7× the standard ±1944 Hz. The BTECH 6X2 still decodes it. Noted on the DMR route in `radio_firmware/HANDOFF.md`.

## End state

Factory image restored over R3a2. YModem `onSuccess` at 23:41:58.545. The first version query printed `0x29050000` at 23:42:07.929, then one restart (23:42:10.404, power cycle 23:42:11.429). Banner `开机初始化完成` at 23:42:14.584. `0x34` at 23:42:14.894 is `DMR003.UV4T.V022` (body `44 4D 52 30 30 33 2E 55 56 34 54 2E 56 30 32 32 00`). Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The takeover wrote analog `0x23` for 162.425 MHz, band 1, power 0, squelch 5 (body `A8 68 AE 09 … 01 00 05`), acked `RX cmd=0x23 rw=0 sr=0` at 23:42:14.968. Voice: Channel 36, NOAA WX4. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. §6 is not met.

# R3a3 — the TX-RAM square is on the air; silence drops the codec tone (2026-10-24, 00:36–01:03)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. Phone transmissions were two loads of one image, one 3 s codec tone, and one 3 s silence, all on the 467.625 VFO at low power. Twenty patch tests pass. A was not raised.

## The image

`c7000-txram-dmr`, tag `R3a3`, `DMR003.R3a3.V022.bin`, 378620 bytes. sha256 `667cfd127d3b403192066da8e67c3633905875a7370a56a4fc379f861d43ea40`. File and pushed MD5 `e247b7b428e3635e71ef2a3f65ee9670`.

R3a2 hooked FM key-up. A host `0x26` never calls that function, so the flag stayed clear and the air was the codec tone. This image leaves `+0x3EDFC` and `+0x3074` factory. It replaces the four `bsr 0xe9c` sites inside the flash `0x26` handler:

| Site | Was | Now |
|---|---|---|
| `+0x92C8` launch 1, byte `0x38874` == 0 | `bsr 0xe9c` | `bsr on_key` |
| `+0x92E0` launch 1, byte `0x38874` != 0 | `bsr 0xe9c` | `bsr on_key` |
| `+0x92AA` launch 2, r7 == 0 | `bsr 0xe9c` | `bsr on_unkey` |
| `+0x92FA` launch 2, r7 != 0 | `bsr 0xe9c` | `bsr on_unkey` |

`on_key` is at file `+0x5B000` (XIP `0x03075000`), 188 bytes through `+0x5B0BB`. It posts the same event (`bsr 0xe9c` with the handler's r0/r1), stores `RF_MODE` `0x11000104` = `0x10E0` and `WORK_MODE` `0x11000100` = `0x80`, sets `0x11000080` bit 0, clears `FM_BANDWIDTH` `0x11000500` bits 4 and 6, fills `0x16000030` with +256 for 256 samples and −256 for the next 256, writes AT1846S `0x30` = `0x4006` then `0x4026` and `0x58` = `0xBCFD`, and stores PTT = 1. Bit 4 stays clear: the stub contains no `3aa4`. `on_unkey` posts the event, stores PTT = 0, clears bit 0, and writes `0x58` = `0x8405` and `0x30` = `0x7026`. The five factory `0x8405` sites and the DMR site at `+0x2E94` are unchanged. The boot self-test does not send `0x26`.

## Boot

VFO 467.625 / 467.625 FM at 00:36:47.278, low power. HackRF from 00:36:50, 143.47 s, floor power 6.82. YModem `onSuccess` at 00:39:00.214. `0x34` at 00:39:12.867 is `DMR003.R3a3.V022`. Hottest 100 ms bin +0.11 dB, no bin at +6 dB, clip 0. The reboot is inside the file and does not spike. The stub is not on the boot path.

The key capture started immediately after that HackRF was closed and wrote 0 bytes. It is not a measurement. Factory restored over that load: `onSuccess` 00:41:43.451, `0x34` `DMR003.UV4T.V022` at 00:41:56.109, VFO 467.625 at 00:41:58.119.

## The tone key

Second load, same bytes. `onSuccess` 00:46:07.979. `0x34` `DMR003.R3a3.V022` at 00:46:21.386. VFO 467.625 at 00:46:23.272. DIAG `testtone` 3000 ms. `0x26` launch 1 at 00:46:28.923, acked `sr=0` at 00:46:28.929. `0x36` body `03` at 00:46:28.935. `played 24000 samples` at 00:46:32.328. Launch 2 at 00:46:32.330. `0x36` body `04` at 00:46:32.664.

Carrier 3.45 s, SNR 39.8 dB, clip 0, offset +1028 Hz. The steady window drops the first 1.0 s and the last 0.3 s (2.15 s). It is a 999.92 Hz sine of amplitude 2399 Hz, rms 1738 Hz, p99 2727 Hz. Harmonics at 2 kHz and 3 kHz are 0.5 Hz and 0.2 Hz. Under the sine, the square is present:

| Harmonic | Amplitude |
|---|---|
| 15.625 Hz | 133 Hz |
| 31.25 Hz | 2.5 Hz |
| 46.875 Hz | 50 Hz |
| 62.5 Hz | 3.1 Hz |
| 78.125 Hz | 32 Hz |

Noise from 5–40 Hz, excluding the fundamental, has median 0.23 Hz.

The square leads the codec. At t = 0.0 s (100 ms) the p99 is 22974 Hz and the 1 kHz line is 51 Hz: that is the key-up click. At t = 0.1 s the click is gone (p99 445 Hz, rms 183 Hz), the 1 kHz line is 0.7 Hz, and the 15.625 Hz line is 148 Hz. From t = 0.2 s the sine is up. The click is not the stimulus. The steady p99 of 2727 Hz is the sine. A was not raised.

## The silence key

Third load, same bytes. The host file was 3.000 s of zeros, 8 kHz mono 16-bit, 48044 bytes, installed as `tx_silence.wav`. `onSuccess` 00:59:04.301. Banner `开机初始化完成` at 00:59:17.881. `0x34` at 00:59:18.196 is `DMR003.R3a3.V022`. VFO 467.625 at 00:59:20.012. `txwav` at 00:59:25. `0x26` launch 1 at 00:59:25.658, acked `sr=0`. `TX bench wav (3000 ms)`. `0x36` body `03` at 00:59:25.670. `played 24000 samples` at 00:59:29.053. Launch 2 at 00:59:29.055. `0x36` body `04` at 00:59:29.395.

Carrier 3.44 s, SNR 39.6 dB, clip 0, offset +1022 Hz. Same steady window:

| Harmonic | Amplitude |
|---|---|
| 15.625 Hz | 129 Hz |
| 31.25 Hz | 3.7 Hz |
| 46.875 Hz | 47 Hz |
| 62.5 Hz | 2.9 Hz |
| 78.125 Hz | 30 Hz |
| 1000 Hz | 1.2 Hz |
| 2000 Hz | 0.4 Hz |
| 3000 Hz | 0.6 Hz |

A 40 Hz low-pass of that window has rms 104 Hz and median absolute value 103 Hz. The fundamental 129 Hz is `4A/π` for a square of amplitude 101 Hz. The tops are about ±104 Hz. At A = 256 that is 0.40 Hz per count. Raw `|deviation|` is p50 133 Hz, p90 306 Hz, p99 469 Hz: the upper percentiles are the edges of the square, not a second tone. From t = 0.1 s through the end of the carrier the 1 kHz line stays under 5 Hz and the 15.625 Hz line stays near 150 Hz. The first 100 ms is again a click (p99 23502 Hz).

The two keys use the same square. The codec sine is added only when the host sends it. Zeros do not radiate a tone, and they do not remove the square.

## What this does not yet say

The scale is one point. A count of about 6000 would be ±2.4 kHz if the 0.40 Hz/count slope holds, which is inside the ±5 kHz stop, and it is not measured. The edge p99 at this amplitude is 4.6 times the tops. A smooth waveform will not have those edges. The next image is the same stub at A = 512, one 6 dB step, another silence key. M17 samples are not in this image. §6 is not met.

## End state

Factory image restored over the silence key. YModem `onSuccess` at 01:01:45.469. The first takeover printed no `module DMR` line. A second start of SignalDeck printed banner `开机初始化完成` at 01:02:57.784 and `0x34` `DMR003.UV4T.V022` at 01:02:58.095. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:02:58.648, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written.

The tone-key restore had already done the same thing earlier. `onSuccess` at 00:48:48.703, empty `0x34` poll, then a later start of SignalDeck: banner 00:51:13.856, `0x34` `DMR003.UV4T.V022` at 00:51:14.167. The loader now starts SignalDeck a second time when that first poll is empty. The radio was factory before the silence load.

# R3a4 — A = 512 doubles the square (2026-10-24, 01:10–01:16)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-one patch tests pass. A was not raised again in this image.

## The image

`c7000-txram-dmr-a512`, tag `R3a4`, `DMR003.R3a4.V022.bin`, 378620 bytes. sha256 `244cd6b25bb834930df88d57a60bdb4cffc0a49283e6a26e8cde6c30fde755f7`. File and pushed MD5 `531b07ea6e6781622373894a77d39965`.

Against the R3a3 image the file differs at three bytes: the tag's last character (`+0x3846E`, `3` → `4`), the +256 immediate (`+0x5B028`, `0x3101` → `0x3102`, big-endian +512), and the −256 immediate (`+0x5B038`, `0x31FF` → `0x31FE`, big-endian −512). The four `0x26` call sites, the AT1846S writes, `+0x3074` and `+0x3EDFC` are the R3a3 bytes. Bit 4 stays clear.

## Boot

VFO 467.625 / 467.625 FM at 01:10:13.300, low power. HackRF from 01:10:16, 180.0 s, floor power 6.77. YModem `onSuccess` at 01:12:27.557. Banner `开机初始化完成` at 01:12:41.438. `0x34` at 01:12:41.749 is `DMR003.R3a4.V022`. Hottest 100 ms bin +0.14 dB, at 171 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 01:13:37.682. `txwav` of the same 3 s of zeros. `0x26` launch 1 at 01:13:43.338, acked `sr=0`. `TX bench wav (3000 ms)`. `0x36` body `03` at 01:13:43.349. `played 24000 samples` at 01:13:46.749. Launch 2 at 01:13:46.751. `0x36` body `04` at 01:13:47.077.

Carrier 3.46 s, SNR 39.6 dB, clip 0, offset +1024 Hz. Steady window, dropping the first 1.0 s and the last 0.3 s:

| Harmonic | A = 256 | A = 512 |
|---|---|---|
| 15.625 Hz | 129 Hz | 284 Hz |
| 31.25 Hz | 3.7 Hz | 2.6 Hz |
| 46.875 Hz | 47 Hz | 101 Hz |
| 62.5 Hz | 2.9 Hz | 3.4 Hz |
| 78.125 Hz | 30 Hz | 55 Hz |
| 1000 Hz | 1.2 Hz | 0.6 Hz |

A 40 Hz low-pass of that window has rms 212 Hz and median absolute value 211 Hz. At A = 256 the same low-pass was 104 Hz and 103 Hz. The tops doubled. 212 / 512 = 0.41 Hz per count, and 104 / 256 = 0.41 Hz per count. The fundamental rose by 2.20, which is 0.8 dB more than a pure doubling. The odd harmonics rose with it. The evens stayed at a few hertz.

Raw `|deviation|` p99 is 578 Hz, against 469 Hz at A = 256. The edges did not double. The first 100 ms is a key-up click, p99 23043 Hz. The steady window is the stimulus, and it stayed under ±1 kHz.

## What this does not yet say

Two amplitudes agree on 0.41 Hz per count at the tops. ±2.4 kHz, the M17 outer deviation, would be about 5900 counts if the slope keeps, inside the ±5 kHz stop. That count has not been transmitted. The next image is A = 1024, one more 6 dB step, another silence key. Predicted tops are about ±420 Hz. M17 samples are not in this image. §6 is not met.

## End state

Factory image restored over R3a4. YModem `onSuccess` at 01:16:03.289. Banner `开机初始化完成` at 01:16:16.520. `0x34` at 01:16:16.831 is `DMR003.UV4T.V022`. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:16:18.712, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. The first version poll returned the tag; the second-start path in the loader was not needed.

# R3a5 — A = 1024 doubles the square again (2026-10-24, 01:22–01:29)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-two patch tests pass. A was not raised again in this image.

## The image

`c7000-txram-dmr-a1024`, tag `R3a5`, `DMR003.R3a5.V022.bin`, 378620 bytes. sha256 `07a76c84abce64ff159fb233499a4090bf52365288dce78b4f46d839f8b07ca5`. File and pushed MD5 `9b30d2e935e49c4c07608edcfde7bf92`.

Against the R3a4 image the file differs at three bytes: the tag's last character (`+0x3846E`, `4` → `5`), the +512 immediate (`+0x5B028`, `0x3102` → `0x3104`, big-endian +1024), and the −512 immediate (`+0x5B038`, `0x31FE` → `0x31FC`, big-endian −1024). The four `0x26` call sites, the AT1846S writes, `+0x3074` and `+0x3EDFC` are the R3a4 bytes. Bit 4 stays clear.

## Boot

VFO 467.625 / 467.625 FM at 01:22:56.888, low power. HackRF from 01:23:01, 180.0 s, floor power 6.82. YModem `onSuccess` at 01:25:11.158. Banner `开机初始化完成` at 01:25:25.191. `0x34` at 01:25:25.512 is `DMR003.R3a5.V022`. Hottest 100 ms bin +0.12 dB, at 165 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 01:26:21.519. `txwav` of the same 3 s of zeros. `0x26` launch 1 at 01:26:27.156, acked `sr=0`. `TX bench wav (3000 ms)`. `0x36` body `03` at 01:26:27.167. `played 24000 samples` at 01:26:30.558. Launch 2 at 01:26:30.560. `0x36` body `04` at 01:26:30.887.

Carrier 3.45 s, SNR 39.3 dB, clip 0, offset +953 Hz. Steady window, dropping the first 1.0 s and the last 0.3 s. The 40 Hz figure is an FFT cutoff at 40 Hz, the same one that reads 212 Hz and 211 Hz on the R3a4 capture:

| Harmonic | A = 512 | A = 1024 |
|---|---|---|
| 15.625 Hz | 284 Hz | 537 Hz |
| 31.25 Hz | 2.6 Hz | 2.4 Hz |
| 46.875 Hz | 101 Hz | 193 Hz |
| 62.5 Hz | 3.4 Hz | 3.4 Hz |
| 78.125 Hz | 55 Hz | 122 Hz |
| 1000 Hz | 0.6 Hz | 0.3 Hz |

A 40 Hz low-pass of that window has rms 438 Hz and median absolute value 422 Hz. At A = 512 the same low-pass was 212 Hz and 211 Hz. The median doubled (422 / 211 = 2.00). The rms rose by 2.06. 422 / 1024 = 0.41 Hz per count, and 438 / 1024 = 0.43. The two earlier medians were 0.41 Hz per count as well.

The fundamental, 537 Hz, is `4A/π` for a square of amplitude 422 Hz. The A = 512 fundamental (284 Hz) sat above `4A/π` of its own plateau (269 Hz). This one sits on the plateau. The odd harmonics rose with the square. The evens stayed at a few hertz. The 1 kHz line is 0.3 Hz.

Raw `|deviation|` p99 is 846 Hz, against 578 Hz at A = 512. The edges rose and still did not double. The first 100 ms is a key-up click, p99 23077 Hz. The steady window is the stimulus, and it stayed under ±1 kHz.

## What this does not yet say

Three amplitudes agree on about 0.41 Hz per count at the flat top, from ±104 Hz to ±422 Hz. ±2.4 kHz, the M17 outer deviation, would be about 5900 counts if the slope keeps. That count has not been transmitted. The edge p99 is still rising (469, 578, 846 Hz), so a jump to 5900 counts is not the next image. The next image is A = 2048, one more 6 dB step, another silence key. Predicted median tops are about ±840 Hz. M17 samples are not in this image. §6 is not met.

## End state

Factory image restored over R3a5. YModem `onSuccess` at 01:28:47.284. Banner `开机初始化完成` at 01:28:59.080. `0x34` at 01:28:59.395 is `DMR003.UV4T.V022`. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:29:01.242, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. The first version poll returned the tag; the second-start path in the loader was not needed.

# R3a6 — A = 2048, the rms grows and the flat top lags (2026-10-24, 01:33–01:39)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-three patch tests pass. A was not raised again in this image.

## The image

`c7000-txram-dmr-a2048`, tag `R3a6`, `DMR003.R3a6.V022.bin`, 378620 bytes. sha256 `57e712c0ab97f438aded0a733f1502f4120a55b8b3b0ed49c30ff704bf3118df`. File and pushed MD5 `1b9c2c4f8f0b5a9f2320f4cf3bcec479`.

Against the R3a5 image the file differs at three bytes: the tag's last character (`+0x3846E`, `5` → `6`), the +1024 immediate (`+0x5B028`, `0x3104` → `0x3108`, big-endian +2048), and the −1024 immediate (`+0x5B038`, `0x31FC` → `0x31F8`, big-endian −2048). The four `0x26` call sites, the AT1846S writes, `+0x3074` and `+0x3EDFC` are the R3a5 bytes. Bit 4 stays clear.

## Boot

VFO 467.625 / 467.625 FM at 01:33:42.496, low power. HackRF from 01:33:47, 180.0 s, floor power 6.77. YModem `onSuccess` at 01:35:56.936. Banner `开机初始化完成` at 01:36:10.932. `0x34` at 01:36:11.242 is `DMR003.R3a6.V022`. Hottest 100 ms bin +0.11 dB, at 168 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 01:37:07.335. `txwav` of the same 3 s of zeros. `0x26` launch 1 at 01:37:13.013, acked `sr=0`. `TX bench wav (3000 ms)`. `0x36` body `03` at 01:37:13.023. `played 24000 samples` at 01:37:16.436. Launch 2 at 01:37:16.438. `0x36` body `04` at 01:37:16.768.

Carrier 3.47 s, SNR 39.2 dB, clip 0. The median of the keyed deviation is +479 Hz. The three earlier silence keys sat near +1000 Hz. The VFO log still reads 467.625 / 467.625. Steady window, dropping the first 1.0 s and the last 0.3 s. The 40 Hz figure is the same FFT cutoff:

| Harmonic | A = 1024 | A = 2048 |
|---|---|---|
| 15.625 Hz | 537 Hz | 1213 Hz |
| 31.25 Hz | 2.4 Hz | 3.2 Hz |
| 46.875 Hz | 193 Hz | 383 Hz |
| 62.5 Hz | 3.4 Hz | 2.7 Hz |
| 78.125 Hz | 122 Hz | 214 Hz |
| 1000 Hz | 0.3 Hz | 0.3 Hz |

A 40 Hz low-pass of that window has rms 967 Hz and median absolute value 741 Hz. At A = 1024 the same low-pass was 438 Hz and 422 Hz. The rms rose by 2.21. The median rose by 1.75. 967 / 2048 = 0.47 Hz per count, against 0.43 at A = 1024 and 0.41 at A = 256 and A = 512. 741 / 2048 = 0.36 Hz per count. The flat top is a smaller part of the cycle than it was at A = 1024.

The fundamental, 1213 Hz, is close to `4A/π` for a square of amplitude 967 Hz (1231 Hz). The third harmonic doubled (383 Hz). The fifth rose by 1.76 (214 Hz). The evens stayed at a few hertz. The 1 kHz line is 0.3 Hz.

Raw `|deviation|` p99 is 1729 Hz, against 846 Hz at A = 1024. This time the edges doubled. The first 100 ms is a key-up click, p99 23008 Hz. The steady window is the stimulus, and it stayed under ±2 kHz.

## What this does not yet say

The deviation is still growing at A = 2048, and it stayed under the ±5 kHz stop. The rms ran a little ahead of a pure doubling. The median did not keep up, so a count of 5900 is still not a measured ±2.4 kHz. The next image is A = 4096, one more 6 dB step, another silence key. If the ratios repeat, the low-pass rms would be about 2.1 kHz and the steady p99 about 3.5 kHz. M17 samples are not in this image. §6 is not met.

## End state

Factory image restored over R3a6. YModem `onSuccess` at 01:39:32.773. Banner `开机初始化完成` at 01:39:45.065. `0x34` at 01:39:45.383 is `DMR003.UV4T.V022`. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:39:47.195, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. The first version poll returned the tag; the second-start path in the loader was not needed.

# R3a7 — A = 4096, still under the stop (2026-10-24, 01:43–01:49)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-four patch tests pass. A was not raised again in this image.

## The image

`c7000-txram-dmr-a4096`, tag `R3a7`, `DMR003.R3a7.V022.bin`, 378620 bytes. sha256 `50f8e78986a4efafd288b8d61811e289055ed1aba570278e14e2c6347a2c1354`. File and pushed MD5 `1b0da45c4510840aa7ac58e9b6cbd601`.

Against the R3a6 image the file differs at three bytes: the tag's last character (`+0x3846E`, `6` → `7`), the +2048 immediate (`+0x5B028`, `0x3108` → `0x3110`, big-endian +4096), and the −2048 immediate (`+0x5B038`, `0x31F8` → `0x31F0`, big-endian −4096). The four `0x26` call sites, the AT1846S writes, `+0x3074` and `+0x3EDFC` are the R3a6 bytes. Bit 4 stays clear.

## Boot

VFO 467.625 / 467.625 FM at 01:43:17.556, low power. HackRF from 01:43:22, 180.0 s, floor power 6.79. YModem `onSuccess` at 01:45:31.701. Banner `开机初始化完成` at 01:45:43.796. `0x34` at 01:45:44.107 is `DMR003.R3a7.V022`. Hottest 100 ms bin +0.13 dB, at 97 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 01:46:41.879. `txwav` of the same 3 s of zeros. `0x26` launch 1 at 01:46:47.552, acked `sr=0`. `TX bench wav (3000 ms)`. `0x36` body `03` at 01:46:47.563. `played 24000 samples` at 01:46:50.958. Launch 2 at 01:46:50.959. `0x36` body `04` at 01:46:51.288.

Carrier 3.45 s, SNR 39.3 dB, clip 0. The median of the keyed deviation is −331 Hz. The earlier silence keys read +1024, +953 and +479 Hz as that same median, while the VFO log kept reading 467.625. Steady window, dropping the first 1.0 s and the last 0.3 s. The 40 Hz figure is the same FFT cutoff:

| Harmonic | A = 2048 | A = 4096 |
|---|---|---|
| 15.625 Hz | 1213 Hz | 2227 Hz |
| 31.25 Hz | 3.2 Hz | 2.3 Hz |
| 46.875 Hz | 383 Hz | 808 Hz |
| 62.5 Hz | 2.7 Hz | 2.7 Hz |
| 78.125 Hz | 214 Hz | 490 Hz |
| 1000 Hz | 0.3 Hz | 0.5 Hz |

A 40 Hz low-pass of that window has rms 2266 Hz and median absolute value 1462 Hz. At A = 2048 the same low-pass was 967 Hz and 741 Hz. The rms rose by 2.34. The median rose by 1.97. 2266 / 4096 = 0.55 Hz per count, against 0.47 at A = 2048. 1462 / 4096 = 0.36 Hz per count, the same as A = 2048. The 1 kHz line is 0.5 Hz.

Raw `|deviation|` p99 is 3700 Hz, against 1729 Hz at A = 2048. The edges rose by 2.14. The first 100 ms is a key-up click, p99 22990 Hz. The steady window is the stimulus, and it stayed under ±4 kHz.

## What this does not yet say

A = 4096 is the largest square that was transmitted. Another doubling, A = 8192, would put the steady p99 near 8 kHz if this step's ratio repeated, past the ±5 kHz stop, so that image was not built. ±2.4 kHz as a clean M17 outer deviation is not what this square is: the fundamental is 2227 Hz and the edges are 3700 Hz. The next image is a 1 kHz sine in the same TX RAM, peak count 2048, the peak already measured as a square at p99 1729 Hz. M17 samples are not in this image. §6 is not met.

## End state

Factory image restored over R3a7. YModem `onSuccess` at 01:49:07.225. Banner `开机初始化完成` at 01:49:19.335. `0x34` at 01:49:19.648 is `DMR003.UV4T.V022`. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 01:49:21.452, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. The first version poll returned the tag; the second-start path in the loader was not needed.

# R3a8 — a 1 kHz sine at peak count 2048 (2026-10-24, 02:02–02:08)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-five patch tests pass. The peak was not raised. No M17 samples were sent.

## The image

`c7000-txram-dmr-sine1k`, tag `R3a8`, `DMR003.R3a8.V022.bin`, 378620 bytes. sha256 `8436ac95064e9643f034dfdc867dacccdb283752bf705c858f180187c2928147`. File and pushed MD5 `83b443d97cab5a7757f74da83b69dea6`.

The fill is eight samples, one cycle at 8 kHz, repeated 64 times across the 512 halfwords. The `movi r1` immediates are 0, 6, 8, 6, 0, 250, 248, 250. The TX RAM reads each stored halfword big-endian, so the aired samples are 0, +1536, +2048, +1536, 0, −1536, −2048, −1536. Peak count is 2048, the same peak as the A = 2048 square. `on_unkey` is at `+0x5B0A0`. The launch=1 sites still call `on_key` at `+0x5B000`. `+0x3074` and `+0x3EDFC` are factory. Bit 4 stays clear. The measured square patches still build.

## Boot

VFO 467.625 / 467.625 FM at 02:02:19.687, low power. HackRF running at 02:02:24, 180.0 s, floor power 6.81. YModem `onSuccess` at 02:04:33.673. Banner `开机初始化完成` at 02:04:45.784. `0x34` at 02:04:46.094 is `DMR003.R3a8.V022`. Hottest 100 ms bin +0.11 dB, at 132 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 02:05:44.193. `txwav` of 3 s of zeros. `0x26` launch 1 at 02:05:49.837, acked `sr=0`. `TX bench wav (3000 ms)`. `0x36` body `03` at 02:05:49.849. `played 24000 samples` at 02:05:53.243. Launch 2 at 02:05:53.246. `0x36` body `04` at 02:05:53.575.

Carrier 3.45 s, SNR 39.1 dB, clip 0. The median of the keyed deviation is +1039 Hz. The VFO log still reads 467.625, as it did when earlier silence keys read +1024, +953, +479 and −331 Hz. Steady window, dropping the first 1.0 s and the last 0.3 s:

| Line | Amplitude |
|---|---|
| 15.625 Hz | 3.0 Hz |
| 31.25 Hz | 3.7 Hz |
| 250 Hz | 0.5 Hz |
| 500 Hz | 0.9 Hz |
| 1000 Hz | 923 Hz |
| 2000 Hz | 3.5 Hz |
| 3000 Hz | 26.5 Hz |

The 15.625 Hz line, which was the square's fundamental (2227 Hz at A = 4096), is 3 Hz. The 1 kHz line is the sine. An 8-sample cycle of these values has a third harmonic 2.9% of its fundamental; 26.5 / 923 is 2.9%, so that 3 kHz line is the staircase, not a second tone. The 2 kHz line is 3.5 Hz. A 40 Hz FFT cutoff of the same window, the figure used on the squares, has rms 5.0 Hz. The raw steady rms is 731 Hz and the raw median absolute deviation is 715 Hz.

Steady p99 is 1217 Hz. The first 100 ms is a key-up click, p99 23251 Hz. The steady window is the stimulus, and it stayed under ±1.3 kHz. 923 / 2048 = 0.45 Hz per count on the tone. 1217 / 2048 = 0.59 Hz per count on the steady p99.

## What this does not yet say

The waveform is a sine, and it is not yet near the M17 outer deviation of ±2.4 kHz. A linear doubling, peak count 4096, predicts a 1 kHz line near 1850 Hz and a steady p99 near 2400 Hz, under the ±5 kHz stop. That is the next image. The peak was not raised in this one. M17 samples were not sent. §6 is not met.

## End state

Factory image restored over R3a8. YModem `onSuccess` at 02:08:09.502. Banner `开机初始化完成` at 02:08:21.899. `0x34` at 02:08:22.214 is `DMR003.UV4T.V022`. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 02:08:24.024, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written. The first version poll returned the tag; the second-start path in the loader was not needed.
