# Back-check: strings_channels.xml (de)

Each German string was translated back into English without the source, then compared with the English source for
meaning, negations, numbers and units.

**Strings checked:** 395 strings + 24 plurals (48 plural forms) = 443 texts.

## Changes made after the back-check

| String | Problem found | Fix |
|---|---|---|
| `channels_region_intro` | Grammar: "ändert keine deiner Kanäle" (wrong case, Kanal is masculine); meaning intact. | "ändert keinen deiner Kanäle". |
| `channels_region_free_footer` | Quoted the "Not legal here" label as „hier nicht legal“; the Add-a-zone sheet's German label (strings_intercom) is „Hier nicht erlaubt“. A quoted label must match. | „Hier nicht erlaubt“. |
| `channels_region_wx_no` | Quoted the button as „Alle Listen anzeigen“; its German label is „Alle Listen zeigen“. | „Alle Listen zeigen“. |
| `channels_rep_none_match` (one) | "None of the 1 repeaters" is not natural German in the singular; rewritten as "1 repeater within X, but it does not match these filters". Meaning unchanged. | Kept the rewrite (checked). |

No string lost or gained a negation, and no number or unit changed. Back-translations that differ only in nuance:

- `channels_list_badge_not_tunable` „AUSSERHALB“ ("OUTSIDE"): shortened for the 480 px chip; the content description
  `channels_list_cd_not_tunable` carries the full meaning ("not tunable on this radio").
- `channels_list_on_air` „AKTIV“ ("ACTIVE"): the tag marks the tuned channel, not transmission; "AUF SENDUNG" would
  wrongly say it is transmitting.
- `channels_preset_frs_about` "bubble-pack walkie-talkies" → "walkie-talkies from the supermarket shelf" (idiom).
- Weekday names use the German abbreviations with a full stop (So., Mo. …) per style.md §5.

## SAFETY strings (licence, transmit legality, receive-only, restricted mode): checked twice

- `channels_preset_licence_none`: checked twice
- `channels_preset_licence_rx_only`: checked twice
- `channels_preset_licence_amateur`: checked twice
- `channels_preset_licence_amateur_tx`: checked twice
- `channels_preset_gmrs_licence` (US statement: „In den USA …“): checked twice
- `channels_preset_biz_licence` (US statement): checked twice
- `channels_preset_cb_licence` ("not for use in the US" → „in den USA nicht zugelassen“): checked twice
- `channels_preset_pmr_licence`: checked twice
- `channels_preset_biz_about` (VHF wide band not allowed for transmitting): checked twice
- `channels_preset_marine_about` (receive-only, not a marine radio): checked twice
- `channels_preset_wx_about` (receive-only): checked twice
- `channels_preset_rail_about` (receive-only): checked twice
- `channels_preset_murs_about` (2 W limit): checked twice
- `channels_preset_pmr_about` (0,5 W limit): checked twice
- `channels_preset_sat_about` (cross-band untested; listen first): checked twice
- `channels_preset_preview_rx_only`: checked twice
- `channels_bandplan_no_fm_here`: checked twice
- `channels_bandplan_do_not_transmit`: checked twice
- `channels_bandplan_keep_fm_off`: checked twice
- `channels_bandplan_satellites_translators_not_fm`: checked twice
- `channels_bandplan_not_fm`: checked twice
- `channels_bandplan_satellites_only_no_terrestrial_fm`: checked twice
- `channels_bandplan_receive_only`: checked twice
- `channels_bandplan_receive_only_radio`: checked twice
- `channels_bandplan_licensed_users_only_public_safety`: checked twice
- `channels_bandplan_licensed_users_only`: checked twice
- `channels_bandplan_murs_licence_free_2_w`: checked twice
- `channels_bandplan_frs_gmrs_channels_8_14` (0,5 W): checked twice
- `channels_bandplan_gmrs_needs_fcc_licence_frs`: checked twice
- `channels_bandplan_fcc_gmrs_licence_needed`: checked twice
- `channels_region_intro` (never transmits; you stay responsible for licence and rules): checked twice
- `channels_region_free_caution` (licence-free band ≠ this phone approved; check before transmitting): checked twice
- `channels_region_locked` (Restricted mode → Sperrmodus): checked twice
- `channels_list_badge_wx_rx_only`: checked twice
- `channels_list_badge_rx_only`: checked twice
- `channels_codeplug_rx_only`: checked twice
- `channels_share_intro` (encryption keys never included): checked twice
- `channels_list_delete_message` (cannot be undone): checked twice
