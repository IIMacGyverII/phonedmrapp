# Back-check: strings_intercom.xml (de)

Method: every German string translated back to English without the source, then compared with the English for
meaning, negations, numbers and units.

**Strings checked:** 570 strings + 32 plurals (64 plural items).

## Changes made after the back-check

| String | Problem in the draft | Fix |
|---|---|---|
| intercom_emergency_hint | Comma split "deine Position, auf dem eingestellten Kanal" read back as two separate actions | Comma removed: "Sendet sofort deine Position auf dem eingestellten Kanal." |
| intercom_lastheard_ex_usbdrop_text | First draft word order read back as "a repeater transmitting on 144.770" (the repeater sending) instead of you sending to it | Reordered: "beim Senden mit hoher Leistung auf 144,770 MHz zu einem 2-m-Relais" |
| intercom_lastheard_ex_rxonly_text | Back-check of the draft showed the negation at the end ("…sendet das Funkgerät dort nicht") | Negation moved early: "Dort sendet das Funkgerät nicht, egal welche Taste gedrückt wird." |
| intercom_zones_repeater_tone_hint | GMRS is US-only; the German text could read as a general rule | Starts "In den USA brauchen die meisten GMRS-Relais …" (rule 7) |
| intercom_lastheard_ex_keyword_text | The menu item "Keywords" is rendered "Stichwort-Alarme…" in the TXT menu; "→ Stichwörter" would name a menu item that does not exist | Path written "lange auf TXT drücken → Stichwort-Alarme" |

No other string changed meaning; all numbers (30 s, 28,5 s, 15 min, 10 min, 5 min, 30 min, ±20 s, 32, frequencies)
and units match the English. Decimal points in prose frequencies were changed to commas (144,770 MHz, 12,5 kHz,
162,400 MHz …).

## SAFETY strings (checked twice)

- intercom_lastheard_ex_rxonly_title / _text (receive-only channels) – checked twice
- intercom_lastheard_ex_toolong_title / _text (30 s firmware transmit limit, 28,5 s) – checked twice
- intercom_lastheard_ex_busy_title / _text (transmit refused, channel busy) – checked twice
- intercom_lastheard_ex_notsent_title / _text (transmission refused, packet needs FM) – checked twice
- intercom_lastheard_ex_usbdrop_text (transmit power into USB, low power advice) – checked twice
- intercom_autotrust_usb_text_car / intercom_autotrust_usb_text / _short / _title / _title_car – checked twice
- intercom_widget_rx_only (receive-only channel) – checked twice
- intercom_zones_add_hint (licence line: listening always fine, transmitting not on every list) – checked twice
- intercom_zones_not_legal / intercom_zones_not_legal_hint / intercom_zones_partly_legal (legal text) – checked twice
- intercom_emergency_hint (real emergencies only) – checked twice
- intercom_emergency_hold_to_send / _send_again / _keep_holding / _hold_hint / _not_sent – checked twice
- intercom_main_classic_loading / intercom_main_neo_loading / intercom_mode_state_loading / intercom_car_firmware_loading / intercom_car_btn_loading (radio busy loading firmware) – checked twice
- intercom_main_tone_heard_message (tone set on TX and RX) – checked twice
