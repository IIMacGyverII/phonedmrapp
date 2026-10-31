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
