# Back-check: strings_modes.xml (fr)

File: `app/src/main/res/values-fr/strings_modes.xml`. Checked: all 881 entries (831 strings, 50 plurals; 981 text items
counting plural quantities). Each French string was read back into English and compared with the source for meaning,
negation, numbers and units.

## Fixes

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

## Safety strings checked twice
- Transmit limits: `modes_text_hint` (30 s per transmission), `modes_parrot_hint` (30 s cap), `modes_parrot_event_repeated_cut`, `modes_parrot_event_repeated_cut_id` (26 s), `modes_m17_note_send` (Appareil → Durée d’émission maximale).
- Receive only / nothing transmitted: `modes_scope_subtitle`, `modes_scope_intro`, `modes_morse_hint`, `modes_recdec_hint_sstv`, `modes_recdec_hint_aprs`, `modes_satd_listen`, `modes_satd_listen_only`, `modes_m17_note_firmware`, `modes_m17_note_rx_only`.
- Transmitting: `modes_fox_beacon_hint`, `modes_fox_not_while_tx`, `modes_keyer_hint`, `modes_pager_freq_hint` (low power), `modes_satd_hint`, `modes_satd_hint_no_orbits` (never while you talk), `modes_forms_aprs_message` (analog channel), `modes_ft8_status_transmitting`.
- Licence / identification: `modes_keyer_id_hint` (ten minutes, at the end), `modes_exam_hint` (stays a statement about the US exams).
- Firmware: `modes_m17_note_firmware`, `modes_pager_sign_hint` (symbol engine).
- PIN / password: `modes_dtmf_event_locked`, `modes_dtmf_event_wrong_pin`, `modes_wl_set_hint`, `modes_wl_set_diag_hint`, `modes_wl_log_hint`, `modes_wl_ask_message` (password never shown, logged, in a report or backup).
- Irreversible: `modes_sstv_delete_message`, `modes_wl_delete_outbox`.
