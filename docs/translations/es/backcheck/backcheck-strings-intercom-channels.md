# Back-check: Spanish (es), part strings-intercom-channels

Files: values-es/strings_common.xml, strings.xml, strings_intercom.xml, strings_channels.xml, strings_channel_editor.xml.
Checked: 1194 strings/plurals (20 + 1 + 602 + 419 + 152), each read back into English and compared with the source.
de_check.py: 0 problems, 0 untranslated in all five files.

## Fixes made after the back-check

| String | Draft said (back-translated) | Fixed to |
|---|---|---|
| intercom_zones_add_hint | "transmitting is not permitted on all lists" (Spanish partial negation readable as "on no list") | "escuchar siempre está permitido; transmitir, solo en algunas listas" |
| intercom_main_tone_heard_message | "other stations will hear you if they need it" (who needs what unclear) | "las estaciones que lo necesiten te oirán" (stations that need the tone) |
| intercom_main_keywords_message | added a sentence not in English ("recognition is English, type them in English") | removed; text now matches the English |
| channels_preset_added_reused(_skipped) | "%3$d ya los tenías" read wrong for 1 | "%3$d que ya tenías" |
| channels_rep_none_match [one] | awkward "the repeater ... (1)" | "El único repetidor a menos de %2$s no coincide con estos filtros." |
| channel_editor_h_callfrom | "long-press CALL" while the readout cell is translated LLAMADA (glossary §4) | "mantener presionado LLAMADA" |
| channel_editor_h_type / subtitle_new / location_filled / h_pos | "rellenar", "de toda la vida" (Peninsular/colloquial) | "completar", "FM clásica" |
| channel_editor_h_rxt | "comprueba" | "verifica" (style §2) |

No changed number, unit, negation or placeholder remained after the fixes.

## Safety strings checked twice (against the English)
- channel_editor_h_rxonly, _h_enc ("El cifrado no está permitido en frecuencias de radioaficionado"), _h_power, _h_band, _h_relay, _o_rx_only
- channels_preset_licence_none / _rx_only / _amateur / _amateur_tx, _gmrs_licence, _biz_licence, _cb_licence, _pmr_licence,
  _marine_about, _biz_about, _wx_about, _rail_about, _sat_about (cross-band untested, listen first)
- channels_bandplan_do_not_transmit, _keep_fm_off, _no_fm_here, _not_fm, _satellites_only_no_terrestrial_fm,
  _licensed_users_only(_public_safety), _receive_only(_radio), _gmrs_needs_fcc_licence_frs, _fcc_gmrs_licence_needed
- channels_region_intro (never transmits; you remain responsible), _free_caution ("Verifícalo antes de transmitir"),
  _free_footer, _aprs_untunable
- intercom_zones_add_hint, _not_legal, _not_legal_hint, _partly_legal
- intercom_lastheard_ex_rxonly_text, _toolong_text (30 s / 28,5 s), _busy_text, _notsent_text, _usbdrop_text,
  intercom_autotrust_usb_text(_car)
- intercom_emergency_hint ("Solo para una emergencia real"), _hold_to_send, _not_sent, _hold_hint
- intercom_widget_rx_only, intercom_main_classic_loading / neo_loading / mode_state_loading / car_firmware_loading
  (module busy loading firmware)
