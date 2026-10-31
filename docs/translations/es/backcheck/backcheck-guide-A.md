# Back-check: guide part A (es)

Scope: 24 topics, 155 sections (about 15 900 English words, 17 600 Spanish). Every section was read back into English
and compared with the source for meaning, negations, numbers and units. Script check: section ids, `{@…}` references,
leading numbers in heads and every number in the text match en.json (two intended differences listed below).

## Fixes made

| Topic / section | Problem found | Fix |
|---|---|---|
| packet-radio / sstv | "about 17 minutes at most" read back as "17 minutes at most" (lost "about") | "unos 17 minutos como máximo" |
| channels / zones-and-standard-lists | GMRS "US licence needed" read back as "in the US it needs a licence" (weaker: a US licence specifically) | "requiere licencia de EE. UU." |
| record-and-monitor / monitor | "modo de monitorización" (Peninsular verb the style guide avoids) | "modo monitor" |
| winlink-e-mail / trying-a-real-gateway | "a ti mismo" agreed with the reader's gender | "Empieza enviándote un mensaje corto." |
| packet-radio / morse, id-timer | setting name rendered "… al hablar", Spanish strings say "… después de hablar" | aligned with `packet_set_morse_id` |
| several | UI names differing from values-es (Ajustes APRS, En curso, Quitar, Mostrar alertas…, Programaciones, Últimos escuchados for the contact field, Terminal) | aligned: Ajustes de APRS, En marcha ahora, Retirar, Ver alertas meteorológicas NOAA, Programación…, Última escucha, Terminal (BBS, nodo) |
| logbook, pota-and-sota, winlink-e-mail, band-scope, fox-hunt, packet-radio | second pass against strings_modes.xml once it appeared | Consulta / Consultar el indicativo, Agregar QSO, Anotar QSO, Entrada / Salida, Rango propio, Pitido: sí, Marca, Desplazar frec., Calcular ya, Así, sigue, Última llamada, Marcas auto, MANIP., Ya me identifiqué |

## Intended differences from the English
- live-captions / captions: one sentence added, "El reconocimiento es en inglés (el modelo es en-us)", as style.md §10
  asks the guide to say.
- packet-radio / automatic-beacons: "60 mph" followed by "unos 100 km/h".
- exam-practice: summary and pools say the pools are the US exam, in English (glossary §1, rule 7).
- channels / find-and-filter: the search example shows "462.6 o 462,6" (entry accepts both).

## Safety strings checked twice
- getting-started / talk-and-listen (transmit limit, heat guard past 30 s)
- intercom / channel (receive-only channels, talk key dimmed); intercom / talkgroup ("not while transmitting")
- vfo / frequency-range (refused frequencies, never sent); vfo / band-plan (caution where another licence is needed / not allowed)
- record-and-monitor / monitor (promiscuous receive not available)
- packet-radio / aprs (DMR channel refused), sstv (transmit limit, heat thresholds 60/45/70/48 °C, 2 °C in 10 s, wait rule),
  iss (ISS SSTV receive only, transmitting blocked), dtmf-remote-control (PIN, lock-out, never logged, off by default),
  morse (skipped within 3 s of the limit), voice-keyer and simplex-repeater-parrot (ID on amateur channels)
- m17 / talking-back (no transmit on stock firmware, transmit limit, heat guard)
- pager / sending (does not key on stock firmware), ft8-over-fm / what-it-is
- winlink-e-mail / what-it-is (licence needed), account-and-password (password never shown/logged/backed up)
- scheduled-operations / when-it-runs; band-scope / listen-and-stop (receive only)
- fox-hunt / marks (refused while transmitting), be-the-fox (callsign in Morse)
- channels / zones-and-standard-lists ("not legal here", transmitting is your responsibility, licence notes for GMRS
  and Business, receive-only lists), channels / receive-only (every transmission refused)

All read back with the negation and the numbers intact after the fixes above.
