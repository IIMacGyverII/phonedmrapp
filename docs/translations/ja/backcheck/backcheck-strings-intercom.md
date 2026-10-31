# Back-check: strings_intercom.xml (ja)

Every entry translated back into English without looking at the source, then compared with the English. Checked: **602 entries** (570 strings + 32 plurals, `other` only). de_check: 0 problems, 0 untranslated.

## Fixes made

| String | Back-translation of draft | Problem | Fix |
|---|---|---|---|
| intercom_carmsg_noaa | "NOAA weather information" | Glossary term for NOAA weather is 気象放送 | NOAA 気象放送 |
| intercom_lastheard_ex_connected_text | "…(Device → Full-screen radio controls for the car)" | Setting name did not match values-ja/strings_device.xml (`device_set_car_screen` = 車で全画面の無線操作) | デバイス → 車で全画面の無線操作 |
| intercom_lastheard_ex_usbdrop_text | (draft) "a 2 m repeater" | Glossary: prose uses 144 MHz 帯 for 2 m | 144 MHz 帯のレピーターチャンネル; numbers 144.770 / 146.370 MHz unchanged |
| intercom_nets_elsewhere_show / _hide | (draft) "2 m, 70 cm" | Same glossary rule | 144 MHz 帯、430 MHz 帯 |
| intercom_netstore_report_flag_sep | ", " → 、 | Intentional: Japanese list separator needs no space (the one   difference the build script reports) | kept 、 |

No meaning, negation, number or unit changed in the final draft.

## Safety strings checked twice (against the English, negation and numbers)
- intercom_emergency_hint (real emergencies only; real people answer)
- intercom_emergency_hold_hint, intercom_emergency_not_sent (2 seconds; 未送信 first)
- intercom_lastheard_ex_rxonly_text (three ranges, "does not transmit there, whatever button is pressed")
- intercom_lastheard_ex_toolong_text (Device → 最長送信時間; refused instead of cut off)
- intercom_lastheard_ex_busy_text, intercom_lastheard_ex_notsent_text (refused before keying; AFSK not over DMR)
- intercom_lastheard_ex_usbdrop_text, intercom_autotrust_usb_text, intercom_autotrust_usb_text_car (frequencies, high/low power advice)
- intercom_zones_add_hint ("listening is always fine, transmitting is not on every list")
- intercom_zones_not_legal, intercom_zones_not_legal_hint, intercom_zones_partly_legal (legal text; "your responsibility" kept)
- intercom_widget_rx_only, intercom_lastheard_ex_rxonly_title
- intercom_main_classic_loading, intercom_main_neo_loading, intercom_mode_state_loading, intercom_car_firmware_loading (glossary sentence 無線機は使用中です（ファームウェア書き込み中）), intercom_car_btn_loading
- intercom_lastheard_ex_repeaterid_text ("as repeaters must" kept as an obligation: 送出しなければなりません)

## Notes for the translation agent
- Too long / check on screen: intercom_vfo_simplex シンプレックス (7 glyphs in a five-pill row; no shorter community word except the legal 単信); intercom_lastheard_activity アクティビティ (one of three buttons; glossary term); intercom_vfo_save_as_channel shortened to チャンネル保存.
- intercom_car_btn_loading = 書き込み中 (drops "firmware" to stay short on the car button; no invented abbreviation).
- intercom_netedit_time / _am / _pm: the code formats 12-hour time; style §7 says 24-hour for ja. I kept "AM"/"PM" in Latin (no 午前/午後). Code should use 24-hour for ja.
- intercom_nets_place_miles: the value is miles from code; written マイル.
- intercom_main_meter_floor: "floor" rendered ノイズ (the noise floor value) to keep the line short.
