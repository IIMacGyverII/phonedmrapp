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
