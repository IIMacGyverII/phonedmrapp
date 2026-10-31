# pt-BR back-check: strings-intercom-channels

Files: `values-pt-rBR/strings_common.xml`, `strings.xml`, `strings_intercom.xml`, `strings_channels.xml`,
`strings_channel_editor.xml`.

Checked: 1194 entries (strings and plurals), all of them back-translated into English and compared with the source.
`de_check.py`: 0 problems, 0 untranslated in all five files. Escape count (` `, `\n`) per string matches English
after restoring the escapes the write tool had turned into plain spaces (restored by script in every affected string).

## Fixes made after the back-check

| String | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| `channel_editor_h_rxonly` | "while on it, *to talk*, the side key … are refused" | "Talk" is the Talk button, not the verb | "o botão de falar, a tecla lateral, …" |
| `channels_preset_licence_amateur_tx` | "To transmit, needs an amateur licence" | subjectless, weaker than the English | "Transmitir exige licença de radioamador" |
| `channels_preset_gmrs_licence` | "covers the family" | English: *your* family | "vale para a sua família" |
| `channels_import_intro`, `_chirp` (all forms) | "“X”: channels shared by SignalDeck: 5." | two colons, reads as a list | "“X”, compartilhado pelo SignalDeck (canais: 5)." |
| `intercom_lastheard_ex_notsent_text` | "refused before *opening* the PTT" | "abrir" is the repeater verb | "antes de acionar o PTT" |
| `intercom_chhistory_summary` | "…, packet 2, yours 1." | "yours" unclear | "suas transmissões %8$d" |
| `channels_preset_sat_about` | "+ (rising), *no signal* (overhead)" | "sem sinal" = no signal | "sem sufixo (no alto)" (twice) |
| `channels_contact_unknown_heard`, `_ago` | "*Heard* (m.) at …" | gendered participle for a person | "Última escuta em %1$s" |
| `channel_editor_h_key` | "Exactly 8 characters, the same (f.) …" | dangling agreement | "A chave tem exatamente 8 caracteres e é a mesma…" |
| `channel_editor_h_groups` | "Talkgroup lists below inserts…" | button name as subject | "O botão Listas de talkgroups, logo abaixo, insere…" |
| `channel_editor_no_private_msg` | "(type Private, f.)" | must match the Contacts chip "Privado" | "(tipo Privado)" |

No negation, number, unit or frequency changed meaning; all frequencies in prose use the decimal comma.

## Safety strings checked twice

- Transmit refusals and receive-only: `channel_editor_h_rxonly`, `channel_editor_o_rx_only`,
  `intercom_lastheard_ex_rxonly_text`, `intercom_lastheard_ex_notsent_text`, `intercom_lastheard_ex_busy_text`,
  `intercom_widget_rx_only`, `channels_preset_marine_about`, `channels_preset_wx_about`, `channels_preset_rail_about`,
  `channels_bandplan_receive_only`, `_receive_only_radio`, `_do_not_transmit`, `_keep_fm_off`, `_not_fm`,
  `_satellites_only_no_terrestrial_fm`, `_licensed_users_only`, `_licensed_users_only_public_safety`.
- 30 s transmit limit: `intercom_lastheard_ex_toolong_text` (30 s, 28,5 s).
- Licences and legality: `channels_preset_licence_*`, `channels_preset_gmrs_licence`, `_biz_about`, `_biz_licence`,
  `_cb_licence`, `_pmr_licence`, `channels_bandplan_gmrs_needs_fcc_licence_frs`, `_fcc_gmrs_licence_needed`,
  `channels_region_intro`, `channels_region_free_caution`, `channels_region_free_footer`, `intercom_zones_add_hint`,
  `intercom_zones_not_legal`, `intercom_zones_not_legal_hint`, `intercom_zones_partly_legal`,
  `channel_editor_h_enc` (encryption not allowed on amateur frequencies), `channels_preset_sat_about` (cross-band untested).
- Power: `channel_editor_h_power`, `channel_editor_h_band` (VHF always Wide), `channels_preset_murs_about`,
  `channels_preset_pmr_about`, `channels_bandplan_frs_gmrs_channels_8_14`.
- Emergency: `intercom_emergency_hint`, `_hold_to_send`, `_hold_hint`, `_not_sent`, `_keep_holding`.
- Firmware loading: `intercom_main_classic_loading`, `intercom_main_neo_loading`, `intercom_mode_state_loading`,
  `intercom_car_firmware_loading`, `intercom_car_btn_loading`.
- USB / RF into the cable: `intercom_lastheard_ex_usbdrop_text`, `intercom_autotrust_usb_text`, `_usb_text_car`.
