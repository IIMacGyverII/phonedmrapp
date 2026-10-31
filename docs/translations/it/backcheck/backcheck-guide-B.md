# Back-check: Italian guide, part B

Part file: `scratchpad/it-guide/partB.json`. Topics: messages, device, region, signaldeck-web, map, coverage-maps,
android-auto, widget-and-notification, emergency-and-roger-beep, transmitting-legally. 10 topics, 102 sections,
about 15,700 English words. Every section was read back into English and compared with en.json. A script also
compared section ids, `{@…}` references, every number (multiset) and newline count per section: all match.

## Fixes made after the back-check

| Section | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| transmitting-legally / time-limit | "… long data does not start **until** the phone is still cooling down …" (*finché*) | *finché* reads as "until": the heat guard condition became unclear (SAFETY) | *mentre* ("while"), and the cooling clause now reads "until it is back within 1 °C of the earlier temperature, or for 17 minutes" |
| transmitting-legally / time-limit | "while the radio area is at 60 °C" | "at" could read as exactly 60 | "ha raggiunto i 60 °C / i 45 °C" (has reached) |
| coverage-maps / driving-with-a-steady-signal | "at 60 mph (about 100 km/h)" | an addition not in the English (adds a number) | removed |
| messages / monitor | "sending is set aside" | unclear what is hidden | "la parte di invio viene nascosta" (the sending part is hidden) |
| android-auto / choosing-a-channel | voice example left in English | an Italian user speaks Italian to the assistant | "Hey Google, riproduci NOAA WX6 su SignalDeck" (flagged: unchecked that Italian Assistant parses it) |
| several | UI names | matched to values-it / web it.json where written: Aggiungi una zona, Mostra tutti gli elenchi, Microfono per i comandi al volante, Interrompi quando smetto di parlare, Bitonale, K in CW, riga Parla, IN RICEZIONE / SILENZIO, Fai il backup ora, Rete mobile, Segnale ascoltato / Ponte raggiunto, Mostra tutto, layer Ascoltati | renamed in the text |

No meaning, negation, number or unit changes remain.

## Safety strings checked twice (draft and back-check)

- device: exit (closing does not switch the radio off), custom-ptt-key (nothing transmits while learning; refuses
  unsafe keys; untested profile does not transmit), radio-settings (Longest transmission), radio-firmware (whole
  section: pre-flight checks, nothing sent unless you submit, never uploads, attachment public, Allow unlisted images
  off until confirmed twice, own risk / no warranty, certified phones only, never on other phones),
  help-support-this-phone (every step only listens), run-all-checks (do not press PTT while the stock app runs;
  receive only; nothing keyed; nothing applied), radio-audio-check (nothing transmits, audio never kept),
  device-report (only reads; only the Transmit test session transmits; power on only with Probe + power pulse;
  files shared only privately, only if asked), when-the-radio-module-stops-answering (never while transmitting),
  second-radio-test (only listens), transmit-test-session (whole section: opens only when the profile may transmit,
  never with an advisory or Restricted mode, safety sheet rules, 28 s limit, Release now), radios-that-do-less (never
  sends on another channel), unihertz-atom-xl (temperatures), anysecu-w6plus-dmr (test cage, low power, M17 cannot be
  sent), untested-profiles (no automatic take-over; transmit off until tested; exceptions only in the guided
  session; 2 s / 1.5 s / 0.6 s timings).
- transmitting-legally: licences (you are responsible; GMRS licence "negli Stati Uniti"; receive-only channels, the
  app never transmits there) and time-limit (every sentence: limits, radio timer +2 s / 255 s, No limit means only
  you or SignalDeck end the key, own shorter limits, heat warning, heat guard 30 s / 1 °C / 17 min / 60 °C / 45 °C /
  70 °C / 48 °C / 2 °C in 10 s, locked in Restricted mode).
- Also: region safe-by-design and how-accurate (licence responsibility; licence-free needs approved equipment),
  signaldeck-web transmitting and safety (never transmits unless allowed; PIN; passcode never sent), widget and car
  Talk (transmit limit; receive-only refuses), emergency (hold two seconds; real emergencies only), coverage key-up
  test and good habits (asks before transmitting; do not key a repeater just to test it).
