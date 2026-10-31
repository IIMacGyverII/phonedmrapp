# Back-check: ja, strings_packet.xml + strings_modes.xml

Checked: 1,642 entries (strings_packet.xml 748 strings + 11 plurals; strings_modes.xml 833 strings + 50 plurals),
every one read back into English and compared with the source for meaning, negation, numbers, units and placeholders.
`de_check.py … ja`: 0 problems, 0 untranslated for both files. Escapes (` `, `\n`, `\\`, `%%`) counted per string
against English by script; the only differences are the intentional ones listed at the end.

## Fixes made after the back-check

| String | Draft said (back-translated) | Problem | Fixed to (back-translated) |
|---|---|---|---|
| packet_igate_not_gated | "Not gated to the radio (stations not on %1$s)" | Moved the "not on" to the station; English means the radio is not on the APRS frequency | "Not gated to the radio (because it is not tuned to %1$s)" |
| packet_cov_range_hint | "Auto is up to the distance … up to 50 miles" | Clumsy double "up to"; "a fixed range is a minimum" kept | Rewritten: "Auto covers the distance … up to 50 miles. A fixed range is the minimum. Your position and measured points are always all included." |
| packet_cov_test_hint | "Don't overuse it." | Stronger than "use it sparingly", read as a prohibition | "Use it sparingly." (控えめに使ってください) |
| modes_cond_aurora_advice | "VHF aurora reflection reflects off the auroral oval" | Doubled verb | "In VHF aurora, signals reflect off the auroral oval to the north …" |
| modes_clause_separator | 。 (full stop) | Joins clauses of one sentence; a full stop broke it into sentences | 、 |
| modes_morse_key | KEY (left in English) | Not a key legend from the keep-English list | 電鍵 (the Japanese ham word for a Morse key) |

## Safety strings checked twice

Transmit limits, licence/ID rules, PIN, receive-only, "nothing is transmitted", passwords and transmitting refused:

- packet_sstv_err_too_long (30 s / transmit limit, Device → Longest transmission)
- packet_pkt_sstv_hint, modes_text_hint, modes_parrot_hint, packet_pkt_parrot_hint (30 s limit, 26 s parrot cap, Morse ID every 10 min)
- modes_m17_note_send (transmit limit), modes_m17_note_firmware, modes_m17_note_rx_only, packet_pkt_m17_hint (receive only: cannot transmit M17)
- packet_cov_test_hint, packet_cov_test_title, packet_cov_test_msg ("only test a repeater you are allowed to use")
- packet_pkt_remote_pin ("keep it to yourself"), packet_pkt_remote_intro, packet_pkt_remote_outro (3 wrong PINs → 10 min lock; PIN never in the history), packet_pkt_remote_err_pin, modes_dtmf_event_locked, modes_dtmf_event_wrong_pin
- packet_set_is_passcode (never shown or logged), modes_wl_set_hint, modes_wl_set_diag_hint, modes_wl_log_hint, modes_wl_ask_message (password never logged)
- packet_pfd_hint (never transmits), modes_scope_subtitle (nothing is transmitted), modes_scope_intro, modes_recdec_hint_aprs (nothing sent, digipeated or gated), packet_pkt_finder_hint (receive only)
- modes_satd_hint / _no_orbits (no Doppler retune while you talk), modes_fox_not_while_tx, packet_finder_err_tx
- modes_keyer_id_hint, packet_pkt_id_within, packet_pkt_id_due, modes_keyer_timer_now, packet_pkt_morse_id_on/off, packet_set_morse_id (ID rules)
- packet_set_power_hint, packet_pfd_vfo_on (low power), modes_pager_freq_hint (low power)
- modes_fox_beacon_hint, packet_pkt_fox_hint_tx, modes_fox_no_rssi
- packet_event_not_sent_analog / _dmr, packet_weather_not_sent, modes_ft8_event_nonstandard
- Exam: packet_pkt_exam_section, packet_pkt_exam_hint, modes_exam_title, modes_exam_hint: stated as the US exam
  (「米国」 explicit; "（英語）" added to say the pools are English, as style §10 asks). No Japanese regulation added.

All clean on the second pass.

## Intentional differences from English escapes

- packet_sentence_sep, modes_sentence_separator: empty (Japanese joins sentences without a space; the comments ask for this).
- packet_list_sep, modes_list_separator: 、 ; modes_clause_separator: 、 (no trailing ` `).
- modes_fox_not_used: trailing ` ` dropped (sentence ends in 。 and Japanese adds no space before the next one).
- modes_morse_result: three ` ` instead of four, so 「送信：」 and 「入力：」 (same width) still line up in the monospaced box.
- modes_ft8_event_no_answer, modes_ft8_send_hint: `\"…\"` replaced by 「…」.

## Labels that may be tight (for the screen check)

- modes_ft8_send_text 「テキスト送信」 (third of a row), modes_ft8_call_cq 「CQ を出す」.
- packet_pkt_morse_id 「コールサインをモールスで送信」, packet_pkt_parrot_start 「このチャンネルでパロット」,
  packet_pkt_finder_listening 「パケット検索（受信中）」 (two-button rows on the PKT sheet).
- modes_log_heard_on/off 「受信局を記録：オン」 (third of a row).
- packet_aprs_tab_messages 「メッセージ」 (three tabs share a row).
