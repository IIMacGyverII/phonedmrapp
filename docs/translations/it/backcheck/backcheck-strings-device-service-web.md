# Back-check: Italian, strings_device.xml + strings_service.xml + strings_web.xml

Checked: 1337 entries (device 703, service 391, web 243; strings and plurals). Each Italian string was read back into
English and compared with the source meaning, negations, numbers and units. de_check: 0 problems, 0 untranslated on all
three files. Escapes (` `, `\n`, `\"`, `&amp;`, leading/trailing spaces) compared per string against English by
script: only intended differences (curly quotes “ ” in place of `\"`, "e" in place of `&amp;`).

## Fixes made

| String | Problem in draft | Fix |
|---|---|---|
| web_set_txlimit_sub | Added "prima" (stops it *earlier*): meaning not in English | Removed |
| device_thermal_cooling_timer | "(ne mancano circa %2$d)": unit "min" dropped | "(mancano circa %2$d min)" |
| device_fw_flash_read_at | "non riuscita a %1$d": byte offset unclear | "non riuscita all’offset %1$d" |
| device_diag_release | "Rilascia (app originale)": lost "stock app on" | "Rilascia all’app originale" |
| service_tg_back | Awkward word order, meaning blurred | "%1$s torna al suo numero di chiamata %2$d" |
| service_vosk_better | "Migliore" above "Ottimo" read as a wrong order | "Buono" (Piccolo < Buono < Ottimo < Massimo) |
| device_listen_ans_unsure | "Non sono sicuro": gendered (style §8) | "Non saprei" |
| device_set_new_look | Clashed with "Aspetto della pagina Radio" (Intercom layout) | "Nuova grafica della pagina Radio" |
| 11 device strings | File tool turned ` ` into plain spaces; separator lost its trailing space | Restored by script, verified per string |

## Safety strings checked twice (176)

Every string whose English comment starts `SAFETY:` (device 123, service 53), plus the web strings about transmit
(web_tx_off, web_restricted, web_not_while_tx, web_sat_receive_only, web_channel_receive_only, web_talk_*,
web_set_txlimit_*, web_login_*). Groups:
- Transmit refusals and receive-only: service_tx_receive_only, service_receive_only_channel, service_tx_off_channel,
  service_tx_blocked_receive_only, service_tx_untested_profile, service_sms_tx_off, service_sos_* (all "Non inviato: …"
  first), service_keyer/fox/parrot_needs_fm, service_m17_* (needs firmware / analog), service_m17_receive_only.
- Band limits: service_*_out_of_band, service_freq_outside, service_channel_untunable/outside(_still),
  service_zone_untunable(_history), service_no_tunable_channel, service_sched_* (skip_band, no_aprs, channel_outside,
  winlink_not_moved), service_page_out_of_band.
- Transmit limit: device_txlimit* (all), service_txlimit_locked/minimum, service_tx_too_long_limit/sender,
  service_page_too_long/over_limit, service_tones_over_limit, service_tx_module_timeout, service_tx_limit_ended.
- Heat: device_thermal_* (8), device_txlimit_heat_warning, service_heat_stop/cap, service_tx_held. Numbers (70 °C,
  48 °C, 11 °C, 1 °C, 17 minutes, 10 s) and °C kept.
- Firmware loading: device_fw_* SAFETY strings (disclaimer, confirm, unlisted q1/q2/allow, hash, preflight, mismatch and
  restore lines, flash read-back), device_link_fw_not_certified. Disclaimer keeps every point: own risk, bench-tested,
  checks before writing, factory image always loadable, no warranty, not responsible for a dead module or what it
  transmits.
- Take over / hand back / exit: device_link_untested_*, device_link_note, device_exit_*, device_main_exit_handed_back,
  device_firstrun_trial_take_over/hand_back, device_firstrun_watch_open(_bridged) ("non premere il PTT").
- Advisories: device_advisory_* (override needs two confirmations; "Ti assumi la responsabilità"), device_profile_*.
- Web transmit: device_web_allow_tx(_sub) ("non manda mai in trasmissione la radio"), web_tx_off.
- Transmit test / diagnostics: device_txtest_*, device_diag_bring_up/release/tone*, device_report_txtest
  ("(trasmette)").
- Licence: device_second_intro ("Esempi senza patente …; oppure una frequenza simplex radioamatoriale se hai la
  patente"; "da qui non viene trasmesso niente").

No negation, number or unit changed in the final text.
