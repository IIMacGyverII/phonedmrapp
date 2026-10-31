# Back-check: German guide, part 4

Source: `app/src/main/assets/guide/en.json` (SignalDeck-i18n worktree), topics region, signaldeck-web, map,
coverage-maps, android-auto, widget-and-notification, emergency-and-roger-beep, transmitting-legally.
Draft: `de-guide/part4.json`.

Method: each section's German was translated back into English without looking at the source, then compared with the
English for meaning, negations, numbers, units and conditions. I also ran a script check on every section: topic and
section ids, every `{@name}` reference, the number of → arrows, and the digits in each text. All matched. The only digit
difference is "8-character", which became "achtstellige".

## Counts
- Topics: 8. Sections: 64. Plus 8 titles and 8 summaries: 80 topic/section units in all.
- Words: about 6,400 English, 6,350 German (with punctuation that splits words, the counts compare roughly).
- Meaning problems found and fixed: 7 (table below).

## Changes made after the back-check

| Topic / section | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| signaldeck-web / safety | "After five wrong PINs the address concerned waits a minute" | "from one address" was only implied | "Nach fünf falschen PINs von derselben Adresse muss diese eine Minute warten." |
| coverage-maps / focus-and-details | "to show only this channel" | Too strong: "focus" picks that repeater; nothing says the others are hidden from the app | "um die Anzeige auf diesen Kanal zu beschränken" (closer to the sheet's one-repeater choice) |
| emergency-and-roger-beep / hold-to-send | "Whoever lets go earlier cancels" | Read as if a person cancels; "early" lost its sense of "too soon" | "Lässt du zu früh los, wird abgebrochen." |
| transmitting-legally / time-limit | "while the radio area has 60 °C" | "at 60 °C" means it has reached 60 °C | "60 °C … erreicht hat" |
| transmitting-legally / time-limit | "a voice key ends at 30 s, and long data does not start, while the phone is cooling …" | The "while" clause could be read as applying only to data, so a voice key would always end at 30 s | Sentence reordered: the conditions first ("Solange … abkühlt … oder solange …"), then both effects |
| signaldeck-web / what-it-shows | "training for the licence exam" | Glossary: licence = Zulassung, so "Lizenzprüfung" was off-glossary | "Amateurfunkprüfung" |
| signaldeck-web / turning-it-on | "stays logged in as long as it is used at least every 30 days" | "30 days of use" is ambiguous in English. I checked the code: `WebServer.SESSION_IDLE_MS` is a 30-day idle timeout, so the clearer German matches what the app does | Kept, and noted here |

## Section-by-section result (clean unless noted above)
- **region:** what-it-sets, how-it-was-chosen, choosing, what-changes-with-it, your-own-values, safe-by-design,
  how-accurate-it-is: clean. The GitHub issue title "Region data: <country>" stays in English on purpose, because the
  maintainers read the issues.
- **signaldeck-web:** turning-it-on (see table), what-it-shows (see table; every "needs Allow transmit from the web" is
  still there: SSTV send, parrot and fox, FT8 answer, CQ and send), decode-in-the-browser, sstv-pictures, phone-panel,
  transmitting, safety (see table), if-it-does-not-open: clean.
- **map:** open-it, what-is-on-it (15 to 120 miles kept in miles), moving-around, markers, coverage, map-tiles: clean.
- **coverage-maps:** what-it-does, turn-it-on, which-channels, heard-repeater-to-phone (50 m, 5 s, 25 m, 150 m,
  S3, S9+30), key-ups-phone-to-repeater (0.5 s, five reads in 2 s, 8 dB), driving-with-a-steady-signal (2 s, 5 s,
  60 mph, 55 m), noaa-weather (162,400 to 162,550 MHz), on-the-unihertz-atom-xl, while-scanning, key-up-test (3 s,
  20 wpm, 9990), reading-the-two-layers, live-while-you-watch (2 min, half a minute), focus-and-details (see table),
  terrain-prediction (50 miles twice, 10 to 350 m, 30 m, 50 W, 1000 W), how-it-is-calculated (ITU-R P.526),
  how-the-prediction-learns (50 W, 4 W, 12 dB, 10 to 30 m), in-the-browser, terrain-data (55 m), export-and-clear,
  good-habits (10 to 20 dB): clean.
- **android-auto:** in-the-car, choosing-a-channel, talk (2 min), radio-controls-big-talk-button, scan-pause,
  how-it-sounds, messages-read-aloud ("its reply is never sent" kept), coverage-while-you-drive, next-as-a-talk-key
  (0.5 s, 4 s, 1.5/2.5/4 s, 6 s), steering-wheel-talk, last-heard, if-android-auto-drops-while-you-talk (144,770 and
  146,370 MHz), if-the-radio-is-missing (ten taps, 30 s): clean.
- **widget-and-notification:** notification, home-screen-widget, talk-from-the-widget (2 min), when-the-radio-is-off:
  clean.
- **emergency-and-roger-beep:** emergency, hold-to-send (see table), pick-the-right-channel, roger-beep: clean.
- **transmitting-legally:** licences, time-limit (see table): clean after the fixes.

## SAFETY sections: checked twice
Each of these was read against the English a second time, after the fixes. I checked that the negation comes early,
that nothing is softened, and that every number, unit and condition is the same. The US text stays a statement about
the US ("GMRS erfordert in den USA eine Zulassung"). No German rules were added.

| Topic / section | What makes it safety text | Second pass |
|---|---|---|
| region / safe-by-design | never transmits; licence responsibility | checked twice |
| region / how-accurate-it-is | licence-free does not mean this phone is approved | checked twice |
| signaldeck-web / what-it-shows | the transmit features that need "Allow transmit from the web" | checked twice |
| signaldeck-web / transmitting | browser never transmits unless allowed; unkey rules; transmit limit; 1.5 s cut-off | checked twice |
| signaldeck-web / safety | network-only server, PIN lockout, passcode never sent | checked twice |
| coverage-maps / key-up-test | it transmits; asks first; use sparingly | checked twice |
| coverage-maps / good-habits | do not key a repeater just to test; identify | checked twice |
| android-auto / talk | transmit limit; receive-only channels refuse it | checked twice |
| android-auto / radio-controls-big-talk-button | TALK transmits | checked twice |
| android-auto / next-as-a-talk-key | stuck transmit when a release is lost; how to stop | checked twice |
| android-auto / steering-wheel-talk | wheel starts transmitting; transmit limit | checked twice |
| android-auto / if-android-auto-drops-while-you-talk | RF into the cable at high power | checked twice |
| widget-and-notification / talk-from-the-widget | tap-to-transmit; transmit limit; receive-only refusal | checked twice |
| emergency-and-roger-beep / emergency | what is sent where; the callsign needed | checked twice |
| emergency-and-roger-beep / hold-to-send | a stray tap never sends | checked twice |
| emergency-and-roger-beep / pick-the-right-channel | only for a real emergency | checked twice |
| emergency-and-roger-beep / roger-beep | a transmitted tone | checked twice |
| transmitting-legally / licences | licences; US-only GMRS; receive-only channels | checked twice |
| transmitting-legally / time-limit | transmit limit, No limit risk, heat guard thresholds | checked twice |

19 SAFETY sections, each checked twice.
