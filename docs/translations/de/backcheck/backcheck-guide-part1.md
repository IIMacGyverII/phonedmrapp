# Back-check: German guide, part 1

Scope: groups (4) and topics getting-started, intercom, scanning-and-zones, soft-sq, live-captions, vfo,
record-and-monitor, packet-radio, logbook, pota-and-sota, exam-practice, nets-near-you, message-forms, packet-finder.

Method: each German section was read back into English without the source, then compared with en.json for meaning,
negations, numbers, units and conditions. A script also checked that ids match en.json, that every `{@name}` reference
and every `→` survives unchanged, and that the digits in each text match the English (decimal point → comma).

## Counts
- Strings checked: 4 group names + 14 titles + 14 summaries + 86 section heads + 86 section texts = **204**.
- Meaning changes found and fixed: **4** (table below). Remaining deliberate deviations: 2 (listed under "Kept on purpose").
- Script checks: 0 missing/extra `{@…}` references, 0 arrow mismatches, 0 number mismatches (one multiplicity
  difference in intercom/signal: "above S9" rendered as "darüber", same meaning).

## Changes made after the back-check

| Section | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| intercom / activity-panel | "the bars … fall back into rest" | "silence" weakened to an idle state | "fallen auf Stille zurück" |
| packet-radio / aprs | "act as a gap-filler digipeater" | understandable, but not the term German hams use for fill-in digis | "Fill-in-Digipeater" |
| packet-radio / vhf-uhf-conditions | "cyan slightly raised" | "enhanced" means better conditions, not a raised value | "leicht verbessert" |
| nets-near-you / elsewhere-on-the-air (head) | "Elsewhere in the air" | idiomatically odd (sounds like aviation) | "Anderswo aktiv" |

## Kept on purpose (not meaning changes)
- exam-practice summary: back-translates as "Practice for the amateur licence exams of the USA". The English has no
  "US"; the glossary requires the topic to be labelled as the US exam (title "US-Prüfung (englisch)") and brief rule 7
  forbids implying it applies in Germany. Flagged for the owner.
- activity-panel "within 20 seconds of it": rendered as "bis zu 20 Sekunden davor oder danach", which makes the
  two-sided window explicit; same meaning.

## Section by section

| Topic / section | Result |
|---|---|
| getting-started / take-over-the-radio | OK: cannot share; paused + icon hidden until Hand back; Magisk root; failure → stock app back on, never without a radio app. |
| getting-started / pick-a-channel | OK: first time and on empty list; Start empty remembered. |
| getting-started / talk-and-listen | OK: amber/green/red; ends at transmit limit, 2 min default; heat guard past 30 s; path → Legal senden. |
| getting-started / the-launch-screen | OK: ~2.5 s, skip on tap, never on return, only after close. |
| getting-started / hear-more | OK. |
| intercom / channel | OK: talk key dimmed, receive-only. |
| intercom / talkgroup | OK: long-press only, tap does nothing; temporary RX list; RUF · GEWÄHLT; lasts until channel/scan/VFO; not while transmitting. |
| intercom / talk-key | OK. |
| intercom / activity-panel | Fixed (see above); 7 days, 200 Hz–3,6 kHz, 20 s. |
| intercom / activity-statistics | OK: today / 7 / 30 days; twelve busiest; zone Meiste Aktivität. |
| intercom / tone-offer | OK. |
| intercom / signal | OK: S1–S9 cyan, +20/+40, KEIN SIGNAL, noise floor. |
| intercom / two-looks | OK. |
| intercom / small-screens | OK: < 700 dp, 480 × 854, 132 dp, 66 × 44 dp; Automatic/Regular/Compact. |
| intercom / music-calls-and-the-car | OK: 2,5 s; navigation prompt; navigation volume. |
| scanning-and-zones / scan | OK: 1,5 s / 2,5 s (Xplore 1); 2,5 s after activity. |
| scanning-and-zones / skip-a-channel | OK. |
| scanning-and-zones / priority-channel | OK: after every three; every 10 s while held. |
| scanning-and-zones / soft-sq-while-scanning | OK: default 5, 1 lenient – 9 strict; per step; CTCSS opens on tone; switch-off path. |
| scanning-and-zones / zones | OK: first-time rule, left alone while talking/scanning/VFO. |
| soft-sq / what-it-does | OK. |
| soft-sq / the-slider | OK: 1–9, default 5, green open / amber closed; hidden when off and on DMR/M17. |
| soft-sq / switching-channels | OK: "under a second". |
| soft-sq / per-channel | OK. |
| live-captions / captions | OK: downloads once, survives updates, only uninstall removes. |
| live-captions / options | OK. |
| live-captions / in-the-browser | OK: key saved write-only. |
| live-captions / keyword-alerts | OK. |
| vfo / tuning | OK. |
| vfo / frequency-range | OK: 136–174 and 400–480 MHz only; 220 MHz refused; never sent; radio refusal → history, display reverts. |
| vfo / while-vfo-is-on | OK. |
| vfo / band-plan | OK: US plan stays US; amber caution where another licence / not allowed / would disturb. |
| record-and-monitor / record | OK. |
| record-and-monitor / monitor | OK: promiscuous receive not available yet; no firmware proven; MON off on channel change. |
| packet-radio / mode-pages | OK: 8 steps; 144,500; several modes at once. |
| packet-radio / aprs | Fixed (see above). 144,390 / 144,800 MHz; auto-ack off by default and never on UHF-only; six characters; 1200 Bd, 1,6 s, packet twice; refused on DMR; High default; 1,6 s lead-in default. |
| packet-radio / aprs-is | OK: without passcode receive only. |
| packet-radio / two-way-igate | OK: 30 min, once, WIDE1-1, needs passcode + Monitor. |
| packet-radio / automatic-beacons | OK: 30 min parked, 3 min above 60 mph; only on APRS frequency and no TNC client. |
| packet-radio / telemetry-and-weather | OK: first and every tenth; every 30 min. |
| packet-radio / objects-and-bulletins | OK: BLN0–BLN9. |
| packet-radio / text-and-email-gateways | OK: US/Canada; 67 characters in all. |
| packet-radio / message-groups | OK: without an acknowledgement. |
| packet-radio / satellite-passes | OK: 24 h, 10°, two days, 10 kHz, 2 kHz, never while talking, 74,4 Hz for two seconds. |
| packet-radio / is-it-working | OK: 4 days; nothing about you is sent. |
| packet-radio / vhf-uhf-conditions | Fixed (see above). 48 h, 50 km, Kp 5, 800–2000 km, 20°. |
| packet-radio / iss | OK: 437,825 / 437,550; 10 kHz; 10°; a minute before; 15 min, older than a day; 1 MB/min; only while in view; SSTV receive only, transmitting blocked; 5 kHz. |
| packet-radio / kiss-tnc | OK: 127.0.0.1:8001 (address, not a decimal), 1,6 s. |
| packet-radio / dtmf | OK. |
| packet-radio / dtmf-remote-control | OK: PIN 4–6 digits; commands 1–6; 1,5 s; three wrong PINs in ten minutes lock for ten minutes; PIN never logged; off by default. |
| packet-radio / weather-alerts | OK: 162,400–162,550 MHz; decoder still runs. |
| packet-radio / sstv | OK: 115 s; 2 min default; refused beyond limit; 120 s → ~11 °C; within 1 °C; ≤ ~17 min; not start at 60 °C radio / 45 °C battery; every five seconds; ended early past 70 °C / 48 °C / 2 °C in ten seconds; below the phone's own throttling; bench stricter; 16 lines. |
| packet-radio / decode-a-recording | OK: nothing sent, digipeated or gated; saved once. |
| packet-radio / rtty-and-psk31 | OK: 45,45 Bd, 170 Hz, 2125 Hz, 1000 Hz, ~26 s, FW22 or later. |
| packet-radio / packet-terminal | OK: two digipeaters, six tries 15 s apart, needs callsign. |
| packet-radio / simplex-repeater-parrot | OK: 1 s, 26 s, ID at most once per interval (ten minutes or region's); squelch must close (level above 0 or Soft SQ). |
| packet-radio / morse-trainer | OK: nothing transmitted; 5 × 5; 90 %; 5–35 WPM, 20. |
| packet-radio / voice-keyer | OK: 25 s; 1,5 s lead; Morse ID only when ID on and amateur channel. |
| packet-radio / id-timer | OK: ten minutes in the US, five in the Netherlands (examples, stays country-specific). |
| packet-radio / morse | OK: 5–40 WPM; eight characters; 2 s pause; at most every ten minutes; 2 m / 1,25 m / 70 cm; skipped within 3 s of the limit; FW22; no 1,5 s lead. |
| packet-radio / the-pkt-key | OK. |
| logbook / opening-it | OK. |
| logbook / stations-heard | OK: one entry per station and mode per hour. |
| logbook / contacts | OK: 59. |
| logbook / callsign-lookup-and-grid-squares | OK: only callsign sent, 30 days, four-character squares, contacts only. |
| logbook / adif | OK: ADIF 3.1 (version number, dot kept); SWL not counted. |
| pota-and-sota / open-it | OK. |
| pota-and-sota / activate | OK: 60 km, half a degree, 59, same UTC day + band duplicate, POTA 10 / SOTA 4. |
| pota-and-sota / upload-the-log | OK: file-name placeholders rendered in German (<dein Rufzeichen> etc.); field names unchanged. |
| pota-and-sota / hunt | OK: FM on 2 m / 70 cm first; HF shown dimmed. |
| exam-practice / the-pools | OK: 409 / 423 / 599, element numbers and years; public domain; offline. |
| exam-practice / practice-exam | OK: 35 (26), 50 (37); no feedback until the end. |
| exam-practice / study-and-review | OK. |
| nets-near-you / opening-it | OK: every minute. |
| nets-near-you / on-the-air-near-you | OK: callsign, name, state only; 20 minutes, a dozen transmissions; receive-only left out; caption phrase kept in English (it matches English speech). |
| nets-near-you / coming-up | OK: last week; four or more days; two weeks running / three days in a row. |
| nets-near-you / adding-a-net | OK. |
| nets-near-you / near-you-or-not | OK: state stays on the phone. |
| nets-near-you / reminders | OK: 10 min before; every 5 min; off until turned on; at most once a minute. |
| nets-near-you / elsewhere-on-the-air | Head fixed (see above); text OK. |
| message-forms / open-it | OK. |
| message-forms / send-or-read | OK: 67 characters, one every 12 s, analog channel + callsign required; 120-character DMR texts. |
| message-forms / receive | OK: any order. |
| packet-finder / what-it-does | OK: only listens, never transmits. |
| packet-finder / how-long | OK: 10–30 min; stops on transmit / channel change / tracked pass; 144,910–145,090 MHz. |
| packet-finder / using-a-station | OK. |

Titles, summaries and group names: all back-translate to the English meaning, except the exam-practice title and
summary (US label, kept on purpose, see above).

## SAFETY-relevant sections, checked twice
Transmitting, transmit limits, heat, licences, receive-only, PIN lock. Each was read a second time against the English
for negations (placed early), numbers and strength; none was softened.

- getting-started / take-over-the-radio: checked twice
- getting-started / talk-and-listen: checked twice
- intercom / channel: checked twice
- intercom / talkgroup: checked twice
- intercom / activity-panel: checked twice
- vfo / frequency-range: checked twice
- vfo / band-plan: checked twice
- packet-radio / aprs: checked twice
- packet-radio / two-way-igate: checked twice
- packet-radio / automatic-beacons: checked twice
- packet-radio / satellite-passes: checked twice
- packet-radio / iss: checked twice
- packet-radio / kiss-tnc: checked twice
- packet-radio / dtmf-remote-control: checked twice
- packet-radio / sstv: checked twice
- packet-radio / decode-a-recording: checked twice
- packet-radio / rtty-and-psk31: checked twice
- packet-radio / packet-terminal: checked twice
- packet-radio / simplex-repeater-parrot: checked twice
- packet-radio / morse-trainer: checked twice
- packet-radio / voice-keyer: checked twice
- packet-radio / id-timer: checked twice
- packet-radio / morse: checked twice
- message-forms / send-or-read: checked twice
- packet-finder / what-it-does: checked twice
- packet-finder / how-long: checked twice

All 26 back-checked clean on the second pass.
