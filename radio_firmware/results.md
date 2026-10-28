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

# R3a9 — a 1 kHz sine at peak count 4096 (2026-10-24, 02:12–02:19)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-six patch tests pass. The peak was not raised. No M17 samples were sent.

## The image

`c7000-txram-dmr-sine1k-p4096`, tag `R3a9`, `DMR003.R3a9.V022.bin`, 378620 bytes. sha256 `ebe8144f22e9eb3c7ad9956ac6911b0356592927cfeec1937adb767f8fc28013`. File and pushed MD5 `ccab6930545b0d35fa38279e7e48bd72`.

Same eight-sample cycle as R3a8, with the peak immediate doubled. The `movi r1` immediates are 0, 11, 16, 11, 0, 245, 240, 245. The aired samples are 0, +2816, +4096, +2816, 0, −2816, −4096, −2816. The built file differs from R3a8 at the tag byte and at those six immediate bytes. `on_unkey` stays at `+0x5B0A0`. `+0x3074` and `+0x3EDFC` are factory. Bit 4 stays clear. The measured R3a8 sine still builds.

## Boot

VFO 467.625 / 467.625 FM at 02:12:48.342, low power. HackRF running at 02:12:53, 180.0 s, floor power 6.78. YModem `onSuccess` at 02:15:02.396. The first version poll returned `0x29050000` and no `0x34`. The loader started SignalDeck again. Banner `开机初始化完成` at 02:16:12.953. `0x34` at 02:16:13.265 is `DMR003.R3a9.V022`. Hottest 100 ms bin +0.12 dB, at 170 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 02:16:33.616. `txwav` of 3 s of zeros. `0x26` launch 1 at 02:16:39.276, acked `sr=0` at 02:16:39.280. `TX bench wav (3000 ms)`. `0x36` body `03` at 02:16:39.286. `played 24000 samples` at 02:16:42.675. Launch 2 at 02:16:42.677, acked `sr=0`. `0x36` body `04` at 02:16:43.009.

Carrier 3.45 s, SNR 39.0 dB, clip 0. The median of the keyed deviation is +1047 Hz. The VFO log still reads 467.625. Steady window, dropping the first 1.0 s and the last 0.3 s:

| Line | Amplitude |
|---|---|
| 15.625 Hz | 2.8 Hz |
| 31.25 Hz | 3.8 Hz |
| 250 Hz | 0.7 Hz |
| 500 Hz | 1.2 Hz |
| 1000 Hz | 1923 Hz |
| 2000 Hz | 11.9 Hz |
| 3000 Hz | 26.0 Hz |

The 15.625 Hz line is 3 Hz, as it was at peak count 2048. The 1 kHz line is 1923 Hz, 2.08× the 923 Hz at half the peak, so the tone tracked the doubling. The 3 kHz line is 26 Hz, the same size it was at peak count 2048 (26.5 Hz), so it did not grow with the tone. The 2 kHz line rose from 3.5 Hz to 11.9 Hz and is still under 1% of the tone. The raw steady rms is 1383 Hz.

Steady p99 is 2186 Hz, 1.80× the 1217 Hz at peak count 2048. The first 100 ms is a key-up click, p99 23279 Hz. The steady window is the stimulus, and it stayed under ±2.2 kHz. 1923 / 4096 = 0.47 Hz per count on the tone. 2186 / 4096 = 0.53 Hz per count on the steady p99.

## What this does not yet say

The waveform is a sine, and the tone is not yet at the M17 outer deviation of ±2.4 kHz. The steady p99 is 2186 Hz. One more step, peak immediate 20 (peak count 5120), scales the measured tone to about 2400 Hz and the steady p99 to about 2700 Hz. Both sit under the ±5 kHz stop. That is the next image. The peak was not raised in this one. M17 samples were not sent. §6 is not met.

## End state

Factory image restored over R3a9. YModem `onSuccess` at 02:18:59.822. Banner `开机初始化完成` at 02:19:11.565. `0x34` at 02:19:11.875 is `DMR003.UV4T.V022`, on the first poll. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 02:19:13.726, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written.

# R3a10 — a 1 kHz sine at peak count 5120, tag R3b0 (2026-10-24, 02:26–02:32)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-seven patch tests pass. The peak was not raised. No M17 samples were sent. The version field holds four characters, so the image tag is `R3b0` and the handoff name of the step is R3a10.

## The image

`c7000-txram-dmr-sine1k-p5120`, tag `R3b0`, `DMR003.R3b0.V022.bin`, 378620 bytes. sha256 `0861b82a6e82ffd8316e7155c55f566006b0f13f0c5990fe3c726b9fc70e7e39`. File and pushed MD5 `d72f17a6c5be609311d995ddf71d836e`.

Same eight-sample cycle as R3a9, with the peak immediate raised from 16 to 20. The `movi r1` immediates are 0, 14, 20, 14, 0, 242, 236, 242. The aired samples are 0, +3584, +5120, +3584, 0, −3584, −5120, −3584. The built file differs from R3a9 at two tag bytes and at those six immediate bytes. `on_unkey` stays at `+0x5B0A0`. `+0x3074` and `+0x3EDFC` are factory. Bit 4 stays clear. The measured R3a8 and R3a9 sines still build.

## Boot

VFO 467.625 / 467.625 FM at 02:26:16.526, low power. HackRF running at 02:26:21, 180.0 s, floor power 6.76. YModem `onSuccess` at 02:28:30.684. Banner `开机初始化完成` at 02:28:44.605. `0x34` at 02:28:44.915 is `DMR003.R3b0.V022`, on the first poll. Hottest 100 ms bin +0.16 dB, at 96 s, clip 0, nothing at +6 dB. The reboot is inside the file. The stub does not run at boot.

## The silence key

VFO 467.625 again at 02:29:40.858. `txwav` of 3 s of zeros. `0x26` launch 1 at 02:29:46.509, acked `sr=0` at 02:29:46.513. `TX bench wav (3000 ms)`. `0x36` body `03` at 02:29:46.519. `played 24000 samples` at 02:29:49.917. Launch 2 at 02:29:49.919, acked `sr=0`. `0x36` body `04` at 02:29:50.245.

Carrier 3.46 s, SNR 39.1 dB, clip 0. The median of the keyed deviation is +1036 Hz. The VFO log still reads 467.625. Steady window, dropping the first 1.0 s and the last 0.3 s:

| Line | Amplitude |
|---|---|
| 15.625 Hz | 2.6 Hz |
| 31.25 Hz | 2.8 Hz |
| 250 Hz | 1.6 Hz |
| 500 Hz | 0.5 Hz |
| 1000 Hz | 2261 Hz |
| 2000 Hz | 18.8 Hz |
| 3000 Hz | 13.7 Hz |

The 15.625 Hz line is 3 Hz, as it was at peak counts 2048 and 4096. The 1 kHz line is 2261 Hz. The peak count rose by 1.25× and the tone rose by 1.18× (1923 Hz at peak count 4096), so the tone scale compressed. The 3 kHz line fell from 26 Hz to 14 Hz. The 2 kHz line rose from 11.9 Hz to 18.8 Hz and is still under 1% of the tone. The raw steady rms is 1746 Hz.

Steady p99 is 2674 Hz, 1.22× the 2186 Hz at peak count 4096. The first 100 ms is a key-up click, p99 23301 Hz. The steady window is the stimulus, and it stayed under ±2.7 kHz. 2261 / 5120 = 0.44 Hz per count on the tone. 2674 / 5120 = 0.52 Hz per count on the steady p99.

## What this does not yet say

The tone is 2261 Hz, 6% under the M17 outer deviation of ±2.4 kHz. The steady p99 is 2674 Hz, 11% over it. The waveform is still a sine, and it is smooth: the square's 15.625 Hz line is 3 Hz. Another sine step is not the next measurement. The same peak, count 5120, already sits at a steady p99 of 2674 Hz, so a later fill keeps every sample at or below that count. §6 is not met.

## End state

Factory image restored over R3b0. YModem `onSuccess` at 02:32:06.360. Banner `开机初始化完成` at 02:32:18.323. `0x34` at 02:32:18.633 is `DMR003.UV4T.V022`, on the first poll. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. VFO 467.625 / 467.625 FM at 02:32:20.450, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written.

# R4a — an RRC 4FSK pattern at peak count 5120, tag R4a0 (2026-10-24, 02:48–03:01)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-eight patch tests pass. The peak was not raised. No M17 frame was sent. The version field holds four characters, so the image tag is `R4a0`.

## The image

`c7000-txram-dmr-rrc`, tag `R4a0`, `DMR003.R4a0.V022.bin`, 378620 bytes. sha256 `9271b363eeda6e6ad6625007e98bd25795eb05c1f3e22c23bac1fc6951fac653`. File and pushed MD5 `049ff4ed685179c3392a5931b9ca5e9b`.

Same host-key path as the sine. The stub is 180 bytes at `+0x5B000`, and `on_unkey` is at `+0x5B080`. The fill is 512 little-endian halfwords at `+0x5C000` (XIP `0x03076000`). `+0x3074` and `+0x3EDFC` are factory. Bit 4 stays clear. The measured sine images still build.

The samples are one root-raised-cosine, α = 0.5, at 4800 symbols/s and 8 kHz. The symbol sequence, repeated, is +3, +1, −1, −3, +3, −1. Six symbols are ten samples. 306 symbols fill 510 samples, and samples 510 and 511 repeat samples 0 and 1, so the wrap has one extra pair. The signed immediates of that ten-sample period are 19, 12, 2, −2, −12, −20, 7, 20, −7, 1. The aired counts are those immediates times 256. The peak is ±5120. The period repeats 51 times, then the first two samples.

## Boot

VFO 467.625 / 467.625 FM at 02:48:52.099, low power. HackRF probe 9600000 bytes at 02:48:51. Boot capture from 02:48:57, 180.0 s, floor power 6.81. YModem `onSuccess` at 02:51:06.463. Banner `开机初始化完成` at 02:51:20.359. `0x34` at 02:51:20.671 is `DMR003.R4a0.V022`, on the first poll. Hottest 100 ms bin +0.18 dB, at 177 s, clip 0, nothing at +6 dB. That bin is spread across ±24 kHz, so it is the noise floor. The stub does not run at boot.

## The silence key

VFO 467.625 again at 02:52:16.522. `txwav` of 3 s of zeros. `0x26` launch 1 at 02:52:22.179, acked `sr=0` at 02:52:22.184. `TX bench wav (3000 ms)`. `0x36` body `03` at 02:52:22.190. `played 24000 samples` at 02:52:25.578. Launch 2 at 02:52:25.579, acked `sr=0` at 02:52:25.585. `0x36` body `04` at 02:52:25.911.

Carrier 3.44 s, SNR 39.5 dB, clip 0. The median of the keyed deviation is +908 Hz. The VFO log still reads 467.625. Steady window, dropping the first 1.0 s and the last 0.3 s:

| Line | Amplitude |
|---|---|
| 15.625 Hz | 11.0 Hz |
| 31.25 Hz | 15.0 Hz |
| 250 Hz | 12.0 Hz |
| 500 Hz | 15.5 Hz |
| 1000 Hz | 17.1 Hz |
| 2000 Hz | 21.6 Hz |
| 3000 Hz | 12.2 Hz |

The 1 kHz line is 17 Hz. The 15.625 Hz line is 11 Hz. The other preset lines from 47 Hz through 3 kHz are 10–22 Hz. The raw steady rms is 1516 Hz.

Steady p99 is 2774 Hz (`steady_p99 2773.72`). The first 100 ms is a key-up click, p99 23098 Hz (`click_p99 23098.4`). The steady window is the stimulus, and it stayed under ±2.8 kHz. `STOP False`. 2774 / 5120 = 0.54 Hz per count on the steady p99.

The capture log's half-second fit does not lock (`r2` −0.005, `follows_pattern` false). That fit held one alignment across 0.5 s. The extra pair at the end of the buffer walks the phase: 510 of every 512 samples advance the ten-sample pattern, so the long-term rate is 8000 × (510 / 512) / 10 = 796.875 Hz. On the first 0.25 s of the steady window the autocorrelation is 0.96 at a lag of 60 samples, 0.926 at 120, and 0.894 at 180. That lag is 800 Hz, ten stored samples at 8 kHz. Over the whole steady window the 796.875 Hz line is 1152 Hz, the 1593.75 Hz line is 867 Hz, and the 2390.625 Hz line is 649 Hz. The 800.0 Hz line is 1 Hz.

Ten-millisecond stretches, eight periods stepped every 50 ms, 43 of them: a linear interpolation of the ten stored counts fits at median r² 0.96, and 36 of the 43 reach 0.95. The gain on those stretches is −0.54 Hz per count. A positive gain on the same shape reaches median r² 0.14, and none reach 0.95. A time-reversed copy reaches median r² 0.75, and none reach 0.95. A zero-order hold of the ten levels reaches median r² 0.84, and none reach 0.95. The air follows the stored shape with the sign flipped, as one continuous wave.

## What this does not yet say

The steady p99 is 2774 Hz, near the M17 outer deviation of ±2.4 kHz, and the sign on the air is the opposite of the stored count. Four held symbol levels are absent at this sample rate. No M17 frame was sent. Command `0x3D` is not in this image. §6 is not met.

## End state

The first factory restore failed. YModem `onFailed, reason=Received CAN` at 02:53:09.509, loader exit 1. The pushed factory MD5 was `4426035392262ca54583c230c9e268e0`. Further waits at 02:54:41 and 02:56:16 returned no `0x34`. `/sdcard/DMR/DMRDEBUG.bin` was already absent.

The second restore succeeded. It started at 02:57:40. YModem `onSuccess` at 02:59:49.055. The first version poll was empty. The loader's second start of SignalDeck printed `0x34` at 03:00:58.517, `DMR003.UV4T.V022`. The tool log for this restore has no banner line. VFO 467.625 / 467.625 FM at 03:00:59.876, low power. SignalDeck owns the radio. `/sdcard/DMR/DMRDEBUG.bin` is absent. `PATCH14_BACKUP.bin` was not touched. The ES8311 debug node was not written.

# T2 — `WORK_MODE` 0x22, read only (2026-10-24)

No image was loaded. Nothing was keyed. The factory image was disassembled at the two sites already named in ch. 19, `+0x179C8` and `+0x17D54`. The sibling notes in M17-Project/AtomXL-reverse-engineering (`atomxl-re-docs/dmr-firmware-notes.md`) were read for a raw-symbol register. They do not name one.

## What the image stores

Both sites build `WORK_MODE` the same way: `movih r3, 0x1100`, then `bseti r3, 8`, which is `0x11000100`. Each stores 34 (`0x22`) when byte 3 of the RAM struct at `0x34808` is nonzero, and each begins the same store when byte 4 is nonzero.

On the byte-3 path the first copy (`+0x179C8`) also stores `0x1100039c` = `0x1800`, `0x11000400` = `0x40`, and `0x11000408` = `0x41`, then returns. The second copy (`+0x17D54`) stores `0x1100039c` = `0x800` and the same `0x40` / `0x41`. The first copy's byte-4 path stores `WORK_MODE` = `0x22`, `0x11000400` = `0x82`, and `0x11000408` = 1, then returns. Neither path writes a sample buffer, a symbol FIFO, or `RF_MODE`.

When byte 3 and byte 4 are both zero, the first copy continues. If byte 2 is 4 it stores `WORK_MODE` = `0x6A`. Otherwise it stores `0x6E`. That fall-through writes `0x11000384` from byte `0xA` and does not write a symbol buffer either.

`0x34808` occurs as a literal 141 times. Bytes 3 and 4 are not named. The 163-byte digital unpack at `+0x9310` was not shown copying the channel into this struct. A normal digital channel's value for those two bytes is unread.

## Filter controls

The `0x22` paths do not write `FM_BANDWIDTH` (`0x11000500`) or `RF_MODE` (`0x11000104`). The only full-word `RF_MODE` store previously found is the FM key-up's `0x10E0`, whose bit 7 is clear. The sibling notes call bit 7 of `WORK_MODE` the FM-mode bit, call `FM_BANDWIDTH` the FM band-pass and emphasis (never written, reset `0x5F`), and call `RF_MODE` bits 31 and 29 an undocumented physical-layer receive test. They also say no documented register exposes the 38.4 kHz receive samples to the CPU. No RRC coefficient register is written on this path.

## What this does not yet say

The CPU path that selects `0x22` does not take symbols from a buffer it fills. That does not show a modem FIFO the hardware might read on its own. Bytes 3 and 4 of `0x34808` are still unnamed, so it is unread whether a normal channel even takes the `0x22` path. T2 is not closed. A `0x22` image was not built. §6 is not met.

## End state

The radio was not touched. End state remains the R4a restore: factory image, `0x34` `DMR003.UV4T.V022` at 03:00:58.517, VFO 467.625 / 467.625 FM at 03:00:59.876, low power, no `DMRDEBUG.bin`.

# T2 — bytes 3 and 4 of `0x34808` (2026-10-24)

No image was loaded. Nothing was keyed. The factory image and the OEM BER sender were read.

## The two bytes

The only stores that cover byte 3 or byte 4 are in the initializer at `+0x11E0`. It loads the base `0x34808` at `+0x120A`. A walk of the 602 real `lrw`s of that address, across 141 pool slots, found six stores and no others. The pointer is written to the stack at `+0x0B308` and is not saved as a global.

RAM flag `0x324D7` selects the pair. `r3` is 0 before the compare. Flag 1 takes `+0x13E4`: byte 3 = 1, byte 4 = 0. Flag 2 takes `+0x13F2`: byte 3 = 0, byte 4 = 1. Any other value falls through `+0x124A` and writes both bytes 0.

Both channel setups call the initializer before they read the struct. `+0x176FC` and `+0x17B62` are `bsr 0x11E0`. Boot zeroes IRAM from `0x31AF4` through `0x4DAB0`, and `0x324D7` sits in that range, so the flag starts at 0.

## Who sets the flag

The address has five `lrw`s. The one at `+0x1236` is the initializer's read. None of the five stores the value 2, so the byte-4 arm is present and unused by these writers. A copy that never names the address is still unnamed.

Command `0x3F` is the OEM BER test (`TEST_BIT_ERROR_RATE`, literal 63). Its thunk is `+0xAAEE` (dispatcher table at file `+0x38240`, index 29). The handler at `+0x8FA8` reads the first body byte. Value 1 stores the flag as 1, stores `0x3CE6F` as 0, and passes the string at file `+0x38444`, `宏睿误码率测试`. Value 2 does `movi r3, 1` before the store, so the flag is 1 again, stores `0x3CE6F` as 1, and passes file `+0x38454`, `o.153误码率测试`. Both strings sit immediately before `DMR003.UV4T.V022` at file `+0x38464`. The OEM screen `FragmentLocalTestBiteErrorRateActivity` sends body byte 2 on open. Either value makes the next channel setup write byte 3 = 1 and byte 4 = 0, and that setup then stores `WORK_MODE` `0x22`. The modem generates the pattern. The CPU still fills no symbol buffer on that path.

`+0x7EF0` is the other writer. It stores 1 only when its `r2` is 0 and byte 8 of its argument is 1, and it clears the flag when `r2` is 0 and that byte is some other value. The `0x21` handler at `+0x8BE4` calls it. Sub-command 34 (table `0x030520D8`, stub `+0x8C5C`) passes `r2` from the return of `+0x8A44`. The other site, `+0x8C34`, stores 0 at argument byte 8 and then calls. The phone app has no `0x21` sender. This writer was not followed past those two sites.

## The normal path

With the flag at 0 the initializer writes byte 3 = 0 and byte 4 = 0. The first setup then stores `WORK_MODE` `0x6A` when byte 2 is 4, and `0x6E` otherwise. After that store it calls `+0x18218`. That function reads byte 5, zeros three bytes at `0x4D404+0xF9` when byte 5 is 1, and calls `+0x186BC` and `+0x28904`. `+0x186BC` zeros the record at `0x4C7BC`, calls `+0x1AE8` with 3080, and returns. `+0x28904` zeros the record at `0x4D318`, clears 27 bytes at `0x4D3AD` and at `0x4D3C8`, calls `+0x1B76C` (one byte at `0x4C7E8+2`), and returns. `+0x18218` then writes bits in `0x11000404` and `0x11000408`. When byte 1 is nonzero it sets bit 8 of `WORK_MODE` and stores `0x1100039C` = `0x1E07F`. It calls `+0x18068`, prints `close slot.` from file `+0x38A6C`, and returns. When byte 2 is 4 the setup also calls `+0x19438`, which sets bit 4 of `0x11000400`, stores `0x1100040C` = `0x20000000`, sets bit 1 of `0x11000404`, and returns. None of these functions writes a symbol buffer.

## What this does not yet say

A modem FIFO the CPU never touches is still unnamed. T2 is closed on the reading above: `0x22` is the built-in BER test, and the path a normal channel takes fills no symbol buffer either. No `0x22` image was built. §6 is not met.

## End state

The radio was not touched. End state remains the R4a restore: factory image, `0x34` `DMR003.UV4T.V022` at 03:00:58.517, VFO 467.625 / 467.625 FM at 03:00:59.876, low power, no `DMRDEBUG.bin`.

# T3 — AT1846S registers `0x3A`, `0x30`, `0x41`–`0x44`, `0x35` and `0x36` (2026-10-24)

No image was loaded. Nothing was keyed. `scripts/fw_at1846_regmap.py` was run on a fresh factory disassembly (no `-M`), not on the script's default listing. Every `bsr 0xFD011220` in that listing was checked. One write does not build `r0` with `movi`: the bandwidth profile at `+0x2B30`. Every other write does. Registers `0x35` and `0x36` have no write and no read.

The two public descriptions disagree, and both are cited. The OpenRTX web table is https://github.com/OpenRTX/openrtx.github.io/blob/master/at1846_registers.md. The Auctus text is AT1846S/AT1846SD Programming Guide 1.4, https://www.opengd77.com/downloads/datasheets/AT1846S/AT1846S-ProgrammingGuide-1.4.pdf. Ch. 11 already reads `0x30` = `0x0001` as that guide's soft reset, and it already calls `0x44` bits 11:8 the TX mic gain. Those readings are kept. §11 is not rewritten.

## The stores

`at1846_apply_bw_profile` (`+0x2B14`) is the indirect writer. The loop at `+0x2B2C` loads the register number from SRAM `0x18000808` (file `+0x322E8`) and the halfword from flash `0x03050608` (file `+0x36608`, 46 bytes per row) and writes at `+0x2B30`. Of the asked registers the list contains only `0x3A`. `0x3C` is not on the asked list. It is included because the OpenRTX table puts the voice source there.

| Row | `0x3A` | `0x3C` |
|---|---|---|
| 12.5 kHz | `0x00C3` | `0x0407` |
| 25 kHz | `0x04C3` | `0x1930` |

`at1846_init` (`+0x2BAC`):

| Offset | Register | Value |
|---|---|---|
| `+0x02BB2` | `0x30` | `0x0001` |
| `+0x02BC0` | `0x30` | `0x0004` |
| `+0x02C18` | `0x41` | `0x470F` |
| `+0x02C22` | `0x42` | `0x1036` |
| `+0x02C2A` | `0x43` | `0x00BB` |
| `+0x02C34` | `0x44` | `0x07F7` |
| `+0x02C3C` | `0x3A` | `0x00C3` |
| `+0x02CB0` | `0x30` | `0x40A4` |
| `+0x02CC0` | `0x30` | `0x40A6` |
| `+0x02CD0` | `0x30` | `0x4006` |
| `+0x02D04` | `0x3A` | `0x00C3` |
| `+0x02D0E` | `0x3C` | `0x0407` |

`at1846_tune` (`+0x2DD8`):

| Offset | Register | Value |
|---|---|---|
| `+0x02DF2` | `0x30` | `0x4006` |
| `+0x02E26` | `0x30` | `0x4046` |
| `+0x02E34` | `0x42` | `0x1036` |
| `+0x02E3C` | `0x43` | `0x00BB` |
| `+0x02E78` | `0x30` | `0x4006` |
| `+0x02E82` | `0x30` | `0x4026` |
| `+0x02E8C` | `0x44` | `0x0AD1` |
| `+0x02EA8` | `0x3A` | `0x00C9` |
| `+0x02ECE` | `0x3A` | `0x00C3` |
| `+0x02ED8` | `0x3C` | `0x0407` |
| `+0x02FEA` | `0x30` | `0x4046` |
| `+0x03024` | `0x42` | `0x1052` |
| `+0x0302E` | `0x43` | `0x0100` |
| `+0x0303C` | `0x30` | `0x4006` |
| `+0x03046` | `0x30` | `0x4026` |
| `+0x0306A` | `0x44` | `0x0AD1` |
| `+0x03074` | `0x3A` | `0x40C3` |
| `+0x03082` | `0x30` | `0x7006` |
| `+0x0308C` | `0x30` | `0x7026` |

The function at `+0x3190` writes one `0x30` and returns. `+0x031B0` = `0x40A6`, `+0x031C2` = `0x4026`, `+0x031D0` = `0x70A6`, `+0x031DE` = `0x7026`.

The function at `+0x31E4` runs these only when byte 0 of its copied struct is 0. `+0x0320E` reads `0x3A` and `+0x03222` writes that halfword ANDed with `0x8FFF`, after saving the original at `(r7, 2)`. `+0x03234` reads `0x30` and `+0x03240` sets bit 11. `+0x03250` writes `0x30` = `0x4006`. `+0x03258` writes the saved `0x3A` halfword back.

`at1846_set_ctcss_dcs` (`+0x32E4`) writes `0x3A` = `0x40C9` at `+0x03324`, `0x40CC` at `+0x033A2`, `0x40D1` at `+0x033E4`, and `0x40CA` at `+0x0343A`.

The function at `+0x346C` writes `0x41` = `0x4730` at `+0x034A0`.

The function at `+0x61A8` writes `0x44` at `+0x061CE`. The value is one byte from the table at file `+0x36EE4` (XIP `0x03050EE4`), indexed by the byte at `0x38C70+0x10`, ORed with `0x0700`.

`set_tx_gain_reg44` (`+0x8E0C`) reads `0x44` at `+0x08E12` and writes it at `+0x08E26`: bits 11:8 replaced by the caller byte, low byte forced to `0xFF`.

The function at `+0xA108` reads `0x44` at `+0x0A10E` and writes it at `+0x0A130`: bits 11:8 replaced by a halfword from the table at file `+0x383E4` (XIP `0x030523E4`), low byte forced to `0xFF`.

The function at `+0xA150` reads `0x41` at `+0x0A156` and writes it at `+0x0A164`: bits 6:0 replaced by the caller byte.

The function at `+0xA16C` writes `0x44` = `0x0FFF` at `+0x0A266` and `0x41` = `0x4705` at `+0x0A270`.

`at1846_rx_off` (`+0xB00C`) reads `0x30` and writes it back with bits 6 and 5 clear (`+0x0B024`, AND `0xFF9F`), then with bit 2 clear (`+0x0B038`, AND `0xFFFB`). `at1846_rx_on` (`+0xB048`) sets bit 2 (`+0x0B058`), waits 10 ms, and sets bit 5 (`+0x0B070`).

`0x42` and `0x43` are the immediates above. Neither is read back. `0x35` and `0x36` have no `bsr` to the register write or the register read. The six `movi r0, 53` / `movi r0, 54` sites in the whole dump are `+0x7BE6`, `+0x7C1A`, `+0x25642`, `+0x258C0` (argument 54 to `bsr 0x9120` or `bsr 0x2A4C`) and `+0x4075A`, `+0x407E8` (byte 53 stored into a frame). They are not chip selects.

## What the values select

Programming Guide register 30h bit 10 is `direct_reg`: "1=enable direct_reg, 0=disable direct_reg". The guide gives no further definition. The same page uses "direct reg" for register 03h bit 12, which overrides `tx_adc_reset`, and for register 04h bit 7, which overrides `dsp_resetn`. The wording is an override of another control bit. It is not described as a modulation input. Bit 10 is clear in every immediate: `0x0001`, `0x0004`, `0x40A4`, `0x40A6`, `0x4006`, `0x4046`, `0x4026`, `0x7006`, `0x7026`, `0x70A6`. The read-modify-writes set bit 11, clear bits 6 and 5, clear bit 2, set bit 2, or set bit 5. None sets bit 10.

The guide's other `0x30` names match the immediates. Bit 0 is `soft_reset` (`0x0001`). Bit 2 is `pdn_reg` (`0x0004`, chip power). Bit 14 is `xtal_mode`. Bits 13 and 12 are the 25 kHz / 12.5 kHz selects, so `0x40xx` is 12.5 kHz and `0x70xx` is 25 kHz. Bit 6 is `tx_on` (`0x4046`). Bit 5 is `rx_on` (`0x4026`, `0x7026`). The OpenRTX web table packs channel mode into bits 13:12 and does not name bits 14, 10, or 0. Both sources agree on bits 13:12 and on bits 6, 5, and 2. The DMR leave-at `0x4026` and the FM wide pair are the ones already in ch. 19. The wide pair was not used as a test state.

Voice source, both definitions. Guide section 5: `3aH[14:12]` `voice_sel` is 000 = Tx nothing, 001 = tone1, 010 = tone2, 011 = both tones, 100 = microphone, other = reserved. Every stored `0x3A` is 000 or 100. `0x00C3`, `0x00C9`, and the 25 kHz profile's `0x04C3` are 000. `0x40C3`, `0x40C9`, `0x40CC`, `0x40D1`, and `0x40CA` are 100. The `+0x31E4` AND with `0x8FFF` clears bits 14:12 (000) and the later write puts the saved halfword back. The OpenRTX table does not document `0x3A`. It puts voice selection on `0x3C` bits 15:14: 00 = microphone, 01 = inner sine (tone2), 10 = GPIO1 `code_in`, 11 = nothing. Every `0x3C` store is `0x0407` or the 25 kHz profile's `0x1930`. Both have bits 15:14 = 00. The inner sine is not selected and GPIO `code_in` is not selected. `code_in` would be a 1-bit pin input. The other bits of `0x0407` and of `0x1930` stay unnamed: the guide's register introduction does not list `0x3C`, and the OpenRTX table names only bits 15:14.

`0x35` and `0x36` are the tone frequencies (OpenRTX: freq_kHz × 2^12; the guide's DTMF section uses frequency(Hz) × 10). Nothing writes them. Guide registers `0x79` and `0x7A` (`dtmf_en`, `single_tone`) were not on the asked list and were not scanned. The voice-select field is never left on a tone, so that scan was not needed to close the tone path.

`0x41` keeps the high byte at `0x47` and changes bits 6:0 (15, 48, 5, or the caller byte). Guide section 11 and register 41h call bits 6:0 `voice_gain_tx`, default `0x4006`. The OpenRTX table calls the whole register the VOX open threshold. The guide's VOX thresholds are register `0x64`, not `0x41`. Either reading of `0x41` is one scalar.

`0x42` is only `0x1036` and `0x1052`. The OpenRTX table calls the whole register the VOX close threshold. The programming guide does not list `0x42`. The values are constants.

`0x43` is `0x00BB` and `0x0100`, the pair already in §11. The OpenRTX table calls bits 12:6 the voice-plus-CTCSS deviation and bits 5:0 the CTCSS-only deviation. Guide section 11 puts those two deviation fields on register `0x59` and does not list `0x43`. Either reading is one constant.

`0x44` is `0x07F7`, `0x0AD1`, `0x0FFF`, or one table byte / caller byte placed in bits 11:8 or in the low byte and ORed with `0x0700` or `0x00FF`. Guide register 44h calls bits 11:8 `gain_tx`, bits 7:4 the DAC gain, and bits 3:0 the digital volume. The image writes bits 11:8, which is the field ch. 11 already uses. The OpenRTX table documents only bits 7:0, as RX volume. Each write is one gain word.

## What this does not yet say

No stored value of this set enables `direct_reg`, an on-chip tone, or GPIO `code_in`. The datasheet's analog baseband pins were not traced on this module, and no asked register is programmed as a sample input. T3 closes the AT1846S register route as a host-symbol path. No image was built. §6 is not met. `0x3D` still waits, and T1 stays the main line. T4 stays closed: T1 has not failed. Whether a baseband pin is wired is unread.

## End state

The radio was not touched. End state remains the R4a restore: factory image, `0x34` `DMR003.UV4T.V022` at 03:00:58.517, VFO 467.625 / 467.625 FM at 03:00:59.876, low power, no `DMRDEBUG.bin`.

# R-A — C7000 receive symbols, read only (2026-10-24)

No image was loaded. Nothing was keyed. The factory image was disassembled with no `-M`. The question was whether this image reads sliced 4FSK symbols or discriminator samples from modem RAM and can put them on the UART.

## What the CPU reads

`+0x2A4C` copies `r2` bytes from `r0 + 0x160004B0` into `r1`. A length of 0 returns at once. There are 26 direct calls. Every `r0` is a `movi`. No call walks the window.

| `r0` | Length | Calls | Source |
|---|---|---|---|
| 0 | 12 | 10 | `0x160004B0`–`0x160004BB` |
| 0 | 9 | 5 | `0x160004B0`–`0x160004B8` |
| 0 | 12, 18, or 24 | `+0x1E1CA` | starts at `0x160004B0`; 24 bytes end at `0x160004C7` |
| 43 | 5 | `+0x25B6C` | `0x160004DB`–`0x160004DF` |
| 48 | 36 | `+0x27E78` only | `0x160004E0`–`0x16000503` |
| 54 | 27 | `+0x25648`, `+0x258C6` | `0x160004E6`–`0x16000500` |
| 57 | 27 | `+0x25698`, `+0x25916` | `0x160004E9` |
| 102 | 27 | `+0x2560A`, `+0x258A4` | `0x16000516` |
| 105 | 27 | `+0x25676`, `+0x258F4` | `0x16000519` |

The 12-byte, 9-byte, and 5-byte copies end before `0x160004E0`. At `+0x1E1CA` (function `+0x1E0F8`) the length is a stack byte: an incoming byte of 7, 8, or 10 selects 12, 18, or 24, and the same arms store the halfwords 240, 511, and 271 at `0x4D0F0+0x1FA`. 511 is 2^9−1. The copy still starts at `0x160004B0`, and the function then calls `+0x14EC`.

The 36-byte copy is the only one that starts at `0x160004E0`. It is inside `+0x27E50`. That function stores the caller's pointer, loads the word at `0x11000390`, copies 36 bytes, and returns the low 2 bits of that word. The two callers are `+0xAD7C` and `+0xAE2A`, both in `+0xAD64`, and the pointer is `0x3246C+56` (`0x324A4`). When the return equals 1, `+0xAF74` clears the byte at `(r4, 0x6A)` and joins the compare that already has the copied bytes. It does not copy the window again.

`+0xAD64` is the BER scorer. It reads `0x3CE6F`, the pattern select T2 already named (0 = Hongrui, 1 = O.153). Both arms call `+0x27E50`, XOR the copied bytes against a ROM pattern, and count set bits into the word at `(r4, 0x5C)`. The compare runs while the index is not 33, so 33 bytes, 264 bits. The patterns sit at file `+0x38488` and file `+0x384AC`, just after the version string, and they are not text. When the first arm's call count is divisible by 100, or the second arm's count passes 119, the function converts the error count and calls `family21_emit` (`+0x7E94`) with `r3` = 34 and a 6-byte body: the bytes 1 and 2, then two halfwords. `family21_emit` builds `68 21` and stores `r3` at byte 2. The 33 payload bytes stay on the MCU.

The scorer has one caller, `+0xC0D4`, in the task that starts at `+0xC084`. That task pends flag object `0x37744` with mask 15. Value 8 clears the flag and calls the scorer. Values 1, 2, and 4 update status bytes at `0x38908` and `0x34808+0x2B` and do not call `+0x2A4C`. The task is created at `+0xC2D0` by `OSTaskCreate`, function pointer `0x03026084`, and that pointer occurs once, at file `0xC358`. Command `0x3F` does not call the scorer. It selects the pattern, which T2 already read. The post that raises flag value 8 was not traced.

The 27-byte copies are an odd length, so they are not 16-bit samples. The image does not name the record. The sites at `+0x256xx` choose the source from byte 2 of `0x34808` (the same byte-2==4 test T2 used for `WORK_MODE`) and from a byte at `(r8−7)`. The destination is `0x4D3AD + (byte at 0x4D318+0xB) * 27`. `+0x2B778` then copies those 27 bytes into a second SRAM pair at `0x4D49E + n*27` and toggles the index byte. One later site passes that slot to IRAM `0xFD014BEC` when byte `0x12` of `0x34808` is 2 or 3. `reply_build`, `uart_send`, and `family21_emit` are not called with `0x4D3AD` or `0x4D49E`.

`+0x2A18` is the other direction. It writes `r2` bytes from the caller's pointer into modem RAM at `r0 + 0x16000000`. It has 23 calls. The call at `+0x2AAB2` uses `r0` = 48 and length 27, so the destination is `0x16000030`. That writes a record into the modem. It does not read receive samples.

No `lrw` names `0x160004E0` or `0x160008DF`. Nothing copies the rest of that 1024-byte range. The other `0x1600` literals are single bytes or control words. `0x16000232` and `0x16000233` are one load each, inside `+0x3EEEC`; the only caller, `+0x3EFF2`, folds the word into an LCG and returns one byte. `0x160009C9` and the neighbouring codec bytes are single-byte control stores in the snapshot at `+0x3ECC0`. The copies at `+0x2A78` and `+0x2AB4` have no `bsr`.

The modem loads that were opened are single words. `0x11000390` is load-only, and the BER function returns its low 2 bits. `0x1100041C` contributes one bit at `+0x182EC`. `0x11000394` is split into two status bytes at `+0x27CFC`. `0x11000398` is two loads and was not followed past the load. `0x11000104` is one load and two stores of a control word. None of these is a drained sample FIFO.

## What reaches the UART

The score is the UART output of the 36-byte snapshot. `MessageDispatcher` registers command 63 and does not register command `0x21`. Chapter 01 routes on the command byte alone, so the score has no OEM handler.

`+0xBFE8` and `+0xC010` would copy 27 bytes into ping-pong slots at `0x38C10` and `0x388B4`. `+0xC040` would loop on `reply_build(14, 0, 0x388EB, 27)`. The factory image has no XIP pointer to any of the three, and the disassembly has no `bsr` to them. The dispatcher does not register command 14.

The replies this dispatcher already handles are the ones already named: `0x24` (163 bytes from `0x38E4C`), `0x25` (19 bytes from `0x38C70`), `0x2B` (the 9-byte caller record), `0x39` (169 bytes from `0x38AB0`), and `0x34` (the version string). `0x3F` selects the BER pattern. None of those bodies is the modem window.

## What this does not yet say

The CPU in this image has no discriminator-sample buffer and no host symbol FIFO. The multi-byte read that starts at `0x160004E0` is the BER scorer's 36-byte snapshot, and its UART output is a 6-byte score on command `0x21`. The 27-byte record stays unnamed in SRAM. A new SignalDeck sender was not added. An existing command does not return sliced M17 symbols. `0x3D` still waits. R-B was not started. T4 stays closed. §6 is not met.

## End state

The radio was not touched. End state remains the R4a restore: factory image, `0x34` `DMR003.UV4T.V022` at 03:00:58.517, VFO 467.625 / 467.625 FM at 03:00:59.876, low power, no `DMRDEBUG.bin`.

# T2 — `RF_MODE` and filter controls (2026-10-24)

No image was loaded. Nothing was keyed. The factory image was disassembled with no `-M`. The question was what `RF_MODE` bit 7 selects in this image, and whether an RRC roll-off or a filter bypass is stored anywhere.

## What this image stores

The only full-word immediate store of `RF_MODE` (`0x11000104`) is in the FM key-up `+0x3ECC0`. At `+0x3EDD6` the code does `movi r3, 135; lsli r3, 5` and at `+0x3EDDA` stores that word. `135 << 5` is `0x10E0`. The bits set in that word are 12, 7, 6, and 5. Bits 6:5 are 11, which is two-point mode. Bit 10 is clear, so the built-in 40 Hz square stays off. Bit 9 is clear, which Document 2 calls the 1.65 V ramp start. Bit 12 is set. Document 2 and the sibling notes do not name bit 12, and this reading does not name it either.

The same function saves the previous `RF_MODE` word to SRAM `0x32520` at `+0x3ECCC` and the restore at `+0x3EE74` writes that saved word back. In the same key-up, `+0x3EDE4` stores `WORK_MODE` (`0x11000100`) = `0x80`. Document 2 calls `WORK_MODE` bit 7 the modulator mode: 0 is DMR digital and 1 is FM analog. That is a different register from `RF_MODE` bit 7.

An earlier paragraph of this file reads bit 7 of this same `0x10E0` as clear. The store above sets it. That earlier paragraph is left as written.

Document 2 (Connect Systems HR-C7000, two-point modulation) maps the four symbol codes by `RF_MODE[7]`, which it names `rf_transiq_mode`:

| Bit 7 | +3 | +1 | −1 | −3 |
|---|---|---|---|---|
| 0 | +1944 Hz | +648 Hz | −648 Hz | −1944 Hz |
| 1 | −1944 Hz | −648 Hz | +648 Hz | +1944 Hz |

The two rows are the same magnitudes with the sign reversed. The guide lists the bit's reset as 1, and this store writes 1, so +3 maps to −1944 Hz. The guide's physical-layer TX example is `0x60` (bits 6 and 5 only). This image stores `0x10E0`, which is that example with bits 12 and 7 also set. It does not store `0x60`. M17's ±2400 Hz outer deviation is not a value on either row.

The `0x22` paths still write neither `RF_MODE` nor `FM_BANDWIDTH`, as the first T2 section says. Channel setup does not store `RF_MODE`. The measured narrow-band DMR outer of about ±3.3 kHz, with AT1846S `0x30` left at `0x4026`, is the earlier air result. It is not this `0x10E0`.

## Filter and RRC

No `lrw` in the factory disassembly names `FM_BANDWIDTH` (`0x11000500`) or `FM_DEV_COEF` (`0x11000504`). A walk that tracked `movi`, `movih`, `lsli`, `rotli`, `addi`, `bseti`, `bclri`, and `lrw` also never built either address. The same walk did build other `0x110005xx` addresses, including `0x11000560`, so the miss is not a skipped encoding of the `0x1100` base. Both registers therefore stay at reset. `FM_BANDWIDTH` reset `0x5F` leaves the FM band-pass (bit 6) and FM pre-emphasis (bit 4) on. `fm_dev_coef_t` stays `0x10`. Those bits are the FM audio chain. They are not an RRC roll-off.

UVm3 and UVm7 wrote both registers from the keyed-path stub, and UVm8 showed that the stub runs. The HackRF curve did not follow the writes. The pre-emphasis the air does follow is AT1846S `0x58` bit 7. No RRC coefficient register is stored in this image. The sibling notes name none. The α = 0.5 pattern that was on the air was the R4a host PCM fill, and that capture was inverted.

`0x11000560` is saved with `RF_MODE` at `+0x3ECEE` (SRAM `0x3252C`), stored as 1 at `+0x3EE00`, and restored at `+0x3EE9C`. That word is PTT. It is not a filter.

## What this does not yet say

The symbol map in this image is the inverted ±1944 / ±648 Hz table. There is no stored setting that selects ±2400 Hz, and there is no stored RRC coefficient. A host shaper on the TX-RAM path is still the way an α = 0.5 waveform has been put on the air. Whether the modem can take symbols from a RAM buffer of its own is the next reading. No image was built. R-B was not started. T4 stays closed. `0x3D` still waits. §6 is not met.

## End state

The radio was not touched. End state remains the R4a restore: factory image, `0x34` `DMR003.UV4T.V022` at 03:00:58.517, VFO 467.625 / 467.625 FM at 03:00:59.876, low power, no `DMRDEBUG.bin`.

# T2 — symbol buffer, read only (2026-10-24)

No image was loaded. Nothing was keyed. The factory image was disassembled with no `-M`. The question was whether the modem can hold PTT and take 4FSK symbols from a RAM buffer the host could fill.

## The copy

`+0x2A18` writes `r2` bytes from the caller's pointer (`r1`) into modem RAM at `r0 + 0x16000000`. The base is `movi r12, 176; lsli r12, 21`. A length of 0 returns. There are 23 direct calls. Every `r0` and every length is a `movi`. No call walks a window, and no call sits in a loop that repeats the copy.

| Calls | `r0` | Length | Destination | Source |
|---|---|---|---|---|
| `+0x8148` | 0 | 36 | `0x16000000` | stack, `r14+336`, on the arm where `(r5, 0x19)` is 4 |
| `+0x8152` | 36 | 36 | `0x16000024` | the same stack buffer |
| `+0x83E2`, `+0x85F4`, `+0x8774` | 0 | 36 | `0x16000000` | the same stack slot, filled with `0x5F` for 36 bytes first |
| `+0x83EC`, `+0x85FE`, `+0x877E` | 36 | 36 | `0x16000024` | that `0x5F` fill |
| `+0x2A64A`, `+0x2AEC4`, `+0x2B5FC` | 0 | 24 | `0x16000000` | the pointer at `(r8−4)`, plus 5 |
| `+0x2A7F4`, `+0x2A8AC`, `+0x2A9D0`, `+0x2A9FA` | 0 | 9 | `0x16000000` | `0x4D43E + slot*12` |
| `+0x2A83A` | 0 | 9 | `0x16000000` | `0x4D486 + slot*12` |
| `+0x2A9AE` | 0 | 9 | `0x16000000` | `0x4D435` |
| `+0x2AD0C`, `+0x2AD46` | 41 | 4 | `0x16000029` | `0x4D411` |
| `+0x2AD66` | 41 | 2 | `0x16000029` | two zero bytes on the stack |
| `+0x2AAB2`, `+0x2ABAE`, `+0x2ADB0` | 48 | 27 | `0x16000030` | `0x4D49E + n*27` |

The slot in the 9-byte rows is the byte at `(r8−36)`. The index `n` in the 27-byte rows is the byte at `0x4D404+0xA`, and the address math is that byte times 27. `+0x2AD0C` runs when byte `0x12` of `0x34808` is 1. `+0x2AD46` runs when that byte is 2 or 3. `+0x2AD66` runs otherwise and writes the two zeros. `+0x2ABAE` copies the 27-byte record on every path; the call of IRAM `0xFD014BEC` just above it runs only for byte `0x12` equal to 2 or 3, which R-A already read.

The longest copy is 36 bytes. A 256-sample PCM half is 512 bytes. None of these lengths is 256, 512, or 1024.

## What lands in the TX window

TX RAM is `0x16000030`–`0x1600042F`. The 27-byte copies are the only calls whose destination is that address. They write the unnamed record R-A already placed at `0x4D49E`, one record, then return. They do not stream symbols.

The 36-byte copy at offset 36 covers `0x16000024`–`0x16000047`, so its last 24 bytes sit in the TX window. Three of those copies are the byte `0x5F`. That is a fixed record, not a waveform. An earlier paragraph says this image has no store into that RAM. These copies do write its first 24 bytes, and the 27-byte record writes the next 27. The paragraph is left as written. The rest of the 1024-byte window has no store in this list.

No `lrw` names `0x16000030` or `FM_ADDR_SW` (`0x1100056C`). The only literal of PTT (`0x11000560`) is the FM key-up: saved at `+0x3ECEE`, stored as 1 at `+0x3EE00`, restored at `+0x3EE9C`. The word at `+0x3EE30` is the linear dump decoding a pool slot. Nothing branches back to the store of 1, and none of the 23 copies touches that register.

## What this does not yet say

The CPU writes short fixed records into the modem. It does not fill a symbol FIFO, and it does not hold PTT while a buffer drains. A host shaper on the TX-RAM path is still the transmit path that has put a waveform on the air. `0x3D` still waits on a SignalDeck sender. T4 stays closed. R-B was not started. §6 is not met.

## End state

The radio was not touched. End state remains the R4a restore: factory image, `0x34` `DMR003.UV4T.V022` at 03:00:58.517, VFO 467.625 / 467.625 FM at 03:00:59.876, low power, no `DMRDEBUG.bin`.

# R4b — one M17 link-setup frame in the TX-RAM loop, tag R4b0 (2026-10-24, 04:35–04:43)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Twenty-nine patch tests pass. The ES8311 debug node was not written.

The fill is 512 halfwords at file `+0x5C000`. One hundred eight symbols of the `0x77` preamble (`+3`, `-3`), the 192-symbol link-setup frame, and six zero symbols of filter tail occupy 510 samples. The last two samples are zero. Source and destination are the research modem's bench callsign. Samples are 16-bit, high byte at the low address. Each stored count is `-round(Hz / 0.54)`, the sign flip from the R4a air result, so a positive symbol aims at a positive deviation and a long run of `+3` aims at `+2400` Hz. The preamble overshoot sets the peak count at 6451. At 0.55 Hz per count the linear prediction is 3548 Hz. The stub bytes, the two key call sites, and the two unkey call sites are the R4a stub. `on_unkey` is still at `+0x5B080`. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear. The buffer loops every 64 ms, so the air carries one frame per loop.

`c7000-txram-m17-lsf`, tag `R4b0`, `DMR003.R4b0.V022.bin`, 378620 bytes. sha256 `a115ac083e138d48deb07c2b98b8767c5ed1c5ab1f5ead38723aaad2c183492d`. File and pushed MD5 `c5c6aaf369cbcaec83c175b5a8fa4645`.

## Boot

VFO 467.625 / 467.625 FM at 04:35:54.063, low power. HackRF probe 9600000 bytes at 04:35:53. Boot capture from 04:35:59, 240.0 s, floor power 6.78. YModem `onSuccess` at 04:38:08.861. Banner `开机初始化完成` at 04:38:20.762. `0x34` at 04:38:21.072 is `DMR003.R4b0.V022`, on the first poll. Hottest 100 ms bin +0.15 dB, at 174.2 s, clip 0, nothing at +6 dB. That bin is spread across ±24 kHz, so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 04:40:24.374. The key capture started at 04:40:29. `txwav` silence, 3000 ms, at 04:40:30.007. `0x36` body `03` at 04:40:30.017, `0x26` launch 2 at 04:40:33.419, `0x36` body `04` at 04:40:33.749. The carrier is up for 3.46 s. SNR 38.7 dB, clip 0, carrier offset +1026 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.158 s. RMS 1785 Hz. Steady p99 3148 Hz. The key-up click p99 is 23164 Hz and is outside that window. The stop stays clear. The 1 kHz line is 260 Hz and the 3 kHz line is 19 Hz.

Over 2.816 s of the same capture the aired deviation follows the aimed waveform at r² 0.807, polarity +1, gain 0.793. The same alignment against the stored counts is −0.43 Hz per count. The sign flip landed positive deviation on a positive symbol, and the level is about four fifths of the `+2400` Hz aim. The plain matched-filter decoder, the same one that checks the specification vectors, accepted the link-setup frame on 43 of 43 loops in that window. Best sync score 0.999. It reported no stream frame after the link setup. The loop period is 64 ms, and a stream frame wants the next sync 40 ms later, which this buffer does not hold.

## End state

Factory image restored. YModem `onSuccess` 04:42:51.014. Banner `开机初始化完成` at 04:43:02.951. `0x34` `DMR003.UV4T.V022` at 04:43:03.271. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 04:43:05.143, low power, `RX cmd=0x23 rw=0 sr=0`. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: one looping link-setup frame passed, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# FM refill interrupt — bit 15, no refill in this image (2026-10-24)

No image was loaded. Nothing was keyed. The factory objdump (no `-M`) and Document 2 were read. The radio was left as the R4b restore left it.

## The bit

Document 2 §4.6.5.9, `SYS_INTERP_LIST` at `0x11000398`. Bit 15 is `fm_tx_interp`, the analog transmit data interrupt. Bit 14 is `fm_rx_interp`. Bit 13 is `fm_sig_rx_interp`. `SYS_INTERP_MASK` at `0x1100039C` uses the same bit numbers. On each of those mask bits, 0 blocks the interrupt and 1 lets it through. The register default in the guide is 1.

This image does not leave bit 15 open. The store at `+0x179A2` writes `0x1187F` (bits 0–6, 11, 12, and 16). The normal-path store at `+0x17A8E` writes `0x1007F` (bits 0–6 and 16). Both leave bit 15 clear, so the interrupt is blocked. The path that runs when byte 1 of `0x34808` is nonzero stores `0x1E07F`, and that value does set bits 13, 14, and 15. The OEM FM key-up at `+0x3EDCE` then stores 0, which blocks every sub-interrupt, and the unkey at `+0x3EE9E` writes the saved mask back. The `0x26` stub used by R4a and R4b does not touch this register.

`FM_ADDR_SW` (`0x1100056C`, bits 1:0) is still absent as a literal. The guide says 1 means the CPU reads or writes the low half and 2 means the high half. That status is the ping-pong pointer. It is not the interrupt bit.

## The task that would have to refill

File `+0x1C92` passes `0x03032A70` as a task entry. That is file `+0x18A70`. The task pends semaphore `0x38848`. The post helper at `+0x3B670` accepts that object only when its first word is `0x414D4553`. Each wake ORs `SYS_INTERP_LIST` into a stack word, writes that word to `SYS_INTERP_CLEAR` (`0x110003A0`) until the list reads 0, and saves it at `0x4C7E0`.

The dispatcher at `+0x18B70` calls a handler for bits 0, 1, 2, 3, 4, 5, 6, 11, 12, and 16. Bit 15 is not in that list. Nothing in the dispatcher stores into `0x16000030`. The only use of bit 15 is the side path at `+0x18B28`: when byte 1 of `0x34808` is nonzero and the saved word has bit 13 or bit 15 (`0xA000`), it stores `WORK_MODE` `0x80`, ANDs the mask with `0xFFFEFF80` (bit 15 stays set if it was set), and stores 1 at byte 0 of `0x34808`. Byte 0 then sends later wakes to `+0x3D20`, which is `jmp r15`. A hook placed only on `+0x18B70` would run once and then miss the rest of the key.

The poster of `0x38848` is `+0x54BB0`. Its two neighbors, `+0x54B6C` and `+0x54B8C`, post the other two top-level lines and set a bit in `INTERP_CLEAR` (`0x110003B0`). No `bsr` and no 4-byte literal names `+0x54BB0`, so the PIC slot that enters it is not a stored pointer in this image.

## What a host-key stub can do

A refill does not need that PIC slot. The `0x26` key stub already runs only on a host launch. After the 512-sample fill and `PTT = 1`, it can poll `FM_ADDR_SW` and, each time the value changes, copy the next 256 samples into the half the register names. The OEM key-up already calls `+0x541F8` between its own waits (counts 10, 50, and 100). The same helper can space the polls, so the stub does not spin. If the register never changes, the two halves keep the first 512 samples and the air stays the R4b loop.

The file is zeros from `+0x5AEFC` through the end, 6144 bytes. The stub occupies the start of that run. The rest can hold a table longer than 512 samples. The count scale stays the R4b scale: peak stored count at or below 6451, which measured steady p99 3148 Hz. A longer table at that scale does not cross the ±5 kHz stop on the linear prediction that passed for R4b.

The service task is the wrong place for the first refill image. It runs on every wake, including ordinary DMR interrupts. A bad hook there would sit on the live path at boot. The poll stays inside the gated `0x26` stub and does nothing until a host launch.

No image was built. §6 is not met. `0x3D` still waits. The ES8311 debug node was not written.

## End state

The radio was not touched. End state remains the R4b restore: factory image, `0x34` `DMR003.UV4T.V022` at 04:43:03.271, VFO 467.625 / 467.625 FM at 04:43:05.143, low power, no `DMRDEBUG.bin`.

# R4c — the TX-RAM poll returns before the carrier, tag R4c0 (2026-10-24, 05:19–05:27)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty patch tests passed before the load. The ES8311 debug node was not written.

The stub is `c7000-txram-m17-stream` at file `+0x5B000` (348 bytes). `on_unkey` is at `+0x5B128`. The four `0x26` sites are the only calls. The stub copies the first 512 samples into both TX-RAM halves, sets the same FM words R4b sets, stores PTT = 1, then polls `FM_ADDR_SW` (`0x1100056C`). The first value of 1 or 2 is recorded and not written. Each later change copies 256 samples into the half the register names (1 = low, `0x16000030`; otherwise high, `0x16000230`). When the table runs out it writes two zero halves and returns. It does not store the interrupt mask, and it does not branch to `+0x18A70`. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

The table is file `+0x5B400` through the end of the image, 2430 samples, 1458 symbols. One hundred eight symbols of `+3`, `-3` preamble, one link-setup frame, six zero-payload stream frames (frame numbers 0, 1, 2, 3, 4, and `0x8005`), and six zero tail symbols. Source and destination are the research modem's bench callsign. Samples are 16-bit, high byte at the low address. Each stored count is `-round(Hz / 0.54)`, the same sign flip as R4b, so a positive symbol aims at a positive deviation. The peak count is 6451. The aimed peak is 3483.5 Hz. At 0.55 Hz per count the linear prediction is 3548.1 Hz. The host decoder accepts the link setup and those six frame numbers. The gap `+0x5B15C`–`+0x5B400` is still factory zeros and is not part of the patch.

`DMR003.R4c0.V022.bin`, 378620 bytes. sha256 `e36364b6ad57a37252a393ddfa120a8ca19e4d1ede1902888ac00860f57730f4`. File and pushed MD5 `5f3e5f1f11d585514d472f4bacd0f3ae`.

## Boot

VFO 467.625 / 467.625 FM at 05:19:48.178, low power. HackRF probe 9600000 bytes. Boot capture from 05:19:53, 240.0 s, floor power 6.81. YModem `onSuccess` at 05:22:02.240. Banner `开机初始化完成` at 05:22:14.407. `0x34` at 05:22:14.718 is `DMR003.R4c0.V022`. Hottest 100 ms bin +0.12 dB, at 20.7 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth, so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 05:24:17.557. The key capture started at 05:24:23. `txwav` silence, 3000 ms, at 05:24:23.124. `0x26` launch 1 at 05:24:23.199, ack at 05:24:23.557, `0x36` body `03` at 05:24:23.564. The ack was held 358 ms. `SEND_START` followed the ack by 7 ms. R4b's same launch acked in 5 ms (`04:40:30.006` to `04:40:30.011`) and `SEND_START` was 6 ms after that ack. Unkey launch 2 at 05:24:26.619, ack at 05:24:26.625 (6 ms), `0x36` body `04` at 05:24:26.952. The carrier is up for 3.11 s. SNR 38.7 dB, clip 0, carrier offset +1049 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 1.812 s. RMS 145 Hz. Steady p99 371 Hz. The 100 ms slice at key-up has p99 23084 Hz, and the slice at 3.0 s has p99 22210 Hz. Both are the key clicks and sit outside the steady window. The stop stays clear. The 1 kHz line is 0.4 Hz and the 3 kHz line is 2 Hz. Every 100 ms slice from 0.1 s through 2.9 s has p99 between 328 Hz and 444 Hz. The burst from 0.15 s to 0.70 s after key-up has p99 346 Hz.

The 64 ms autocorrelation of the keyed audio is 0.021, so the prefilled 512 samples are not looping. The aimed-waveform fit over the keyed span is r² 0.0, polarity +1, lag 99 samples, shape gain 0.05. The plain decoder reported frame number 44226 on the keyed span and 24181 after the click. Both link-setup CRCs are false, and neither callsign matches. Those hits are noise.

The 358 ms hold is about the length of the table (2430 samples is 304 ms) plus two zero halves (64 ms). The poll walked the table, wrote the zeros, and returned. The `0x26` handler emits `SEND_START` only after that return, so the modulator started on the zero tail. The carrier is shorter than R4b's 3.46 s, not longer by the hold, so the radio was not radiating while the poll ran. The first 512 samples never reached the air. The peak was not raised. Staying inside `on_key` until the table ends cannot overlap the carrier.

## End state

Factory image restored. YModem `onSuccess` 05:26:50.089. `0x34` `DMR003.UV4T.V022` at 05:27:02.250. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 05:27:04.069, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: the carrier was unmodulated, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# R4d — the wake refill plays one M17 stream, tag R4d0 (2026-10-24, 06:08–06:15)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-one patch tests passed before the load. The ES8311 debug node was not written.

The stub is `c7000-txram-m17-wake` at file `+0x5B000` (432 bytes). `on_key` is at `+0x5B0D0` and `on_unkey` is at `+0x5B168`. The four `0x26` sites are the only key-up calls. `on_key` copies the first 512 samples into both TX-RAM halves, sets the same FM words R4b sets, stores PTT = 1, writes the next-sample cursor at IRAM `0x4DAAC`, sets mask bit 15 of `0x1100039C`, and returns. The cursor is 0 at boot, so a wake copies nothing until that store. `on_unkey` clears the cursor and bit 15 before the factory unkey.

The image hooks the two per-wake calls. File `+0x18B5C` (factory `bsr +0x18B70`, taken when byte 0 of `0x34808` is 0) goes to `on_wake_disp`, which returns into the dispatcher at `0x03032B70`. File `+0x18B68` (factory `bsr +0x3D20`, and that target is `jmp r15`) goes to `on_wake_skip`, which returns to the caller. The task entry `+0x18A70` is unchanged, and so is the task-creation pool at `+0x1F30`. A wake copies 256 samples only when the cursor is set, bit 15 of the saved word at `0x4C7E0` is set, bit 0 of `0x11000080` is set, and `FM_ADDR_SW` (`0x1100056C`) is 1 or 2. Value 1 writes the low half (`0x16000030`). Value 2 writes the high half (`0x16000230`). When the cursor passes the table the stub writes two zero halves and stores 0. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

The table is the R4c table: file `+0x5B400` through the end of the image, 2430 samples, 1458 symbols, 303.75 ms. One hundred eight symbols of `+3`, `-3` preamble, one link-setup frame, six zero-payload stream frames (frame numbers 0, 1, 2, 3, 4, and `0x8005`), and six zero tail symbols. Source and destination are the research modem's bench callsign. Each stored count is `-round(Hz / 0.54)`. The peak count is 6451. The aimed peak is 3483.5 Hz. At 0.55 Hz per count the linear prediction is 3548.1 Hz. The gap `+0x5B1B0`–`+0x5B400` is still factory zeros and is not part of the patch.

`DMR003.R4d0.V022.bin`, 378620 bytes. sha256 `c1e2277077e876889756ea1165203275efc87bb8dcd1ba9771446a655f273571`. File and pushed MD5 `053b8ea8bd2c91dedb8f94e1270093b1`.

## Boot

VFO 467.625 / 467.625 FM at 06:08:06.382, low power. HackRF probe 9600000 bytes. Boot capture from 06:08:11, 240.0 s, floor power 6.81. YModem `onSuccess` at 06:10:20.395. Banner `开机初始化完成` at 06:10:32.702. `0x34` at 06:10:33.015 is `DMR003.R4d0.V022`. Hottest 100 ms bin +0.13 dB, at 53.8 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth, so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 06:12:35.649. `txwav` silence, 3000 ms, at 06:12:41.309. `0x26` launch 1 ack at 06:12:41.314, 5 ms after that log. `0x36` body `03` at 06:12:41.319, 5 ms after the ack. R4c held this same ack for 358 ms and `SEND_START` came after the poll returned. Here `on_key` returned at the R4b rate, and the carrier was up for the key. Unkey launch 2 at 06:12:44.731, ack at 06:12:44.736 (5 ms), `0x36` body `04` at 06:12:45.059. The carrier is up for 3.47 s. SNR 39.0 dB, clip 0, carrier offset +1049 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.167 s. RMS 158 Hz. Steady p99 408 Hz. That window starts after the 304 ms table, so it is the zero tail. The 100 ms slice at key-up has p99 22776 Hz. The 20 ms slices at 0.00 s and 0.02 s have p99 23640 Hz and 22616 Hz. Those are the key click and sit outside the steady window. The stop stays clear. In the steady window the 1 kHz line is 0.5 Hz and the 3 kHz line is 0.2 Hz, which is the unmodulated tail.

The table is on the air before that tail. The 20 ms slice at 0.04 s already has p99 3316 Hz and rms 1763 Hz. Slices stay in that range through 0.30 s (p99 3207 Hz, rms 1636 Hz). The slice at 0.32 s falls to p99 2624 Hz and rms 749 Hz, and from 0.34 s on every slice is the tail (p99 357–463 Hz). The highest 20 ms p99 inside the modulated run is 3321 Hz, at 0.26 s. The 100 ms slices agree: 0.1 s is p99 3132 Hz, 0.2 s is 2982 Hz, 0.3 s is 2653 Hz, and 0.4 s is 415 Hz. The run is about 300 ms, the length of the table. It is not time-compressed. The 64 ms autocorrelation of the keyed audio, measured from 0.15 s, is −0.023, so the first 512 samples are not looping.

The runner's decode of the whole carrier locked the click: one sync at score 0.946, 15 ms after key-up, link-setup CRC false, frame number 31643, Golay error 14. The fit it stored over the first 1.2 s includes that click: r² 0.13, polarity +1, lag 22.5 ms, gain 0.81. A search that starts at 40 ms does not see the click. On 0.04–0.40 s it finds seven syncs, the first at score 0.999 and the rest at 1.000. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. The six stream frames are 0, 1, 2, 3, 4, and `0x8005` (32773), each with Golay error 0. The link-setup sync is 45 ms after key-up, and the stream syncs follow every 40 ms through 0.285 s. The same six frames decode on 0.02–0.45 s. A window that starts at 0.05 s misses the link setup and still returns those six frames at Golay error 0. The window that starts at key-up is the false click sync.

The aimed waveform over 0.04–0.36 s, lag search ±30 ms, matches at r² 0.877, polarity +1, lag −17.5 ms, gain 0.825, on 13739 samples. That fit supports the decode. The peak was not raised. The file ends at `+0x5C6FC`, and the table already fills `+0x5B400` to that end, so a longer table does not fit. The two zero halves are why the carrier is unmodulated after 0.34 s. Wrapping the stream-frame cursor until unkey is the next image. It keeps this peak and these gates.

## End state

Factory image restored. YModem `onSuccess` 06:15:08.254. `0x34` `DMR003.UV4T.V022` at 06:15:20.787. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 06:15:22.616, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: one transmission produced one link-setup frame and six stream frames, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# R4e — the wake refill loops the M17 stream until unkey, tag R4e0 (2026-10-24, 06:36–06:44)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-two patch tests passed before the load. The ES8311 debug node was not written.

The stub is `c7000-txram-m17-loop` at file `+0x5B000` (368 bytes). `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The four `0x26` sites are the only key-up calls. `on_key` copies the first 512 samples into both TX-RAM halves, sets the same FM words R4b sets, stores PTT = 1, writes the next-sample cursor at IRAM `0x4DAAC`, sets mask bit 15 of `0x1100039C`, and returns. The cursor is 0 at boot, so a wake copies nothing until that store. `on_unkey` clears the cursor and bit 15 before the factory unkey.

The image hooks the same two per-wake calls as R4d. File `+0x18B5C` goes to `on_wake_disp`, which returns into the dispatcher at `0x03032B70`. File `+0x18B68` goes to `on_wake_skip`, which returns to the caller. The task entry `+0x18A70` is unchanged, and so is the task-creation pool at `+0x1F30`. A wake copies 256 samples only when the cursor is set, bit 15 of the saved word at `0x4C7E0` is set, bit 0 of `0x11000080` is set, and `FM_ADDR_SW` (`0x1100056C`) is 1 or 2. Value 1 writes the low half (`0x16000030`). Value 2 writes the high half (`0x16000230`). While that half is filling, a cursor at or past sample 2420 (`0x030766E8`, the six-symbol tail) is set back to sample 500 (`0x030757E8`, the first stream frame) and the same half continues. There is no zero half and no sentinel cursor. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

The table is the R4d table: file `+0x5B400` through the end of the image, 2430 samples, 1458 symbols, 303.75 ms. One hundred eight symbols of `+3`, `-3` preamble, one link-setup frame, six zero-payload stream frames (frame numbers 0, 1, 2, 3, 4, and `0x8005`), and six zero tail symbols. Source and destination are the research modem's bench callsign. Each stored count is `-round(Hz / 0.54)`. The peak count is 6451. The aimed peak is 3483.5 Hz. At 0.55 Hz per count the linear prediction is 3548.1 Hz. The gap `+0x5B170`–`+0x5B400` is still factory zeros and is not part of the patch. The prefill takes samples 0–511 and leaves the cursor at sample 512. Later loops replay samples 500–2419. Sample 2420 is never read.

`DMR003.R4e0.V022.bin`, 378620 bytes. sha256 `956f8d6d5a62845505a07f872c129327109f5f7860842095411db340f86926cd`. File and pushed MD5 `a842958f3b37594727d547c380222b51`.

## Boot

VFO 467.625 / 467.625 FM at 06:36:41.974, low power. HackRF probe 9600000 bytes. Boot capture from 06:36:47, 240.0 s, floor power 6.82. YModem `onSuccess` at 06:38:55.629. Banner `开机初始化完成` at 06:39:07.687. `0x34` at 06:39:08.007 is `DMR003.R4e0.V022`. Hottest 100 ms bin +0.11 dB, at 203.4 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth (peak −16828 Hz, occupied bandwidth −24000..23998 Hz), so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 06:41:11.171. `txwav` silence, 3000 ms, at 06:41:16.825. `0x26` launch 1 ack at 06:41:16.829, 4 ms after that log. `0x36` body `03` at 06:41:16.835, 6 ms after the ack. R4c held this same ack for 358 ms. Here `on_key` returned at the R4b and R4d rate, and the carrier was up for the key. Unkey launch 2 at 06:41:20.233, ack at 06:41:20.238 (5 ms), `0x36` body `04` at 06:41:20.566. The carrier is up for 3.45 s. SNR 39.3 dB, clip 0, carrier offset +1383 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.154 s. RMS 1614 Hz. Steady p99 3075 Hz. That window is the looped stream, not a zero tail. The 100 ms slice at key-up has p99 22987 Hz. That is the key click and sits outside the steady window. The stop stays clear. Every 100 ms slice from 0.1 s through 3.3 s stays modulated: p99 2959–3168 Hz, rms 1593–1635 Hz. The highest of those is 3168 Hz, at 2.5 s. The lowest is 2959 Hz, at 2.6 s. There is no drop to the R4d tail. In the steady window the 1 kHz line is 150 Hz and the 3 kHz line is 33 Hz. The 500 Hz line is 262 Hz and the 2 kHz line is 316 Hz. Those lines are the stream, not a sine.

The 240 ms autocorrelation of the keyed audio is 0.993, so the six stream frames are repeating. The burst from 0.15 s to 0.70 s after key-up has p99 3071 Hz. The aimed-waveform fit on 0.04–1.20 s, lag search ±30 ms, matches the looped table at r² 0.888, polarity +1, lag −17.4 ms, gain 0.83.

A decode of 0.04–1.20 s accepts the link setup (sync 0.989) and 27 stream frames. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. The 16-byte payloads are zeros. Golay error is 0 on every frame. The frame numbers are 0, 1, 2, 3, 4, and `0x8005` (32773), four times, then 0, 1, 2. A decode of the steady window, from 1.0 s, has no link setup in it, which is expected, and accepts 53 stream frames at Golay error 0, payloads zero, frame numbers only in that same set. The two windows overlap from 1.0 s to 1.20 s, so the counts are not added. Fifty-three frames in 2.15 s is the 40 ms spacing held for the whole key. The end-of-transmission frame repeats every loop. The decoder used here does not stop on that bit. A real receiver might. The peak was not raised. The next image loops frames 0–4 only, at this peak and these gates.

## End state

Factory image restored. YModem `onSuccess` 06:43:44.407. `0x34` `DMR003.UV4T.V022` at 06:43:56.776. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 06:43:58.625, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: one transmission produced the link setup and a loop of six frames, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# R4f — the wake refill loops frames 0-4 until unkey, tag R4f0 (2026-10-24, 06:56–07:04)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-three patch tests passed before the load. The ES8311 debug node was not written.

The stub is `c7000-txram-m17-loop5` at file `+0x5B000` (368 bytes). `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The four `0x26` sites are the only key-up calls. `on_key` copies the first 512 samples into both TX-RAM halves, sets the same FM words R4b sets, stores PTT = 1, writes the next-sample cursor at IRAM `0x4DAAC`, sets mask bit 15 of `0x1100039C`, and returns. The cursor is 0 at boot, so a wake copies nothing until that store. `on_unkey` clears the cursor and bit 15 before the factory unkey.

The image hooks the same two per-wake calls as R4e. File `+0x18B5C` goes to `on_wake_disp`, which returns into the dispatcher at `0x03032B70`. File `+0x18B68` goes to `on_wake_skip`, which returns to the caller. The task entry `+0x18A70` is unchanged, and so is the task-creation pool at `+0x1F30`. A wake copies 256 samples only when the cursor is set, bit 15 of the saved word at `0x4C7E0` is set, bit 0 of `0x11000080` is set, and `FM_ADDR_SW` (`0x1100056C`) is 1 or 2. Value 1 writes the low half (`0x16000030`). Value 2 writes the high half (`0x16000230`). While that half is filling, a cursor at or past sample 2100 (`0x03076468`, the six-symbol tail) is set back to sample 500 (`0x030757E8`, the first stream frame) and the same half continues. There is no zero half and no sentinel cursor. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

The table is file `+0x5B400`, 2110 samples, 1266 symbols, 263.75 ms. One hundred eight symbols of `+3`, `-3` preamble, one link-setup frame, five zero-payload stream frames (frame numbers 0, 1, 2, 3, and 4), and six zero tail symbols. There is no frame number `0x8005`. Source and destination are the research modem's bench callsign. Each stored count is `-round(Hz / 0.54)`. The peak count is 6451. The aimed peak is 3483.5 Hz. At 0.55 Hz per count the linear prediction is 3548.1 Hz. The gap `+0x5B170`–`+0x5B400` is still factory zeros and is not part of the patch. Bytes from `+0x5C47C` through the end of the file stay factory zeros and are not part of the patch. The prefill takes samples 0–511 and leaves the cursor at sample 512. Later loops replay samples 500–2099, which is 1600 samples, 200 ms, five frames. Samples 2100–2109 are never read. Frame 4 occupies samples 1780–2099 and is fully inside the played loop. The LICH counter is `i % 6`, so this five-frame loop sends LICH parts 0–4 and never sends part 5.

`DMR003.R4f0.V022.bin`, 378620 bytes. sha256 `4d187ca310940caca55b735f446504a637ff96b8fc98886dbdf848dd4b37d33d`. File and pushed MD5 `74caa04a7d573bbf91a9282a3720b7d6`.

## Boot

VFO 467.625 / 467.625 FM at 06:56:49.045, low power. HackRF probe 9600000 bytes. Boot capture from 06:56:54, 240.0 s, floor power 6.78. YModem `onSuccess` at 06:59:03.176. Banner `开机初始化完成` at 06:59:17.304. `0x34` at 06:59:17.624 is `DMR003.R4f0.V022`. Hottest 100 ms bin +0.15 dB, at 87.2 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth (peak −17006 Hz, occupied bandwidth −24000..23998 Hz), so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 07:01:18.623. `txwav` silence, 3000 ms, at 07:01:24.230. `0x26` launch 1 ack at 07:01:24.234, 4 ms after that log. `0x36` body `03` at 07:01:24.240, 6 ms after the ack. R4c held this same ack for 358 ms. Here `on_key` returned at the R4b, R4d, and R4e rate, and the carrier was up for the key. Unkey launch 2 at 07:01:27.636, ack at 07:01:27.642 (6 ms), `0x36` body `04` at 07:01:27.968. The carrier is up for 3.45 s. SNR 39.3 dB, clip 0, carrier offset +1393 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.152 s. RMS 1615 Hz. Steady p99 3095 Hz. That window is the looped five-frame stream, not a zero tail. The 100 ms slice at key-up has p99 22918 Hz. That is the key click and sits outside the steady window. The stop stays clear. Every 100 ms slice from 0.1 s through 3.3 s stays modulated: p99 2974–3210 Hz, rms 1601–1628 Hz. The highest of those is 3210 Hz, at 2.3 s. The lowest is 2974 Hz, at 1.4 s. There is no drop to the R4d tail. In the steady window the 1 kHz line is 142 Hz and the 3 kHz line is 44 Hz. The 500 Hz line is 260 Hz and the 2 kHz line is 322 Hz. The 250 Hz line is 94 Hz. The 15.625 Hz line is 4 Hz. Those lines are the stream, not a sine.

The 200 ms autocorrelation of the keyed audio is 0.991, so the five stream frames are repeating. The burst from 0.15 s to 0.70 s after key-up has p99 3089 Hz. The aimed-waveform fit on 0.04–1.20 s, lag search ±30 ms, matches the looped table at r² 0.886, polarity +1, lag −17.2 ms, gain 0.83.

A decode of 0.04–1.20 s accepts the link setup (sync 0.987) and 27 stream frames. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. The 16-byte payloads are zeros. Golay error is 0 on every frame. The frame numbers are 0, 1, 2, 3, and 4, five times, then 0 and 1. There is no `0x8005`. The stream syncs that follow the link setup score 0.991–0.992. A decode of the steady window, from 1.0 s, has no link setup in it, which is expected, and accepts 53 stream frames at Golay error 0, payloads zero, frame numbers only in that same set. The window starts at frame 3 and ends at frame 0. The two windows overlap from 1.0 s to 1.20 s, so the counts are not added. Fifty-three frames in 2.15 s is the 40 ms spacing held for the whole key. The decoder used here does not drop the link when LICH part 5 is absent. The peak was not raised. The next image keeps this loop and sets the 16 payload bytes to 0 through 15.

## End state

Factory image restored. YModem `onSuccess` 07:03:51.874. `0x34` `DMR003.UV4T.V022` at 07:04:04.105. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 07:04:05.920, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: one transmission produced the link setup and a loop of five frames, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# R4g — the wake refill loops frames 0-4 with payload bytes 0 through 15, tag R4g0 (2026-10-24, 07:14–07:22)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-four patch tests passed before the load. The ES8311 debug node was not written.

The stub is `c7000-txram-m17-pay16` at file `+0x5B000` (368 bytes). Its instructions match R4f. `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The four `0x26` sites are the only key-up calls. `on_key` copies the first 512 samples into both TX-RAM halves, sets the same FM words R4b sets, stores PTT = 1, writes the next-sample cursor at IRAM `0x4DAAC`, sets mask bit 15 of `0x1100039C`, and returns. The cursor is 0 at boot, so a wake copies nothing until that store. `on_unkey` clears the cursor and bit 15 before the factory unkey.

The image hooks the same two per-wake calls as R4f. File `+0x18B5C` goes to `on_wake_disp`, which returns into the dispatcher at `0x03032B70`. File `+0x18B68` goes to `on_wake_skip`, which returns to the caller. The task entry `+0x18A70` is unchanged, and so is the task-creation pool at `+0x1F30`. A wake copies 256 samples only when the cursor is set, bit 15 of the saved word at `0x4C7E0` is set, bit 0 of `0x11000080` is set, and `FM_ADDR_SW` (`0x1100056C`) is 1 or 2. Value 1 writes the low half (`0x16000030`). Value 2 writes the high half (`0x16000230`). While that half is filling, a cursor at or past sample 2100 (`0x03076468`, the six-symbol tail) is set back to sample 500 (`0x030757E8`, the first stream frame) and the same half continues. There is no zero half and no sentinel cursor. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

The table is file `+0x5B400`, 2110 samples, 1266 symbols, 263.75 ms. One hundred eight symbols of `+3`, `-3` preamble, one link-setup frame, five stream frames (frame numbers 0, 1, 2, 3, and 4), and six zero tail symbols. Each frame's 16 payload bytes are 0 through 15. There is no frame number `0x8005`. Source and destination are the research modem's bench callsign. Each stored count is `-round(Hz / 0.54)`. The peak count is 6451, the same cap as R4f, and this table was not scaled. The aimed peak is 3483.5 Hz. At 0.55 Hz per count the linear prediction is 3548.1 Hz. Samples 0–509 match the R4f table. Sample 510 is the first difference, the root-raised-cosine smear of the new payload. The gap `+0x5B170`–`+0x5B400` is still factory zeros and is not part of the patch. Bytes from `+0x5C47C` through the end of the file stay factory zeros and are not part of the patch. The prefill takes samples 0–511 and leaves the cursor at sample 512. Later loops replay samples 500–2099, which is 1600 samples, 200 ms, five frames. Samples 2100–2109 are never read. Frame 4 occupies samples 1780–2099 and is fully inside the played loop. The LICH counter is `i % 6`, so this five-frame loop sends LICH parts 0–4 and never sends part 5.

`DMR003.R4g0.V022.bin`, 378620 bytes. sha256 `763ca1733a10e0c0af388cc58b6764f602c507dc646d027f92966d3735936483`. File and pushed MD5 `ceb1c0a8277c9e7afd46a6673b9104a9`.

## Boot

VFO 467.625 / 467.625 FM at 07:14:52.961, low power. HackRF probe 9600000 bytes. Boot capture from 07:14:58, 240.0 s, floor power 6.84. YModem `onSuccess` at 07:17:06.777. Banner `开机初始化完成` at 07:17:19.944. `0x34` at 07:17:20.255 is `DMR003.R4g0.V022`. Hottest 100 ms bin +0.11 dB, at 194.6 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth (peak +2124 Hz, occupied bandwidth −24000..23998 Hz), so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 07:19:23.854. `txwav` silence, 3000 ms, at 07:19:29.450. `0x26` launch 1 ack at 07:19:29.457, 7 ms after that log. `0x36` body `03` at 07:19:29.463, 6 ms after the ack. R4c held this same ack for 358 ms. Here `on_key` returned at the R4b, R4d, R4e, and R4f rate, and the carrier was up for the key. Unkey launch 2 at 07:19:32.855, ack at 07:19:32.860 (5 ms), `0x36` body `04` at 07:19:33.181. The carrier is up for 3.45 s. SNR 47.4 dB, clip 0, carrier offset +1124 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.149 s. RMS 1681 Hz. Steady p99 2886 Hz. That window is the looped five-frame stream, not a zero tail. The 100 ms slice at key-up has p99 22905 Hz. That is the key click and sits outside the steady window. The stop stays clear. Every 100 ms slice from 0.1 s through 3.3 s stays modulated: p99 2880–2957 Hz, rms 1671–1695 Hz. The highest of those is 2957 Hz, at 2.1 s. The lowest is 2880 Hz, at 1.6 s. There is no drop to the R4d tail. In the steady window the 1 kHz line is 230 Hz and the 3 kHz line is 59 Hz. The 500 Hz line is 406 Hz and the 2 kHz line is 163 Hz. The 250 Hz line is 206 Hz. The 15.625 Hz line is 4 Hz. Those lines are the stream, not a sine.

The 200 ms autocorrelation of the keyed audio is 0.997, so the five stream frames are repeating. The burst from 0.15 s to 0.70 s after key-up has p99 2884 Hz. The aimed-waveform fit on 0.04–1.20 s, lag search ±30 ms, matches the looped table at r² 0.886, polarity +1, lag −17.4 ms, gain 0.83.

A decode of 0.04–1.20 s accepts the link setup (sync 0.999) and 27 stream frames. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. Every 16-byte payload is the bytes 0 through 15. Golay error is 0 on every frame. The frame numbers are 0, 1, 2, 3, and 4, five times, then 0 and 1. There is no `0x8005`. The stream syncs that follow the link setup score 0.996–1.0. A decode of the steady window, from 1.0 s, has no link setup in it, which is expected, and accepts 53 stream frames at Golay error 0, the same payload bytes, frame numbers only in that same set. The window starts at frame 3 and ends at frame 0. The two windows overlap from 1.0 s to 1.20 s, so the counts are not added. Fifty-three frames in 2.15 s is the 40 ms spacing held for the whole key. The decoder used here does not drop the link when LICH part 5 is absent. The peak was not raised. The next image adds frame 5 with the end bit clear, so the loop sends LICH parts 0–5.

## End state

Factory image restored. YModem `onSuccess` 07:21:59.878. `0x34` `DMR003.UV4T.V022` at 07:22:13.197. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 07:22:14.810, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: one transmission produced the link setup and a loop of five frames whose payloads are the bytes 0 through 15, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# R4h — the wake refill loops frames 0-5 with the end bit clear, tag R4h0 (2026-10-24, 07:34–07:42)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-five patch tests passed before the load. The ES8311 debug node was not written.

The stub is `c7000-txram-m17-lich5` at file `+0x5B000` (368 bytes). Its instructions match R4g except the wrap address. `on_key` is at `+0x5B090` and `on_unkey` is at `+0x5B128`. The four `0x26` sites are the only key-up calls. `on_key` copies the first 512 samples into both TX-RAM halves, sets the same FM words R4b sets, stores PTT = 1, writes the next-sample cursor at IRAM `0x4DAAC`, sets mask bit 15 of `0x1100039C`, and returns. The cursor is 0 at boot, so a wake copies nothing until that store. `on_unkey` clears the cursor and bit 15 before the factory unkey.

The image hooks the same two per-wake calls as R4g. File `+0x18B5C` goes to `on_wake_disp`, which returns into the dispatcher at `0x03032B70`. File `+0x18B68` goes to `on_wake_skip`, which returns to the caller. The task entry `+0x18A70` is unchanged, and so is the task-creation pool at `+0x1F30`. A wake copies 256 samples only when the cursor is set, bit 15 of the saved word at `0x4C7E0` is set, bit 0 of `0x11000080` is set, and `FM_ADDR_SW` (`0x1100056C`) is 1 or 2. Value 1 writes the low half (`0x16000030`). Value 2 writes the high half (`0x16000230`). While that half is filling, a cursor at or past sample 2420 (`0x030766E8`, the six-symbol tail) is set back to sample 500 (`0x030757E8`, the first stream frame) and the same half continues. There is no zero half and no sentinel cursor. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

The table is file `+0x5B400`, 2430 samples, 1458 symbols, 303.75 ms. One hundred eight symbols of `+3`, `-3` preamble, one link-setup frame, six stream frames (frame numbers 0, 1, 2, 3, 4, and 5), and six zero tail symbols. Frame 5 carries LICH part 5, and its end bit is clear. Each frame's 16 payload bytes are 0 through 15. There is no frame number `0x8005`. Source and destination are the research modem's bench callsign. Each stored count is `-round(Hz / 0.54)`. The peak count is 6451, the same cap as R4g, and this table was not scaled. The aimed peak is 3483.5 Hz. At 0.55 Hz per count the linear prediction is 3548.1 Hz. Samples 0–2093 match the R4g table. Sample 2094 is the first difference, the root-raised-cosine smear of frame 5 into the end of frame 4. The gap `+0x5B170`–`+0x5B400` is still factory zeros and is not part of the patch. The table runs through the end of the file. The prefill takes samples 0–511 and leaves the cursor at sample 512. Later loops replay samples 500–2419, which is 1920 samples, 240 ms, six frames. Samples 2420–2429 are never read. Frame 5 occupies samples 2100–2419 and is fully inside the played loop.

`DMR003.R4h0.V022.bin`, 378620 bytes. sha256 `df8ff37d7dde9f60abbb9251d866acf3a09b45125c3b876d0b5c74b4efb9af42`. File and pushed MD5 `2dcc96e7776afb93b11df010a42bc0d9`.

## Boot

VFO 467.625 / 467.625 FM at 07:34:51.213, low power. HackRF probe 9600000 bytes. Boot capture from 07:34:56, 240.0 s, floor power 6.77. YModem `onSuccess` at 07:37:04.941. Banner `开机初始化完成` at 07:37:17.653. `0x34` at 07:37:17.968 is `DMR003.R4h0.V022`. Hottest 100 ms bin +0.15 dB, at 178.5 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth (peak +20826 Hz, occupied bandwidth −23998..23998 Hz), so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 07:39:22.726. `txwav` silence, 3000 ms, at 07:39:28.322. `0x26` launch 1 ack at 07:39:28.328, 6 ms after that log. `0x36` body `03` at 07:39:28.334, 6 ms after the ack. R4c held this same ack for 358 ms. Here `on_key` returned at the R4b, R4d, R4e, R4f, and R4g rate, and the carrier was up for the key. Unkey launch 2 at 07:39:31.744, ack at 07:39:31.749 (5 ms), `0x36` body `04` at 07:39:32.070. The carrier is up for 3.47 s. SNR 49.4 dB, clip 0, carrier offset +1096 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.165 s. RMS 1686 Hz. Steady p99 2909 Hz. That window is the looped six-frame stream, not a zero tail. The 100 ms slice at key-up has p99 22976 Hz. That is the key click and sits outside the steady window. The stop stays clear. Every 100 ms slice from 0.1 s through 3.3 s stays modulated: p99 2896–3014 Hz, rms 1666–1707 Hz. The highest of those is 3014 Hz, at 0.8 s. The lowest is 2896 Hz, at 1.0 s. There is no drop to the R4d tail. In the steady window the 1 kHz line is 224 Hz and the 3 kHz line is 64 Hz. The 500 Hz line is 434 Hz and the 2 kHz line is 151 Hz. The 250 Hz line is 194 Hz. The 15.625 Hz line is 3 Hz. Those lines are the stream, not a sine.

The 240 ms autocorrelation of the keyed audio is 0.995, so the six stream frames are repeating. The burst from 0.15 s to 0.70 s after key-up has p99 2910 Hz. The aimed-waveform fit on 0.04–1.20 s, lag search ±30 ms, matches the looped table at r² 0.889, polarity +1, lag −17.3 ms, gain 0.83.

A decode of 0.04–1.20 s accepts the link setup (sync 0.999) and 27 stream frames. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. Every 16-byte payload is the bytes 0 through 15. Golay error is 0 on every frame. The frame numbers are 0, 1, 2, 3, 4, and 5, four times, then 0, 1, and 2. There is no `0x8005`. The stream syncs that follow the link setup score 0.995–1.0. A decode of the steady window, from 1.0 s, has no link setup in it, which is expected, and accepts 54 stream frames at Golay error 0, the same payload bytes, frame numbers only in that same set. The window starts at frame 5 and ends at frame 4. The two windows overlap from 1.0 s to 1.20 s, so the counts are not added. Fifty-four frames in 2.165 s is the 40 ms spacing held for the whole key. The peak was not raised. The loop never sets the end bit, so the next image sends one frame with the end bit set when the key ends, and that frame is not in the loop.

## End state

Factory image restored. YModem `onSuccess` 07:41:59.048. `0x34` `DMR003.UV4T.V022` at 07:42:11.962. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 07:42:13.659, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met: one transmission produced the link setup and a loop of six frames whose payloads are the bytes 0 through 15, and the acceptance is 85 of 90 frames across three transmissions. `0x3D` still waits. The ES8311 debug node was not written.

# R4i — one end frame after the loop, tag R4i0 (2026-10-24, 08:46–08:54)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-six patch tests passed before the load. The ES8311 debug node was not written.

The image keeps the R4h loop and adds one end frame. The loop table is still file `+0x5B400`, 2430 samples, frames 0–5, peak count 6451. The end frame is the 320-sample continuation of that waveform, file `+0x5B170`, 640 bytes, peak count 6337. It is not in the loop. `on_key` is unchanged. `on_unkey` leaves the cursor and mask bit 15 alone, sets bit 31 of the cursor, and waits in `play_eot` at file `+0x5AF78` until the cursor is 0 or 1200 ticks pass. The wake's copy entry branches to `wake_half` at file `+0x5AEFC`. While bit 31 is clear the half is the R4h loop. While it is set, sample 2420 switches to the end frame. The stub stays 368 bytes. The task entry `+0x18A70` is unchanged. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

`DMR003.R4i0.V022.bin`, 378620 bytes. sha256 `0680c84e5b3f52883e2899b07deb7897370293bbeae64a809f4bfec22ba73fa2`. File and pushed MD5 `3c43a3422b0f36795240f5579d84fb68`.

## Boot

VFO 467.625 / 467.625 FM at 08:46:50.073, low power. HackRF probe 9600000 bytes. Boot capture from 08:46:55, 240.0 s, floor power 6.80. YModem `onSuccess` at 08:49:04.009. Banner `开机初始化完成` at 08:49:17.067. `0x34` at 08:49:17.378 is `DMR003.R4i0.V022`. Hottest 100 ms bin +0.13 dB, at 209.9 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth (peak +20574 Hz, occupied bandwidth −24000..23998 Hz), so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 08:51:22.335. `txwav` silence, 3000 ms, at 08:51:27.957. `0x26` launch 1 ack at 08:51:27.962, 5 ms after that log. `0x36` body `03` at 08:51:27.968, 6 ms after the ack. Unkey launch 2 at 08:51:31.361. Its ack is at 08:51:32.228, 867 ms later, which is the full 1200-tick wait in `play_eot`. `0x36` body `04` at 08:51:32.239, 11 ms after that ack. The carrier is up for 4.30 s. SNR 30.3 dB, clip 0, carrier offset +1129 Hz.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 3.004 s. RMS 1725 Hz. Steady p99 3257 Hz. The 100 ms slice at key-up has p99 23024 Hz. That is the key click and sits outside the steady window. The stop stays clear. Every 100 ms slice from 0.1 s through 4.1 s stays at the stream deviation: p99 2898–3635 Hz, and the slice at 4.2 s is the unkey click, p99 22803 Hz. The highest stream slice is 3635 Hz, at 2.5 s. The lowest is 2898 Hz, at 3.8 s. In the steady window the 1 kHz line is 228 Hz and the 3 kHz line is 57 Hz. The 500 Hz line is 464 Hz and the 2 kHz line is 158 Hz. The 250 Hz line is 208 Hz. The 15.625 Hz line is 4 Hz.

The 240 ms autocorrelation of the audio from 1.0 s is 0.940. The burst from 0.15 s to 0.70 s after key-up has p99 3107 Hz. The aimed-waveform fit on 0.04–1.20 s, lag search ±30 ms, matches the looped table at r² 0.864, polarity +1, lag −17.6 ms, gain 0.83.

A decode of 0.04–1.20 s accepts the link setup (sync 0.999) and 27 stream frames. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. Every 16-byte payload is the bytes 0 through 15. Golay error is 0 on every frame. The frame numbers are 0, 1, 2, 3, 4, and 5, four times, then 0, 1, and 2. There is no `0x8005`. The stream syncs that follow the link setup score 0.994–1.0. A decode of the steady window accepts 61 stream frames at Golay error 0, the same payload bytes, frame numbers only in that same set, and then one more frame, number 0, with Golay error 7. The two windows overlap from 1.0 s to 1.20 s, so the counts are not added. Half-second windows stepped across the key find the same loop through 3.29 s and no frame `0x8005` anywhere. From 3.54 s onward those windows accept nothing, while the carrier through 4.1 s is still at the stream deviation. The handler had not returned, so the wake could not keep filling: the halves already queued played out, and the last half kept the deviation up until the timeout dropped PTT. The peak was not raised. The end frame was stored and was not on the air as a decoded frame.

## End state

Factory image restored by this runner, which was already in flight when the owner said a test image may stay loaded. YModem `onSuccess` 08:53:58.933. `0x34` `DMR003.UV4T.V022` at 08:54:12.828. Pushed factory MD5 `4426035392262ca54583c230c9e268e0`. The loader's channel write was followed by the VFO tune: 467.625 / 467.625 FM at 08:54:14.595, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. `0x3D` still waits. The ES8311 debug node was not written. The next image sets the end bit and returns from `on_unkey`, so the reply at file `+0x9294` goes out and the wake keeps running. The wake drops PTT when the cursor reaches 0.

# R4j — the end frame plays after on_unkey returns, tag R4j0 (2026-10-24, 09:20–09:26)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-seven patch tests passed before the load. The ES8311 debug node was not written. The factory image was not reloaded after the key.

The image keeps the R4h loop and the R4i end frame. The loop table is still file `+0x5B400`, 2430 samples, frames 0–5, peak count 6451. The end frame is the 320-sample continuation, file `+0x5B170`, 640 bytes, peak count 6337. It is not in the loop. `on_key` is unchanged. `on_unkey` sets bit 31 of the cursor and returns. It does not wait and it does not call `0xE9C`. The wake keeps filling. When the cursor reaches 0, after the end frame and the zero halves, `drop_ptt` at file `+0x5AF9A` clears PTT, the voice bit, and mask bit 15, and restores the two AT1846S words. The stub stays 368 bytes. The task entry `+0x18A70` is unchanged. No `+0x3074`, no `+0x3EDFC`, bit 4 stays clear.

`DMR003.R4j0.V022.bin`, 378620 bytes. sha256 `c495f625fd62097461deea65c8882e95c83914ed706460a1dd7a7f575b462ae3`. MD5 `667b6b027eb5fa419e4d0fd1c027ce69`.

## Boot

VFO 467.625 / 467.625 FM at 09:20:50.027, low power. HackRF probe 9600000 bytes. Boot capture from 09:20:55, 240.0 s, floor power 6.79. YModem `onSuccess` at 09:23:04.176. Banner `开机初始化完成` at 09:23:17.688. `0x34` at 09:23:17.998 is `DMR003.R4j0.V022`. Hottest 100 ms bin +0.13 dB, at 61.5 s, clip 0, nothing at +6 dB. That bin is spread across the capture bandwidth (peak −16766 Hz, occupied bandwidth −23998..23998 Hz), so it is the noise floor. The stub does not run at boot.

## Silence key

VFO confirmed again at 09:25:20.522. `txwav` silence, 3000 ms, at 09:25:26.142. `0x26` launch 1 ack at 09:25:26.147, 5 ms after that log. `0x36` body `03` at 09:25:26.153, 6 ms after the ack. Unkey launch 2 at 09:25:29.534. Its ack is at 09:25:29.539, 5 ms later. The log has no `0x36` body `04` through 09:25:36. The carrier is up for 3.76 s and falls 0.39 s after the unkey command. SNR 43.1 dB, clip 0, carrier offset +1096 Hz. RSSI reads after 09:25:30 are raw 4–6.

The steady window, from 1.0 s after key-up to 0.3 s before release, is 2.457 s. RMS 1688 Hz. Steady p99 2914 Hz. The 100 ms slice at key-up has p99 22781 Hz. That is the key click and sits outside the steady window. The stop stays clear. Every 100 ms slice from 0.1 s through 3.3 s stays at the stream deviation: p99 2886–2996 Hz. The helper's slice loop stops at 3.4 s, so the last half-second was measured in 50 ms slices: from 2.80 s through 3.65 s the p99 is 2910–3066 Hz. The slice at 3.70 s is the carrier-drop click, p99 23392 Hz, and it is not a stop. The highest stream slice in the 100 ms set is 2996 Hz, at 2.5 s. The lowest is 2886 Hz, at 2.2 s. In the steady window the 1 kHz line is 238 Hz and the 3 kHz line is 64 Hz. The 500 Hz line is 402 Hz and the 2 kHz line is 167 Hz. The 250 Hz line is 199 Hz. The 15.625 Hz line is 2 Hz.

The 240 ms autocorrelation of the audio from 1.0 s is 0.996. The burst from 0.15 s to 0.70 s after key-up has p99 2914 Hz. The aimed-waveform fit on 0.04–1.20 s, lag search ±30 ms, matches the looped table at r² 0.889, polarity +1, lag −17.2 ms, gain 0.83.

A decode of 0.04–1.20 s accepts the link setup (sync 0.999) and 27 stream frames. The link-setup CRC is true. Both callsigns match the research modem's bench callsign. Every 16-byte payload is the bytes 0 through 15. Golay error is 0 on every frame. The frame numbers are 0, 1, 2, 3, 4, and 5, four times, then 0, 1, and 2. There is no `0x8005` in that window. A decode of the steady window accepts 61 stream frames at Golay error 0, the same payload bytes, frame numbers only 0 through 5, last frame 5. The steady window ends 0.3 s before the carrier ends, and the end frame is later than that. The two windows overlap from 1.0 s to 1.20 s, so the counts are not added. The runner's last-0.8 s window locked a stream sync at score 0.911 and then three frames, numbers 59690, 26279, and 26279, Golay error 12, 13, and 13. That window is why the runner's flag is false.

A sync search of the whole carrier, keeping local peaks above 0.95, finds one frame `0x8005` at 3.685 s. Its score is 0.997, Golay error is 0, and the 16 payload bytes are 0 through 15. The frame before it, at 3.645 s, is frame 5, score 0.999, Golay error 0. The frame 5 at 3.405 s is followed by frame 0, so the end frame is not in the loop. The unkey command falls at 3.36 s, during frame 4, and the loop runs one more 0–5 cycle before the end frame. The carrier falls 72 ms after that sync. The peak was not raised.

## End state

R4j0 stays loaded. The factory image was not written. VFO 467.625 / 467.625 FM at 09:25:49.264, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. `0x3D` still waits. The ES8311 debug node was not written. The module cleared the carrier without sending `SEND_STOP`. The next step is to read where `0x36` body `04` is produced, and to build an image only if that status is a call the wake can make after `drop_ptt` without holding the `0x26` handler.

The owner asked for the factory image after this report. It was loaded over R4j0. Banner `开机初始化完成` at 09:45:33.282. `0x34` `DMR003.UV4T.V022` at 09:45:33.593. VFO 467.625 / 467.625 FM at 09:45:35.253, low power. No `DMRDEBUG.bin`. Nothing was keyed.

# R4k — the wake posts the transmit-stop status, tag R4k0 (2026-10-24, 10:44–10:50)

HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38. One boot and one 3 s silence key, both at 467.625 MHz, low power. Thirty-eight patch tests passed before the load. The ES8311 debug node was not written. The factory image was not reloaded after the key.

The image is R4j plus one call. `drop_ptt` still clears PTT, the voice bit, and mask bit 15, and restores the two AT1846S words. It then posts status byte 4 through file `+0x7E08`. That function stores the byte at RAM `0x38EF2`, sets bit 0 of `0x38EF0`, and wakes the sender at file `+0x7BC0`. The sender emits command `0x36` with that one body byte. The call does not enter `0xE9C` and it does not key the radio. The loop, the end frame, and the peak counts are unchanged. The stub stays 368 bytes.

`DMR003.R4k0.V022.bin`, 378620 bytes. sha256 `c71ee7d89973048408e58112b1abe72d89ec18b0b0f86ec72356b6b445c02745`. MD5 `c1dbd0e7dba8954d4b91e3251ab0bf9e`.

## Boot

VFO 467.625 / 467.625 FM at 10:44:58.494, low power. YModem `onSuccess` at 10:47:12.569. Banner `开机初始化完成` at 10:47:25.489. `0x34` at 10:47:25.800 is `DMR003.R4k0.V022`. Hottest 100 ms bin +0.16 dB, clip 0, nothing at +6 dB. The stub does not run at boot.

## Silence key

VFO confirmed again at 10:49:28.998. `txwav` silence, 3000 ms, at 10:49:34.625. `0x26` launch 1 ack at 10:49:34.630, 5 ms later. `0x36` body `03` at 10:49:34.636, 6 ms after the ack. Unkey launch 2 at 10:49:38.027. Its ack is at 10:49:38.032, 5 ms later. `0x36` body `04` is at 10:49:38.344, 312 ms after that ack. The carrier is up for 3.76 s. SNR 56.9 dB. The IQ clip fraction is 0.31. Carrier offset +1011 Hz. Steady p99 2922 Hz. The key-up click p99 is 23040 Hz and the drop click at 3.70 s is 23160 Hz. Neither is a stop. The 100 ms slices of the stream stay at that deviation, and the 50 ms slices from 2.80 s through 3.65 s are 2913–3088 Hz.

The 240 ms autocorrelation from 1.0 s is 0.995. The aimed-waveform fit on 0.04–1.20 s is r² 0.891, polarity +1, lag −17.0 ms, gain 0.83. A decode of 0.04–1.20 s accepts the link setup and 27 stream frames, Golay error 0, payload bytes 0 through 15, frame numbers 0 through 5. A decode from 1.0 s accepts 61 such frames, Golay error 0. The two windows overlap, so the counts are not added. The runner's last-0.8 s window locked a sync at score 0.955-class false hit and reported frames 59690 and 26279. A sync search of the whole carrier finds one frame `0x8005` at 3.686 s, score 0.999, Golay error 0, the same payload bytes, after frame 5 at 3.646 s. The end frame is not in the loop. The peak was not raised.

## End state

R4k0 stays loaded. VFO 467.625 / 467.625 FM at 10:49:54.172, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. `0x3D` still waits. The ES8311 debug node was not written. The transmit-stop status now follows the end frame.

# R4l — command 0x40 in a data table, no version reply (2026-10-24, 11:19–11:27)

The dispatch table is at file `+0x38240`. The index is `cmd - 0x22`. An index of 105 or more returns. Command `0x3D` is index 27 and already has a handler at file `+0xAAFE`. It was not changed. Command `0x40` was an empty `pop r4-r8, r15` at file `+0xAA54`.

`c7000-cmd40-ack`, tag `R4l0`. The table word at `+0x382B8` pointed at a 20-byte thunk at `+0x35F64`. The thunk moves the frame into `r0`, calls file `+0x8E7C` with `r1 = 0`, and pops the dispatcher's frame. Thirty-nine patch tests passed before the load. sha256 `83fb392796b969c79dc9ace160e7aea7fa6e2fe7d161a0c1b7ab61d05c374565`.

VFO 467.625 at 11:19:37.714. YModem `onSuccess` at 11:21:50.172. The loader started SignalDeck again and the `0x34` line was empty. The bytes at `+0x35F64` are 128 zeros after a run of `0x01` bytes. Nothing in the image holds their address, and they are still the tail of that table. The image was not left loaded.

Factory restored. YModem `onSuccess` at 11:26:49.784. `0x34` `DMR003.UV4T.V022` at 11:27:03.083. VFO 467.625 / 467.625 FM at 11:27:05.024, low power. No `DMRDEBUG.bin`. Nothing was keyed. The ES8311 debug node was not written. §6 is not met. Do not reload R4l0.

# R4m — command 0x40 acks from the unused gap, tag R4m0 (2026-10-24, 11:32–11:35)

No HackRF capture. Nothing was keyed. Forty patch tests passed before the load. The ES8311 debug node was not written.

`c7000-cmd40-ack2`. The same 20-byte thunk as R4l, linked at file `+0x5AEFC` instead of the data table at `+0x35F64`. The dispatch word at `+0x382B8` is runtime `0x03074EFC`. The thunk moves the frame into `r0`, calls file `+0x8E7C` with `r1 = 0`, and pops the dispatcher's frame. Command `0x3D` at `+0xAAFE` is unchanged. The bytes at `+0x35F64` stay factory.

`DMR003.R4m0.V022.bin`, 378620 bytes. sha256 `673884b2ce0d77bc0f2e089775b1f127a742b5bae982b2f95d3a85fc9fec92a8`. Pushed MD5 `42827eae2e777c0d1f0aa031ecf2b3cd`.

## Load

VFO 467.625 / 467.625 FM at 11:32:56.669, low power, before the load. YModem `onSuccess` at 11:35:09.348. The first `0x34` at 11:35:14.363 had no answer, and the loader power-cycled the module. Banner `开机初始化完成` at 11:35:21.611. `0x34` at 11:35:21.922 is `DMR003.R4m0.V022`. The loader then wrote channel 36 (162.425 MHz, low power, `RX cmd=0x23 rw=0 sr=0` at 11:35:21.995). The VFO was put back: 467.625 / 467.625 FM at 11:35:23.839, low power, acked at 11:35:23.860.

## Command

DIAG `cmdbyte` with body byte 1. `TX cmd=0x40 rw=1 sr=1 len=1 [01]` at 11:35:27.838, frame `68 40 01 01 95 AD 00 01 01 10`. `RX cmd=0x40 rw=0 sr=0 len=0` at 11:35:27.844, 6 ms later. The log has no `0x26` and no `0x36`.

## End state

R4m0 stays loaded. VFO 467.625 / 467.625 FM at 11:35:29.955, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. The slot answers. It does not yet carry samples. Do not reload R4l0.

# R4n — command 0x40 echoes its first body byte, tag R4n0 (2026-10-24, 11:46–11:49)

No HackRF capture. Nothing was keyed. Forty-one patch tests passed before the load. The ES8311 debug node was not written.

`c7000-cmd40-echo`. A 62-byte handler at file `+0x5AEFC`. The dispatch word at `+0x382B8` is runtime `0x03074EFC`. The handler reads the byte at frame offset 8, builds a 10-byte reply on the stack, checksums it through file `+0x8E5C`, and sends it through file `+0x7DE8`. It does not key. Command `0x3D` at `+0xAAFE` is unchanged. The bytes at `+0x35F64` stay factory.

`DMR003.R4n0.V022.bin`, 378620 bytes. sha256 `2faa75635478890e689f8685ed8e8d8ec87ddb17baba1b50fe9a7aeb36b0bbc7`. Pushed MD5 `872bb00b2974d0aa4b40a36b6eb37022`.

## Load

VFO 467.625 / 467.625 FM at 11:46:07.739, low power, before the load. YModem `onSuccess` at 11:48:20.093. The first `0x34` at 11:48:26.017 had no answer, and the loader power-cycled the module. Banner `开机初始化完成` at 11:48:33.212. `0x34` at 11:48:33.523 is `DMR003.R4n0.V022`. The loader then wrote channel 36 (162.425 MHz, low power, `RX cmd=0x23 rw=0 sr=0` at 11:48:33.592). The VFO was put back: 467.625 / 467.625 FM at 11:48:35.181, low power, acked at 11:48:35.203.

## Command

DIAG `cmdbyte` twice. `TX cmd=0x40 rw=1 sr=1 len=1 [01]` at 11:49:16.920, frame `68 40 01 01 95 AD 00 01 01 10`. `RX cmd=0x40 rw=0 sr=0 len=1 [01]` at 11:49:16.925, 5 ms later. `TX cmd=0x40 rw=1 sr=1 len=1 [5A]` at 11:49:18.480, frame `68 40 01 01 3C AD 00 01 5A 10`. `RX cmd=0x40 rw=0 sr=0 len=1 [5A]` at 11:49:18.486, 6 ms later. The log has no `0x26` and no `0x36`.

## End state

R4n0 stays loaded. VFO 467.625 / 467.625 FM at 11:49:20.082, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. The handler reads one body byte. It does not store samples and it does not key. Do not reload R4l0.

# R4o — command 0x40 stores a sine and the wake plays it, tag R4o0 (2026-10-24, 12:02–12:05)

Forty-two patch tests passed before the load. The ES8311 debug node was not written. HackRF receive only, 467.385 MHz center, 2.4 MS/s, LNA 24, VGA 38.

`c7000-cmd40-host`. The handler at file `+0x5AEFC` copies a body of little-endian int16 samples into RAM `0x4A800`, clamps each one to ±6451, and stores the count at `0x4A7F0`. It clears the cursor at `0x4DAAC` and does not set PTT. A clear cursor makes the wake return without writing TX RAM. A host key with a zero count is the stock key. A non-zero count fills both TX halves from that buffer, then the wake writes zero halves. The task entry `+0x18A70` is not patched. Command `0x3D` is unchanged.

`DMR003.R4o0.V022.bin`, 378620 bytes. sha256 `2b37af7a4fad24e2d3873cacc88d532842d3081dc2be8c7ab8a07f4b1bbfb291`. Pushed MD5 `4696ab091f2f280bea6798b4f340584c`.

## Boot

VFO 467.625 / 467.625 FM at 12:02:18.444, low power, before the load. YModem `onSuccess` at 12:04:30.609. `0x34` at 12:04:43.863 is `DMR003.R4o0.V022`. The runner required the boot banner and did not restore. The HackRF record of that boot has floor 0.00 dB, peak 0.28 dB, and no run at +10 dB.

## Store, then one key

DIAG `cmdsine` at amplitude 2048, 64 samples, 1000 Hz. `TX cmd=0x40` length 128 at 12:05:08.368. The body begins `00 00 A8 05 00 08`, which is 0, 1448, 2048. `RX cmd=0x40 rw=0 sr=0 len=2 [40 00]` at 12:05:08.396, the count 64. That command did not key.

One 3 s silence key. Launch 1 at 12:05:11.521. Its ack is at 12:05:11.527, 6 ms later. `SEND_START` is at 12:05:11.532. Unkey at 12:05:14.911. Its ack is at 12:05:14.916, 5 ms later. `SEND_STOP` is at 12:05:15.239, 323 ms after that ack. The carrier is up for 3.49 s. SNR 61.4 dB. Offset +992 Hz. The IQ clip fraction is 0.42.

The key-up click, 0–40 ms, has p99 20711–22329 Hz and is not a stop. The tone window, 60–100 ms, has p99 4446–4495 Hz and a 1 kHz line of 3070–4183 Hz. That is under 5 kHz. From 120 ms on, p99 is about 100 Hz, so the wake's zero halves took over. The peak was not raised. There was no second key.

## End state

R4o0 stays loaded. VFO 467.625 / 467.625 FM at 12:05:19.439, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. A host sine went out. A full M17 frame does not fit in one 799-byte body.

# R4p — command 0x40 stores an M17 waveform in pieces, tag R4p0 (2026-10-24, 12:22–12:30)

Forty-three patch tests passed before the load. The ES8311 debug node was not written. HackRF receive only, 467.385 MHz center, 2.4 MS/s. The boot capture used LNA 24 and VGA 38. Both keys used LNA 16 and VGA 16.

`c7000-cmd40-m17`. The body is a little-endian sample offset and then little-endian int16 samples, at most 398 samples in one frame. They are clamped to ±6451 and written at RAM `0x4A400`. Offset 0 replaces the count at `0x4A3E4`. A later piece extends it. The handler does not set PTT. A clear cursor at `0x4DAAC` makes the wake return. A host key copies the buffer once, and the wake continues it, then writes zero halves. The task entry `+0x18A70` is not patched. Command `0x3D` is unchanged.

The waveform is 108 preamble symbols, one link setup, three stream frames, and 6 symbols of tail: 1470 samples. The peak count is 6451. The linear prediction is 3548 Hz. The first 500 samples are the same counts as the canned table. A second copy was scaled to peak count 4096, prediction 2253 Hz.

`DMR003.R4p0.V022.bin`, 378620 bytes. sha256 `70a4ce04766dc37b089036b4aeb976d9afcd626c845722ecc23d788d27e85685`. Pushed MD5 `9f6efe57be112105d952a616ee536b2f`.

## Boot

VFO 467.625 / 467.625 FM at 12:22:45.267, low power, before the load. YModem `onSuccess` at 12:24:57.394. `0x34` at 12:25:11.041 is `DMR003.R4p0.V022`. The runner required the boot banner and did not restore. The boot record peaks at 0.42 dB and has no run at +10 dB.

## Store

Four commands, none of them a key. Count 398 at 12:25:36.208, body `[8E 01]`. Count 796 at 12:25:37.878, body `[1C 03]`. Count 1194 at 12:25:39.572, body `[AA 04]`. Count 1470 at 12:25:41.181, body `[BE 05]`.

## Keys

The first key, peak count 6451, starts at 12:25:43.738. The ack is at 12:25:43.745, 7 ms later. `SEND_START` is at 12:25:43.750. The unkey ack is at 12:25:47.151, 6 ms after the unkey command. `SEND_STOP` is at 12:25:47.477, 326 ms later. The carrier is up for 3.50 s. SNR 55.2 dB. Offset +992 Hz. Clip fraction 0. The click, 0–40 ms, has p99 about 22 kHz and is not a stop. From 60 ms through 220 ms the p99 is 4404–5050 Hz. One 20 ms bin reaches 5050 Hz. From 240 ms the p99 is about 95 Hz. The plain decoder does not accept a link setup. The aimed-wave fit on that capture is r² 0.31 at a lag of 48 ms. The first 200 samples reach r² 0.52.

The second key, peak count 4096, starts at 12:30:13.989. The ack is at 12:30:13.995, 6 ms later. `SEND_START` is at 12:30:14.000. The unkey ack is at 12:30:17.407, 5 ms after the unkey command. `SEND_STOP` is at 12:30:17.727, 320 ms later. SNR 56.8 dB. Offset +986 Hz. Clip fraction 0. From 60 ms through 220 ms the p99 is 4490–4801 Hz. From 240 ms the p99 is about 90 Hz. The plain decoder does not accept a link setup. Lowering the peak count did not lower that air reading. The peak was not raised. There is no third key.

## End state

R4p0 stays loaded. VFO 467.625 / 467.625 FM at 12:30:21.974, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. The buffer plays for the length of the samples and then goes quiet. The plain decoder does not accept the frame.

# R4q — command 0x40 stores the sine in TX-RAM byte order, tag R4q0 (2026-10-24, 12:39–12:42)

Forty-five patch tests passed before the load. The new ones check that a known sample is stored with its high byte at the low address, and that the built image's store loop loads both body bytes and stores with `st.h`. The ES8311 debug node was not written. HackRF receive only, 467.385 MHz center, 2.4 MS/s. The boot capture used LNA 24 and VGA 38. The key used LNA 16 and VGA 16.

`c7000-cmd40-swap`. The handler is the R4o handler with one change in the store loop. The host still sends little-endian int16. The loop builds the signed sample, clamps it to ±6451, and stores the high byte at the low address. TX RAM reads that order. The copy into the modulator is still `ld.h`/`st.h`, so it keeps the bytes the store wrote. The buffer is RAM `0x4A800`. The count is `0x4A7F0`. A clear cursor at `0x4DAAC` makes the wake return. The handler does not set PTT. The task entry `+0x18A70` is not patched. Command `0x3D` is unchanged.

`DMR003.R4q0.V022.bin`, 378620 bytes. sha256 `26730d4b611ae14807c5c99396f6ffeed6c59d210005c1b52847daa06f598a66`. Pushed MD5 `6f174fb60d5c2ce92b58e2adcf06f51d`.

## Boot

VFO 467.625 / 467.625 FM at 12:39:51.727, low power, before the load. YModem `onSuccess` at 12:42:03.985. Banner `开机初始化完成` at 12:42:17.294. `0x34` at 12:42:17.604 is `DMR003.R4q0.V022`. The boot record has floor 0.00 dB, peak 0.06 dB, and no run at +10 dB. The loader wrote channel 36, and the VFO was put back at 12:42:38.238 before the sine.

## Store, then one key

DIAG `cmdsine` at amplitude 2048, 64 samples, 1000 Hz. `TX cmd=0x40` length 128 at 12:42:42.328. The body begins `00 00 A8 05 00 08`, which is 0, 1448, 2048, little-endian. `RX cmd=0x40 rw=0 sr=0 len=2 [40 00]` at 12:42:42.355, the count 64. That command did not key.

One 3 s silence key. Launch 1 at 12:42:45.459. Its ack is at 12:42:45.465, 6 ms later. `SEND_START` is at 12:42:45.471. Unkey at 12:42:48.875. Its ack is at 12:42:48.881, 6 ms later. `SEND_STOP` is at 12:42:49.200, 319 ms after that ack. The carrier is up for 3.51 s. SNR 49.8 dB. Offset +978 Hz. The IQ clip fraction is 0.

The key-up click, 0–40 ms, has p99 22760 Hz and is not a stop. The 60 ms slice has a 1 kHz line of 970 Hz and p99 1106 Hz. The 80 ms slice, the strongest 1 kHz line whose p99 stays under 8 kHz, has a line of 972 Hz and p99 1040 Hz. Both sit inside 15 percent of the R3a8 numbers, a 923 Hz line and p99 1217 Hz. From 120 ms on, the line is about 3 Hz and p99 is about 100 Hz, so the wake's zero halves took over. The peak was not raised. There was no second key, and no M17 body was sent.

## End state

R4q0 stays loaded. VFO 467.625 / 467.625 FM at 12:42:53.391, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. The byte swap puts this sine on the R3a8 scale. The R4p waveform has not been sent again.

# R4r — the same M17 body, stored in TX-RAM byte order, tag R4r0 (2026-10-24, 12:48–12:51)

Forty-six patch tests passed before the load. The ES8311 debug node was not written. HackRF receive only, 467.385 MHz center, 2.4 MS/s. The boot capture used LNA 24 and VGA 38. The key used LNA 16 and VGA 16.

`c7000-cmd40-m17swap`. The piece store is the R4p handler. The sample loop is the R4q swap: the signed value is clamped to ±6451, then the high byte is stored at the low address. The copy into TX RAM is still `ld.h`/`st.h`. The buffer is RAM `0x4A400`, 1500 samples. It does not set PTT. A clear cursor at `0x4DAAC` makes the wake return. The task entry `+0x18A70` is not patched. Command `0x3D` is unchanged.

The waveform is the R4p body: 108 preamble symbols, one link setup, three stream frames, and 6 symbols of tail. 1470 samples. The peak count is 6451. The linear prediction is 3548 Hz. The last stream frame has the end bit set.

`DMR003.R4r0.V022.bin`, 378620 bytes. sha256 `8ce6cd45f9872dbc525d77dbaf912a40b499498aacd1bc18563954bd6348d2d2`. Pushed MD5 `c4b9fec38491a7ceb7cf8e75a22c2272`.

## Boot

VFO 467.625 / 467.625 FM at 12:48:15.695, low power, before the load. YModem `onSuccess` at 12:50:27.733. Banner `开机初始化完成` at 12:50:41.448. `0x34` at 12:50:41.759 is `DMR003.R4r0.V022`. The boot record has floor 0.00 dB, peak 0.05 dB, and no run at +10 dB. The loader wrote channel 36, and the VFO was put back at 12:51:02.226 before the store.

## Store, then one key

Four commands, none of them a key. Count 398 at 12:51:06.439, body `[8E 01]`. Count 796 at 12:51:08.151, body `[1C 03]`. Count 1194 at 12:51:09.827, body `[AA 04]`. Count 1470 at 12:51:11.452, body `[BE 05]`.

One 3 s silence key. Launch 1 at 12:51:13.970. Its ack is at 12:51:13.976, 6 ms later. `SEND_START` is at 12:51:13.981. Unkey at 12:51:17.382. Its ack is at 12:51:17.387, 5 ms later. `SEND_STOP` is at 12:51:17.714, 327 ms after that ack. The carrier is up for 3.51 s. SNR 57.1 dB. Offset +980 Hz. The IQ clip fraction is 0.

The key-up click, 0–40 ms, has p99 22827 Hz and is not a stop. From 60 ms through 220 ms the p99 is 2817–3086 Hz. From 240 ms the p99 is 91 Hz. The peak was not raised. There was no second key.

The link-setup sync at 70 ms scores 0.998. Aimed at that sync, the CRC passes, and both callsigns match the research modem's bench callsign. The symbol gain there is about 2233 Hz. Three stream frames follow, scores 0.999: frame 0, frame 1, and frame 2 with the end bit set. Each has Golay error 0 and payload bytes 0 through 15. The plain decoder's returned link-setup flag stays false, because a later sync at 230 ms, score 0.675, overwrites that slot. The frame at 70 ms passed.

## End state

R4r0 stays loaded. VFO 467.625 / 467.625 FM at 12:51:21.985, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met. The byte swap puts this body on the R4b scale, and the stream frames decode.

# R4s — symbols over command 0x40, RRC in the wake, tag R4s0 (2026-10-24, 13:36–14:06)

The host tests passed before the load. The integer RRC matches the float waveform at r² 1.0, max absolute error 2 counts. The image carries those coefficient bytes and the dibit table `01 03 ff fd`. The task entry `+0x18A70` and the `0x3D` thunk are factory. The ES8311 debug node was not written. HackRF receive only, 467.385 MHz center, 2.4 MS/s. The boot capture used LNA 24 and VGA 38. The key used LNA 16 and VGA 16.

`c7000-cmd40-sym`. Command `0x40` byte 0 is an op-code. Op 1 appends symbols, four per byte, MSB dibit first. Op 2 returns the ring fill, the underrun count, and the last error. Op 3 clears the five control words. Op 0 and any other op answer `sr=1`: the 2048-symbol ring at `0x4A400` is the only safe RAM, so this image does not also store samples. An empty ring leaves the stock key. An underrun emits a zero sample, counts it, and does not advance the read pointer. The wake fills each 256-sample half with the 5-phase RRC at the table-generator scale. It does not key. Boot does nothing.

The outer-symbol scale stays `HZ_PER_COUNT` 0.54 and `OUTER_SCALE` 1. A long +3 is already at the 6451 count cap, so a factor of 1.07 would clip at the same cap. The research decoder now keeps a CRC-valid link setup unless the new sync also passes CRC and scores at least as high. Re-run on the kept R4r capture, slice 0.02–0.40 s: the link-setup flag is true, both callsigns match, and the three frames are Golay 0.

`DMR003.R4s0.V022.bin`, 378620 bytes. sha256 `2c8866bcf1a8696d8f0383cc86c11a674b56d764f2b171581d52922d969dd70f`. Pushed MD5 `3361b58af15aa9f81cfa6c9ca06a08d1`.

## Boot

VFO 467.625 / 467.625 FM at 14:03:07.583, low power, before the load. YModem `onSuccess` at 14:05:19.716. Banner `开机初始化完成` at 14:05:32.761. `0x34` at 14:05:33.072 is `DMR003.R4s0.V022`. The boot record has floor 0.00 dB, peak 0.08 dB, and no run at +10 dB.

## One key

The symbol file is 2475 bytes: preamble, one link setup, and 50 stream frames. `sym ready fill=1536` at 14:05:58.184. `sym done bytes=2475` at 14:06:00.827. The status read at 14:06:06.873 is `fill=0 underrun=19340 err=0 sr=0`. The carrier is up for 4.53 s. SNR 58.0 dB. Offset +1007 Hz. Clip fraction 0.

The key-up click, 0–40 ms, has p99 22045 Hz and is not a stop. From 60 ms through 2000 ms the p99 is 3660–4109 Hz. From 2200 ms the p99 is about 80 Hz. No slice from 60 ms on is at or over 5 kHz. The peak was not raised. There was no second key and no 90-frame run.

The plain decoder accepts no link setup and no stream frame. A sync search on the same capture finds one link-setup score of 0.928 at 0.856 s and one stream score of 0.939 at 1.106 s, and the frame tracker loses the next sync. The fit of that capture to the integer RRC model, best lag, is r = −0.34. The 2.06 s of symbols did go out: the modulated interval matches that length, and the underrun count is the rest of the 4 s key after the ring runs dry.

## End state

R4s0 stays loaded. VFO 467.625 / 467.625 FM at 14:06:08.335, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. §6 is not met.

# R-C step 1 — FM receive RAM, reading only (2026-10-24)

No image was built for this reading. Nothing was keyed for it. The factory objdump was read.

Analog receive does not set `WORK_MODE` bit 7. The channel setup stores `0x22`, `0x6A`, or `0x6E`, and none of those has bit 7. Bit 7 (`0x80`) is stored by the FM key-up at `+0x3EDE4` and by the in-key side path at `+0x18B3E`, and the unkey at `+0x3EE86` writes the saved word back. The function at `+0x19470` stores `0x16A` or `0x16B`, which also leave bit 7 clear. Its two callers are `+0x62A8` and `+0x6380`, and each calls it only when the helper at `+0x2404` returns nonzero.

`SYS_INTERP_MASK` bit 14 is clear in the normal setup stores `0x1187F` (`+0x179AA`) and `0x1007F` (`+0x17A96` and `+0x17E3E`), and in the BER stores `0x1800` and `0x800`. It is set by the `0x1E07F` store at `+0x18292` when byte 1 of `0x34808` is nonzero, and by both arms of `+0x19470`. The FM key-up stores 0 into the mask and the unkey restores the saved value.

The only literals in `0x160004B0`–`0x160008DF` are `0x160004B0` and `0x160004B1`, both in the copy helper at `+0x2A4C`. That is the same helper R-A read. The 36-byte BER snapshot remains the only copy that starts at `0x160004E0`. No other reader of the FM audio halves was found.

# R4t — sign-extended taps, tag R4t0 (2026-10-24, 14:37–14:43)

The coefficient load in `one_sample` is `ld.hs`. `ld.h` zero-extends on this core, and that was the R4s clamp. Op 4 renders up to 256 samples into `0x4AC00` and returns them. It does not key. The image test checks the `ld.hs` encoding `04 d8 00 50` followed by the multiply. The ES8311 debug node was not written. HackRF receive only, 467.385 MHz center, 2.4 MS/s. The boot capture used LNA 24 and VGA 38. The keys used LNA 16 and VGA 16.

`DMR003.R4t0.V022.bin`, 378620 bytes. sha256 `c571018f704cc8aa4faa023a56efaf70f3b267d9a1d1befc34b924880be8e1b9`. Pushed MD5 `78053778b0d23cadc07262458fbf19a5`.

## Boot

VFO 467.625 / 467.625 FM at 14:37:27.808, low power, before the load. YModem `onSuccess` at 14:39:39.917. Banner `开机初始化完成` at 14:39:53.631. `0x34` at 14:39:53.952 is `DMR003.R4t0.V022`. The boot record has floor 0.00 dB, peak 0.06 dB, and no run at +10 dB.

## Render, no key

64 symbols: eight +3, eight −3, then 48 symbols of +3/−3. Op 3, op 1, op 4 for 106 samples. The returned samples, un-swapped, match `integer_counts` on those symbols: 106 of 106, no mismatch. VFO 467.625 / 467.625 FM at 14:40:19.125. Nothing was keyed for the render.

## Keys

One 50-frame stream, then three 90-frame streams. Low power, 467.625 MHz. Each status read is `underrun=5004`. That count is the same on the 2.06 s stream and the 3.66 s stream, and it matches the carrier tail after the symbols (about 0.63 s). The stream itself did not run dry.

The 50-frame key: `sym ready` at 14:41:55.373, `sym done bytes=2475` at 14:41:58.051, status at 14:42:02.071. Carrier 2.72 s, SNR 57.4 dB, offset +1020 Hz, clip 0. The click, 0–40 ms, has p99 22487 Hz and is not a stop. From 60 ms through the stream the p99 is 2788–3082 Hz. No slice from 60 ms on is at or over 5 kHz. The link-setup CRC passes and both callsigns match. A window through 2.45 s accepts 50 stream frames at Golay error 0 with payload bytes 0 through 15. Two later syncs are not those frames.

The three 90-frame keys, each `sym done bytes=4395`, status underrun 5004, clip 0:

| Key | Ready | Status | Carrier | SNR | Offset | p99 min | p99 max | Good frames |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | 14:43:04.078 | 14:43:12.733 | 4.32 s | 58.0 dB | +1021 Hz | 2733 Hz | 3110 Hz | 90 |
| 1 | 14:43:18.916 | 14:43:27.578 | 4.33 s | 57.4 dB | +1017 Hz | 2741 Hz | 3093 Hz | 90 |
| 2 | 14:43:33.713 | 14:43:42.365 | 4.33 s | 57.4 dB | +1014 Hz | 2753 Hz | 3094 Hz | 90 |

Each link-setup CRC passes and both callsigns match. The 90 good frames are Golay error 0 with payload bytes 0 through 15. The printed slices from 80 ms through 3600 ms sit between 2792 Hz and 2895 Hz. The 60 ms slice is 3093–3110 Hz, the shoulder of the click. The lowest 20 ms slice in the set is the minimum in the table. No slice from 60 ms on is at or over 5 kHz. The peak was not raised.

## End state

R4t0 stays loaded. VFO 467.625 / 467.625 FM at 14:43:44.020, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The independent decoder is still waiting on the Ubuntu box.

# R-C step 2 — one FM receive half, tag RC20 (2026-10-24, 15:07–15:11)

Op 5 saves `WORK_MODE` (`0x11000100`), stores `0x80` when the second body byte is 0 or `0x16A` when it is 1, and waits until `FM_ADDR_SW` (`0x1100056C`, bits 1:0) has taken two values or the spin of `1<<22` ends. It then copies the half that register is not pointing at (1 copies `0x160006E0`, 2 copies `0x160004E0`) into `0x4AC00`, restores `WORK_MODE`, and returns the 512 bytes. The reply frame is built at `0x4AE00`, not on the stack. The path does not write PTT (`0x11000560`). A timeout restores the word and returns sr=1. The phone was not keyed. HackRF transmit used 467.625 MHz, 2 MS/s, deviation 2.5 kHz, amp off, and a dummy burst before each tone. The ES8311 debug node was not written.

`DMR003.RC20.V022.bin`, 378620 bytes. sha256 `ad941d8a46b64aabbb57ee441698a85991559b1770ed7ee939e595890c7c40ef`. Pushed MD5 `af523ecaa81540c36387c1d5900abce4`.

## Boot and a quiet op 5

VFO 467.625 / 467.625 FM at 15:07:27.282, low power, before the load. YModem `onSuccess` at 15:09:36.314. Banner `开机初始化完成` at 15:09:50.664. `0x34` at 15:09:50.975 is `DMR003.RC20.V022`. The boot record has floor 0.00 dB, peak 0.07 dB, and no run at +10 dB. VFO again at 15:10:10.999. One op 5, mode 0, with the HackRF only receiving: `rxram bytes=512 sr=0 mode=0` at 15:10:16.657. That capture's peak is 0.09 dB. The command does not make the phone radiate.

## What the 512 bytes are

Each half is 512 bytes, and the bytes come back as `HH 00 00 00` repeated. 128 of the int16 slots hold the audio in the high byte. The low byte of those slots is 0, and the 128 slots between them are 0. Dropping the zero slots leaves 128 samples. A 1 kHz tone lands on 1 kHz when those 128 samples are read at 4 kHz, which is one half (32 ms) with a zero int16 between audio samples. The idle half is a constant high byte `0xFF`.

## HackRF tones, mode 0 (`0x80`)

`0x16A` was not sent. The 1 kHz line is the peak of the 128 audio samples from TX VGA 6 up. VGA 0 is a different peak. RSSI is the module's `0x32` byte, `dBm = -(120 - raw/2)`.

| TX VGA | RSSI raw | dBm | Audio rms | Peak | dB over median |
| --- | --- | --- | --- | --- | --- |
| 0 | 0x21 | −103.5 | 11310 | 375 Hz | 22 |
| 6 | 0x26 | −101 | 6724 | 1000 Hz | 37 |
| 12 | 0x2A | −99 | 7086 | 1000 Hz | 44 |
| 20 | 0x34 | −94 | 6874 | 1000 Hz | 48 |

A 100 Hz tone at VGA 20 (RSSI raw `0x33`, −94.5 dBm) has audio rms 335 and a peak at 406 Hz, 7 dB over the median. It does not stand out. The sweep, 40 Hz to 3200 Hz over 16 s, VGA 20:

| t | Expected | Peak | dB | Audio rms |
| --- | --- | --- | --- | --- |
| 1.2 s | 293 Hz | 312 Hz | 10 | 318 |
| 3.5 s | 747 Hz | 719 Hz | 49 | 9750 |
| 6.0 s | 1241 Hz | 1219 Hz | 46 | 5159 |
| 8.5 s | 1735 Hz | 1688 Hz | 39 | 3162 |
| 11.0 s | 2228 Hz | 1812 Hz | 37 | 2196 |
| 13.0 s | 2623 Hz | 1406 Hz | 33 | 1710 |

The line is weak near 300 Hz and full from about 720 Hz through 1700 Hz. Above 2 kHz it folds (2228 Hz appears near 1812 Hz, and 2623 Hz near 1406 Hz), which is the 4 kHz sample rate of the audio slots. The low end of this receive RAM is not there.

## End state

RC20 stays loaded. VFO 467.625 / 467.625 FM at 15:11:19.770, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The phone was not keyed.

# R-C step 3 — both halves, byte copy, tag RC30 (2026-10-24, 15:32–15:38)

The RC20 copy was `ld.w` on byte-wide RAM, so those 512 bytes were the high byte of every second sample. Op 5 now copies each half with `ld.b` × 512 and sends two replies. Each body is 512 sample bytes, the `FM_SQL` word, the half index and the final switch value. Every variant stores `WORK_MODE` `0x80` and restores it. Variant 2 also clears `FM_BANDWIDTH` (`0x11000500`) bits 6 and 4 for the capture. Variant 3 writes AT1846S `0x58` = `0xBCFD` and writes `0x8405` back. Variant 4 does both. A timeout restores the same words. The phone was not keyed. HackRF transmit was 467.625 MHz, 2 MS/s, deviation 2.5 kHz, TX VGA 20, amp off, with a dummy burst before each variant.

`DMR003.RC30.V022.bin`, 378620 bytes. sha256 `6b0d873bc5526d24495d801f86f2b800b6cc62a2ac71c7ca495411c863a58ade`. Pushed MD5 `ae80df7dbbfe2051ea0ecd37baedb980`.

## Boot and the quiet read

VFO 467.625 / 467.625 FM at 15:32:16.209, low power, before the load. YModem `onSuccess` at 15:34:28.467. Banner `开机初始化完成` at 15:34:42.050. `0x34` at 15:34:42.361 is `DMR003.RC30.V022`. Boot peak 0.10 dB. The quiet variant 0 reply at 15:35:08.263 is two bodies of 518 bytes, sr=0. Each half is 256 int16. The `xx 00 00 00` groups are 0 and 3 of 128. Idle means are −8 and −9, rms 17 and 5. Receive peak 0.06 dB. The other three variants are the same kind of idle (rms 4–59) and their receive peaks are 0.03–0.05 dB. `FM_SQL` on a quiet half is 4.

Both halves carry the same tone when a tone is present. A 1 kHz capture has no seam on either half. The switch byte is 1 or 2 from call to call. The finished half and the half the register names are both live audio.

## Tones

Levels are the rms of one half relative to that variant's 1 kHz rms. The half is the one with the stronger 1 kHz rms. 300 Hz falls in the 312.5 Hz bin.

| Variant | 1 kHz rms | 300 Hz | 100 Hz | 50 Hz |
| --- | --- | --- | --- | --- |
| 0, plain | 6881 | +11.1 dB | −32.2 dB | −30.2 dB |
| 2, band-pass bits clear | 7643 | +9.2 dB | −31.5 dB | −31.0 dB |
| 3, `0x58` = `0xBCFD` | 6877 | +11.1 dB | −29.0 dB | −34.9 dB |
| 4, both | 6889 | +11.0 dB | −17.6 dB | −4.0 dB |

Variant 2's other half does peak at 94 Hz, 29 dB over its own median, and that rms is still −22 dB against its 1 kHz. Variant 4's −17.6 dB and −4.0 dB rows are the halves that also show a seam, so those rms figures are not a clean tone. No variant puts a 100 Hz line within 6 dB of its 1 kHz line.

The plain sweep tracks the chirp: expected 747, 1241, 1735, 2228 and 2623 Hz come back as 750, 1219, 1719, 2219 and 2594 Hz. The 293 Hz point does not. There is no fold above 2 kHz. The RC20 fold was the word read.

## End state

100 Hz is not within 6 dB of 1 kHz in any variant. R-C closes on that measurement. The receive side stays the audio-path equaliser. RC30 stays loaded. VFO 467.625 / 467.625 FM at 15:38:49.337, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The phone was not keyed.

# R-C step 4 — 128 ms lines, tag RC40 (2026-10-24, 15:53 load, 16:01–16:06 measurement)

Op 5 holds `WORK_MODE` `0x80` across four `FM_ADDR_SW` changes and copies the half that value names, with `ld.b`, into `0x4A400`. Four replies return the 2048 bytes. Variants are the RC30 set. The phone was not keyed. HackRF FM was 467.625 MHz, 2 MS/s, deviation 2.5 kHz, TX VGA 20, amp off. Each tone was captured three times. The level is a Goertzel line at that frequency over the 1024 samples, and the table is the median of the three against the median 1 kHz line.

`DMR003.RC40.V022.bin`, 378620 bytes. sha256 `f129a0c37bd22d672c5398bfdb273c702a586e7e14fce248120498003c3c89d4`. Pushed MD5 `cbbf0e1a95960b3c5e3f1d17c06f875c` at the 15:55:39.888 load. The HackRF was absent for that boot, so the module was power-cycled again for the capture below. Adb was `192.168.1.125:5555`.

## Boot and quiet reads

Banner `开机初始化完成` at 16:01:03.522. `0x34` at 16:01:03.835 is `DMR003.RC40.V022`. Boot peak 0.08 dB, no run at +10 dB. VFO 467.625 / 467.625 FM at 16:01:30.554. A quiet op 5 on each variant returned four frames. Idle rms is 9–34. The `xx 00 00 00` groups are 0 or 1 per half. Receive peaks are 0.03–0.07 dB. The halves alternate, so each reply is the next completed half.

## Lines

| Variant | 300 Hz | 100 Hz | 50 Hz | Largest half-boundary step |
| --- | --- | --- | --- | --- |
| 0, plain | +11.1 dB | −42.1 dB | −46.1 dB | 2.3× |
| 2, `FM_BANDWIDTH` bits 4 and 6 clear | −4.4 dB | −22.4 dB | −24.0 dB | 97× on one 300 Hz capture |
| 3, AT1846S `0x58` = `0xBCFD` | +11.3 dB | −19.3 dB | −22.8 dB | 5.8× |
| 4, both | −2.3 dB | +0.3 dB | −0.3 dB | 8.3× |

The three 100 Hz lines on variant 4 are 7465, 8526 and 8878, against 1 kHz lines 7707, 8275 and 8499. The half-boundary step on those captures is at most 7.8 times the median sample-to-sample step. It does not move the line. Variant 2's 300 Hz readings are 8000, 5441 and 4733, and one of them has a step 97 times the median, so that row is the rough one. Its 100 Hz readings are 680, 616 and 725.

## The state that passes

100 Hz is within 6 dB of 1 kHz only on variant 4. During that capture the module has `WORK_MODE` `0x11000100` = `0x80`, `FM_BANDWIDTH` `0x11000500` with bits 4 and 6 clear, and AT1846S register `0x58` = `0xBCFD`. The reply then restores `WORK_MODE` and `FM_BANDWIDTH` and writes `0x58` back to `0x8405`. Either change alone leaves 100 Hz at −19 dB or −22 dB.

## End state

R-C and R-B close on this measurement. The receive design stays the audio-path equaliser. RC40 stays loaded. VFO 467.625 / 467.625 FM at 16:06:43.569, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The phone was not keyed.

# R-D — phone path, receive-RAM top end, UART clock (2026-10-24, 17:13–17:20)

Tag `RD10`. Sha256 `6550e55256600b2b6880b9609bce919900cb8dd16c19aff67edf8ba03d970527`. Pushed MD5 `65d92fa2c85b516934211f70fc21ee14`. Command `0x40` op 5 returns four or six FM receive halves. Op 6 applies variant 3 or 4 and leaves it until a restore. Neither op writes PTT. The phone was not keyed. HackRF transmit was FM at 467.625 MHz, VGA 20, amplitude off, deviation 2.5 kHz, finite files, a dummy burst first. Wi-Fi adb `192.168.1.125:5555` only.

## Load and boot

YModem `onSuccess` at 17:15:07.427. `0x34` `DMR003.RD10.V022` at 17:15:21.429. The HackRF receive that covered the load peaked at 0.15 dB, with no sample above 10 dB. The retained log kept the `0x34` line and not the banner sentence. Quiet op 5, mode 0 and mode 4, four replies of 514 bytes, `sr=0`, idle rms 9 and 43, receive peaks 0.04 dB. Six halves, mode 4, idle, peak 0.02 dB.

## Phone path

8 kHz mono, before the app squelch. Line level against the 1 kHz tone in the same state.

| Hz | Plain | `0x58` = `0xBCFD` | Variant 4 |
|---|---|---|---|
| 50 | −27.6 dB | −0.6 dB | −0.6 dB |
| 100 | −24.5 dB | +1.2 dB | +1.2 dB |
| 300 | +5.7 dB | −1.6 dB | −1.6 dB |
| 1000 | 0 | 0 | 0 |
| 2000 | −4.0 dB | +1.8 dB | +1.8 dB |
| 3500 | −12.1 dB | +1.7 dB | +1.7 dB |
| 3800 | −17.0 dB | +1.7 dB | +1.7 dB |

`WORK_MODE` `0x80` does not mute the phone. Variant 4 matches the single `0x58` write within 0.1 dB, so what the phone hears is the AT1846S voice filter. A VFO write to 467.625 MHz, without re-applying the hold, puts 100 Hz back to −24.5 dB in both states. `at1846_tune` rewrites `0x8405`.

## Receive RAM, variant 4

Four halves, line against the 1 kHz line of 4795 counts. 2 kHz +4.7 dB, 3 kHz +2.6 dB, 3.5 kHz +4.7 dB, 3.8 kHz +2.2 dB. The top of the band is present.

## M17 from those samples

A loop of one link setup and two stream frames, ±2.4 kHz, captured as six halves (192 ms) eight times. Plain `m17.py`, no equaliser, scale 0.521 Hz per count from the 1 kHz line, and the inverted polarity. Sync locked. As captured, the frame number was often 1. No capture had a link-setup CRC. Golay errors on the stream frames were 8 to 14. The pass was not met.

## UART clock, read only

File `+0x5DEC`, called from the boot list at `+0xD9E`, programs the DesignWare UART at `0x14090000`. The divisor is `(*0x32F90 >> 4) / 57600`, written to DLL and DLH with DLAB. No fractional divisor register is written. The word at `0x32F90` is one of three constants from `+0x5432C`: 6 MHz when the first argument is not 1, 48 MHz when the first is 1 and the second is not, and 42 MHz when both are 1. Integer division gives 62500 Hz (+8.5%), 57692 Hz (+0.160%) and 58333 Hz (+1.27%). The working 57600 link fits the 48 MHz value. The same clock and a divisor for 230400 lands on 13 and 230769 Hz, +0.160%, the same fraction, not an integer. SignalDeck's Armor control port is `/dev/ttyS0` at 57600. `RadioEngine.open` passes the profile baud to `VendorSerial.openPort`. The Xplore 1 profile already opens `/dev/ttyS1` at 230400 through that JNI.

## End state

RD10 stays loaded. VFO 467.625 / 467.625 FM at 17:20:44, low power. SignalDeck owns the radio. No `DMRDEBUG.bin`. The phone was not keyed. R-C stays open. The phone path is flat after one AT1846S write, and that write does not survive a channel write. A runtime UART switch to 230400 is as close as the link that already works. The eight M17 captures did not plain-decode.

# R-E — held phone path, capture integrity, op 6 fixes (2026-10-24, 17:41–18:02)

The pass on the phone path is not met. RD10 stayed loaded for the receive measurements. RE10 is the op 6 fix and is the image left in the module. The phone was not keyed. HackRF transmit was FM at 467.625 MHz, VGA 20, amplitude off, finite files, a dummy burst first. Wi-Fi adb `192.168.1.125:5555` only. No `DMRDEBUG.bin` (ls rc 1) at the end.

## Phone path, variant 3, on RD10

Op 6 variant 3 applied with `sr=0` at 17:41:16.759, before the carrier. Each `rxclip` is 8 kHz mono, taken before the app squelch. The module itself holds that PCM at a peak of about 5 counts until its squelch opens. On these clips that mute lasts 1.09–1.24 s, and the tone is only in the tail. The runner's 0.8 s window sat in the mute, so its printed lines (100 Hz 653, then 0.1) are that silence. The loud tail is the measurement. A clean held 100 Hz from R-D is line 7303 and rms 5166.

| Clip | Onset of audio | 100 Hz or 1 kHz line, last 0.4 s |
|---|---|---|
| 100 Hz, hold just applied | 1.09 s | 7291 |
| 1 kHz, still held | 1.13 s | 6222 |
| 100 Hz, after three M17 loops | 1.21 s | 6334 (tail rms 5162) |
| 100 Hz, after a VFO write, hold not re-sent | the clip never reaches the held level | 387 |
| 100 Hz, hold applied again | 1.16 s | 7258 |

The hold survives the squelch opening: after three M17 carriers the tail rms matches R-D's held 100 Hz. The VFO write clears it (387 counts, −25.5 dB against 7291), and applying variant 3 again restores it. SignalDeck's sequence while a raw-discriminator decoder is on is: op 6 variant 3 action 1, and the same command again after every channel or VFO write. A variant-3 restore is a separate clear, measured on RE10 below.

The M17 loop is a link setup plus stream frames 0 and 1 (`N0CALL` to `@ALL`, payloads 16 zero bytes then bytes 0–15), ±2.4 kHz, no preamble and no end frame. Three 3 s clips, then one clip after the hold was restored. Plain `m17.py`, both polarities, no equaliser, scored on the loud part. A scale sweep from 0.25 to 0.70 did not change the decisions.

| Recording | Best sync | Link-setup CRC | Source | Destination | Frames | Golay 0 | Frame numbers |
|---|---|---|---|---|---|---|---|
| held 0, as captured | 0.957 | no | — | — | 2 | 0 | 15311, 20760 |
| held 0, inverted | 0.957 | no | 8M07.HMMC | EHHLLZ- D | 0 | 0 | — |
| held 1, inverted | 0.943 | no | OIVHXT9J | a broken `@ALL` | 28 | 0 | 0, 1, 0, 1, … |
| held 1, as captured | 0.943 | no | not N0CALL | not @ALL | 14 | 0 | 40893 repeated |
| held 2, inverted | 0.950 | no | OIVHXT9J | a broken `@ALL` | 29 | 0 | 1, 0, 1, 0, … |
| held 2, as captured | 0.950 | no | not N0CALL | not @ALL | 15 | 0 | 40893 repeated |
| plain control, either polarity | 0.889 | no | not N0CALL | not @ALL | 0 or 1 | 0 | one frame 49914 |

LICH Golay sums on the locked 0/1 frames stay between 7 and 15. Inverted is the polarity that produces frame numbers 0 and 1. The plain-state control does not lock. Pass was CRC true and every stream frame at Golay 0, on all three. It is not met.

## Receive RAM, variant 4, on RD10

Every raw capture is a six-part `rxram.bin` copied to `C:\Users\Joshua\AppData\Local\Temp\fw1718\re\`. Names: `re_1k_0.bin` through `re_1k_4.bin`, `re_310_0.bin` through `re_310_2.bin`, `re_m17ram_0.bin` through `re_m17ram_2.bin`. Each reply is 514 bytes, `sr=0`, sequence 0 through 5. Half ids alternate, starting on whichever half was live: `1,0,1,0,1,0` or `0,1,0,1,0,1`. No capture repeats or skips an id.

1 kHz, deviation 2.5 kHz. The line is the tone amplitude. A pure sine would have rms = line / √2.

| Capture | Halves | Line | Rms | Peak Hz |
|---|---|---|---|---|
| re_1k_0 | 1,0,1,0,1,0 | 7699 | 6898 | 999.99 |
| re_1k_1 | 0,1,0,1,0,1 | 7409 | 6902 | 1000.00 |
| re_1k_2 | 0,1,0,1,0,1 | 7934 | 6897 | 1000.00 |
| re_1k_3 | 1,0,1,0,1,0 | 7610 | 6889 | 999.99 |
| re_1k_4 | 1,0,1,0,1,0 | 8821 | 6942 | 1000.00 |

The peak is inside 1000.0 ± 0.5 Hz on every capture, so this receive sample rate is 8 kHz at that resolution. The lines sit with RC40's 7707–8499, not with the one RD10 capture that read 4795. At 1 kHz a half is exactly 32 cycles, so a continuous recording has no phase step at a boundary. Halves 1 through 5 step by 0.0–0.3 degrees. Half 0 is off by 57–133 degrees in four captures and by 0.5 degrees in `re_1k_4`, which is also the capture with the highest line. The extra energy (rms above line / √2) is in that first half.

310 Hz is 9.92 cycles per half, a phase step of −28.8 degrees when the recording is continuous. The fitted phase does that on every boundary of all three captures. The largest sample step is inside the first half, at index 18, 170 and 241, sizes 10850, 23190 and 23118, against a median step of 981–1262. None of those indexes is 255, 511, 767, 1023 or 1279. Residual rms of one 1536-sample fit, halves 0 through 5: `re_310_0` 7526, 2534, 2137, 2122, 2416, 2473; `re_310_1` 14017, 3653, 2959, 2726, 2803, 2795; `re_310_2` 16098, 4792, 3858, 3425, 3222, 3133. The first half carries the step. The later halves are one tone.

`uart_status_sender` at file `+0x7BC0` is the status task. It copies one byte onto its stack and calls `+0x9120`. That function copies the caller's body into its own stack frame (`+0x304E8` is a memcpy) and `uart_send`s the copy. Op 5 does not use `+0x9120`. It calls `uart_send` (`+0x7DE8`) on the in-place frame. `uart_put` (`+0x5EF4`) stores each byte to the data register before it takes the next one, and it returns only after the length is written. The next half's header cannot change a frame that has already gone out. The replies were not rebuilt at `0x4AE00`.

The M17 loop, three captures, same symbols as the phone test. The slicer fits a gain, then compares to the known 576 symbols. Distance is in 8 kHz samples to the nearest 256-sample boundary. Bins are 24 symbols wide across one 192-symbol frame.

| Capture | Errors | Rate | Sync | Errors within 8 samples of a boundary | Median distance | Errors per 24 symbols |
|---|---|---|---|---|---|---|
| re_m17ram_0 | 184/576 | 0.319 | 0.996 | 10 | 63 | 21, 34, 20, 19, 21, 24, 20, 25 |
| re_m17ram_1 | 380/576 | 0.660 | 0.963 | 17 | 70 | 46, 47, 57, 51, 42, 40, 50, 47 |
| re_m17ram_2 | 123/576 | 0.214 | 0.916 | 9 | 56 | 16, 27, 13, 9, 14, 16, 10, 18 |

The errors do not gather at the half boundaries and they do not rise toward the end of the frame. `re_m17ram_1` is a poor gain fit (0.64 against about 3.1 on the other two). The in-place headers and the sample rate are not what leaves the symbols wrong. What remains is the shape of this receive path. The same miss is on the phone path above, which does not go through these replies.

## Op 6 fixes, tag RE10

Saves moved off `0x4A3F8` and `0x4A3FC`. `0x4A3F0` is the underrun count and `0x4A3F4` is the last error, so those words were not used. The factory image has no immediate in `0x4B000`–`0x4B077`. WORK_MODE is saved at `0x4B000`, the bandwidth word at `0x4B004`, and `0x4B008` holds `0x484F4C44` while a hold is applied. Op 5 compares that word before it touches a register and returns `sr=1` when it matches. `0x4A3F8` remains op 5's return-address scratch and the first reply header. Variant 3 restore writes `0x8405` and clears the flag. It does not write WORK_MODE back. Variant 4 restore writes both saved words, then `0x8405`.

Sha256 `53bf713cc19e718fee286a6f83b0812ca9e78bf92c91990ed946bb1bc3b1091c`. Pushed MD5 `5c8c2c86c1e756dc9750596ca8083af3`. The command-slot word is `fc4e0703` at file `0x382B8`. YModem `onSuccess` at 18:00:21.251. `0x34` `DMR003.RE10.V022` at 18:00:35.934. The retained log kept the `0x34` line and not the banner sentence. Boot peak 0.20 dB, no sample above 10 dB.

Hold variant 3 returned `sr=0`. The following op 5 (mode 4, four halves) logged `rxram bytes=0 sr=1`. The HackRF receive over that command peaked at 0.03 dB. A 100 Hz tone then read 7299 on the last 0.4 s, the held level, with the squelch already open from the dummy burst. Variant 3 restore returned `sr=0`, and the next 100 Hz line was 387. A VFO write after that left it at 387. The restore alone is the plain path. SignalDeck can clear the hold with that restore, and it still has to send the hold again after a channel write, because `at1846_tune` writes `0x8405` on its own.

## Writers of AT1846S 0x58

The I²C write is file `+0x54628`. These are the sites that pass register `0x58`, from the C-SKY listing. Callers of `at1846_tune` and of the CTCSS setter were not followed past the function, so this is not a claim that squelch or power-save never reach them.

| File offset | Value | When |
|---|---|---|
| `+0x2C92` | `0x8405` | `at1846_init`, the `0x54`–`0x58` run, before the calibration waits |
| `+0x2E96` | `0xBCFD` | DMR arm of `at1846_tune` |
| `+0x3056` | `0x8405` | FM 12.5 kHz arm of `at1846_tune`. This is the write a VFO change uses, and the one that cleared the hold in R-D |
| `+0x3342` | read, then `& 0xFFF7` | `at1846_set_ctcss_dcs` when the mode byte is 0. Clears bit 3 of whatever was in `0x58` |
| `+0x33BC` | `0x8404` | same setter, mode 1, tone code below 17 |
| `+0x3450` | `0x8405` | same setter, mode 1, code 17 or above |
| `+0x34F4` | `0x8405` | second tone setter, no-tone arm |
| `+0x35C6` | `0x8404` | that setter, tone present |
| `+0x35D6` | `0x8404` | that setter, the other tone-present arm |
| `+0x3642` | `0x8405` | that setter, code 17 or above |

No `0x58` write in the slices sits on the UART, squelch, or PTT path by itself. The writes live in init, tune, and the CTCSS/DCS setter. A channel write is the proven clear. The setter also replaces `0x58`, so SignalDeck re-applies the hold after a channel write and after any CTCSS or DCS programming, not only after a VFO write.

RE10 stays loaded. VFO 467.625 / 467.625 FM at 18:02:46.734. The phone was not keyed.

# R-F — independent equaliser, the dip, POCSAG (2026-10-24, 18:29–18:31)

The pass is not met. Tag `RE10` was already loaded (`0x34` `DMR003.RE10.V022` at 18:29:05). No new image. The phone was not keyed. HackRF FM at 467.625 MHz, amplitude off, finite files, a dummy burst first, Wi-Fi adb `192.168.1.125:5555` only. No `DMRDEBUG.bin`.

The taps are the ±20-symbol filter trained on `re_phone_m17_1.wav` (the R-E loop, `N0CALL` to `@ALL`, frames 0 and 1). A sync-only decode of that clip and of `re_phone_m17_2.wav` is LSF CRC 12/12 and 13/13, Golay 0 24/24 and 25/25. The air clips below do not use that loop.

## Independent M17

Each transmission is a 1.6 s `+3/−3` lead, then a preamble, a link setup, 80 stream frames with random 16-byte payloads, and an EOT. Callsigns are not `N0CALL`. Three recordings per deviation and VGA. The clip is 4.5 s at 8 kHz. Decode uses the fixed taps and the eight sync symbols for the gain. `0x32` is one reading during the clip: dBm = −(120 − raw/2).

| Deviation | VGA | RSSI | Link-setup CRC | Golay 0 |
|---|---|---|---|---|
| ±2.4 kHz | 20 | raw 66, −87.0 dBm | yes, K6M17 → W9LAB | 57/75 |
| ±2.4 kHz | 20 | raw 67, −86.5 | no | 0/1 |
| ±2.4 kHz | 20 | raw 65, −87.5 | yes, W1RF → N2EQ | 46/75 |
| ±2.4 kHz | 10 | raw 54, −93.0 | yes | 46/73 |
| ±2.4 kHz | 10 | raw 54, −93.0 | yes | 12/18 |
| ±2.4 kHz | 10 | raw 56, −92.0 | yes | 57/77 |
| ±2.4 kHz | 0 | raw 41, −99.5 | no | 0/0 |
| ±2.4 kHz | 0 | raw 43, −98.5 | no | 0/0 |
| ±2.4 kHz | 0 | raw 43, −98.5 | no | 0/1 |
| ±1.9 kHz | 20 | raw 66, −87.0 | yes | 59/76 |
| ±1.9 kHz | 20 | raw 65, −87.5 | yes | 56/74 |
| ±1.9 kHz | 20 | raw 65, −87.5 | yes | 49/74 |
| ±1.9 kHz | 10 | raw 53, −93.5 | yes | 46/76 |
| ±1.9 kHz | 10 | raw 53, −93.5 | yes | 47/73 |
| ±1.9 kHz | 10 | raw 53, −93.5 | yes | 51/73 |
| ±1.9 kHz | 0 | raw 43, −98.5 | no | 0/1 |
| ±1.9 kHz | 0 | raw 43, −98.5 | yes | 6/77 |
| ±1.9 kHz | 0 | raw 43, −98.5 | no | 0/0 |

Every Golay 0 frame has the payload that was sent. On the first ±2.4 kHz / VGA 20 clip the frames found are 0 through 74, each once. The 18 misses have LICH Golay sums 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5 and 8. The third VGA 20 clip is the same shape (rms 5717). The second has the same rms (5733) and a best link-setup correlation of 0.924, and the walker does not stay on the stream. The pass was a CRC on every ±2.4 kHz / VGA 20 recording and at least 99 % of stream frames at Golay 0. The best locked recording is 57/75.

Clips: `C:\Users\Joshua\AppData\Local\Temp\fw1718\rf\m17_d2400_v20_0.wav` through `m17_d1900_v0_2.wav`, named `m17_d<deviation>_v<vga>_<0-2>.wav`.

## Where the dip is

Held phone path, variant 3, last 0.4 s of each tone, against the 1 kHz line of 6346. Receive RAM is op 5 mode 4 (the variant-4 register state for the length of the copy), six halves, the first half dropped.

| Hz | Phone | RAM, halves 1–5 |
|---|---|---|
| 400 | −5.8 dB | −0.10 dB |
| 500 | −9.6 dB | −0.23 dB |
| 600 | −6.7 dB | −0.03 dB |
| 700 | −3.7 dB | −0.04 dB |
| 800 | −1.9 dB | +0.08 dB |

The phone recording has the dip. The receive RAM stays within 0.3 dB of 1 kHz from 400 Hz to 800 Hz, so the dip is the ES8311.

## POCSAG

One 1200 baud transmission, deviation ±3500 Hz, RIC 1234567, function 3, text `RF HELD PATH`, four copies, VGA 20, RSSI raw 66 (−87.0 dBm). Plain slicing of the 8 kHz clip: 38 bit errors in 4993 bits, 7 of 156 codewords nonzero, mean 0.24 errors per codeword. The same audio through the M17 matched filter and the 41 taps, sliced at 1200 baud: 6 bit errors in 4987 bits, 3 of 155 codewords nonzero, mean 0.039. Clip: `C:\Users\Joshua\AppData\Local\Temp\fw1718\rf\pocsag.wav`.

## Not in this image

Op 5 still copies the live half first. RE10 was not replaced. The host equaliser was not wired into SignalDeck: the independent recordings miss the pass. Hold was restored (`sr=0`). VFO 467.625 / 467.625 FM at 18:31:55. RE10 stays loaded.


# R-G firmware — stream end, render reply, live half (2026-10-24, 19:01–19:04)

Tag `RG10`. Sha256 `4550a6eb8108f1ed83f396d34b24b6af7a59db521487a0fa2b08e6c47caa6784`. Pushed MD5 `4a9545d5bda949e46ef4c890c58a8449`. The command-slot word is `fc4e0703` at file `0x382B8`. Loaded over RE10. Wi-Fi adb `192.168.1.125:5555` only.

Op 1 is unchanged. Op 7 appends the same way and stores 1 at `0x4B00C`. When that word is set, the read index has caught the write count, and the RRC phase is 0, the wake clears the cursor and calls `drop_ptt`: PTT off, voice bit clear, AT1846S `0x58` = `0x8405`, `0x30` = `0x7026`, mask bit 15 clear, then status byte 4 through file `+0x7E08`. Op 4 accepts at most 240 samples and builds the reply at `0x4AE00`. Op 5 waits through one `FM_ADDR_SW` change and copies from the next one. Nothing in the command keys at boot.

## Load

YModem `onSuccess` at 19:01:55.805. `0x34` `DMR003.RG10.V022` at 19:02:08.580. The retained log kept the `0x34` line and not the banner sentence. Boot peak 0.10 dB, no sample above 10 dB.

## Render, no key

64 samples from a short symbol block. The reply was `render bytes=128 sr=0` at 19:03:57.107. The frame was not built on the stack.

## Receive half

HackRF 1 kHz at 467.625 MHz, VGA 20, deviation 2.5 kHz, op 5 mode 4, six halves. Half ids `1,0,1,0,1,0`. Phase step of a 1 kHz tone across each boundary, in degrees: −0.09, +0.08, +0.02, −0.13, −0.06. The first boundary is included. The line over all six halves is 9221. Capture `C:\Users\Joshua\AppData\Local\Temp\fw1718\rg10\ram1k.bin`.

## One 90-frame key

Low power, 467.625 MHz. The host streamed with op 1 and held PTT for the silence wav, so op 7 was not the path and `drop_ptt` did not run. Underrun 4748 is that tail. Link-setup CRC passes, both callsigns match, 90 payload-exact frames, and one further frame at the tail. Steady p99 from 80 ms through 3600 ms is 2794–2913 Hz. The 60 ms slice is 3134 Hz. The click, 0–40 ms, is about 23 kHz and is not a stop. No modulated slice is at or over 5 kHz. HackRF LNA 16, VGA 16, clip fraction 0.

No `DMRDEBUG.bin`. VFO 467.625 / 467.625 FM at 19:04:17. RG10 stays loaded. The SignalDeck data-receive state and the held-path front end are not in this change.

# R-G host — data-receive hold and the fixed taps (2026-10-24, 19:26–19:30)

No new image. RG10 stayed loaded. Wi-Fi adb `192.168.1.125:5555` only. The phone was not keyed.

SignalDeck sends op 6 variant 3 when M17 starts and `0x34` is a stub tag (`DMR003.XXXX.V022` other than `UV4T`), and sends it again after a channel, VFO or tone write. Stopping M17 sends action 0. The Armor's 41 taps are applied to the matched-filter audio before the sync search, threshold 0.95. The calibrated decision-feedback equalizer remains the plain state.

## Host clips

`HeldPathTest` on the 18 saved R-F clips reproduces the research decoder's stream count and payload-exact count on every clip. Link-setup CRC passes on all 18, with the callsigns that were sent. One −99 dBm clip, `m17_d2400_v0_2`, is 71 of 77. `m17_d2400_v10_1` locks 18 frames, all exact. The other −87 and −93 dBm clips are 98.6 to 100 percent of the frames they lock.

## Device

HackRF transmit, VGA 20, ±2.4 kHz, 467.625 MHz, 30 stream frames. The hold returned `data hold action=1 sr=0`. During the transmission the `0x32` body was `0x41`, −87.5 dBm. The M17 list showed `K6M17 → W9LAB`, 13 frames, 12 clean, and two shorter entries with no callsigns. A second transmission, `W1RF → N2EQ`, with the hold released and the calibrated equalizer selected, did not appear under those callsigns; the list added another `K6M17 → W9LAB`, 12 frames. Raw `0x41` again.

VFO 467.625 / 467.625 FM. M17 was stopped. No `DMRDEBUG.bin`. RG10 stays loaded.

# R-H host — the live receiver (2026-10-24, 20:40–20:41)

No new image. RG10 stayed loaded (`0x34` `DMR003.RG10.V022` at 20:40:41). Wi-Fi adb `192.168.1.125:5555` only. The phone was not keyed. SignalDeck `943e4ec2` was installed with `adb install -r`.

The live receiver searches every sync chain, skips PCM the module is still muting, and opens a contact only from a link-setup CRC or six LICH chunks. It keeps the buffered audio until that call ends, then drops it. Releasing the app's own PTT schedules the voice-filter hold again. `HeldPathTest` feeds each of the 18 saved clips, with 3 s of that clip's muted head in front, in 64 ms blocks, and decodes once while the clip is still arriving: one contact, the callsigns that were sent, and the reference stream-frame count on every clip, including 18 on `m17_d2400_v10_1`. The batch decoder's exact counts are unchanged.

## Device

HackRF transmit, VGA 20, ±2.4 kHz, 467.625 MHz, 30 stream frames, each with a 1.6 s +3/−3 lead. The hold returned `data hold action=1 sr=0`. During each transmission the `0x32` body was `0x43`, −86.5 dBm. The M17 list, and nothing else:

- `K6M17 → W9LAB`, 28 frames, 25 clean
- `W5RF → N6EQ`, 28 frames, 25 clean
- `N5TST → K6DEC`, 27 frames, 23 clean

No listing without callsigns. The third count is 27, one under the 28 bar. The hold was then released (`action=0 sr=0`) and M17 started again on the calibrated equalizer. One more transmission with the same lead listed `W1RF → N2EQ`, 27 frames, 20 clean. The three held listings were still on the list and were not repeated as the new line.

VFO 467.625 / 467.625 FM at 20:41:11. M17 was stopped. No `DMRDEBUG.bin`. RG10 stays loaded.

# FW19 — the 0x3B ceiling (2026-10-24, 21:43–22:47)

Tag `FW19`. Sha256 `555b0128f62116a28496c8e8e3ef8d4277b4fa81d6420a23b4d033102070e52a`. Pushed MD5 `975f16ec0dbe2093f46f046e7b64a082`. Loaded over RG10. The RG10 symbol stub is in the same image. Wi-Fi adb `192.168.1.125:5555` only. HackRF receive only, `-f 467385000 -s 2400000`, finite `-n`.

The `0x3B` handler at file `+0xA308` stores the body byte. When the byte is 0 it clears the enable flag and does not clear the byte. There is no `min(tot, 30)` instruction. The timer at file `+0x1D8` counts 100 wakes per stored unit, and a unit is one second. The stub at file `+0x5B700` (24 bytes, called from the thunk at `+0xAB18`) writes 120 when the byte is 0 or above 120, then calls `+0xA308`. Values 1–120 pass through. `0x3D` and the `0x40` slot are unchanged. Boot peak 0.17 dB, no sample above 10 dB. YModem `onSuccess` at 21:43:41.610. `0x34` `DMR003.FW19.V022` at 21:43:54, 21:45:31, 22:08:09, 22:26:33 and 22:47:06.

## The 45 s stream

1125 stream frames, preamble, one link setup, payload bytes 0–15, no end bit. The host keyed with `engine.ptt(true)` after eight chunks and did not send the unkey. The last chunk was op 7.

First key, low power, HackRF LNA 16 / VGA 16. `sym key` at 21:45:38.009, `sym last op 7` at 21:46:22.720, `sym done` 54075 bytes at 21:46:22.767. Carrier 45.12 s, SNR 68.3 dB, clip 0, offset +1145 Hz. Whole capture: 1124 frames, 1123 payload-exact. A 2 s window at 20–22 s was 49/49. The 1–3 s window locked 2 frames and the 42–44.5 s window locked 3, none payload-exact; those windows missed sync. Status byte 4 (`SEND_STOP`) at 21:46:23.041. The host sent `0x26` body 1 only. Steady body p99 peaked at 2977 Hz. Slices at or over 5 kHz start at 45.06 s and are the drop click (p99 about 22 kHz), which is not a stop. The carrier ends about 60 ms after that click starts.

Second key, the same stream, with the temperature log. Carrier 45.12 s, SNR 67.1 dB, clip 0, body p99 2996 Hz, no body slice at or over 5 kHz. `sym key` at 22:13:11.068, `sym last op 7` at 22:13:55.777, status byte 4 at 22:13:56.099. The frame count was not repeated. A second status byte 4 arrived at 22:15:11 with no new key command.

## 0x58 after PTT

Hold on (mode 3, action 1), then a 1 s silence `txwav`, which unkeys, then 1 s of 100 Hz and 1 s of 1 kHz at −24 dBFS. Carrier 3.11 s, clip 0. The 100 Hz line was 0.12 against the 1 kHz line at 426 (ratio 0.00028, about −71 dB). p99 was 71 Hz on the 100 Hz window and 465 Hz on the 1 kHz window. The hold does not survive the unkey.

## Heat

Battery is `dumpsys battery` temperature in tenths of °C. Zone values below are the rise from that key's before-sample, in °C. `mtktspa` samples of exactly 25.0 °C are dropped. The CPU zone is listed and was not used as a stop: it swung 6.2 °C, then 4.2 °C, during the idle minute. `tzimgs*` and `mtktscharger` read −127 °C.

| Zone | Low 30 s during | Low 30 s after | Low 45 s during | Low 45 s after | High 30 s during | High 30 s after |
|---|---:|---:|---:|---:|---:|---:|
| Battery | +0.1 | +0.2 | +0.1 | +0.5 | +0.3 | +0.6 |
| `mtktsAP` | +0.6 | +1.1 | +0.9 | +3.2 | +1.6 | +3.4 |
| `mtktsbtsmdpa` | +0.4 | +1.0 | +0.7 | +3.1 | +1.2 | +3.3 |
| `mtktsbtsnrpa` | +0.4 | +1.0 | +0.9 | +3.3 | +1.3 | +3.4 |
| `mtktspmic` | +0.2 | +0.2 | +0.6 | +2.4 | +0.6 | +2.5 |
| `mtktswmt` | 0 | 0 | 0 | +2.0 | 0 | +4.0 |
| `mtktspa` (valid) | 0 | +1 | +1 | +4 | — | 55 at the start of the cool-down |
| `mtktscpu` (not a stop) | +1.7 | +2.1 | +8.4 | +9.7 | +1.3 | +2.9 |

The battery is the reading that stays up. It started the low-power pair at 37.4 °C and was 38.2 °C six minutes after the 45 s stream. It started the high-power key at 38.1 °C, reached 38.7 °C, and was 38.6 °C twelve minutes later and again at the check after that. The AP and BTS zones rise during the key and for a few minutes after. A 45 s low-power stream and a 30 s high-power carrier leave them about +3.3 °C. A 30 s low-power carrier leaves them about +1 °C. The battery did not pass 39 °C. No stop-eligible zone rose more than 1 °C inside 10 s during a completed key. One early 30 s attempt was unkeyed at 7 s because a 1.0 °C `mtktspa` step was treated as the stop; a 1.0 °C step is not more than 1 °C, and that key is not the baseline.

Low 30 s carrier: 31.79 s, SNR 69.3 dB, body p99 112 Hz, HackRF LNA 16 / VGA 16, whole-file clip fraction 0.000051, body peak 115 of 127. High 30 s carrier: 31.74 s, SNR 46.0 dB, body p99 199 Hz, LNA 0 / VGA 0, clip 0, body peak 13 of 127. A 2.6 s high-power probe at the same gain was clip 0, peak 14, body p99 105 Hz. The channel write for high power had body byte 1 at the power field. The 45 s and 120 s high-power keys were not run.

## End state

`0x34` `DMR003.FW19.V022` at 22:47:06. VFO 467.625 / 467.625 FM, low power. No `DMRDEBUG.bin`. SignalDeck owns the radio. The bench `eot` extra is the SignalDeck `cmdsym` change committed with this report.

## M17 voice (2026-10-24, 23:21)

No new image. FW19 stayed loaded (`0x34` `DMR003.FW19.V022` at 23:20:59). Wi-Fi adb `192.168.1.125:5555` only. One low-power key, 467.625 MHz. HackRF receive, LNA 16 / VGA 16, finite `-n`, 8 s. The product path ends on op 7, so this key had no extra carrier pad.

SignalDeck Hold-to-talk encodes Codec 2 3200, builds the link setup and stream frames from the M17 specification (the same vectors as `tools/m17-research/m17.py`), and streams symbols on `0x40`. It keys with `0x26` body 1 after eight chunks, because the ring does not drain until the transmitter is up. The last frame carries the end bit. The last chunk is op 7. After status byte 4 it sends `0x26` body 2, so the module timer does not keep running. The boot handshake sends `setTot(120)`.

The bench tone was 1.5 s of 1 kHz at amplitude 8000. `m17 voice key [callsign]` at 23:21:06.130 (`0x26` body 1). Status byte 3 at 23:21:06.143. Last chunk op 7 at 23:21:07.361, 38 Codec 2 payloads logged (frames 0–36 and frame 37 with the end bit). Status byte 4 at 23:21:07.674, 1.54 s after the key. The unkey (`0x26` body 2) followed at 23:21:07.689. A second status byte 4 at 23:21:08.019 is that unkey, not the 120 s timer.

Carrier 1.63 s, SNR 66.7 dB, whole-file clip 0, offset +850 Hz. Body peak 83 of 127, body clip 0. Steady body p99 3206 Hz. No body slice from 80 ms to 400 ms before the drop is at or over 5 kHz.

Our decoder: link setup [callsign] → `@ALL`, CRC ok. Frames 0–35, all 36 payload-exact against the bytes the phone logged. Frame 36 and the end frame were not locked. One false sync at the drop had Golay error 15. Codec 2 decode of the 36 frames (72 Codec 2 frames, 1.44 s) has rms 663 and a peak at 1003 Hz, 1.0×10^5 above the median of 200–3000 Hz.

`mtktsAP` 45.9 °C before the key and 45.6 °C after. Battery zone 37.3 °C. VFO 467.625 / 467.625 FM, low power, at 23:21:17. No `DMRDEBUG.bin`. FW19 stays loaded.

## High power 45 s (2026-10-24, 23:47)

Same 1125-frame file as the low-power streams. FW19 stayed loaded (`0x34` `DMR003.FW19.V022` at 23:47:03). Wi-Fi adb `192.168.1.125:5555` only. VFO 467.625 MHz, power byte 1. HackRF receive, LNA 0 / VGA 0, finite `-n`. The host keyed and did not send the unkey until the heat stop.

`sym key` at 23:47:10.289 (`0x26` body 1). Status byte 3 at 23:47:10.301. Last chunk op 7 at 23:47:55.011. `sym nounkey` at 23:47:55.028. Status byte 4 at 23:47:55.320, 45.03 s after the key. The heat stop sent `0x26` body 2 at 23:47:56.661, 1.3 s after that status byte, so the timer-after-op-7 watch was not run.

The capture is 47.3 s because the stop closed it. Level gate (carrier magnitude about 8, quiet about 2.5): carrier 45.05 s, from 0.85 s to 45.9 s of the file. Whole-file clip 0, peak 13 of 127, body peak 12. Steady body p99 3131 Hz. No body slice from 80 ms to 400 ms before the drop is at or over 5 kHz. At this gain the carrier is about 10 dB over the quiet floor, so a threshold of 20 times the 10th-percentile power does not see it when the carrier fills the file.

Battery (`dumpsys`, tenths) 39.2 °C before the key and 39.5 °C at the last sample, 40.1 °C when read after the capture was measured. `mtktsAP` 48.7 °C before, 51.4 °C at 23:47:54 (+2.7), and 50.8 °C on that later read. `mtktsbtsmdpa` 46.1 to 48.6 (+2.6). `mtktsbtsnrpa` 46.7 to 49.5 (+2.8). From 23:47:44 to 23:47:54, `mtktsAP` rose 1.03 °C. That is the written stop (more than 1 °C inside 10 s). Battery stayed under 45 °C. Neither watched zone reached 60 °C.

The 120 s stream and the 40 s tone were not run in this pass. The heat rule is not rewritten here. VFO returned to 467.625 MHz, low power (power byte 0). No `DMRDEBUG.bin`. FW19 stays loaded.

## High power 120 s, the 40 s tone, and the op-7 timer (2026-10-25, 00:01–00:27)

FW19 stayed loaded (`0x34` `DMR003.FW19.V022` at 23:59:29). Wi-Fi adb `192.168.1.125:5555` only. The 1 °C in 10 s stop was retired. Stops for these keys: battery above 45 °C, `mtktsAP` or `mtktsbtsmdpa` above 60 °C, or more than 2 °C inside 10 s. The ceiling key started with `mtktsAP` at 47.9 °C, within 1 °C of 48.7 °C. HackRF receive used a finite `-n`. At LNA 0 / VGA 0 the carrier is only about 10 dB over the quiet floor, so the carrier bounds are a magnitude gate, not 20 times the 10th-percentile power.

### Ceiling

3250 stream frames, no end bit, power byte 1, HackRF LNA 0 / VGA 0. `sym key` at 23:59:38.666 (`0x26` body 1). Status byte 3 at 23:59:38.678. Status byte 4 at 00:01:38.996, 120.33 s after the key. No status byte 6. Carrier 120.35 s (0.90 s to 121.25 s of the file). Clip 0, peak 11 of 127, body peak 11. Steady body p99 3241 Hz. No body slice from 80 ms to 400 ms before the drop is at or over 5 kHz. The host sent the unkey only after the three-minute log.

`mtktsAP` 47.9 °C before the key, 59.2 °C at the highest sample (about 15 s after the carrier ended), 54.6 °C three minutes later. `mtktsbtsmdpa` 46.3 to 56.8 during the key and 57.1 at its highest just after. `mtktsbtsnrpa` 46.9 to 57.7. Battery 40.2 °C before, 41.4 °C at the end of the key samples, 41.9 °C three minutes later. No stop fired. `mtktsAP` was back within 1 °C of 47.9 °C at about 17 minutes.

### 40 s FM tone

Low power, power byte 0, after that cool-down. HackRF LNA 16 / VGA 16. The bench tone was 40000 ms (`TX 1 kHz test tone 40000 ms`). `0x26` body 1 at 00:22:45.812, status byte 3 at 00:22:45.825, `0x26` body 2 at 00:23:26.213 (40.40 s), status byte 4 at 00:23:26.539 (40.73 s). Carrier 40.75 s. The module did not end it at 30 s. Body p99 2887 Hz. Body peak 102 of 127. The whole-file peak of 127 and the clip fraction 1.1e-6 are the key-up click. `mtktsAP` 49.0 to 50.0 °C. Battery stayed 41.5 °C.

### Timer after op 7

Low power, the same 1125-frame file, last chunk op 7, no unkey until the watch ended. HackRF LNA 16 / VGA 16. `sym key` at 00:24:34.923. Status byte 3 at 00:24:34.935. Op 7 at 00:25:19.638. `sym nounkey` at 00:25:19.655. Status byte 4 at 00:25:19.954, 45.03 s after the key. Carrier 45.05 s, clip 0, body peak 104 of 127, body p99 3040 Hz. The whole-file peak of 121 is the click. The next status byte was 4 again at 00:26:35.260, 120.34 s after the key. No status byte 6, and no status byte 1.

Sixty seconds after the drop, a HackRF carrier at TX VGA 0 (a dummy burst, then 3 s, finite `-n`) left the phone's `0x32` at raw 6 then raw 5, about −117 dBm. The same gain-0 carrier, tried a minute later with the radio idle and unkeyed, moved `0x32` from raw 31 (−104.5 dBm) to raw 47 (−96.5 dBm). During the flagged window the floor was about 12 dB quieter and the weak carrier did not show. No stronger HackRF transmission was used.

### End state

VFO 467.625 / 467.625 FM, low power, power byte 0, at 00:27:01. No `DMRDEBUG.bin`. SignalDeck owns the radio. FW19 stays loaded. The heat rule in `HANDOFF.md` now uses these rises: a 120 s high-power key waits until `mtktsAP` is back within 1 °C of its pre-key value, and the stops are battery 45 °C, the two zones at 60 °C, and more than 2 °C inside 10 s.

## FW20 — the op-7 drop waits, then the stock unkey (2026-10-25, 02:03–02:14)

Low power, 467.625 MHz, power byte 0. HackRF receive LNA 16 / VGA 16. The carrier fills that capture, so the bounds are a magnitude gate (block mean absolute value above 8; the quiet floor is about 1.5 and the carrier about 60), not 20 times the 10th-percentile power. Image sha256 `31ecdd307e1ce33bee588b3abe41ed60793e38d8416da3395a9b305308d28796`, phone md5 `1b47fbe9f83c97da67bb4352c7d2df76`. YModem `onSuccess` at 02:06:03.479. `0x34` `DMR003.FW20.V022` at 02:06:17.049. Boot peak 0.06 dB. It does not key at boot.

The op-7 drain counts eight more TX-RAM half interrupts, calls `drop_ptt` while the timer's TX bits are still set, calls the stock unkey at file `+0xE9C` with the same `r0`/`r1` choice command `0x26` uses, and only then clears bits 0 and 2 of `0x38908` and the count at `0x38C64+2..5`. An earlier image cleared those bits first. On that image a 1125-frame stream was also 1125 of 1125 with the end bit and an EOT score of 1.0, and no timer status arrived inside 130 s, but `0x32` stayed at raw 6 (−117.0 dBm) through a gain-0 carrier and through a later `0x26` body 2. A VFO rewrite brought it back to raw 29–32. That image was replaced. It is not the one left loaded.

### One 1125-frame stream

1125 stream frames, the last with the end bit, then one EOT frame. Last chunk op 7. The host did not unkey. `sym key` at 02:07:29.858. Status byte 3 at 02:07:29.868. Op 7 at 02:08:14.609. Status byte 4 at 02:08:15.175 (45.32 s) and again at 02:08:15.502 (0.33 s later, the stock unkey). Carrier 45.30 s. Body p99 3041 Hz, body peak 106 of 127, body clip 0. No body slice at or over 5 kHz. 1125 of 1125 frames payload-exact. The last frame number is 1124 with the end bit set. The eight-symbol EOT pattern after it scores 0.999. The decode window starts 50 ms into the carrier, so the link-setup CRC is not in that window.

From 02:08:15.502 until 02:10:25 there is no further status byte 4 or 6. The key-on + 120 s mark (02:09:30) is inside that window and is empty. Battery 38.7 °C. `mtktsAP` 45.1 to 46.1 °C. No heat stop.

### Receive after the drop

Before the key, idle `0x32` was raw 31 (−104.5 dBm). The same gain-0 HackRF carrier (dummy lead of 0.25 s, then the carrier, TX VGA 0, finite `-n`) moved it to raw 47 (−96.5 dBm). A query 0.15 s after the first status byte 4 still read raw 6: that query went out before the stock unkey had returned. The same carrier, read at 2.88 s, was raw 47 again. The squelch opened at 02:08:17.777 (status byte 1, 2.60 s after the first status byte 4) and closed at 02:08:20.292 (status byte 2). No stronger HackRF transmission was used. The phone was not keyed while the HackRF transmitted.

### Second stream

After the first drop, 10 s later, a 1750-frame stream with the end bit and one EOT frame. First key 02:10:33.422, status byte 4 at 02:11:18.739 (45.32 s) and at 02:11:19.063. Second key 02:11:29.324, op 7 at 02:12:39.094, status byte 4 at 02:12:39.638 (70.30 s). A stale 120 s timer from the first key would have fired at 02:12:33, about 64 s into the second key. It did not. Magnitude gate: first carrier 45.35 s, second carrier 70.35 s, gap 10.5 s. Steady p99 3018 Hz on the first and 3074 Hz and 3032 Hz on the second. Those slices peak at 104–105 of 127, clip 0. One 50 ms block on the first carrier reaches 127; that is the key click. Battery 38.6 to 38.8 °C. `mtktsAP` 45.7 to 49.0 °C. `mtktsbtsmdpa` 44.9 to 47.7 °C. No stop.

### End state

`0x34` `DMR003.FW20.V022` at 02:14:05. `0x32` raw 31, 30 and 32 (−104.5 to −104.0 dBm). VFO 467.625 / 467.625 FM, low power, power byte 0, at 02:12:59. No `DMRDEBUG.bin`. SignalDeck owns the radio. FW20 stays loaded.

## Spoken microphone check on FW20 (2026-10-25, 02:43)

FW20 stayed loaded (`0x34` `DMR003.FW20.V022`). Low power, 467.625 MHz, power byte 0. HackRF receive LNA 16 / VGA 16. This is the microphone path, not the tone extra. The hold was 10 s. A spoken clip played on the handset alarm stream during the hold, so the microphone had speech. An earlier hold with nothing playing decoded as silence (Codec 2 peak 49 of 32767) and is not this check.

Carrier 10.30 s (1.35 s to 11.65 s of the file). Steady body p99 2947 Hz. No steady slice at or over 5 kHz. 247 of 247 frames, numbers 0 through 246, the last with the end bit set. Link-setup CRC ok. The eight-symbol EOT pattern scores 0.978.

`m17 mic` at 02:43:42.336. Key at 02:43:42.731. Status byte 3 at 02:43:42.743. Op 7 at 02:43:52.438 (247 frames). Status byte 4 at 02:43:52.977. The host unkey (`0x26` body 2, `sym unkey`) at 02:43:52.990, 13 ms after that status byte. Status byte 4 again at 02:43:53.301, the stock unkey, 0.32 s after the drop. No other status byte between them.

Codec 2 decode of those 247 frames is 9.88 s, 8 kHz, peak 15873 of 32767, rms about 1287. A Windows dictation pass on that wav returned a short phrase and did not recover the scripted sentence. The audio is speech, not silence. Battery 37.3 °C and `mtktsAP` 45.4 °C before the key. No heat stop.

### End state

`0x34` `DMR003.FW20.V022`. `0x32` raw 30 and 31. VFO 467.625 / 467.625 FM, low power. No `DMRDEBUG.bin`. SignalDeck owns the radio. FW20 stays loaded.

## FW21 — generic waveform engines (2026-10-25, 08:57–09:12)

Low power, 467.625 MHz, power byte 0. HackRF receive LNA 16 / VGA 16 for every key, LNA 24 / VGA 38 for the boot capture. Magnitude gate: a 10 ms block whose mean absolute value is above 8. Body p99 drops the first and last 50 ms. Image sha256 `f726056aa3e62db4399d45ee6cf5df4e29756083761c1651ce734d4c08d477ed`, phone md5 `cd252c1086e01c581867bec96e8a5184`. YModem `onSuccess` at 08:57:04.819. `0x34` `DMR003.FW21.V022` at 08:57:18.877, and again at 09:10:30 before the long stream. Boot peak 0.08 dB. It does not key at boot.

The sine table is in flash. A load of its link address (`0x5BC64`) never returns; the stock image addresses its own flash as `0x0301A000` plus the file offset, and this image does the same (`0x03075C64`). The sample is sign-extended (`ld.hs`). The phase remainder and the frequency are uint16 and are zero-extended (`ld.h`); sign-extending them walks the phase off once the remainder passes 32767. An earlier image (sha256 `2392c912f78ccd8092109490d66647391a4ad306c281a8731d3998d106471043`) hung the `0x40` handler on a tone render. It was replaced. It is not the one left loaded.

`on_key` enters the TX-RAM path only when the symbol ring is not empty. A tone queue with an empty ring keys the stock analog carrier and does not play the queue (measured: no 700 Hz line, body p99 633 Hz). One dummy symbol after op 11 arms the TX-RAM path. The tone engine then ignores that symbol.

### Renders, no key

Hold, op 8, shaping 0, advance 3/20, levels ±4000. Op 4 of 128 samples returned `sr=0`, 19 sign changes, runs of 7. The 1 kHz queue (8000 eighths, amplitude 4000) returned 32 of 32 samples: 2828, 3999, 2828, 0, −2829, −4000, −2829, 0, and the same eight again. Op 3 and then 32 samples were all zero. A 700 Hz queue (5600 eighths, amplitude 4000) returned 64 of 64 samples, first 2056, 3527, 3989, 3270, 1530, −587, −2538, −3798.

### POCSAG 1200

One batch, RIC 1234567, function 3, text `HI`, then 0.5 s of zero-count samples. Our decoder, both polarities. `multimon-ng` is not installed.

±7600 counts, the lower amplitude, aimed at ±3.5 kHz. Key 09:03:26. Carrier 2.73 s. Body p99 4061 Hz, body peak 61 of 127, clip 0. 16 of 16 codewords, page `HI`.

±8400 counts, scaled from that p99 toward ±4.5 kHz. Key 09:04:16. Carrier 2.80 s. Body p99 4138 Hz, body peak 72, clip 0. 16 of 16 codewords, page `HI`. The air compressed: 1.105 times the count moved the p99 by 1.019. It did not reach 4.5 kHz and it did not reach 5 kHz. No third, hotter key.

Battery 36.7 °C. `mtktsAP` 42.9 to 43.7 °C. `mtktsbtsmdpa` 41.7 to 42.0 °C.

### MCW, 700 Hz, 20 words per minute

The letters `HI`. Dit 60 ms, letter gap 180 ms, amplitude 4000. Op 11, so the module dropped the carrier. A leading 150 ms of silence covers the half filled at key-up. Key 09:07:38. Carrier 1.34 s. Body p99 2021 Hz, body peak 57, clip 0. The 700 Hz envelope, with tone blips shorter than a dit removed, is off 200 ms, then 60/60 four times, off 180, 60/60 twice, off 450. That is `HI`.

### M17 after op 3

`cmdsym` sends op 3 before the symbols. Ninety stream frames, the last with the end bit, one EOT frame, last chunk op 7. Carrier 3.91 s. Body p99 2905 Hz, body peak 58, clip 0. 90 of 90 payload-exact. Last frame number 32857, which is 89 with the end bit set. EOT score 1.0.

### The 1125-frame stream

Same shape as the FW20 stream. `0x34` was still `DMR003.FW21.V022`. Carrier 45.31 s. Body p99 2939 Hz (the frame judge's slices peak at 2959). Body peak 74, clip 0. 1125 of 1125 payload-exact. Last frame number 33892, which is 1124 with the end bit set. EOT score 1.0. Battery 36.8 to 36.9 °C. `mtktsAP` 43.0 to 44.3 °C. `mtktsbtsmdpa` 41.8 to 42.9 °C. No 10 s step was over 2 °C. No stop.

### RTTY, 45.45 baud, 170 Hz shift

Mark 1000 Hz, space 1170 Hz, bit 22 ms, stop 33 ms. Letters shift, then `H` and `I`, with 800 ms of mark first. Amplitude 4000. Op 11. One symbol left in the ring so the key takes the TX-RAM path. The mark render matched 64 of 64 samples before the key. Key 09:17:13. Carrier 1.89 s. Body p99 2081 Hz, body peak 63, clip 0. SignalDeck's `Rtty` decoder on the 8 kHz clip: locked, mark 1000 Hz, text `HI`. Battery 36.9 to 37.0 °C. `mtktsAP` 43.3 to 43.7 °C.

### FT8

`CQ N0CALL FN20` packed by SignalDeck's `Ft8Message`. That packer unpacks it as `CQ N0CALL`. 79 tones of 160 ms at 1000 Hz plus 6.25 Hz steps, tone 0 first in the Costas block, 0.5 s of silence ahead of them. A render 18.75 Hz above 1 kHz matched 64 of 64 samples. The queue holds 64 pairs, so 60 went out before the key and the other 20 at 6 s, as op 11. Key 09:19:36. Carrier 13.35 s. Body p99 2101 Hz, body peak 73, clip 0. SignalDeck's `Ft8.decode` on the 8 kHz clip: `CQ N0CALL` at 1000 Hz, dt +0.4 s, about −8 dB. Battery 36.9 to 37.0 °C. `mtktsAP` 43.5 to 43.7 °C. `mtktsbtsmdpa` 42.1 to 42.3 °C. No stop.

### End state

`0x34` `DMR003.FW21.V022`. VFO 467.625 / 467.625 FM, low power, power byte 0. No `DMRDEBUG.bin`. SignalDeck owns the radio. FW21 stays loaded. Not keyed.

## FW22 — tone-queue key and flash read (2026-10-25, 09:39–09:59)

Low power, 467.625 MHz, power byte 0. HackRF receive LNA 16 / VGA 16 for the keys, LNA 24 / VGA 38 for the boot. Image sha256 `38f900a0df169c0101f9e6183fe8ec8d2e9cdca74169f034f5571b04aa988d6a`, phone md5 `a78a39979b1705e68c1e730e5c3a7c54`. YModem `onSuccess` at 09:39:20.931. `0x34` `DMR003.FW22.V022` at 09:39:34.861 and again at 09:57:37. Boot peak 0.09 dB.

`on_key` arms the TX-RAM path when the symbol ring has symbols, or when the mode word is the tone magic and the queue count or the samples still to play are not zero. The mode word is required so a leftover RAM value cannot divert an analog key. Opcode 12 takes a little-endian file offset and a length of 1 to 240 and replies with those bytes of the image. The frame pointer is read before the handler pushes, because the push moves the stack.

An earlier image, sha256 `8bbd61fa4bbe31cae2d18ec44e93c654e371dbeaaf43cf94c1c745dd9d6ea708`, played the empty-ring tone and then answered opcode 12 with `sr=1`. The read loaded the frame pointer after the push. It was replaced.

### Empty ring, 700 Hz

Op 3, then op 11: 400 ms at 700 Hz, amplitude 4000, then 200 ms of silence. No symbol was written. Key 09:57:25. Carrier 0.80 s. Body p99 2060 Hz. The audio peak is 700 Hz.

### Flash read

Opcode 12, 240 bytes at a time, 1578 reads. All 378620 bytes matched the file that was loaded, in 971 s. The first reply was the tag `DMR003.FW22.V022`.

### 1125-frame stream

Same stream as FW21. Carrier 45.31 s. Body p99 2953 Hz (the frame judge's slices peak at 3020). Body peak 64, clip 0. 1125 of 1125 payload-exact. Last frame number 33892, which is 1124 with the end bit set. EOT score 1.0. Battery 38.3 to 38.4 °C. `mtktsAP` 47.1 to 47.5 °C. `mtktsbtsmdpa` 45.8 to 46.1 °C. The zones were already warm from the read-back. No 10 s step was over 2 °C. No stop.

### End state

`0x34` `DMR003.FW22.V022`. VFO 467.625 / 467.625 FM, low power, power byte 0. No `DMRDEBUG.bin`. SignalDeck owns the radio. FW22 stays loaded. Not keyed.

# Phase E step 1 — SignalDeck YModem sender (2026-10-25, 13:12–13:33)

Wi-Fi adb `192.168.1.125:5555` only. SignalDeck `4fc1989d`. The five loads below used DIAG `fwload` only. `fwload_stock.sh` was used once, before those loads, to put FW22 back after an earlier sender was cancelled at block 5. That cancel was the intercom page writing command `0x32` onto the port during the transfer. The sender now holds ordinary commands, including the signal poll and the module watchdog, until the load finishes. Host `YModemSenderTest` passed before the device runs.

Image files: FW22 sha256 `38f900a0df169c0101f9e6183fe8ec8d2e9cdca74169f034f5571b04aa988d6a`, phone md5 `a78a39979b1705e68c1e730e5c3a7c54`. Factory md5 `4426035392262ca54583c230c9e268e0`. Both are 378620 bytes, 370 data blocks.

Every successful load: the first knock got `C` in 203 or 204 ms. The header was acknowledged about 11.4 s later. Each data block was acknowledged in 288–292 ms. The sender waits 300 ms and drains the port before each data block. From the prompt `C` to the tag was about 248 s.

### (a) FW22 over itself

`fwload ok(DMR003.FW22.V022)` at 13:16:59. Prompt `C` at 13:12:51.539. Opcode 12 of the first 4096 bytes matched the file (240-byte reads, then 16). Boot capture, HackRF LNA 24 / VGA 38, started before the knock: peak 0.09 dB.

### (b) Factory image

`fwload ok(DMR003.UV4T.V022)` at 13:22:03. VFO 467.625 / 467.625 FM, power byte 0. One `testtone --ez lift --ei ms 10000`. Before the key, battery 36.1 °C and `mtktsAP` 49.0 °C. Carrier 10.76 s. Body p99 2790 Hz. The audio peak is 1000 Hz. No slice at or over 5 kHz. No stop.

### (c) FW22 again

`fwload ok(DMR003.FW22.V022)` at 13:26:49. Boot capture, same gains: peak 0.08 dB.

### (d) Abort, then a full load

`fwload --ez abort50` closed the port after block 185 of 370 at 13:29:03. The next `fwload` of FW22 knocked once, got `C` in 204 ms (13:29:08), and finished `fwload ok(DMR003.FW22.V022)` at 13:33:15.

### (e) Boots

The captures in (a) and (c) stayed under 0.1 dB. Nothing was at the 10 dB stop.

### End state

`0x34` `DMR003.FW22.V022`. VFO 467.625 / 467.625 FM, low power. No `DMRDEBUG.bin`. SignalDeck owns the radio. FW22 stays loaded.

# Phase E step 2 — firmware page pass (2026-10-25, 14:20–15:10)

Wi-Fi adb `192.168.1.125:5555` only. SignalDeck `16ff14bc`, the release build already on the phone. Every load below was started from the Module firmware page (image button, Load, confirm Load), except the wrong-tag drill, which is DIAG `fwbadtag` because the page button for that drill was removed. `fwload_stock.sh` was not used. HackRF receive only, 467.385 MHz, 2.4 MS/s, LNA 24, VGA 38. Battery stayed 95–99% and 37.1–37.6 °C, on battery, which passes the above-60% rule. `mtktsAP` stayed at or under 44.7 °C and `mtktsbtsmdpa` at or under 43.0 °C. No heat stop.

Screenshots: `C:\Users\Joshua\AppData\Local\Temp\fw1718\shots\`.

### (a) FW22 over itself

Pre-flight all green, installed tag `DMR003.FW22.V022`, image hash `38f900a0df16`, factory backup "stock app". Confirm asked for `DMR003.FW22.V022`. The bar showed Erasing with "10 s left in this phase", Prepare, Update and Hello already lit (`a-erasing.png`, 14:20). Transfer then showed `45 / 370 blocks`, 46,080 bytes, 1129 B/s, 0:40 elapsed, 3:11 left, 0 retries (`a-transfer.png`). Result at 14:25:03, 258.9 s: `DMR003.FW22.V022 · flash sample matched`. Boot capture `page_boot_a`: peak 0.09 dB, clip 0, no run at or above 10 dB. During this load `dumpsys notification --noredact` had `android.text` "Radio busy, loading firmware".

### (b) Factory image

Chosen hash `90e361fda108`. Block 370 was on screen at about 240 s. The page result, read once the screen was idle, was `DMR003.UV4T.V022` (14:32:43). The factory row does not append the flash-sample line.

### (c) FW22 again

Same page path. Result at 14:37:39, 259.0 s: `DMR003.FW22.V022 · flash sample matched`. Boot capture `page_boot_c`: peak 0.09 dB, clip 0, no run at or above 10 dB.

### (d) Stop near halfway, then a full load

The first Stop tap used a point recorded before the confirm card closed (872, 1549). The Stop label was at 911, 2129, so that load ran through and is not the abort proof. The retry tapped the Stop label at block 175. Result at 14:47:51, 127.3 s: `aborted(stopped after block 179)`. The following full load from the page finished at 14:52:42, 254.2 s: `DMR003.FW22.V022 · flash sample matched`. On the wrong-tag drill that followed, data-block acks were 289–290 ms.

### Altered file hash

`FW22.bin` in `Download/DMR/Firmware/` had one byte flipped. The page's pre-flight turned two lines red: Image hash "The file does not match the known image", and This phone with the same sentence (`altered-preflight.png` was captured; the on-screen checks are also in the log at 14:53:36). Load returned in 17.9 s: `That image is not in Download/DMR/Firmware`. The good file was copied back. Its sha256 is again `38f900a0df169c0101f9e6183fe8ec8d2e9cdca74169f034f5571b04aa988d6a`.

### Stock app removed, no verified copy

`pm uninstall --user 0 com.pri.prizeinterphone` returned Success, and `pm path` was empty. The private factory file and the Download factory copies were moved aside. FW22.bin stayed. The page (`stock-removed-preflight.png`, 15:02) showed the factory backup "Not verified yet. The stock app's copy could not be read." and two red lines: Factory backup "Missing or it does not match", and This phone "The stock app is gone and there is no verified factory copy on this phone". The other checks stayed green, including the FW22 hash. `cmd package install-existing com.pri.prizeinterphone` put the package back (`package:/system/priv-app/PriInterPhone/PriInterPhone.apk`). That re-enabled the stock app, so SignalDeck was started again and the stock app was paused with `pm disable-user --user 0`, the same command SignalDeck uses when it takes the radio. The page then showed the backup "Verified · stock app", installed `DMR003.UV4T.V022`, and all seven checks green (`stock-restored-preflight.png`, 15:07).

### Wrong-tag drill

DIAG `fwbadtag` loaded FW22 (block 370/370) and then the factory image (block 370/370). At 15:02:12, 504 s from the start: `fwbadtag done Restored the factory image (DMR003.UV4T.V022) because the tag did not match`. The page after that showed the factory tag installed.

### Help, read against the page

Device → Help, search `twelve`, opens Device · Radio firmware (`help2-search.png`, `help-topic-1.png`, `help-topic-2.png`, 15:09–15:10). The section matches the page this pass used. It names the seven pre-flight checks, the bar Prepare / Update / Hello / Erasing / Transfer / Finish / Restart / Verify, Erasing filling over about twelve seconds, Transfer filling as each block is accepted, and the figures under the bar. Load (a) showed Erasing with about 10 s left in that phase, then Transfer counts, bytes, rate, elapsed, time left and retries. It says that while a load runs the intercom, SignalDeck Web and Android Auto say the radio is busy loading firmware and Talk does nothing; the notification during load (a) carried that sentence. It says a tag that does not match restores the factory image, which is what `fwbadtag` did. It says a different stock-app version is only a warning when the file matches; this phone's stock app stayed the recorded version, so that line did not appear. It says an image stays until another one is loaded, including after a reboot, and that the page does not change bands or power.

### End state

Installed tag `DMR003.UV4T.V022`, the factory image the wrong-tag drill restored. Factory backup verified from the stock app. Stock app paused. SignalDeck owns the radio. Battery 95%. No `DMRDEBUG.bin`. The signed catalogue was not built in this pass.

# Phase E catalogue and the block pause (2026-10-25, 15:29–15:45)

SignalDeck `7b3ded47` fetches the signed catalogue with the profile-list key. On the phone, DIAG `fwcatalog` returned `Firmware catalogue 3 loaded: 1 image` at 15:29:35. That image is the factory row. Host `FirmwareCatalogTest` verified the published file, rejected a bad signature, and rejected an older serial. Download factory image is on the page when the backup is not verified. The backup on this phone was already verified, so the button stayed hidden.

The per-block pause was measured with DIAG `fwload --ei pause` of `Download/DMR/Firmware/FW22.bin`, three loads at 0 ms and three at 50 ms. Every load returned `ok(DMR003.FW22.V022)`.

| Pause | Times |
|---|---|
| 0 ms | 147.9 s, 147.8 s, 147.6 s |
| 50 ms | 160.1 s, 160.3 s, 160.0 s |

0 ms is the smallest pause that passed. The page now waits 0 ms and estimates the remaining time from the measured block time. The module was left on `DMR003.FW22.V022`.

### End state

Installed tag `DMR003.FW22.V022`. Factory backup still verified. Stock app paused. SignalDeck owns the radio. No `DMRDEBUG.bin`. The unlisted-images switch is the next sub-step.

# Phase E — Allow unlisted images (2026-10-25, 16:09–16:31)

SignalDeck `9e58dbbf`. Wi-Fi adb `192.168.1.125:5555` only. The release build was installed with `adb install -r` after the wrong-tag drill and before the backup-absent check. `fwload_stock.sh` was not used. No HackRF capture: this step does not key. The bench file was a copy of the factory image, 378620 bytes, with the 16-byte version string at `0x38464` set to `DMR003.UNL1.V022`. sha256 `28950e2123f225778e83b2e8336d6db318952250c13605da3a86d7e3d85b587e`. It was placed at `Download/DMR/Firmware/UNL1.bin` and removed at the end. It is not a catalogue image and it is not in AndroidRadio_Firmware_Project.

### Switch off, then a refusal

At 16:09 the Advanced button read `Allow unlisted images · off`. Selecting `DMR003.UNL1.V022` and confirming Load returned in 12.4 s: `That file is not a known module image`. No transfer started.

### Load after the hash is typed

The switch was confirmed twice (`Allow unlisted images? (1 of 2)`, then `Your decision (2 of 2)`). The first eight characters `28950e21` were typed. At 16:12:05 the module reported `DMR003.UNL1.V022` and RadioService logged `unlisted image 28950e2123f225778e83b2e8336d6db318952250c13605da3a86d7e3d85b587e`. The preference `firmware` / `unlisted` was `false` after that load. The page at 16:21 still showed `Allow unlisted images · off`, installed `DMR003.UV4T.V022` (the factory image had been put back before that screenshot), and the factory backup `Verified · stock app`.

### Wrong tag restores the factory image

The module was on the factory image. DIAG `fwunlistedbad` at 16:16 passed every pre-flight check (module `DMR003.UV4T.V022`, idle, stock app paused, battery 90% on battery, hash `28950e2123f2`, factory backup from the stock app). The transfer read back `ok(DMR003.UNL1.V022)` in 137 s at 16:18:33. The drill then treated the tag as `DMR003.NOPE.V022` and restored the factory image: `ok(DMR003.UV4T.V022)` in 138 s at 16:20:51. The finished line was `Restored the factory image (DMR003.UV4T.V022) because the tag did not match`.

### No factory backup, switch on

The private factory copy and the Download factory files were moved aside, and `pm uninstall --user 0 com.pri.prizeinterphone` returned Success. The switch was turned on, `28950e21` was typed, and Load was confirmed. The page (`unlisted-no-backup.png`, 16:23) showed the switch still on, the bar still on Prepare, Factory backup in red (`Missing or it does not match`), and This phone in red (`Load the factory backup onto this phone before any other image`). The result line was `Missing or it does not match`. Logcat had no knock and no transfer. `cmd package install-existing` put the stock app back, which re-enables it, and `pm disable-user --user 0` paused it again. The page then showed installed `DMR003.UV4T.V022`, factory backup `Verified · stock app`, and the stock app paused (`unlisted-restored.png`). A refusal does not clear the switch, so it was turned off again. The preference read `false` at the end.

### Help

Device → Help & how-to, search `unlisted`, opens Device · Radio firmware (`unlisted-help-search.png`, `unlisted-help-sentence.png`, 16:30–16:31). The section says the switch is off until it is confirmed twice, the file comes from Download/DMR/Firmware, the first eight characters of the hash are typed, the factory backup has to be on the phone, the catalogue and the project do not cover the file, the switch turns off after the load, a version string that does not match restores the factory image, and Restore factory still loads that image when the backup is verified even if the module is reporting the unlisted version.

Host `ImageTableTest` passed, including the case that a verified factory backup may restore the factory image when the running tag is not in the table, and that any other image is still refused on that tag.

### End state

Installed tag `DMR003.UV4T.V022`. Factory backup verified from the stock app. Stock app paused (`pm list packages -d` lists `com.pri.prizeinterphone`). Allow unlisted images is off. `UNL1.bin` is not in Download/DMR/Firmware. SignalDeck owns the radio. Battery 89–90%. No `DMRDEBUG.bin`. Next is route-list item 7 (the receive self-calibration reading) and item 6 once the contact callsign work it depends on is in. FW21 and FW22 stay unlisted in the public catalogue until their builds are reproducible. Only stock and released images go in AndroidRadio_Firmware_Project.

# Item 7 reading — what drives the phone's receive input (2026-10-25)

No image was built. The phone was not used: it is leased for the contacts check. The question is which converter's analog output reaches the phone's ES8311 input while the radio is receiving, whether the AT1846S audio pin and the HR-C7000 DAC share that input, and which register or RAM a later `0x40` op can play a known waveform into without keying.

## The phone side

The converter into the phone is the Everest ES8311 at I²C `7-0018`. tinyserver takes receive audio from I2S2 (`UL2_CH1` ↔ `I2S2_CH1`) at 8 kHz (`es8311_pcm_hw_params`, MCLK 1.024 MHz). Transmit PCM leaves on I2S1. The speaker amplifier `aw883xx` is a different path. Chapter 19 §19–§20. So "the ES8311 input" is the codec's analog microphone pin. There is one such input on this link.

## Analog receive is the AT1846S audio pin

Three measurements already separate that pin from the HR-C7000's own converters:

- AT1846S register `0x58` is in the phone's receive audio. The FM tune writes `0x8405` at file `+0x3052` (voice high-pass, emphasis, voice low-pass and the CTCSS filter all on) and the DMR tune writes `0xBCFD` at `+0x2E92` (those filters bypassed). `at1846_tune` is `+0x2DD8`. R-D: op 6 variant 3 (`0x58` = `0xBCFD` alone) flattens the phone path (100 Hz +1.2 dB against 1 kHz). Variant 4 adds the C7000 `FM_BANDWIDTH` bypass and is the same curve. The C7000 FM filters are not in the phone path. The whole analog cut the phone hears is the AT1846S.
- The HR-C7000 codec ADC is not in that path. UVm10 lowered `GCR_ADCL` (codec base `0x16000900` + `0xE5`, which is `0x160009C0` + `0x25`). Open-squelch receive on 467.625 MHz was −15.55 dBFS against −15.61 dBFS on the factory image, **+0.06 dB**. A 6 dB drop would have meant the codec ADC sat between the AT1846S and the phone.
- The same codec's DAC gain is not in the radiated transmit path (UVm11, all ten `GCR_DACL` slots). That result does not by itself say where the DAC's lineout goes on receive.

## What the user guide says the DAC plays

Document 2, chapter 6 and §7. The codec DAC output is two single-ended lineouts of one PWM (`DO_LO_PWM`, `CR_DAC` bit 0 `dac_zero_n` at `0x160009CD[0]`: 0 = pin active, 1 = clamped). Both of these playback sources are specified to feed that DAC, and no CPU copy is required for the analog one:

- Analog FM receive (§7.2.2.2, page 271): the modem FM demod goes to the codec DAC when `0x11000080[0]` = 0, `0x11000100[7]` = 1, and the DAC interface is on (`0x160009C8[4]` = 0, master, parallel PCM). The same demod is what RX RAM saves at `0x160004E0`–`0x160008DF` (§7.2.2.3.2). RX RAM includes `FM_BANDWIDTH`. The phone audio does not. So the phone is not listening to this DAC feed.
- DMR receive (§7.1.2.2, page 270): vocoder PCM, 160 bytes / 10 ms, sits at `0x180000A0`–`0x18000140`. The codec reads it over AHB and raises irq 27. The CPU refills the buffer and clears the flag with `0x110003B0` bit 5. That is the only documented way decoded DMR voice leaves the chip. The phone does play DMR voice, and the only ADC into the phone is the ES8311, so this lineout reaches that same microphone input.

The boot codec init at file `+0x647C` (one caller, `+0xDE4`) already turns that playback path on. From base `0x16000900` it stores `AICR_ADC` (`+0xC9`) = `0xC0`, `AICR_DAC` (`+0xC8`) = `0xC0` (24-bit, master, parallel, and bit 4 clear so `SB_AICR_DAC` is active), `GCR_DACL` (`+0xDF`) = `0xAB`, `GCR_ADCL` (`+0xE5`) = `0x8B`, and it clears `CR_DAC` (`+0xCD`) bits 4 and 7 (`SB_DAC` active, soft mute off) and the same two bits of `CR_ADC` (`+0xCF`). The guide's speaker gate, separate from the AT1846S pin, is `STANDBY_LO` at `0x11000088[31]` (page 249). No register in this image was found that selects the AT1846S pin or the lineout as the ES8311's source. They meet off-chip.

## Both sources, one ES8311 input

Analog receive at the phone is the AT1846S audio pin, after `0x58`, and not the modem demod that fills RX RAM. DMR voice can leave only through the codec DAC lineout, and it is heard on the phone, so that lineout reaches the same ES8311 input. The two converters share the input. They are not the same signal: a sweep played from the DAC does not pass through `0x58`, and a tone received over the air does not pass through `GCR_DACL`.

## The idle playback path, and the op

Nothing in the AT1846S programming this image uses will play an arbitrary 50 Hz–3.8 kHz waveform out of the audio pin without RF. The CTCSS generator (`at1846_set_ctcss_dcs` at `+0x32E4`, the 50-entry table at `+0x366B2`, 67.0–254.1 Hz) is sub-audible and is not that sweep. The codec DAC buffer is the path that can.

Proposed `0x40` opcode **13** (12 is FW22's flash read). It does not set PTT (`0x11000560` stays 0) and does not write AT1846S `0x30`. It keeps the DAC up the way `+0x647C` does (`0x160009C8` = `0xC0`, `0x160009CD` bits 4 and 7 clear, `0x160009D2` bits 0 and 1 clear). The host sends 8 kHz 16-bit PCM, at most the ±3-symbol level used on the air. The stub refills `0x180000A0`–`0x1800013F` on irq 27 for 3 s, the same slot the vocoder uses, and does not run the vocoder. Squelch stays closed so the AT1846S pin is quiet if the chip mutes it; the op does not retune and does not key. SignalDeck records I2S2 as it does for a normal reception.

The bench then compares that recording with the held-path tone table (R-D/R-E). Agreement within 1 dB and 0.2 symbols from 100 Hz to 3.5 kHz would mean the lineout and the AT1846S pin really are one input and the AT1846S contribution was quiet. A curve that is only the ES8311's 500 Hz dip, or silence, means the DAC is not the analog leg the equalizer is fitting, and opcode 13 cannot replace an over-the-air calibration. The fallback in the route list stands for that case: train on a real M17 reception. No image is loaded until that reading is accepted.

# FW23 — opcode 13 idle playback (2026-10-25, 17:14–17:22)

FW23 is FW22 plus opcode 13. The 3 s waveform is synthesized in the module: 200 ms at 1 kHz, then a linear chirp from 50 Hz to 3799 Hz, peak about ±8192, written 80 samples at a time to `0x180000A0` with a 10 ms wait and irq 27 cleared (`0x110003B0` bit 5). The stub sets the DAC the way boot does and does not store PTT or AT1846S `0x30`. Host `test_fw23` : 3 tests, the 1 kHz cycle is 8 samples and the chirp ends at 3799 Hz. Image sha256 `d880d6e52583838280939aaaab3dcac39e4aa4614ac1550716699adac6c3132a`, 378620 bytes. Loaded with DIAG `fwload --ei pause 0`. `fwload ok(DMR003.FW23.V022)` at 17:19:03. The boot capture was missed: the watcher did not see the verify line before the restart at 17:18:56.

Two playbacks, each acked `RX cmd=0x40 rw=0 sr=0 len=0` about 4 s after the command. No `0x26` and no `0x36`. HackRF receive only, 467.385 MHz, 2.4 MS/s, LNA 24, VGA 38, 20 s.

| Run | Squelch | HackRF peak | Clip | Phone recording |
|---|---|---|---|---|
| 17:19:44 | closed (the channel's) | 0.085 dB | 0 | peak sample ±6, −88 dBFS, no tone |
| 17:21:38 | opened with command `0x30` body 0, acked `sr=0` | 0.056 dB | 0 | −27 dBFS the whole 8 s, peak frequency wandering, no 1 kHz line |

The open-squelch recording is receiver noise at one level before, during and after the 3 s. The buffer write is not reaching the phone. **Decision (c):** opcode 13, as built, is the wrong leg. Item 7 falls back to training on a real reception. The 1125-frame stream was not re-run: ops 0–7 were not edited, and the playback result was already (c). Squelch was put back to body 2 afterwards.

### End state

`0x34` `DMR003.FW23.V022`. No `DMRDEBUG.bin`. SignalDeck owns the radio. Stock app was paused at the start of the step and was not changed. VFO was not moved. The 1125-frame check and a HackRF tone through the phone path were not run.

# FW24 — opcode 13 on a DMR channel, then with the speaker gate (2026-10-25, 17:36–18:13)

The review asked for the same playback on a DMR channel, then on analog with `STANDBY_LO` bit 31 cleared and the DAC interface on. Host `test_fw23`: 3 tests. The image that stays loaded is `DMR003.FW24.V022`, sha256 `0afc3d80f90f2bbdb39ffe9a8a45afdb14fb6f1169ba62629fa7bf4d4216b2fc`, 378620 bytes. Opcode 13 with a one-byte body is the FW23 playback. A second body byte of 1 is the gate. The reply is 24 bytes: `0x11000080` and `0x11000100` at the end of the 3 s, `STANDBY_LO` before and after, and the three codec bytes before and after. The top byte of the last word is a flag: bit 0 the first demod register changed, bit 1 the second, bit 2 the speaker-gate word did not read back. Those two demod registers are only loaded.

An earlier FW24 build (sha256 `43d664c3414da94e6c363ea88cd77b28db2a69f4bad45ebd1bc29c242a5d6426`) read the frame pointer after the push, so the length check saw the stack and took the old path. It acked `len=0`. Its boot peak was 0.075 dB. It was replaced and is not the measurement.

### Variant 1 — DMR channel, FW23, no new image

Channel 4, 467.700 MHz, colour code 15, low power, squelch left as the channel had it. Opcode 13 sent at 17:36:30, acked `sr=0` `len=0` at 17:36:34.995. No `0x26` and no `0x36`. HackRF 467.700 MHz, 2.4 MS/s, LNA 24, VGA 38, 20 s: peak 0.10 dB, clip 0.

The phone clip is digital silence for all 8 s. Peak sample ±6, −88 dBFS. The 1 kHz bin sits at the noise median. There is no chirp.

### Variant 2 — analog, speaker gate

`fwload ok(DMR003.FW24.V022)` at 17:55:59. The HackRF capture started when the transfer reached block 350 of 370, before the restart. Boot peak 0.080 dB, clip 0, nothing at or above 10 dB. Channel 2, 467.625 MHz analog, low power. Squelch opened with `0x30` body 0, acked `sr=0`. Body `0D 01` sent at 17:56:55, acked at 17:56:58 (`sr=0`, `len=24`):

| Word | Value |
|---|---|
| `0x11000080` | `0x00000002` (bit 0 set), unchanged |
| `0x11000100` | `0x000000EE` (bit 7 set), unchanged |
| `STANDBY_LO` before | `0x00000002` (bit 31 already clear) |
| `STANDBY_LO` after | `0x00000001` (bit 31 still clear; bit 0 did not hold) |
| codec before / after | `AICR` `0xC0`, `CR_DAC` `0x20`, mute `0x0C`, both times |

The flag byte is `0x04`, only the speaker-gate mismatch. Bit 31 was already clear, and `AICR` bit 4 was already clear, so the 3 s did not have to open either one. HackRF 467.385 MHz, LNA 24, VGA 38: peak 0.07 dB, clip 0. No `0x26` and no `0x36`.

The phone clip is −13.7 dBFS for all 8 s, before the command, during the 3 s, and after. The peak stays near 320 Hz. The 1 kHz bin stays at the noise median. There is no chirp. This is louder than the FW23 open-squelch noise (−27 dBFS) and it is not the sweep.

A power-cycle (`restartmodule` at 18:00, boot peak 0.080 dB) and the stream below did not leave the speaker-gate word at `0x1`. The same op at 18:13, squelch closed, still read `0x2` at the start and `0x1` at the end, and `0x11000100` was then `0x80` (bit 7 still set, unchanged across that op). Bit 0 of `0x11000088` does not hold a write, and it is back by the next command. Bit 31 stayed clear.

**Decision (c), final.** Neither variant put the 1 kHz line or the chirp into the phone audio. Opcode 13 is the wrong leg. Item 7 trains on a real reception.

### Unchanged behaviour

The first 1125-frame stream, HackRF LNA 16 / VGA 16, clipped (body peak 181 of 127, clip fraction 1, the 2969 Hz figure is not used). After the 10 minute cool-down the same stream at LNA 8 / VGA 8: keyed 45.30 s, p99 3004 Hz, body peak 14, clip 0. Decode 1125 of 1125, the last frame is 1124 with the end bit, EOT score 0.999. Battery 37.4 to 38.0 °C, `mtktsAP` 45.0 to 50.8 °C, `mtktsbtsmdpa` 42.9 to 47.9 °C. No heat stop.

Receiver, phone not keyed. Idle `0x32` raw 23 (−108.5 dBm). The gain-0 HackRF carrier moved it to raw 43 (−98.5 dBm). The earlier pair on an idle radio was raw 31 to raw 47. A 1 kHz FM tone, ±2.5 kHz, HackRF VGA 20, dummy burst first: the phone clip is silence until the squelch opens, then −11.0 dBFS with a 1 kHz line of 12990 for 3.5 s. The held-path line on that same stimulus was about 6200. The path is open.

### End state

`0x34` `DMR003.FW24.V022`. Channel 2, 467.625 MHz analog, low power, squelch body 2. No `DMRDEBUG.bin`. SignalDeck owns the radio. The stock app was not changed. The web server was turned off. Boot peak 0.080 dB on the load and on the restart.

# PR 5 SSTV pass, partial (2026-10-25, 18:16–18:48)

SignalDeck PR 5 (`claude/host-items`, `dedb63da`) was built and installed with `adb install -r` over the beta.19 already on the phone. Same version name `1.0.0-beta.19`, versionCode 118. The radio stayed on `DMR003.FW24.V022`, channel 2, 467.625 MHz analog, low power. Pictures went out through `sendSstv` (the PKT SSTV button's call) via the web API, which is that same method. HackRF receive, LNA 8, VGA 8.

Robot 36 at 18:19. The previous 45 s stream had ended at 18:12 with `mtktsAP` still 5 °C above its pre-key value, so this key started inside the 10 minute cool-down. It ran 39.5 s, steady p99 2040 Hz, clip 0. History: `Sent SSTV Robot 36`, then `Long transmission 39 s (SSTV Robot 36); AP zone 52.7 °C, last long key 38 s, 0 min ago, zone before it 50.7 °C`. SignalDeck's Robot 36 decoder (`RecordingDecoder.sstv`) on the demodulated 8 kHz recording: one picture, 219 of 240 lines, noise 1.9, not marked complete. The six horizontal bands are the red, green, blue, yellow, black and white bars that were sent.

A Martin M1 request immediately after was refused, and it did not key. The reply was: `Cooling down after the last 38 s transmission: the phone's radio zone is still 3.6 °C above where it was (54.3 °C now). Long pictures wait until it is within 1 °C; a short mode can go now.` That sentence is the API error. It is not a history row. `sendSstv` returns the guard text before `transmitPcm`, and only `transmitPcm` writes the history line.

Martin M1 was allowed at 18:37 (the zone was 51.8 °C, 0.2 °C above the 51.6 °C it had stored). It ran 117.8 s, steady p99 2029 Hz, clip 0. History: `Sent SSTV Martin M1`, then `Long transmission 117 s (SSTV Martin M1); AP zone 62.0 °C, last long key 117 s, 0 min ago, zone before it 51.6 °C`. The reading after the key was battery 43.9 °C, `mtktsAP` 63.2 °C, `mtktsbtsmdpa` 60.9 °C. The 60 °C stop was crossed. The key was not polled while it ran, so it was not cut short. The host VIS detector reads code 44, Martin M1, at 0.5 s into the demodulated recording. The line renderer then dies in this unit-test classpath (`Bitmap.createBitmap` returns null), so there is no picture file for Martin M1.

Robot 24 was not sent. After Martin M1 the battery was 43.9–44.2 °C and the AP zone was still above 52 °C. A short key on top of that is too close to the battery stop.

### End state

PR 5's release build is the installed SignalDeck. `0x34` `DMR003.FW24.V022`. Channel 2, 467.625 MHz analog, low power. No `DMRDEBUG.bin`. The web server was left on for the sends. No further key until the battery is down and `mtktsAP` is back under 60 °C, which it was (52.7 °C at 18:48) while the battery was still 43.9 °C.

# FW25 — two-tone into the vocoder buffer (2026-10-25, 19:32–19:43)

The review of FW24 said the −13.7 dBFS stationary tone meant the lineout was heard and the samples at `0x180000A0` were not what the DAC played. FW25 adds two things to that image. Opcode 13 with a second body byte of 2 writes a square at ±8192: 1.5 s at 500 Hz (8 samples high, 8 low), then 1.5 s at 2 kHz (2 high, 2 low). It sets the DAC the way boot does and does not touch `STANDBY_LO` or PTT. The 24-byte reply is the irq-27 count, the flag word `0x110003B0` at the start, at sample 12000 and at the end, and four halfwords (the buffer before the first write, the square value at sample 12000, the last value written, the buffer after). Opcode 14 reads 1..240 bytes from `0x18000000`..`0x1800FFFF`, the same shape as opcode 12. Host `test_fw23`: 4 tests. Image sha256 `f0759b7d3bce21471f82957cc488553b81dbf8bc01aeb6861a7832bec08c116a`, 378620 bytes. The extension is 3280 bytes and ends at `0x5C464`.

`fwload ok(DMR003.FW25.V022)` at 19:35:49. The HackRF capture started at block 350 of 370 (19:35:31), before the restart. Banner `开机初始化完成` at 19:35:41. Boot peak 0.074 dB, clip 0, nothing at or above 10 dB. `0x34` body is `DMR003.FW25.V022`.

The playback was on the low-power VFO at 467.625 MHz (band 1, power byte 0, squelch opened with `0x30` body 0, acked `sr=0`). Opcode 14 read 160 bytes at `0x180000A0` before the tone: the first samples were −1, 0, −1, −1. Body `0D 02` was sent at 19:37:44. `raw40` returned none at 800 ms, and the module's own reply arrived at 19:37:47 (`sr=0`, `len=24`):

| Word | Value |
|---|---|
| irq-27 count | 0 |
| `0x110003B0` at the start | `0x00000000` |
| `0x110003B0` at sample 12000 | `0x00000000` |
| `0x110003B0` at the end | `0x00000000` |
| buffer halfword before | `0xFFFF` (−1) |
| square at sample 12000 | `0x2000` (+8192) |
| last value written | `0xE000` (−8192) |
| buffer halfword after | `0x2000` (+8192) |

Opcode 14 read the same 160 bytes at 19:37:49, about 2 s after the reply. The first eight samples are +8192, +8192, −8192, −8192, and that pair repeats: the 2 kHz square is sitting in the buffer. HackRF 467.385 MHz, LNA 24, VGA 38, 16 s: peak 0.065 dB, clip 0. No `0x26`. A status byte 2 arrived only when the squelch was closed afterwards.

The phone clip is 10 s at 8 kHz. Every 0.5 s window from 0 s through 9 s is −15.5 to −16.0 dBFS. The spectral peak stays near 320 Hz (300–344 Hz, one window at 748 Hz after the tone). The 500 Hz line and the 2 kHz line stay in the noise of that tone. The square that is in the buffer does not come out of the speaker.

The irq-27 count is 0 and the flag word stays 0, so the codec is not consuming this buffer while the modem is in FM. The flag word is not an address. The guide names `0x180000A0` as the buffer the codec reads, and that is the buffer the square was written into. There is no second source register in the read-back, so nothing was written on a guess. **Decision (c) is final.** Item 7 trains on a real reception. The chirp comparison was not run: the two tones did not move the sound.

### Unchanged behaviour

The 1125-frame stream was keyed on the same low-power VFO, because channel 2's own row programs power byte 1. HackRF LNA 8 / VGA 8. Keyed 45.41 s, steady p99 3026 Hz, IQ peak 5, clip 0. Decode 1125 of 1125, last frame 1124 with the end bit (33892), EOT score 0.999. Battery 39.1 to 39.2 °C, `mtktsAP` 45.5 to 47.3 °C, `mtktsbtsmdpa` 44.2 to 45.6 °C. No heat stop. The VFO was turned off at 19:41:59.

Receiver, phone not keyed, back on channel 2. Idle `0x32` raw 21 (−109.5 dBm). The gain-0 HackRF carrier moved it to raw 35 (−102.5 dBm). A 1 kHz FM tone, ±2.5 kHz, HackRF VGA 20, dummy burst first: the clip is silence until the squelch opens, then −11.1 dBFS with a 1 kHz line of about 12940 for 3.5 s. The path is open.

### End state

`0x34` `DMR003.FW25.V022`. Channel 2, 467.625 MHz analog. That row programs power byte 1 and squelch 5; the hardware squelch was then set to body 2. No `DMRDEBUG.bin`. SignalDeck owns the radio. The stock app was not changed. The web server was turned off. Boot peak 0.074 dB.

# Item 6 host part — M17 as a channel type (2026-10-25, 20:20)

Host only. SignalDeck branch `grok/m17-channel`, pull request https://github.com/IIMacGyverII/SignalDeck/pull/9. Commit `3a7ccb49` is the channel type rebased onto `origin/main` `28517806`. Commit `58c30c69` keeps type 2, the destination and the channel access number in the web save, and shows those fields in the web editor. `testReleaseUnitTest --offline` passed, including `M17ChannelTest` (destination cleaning, the CAN in the voice type word, the backup type cell, and the web save).

The release APK of that branch was installed with `adb install -r` at 20:18 (versionCode 118, no uninstall). The app logged `module DMR003.FW25.V022` at 20:18:43. No channel was written after that install. No transmission. The HackRF was not started. The device pass (create the channel, a reception on the intercom, a 10 s key, the web intercom) has not been run.

# Item 6 device pass (2026-10-25, 21:14)

SignalDeck PR https://github.com/IIMacGyverII/SignalDeck/pull/9, branch `grok/m17-channel`, tip `1cad336b`. The review fixes (CAN in TYPE bits 10:7, squelch held open, decoded voice only) are `3a69f373`. `1cad336b` fixes the backup row. Release installed with `adb install -r` at 21:07:37 (versionCode 118, versionName 1.0.0-beta.19, no uninstall). Module stayed `DMR003.FW25.V022`. `M17ChannelTest` passed on the host before that install.

## Channel

Channel 56, name Bench M17, type 2, 467.625 MHz both ways, power 0, colour code 7, destination the bench callsign, squelch 0, band 1. Selecting it at 20:47:53 wrote `0x23` body `28 64 DF 1B 28 64 DF 1B 01 00 00 00 00 00 00 02 08 02 02`: both frequencies 467625000, wide (`01`), low power (`00`), squelch `00`. The voice-filter hold followed, `data hold action=1 sr=0`. After the 21:07 install, selecting it again left `/api/m17` running with the fixed-tap calibration (the module holding the voice filter open). The idle intercom line for that channel is the destination and CAN 7.

## Receive

HackRF at 467.625 MHz, amp off, 2 MS/s, scale 80. A dummy burst first. The first files were time-compressed into one second (the interpolator’s source axis was a fraction of the buffer, not seconds) and the phone did not list them. The corrected file has a 1.6 s unmodulated lead, 30 stream frames, CAN 7 (type `0x0385`), bench callsign to bench callsign, and a 0.5 s carrier tail. Checked on the host before it was sent: lead p99 0 Hz, body p99 3165 Hz.

| When | VGA | Meter during the symbols | Intercom |
|---|---|---|---|
| 21:10:41 | 10 | −97 dBm | 30 frames, 30 clean, both ends the bench callsign |
| 21:10:50 | 8 | −97 dBm | 20 frames, 19 clean, both ends the bench callsign |
| 21:13:56 | 16 | −95 dBm | 30 frames, 30 clean, both ends the bench callsign |
| 21:14:03 | 5 | −100 dBm | 26 frames, 26 clean, both ends the bench callsign |

A carrier sweep the same minutes read VGA 5 at −100, VGA 8 at −98, VGA 10 at −96, VGA 11 at −94, VGA 16 at −95, VGA 22 at −87. Several other steps read the noise floor because the sample missed the carrier. The asked −93 and −99 were not the readings; the modulated passes landed at −95 and −100.

The two −97 clips, scored with the app’s own `HeldPath.decode` and the Armor taps, skipping the first second of open-squelch hiss: link-setup CRC, type `0x0385`, destination and source the bench callsign, 30 of 30 payload-exact, end bit set. The same clips from sample 0 lock a false sync in the hiss and decode nothing. The live count at VGA 8 (20) and at −100 dBm (26 of 30, 87 %) is below the 95 % bar. The −95 dBm pass is 30 of 30 on the intercom; that one was not clip-scored.

## Transmit

One 10 s web intercom key (`/api/ptt`) on channel 56, capture `item6_talk.iq` closed 20:54:36 (16 s, 2.4 MS/s, tuner 467.385 MHz, LNA 8, VGA 8). Carrier 10.367 s, clip fraction 0, SNR 44.7 dB, offset 1105.2 Hz, body p99 2883.7 Hz, slice p99 max 3169.5 Hz, no 5 kHz stop. Battery 40.2 °C before and after; the AP zones were not in that sensor read. The log counted 249 voice frames and a last op 7. Decoded from the keyed slice, positive polarity: link-setup CRC, type `0x0385`, destination the bench callsign, 249 of 249 stream frames at Golay 0, frame numbers 0–248 with no gaps, the end bit on 248, EOT-pattern correlation 1.000 eight milliseconds after the last frame. The source is the station record and is not written here. The on-screen round key was not pressed; it calls the same `RadioService.ptt` method, which calls `m17Voice` for an M17 channel.

Stock firmware was not loaded. `txInhibited()` is true for an M17 channel when `0x34` is not a stub tag, and the history line in that case is the receive-only warning. FW25’s tag is a stub tag, so after the version query `txInhibited` was false and the key was sent. A “TX blocked on a receive-only channel” line from before that query is not the stock-firmware path.

## Backup

Export `20261025_210240` (the build before `1cad336b`) wrote 39 fields against a 40-column header. The M17 tone cells were one comma short, so the power cell landed in Squelch and the destination landed in SoftSQLevel. Restore kept type 2, band 1, CAN 7 and squelch 0, set the destination to everyone, and set power to 1.

`1cad336b` adds the missing comma. `m17ToneCells` plus the power cell is 11 columns, which `M17ChannelTest` checks. Export `20261025_210824` after the 21:07 install: 40 fields, type M17, bandwidth 25, colour code 7, squelch Disabled, power P1, destination the bench callsign. Restore read back type 2, band 1, CAN 7, squelch 0, destination the bench callsign, power 0.

## End state

Channel 2 (467.625 MHz FM). This build is installed (21:07:37). Module `DMR003.FW25.V022`. HackRF idle. Nothing keyed at the end. No factory image loaded.

# Item 8 device pass — POCSAG page (2026-10-25, 21:35)

SignalDeck PR https://github.com/IIMacGyverII/SignalDeck/pull/10, branch `grok/pocsag-page`, rebased onto `main` `1cad336b`, tip `8fd25662`. `PocsagTest` passed. Release installed with `adb install -r` at 21:35:13 (versionCode 118, no uninstall). Module stayed `DMR003.FW25.V022`. Battery 39.6 °C through the keys. The AP zone read did not return. HackRF receive, LNA 8, VGA 8, clip fraction 0. `multimon-ng` is not on this PC. The independent decoder is `tools/pocsag-research/pocsag.py`. Pages were sent with the bench text already signed, so the station record was not put on the air. RICs are 1000001, 1000002, 1000003 and 1000008.

A positive TX-RAM count deviates low on this radio. The first build put a 0 bit on the positive count, and `pocsag.py` decoded it only at polarity −1. `8fd25662` swaps the two levels, so a 0 bit is the negative count and comes out as a positive deviation. The confirming page below decoded at polarity +1.

Channel 2 is high power, so every page tuned a low-power wide VFO, waited 3.5 s, keyed, and returned. The history line is written on the channel that was left.

| Page | When | Carrier | Body p99 | Worst 0.5 s slice | Stop | Research decoder | `Pocsag.decode` |
|---|---|---|---|---|---|---|---|
| 1200, one RIC | 21:31 | 2.271 s | 4122 Hz | 4589 Hz | no | polarity −1, 16/16, RIC 1000001 function 3, `N0CALL: HI` | same page |
| 1200, three RICs | 21:31 | 3.200 s | 4115 Hz | 5086 Hz | yes, one slice | polarity −1, 48/48, frames 1, 2 and 3, each `N0CALL: ABC` | the same three pages |
| 512, one RIC | 21:32 | 2.625 s | 4094 Hz | 6281 Hz | yes, two slices | polarity −1, 16/16, `N0CALL: LO` | same page |
| 2400, one RIC | 21:32 | 0.510 s | 4835 Hz | no full half-second | no | polarity −1, phase 5 samples, 12 of 15 codewords, page `N0CALL: HI`, three tail words bad | the page, the bad words skipped |
| 467.550 MHz, 1200 | 21:32 | 2.270 s | 4229 Hz | 4648 Hz | no | polarity −1, 16/16, RIC 1000008, `N0CALL: MOVE` | same page |
| 1200, one RIC, swapped levels | 21:35 | 2.27 s | 4123 Hz | 4654 Hz | no | polarity +1, 16/16, `N0CALL: HI` | same page |

The 1200-baud page itself is 1120 bits, 0.933 s. The carrier is about 1.3 s longer: the symbol ring fills before the key, and the drop follows the last symbol. At 21:32:44, during the 467.550 page, status showed 467.550 MHz on channel number 0. Afterwards the radio was back on channel 2 at 467.625 MHz. The confirming page wrote `21:35:34 Page sent to 1 RIC at 1200 baud` into channel 2's history.

The 512-baud slices at 6281 Hz and 5691 Hz, and one slice of the three-RIC page at 5086 Hz, are over the 5 kHz line. The 99th percentile of each whole carrier stays near 4.1 kHz because the quiet tail is in that window. The level was not changed. Those two transmissions are the stop.

## End state

Channel 2, 467.625 MHz FM. The `8fd25662` build is installed (21:35:13). Module `DMR003.FW25.V022`. HackRF idle. Nothing left keyed.

# Item 8 level table (2026-10-25, 21:59)

PR 10 tip `ab606d64`. `PocsagTest` pins 4600 / 6500 / 7000 and the idle word after the last batch. Installed `adb install -r` at 21:57:57. The first pass used the review's starting counts (512 → 5400, 1200 and 2400 → 7000). Two of those were still over 4.5 kHz, so those two counts came down and were measured again. Every page below decoded at polarity +1, function 3, text `N0CALL: …`, and the radio was back on channel 2 afterwards. HackRF LNA 8, VGA 8, clip 0.

The empty zone read last time was the shell splitting `su -c` from its script. Quoted, the nodes answer: `mtktsAP` 47.1 °C before the first key of this set and 47.7 after the 512-baud page, `mtktsbtsmdpa` 45.3 to 45.7, battery 39.4 to 39.5 °C.

| Baud | Counts | Page | Carrier | Body p99 | Worst 0.5 s | Codewords | Text |
|---|---|---|---|---|---|---|---|
| 512 | 5400 | one RIC | 2.62 s | 3345 Hz | 5199 Hz | 16/16 | `N0CALL: LO` |
| 512 | 4600 | one RIC | 2.625 s | 2751 Hz | 4230 Hz | 16/16 | `N0CALL: LO` |
| 1200 | 7000 | one RIC | 2.271 s | 4001 Hz | 4489 Hz | 16/16 | `N0CALL: HI` |
| 1200 | 7000 | three RICs | 3.23 s | 3996 Hz | 4814 Hz | 48/48 | `N0CALL: ABC` on 1000001, 1000002, 1000003 |
| 1200 | 6500 | one RIC | 2.271 s | 3864 Hz | 4346 Hz | 16/16 | `N0CALL: HI` |
| 1200 | 6500 | three RICs | 3.227 s | 3864 Hz | 4493 Hz | 48/48 | `N0CALL: ABC` on each |
| 2400 | 7000 | one RIC, with the idle pad | 1.79 s | 4119 Hz | 4417 Hz | 16/16 | `N0CALL: HI` |

The table that ships is 4600, 6500, 7000. The loudest half-second in that table is 4493 Hz, on the three-address page. The 2400-baud page that was cut at 12 of 15 codewords is 16 of 16 with one idle codeword after the last batch. The carrier is still about two seconds: the ring fills before the key, then the page, then the tail.

## End state

Channel 2, 467.625 MHz FM. The `ab606d64` build is installed (21:57:57). Module `DMR003.FW25.V022`. HackRF idle. Nothing left keyed.

# Item 7 design — receive self-calibration (2026-10-25, 22:05)

No image and no key. The design is `radio_firmware/plan-rx-selfcal.md`. The equaliser is the held path's 41 taps, fitted after a call from the frames the decoder already accepted, re-encoded to the symbols that were sent. The shipped per-model table gets the first lock. The decision-feedback receiver stays the fallback on stock firmware and on a phone with no table. A fit replaces the live taps only after a second, independent transmission decodes at least as well. The file is per profile in the app's files, with a reset. The M17 page line says which set is in use. The bench pass is two transmissions after this review.

# Item 7 bench (2026-10-25, 22:42)

SignalDeck PR https://github.com/IIMacGyverII/SignalDeck/pull/12, branch `grok/rx-selfcal`, `87a6a503`. `HeldFitTest` passed (synthetic channel 30 of 30 payload-exact, the 5 percent guard, the 20-frame minimum, the second-call rule). Release installed with `adb install -r` at 22:41. Module stayed `DMR003.FW25.V022`. Channel 56, held path, shipped Armor taps at the start. HackRF at 467.625 MHz, amp off, 40-frame files except the third which is 30. Nothing was keyed by the phone.

| Call | VGA | Meter | Heard | Usable frames | Calibration line after |
|---|---|---|---|---|---|
| N0CALL, 40 frames | 20 | −90 dBm | 40 frames, 39 clean | 31 | fit waiting for a second call (31 frames at −90 dBm) |
| N0CALL, 40 frames | 10 | −99 dBm | 40 frames, 31 clean | — | fit not kept (18 clean vs 19, locked) |
| N0CALL, 30 frames | 5 | −102 dBm | 30 frames, 20 clean | 9 | shipped taps, 9 usable frames |

The second call was 9 dB weaker than the fit and the pending taps locked on its recording, but they decoded 18 clean frames against 19 for the shipped taps, so the fit was not kept. The third call did not start a new fit (9 frames, under 20). The shipped table is still what the receiver uses. The phone was put back on channel 2.

## End state

Channel 2, 467.625 MHz FM. The `87a6a503` build is installed. Module `DMR003.FW25.V022`. HackRF idle. The shipped taps are still the ones in use.

# FW26 promiscuous receive (2026-10-25, 23:41)

Image `DMR003.FW26.V022`, sha256 `71949d24910d214dd0a98be7d5da0dd87aeb6ce3b228ef27e7b3d3891357a34e`, 378620 bytes. Built by `tools/fw-patch/fw26_build.py` on the FW25 image (that file's sha256 `f0759b7d…c116a`). Host test `test_fw26.py`: five tests, the only byte differences from FW25 are the tag, the five redirected sites, and the tail.

FW25's extension ends at file `0x5C464`. The free tail is 664 bytes, through `0x5C6FB`. The old 1,788-byte gap at `0x05AEFC` is already full. The four stubs use 232 bytes and end at `0x5C54C`. The flag byte is IRAM `0x4B364`, inside the region startup zeroes (`0x31AF4` to `0x4DAB0`), so it is 0 until op 15 writes it.

`0x1832e` loads `RX_TYPE_INFO` and shifts it 22 then masks 1, and shifts it 20 then masks 3, into the sync accumulator at `0x4C7BC`. No load of that register extracts bits 7:4 or bit 19. Bits 3:2 are extracted at `0x2628E`, which matches the manual's sync-type field. The appended caller bytes therefore use the spec: colour code `(word >> 4) & 15`, slot `(word >> 19) & 1`.

The first image tail-called `reply_build` with a `bsr` and then `jmp r15`. That pop already jumps to the return address, so the `jmp` spun on itself after the 11-byte reply. The module was restarted and the image was replaced. The tail call is now `jmp` to `0x030230B0`. The numbers below are that image.

Load started 23:35:25, `fwload ok` and `0x34` `DMR003.FW26.V022` at 23:37:43 (138 s). Boot capture across the following restart: peak 0.056 dB, nothing at or above 10 dB, clip 0. `mtktsAP` 42.4 to 43.0 °C through the keys, `mtktsbtsmdpa` about 41.1 to 41.7, battery 36.9 to 37.0 °C. No heat stop.

| Check | Time | Result |
|---|---|---|
| `0x2B` with the flag still 0 | 23:38:05 | `sr` 0, body length 9 |
| op 15 `[15, 2]` | 23:38:07 | `sr` 1, body length 0; the next `0x2B` is still 9 |
| op 15 `[15, 1]` | 23:38:12 | `sr` 0, body `[01]` |
| `0x2B` with the flag on | 23:38:14 | `sr` 0, body length 11, both new bytes 0 (no DMR carrier; the length is the check) |
| op 15 `[15, 2]` again | 23:38:16 | `sr` 1; the next `0x2B` is still 11 |
| op 15 `[15, 0]` | 23:38:21 | `sr` 0, body `[00]`; the next `0x2B` is 9 |

Regression, all at 467.625 MHz, low power, HackRF receive, clip 0. The 1 kHz key and the page used LNA 16 / VGA 16. The M17 key used LNA 8 / VGA 8.

| Key | Time | Carrier | SNR | Body p99 | Worst 0.5 s | What decoded |
|---|---|---|---|---|---|---|
| 1 kHz tone, 2 s | 23:38:32 | 2.536 s | 64.7 dB | 3626 Hz | 3994 Hz | spectral peak 1000.1 Hz |
| M17, 40 frames, bench call | 23:38:48 | 2.02 s | — | 2873 Hz | — | 40/40 payload-exact, end bit set |
| 1200-baud page, one test RIC, `N0CALL: LO` | 23:38:59 | 2.272 s | 64.9 dB | 3761 Hz | 3801 Hz | not run through the bit decoder; the carrier length matches the earlier one-RIC page |

None of those half-second slices reached 5 kHz.

Held-path receive, HackRF transmit, VGA 20, amp off, 30 frames of the bench call. The hold answered `data hold action=1 sr=0`. During the carrier `0x32` raw was `0x40`, about −88 dBm; after it, raw `0x15`, about −109 dBm. History at 23:40:05: the bench call, 0.6 s, 19 frames, 84 percent clean. The phone was not keyed during that transmission.

## End state

23:41:16 `0x34` `DMR003.FW26.V022`. Op 15 `[15, 0]` echoed 0. `0x2B` body length 9. Channel returned with `vfooff` (the keys had been on the low-power VFO). `mtktsAP` 42.9 °C, battery 37.0 °C. HackRF idle. Nothing left keyed. The same SignalDeck build as the item 7 bench is still installed. SignalDeck's promiscuous control is PR 11; it was not rebuilt here.

## Open for the hotspot

Out-of-list talkgroup with the flag on (Patch A). Wrong colour code with the flag on, and whether stock already passes it (Patch B). Whether stock monitor `0x2F` already passes an out-of-list talkgroup. Slot is still deferred (Patch C). The `0x2B` colour-code and slot values themselves need a real DMR carrier; this bench only checked the length.

## Held-path re-run (2026-10-25, 23:55)

The same file as the item 7 call at 22:42 (`item7_A.cs8`, 8,240,000 samples, bench call, 40 frames) was transmitted again at VGA 20 on channel 56. The meter during the clip was −89 dBm. The page listed 40 frames, 37 clean. On FW25 that clip listed 40 frames, 39 clean. This is not the 19-of-30 result from the shorter clip at 23:40. The receiver then had a fit waiting (33 frames at −89 dBm). The live taps stay the shipped table until a second call. The phone was put back on channel 2. HackRF idle. Module still `DMR003.FW26.V022`. Nothing was keyed.

## R-I live receiver (2026-10-26, 00:30)

SignalDeck `grok/live-receiver` `0465553e` (PR 13), release build installed over the previous one. Channel 56, M17 listening, the voice-filter hold on, fixed taps. HackRF transmit only, 467.625 MHz, amp off, VGA 20 after a 0.3 s dummy at VGA 10. The phone was not keyed. Battery 38.8 °C before the first clip and 38.9 °C before the repeat.

A 750-frame transmission (65,040,000 samples, 32.5 s, including the 1.6 s lead and 0.8 s of carrier after the end) at 00:30. The meter during the carrier was −88 dBm. The page made one listing: 750 frames, 702 clean, the bench call. `HeldPath.decode` on that receive clip, from 2.5 s through 33 s (the carrier; the clip's first second is open-squelch noise), returned 750 stream frames, last frame number 749. The live count and the batch count are the same.

A 200-frame transmission with one second of no deviation after frame 99 (23,040,000 samples, 11.5 s) at 00:30, and the same file again at 00:32 because the first receive clip was cut to 1.4 s by the previous clip's timer. Both times the page made one listing: 200 frames, 185 clean. The meter during the carrier was −88 dBm. On the second recording the one-chain batch walker, which stops at the first lost sync, returned 100 stream frames and stopped at frame 99. The level in that recording dips for that second (rms about 4900, then 3350 and 3500, then 4800 again). The live receiver kept the one listing and counted the frames on both sides of the hole.

The fit after the 30 s call was waiting (400 frames at −88 dBm). The first gapped call was not kept (83 clean against 81, no lock). After the repeat the line was waiting again (168 frames at −88 dBm). The taps in use were not replaced. The phone was put back on channel 2. HackRF idle. The module was not reloaded.

## Bench runner acceptance (2026-10-26, 01:19)

`tools/fw-bench/runner/bench.py` on `DMR003.FW26.V022`, 467.625 MHz, low power. JSON and the table: `tools/fw-bench/results/DMR003.FW26.V022/`. The `all` run (01:12–01:19) passed every test: boot peak 0.07 dB and silent, a 10.5 s 1 kHz tone at body p99 2551 Hz with the hottest half-second 4044 Hz, the 1125-frame stream 1125/1125 at p99 2908 Hz and clip fraction 0, the receive clip carrying the 1 kHz line at −19.1 dBFS, and a 45 s key with no heat stop. The earlier single runs match: boot 0.048 dB, tone p99 2539 Hz, stream p99 2903 Hz, a 30 s key raising `mtktsAP` from 47.5 to 48.5 °C and the battery from 39.5 to 39.7 °C, a 45 s key from 47.9 to 49.0 °C and the battery from 39.7 to 40.0 °C.

Five runner defects, fixed before `all`: the version string drops out of logcat while the signal poll runs, so the tag is read from the settings API; a 10 s tone needs the lift flag or the app stops it at 5 s; the receive clip is a WAV in the app cache; the heat stop was watching `mtktsPA`; `all` did not wait for the zone to cool. Not part of this runner: a plain-versus-held tone table, M17 receive at two levels, and a 120 s time-out key. The phone was returned to channel 2. HackRF idle. The module was not reloaded.

## Receive-RAM stream (2026-10-26, 01:41)

FW26, channel 2, 467.625 MHz. A HackRF 1 kHz tone at 2.5 kHz deviation, VGA 20, read −89 dBm on the phone. The phone was not keyed. The phone's own clip, scored at 8 kHz, peaks at 1000.00 Hz with rms 5971.

Opcode 14 reads only `0x18000000`–`0x1800FFFF`. A 160-byte read at `0x180000A0` returned the idle vocoder pattern (first samples −1, 0, −1, −1, rms 0.7). The same read at the FM receive RAM `0x160004E0` was refused. That window is not the discriminator.

Op 5 still answers. Four halves, 514 bytes each, sequence 0, 1, 2, 3 and half ids 1, 0, 1, 0: this short dump did not skip a block. As big-endian samples the four halves sit near a small offset (means 114, 96, 68, 54) with rms 10, 6, 14 and 6. There is no 1 kHz line. Op 5 with mode 4 returns `sr=1` and no bytes. Applying op 6 mode 4 and restoring it both return `sr=0`; a mode-0 dump while that hold was on did not produce a file.

The running UART is 57600. One 514-byte half takes about 89 ms on the wire and covers 32 ms of 8 kHz audio, so a continuous dump at this rate would keep about 36 % of the halves and drop the rest. A 230400 line (the divisor reading is 230769 Hz, +0.160 %) would carry the same half in 22 ms, inside the 32 ms it represents. FW26 does not switch the UART, and opcode 14 cannot see the FM RAM. **Decision: close the RAM stream on this image.** The phone audio path is the one that carries the signal. A stream would be a new stub. None was built. Hold mode 4 was restored. Channel 2. HackRF idle.

## Independent pager decoder (2026-10-26, 02:23)

multimon-ng 1.6.2, source commit `b5f7d71`, built on this PC with MSYS2 MinGW gcc 16.2.0. No WSL. The CMake MinGW generator wrote a makefile with no compile rules, so the sources were compiled directly (`-DONLY_RAW -DNO_X11 -DNO_SDL3 -DWIN32_AUDIO -DWINDOWS`). The executable stays outside the repository. The phone was not keyed and the HackRF was not started: the 21:57–21:59 demodulated wavs were still on disk. Each was resampled from 48 kHz mono to 22050 Hz signed 16-bit, which is the rate the POCSAG demodulators ask for. There is no `item8_F2400.wav`; the 2400-baud file is `item8_L2400.wav` from 21:57:20, the level-table page.

| File | Written | Demodulator | RIC | Function | Text multimon-ng printed |
|---|---|---|---|---|---|
| `item8_F512.wav` | 21:58:25 | POCSAG512 | 1000001 | 3 | `N0CALL: LO` |
| `item8_F1200.wav` | 21:58:44 | POCSAG1200 | 1000001 | 3 | `N0CALL: HI` |
| `item8_F3.wav` | 21:59:05 | POCSAG1200 | 1000001, 1000002, 1000003 | 3 | `N0CALL: ABC` on each |
| `item8_L2400.wav` | 21:57:20 | POCSAG2400 | 1000001 | 3 | `N0CALL: HI` |

`-P auto` at verbosity 3. The inverted-sync line (printed only when the inverted sync word matches) did not appear. On the 1200-baud page, `-P normal` printed the same RIC, function and text, and `-P inverted` printed no address. The inverted option was not needed. The one-RIC pages also show a trailing null after the text; the three-RIC page does not. The BCH counters run over the whole file, including the lead-in, so they are not a bit-error rate for the page. The pass is the printed address and text.

The runner's tone JSON key is now `line1k_dev_Hz`. It is the deviation of the 1 kHz line, not the line's frequency. The two tone records already committed under `tools/fw-bench/results/DMR003.FW26.V022/` still say `line1k_Hz`; those files are the record of the runs that wrote them.

## End state

The phone was not used. Channel 2, module `DMR003.FW26.V022`, HackRF idle, the same end state as the 01:19 runner. Nothing was keyed.

## Cold-boot regression (2026-10-26, 02:42) — stopped at adb

Before the reboot, at 02:42:15: installed APK sha256 `c54cf9ad6c0290985e98ce7eec14102cfc1bc7d80a8d73014f51e54fca86c088` (`1.0.0-beta.19`), `0x34` `DMR003.FW26.V022`, link ready, channel 2 at 467.625 MHz, monitor off, not transmitting, stock app disabled.

`adb reboot` dropped the session within a second. From 02:43 through 02:50, `adb connect 192.168.1.125:5555` was refused (Windows error 10061). The address answered ping. `adb devices` stayed empty, `adb mdns services` listed nothing, and no USB device appeared. The runner's tag, boot and receive tests, the channel 56 listing, and the channel 4 MON check were not run. The HackRF was not started. Nothing was keyed.

The same wait also rebuilt FW21 and FW22 on the host. Both match the images that were loaded: FW21 `f726056aa3e62db4399d45ee6cf5df4e29756083761c1651ce734d4c08d477ed`, FW22 `38f900a0df169c0101f9e6183fe8ec8d2e9cdca74169f034f5571b04aa988d6a`. The assembly is in `tools/fw-patch/stubs/`, and `test_repro.py` passed (5 tests) along with `test_patches.py` (48). No image was loaded.

## Cold-boot regression, resumed (2026-10-26, 05:46)

The owner reconnected USB. At 05:40 the stock app was enabled and SignalDeck was not running, because `ownAtBoot` is absent and the receiver's fallback re-enables the stock app. That part was already read. Wi-Fi adb was up again for this boot.

`am start` at 05:46:44. The radio was ready 7.2 s later: link ready, stock app disabled, `0x34` `DMR003.FW26.V022`, channel 2 at 467.625 MHz, monitor off.

| Step | Result |
|---|---|
| runner tag | `DMR003.FW26.V022` |
| runner boot | PASS silent, peak 0.108 dB, no run over 10 dB, tag after the restart still FW26 |
| runner receive | PASS, clip −18.9 dBFS, 1 kHz line 1.5 times the noise, 80000 samples |
| channel 56 | live receiver on, "the module's voice filter is held open", one listing: 30 frames, 27 clean, both ends the bench callsign |
| channel 4 MON | digital, 467.700 MHz. `promiscuous on: sr=0 flag=1`. Off: `sr=0 flag=0` |
| channel 2 | monitor off, link ready, not transmitting |

`ownAtBoot` was then turned on and the phone was rebooted from USB at 05:48:09. USB adb returned in 24 s. The app's process appeared by itself at uptime 43 s, and the radio was ready at uptime 47.9 s: link ready, stock app still disabled, tag `DMR003.FW26.V022`, channel 2. Nothing on the host started the app. `adb -s 5006AF1020002922 tcpip 5555` answered `restarting in TCP mode port: 5555`. A following `adb connect 192.168.1.125:5555` timed out (Windows 10060); USB stayed up.

The boot setting was turned back off. End state 05:50: channel 2 at 467.625 MHz, monitor off, not transmitting, stock app disabled, SignalDeck owning the radio, `ownAtBoot` false, module `DMR003.FW26.V022`. HackRF idle. Nothing was keyed.

## Hotspot arrival runbook (2026-10-26, 06:10)

Written into `radio_firmware/plan-independent-m17-check.md` under "Arrival-day runbook". No phone, no key, no image loaded. The image to flash is the M17 community fork, because upstream WPSD dropped M17 in July 2025. Frequencies follow the phone's channels (2 and 56 on 467.625, channel 4 on 467.700), read again on the day. Must-confirm 0 is the stock image with MON on and an out-of-list talkgroup, before any FW26 flag row. The phone was left as the cold-boot end state.

## Receive-RAM stream design (2026-10-26, 08:20)

`radio_firmware/plan-rx-ram-stream.md`. No image and no phone. Op 6 mode 5 holds the AT1846S bypass and `WORK_MODE` `0x80` together, with its own marker so op 5 can read. Op 16 switches 57600 ↔ 230400, ack at the old rate, 30 s host-silence fallback, boot stays 57600, and the loader is NAKed at 230400. Op 17 pushes each half with a 16-bit sequence; a frame is 22.8 ms of the 32 ms half, leaving 9.2 ms for a status push. FW27 waits for the review. The phone is unchanged.

## FW27 stub size (2026-10-26)

No image. The control stub assembles at file `0x5C54C` and ends at `0x5C690` (324 bytes): the opcode gate, mode 5, its restore, the rate switch, and the divisor write. That leaves 108 bytes of the 432-byte tail. The half-copy, assembled with the stream-marker check, an `FM_ADDR_SW` value of only 1 or 2, the frame placed at `0x4AC00` so it ends before the saves at `0x4B000`, and the checksum before `uart_send`, is 164 bytes. The two together are 488 bytes. The only other zero run of 40 bytes or more is `0x35F64` (128 bytes), the data-table tail where R4l did not boot. Nothing was loaded.

## FW29 (2026-10-27, 15:33)

FW29 is FW28 with the three stale callers moved off the restored exit. sha256 `de10d5c5961bf089f3b2ecc3875e5f3a759e965fb242759e48cfd454e8d7657b`, tag `DMR003.FW29.V022`.

`0x5B2BE` is the op 6 handler's non-zero value path, not a variant-6-only branch. Variants 3, 4 and 5 with value 1 go through it and have to reach `0x5B2C2`, so those four bytes are FW26's compare again: value 1 falls through, any other value takes the stock reject at `0x5B308`. Variant 6 is refused at the trampoline. `0x5C564` and `0x5BCAE` are `br 0x5C584`, the trampoline's existing sr=1 tail (`jmp` to file `0x5B308`). The opcode gate is entered only for opcodes 8 and above, so variants 3 and 4 never reach `0x5BCAE`.

`changed_branches` flags a branch from outside a changed range into it unless the build lists the pair. Against FW26 it reports `0x5B7EE`, `0x5B7FC` and `0x5B814` on FW27. Against FW27, with the seven stock dispatcher branches into the restored exit listed, it still reports `0x5B2BE`, `0x5BCAE` and `0x5C564` on FW28. Against FW28, with that list, FW29 has none.

`fwload ok` at 15:12:01. Runner `all`, low power, 467.625 MHz. Boot silent, peak 0.057 dB, tag still FW29. Tone carrier 10.56 s, clip 0, p99 2503 Hz, loudest half-second 3991 Hz. Stream 1125 of 1125, carrier 45.41 s, p99 2877 Hz, clip 0, end bit set. Receive line 1.50 times the noise, clip −19.1 dBFS. Heat 45 s, battery 35.5 to 35.6 °C, `mtktsAP` 42.1 to 42.4 °C, no stop. The cool-down stayed near 42 °C and the key ran at the 10 minute cap.

One page, RIC 1001, "FW29PAGE", 512 baud. Carrier 2.63 s, clip 0, p99 2663 Hz. The host codeword check on the flat deviation is Hamming 0.

Mode 5 on and off both answered `sr=0`. Op 17 start `[17, 1, 8]` and stop `[17, 0]` each answered `sr=0` with an empty body, twice. In the 2.5 s after a start the host log had the ack and the signal polls, and no 514-byte half. `[6, 6, 1]` answered `sr=1`. The signal reading kept moving. This build does not reopen the UART at 230400, so the halves were not counted. The phone was then loaded back to `DMR003.FW26.V022` (`fwload ok` at 15:33:03).

End state: channel 2, 467.625 MHz, pager receive off, monitor off, not transmitting. HackRF idle. Tag `DMR003.FW26.V022`.

## FW28 (2026-10-27, 14:56)

FW28 is FW27 with `0x5B81A` through `0x5B875` copied back from FW26. The op 13 redirect at `0x5B816` is the FW27 branch. Variant 6 is dropped. The tag is `DMR003.FW28.V022`. sha256 `518345e89a752fa3932e02c0a33d297bae6a46c26dd754eb6aaf14ec0920abe3`. `literal_guard.py` now reports a 16-bit `br`/`bt`/`bf` from outside a written span that lands inside one. A one-instruction hook and a `bsr` that still names its old callee are not hits. The test finds `0x5B7EE`, `0x5B7FC` and `0x5B814` on FW27 and no hits on FW28. The literal check is clean on FW28 too.

The first load was cut off. The runner waited 420 s without seeing the load line and then restarted the module, and a phone lease that started at 14:15 overlapped it. That pass is void: tag unread, tone no carrier, stream empty. Factory `DMR003.UV4T.V022` was loaded (`fwload ok` at 14:32:41) and keyed on channel 4: status 3, then status 4. FW28 was loaded again (`fwload ok` at 14:35:32).

Runner `all` on that image, low power, 467.625 MHz. Boot silent, peak 0.104 dB, tag still FW28. Tone carrier 10.55 s, clip 0, p99 3140 Hz, the loudest half-second 4173 Hz. Stream 1125 of 1125, carrier 45.41 s, p99 2876 Hz, clip 0, end bit set. Receive line 1.49 times the noise, clip −19.0 dBFS. Heat 45 s, battery 34.6 to 34.8 °C, `mtktsAP` 41.1 to 41.5 °C, no stop. The cool-down before the heat key sat near 41 °C and did not return to 39 °C within 10 minutes, so the key ran at the cap.

One page, RIC 1001, "FW28PAGE", 512 baud, signing off. `page key` and `sym unkey`. Offset capture, carrier 2.62 s, clip 0, p99 2679 Hz. The host codeword check on the flat deviation is Hamming 0.

Op 16 action 0 and op 17 action 0 answered `sr=0` at 57600. Op 17 action 1 did not answer, and mode 5 did not answer. After that start, ops 16 and 17 stopped answering until a module restart. The restart came back with tag FW28, and the signal reading moved. This build has no host that reopens the UART at 230400, so the stream was not run at that rate.

End state: channel 2, 467.625 MHz, pager receive off, monitor off, not transmitting. HackRF idle. Tag `DMR003.FW28.V022`.

## POCSAG part B on FW26 (2026-10-27, 14:03)

The module was already `DMR003.FW26.V022` (`fwload ok` at 13:46:38). No new image. Low-power VFO at 467.625 MHz, wide. HackRF receive at 467.385 MHz, 2.4 MS/s, LNA 16, VGA 16, amplifier off. Battery 34.8 °C, `mtktsAP` 41.0 °C, `mtktsbtsmdpa` 39.6 °C before the keys.

One 2 s 1 kHz tone. Carrier 2.55 s, clip 0, body p99 3632 Hz. Not a stop.

The browser Pager page sent RIC 1001, "FW26 PAGE", 512 baud, signing off. The reply was "Sending to 1 RIC". The log has `page key` and `sym unkey`. Carrier 2.63 s, clip 0, body p99 2659 Hz. Not a stop. `pocsag.py rx` applies a 20 ms mean removal that the phone-audio clips need. On this flat capture that removal puts 4 errors in the last message word, and the printed text is "FW26 PAG". The idle words after that word are exact, so the carrier was not cut. The same slicer and the same codeword check, without that mean removal, are Hamming 0 on both leading idle words, the address, and all four message words. RIC 1001, function 3, text "FW26 PAGE".

The browser then sent an M17 text, "WEB M17", to @ALL, with the station callsign set to the bench callsign for that key and put back afterwards. The reply was "Sending". Carrier 0.45 s, clip 0, body p99 2977 Hz. Not a stop. The carrier's 50 ms bins sit at the same level from 1.05 s through 1.30 s, so the strongest bin is the last of them. A window 50 ms before that bin does not hold the link setup. The window that starts where the carrier starts does: `decode_packet_transmission` reports the CRC good, the text matched, one frame, and a link setup from the bench callsign to @ALL with its CRC good.

End state: channel 2, 467.625 MHz, pager receive off, monitor off, not transmitting. HackRF idle. Battery 34.9 °C. Tag `DMR003.FW26.V022`.

## POCSAG page send did not key (2026-10-27, 13:31)

No firmware change. The phone-path send is DIAG `page`, which calls the same `sendPage` as the Pager screen. Pager receive was off and monitor was off. Channel 2, 467.625 MHz. RIC 1001, 512 baud, text PHONEPAGE, signing off.

The radio logged the page, wrote the low-power wide VFO, and sent command `0x40` op 3. That reset was answered (`sr=0`). It then sent op 8, the pager waveform, eight times. None of them got a reply. The log line is `page: waveform not accepted`, and the channel was restored. A 20 s HackRF capture at 467.625 MHz stayed at a deviation p99 of 265 Hz. The host decoder found no codeword.

The runner's `stream` test on the same image, straight after, was PASS 1125/1125 (carrier 45.41 s, p99 2870 Hz, clip 0, end bit set). The symbol engine is not stuck, so the factory-key rule was not applied. Op 8 is the command that gets no answer. Op 1 and op 7, which the stream uses, still key.

A browser M17 text, "WEB M17" to @ALL, was on the air for 0.45 s in an offset capture (467.385 MHz, 2.4 MS/s, LNA 16, VGA 16). The host packet decoder found one frame and no link setup, so the text was not recovered.

End state: channel 2, 467.625 MHz, pager receive off, monitor off, not transmitting. HackRF idle. Battery 35.1 °C.

## POCSAG web pager (2026-10-27, 13:12)

No firmware change. SignalDeck `grok/web-pager` `fffe3e2d`, PR 27, installed over the phone (`1.0.0-beta.19`). Headless Chrome on `adb forward` to port 8080, logged in. The PIN was not written to the log.

Chrome opened the Pager page (the page state read OFF, the login form stayed hidden). The browser's Send returned "Sending to 1 RIC" for RIC 1001, "WEB PAGE", 512 baud, 467.625 MHz, signing off. The phone filed that page. Two HackRF captures of that transmission (16 s at LNA 0, then 22 s and 25 s at LNA 16, VGA 8, amplifier off) had a deviation p99 of 270–480 Hz and the host decoder found no codeword. The radio log shows the low-power wide VFO write, the symbol-waveform command, and the channel restored, with no page-key line. Channel 2 is high power and narrow, so the send hops off it and back.

A HackRF page "FROM AIR" (512 baud, RIC 1001) was in `/api/pager/pages` one second after the transmission. The browser's M17 text to @ALL, "WEB M17", was in the M17 text list. Monitor turned on and then off from the browser (the flag read true, then the switch was turned off). The radio-module card read tag `DMR003.FW27.V022`, not the factory image, profile `ulefone-armor26ultra` revision 1, battery 34.9 °C, processor 41.3 °C, own-at-boot off, Wi-Fi debugging on port 5555. The update check found a newer build and did not install it.

End state: channel 2, 467.625 MHz, pager receive off, monitor off, not transmitting. HackRF idle. Battery 34.9 °C.

## POCSAG padding run (2026-10-27, 12:16)

No firmware change. The dip at bits 806–822 of the padded RESTORE B clip is the 17 padding bits after the text. From bit 810 the sample means fall 2541, 2267, 1947, 1603, 1302, 1020, 798, 576, 446, 321, 221, 160. An exponential fit of that run is slope −131 s⁻¹, τ = 7.6 ms. The Armor profile now uses 7.5 ms.

The inverse is still exact, with no leak. The offset removed is the mean of the restored preamble, not the mean of the whole clip. Alphanumeric text stops at the first NUL (0x00) or EOT (0x04). At 512 baud a run of the same bit keeps the previous decision until the restored sample is a quarter of the eye past the threshold. 1200 and 2400 are unchanged: held-path taps, no restore.

Host, both new clips, `best` at 7.5 ms: RIC 1001, "ALPHA ONE" and "RESTORE B", corrected 0. Those clips are `rx_alpha_pad.wav` and `rx_restore_b_pad.wav`.

Air, channel 2, 467.625 MHz, low-power channel, HackRF amplifier off, VGA 20, phone not keyed. Battery 34.0 °C at the start and at the end. Each page corrected 0:

| Baud | RIC | Text |
|---|---:|---|
| 512 | 1001 | RESTORE A |
| 512 | 1001 | RESTORE B |
| 512 | 1001 | RESTORE C |
| 1200 | 1002 | STILL 1200 |
| 2400 | 1003 | STILL 2400 |

Part A of the pager receive plan closes on that.

## POCSAG tail on the air (2026-10-27, 11:57)

No decoder change. The padded 512 baud IQ (`--pad 0.5`, 1376 bits, 3.6875 s) is 14,750,000 bytes, 7,375,000 samples. `hackrf_transfer -n` is a sample count. The bench transfer now refuses a count shorter than the file and rounds up to a multiple of 262144, repeating the last IQ sample. This send was 7,602,176 samples (3.801 s). HackRF exited after 4.03 s with `streaming terminated (-1004)`.

Re-recorded on channel 2 with the tracker build, phone not keyed. The new RESTORE B clip's modulation starts at 1.354 s. Mean absolute sample per bit, 512 baud, from that start: bits 768–805 stay in the thousands (about 5,000–15,000), bits 806–822 fall through 1,719, 1,075, 223, 167, and bit 824 is 14,639 again. The level stays high through bit 863. The hole is about 16 bits inside the last codeword, and the pad after it is on the air.

Host decode of the new clips: ALPHA ONE came back as "ALPHA ONUp", RESTORE B as "RESTORE". The phone listed "ALPHA ONE" plus a stray character for the first clip and no page line for the second. 512 baud 3/3 was not run.

## POCSAG bit clock (2026-10-27, 11:30)

No firmware change. The leak is out of the 512 baud restore: exact inverse, then the mean removed.

On `rx_restore_b.wav`, polarity −1, sync at bit 576, raw bit errors against the sent words before any correction:

| | idle | idle | address | msg | msg | msg | last |
|---|---:|---:|---:|---:|---:|---:|---:|
| Fixed preamble rate, no tracker | 0 | 0 | 2 | 2 | 7 | 10 | 13 |
| Transition tracker, one eighth | 0 | 0 | 0 | 0 | 0 | 0 | 8 |

The last word's first 16 bits match the sent word, and those bits include the final character. The check field does not (xor `0x7f10`, 8 bits). The word fails, so the page text is "RESTORE" and not "RESTORE B". The held ALPHA clip still decodes as a page that starts with ALPHA. Because neither clip is the full sent text, this step was not put on the air.

## POCSAG sync cadence and leaky restore (2026-10-27, 11:15)

No firmware change. Channel 2, 467.625 MHz. HackRF transmit, amplifier off, VGA 20, 0.5 s of idle words after the page. The phone was not keyed.

`PocsagTest.three_rics_in_one_transmission` passes. The first sync still needs a preamble. Each later sync is expected 544 bits after the previous one and is accepted within two bit errors whether or not a page is still open. If that sync is absent, the transmission is over and the search waits for a preamble again.

The inverse filter is now `state = s − b·prev + c·state`, with `c = exp(−1/(fs·τ_long))`. On the held ALPHA clip, τ_long of 100 ms decodes nothing. At 250 ms the page is RIC 1001 and the text is "ALPHA ONE" plus one extra character. On the padded RESTORE B clip (`tools/pocsag-research/rx/recordings-armor26/rx_restore_b.wav`) every leak from 100 ms through a pure integrator reads RIC 1001 and a text that starts with "RESTORE" and is not "RESTORE B". At 250 ms that text is "RESTORE ?`".

| Sent | Heard |
|---|---|
| RESTORE A | exact, corrected 2, and also "RESTORE a" |
| RESTORE B | "RESTORE `" and "RESTORE" |
| RESTORE C | "RESTORE Sp" |

Not 3/3. Pager receive was turned off. The radio stayed on channel 2.

## POCSAG false pages and the tail (2026-10-27, 10:58)

No firmware change. Channel 2, 467.625 MHz unless a monitor step says otherwise. HackRF transmit, amplifier off, VGA 20. The phone was not keyed.

The five listings that were not the sent texts, from the 10:31 monitor, all at 1200 baud:

| RIC | Text | Corrected |
|---|---|---|
| 1262599 | `)5193` | 1 |
| 2035770 | `)5193)5193)5193)5193` | 6 |
| 2035770 | `)5193)5193)5193)5193)5193` | 6 |
| 2035770 | `393)5193)5193)5193)5193` | 7 |
| 1616023 | `-,` | 1 |

Those are numeric-function pages opened from noise. A sync is now kept only when the 256 bits before it alternate, except the sync that continues a page already open. An address or a message word repaired by two bits does not extend a page. Sixty seconds of band-limited noise at a squelch-open level opens no page. Lengths 1 through 40 round-trip through the encoder and the bit decoder at 512, 1200 and 2400, so a short text does not lose its last character there.

`pocsag.py gen` appends 0.5 s of idle words. On the air, padded 512 baud RIC 1001: "RESTORE A" was exact. "RESTORE B" and "RESTORE C" still lost the last character. A clip of the padded "RESTORE B" transmission decoded the same way, so the missing character is in the received audio.

Audio after a monitor retune came up about 0.8 s after the tune line (clip energy at 1.7 s, tune 0.9 s after the clip started). The dwell is now 2.5 s. The following monitor took 7 steps and listed both texts and nothing else: "LEFT THREE" RIC 6101 corrected 0, "RIGHT THREE" RIC 6102 corrected 0.

Pager receive was turned off. The radio was put back on channel 2.

## POCSAG 512 baud droop (2026-10-27, 10:31)

No firmware change. Image unchanged, channel 2, 467.625 MHz. HackRF transmit, amplifier off, VGA 20, deviation 2.5 kHz. The phone was not keyed. Voice-filter hold on (`data hold action=1 sr=0`).

The held-path clip `tools/pocsag-research/rx/recordings-armor26/rx_p512_held.wav` (8 kHz, RIC 1001, "ALPHA ONE") does not decode until a one-pole high-pass of 1.6 ms is inverted. That coefficient is on the Armor profile. The inverse runs only when the preamble period is within 1.5 samples of 15.625 (512 baud). A 1200 baud preamble measures about 6.7 samples, so it is not restored. 1200 and 2400 use the phone's held-path taps. Those taps turn the 512 baud address into RIC 123617, so they are not used at 512.

| Check | Result |
|---|---|
| Host, 512 clip, restore 1.6 ms | RIC 1001, text starts with ALPHA |
| Host, 1200 clip `rx_g1200.wav`, taps | RIC 1002, "STILL 1200" |
| Host, 2400 clip `rx_g2400.wav`, taps | RIC 1003, "STILL 2400" |
| Air, 1200, RIC 1002, "STILL 1200" | Exact, corrected 0 |
| Air, 2400, RIC 1003, "STILL 2400" | Exact, corrected 1 |
| Air, 512, RIC 1001 | RIC 1001 each time. "RESTORE A" and "FOR CONTACT" exact, corrected 0. "RESTORE B" and "RESTORE C" kept the RIC and damaged the last character |
| Contact diagnostic | Saved through the contact store. The following 512 baud page filed on that contact (`c:117`). The row was deleted afterward |
| Monitor, 467.625 and 467.650, 1200 baud, repeat 3 | 15 steps. Dwell 1 s, preamble checked every 150 ms, hold 1 s after the preamble. "RIGHT THREE" on 467.650 was exact, corrected 0. "LEFT THREE" on 467.625 was not listed. Four other listings were not the sent texts |

Pager receive was turned off. The radio was put back on channel 2.

## POCSAG 512 baud threshold (2026-10-27, 09:26)

One threshold per batch, the mean of the sync-word samples. No running mean across the bits. The generator's 512 baud file, resampled to 8 kHz, decodes as RIC 1001 with that threshold. A three-error address opens no page.

On the held path at 2.5 kHz the same build still did not do 3/3. RIC 1001, text "ALPHA ONE", was listed as RIC 123617. "ALPHA TWO" and "ALPHA THREE" were not listed. Monitor mode stepped 467.625 and 467.650 MHz and listed no page during those two transmissions. The contact was not saved, so the page to RIC 1001 filed under `ric:1001`.

## POCSAG parity check and 512 baud (2026-10-27, 09:00)

Held path, 2.5 kHz, channel 2, phone not keyed. An address word is corrected only in its 31 BCH bits, then the even-parity bit has to match or the word is unreadable. A page with a failed address is stored as RIC unreadable and keeps its text. Hear pages refuses to start when the module tag is not bench firmware. The 512 baud slicer sets its threshold to the average of each sync word.

| Check | Result |
|---|---|
| 512, RIC 1001, three texts | Not 3/3. One listing was RIC 123617 with the text, and the same text was also stored as unreadable. Another text was missed. A third came back as RIC 123617 with a damaged text. |
| Signed page, RIC 3003, text starting with the bench callsign | RIC 3003, thread `call:` the callsign |
| Bare page, RIC 3004 | RIC 3004, thread `ric:3004`, text one character short, one bit repaired |
| Monitor 467.625 and 467.650 | The radio stepped to both. The pages decoded during the step were not the two texts that were sent. |

The contact-thread case was not shown: the temporary contact row did not get used, and the page filed under the RIC.

## POCSAG receive, held path (2026-10-27, 08:31)

No firmware change. Image `7126749f…b779`, channel 2, 467.625 MHz. HackRF transmit on the channel, amplifier off, VGA 20, deviation 2.5 kHz. The phone was not keyed. Pager receive on, voice-filter hold on.

| Rate | Sent | Heard | Result |
|---|---|---|---|
| 1200 | RIC 1002, three texts | 3/3 | RIC, text and baud exact, corrected 0 |
| 2400 | RIC 1003, three texts | 3/3 | RIC, text and baud exact, corrected 0 |
| 512 | RIC 1001, two texts | 1/2 | The one listing kept the text and baud and reported RIC 123617 |

With the hold off, one 1200 baud page kept the text and reported RIC 16330.

## Two-frame M17 SMS (2026-10-26, 23:24)

Text `two-frame-sms-0123456789ab`, 26 bytes. The SMS buffer is 30 bytes, so two frames: counter 0, then the last frame's valid-byte count 5. Image `7126749f…b779`, channel 2, 467.625 MHz, low power. The station callsign was the bench callsign only while the phone transmitted, and it was put back.

Transmit, three times, HackRF LNA 8 / VGA 8, clip 0. The host decoder read each one payload-exact with the CRC good, counters 0 then 5, link setup `N0CALL` to `@ALL`. The link setup is 50 ms before the strongest slice; a window that starts on the slice itself still has the counters and the text.

Receive, three times, HackRF on 467.625 MHz, amplifier off, VGA 20, a dummy burst first. The phone logged the same text from `N0CALL` to `@ALL`, 3/3.

A packet whose CRC fails is not listed. The history line is "M17: frames lost". Host test: a good "hi" is delivered, and a copy with the CRC byte flipped notes frames lost once and delivers nothing.

End state: `DMR003.FW27.V022` sha `7126749f…b779`, channel 2, 467.625 MHz, not transmitting. Battery 38.1 °C, `mtktsAP` 45.3 °C, `mtktsbtsmdpa` 43.9 °C. HackRF idle.

## M17 SMS, packet mode (2026-10-26, 23:10)

No firmware change. Image `7126749f…b779`, tag `DMR003.FW27.V022`, channel 2 at 467.625 MHz, low power. The station callsign was the bench callsign only while the phone was transmitting these texts, and it was put back afterwards.

The voice stream had gone silent again after the receive run (`ERROR a cannot be empty` at 22:47). Factory image `90e361fd…8c10` loaded at 22:54:16 (boot peak 0.063, nothing above +10 dB). Channel 4, digital, 467.700 MHz, power 0, SignalDeck PTT for 3 s: `0x36` body `03` at 22:55:18.361, body `04` at 22:55:22.395, HackRF LNA 16 / VGA 16, centre 467.460 MHz, peak 18.0 dB over the quiet second. The bench image loaded again at 22:58:57 (boot peak 0.045). Runner `stream` at 22:59:28 passed: 1125/1125, carrier 45.41 s, p99 2896 Hz, clip 0, end bit set.

Receive, before that recovery, HackRF transmit on the channel (467.625 MHz, amp off, VGA 20, 2 MS/s): 9/9 payload-exact, `N0CALL` to `@ALL`, texts `A`, `hello` and `packet check 26`, three times each, logged 22:43:53–22:44:31. An earlier pass 240 kHz low was 0/9 and is not counted.

Transmit, after the stream pass, HackRF receive at the runner's offset, LNA 8 / VGA 8. Each text once. The host decoder needs the window to start at the strongest 50 ms: the key-up and the unkey are about 19 kHz wide, and the 4FSK body is p99 about 2840 Hz, clip 0.

| Text | Bytes | CRC | Link setup | Body p99 |
|---|---|---|---|---|
| A | 1 | good | N0CALL → @ALL | 2845 Hz |
| hello | 5 | good | N0CALL → @ALL | 2841 Hz |
| packet check 26 | 15 | good | N0CALL → @ALL | 2827 Hz |

One exchange both ways: the HackRF sent `ping` and the phone logged it from `N0CALL` to `@ALL`; the phone's reply `pong` decoded with the CRC good and the same link setup (window 50 ms before the strongest bin). The symbol file is 192 bytes, one packet frame. Carrier about 0.45 s.

End state: `DMR003.FW27.V022` sha `7126749f…b779`, channel 2, 467.625 MHz, not transmitting. Battery 38.6 °C, `mtktsAP` 45.7 °C, `mtktsbtsmdpa` 44.2 °C. HackRF idle.

## The symbol stream is back on 7126749f after the factory image (2026-10-26, 21:25)

Step 1 of the 21:25 task. Loaded `7126749f…b779` again at 21:23:53, over the factory image. Boot peak 0.135 dB, nothing above +10 dB, clip 0. Channel 2, 467.625 MHz. Runner `stream` at 21:24:16 passed: 1125 of 1125 payload-exact, end bit set, carrier 45.41 s, p99 2862 Hz, clip 0.

The log buffer still held the end of that run: `sym last op 7 fill=1536` at 21:25:01.272, `sym done bytes=54144` at 21:25:01.315, status 4 at 21:25:01.826, `0x26` off (`sr=0`) at 21:25:01.834, `sym unkey`, and a second status 4 at 21:25:02.156. The `sym reset`, `sym ready fill=` and `sym key` lines, and the `0x26` down, had already left the buffer. The 45.41 s carrier is the proof the key was accepted.

Steps 2 and 3 were not run. A decoded 1125-frame carrier is not a deaf HackRF, and it is not a refused key. What stands between the silent runs and this pass is the factory-image load and the stock digital PTT on channel 4. The 15 s `pwd` off, the digital tune, the module restart, and the FW26 load did not restore the stream. The factory load did, and the variant-6 image then keyed normally.

End state: `DMR003.FW27.V022` sha `7126749f…b779`, VFO 467.625 MHz, low power, not transmitting. `mtktsAP` 41.0 °C, battery 34.5 °C. HackRF idle.

## Symbol stream still silent after a power-off, a digital tune, and FW26 (2026-10-26, 21:10)

Steps 1–4 of the 20:55 task, on the image that was already loaded (`7126749f…b779`) until step 4.

Before one failing stream, `0x34` read `DMR003.FW27.V022`. `0x25` read `28 64 DF 1B 28 64 DF 1B 01 00 02 00 00 00 00 02 08 02 02`: both frequencies 467.625 MHz, power 0, squelch 2, volume 8. `0x24` read 163 bytes beginning `E8 27 E7 17`. The 19:22:46 pass did not keep its RadioService log; its runner line is carrier 45.41 s, p99 2855 Hz. The failing `cmdsym` at 20:58:01 produced only status byte 4, at 20:58:47.095 and 20:58:47.422, then `0x26` off `sr=0`. No status 3. The capture was no carrier.

`dmr009` `pwd` was held at 0 for 15 s and read back `pwd :0`, then set to 1. `0x34` answered `DMR003.FW27.V022`. The stream at 21:00:04 was no carrier. VFO off, channel 4 (digital, 467.700 MHz, not keyed), then channel 2. The stream at 21:01:32 was no carrier.

FW26 `71949d24…a34e` loaded at 21:05:16, boot peak 0.041 dB. The stream at 21:05:36 was no carrier. The factory image `90e361fd…8c10` loaded at 21:09:33, boot peak 0.095 dB, tag `DMR003.UV4T.V022`. On channel 4, low power, SignalDeck's own PTT for 3 s: the status API said transmitting, status 3 then status 4, and the HackRF file (LNA 16, VGA 16, centre 467.460 MHz) had a per-second RMS ratio of 3.38, 10.6 dB. Stock digital TX radiates. The symbol stream was not restored by any step.

End state: factory image, channel 2, 467.625 MHz, power byte 1, not transmitting. HackRF idle.

## FW27 symbol stream is silent on the variant-6 image too (2026-10-26, 20:50)

Bisect step 1 of the 20:45 task. Rebuilt `7126749f…b779` from the variant-6 source and loaded it at 20:44:34. Boot peak 0.054 dB, clip 0, channel 2, 467.625 MHz, not transmitting. Runner `stream` at 20:44:54 returned `ERROR a cannot be empty`. The 53 s capture's per-second RMS ran from 2.16 to 4.05, a ratio of 1.87 (5.4 dB), so the file is no carrier. Status byte 4 and `0x26` off `sr=0` are in the log, as on `f8298581…3ef8`.

A single channel write (`/api/channel/select` number 2) at 20:46 left channel 2 at power byte 1. The stream at 20:46:36 failed the same way. `restartmodule` at 20:47:49 brought `0x34` back, and the stream at 20:48:15 failed again (status 4 at 20:49:01, `0x26` off `sr=0`).

Runner `tone` at 20:49:35 on the same image passed: carrier 10.85 s, clip 0, p99 2705 Hz, 1 kHz line 2640 Hz. The tone path radiates. The symbol path does not, on the image whose 19:29 stream was 1125/1125, and neither prescribed clear restored it.

The two images differ in the opcode-13 hole, eight bytes at the mode-5 restore (`0x5BD68`), one byte in the low stub (`0x5BCB0`), one byte in the trampoline (`0x5C566`), and the tail pool. That diff is not the cause of this failure.

End state: `DMR003.FW27.V022` sha `7126749f…b779`, VFO 467.625 MHz, low power, not transmitting. Battery 33.4 °C, `mtktsAP` 41.4 °C. HackRF idle.

## FW27 variant 7 lowers AT1846S register 0x44 (2026-10-26, 20:34)

Wi-Fi ADB. `persist.adb.tcp.port` reads `5555` after the reboot with USB attached, and `adb connect 192.168.1.125:5555` succeeded without `adb tcpip` once the phone associated. Association waited until the Wi-Fi panel was opened. USB was unplugged after both transports had listed. Own-the-radio-at-boot is off, so SignalDeck was started after the reboot. This session's connect still answers, and the property still reads `5555`.

The FM branch of `at1846_tune` writes `0x42` = `0x1052`, `0x43` = `0x0100`, and `0x44` = `0x0AD1` (the tune table above). `0x42` and `0x43` are constants. Guide register 44h names bits 11:8 `gain_tx`, bits 7:4 the DAC gain, and bits 3:0 the digital volume. OpenRTX calls bits 7:0 the receive volume. The field tried is bits 7:4, with bits 11:8 held at `0xA` and bits 3:0 held at `1`. The C7000 FM receive input is the AT1846S demod audio (guide §7.2.2.3.2). The receive count scale is `FM_DEV_COEF` bits 15:8, already measured as a gain after the limiter. This image programs no separate C7000 FM input-gain field.

The first stage D image `ab726955…9a52` encoded the I²C branch from a file-offset PC, so the call landed at XIP+`0x2B220`. `[6, 7, 0x81]` and the following `[6, 5, 0]` got no reply. `restartmodule` returned `DMR003.FW27.V022`. The loaded image is `f8298581…3ef8`. Its three I²C calls use the XIP PC and land on IRAM `0x2B220`, the helper mode 5 uses for `0x58`. Variant 7 writes `0x44` with the value byte as the low byte and acks through variant 6's empty ack. Mode 5 off writes `0x58` = `0x8405` and `0x44` = `0x0AD1`. Load boot peak 0.041 dB, clip 0. Channel 2's power byte was 1 before the load. At 20:18, `[6, 7, 0x81]`, `[6, 5, 1]`, and `[6, 5, 0]` each returned `sr=0 len=0`.

1 kHz tone, HackRF VGA 20, centre 467.625 MHz, phone not keyed, mode 5 on. Amplitude is the same Hann `2/N` peak as the 16:53 table. `0x81` matches that table. `0x41` is twice that table at every step, ceiling included. A straight line through the 0.5 kHz point is about 12900 at `0x81` and about 25600 at `0x41` for 2.4 kHz. The measured points are 6001 and 11795, the same fraction of the line as the stock curve (about 0.46). The knee stays at 1 kHz of deviation. The 30-frame file was not sent.

| Deviation kHz | stock `0x10` (16:53) | `0x81` | `0x41` |
|---:|---:|---:|---:|
| 0.5 | 2774 | 2693 | 5344 |
| 1.0 | 4377 | 4359 | 8580 |
| 1.5 | 5445 | 5481 | 10802 |
| 2.0 | 5888 | 5895 | 11595 |
| 2.4 | 5980 | 6001 | 11795 |
| 3.0 | 6017 | 6052 | 11888 |
| 3.5 | 6034 | 6068 | 11913 |
| 4.0 | 6032 | 6061 | 11904 |

Channel 56, mode 5 off, 1 kHz deviation, the steady half-second after the squelch opens. The 2.5 kHz dummy is not these numbers. `0x81` reads 44 at 500 Hz and 134 at 1000 Hz, −19.6 dB against the 19:28 clip's 1280. `0x41` reads 24 and 71, −25.1 dB. The 500 Hz dip stays about 9.5 dB. The phone path follows this register. The receive-RAM knee stays put. The route is closed on this phone. The audio path with the taps is the M17 receiver. The stream remains the path for a phone without a flat audio path, and for a mode that stays inside ±1 kHz.

Runner `all` on `f8298581…3ef8`. Boot peak 0.073 dB. Tone carrier 10.535 s, p99 2490 Hz, clip 0. Receive −19.0 dBFS. Heat, 45 s at low power: `mtktsAP` 38.7 to 39.6 °C, battery 32.0 to 32.3 °C. The symbol stream, tried at 20:23 and again at 20:33, accepted the `0x40` chunks (`sr=0`) and later sent status byte 4, with `0x26` off acked. Both HackRF files stayed within 6 dB of their quietest second, so the capture is no carrier. The tone path on this image did radiate.

End state: `DMR003.FW27.V022` sha `f8298581…3ef8`, VFO 467.625 MHz, low power, not transmitting, mode 5 off. HackRF idle.

## FW27 variant 6 writes the receive coefficient (2026-10-26, 19:28)

The five `lrw` instructions in the hole of `b207ea72…9848` are the 32-bit form (file bytes `84 ea` or `80 ea`). The pool address is `(PC & ~3) + 4 × imm`, and each one lands on its own word: `0x5B820` → `0x4B008`, `0x5B826` → `0x5354524D`, `0x5B84C` → `0x11000504`, `0x5B852` → `0xFFFF00FF`, `0x5B85E` → `0x180000A0`. A short `lrw` was not the hang. The value-not-1 exit was replaced with a branch to a filter in the hole: value 1 returns to `0x5B2C2`, any other variant goes to `0x5B308` with `r15` and the stack untouched, and variant 6 calls the body and then takes the value-1 epilogue.

Three images, each with a quiet boot. **A** `d8a3aa19…3888` acks and touches nothing: `[6, 6, 0x08]` returned `sr=0 len=0`, and `[6, 5, 1]` still did. Boot peak 0.10 dB. **B** `4a0a34f8…8ffc` reads `0x11000504` and puts the word in the reply: `10 10 0f 00`, which is `0x000F1010` (limiter `0x0F`, receive `0x10`, transmit `0x10`). Boot peak 0.08 dB. A first **C** that mirrored the word at `0x180000A0` acked the write, and a byte read of that address through opcode 14 did not answer; `restartmodule` recovered `0x34`. The loaded **C** is `7126749f…b779`. Variant 6 is refused unless the mode-5 marker is set. It replaces bits 15:8, leaves the other bytes, and replies with the stored word through opcode 14's sender at `0x5C0F8`. `[6, 6, 0x08]` replied `10 08 0f 00`. `[6, 6, 0x04]` replied `10 04 0f 00`. `[6, 6, 0x10]` replied `10 10 0f 00`. Boot peak 0.10 dB on the load and 0.06 dB on the runner's restart.

The 1 kHz tone, HackRF VGA 20, centre 467.625 MHz, phone not keyed. Amplitude is the same Hann `2/N` peak as the 16:53 table. A control at `0x10` and 1.0 kHz deviation read 4375, against that table's 4377. The byte is an inverse gain: at 0.5 kHz, `0x08` is twice `0x10` and `0x04` is four times.

| Deviation kHz | `0x10` (16:53) | `0x08` | `0x04` |
|---:|---:|---:|---:|
| 0.5 | 2774 | 5541 | 11094 |
| 1.0 | 4377 | 8763 | 16361 |
| 1.5 | 5445 | 11030 | 18903 |
| 2.0 | 5888 | 11824 | 20568 |
| 2.4 | 5980 | 12026 | 20565 |
| 3.0 | 6017 | 12114 | 20516 |
| 3.5 | 6034 | 12142 | 20760 |
| 4.0 | 6032 | 12127 | 20991 |

Both new curves are on the ceiling by 2.4 kHz (about 12100 at `0x08`, about 20600 at `0x04`). A straight line through the 0.5 kHz point would be about 26600 and 53300 there. No value in this pair keeps 2.4 kHz linear, so the 30-frame decode was not run. A larger coefficient byte is the direction that lowers the gain.

Channel 56, 1 kHz deviation, mode 5 off, the coefficient left at the value variant 6 wrote. 500 Hz reads 424 and 1000 Hz reads 1281 at `0x08`, and 424 and 1280 after writing `0x10`. The 17:05 clip at `0x10` was 420 and 1267. The phone path still has the 9.6 dB dip at 500 Hz, and it does not follow this coefficient. `[6, 5, 0]` acks and does not rewrite the coefficient. Writing `0x10` does, and a module restart returns the register to `0x000F1010`.

Runner `all` on `7126749f…b779` passed. Boot peak 0.057 dB. Tone carrier 10.5 s, p99 2489 Hz, hottest half-second 3982 Hz, clip 0. Heat: 45 s low power, `mtktsAP` 39.4 to 40.1 °C, battery 31.9 to 32.1 °C. Stream 1125/1125, p99 2855 Hz. Receive clip −19.0 dBFS.

End state: `DMR003.FW27.V022` sha `7126749f…b779`, channel 2, 467.625 MHz, not transmitting, coefficient `0x10`, mode 5 off. HackRF idle.

## FW27 variant 6 does not answer (2026-10-26, 18:24)

Image `b207ea72cf3b908ce82a53f80f7b223805ad62f8627c536f64c0534f74239848`. The register trailer is no longer sent; a stream half is op 5's 514-byte body. Variant 6 lives in the opcode-13 hole and is reached from the opcode-6 handler, which used to leave any value other than 0 or 1. `[6, 5, 1]` returns `sr=0`. `[6, 6, 0x08]` is transmitted and no reply arrives within 800 ms. `restartmodule` recovers `0x34`. No deviation sweep was run. Boot peak 0.11 dB. Channel 2, 467.625 MHz, not transmitting.

## FW27 variant 6 does not fit (2026-10-26, 17:20)

No new image. On `e552549c…b2dc`, `WRAP_END` is `0x5C6EC` and the tail through `0x5C6FB` is 16 bytes. The low hole ends at `0x5BE5C` with 4 bytes before the literal pool. The high piece ends at `0x5C098`. `regsend` at `0x5C590` is the live half send: file `0x5C032` branches to it. A read-modify-write of `0x11000504` with the mode-5 check does not fit in 16 bytes. Nothing was loaded. Details in the Stuck block of `HANDOFF.md`.

## FW27 deviation sweep with a 300 Hz tone (2026-10-26, 17:12)

Image `e552549c…b2dc`. The same deviation steps as the 1 kHz-tone sweep, now with a 300 Hz tone, HackRF VGA 20, centre 467.625 MHz, phone not keyed. Amplitude is the Hann-windowed peak of a steady half-second. The 1 kHz-tone column is the earlier sweep.

| Deviation kHz | 300 Hz tone | 1 kHz tone |
|---:|---:|---:|
| 0.5 | 2805 | 2774 |
| 1.0 | 4439 | 4377 |
| 1.5 | 5543 | 5445 |
| 2.0 | 5801 | 5888 |
| 2.4 | 5852 | 5980 |
| 3.0 | 5888 | 6017 |
| 3.5 | 5994 | 6034 |
| 4.0 | 5970 | 6032 |

The two curves match. A straight line through the 0.5 kHz point is about 5610 counts per kHz, which would be about 13 500 at 2.4 kHz. Both tones are already at 1.58 times the 0.5 kHz amplitude by 1.0 kHz, and both sit near 6000 counts from 2.4 kHz up. A channel filter that passed 300 Hz and cut 1 kHz would have kept the 300 Hz curve straighter. It did not.

`FM_BANDWIDTH` at `0x11000500`, hardware reset. Bit 1 `fmbandwidth_r` reset 1 is the receive bandwidth, 0 for 12.5 kHz and 1 for 25 kHz. Bit 0 is the CTCSS receive bandwidth. Bits 2, 3 and 4 are transmit (adjacent-channel filter, transmit bandwidth, pre-emphasis). A receive-only change is bit 1. The stub still has 4 bytes free, which is not a read-modify-write, and the two curves already say the ceiling is not that filter, so op 6 variant 6 was not built.

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, not transmitting. `0x34` answers. HackRF idle.

## FW27 sweep at 1 kHz deviation, and the reduced-deviation file (2026-10-26, 17:05)

Image `e552549c…b2dc`. HackRF VGA 20, 467.625 MHz, phone not keyed. The 1 kHz-deviation sweep uses the same tones as the 2.5 kHz sweep. Amplitude is the Hann-windowed peak of a steady half-second. Decibels are relative to 1000 Hz in that capture. The stream's no-carrier second is DC +4.1, rms 54.

At 1.0 kHz deviation the stream is below the 6030-count ceiling (the 1000 Hz tone reads 4378) and stays within 0.2 dB from 100 Hz to 2.5 kHz. It is 0.5 dB down at 3 kHz and 1.3 dB down at 3.5 kHz. Channel 56, hold `action=1 sr=0`, still has the 9.6 dB dip at 500 Hz.

| Hz | Stream | dB | Channel 56 | dB |
|---:|---:|---:|---:|---:|
| 100 | 4437 | +0.1 | 1454 | +1.2 |
| 200 | 4447 | +0.1 | 1372 | +0.7 |
| 300 | 4448 | +0.1 | 1052 | −1.6 |
| 500 | 4422 | +0.1 | 420 | −9.6 |
| 700 | 4398 | 0.0 | 821 | −3.8 |
| 1000 | 4378 | 0 | 1267 | 0 |
| 1500 | 4405 | +0.1 | 1510 | +1.5 |
| 2000 | 4373 | 0.0 | 1575 | +1.9 |
| 2500 | 4317 | −0.1 | 1580 | +1.9 |
| 3000 | 4132 | −0.5 | 1576 | +1.9 |
| 3500 | 3775 | −1.3 | 1568 | +1.8 |

The same 30-frame file through the plain stream, deviation scaled from the ±2.4 kHz original. Host decode of each body: 30 frames every time, link-setup CRC failed, and the host Golay count (`lerr` ≤ 2) was 0 at every step. Payload-exact frames: 21 at 40 percent, 8 at 60, 4 at 80, 3 at 100. The four bodies are `stream-dev40.s16` through `stream-dev100.s16` in `tools/m17-research/captures/fw27-stream/`.

Guide, `radio_firmware/HR_C7000_user_guide.pdf`. §7.2.2.3.2 (printed p. 271) is the analog receive recording into RX RAM. The receive scale is in the FM map, §11.2.2.3 `FM_DEV_COEF` at `0x11000504`, hardware reset. Bits 15:8 `fm_dev_coef_r` reset `0x10` are the receive deviation coefficient. Bits 23:16 `tr_sig_lim` reset `0x0f` and bits 7:0 `fm_dev_coef_t` reset `0x10` are the transmit limiter and the transmit coefficient. `DEV_LIMITER` at `0x11000118`, reset `0xff00`, is transmit only. `PHASE_OUT` at `0x11000128` is a read-only AF phase range. A whole-word write of `FM_DEV_COEF` would change the transmitter. A write of bits 15:8 alone is the receive scale. The stub has 4 bytes free, which is not a read-modify-write of that word, so op 6 variant 6 was not built and nothing new was loaded.

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, not transmitting. `0x34` answers. HackRF idle.

## FW27 carrier offset and deviation (2026-10-26, 16:53)

Image `e552549c…b2dc`. 1 kHz tone, HackRF VGA 20, phone not keyed. The stream was period 8. DC is the mean of the steady second after the first half-second of each transmission. Amplitude is the Hann-windowed 1 kHz peak of that same second.

Carrier offset, deviation held at 2.5 kHz. The HackRF centre moved around 467.625 MHz. The steady mean stays near +7 counts from −1000 Hz to +1000 Hz. It does not draw a line against offset, so this stream has no counts-per-hertz scale for a carrier error. Each transmission opens with a transient of about +800 to +1300 counts that is gone within half a second, at both ends of the offset list.

| Offset Hz | DC | 1 kHz amplitude |
|---:|---:|---:|
| −1000 | +8.0 | 5716 |
| −500 | +7.3 | 5835 |
| −200 | +4.0 | 5086 |
| 0 | +6.3 | 5993 |
| +200 | +7.8 | 6024 |
| +500 | +7.9 | 6024 |
| +1000 | +6.3 | 6003 |

Deviation, centre on 467.625. A straight line through the 0.5 kHz point is 5548 counts per kHz. The measured amplitude is already below that line at 1.0 kHz and is flat from 2.4 kHz to 4.0 kHz, at about 6030.

| Deviation kHz | Amplitude | Line through 0.5 kHz |
|---:|---:|---:|
| 0.5 | 2774 | 2774 |
| 1.0 | 4377 | 5548 |
| 1.5 | 5445 | 8322 |
| 2.0 | 5888 | 11096 |
| 2.4 | 5980 | 13315 |
| 3.0 | 6017 | 16644 |
| 3.5 | 6034 | 19418 |
| 4.0 | 6032 | 22192 |

The 2.0 kHz step was repeated in a second capture and read 5886.

The two plain-stream captures and a channel-56 recording of the same 30-frame file are in `tools/m17-research/captures/fw27-stream/`. The 15:55 channel-56 pass was a listing, so `channel56.s16` is a new recording of that file with the hold at `action=1 sr=0` (16:51).

The stop frame the bench sends is the same bytes SignalDeck logs: `68 40 01 01 75 BC 00 02 11 00 10`. At 15:23 that frame, sent by `raw40` four seconds into a running stream, was acked `sr=0` six milliseconds later. Nothing waits for a gap after the last half. The same bytes from `ramstream` off were acked at 16:50 (`sr=0`, then `0x34` at 57600 and mode 5 off `sr=0`) and unanswered at 16:27 and 16:53.

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, not transmitting. `0x34` answers. HackRF idle.

## FW27 stream response, eye, and the miss recount (2026-10-26, 16:37)

Image `e552549c…b2dc`. HackRF at 467.625 MHz, VGA 20, 2.5 kHz deviation, 4 s per tone. The phone did not key. Amplitudes are the Hann-windowed FFT peak of a steady half-second, and the decibel column is relative to the 1000 Hz tone in that same capture.

The stream, period 8, no carrier for the 3 s before the first tone: DC +5 counts, rms 55. A tone sits at rms about 8600 to 9000, so the idle stream is 44 dB down. Across 100 to 3500 Hz the stream amplitude stays within 0.5 dB of the 1000 Hz tone.

| Hz | Stream | dB | Channel 56 | dB |
|---:|---:|---:|---:|---:|
| 100 | 5724 | −0.4 | 3640 | +1.2 |
| 200 | 5756 | −0.4 | 3433 | +0.7 |
| 300 | 5857 | −0.2 | 2631 | −1.6 |
| 500 | 5860 | −0.2 | 1052 | −9.6 |
| 700 | 5801 | −0.3 | 2066 | −3.7 |
| 1000 | 5994 | 0 | 3173 | 0 |
| 1500 | 5980 | 0.0 | 3729 | +1.4 |
| 2000 | 5844 | −0.2 | 3912 | +1.8 |
| 2500 | 5672 | −0.5 | 3933 | +1.9 |
| 3000 | 5682 | −0.5 | 3904 | +1.8 |
| 3500 | 5770 | −0.3 | 3857 | +1.7 |

Channel 56 had the hold at `action=1 sr=0` for that clip. An earlier clip whose hold did not ack drew the same curve, including the 9.6 dB dip at 500 Hz. The stream does not have that dip.

The saved plain-stream body (halves 213..258 of the 15:52 capture), after sync normalisation, 5704 symbols:

| Level | Count | Mean | Std |
|---:|---:|---:|---:|
| −3 | 2376 | −3.00 | 0.43 |
| −1 | 571 | −1.27 | 0.56 |
| +1 | 1025 | +1.07 | 0.53 |
| +3 | 1732 | +3.37 | 0.76 |

`heldpath_eq.py --taps 20` on wavs cut from a later stream capture found no frame that matched its training pattern, so it wrote no taps. On the 15:52 body the transmitted frames correlate at 0.89 for one frame and about 0.43 for the rest, which is not a training set. A second copy of the same 30-frame file, captured at 16:36, decoded to 30 frames and 3 payload-exact, and the link-setup CRC failed. The 15:52 body remains 30 frames and 4 payload-exact. Channel 56's listing of that file is still 30 frames, 96 percent clean.

The 13.3 s stop counted 415 halves. At 31.25 per second that interval holds 416. The 50.5 s stop counted 1579 halves, and 50.5 s holds 1578. A skipped sequence would have made the count short. Counted by the sequence byte alone the misses are 0, and the 18 and the 47 are the half-id rule. The saved files are the samples only, so there is no per-gap list.

`ramstream` off at 16:27, process 13933:

```
16:27:10.842 TX cmd=0x40 rw=1 sr=1 len=2 [11 00]  <68 40 01 01 75 BC 00 02 11 00 10>
16:27:11.843 ram stream stop: no answer
16:27:11.845 TX cmd=0x40 rw=1 sr=1 len=2 [10 00]  <68 40 01 01 76 BC 00 02 10 00 10>
16:27:11.858 ram stream rate 57600: sr=0
16:27:11.861 UART /dev/ttyS0 open @ 57600 (stock serial library)
16:27:11.866 TX cmd=0x34 rw=1 sr=1 len=1 [01]  <68 34 01 01 95 B9 00 01 01 10>
16:27:14.892 ram stream: no version at 57600 after the switch back
16:27:15.895 ram stream mode 5 off: no answer
```

`adb logcat -b crash -d` was empty. `/data/tombstones` has nothing from today. Process 20936 was still logging the first heat key at 16:02:09 and was gone by 16:03:23. No app change.

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, not transmitting. `0x34` answers. HackRF idle.

## FW27 stream clock, the quiet run, and the 30-frame compare (2026-10-26, 16:13)

Image `e552549c…b2dc`, tag `DMR003.FW27.V022`. Channel 2 at 467.625 MHz except the channel-56 pass. The phone did not key during any HackRF transmission. VGA 20, 2 MS/s, 2.5 kHz deviation for the tone. Period 8.

The 1 kHz tone was on the air before the first half. A 4 s FFT (0.25 Hz bins) peaks at 1000.00 Hz, so the capture clock is 8000 Hz and the half rate is 31.250 per second. The 14 s file has 443 halves and the 52 s file has 1610. No two consecutive halves are identical. The 1 kHz amplitude is about 5970 from half 0 until the tone ends. The 15:25 file's 1 kHz bin stayed under about 1100, so its 987.25 Hz reading was the noise floor of that file.

The host counts a miss from the sequence byte at body[512] (the slot, 0 through 5) and the half id at body[513]. A sequence that is not the next slot adds the forward gap modulo 6, and a repeated half id on the next slot adds 1. Op 5's send writes those two bytes. On this image: 415 halves (13.3 s), 18 missed; 1579 halves (50.5 s), 47 missed. An earlier run whose tone started after the stream reported 591 halves (18.9 s), 0 missed, and the M17 stream reported 341 halves (10.9 s), 0 missed. The tone amplitude stays flat and no halves repeat, so those misses are not a gap in the saved audio. The 83-on-10 s and 0-on-45 s figures were the previous image.

There is no quiet hole after the start. The only run under a quarter of the tone amplitude is the tail after the HackRF stops: halves 403..442 (1.28 s) on the 14 s file, halves 1561..1609 (1.57 s) on the 52 s file. The 52 s stream was still sending at 50.5 s. Its first keepalive logged no answer, which is what action 2 does in the sniffer (the 30 s count is reset and no ack is sent). `ramstream` off on these runs still logged stop with no answer, rate `sr=0`, then no version at 57600; `restartmodule` brought `0x34` back. The explicit 15:23 sequence is unchanged.

(c) One 30-frame transmission, 1.6 s unmodulated lead, 0.5 s tail. The plain stream (identity taps) listed 30 frames, 46 percent clean, which is the share whose LICH Golay errors are 2 or fewer. A host decode of the loud slice, halves 213..258, found 30 frames and 4 payload-exact, and the link-setup CRC failed. The same file again on channel 56 with mode 5 off: the hold answered `action=1 sr=0`, and the listing was 30 frames, 96 percent clean, at −87 dBm.

Runner `all` on this image, low power. A first pass at 15:56 recorded NO CARRIER and the app process was gone afterwards. SignalDeck was started again. The 16:04 pass:

| Test | Result |
|---|---|
| boot | PASS silent, peak 0.271 dB, clip 0, tag still FW27 |
| tone | PASS, carrier 10.539 s, clip 0, p99 2531.5 Hz, 1 kHz line 2437.5 Hz, hottest half-second 4035.7 Hz |
| stream | PASS 1125/1125, carrier 45.41 s, p99 2900.8 Hz, clip 0, end bit set |
| receive | PASS, clip −19.1 dBFS, 1 kHz line 1.5 times the noise |
| heat | PASS, 45 s low power, `mtktsAP` 46.861 → 47.602 → 47.196 °C, battery 39.1 → 39.3 °C, no stop |

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, VFO off, not transmitting. `0x34` answers. HackRF idle.

## FW27 stop path and the stream rate (2026-10-26, 15:25)

Literal guard, host only. `tools/fw-patch/literal_guard.py` reads objdump's `lrw` lines. A load counts when the next instruction reads that register and the pool word is not zero, and the `04 00` sine-table pattern is not a load. FW22→FW23, FW23→FW24, FW24→FW25, FW25→FW26 and the shipped FW27 against FW26 have no such load. Painting `0x5BE60`–`0x5BEE0` on FW26 reports the key helper at `0x5BBE2` loading `0x5BEA0`.

Stop path on image `e552549c…b2dc` (the shipped image plus an ack at the end of the stream loop). Boot peak 0.079 dB, clip 0. The stream was up at 230400. `[17, 0]` acked `sr=0` at 15:23:43.936. `0x34` at 230400 answered at 15:23:44.614, tag `DMR003.FW27.V022`. `[16, 0]` acked `sr=0` at 15:23:45.513. After the port reopened, `0x34` at 57600 answered at 15:23:45.524, and `[6, 5, 0]` acked `sr=0` at 15:23:45.573. No restart.

A 1 kHz HackRF tone, 8 s, VGA 20, while the stream ran (the phone did not key). The saved audio is 10.432 s, 326 halves, 0 identical consecutive halves. Read as 8 kHz the tone is 987.25 Hz, so the capture clock is 8103 Hz and the half rate is 31.65 per second, against 31.25 from 8000/256. The file's half rms stays about 5500 from the first half; it does not show the earlier 1.5 s quiet run. The 45 s run and (c) were not repeated on this image.

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, not transmitting. `0x34` answers. HackRF idle.

## FW27 keys again (2026-10-26, 14:46)

The old image (`9ea5365c…ded5`) hung inside the key, on a warm boot and after SRAM was lost. Opcode 14 cannot read `0x4B360` (it accepts only `0x18000000`–`0x1800FFFF`), so those words were not observed. The `0x34` after `0x26` down did not answer either time.

| | 0x34 | op 14 of `0x4B360` | 0x26 down | 0x34 within 1 s | 0x26 up | 0x34 |
|---|---|---|---|---|---|---|
| 14:15, warm boot of `9ea5365c` | TX 14:15:50.309, RX 14:15:50.318 `sr=0` | not sent (the body file was not readable) | TX 14:15:50.984, no RX, no status 3 | TX 14:15:51.055, no RX | TX 14:15:51.951, no RX | no RX |
| 14:17, `dmr009` low for 10 s, then boot | TX 14:17:15.685, RX 14:17:15.694 `sr=0` | TX 14:17:14.393, RX 14:17:14.399 `sr=1` len 0 | TX 14:17:16.363, no RX, no status 3 | TX 14:17:16.455, no RX | TX 14:17:17.327, no RX | no RX |

`0x7C56` is the UART receive loop's pend. `0x34` gets through it before the key, so that hook is not the hang. The key path is `0x9264` → `0x5B580` → `0x5BBE2`, and `0x5BBE2` loads its literals from `0x5BE60`–`0x5BEDC`. The old stub wrote opcodes over that pool (`0x5BEA0` is `0x0004A3E4` on FW26). No site-by-site reload: the pool names the site. The 13:58 tone log acked the channel write `0x23` and never sent `0x25`, `0x3B`, or a `0x40` tone setup.

The stub is now two pieces around that pool. Low is `0x5BCA4`–`0x5BE58` (the gate, mode 5, and the stream handler). High is `0x5BEE0`–`0x5C098` (the divisor, the rate switch, the half send, and the pend hook). `0x5BE60`–`0x5BEE0` is the FW26 bytes. Opcode 16 rate 2 takes the reject path; the register dump that used to answer it was removed so the stub would fit. Image sha256 `152358b005e5a239f09ffa5fa4e7be67f780431e5d1f68e536c102a47d94b4ad`, 378620 bytes. Loaded 14:35:38. Boot peak 0.141 dB, nothing above +10 dB, clip 0.

Low-power VFO at 467.625 MHz, then one key. `0x34` at 14:36:14.323 answered at 14:36:14.331. `0x26` down at 14:36:14.993 acked at 14:36:15.003 (`sr=0`), status 3 at 14:36:15.009. The `0x34` at 14:36:15.118 answered at 14:36:15.126. `0x26` up at 14:36:16.031 acked at 14:36:16.037, status 4 at 14:36:16.358. The following `0x34` answered. The radio was not left keyed.

Runner on that image, low power, 467.625 MHz:

| Test | Result |
|---|---|
| boot | PASS silent, peak 0.068 dB, clip 0, tag still FW27 |
| tone | PASS, carrier 10.565 s, clip 0, p99 2541.0 Hz, 1 kHz line 2439.5 Hz, hottest half-second 4015.2 Hz |
| stream | PASS 1125/1125, carrier 45.41 s, p99 2901.3 Hz, clip 0, end bit set |
| receive | PASS, clip −19.2 dBFS, 1 kHz line 1.5 times the noise |
| heat | PASS, 45 s low power, `mtktsAP` 46.991 → 47.804 → 47.399 °C, battery 38.9 → 39.1 °C, no stop |

A floor capture now reports NO CARRIER. The 13:58 FW27 file, which the old detector called a 16 s carrier, is carrier 0. The 13:55 FW26 file is still carrier 10.86 s, SNR 58.6 dB. The stop path, the half rate, the quiet hole, and (c) were not re-run.

End state: `DMR003.FW27.V022`, channel 2, 467.625 MHz, power byte 1, monitor off, VFO off, not transmitting. HackRF idle.

## Tone sandwich, FW26 / FW27 / FW26 (2026-10-26, 14:01)

No RAM overlap. The tone queue occupies `0x4B260`–`0x4B35F`. FW27's stores are the mode-5 saves at `0x4B000`/`0x4B004`/`0x4B008`, then `0x4B360`–`0x4B38B` in the gap before the factory name at `0x4B398`. The promiscuous flag at `0x4B364` is not in those stores. The 30 s count is written only while the rate flag is set. No word outside `0x5BCA4`–`0x5C098` points into that body.

HackRF was not power-cycled. Low power, 467.625 MHz, 10 s tone.

| Run | Tag | Key | Status 3 | Status 4 | RMS | p99 | 1 kHz line | SNR |
|---|---|---|---|---|---:|---:|---:|---:|
| 13:55:37 | FW26 | acked in 4 ms | 13:55:37.842 | 13:55:48.611 | −17.4 dBFS | 2726 Hz | 2570 Hz | 58.6 dB |
| 13:58:31 | FW27 | sent, no ack; unkey 13:58:42.378 | none | none | −38.3 dBFS, flat | 22377 Hz | 26 Hz | 0.5 dB |
| 14:01:26 | FW26 | acked | yes | yes | −14.1 dBFS | 2530 Hz | 2427 Hz | 62.2 dB |

FW27's boot before that tone peaked at 0.043 dB. End state: `DMR003.FW26.V022`, channel 2, VFO off, not transmitting.

## FW26 tone after the FW27 capture (2026-10-26, 13:28)

FW27 sha256 `9ea5365c…ded5` against FW26 sha256 `71949d24…a34e`. Changed ranges: `0x7C56` (4), tag `0x3846E` (1), `0x5B2A8` (4), `0x5B2C8` (4), `0x5B7E0` (2), `0x5B816` (4), stub `0x5BCA4`–`0x5C060`, tail `0x5C54C`–`0x5C6EB`. The stub passes `0x5BF84` and overwrites the opcode 13 playback through `0x5C096`. Callers of that body are `0x5B82C` and `0x5B83C`, both in the opcode 13 dispatcher, which `0x5B816` skips. `test_fw27.py` allows the whole span because `RECLAIM_END` is opcode 14 at `0x5C098`.

FW26 loaded 13:27:43. Boot peak 0.067 dB, clip 0. Runner `tone`: carrier 10.537 s, clip 0, p99 2533.2 Hz, 1 kHz line 2430.3 Hz, hottest half-second 4013.7 Hz, SNR 61.1 dB. The FW27 tone file is SNR 0.4 dB, p99 22388.8 Hz, line 25.4 Hz, carrier marked 16.0 s.

Stream files already saved, no new key. No two consecutive halves are identical. Interpolated 1 kHz peak: p1 999.98 Hz, p2 999.98, p4 999.97, the 45 s file 999.96 Hz. Quiet runs from the first saved half: the 10 s files about 1.7–3.0 s; the 45 s file halves 66–226, 2.11–7.26 s. End state: `DMR003.FW26.V022`, channel 2, VFO off, not transmitting.

## FW27 capture re-arm (2026-10-26, 13:02)

Image sha256 `9ea5365ca31e0aada446127290a460a128b89206a943cbda53129b52c4f9ded5`, 378620 bytes, tag `DMR003.FW27.V022`. Loaded 12:52:41. Boot peak 0.043 dB, nothing above +10 dB, clip fraction 0. A later regression boot was peak 0.059 dB, clip 0. Channel 2, 467.625 MHz, power byte 1, monitor off, not keyed, except the regression tone below. HackRF transmit 467.625 MHz, 2 MS/s, VGA 20, amp off, 2.5 kHz deviation. The tone file's magnitude is constant. Goertzel is the 1000 Hz bin at 8000 Hz.

The stream stores `WORK_MODE` `0x80` with the same `movi` / `st.w` as op 5 at file `0x5B096`, remembers `FM_ADDR_SW`, and copies on the next flip. The copy is still switch 1 → `0x160004E0`. The start body is `[17, 1, period]` with period 1, 2, 4 or 8. Op 5's reply is still 514 bytes: samples 0..511, sequence at 512, half id at 513.

Each 10 s capture has a quiet run of about 48 halves (1.5 s) a few halves after the line appears, then the line returns through the rest of the tone. It is in every period, and the transmitted file has no matching dip.

| Period | Halves in the file | Host at stop | Loud span | Loud halves in the span | Quiet run | Residue median 1 kHz amplitude |
|---:|---:|---|---|---:|---|---|
| 1 | 361 | 337 halves, 10.8 s, 84 missed | 37..333 | 248 of 297 | 45..92 | even 11990, odd 11986 |
| 2 | 364 | 339 halves, 10.8 s, 83 missed | 40..335 | 248 of 296 | 46..93 | 11986, 11984 |
| 4 | 362 | 336 halves, 10.8 s, 83 missed | 37..334 | 250 of 298 | 44..91 | 12005, 11983, 11984, 11984 |
| 8 | 422 | 394 halves, 12.6 s, 20 missed | 37..391 | 297 of 355 | 49..101 | 11988, 11986, 11986, 11991, 11986, 11986, 11988, 11988 |

A store every half does not drop the alternate half. Every residue class at period 8 is the line. The host's miss count on the 10 s runs did not remove audio time: the saved halves still arrive one per 32 ms. The 45 s run below counted 0.

45 s, period 8, same tone. The host reported 1631 halves, 52.2 s, 0 missed. The file has 1663 halves. All eight residue medians are 11988 or 11989. The stream was still sending after the 30 s fallback window.

The stop frame is consumed and not executed. `[16, 0]` then did not change the baud: the version read at 57600 failed and mode 5 off got no answer. `restartmodule` brought `DMR003.FW27.V022` back each time. Channel 2 was applied again.

Regression `bench.py --arm all`. Boot passed, peak 0.059 dB. The tone step stopped the run: carrier 16.0 s, clip 0, p99 22389 Hz, the 1 kHz slice 25 Hz. Stream, receive and heat were not run. The VFO was turned off afterwards.

End state: channel 2, 467.625 MHz, monitor off, not transmitting, VFO off, UART back at 57600 after the last restart, HackRF idle. The host on the phone asks for period 8.

## FW27 op 16 versus op 17 (2026-10-26, 12:30)

(A) and (B) used the image whose copy matches live op 5, sha256 `1d83e5bf9b6685e191b5084cc92ec04a9ccb3cdbf424960f7ff69444688bc489`. The register frame used sha256 `ab7a809d83521d64bbffd2a42c10e983d7de90a74452ee80e9525197aa0f4d20`, 378620 bytes, loaded 12:24:37 (`fwload ok`), boot peak 0.055 dB, nothing above +10 dB, clip fraction 0. Channel 2, 467.625 MHz, power byte 1, monitor off, not keyed. HackRF transmit 467.625 MHz, 2 MS/s, VGA 20, amp off, 2.5 kHz deviation, dummy burst first. Goertzel is the 1000 Hz bin at 8000 Hz.

(B) at 12:14:51: mode 5, op 16 to 230400, then op 5 mode 0, no op 17, during an 8 s tone. Two 514-byte halves. Both half id 0, sequence 0 then 2. rms 17075 and 17079, lag-1 0.66, 1 kHz amplitude 23510 and 23529. Bend at 12:14:49 restored `DMR003.FW27.V022` and mode 5 off, `sr=0`.

(A) at 12:17:29: mode 5, then op 17, UART left at 57600, during a 10 s tone. Start `sr=0`. The saved PCM was 0 bytes. At 12:17:39 the keepalive logged no answer. At 12:17:42.814 the stop logged no answer, and at 12:17:42.821 the return to 57600 logged `sr=0`. Mode 5 off at 12:17:42.878, `sr=0`. A quiet run of the same path at 12:16, with the HackRF idle, saved 19968 bytes. That file has no tone to score.

Register frame at 12:24:59, the normal stream (mode 5, op 16, op 17 at 230400) during a 6 s tone. The stream body is 526 bytes on this image: 512 sample bytes, sequence, half id, then `WORK_MODE`, `FM_BANDWIDTH`, and the word at `0x3A81C`, each little-endian. Op 5's reply is still 514 bytes (samples 0..511, sequence at 512, half id at 513). The first frame's trailer is sequence 0, half id 1, `WORK_MODE` `0x00000080`, `FM_BANDWIDTH` `0x0000000F`, and `0x3A81C` = 0. PCM 129536 bytes, 253 halves.

| Half | 1 kHz amplitude | rms | lag-1 |
|---:|---:|---:|---:|
| 0 | 396 | 3088 | 0.32 |
| 1 | 308 | 3209 | 0.12 |
| 8 | 494 | 3189 | 0.16 |

`hold mode=5 action=0` at 12:25:48 returned missing. `0x34` at 12:29:07 answered `DMR003.FW27.V022` in 9 ms. Bend at 12:30:36: rate `sr=0`, version handshake true, mode 5 `sr=0`. No `restartmodule`. Battery 38.7 °C, `mtktsAP` 46.0 °C. Stock app disabled. HackRF idle. Section 4 (b) with the line in the stream, (c), the 45 s keepalive, and (d) were not run.

## FW27 stream halves, 1 kHz Goertzel (2026-10-26, 12:05)

The 11:49:48 capture, `C:\Users\Joshua\AppData\Local\Temp\fw1718\fw27line\ramstream.pcm`, 172032 bytes, 336 halves of 256 samples. The log said 344 halves. Goertzel at 1000 Hz assuming 8000 Hz, amplitude of one bin. No new image and the phone was not used.

| Half | 1 kHz amplitude | rms | lag-1 |
|---:|---:|---:|---:|
| 0 | 286 | 3096 | 0.24 |
| 1 | 583 | 3028 | 0.21 |
| 2 | 164 | 3242 | 0.17 |
| 4 | 642 | 3141 | 0.21 |
| 8 | 190 | 3056 | 0.14 |
| 16 | 260 | 3243 | 0.18 |
| 32 | 292 | 3094 | 0.16 |

Every 8th half from 0 through 320 stays near rms 3000. The largest 1 kHz bin in the file is 867, at half 88. Op 5's halves from 11:41, for comparison, were rms 8957, lag-1 0.57, peak 1000 Hz. The stream does not start as that line and then fall to the noise floor.

## FW27 op 5 versus the stream (2026-10-26, 11:50)

Image sha256 `1d83e5bf9b6685e191b5084cc92ec04a9ccb3cdbf424960f7ff69444688bc489` for the stream retest. The op 5 dump was on the previous image (`2b0d249c…52be`), which has the same mode 5 registers and the opposite half choice. Channel 2, 467.625 MHz, not keyed. UART stayed at 57600. No op 16 and no op 17 during the dump.

Mode 5 on, `sr=0`. A 10 s 1 kHz HackRF tone, VGA 20, amp off, deviation 2.5 kHz. At about 3.5 s, op 5 mode 0. The log at 11:41:58 was `rxram bytes=514 sr=0+514 sr=0`. Both halves: sequence 0 then 2, half id 0, rms 8957 and 8955, lag-1 0.57, peak 1000.0 Hz. Mode 5 off afterwards, `sr=0`.

The live op 5 copy at file `0x5B110` reads `0x160004E0` when `FM_ADDR_SW` is 1 and `0x160006E0` when it is 2, with `ld.b` of 512 bytes into `0x4A400 + slot*512`. The stream's loop is that same `ld.b` copy. It had the two addresses swapped. Matching `0x5B110` and loading `1d83e5bf…c489` (boot peak 0.154 dB) left the stream at 11:49:48 as 344 halves (11.0 s), 2 missed, rms 3147, lag-1 0.16, peak 281 Hz. Op 5's copy does not return; it falls into the slot counter. Section 4 (c) and (d) were not run. Mode 5 was turned off at 11:50:17, `sr=0`.

## FW27 stream, section 4 (b) (2026-10-26, 11:25)

Image sha256 `2b0d249c24809de0a0a87b5e641f3c917f7758ed807d928760b18e1fbe6a52be`, 378620 bytes. Loaded 11:25:00, `fwload ok`, tag `DMR003.FW27.V022`. Boot capture peak 0.073 dB, nothing above +10 dB, clip fraction 0. Channel 2, 467.625 MHz, power byte 1, monitor off, not keyed.

The op 6 handler at file `0x5B240` rejects variant 5 before the FW27 gate. The compares at `0x5B2C8` (apply) and `0x5B2A8` (restore) branch to a trampoline at `0x5C54C`. Variant 5 calls the existing mode-5 apply at `0x5BCD6` and the restore at `0x5BD42`. Variants 3 and 4 return to the old bodies. At 11:20:44–11:20:47: `[6, 7, 1]` `sr=1`; `[6, 5, 1]`, `[6, 5, 0]`, `[6, 4, 1]` and `[6, 4, 0]` all `sr=0`. Mode 4 and mode 5 were left off.

Op 5's reply, which op 17 sends, is unchanged: body length 514, big-endian samples at 0..511, sequence at 512 (the slot, 0..5), half id at 513 (0 = `0x160004E0`, 1 = `0x160006E0`). sendh clobbers r5, so a counter updated after the call stayed 0 and every half carried sequence 0 (317 halves, 1580 missed). The next slot is stored before the call. The half sent is the one `FM_ADDR_SW` is not pointing at (`1` copies `0x160006E0`, `2` copies `0x160004E0`).

The 10 s tone, HackRF 467.625 MHz, VGA 20, amp off, deviation 2.5 kHz, dummy burst first. 11:25:29: 346 halves (11.1 s), 1 missed, 88576 samples, rms 3099. One half in the middle has lag-1 correlation 0.21. There is no 1 kHz line. The phone clip recorded during the stream is silent (rms 1). With mode 5 off, the same tone on the speaker path is rms 7142, peak 1129 Hz. Stop `[17, 0]` does not ack. The following rate command also got no answer, the version read at 57600 failed, and `[6, 5, 0]` then returned `sr=0`. The 45 s stream, section 4 (c) and (d) were not run.

## FW27 rate switch, bench (a) (2026-10-26, 10:32)

Image sha256 `72737f824be61f30f4c58a24602b0a002fa4e4ffddaf07efa20e2da99ca7fcff`, 378620 bytes, stub 1008 bytes ending `0x5C094`. Loaded 10:32:13, `fwload ok`, tag `DMR003.FW27.V022`. Op 16 waits until USR bit 0 is clear and LSR bit 6 is set, sets DLAB only after a read-back, writes the divisor from the boot clock word at `0x32F90` (shifted right 4, divided by 57600 or by 230400), clears DLAB with a read-back, and restores the IER it read first. The same path is the 57600 fallback. 230400 is four times 57600, so its quotient is the boot divisor divided by 4.

Bench (a), channel 2, not keyed. `[16, 1]` ack `sr=0` at 57600 at 10:32:21.062. At 230400, `0x34` answered `DMR003.FW27.V022` (10:32:21.235). No host frame until 10:32:56.290. `0x34` at 57600 answered the same tag. `[16, 1]` again, `sr=0`, and `0x34` at 230400 answered. The update knock then returned `00 00`, not `C`. Power cycle at 10:32:58, `0x34` true, tag unchanged. The sequence byte stays the slot, 0 through 5: the existing send uses that byte as the buffer slot, so a free-running 0..255 counter is not free. HackRF was not started.

Section 4 (b) did not start. At 10:36:11 `[6, 5, 1]` returned `sr=1` with an empty body in 4 ms, and the stream log never opened. At 10:38:11 `[6, 4, 1]` returned `sr=0`. At 10:38:12 `[6, 5, 0]` returned `sr=1` in 5 ms. Mode 4 was turned off at 10:40:48 (`sr=0`). M17 receive is off. The HackRF did not transmit.

## FW27 loaded, rate switch silent (2026-10-26, 10:06)

Image `DMR003.FW27.V022`, 378620 bytes, sha256 `400c7cc84edbaecde2f3c9d24bc479c00f64c4ff6d29d3e213ba041db010fd70`. YModem `fwload ok` at 10:04:03, 137788 ms. `0x34` after the load and again after a power cycle: `DMR003.FW27.V022`. The file length is unchanged. Opcode 13 branches to the `sr=1` return. Opcodes 12 and 14 are the FW26 bytes. The free tail from `0x5C54C` is still zero. The stub is 736 bytes at `0x5BCA4`, ending `0x5BF84`.

Op 17 calls op 5's existing send (`0x5B1B4`). That reply body is 514 bytes, not a new 516-byte opcode-17 body. Samples are big-endian at body 0..511. Body 512 is the sequence byte and is also the slot, so it runs 0, 1, 2, 3, 4, 5, 0. Body 513 is the half id (0 = RAM `0x160004E0`, 1 = RAM `0x160006E0`). The host should wrap at 6. An empty ack does not carry the rate byte. A frame seen during the stream that is not `[17, 2]` ends the stream and is not executed afterwards. Mode 5 is not cleared by a channel write; the host sends `[6, 5, 0]`.

Op 16 `[16, 1]` at 57600: `sr=0` at 10:04:09, 10:04:52 and 10:05:22. The host then opened 230400. A `0x34` frame, sent after the module's 20 ms post-ack delay, produced 0 bytes in 1.2 s. Three seconds at 230400 produced no version reply. From 10:05:25 to 10:06:00 the host sent nothing. `0x34` at 57600 still failed, and a second `[16, 1]` got no answer. The update knock at 230400 returned `00 00 FC`, not `C`. Power cycle at 10:06:11, banner, `0x34` true, tag unchanged. Channel 2, 467.625 MHz, not keyed, monitor off, RSSI −110. HackRF was not started. Section 4 (b), (c) and (d) were not run.

# Hotspot setup and the first independent M17 decode (Claude, 2026-10-27 17:40–18:05)

**Hotspot:** WPSD "M17 Edition", updated during the session (owner); MMDVMHost `20261012_M17` git `2b27b08` (was `20250620_WPSD` `07fba41` before the update); Raspbian 12, aarch64. Modem: `MMDVM_HS_Dual_Hat-v1.6.1 20231115_WPSD 14.7456MHz dual ADF7021`, GitID `7e16099`, on `/dev/ttyAMA0` at 115200. Duplex-capable board, configured simplex (`Duplex=0`). Login and network keys are not recorded anywhere in the repos.

**Configuration for the cage (RF only):** `Callsign=N0CALL`; `[M17] Enable=1`, `SelfOnly=0`, CAN 0; every network off; RX/TX 467.625 MHz; `RXOffset=-450`; RF level unchanged (100 %), the hotspot has not transmitted. Backup of the original file on the hotspot: `/etc/mmdvmhost.bak-claude-20261027`.

**Armor:** SignalDeck `ebe814a4` (Grok's build), module `DMR003.FW26.V022`, VFO low power, station callsign N0CALL only during the keys and restored after each run. Bursts: `DIAG m17 --ei tx` (Codec 2 tone through the symbol engine).

**Finding 1, deviation depends on frequency.** HackRF capture (receive only, LNA 8 / VGA 8): at **438.800 MHz** the M17 body p99 deviation is **4523 Hz** (carrier +832 Hz, our decoder 75/75 frames); at **467.625 MHz** it is **2866 Hz** (carrier +897 Hz, 75/75). The hotspot found no M17 sync at 438.800 for any RXOffset from −3000 to +3000 Hz. The symbol engine's scale was set at 467.625; on 70 cm it is about 1.58× too wide for a standard receiver. **Open item: a per-frequency deviation scale in SignalDeck (or the engine), measured across the band.**

**Finding 2, the hotspot decodes SignalDeck M17 voice.** At 467.625 MHz, 3 s bursts, RSSI −47 dBm:

| RXOffset (Hz) | Hotspot log |
|---|---|
| −900 | voice from N0CALL to ALL, 3.0 s, BER 0.3 % |
| −600 | voice from N0CALL to ALL, 3.0 s, BER 0.0 % |
| −300 | voice from N0CALL to ALL, 3.0 s, BER 0.0 % |
| 0 | **late entry** voice from N0CALL to ALL, 2.7 s, BER 6.5 % |
| +300, +600 | nothing |

With −450 a further burst logged `received RF voice transmission from N0CALL to ALL` … `4.0 seconds, BER: 0.0%`. This is the first decode of our M17 transmit by an independent implementation: sync words, LSF coding, callsign encoding, LICH, the stream frames and the EOT are right.

**Finding 3, packet mode does not pass.** `DIAG m17 --es sms "HOTSPOT CHECK 1" --es to @ALL` (returned null = sent): `M17, received RF packet transmission from N0CALL to ALL`, then `M17, RF packet from N0CALL to ALL, ended before its last frame`, `0.0 seconds, BER: 0.0%`. The packet LSF is recognised (type field right); the packet frame after it is not accepted. Our own decoder passes the same transmission, so this is a convention difference in the packet frame (sync `0x75FF`, the 6-bit metadata / last-frame field, P3 puncturing, or the CRC placement), or a gap in the hotspot's packet reader. **Open item: check §2.15–2.17 of the current spec line by line against `M17.java`'s packet frame; if it matches, compare with the spec version MMDVMHost implements.** PR 24 (M17 SMS) stays open on this.

**Packet follow-up (18:07).** A 34-character text (two packet frames; 240 symbol bytes = preamble, LSF, 2 packet frames, EOT) and a 1-character text (one frame). Hotspot: `received RF packet transmission from N0CALL to ALL`, then `ended before its last frame` **85 ms** later for two frames and **45 ms** later for one. Those times match the arrival of the last packet frame, not the EOT 40 ms after it, so the hotspot is tracking our packet frames frame by frame and reacts to the one with EOF = 1, but does not accept the packet as complete. Our frame layout was checked against spec 2.0.10 (2026-10-16) §2.9: 200 data bits, then EOF and the 5-bit counter (byte count on the last frame, CRC bytes included), 4 flush bits, P3 `1111/1110` (linearised 1,1,1,1,1,1,1,0), CRC-16 big-endian over the whole packet data including the protocol byte and the terminating null, padding with nulls after the CRC. They agree. Remaining suspects: the last frame's byte count or CRC as MMDVMHost reads them, or an older packet layout in this MMDVMHost build. Not resolved; PR 24 stays open.

End state: Armor on 467.625 MHz, not transmitting, callsign restored, Grok's build installed. Hotspot as above, `[Modem] Debug=0`. HackRF idle, released to the W6 agent.

# Hotspot with no network: parrot and the PC audio relay (Claude, 2026-10-27 18:15–18:31)

MMDVMHost's `[M17 Network]` link (UDP 127.0.0.1 17010/17011) now goes to our own relay instead of M17Gateway, so the hotspot transmits and reports M17 with no internet. Tools in `tools/hotspot-bench/` (README there). The hotspot's RF level is 20 % for the cage.

- **Link format** (read from MMDVMHost's own frames): 54 bytes, `M17 `, stream id 2, destination 6, source 6, type 2 (`0005`), META 14, frame number 2 (bit 15 = last), Codec 2 payload 16, CRC 2. MMDVMHost writes CRC `0000` on this link. PING datagrams (4 bytes) come every few seconds.
- **Parrot:** a 3 s Armor burst came back as `received network voice transmission from N0CALL to ALL` … `3.0 seconds`; the hotspot transmitted it.
- **Hearing the hotspot's receiver on the PC:** an Armor 3 s burst gave the PC 3.04 s of decoded audio (rms 688, peak 9085), 76 frames, end bit.
- **Sending a file:** a 5 s MP3 from the PC went out as `received network voice transmission from N0CALL to ALL`, `5.0 seconds`.
- **Open: SignalDeck does not decode the hotspot's transmission.** During the parrot's replay the Armor's receiver started (`0x36` status 1) with RSSI 100. Its held-path M17 receiver listed nothing. An `rxclip` of the replay (4.1 s of signal) gives a best sync score of 0.70 in either polarity, and the shipped taps find one frame and no LSF. Not yet known: the hotspot's transmit deviation (`M17TXLevel=50`), its polarity (`TXInvert=1`), or its frequency (`TXOffset=0`, while receive needed −450 Hz). A HackRF capture of the hotspot's carrier would answer all three at once.

# Receive muted after a symbol-engine key (Claude, 2026-10-27 18:45–19:05, hotspot bench)

Owner report: after keying M17 from SignalDeck, the next hotspot M17 transmission showed on the signal bar but gave no audio until a channel change. Reproduced with the hotspot relay (`tools/hotspot-bench/`): 4 s from the hotspot heard (103 frames, 86 good), Armor M17 key (`DIAG m17 --ei tx 3000`, N0CALL), 4 s from the hotspot again: not listed. The APRS decoder's level lines give the receive RMS every 2 s: about 5600 (open squelch) up to the key, **1.3 from 2 s after the unkey on**, and an rxclip of the second transmission peaks at 2. The hold re-send alone (`data hold action=1 sr=0` after `sym unkey`) did not change it, nor did closing and reopening the phone's receive stream (`openRecvPcm=true`). Rewriting the current channel after the unkey did: 99/83 before the key, 100/86 after it, rxclip RMS 4543. **So FW26, after the op 7 drop and the stock unkey, leaves the module's receive audio muted until a channel write.** The plain PTT key does not do this. SignalDeck PR 39 rewrites the channel after every symbol-engine transmission; a firmware fix in the drop path would be cleaner (FW candidate). Also seen: the hotspot's transmissions reach SignalDeck at ~85 % good frames (hotspot `TXOffset=0`, `M17TXLevel=50`, not tuned yet).

**Channel access number (19:08).** From 18:30 on the hotspot logged no RF reception at all, including the owner's keys: SignalDeck's bench M17 channel 56 has CAN 7 (`cc` 7, destination N0CALL), the hotspot had `[M17] CAN=0`, and an M17 receiver drops another CAN silently (the earlier passes were VFO keys with CAN 0). With `CAN=7` on the hotspot and the relay sending type `0x0385` (CAN 7): Armor key heard (`N0CALL to N0CALL, 3.0 seconds, BER: 0.0%`), and the parrot round trip works (76 frames replayed, the Armor heard 79 frames, 74 good).

# DMR through the hotspot, first pass (Claude, 2026-10-27 20:00–20:35)

Hotspot: `[DMR] Enable=1`, `SelfOnly=0`, `ColorCode=1`; `[DMR Network] Enable=1`, `Type=Gateway` to the relay (127.0.0.1:62031; MMDVMHost sends `DMRC` every 10 s, `DMRD` per burst). SignalDeck channel 49 ("dmr test") edited to 467.625 MHz, colour code 1, slot index 1 (= time slot 2), group talkgroup 9, receive list 1,9,99 (database backed up on the phone as `radio.db.bak-claude-20261027`).

- Slot index 0 (TS1): the hotspot never entered DMR mode. Slot index 1 (TS2): `Mode set to DMR`, then `DMR Slot 2, RF user … rejected`: MMDVMHost accepts only 5–7 digit source IDs and the Armor's own ID is shorter. With SignalDeck's DMR ID set to the bench ID 1234568 for the key (restored afterwards, the original never printed): `DMR Slot 2, received RF voice header from 1234568 to TG 9`, `end … 3.6 seconds, BER: 14.3%, RSSI: -47 dBm`; the parrot replayed it (`received network voice header … 3.7 seconds, 0% packet loss`).
- Not yet shown: the Armor receiving the replay (the first replay started 0.25 s after the Armor's unkey; the parrot now waits 3 s). **Correction (21:05):** the later tries ran without a lease while Grok was loading and keying FW30 on the same phone; the module restarts I saw were Grok's loads (`fwload`, `restartmodule`), not a module fault, and my 20:17 test tone cut Grok's first load of image 2. These DMR tries are void; the DMR receive check waits for a lease.
- 14.3 % BER on the hotspot's DMR receive is high next to M17's 0.0 % at the same RXOffset; to look at.
- The relay now keeps the last DMR call on disk (`~/claude-bench/dmr_last.bin`). It serves one PC client at a time: a second connection replaces the first.

# FW30 (2026-10-27, 20:34) — receive still muted after a symbol-engine key

The drop writes one AT1846S `0x30` value (`0x7026`) after the symbol key has left `0x4026`, so bit 5 is already set. The analog tune writes `0x7006` and then `0x7026`, the same edge `at1846_rx_on` makes. RSSI keeps moving either way. `WORK_MODE` stays `0x80`. The stock voice unkey writes the key-up save back; this path never saved it, and calling that restore can write a zero codec image. Silent boot was not captured: the HackRF is not on this bench.

**Image 1, sha256 `f53c5a2d…bf599d`, tag `DMR003.FW30.V022`.** The `0x58` write in the drop is replaced by `0x30 = 0x7006`, and the following instruction still writes `0x7026`. Loaded over FW26 (`fwload ok` about 140 s, 20:04:24). On channel 56 the 1125-frame stream (CAN 7, bench callsign) was decoded by the hotspot relay: type `0385`, 1118 frames, 44.72 s, end bit. The MMDVM log was not read (the bench SSH key was rejected). Then SignalDeck `1.0.0-beta.19` (`ebe814a4`, no channel rewrite) replaced the PR 39 build. Three 75-frame keys: the 1 s clip just after unkey read RMS 2009, 1961 and 2272, and the APRS level line settled at **1.3** (baseline before the keys was about 5600). Not a pass.

**Image 2, sha256 `e1433e99…06db93`, same tag.** Same `0x30` pair, and the eight free bytes at `0x5B718` store `WORK_MODE` `0x6E`: `r4` keeps `0x11000080` across the calls, then `addi r4, 128` and `st.w` of 110. The changed-range guard's only new branch is that detour, and it is listed. The first load of this file died at block 65 of 370 (20:17) when another session's 3 s test tone wrote the port; `restartmodule` left the version reply empty. The retry finished (`fwload ok` 20:32:29, block 370/370). On beta.19, channel 56, baseline level 5634. Key 1: relay 72 frames, 2.88 s, end bit; the unkey line was not logged; the level two seconds later was 5614 then 5594. Key 2: 71 frames, 2.84 s, end bit; the 1 s clip was RMS 2218 and the next level line was 902. Key 3: the relay showed no transmission and the clip was RMS 2.9. The phone's M17 dump listed no hotspot call on any of the three. A page clip was RMS 198. `DIAG ft8` on this build wrote no log line. Not a pass.

The 20:32 keys on image 2 were made while the other session had the phone and the hotspot. They are not the result.

**Image 2, quiet retest (21:01–21:04).** No other session on the phone. Channel 56, beta.19, level 5571 before the key. The 1125-frame stream: relay type `0385`, 1119 frames, 44.76 s, end bit, `sym unkey` logged; the level at 3 s after the unkey was **1.3**. A channel write brought it back to 5534–5555. Three 75-frame keys each ended on the relay at 76 frames, 3.04 s, end bit, with `sym unkey`. The level after the first was 1453 at 1.3 s, 1154 at 2.5 s, and **1.3 from 3.8 s on**. The next two keys started from that muted level and showed the same fall (about 1000 for the first 4 s, then 1.3). The signal reading kept answering (−104 to −106). `WORK_MODE` `0x6E` does not hold the receive audio. Not a pass.

End state: tag `DMR003.FW30.V022` (image 2), channel 56, 467.625 MHz, not transmitting, RSSI −106, SignalDeck `1.0.0-beta.19`, battery 35.1 °C, AP zone 44.2 °C. HackRF was not started. Pager receive was off.

**Image 3, sha256 `590b4efaebb4cea06c56ee19a2f37a108d4c03c8ff78066f4d08d2acfc36ae3e`, same tag.** Image 2 plus a read-only opcode 18 in the 128 zero bytes at file `0x35F64`. The gate compare at `0x5BCBC` is `cmphsi r3, 19`, and `0x5BCCA` is a `bsr` to that stub. The stub reads one AT1846S register through file `+0x54664` and replies with the 16-bit value, or `sr=1` when the register byte is `0x80` or higher. Opcode 17 still reaches its old handler. The patch suite was green (54) before the load. Op 14 was not widened: it only accepts `0x18000000`–`0x1800FFFF`, so it cannot read the `0x1100xxxx` blocks in the review.

The transfer finished (370/370, `fwload ok` 21:22:31). The module never came back. There was no boot banner, the `0x34` queries at 21:22:07 and 21:22:15 had no reply, and the tag in the ok line is the previous image's identical string. The channel write and the M17 hold at 21:22:34 were not answered (`data hold action=1 missing`). Power cycles at 21:24:34, 21:26:38, 21:27:27, 21:29:30 and 21:31:34 each logged no banner. Opcode 18 was sent twice (`0x40` body `12 30`, 21:27:12 and 21:29:34) and both replies were missing, because the module was already silent. The three snapshots were not taken. Image 4 was not built.

This is the same hole R4l used on 2026-10-24. Those 128 bytes are the tail of the dispatch data table, after a run of `0x01` bytes, and that image also produced no version reply. Factory restored: banner at 21:37:11, `0x34` `DMR003.UV4T.V022` at 21:37:19.

End state: factory tag `DMR003.UV4T.V022`, channel 3, analog, 462.675 MHz, low power, squelch 5, not transmitting, RSSI −108, SignalDeck `1.0.0-beta.19`. Battery 34.2 °C, AP 39.5 °C. HackRF was not started. The hotspot was not used. Pager receive was off.

**Image 3b, sha256 `fc8eb51b5e00e98ae7ecdac89ea267f5de1f605e14875f4f5c8da07342f0a35e`, same tag.** The read stub is at `0x5BD74`, the start of opcode 17. The data-table tail at `0x35F64` is unchanged. Opcodes 16 and 17 ack `sr=1` through file `+0x8E7C` and return with the dispatcher's saved `r6`. Opcode 18 calls the firmware's own AT1846S read at `+0x54664`, builds the 11-byte reply, and returns the same way. The patch suite was green (54). An earlier file, `af23f6fe…`, booted as well; its opcode 16/17 branch went to `0x5C584`, and that path calls the `0x40` dispatcher again. Its stub ended with `jmp r15` while `r15` still pointed at that instruction.

`fc8eb51b…` loaded over that image (`fwload ok` 22:23:59). Banner seen, `0x34` `DMR003.FW30.V022`, channel 56 level 5651. Opcode 6 answered (`sr=0`, empty body) before the reads. Opcode 18 for `0x30`, `0x44` and `0x58` was sent and none of the three produced a reply. Opcode 6 sent again after that also produced no reply. A module restart brought opcode 6 back (`sr=0` at 22:25:25). RSSI kept answering through the silence. The three snapshots were not taken.

End state: tag `DMR003.FW30.V022` (this file), channel 56, 467.625 MHz, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`. Opcode 6 answers. Battery 34.0 °C, AP 40.0 °C. HackRF was not started. The hotspot was not used.

**How command `0x32` reads the AT1846S (FW29, read-only).** The dispatch word at file `0x38280` is `0x03024B6A`. That thunk (`0xAB6A`) calls `0xA6A8`. `0xA6A8` calls `0x377C`, stores the returned byte, and sends a 1-byte `sr=0` reply through `0x90B0`. `0x377C` is only `bsr 0x2B4C`. `0x2B4C` is `movi r0, 27` (register `0x1B`), the 4-byte far call whose file-relative target is `0x1125C` (objdump's flat name `0xFD01125C`), then `zext` bits 15:8. That target is the IRAM entry of the read at file `+0x54664` (IRAM `0x2B25C`). There is no lock and no cached RAM value in this handler. The raw function, once entered at its IRAM address, calls `0x55260`, which takes a lock and releases it. The only ordinary `bsr` to file `+0x54664` is at `0x54890`, inside the block that boot copies to IRAM, so the call stays in IRAM. The tail past `0x5AEFC`, where opcode 18 lives, has no such call. Image 3b's `bsr` from that tail landed on the flash copy and did not return.

Image 3c keeps 3b and replaces that `bsr` with `lrw r1, 0x0002B25C` / `jsr r1`. `r0` is still the register number. The reply is the full 16-bit value. RSSI keeps only bits 15:8 because register `0x1B` stores the reading there.

**Image 3c, sha256 `6ff663cf120ea95af0306c3a7b9f37095da2b560743a50170a41d8361c404bd8`, same tag.** The call is `lrw r1` / `jsr r1` at `0x5BD80` (`3f 10 c5 7b`). The literal at `0x5BDFC` is `0x0002B25C`. The patch suite was green (54) before the load. Opcode 14 was not widened.

Loaded over image 3b (`fwload ok` 22:49:49, 139 s, banner `module DMR003.FW30.V022`, `0x34` the same tag). Channel 56, 467.625 MHz, low power, SignalDeck `1.0.0-beta.19`. HackRF was not started. The hotspot was not used.

Three snapshots, 128 reads each, every read returned a 16-bit value. A is after a channel write (level 5607.3). B is after a 75-frame symbol-engine key with the end bit (level 1.4). C is after the next channel write (level 5583.4). Registers where B differs from both A and C:

| Reg | A | B | C | Channel write puts B back |
|---|---|---|---|---|
| `0x1B` | `1F41` | `1E42` | `1D42` | no; A and C already differ (the RSSI register) |
| `0x1D` | `4021` | `4020` | `401D` | no; A and C already differ |
| `0x20` | `0660` | `09D5` | `0831` | no; A and C already differ |
| `0x30` | `7026` | `70A6` | `7026` | yes; B sets bit 7 (`0x0080`) |
| `0x3B` | `2918` | `2E1A` | `2A19` | no; A and C already differ |
| `0x41` | `470F` | `4730` | `470F` | yes; low byte `0F` versus `30` |
| `0x58` | `BCFD` | `BCF5` | `BCFD` | yes; B clears bit 3 (`0x0008`) |
| `0x59` | `0B90` | `0910` | `0B90` | yes; difference `0x0280` |

`0x44` stayed `07FE` in all three. The muted `0x30` is `70A6`, which is the open value `7026` with bit 7 set. It is not the `4026` the earlier drop reading named. The four rows a channel write puts back are `0x30`, `0x41`, `0x58` and `0x59`. The `0x1100xxxx` blocks were not read: opcode 14 still accepts only `0x18000000`–`0x1800FFFF`. No GPIO was named. Image 4 was not built.

End state 22:59: this image, channel 56, analog, 467.625 MHz, low power, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`, link ready. Battery 34.7 °C, AP 45.6 °C, PA 42.4 °C. HackRF idle. Pager receive was off.

**Image 4, sha256 `44572ba28fc92c65223d4c04895b7ee143f86695861d5b8d46cc026e7f13e5ce`, same tag.** Image 3c plus a save and a restore. The save is the first thing `on_key` does (the call at file `0x5B582`): it reads `0x30`, `0x41`, `0x58` and `0x59` through IRAM `0x2B25C` into `0x4B388`, then makes the stock key call those four bytes replaced. The restore is the last step of the FW20 drop (file `0x5B76E`), after the stock unkey and the timeout clears: it writes the four words back through IRAM `0x2B220`. Opcode 18 is unchanged. The literal-guard tests passed.

Loaded over image 3c (`fwload ok` 23:34:32, banner `module DMR003.FW30.V022`). Channel 56, 467.625 MHz, low power, SignalDeck `1.0.0-beta.19`. HackRF was not started.

Three 75-frame keys. The hotspot logged each with the end bit: 70 frames / 2.8 s, then 76 / 3.04 s, then 76 / 3.04 s, type `0385`. Before each key the level was 5587, 5570 and 5564, and the four registers were `7026`, `470F`, `BCFD`, `0B90`. At about 0.5 s and at 3 s after the unkey log, every key read `0x30=70A6`, `0x41=470F`, `0x58=BCF5`, `0x59=0B90`. The level about 4 s after each unkey was 1.3. A 2 s call from the hotspot after each key was not listed. `0x41` and `0x59` match the pre-key values. `0x30` and `0x58` match the muted snapshot from image 3c.

A fourth key read `0x30` from the moment the host logged the unkey: `70A6` at 0, 0.33, 0.69, 1.04, 1.51, 1.86, 2.23, 2.56 and 2.88 s. Bit 7 is already set at that log line.

The 1125-frame stream reached the hotspot: 1118 frames, 44.72 s, end bit, type `0385`. An FT8 CQ was requested with the bench callsign set for that command and restored afterwards. The radio did not key during the next 46 s.

End state 23:39: this image, channel 56, 467.625 MHz, low power, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`. Battery 34.7 °C, AP 42.3 °C, PA 41.2 °C. HackRF idle. No further image was built.

**Image 4, the host unkey left off (no new file).** `DIAG cmdsym --ez nounkey true` logs `sym nounkey` and sends no `0x26` off. Three 75-frame keys on channel 56, then one control key with the host unkey. The hotspot heard every key with the end bit. Before each key `0x30` was `7026` and `0x58` was `BCFD`.

The control key, with the host unkey, read `70A6` / `BCF5` at 0.5 s and at 3 s, and the level was 1.3. One no-unkey key read the same `70A6` / `BCF5` and a level of 1073. Two further no-unkey keys were read from the status-4 line: the first `0x30` sample was `7026`, and the next sample was `70A6` (at 0.33 s and at 0.32 s). It stayed `70A6` through 3 s. `0x58` at the end of that window was `BCF5`. The levels were 1.3 and 987. The hotspot's return call was not listed. Leaving off the host's `0x26` does not keep the receive path open. No further image was built.

End state 23:53: same image, channel 56 selected again, 467.625 MHz, low power, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`. Battery 34.6 °C, AP 42.3 °C, PA 41.0 °C. HackRF idle.

**Where `0x30` bit 7 and `0x58` bit 3 are written (static, image 4, no phone).** There is no `movi` of `0xBCF5`. The wide muted value `0x70A6` is `0x7026` with bit 7 set. Two stores write it.

The selector at file `0x03190` reads the channel config and writes register `0x30` once. The argument and config byte 1 pick the value. Byte 1 equal to 1 is the wide pair. An argument of 1 leaves bit 7 clear; any other argument sets it. On a wide channel that is `0x7026` or `0x70A6`. The narrow pair is `0x4026` or `0x40A6`. Its only two callers are inside `0x037F4`.

`0x037F4` is the receive open/close. It reads the state byte at `0x38908`. Bit 3 of that byte is the open flag. Called with 0 while bit 3 is clear, it sets bit 3, calls the selector with 1 (so a wide channel gets `0x7026`), and posts status 1. Called with a nonzero argument while bit 3 is set, it clears bit 3, calls the selector with 0 (wide channel gets `0x70A6`), and posts status 2. The other two combinations return without writing `0x30`. `at1846_rx_on` (`0xB048`) and `at1846_rx_off` (`0xB00C`) change bits 2 and 5 of `0x30` and do not set bit 7.

The periodic task is `0x0399C`. Each pass copies the channel config. It does nothing when config byte 0 is nonzero, when `0x38908` bit 2 is set, or when the byte at `0x32457` is nonzero. Otherwise it is the squelch state machine, and that machine calls `0x037F4` with 0 or with 1. The close calls pass 1, which is the `0x70A6` write. One of them stores 300 and calls `0x18A4`. That helper adds 9, divides by 10, and calls the kernel delay, so 300 is 30 ticks. The drop path clears bits 0 and 2 of `0x38908` and does not clear bit 3, so when the transmission ends the task is allowed to run and the open flag is still set. A close call then writes `0x70A6`.

The wide branch of the IRAM tune (file `0x5481E`, taken when its byte 1 is 1) writes `0x7006` and then `0x70A6` with no argument. A channel write does not leave the register there: the open call above replaces it with `0x7026`. That is why a channel write ends at `0x7026` and the task can put `0x70A6` back.

Register `0x58` has one read-modify-write that clears bit 3. Function `0x032E4` does it when config byte 0 is 0 and config byte `0xD` is 0: it reads `0x58`, ANDs with `0xFFF7`, and writes it back. `0xBCFD` becomes `0xBCF5`. No branch in the image targets `0x032E4`, and the periodic task does not call it. The other bit-3 clears in the image are HR-C7000 words (`0x11000000` and `0x11000080`), not this register. The op 14 diff is what has to show whether `0x38908` is the byte a channel write puts back. `0x38908` is the address the instruction loads. It sits above the copied image (the copy ends near `0x31AF4`) and outside opcode 14's `0x18000000`–`0x1800FFFF` window. The squelch timer at `0x31BD4` is outside that window too. The task does use `0x18000820`, which the window covers: it stores 100 there and writes 5 to the byte at `0x18000824` when it resets the count.

**Op 14, image 4, channel 56, no new file.** One 75-frame key with the host unkey left off. A is after the channel write, B is 1 s after the end, C is after the next channel write. `0x30` was `7026`, `70A6`, `7026`. The level was 4983, 1890, 5550 on the first pass and 5001, 1845, 5518 on the second. A 128-byte read at `0x18006E00` (the file-map guess for `0x38908`) had no byte that differed in B. The byte at `+0x28` stayed `0x97`. A 32-byte read at `0x18000820` also had no such byte. The byte at `+4` stayed `0x05`. Opcode 14 did not show the state the close path reads. No image was built.

End state 00:20: image 4, channel 56, 467.625 MHz, low power, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`. Battery 34.3 °C, AP 41.9 °C, PA 40.3 °C. HackRF idle.

**The stored channel apply (read only, before image 5).** `cmd23_analog` is `0x99B4`. After it unpacks the new body it calls `apply_analog_config` at `0x7A30`. That copies 176 bytes to `0x38B5C` and calls `at1846_tune` at `0x2DD8` with the word at offset 8. On a wide channel the tune writes `0x30` = `0x7006` and then `0x7026` (immediates 28678 and 28710 at `0x307E` and `0x3086`). Both widths then write `0x58` = `0x8405`. The 176-byte block at `0x38B5C` is the stored channel. Boot re-reads it from `0x7B04` and then creates a task, so image 5 does not call `0x7B04`. The 19-byte record a `0x25` query returns is `0x38C70`.

The periodic task has no branch to its entry and no pointer to it in the image. Its loop waits on `0x38FE4` through `0x18E8` with timeout 0, so a countdown has no known period. The tail has no free 8 bytes. `0x18A4` is the delay `cmd23_analog` already uses (`250` shifted left one, 500). A close path calls that same helper with 300, which is the ~0.3 s re-mute. Image 5 sleeps 500 at the end of the drop, after status 4, then calls `0x7A30` with the four words of `0x38B5C`, then writes the saved `0x58` back. The four register writes do not fit in the same 52 bytes. Sha256 `56eb76b10bee151038dd402151880e6aaec2a78dc73713fbc808ceb9f3abd116`. Opcode 12 read the 52 stub bytes back equal to the file. The literal-guard test passed.

**Image 5, three 75-frame keys, channel 56.** The hotspot logged each key with the end bit (70 frames, then 76, then 76). Before each key the level was 5606, 5553 and 5603, and `0x30`/`0x58` were `7026`/`BCFD`. From status 4, `0x30` was `7026` on the first read and `70A6` by 0.32–0.35 s, and it stayed `70A6` through 1.9 s on all three keys. `0x58` at the end of each window was `BCFD`, which is the saved value the stub writes after the apply, not the muted `BCF5`. The level stayed 1.3. The hotspot's return call was not listed. A channel select before the next key brought the level back, so the module was not hung. The 1125-frame stream and the FT8 key were not run.

End state 00:59: image 5, channel 56, 467.625 MHz, low power, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`. Battery 33.4 °C, AP 39.0 °C, PA 38.2 °C. HackRF idle. Phone and hotspot free.

**The close and the unmute (read only, before image 6).** `0x037F4` is the receive open/close. A nonzero argument while bit 3 of `0x38908` is set clears that bit, posts status 2, and calls the selector `0x03190` with 0, which stores `0x70A6` on a wide channel. The same call with bit 3 already clear returns without writing `0x30`. An argument of 0 while bit 3 is clear sets the bit and calls the selector with 1, which stores `0x7026`. The squelch task `0x0399C` does not run that machine while bit 2 of `0x38908` is set. The symbol drop clears bits 0 and 2 after it posts status 4, so the next pass can close. The task calls the close at `0x03AB2` when `0x02414` returns 0, the byte at `0x18000824` is 0, and the byte at `0x31BD4+6` is 4 or less. It calls the open at `0x03A5C` when `0x02414` returns nonzero. After a symbol key that open does not run. The value 300 is `150<<1` and the task delays with it after the close (`0x03B24`, `0x03BB6`), not before the write. A channel write unmutes because `at1846_tune` stores `0x7026` itself.

Writing the pre-key `0x38908` back would leave bit 3 set, which is the condition the close needs. Image 6 clears bit 3 in the drop's existing mask (`andi` 250 becomes 242) and restores the four registers as image 4 did. The sleep and the channel apply are gone. Sha256 `4a7c8008293102325cd47174387d50f351076d7c0a91cf9b0d81ad8113376dc8`. Opcode 12 read the stub back equal to the file.

**Image 6, three 75-frame keys, channel 56.** The hotspot logged each key with the end bit, 76 frames. Before each key the level was 5436, 4942 and 4902, and `0x30`/`0x58` were `7026`/`BCFD`. From status 4, key 1 was already `70A6`. Keys 2 and 3 were `7026` on the first read and `70A6` by 0.31 s and 0.37 s, and they stayed there. `0x58` at the end of each window was `BCF5`. The level fell to 1.3. The hotspot's return call was not listed. Clearing bit 3 before the close does not stop the mute. The 1125-frame stream was not run.

The one-shot skip of the selector does not fit. The save stub is 60 bytes and ends at live code; a looped save plus the skip is 92 bytes. The bytes after the gate are still called. `0x4B384` is an unnamed byte, but there is nowhere to put the test that reads it.

End state 01:19: image 6, channel 56, 467.625 MHz, low power, not transmitting, RSSI −105, SignalDeck `1.0.0-beta.19`. Battery 33.3 °C, AP 39.2 °C, PA 38.4 °C. HackRF idle. Phone and hotspot free.

# DMR loop through the hotspot: the Armor hears the hotspot's replay (Claude, 2026-10-27 21:55–22:00, leased)

Factory module firmware `DMR003.UV4T.V022`, SignalDeck channel 49 (467.625 MHz, colour code 1, time slot 2, group TG 9, receive list 1,9,99), SignalDeck's DMR ID set to the bench ID 1234568 for the key and restored afterwards. A 3 s test tone keyed from the Armor: hotspot `DMR Slot 2, received RF voice header from 1234568 to TG 9`, `end … 3.6 seconds, BER: 10.9%, RSSI: -53/-47/-49 dBm`; the relay recorded 62 bursts and saved them (`dmr_last.bin`). With the Armor back on its own ID, the relay replayed the call (`DMR replay sent: 62 bursts, group 1234568 -> 9, slot 2`) and the Armor received it: `0x36` status 1 at 21:59:15.997, `0x2B` `[01 88 D6 12 00 09 00 00 00]` (group call, caller 0x12D688 = 1234568, target TG 9) three times, audio focus taken (audio played), `0x36` status 2 at 21:59:19.717. **The full DMR loop works: Armor → hotspot → relay → hotspot → Armor.** The factory `0x2B` body is 9 bytes (no colour-code/slot bytes; those come with FW26's promiscuous extension). Two earlier keys in the same window ended after about 1 s with no header at the hotspot (the channel select had probably not settled yet); not investigated. The hotspot's DMR receive BER (10.9–14.3 %) is still high against M17's 0.0 % at the same RXOffset: open.

## DMR is dead on every bench image from FW19 to FW30 (Claude, 2026-10-28 02:20–03:05, lease)

Hotspot (MMDVMHost, CC1, slot 2) replays one stored call, unchanged: the Armor's own 3 s key from 21:58 (bench ID 1234568 to TG 9). The Armor listens on channel 49 (DMR 467.625, CC1, TS2, TG 9, list 1/9/99). "Heard" = `0x36` status 1, `0x2B` caller `[01 88 D6 12 00 09 00 00 00]`, status 2.

| Image | Armor decodes the hotspot | Hotspot decodes the Armor's 3 s key |
|---|---|---|
| factory `90e361fd…` (02:49, again 03:02) | heard, both times | heard, RF header 1234568 → TG 9, BER 13.1 % |
| FW19 (02:59) | silent | — |
| FW22 (02:55) | silent | — |
| FW26 `71949d24…` (02:52) | silent | — |
| FW29 `de10d5c5…` (02:29) | silent | — |
| FW30 image 6 (02:19–02:23, also after a module power-cycle) | silent | not heard (status 3/4 sent, MMDVMHost logs nothing) |

On the silent images the RF arrives (`0x32` RSSI from 0x19 to 0x46–0x47 during the replay), but the module never reports a call. SignalDeck is not the cause. The `0x22` channel write is byte-identical on main `aebabef2` and beta.19 `ebe814a4`, both are deaf on the bench images, and beta.19 hears on factory. Nothing else is sent after the select. The hotspot is not the cause either: the same replay is heard on factory between the bench images.

FW19 against factory changes only ten ranges: 4 bytes each at `0x92AA`, `0x92C8`, `0x92E0`, `0x92FA`, `0xAB18`, `0x18B5C` and `0x18B68`; 3 bytes at `0x382B8`; the tag at `0x3846B`; and a 2076-byte stub at `0x5AEFC`. All later images inherit them. The promiscuous A/B cases could not run, because every image with the flag (FW26+) is deaf on DMR.

End state 03:05: factory image, SignalDeck beta.19 `ebe814a4…` (Grok's build), the radio's own DMR ID restored, channel 49, MON off, hotspot CC1 unchanged, no test channels made.

**The four `0x92xx` sites are the `0x26` launch handler, not the digital channel write (read only).** The handler starts at `0x9264`. Byte 1 is the key path and byte 2 is the unkey path. `0x92C8` and `0x92E0` call `tx_launch_action` at `0x0E9C` for a key. `0x92AA` and `0x92FA` call it for an unkey. `0x0E9C` is `0x0301AE9C` with the flash base `0x0301A000`. FW19 sends the key sites to `0x5B580` and the unkey sites to `0x5B614`. Both stubs call `0x0E9C` first. The key stub then treats a ring whose end is not below its start, including a ring of two zeros, as occupied: it rewrites the HR-C7000 FM setup and stores AT1846S `0x30` = `0x4026` and `0x58` = `0xBCFD`. The unkey stub clears the flag and two C7000 bits, then stores `0x58` = `0x8405` and `0x30` = `0x7026`. It does not put `0x11000104`, `0x11000100` or `0x11000500` back. That is not what `0x0E9C` does on a digital channel. The bisect image puts those four sites back to the factory calls and leaves every other FW19 byte. Its tag is `DMR003.F19R.V022`. Sha256 `4290cafaba092de660dd4508022549b9b2108ade9d5c8990c44c45a2afc4ba7d`. `0x34` read `DMR003.F19R.V022` after the load.

**F19R, channel 49, one stored replay and one 3 s key.** The hotspot accepted the replay and sent 62 bursts on slot 2 to TG 9. The Armor's signal stayed −108 to −107 dBm across that window. No status 1 and no caller packet. SignalDeck logged the 3 s test tone. The hotspot reported no DMR call from the radio. Restoring the four launch sites does not bring DMR back. Heat at the end: battery 30.6 °C, AP 36.4 °C, PA 35.5 °C.

End state 06:58: `DMR003.F19R.V022`, channel 49, 467.625 MHz, low power, not transmitting, RSSI −108, SignalDeck `1.0.0-beta.19`. HackRF idle. Phone and hotspot free.

**The other three FW19 calls.** `0xAB18` is the `0x3B` time-out store at `0xA308` (`0x03024308`). FW19 points it at `0x5B700`, which writes 120 when the byte is 0 or above 120 and then calls `0xA308`. `0x18B5C` is the branch taken when the byte at `0x34808` is 0; stock calls `0x18B70` (`0x03032B70`). FW19 calls `0x5B4CA`, which jumps to that same function while the symbol flag is clear. `0x18B68` is the other branch, stock `bsr 0x3D20` (`0x0301DD20`) with the word at `0x4C7E0`. FW19 calls `0x5B4D0`, and while the symbol flag is clear that stub returns without calling `0x3D20`.

**Receive bisect, channel 49, the same 62-burst replay.** F19T is the factory image with the tag `DMR003.F19T.V022` (`599e3d5d…`). On take-over SignalDeck sent `0x34`, `0x22`, `0x35`, `0x22`, `0x35`, then `0x32`. No `0x40`. RSSI stayed −108 to −106. No status 1 and no caller packet. F19R2 restores `0xAB18`, `0x18B5C` and `0x18B68` as well and keeps the `0x40` slot and the stub. Its tag is `DMR003.FR22.V022` (`66611624…`, retagged so SignalDeck treats it as a bench image). Same replay, RSSI −108 to −107, no status 1, no caller packet. The factory image reloaded afterwards (`DMR003.UV4T.V022`) did the same: RSSI −107, no status 1, no caller packet, while the hotspot again reported 62 bursts. The three sites were not separated. The singles were not built.

**`0x3D20` is an empty return.** The factory bytes at `0x3D20` are `3c 78 00 00`, `jmp r15`. Skipping that call, which the `0x18B68` stub does while the symbol flag is clear, matches the stock call. The 07:30 restart of MMDVMHost did not run: SSH as `pi-star` with the bench key was refused.

**The `0x382B8` slot is command `0x40` (read only).** The dispatch pointers run from `0x38224` to `0x383E4`, 112 entries. With command `0x22` at `0x38240`, command `0x40` is the word at `0x382B8`. Stock it holds `0x03024A54`, file `0xAA54`, the two bytes `95 14`, a pop. 71 of the 112 entries point at that same pop, so it is the shared default for an unused command. Commands `0x22`, `0x23`, `0x2B`, `0x36` and `0x3B` each have their own handler. Nothing in the DMR receive path indexes this slot. The patch notes record that nothing at boot sends `0x40`. FW19 stores `0x03074EFC` there, the stub at `0x5AEFC`.

**FW19 entries into the stub, from outside it.** The four `0x26` sites `0x92AA`, `0x92C8`, `0x92E0`, `0x92FA`; `0xAB18` to `0x5B700`; `0x18B5C` to `0x5B4CA`; `0x18B68` to `0x5B4D0`; and the `0x40` pointer. FW30 adds external branches FW19 does not have, at `0x7C56`, `0xA890`, `0xC1BA`, `0xC244` and `0x17E26`, all into the later stub past `0x5C000`. No image was loaded. The rerun waits on the owner's MMDVMHost restart.

**The three pass-throughs, with the symbol flag clear (read only).** `0x5B700` pushes `r15`, may store 120 at `r0+8`, then `bsr 0xA308` and pops. `r0` is still the packet the thunk put there (`mov r0, r4` at `0xAB16`). `r1` is 120, `r2` is the old byte and `r3` is `r0+8`. `0xA308` overwrites `r1`–`r3` before it reads them, and it uses `r15` only to return. The stack is one word deeper while it runs. The return still reaches `0xAB1C`.

`0x5B4CA` pushes `r4`–`r7` and `r15`, sees the flag clear, pops them, and jumps to `0x18B70`. That restores `r15` to `0x18B60`, the same link a direct `bsr` would have used, and the stack is back where it was. `r0`–`r2` are untouched. `r3` is then the jump address. `0x18B70` writes `r3` (`subi r3, r8, 4`) before it reads it, and it loads `0x4C7E0` itself rather than taking it in a register.

`0x5B4D0` does not call `0x3D20` on this path. It pops and returns to `0x18B6C`. `0x3D20` is `jmp r15`, so a direct call would also land there and would read no other register. The stub leaves `r3` as 0. The next instruction is `br 0x18A84`, which does not use `r3`. The caller's `r0` (the word from `0x4C7E0`) is unchanged.

With the flag set, the wake stub does rewrite `r0`–`r2` before the same tail call. That is the symbol-key path, not a DMR receive with the flag clear.

**RAM the FW19 stub uses (read only).** Every static word is in bss `0x31AF4`–`0x4DAB0`, which boot zeros, or it is HR-C7000 / TX RAM rather than phone RAM. None sit outside the copied and zeroed ranges.

| Address | What | Stock `lrw` |
|---|---|---|
| `0x4DAAC` | symbol flag | none |
| `0x4A3E4` | ring, words at +0, +4, +8, +0xC, +0x10 | none |
| `0x4A3F8` | saved `r15` for one restore helper | none |
| `0x4B000`, `0x4B004` | saved `0x11000100` and `0x11000500` | none |
| `0x4B008` | hold mark `0x484F4C44`, or 0 | none |
| `0x4B00C` | a second flag, 0 or 1 | none |
| `0x4AC00`, `0x4AE00` | a reply buffer | none |
| `0x4C7E0` | status word, bit 15 tested only while the flag is set | four, all in the stock wake function |
| `0x1100039C` and the other `0x11000xxx` / `0x16000xxx` words | module registers, written on an armed key and cleared on the unkey | `0x1100039C` has two stock loads |

The only store of 1 into `0x4DAAC` is at `0x5B5E4`. It runs only when the ring's end is below its start. A zeroed ring has end equal to start, and that key returns after `0xE9C` without setting the flag. The unkey and the armed wake path store 0. No stock instruction names `0x4DAAC`, so DMR receive cannot set the flag, and the idle stub does not write `0x4C7E0`. No image was loaded. The receive rerun still waits on the hotspot.

**How far the neighboring stock objects extend.** `0x4A3C4` is one byte (`ld.b`/`st.b` at offset 0). It stops 0x1C bytes short of the ring. `0x4A3C8` is the base of a large object used from IRAM. The instruction after the load stores or reads at offsets `0x1152`, `0x116A`, `0x116C` and `0x1474`, so the object runs at least to `0x4A3C8+0x1474` = `0x4B83E`. The ring at `0x4A3E4` is offset `0x1C` inside that span. `0x4AC00`, `0x4AE00` and `0x4B000`–`0x4B00C` are inside it too. `0x4DAA4` is one word (`ld.w`/`st.w` at offset 0). `0x4DAA8` is passed into `0x30688`, `0x3068C` and `0x30690`, which are `movi r0, 0; jmp r15`. Those sites do not index far enough to reach the flag at `0x4DAAC`.

**F19M.** FW19 with the four `0x26` launch sites restored, and the stub's own words moved to the gap above bss. The ring `0x4A3E4`–`0x4A400` is now at `0x4DAB0`. The flag is at `0x4DAD0`. `0x4B000`–`0x4B00C` is at `0x4DAD4`. The two buffers are at `0x4DAE4` and `0x4DCE4` (512 bytes each). `0x4C7E0` stays, because stock and the stub share it. The block ends at `0x4DEE4`. The initial stack pointer is `0x50000`, so 8476 bytes remain. Tag `DMR003.F19M.V022`, sha256 `bcf255fd7df2c94e6a39ee3dc28081deab320a9f9aba8e45bede53d525bc3bde`. Not loaded. The hotspot was still down.

End state 07:21: factory image, channel 49, 467.625 MHz, low power, not transmitting, RSSI −107, SignalDeck `1.0.0-beta.19`. Battery 30.7 °C, AP 34.8 °C, PA 34.4 °C. HackRF idle. Phone and hotspot free.
