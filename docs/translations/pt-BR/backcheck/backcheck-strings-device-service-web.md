# pt-BR back-check: strings_device.xml, strings_service.xml, strings_web.xml

Every string was back-translated to English without the source, then compared; changed meanings, negations, numbers and units were fixed. Merge-time fixes: service_fw_load_running "carga" (could read as battery charge) -> "carregamento de firmware"; web_set_wheelmic_label aligned with device_set_wheel_mic ("Microfone para o volante"). de_check: 0 problems, 0 untranslated in all three files; \u0020 and \n counts match English per string.

## strings_device.xml, part A

**Checked:** 348 entries (344 strings + 4 plurals), about 4300 words of pt-BR. I translated each one back into English without looking at the source, then compared it with the English.

| name | issue found | fix |
|---|---|---|
| device_support_step2b | The draft said "grave o chiado (10 s)", which made the owner record the static. In the English the check records it. | "depois vêm o chiado (10 s) e a estação (50 s)" |
| device_support_step1, device_support_locked, device_support_locked_send | "Rodar todos os testes" ("run all tests") did not match the dialog title `device_checks`, so one feature had two names. | "Executar todas as verificações" everywhere |
| device_second_intro | Frequencies had decimal points ("446.00625 MHz"). Style §5 asks for decimal commas in prose (German did the same). | 446,00625 MHz; 462,5625 MHz |
| device_link_untested_msg | "relatórios de donos do aparelho" sounded like many owners. | "relatórios de quem tem o aparelho" |
| device_web_url_or, device_web_pin, device_contrib_donate/develop/phone, device_support_step1/2/3 | The Write tool turned ` ` into plain spaces. | Escapes restored. The counts of ` ` and `\n` now match English in every string. |
| device_report_ready_msg | English uses `\"…\"`. | Typographic “…” used on purpose (style §4). This is the only escape-count difference. |

No negation, number or unit was found changed after these fixes.

**Plurals:** `one` covers 0, so every `one` form is written to read right at 0:
- device_web_clients: "Navegadores conectados: %1$d"
- device_radioid_loaded: "IDs DMR carregados: %1$s"
- device_fwfiles_found: "Encontrados: %1$d (…)"
- device_fwfiles_copied: "Arquivos copiados: %1$d, para …"

The `many` forms use the `other` text.

**SAFETY strings checked twice (the second time against the English):**
- device_link_fw_not_certified
- device_link_untested_title, device_link_untested_msg
- device_link_note
- device_txlimit, device_txlimit_sub, device_txlimit_locked, device_txlimit_default, device_txlimit_custom_value, device_txlimit_custom, device_txlimit_custom_title, device_txlimit_custom_msg, device_txlimit_custom_bad, device_txlimit_none_title, device_txlimit_long_title
- device_web_allow_tx, device_web_allow_tx_sub ("nunca transmite pelo rádio")
- device_report_txtest ("(transmite)")
- device_exit_hint, device_exit_off_hint, device_exit_handback_hint, device_exit_handback_hint_boot
- device_advisory_line, device_advisory_line_kept, device_advisory_until, device_advisory_row_overridden, device_advisory_row_active, device_advisory_body, device_advisory_body_lapses, device_advisory_body_kept, device_advisory_reapply, device_advisory_keep, device_advisory_override, device_advisory_confirm1, device_advisory_confirm1_msg, device_advisory_confirm2, device_advisory_confirm2_msg, device_advisory_confirm2_ok, device_advisory_overridden
- device_second_intro: licence note and "este celular só escuta: nada é transmitido por ele"

I also checked these for transmit and receive-only wording:
- device_support_what_msg
- device_checks_steps
- device_checks_trial, device_checks_trial_untested
- device_checks_open_app_msg
- device_learn_hint
- device_audio_intro

**New terms not in the glossary:**

| English | pt-BR |
|---|---|
| Run all checks / checks | Executar todas as verificações / verificações |
| trial (receive-only) | teste prático |
| Checks + trial / Checks only | Verificações + teste / Só verificações |
| Radio probe (title) | Sondagem do rádio |
| Radio probe (root) (menu item) | Sondar o rádio (root) |
| static | chiado |
| advisory overridden | ignorado ("Ignorado por você") |
| In effect | Em vigor |
| lapses | expira |
| Boot persistence | Persistência na inicialização |
| Phone profile | Perfil do celular |
| built-in profile | perfil embutido |
| updated profiles | perfis atualizados |
| Learn a PTT key | Ensinar uma tecla PTT |
| Custom PTT key | Tecla PTT personalizada |
| Volume-up transmits | Volume + transmite |
| DMR roaming | Roaming DMR |
| Mission Statement | Missão |
| Home widget | Widget da tela inicial |
| Back up (tile) | Backup |
| Re-import | Reimportar |
| GitHub issue | issue no GitHub (kept as "issue") |
| Intercom layout | Layout da página Rádio |
| Regular / Compact | Normal / Compacto |
| fingerprint (certificate or file) | impressão digital |
| New firmware variant | Nova variante de firmware |
| handheld | HT |

**Strings likely too long:**
- device_report (tile title "Relatório do dispositivo", half-width; it is the glossary term)
- device_tool_about_sub ("Especificações e peculiaridades")
- device_tool_diag_sub ("Registro do protocolo ao vivo")
- device_widget ("Widget da tela inicial", half-width)
- device_tool_report_sub ("Relatórios de suporte e testes")
- device_tool_contribute_sub
- device_set_car_screen ("Controles do rádio em tela cheia no carro", one line)
- device_set_wheel ("Play/pause do volante transmite")
- device_checks_first_title ("Ajude a gente a dar suporte a este celular")
- device_support_title, with the model added

**Unsure:**
- "Executar" vs "Rodar" for running the checks. I chose "Executar" (Android pt-BR); the device part B fork should use the same word for the checks progress lines.
- device_set_wheel_next "Próxima do volante transmite": the Next key is named "Próxima" (feminine, as in *próxima faixa*).
- "Ignorado por você" for an overridden advisory. *Desconsiderado* is an alternative.
- device_txlimit_custom_bad does not repeat "whole" ("segundos inteiros"). The dialog message says it.
- "Muito obrigado" in device_contrib_donate_text: the speaker is the developer, which is fine.
- Outside my scope: values-de/strings_device.xml `device_support_step1` reads "1  Alle…" with two plain spaces, so the German file seems to have lost its ` ` there.

## strings_device.xml, part B

Strings checked: 355 (352 strings + 3 plurals). Placeholders: 0 mismatches. ` `, `\n`, `\"` counts: match English
(the writer dropped the 12 ` ` in `device_fw_progress`; restored by script). Comments identical to English.

| name | issue found | fix |
|---|---|---|
| device_fw_unlisted_q1 | "não dá cobertura a ele" reads as insurance cover, not "the project does not stand behind it" | "Este projeto não se responsabiliza por ele" |
| device_fw_phase_update | "Modo atu" unclear abbreviation | "Atualiz." (8 characters) |
| device_main_region_roaming | "a rede é de %3$s" needs the country's article ("do Brasil"), wrong with "de" | "rede: %3$s" |
| device_ptt_learn_held | "%1$s pressionado" wrong gender for "Tecla F9" | "Pressionando %1$s… agora solte." |
| device_fw_flash_read_at, device_fw_flash_differs | I had added a final period the English does not have (the restore result follows) | removed |
| device_profile_describe_updated / _builtin | "perfil %1$s" put a lower-case word first where the string can start a line | "%1$s, perfil r%2$s (…)" |
| device_fw_progress | ` ` lost on write (Android would trim the spaces) | restored |

SAFETY strings checked twice (negation, numbers, units): device_status_advisory, device_thermal_zone_hot,
device_thermal_battery_hot, device_thermal_stop_zone, device_thermal_stop_battery, device_thermal_stop_zone_rise,
device_thermal_stop_battery_rise, device_thermal_cooling_zone, device_thermal_cooling_timer (17 min),
device_txlimit_heat_warning (2 min, 11 °C, 70 °C, 48 °C), device_txlimit_none, device_firstrun_watch_open,
device_firstrun_watch_open_bridged, device_firstrun_trial_take_over, device_firstrun_trial_hand_back,
device_ptt_check_no_release, device_ptt_check_bluetooth, device_main_exit_handed_back, device_fw_erasing_left,
device_fw_risk_heading, device_fw_disclaimer, device_fw_preflight, device_fw_unlisted_off/on, device_fw_hash_hint,
device_fw_download_failed, device_fw_unlisted_q1_title, device_fw_unlisted_q1, device_fw_unlisted_q2_title,
device_fw_unlisted_q2, device_fw_unlisted_allow, device_fw_type_hash, device_fw_confirm, device_fw_no_factory_copy,
device_fw_backup_unread, device_fw_backup_mismatch, device_fw_variant_unsupported, device_fw_file_mismatch,
device_fw_check_idle_busy, device_fw_check_stock_on, device_fw_check_backup_missing, device_fw_hist_mismatch,
device_fw_answered_no_copy, device_fw_answered_nothing_no_copy, device_fw_restored_tag, device_fw_restore_failed,
device_fw_hist_readback, device_fw_sample_restored, device_fw_sample_restore_failed, device_fw_flash_read_at,
device_fw_flash_differs, device_fw_flash_read_error, device_fw_fw22_summary (120 s), device_fw_not_known_image,
device_fw_recovery_factory_only, device_fw_backup_needed_recovery, device_fw_stock_gone, device_fw_variant_tag,
device_fw_wrong_model, device_fw_wrong_stock_app, device_fw_stock_mismatch, device_fw_backup_first,
device_fw_wrong_base, device_fw_unlisted_summary, device_txtest_title, device_txtest_take_over, device_txtest_intro
(28 s), device_txtest_before, device_txtest_start, device_txtest_confirm_rules, device_txtest_transmitting,
device_txtest_release, device_diag_bring_up, device_diag_release, device_diag_tone, device_diag_tone_q,
device_diag_tone_msg, device_diag_tone_go, device_profile_restrict_profile, device_profile_restrict_takeover,
device_profile_restrict_transmit, device_profile_bad_signature, device_profile_advisory_title,
device_profile_advisory_text. All clean after the fixes above.

New terms not in the glossary:
- stock version / "take as stock" → versão de fábrica / "Adotar como de fábrica"
- trial (receive-only trial take-over) → Ensaio
- probe (radio probe) → Sondagem
- pre-flight (checks) → Verificações prévias
- handshake log → Registro do handshake
- read-back / flash sample → releitura / amostra da flash
- unlisted image → imagem não listada (glossary has "Permitir imagens não listadas")
- Release / Beta (update paths) → Estável / Beta; "a release" → versão estável
- power-cycle → Reiniciar módulo / "Desligar e religar o módulo de rádio?"
- backup round trip → Ida e volta do backup
- advisory → aviso (glossary §6)
- headset → fone; volume up/down → Volume + / Volume −
- radio zone (thermal) → zona do rádio

Strings likely too long:
- device_main_tab_device "Dispositivo" (11 characters, the comment says ≤ 9). Kept for consistency with every
  "Dispositivo → …" menu path; the parent/screen check should decide (alternative "Aparelho", 8, would break the
  glossary).
- device_fw_preflight "Verificações prévias" (capitals heading; may be wide).
- device_diag_release "Devolver (app do fabricante)" in a row of four pills; device_diag_power_cycle "Reiniciar módulo"
  and device_diag_version "Versão do módulo" in rows of three.
- device_fw_restore_factory "De fábrica" and device_fw_load "Carregar" are fine (three buttons in a row).

Unsure:
- device_fw_confirm uses "Falar" for the Intercom's Talk button; check the name the intercom file uses.
- device_ptt_check_own_ptt / _vol_ptt / _wheel quote setting names ("PTT lateral", "Volume + transmite", "Play/pause do
  volante transmite"); they must match the pt-BR names in the other strings files.
- device_txtest_intro "o teste de soltar" (release check) and "aquecimento" (heat): fine for a ham, but a native
  reviewer may prefer other words.

## strings_service.xml

Checked: 391 entries (379 strings + 12 plurals), all back-translated to English and compared. de_check: 0 problems,
0 untranslated. ` ` / `\n` counts per string match English (the Write tool had turned the 5 ` ` in
`service_m17_heard_line`, `service_m17_idle_line`, `service_m17_idle_line_rx`, `service_sched_day_sep` into plain
spaces; restored by script).

| name | issue found | fix |
|---|---|---|
| service_sat_out_of_band | "o %2$s transmite": masculine article before a satellite name breaks for "a ISS" | article dropped: "%2$s transmite em %3$s MHz" |
| service_tx_too_long_sender | "este transmissor" read as the radio hardware, not the software sender | "este recurso permite no máximo %3$d s" |
| service_iss_link_out_of_band | "não alcança o downlink nem o uplink" said *neither* is reachable; English means one or the other is outside | "o downlink ou o uplink APRS da ISS fica fora da faixa" |
| service_scan_skip_priority | "remova-o em Canais" could read as delete the channel; English is clear the priority mark | "desmarque a prioridade em Canais" |
| service_net_repeater_unnamed | "Repetidora sem indicativo" added meaning not in the English | "Repetidora" |
| service_car_sound_taken | "passou o som para outra fonte" lost "took away" and "(another source played)" | "tirou o som do rádio (outra fonte tocou)" |
| 4 strings with ` ` | escapes lost on write | restored |

Plurals: Portuguese `one` covers 0 and 1, so every `one` form with a count is phrased "Canais excluídos: %1$d" /
"Nova zona %1$s (canais: %2$d)", which reads right for 0 and 1; `many` = `other`. `service_imported*` use the label form
for all quantities (English uses "channels" for one too). `service_net_in_days` is only shown for 2+ ("em %1$d dias").

### SAFETY strings checked twice (negation, number, unit)
service_keyer_needs_fm, service_tx_receive_only, service_txlimit_locked, service_txlimit_minimum,
service_sat_out_of_band, service_fox_needs_fm, service_freq_outside, service_parrot_needs_fm, service_iss_out_of_band,
service_iss_link_out_of_band, service_iss_beacon_not_tuned, service_tx_blocked_receive_only, service_tx_too_long_limit,
service_tx_too_long_sender, service_aprs_out_of_band, service_zone_untunable, service_zone_untunable_history,
service_no_tunable_channel, service_channel_untunable, service_channel_outside, service_channel_outside_still,
service_m17_receive_only, service_tx_untested_profile, service_page_out_of_band, service_tx_off_channel,
service_page_too_long, service_page_over_limit, service_m17_needs_fw_history, service_m17_needs_analog_history,
service_m17_needs_fw, service_m17_needs_analog, service_receive_only_channel, service_tones_over_limit,
service_heat_stop, service_heat_cap, service_tx_module_timeout, service_channel_busy, service_sms_tx_off,
service_sched_skip_band, service_sched_skipped_band, service_sched_winlink_not_moved, service_sched_no_aprs,
service_sched_channel_outside, service_tx_held, service_sos_radio_off, service_sos_receive_only,
service_sos_choose_recipient, service_sos_text_sent, service_sos_text_sent_no_fix, service_sos_no_packet,
service_sos_not_sent, service_sos_aprs_position_sent, service_sos_aprs_status_sent (53).

### New terms not in the glossary
| English | pt-BR |
|---|---|
| symbol engine (already §8) / tone queue | motor de símbolos / fila de tons |
| USB bridge (radio) | ponte USB |
| pager waveform | forma de onda do pager |
| frames (M17) | quadros |
| equaliser taps / fit / not kept | coeficientes / ajuste / ajuste descartado |
| locked / no lock (M17 link setup) | sincronizado / sem sincronismo; "link setup" kept |
| roaming (DMR) | Roaming |
| skipped (scheduled op) | ignorado |
| Weekdays / Weekends | Dias úteis / Fins de semana |
| net control (station, notification) | coordenação %s |
| Hold / Double-press (wheel Next) | Segurar / Dois toques |
| Beep / Two-tone / Morse K (roger) | Bipe / Dois tons / K em CW |
| Small / Better / Best / Max (speech models) | Pequeno / Melhor / Ótimo / Máximo |
| billing / quota (Google Cloud) | faturamento / cota |
| Ch (notification) | Can. |

### Likely too long
- service_notif_stop_scan "Parar varredura" (media button, English "Stop scan"): may clip on narrow notification
  buttons; fallback "Parar".
- service_page_for_you "Mensagem de pager para você" (notification title, fine on one line but long).
- service_scope_sat_busy, service_bridge_lost, service_rx_line_dead are long history lines (as in English).

### Unsure
- Screen/button names referred to in text, to match the other pt-BR files when they land: "Receber aqui"
  (service_sstv_out_of_band), "Passagens de satélites" (service_iss_no_orbit), "Repetidoras próximas", "Zonas",
  "Canais", "Controles do rádio", "Tipo de subtom RX" / "Nenhum", "Winlink → Conectar: rádio",
  "PKT → Configurações", "PKT → Configurações de APRS", "PKT → Formulários de mensagem", "Fontes desconhecidas"
  (Android Auto's own setting; Android Auto pt-BR calls it this, but confirm).
- service_agold_app_block keeps the phone's own path "Settings → App block → SignalDeck" in English (Agold ROM labels);
  change if the pt-BR ROM shows Portuguese.
- service_keyup_dmr keeps BrandMeister's "Parrot" (glossary §8).
- service_heat_stop / service_heat_cap: "%1$s interrompido" assumes a masculine English label ("APRS beacon").

## strings_web.xml

Checked: 240 strings + 3 plurals (all of them back-translated and compared).

| name | issue found | fix |
|---|---|---|
| web_net_ended | `one` "Roda encerrada: %1$d check-ins" read "1 check-ins" (and Portuguese `one` also takes 0) | "Roda encerrada (check-ins: %1$d)" in every quantity |
| web_pager_sending | `one` with a number would give "0 RIC" | `one` = "Enviando (RICs: %1$d)", reads right for 0 and 1 |
| web_keyer_saved | "%1$s salva" guessed the slot name's gender (slots are m and f) | "Salvo: %1$s (%2$s s)" |
| web_pota_logged | "%1$s registrado" back-translated as "the callsign was registered" (licensing sense) | "QSO com %1$s registrado" |
| web_net_checkin_updated | "%1$s atualizado" unclear what was updated | "Check-in de %1$s atualizado" |
| web_log_logged | first draft literal "Registrado %1$s" | "QSO com %1$s registrado" |

Safety strings checked twice: web_tx_off, web_restricted, web_firmware_busy, web_not_while_tx, web_sat_receive_only,
web_channel_receive_only, web_confirm_first, web_login_wrong_pin, web_login_too_many, web_cross_site, web_talk_busy,
web_history_talk_mic, web_history_web_tx, web_channel_untunable, web_scope_untunable, web_set_txlimit_label,
web_set_txlimit_sub, web_set_hwptt_sub, web_set_volptt_label, web_set_customptt_sub, web_set_wheeltalk_*,
web_set_nexttalk_*, web_set_voxstop_*, web_device_restarting, web_update_too_big.

New terms (not in the glossary): engine (captions / packet) = *motor* ("motor Google", "motor no aparelho", "motor de
packet"); on-device = *no aparelho*; Custom PTT key = *Tecla PTT personalizada*; Volume-up = *Volume +*; steering wheel
= *volante*; media key Next = *Próxima*; hands-free link = *conexão viva-voz*; grid square (Winlink/contact) = *locator*
(glossary §3); DUPE kept.
Possibly long: web_set_txlimit_sub, web_set_carscreen_sub, web_captions_need_key (two-line slots).
Unsure: "Volume + transmite" (label for the volume-up key as PTT); "Próxima" must match what Android Auto pt-BR calls
the Next key.
