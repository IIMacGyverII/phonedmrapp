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
