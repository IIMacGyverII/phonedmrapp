# 04 — Measured behaviour and modes

Part of the firmware reference for the Ulefone Armor 26 Ultra radio module: image `DMR003.UV4T.V022` (factory), SoC HR-C7000 (C-SKY CK803S with DMR/FM modem, vocoder, 8 kHz codec), RF IC Auctus AT1846S, phone-side codec Everest ES8311. This chapter collects what was **measured** about how the radio behaves, by topic, and the bench methods that produced the numbers. Register maps, the command table and the patch history live in the other chapters; this one cites them only where a measurement depends on them.

Compiled 2026-10-30 from the sources listed in §0.2. Nothing here was re-measured for this chapter.

## Contents

- §0 Conventions and sources
- §1 Transmit audio path
- §2 Receive audio path
- §3 Modes: state, feasibility and key numbers
- §4 Timing and limits
- §5 Bench methods
- §6 Where the sources disagree
- §7 Open questions

---

## 0. Conventions and sources

### 0.1 Labels

| Label | Meaning |
|---|---|
| **V (date)** | Verified on the bench or on air on that date. The source records the measurement and its numbers. |
| **I** | Inferred: follows from a measurement plus a reading of the image or a datasheet, not measured directly. |
| **S** | Superseded: an earlier result that a later bench run overturned. Kept so old notes can be recognised. |

When two sources disagree, the later bench result wins and §6 lists the disagreement.

Unless stated otherwise the bench is: Armor 26 Ultra inside the Faraday cage, **467.625 MHz, low power**, HackRF One a few feet away, SignalDeck (`com.macdmr.radio`) owning the radio. Deviations are FM instantaneous-frequency figures from a HackRF capture (§5.2). "Body p99" is the 99th percentile of |deviation| over the keyed carrier with the first and last 50 ms dropped.

### 0.2 Source key

| Key | File |
|---|---|
| CL | `CLAUDE.md` (repo root) §3 and §3a |
| P19 | `docs/deep-dive/19-firmware-modification-plan.md` (§10 progress log; §11–§23 reviews) |
| G11 | `docs/grok-deep-dive/11-firmware-fw0-results.md` |
| M17D | `docs/m17-deep-dive-2026-10-22.md` |
| POCD | `docs/pocsag-deep-dive-2026-10-22.md` |
| PROM | `docs/promiscuous-rx-patch-spec-2026-10-24.md` |
| RES | `radio_firmware/results.md` (section headings quoted) |
| REV | `radio_firmware/reviews.md` |
| HO | `radio_firmware/HANDOFF.md` (standing approval, protocol, owner rules) |
| RAM | `radio_firmware/plan-rx-ram-stream.md` |
| SELF | `radio_firmware/plan-rx-selfcal.md` |
| IND | `radio_firmware/plan-independent-m17-check.md` |
| FWB | `tools/fw-bench/README.md`, `tools/fw-bench/runner/*.py` |
| MEM | Claude memory notes (name given), `C:\Users\Joshua\.claude\projects\D--Documents-code-personal-phonedmrapp\memory\` |

---

## 1. Transmit audio path

### 1.1 The chain, as far as it is established

| Stage | What is known | Status | Source |
|---|---|---|---|
| Phone PCM | SignalDeck writes 8 kHz 16-bit PCM through `PrizeTinyService.writeFrame` into `tinyserver`, which plays it out on **I2S1** (`I2S1_CH1 DL8_CH1`) at 8000 Hz, MCLK 1.024 MHz | V 2026-10-23 | P19 §19, RES "UVm8 / UVm9 — Phone route, read only" |
| Phone codec | The converter on I2S1 (transmit) and I2S2 (receive) is an **Everest ES8311** at I²C `7-0018`, ALSA card `mt6885-mt6359`. Its exposed ALSA controls include no high-pass on the DAC (transmit) side | V 2026-10-23 | P19 §19, §20 |
| Analog line into the module | ES8311 DAC output → AT1846S microphone input. No module register controls this junction | I (from UVm10/UVm11 nulls) | P19 §19, §20 |
| AT1846S | Register `0x58` (pre-emphasis, voice low-pass, CTCSS filters) shapes the transmitted audio; register `0x44` bits 11:8 is the TX mic gain | V 2026-10-23 (0x58); I (0x44, not tested on TX) | RES UVm2–UVm9; P19 §10 UVm10 |
| HR-C7000 codec ADC / DAC | **Not** in the radiated path: lowering `GCR_ADCL` by 6 dB (UVm10) and all ten `GCR_DACL` slots by 6 dB (UVm11) left the air within 0.5 dB | V 2026-10-23 | P19 §18, §19; RES UVm10, UVm11 |
| HR-C7000 FM chain (`FM_BANDWIDTH 0x11000500`, `FM_DEV_COEF 0x11000504`) | **Not** what shapes the phone-audio transmission (UVm3, UVm7; UVm8 proved the stub runs on the keyed path) | V 2026-10-23 | P19 §17; RES UVm3, UVm7, UVm8 |
| Modulator | Analog FM key-up stores `RF_MODE` = `0x10E0` (two-point), `WORK_MODE` = `0x80`, PTT `0x11000560` = 1, and clears `tx_voice_source` (`0x11000080[0]`) | Read (G11/P19 §10 R2, T2) | P19 §10 |

### 1.2 Factory transmit response (FW17 baseline)

Factory image, 467.625 MHz low power, −30 dBFS tones (amplitude 1036), deviation and level against 1 kHz. **V 2026-10-23.** Source: RES "Factory — DMR003.UV4T.V022".

| Tone | Deviation | vs 1 kHz |
|---:|---:|---:|
| 50 / 100 / 150 / 200 Hz | 0 Hz | absent (floor) |
| 300 Hz | 56 Hz | −12.4 dB |
| 500 Hz | 122 Hz | −5.7 dB |
| 1000 Hz | 234 Hz | 0 dB |
| 2000 Hz | 472 Hz | +6.1 dB |
| 3000 Hz | 654 Hz | +8.9 dB |
| 3500 Hz | 510 Hz | +6.8 dB |

- Mid-band gain: **0.20–0.22 Hz of deviation per PCM count** at 1 kHz on every image measured (factory probe at −36 dBFS: 1 kHz 115 Hz = 0.221 Hz/count; 3.5 kHz 250 Hz = +6.8 dB). V 2026-10-23.
- Level linearity at 1 kHz (factory): −30 dBFS 219 Hz, −24 468 Hz, −18 868 Hz, −12 **1827 Hz**, −6 **3264 Hz**; still linear at −6 dBFS. 0 dBFS (linear prediction 6513 Hz) was not sent because of the ±5 kHz stop, so the limiter ceiling was **not measured in this run**. V 2026-10-23.
- Of a demodulated voice transmission, 1.1 % of the power is below 250 Hz (factory); 0.3–0.7 % on the flat images. V 2026-10-23.
- The −20 dBFS sweep reads low near the band edge (500 Hz at 184 Hz where ~390 Hz was expected). Treat the −30 dBFS table as the shape. V 2026-10-23 (RES), flagged in P19 §15.

### 1.3 What register `0x58` changes (UVm2–UVm9)

All V 2026-10-23, 467.625 MHz low power, HackRF receive only. Sources: RES UVm2–UVm9; P19 §15–§17; bit layout from G11 §21.3.

| Image | `0x58` value written (analog sites) | Bits changed vs `0x8405` | 50–200 Hz | 300 Hz | 2–3 kHz | 3.5 kHz | Verdict |
|---|---|---|---|---|---|---|---|
| Factory | `0x8405` | — | absent | −12.4 dB | +6 to +9 dB | +6.8 dB | pre-emphasised, bottom octave cut |
| UVm2 | `0x84C5` | 6 (voice HPF bypass), 7 (emphasis bypass) | −42 to −43 dB | −0.6 dB | +0.8 to +1.2 dB | −2.6 dB | **bit 7 is the pre-emphasis**; bit 6 does not open the bottom |
| UVm4 | `0x84C5` + C7000 stub | as UVm2 | −43 to −45 dB | −1.7 dB | ±0.5 dB | −4.0 dB | C7000 stub adds nothing |
| UVm5 | `0x84DD` + CTCSS RMW neutralised | + 3, 4 (CTCSS HPF/LPF bypass) | −40 to −43 dB | −1.6 dB | ±0.4 dB | −4.0 dB | CTCSS filters are **not** the cut |
| UVm6 | `0x84FD` + CTCSS RMW neutralised | + 5 (voice LPF bypass) | −42 dB | −1.6 dB | 0 to −0.4 dB | **−1.0 dB** | **flat ±2 dB 300 Hz–3.5 kHz**; best transmit curve |
| UVm8 | stub writes `0x84C5`, immediates stock | 6, 7 from inside the C7000 stub | not swept | — | — | probe −4.0 dB | proves the stub runs on the keyed path |
| UVm9 | `0xBCFD` (the DMR value) + RMW neutralised | + 11, 12, 13 (VOX HPF/LPF, RSSI LPF) | best −40.9 dB | tracks level | — | −0.5 dB | **register exhausted**; bottom octave stays shut |

Supporting details:
- The no-tone analog `0x23` runs `at1846_set_ctcss_dcs`, whose read-modify-write at `+0x3332` (`0x58 & 0xFFF7`) clears bit 3 after the patched immediate; UVm5/6/9 neutralised it (mask `0xFFFF` at `+0x333A`). Read 2026-10-23; RES "UVm5 / UVm6 / UVm7".
- At −30, −24 and −18 dBFS the 300 Hz tone scales linearly (UVm5: 186 → 362 → 733 Hz) while 50/100/200 Hz stay at 0–8 Hz, so the cut is not a weak-tone artefact. V 2026-10-23.
- **TX pre-emphasis is AT1846S `0x58` bit 7; the 3.5 kHz roll-off is bit 5 (voice low-pass).** V 2026-10-23.
- The `0x58` hold does **not** survive PTT: after a hold and a silence unkey, the 100 Hz line was ~71 dB below 1 kHz. V 2026-10-24 (RES "FW19 — 0x58 after PTT").

### 1.4 The C7000 FM chain and the module codec

| Image | Change | Result | Source |
|---|---|---|---|
| UVm3 | `FM_BANDWIDTH` = `0x0F` (band-pass, pre-emphasis off), `FM_DEV_COEF` reset | factory curve (pre-emphasis still +6.7 dB at 3.5 kHz) | RES UVm3, V 2026-10-23 |
| UVm7 | `tr_sig_lim` `0x0F` → `0x02` | −12 dBFS 1 kHz: 1829 Hz vs factory 1827 Hz | RES UVm7, V 2026-10-23 |
| UVm8 | same stub + `0x58` write | pre-emphasis gone → stub runs, so UVm3/UVm7 are real negatives | RES UVm8, V 2026-10-23 |
| UVm10 | `GCR_ADCL` −6 dB (live branch, `0x61F4` immediates too) | air within 0.5 dB (109 / 237 / 1740 Hz vs 115 / 250 / 1827 Hz); half would be ~57 / 125 / 914 Hz | RES UVm10, V 2026-10-23 |
| UVm11 | all ten `GCR_DACL` table slots −6 dB | ratios 0.973 / 0.999 / 0.949 | RES UVm11, V 2026-10-23 |

The image never stores `FCR_ADC` (`0x160009D7`; `adc_hpf`, wind-noise filter, reset off), `FCR_DAC`, `GCR_MIXDACL` or `CR_DAC_AGC` (read 2026-10-23, RES UVm10/UVm11). The guide lists no DAC high-pass or DC-block bit.

### 1.5 Why the bottom octave cannot be opened by module firmware

**V 2026-10-23** (P19 §19, §20; RES UVm8–UVm11):

1. Every module-side control that could shape it was measured and ruled out: AT1846S `0x58` all bits (UVm2, 5, 6, 9); the C7000 FM band-pass, pre-emphasis and limiter (UVm3, 7, 8); the C7000 codec ADC and DAC (UVm10, 11).
2. The audio does pass through the AT1846S (UVm2/UVm8 changed it through `0x58`), so it enters the module as an analog line.
3. The converters are on the phone side (ES8311 on I2S1/I2S2). The ES8311 exposes no DAC-side high-pass; its DC-removal HPF is on the ADC (receive) side only.
4. **Conclusion: the transmit cut below ~250 Hz is most likely the analog coupling between the ES8311 output and the module's microphone input (hardware).** I (the coupling itself was not probed).
5. Consequence: standard M17 and POCSAG transmission to ordinary radios through the audio path is infeasible on this phone. A −40 dB hole cannot be pre-shaped away (POCSAG pre-distortion needed 13–20× more drive than the input accepts, POCD). V 2026-10-22/23.
6. What firmware still gives: UVm6 is flat 300 Hz–3.5 kHz, a candidate run-time mode for AFSK, FT8, SSTV and SignalDeck-to-SignalDeck links; it would need a per-transmission `0x58` switch because the register also sets receive de-emphasis. I/design (P19 §19). Not built.

Also tested and negative: `/dev/ttyS1` carries no audio on the Armor (0 bytes in 6 s with receive audio flowing), unlike the Xplore 1 module which streams PCM at 230400 on a second UART. V 2026-10-23 (P19 §20).

### 1.6 Gain, limiter and compression

| Item | Value | Status | Source |
|---|---|---|---|
| Phone-audio gain, 1 kHz | 0.20–0.22 Hz/count (FW17) | V 2026-10-23 | RES FW17 |
| Phone-audio gain, 400 Hz–1 kHz | 0.45–0.48 Hz/count | V 2026-10-22, different session (see §6) | M17D |
| Pre-emphasis | +5 dB at 2 kHz, +10 dB at 2.4 kHz (M17D); +6.1 dB at 2 kHz, +8.9 dB at 3 kHz (FW17) | V | M17D, RES |
| Deviation limiter | ~±4.5 kHz, hit by pre-emphasised symbol transitions even at low audio level | V 2026-10-22 | M17D |
| Limiter in FW17 | not reached: 1 kHz still linear at −6 dBFS (3076–3264 Hz on all four images) | V 2026-10-23 | RES FW17 |
| Compression before the modulator | pre-shaped M17 (pre-emphasis removed, cut above 2.8 kHz, aimed ±1.2–2.4 kHz) still peaked 4.1–4.4 kHz and decoded nothing; an equaliser trained on the exact transmission reached MSE 0.65 (vs 0.02 on receive) | V 2026-10-22 | M17D |
| Polarity, audio path | the radio inverts the polarity (M17D) | V 2026-10-22 | M17D |
| Bandwidth bit | VHF needs `band=1`; UHF receives with either | V 2026-10-16/17 | CL §3a |

### 1.7 Digital modes through the audio path (plain decoders, no equaliser)

| Mode | Images | Result | Source |
|---|---|---|---|
| M17, 90 frames, standard ±2.4 kHz scaling | factory, UVm2–UVm6 | **0 / 90** exact on every image, both polarities; p99.5 3.0–3.4 kHz | RES FW17, UVm5/6 (V 2026-10-23) |
| M17, three audio levels | factory | 0 / 90 | M17D (V 2026-10-22) |
| POCSAG 1200 / 512, three pages, ±4.5 kHz scaling | factory, UVm2–UVm6 | **0 / 3** pages, 23–31 % bit errors | RES (V 2026-10-23) |
| POCSAG at a pager-like flat discriminator | factory | 16.7–17.2 % bit errors | POCD (V 2026-10-22) |
| AFSK (APRS), FT8, SSTV, DTMF, SAME | factory | work on the factory path (see §3) | CL §3, P19 §19 |

### 1.8 Transmitting without the audio path: TX RAM and the symbol engine

The route that bypasses the ES8311 and the analog line: the HR-C7000 builds the modulation from **TX RAM** (`0x16000030`–`0x1600042F`, two halves of 256 big-endian int16 samples, 32 ms at 8 kHz; `FM_ADDR_SW 0x1100056C` names the half; P19 §10 R2) through the DMR modulator path (two-point `RF_MODE` `0x10E0`, `WORK_MODE` `0x80`, `tx_voice_source` = 1, AT1846S `0x30` = `0x4006`→`0x4026`, `0x58` = `0xBCFD`).

**Step 1 — is the DMR modulator path DC-capable? (R1/R1b, factory, V 2026-10-23.)**

| Measure | Value |
|---|---|
| Burst period | 60.00 ms envelope (one direct-mode slot), 47 bursts of 26.1 ms |
| Symbol centres (open eye) | −3344.7 / −1068.9 / +1219.2 / +3344.7 Hz; inner/outer 0.342 |
| Outer symbol | **±3.3 kHz** (≈1.7× the standard ±1944 Hz), on the 12.5 kHz DMR branch (`0x30` = `0x4026`) |
| 99 % occupied bandwidth | 10546.875 Hz |
| Held outer symbol, late/early | 0.995 (no droop) |
| Power below 250 Hz (0–4 kHz) | 17.7 % (FM audio path: < 1 %) |

The first reading (outer ±7.3 kHz, 7.2 % below 250 Hz) was a phase lock onto the discriminator tail and is **S** (P19 §22). The BTECH 6X2 decodes this radio's ±3.3 kHz DMR on air.

**Step 2 — scale of the TX-RAM path (R3a3–R3b0, silence keys, V 2026-10-24).** Source: P19 §10.

| Image | Fill | Result |
|---|---|---|
| R3a2 | gated square, host key | air was the phone's codec tone (999.5 Hz, ±2.1 kHz): stub did not supply the modulation |
| R3a3 | ±256 square (15.625 Hz) | tops ±104 Hz → **0.40 Hz/count**, flat (DC-capable); silence drops the codec tone |
| R3a4 | ±512 | tops ±211 Hz (0.41 Hz/count) |
| R3a5 | ±1024 | ±422 Hz (0.41 Hz/count) |
| R3a6 | ±2048 | LP rms 967 Hz, median 741 Hz (0.36 Hz/count median; the flat top shrinks) |
| R3a7 | ±4096 | LP rms 2266 Hz, steady p99 3700 Hz; next doubling predicted past ±5 kHz, not built |
| R3a8 | 1 kHz sine, peak 2048 | 1 kHz line 923 Hz, p99 1217 Hz, 3rd harmonic 2.9 % |
| R3a9 | peak 4096 | 1923 Hz (2.08×), p99 2186 Hz |
| R3b0 | peak 5120 | 2261 Hz (1.18× for a 1.25× peak: compressing), p99 2674 Hz |
| R4a | RRC α 0.5 4FSK pattern, peak 5120 | p99 2774 Hz; **stored shape inverted on air**, −0.54 Hz/count |

**Step 3 — M17 from TX RAM (R4b–R4t, V 2026-10-24).** The ladder ended at R4t: symbols streamed over UART command `0x40` into a 2048-symbol ring, RRC-shaped in the module (5/3 samples per symbol, `ld.hs` sign-extended taps), refilled from the per-wake hooks at `+0x18B5C`/`+0x18B68`. **Three 90-frame keys, each link setup + 90/90 frames at Golay error 0** with our decoder; steady slices 2792–2895 Hz. Peak count 6451, linear prediction 3548 Hz at 0.55 Hz/count. Source: P19 §10 R4b–R4t; REV "pass" verdict.

Lessons recorded along the way: byte order matters (high byte at the low address, R4q/R4r); a polling refill finishes before the modulator starts (R4c); the end frame must play after `on_unkey` returns (R4j); status 4 has to be posted by the drop (R4k).

**Step 4 — the engines (FW19–FW22, V 2026-10-24/25).** Source: RES FW19–FW22.

| Item | Measured |
|---|---|
| 1125-frame M17 stream (45 s) | 1125/1125 payload-exact, end bit, EOT score 0.999–1.0, body p99 2.9–3.0 kHz (FW20, FW21, FW22, FW25, FW26 runner) |
| Spoken microphone check (FW20) | 247/247 frames, end bit, Codec 2 output 9.88 s of speech |
| Generic symbol engine (ops 8–11, FW21) | 2- or 4-level symbols, rational clock, hold or polyphase pulse |
| Tone queue (FW21/22) | 64 pairs, phase-continuous, frequency in 1/8 Hz; renders matched 32/32 and 64/64 samples |
| Tone-only key (FW22) | arms without a dummy symbol (700 Hz, 0.80 s carrier) |
| Flash read (op 12, FW22) | whole 378620-byte image read back equal in 971 s |

**Per-frequency deviation (V 2026-10-27, RES "Hotspot setup…" Finding 1).** The same symbol-engine M17 key gave body p99 **4523 Hz at 438.800 MHz** and **2866 Hz at 467.625 MHz** (both 75/75 with our decoder). The engine's scale was set at 467.625; at 438.8 it is ~1.58× too wide for a standard receiver (the hotspot found no sync there). Open item: a per-frequency scale.

**Polarity on the engine path (V 2026-10-25, RES "Item 8 device pass").** A positive TX-RAM count deviates **low**. A 0 bit must be the negative count to come out as a positive deviation (standard POCSAG sense).

**Compression on the engine path (V 2026-10-25, RES FW21 POCSAG).** ±7600 counts → p99 4061 Hz; ±8400 → 4138 Hz (1.105× count moved p99 1.019×). The modulator saturates near ~4.1 kHz p99 at this setting.

**Side effects of a symbol-engine key (open, V 2026-10-27 to 2026-10-30).** See §2.10 (receive mute) and §3.3 (DMR first key after a restart). Later images (FW46+) also regressed the tone queue (PTT held after the message; FW50+ pitch at 7.5 kHz because `0x5B700` was overwritten); FW54 restored a releasing FT8/RTTY. Source: P19 §10 2026-10-29/30 entries, RES FW45–FW55.

### 1.9 Transmit frame format from the phone

- The OEM TX path expects **8 kHz stereo, both channels identical**. The old mono format doubled every frequency (1200 → 2400 Hz, 2200 → 3600 Hz); with stereo-duplicated frames a 1200 Hz tone transmits as 1200 Hz. V 2026-10-16 (HackRF; CL §3 APRS row).

### 1.10 TXDELAY and lead-in

- **The radio passes audio only about 1.5 s after key-up.** A packet sent at key-up never decodes. V 2026-10-16 (CL §3; RES FW17 "How the numbers were taken": every file starts with 2.0 s of silence for this reason).
- Bench 2026-10-20, 252 single-copy packets, HackRF + direwolf: tone, HDLC flags and silence lead-ins decode alike at 1.6 s; shorter than 1.6 s loses packets on the module path (SignalDeck is less sensitive); silence is weakest when short. Both apps default to a 1.6 s HDLC-flag lead-in and send the frame twice. V 2026-10-20 (CL §3).
- FT8: key-to-audio latency calibrated at **320 ms** in SignalDeck (`Ft8Station.txLatencyMs`), DT −0.02 s after calibration. V 2026-10-22 (MEM ft8-over-fm-bench).
- Symbol engine: the ring does not drain until the transmitter is up, so SignalDeck keys after eight chunks; status 3 arrives ~10–13 ms after `0x26` body 1. V 2026-10-24 (RES "M17 voice").

### 1.11 Channel writes before keying

| Fact | Value | Status | Source |
|---|---|---|---|
| Wait after a retune before keying | **≥ 3.5 s** (`RETUNE_SETTLE_MS`): the OEM channel change completes ~3 s later and stops a transmission in progress | V | CL §3 Transmit length row |
| `syncChannelInfoWithData()` + a direct `AnalogMessage.send()` back to back | 3 of ~8 left the MCU reporting `SEND_START`/`SEND_STOP` with **no RF at all**; survives phone reboots; either path alone 10/10 | V 2026-10-17 | CL §3a |
| Recovery from that state | any single-path channel write | V 2026-10-17 | CL §3a |
| Busy flag `0x32457` | `0x22`/`0x23` set it on entry; a write that arrives while it is still set does not change the mode. Fits FW55's first digital write missing and the next one 4.5 s later applying | I (static reading 2026-10-30) | RES "FW55 first channel write, offline"; P19 §10 |
| Channel 56 kills the carrier, channel 49 restores it (factory and FW32) | a single analog `0x23` left no full carrier on a plain FM channel and on the VFO in that session | V 2026-10-29 (session-specific, unresolved) | P19 §10 2026-10-29 |
| Settling | a channel-58 tone started while its write was still settling showed no carrier; the runner's tone after its own settle held 10.547 s | V 2026-10-29 | RES FW38 |

### 1.12 Key-up click and boot silence

- Every TX-RAM key starts with a **key-up click** of p99 ≈ 22–23 kHz in the first 40–100 ms (and a drop click at the end). It is the edge, not the stimulus, and is excluded from the ±5 kHz stop. V 2026-10-24 (P19 §10 R3a3 onward).
- The factory boot does not radiate: VFO on 467.625, `restartmodule`, 24 s capture: hottest 100 ms bin +0.11 dB, nothing at +3 dB. V 2026-10-23 (P19 §10 R3a2). Every later image was boot-captured: peaks 0.05–0.42 dB, no run ≥ 10 dB.
- Rule from R3a1: any stub on the key-up path must act only on a host-requested key; the FM key-up path runs during the module's own boot cycle. V 2026-10-23 (P19 §23).

---

## 2. Receive audio path

### 2.1 Format

- RX audio does **not** cross the UART; it arrives through `android.os.PrizeTinyService` from tinyserver (I2S2, `UL2_CH1 I2S2_CH1`, 8000 Hz). V (CL §3a; P19 §19).
- OEM `AudioTrack` is 8 kHz stereo 16-bit, 2048 B / 64 ms chunks. **L == R for 100.00 % of 30,720 sample pairs**, corr 1.000, mean |x| 3895: the content is **8 kHz mono duplicated**. V 2026-10-14 (G11 §16).
- SignalDeck records "before the app squelch" at 8 kHz for bench clips (`rxclip`, WAV in the app cache). V 2026-10-24/26 (RES R-D; FWB).

### 2.2 Plain receive response

| Measure | Value | Status | Source |
|---|---|---|---|
| 20 Hz–3.8 kHz sweep, plain path | below 250 Hz −25 to −37 dB; 300 Hz–3 kHz within ~6 dB; noise above ~3.2 kHz | V 2026-10-22 | M17D |
| Plain path vs 1 kHz (R-D, 2.5 kHz deviation) | 50 Hz −27.6 dB, 100 Hz −24.5, 300 Hz +5.7, 2 kHz −4.0, 3.5 kHz −12.1, 3.8 kHz −17.0 | V 2026-10-24 | P19 §10 R-D |
| Cause of the low cut | AT1846S `0x58` (`0x8405` on analog: voice HPF, de-emphasis, voice LPF, CTCSS filter on). The C7000 FM filters are **not** in the phone path | V 2026-10-24 | RES "Item 7 reading"; P19 §10 R-D |
| AC coupling | NRZ data shows long-tailed ISI ("baseline wander"); POCSAG plain slicing 21–23 % bit errors | V 2026-10-22 | POCD |
| Receiver limiter | at ±4.5 kHz deviation, 4.5 kHz arrives only 1.15× as loud as 2.5 kHz (instead of 1.8×); the module volume byte acts after it | V 2026-10-22 | POCD |
| Codec ADC gain | not in the receive path: UVm10's −6 dB `GCR_ADCL` moved open-squelch audio +0.06 dB (−15.55 vs −15.61 dBFS) | V 2026-10-23 | P19 §10 UVm11; RES UVm11 "Receive check" |
| Audio clock drift vs a transmitter | ~15 ppm (negligible) | V 2026-10-22 | M17D, POCD |

### 2.3 The held path: `0x58` = `0xBCFD` (op 6 variant 3)

Bench firmware's op 6 holds the AT1846S DMR filter value on an analog channel. **V 2026-10-24** (P19 §10 R-D, R-E; RES R-E).

| Tone vs 1 kHz | Plain path | Held (`0xBCFD`) | Variant 4 (+ C7000 bypass) |
|---|---:|---:|---:|
| 50 Hz | −27.6 dB | −0.6 dB | same as held within 0.1 dB |
| 100 Hz | −24.5 dB | +1.2 dB | — |
| 3.8 kHz | −17.0 dB | +1.7 dB | — |

- The path is **linear** with exact ±1/±3 M17 levels once held, with a long linear distortion: a ~9.6 dB dip at 400–600 Hz plus the AC coupling's group delay. Plain M17 decoding on it still fails at ~19 % symbol errors; a fixed ±20-symbol (41-tap) linear equaliser fixes it. V 2026-10-24 (CL §3 M17 row; RES R-E/R-F).
- **The hold is cleared by any channel write** (`at1846_tune` writes `0x8405`): a VFO write drops the 100 Hz tail from 7291 to 387 counts; re-applying the hold restores 7258. The CTCSS/DCS setter also rewrites `0x58`. So SignalDeck re-sends the hold after channel, VFO and tone writes and after PTT release. V 2026-10-24 (RES R-E, "Writers of AT1846S 0x58").
- The module squelch holds the PCM at digital silence (peak 5 counts) for ~1.1 s after a HackRF carrier starts, then opens. V 2026-10-24 (P19 §10 R-E).
- The hold does not survive PTT (§1.3).

### 2.4 The ES8311 dip

- Held phone path: −9.6 dB at 500 Hz against 1 kHz. The HR-C7000 receive RAM (op 5 mode 4) on the same stimulus is −0.23 dB at 500 Hz. **The dip is the ES8311**, so equaliser taps are a per-phone-model table. V 2026-10-24 (P19 §10 R-F).
- FW27 cross-check: stream flat within 0.5 dB 100 Hz–3.5 kHz while channel 56 (held) dipped 9.6 dB at 500 Hz. V 2026-10-26 (P19 §10 16:37).
- The ES8311 ADC has a register-only DC-removal HPF (`0x1B`/`0x1C`); it may account for part of the receive loss. Reading it needs the `es8311_debug` node (count 0 = read, prints to the kernel log); writing is the owner's decision. I / read-only (P19 §19, §21; CL §1).

### 2.5 What feeds the phone's receive input

| Finding | Status | Source |
|---|---|---|
| Analog receive at the phone is the **AT1846S audio pin, after `0x58`**, not the C7000 modem demod that fills RX RAM | V 2026-10-24/25 | RES "Item 7 reading" |
| DMR voice can only leave through the C7000 codec DAC lineout (vocoder buffer `0x180000A0`–`0x18000140`, irq 27); it is heard on the phone, so that lineout shares the ES8311 input | I | RES "Item 7 reading" |
| Opcode 13 idle DAC playback (FW23, 3 s chirp, PTT 0) | phone heard nothing (closed squelch −88 dBfs; open −27 dBFS noise, no tone) | V 2026-10-25 (RES FW23) |
| FW24, DMR channel and analog with the speaker gate | DMR: digital silence; analog: −13.7 dBFS with a stationary ~320 Hz tone regardless of the playback | V 2026-10-25 (RES FW24) |
| FW25, two-tone square written into `0x180000A0` | the square sat in the buffer (read back), irq-27 count 0, phone clip −15.5 to −16.0 dBFS with the ~320 Hz peak; **the DAC's idle playback never reaches the phone** | V 2026-10-25 (RES FW25) |

So receive self-calibration trains on a real reception (§3.4).

### 2.6 The receive-RAM stream (`0x160004E0`)

The HR-C7000's FM receive RAM (mirror of TX RAM, halves at `0x160004E0` and `0x160006E0`, 256 big-endian samples each).

| Step | Measured | Status | Source |
|---|---|---|---|
| RC20 | the RAM fills only in `WORK_MODE` `0x80`; 128 of 256 slots carried audio in the high byte; plain sweep folded above 2 kHz | V 2026-10-24 | P19 §10 RC20 |
| RC30 | byte copy of both halves; 100 Hz −32 dB plain, −18 dB with both bypasses | V 2026-10-24 | P19 §10 RC30 |
| RC40 (128 ms lines) | **both bypasses together (AT1846S `0x58` = `0xBCFD` + `FM_BANDWIDTH` bits 4/6 clear) give a flat baseband: 100 Hz +0.3 dB, 50 Hz −0.3 dB**; each alone ~−20 dB at 100 Hz (two filters in series) | V 2026-10-24 | P19 §10 RC40; CL §3 |
| FW26 op 5 mode 0 | idle RAM (op 5 refuses while the hold marker is set); at 57600 a 514-byte half takes 89 ms and covers 32 ms → a dump keeps ~36 % of halves | V 2026-10-26 | RES "Receive-RAM stream (01:41)" |
| FW27 rate switch (op 16) | 57600 ↔ 230400 works (230769 Hz actual, +0.160 %); 30 s silence fallback to 57600; the update knock is NAKed at 230400 | V 2026-10-26 | P19 §10 10:32; RAM §2 |
| Capture semantics | the RAM is **a capture that each `WORK_MODE` `0x80` store re-arms**, not an open tap; a store every 1/2/4/8 halves kept the 1 kHz line in every residue (median ~11990); period 8 ran 45 s with 0 misses | V 2026-10-26 | P19 §10 13:02 |
| Clock | **8000 Hz** (1 kHz tone reads 1000.00 Hz, 31.250 halves/s); the earlier 987.25 Hz / 8103 Hz reading was a file's noise floor (**S**) | V 2026-10-26 | P19 §10 15:25, 16:13 |
| Response | flat within 0.5 dB 100 Hz–3.5 kHz; idle 44 dB down; DC-coupled; misses 0 by the sequence byte (FW27 reports the same half id for consecutive halves; count by the sequence byte) | V 2026-10-26 | CL §3; P19 §10 16:37 |
| Plain M17 on the stream | 30-frame transmission: **46 % clean, 4/30 payload-exact** vs **96 %** on the equalised audio path (channel 56, −87 dBm) | V 2026-10-26 | P19 §10 16:13 |
| Eye after sync normalisation | −3.00 / −1.27 / +1.07 / +3.37, spreads 0.43–0.76 (audio path: exact ±1/±3) | V 2026-10-26 | CL §3 |
| **Saturation** | carrier offset ±1000 Hz leaves the mean near +7 counts; amplitude is linear to ~±1 kHz deviation and sits at ~**6030 counts from ±2.4 kHz to 4.0 kHz** | V 2026-10-26 (16:53) | P19 §10 |
| Saturation is level, not frequency | a 300 Hz tone draws the same curve as 1 kHz (both 1.58× the 0.5 kHz amplitude by 1.0 kHz); at 1.0 kHz deviation the stream is flat within 0.2 dB to 2.5 kHz | V 2026-10-26 (17:05, 17:12) | P19 §10 |
| Deviation sweep, 30 frames | 21 / 8 / 4 / 3 payload-exact at 40 / 60 / 80 / 100 % deviation | V 2026-10-26 (17:05) | P19 §10 |
| `FM_DEV_COEF` bits 15:8 (op 6 v6, reset `0x10`) | `0x08` doubles, `0x04` quadruples the curve; the ceiling stays at 2.4 kHz → scale **after** the saturation | V 2026-10-26 (19:28) | P19 §10 |
| AT1846S `0x44` bits 7:4 (op 6 v7) | `0x41` doubles the curve, ceiling included; the phone's audio path follows it (−19.6 / −25.1 dB, dip kept) → also after the saturation | V 2026-10-26 (20:34) | P19 §10 |
| Host linearisation | level maps and 65-tap filters cannot undo it (`tools/m17-research/fw27_stream_levelmap.py`) | V 2026-10-26 | CL §3 |

**Verdict (V 2026-10-26): the route is closed on the Armor 26 Ultra.** The receive RAM is a flat, gapless baseband that saturates above about ±1 kHz of deviation; the saturation sits between the AT1846S demodulator and the C7000 capture where no register reaches. Kept for a phone whose audio path cannot be made flat and for modes inside ±1 kHz (SignalDeck PR 14, bench tool). Source: CL §3 M17 row; P19 §10.

### 2.7 Squelch levels

| Signal | `sq=0` | levels 1–9 | Source |
|---|---|---|---|
| ≈ −94 dBm (NOAA 162.500) | always open | all closed except brief fading-like openings (1.5 s at sq 1, 2.4 s at sq 2) | G11 §17, V 2026-10-14 |
| ≈ −81 dBm | open | all open within 0.6 s, 29/30 s per window, 26 windows | G11 §17.1, V 2026-10-14 |

- The MCU stores the byte as sent (`0x25` read back `sq=5`); no per-level logic was found in the image. Power-up default of the analog image is `sq=3`. V 2026-10-14 (G11 §15, §16).
- **Treat 1–9 as one threshold between −94 and −81 dBm (CL: "near −90 dBm"), `sq=0` as carrier squelch off.** Use `0x32` RSSI for anything finer. V 2026-10-14.
- That threshold sits about where AFSK and SSTV become decodable; `sq 0` + decoding below the squelch gave no measurable gain on a steady weak signal (kept for data modes). V 2026-10-20 (CL §3; MEM iss-437-doppler-bench).
- Only the APRS and SSTV decoders may run below the squelch: feeding open-squelch noise to all decoders made the Morse decoder invent text. V 2026-10-20 (MEM iss-437-doppler-bench).
- Reprogramming the analog channel costs ≈ 0.6 s of receive (`RECEIVE_STOP` → `RECEIVE_START`). V 2026-10-14 (G11 §17.1).

### 2.8 RSSI (`0x32`)

| Fact | Value | Status | Source |
|---|---|---|---|
| Formula | dBm = −(120 − raw/2) (raw 31 = −104.5 dBm) | V | G11 §17.1; RES FW19/FW20 |
| Readable while closed | yes: 14 replies per 30 s window with no `RECEIVE_START` | V 2026-10-14 | G11 §17 |
| Settle after a `0x23` retune | answered only once the next reading is ready (~0.52–0.60 s); readings ~0.6 s after the retune are **15–20 dB low**; from **0.7 s** on they match steady (squelch byte makes no difference) | V 2026-10-22 | CL §3; MEM rssi-settle-after-retune |
| Sweep cost | ~0.7 s per step (2 m in 25 kHz steps ≈ 2 min) | V 2026-10-22 | CL §3 |
| Idle floor at 467.625 | raw 21–31 (−109.5 to −104.5 dBm) on different days | V 2026-10-25 | RES FW20, FW24, FW25 |
| Deaf/flagged state | raw 6 (−117 dBm) after an op 7 drop without unkey on FW19, and on an early FW20 that cleared the TX bits before the unkey; a gain-0 HackRF carrier did not move it | V 2026-10-25 | RES FW19 "Timer after op 7", FW20 |
| RSSI register | AT1846S `0x1B`, bits 15:8; read through IRAM `0x2B25C`, no lock or cache in the handler | Read 2026-10-27 | RES FW30 "How command 0x32 reads the AT1846S" |

### 2.9 The `band` byte

- `channel_band` is documented as bandwidth, but **`band=0` on a VHF frequency makes the receiver deaf** (no `RECEIVE_START` at −73 dBm, nor on NOAA). An app restart does not recover it, only a phone reboot. V 2026-10-16 (HackRF; CL §3a; MEM sstv-rx-findings).
- Re-measured at 162.500: the same HackRF carrier reads −72 dBm with `band=1`, −92 dBm with `band=0`. V 2026-10-17 (CL §3a; MEM wx-same-alerts-bench).
- Rule: `band=1` on VHF; on UHF both receive. V.
- In the image, the band byte selects the 12.5 kHz (`0x30` = `0x4006`/`0x4026`) or 25 kHz (`0x7006`/`0x7026`) AT1846S branch on FM, and `at1846_apply_bw_profile` r0 = 0/1. Read (G11 §21.2; P19 §10 R3-0).

### 2.10 Receive muted after a symbol-engine key (bench firmware)

- Owner report reproduced 2026-10-27 on FW26: after a symbol-engine key the receive RMS falls from ~5600 to **1.3 from ~2 s after the unkey on**, until a channel write; a plain PTT key does not do this. V 2026-10-27 (RES "Receive muted after a symbol-engine key").
- Register diff (FW30 image 3c, op 18 reads): after the key `0x30` = `0x70A6` (open value `0x7026` with bit 7 set), `0x41`, `0x58` (`0xBCF5`, bit 3 cleared) and `0x59` differ; a channel write puts all four back. V 2026-10-27 (RES FW30 image 3c).
- Static reading: `0x70A6` is written by the squelch task's close path (`0x037F4` → selector `0x03190`), which runs because the drop clears `0x38908` bits 0 and 2 and leaves bit 3 (the open flag) set. Restoring the four registers (image 4), a delayed channel apply (image 5) and clearing bit 3 (image 6) did not hold the audio. V 2026-10-27/28 (RES FW30 images 4–6).
- Stopgap: two channel writes after a symbol key list the next hotspot call 3/3 (SignalDeck PR 39 rewrites the channel). V 2026-10-28.
- FW37 restores `RF_MODE`; FW38 also restores `WORK_MODE` and the FM bandwidth bits after a symbol key, and a following DMR key gets a hotspot voice header with the Atom XL showing the caller ID. V 2026-10-29 (P19 §10). FW52 acceptance: M17 receive 19/20 immediately after a symbol key that sent status 4. V 2026-10-30 (RES FW52 acceptance).

### 2.11 Receive sensitivity and the HackRF level map

M17 on the held path (channel 56, CAN 7, fixed Armor taps):

| Meter | Result | Source |
|---|---|---|
| −95 dBm | 30/30 frames clean (live) | RES "Item 6 device pass", V 2026-10-25 |
| −97 dBm | 30/30 live (VGA 10); clip-scored 30/30 payload-exact | same |
| −100 dBm | 26/30 live (87 %) | same |
| −102 dBm | 30 frames, 20 clean | RES "Item 7 bench", V 2026-10-25 |
| −87 / −93 dBm (R-F, 18 independent transmissions) | 98–100 % payload-exact; ~95 % at −99 dBm | CL §3; P19 §10 R-G |
| −88 dBm, 750-frame 32.5 s transmission | one listing, 750 frames (702 clean), equal to the batch decoder | RES "R-I live receiver", V 2026-10-26 |

HackRF transmit level into the phone at the bench placement (467.625, amp off): TX VGA 20 ≈ −87 to −89 dBm, VGA 10 ≈ −93 to −96, VGA 5 ≈ −100, VGA 0 ≈ −99 (R-F) — readings scatter between sessions. V 2026-10-24/25 (RES R-F, "Item 6 device pass"). A gain-0 carrier moves an idle radio from about −104.5 to −96.5 dBm. V 2026-10-25.

---

## 3. Modes: state, feasibility and key numbers

### 3.0 Summary

| Mode | Receive | Transmit | Firmware needed | Key source |
|---|---|---|---|---|
| FM voice | works | works | no | — |
| CTCSS | decode works (Goertzel); MCU squelches | works (67 Hz line ~590 Hz dev.) | no | CL, RES FW52 |
| DCS | MCU squelches in hardware; display from audio **infeasible** | works (stock) | no | MEM dcs-decode |
| DMR | works (groups[] admission) | works (outer ±3.3 kHz) | promiscuous: FW26+ | G11 §19, P19 §22 |
| M17 | works: held path + 41-tap per-model EQ (bench fw); DFE on stock | through TX RAM engine only (bench fw) | yes for TX and the held path | CL §3 |
| POCSAG | decodable (DFE+BCH; held path + taps) | through the symbol engine only | yes for TX | CL §3 |
| APRS / AFSK 1200 | works, incl. passive decode | works (stereo frames, 1.6 s lead) | no | CL §3 |
| FT8 over FM | works | works (audio path; tone queue FW21) | tone queue optional | MEM ft8, RES FW21 |
| RTTY / MCW | — | tone queue (FW21) decoded | yes (tone queue) | RES FW21 |
| SSTV | works (Robot 36 continuous decoder) | works; long modes tested on a PR build | no | RES "PR 5 SSTV pass" |
| NOAA APT | decoder bench-verified; no satellites left | — | no | CL §3 |
| SAME | works | — | no | MEM wx-same |
| DTMF | always-on decode (analog) | keypad + saved sequences | no | CL §3 |

### 3.1 FM voice

- Factory curve: §1.2. Plain 40 s FM key is **not** ended by the module (the voice path has no limit of its own on stock or FW19). V 2026-10-25 (RES FW19 "40 s FM tone": carrier 40.75 s).
- Runner tone (10 s, 1 kHz): body p99 2.52–2.72 kHz, hottest half-second ~4.0 kHz, carrier ~10.5–10.9 s on FW26–FW52. V 2026-10-26 to 2026-10-30 (FWB; RES FW51/FW52).
- Receive with a 1 kHz ±2.5 kHz tone, open path: −11.0 dBFS, 1 kHz Goertzel line ~12990 (held path ~6200). V 2026-10-25 (RES FW24 "Unchanged behaviour").

### 3.2 CTCSS and DCS

- The CTCSS table is in the image at `+0x366B2`: 50 entries, LE16 centihertz, 67.00–254.10 Hz, 49/50 exact EIA (index 32 is 177.4). Read 2026-10-14 (G11 §18).
- TX (FW52/FW55, 67.0 Hz): 67 Hz line 585–591 Hz of deviation against 0.3 Hz on a plain tone. RX with squelch 2 and the 67.0 Hz tone: clip −19.7 dBFS; the same carrier without the tone: −87.0 dBFS (closed). V 2026-10-30 (RES FW52 acceptance, FW55).
- FW54 regression: a CTCSS 67.0 Hz key produced **no carrier** (squelch 2 and 0). V 2026-10-30 (RES FW54 acceptance). FW55 radiates again.
- CTCSS decode from the phone audio works (Goertzel peak ~2.5e10, ratio ~469 on a 100 Hz tone). V 2026-10-16 (MEM dcs-decode).
- **DCS display from audio is infeasible**: in captures of DCS 023N/047N/114N/023I the 8–300 Hz band was ~1.5 % of voiceband energy with no 134.4-baud structure. No DCS table was found in the image (three encodings tried). DCS channels are squelched by the MCU in hardware. V 2026-10-16 (MEM dcs-decode; G11 §18.2).

### 3.3 DMR

**Admission (V 2026-10-15, on air, BTECH 6X2 → Armor, simplex, CC1/TS1; G11 §19).**

| Phone image (`groups`, `txContact`) | Call from the handheld | Result |
|---|---|---|
| `[1]`, 9 | TG 9 | silent |
| `[1]`, 99 | TG 1 | heard |
| `[1]`, 99 | private to the radio's own ID | heard |
| `[1,9,99]`, 99 | TG 99, TG 9 | heard |

- The MCU passes a group call **iff its TG is in `groups[]`** (32 slots at `0x22` body +12). The Call Number does not admit its own TG. Private calls to the radio's own ID always pass. The image's copy loop closes at `+0x962E cmpnei r0, 32`. V 2026-10-15 (G11 §19, §20).
- ALL / RECEIVE_ALL (`contactType=2`) reports `0xFFFFFF` (built with `bmaski r?, 24`) and drops audio. V (G11 §19.3, §20).
- **`0x2B` caller info** (9 bytes, LE): `[0]` call type 0 private / 1 group, `[1..4]` caller ID, `[5..8]` target (own ID or TG). Sequence per call: status 1 → ~3 s → status 2 → `0x2B` → status 2 again. V 2026-10-15 (G11 §19.2). The factory body stays 9 bytes. V 2026-10-27 (RES "DMR loop through the hotspot").
- >32 TGs per channel: not possible in software (MCU drops out-of-list calls before `RECEIVE_START`). V (CL §3).

**Transmit.** Outer symbol ±3.3 kHz on the 12.5 kHz branch (§1.8). Decoded keys on FW54: deviation p50 ~2494–2566 Hz, sync correlation 0.997–0.998, 17–18 direct-mode bursts. A DMR key read by the FM deviation judge shows p99 ~20.3–20.5 kHz (bursts and ramps), which is not an FM deviation reading and not a stop. V 2026-10-29/30 (RES FW54, FW36 "HackRF compare").

**Loop through the hotspot (factory, V 2026-10-27, RES "DMR loop through the hotspot").** Armor → hotspot (TS2, CC1, TG 9; BER 10.9 %) → relay → hotspot → Armor: status 1, `0x2B` `[01 … 09 00 00 00]` three times, audio played, status 2. The hotspot only enters DMR on TS2 (simplex hotspot) and accepts only 5–7 digit source IDs, so bench keys use a bench ID. Hotspot DMR receive BER 10.9–14.3 % is high next to M17's 0.0 % at the same offset (open).

**Colour code and slot telemetry; promiscuous receive (FW26+).**
- FW26 op 15 `[15, v]`: flag 0/1 in IRAM `0x4B364` (zeroed at boot), echoed; `v` = 2 is `sr=1`. With the flag on, `0x2B` grows to 11 bytes (received colour code `(word>>4)&15`, slot `(word>>19)&1`); off it is 9 bytes and behaviour is byte-identical. V 2026-10-25 (length only; no DMR carrier on that bench) (RES "FW26 promiscuous receive").
- First A/B pass on FW30 (V 2026-10-28, RES "Promiscuous DMR receive on FW30"): with the flag on and the TG in the list, the module reports **status 10/11** (`MIX_DIGITAL_RX_START/_STOP`) instead of 1/2; once an 11-byte `0x2B` ended `0A 00`, which is not CC1 + slot 2 (**decoding of the two bytes unverified**). Flag on → off left receive deaf until a channel write (firmware bug in the off path). Out-of-list TG with the flag on: inconclusive. Private and wrong-CC rows not run.
- FW54: monitor on/off reports the flag true/false; no out-of-list call was sent. V 2026-10-30.
- Open: whether stock monitor `0x2F` already passes an out-of-list TG (PROM must-confirm item 0).

**Bench images and DMR receive (V 2026-10-28, RES "DMR is dead on every bench image from FW19 to FW30").** The same stored 62-burst replay was heard on factory and silent on FW19, FW22, FW26, FW29 and FW30 (RSSI rose to raw `0x46`–`0x47`, no call reported). A HackRF bisect at level 20 isolated the break to **the hook at `0x18B5C`** (the per-wake branch the symbol refill used); F30F decodes the recording with `0x18B5C` left stock. V 2026-10-28 (P19 §10 2026-10-28 entries; RES F19B2).

**First group slot 0 key after a bench-ID restart (open, V 2026-10-30).** On FW52 group slot 0 sent status 3/4 and no carrier; on FW54/FW55 the first slot-0 key after the restart is either no carrier or a carrier with deviation p50 ~310–330 Hz and no sync burst; the second key decodes. The factory image's first key radiates and decodes (5.30 s, 18 bursts). Private slot 0, group slot 1 and private slot 1 decode. Cause candidate: the channel-write busy flag `0x32457` (§1.11). Source: RES FW52, FW54, FW55; P19 §10 2026-10-30.

**DMR replay is a weak receive test (V 2026-10-30).** A HackRF replay of a decoded capture, carrier moved onto 467.625 and deviation scaled toward ±1.9 kHz, read ~−84/−85 dBm and gave **no receive start on the factory image either**; FW54's replay read −108 dBm; FW55's (amp on, drive 47) read −105 dBm with 3 receive starts and no decoded call. "The replay is not a receive test." Earlier unscaled replays at HackRF level 20 did decode on factory (2026-10-28). Source: RES FW52 "Factory comparison (03:16)", FW54/FW55 tables.

### 3.4 M17

**Receive, stock firmware (DFE).** Plain demodulator: 0/100 frames at every level. A calibrated DFE (±4 symbols feed-forward at T/2, 16–48 symbols feedback, cubic and |x|x terms, per-frame timing) trained on one HackRF transmission decoded independent transmissions **100/100** at 40–100 % deviation (symbol errors 0.01 % at ±1.2 kHz, 0.60–0.71 % at ±2.4 kHz), ~−94 dBm. Training on a different recording gave 86–98/100. V 2026-10-22 (M17D).

**Receive, bench firmware (final design, R-F 2026-10-24).** `0x58` = `0xBCFD` held (op 6 variant 3) + a **fixed 41-tap per-phone-model equaliser** before acquisition + the existing audio path and frame decoder. 18 independent HackRF transmissions (other callsigns, random payloads, ±2.4 and ±1.9 kHz): every clip locks with LSF CRC; payload-exact 98–100 % at −87/−93 dBm, ~95 % at −99 dBm. POCSAG behind the same taps: 0.039 bit errors per codeword (0.24 plain). **The pass measure is payload-exact frames, not "Golay 0".** V 2026-10-24 (CL §3; P19 §10 R-F, R-G).

- SignalDeck has it since `12da3d84`; the live `HeldPathReceiver` follows one transmission (R-H); a 32.5 s 750-frame transmission is one listing equal to the batch decoder, a one-second gap stays one call (R-I, PR 13). V 2026-10-24/26.
- Bench gotcha: `hackrf_transfer -n` cancels its in-flight USB transfers (up to ~260 ms), so bench transmissions carry 0.5 s of carrier after the EOT. V 2026-10-24 (CL §3).
- Self-calibration (PR 12, design SELF): fit the 41 taps from re-encoded frames of a clean call (≥ 20 frames, ≤ 5 % re-encode disagreement), keep only if a second call ≥ 6 dB weaker or from another station decodes at least as well. Bench: a 31-frame fit at −90 dBm was not kept (18 vs 19 clean at −99 dBm). V 2026-10-25 (RES "Item 7 bench").
- Hotspot's own M17 transmission reaches SignalDeck at ~85 % good frames (`TXOffset=0`, `M17TXLevel=50`, not tuned). V 2026-10-27. A CAN mismatch is dropped silently by the receiver (hotspot CAN 0 vs channel CAN 7). V 2026-10-27 (RES "Receive muted…" CAN note).

**Receive-RAM route:** closed on this phone (§2.6).

**Transmit.** Audio path infeasible (§1.5, §1.7). TX-RAM route proven (§1.8): R4t 90/90 × 3 at Golay 0 (V 2026-10-24); SignalDeck M17 voice since `af63e000` (FW19 first key: link setup CRC ok, frames 0–35 payload-exact; FW20: 1125/1125 with the EOT; spoken 10 s check 247/247). Item 6 web Talk key on FW25: 249/249 at Golay 0, body p99 2883.7 Hz. V 2026-10-24/25.

**Independent decoder.** The MMDVM hotspot (WPSD "M17 Edition", MMDVMHost `20261012_M17`) decoded SignalDeck M17 voice at 467.625 MHz: BER 0.0 % at RXOffset −300/−600 and −450 Hz, 0.3 % at −900, late entry 6.5 % at 0; nothing at +300/+600. This is the first independent decode: sync words, LSF coding, callsign encoding, LICH, stream frames and EOT are right. V 2026-10-27 (RES "Hotspot setup…" Finding 2). The Mobilinkd `m17-demod` / SDRangel check (IND) has not been run.

**M17 SMS (packet mode).** Our decoder: 9/9 HackRF SMS received, own texts CRC good; two-frame 26-byte text 3/3 each way. V 2026-10-26 (P19 §10 23:10, 23:24). The hotspot recognises the packet LSF but reports "ended before its last frame" 45–85 ms after the frame with EOF=1; our layout matches spec 2.0.10 §2.9 line by line. Unresolved (PR 24). V 2026-10-27 (RES Finding 3).

### 3.5 POCSAG

**Receive (V 2026-10-22, POCD).**

| Decoder | Bit errors (unseen data) |
|---|---|
| plain slicer | 21–23 % |
| 61-tap linear LS equaliser | 1.5–3.7 % (same recording) |
| FF (±5 bits, T/2) + 250-bit DFE, genie | 0.6 % at 2.5 kHz, 2.5 % at 4.5 kHz |
| same, own decisions | 3.5–4 % at 2.5 kHz, 6–12 % at 4.5 kHz |
| **same with BCH(31,21) inside the feedback loop** | **0 errors**: blind decode of an independent reception at 2.5 kHz, 96/96 codewords |

Limits: at the standard ±4.5 kHz the receiver limiter compresses and the floor stays ~1–2 % (3/6 pages, damaged text); the equaliser is transmitter-shape specific (real transmitter recordings retransmitted through the radio failed); 512 baud is worse (more low-frequency content), 2400 better. V 2026-10-22.

**Receive on the held path (V 2026-10-27, P19 §10 08:31–12:16).** Held path at 2.5 kHz: 1200 and 2400 baud 3/3 payload-exact; 512 baud needed a 1.6 ms high-pass inverse and a 17-bit pad fit (τ = 7.6 ms); after the bit-clock tracker, three 512-baud texts and one each at 1200 and 2400 were payload-exact on air, corrected 0. Sixty seconds of noise open no page. After a measured 0.8 s retune settle the monitor dwell is 2.5 s.

**Transmit through the symbol engine (FW21+).**

| Run | Counts | Body p99 | Worst 0.5 s | Codewords | Source |
|---|---|---|---|---|---|
| FW21 1200, aimed ±3.5 kHz | ±7600 | 4061 Hz | — | 16/16 `HI` | RES FW21, V 2026-10-25 |
| FW21 1200, aimed ±4.5 kHz | ±8400 | 4138 Hz | — | 16/16 (air compressed) | same |
| Item 8, 512 baud | 4600 (shipped) | 2751 Hz | 4230 Hz | 16/16 | RES "Item 8 level table" |
| Item 8, 1200, one RIC | 6500 (shipped) | 3864 Hz | 4346 Hz | 16/16 | same |
| Item 8, 1200, three RICs | 6500 | 3864 Hz | 4493 Hz | 48/48 | same |
| Item 8, 2400 + idle pad | 7000 (shipped) | 4119 Hz | 4417 Hz | 16/16 | same |
| Item 8, 512 at 5400 | 5400 | 3345 Hz | 5199 Hz (**stop**) | 16/16 | same |

- Polarity: a positive count deviates low → a 0 bit is the negative count (§1.8). V 2026-10-25.
- **Independent check: multimon-ng 1.6.2** decoded the 512, 1200 and 2400-baud pages and the three-RIC page (RIC 1000001–1000003, function 3) from the HackRF captures with `-P auto`/`normal`; `-P inverted` printed no address. V 2026-10-26 (RES "Independent pager decoder").
- SignalDeck sends pages since PR 10: low-power VFO hop, 3.5 s settle, key, channel restored. The carrier is ~1.3–2 s longer than the page (ring fills before the key, then the tail). V 2026-10-25.
- Through the audio path: infeasible for real pagers (§1.7). DAPNET on the held path is practical (I, from the 0.039 errors/codeword figure).

### 3.6 APRS / AFSK 1200

- TX works over analog FM since 2026-10-16 (stereo frames, §1.9): a full AX.25 packet decoded by direwolf `atest` 3/3, valid FCS. Three TX features ship (message, position beacon, KISS TNC TX+RX); all verified on air on 144.390 MHz. V 2026-10-16/17 (CL §3).
- Lead-in: 1.6 s HDLC flags, frame sent twice (§1.10).
- RX: passive decode on any analog channel; Mic-E, compressed, objects, messages, status, NMEA, weather; auto-ack; fill-in digipeater (WIDE1-1 → MYCALL*, HackRF-verified). V 2026-10-17 (CL §3).
- Demodulator benchmark (direwolf `gen_packets -n 100` at 8 kHz): old 23/20/1 (flat/pre/de-emphasis), new 32/35/33, direwolf `atest` 24/23/24; ~4× more packets at the weak end on air. V 2026-10-20 (MEM sstv-aprs-decoder-upgrade).

### 3.7 FT8, RTTY and MCW

| Mode | Path | Measured | Source |
|---|---|---|---|
| FT8 over FM, audio path | phone PCM | on-air TX at 467.625 decoded, DT −0.02 s after the 320 ms latency calibration; RX decodes 69 % of WSJT-X decodes on ft8_lib's 14 real recordings; a slot decodes in ~0.2 s | MEM ft8-over-fm-bench, V 2026-10-22 |
| FT8, tone queue (FW21) | 79 tones × 160 ms at 1000 Hz + 6.25 Hz steps; 60 pairs before the key, 20 at 6 s | carrier 13.35 s, body p99 2101 Hz; SignalDeck `Ft8.decode`: `CQ N0CALL` at 1000 Hz, dt +0.4 s, ~−8 dB | RES FW21, V 2026-10-25 |
| FT8, FW54 | tone queue at 1500 Hz | `CQ N0CALL`, −6 dB, dt +1.2 s, 80/81 windows 1400–1700 Hz, released | RES FW54, V 2026-10-30 |
| RTTY 45.45 Bd, 170 Hz (FW21) | mark 1000 / space 1170 Hz, 22 ms bits, 33 ms stop | carrier 1.89 s, body p99 2081 Hz; SignalDeck `Rtty` decoded `HI` | RES FW21 |
| RTTY, FW54 | 2125/2295 Hz | text `FW54 OK`, carrier 3.58 s, released | RES FW54 |
| MCW 700 Hz, 20 wpm (FW21) | dit 60 ms, letter gap 180 ms | envelope reads `HI`; body p99 2021 Hz | RES FW21 |

Regressions on later images: FW46–FW53 held PTT after a tone-queue message; FW50–FW52 played the queue near 7.4–7.5 kHz. FW54 fixed both. V 2026-10-30 (RES "FW46 is the first image…").

### 3.8 SSTV

- RX: `band=0` on VHF deafened the receiver (§2.9); the VIS polarity was inverted in the old detector; Robot YCbCr is full-range. V 2026-10-16 (MEM sstv-rx-findings).
- Continuous Robot 36 decoder (no VIS, coasts through fades): whole 240 lines at 20.2 dB (old 238 at 18.5 dB); 3 dropouts still 240 lines. V 2026-10-20 (MEM sstv-aprs-decoder-upgrade).
- Doppler tolerance with the radio fixed on 437.550: +3/+6 kHz clean, +10 kHz speckled but decoded; a retune mid-picture costs one glitch line. V 2026-10-20 (MEM iss-437-doppler-bench).
- TX (PR 5 build, FW24): Robot 36 39.5 s, steady p99 2040 Hz, decoded 219/240 lines; **Martin M1 117.8 s**, p99 2029 Hz, VIS 44 read (picture not rendered in the unit-test classpath). Martin M1 took `mtktsAP` to 63.2 °C and the battery to 43.9 °C. V 2026-10-25 (RES "PR 5 SSTV pass, partial").
- Robot 8 BW on FW52/FW55: carrier 11.5 s, 1900 Hz leader, VIS 2, 120/120 line syncs, 81 % of pixels match the sent checkerboard. V 2026-10-30. FW54 did not radiate it (regression).

### 3.9 NOAA APT

- NOAA-15/18/19 decommissioned in 2025; nothing to receive. V (CL §3).
- At ±5 kHz deviation the audio is clean (decode correlation 0.99); at the real ±17 kHz the narrow-FM discriminator aliases the 2400 Hz subcarrier's 2nd/3rd harmonics to 3200/800 Hz (−26/−15 dB): correlation 0.88, 0.94 with 800/1600 Hz envelope notches. A 3 kHz offset drops 0.94 → 0.84. A retune mid-reception costs ~1.2 s of audio. V 2026-10-17 (MEM noaa-apt-bench-findings).

### 3.10 SAME (NOAA Weather Radio alerts)

- Decoder: 520.8 baud AFSK 2083/1562 Hz, DPLL, `0xAB` preamble alignment, ZCZC/NNNN, 1050 Hz tone. Bench: header + EOM decoded from a HackRF at 162.500 MHz (x = 47), notification posted. HackRF → radio link silent on 2 of 5 identical runs (HackRF hiccup). V 2026-10-17 (MEM wx-same-alerts-bench).

### 3.11 DTMF

- Decode always on for analog; send from a keypad and saved sequences (`DTMF.csv`). Shipped 2026-10-17. V (CL §3). The AT1846S tone registers `0x35`/`0x36` are never written by the image; DTMF is generated as phone audio. Read 2026-10-24 (RES T3).

---

## 4. Timing and limits

### 4.1 Transmit time-out (`0x3B`)

| Fact | Status | Source |
|---|---|---|
| The stock `0x3B` handler (`+0xA308`) **stores the byte it is sent; there is no `min(tot, 30)`**. The timer counts 100 wakes per unit; a unit is one second | Read + V 2026-10-24 | RES FW19; CL §3 |
| A byte of **0 turns the timer off**. The OEM app (`sendSetTotCmdToMdl`) and SignalDeck's old boot handshake (`setTot(0)`) both sent 0, so on stock firmware the module has no time-out. Its own start-up value is 120 | V/read | CL §3 |
| The 2026-10-16 keys that ended near 30 s were the **apps'** countdowns (OEM `PERSON_LIMIT_SEND_TIME = 30`, module `TX_LIMIT_S = 30`) | V | CL §3; MEM radio-30s-transmit-timeout |
| FW19 maps 0 or > 120 to 120. Measured: status 4 at **120.33 s**, carrier 120.35 s, never status 6 | V 2026-10-25 | RES FW19 "Ceiling" |
| A 40 s plain FM key is not ended by the module (40.75 s carrier, ended by the host) | V 2026-10-25 | RES FW19 "40 s FM tone" |
| Op 7's drop on FW19 left the TX state flagged: a second status 4 exactly **120.34 s** after key-on, and the receiver deaf (raw 6) until then | V 2026-10-25 | RES FW19 "Timer after op 7" |
| FW20: the stock unkey has to run while the TX bits are still set; then no timer status in the next 130 s and a second stream is not cut | V 2026-10-25 | RES FW20 |
| **FW36 removed the FW19 clamp** (`0xAB18` back to `bsr 0xA308`): a byte of 0 is stored unchanged and the module timer stays off from FW36 on. Standing rule: never add a transmit time-out to any phone's firmware; SignalDeck enforces it (sends 120 where the module has a timer) | V 2026-10-29 | RES "FW36"; HO line 501 |
| SignalDeck's voice watchdog 28 s; `txPcmOneShot` refuses audio > ~28.5 s (as of CL); long SSTV modes ran on the PR 5 build | V | CL §3; RES "PR 5 SSTV pass" |

### 4.2 Heat

Zones: `mtktsAP`, `mtktsbtsmdpa`, `mtktsbtsnrpa` (AP and modem PA); battery from `dumpsys battery` in tenths. Not inputs: `mtktscpu` (swings 4–6 °C idle), `mtktspa` samples of exactly 25.0 °C, `tzimgs*` and `mtktscharger` (−127 °C). Source: RES FW19 "Heat"; HO standing approval.

| Key | AP zone rise | Battery rise | Source |
|---|---|---|---|
| 30 s low power | +0.6 during, +1.1 after | +0.1 / +0.2 | RES FW19 Heat, V 2026-10-24 |
| 45 s low-power stream | +0.9 / +3.2 | +0.1 / +0.5 | same |
| 30 s high power | +1.6 / +3.4 | +0.3 / +0.6 | same |
| 45 s high power | 48.7 → 51.4 °C (+1.03 °C in the last 10 s, the old stop) | 39.2 → 39.5 | RES "High power 45 s" |
| **120 s high power** | **47.9 → 59.2 °C** (peak ~15 s after the carrier), back within 1 °C in **~17 min** | 40.2 → 41.9 °C (+1.7 by 3 min) | RES FW19 "Ceiling", V 2026-10-25 |
| Runner 30 s / 45 s low power (FW26) | +1.0 / +1.1–1.2 | +0.2 / +0.3 | FWB |
| SSTV Martin M1 117.8 s (after Robot 36) | to 63.2 °C | to 43.9 °C | RES PR 5 SSTV |
| 10 min soak, 116 DMR keys of ~2 s (FW54) | 35.3 → 39.4 °C | 30.4 → 30.9 °C | RES FW54 |

High-power current on FW36 during an M17 key: −2.7 to −3.4 A (one rising-edge sample −1.75 A); a high-power key draws about 2.5 A for the whole 3 s on factory and FW34. V 2026-10-29 (RES FW36; P19 §10).

| Threshold set | In-key stop | Long key may start | Source |
|---|---|---|---|
| **Bench** (runner, HO) | battery > 45 °C, `mtktsAP` or `mtktsbtsmdpa` > 60 °C, or > 2 °C inside 10 s (the 1 °C/10 s stop is retired); wait until `mtktsAP` is within 1 °C of the pre-key value or 10 min (a 120 s high-power key waits for the return) | — | HO; FWB `common.py` |
| **Product** (SignalDeck `ThermalGuard`, owner 2026-10-25) | 70 °C AP zone / 48 °C battery / +2 °C in 10 s | only below 60 / 45 | MEM product-heat-thresholds |

The bench numbers are equipment-protection rules, not hazards (MEM product-heat-thresholds).

### 4.3 Tuning range

- **The MCU enforces 136.000–174.000 and 400.000–480.000 MHz.** 174.000 and 400.000 ack `sr=0`; 174.005, 175–225 (220 band), 300 and 399.995 MHz → `sr=1`, and the radio **stays on its previous frequency** (a NOAA carrier at −75 dBm kept reading −75 after a rejected write). No out-of-band receive is possible over the UART. V 2026-10-21 (CL §3; MEM mcu-tuning-range-enforced).
- Band limits and power are out of scope for firmware patches (HO scope rules).

### 4.4 Frequency resolution and Doppler

| Requested offset | Landed | Source |
|---|---|---|
| 0 / +500 / +1000 / +1500 / +2500 / +5000 / 0 Hz | 0 / +499.8 / +1000.3 / +1498.9 / +2499.5 / +4999.6 / −1.5 Hz | CL §3, V 2026-10-22 |

- **The synthesizer tunes in 500 Hz steps exactly**, not a 5/6.25/12.5 kHz grid; off-grid writes ack `sr=0`. A real ISS pass retuned 437.5570 → 437.5445 MHz in 2 kHz steps, all accepted. SignalDeck's 500 Hz Doppler rounding is real. V 2026-10-22.
- The common +800 Hz offset seen in captures is the radio's and the HackRF's crystal errors together (not separable without a reference). Carrier offsets recorded on the bench range +760 to +1393 Hz. V (CL §3; RES).
- The hotspot needed RXOffset −450 Hz to decode the Armor. V 2026-10-27.

### 4.5 Transmitting resets the USB cable on some frequencies

- 2026-10-19, owner's car, wired Android Auto: TX on **144.770 MHz high power** dropped USB ~1.5 s after key-up every time (`UsbPortManager: USB port changed` → `ACTION_POWER_DISCONNECTED` → projection released); 146.370 MHz and UHF 448.550/467.625 did not. RF couples into the cable; frequency-dependent; not fixable in software. SignalDeck detects it (AA disconnect or charging stopped during / ≤ 3 s after TX) and warns. V 2026-10-19 (CL §3; MEM radio-tx-resets-usb-cable).
- Related, different phone (Atom XL): powering the radio puts the only USB controller into host mode and drops adb. V 2026-10-28 (CL §3). Not an Armor behaviour.

### 4.6 Other timings

| Item | Value | Status | Source |
|---|---|---|---|
| Analog channel reprogram | ~0.6 s receive gap | V 2026-10-14 | G11 §17.1 |
| Retune before keying | ≥ 3.5 s | V | CL §3 |
| RSSI after retune | ≥ 0.7 s | V 2026-10-22 | CL §3 |
| Status 3 after `0x26` body 1 | 4–13 ms | V 2026-10-24/25 | RES |
| Status 4 after an op 7 drop (FW20) | 0.33 s later a second status 4 (stock unkey) | V 2026-10-25 | RES FW20 |
| YModem load (SignalDeck sender) | erase 11.4 s, ~0.29 s per 1 KiB block, 248 s per load; ~138–148 s with the block pause at 0 | V 2026-10-25 | CL §1; RES Phase E |
| Full image flash read (op 12, 240 B per read) | 971 s | V 2026-10-25 | RES FW22 |
| UART | 57600 actual 57692 Hz (+0.160 %, DesignWare, 48 MHz clock); 230400 = divisor 13, 230769 Hz | V/read 2026-10-24 | P19 §10 R-D |
| Cold boot with "Own the radio at boot" | SignalDeck up by itself at 47.9 s; with it off, SignalDeck takes the radio ~7.2 s after opening | V 2026-10-26 | P19 §10 05:50 |
| Loads persist | a loaded image goes to flash and survives module power-cycles and phone reboots; restore = load the factory image | V 2026-10-23 | P19 §14 |

---

## 5. Bench methods

### 5.1 Layout and defaults

- Phone and HackRF next to each other inside the Faraday cage. Owner principle (2026-10-24): anything that cannot damage equipment is allowed; 467.625 MHz and low power are defaults for comparability, not limits (VHF needs `band=1`). HO "Standing approval".
- End state after a run: SignalDeck owns the radio, no `DMRDEBUG.bin`; the test image may stay loaded; the factory image is loaded when there is a reason (a stop, a bad banner or tag, an unknown image, boot radiation, or leaving a known-good radio). The radio may stay on the test frequency. HO.
- Bench identities are test values only (callsign N0CALL / a bench callsign, a bench DMR ID); never the owner's.
- Leases: the phone, HackRF, hotspot and Atom XL are used only under a pushed lease line (HO; `docs/atomxl-status.md`).

### 5.2 HackRF capture of the phone's transmission

| Setting | Value | Source |
|---|---|---|
| Command | `hackrf_transfer -r` only, `-f 467385000 -s 2400000`, finite `-n`; never `-R`, never `-t` during a phone key | RES FW17 "How the numbers were taken" |
| Offset | signal parked 240 kHz above the tuner centre (off the DC spike) | FWB `common.py` |
| Demod | mix by exactly 240 kHz, decimate ×50 to 48 kHz, 9 kHz low-pass (129-tap), phase difference → instantaneous frequency, subtract the median over the keyed region | FWB `fm.py` |
| Gains | low-power key at ~5 ft LNA 16 / VGA 16; boot capture LNA 24 / VGA 38; LNA 8 / VGA 8 when LNA 16/16 clips; **high power: LNA 0 / VGA 0** (clip 0, peak 13–14 of 127) | FWB; HO |
| Carrier bounds | power above 20× the quietest one-second window; on a capture the carrier fills, use a magnitude gate instead (block mean |x| > 8) | FWB `fm.py`; RES FW19/FW20 |
| No-carrier judge | the whole file within 6 dB of its quietest second | FWB `fm.py` |
| Carrier length | keyed seconds between the first and last on-sample | FWB |
| Body p99 | 99th percentile of |dev − median| with the first and last 50 ms dropped; plus 0.5 s slice p99s | FWB `key_report` |
| 1 kHz line | Hann-windowed Goertzel amplitude at 1000 Hz on the body (`line1k_dev_Hz` = the line's deviation, not its frequency; older records say `line1k_Hz`) | FWB; RES 02:23 |
| Clip | fraction of raw int8 samples ≥ 126; a kept capture must be 0 | RES FW17; FWB |
| Stop | any 0.5 s slice or the p99 at or over **5000 Hz** ends the step (`stop_hz`); applies to **our** stimuli, not to measurements of factory modulation (P19 §21); key-up and drop clicks are not stops | FWB; HO; P19 §21 |
| Tones on probe | a linear prediction past ±5 kHz is not sent; FW17 used a −36 dBFS 1 kHz + 3.5 kHz probe instead of the 1 kHz `testtone` | RES FW17 |
| Boot judge | floor = median of the 100 ms bins before the restart; peak dB above it; a run ≥ 10 dB is radiation (`SILENT` = no such run) | FWB `boot_report` |

### 5.3 HackRF transmitting into the radio

- `hackrf_transfer -t file.iq -f <freq> -s 2000000 -x <gain> -a 0 -n <samples>`. On 2 m (inches apart) **`-x 47` is needed**: `-x 20` lands below the ~−90 dBm squelch (−73 dBm at 47). V 2026-10-16 (MEM sstv-rx-findings). At the UHF bench placement VGA 20 (amp off) ≈ −87/−89 dBm (§2.11).
- **Dummy burst first**: the first `-t` after a pause is often silent. V 2026-10-17 (MEM hackrf-killed-by-nearby-radio-tx; FWB `hackrf.dummy`).
- M17 bench files: 1.6 s unmodulated lead, frames, EOT, then 0.5 s of carrier (the `-n` tail cut). V 2026-10-24/25.
- Never key the phone while the HackRF transmits next to it. HO.
- HackRF transmit only inside the cage, never from the outdoor antenna; while the HackRF is on the outdoor antenna it is receive-only. HO; MEM hackrf-outdoor-antenna-rx-only.

### 5.4 The fw-bench runner (`tools/fw-bench/runner/bench.py`)

Accepted on the Armor 2026-10-26 against FW26; every later image runs it first. Nothing keys without `--arm`; Diagnostics must be on in SignalDeck. Source: FWB.

| Row | What it does | Pass (Armor reference, FW26) |
|---|---|---|
| `tag` | reads `0x34` through SignalDeck's settings API (the version line drops out of logcat once the signal poll runs) | `DMR003.FW26.V022` |
| `boot` | 3 s lead, `restartmodule`, 20 s capture at LNA 24 / VGA 38 | silent: no 100 ms bin ≥ 10 dB (peaks 0.048 / 0.07 dB; README bar "under 0.1 dB") |
| `tone` | 10 s 1 kHz `testtone` with the lift flag (else the app clamps at 5 s) | carrier within 1.5 s of 10 s, 1 kHz line > 0.5× p99, no stop (body p99 2.54–2.55 kHz, hottest half-second 4.03–4.04 kHz) |
| `stream` | 1125-frame M17 symbol file through `0x40` with EOT, captured at LNA 8 / VGA 8, decoded | ≥ frames − 1 payload-exact (bytes 0–15, Golay 0), end bit, clip 0, p99 < 5 kHz (1125/1125, 45.41 s, p99 2903–2908 Hz) |
| `heat` | test tone of N s (default 45), zones every 5 s, unkey on the heat rule | no stop (30 s: AP +1.0 °C; 45 s: AP +1.2 °C) |
| `receive` | dummy burst, 6 s HackRF 1 kHz FM tone (±2.5 kHz, VGA 20) while the phone records a WAV clip | the 1 kHz line is in the clip (−19.1 dBFS) |
| `all` | the five in order, waiting until `mtktsAP` is within 1 °C of the previous key or 10 min | all pass |

Not runner rows: a plain-versus-held tone table, M17 receive at two levels, a 120 s time-out key (they stay in RES). `armor-2026-10-snapshot/` is a read-only copy of the scripts the firmware work ran from; do not run it blind.

Later runner results: FW51/FW52 `all` passed (stream carrier 47.7 s, p99 2885–2889 Hz); FW36 failed `receive` (no 1 kHz line, the post-key mute). V 2026-10-29/30.

### 5.5 Decoders used

| Decoder | Use | Independent? | Source |
|---|---|---|---|
| `tools/m17-research/m17.py` | M17 TX scoring (payload-exact, Golay, LSF CRC), DFE and held-path research (`heldpath_eq.py`, `heldpath_rf_score.py`, `fw27_stream_levelmap.py`) | no (ours, written from the spec) | M17D; CL §3 |
| SignalDeck `HeldPath.decode`, `HeldPathReceiver` | on-phone M17 receive | no | RES |
| MMDVM hotspot (MMDVMHost `20261012_M17`) | first independent M17 decode; DMR header/BER | yes, but never the sole receiver (§5.6) | RES "Hotspot setup…" |
| `m17-demod` / SDRangel (Mobilinkd family) | planned independent M17 check (BERT mode for a BER figure) | yes | IND (not run) |
| `tools/pocsag-research/pocsag.py`, SignalDeck `Pocsag.decode` | POCSAG scoring (polarity flag) | no | RES Item 8 |
| **multimon-ng 1.6.2** (built with MSYS2 MinGW, `-DONLY_RAW…`) | independent pager decode; audio resampled 48 kHz → 22050 Hz s16 | yes | RES 02:23 |
| direwolf `atest`, `gen_packets` | APRS TX verification and the demodulator benchmark | yes | CL §3; MEM sstv-aprs-decoder-upgrade |
| `scratchpad/sstv_rx.py` (PC), SignalDeck `RecordingDecoder.sstv`, `SstvContinuous` | SSTV; the PC decoder needs an 800–2800 Hz band-limit before the Hilbert transform | partly | MEM hackrf-killed…, sstv-rx-findings |
| SignalDeck `Ft8.decode`, `Rtty`, Morse envelope | FT8/RTTY/MCW from the tone queue | no | RES FW21 |
| ft8_lib recordings (14), WSJT-X counts | FT8 RX benchmark | yes (reference) | MEM ft8-over-fm-bench |
| Codec 2 decoder | checks M17 voice payloads (a 1 kHz tone peaks at 1003 Hz; speech 9.88 s) | — | RES "M17 voice", FW20 |
| BTECH DMR-6X2 | on-air DMR group/private admission | yes | G11 §19 |
| Atom XL (second phone, same HR-C7000 family) running SignalDeck | second receiver: RSSI above −90 dBm = carrier; DMR voice line with caller ID | yes | RES FW36–FW38; HO |

### 5.6 The hotspot rule and the second-receiver rule

- Owner rule (2026-10-29 08:30): **the hotspot is not a trusted receiver on its own; no result counts as a failure on the hotspot's word alone.** For every DMR or M17 check a second receiver must agree: M17 — a HackRF capture decoded with our decoder (payload-exact) or the Atom XL (RSSI plus SignalDeck's decode); DMR — the Atom XL on the same channel showing the caller ID, plus HackRF bursts at the right slot timing or an offline decode. A hotspot-only pass is fine; a disagreement is logged as "hotspot fault, not a radio result". HO; MEM hotspot-not-sole-receiver.
- Why: on 2026-10-28/29 the hotspot logged `Mode set to DMR` with no RF voice header from 2026-10-28 20:49 UTC on, which looked like an Armor fault for hours; part of it was FW31–FW34 not radiating and a DMR slot/mode issue. RES "Hotspot DMR logs"; MEM.
- From FW52 on, acceptance rows name "the HackRF was the second receiver". RES FW52/FW54.

### 5.7 Recovery order and the factory-load-and-key rule

- Recovery for a silent module, in this order, one try each: DIAG `restartmodule` and read `0x34`; a module power-cycle (`diagPowerCycle`) and read `0x34`; the firmware page's Restore (factory image from the verified backup) and read `0x34`. A HackRF that does not stop is power-cycled at the PortaPack. Nothing in recovery keys the radio. HO "Protocol".
- **After any image that hung, took a wild branch or was restarted mid-command, load the factory image and key it once (3 s stock PTT on a digital channel, status 3 seen) before the next bench image. When a bench image stops radiating with no change in its bytes, the factory load is the first recovery.** Origin: 2026-10-26 20:44–21:01 the symbol stream produced no carrier on FW27 and FW26 alike; image reloads, `restartmodule`, a 15 s `dmr009` power-off and tunes did not clear it; the factory load and one key did (21:25, 1125/1125 again). V 2026-10-26 (HO; P19 §10 20:50–21:25; CL §3).
- After a hang mid-load (e.g. a port write during YModem), `restartmodule` can leave the version reply empty; the retry completes. V 2026-10-27 (RES FW30 image 2).
- Known non-booting placements: the 128-byte table tail at `0x35F64` (R4l, FW30 image 3) — never reload R4l0. A reclaimed range must contain no literal that code outside it loads (FW27 overwrote the key helper's `lrw` pool at `0x5BE60` and the module never answered the key). V 2026-10-24/26.
- An IRAM call from the XIP tail must use the IRAM address (`lrw` + `jsr` to `0x2B25C`), not a `bsr` to the flash copy (FW30 image 3b did not return). V 2026-10-27.

### 5.8 HackRF gotchas

| Gotcha | Rule | Source |
|---|---|---|
| The radio keying at close range kills the HackRF receiver (`streaming stopped (-1003)`, then floor-only captures, mean |x| ≈ 0.017) | more distance/attenuation; a full **PortaPack power-cycle** (USB replug is not enough) | MEM hackrf-killed-by-nearby-radio-tx |
| The first `-t` after a pause is often silent | send a dummy burst first | same; FWB |
| A killed `-R` (repeat) transfer wedges in the WinUSB driver; `hackrf_open()` fails −1000 and the device may keep radiating the last buffer | never background or kill `-R`; use finite files sized to the test; check `tasklist` for `hackrf_transfer` first; only a power-cycle frees it | MEM hackrf-transfer-stuck-process |
| A `timeout`-killed 90 s transmit hung the same way (2026-10-29) | timeout = file duration + 15 s; refuse files over 60 s unless asked; refuse to key while another transfer runs | same |
| Intermittent HackRF → radio link (2 of 5 identical SAME runs silent) | treat a silent run as a HackRF hiccup, repeat | MEM wx-same-alerts-bench |
| A capture opened right after closing the HackRF is empty | do not measure from it | P19 §10 R3a3 |
| Front-end protection | close-range keys drive the IQ into clipping at LNA 24 (clip 0.3–0.4 on R4k/R4o); high power only with LNA 0 / VGA 0, an attenuator or distance | HO |

### 5.9 DMR replay as a receive test

A HackRF replay of a recorded DMR call is a weak test on this bench: replays scaled in deviation and moved in frequency gave no receive start on the factory image at ~−85 dBm (2026-10-30), and the FW55 replay with the amp on and drive 47 read −105 dBm with three receive starts and no decoded call. The unscaled stored call at HackRF level 20 did decode on factory on 2026-10-28, and so did the hotspot relay's replay. Use the hotspot relay replay or a real handheld, confirmed by the Atom XL, for DMR receive. V (RES FW52/FW54/FW55, 2026-10-28 bisect).

### 5.10 Measurement discipline (HO)

Tune first; check the banner and the `0x34` tag after every load; the ±5 kHz rule on what we transmit (a test that needs more says so first); boot capture on every image; `git pull --rebase` before every load; one long or high-power key at a time under the heat rule (§4.2). Every image carries a 4-character tag in its version string (e.g. `DMR003.FW26.V022`; `UVm10` had to be `Vm10`, `R3a10` became `R3b0`).

---

## 6. Where the sources disagree

| Topic | Source A | Source B | Resolution |
|---|---|---|---|
| Transmit time-out | MEM sstv-rx-findings: "firmware TOT caps TX at 30 s" | CL §3, RES FW19: the stock handler stores the byte; 0 = off; the 30 s was the apps' countdowns | B (bench 2026-10-24/25). A is **S** |
| FW19 clamp current? | CL §3: "FW19 writes 120 when the byte is 0 or above 120"; HO scope rule "the 120 s ceiling is approved" | RES FW36 (2026-10-29): the clamp was removed; from FW36 the timer is off as on stock; HO standing rule "never add a transmit time-out to any phone's firmware" | Latest: images FW36+ have no clamp; SignalDeck enforces the limit |
| TX gain per PCM count | M17D: 0.45–0.48 Hz/count, 400 Hz–1 kHz | RES FW17: 0.20–0.22 Hz/count at 1 kHz on every image | Unresolved; different sessions and stimuli (M17D was a wide VFO; FW17 low power, DIAG). Neither source states the channel width for both. Treat as per-setup |
| Transmit low cut depth | M17D, CL §3: ≈ −60 dB below 250 Hz | RES FW17/UVm9, P19 §19: ≈ −40 dB (best −40.9 dB) | Both are floor-limited readings; the stop-band is at least 40 dB deep |
| POCSAG TX pre-emphasis | POCD: "≈ +30 dB from 50 Hz to 2 kHz" | RES FW17: +6.1 dB at 2 kHz vs 1 kHz; 50 Hz absent | POCD's figure combines the low cut with the pre-emphasis; FW17's table separates them |
| Limiter ±4.5 kHz | M17D: limiter at ~±4.5 kHz, hit at low audio levels | RES FW17: 1 kHz still linear at −6 dBFS (3.1–3.3 kHz); ceiling not measured | Not contradictory; the ceiling was never re-measured after M17D |
| Where the TX cut sits | RES UVm9 / P19 §10 (16:50): "the analog coupling between I2S playback and the **codec ADC** input" | P19 §18/§19, UVm10/11: the C7000 codec ADC and DAC are in neither path; the cut is between the ES8311 output and the AT1846S mic input | Later (§19) wins |
| Factory DMR outer symbol | P19 §10 R1: +7346 / −7049 Hz (±7.3 kHz), 7.2 % below 250 Hz | R1b: ±3.3 kHz, 17.7 % below 250 Hz | R1b wins (the first was a tail lock); R1 **S** |
| `RF_MODE` `0x10E0` bit 7 | P19 §10 R2: "bit 7 = 0" | P19 §10 T2 (later): the store sets bit 7 (`rf_transiq_mode` = 1, sign reversed) | T2 wins (the earlier paragraph is left as written) |
| Receive-RAM stream clock | P19 §10 15:25: 8103 Hz (987.25 Hz line) | 16:13: 8000 Hz | 8000 Hz (the earlier reading was a file's noise floor) |
| Squelch threshold | CL §3: "one threshold near −90 dBm" | G11 §17.1: between −94 and −81 dBm, not narrowed further | Consistent; −90 is an estimate inside the measured window |
| Boot "silent" bar | FWB README: "the bar is under 0.1 dB" | FWB `fm.py`: SILENT = no run ≥ 10 dB; images passed at 0.108, 0.28 and 0.42 dB | The code's 10 dB run rule is what judges |
| Receive-RAM route status | CL §3 (earlier text): "parked 2026-10-26 … reopen only for a phone whose audio path cannot be made flat" | CL §3 (later text) and P19 §10: reopened as FW27 the same day, then closed on saturation | Closed on the Armor (2026-10-26, 20:34) |
| SSTV TX modes | CL §3: SSTV TX still Robot 24 / 12 / 8 only until the long modes land | RES "PR 5 SSTV pass": Martin M1 117.8 s and Robot 36 39.5 s sent on the PR 5 build | Long modes exist on that build; the shipped state is SignalDeck's changelog's to say |
| DMR on bench images | RES 2026-10-28 02:20: "DMR is dead on every bench image FW19–FW30" | RES later 2026-10-28: the break is the `0x18B5C` hook; F30F and later images decode with it stock; FW36 DMR confirmed by the Atom XL | The later bisect wins |

---

## 7. Open questions

1. **Transmit low cut, hardware or not.** The ES8311-to-AT1846S coupling was inferred, not probed. A schematic or a scope on that line would settle it. Is there any ES8311 DAC-side register (not exposed in ALSA) that shapes the low end?
2. **ES8311 ADC high-pass (`0x1B`/`0x1C`).** Not read yet (count-0 read on `es8311_debug` is allowed; writes are the owner's call). How much of the receive loss and the 500 Hz dip is it?
3. **Phone-audio gain discrepancy** (0.22 vs 0.45–0.48 Hz/count) and the true **limiter ceiling** of the audio path: re-measure both on one setup, stating the channel width.
4. **Per-frequency deviation of the symbol engine.** 4523 Hz at 438.800 vs 2866 Hz at 467.625. Measure across 400–480 and 136–174 MHz and decide where the scale lives (SignalDeck or the engine). Does the phone-audio FM path vary the same way?
5. **Why ±3.3 kHz DMR outer deviation** (1.7× the standard) on the 12.5 kHz branch, and whether it affects interoperability beyond the BTECH 6X2 and the hotspot (hotspot DMR BER 10.9–14.3 % vs M17 0.0 %).
6. **Receive mute after a symbol key:** FW38 restores `WORK_MODE` and the FM bandwidth; is that the whole fix, and does it hold on the current image line (FW52+)? Which state does a channel write reset that the drop does not?
7. **First DMR group slot 0 key after a restart** fails on FW52/FW54/FW55 and not on factory. Is it the busy flag `0x32457` (the FW56 gate is built, not loaded)?
8. **Promiscuous receive:** meaning of the two appended `0x2B` bytes (`0A 00` seen), status 10/11 handling, the flag-off deafness, out-of-list TG, wrong colour code, private calls; and whether stock `0x2F` monitor already passes an out-of-list TG.
9. **Independent M17 decoder** (`m17-demod` BERT, SDRangel) still not run; the hotspot is the only independent decode so far. M17 packet mode is rejected by MMDVMHost although our layout matches spec 2.0.10.
10. **Receive-RAM saturation point.** Between the AT1846S demodulator and the C7000 capture: is there any register on another phone family (same SoC) that moves the knee?
11. **The stationary ~320 Hz tone** at −13.7 to −16 dBFS in open-squelch analog audio (FW24/FW25). Source unknown.
12. **Squelch levels 1–9** inside the −94 to −81 dBm window: untested at ≈ −88 dBm.
13. **Channel-specific no-carrier** (2026-10-29: channel 56 / a single analog `0x23` left no full carrier on factory and FW32; channel 49 restored it). Not explained.
14. **DMR receive test method:** a reliable replay level and format for HackRF-driven DMR receive, since scaled replays fail on factory.
15. **POCSAG at ±4.5 kHz through the engine**: the modulator ceiling (~4.1 kHz p99) keeps standard deviation out of reach; is the TX-RAM scale (`FM_DEV_COEF` transmit limiter field) able to raise it, and is that in scope?
