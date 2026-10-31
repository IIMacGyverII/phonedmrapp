# Back-check: pt-BR, part `web` (assets/web/i18n/pt-BR.json)

Checked: **940 of 940 keys**. Method: read the pt-BR draft back into English without looking at the source, then
compared against en.json for meaning, negation, numbers and units. Mechanical checks: `de_check.py … web pt-BR`
gives 0 problems, 0 untranslated; key order matches en.json; HTML tags, `{placeholders}`, leading and trailing spaces
and the two `\n\n` breaks match English, string for string.

## Fixes made

| Key | Problem found in the back-translation | Fix |
|---|---|---|
| sstv_sends_current_analog_channel | "the phone cools down before the next long picture" read as a fact, not as a wait (heat) | "o celular espera esfriar antes de transmitir a próxima imagem longa" |
| intercom_ptt_phone_mic, intercom_ptt_phone_mic_https | "quem transmite é o microfone do celular" read back as "the microphone is the one that transmits" | "a transmissão usa o microfone do celular" |
| messages_your_callsign_comes_from | "só pode ser gravada" read back as "can only be recorded", not write-only | "só pode ser digitada, nunca lida" |
| pkt_fox_sub, pkt_parrot_sub | "precisa de transmissão" read back as "needs a transmission" | "precisa poder transmitir" (needs transmit allowed) |
| settings_take_over_gives_radio | "Devolver o devolve" clumsy, meaning blurred | "Devolver entrega o rádio de volta ao app de rádio do fabricante" |
| map_one_repeater_its_range | "por baixo do que foi medido" ambiguous | "sob o que foi medido" (layer drawn under the measurements) |
| sat_grey_normal_cyan_slightly | adjective gender clashed with the colour names ("ciano levemente favorecida") | "Cinza: normal · ciano: leve reforço · verde: super-refração · âmbar: duto provável" |
| sat_cond_normal | "sem abertura" clashed with *aberturas* = key-ups (glossary) | "nenhum reforço esperado" |
| sat_orbits_old | "ÓRBITAS DE {n} DIAS ATRÁS" read as "orbits from n days ago" | "DADOS ORBITAIS COM {n} DIAS" |
| sat_track_ask, sat_track_ask_iss | "em vez da atual … substitui o atual" said it twice | one clause: "Isso substitui o rastreamento atual" |
| exam_passed | "Aprovado" agrees with a male user (style §1) | "Passou: …" |
| channels_click_channel_s_edit | "sintoniza ele" too colloquial | "sintoniza esse canal" |
| intercom_cell_value | "celular" (cell tile value) read back as "the phone" | "rede móvel" |
| common_selected, channels_zone_count, log_net_running, log_net_checkins, exam_about(_best), map_cov_tx/rx | pt `one` covers 0: "0 selecionado", "0 canal" would show | count put after a label ("Selecionados: {n}", "Canais: {n}", "CHECK-INS: {n}", "erradas para revisar: {n}") in both forms |

No negation, number or unit changed meaning in the final text.

## Safety strings read twice against English

- intercom_ptt_rx_only, editor_rx_only, editor_tx_allowed, pkt_set_passcode_none (receive-only)
- intercom_ptt_web_tx_off, sstv_web_tx_off, common_needs_web_tx, pager_needs_web_tx, pkt_wsjt_x_mode_phone,
  settings_web_access_pin_allow (transmit from the web / PIN: changed only on the phone)
- intercom_ptt_firmware, intercom_loading_firmware, settings_restart_installing_update_each (firmware loading)
- sstv_sends_current_analog_channel (120 s time-out, cool-down)
- messages_wl_tune_ask ("O rádio vai transmitir."), settings_dev_restart_ask ("Nada é transmitido.")
- scope_receive_only_radio_sweeps, scope_idle, scope_running, scope_sweeping_*, sat_tracking_follows_every_pass,
  sat_listen_only, pkt_listens_across_packet_frequencies, pkt_m17_digital_voice_phone (receive only, never transmits)
- pkt_fox_sub, pkt_parrot_sub, pkt_upload_recording_any_audio (transmit needed)
- editor_save_note, editor_vfo_note (VHF always wide band)
- settings_hand_back_ask, settings_take_over_gives_radio, settings_restore_ask, settings_restore_files_ask,
  sstv_delete_ask, editor_delete_ask(_named) ("Não é possível desfazer")
- messages_your_callsign_comes_from, messages_send_us_e_mail, messages_wl_diag_ask, pkt_set_note (password and
  passcode never shown or sent)
