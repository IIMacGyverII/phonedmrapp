# Back-check: strings_packet.xml (de)

Every German string was translated back into English and compared with the English source for meaning, negations,
numbers and units.

**Strings checked:** 748 strings + 11 plurals (22 plural items) = 770 texts.
**Meaning changes found and fixed:** 9 (table below). No negation, number or unit was lost or changed in the final file.

## Changes made after the back-check

| String | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| `packet_pkt_is_hint` | "Forwards what the radio hears, to the internet" | Clumsy word order, reads like a literal rendering | Rebuilt: „Leitet das, was das Funkgerät hört, ins Internet weiter …“ |
| `packet_pkt_obj_hint` | "a control-centre point of a net" | "net control point" became an odd term | „der Standort der Rundenleitung“ (glossary: Rundenleitung) |
| `packet_set_lead_hint` | "while the radio's transmit tone settles … silence is an empty carrier" | "transmit audio" is not a tone; "dead air" is an unmodulated carrier | „Sende-Audio … einschwingt“, „Stille ist unmodulierter Träger“ |
| `packet_cov_ant_hint` | "the antenna-mast register lists mast heights" | Implied one specific register | „Mastregister nennen die Masthöhen“ |
| `packet_cov_range_hint` | "up to 50 miles" | Unit unfamiliar to German readers | Kept 50 Meilen, added „(etwa 80 km)“; number unchanged |
| `packet_pkt_auto_away` | "…and this frequency this radio cannot tune" | Double "this", wordy | „…das dieses Funkgerät nicht einstellen kann“ |
| `packet_map_help_1/2/3` | "the APRS pill", "the pills", "the keys on the right" | "Pille" is not German UI language; the round controls are buttons | „Filter“, „Schaltflächen“ |
| `packet_cov_intro_1` | "Drive or run around normally" | „lauf herum“ reads as aimless running | „Sei einfach wie gewohnt zu Fuß oder mit dem Auto unterwegs“ |
| `packet_same_eww` | "Hurricane-force wind warning" (Orkanwarnung) | Narrower than "Extreme Wind Warning" | „Warnung vor extremem Wind“ |

Also adjusted for the screen (not meaning): labels whose English is written in capitals (PACKETS, NEW, ON/OFF, EARLIER)
are written in capitals in German too, in case the view does not upper-case them.

## Accepted shortenings (meaning kept, noted for the reviewer)
- `packet_aprs_stat_last` "LAST HEARD" → „ZULETZT“ (four counters share a row; „Zuletzt gehört“ will not fit).
- `packet_pkt_dtmflog_row` "ch" → „K.“ (Kanal).
- `packet_same_duration` "1h30" → „1:30 h“ (German time notation, same placeholders).

## Safety and transmit strings (no `SAFETY:` comments in this file; these touch transmitting, limits, PINs or receive-only)
Each read a second time against the English: **checked twice**, back-translation clean.

- `packet_sstv_err_too_long` (transmit limit, Gerät → Längste Aussendung): checked twice
- `packet_sstv_event_held` (picture not sent, cool-down guard): checked twice
- `packet_pkt_sstv_hint` (30 s transmit limit): checked twice
- `packet_cov_test_title` (transmit a key-up test?): checked twice
- `packet_cov_test_msg` ("Only test a repeater you are allowed to use" → „Teste nur Relais, die du nutzen darfst“): checked twice
- `packet_cov_test_hint` (legal identification, use sparingly): checked twice
- `packet_pkt_m17_hint` (receive only: cannot transmit M17): checked twice
- `packet_pfd_hint`, `packet_pkt_finder_hint` (only listens, never transmits): checked twice
- `packet_finder_err_tx` (not while transmitting): checked twice
- `packet_event_not_sent_analog`, `packet_event_not_sent_dmr`, `packet_weather_not_sent`: checked twice
- `packet_pkt_remote_pin`, `packet_pkt_remote_intro`, `packet_pkt_remote_outro`, `packet_pkt_remote_err_pin` (DTMF remote PIN, lock-out): checked twice
- `packet_set_is_passcode` (passcode never shown or logged): checked twice
- `packet_pkt_parrot_hint` (repeats transmissions, Morse ID every ten minutes): checked twice
- `packet_pkt_id_within`, `packet_pkt_id_due`, `packet_pkt_morse_id_on`, `packet_pkt_morse_id_off`, `packet_set_morse_id` (station identification): checked twice
- `packet_set_autoack_off` (no 2 m band, no automatic acks): checked twice
- `packet_set_power_hint` (which power applies where): checked twice
