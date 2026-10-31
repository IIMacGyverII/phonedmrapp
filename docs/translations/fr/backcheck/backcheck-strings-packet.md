# Back-check: strings_packet.xml (fr)

Checked: 759 entries (all strings and plurals; 6,200 French words). Each French string was read back into English
without the source, then compared for meaning, negation, numbers and units.

## Fixes

| String | Problem in the draft | Fix |
|---|---|---|
| packet_sstv_err_too_long | "plus que la limite" read back as "more than the limit", ungrammatical and vague | "au-delà de la limite de durée d’émission" (past the transmit limit) |
| packet_pkt_pager_hint | "firmware d’origine" drifted from the glossary (stock firmware = firmware d’usine) | "firmware d’usine" |
| packet_pkt_parrot_on | "%1$d émissions répétées" reads wrong for 0 and 1 (a plain string, not a plural) | "émissions répétées jusqu’ici : %1$d." |
| packet_pkt_finder_found | "(%1$d trouvées)" wrong for 1 | "(trouvées : %1$d)" |
| packet_pkt_winlink_new | "(%1$d nouveaux)" wrong for 1 | "(nouveaux : %1$d)" |
| packet_same_duration, packet_pkt_id_within | plain space between "h"/"min" and the minutes could break the line | no-break spaces |

No changed negation, number or unit was found after these fixes. One deliberate addition:
packet_cov_range_hint gives "80 km (50 miles)" where the English says "50 miles".

## Safety strings checked twice
packet_sstv_err_too_long, packet_pkt_sstv_hint (30 s transmit limit), packet_cov_test_hint, packet_cov_test_title,
packet_cov_test_msg ("Ne testez qu’un relais que vous avez le droit d’utiliser"), packet_pkt_m17_hint (receive only,
"ne peut pas émettre"), packet_pfd_hint ("il n’émet jamais"), packet_pkt_finder_hint (réception seule),
packet_pkt_parrot_hint (Morse ID at most every ten minutes, 26 s), packet_pkt_morse_id_on/off, packet_set_morse_id,
packet_pkt_id_timer_idle, packet_pkt_id_within, packet_pkt_id_due, packet_pkt_remote_pin, packet_pkt_remote_intro,
packet_pkt_remote_outro (three wrong PINs lock for ten minutes; PIN never in the history), packet_pkt_remote_err_pin,
packet_set_is_passcode ("jamais affiché ni journalisé"), packet_is_connected_rx_only, packet_is_status_unverified,
packet_pfd_vfo_on (low power), packet_set_power_hint, packet_set_autoack_off, packet_event_not_sent_analog/_dmr,
packet_finder_err_tx, packet_pkt_dtmf_transmit.
