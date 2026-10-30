# Plan: longer SSTV transmit modes (after the transmission-length setting)

**Owner, 2026-10-30:** the new *Longest transmission* setting (default 2 min, user-adjustable with a heat warning; SignalDeck branch `tx-length-setting`) opens up more SSTV modes. Plan them, implement them and test them. **Not for beta.22.**

## Where we are

| | Modes |
|---|---|
| **Transmit today** (`pkt/SSTVEncoder.MODES`) | Robot 8 BW, Robot 12 BW, Robot 24 Color, Robot 36, Martin M2, Scottie S2, PD 90, Scottie S1, Martin M1. The long ones run up to about 115 s, under the 118 s cap, with the cool-down guard. |
| **Receive today** (`pkt/SSTVMode`) | The same, plus **Robot 72, Scottie DX, PD 120, PD 180**. |

The transmit cap so far was 118 s, from the module timer of 120 s. With the setting, SignalDeck's limit and the module timer follow the user's choice:
- up to 255 s, the module timer follows the setting;
- above 255 s or with no limit, the module timer is off and SignalDeck's watchdog applies.

The product heat stops stay in force for every key longer than 30 s: radio area 70 °C, battery 48 °C, or a 2 °C rise in 10 s.

## Modes to add, in order

Lengths are approximate, from the mode specifications; confirm each against the encoder's own `durationMs`.

| Phase | Mode | VIS | Length | Needs | Receive already? |
|---|---|---|---|---|---|
| 1 | Robot 72 | 12 | ≈ 72 s | fits the default 2 min | yes |
| 1 | PD 120 | 95 | ≈ 126 s | setting ≥ 3 min | yes |
| 1 | PD 180 | 96 | ≈ 187 s | setting ≥ 3 min 10 s | yes |
| 1 | Scottie DX | 76 | ≈ 269 s | setting ≥ 5 min; module timer off (> 255 s) | yes |
| 2 | PD 160 | 98 | ≈ 161 s | setting ≥ 3 min | no: decoder and encoder |
| 2 | PD 240 | 97 | ≈ 248 s | setting ≥ 5 min | no |
| 2 | PD 290 | 94 | ≈ 289 s | setting ≥ 5 min; module timer off | no |
| 3 (optional) | Wraase SC2-180, Pasokon P3/P5/P7, MMSSTV MR/MP/ML | various | 3–7 min | long settings | no |

Phase 1 needs only encoder work, because the decoder already knows those modes. Phases 2 and 3 need both sides.

## App behaviour

- **The picker:** list every mode, shortest first, with its length. A mode longer than the current setting is shown but disabled, with "needs Longest transmission ≥ N min (Device → …)". It isn't hidden, so users can see what a longer setting would allow.
- **Before a key longer than 30 s:** the existing cool-down gate and `tooHotToStart` check run. During the key, the in-key heat watch runs. If a heat stop ends the picture early, the history line says so, and that the picture is incomplete.
- **Power:** suggest Low power for modes longer than 2 min (one line in the picker hint; the user decides).
- **Help:** add the SSTV topic's mode table with lengths, and the setting each mode needs.

## Testing (bench, HackRF in the cage, low power on 467.625 MHz)

For each new mode:
1. **Encoder unit test:** the duration matches the spec within 0.5 %, and the VIS code is right.
2. **Loopback:** the encoder's audio through our own decoder gives the picture, with a pixel error budget per mode.
3. **On air:** transmit from the Armor (beta with the setting), capture with the HackRF, then decode:
   - with **our decoder**;
   - with **an independent decoder**: QSSTV or MMSSTV on a PC from the demodulated audio, or pySSTV/slowrx if one runs here. Record the image and a side-by-side.
4. **Heat:** log the AP zone and battery before and after each key longer than 2 min, and check the cool-down gate holds the next long key. Scottie DX and PD 290 (≈ 4.5–5 min) are the heat cases. If the stops end them early at low power, record that and say so in the help.
5. **Receive:** for phase 2/3 modes, HackRF → phone with known pictures, decoded on the SSTV page.

Phone and HackRF time only through the usual leases, and firmware work has priority on the Armor and the HackRF. The Armor is the reference phone. Other phones follow their own certification (§3.7 timing, TX heat).

## Dependencies

1. The *Longest transmission* setting is merged, after beta.22.
2. The heat stops are confirmed on voice keys longer than 30 s (part of that setting's device test).
