# Back-check: SignalDeck Web table (es.json)

Checked: all 940 keys (plural forms included). Method: each Spanish string read back into English without the
source, compared with en.json for meaning, negation, numbers and units; placeholders, HTML tags and digit
sequences compared by script (0 differences); `de_check.py ... web es`: 0 problems, 0 untranslated.

## Fixes made
| Key | Problem in draft | Fix |
|---|---|---|
| channels_click_channel_s_edit | "haz clic en su Editar" read badly | "haz clic en Editar junto a él, o en Nuevo canal para crear uno" |
| sat_grey_normal_cyan_slightly | colour legend adjectives agreed with nothing ("cian ligeramente mejorada") | "Gris: normal · cian: ligera mejora · verde: superrefracción · ámbar: ducto probable" |
| settings_restart_installing_update_each | "piden confirmación cada uno" ungrammatical | "Tanto el reinicio como la instalación de una actualización piden confirmación" |
| pkt_parrot_sub, pkt_fox_sub | "necesita transmitir" read back as "it has to transmit" rather than "needs transmit permission" | "necesita permiso para transmitir" |
| map_coverage_transmit_reached | "transmisión que llegó" vague | "Cobertura: repetidor alcanzado" |
| map_one_repeater_its_range | "bajo lo medido" could read "according to what was measured" | "debajo de lo medido" (drawn under the measurements) |
| map_pred_keyup | "Debería abrirlo" lost the object | "Debería abrir el repetidor" |
| messages_wl_tune_ask | "El equipo transmite" read as a general statement | "El equipo transmitirá." |
| exam_mt_next / exam_mt_result_more | "a la lección", "con 90 % pasas a la siguiente" elliptic | "pasas a la lección {lesson} (nuevo: {adds})", "con un 90 % pasas a la siguiente lección" |
| pkt_id_due_now | "TOCA IDENTIFICARSE" (toca = tap in the UI) | "IDENTIFÍCATE AHORA" |
| channels_delete_ask.other | lost "move up" nuance | "suben un puesto" |
| intercom_bat_rate_wait, sat_cond_normal | vague | "ritmo disponible en unos minutos", "no se espera mejora de la propagación" |
| contacts_hist_empty | heard/sent direction unclear | "Aún no se ha escuchado nada de este contacto ni se le ha enviado nada" |
| intercom_cell, intercom_phone_live, messages_st_failed | regional/ambiguous ("MÓVIL", "EN VIVO", "error") | "RED MÓVIL", "ACTUALIZADO", "fallido" |
| sstv_comb_only_one, sat_cond_kp_forecast, sat_cond_aurora_chance | trailing space lost | restored |

## Safety strings checked twice
intercom_ptt_web_tx_off, intercom_ptt_rx_only, intercom_ptt_firmware, intercom_loading_firmware,
intercom_ptt_browser_mic, intercom_ptt_phone_mic, intercom_ptt_phone_mic_https, common_needs_web_tx,
pager_needs_web_tx, sstv_web_tx_off, settings_web_access_pin_allow, settings_restart_installing_update_each,
sstv_sends_current_analog_channel (120 s limit, cool-down), messages_wl_tune_ask, settings_dev_restart_ask,
scope_receive_only_radio_sweeps, scope_idle, scope_running, pkt_m17_digital_voice_phone (receive only, cannot
transmit M17), pkt_listens_across_packet_frequencies (never transmits), sat_tracking_follows_every_pass (listens only),
sat_listen_only, editor_rx_only, editor_tx_allowed, editor_save_note (VHF narrow = deaf), pkt_parrot_sub, pkt_fox_sub,
pkt_wsjt_x_mode_phone, pkt_set_passcode_none, messages_your_callsign_comes_from / pkt_set_note (password and
passcode never shown), settings_hand_back_ask, channels_stock_import_ask, settings_restore_ask,
settings_restore_files_ask, sstv_delete_ask, editor_delete_ask(_named).
All keep the negation early and as strong as the English.
