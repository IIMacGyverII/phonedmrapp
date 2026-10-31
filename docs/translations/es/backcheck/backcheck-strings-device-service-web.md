# Back-check: strings_device.xml, strings_service.xml, strings_web.xml (es)

Date: 2026-10-31. Files: `app/src/main/res/values-es/strings_device.xml`, `strings_service.xml`, `strings_web.xml`.

**Checked:** 1359 entries (string or plural quantity) in all: device 710, service 403, web 246. Each one translated back
to English and compared with the source. **177 SAFETY strings** (comment starting `SAFETY:`) checked twice, plus the
non-tagged transmit, firmware and heat strings next to them.

Mechanical checks: `de_check.py` gives 0 problems and 0 untranslated for all three files. A second script compared
` `, `\n`, `…`, `→`, `⚠` and `·` counts with English (all equal) and looked for decimal points left in prose
(none; section numbers 3.3 and licence versions are not decimals).

## Fixes from the back-check

| String | Draft (back-translated) | Problem | Fix |
|---|---|---|---|
| `device_thermal_cooling_zone` (SAFETY) | "…wait until it is below 1 °C" | Meaning changed: English is "within 1 °C" of the starting temperature, the draft read as an absolute 1 °C | "a menos de 1 °C de la temperatura inicial" |
| `device_fw_unlisted_q2` (SAFETY) | "The switch turns off only after a load" | "se desactiva solo" reads as "only"; English "by itself" | "se desactiva automáticamente después de una carga" |
| `device_widget_hint` | "Talk … ends only at the transmit limit" | Same *solo* ambiguity | "termina automáticamente al llegar al límite" |
| `device_listen_intro`, `device_listen_part2_msg` | "the squelch opens only when the station talks" | Same *solo* ambiguity (English "by itself") | "se abre por sí solo" |
| `device_fw_backup_mismatch` (SAFETY) | "The factory copy does not match the known factory image" | Wrong subject: English means the **stock app's** copy | "La copia de la app del fabricante no coincide…" |
| `device_fw_hist_mismatch` (SAFETY) | "The firmware load does not match" | Unclear what mismatched | "Discrepancia tras cargar el firmware: se esperaba …, el módulo respondió …" |
| `device_fw_restored_tag` (SAFETY) | "because the label did not match" | "etiqueta" is not the version string | "porque la versión no coincidía" |
| `device_link_fw_not_certified` (SAFETY) | "its recording process has not been tested" | "grabación" reads as audio recording | "su proceso de escritura en la flash" |
| `device_second_intro` (SAFETY) | "a cheap laptop is fine" | "portátil" alone reads as laptop | "un walkie-talkie barato" |
| `device_reimport_which` | "Import which factory area?" | The area is the stock app's, not the factory's | "¿Qué área de la app del fabricante…?" |
| `device_fw_factory_backup` | "Factory copy" | Glossary §8: factory backup = copia de seguridad de fábrica | "Copia de seguridad de fábrica" |
| `service_tg_back` | "Back to the own call of X, 123" | Awkward, number detached | "De vuelta al número de llamada propio de %1$s (%2$d)" |
| `service_tx_not_reported`, `service_tx_no_send_start` | "%1$s not sent" | Participle agreed with an English label of unknown gender | "No se envió %1$s: la radio no informó de que estuviera transmitiendo" |
| `service_heat_stop` (SAFETY) | "%1$s cut: %2$s" | Two colons, agreement with unknown label | "%1$s se cortó antes de tiempo porque %2$s. Deja que el teléfono se enfríe…" (`%2$s` is the lower-case stop reason) |
| `service_heat_cap` (SAFETY) | kept as "%1$s se cortó a los 30 s: %2$s" | `%2$s` here is a full gate sentence (checked in RadioService), so no "porque" | — |
| `web_keyer_saved` | "%1$s saved (feminine)" | Agreement with a slot name of unknown gender | "Se guardó %1$s (%2$s s)" |

## Safety strings checked twice (all 177)

Device: link_fw_not_certified, link_untested_title/msg, link_note, txlimit (title, sub, locked, default, custom_value,
custom, custom_title, custom_msg, custom_bad, none_title, long_title, none, heat_warning), web_allow_tx/_sub,
report_txtest, exit_hint, exit_off_hint, exit_handback_hint/_boot, advisory_line/_kept/_until/row_overridden/row_active/
body/body_lapses/body_kept/reapply/keep/override/confirm1/confirm1_msg/confirm2/confirm2_msg/confirm2_ok/overridden,
second_intro, status_advisory, thermal_zone_hot, thermal_battery_hot, thermal_stop_zone/_battery/_zone_rise/
_battery_rise, thermal_cooling_zone, thermal_cooling_timer, firstrun_watch_open/_bridged, firstrun_trial_take_over/
_hand_back, ptt_check_no_release, ptt_check_bluetooth, main_exit_handed_back, all `device_fw_*` SAFETY strings
(erasing_left, risk_heading, disclaimer, preflight, unlisted_off/on, hash_hint, download_failed, unlisted_q1_title/q1/
q2_title/q2/allow, type_hash, confirm, no_factory_copy, backup_unread, backup_mismatch, variant_unsupported,
file_mismatch, check_idle_busy, check_stock_on, check_backup_missing, hist_mismatch, answered_no_copy,
answered_nothing_no_copy, restored_tag, restore_failed, hist_readback, sample_restored, sample_restore_failed,
flash_read_at, flash_differs, flash_read_error, fw22_summary, not_known_image, recovery_factory_only,
backup_needed_recovery, stock_gone, variant_tag, wrong_model, wrong_stock_app, stock_mismatch, backup_first,
wrong_base, unlisted_summary), txtest_title/take_over/intro/before/start/confirm_rules/transmitting/release,
diag_bring_up/release/tone/tone_q/tone_msg/tone_go, profile_restrict_profile/_takeover/_transmit,
profile_bad_signature, profile_advisory_title/_text.

Service: keyer_needs_fm, tx_receive_only, txlimit_locked, txlimit_minimum, sat_out_of_band, fox_needs_fm,
freq_outside, parrot_needs_fm, iss_out_of_band, iss_link_out_of_band, iss_beacon_not_tuned, tx_blocked_receive_only,
tx_too_long_limit, tx_too_long_sender, aprs_out_of_band, zone_untunable/_history, no_tunable_channel,
channel_untunable, channel_outside/_still, m17_receive_only, tx_untested_profile, page_out_of_band, tx_off_channel,
page_too_long, page_over_limit, m17_needs_fw/_history, m17_needs_analog/_history, receive_only_channel,
tones_over_limit, heat_stop, heat_cap, tx_module_timeout, channel_busy, sms_tx_off, sched_skip_band,
sched_skipped_band, sched_winlink_not_moved, sched_no_aprs, sched_channel_outside, tx_held, all `service_sos_*`.

Web: no strings tagged SAFETY; `web_tx_off`, `web_restricted`, `web_channel_receive_only`, `web_sat_receive_only`,
`web_set_txlimit_*` and the take-over/hand-back replies were checked twice anyway.

Every negation stayed in place and early ("no presiones PTT", "no transmite nada", "no se envió", "no puede
sintonizarlo"); every number, unit and limit (28 s, 30 s, 120 s, 17 min, 70 °C, 48 °C, 11 °C, 1 °C, 25 s, 10 s, 15 s)
matches English. No safety string is left in English.
