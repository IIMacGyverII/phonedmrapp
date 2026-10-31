# Back-check: web table (it.json)

Italian read back into English (prose and confirm boxes, every string of 70+ characters, plus all chips, toasts and
plurals), then compared with en.json. 940 strings checked.

## Fixes

| Key | Problem found in back-translation | Fix |
|---|---|---|
| exam_about*, exam_about_best* (4) | "superato con {pass}" read back as "passed with {pass}" (sounds like a result, not the pass mark) | "si supera con {pass}" |
| map_tx_cell | "{keyed} hanno raggiunto il ponte" is wrong grammar for 1 and read as people, not key-ups | "ponte raggiunto: {keyed} · senza risposta: {failed}" |
| intercom_bat_full, intercom_bat_full_in | "carica" read back as "charge / charged" (ambiguous next to "in carica") | "piena", "piena tra {time}" |
| sat_grey_normal_cyan_slightly | "lieve aumento" (slight increase) did not match the tropo tile's "nessun miglioramento" | "lieve miglioramento" |
| contacts_hist_empty | first draft "inviato a lui" was gendered | "Con questo contatto ancora niente ascoltato né inviato" |
| channels_not_tunable_chip | first draft "fuori gamma per questa radio" too long for the chip | "non sintonizzabile qui" |
| exam_percent | "{pct} %" with a space | "{pct}%" (style §5) |
| sstv_pass_recording_satellite_passes, sstv_no_recordings | menu name "Passaggi dei satelliti" differed from the phone strings | "Passaggi satellitari" as in values-it/strings_modes.xml |

No changed number, unit or negation was found beyond these.

## Safety strings checked twice
intercom_ptt_firmware, intercom_ptt_web_tx_off, intercom_ptt_rx_only, intercom_ptt_browser_mic, intercom_ptt_phone_mic,
intercom_ptt_phone_mic_https, intercom_loading_firmware, common_needs_web_tx, pager_needs_web_tx, sstv_web_tx_off,
pkt_wsjt_x_mode_phone, settings_web_access_pin_allow, settings_restart_installing_update_each,
settings_dev_restart_ask ("Non viene trasmesso niente"), messages_wl_tune_ask ("La radio trasmette."),
sstv_sends_current_analog_channel (120 s time-out, cool-down), scope_receive_only_radio_sweeps, scope_idle,
scope_running, pkt_listens_across_packet_frequencies ("senza mai trasmettere"), pkt_m17_digital_voice_phone
(receive only), sat_tracking_follows_every_pass, pkt_parrot_sub, pkt_fox_sub, editor_tx_allowed, editor_rx_only,
editor_save_note, settings_hand_back_ask, settings_take_over_gives_radio, messages_your_callsign_comes_from,
pkt_set_note, login_enter_pin_shown_phone, exam_licence_exam_practice (stays the US exam).
