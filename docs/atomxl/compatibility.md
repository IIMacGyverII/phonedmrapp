# SignalDeck on the Unihertz Atom XL: compatibility

**State as of:** 2026-10-29 14:40.

**Bench phone:**
- Unihertz Atom XL ATOMXL0000000737, Android 10 (Agold build), rooted.
- Radio module DMR006.U4A.V067 behind the STM32 USB bridge `20201016161541`.
- UHF only, 400–480 MHz.

**Profile:** `unihertz-atomxl`, revision 2. Verified, with transmit on (owner, 2026-10-28).

**How it was tested:**
- Bench in the cage, with the HackRF as the other station on 401.025 MHz (channel 2, BENCH FM) unless noted.
- "PR" is the SignalDeck pull request that made or fixed the feature. All are merged into SignalDeck main.

## Features

| Feature | Result | Tested | PR | Notes |
|---|---|---|---|---|
| Take over / Exit / Hand back | **works** | 2026-10-28 | 76 | Hand back takes about 20 s (it checks the bridge answers first). Exit and Hand back power the radio off and give the USB port back |
| Own the radio at boot | **works** | 2026-10-29 | 76 | ~67 s after a reboot |
| Analog FM receive (sound) | **works** | 2026-10-29 | 76, 92 | Per-reception capture from the bridge's USB sound card. Since PR 92 a capture drop-out recovers with one bridge restart instead of failing until a reboot (15 receptions, 2 drop-outs, both recovered) |
| FM transmit | **works** | 2026-10-28 | 76 | Keyed in the cage, decoded |
| DMR group and private calls, with caller ID | **works** | 2026-10-28 | 76 | HackRF DMR calls, caller named |
| DMR voice transmit | **works** | 2026-10-28 | 76 | |
| DMR texts in and out | **works** | 2026-10-28 | 76 | |
| MON | **works** | 2026-10-29 | 86 | Opens the sound at once on analog, even with a stuck reception line |
| APRS receive (passive) | **works** | 2026-10-29 | 79 | 18 of 20 HackRF frames. Decoder CPU halved in PR 93 (all phones) |
| APRS transmit | **works** | 2026-10-28 | 76 | Decoded in the cage |
| DTMF receive | **works** | 2026-10-28 | — | "1234#" exact |
| SSTV receive | **works** | 2026-10-29 | — | Robot 36 decoded clean |
| FT8 receive | **works** | 2026-10-29 | 84 | Both messages decoded, −13 dB, DT +0.1 s |
| RTTY receive | **works** | 2026-10-29 | 92 | 8 of 8 decoded after PR 92 (6 full, 2 missing the first letters) |
| Live captions + keyword alerts | **works** | 2026-10-29 | — | Vosk on the phone (default model, 125 MB, downloaded). Caption near word for word, alert raised |
| Voice announcements | **works** | 2026-10-29 | — | Spoken on the phone speaker |
| M17 receive | **partial** | 2026-10-29 | 96 | Its own calibration (the bridge records ~125 ppm fast). 71–89 of 100 frames exact on test recordings. On the phone, three test transmissions were listed with 83–90 frames each. Self-calibration can improve it |
| M17 transmit | **n/a** | — | — | Needs the bench firmware's symbol engine. The stock module can't |
| POCSAG page receive and send | **n/a** | — | 85 | Needs the bench firmware's symbol engine and held path. Hidden on the phone and in SignalDeck Web |
| SAME weather alerts | **n/a** | — | — | SignalDeck decodes SAME only on 162.40–162.55 MHz; this radio is UHF only |
| SignalDeck Web audio | **works** | 2026-10-29 | 86 | 53 of 60 s during MON on a healthy line |
| SignalDeck Web messages | likely works | — | — | No profile gate; page not opened on this phone |
| Band scope | **works** | 2026-10-29 | 88 | Inside 400–480 MHz; a 2 m range is refused |
| Fox hunt, coverage log | works (by its parts) | 2026-10-29 | — | Signal readings come through during receptions; dialogs not run with GPS |
| Android Auto | **works** | 2026-10-29 | — | Desktop head unit: SignalDeck appears as the media app, and next/previous change channel. A real car hides it until Android Auto's Unknown sources is on (the Device page explains) |
| Firmware loader | **n/a** | — | 83 | This module can't be loaded from SignalDeck; the stock app's own update route failed on this bridge build (V076 attempt 2026-10-28) |
| Device report | **works** | 2026-10-29 | 82, 87 | With a `reception line:` row |
| Stay awake while the radio is owned | **works** | 2026-10-29 | 90 | 5 of 5 RTTY decoded with the screen asleep |

## Known limits

1. **The reception line can stick.** The bridge's "reception started/ended" signal (`/dev/stmcu`, interrupt `mcu-eint`)
   stops for the whole session.
   - Reproduced 2026-10-29 (1 of 3 replays): a bridge restart during a reception, then SignalDeck force-stopped during
     another, then started again. A force-stop on its own did not do it (11 runs).
   - SignalDeck notices it (PR 87), finds receptions from the signal reading instead, and restarts the bridge once.
   - With PR 98 that restart, and taking the radio again, use the stock HAL's power-off pulse. It brought a stuck line
     back without a phone reboot (1 of 1 so far).
   - A phone reboot always clears it. The exact trigger is still under investigation.
2. **Capture drop-outs.** The bridge's USB audio sometimes stops for 2 s. The kernel then ends the stream, and only a
   bridge power-cycle restarts it, a few seconds without sound.
   - With PR 92 this is rare and recovers.
   - It seems to depend on the signal (some RTTY, speech and one M17 transmission; never a steady tone).
   - The firmware update to V076 may help.
3. **Charger noise.** With a charger on the USB socket the idle level rises to about −98 dBm (from −101 to −103).
   PR 97 keeps reception detection working.
4. **USB while the radio is on.** The phone's only USB controller serves the radio, so a computer can't use the USB
   cable for data while SignalDeck has the radio; work over Wi-Fi ADB. A computer or charger on the socket did not
   cause the drop-outs (tested 2026-10-29).
5. **No M17 transmit or POCSAG** without the bench firmware's symbol engine. No firmware loading from SignalDeck on
   this module.
6. **UHF only (400–480 MHz):** no 2 m, no NOAA or SAME.
7. **Agold App block** must be switched off for SignalDeck (Settings → App block). SignalDeck opens the page once,
   otherwise Android force-stops it 5 minutes after screen-off.
