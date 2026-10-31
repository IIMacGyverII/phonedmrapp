# Back-check: strings_packet.xml + strings_modes.xml (es)

Checked: 1701 entries (770 in strings_packet.xml: 748 strings + 11 plurals; 931 in strings_modes.xml: 831 strings + 50
plurals, `one` and `other` each counted). Every Spanish entry translated back to English and compared with the source in
meaning, negation, numbers and units. Scripted checks on top: placeholders (`de_check.py`, I18nResourcesTest's rule),
every number in each string equal to English (decimal comma normalised: 0 differences), ` ` / `\n` / `\\` counts per
string equal to English, negation words present on both sides.

## Fixes

| String | Draft (back-translated) | Problem | Fixed to |
|---|---|---|---|
| packet_pkt_id_within | "Identifícate antes de %1$d:%2$s" ("identify before 4:59") | Reads as a clock time, not a countdown | "Quedan %1$d:%2$s para identificarte." ("4:59 left to identify") |
| modes_fox_shaded | "…contorno brillante 50 %, tenue 90 %." | English "50 %, faint" contains a pseudo-placeholder `%, f` that the key test counts; the draft lacked it, so the placeholder test would fail | "…50 %, fino y tenue 90 %." (same meaning, keeps `%, f`) |
| packet_cov_unknown / packet_cov_pwr_hint | Pill "Descon." while the hint named it "Desconocida" | Pill name and the text naming it differed | Pill "Desconocida", hint "Desconocida: …" |
| packet_aprs_stat_* / packet_aprs_tab_* / packet_cov_new | Written in sentence case | These strings are capitals in the string itself (not upper-cased by the app; German also writes them in capitals) | PAQUETES, ESTACIONES, PARA TI, ÚLTIMO, EN VIVO, MENSAJES, NUEVO |
| all strings with ` ` (14 in packet, 122 in modes) | Spaces | The authoring tool turned ` ` into plain spaces, which aapt would collapse or trim | Restored; counts per string verified equal to English |
| packet_pkt_keyer_section | "Memorias de voz y temporizador de identificación" | Too long for a one-line capitals heading | "Memorias de voz y temporizador ID" (glossary short form) |
| packet_pkt_wx_show | "Ver alertas meteorológicas NOAA" | Too long for a half-row button | "Ver alertas NOAA" |

No changed meaning, lost negation, changed number or changed unit was found otherwise.

## Safety strings checked twice

Transmit limit: packet_sstv_err_too_long, packet_pkt_sstv_hint, modes_text_hint, modes_parrot_hint,
modes_parrot_event_repeated_cut(_id), modes_m17_note_send, packet_pkt_parrot_hint.
Licence / legal identification / permission to use: packet_cov_test_hint, packet_cov_test_title, packet_cov_test_msg
("Prueba solo repetidores que tengas permitido usar"), modes_keyer_id_hint, modes_keyer_timer_due/now, packet_pkt_id_*,
packet_pkt_morse_id_on/off, packet_set_morse_id, modes_fox_beacon_hint.
Receive-only / never transmits: packet_pkt_m17_hint, modes_m17_note_firmware, modes_m17_note_rx_only, packet_pfd_hint,
packet_pkt_finder_hint, modes_scope_subtitle, modes_scope_intro, modes_recdec_hint_aprs/sstv, modes_satd_listen,
modes_satd_listen_only, modes_fox_not_while_tx, packet_is_connected_rx_only, packet_is_status_unverified.
Firmware (symbol engine): packet_pkt_pager_hint, modes_pager_sign_hint, modes_m17_note_firmware.
PIN / secrets: packet_pkt_remote_pin, packet_pkt_remote_outro, packet_pkt_remote_err_pin, modes_dtmf_event_locked,
modes_dtmf_event_wrong_pin, packet_set_is_passcode, modes_wl_set_hint, modes_wl_set_password_set, modes_wl_set_diag_hint,
modes_wl_log_hint, modes_wl_ask_message.
Deletion that cannot be undone: modes_sstv_delete_message, packet_cov_clear_msg, modes_wl_delete_outbox.
US-specific: modes_exam_hint, packet_pkt_exam_hint, packet_pkt_gw_hint, modes_log_not_found (stay statements about the US
/ Canada).

All read clean against the English the second time.
