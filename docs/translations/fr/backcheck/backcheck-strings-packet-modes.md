# Back-check: strings-packet-modes (fr)

## Back-check: strings_packet.xml (fr)

Checked: 759 entries (all strings and plurals; 6,200 French words). Each French string was read back into English
without the source, then compared for meaning, negation, numbers and units.

### Fixes

| String | Problem in the draft | Fix |
|---|---|---|
| packet_sstv_err_too_long | "plus que la limite" read back as "more than the limit", ungrammatical and vague | "au-delà de la limite de durée d’émission" (past the transmit limit) |
| packet_pkt_pager_hint | "firmware d’origine" drifted from the glossary (stock firmware = firmware d’usine) | "firmware d’usine" |
| packet_pkt_parrot_on | "%1$d émissions répétées" reads wrong for 0 and 1 (a plain string, not a plural) | "émissions répétées jusqu’ici : %1$d." |
| packet_pkt_finder_found | "(%1$d trouvées)" wrong for 1 | "(trouvées : %1$d)" |
| packet_pkt_winlink_new | "(%1$d nouveaux)" wrong for 1 | "(nouveaux : %1$d)" |
| packet_same_duration, packet_pkt_id_within | plain space between "h"/"min" and the minutes could break the line | no-break spaces |

No changed negation, number or unit was found after these fixes. One deliberate addition:
packet_cov_range_hint gives "80 km (50 miles)" where the English says "50 miles".

### Safety strings checked twice
packet_sstv_err_too_long, packet_pkt_sstv_hint (30 s transmit limit), packet_cov_test_hint, packet_cov_test_title,
packet_cov_test_msg ("Ne testez qu’un relais que vous avez le droit d’utiliser"), packet_pkt_m17_hint (receive only,
"ne peut pas émettre"), packet_pfd_hint ("il n’émet jamais"), packet_pkt_finder_hint (réception seule),
packet_pkt_parrot_hint (Morse ID at most every ten minutes, 26 s), packet_pkt_morse_id_on/off, packet_set_morse_id,
packet_pkt_id_timer_idle, packet_pkt_id_within, packet_pkt_id_due, packet_pkt_remote_pin, packet_pkt_remote_intro,
packet_pkt_remote_outro (three wrong PINs lock for ten minutes; PIN never in the history), packet_pkt_remote_err_pin,
packet_set_is_passcode ("jamais affiché ni journalisé"), packet_is_connected_rx_only, packet_is_status_unverified,
packet_pfd_vfo_on (low power), packet_set_power_hint, packet_set_autoack_off, packet_event_not_sent_analog/_dmr,
packet_finder_err_tx, packet_pkt_dtmf_transmit.

### Back-check: strings_modes.xml (fr)

File: `app/src/main/res/values-fr/strings_modes.xml`. Checked: all 881 entries (831 strings, 50 plurals; 981 text items
counting plural quantities). Each French string was read back into English and compared with the source for meaning,
negation, numbers and units.

### Fixes

| String | Problem found | Fix |
|---|---|---|
| `modes_winlink_done` | "envoyé(s), reçu(s)": bracket plural reads badly, and the style guide rules it out | « Terminé : envoyés %1$d, reçus %2$d » |
| `modes_log_rst_sent` | "env. 59" reads as "about 59" (env. = environ in the style guide) | « envoyé %1$s » |
| `modes_fox_shaded` | "contour vif 50 %, pâle 90 %" lost the English false placeholder `%, f` (English "50 %, faint"), which the placeholder test counts | « contour net 50 %, flou 90 % » (same meaning, keeps `%, f`) |
| `modes_cond_meteor_advice` | "fraction of a second up to a few seconds" checked: kept, 800 to 2000 km kept | none |
| `modes_ft8_err_no_fit` / `modes_ft8_send_hint` | 13 characters, the allowed set unchanged | none |
| `modes_parrot_event_repeated_cut*` | 26 s limit kept in both | none |
| `modes_dtmf_event_locked` | 10 minutes, 3 wrong PINs: kept | none |

No changed negation, number or unit was found in the other strings.

### Safety strings checked twice
- Transmit limits: `modes_text_hint` (30 s per transmission), `modes_parrot_hint` (30 s cap), `modes_parrot_event_repeated_cut`, `modes_parrot_event_repeated_cut_id` (26 s), `modes_m17_note_send` (Appareil → Durée d’émission maximale).
- Receive only / nothing transmitted: `modes_scope_subtitle`, `modes_scope_intro`, `modes_morse_hint`, `modes_recdec_hint_sstv`, `modes_recdec_hint_aprs`, `modes_satd_listen`, `modes_satd_listen_only`, `modes_m17_note_firmware`, `modes_m17_note_rx_only`.
- Transmitting: `modes_fox_beacon_hint`, `modes_fox_not_while_tx`, `modes_keyer_hint`, `modes_pager_freq_hint` (low power), `modes_satd_hint`, `modes_satd_hint_no_orbits` (never while you talk), `modes_forms_aprs_message` (analog channel), `modes_ft8_status_transmitting`.
- Licence / identification: `modes_keyer_id_hint` (ten minutes, at the end), `modes_exam_hint` (stays a statement about the US exams).
- Firmware: `modes_m17_note_firmware`, `modes_pager_sign_hint` (symbol engine).
- PIN / password: `modes_dtmf_event_locked`, `modes_dtmf_event_wrong_pin`, `modes_wl_set_hint`, `modes_wl_set_diag_hint`, `modes_wl_log_hint`, `modes_wl_ask_message` (password never shown, logged, in a report or backup).
- Irreversible: `modes_sstv_delete_message`, `modes_wl_delete_outbox`.

## Typography pass after the merge
strings_modes.xml: a no-break space added in 9 strings between a number and m/cm/km (e.g. "70 cm"); no text changed.
