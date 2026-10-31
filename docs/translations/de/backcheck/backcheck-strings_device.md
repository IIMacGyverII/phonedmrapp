# Back-check: strings_device.xml (de)

Method: each German string was translated back into English without looking at the source, then compared with the
English for meaning, negations, numbers and units. Placeholders and escaping were checked with `de_check.py`
(0 problems, 0 untranslated).

- Strings checked: 703 (696 `<string>` + 7 `<plurals>` with `one` and `other`).
- Meaning changes found and fixed: 10.
- Negations, numbers and units: no difference left (all °C, s, min, MB, kB, dp, %% and the 28 s / 120 s / 2 min / 17 min / 70 °C / 48 °C / 11 °C figures match).

## What changed in the German, and why

| String | Draft said (back-translated) | Fixed to | Why |
|---|---|---|---|
| device_exit_hint | "„Beenden“ stops it properly" | „SignalDeck beenden“ | The English names the Exit SignalDeck button; the German must name its German label. |
| device_profile_advisory_text | "…to read it or to carry on anyway" | "…oder trotzdem weiter zu verwenden" | English is "keep using it anyway", not "carry on". |
| device_audio_intro | "custom ROMs often lack it" | "fehlt er unter Umständen" | "often" was added; English says "may lack it". |
| device_second_intro | "this phone tunes in %1$s" | "deckt %1$s ab" | The figure is the tuning range; "abstimmen" read as tuning to one frequency. |
| device_second_intro | "small power" | "niedrige Leistung" | Glossary: low power = Niedrig. |
| device_modfw_versions | "Factory state:" | "Werk:" | "Stock" is the shipped version, and matches device_firmware_line_*. |
| device_about_legal | "It comes WITHOUT ANY WARRANTY" | "wird OHNE JEDE GEWÄHRLEISTUNG bereitgestellt" | Legal wording: "is provided without", as in GPL German usage. |
| device_firstrun_watch_open, _bridged | "please do NOT press PTT" | "drücke bitte nicht PTT" | Capitals were stronger than the English; the negation is kept early and unchanged. |
| device_diag_power_cycle_msg | "pulls it low and back high" (mixed) | "auf Low und wieder auf High" | Consistent technical wording, meaning unchanged. |
| device_exit_handback_hint_boot | "trotzdem … trotzdem" | "dennoch" in the first | Style only (repeated word); meaning unchanged. |

## SAFETY strings (124), each read a second time against the English: checked twice

- `device_link_fw_not_certified`: checked twice
- `device_link_untested_title`: checked twice
- `device_link_untested_msg`: checked twice
- `device_link_note`: checked twice
- `device_txlimit`: checked twice
- `device_txlimit_sub`: checked twice
- `device_txlimit_locked`: checked twice
- `device_txlimit_default`: checked twice
- `device_txlimit_custom_value`: checked twice
- `device_txlimit_custom`: checked twice
- `device_txlimit_custom_title`: checked twice
- `device_txlimit_custom_msg`: checked twice
- `device_txlimit_custom_bad`: checked twice
- `device_txlimit_none_title`: checked twice
- `device_txlimit_long_title`: checked twice
- `device_web_allow_tx`: checked twice
- `device_web_allow_tx_sub`: checked twice
- `device_report_txtest`: checked twice
- `device_exit_hint`: checked twice
- `device_exit_off_hint`: checked twice
- `device_exit_handback_hint`: checked twice
- `device_exit_handback_hint_boot`: checked twice
- `device_advisory_line`: checked twice
- `device_advisory_line_kept`: checked twice
- `device_advisory_until`: checked twice
- `device_advisory_row_overridden`: checked twice
- `device_advisory_row_active`: checked twice
- `device_advisory_body`: checked twice
- `device_advisory_body_lapses`: checked twice
- `device_advisory_body_kept`: checked twice
- `device_advisory_reapply`: checked twice
- `device_advisory_keep`: checked twice
- `device_advisory_override`: checked twice
- `device_advisory_confirm1`: checked twice
- `device_advisory_confirm1_msg`: checked twice
- `device_advisory_confirm2`: checked twice
- `device_advisory_confirm2_msg`: checked twice
- `device_advisory_confirm2_ok`: checked twice
- `device_advisory_overridden`: checked twice
- `device_second_intro`: checked twice
- `device_status_advisory`: checked twice
- `device_thermal_zone_hot`: checked twice
- `device_thermal_battery_hot`: checked twice
- `device_thermal_stop_zone`: checked twice
- `device_thermal_stop_battery`: checked twice
- `device_thermal_stop_zone_rise`: checked twice
- `device_thermal_stop_battery_rise`: checked twice
- `device_thermal_cooling_zone`: checked twice
- `device_thermal_cooling_timer`: checked twice
- `device_txlimit_heat_warning`: checked twice
- `device_txlimit_none`: checked twice
- `device_firstrun_watch_open`: checked twice
- `device_firstrun_watch_open_bridged`: checked twice
- `device_firstrun_trial_take_over`: checked twice
- `device_firstrun_trial_hand_back`: checked twice
- `device_ptt_check_no_release`: checked twice
- `device_ptt_check_bluetooth`: checked twice
- `device_main_exit_handed_back`: checked twice
- `device_fw_erasing_left`: checked twice
- `device_fw_risk_heading`: checked twice
- `device_fw_disclaimer`: checked twice
- `device_fw_preflight`: checked twice
- `device_fw_unlisted_off`: checked twice
- `device_fw_unlisted_on`: checked twice
- `device_fw_hash_hint`: checked twice
- `device_fw_download_failed`: checked twice
- `device_fw_unlisted_q1_title`: checked twice
- `device_fw_unlisted_q1`: checked twice
- `device_fw_unlisted_q2_title`: checked twice
- `device_fw_unlisted_q2`: checked twice
- `device_fw_unlisted_allow`: checked twice
- `device_fw_type_hash`: checked twice
- `device_fw_confirm`: checked twice
- `device_fw_no_factory_copy`: checked twice
- `device_fw_backup_unread`: checked twice
- `device_fw_backup_mismatch`: checked twice
- `device_fw_variant_unsupported`: checked twice
- `device_fw_file_mismatch`: checked twice
- `device_fw_check_idle_busy`: checked twice
- `device_fw_check_stock_on`: checked twice
- `device_fw_check_backup_missing`: checked twice
- `device_fw_hist_mismatch`: checked twice
- `device_fw_answered_no_copy`: checked twice
- `device_fw_answered_nothing_no_copy`: checked twice
- `device_fw_restored_tag`: checked twice
- `device_fw_restore_failed`: checked twice
- `device_fw_hist_readback`: checked twice
- `device_fw_sample_restored`: checked twice
- `device_fw_sample_restore_failed`: checked twice
- `device_fw_flash_read_at`: checked twice
- `device_fw_flash_differs`: checked twice
- `device_fw_flash_read_error`: checked twice
- `device_fw_fw22_summary`: checked twice
- `device_fw_not_known_image`: checked twice
- `device_fw_recovery_factory_only`: checked twice
- `device_fw_backup_needed_recovery`: checked twice
- `device_fw_stock_gone`: checked twice
- `device_fw_variant_tag`: checked twice
- `device_fw_wrong_model`: checked twice
- `device_fw_wrong_stock_app`: checked twice
- `device_fw_stock_mismatch`: checked twice
- `device_fw_backup_first`: checked twice
- `device_fw_wrong_base`: checked twice
- `device_fw_unlisted_summary`: checked twice
- `device_txtest_title`: checked twice
- `device_txtest_take_over`: checked twice
- `device_txtest_intro`: checked twice
- `device_txtest_before`: checked twice
- `device_txtest_start`: checked twice
- `device_txtest_confirm_rules`: checked twice
- `device_txtest_transmitting`: checked twice
- `device_txtest_release`: checked twice
- `device_diag_bring_up`: checked twice
- `device_diag_release`: checked twice
- `device_diag_tone`: checked twice
- `device_diag_tone_q`: checked twice
- `device_diag_tone_msg`: checked twice
- `device_diag_tone_go`: checked twice
- `device_profile_restrict_profile`: checked twice
- `device_profile_restrict_takeover`: checked twice
- `device_profile_restrict_transmit`: checked twice
- `device_profile_bad_signature`: checked twice
- `device_profile_advisory_title`: checked twice
- `device_profile_advisory_text`: checked twice