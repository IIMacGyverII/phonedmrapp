# Back-check: Italian guide, part A (guide-A)

File: `scratchpad/it-guide/partA.json`. 24 topics, 155 sections plus 24 titles, 24 summaries and 4 groups,
about 16,000 English words. Each section was translated back into English and compared with en.json for meaning,
negations, numbers and units. A script also compared the section ids, the `{@…}` references and every number in each
head and text with en.json: no differences (decimal commas counted as the same number; 2026-10-30 written 30/10/2026).

## Fixes made

| Topic / section | Problem in the draft | Fix |
|---|---|---|
| contacts / history | "ricevuto da lì" back-translates as "received from there", which is vague | "ricevuto da quel contatto" |
| fox-hunt / marks-and-the-estimate | "sei rivolto verso la volpe" is gendered (style §8) | "sei di fronte alla volpe" |
| fox-hunt / spin-for-the-bearing | "gira su te stesso" is gendered | "gira sul posto" (the UI title "Rilevamento girando su te stesso" stays as values-it has it) |
| fox-hunt / fox-signal | "ti sei spostato" is gendered | "non appena il GPS indica che sei a quella distanza dall’ultimo punto" |
| scheduled-operations / what-it-can-do | "ti sei connesso" is gendered | "l’ultimo gateway usato" |
| winlink-e-mail / trying-a-real-gateway | "un messaggio a te stesso" is gendered | "un breve messaggio al tuo indirizzo" |
| packet-radio / mode-pages, kiss-tnc | "TNC KISS" did not match the PKT button | "KISS TNC" (values-it) |
| packet-radio / aprs, two-way-igate, automatic-beacons | "Ascolta APRS" for the Monitor button; the button reads "Ascolta %1$s" | "Ascolta" |
| packet-radio / morse | The Italian label "Identificativo in CW dopo che parlo" has no place for `{@intercom_chhistory_kind_morse}` | The label is written out and the reference moved into the sentence: "aggiunge l’identificativo {@intercom_chhistory_kind_morse} alla fine…"; same meaning |
| about 40 labels | They did not match values-it (for example PRIORITÀ, IN ONDA, Aggiungi una zona, Smetti di seguire, Bip attivo, Più piano, Così, continua, Cancella picchi, Segnale della volpe, Mi sono identificato, TASTO, Liste di talkgroup, Svuota la cronologia di questo canale, Elimina la zona (mantieni i canali), Domande sbagliate, Aggiungi collegamento, Invia come testo DMR, Ruote qui, Scarica il log, SignalDeck Web → Band scope) | Changed to the values-it / web it.json text |

## Deliberate differences (meaning kept)
- pager / receiving: "(your callsign and a colon at the start)" is written "(un nominativo e due punti all’inizio)". It
  describes how any signed page looks; "your" would wrongly suggest the reader's own callsign.
- nets-near-you: "state" is written "stato USA", because Italian "stato" alone can also mean "status".
- channels / zones-and-standard-lists: "whether you may transmit is your responsibility" is written "spetta a te
  verificare se puoi trasmettere" (it is up to you to check whether you may transmit). That is at least as strong.
- vfo / band-plan: "is not allowed" is written "dove trasmettere non è consentito", so the negation names the act.

## Safety text checked twice (against the English, negation first)
- getting-started / talk-and-listen: transmit limit, 2 minutes, heat guard past 30 s.
- intercom / channel: talk key dimmed on NOAA, marine and railroad channels; receive-only.
- vfo / frequency-range and band-plan: refusal outside 136–174 / 400–480 MHz; where transmitting needs another
  licence or is not allowed.
- record-and-monitor / monitor: promiscuous receive not available on any firmware.
- packet-radio / aprs (auto-ack off by default; never on UHF-only radios; packet/DTMF/SSTV refused on DMR),
  iss (ISS SSTV receive only, transmitting blocked; ISS beacon only while the ISS is in view), dtmf-remote-control
  (PIN lock, PIN never logged, off by default), sstv (transmit limit, heat waits, does not start at 60 °C / 45 °C,
  ended early past 70 °C / 48 °C / +2 °C in 10 s), morse-trainer (nothing transmitted), morse (ID skipped near the
  transmit limit).
- m17 / talking-back: cannot talk back on stock firmware; transmit limit and heat guard.
- pager / sending: low power; stock firmware does not key.
- winlink-e-mail / what-it-is (licence needed), account-and-password (password never shown, logged, in a report or a
  backup).
- packet-finder / what-it-does: never transmits.
- band-scope / listen-and-stop: receive only.
- scheduled-operations / when-it-runs: schedules do not run after handing back to the stock app.
- fox-hunt / marks, spin, fox-signal: no marks while transmitting; be-the-fox: callsign in Morse on amateur channels.
- channels / zones-and-standard-lists (licences: GMRS US licence, Business licence; "not legal here"; transmitting is
  your responsibility), receive-only (Talk, side key and automatic transmissions refused).
- contacts / two-locations-kept-apart: home location never leaves the phone unless you send it.

No callsign, DMR ID or location of the owner appears in the part or in this file (the examples N0ABC, US-1234,
W0C/FR-001 and EM12ab are the English placeholders).
