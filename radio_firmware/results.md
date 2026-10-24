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
