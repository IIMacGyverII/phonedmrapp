# Length check: ja buttons, tabs, chips and pills (consistency pass, 2026-10-31)

For the screen check. Every control label (the English comment's first sentence names a button, tab, chip, pill,
badge or toggle) whose Japanese is wider than style §5.2's aim: English letters ÷ 2 in glyphs (ASCII and spaces count
half), or 4 glyphs in the four- and six-button rows (marked ≤ 4). 288 labels; most are glossary terms with no shorter
natural form (チャンネル, メッセージ, ダウンロード), so they are listed, not cut. Shortened in this pass by style §5.2
step 1 (particle dropped): device_diag_bring_up 無線を起動 → 無線起動; intercom_nets_run ロールコールを運用 →
ロールコール運営. The two ≤ 4 rows at the top have no natural shorter form (style §5.2 step 6).

| File | Key | English | Japanese | Glyphs | Aim | Row / place |
|---|---|---|---|---|---|---|
| device | `device_diag_release` | Release (stock app on) | 解放（純正アプリ有効） | 11 | ≤ 4 (row) | One of four buttons in a row: short |
| channels | `channels_list_sel_star` | Star | お気に入り | 5 | ≤ 4 (row) | four buttons share a row |
| channels | `channels_region_wx_no` | No: hide them (still under Show all) | なし：非表示にする（「すべてのリストを表示」には残ります） | 29 | 18 | Choice in the Weather radio dialog; Show all is a button on  |
| packet | `packet_pkt_fox` | Fox hunt | フォックスハンティング | 11 | 4 | two buttons share a row |
| packet | `packet_pkt_activating` | Activating %1$s | %1$s をアクティベーション中 | 13.5 | 7.5 | two buttons share a row |
| device | `device_fw_download_factory` | Download factory image | 純正ファームウェアをダウンロード | 16 | 11 | Module firmware page, button that downloads the verified fac |
| channel_editor | `channel_editor_add_net` | Add a net | ロールコールを追加 | 9 | 4.5 | Button in the Nets section. |
| modes | `modes_sstv_dec_any` | Any mode (header) | すべてのモード（ヘッダー） | 13 | 8.5 | Half width |
| web | `map_tune_channel` | Tune channel {n} | チャンネル {n} に合わせる | 12.5 | 8 | Button on a channel card on the map. |
| intercom | `intercom_nets_add` | Add a net to a channel | チャンネルにロールコールを追加 | 15 | 11 | Button on the Nets sheet that adds a net schedule to a chann |
| modes | `modes_fox_download_terrain` | Download terrain | 地形データをダウンロード | 12 | 8 | Half width |
| modes | `modes_log_export` | Export ADIF | ADIF をエクスポート | 9.5 | 5.5 | Half width |
| packet | `packet_pkt_export_gpx` | Export GPX | GPX をエクスポート | 9 | 5 | Button under the stations list that saves them as a GPX file |
| web | `intercom_loading_firmware` | LOADING FIRMWARE | ファームウェア書き込み中 | 12 | 8 | State badge on the radio panel. |
| web | `log_export_adif` | Export ADIF | ADIF をエクスポート | 9.5 | 5.5 | Button. |
| web | `sat_orbits_old` | ORBITS {n} DAYS OLD | 軌道データが {n} 日前のもの | 13.5 | 9.5 | Chip next to the passes heading: |
| channels | `channels_share_copy` | Copy text | テキストをコピー | 8 | 4.5 | Button on the Share channels sheet: |
| intercom | `intercom_nets_run` | Run a net | ロールコール運営 | 8 | 4.5 | half-width |
| modes | `modes_fox_fox_is` | Fox: %1$s | フォックス：%1$s | 8 | 4.5 | Half width |
| packet | `packet_pfd_set_mine` | Use my channels | 自分のチャンネルを使う | 11 | 7.5 | Button that fills in the frequencies of your own analog chan |
| packet | `packet_pkt_is_start` | APRS-IS (internet) | APRS-IS（インターネット） | 12.5 | 9 | two buttons share a row |
| web | `log_net_end` | End the net | ロールコールを終了 | 9 | 5.5 | Button. |
| web | `log_net_start` | Start a net on this channel | このチャンネルでロールコールを開始 | 17 | 13.5 | Button. |
| web | `settings_back_up_now` | Back up now | 今すぐバックアップ | 9 | 5.5 | Button. |
| device | `device_fw_download_tag` | Download %1$s | %1$s をダウンロード | 9.5 | 6.5 | Module firmware page, button that downloads the chosen catal |
| intercom | `intercom_lastheard_activity` | Activity | アクティビティ | 7 | 4 | One of three buttons in a row: short |
| intercom | `intercom_lastheard_tune` | Tune %1$s | %1$s に合わせる | 7.5 | 4.5 | Button on an alert's details sheet that tunes the channel it |
| modes | `modes_fox_download_terrain_size` | Download terrain (about %1$s MB) | 地形データをダウンロード（約 %1$s MB） | 19 | 16 | Half width |
| modes | `modes_pota_end_activation` | End the activation | アクティベーションを終了 | 12 | 9 | Full width |
| packet | `packet_cov_export` | Export | エクスポート | 6 | 3 | two share a row |
| packet | `packet_pkt_conditions` | VHF/UHF conditions | VHF/UHF のコンディション | 12 | 9 | two buttons share a row |
| packet | `packet_pkt_object` | Object… | オブジェクト… | 6.5 | 3.5 | two buttons share a row |
| packet | `packet_pkt_pager_hear` | Hear pages | ページャーを受信 | 8 | 5 | two buttons share a row |
| packet | `packet_pkt_pocsag_page` | POCSAG page | POCSAG ページャー | 8.5 | 5.5 | two buttons share a row |
| web | `channels_star` | Star | お気に入り | 5 | 2 | Button. |
| web | `contacts_text` | Text | メッセージ | 5 | 2 | Button. |
| web | `log_pota_download_adif` | Download ADIF | ADIF をダウンロード | 9.5 | 6.5 | Button; ADIF is the log file format. |
| web | `log_pota_end_activation` | End the activation | アクティベーションを終了 | 12 | 9 | Button on the activation card. |
| web | `map_repeaters_here` | Repeaters here | この付近のレピーター | 10 | 7 | Button. |
| web | `messages_download_log` | Download log | ログをダウンロード | 9 | 6 | Button. |
| web | `messages_page_chip` | PAGE | ページャー | 5 | 2 | Chip on a conversation that is a pager (POCSAG) thread. |
| web | `pkt_keyer_upload` | Upload | アップロード | 6 | 3 | Button that picks an audio file for a keyer slot. |
| web | `sstv_upload` | Upload… | アップロード… | 6.5 | 3.5 | Button. |
| web | `trans_download_txt` | Download .txt | .txt をダウンロード | 9.5 | 6.5 | Button. |
| channel_editor | `channel_editor_tg_lists_button` | Talkgroup lists… | トークグループリスト… | 10.5 | 8 | Button under the RX group list: |
| channels | `channels_region_own_keep` | Keep mine | 自分の値を残す | 7 | 4.5 | Dialog button: |
| device | `device_diag_tone` | 1 kHz test tone (3 s) | 1 kHz テストトーン（3 秒） | 13 | 10.5 | One of three in a row: short |
| device | `device_fw_handshake_log` | Handshake log | ハンドシェイクログ | 9 | 6.5 | Module firmware page, button that shows or hides the technic |
| intercom | `intercom_contacts_pager` | PAGER | ページャー | 5 | 2.5 | Chip on a contact card that has pager RICs. |
| modes | `modes_fox_set_fox` | Set the fox | フォックスを設定 | 8 | 5.5 | Half width |
| modes | `modes_log_heard_on` | Log heard: on | 受信局を記録：オン | 9 | 6.5 | Third of a row |
| modes | `modes_pota_activate_park_button` | Activate a park… | 公園をアクティベート… | 10.5 | 8 | Half width |
| packet | `packet_map_use_channel` | Use channel | チャンネルを使用 | 8 | 5.5 | Button on the channel card that switches to it. |
| packet | `packet_pkt_nets_near` | Nets near you | 近くのロールコール | 9 | 6.5 | two buttons share a row |
| web | `editor_add_channel` | Add channel | チャンネルを追加 | 8 | 5.5 | Button that saves a new channel. |
| web | `exam_review_missed` | Review missed | 間違えた問題を復習 | 9 | 6.5 | Button on an exam card: |
| web | `nav_pager` | Pager | ページャー | 5 | 2.5 | Tab in the top bar: |
| web | `trans_on_the_phone_vosk` | On the phone (Vosk) | スマートフォン上（Vosk） | 12 | 9.5 | Button. |
| common | `common_cancel` | Cancel | キャンセル | 5 | 3 | Button that closes a dialog without doing anything. |
| common | `common_import` | Import | インポート | 5 | 3 | Button that imports channels, contacts or a file. |
| device | `device_fw_check_new` | Check for new firmware | 新しいファームウェアを確認 | 13 | 11 | Module firmware page, button that fetches the signed firmwar |
| device | `device_fw_load` | Load | 書き込む | 4 | 2 | one of three buttons in a row |
| device | `device_notes_status_tested` | Tested | テスト済み | 5 | 3 | Status chip on the About this radio sheet: |
| device | `device_update_download` | Download | ダウンロード | 6 | 4 | Confirm button of the update offer: |
| intercom | `intercom_car_scan` | Scan | スキャン | 4 | 2 | Car screen button and media app button that starts a scan. |
| intercom | `intercom_contacts_filter_talkgroups` | TALKGROUPS | トークグループ | 7 | 5 | Filter chip on the Contacts page: |
| intercom | `intercom_help_close` | Close help | ヘルプを閉じる | 7 | 5 | Screen-reader label of the X button that closes the Help pag |
| intercom | `intercom_main_menu` | Menu | メニュー | 4 | 2 | Screen-reader label of the menu button in the new-look inter |
| intercom | `intercom_net_check_in` | Check in | チェックイン | 6 | 4 | Button next to the callsign field that checks the station in |
| modes | `modes_fox_chip_plot` | Plot | プロット | 4 | 2 | Chip on the map that switches to the plot. |
| modes | `modes_fox_chip_plot_caps` | PLOT | プロット | 4 | 2 | The same chip on the map (capitals). |
| modes | `modes_fox_download` | Download | ダウンロード | 6 | 4 | Dialog button: |
| modes | `modes_fox_pill_heat` | Heat map | ヒートマップ | 6 | 4 | Third of a row |
| modes | `modes_ft8_clear_list` | Clear list | リストをクリア | 7 | 5 | Half width |
| modes | `modes_log_heard_off` | Log heard: off | 受信局を記録：オフ | 9 | 7 | Third of a row |
| modes | `modes_pota_start` | Start the activation | アクティベーションを開始 | 12 | 10 | Full width |
| modes | `modes_satd_ariss_status` | ARISS status | ARISS ステータス | 8 | 6 | Third of a row |
| modes | `modes_sstv_use_channel` | Use this channel | このチャンネルを使用 | 10 | 8 | Half width |
| modes | `modes_wl_gateways` | Gateways | ゲートウェイ | 6 | 4 | Third of a row |
| packet | `packet_cov_test` | Key-up test here | ここでアクセステスト | 10 | 8 | Button on the coverage sheet that transmits a short test. |
| packet | `packet_msg_ric_mute` | Mute | ミュート | 4 | 2 | Dialog button that mutes pages from this address. |
| packet | `packet_pkt_band_scope` | Band scope | バンドスコープ | 7 | 5 | two buttons share a row |
| packet | `packet_pkt_clear_list` | Clear list | リストをクリア | 7 | 5 | Button under the stations list that empties it. |
| packet | `packet_pkt_iss_beacon` | Beacon via ISS | ISS 経由でビーコン | 9 | 7 | two buttons share a row |
| packet | `packet_pkt_schedules_n` | Schedules (%1$d)… | スケジュール（%1$d）… | 10.5 | 8.5 | two buttons share a row |
| service | `service_notif_scan` | Scan | スキャン | 4 | 2 | Button on the radio notification: |
| web | `common_cancel` | Cancel | キャンセル | 5 | 3 | Button. |
| web | `common_download` | Download | ダウンロード | 6 | 4 | Button. |
| web | `editor_tune` | Tune | 合わせる | 4 | 2 | Button: |
| web | `exam_mt_play` | Play a lesson (10 groups) | レッスンを再生（10 グループ） | 14.5 | 12.5 | Button in the Morse trainer. |
| web | `log_net_check_in` | Check in | チェックイン | 6 | 4 | Button that adds a station to the net. |
| web | `log_start_the_activation` | Start the activation | アクティベーションを開始 | 12 | 10 | Button. |
| web | `messages_gateways` | Gateways | ゲートウェイ | 6 | 4 | Button. |
| web | `pager_sent_chip` | SENT | 送信済み | 4 | 2 | Chip on a page that was sent. |
| web | `pkt_id_idle` | ID TIMER IDLE | ID タイマー停止中 | 8.5 | 6.5 | Chip next to the voice keyer heading. |
| web | `trans_download_use` | Download and use | ダウンロードして使用 | 10 | 8 | Button on a caption model. |
| channel_editor | `channel_editor_open_maps` | Open Maps | マップで開く | 6 | 4.5 | three share a row |
| channel_editor | `channel_editor_paste` | Paste | 貼り付け | 4 | 2.5 | three share a row |
| channels | `channels_contact_message` | Message | メッセージ | 5 | 3.5 | three buttons share a row |
| channels | `channels_list_filter_all` | ALL | すべて | 3 | 1.5 | Filter chip above the channel list (capitals): |
| channels | `channels_list_sel_all` | All | すべて | 3 | 1.5 | Selection bar button: |
| channels | `channels_region_reset` | Reset | リセット | 4 | 2.5 | Chip on a Region value: |
| channels | `channels_rep_filter_all` | All | すべて | 3 | 1.5 | Filter chip on the Nearby repeaters sheet: |
| channels | `channels_rep_map` | Map | マップ | 3 | 1.5 | Button on the repeater details sheet: |
| channels | `channels_share_quick_all` | All | すべて | 3 | 1.5 | four chips share a row |
| common | `common_not_now` | Not now | 今はしない | 5 | 3.5 | Button that declines an offer for now. |
| device | `device_checks_with_trial` | Checks + trial | チェック + 試運転 | 8.5 | 7 | Button in the checks dialog: |
| device | `device_diag_car_message` | Post a test car message | 車にテストメッセージを送る | 13 | 11.5 | Diagnostics page, full-width pill button that posts a test m |
| device | `device_exit_off` | Turn the radio off and exit | 無線モジュールをオフにして終了 | 15 | 13.5 | full width |
| device | `device_fw_unlisted_on` | Allow unlisted images · on | 未登録のイメージを許可 · オン | 14.5 | 13 | Module firmware page, switch button for loading files that a |
| device | `device_probe_run` | Probe | プローブ | 4 | 2.5 | Button: |
| device | `device_second_ready` | Ready | 準備完了 | 4 | 2.5 | Button in a second radio test step: |
| device | `device_txtest_leave_empty` | Leave empty | 空欄のまま進む | 7 | 5.5 | Transmit test session, button under a question form: |
| device | `device_txtest_release` | Release now | 今すぐ送信停止 | 7 | 5.5 | Transmit test session, the button that stops the transmissio |
| intercom | `intercom_car_stop_scan` | Stop scan | スキャン停止 | 6 | 4.5 | Car screen button and media app button that stops the scan. |
| intercom | `intercom_contacts_filter_all` | ALL | すべて | 3 | 1.5 | Filter chip on the Contacts page: |
| intercom | `intercom_main_look_classic` | Classic | クラシック | 5 | 3.5 | Button of the intercom look dialog: |
| intercom | `intercom_net_start` | Start the net | ロールコール開始 | 8 | 6.5 | Button on the Net control sheet that starts the net. |
| modes | `modes_forms_new_radiogram` | New radiogram | 新規ラジオグラム | 8 | 6.5 | half-width |
| modes | `modes_forms_read_on_air` | Read on air | 無線で読み上げ | 7 | 5.5 | Button and sheet title: |
| modes | `modes_fox_beacon_stop` | Stop the fox beacon | フォックス送信機を停止 | 11 | 9.5 | Full width |
| modes | `modes_fox_chip_map_caps` | MAP | マップ | 3 | 1.5 | The same chip on the plot, back to the map (capitals). |
| modes | `modes_fox_spin_fit` | Fit now | 今すぐ算出 | 5 | 3.5 | Half width |
| modes | `modes_fox_spin_save` | Save mark | マークを保存 | 6 | 4.5 | Half width |
| modes | `modes_ft8_send_text` | Send text | テキスト送信 | 6 | 4.5 | Third of a row |
| modes | `modes_morse_again` | Again | もう一度 | 4 | 2.5 | Half width |
| modes | `modes_pota_activate_summit_button` | Activate a summit… | 山頂をアクティベート… | 10.5 | 9 | Half width |
| modes | `modes_satd_update` | Update orbits | 軌道データを更新 | 8 | 6.5 | Full width |
| modes | `modes_scope_clear_peaks` | Clear peaks | ピークをクリア | 7 | 5.5 | Half width |
| modes | `modes_wl_connect_internet` | Connect: internet | 接続：インターネット | 10 | 8.5 | Half width |
| modes | `modes_wl_new_message` | New message | 新規メッセージ | 7 | 5.5 | Third of a row |
| modes | `modes_wl_session_log` | Session log | セッションログ | 7 | 5.5 | Full width |
| packet | `packet_aprs_chip_no_autoack` | No auto-ack (UHF) | 自動 ACK なし（UHF） | 10 | 8.5 | Chip shown on a UHF-only radio, where auto-ack is off. |
| packet | `packet_aprs_map` | Map | マップ | 3 | 1.5 | three share a row |
| packet | `packet_aprs_message` | Message | メッセージ | 5 | 3.5 | three share a row |
| packet | `packet_pkt_dtmf_saved` | Saved… | 保存済み… | 4.5 | 3 | three share a row |
| packet | `packet_pkt_keyer` | Voice keyer | ボイスメモリー | 7 | 5.5 | two buttons share a row |
| packet | `packet_pkt_morse_id` | Send my callsign in Morse | コールサインをモールスで送信 | 14 | 12.5 | two buttons share a row |
| packet | `packet_pkt_net_running` | Net running: %1$s | ロールコール中：%1$s | 10 | 8.5 | two buttons share a row |
| packet | `packet_pkt_schedules` | Schedules… | スケジュール… | 6.5 | 5 | two buttons share a row |
| packet | `packet_pkt_telemetry` | Telemetry | テレメトリー | 6 | 4.5 | two buttons share a row |
| service | `service_notif_stop_scan` | Stop scan | スキャン停止 | 6 | 4.5 | Button on the radio notification while scanning. |
| web | `channels_new_channel` | New channel | 新規チャンネル | 7 | 5.5 | Button. |
| web | `channels_out_of_zone` | Out of zone | ゾーンから除外 | 7 | 5.5 | Button. |
| web | `channels_save_zone` | Save zone | ゾーンを保存 | 6 | 4.5 | Button. |
| web | `common_all` | All | すべて | 3 | 1.5 | Button. |
| web | `editor_about_aria` | About {label} | {label} について | 8 | 6.5 | Screen-reader label of the (i) button next to a field; {labe |
| web | `editor_channel_n` | CHANNEL {n} | チャンネル {n} | 7 | 5.5 | Chip next to the editor heading; {n} is the channel number. |
| web | `map_fit_all` | Fit all | 全体を表示 | 5 | 3.5 | Button. |
| web | `messages_connect_internet` | Connect: internet | 接続：インターネット | 10 | 8.5 | Button. |
| web | `messages_new_message` | New message | 新規メッセージ | 7 | 5.5 | Button. |
| web | `messages_new_radiogram` | New radiogram | 新規ラジオグラム | 8 | 6.5 | Button. |
| web | `messages_session_log` | Session log | セッションログ | 7 | 5.5 | Button. |
| web | `nav_map` | Map | マップ | 3 | 1.5 | Tab in the top bar: |
| web | `nav_scope` | Scope | スコープ | 4 | 2.5 | Tab in the top bar: |
| web | `sat_update_orbits` | Update orbits | 軌道データを更新 | 8 | 6.5 | Button. |
| web | `scope_clear_peaks` | Clear peaks | ピークをクリア | 7 | 5.5 | Button. |
| web | `top_log_out` | Log out | ログアウト | 5 | 3.5 | Button. |
| channels | `channels_list_badge_wide` | WIDE | ワイド | 3 | 2 | Detail chip in the channel menu (capitals): |
| channels | `channels_list_filter_analog` | ANALOG | アナログ | 4 | 3 | Filter chip above the channel list (capitals): |
| channels | `channels_share_quick_analog` | Analog | アナログ | 4 | 3 | four chips share a row |
| device | `device_checks_run` | Run checks | チェック実行 | 6 | 5 | Button in the checks dialog. |
| device | `device_exit` | Exit SignalDeck | SignalDeck を終了 | 8.5 | 7.5 | Button on the link card and title of the exit sheet: |
| device | `device_fw_unlisted_off` | Allow unlisted images · off | 未登録のイメージを許可 · オフ | 14.5 | 13.5 | Module firmware page, switch button for loading files that a |
| device | `device_learn_use` | Use this key | このキーを使用 | 7 | 6 | Button on the Learn a PTT key sheet: |
| device | `device_listen_send` | Send now | 今すぐ送る | 5 | 4 | Button after the listen check: |
| device | `device_main_tab_channels` | Channels | チャンネル | 5 | 4 | Bottom tab: |
| device | `device_main_tab_device` | Device | デバイス | 4 | 3 | Bottom tab: |
| device | `device_main_tab_messages` | Messages | メッセージ | 5 | 4 | Bottom tab: |
| device | `device_probe_pulse` | Probe + power pulse | 応答確認 + 電源パルス | 10.5 | 9.5 | Button: |
| device | `device_title` | Device | デバイス | 4 | 3 | Title in the Device page header (the tab's page). |
| device | `device_variant_open` | Open GitHub | GitHub を開く | 6.5 | 5.5 | Button: |
| intercom | `intercom_car_channels` | Channels | チャンネル | 5 | 4 | Title of the car screen channel list (the zones) and the but |
| intercom | `intercom_carart_paused` | PAUSED | 一時停止 | 4 | 3 | State badge on the car's now-playing picture: |
| intercom | `intercom_carart_scanning` | SCANNING | スキャン中 | 5 | 4 | State badge on the car's now-playing picture: |
| intercom | `intercom_help_all_topics` | All topics | トピック一覧 | 6 | 5 | Back button (screen-reader label) and the button at the end  |
| intercom | `intercom_main_look_new` | New look | 新デザイン | 5 | 4 | Button of the intercom look dialog: |
| intercom | `intercom_net_report` | Report | レポート | 4 | 3 | half-width |
| intercom | `intercom_zones_add` | Add a zone | ゾーンを追加 | 6 | 5 | Button that opens the Add a zone sheet; also that sheet's ti |
| modes | `modes_forms_send_dmr` | Send by DMR text | DMR テキストで送信 | 9 | 8 | Half-width |
| modes | `modes_fox_beacon_start` | Start the fox beacon | フォックス送信機を開始 | 11 | 10 | Full width |
| modes | `modes_fox_beeper_on` | Beeper on | ビープ オン | 5.5 | 4.5 | Third of a row |
| modes | `modes_fox_mark` | Mark | マーク | 3 | 2 | Third of a row |
| modes | `modes_fox_spin_again` | Spin again | もう一度回る | 6 | 5 | Half width |
| modes | `modes_ft8_call_cq` | Call CQ | CQ を出す | 4.5 | 3.5 | Third of a row |
| modes | `modes_ft8_period_first` | TX 1st (:00 :30) | TX 前半（:00 :30） | 9 | 8 | Third of a row |
| modes | `modes_ft8_period_second` | TX 2nd (:15 :45) | TX 後半（:15 :45） | 9 | 8 | Third of a row |
| modes | `modes_log_mode` | Mode: %1$s | モード：%1$s | 6 | 5 | Full width |
| modes | `modes_sstv_use_in` | In | 使用 | 2 | 1 | Toggle button: |
| modes | `modes_wl_gw_import` | Import the CSV | CSV をインポート | 8 | 7 | Half width |
| modes | `modes_wl_gw_open` | Open winlink.org | winlink.org を開く | 9 | 8 | Half width |
| packet | `packet_aprs_beacon` | Beacon | ビーコン | 4 | 3 | three share a row |
| packet | `packet_aprs_chip_beacon_off` | Beacon off | ビーコンオフ | 6 | 5 | Chip: |
| packet | `packet_aprs_chip_digi` | Digipeater | デジピーター | 6 | 5 | Chip: |
| packet | `packet_aprs_tab_live` | LIVE | ライブ | 3 | 2 | three share a row |
| packet | `packet_aprs_tab_messages` | MESSAGES | メッセージ | 5 | 4 | three share a row |
| packet | `packet_map_pill_channels` | Channels | チャンネル | 5 | 4 | five share a scrolling row |
| packet | `packet_map_pill_channels_n` | Channels %1$d | チャンネル %1$d | 7.5 | 6.5 | Channels filter pill: |
| packet | `packet_map_pill_help` | Help | ヘルプ | 3 | 2 | five share a scrolling row |
| packet | `packet_pkt_dtmf_remote` | Remote… | リモート… | 4.5 | 3.5 | three share a row |
| packet | `packet_pkt_parrot_start` | Parrot on this channel | このチャンネルでパロット | 12 | 11 | two buttons share a row |
| packet | `packet_pkt_send_message` | Send message | メッセージ送信 | 7 | 6 | two buttons share a row |
| packet | `packet_pkt_winlink_new` | Winlink (%1$d new) | Winlink（新着 %1$d） | 10 | 9 | two buttons share a row |
| packet | `packet_toggle_on` | ON | オン | 2 | 1 | State pill of a switch on the packet sheets: |
| web | `channels_analog` | Analog | アナログ | 4 | 3 | Button. |
| web | `channels_new_zone` | New zone | 新規ゾーン | 5 | 4 | Button. |
| web | `common_on_chip` | ON | オン | 2 | 1 | Chip or choice: |
| web | `exam_mt_again` | Play again | もう一度再生 | 6 | 5 | Button in the Morse trainer. |
| web | `log_net_none_running` | NO NET RUNNING | ロールコールなし | 8 | 7 | Chip next to the net control heading. |
| web | `login_log_in` | Log in | ログイン | 4 | 3 | Button. |
| web | `messages_go` | Go | 実行 | 2 | 1 | Button. |
| web | `nav_channels` | Channels | チャンネル | 5 | 4 | Tab in the top bar: |
| web | `nav_help` | Help | ヘルプ | 3 | 2 | Tab in the top bar: |
| web | `nav_messages` | Messages | メッセージ | 5 | 4 | Tab in the top bar: |
| web | `nav_packet` | Packet | パケット | 4 | 3 | Tab in the top bar: |
| web | `pkt_call_cq` | Call CQ | CQ を出す | 4.5 | 3.5 | Button. |
| web | `sstv_decode` | Decode | デコード | 4 | 3 | Button on a recording: |
| web | `trans_save_key` | Save key | キーを保存 | 5 | 4 | Button. |
| web | `web_ptt_up` | PTT up | PTT オフ | 4 | 3 | Reply when the web PTT button is released. |
| channels | `channels_list_badge_rx_only` | RX ONLY | 受信専用 | 4 | 3.5 | Badge on a channel card (small chip, shown in capitals). |
| channels | `channels_list_badge_wx_rx_only` | WX · RX ONLY | WX · 受信専用 | 6.5 | 6 | Badge on a channel card (small chip, shown in capitals). |
| common | `common_add` | Add | 追加 | 2 | 1.5 | Button that adds a new item. |
| common | `common_clear` | Clear | クリア | 3 | 2.5 | Button that empties a list or a field. |
| common | `common_close` | Close | 閉じる | 3 | 2.5 | Button that closes a sheet or dialog. |
| device | `device_checks_only` | Checks only | チェックのみ | 6 | 5.5 | Button in the checks dialog: |
| device | `device_diag_backup_check` | Check backup round trip | バックアップの往復を確認 | 12 | 11.5 | Diagnostics page, full-width pill button: |
| device | `device_fwfiles_copy` | Copy ticked | 選択をコピー | 6 | 5.5 | Button: |
| device | `device_listen_part2_start` | Start part 2 | パート 2 開始 | 6.5 | 6 | Button that starts part 2 of the listen check. |
| device | `device_profsheet_check` | Check now | 今すぐ確認 | 5 | 4.5 | Button in the Phone profile dialog: |
| device | `device_share_all` | Share all | すべて共有 | 5 | 4.5 | Button: |
| device | `device_support` | Help support this phone | この端末の対応に協力する | 12 | 11.5 | Button on the link card (unsupported or untested phone) and  |
| device | `device_txtest_no_file` | No file after all | ファイルなしで進む | 9 | 8.5 | Transmit test session, recording sheet, button: |
| device | `device_txtest_share_zip` | Share the report zip | レポートの zip を共有 | 10.5 | 10 | Transmit test results sheet, button that shares the whole de |
| intercom | `intercom_carart_low_pwr` | LOW PWR | 出力ロー | 4 | 3.5 | Chip on the car's now-playing picture: |
| intercom | `intercom_carart_ready` | READY | 待機中 | 3 | 2.5 | State badge on the car's now-playing picture: |
| intercom | `intercom_main_chip_low_power` | LOW PWR | 出力ロー | 4 | 3.5 | Chip under the channel number: |
| intercom | `intercom_main_model_use` | Use | 使用 | 2 | 1.5 | Button of the live-caption model picker: |
| intercom | `intercom_main_panel_restore` | Show the activity box | アクティビティ欄を表示 | 11 | 10.5 | Screen-reader label of the small button that brings the hidd |
| intercom | `intercom_net_end_button` | End | 終了 | 2 | 1.5 | Button in the end-the-net dialog. |
| intercom | `intercom_net_flag_out` | Out | 退出 | 2 | 1.5 | Flag chip on a check-in row: |
| intercom | `intercom_net_flag_traffic` | Traffic | 連絡あり | 4 | 3.5 | Flag chip on a check-in row: |
| intercom | `intercom_netedit_day_fri` | F | 金 | 1 | 0.5 | Weekday button: |
| intercom | `intercom_netedit_day_mon` | M | 月 | 1 | 0.5 | Weekday button: |
| intercom | `intercom_netedit_day_sat` | S | 土 | 1 | 0.5 | Weekday button: |
| intercom | `intercom_netedit_day_thu` | T | 木 | 1 | 0.5 | Weekday button: |
| intercom | `intercom_netedit_day_tue` | T | 火 | 1 | 0.5 | Weekday button: |
| intercom | `intercom_netedit_day_wed` | W | 水 | 1 | 0.5 | Weekday button: |
| modes | `modes_forms_new_ics` | New ICS-213 | 新規 ICS-213 | 6 | 5.5 | half-width |
| modes | `modes_fox_auto_every` | Auto-mark every %1$d m | %1$d m ごとに自動マーク | 11.5 | 11 | Half width |
| modes | `modes_fox_auto_off` | Auto-marks off | 自動マーク オフ | 7.5 | 7 | Half width |
| modes | `modes_fox_beeper_off` | Beeper off | ビープ オフ | 5.5 | 5 | Third of a row |
| modes | `modes_fox_clear_marks` | Clear marks | マークを消去 | 6 | 5.5 | Third of a row |
| modes | `modes_fox_last_caller` | Last caller %1$s | 最後の送信局 %1$s | 8.5 | 8 | Dialog button: |
| modes | `modes_fox_off_freq` | Off-frequency | 周波数をずらす | 7 | 6.5 | Third of a row |
| modes | `modes_ft8_halt` | Halt TX | 送信停止 | 4 | 3.5 | Third of a row |
| modes | `modes_morse_key` | KEY | 電鍵 | 2 | 1.5 | The big Morse key button (capitals). |
| modes | `modes_morse_play` | Play 5 groups | 5 グループ再生 | 7 | 6.5 | Half width |
| modes | `modes_pota_end` | End | 終了 | 2 | 1.5 | Dialog button: |
| modes | `modes_wl_ask_on` | Turn on the log | ログをオンにする | 8 | 7.5 | Dialog button: |
| modes | `modes_wl_log_share` | Share log | ログを共有 | 5 | 4.5 | Full width |
| packet | `packet_aprs_chip_beacon_min` | Beacon %1$d min | ビーコン %1$d 分 | 8 | 7.5 | Chip: |
| packet | `packet_cov_set` | Set | 設定 | 2 | 1.5 | Last choice pill (and dialog button) that takes any number. |
| packet | `packet_map_pill_repeaters` | Repeaters | レピーター | 5 | 4.5 | five share a scrolling row |
| packet | `packet_map_pill_repeaters_n` | Repeaters %1$d | レピーター %1$d | 7.5 | 7 | Repeaters filter pill: |
| packet | `packet_pkt_aprs_log` | APRS log | APRS ログ | 4.5 | 4 | two buttons share a row |
| packet | `packet_pkt_forms` | ICS-213 and radiograms (%1$d) | ICS-213 とラジオグラム（%1$d） | 15 | 14.5 | two buttons share a row |
| packet | `packet_pkt_monitor` | Monitor %1$s | %1$s をワッチ | 6.5 | 6 | two buttons share a row |
| packet | `packet_set_power_low` | Low | ロー | 2 | 1.5 | Choice pill: |
| packet | `packet_toggle_off` | OFF | オフ | 2 | 1.5 | State pill of a switch on the packet sheets: |
| web | `aprs_monitor_aprs` | Monitor APRS | APRS をワッチ | 6.5 | 6 | Button. |
| web | `aprs_monitor_freq` | Monitor {mhz} | {mhz} をワッチ | 7 | 6.5 | Button that starts APRS monitoring on frequency {mhz} (e.g. |
| web | `aprs_send_beacon` | Send beacon | ビーコン送信 | 6 | 5.5 | Button. |
| web | `channels_add_to_zone` | Add to zone | ゾーンに追加 | 6 | 5.5 | Button. |
| web | `common_add` | Add | 追加 | 2 | 1.5 | Button. |
| web | `common_clear` | Clear | クリア | 3 | 2.5 | Button. |
| web | `common_close` | Close | 閉じる | 3 | 2.5 | Button. |
| web | `common_log` | Log | 記録 | 2 | 1.5 | Button. |
| web | `common_new` | New | 新規 | 2 | 1.5 | Button. |
| web | `common_off_chip` | OFF | オフ | 2 | 1.5 | Chip next to a heading: |
| web | `log_net_out` | Out | 退出 | 2 | 1.5 | Flag button on a check-in: |
| web | `log_net_traffic` | Traffic | 連絡あり | 4 | 3.5 | Flag button on a check-in: |
| web | `log_pota_end` | End | 終了 | 2 | 1.5 | Red button of the confirmation card that ends the activation |
| web | `messages_new_ics_213` | New ICS-213 | 新規 ICS-213 | 6 | 5.5 | Button. |
| web | `pager_monitor_chip` | MONITOR | ワッチ中 | 4 | 3.5 | Chip next to the pager heading: |
| web | `pkt_halt_tx` | Halt TX | 送信停止 | 4 | 3.5 | Button. |
| web | `pkt_id_due_in` | ID DUE IN {n} MIN | ID 送出まで {n} 分 | 9 | 8.5 | Chip: |
| web | `settings_check_for_updates` | Check for updates | アップデートを確認 | 9 | 8.5 | Button. |
| web | `trans_use` | Use | 使用 | 2 | 1.5 | Button on a caption model. |
