# Back-check, French (fr): strings_device.xml, strings_service.xml, strings_web.xml

Each draft string was translated back into English without looking at the source, then compared with the English
source for meaning, negation, numbers and units.

## Count checked
| File | Entries | French words (approx.) |
|---|---|---|
| strings_device.xml | 703 (of which 9 plurals) | 7 870 |
| strings_service.xml | 391 (of which 12 plurals) | 3 200 |
| strings_web.xml | 243 (of which 3 plurals) | 1 425 |
| **Total** | **1 337** | **≈ 12 500** |

`de_check.py … fr`: 0 problems, 0 untranslated for all three files. A typography scan found no plain space before
`: ; ! ?` or `»`, and no straight quotes.

## Fixes made after the back-check
| File | Name | Issue | Fix |
|---|---|---|---|
| device | device_link_fw_not_certified | « n’y a jamais été testée » said "never tested" where the English says "has not been tested" (yet) | « n’y a pas encore été testée » |
| device | device_link_untested_msg | « Prendre la main met %2$s en pause… » was a literal calque (the style guide's own counter-example) | « Quand SignalDeck prend la main, %2$s est mis en pause et les ports série… sont ouverts » |
| device | device_contrib_intro | « S’il vous plaît » reads as "please", not "if you like it" | « Si vous l’appréciez » |
| device | device_txlimit_locked | « verrouillée en mode verrouillé »: the verb echoed the mode name | « ne peut pas être modifiée en mode verrouillé » |
| device | device_fw_fw22_summary | « Une tonalité est encore émise » made it "transmitted"; the English only says it "plays" | « est encore jouée » |
| device | device_txtest_release | « Relâcher » was too weak for the big stop-now button | « Couper l’émission » (glossary: Halt TX) |
| device | device_support_locked_send | « tous les tests, puis un test » was circular | « …puis le test avec une seconde radio ou le test d’écoute » |
| device | device_main_region_roaming | "the network is X's" rendered as a clumsy clause | « réseau mobile : %3$s » |
| device | device_mission | « Notre mission » did not fit the first-person text | « Mission du projet » |
| device | device_set_roaming* | glossary gap: aligned with web (« Itinérance DMR », feminine: activée / désactivée) | done |
| device | device_set_wheel, _wheel_next, _wheel_mic | aligned with the web names of the same settings | « Lecture/pause au volant pour parler », « Suivant au volant pour parler », « Micro pour l’émission au volant » |
| service | service_txlimit_locked | the same echo as the device string | « est bloquée en mode verrouillé » |
| service | service_parrot_off_history | a count placed before a plural noun in a non-plural string was wrong for 1 | « (émissions répétées : %1$d) » |
| service | service_scope_sat_busy | "would retune the radio away from it" had shrunk to « dérèglerait » | « le scope éloignerait la radio de sa fréquence » |
| service | service_iss_beaconing | read as a noun, so the action was lost | « Envoi de la balise via l’ISS (ARISS) » |
| service | service_tg_back | stiff word order | « Retour au numéro d’appel propre de %1$s (%2$d) » |
| service | service_dmr_voice_rx | ungrammatical | « Voix reçue (%1$s) de … » |
| service | service_scan_skip_how | the instruction was a bare noun | imperative « appuyez de manière prolongée » |
| service | service_keyup_needs_repeater | « qui a un emplacement » read badly | « dont l’emplacement est connu » |
| service | service_roam_history | "Roaming" left in English | « Itinérance » |
| service, web | (19 + 4 strings) | a no-break space U+00A0 before `;` and `?` instead of the narrow U+202F | replaced by U+202F |
| web | web_msg_too_long | read as a statement, not an error | « 140 caractères au maximum par message » |
| web | web_set_wheelmic_label | meant "microphone of the wheel controls" | « Micro pour l’émission au volant » |
| web | web_decode_uploaded, web_decode_uploaded_failed | « envoyé » means "sent", not "uploaded" | « importé » |

No changed number, unit or lost negation remained after these fixes.

## Safety strings checked twice
- **strings_device.xml:** device_link_fw_not_certified, device_link_untested_title, device_link_untested_msg, device_link_note,
  device_txlimit, device_txlimit_sub, device_txlimit_locked, device_txlimit_default, device_txlimit_custom_value,
  device_txlimit_custom, device_txlimit_custom_title, device_txlimit_custom_msg, device_txlimit_custom_bad,
  device_txlimit_none_title, device_txlimit_long_title, device_web_allow_tx, device_web_allow_tx_sub, device_report_txtest,
  device_exit_hint, device_exit_off_hint, device_exit_handback_hint, device_exit_handback_hint_boot, device_advisory_line,
  device_advisory_line_kept, device_advisory_until, device_advisory_row_overridden, device_advisory_row_active,
  device_advisory_body, device_advisory_body_lapses, device_advisory_body_kept, device_advisory_reapply,
  device_advisory_keep, device_advisory_override, device_advisory_confirm1, device_advisory_confirm1_msg,
  device_advisory_confirm2, device_advisory_confirm2_msg, device_advisory_confirm2_ok, device_advisory_overridden,
  device_second_intro (licence note), device_status_advisory, all device_thermal_* (8), device_txlimit_heat_warning,
  device_txlimit_none, device_firstrun_watch_open, device_firstrun_watch_open_bridged, device_firstrun_trial_take_over,
  device_firstrun_trial_hand_back, device_ptt_check_no_release, device_ptt_check_bluetooth, device_main_exit_handed_back,
  device_fw_erasing_left, device_fw_risk_heading, device_fw_disclaimer, device_fw_preflight, device_fw_unlisted_off,
  device_fw_unlisted_on, device_fw_hash_hint, device_fw_download_failed, device_fw_unlisted_q1_title, device_fw_unlisted_q1,
  device_fw_unlisted_q2_title, device_fw_unlisted_q2, device_fw_unlisted_allow, device_fw_type_hash, device_fw_confirm,
  device_fw_no_factory_copy, device_fw_backup_unread, device_fw_backup_mismatch, device_fw_variant_unsupported,
  device_fw_file_mismatch, device_fw_check_idle_busy, device_fw_check_stock_on, device_fw_check_backup_missing,
  device_fw_hist_mismatch, device_fw_answered_no_copy, device_fw_answered_nothing_no_copy, device_fw_restored_tag,
  device_fw_restore_failed, device_fw_hist_readback, device_fw_sample_restored, device_fw_sample_restore_failed,
  device_fw_flash_read_at, device_fw_flash_differs, device_fw_flash_read_error, device_fw_fw22_summary,
  device_fw_not_known_image, device_fw_recovery_factory_only, device_fw_backup_needed_recovery, device_fw_stock_gone,
  device_fw_variant_tag, device_fw_wrong_model, device_fw_wrong_stock_app, device_fw_stock_mismatch,
  device_fw_backup_first, device_fw_wrong_base, device_fw_unlisted_summary, all device_txtest_* marked SAFETY (title,
  take_over, intro, before, start, confirm_rules, transmitting, release), device_diag_bring_up, device_diag_release,
  device_diag_tone, device_diag_tone_q, device_diag_tone_msg, device_diag_tone_go, device_profile_restrict_profile,
  device_profile_restrict_takeover, device_profile_restrict_transmit, device_profile_bad_signature,
  device_profile_advisory_title, device_profile_advisory_text.
- **strings_service.xml:**
  - Receive-only: tx_receive_only, tx_blocked_receive_only, receive_only_channel, tx_off_channel, sms_tx_off, sos_receive_only.
  - Needs an analog FM channel: keyer_needs_fm, fox_needs_fm, parrot_needs_fm.
  - Transmit limit: txlimit_locked, txlimit_minimum, tx_too_long_limit, tx_too_long_sender, page_too_long,
    page_over_limit, tones_over_limit.
  - Outside the radio's bands: sat_out_of_band, iss_out_of_band, iss_link_out_of_band, iss_beacon_not_tuned,
    aprs_out_of_band, freq_outside, page_out_of_band, zone_untunable(_history), no_tunable_channel, channel_untunable,
    channel_outside(_still), sched_skip_band, sched_skipped_band, sched_no_aprs, sched_channel_outside,
    sched_winlink_not_moved.
  - M17: m17_receive_only, m17_needs_fw(_history), m17_needs_analog(_history).
  - Profile and module: tx_untested_profile, tx_module_timeout.
  - Heat and busy channel: heat_stop, heat_cap, tx_held, channel_busy.
  - Emergency: every sos_* result.
- **strings_web.xml:** web_tx_off, web_restricted, web_firmware_busy, web_not_while_tx, web_sat_receive_only,
  web_channel_receive_only, web_talk_busy, web_history_talk_mic, web_history_web_tx, web_confirm_first,
  web_login_wrong_pin, web_login_too_many, web_set_txlimit_label, web_set_txlimit_sub, web_set_txlimit_default,
  web_set_txlimit_custom, web_channel_untunable, web_scope_untunable, web_update_too_big.
