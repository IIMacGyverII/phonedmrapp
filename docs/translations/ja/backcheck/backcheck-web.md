# Back-check: web table `assets/web/i18n/ja.json` (ja)

I translated every entry back into English without looking at the source, then compared it with en.json.
Checked: **941 keys**. That covers every key in en.json except `_comments`, and plural keys count as two (`.one` and
`.other` carry the same text). `de_check.py … web ja`: 0 problems, 0 untranslated. I also ran these checks by script:
HTML tags match English, the leading space stays where English has one, no あなた, no decimal comma, no half-width
brackets next to Japanese, and no Japanese glyph sits right next to Latin letters or digits without the §3.3 space
(the only hits are placeholders that hold Japanese text).

## Fixes made

| Key | Back-translation of draft | Problem | Fix |
|---|---|---|---|
| exam_not_yet | "Fail: {pass} correct are needed…" | English "Not yet" is softer. 不合格 is right but reads harsher than the source | まだ合格ではありません：… |
| intercom_bat_rate_wait | "Show speed after a few minutes" | Read as an instruction, not a state | 速度は数分後に表示 |
| exam_licence_exam_practice | "Licence exam practice (US exam · English)" | Heading too long for one line (15 glyphs). Style §10 needs "US" and "English" kept | 米国の免許試験対策（英語） |
| editor_power | "Output" | Phone editor (values-ja) says 送信出力 | 送信出力 |
| editor_relay_normal | "Normal" | Phone says 標準 | 標準 |
| editor_mode_direct | "Direct" (katakana) | Phone says 直接 | 直接 |
| editor_ctype | "Call type" | Phone says 連絡先種別 | 連絡先種別 |
| editor_key | "Cipher key" | Phone says 暗号化キー | 暗号化キー（8 文字） |

I found no lost negation, no changed number and no changed unit.

## Safety strings checked twice
- intercom_ptt_firmware (無線機は使用中です（ファームウェア書き込み中）。), intercom_loading_firmware
- intercom_ptt_rx_only: written with the headline first: 送信不可：このチャンネルは受信専用です。
- intercom_ptt_web_tx_off, common_needs_web_tx, pager_needs_web_tx, sstv_web_tx_off, pkt_wsjt_x_mode_phone (the "Allow
  transmit from the web" name matches the phone: Web からの送信を許可)
- intercom_ptt_browser_mic, intercom_ptt_phone_mic, intercom_ptt_phone_mic_https (hold to transmit, which microphone)
- settings_web_access_pin_allow (the PIN and the transmit permission can be changed only on the phone; 決して is kept)
- settings_restart_installing_update_each (the firmware loader stays on the phone)
- messages_wl_tune_ask (無線機が送信します。), settings_dev_restart_ask (送信は一切しません。)
- pkt_m17_digital_voice_phone (受信専用 / M17 で送信できません), pkt_listens_across_packet_frequencies (送信は一切しません),
  scope_* (受信のみ)
- sstv_sends_current_analog_channel (120 s time-out, cool-down)
- editor_save_note (narrow on VHF makes the radio deaf), editor_vfo_note
- pkt_parrot_sub, pkt_fox_sub (送信が必要)
- settings_take_over_gives_radio, settings_hand_back_ask
- channels_delete_ask, sstv_delete_ask, editor_delete_ask*, settings_restore_*, settings_restore_replaces_every_channel
  (元に戻せません / 置き換わります)
- messages_your_callsign_comes_from, pkt_set_note (the password and passcode are never shown, logged or backed up)

## Notes for the translation agent
- `map_openstreetmap_contributors` stays English: it is the attribution OSM requires.
- `trans_newest` has no leading space: it begins with a full-width （, which needs none.
- `sstv_comb_only_one` has no trailing space: nothing follows 。 in Japanese.
- 2 m / 70 cm in prose became 144 MHz 帯 / 430 MHz 帯 (glossary §3): log_pota_nobody*, sat_cond_trails,
  pkt_set_no_autoack.
- "(you)" in pkt_wsjt_x_mode_phone stays as 「(you)」, because WebHost.java inserts that literal.
