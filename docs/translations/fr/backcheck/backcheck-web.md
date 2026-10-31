# Back-check: SignalDeck Web, French (fr)

File: `app/src/main/assets/web/i18n/fr.json`. 940 strings checked (all keys of en.json except `_comments`), about 4,840
French words. I translated each string back into English and compared it with the English meaning, negations, numbers
and units. `de_check.py <worktree> web fr`: 0 problems, 0 untranslated.

## Fixes made in the back-check

| Key | Draft (back-translated) | Problem | Fixed to |
|---|---|---|---|
| map_coverage_transmit_reached | « émission reçue » (transmission received) | Reads as if *we* received; meaning is "your transmit reached the repeater" | « Couverture : relais atteint » |
| map_one_repeater_its_range | « …sous les mesures » (under the measurements) | Unclear that it is *drawn* under the measured data | « …affichée sous les mesures » |
| channels_not_tunable_title | « hors de portée » (out of reach) | Reads as distance/range, not "frequency the radio cannot tune" | « Fréquence hors plage pour cette radio » |
| map_tx_cell | « {keyed} ont atteint… » | Verb agreement broke for 1 | « relais atteint : {keyed} · sans réponse : {failed} » |
| contacts_last_heard | « Dernière écoute » (last listening session) | Changed meaning | « Entendu {ago}{by}{at} » |
| pkt_tx_1st_00_30 / pkt_tx_2nd_15_45 | « TX 1re », « TX 2e » | Ordinal without its noun | « TX période 1 / 2 (…) » |
| pkt_call_cq | « Lancer appel CQ » | Ungrammatical | « Lancer un CQ » |
| intercom_bat_empty_in | « vide dans {time} env. » | "about" stuck at the end, odd | « vide dans {time} environ » |
| editor_relay_disconnect | left as « Disconnect » | Not translated (German translates it) | « Déconnexion » |
| sstv_comb_up/down/left/right | « haut {n} » inside « {vertical} lignes » | Built « haut 3 lignes »; word order breaks | arrows « ↑ {n} », « ↓ {n} », « ← {n} », « → {n} » |
| sstv_pictures_deleted.one | — | French `one` also covers 0; English has no {n} | « Image supprimée » (reads right for 1, never says "1" for 0) |

No negation, number or unit was lost in the final file.

## Safety strings checked twice (transmit, receive-only, licence/web-transmit rights, PIN, firmware loading, time limit)
intercom_ptt_firmware, intercom_ptt_web_tx_off, intercom_ptt_rx_only, intercom_ptt_browser_mic, intercom_ptt_phone_mic,
intercom_ptt_phone_mic_https, intercom_loading_firmware, common_needs_web_tx, pager_needs_web_tx, sstv_web_tx_off,
settings_web_access_pin_allow, settings_restart_installing_update_each, settings_dev_restart_ask (« Rien n'est émis »),
settings_dev_install_ask, settings_hand_back_ask, settings_take_over_gives_radio, messages_wl_tune_ask (« La radio va
émettre »), messages_your_callsign_comes_from (password never shown/logged/backed up), messages_wl_diag_ask,
messages_send_us_e_mail, pkt_set_note, sstv_sends_current_analog_channel (120 s limit, cool-down),
pkt_listens_across_packet_frequencies (« sans jamais émettre »), pkt_m17_digital_voice_phone (« ne peut pas émettre en
M17 »), scope_receive_only_radio_sweeps, scope_idle, sat_tracking_follows_every_pass, pkt_wsjt_x_mode_phone,
pkt_parrot_sub, pkt_fox_sub, pkt_set_passcode_none, editor_rx_only, editor_save_note, editor_tx_allowed, pkt_halt_tx,
settings_restore_ask, settings_restore_files_ask, settings_restore_replaces_every_channel, sstv_delete_ask.*,
editor_delete_ask*, channels_delete_ask.*.
