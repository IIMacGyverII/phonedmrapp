# Back-check: strings_modes.xml (German)

Method: each German string was translated back into English without looking at the source, then compared with the
English source for meaning, negations, numbers and units. Placeholders and escaping were checked with `de_check.py`
(0 problems, 0 untranslated).

**Checked:** 881 entries (831 strings and 50 plurals, both plural forms each).

## Meaning changes found and fixed

| String | Draft said (back-translated) | Fix | Why |
|---|---|---|---|
| modes_scope_err_band | "The radio tunes %1$s off" (verb "abstimmen" read oddly) | "Das Funkgerät deckt %1$s ab: Der Bereich muss ganz in einem davon liegen" | Meaning was muddled; now "covers … the range must lie wholly inside one". |
| modes_pota_end_message | "Ihre Verbindungen …" could read as formal *Sie* ("your contacts") | "Die Verbindungen der Aktivierung bleiben im Logbuch …" | Register (du) and referent (the activation's contacts). |
| modes_pota_their_ref | "deren %1$s %2$s" ambiguous | "Gegenstation %1$s %2$s" | Clear that it is the other station's reference. |
| modes_sat_about_iss_aprs | "the pass is tracked on the APRS page" | "wird … mitgehört" | Source says monitored (listened to), not tracked. |
| modes_recdec_hint_aprs | "forwarded to the internet" for "gated" | "ins APRS-IS weitergeleitet" | Precise meaning of gating. |
| modes_pass_next_detail | "At most %1$s°" (read as a limit) | "Bis %1$s° hoch" | It is the pass's highest elevation, not a cap. |
| modes_satd_pass_up, modes_satd_pass_at | "höchstens %s°" (at most) | "max. %s°" | Same: highest elevation of the pass. |
| modes_term_hint | "Type a line and then Send" (Senden as a verb) | "Gib eine Zeile ein und tippe auf Senden" | Make clear Send is the button. |
| modes_fox_dcs | "der DCS" (wrong gender, unclear) | "der DCS-Code des Kanals" | Grammar. |
| modes_winlink_timeout | "no answer in the time" | "keine rechtzeitige Antwort" | Idiomatic, same meaning. |
| modes_cond_tropo_legend | colour "Bernstein" | "Orange" | A German reader names the strip colour orange, not amber. |
| modes_wl_gw_hint | "Desktop-Version" | "Desktopwebsite" | The label German Chrome actually shows. |
| modes_sstv_combine_sizes | "Sie lassen sich nicht kombinieren" (could read as formal *Sie*) | "Kombinieren ist nicht möglich" | Register; negation kept. |
| modes_sstv_delete_message | "Sie werden … entfernt" | "Die Bilder werden … entfernt" | Register; "cannot be undone" kept. |
| modes_wl_delete_outbox | "Sie wird nicht gesendet" | "Sie wird dann nicht gesendet" | Clear it refers to the message; negation kept. |
| modes_fox_shaded, modes_fox_not_used_shaded | "bright outline 50 %, paler 90 %" | "heller Umriss 50 %-, fahler 90 %-Bereich" | Meaning sharpened (the 50 % / 90 % areas); wording also keeps the placeholder scan identical to English (the English shown-as-is string contains "%, f"). |

Also fixed (not a meaning change): the escaped spaces (` `) in 50 strings were restored to match English exactly
(leading/trailing and double spaces), and the separators keep their English values.

No negation, number or unit differed after these fixes.

## SAFETY and transmit-related strings: checked twice

- modes_dtmf_event_locked: checked twice
- modes_dtmf_event_wrong_pin: checked twice
- modes_parrot_event_failed: checked twice
- modes_parrot_event_repeated_cut: checked twice
- modes_parrot_event_repeated_cut_id: checked twice
- modes_parrot_hint (30-second transmit limit): checked twice
- modes_text_hint (30-second cut per transmission): checked twice
- modes_forms_aprs_message (radio must be on an analog channel): checked twice
- modes_ft8_status_transmitting: checked twice
- modes_ft8_halt: checked twice
- modes_ft8_err_call_unsendable: checked twice
- modes_ft8_event_nonstandard: checked twice
- modes_scope_subtitle (receive only, nothing transmitted): checked twice
- modes_scope_intro (receive only): checked twice
- modes_recdec_hint_sstv (never uses the radio): checked twice
- modes_recdec_hint_aprs (nothing sent, digipeated or gated): checked twice
- modes_morse_hint (sound on the phone, not on the air): checked twice
- modes_keyer_hint (Send transmits on the current channel): checked twice
- modes_keyer_id_hint (identification rules): checked twice
- modes_m17_note_send (up to the transmit limit): checked twice
- modes_m17_note_firmware (receive only on this firmware): checked twice
- modes_m17_note_rx_only (module cannot send M17): checked twice
- modes_pager_freq_hint (low power, retune before sending): checked twice
- modes_pager_sign_hint: checked twice
- modes_satd_listen (receive only): checked twice
- modes_satd_listen_only: checked twice
- modes_satd_not_tunable: checked twice
- modes_satd_iss_invalid (transmit frequencies 136 to 480 MHz): checked twice
- modes_satd_hint / modes_satd_hint_no_orbits (never retunes while you talk): checked twice
- modes_term_hint: checked twice
- modes_wl_radio_hint: checked twice
- modes_fox_not_while_tx (refused while transmitting): checked twice
- modes_fox_beacon_hint (transmits every minute until stopped): checked twice
- modes_fox_no_rssi: checked twice
- modes_fox_state_softsq: checked twice
- modes_wl_set_hint (password never shown, logged, reported or backed up): checked twice
- modes_wl_set_diag_hint (password never logged): checked twice
- modes_wl_log_hint (password never in the log): checked twice
- modes_wl_ask_message (never the password): checked twice
- modes_wl_delete_outbox (will not be sent): checked twice
- modes_sstv_delete_message (cannot be undone): checked twice
