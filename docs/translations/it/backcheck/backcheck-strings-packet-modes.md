# Back-check: strings-packet-modes (it)

Files: `values-it/strings_packet.xml` (748 strings + 11 plurals) and `values-it/strings_modes.xml` (831 strings + 50
plurals). Every entry was translated back into English without the source and compared for meaning, negation, numbers
and units. de_check: strings_packet 0 problems, 0 untranslated; strings_modes 0 untranslated, 1 known false positive
(modes_fox_shaded, "50 %, f…" kept). ` ` and `
` counts per string match English (one deliberate exception in
modes_morse_result, see below).

## strings_packet.xml

Checked: 770 entries (748 strings + 11 plurals with one/other).

| String | Draft | Back-translation / problem | Fixed to |
|---|---|---|---|
| packet_sstv_event_held | "%1$s non inviata" | agreed with "immagine", but %1$s is the mode name | "non inviato" |
| packet_msg_scan_body | "si ferma finché sente un preambolo" | "stops while a preamble is heard" (reads as stopping) | "resta lì finché sente un preambolo" |
| packet_cov_pred_tx_cal | "%1$d prove (%2$d hanno aperto il ponte)" | "tests" vs key-ups; clumsy | "%1$d tentativi di apertura (%2$d riusciti)" |
| packet_pkt_passive_* (4) | "Quando lo interrompi torni…" | "lo" could point at the decode, not the monitoring | "Quando interrompi, torni al tuo canale." |
| packet_set_lead_hint | "Prova al banco" | glossary uses "laboratorio" for bench | "Prova in laboratorio" |
| packet_kiss_running, packet_aprs_sub_kiss_* | "TNC KISS" | comment: keep the name KISS TNC; inconsistent with buttons | "KISS TNC" |
| packet_morse_heard*, packet_aprs_earlier_nothing, packet_aprs_for_you, packet_map_cell_pred_*_none, packet_msg_chip_page, packet_pkt_blnheard_row, packet_pkt_sstv_mode_long, packet_pkt_station_dist, packet_pkt_log_for_you, packet_pkt_dtmflog_row, packet_sentence_sep, packet_list_sep | ` ` lost on write | escape lost (Android would trim) | restored via @@SP@@ in the generator |

Plurals where English uses the plural text for one ("%1$d repeaters…", "%1$d measured squares…", iGate messages,
characters left / too long) got a proper Italian singular in `one`.

Safety strings checked twice: packet_sstv_err_too_long (transmit limit, Device → Longest transmission),
packet_pkt_sstv_hint (30 s transmit limit), packet_cov_test_hint, packet_cov_test_title, packet_cov_test_msg ("Only
test a repeater you are allowed to use"), packet_pkt_m17_hint (receive only, cannot transmit M17), packet_pfd_hint
(never transmits), packet_pkt_finder_hint (receive only), packet_pkt_parrot_hint (callsign in Morse every ten minutes,
26 s), packet_pkt_remote_pin / _intro / _outro / _err_pin (PIN lock, never in history), packet_set_is_passcode (never
shown or logged), packet_is_status_unverified / packet_is_connected_rx_only (receive-only), packet_pkt_morse_id_on /
_off, packet_pkt_id_*, packet_set_morse_id, packet_pkt_fox_hint_tx, packet_pkt_pager_hint (firmware), packet_set_power_*,
packet_event_not_sent_* and packet_err_analog* (not sent). All clean.

## strings_modes.xml

Checked: 881 entries (831 strings + 50 plurals; one/other each), every one translated back into English and compared
with the source. Placeholders, `\u0020` and `\n` counts per string match English (de_check: 0 problems apart from
the known modes_fox_shaded false positive, 0 untranslated).

## Fixes from the back-check

| String | Draft | Back-translation / problem | Fixed to |
|---|---|---|---|
| modes_recdec_hint_aprs | "digipetuto o inoltrato in gate" | not real Italian words | "ripetuto via digipeater o inoltrato via iGate" |
| modes_recdec_hint_sstv | "in un evanescenza" | grammar (feminine noun) | "in un’evanescenza" |
| modes_text_input_hint | "Scrivi da inviare" | "Write to send" read as broken | "Testo da inviare" |
| modes_winlink_state_calling | "Chiamata di %1$s…" | read as "call from X" (wrong direction) | "Chiamata a %1$s…" |
| modes_ft8_status_line(_grid) | "trasmetti a %2$s Hz" | read as an instruction, not a status | "trasmissione a %2$s Hz" |
| modes_pota_their_ref | "il suo %1$s %2$s" | "his POTA US-1234": unclear | "suo riferimento %1$s %2$s" |
| modes_wl_set_hint | "mai mostrata, registrata nei log, inserita…" | "never" might read as only covering "shown" | "non viene mai mostrata, scritta nei log, né inserita in un rapporto dispositivo o in un backup" |
| modes_fox_auto_off | "Punti automatici no" | missing separator | "Punti automatici: no" |
| 5 separator/contact strings in the first two map files | `\u0020` lost on write | escape lost | restored (@@SP@@) |

Intentional differences: modes_morse_result uses "inviato:" / "copiato:" (both 8 characters) so the
monospaced lines line up with one `\u0020` each instead of English's 1 and 2. Percent written "50%" (style §5),
except modes_fox_shaded, which keeps "50 %, fioco" because of the placeholder-check rule.

## Safety strings checked twice
modes_parrot_hint (30 s transmit limit), modes_parrot_event_repeated_cut(_id) (26 s limit), modes_text_hint
(30 s stop), modes_m17_note_send (transmit limit, Device → Longest transmission), modes_m17_note_firmware,
modes_m17_note_rx_only, modes_fox_not_while_tx, modes_fox_beacon_hint, modes_fox_beacon_start/stop,
modes_keyer_hint, modes_keyer_id_hint (identification rule), modes_scope_subtitle and modes_scope_intro (receive
only), modes_satd_listen (receive only), modes_satd_listen_only, modes_satd_not_tunable, modes_satd_iss_invalid,
modes_pager_freq_hint (low power), modes_pager_sign_hint (firmware), modes_morse_hint (not on the air),
modes_recdec_hint_sstv/aprs (never uses the radio, nothing sent), modes_exam_hint (US licence exam stays US),
modes_wl_set_hint, modes_wl_set_diag_hint, modes_wl_log_hint, modes_wl_ask_message (password never logged),
modes_wl_delete_outbox, modes_sstv_delete_message ("Non si può annullare"), modes_dtmf_event_locked /
wrong_pin, modes_forms_aprs_message (analog channel). All clean after the fixes above.
