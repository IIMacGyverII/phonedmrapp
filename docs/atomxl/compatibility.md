# SignalDeck on the Unihertz Atom XL: compatibility

**State as of:** 2026-10-29 19:30.

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
| Analog FM receive (sound) | **works** | 2026-10-29 | 76, 92, 100, 102, 110 | Per-reception capture from the bridge's USB sound card. Drop-outs fixed by PR 110 (no signal reading while the audio streams): 17 of 17 RTTY/speech receptions clean (12 bench build + 5 PR build), against 1 in 6 before. A drop that still happens recovers with one bridge restart (PR 92, 102) |
| FM transmit | **works** | 2026-10-28 | 76 | Keyed in the cage, decoded |
| DMR group and private calls, with caller ID | **works** | 2026-10-28 | 76 | HackRF DMR calls, caller named |
| DMR voice transmit | **works** | 2026-10-28 | 76 | |
| DMR texts in and out | **works** | 2026-10-28 | 76 | |
| Reception detection | **works** | 2026-10-29 | 87, 97, 98, 107 | The bridge's reception line, with a watchdog that finds receptions from the signal when the line misses one (PR 87). A stuck line is restarted without a phone reboot (PR 98, 1 of 1). Short off-channel bursts (another transmitter in the cage, about 2.6 s) are ignored and cause no restart (PR 107, seen live twice) |
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
| SignalDeck Web messages | **works** (receive side) | 2026-10-29 | — | Page loads over Wi-Fi, lists and opens threads, quick replies and typing work, Send is enabled; a send from the web not run yet (it transmits) |
| Band scope | **works** | 2026-10-29 | 88 | Inside 400–480 MHz; a 2 m range is refused |
| Fox hunt, coverage log | works (by its parts) | 2026-10-29 | 110 | They keep reading the signal during receptions (PR 110 holds only the S-meter); dialogs not run with GPS, and a fox-hunt reading during a reception not yet confirmed on the phone |
| S-meter during a reception | **holds** | 2026-10-29 | 110 | Shows the reading from just before the reception and moves again when it ends (a reading during it breaks the audio). A reading every 2 s dropped the audio in 2 of 2 receptions, so the hold stays |
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
   - PR 107: a burst from another transmitter shorter than 3 s no longer counts as a missed reception, and automatic
     restarts are at least 20 s apart (no restart chains).
   - A phone reboot always clears it. The exact trigger is still under investigation.
2. **Capture drop-outs.** The bridge's USB audio sometimes stops for 2 s. The kernel then ends the stream, and only a
   bridge power-cycle restarts it, a few seconds without sound.
   - **Cause found 2026-10-29: a command crossing the bridge's USB link while it streams breaks the stream.** The
     S-meter's signal reading (0x32 every 0.5–2 s) was the only regular one. With no reading during a reception, 12 of
     12 RTTY/speech receptions were clean, against 1 drop in 6 with it; two read-pattern variants copied from the stock
     HAL (read on after EIO, 320-frame reads) dropped 2 and 3 in 8.
   - SignalDeck PR 110: on the Atom XL the S-meter holds its last reading during a reception. Fox hunt, the coverage
     log and the checks still read (and may cost a drop).
   - With PR 92 a drop that still happens recovers with one bridge restart.
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
8. **A transmitter close by deafens it.** In the test cage another phone keying on 446 MHz at low power dropped the
   Atom XL's signal reading on 401.025 MHz from its idle level to near the bottom of its range for the whole key
   (2026-10-29); it hears nothing meanwhile, and recovers at once when the key ends. It does not fake a reception.

## What is left before "fully compatible"

Hardware or module limits (SignalDeck cannot change them; documented above and in the in-app help):
- UHF only: no 2 m, NOAA, SAME or 2 m satellites.
- No computer data on the USB cable while SignalDeck has the radio (one USB controller); Wi-Fi ADB works.
- A transmitter close by deafens the receiver for the length of its key.
- M17 transmit and POCSAG need the bench firmware's symbol engine, and this module cannot be loaded from SignalDeck (the
  stock update route through the bridge failed with V076, 2026-10-28).

Open on the SignalDeck side:
1. **M17 receive is partial** (71–89 of 100 frames exact on recordings, 83–90 frames per call on the phone).
   Self-calibration on real calls may lift it; it needs an M17 station other than the HackRF (the hotspot is not ours
   to use, and a hotspot-only result does not count).
2. **Stuck reception line:** recovery without a reboot is proven once (1 of 1); the trigger is known only as a replay
   (1 of 3). More repeats would make the recovery claim solid.
3. **S-meter frozen during receptions** (PR 110). By design: a reading every 2 s dropped the audio in 2 of 2
   receptions (2026-10-29), so any reading during the stream is too many.
4. **Fox hunt / coverage:** confirm a reading during a reception on the phone (through the PKT sheet), and run the
   dialogs once with GPS.
5. **Not yet exercised on this phone:** a DMR text sent from SignalDeck Web (it transmits; needs a TX slot); Android
   Auto in a real car (only the desktop head unit).
6. **Profile:** revision 2, verified with transmit (owner, 2026-10-28). Today's fixes are all in SignalDeck code, so
   no profile change is needed; a new beta would carry PRs 89–110 to users.

User setup, explained by the app: Agold App block off (SignalDeck opens the page once).
