# Back-check: Italian, part strings-intercom-channels

Files: `values-it/strings_common.xml`, `strings.xml`, `strings_intercom.xml`, `strings_channels.xml`,
`strings_channel_editor.xml` (1194 strings and plurals, about 8400 English words).

Method: each Italian string read back into English without the source, then compared with the English for meaning,
negation, numbers, units and menu names. Mechanical checks by script: placeholders (de_check, 0 problems in all five
files), per-string counts of ` `, `\n` and `→` against English, no straight apostrophes, no dot decimals in
prose (frequencies written 144,770 MHz etc.).

Checked: 1194 of 1194.

## Fixes made

| String | Back-translation of the draft | Problem | Fix |
|---|---|---|---|
| `intercom_main_tone_heard_message` | "...other stations hear you even if they require it" | "if they need it" read as a concession | "e ti sentono anche le stazioni che lo richiedono" |
| `intercom_lastheard_ex_notsent_text` | "The transmission was refused before going into transmission" | circular; "before keying" lost | "prima di attivare il trasmettitore" |
| `intercom_zones_add_hint` | "transmitting is not allowed on all lists" | Italian "non … su tutti" can be misread as "on none" | "trasmettere non sempre: dipende dall’elenco" |
| `intercom_mode_tunes_at` | "tuning at 07:00" | noun, vague | "si sintonizza alle %1$s" |
| `intercom_lastheard_ex_morse_text` | (meaning fine) | `→` escapes turned into a literal → by the writing tool | restored `→` |
| `intercom_main_look_*`, `intercom_main_menu_classic` | "new look" | did not match the Device setting name another translator wrote (`device_set_new_look` = "Nuova grafica della pagina Radio") | aligned to "grafica" |

No changed number, unit or frequency was found; no lost negation remained after the fixes above.

## Safety strings read twice against the English

- Transmit refusals and limits: `intercom_lastheard_ex_rxonly_text`, `_toolong_text` (30 s / 28,5 s), `_busy_text`,
  `_notsent_text`, `intercom_widget_rx_only`, `channel_editor_h_rxonly`, `channels_preset_marine_about` ("questa radio
  non è un apparato nautico"), `channels_bandplan_do_not_transmit`, `_receive_only*`, `_licensed_users_only*`.
- Licence and legality: `channels_preset_licence_*`, `_gmrs_licence`, `_biz_licence`, `_cb_licence`, `_pmr_licence`,
  `channels_bandplan_*licence*`, `intercom_zones_not_legal`, `_not_legal_hint`, `_partly_legal`, `_add_hint`,
  `channels_region_intro`, `_free_caution`, `_free_footer`, `channel_editor_h_enc` (encryption not allowed on amateur
  frequencies), `channels_preset_biz_about` (wide band no longer allowed for transmitting on VHF).
- Emergency: `intercom_emergency_hint`, `_hold_*`, `_keep_holding`, `_not_sent`.
- RF into the USB cable / power: `intercom_lastheard_ex_usbdrop_text`, `intercom_autotrust_usb_*`,
  `channel_editor_h_power`, `_h_band` (Narrow makes the receiver deaf on VHF), `_h_relay` (Disconnect may not transmit at
  all).
- Firmware loading: `intercom_main_classic_loading`, `_neo_loading`, `intercom_mode_state_loading`,
  `intercom_car_firmware_loading`, `intercom_car_btn_loading`.
- Restricted mode: `channels_region_locked`.

All clean after the fixes.
