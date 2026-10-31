# Back-check: ja, strings_common.xml, strings.xml, strings_channels.xml, strings_channel_editor.xml

Checked: 592 resources (20 + 1 + 419 + 152, plurals counted once, `other` only). Every string translated back into
English without looking at the source, then compared for meaning, negation, numbers and units.

## Fixes made

| String | Problem in the draft | Fix |
|---|---|---|
| channel_editor_h_rxonly | "a frequency that should stay quiet" came back as "a frequency where you must not transmit" (stronger than English) | 送信を控えるべき周波数 |
| channels_region_wx_no | "Show all" named as 「すべて表示」, but the Add-a-zone button is 「すべてのリストを表示」 (strings_intercom) | now quotes 「すべてのリストを表示」 |
| all ` ` strings in strings_channels.xml | the write tool turned ` ` into plain spaces (13 strings lost them; three trailing ones disappeared) | restored by script (chr(92)); count now matches English in every string |
| channels_codeplug_notes / _net / _net_notes | three leading spaces collapsed into a wrong escape order after the first repair | restored to `   ` |
| channels_region_list_sep, channels_codeplug_sep | lost the trailing ` ` | restored `, ` (half-width comma: the details are ASCII runs) |

## Deliberate differences from English (not errors)
- channels_net_day_sep: 「、」 with no ` ` (weekdays are kanji: 「月、水」).
- channels_store_quickchat_no_contacts: ends 「…ありません。」 instead of "; " + space: the next note follows directly,
  as Japanese writes it.
- `\'` and `\"` escapes dropped: Japanese uses 「」 and has no apostrophes.
- Weekly schedules use 毎週月曜 etc.; the short weekday names are single kanji (日 月 火 水 木 金 土).
- IARU "Region 1" → 「IARU 第 1 地域」 (the Japanese way of naming IARU regions).

## Safety / transmit / licence strings checked twice
channel_editor_h_rxonly, channel_editor_o_rx_only, channel_editor_h_enc (encryption prohibited on amateur
frequencies), channel_editor_h_relay (may not transmit at all), channel_editor_h_band (VHF always wide),
channel_editor_h_power, channel_editor_h_noslot, channels_region_free_caution, channels_region_intro (never
transmits; licence responsibility), channels_region_free_footer, channels_preset_licence_* , channels_preset_gmrs_licence,
channels_preset_biz_about / _biz_licence, channels_preset_cb_licence, channels_preset_pmr_licence,
channels_preset_murs_about (kept "米国で免許不要"), channels_preset_marine_about (not a marine radio),
channels_preset_wx_about, channels_preset_rail_about, channels_preset_sat_about (cross-band untested),
channels_bandplan_do_not_transmit, _no_fm_here, _keep_fm_off, _not_fm, _satellites_only_no_terrestrial_fm,
_receive_only, _receive_only_radio, _licensed_users_only, _licensed_users_only_public_safety (「絶対に妨害しないでください」),
_murs_licence_free_2_w, _gmrs_needs_fcc_licence_frs, _fcc_gmrs_licence_needed, channels_list_badge_rx_only,
channels_list_badge_wx_rx_only, channels_list_delete_message (cannot be undone), channels_share_intro (encryption keys
never included), channels_region_locked (Restricted mode).

## Labels likely too long (style §5)
- channels_list_sel_star 「お気に入り」 (5 glyphs) in a four-button row (limit 4). Glossary term; no shorter form exists
  without inventing one.
- channels_list_menu_unstar 「★解除」: 「お気に入り解除」 (7) does not fit a four-button row; uses the star the app
  already shows for the Favourites zone. Reviewer: confirm or choose another.
- channel_editor_open_maps 「マップで開く」 (6 glyphs, three buttons share a row) — glossary "Open in maps".

## Unsure / for the reviewer
- channel_editor_got_it 「了解」 (alternative 「OK」).
- channels_list_on_air 「使用中」 for the ON AIR tag of the tuned channel (オンエア is longer and could suggest transmitting).
- channels_tg_kind_all 「一斉」 (short form of 一斉呼出, glossary ❓ オールコール).
- channels_bandplan_*_linear_translator_* → リニアトランスポンダー (the usual Japanese satellite word).
- channel_editor_l_ctype 「連絡先種別」 (literal "contact type"; 呼出種別 would read more naturally).
