# Back-check: strings_web.xml (German)

Method: every German string was translated back into English without the source in view, then compared with the English source for meaning, negations, numbers, units and placeholders. Placeholders and escaping were also checked with `de_check.py` (0 problems, 0 untranslated).

**Strings checked:** 240 strings + 3 plurals (243 entries).

**Meaning changes found and fixed:** 2.

## Changes made after the back-check

| String | Problem found | Fix |
|---|---|---|
| `web_set_txlimit_sub` | Safety-related. The draft added „früher“ ("earlier"), which the English does not say | „früher“ removed |
| `web_ch_key_len` | „Der Schlüssel“ read back as just "the key"; lost that it is the encryption key | „Der Schlüssel für die Verschlüsselung“ |

No negation, number or unit differs from English in the final file.

## SAFETY strings

This file has no strings marked `SAFETY:`. These strings touch transmitting, the transmit limit, the heat guard, Restricted mode or receive-only channels, so they were given the safety second pass anyway:

| String | English | German | Check |
|---|---|---|---|
| `web_tx_off` | Transmit from the web is off (phone: Device → SignalDeck Web) | Senden über das Web ist aus (am Telefon: Gerät → SignalDeck Web) | checked twice |
| `web_restricted` | That is turned off in Restricted mode | Im Sperrmodus ist das ausgeschaltet | checked twice |
| `web_sat_receive_only` | Receive only during this satellite pass | Während dieses Satelliten-Überflugs nur Empfang | checked twice |
| `web_channel_receive_only` | This channel is receive-only | Dieser Kanal ist nur für den Empfang | checked twice |
| `web_not_while_tx` | Not while transmitting | Nicht während des Sendens | checked twice |
| `web_talk_busy` | Someone is already transmitting | Es sendet bereits jemand | checked twice |
| `web_firmware_busy` | Radio busy, loading firmware | Funkgerät belegt: Firmware wird geladen | checked twice |
| `web_confirm_first` | Confirm on the page first | Bestätige zuerst auf der Seite | checked twice |
| `web_set_txlimit_label` | Longest transmission | Längste Aussendung | checked twice |
| `web_set_txlimit_sub` | SignalDeck ends any transmission after this long; the heat guard still stops a long one if the phone gets hot | SignalDeck beendet jede Aussendung nach dieser Zeit; wird das Telefon heiß, stoppt der Überhitzungsschutz eine lange Aussendung trotzdem | checked twice |
| `web_set_txlimit_default` | %1$s (default) | %1$s (Standard) | checked twice |
| `web_set_txlimit_custom` | Custom: %1$s | Eigener Wert: %1$s | checked twice |
| `web_channel_untunable` | %1$s is outside %2$s: this radio cannot tune it | %1$s liegt außerhalb von %2$s: Dieses Funkgerät kann ihn nicht einstellen | checked twice |
| `web_scope_untunable` | Not a frequency this radio can tune | Diese Frequenz kann das Funkgerät nicht einstellen | checked twice |
| `web_ch_band` | Frequencies must be inside %1$s | Die Frequenzen müssen innerhalb von %1$s liegen | checked twice |
| `web_history_web_tx` | 🌐 Transmitting from the web (%1$s) | 🌐 Senden über das Web (%1$s) | checked twice |
| `web_history_talk_mic` | 🌐 Talking from the web with the browser microphone (%1$s) | 🌐 Sprechen über das Web mit dem Browser-Mikrofon (%1$s) | checked twice |
