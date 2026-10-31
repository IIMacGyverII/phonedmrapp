# Back-check: SignalDeck Web text table (de)

File: `app/src/main/assets/web/i18n/de.json` (940 keys, 16 plural pairs). Method: every German string read on its own and
put back into English, then compared with the English source for meaning, negations, numbers and units. Placeholders
and HTML tags were also compared by script (all identical to English; no decimal point left in a number).

**Strings checked: 940.**

## Changes made after the back-check

| Key | First draft | Back-translation | Fixed to | Why |
|---|---|---|---|---|
| map_tx_cell | {keyed} haben das Relais erreicht · {failed} ohne Antwort | "{keyed} have reached…" (wrong for 1) | Relais erreicht: {keyed} · ohne Antwort: {failed} | Count-agnostic; no grammar break at 1. |
| map_coverage_transmit_reached | Reichweite: Sendung angekommen | "Coverage: transmission arrived" | Reichweite: Relais erreicht | English means the transmission reached the repeater. |
| pkt_tx_1st_00_30 / pkt_tx_2nd_15_45 | TX zuerst / TX danach | "TX first / TX afterwards" | TX 1. / TX 2. | English names the 1st / 2nd FT8 period, not an order of events. |
| editor_ctype_* / contacts_type_private, _group | Einzel / Gruppe / Alle | "Single / Group / All" | Einzelruf / Gruppenruf / Sammelruf | Glossary terms; "Alle" alone lost "all call". |
| channels_out_of_zone | Aus der Zone | "From the zone" | Aus Zone nehmen | The button is an action (take out). |
| channels_star | Stern | "Star" (noun) | Stern setzen | The button is an action. |
| pkt_parrot_sub, pkt_fox_sub | braucht Senden | "needs sending" (unclear) | setzt Senden voraus | Clearer that transmitting must be allowed. |
| pkt_set_igate | Sendendes iGate | "Sending iGate" | Sende-iGate | Shorter, a label. |
| log_on_the_air_now | JETZT IN DER LUFT | "now in the air" | JETZT QRV | Literal; German hams say QRV. |
| sat_highest | HÖCHSTER | "highest (masc.)" with no noun | HÖCHSTSTAND | Needs a noun to say "highest elevation". |
| settings_card_listening | HÖREN MIT | "listen with" | HÖRER | The field counts browsers listening. |
| log_net_late | Später | "Later" | Spät | "Später" means later, not "late". |

No negation, number or unit was found changed in the final text.

## SAFETY and transmit strings (each checked twice)

- intercom_ptt_firmware: checked twice
- intercom_ptt_web_tx_off: checked twice
- intercom_ptt_rx_only: checked twice
- intercom_ptt_browser_mic: checked twice
- intercom_ptt_phone_mic: checked twice
- intercom_ptt_phone_mic_https: checked twice
- intercom_loading_firmware: checked twice
- common_needs_web_tx: checked twice
- pager_needs_web_tx: checked twice
- sstv_web_tx_off: checked twice
- settings_web_access_pin_allow: checked twice
- settings_restart_installing_update_each: checked twice
- settings_dev_restart_ask: checked twice
- settings_dev_install_ask: checked twice
- settings_hand_back_ask: checked twice
- settings_take_over_gives_radio: checked twice
- editor_transmit, editor_tx_allowed, editor_rx_only: checked twice
- editor_save_note: checked twice
- messages_wl_tune_ask: checked twice
- messages_tune_gateway_s_channel: checked twice
- messages_your_callsign_comes_from: checked twice
- messages_send_us_e_mail: checked twice
- messages_wl_diag_ask: checked twice
- sstv_sends_current_analog_channel (time-out, cool-down): checked twice
- scope_receive_only_radio_sweeps, scope_idle, scope_running, scope_sweeping_range, scope_sweeping_preset: checked twice
- pkt_listens_across_packet_frequencies (never transmits): checked twice
- pkt_m17_digital_voice_phone (receive only, cannot transmit M17): checked twice
- pkt_wsjt_x_mode_phone: checked twice
- pkt_parrot_sub, pkt_fox_sub: checked twice
- pkt_halt_tx: checked twice
- pkt_set_passcode_none: checked twice
- pkt_set_no_autoack: checked twice
- pkt_set_note: checked twice
- sat_tracking_follows_every_pass, sat_listen_only: checked twice
- pkt_id_due_now, pkt_id_due_in: checked twice
- settings_card_web_tx: checked twice
