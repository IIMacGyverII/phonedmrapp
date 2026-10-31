# Back-check: pt-BR guide, part A

Part file: `pt-BR-guide/partA.json`. That is 24 topics and 155 sections, about 16,000 English words.
Each pt-BR section was read back into English and compared with en.json for meaning, negation, numbers and units. A script also compared ids, `{@…}` references, numbered heads and every number in each head and text (decimal comma treated as equal to the dot, − as equal to -).

## Fixes made
| Topic / section | Problem in the draft | Fix |
|---|---|---|
| vfo / frequency-range | "qualquer outra frequência … é recusada e fica onde estava": that says the *frequency* stays where it was. The English means the *radio* refuses it and stays where it was. | "o rádio recusa qualquer outra frequência (220 MHz inclusive) e continua onde estava, por isso o app nunca a envia." |
| getting-started / take-over-the-radio | "tomada do rádio" reads as "radio power socket" in Brazil | "Se a operação de assumir falhar no meio do caminho" |
| intercom / channel | "tecla … fica apagada" means switched off; the English says dimmed | "fica esmaecida" |
| logbook, pota-and-sota | "reportagens" means news reports | "reportes" (signal reports) |
| pager / open-it | "A numeric-only pager … is not sent yet" came out as "não é atendido" (is not served) | "Ainda não é possível enviar para um pager só numérico (função 0)." |
| winlink / connect-internet | "a signal" was rendered as mobile signal only | "sinal de internet" |
| packet-radio / mode-pages | The cross-reference "M17 receive" named a topic that is not there | "veja os tópicos FT8 em FM e M17" |
| contacts, winlink | "você mesmo" is gendered (style §1) | Reworded without the gender |
| record-and-monitor / monitor | "modo de monitoração" (the glossary avoids "monitoramento" wording) | "modo monitor" |

Numbers: the only difference is one number I added on purpose: "60 mph, uns 100 km/h" in packet-radio / automatic-beacons.

## Safety text read twice against the English
- getting-started / talk-and-listen: the transmit limit, 2 min, and the heat guard after 30 s.
- vfo / frequency-range: the tuning range and the refusal (fixed, see above).
- vfo / band-plan: transmitting needs another licence, is not allowed, or would disturb a special use.
- record-and-monitor / monitor: promiscuous receive is not available.
- packet-radio / aprs: Packet, DTMF and SSTV are refused on DMR channels. No auto-ack on UHF-only radios.
- packet-radio / dtmf-remote-control: the PIN, the lockout (3 wrong PINs, 10 min), the PIN never logged, and the default (off).
- packet-radio / sstv: the transmit limit, the long-mode refusal, and the heat limits (60/45 °C to start; 70/48 °C and +2 °C/10 s to stop; wait to within 1 °C, up to 17 min).
- packet-radio / iss: ISS SSTV is receive only, transmit blocked. The beacon goes only while the ISS is in view.
- packet-radio / id-timer and morse: the ID interval, and Morse ID skipped within 3 s of the transmit limit.
- packet-radio / morse-trainer: nothing is transmitted.
- m17 / talking-back: you cannot transmit on stock firmware. The transmit limit and the heat guard.
- pager / sending: it does not key on stock firmware, and it sends at low power.
- winlink-e-mail / what-it-is and account-and-password: a licence is needed. The password is never shown, logged or backed up.
- channels / receive-only: Talk, the side key and every automatic transmission are refused.
- channels / zones-and-standard-lists: "não permitido aqui"; whether you may transmit is your responsibility. GMRS and Business need a licence (US).
- fox-hunt / marks, spin, fox-signal: marks are refused while you transmit.
- band-scope / listen-and-stop: receive only.
- scheduled-operations / when-it-runs: no runs after handing the radio back. A satellite pass comes first.
- packet-finder / what-it-does: it never transmits.

All of these are clean after the fixes above.
