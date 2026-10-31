# French back-check: strings-intercom-channels

Files: strings_common.xml, strings.xml, strings_intercom.xml, strings_channels.xml, strings_channel_editor.xml (values-fr).

## strings_common.xml, strings.xml, strings_channel_editor.xml

Checked: 173 strings (20 common, 1 strings.xml, 150 strings + 2 plurals in the channel editor).

| String | Was | Now | Why |
|---|---|---|---|
| channel_editor_h_rxonly | … réponses et toute autre émission (poste d’écoute, canal pour lequel vous n’avez pas de licence, fréquence qui doit rester silencieuse). | … réponses et toute autre émission. Utile pour un poste d’écoute, un canal pour lequel vous n’avez pas de licence ou une fréquence qui doit rester silencieuse. | Back-translation read the parenthesis as a list of things refused; in English it lists uses of the setting. |
| channel_editor_h_sq | De 1 à 9, il se ferme ; … toutes ces valeurs … | Les valeurs de 1 à 9 le ferment ; … elles agissent toutes … | Back-translation: "from 1 to 9 it closes (gradually)"; English: values 1–9 close it. |
| channel_editor_h_name | Les logiciels de codeplug … gardent des noms plus courts | … n’acceptent que des noms plus courts | "gardent" read back as "keep (choose to use)"; the meaning is that they only take 16 characters. |
| channel_editor_h_callfrom | choisit un autre talkgroup pour un moment | choisit temporairement un autre talkgroup | Calque; same meaning, clearer. |

Safety strings checked twice: channel_editor_h_rxonly (receive only, refusal of every transmission, NOAA/marine/railroad always RX only), channel_editor_h_enc (« Le chiffrement est interdit sur les fréquences radioamateur »), channel_editor_h_relay (« risque de ne pas émettre du tout »), channel_editor_o_rx_only, channel_editor_l_transmit / o_allowed, channel_editor_h_power (service power limits), channel_editor_h_tx / h_rx / err_band (tuning range, frequencies that cannot be saved), channel_editor_h_band (Narrow deaf on VHF).

# Back-check: strings_intercom.xml (fr)

Checked: 602 entries (570 strings + 32 plurals, each French quantity read), back-translated to English and compared with the source.

## Fixes

| String | Was | Now | Why |
|---|---|---|---|
| intercom_help_featured_text | jusqu’où chaque relais vous reçoit | où chaque relais vous parvient | Meaning flipped: the English is where you hear the repeater, not where it hears you |
| intercom_car_talking, _talking_id | En émission : %1$s | Au micro : %1$s | "En émission" read as you transmitting; the English names the caller who is talking |
| intercom_lastheard_ex_usbdrop_text | un relais 2 m sur 144,770 MHz … le provoquait | émettre vers un relais 2 m sur 144,770 MHz … le provoquait | The cause is your transmission on that channel, not the repeater itself |
| intercom_chhistory_last_heard | Dernière écoute %1$s | Dernière réception %1$s | "Écoute" = when you listened; the English is when something was heard |
| intercom_car_open_phone_start | … pour la démarrer | … pour démarrer la radio | Unclear what "la" referred to |
| intercom_car_last_heard_sub | Qui et quoi a été reçu, du plus récent | Ce qui a été reçu, plus récent d’abord | Order phrase was cut off |
| intercom_main_model_switching | après les mises à jour | après les mises à jour de l’application | Made explicit: app updates |
| intercom_zones_not_legal_hint | c’est à vous de vérifier si … | savoir si vous avez le droit d’y émettre relève de votre responsabilité | Legal text: kept to "your responsibility", nothing added |
| intercom_emergency_hint | un appel d’urgence reçoit la réponse de vraies personnes | ce sont de vraies personnes qui répondent à un appel d’urgence | Same meaning, stated more plainly |
| intercom_nets_following | %1$d abonnés | abonnés : %1$d | Not a plural in English; "1 abonnés" would be wrong |
| intercom_netstore_report_times | Ouvert à %1$s, clos à %2$s | Ouverture %1$s, clôture %2$s | %2$s can be "(en cours)": "clos à (en cours)" made no sense |
| intercom_carart_radio_off | RADIO ÉTEINTE | ÉTEINTE | Badge is limited to about 12 characters |

No negation, number or unit was found changed after these fixes (30 s / 28,5 s, ±20 s, 15 min, 30 min, 10 min, 5 min, 7 days, 32 talkgroups, two seconds, ten taps, all band edges).

## Safety and legal strings checked twice
intercom_lastheard_ex_usbdrop_text, intercom_lastheard_ex_rxonly_text (+ _title), intercom_lastheard_ex_toolong_text (+ _title),
intercom_lastheard_ex_busy_text, intercom_lastheard_ex_notsent_text (+ _title), intercom_widget_rx_only,
intercom_autotrust_usb_text, intercom_autotrust_usb_text_car, intercom_emergency_hint, intercom_emergency_hold_hint,
intercom_emergency_not_sent, intercom_emergency_how_dmr / _how_analog / _how_analog_no_call, intercom_zones_add_hint,
intercom_zones_not_legal, intercom_zones_not_legal_hint, intercom_zones_partly_legal, intercom_zones_delete_all_message,
intercom_main_key_message, intercom_main_classic_loading / neo_loading / mode_state_loading / car_firmware_loading /
car_btn_loading, intercom_vfo_out_of_band_toast.

# Back-check: strings_channels.xml (fr)

Checked: 419 entries (395 strings + 24 plurals, 443 texts with plural forms), all back-translated to English and
compared with the source. de_check: 0 problems, 0 untranslated. Typography scan (plain space before `: ; ! ?` / `»`,
straight quotes, plain space before a unit, decimal point in prose): 0 hits. ` ` kept in all 20 strings that have it.

## Fixes

| String | Was | Now | Why |
|---|---|---|---|
| channels_bandplan_licensed_users_only_public_safety | … ; ne perturbez jamais la sécurité publique | … ; les services de sécurité publique ne doivent jamais être perturbés | Back-translation "never disturb public safety" read as odd; the obligation now names the services, as strong as "must never be disturbed". |
| channels_region_intro | Elle n’émet jamais, ne démarre aucun mode et ne modifie pas vos canaux. | … ne démarre jamais de mode et ne modifie jamais vos canaux. | English "never" covers all three verbs; "ne modifie pas" was weaker. |
| channels_region_free_caution | … libre de licence en %1$s pour les radios homologuées à cet effet. | … utilisable sans licence (%1$s) avec les radios homologuées pour cet usage. | "en %1$s" is wrong for country names that take "au/aux" (Canada, États-Unis); meaning unchanged. |
| channels_region_free_none | Aucun indiqué pour %1$s pour l’instant. | Aucun service indiqué pour l’instant (%1$s). | Same preposition problem. |
| channels_region_service_unconfirmed | (À confirmer pour %4$s.) | (%4$s : à confirmer.) | Same. |
| channels_region_locked | La région est verrouillée en mode verrouillé | La région ne peut pas être modifiée en mode verrouillé | Read as a tautology. |
| channels_list_prio_set | Pendant le balayage, %1$s est revérifié … | … le canal %1$s est revérifié … | Agreement with an unknown name (style §8). |
| channels_backup_skipped | %1$d ignorés, hors de la plage … : %3$s | Hors de la plage de cette radio (%2$s), non restaurés : %1$d (%3$s) | "1 ignorés"; also "skipped" in a restore = not restored. |
| channels_preset_added_reused(_skipped) | %3$d déjà présents | %3$d en double | Invariable, reads right for 1. |
| channels_bandplan_keep_fm_off | Pas de FM ici | Évitez la FM ici | Identical to channels_bandplan_no_fm_here; the English differs. |
| channels_contact_last_hint(_by) | Dernière écoute %1$s %2$s | Entendu en dernier à %1$s %2$s | %1$s is a position; back-translation lost "at". |
| channels_contact_call_auto | corrigez-le si vous savez mieux | corrigez-le au besoin | Calque. |

No number, unit or negation was found changed apart from the rows above.

## Safety strings checked twice
channels_preset_licence_amateur, channels_preset_licence_amateur_tx, channels_preset_licence_rx_only,
channels_preset_gmrs_licence, channels_preset_biz_licence, channels_preset_cb_licence, channels_preset_pmr_licence,
channels_preset_marine_about, channels_preset_wx_about, channels_preset_rail_about, channels_preset_biz_about,
channels_preset_sat_about, channels_preset_murs_about, channels_preset_pmr_about, channels_bandplan_do_not_transmit,
channels_bandplan_no_fm_here, channels_bandplan_keep_fm_off, channels_bandplan_not_fm,
channels_bandplan_satellites_only_no_terrestrial_fm, channels_bandplan_receive_only, channels_bandplan_receive_only_radio,
channels_bandplan_licensed_users_only, channels_bandplan_licensed_users_only_public_safety,
channels_bandplan_gmrs_needs_fcc_licence_frs, channels_bandplan_fcc_gmrs_licence_needed, channels_region_intro,
channels_region_free_caution, channels_region_free_footer, channels_region_locked, channels_list_delete_message,
channels_list_badge_rx_only, channels_list_badge_wx_rx_only, channels_codeplug_skip_tx_outside, channels_share_intro
(encryption keys never included).
