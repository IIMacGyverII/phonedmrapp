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
