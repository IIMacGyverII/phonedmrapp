# Back-check: German guide, part 3 (topics `messages`, `device`)

Method: each German section was read on its own and rendered back into English (condensed to its claims: every
fact, number, unit, condition and negation). That rendering was then compared with en.json. A mechanical pass also
compared, per section: the section ids and their order, the `{@name}` references, the → arrows, the line breaks, and
every number in the text (the English dates 2026-10-28 now appear as 28.10.2026, and decimal points are now decimal
commas). That pass found no differences.

## Strings checked

| Item | Count |
|---|---|
| Topic titles | 2 |
| Topic summaries | 2 |
| Section heads | 38 |
| Section texts | 38 (custom-ptt-key has 3 paragraphs) |
| **Total strings** | **80** |
| English words covered | 9,407 |

## Meaning changes found and fixed

| Section | Draft German | Problem in the back-translation | Fix |
|---|---|---|---|
| device / radio-firmware | „ist nur dann bloß eine Warnung, wenn die Firmware-Datei selbst übereinstimmt“ | Read back as "is a warning *only if* the file matches". That suggests it is something worse otherwise. The English says it is *merely* a warning when the file matches. | „ist bloß eine Warnung, sofern die Firmware-Datei selbst übereinstimmt“ |
| device / radio-firmware | „vollständig von Anfang bis Ende getestet“ | No change in meaning, but "fully, end to end" doubles the English "end to end". | „von Anfang bis Ende getestet“ |
| device / phone-profile | „die Details sagen, was abgeschaltet ist und warum“ | Read back as "what is switched off and why". The English says only "what and why", and an advisory could be about more than switching off. | „was betroffen ist und warum“ |
| device / anysecu-w6plus-dmr | „Beschneidung über 3 kHz“ | No change in meaning; the wording was unidiomatic. | „Beschnitt oberhalb von 3 kHz“ |

The other sections came back with the English meaning, and every negation, number and unit matched.

## Section by section

`messages`: title, summary, then threads, monitor, sending, delivery, receiving, names and contact-history. Each was
back-translated and matches the English. Specific checks:
- monitor: "about two and a half seconds", "about a second", "off until you turn it on" and "stays off across a
  restart" are all there.
- delivery: the ✓✓, ✓ and ✖ meanings are kept.

`device`: these sections were back-translated and match the English (beyond the fixes in the table):
- radio-link, from-a-browser, root-and-reboots, radio-settings;
- region, language, your-dmr-id, about-and-license, contribute, mission-statement, tools;
- about-this-radio, custom-roms, build-identity, report-summary, unihertz-atom-xl, anysecu-w6plus-dmr.

The other device sections are listed below under SAFETY.

## SAFETY-relevant sections: checked twice

Each of these was read a second time against the English, sentence by sentence. The second pass looked for any
softened or moved negation, and for any changed limit, number or condition.

| Section | Why it is safety text | Second pass |
|---|---|---|
| messages / sending | "nothing is sent" on analog channels | checked twice: „es wird nichts gesendet“ |
| device / radio-link | take over and hand back | checked twice |
| device / exit | Closing the app does **not** switch the radio off. Exit ends any transmission. | checked twice: the negation is in the first clause, „wird das Funkgerät nicht ausgeschaltet“ |
| device / root-and-reboots | taking the radio at boot | checked twice |
| device / radio-settings | Longest transmission, PTT keys | checked twice |
| device / dmr-roaming | never switches while you transmit | checked twice: "5 km", "30 %", "30 Sekunden", "zwei Minuten" and „nie … während du sendest“ |
| device / custom-ptt-key | Learning transmits nothing. Limit, receive-only and untested profile still apply. | checked twice: „während des Anlernens wird nichts gesendet“ and „auf einem Telefon mit ungetestetem Profil sendet sie nicht“ |
| device / from-a-browser | firmware loader and unlisted images stay on the phone | checked twice |
| device / phone-profile | advisories switch off transmit, take-over or the profile; the override asks twice | checked twice (wording fix above) |
| device / custom-roms | transmit audio path | checked twice |
| device / radio-firmware | firmware loading: pre-flight checks, Talk does nothing during a load, auto-restore, no warranty, only on certified phones | checked twice (two fixes above); "40"/"60 Prozent", "zwölf Sekunden", "zweimal" and „ersten acht Zeichen“ verified |
| device / help-support-this-phone | every step only listens | checked twice |
| device / run-all-checks | do not press PTT while the stock app runs; the trial transmits nothing | checked twice: „drücke in dieser Zeit nicht die PTT-Taste, die Hersteller-App würde senden“, „es wird nichts gesendet“, „es wird nichts getastet“ |
| device / radio-audio-check | nothing transmits | checked twice |
| device / device-report | reads only; the transmit test session is the only item that transmits; firmware files must not be shared | checked twice |
| device / when-the-radio-module-stops-answering | never restarts while transmitting | checked twice |
| device / second-radio-test | this phone only listens; licence-free example frequencies (US one marked „in den USA“) | checked twice: 446,00625 MHz, 462,5625 MHz, 100,0 Hz |
| device / transmit-test-session | when it may open, the safety sheet rules, the 28 s limit and Release now | checked twice: the „nie, solange …“ conditions, the rule list, 5/2/28/10/5/3 s and „fünf“ keys |
| device / build-identity | transmit switched on by overriding an advisory | checked twice |
| device / radios-that-do-less | refused schedules never transmit on another channel | checked twice: „so wird nie stattdessen auf einem anderen Kanal gesendet“ |
| device / unihertz-atom-xl | heat figures; hand back and firmware files in /sdcard/intercom/dmr | checked twice: 3 °C, 36 °C, 31 °C and 15 minutes |
| device / anysecu-w6plus-dmr | transmit verification, 28 s limit, offset, M17 cannot be sent | checked twice: 1,6 kHz, 300 Hz and 3 kHz |
| device / untested-profiles | no automatic take-over; transmit off until tested; the exceptions; key timing | checked twice: 2 s, 1,5 s, 0,6 s, „eine Fünftelsekunde“, „eine halbe Sekunde“ and „außerhalb der Sendetest-Sitzung tastet sie nichts“ |

**Safety sections checked twice: 23.** After the fixes listed above, none of them has an open problem.

No callsign, DMR ID or location appears in this file or in part3.json. The `<callsign>` and `<dmr id>` placeholders
are kept literally, as in the English.
