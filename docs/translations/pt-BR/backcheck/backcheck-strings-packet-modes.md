# Back-check: pt-BR strings_packet.xml + strings_modes.xml

Draft translated back into English string by string (pt text only), then compared with the English meaning,
negations, numbers and units.

- Checked: 1640 resources (packet 759, modes 881), every plural quantity included (one/many/other).
- de_check.py: strings_packet.xml 0 problems; strings_modes.xml 1 problem = the known `modes_fox_shaded` false positive
  ("50 %, fraco 90 %" keeps the "%, f" sequence). 0 untranslated in both.
- Escape counts (` `, `\n`, `&amp;`, `%%`) compared per string with English: all equal, except the intended
  `packet_set_title` ("APRS &amp; packet" → "APRS e packet") and two `\"` replaced by curly quotes “…” (style §4).

## Fixes made from the back-check

| String | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| packet_cov_event_keyed | "<channel> opened (f.) from here" | adjective agreed with an unknown channel name | "Abriu %1$s daqui" (verb, no agreement) |
| packet_map_cell_no_reply (other) | "No reply 3 times" (stiff word order) | unnatural | "%1$d vezes sem resposta" |
| packet_map_cell_heard | "Heard <repeater>" read as the station heard | ambiguous | "Ouvida: %1$s · %2$s" |
| packet_pfd_row, packet_pfd_row_dbm | "…, last <time>" (last what?) | ambiguous | "última vez %4$s" / "%5$s" |
| modes_recdec_upload, modes_recdec_none_hint | "Send a recording…" | "Enviar" reads as transmit; English is upload/import | "Importar gravação…" |
| modes_fox_* prose (block_marks, block_floor, block_spread, note_no_compass, note_no_bearing, layer_strongest) | "points" | glossary: mark = *marcação* in prose, *Ponto* on buttons | "marcação/marcações" |
| modes_pota_their_ref | "his POTA …" | gendered pronoun for the other station | "%1$s da outra estação: %2$s" |
| modes_satd_hint | "Orbits of 5 h back" | unnatural, unclear | "Órbitas baixadas há %1$s h." |
| modes_satd_pass_rises | "Rises to NE" | preposition wrong with a compass abbreviation | "Nasce: %1$s, se põe: %2$s" |
| packet_toggle_on / off | "ACTIVATED / DEACTIVATED" | too long for a very short pill | "ATIVO / INATIVO" |
| 14 packet + all modes strings with ` ` | — | the file tool turned ` ` into plain spaces (Android would trim them) | restored via a placeholder; counts now equal English |

No changed number, unit, negation or placeholder was found beyond the table.

## Plural forms (Portuguese `one` covers 0)
Where the count can be 0, the `one` form is phrased without number agreement: packet_same_areas ("áreas: N"),
packet_map_st_n_here, packet_map_legend_squares, packet_map_cell_typical, packet_map_cell_no_reply,
packet_finder_stations (sentence reworded: "estações na lista: N"), packet_pkt_logbook_n, packet_pkt_igate_on,
packet_pkt_gw_left, packet_pkt_gw_too_long, modes_winlink_import_usable, modes_m17_packet, modes_rec_sstv_found
("completas: N" for the second count), modes_term_state_pending, modes_pager_chars, modes_forms_aprs_message,
modes_log_grids(_here), modes_log_contacts, modes_log_heard, modes_sstv_selected, modes_exam_missed_review,
modes_wl_gw_count, modes_wl_attach_bytes, modes_fox_spin_progress(_wait). Counts the comments give as 2 or more use
the plural text in `one` too.

## Safety strings checked twice (negation, limits, licence, PIN, transmit)
packet_sstv_err_too_long · packet_err_analog* · packet_event_not_sent_* · packet_finder_err_tx · packet_pfd_hint
("só escuta (nunca transmite)") · packet_pkt_m17_hint ("este rádio não transmite M17") · packet_pkt_sstv_hint (30 s
limit) · packet_pkt_parrot_hint · packet_cov_test_hint / _title / _msg ("Só teste uma repetidora que você tem
permissão para usar") · packet_pkt_remote_pin / _intro / _outro / _err_pin (lockout 3 PINs / 10 min, PIN never in
history) · packet_set_is_passcode ("nunca exibido nem registrado") · packet_set_power_hint · packet_set_lead_hint ·
packet_set_morse_id · packet_pkt_id_* · modes_keyer_id_hint · modes_keyer_hint · modes_parrot_hint (30-second limit) ·
modes_text_hint (30 seconds) · modes_m17_note_send (Dispositivo → Transmissão máxima) · modes_m17_note_firmware ·
modes_m17_note_rx_only · modes_fox_not_while_tx · modes_fox_beacon_hint · modes_scope_subtitle ("nada é
transmitido") · modes_scope_intro · modes_recdec_hint_sstv / _aprs ("nunca usa o rádio", "Nada é enviado") ·
modes_morse_hint ("não vai para o ar") · modes_satd_hint ("nunca enquanto você fala") · modes_pager_freq_hint (low
power) · modes_wl_set_hint / _set_diag_hint / _log_hint / _ask_message (password never shown, logged or shared) ·
modes_exam_hint (stays a statement about the US exams) · modes_log_not_found (US/Canada) · packet_pkt_gw_hint (US and
Canada numbers).
