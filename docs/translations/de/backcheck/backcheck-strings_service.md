# Back-check: strings_service.xml (German)

Method: every German string was translated back into English without the source in view, then compared with the English source for meaning, negations, numbers, units and placeholders. Placeholders and escaping were also checked with `de_check.py` (0 problems, 0 untranslated).

**Strings checked:** 379 strings + 12 plurals (391 entries).

**Meaning changes found and fixed:** 4.

## Changes made after the back-check

| String | Problem found | Fix |
|---|---|---|
| `service_car_sound_taken` | „hat den Ton abgegeben“ read back as "gave the sound away"; English says Android Auto *took* the sound away | „hat den Ton entzogen“ |
| `service_iss_link_out_of_band` | SAFETY. „weder … noch“ read back as "neither the downlink nor the uplink"; the English also fits only one of them being outside | „ISS-APRS-Downlink oder -Uplink liegt außerhalb“ |
| `service_scope_sat_busy` | „beginnt in 15 Minuten“ read back as "starts in 15 minutes" (exactly); English says *within* 15 minutes | „beginnt innerhalb von 15 Minuten“ |
| `service_sched_skipped_tx` | „hat gesendet“ read back as "has transmitted" (finished); English: the radio *was* transmitting at the time | „sendete gerade“ |

No negation, number or unit differs from English in the final file.

## SAFETY strings (53): each checked twice

| String | English | German | Check |
|---|---|---|---|
| `service_keyer_needs_fm` | The voice keyer needs an analog FM channel | Der Sprachspeicher braucht einen analogen FM-Kanal | checked twice |
| `service_tx_receive_only` | This channel is receive-only | Dieser Kanal ist nur für den Empfang | checked twice |
| `service_txlimit_locked` | The transmit limit is locked in Restricted mode | Im Sperrmodus lässt sich die Sendezeitbegrenzung nicht ändern | checked twice |
| `service_txlimit_minimum` | The limit is at least %1$d seconds | Die Begrenzung beträgt mindestens %1$d Sekunden | checked twice |
| `service_sat_out_of_band` | This radio tunes %1$s: %2$s sends on %3$s MHz | Dieses Funkgerät deckt %1$s ab: %2$s sendet auf %3$s MHz | checked twice |
| `service_fox_needs_fm` | The fox beacon needs an analog FM channel | Der Fuchssender braucht einen analogen FM-Kanal | checked twice |
| `service_freq_outside` | This radio tunes %1$s: %2$s MHz is outside it | Dieses Funkgerät deckt %1$s ab: %2$s MHz liegt außerhalb | checked twice |
| `service_parrot_needs_fm` | The parrot needs an analog FM channel | Der Papagei braucht einen analogen FM-Kanal | checked twice |
| `service_iss_out_of_band` | This radio tunes %1$s: the ISS APRS frequency (%2$s MHz) is outside it | Dieses Funkgerät deckt %1$s ab: Die ISS-APRS-Frequenz (%2$s MHz) liegt außerhalb | checked twice |
| `service_iss_link_out_of_band` | This radio tunes %1$s: not the ISS APRS downlink or uplink | Dieses Funkgerät deckt %1$s ab: ISS-APRS-Downlink oder -Uplink liegt außerhalb | checked twice |
| `service_iss_beacon_not_tuned` | ⛔ ISS beacon not sent: the radio did not tune the ISS APRS frequency | ⛔ ISS-Bake nicht gesendet: Das Funkgerät hat die ISS-APRS-Frequenz nicht eingestellt | checked twice |
| `service_tx_blocked_receive_only` | ⛔ TX blocked on a receive-only channel | ⛔ Senden blockiert: Der Kanal ist nur für den Empfang | checked twice |
| `service_tx_too_long_limit` | ⛔ Too long to send (%1$s, %2$d s; the transmit limit is %3$s, Device → Longest transmission) | ⛔ Nicht gesendet, zu lang („%1$s“, %2$d s; die Sendezeitbegrenzung ist %3$s, Gerät → Längste Aussendung) | checked twice |
| `service_tx_too_long_sender` | ⛔ Too long to send (%1$s, %2$d s; this sender allows %3$d s) | ⛔ Nicht gesendet, zu lang („%1$s“, %2$d s; diese Funktion erlaubt höchstens %3$d s) | checked twice |
| `service_aprs_out_of_band` | This radio tunes %1$s, not %2$s MHz | Dieses Funkgerät deckt %1$s ab, nicht %2$s MHz | checked twice |
| `service_zone_untunable` | Zone %1$s has no channel this radio can tune (%2$s) | Zone %1$s: kein Kanal, den dieses Funkgerät einstellen kann (%2$s) | checked twice |
| `service_zone_untunable_history` | ⚠ Zone %1$s has no channel this radio can tune (%2$s) | ⚠ Zone %1$s: kein Kanal, den dieses Funkgerät einstellen kann (%2$s) | checked twice |
| `service_no_tunable_channel` | ⚠ No channel here this radio can tune (%1$s) | ⚠ Hier kein Kanal, den dieses Funkgerät einstellen kann (%1$s) | checked twice |
| `service_channel_untunable` | %1$s (%2$s MHz) is outside %3$s: this radio cannot tune it | %1$s (%2$s MHz) liegt außerhalb von %3$s: Dieses Funkgerät kann ihn nicht einstellen | checked twice |
| `service_channel_outside` | ⚠ %1$s (%2$s MHz) is outside what this radio can tune (%3$s) | ⚠ %1$s (%2$s MHz) liegt außerhalb dessen, was dieses Funkgerät einstellen kann (%3$s) | checked twice |
| `service_channel_outside_still` | ⚠ %1$s (%2$s MHz) is outside what this radio can tune (%3$s); still on %4$s, %5$s MHz | ⚠ %1$s (%2$s MHz) liegt außerhalb dessen, was dieses Funkgerät einstellen kann (%3$s); weiter auf %4$s, %5$s MHz | checked twice |
| `service_m17_receive_only` | ⚠️ M17 is receive-only until the module firmware has the symbol engine | ⚠️ M17 nur Empfang, bis die Modul-Firmware die Symbol-Engine hat | checked twice |
| `service_tx_untested_profile` | ⛔ Transmit is off on this phone until its profile has been tested | ⛔ Senden ist auf diesem Telefon aus, bis sein Profil getestet ist | checked twice |
| `service_page_out_of_band` | Frequency must be inside %1$s | Die Frequenz muss innerhalb von %1$s liegen | checked twice |
| `service_tx_off_channel` | Transmit is off on this channel | Senden ist auf diesem Kanal aus | checked twice |
| `service_page_too_long` | That page is longer than 25 seconds | Dieser Funkruf dauert länger als 25 Sekunden | checked twice |
| `service_page_over_limit` | That page is longer than the transmit limit (%1$s, Device → Longest transmission) | Dieser Funkruf dauert länger als die Sendezeitbegrenzung (%1$s, Gerät → Längste Aussendung) | checked twice |
| `service_m17_needs_fw_history` | ⚠️ M17 transmit needs the module firmware with the symbol engine | ⚠️ M17-Senden braucht die Modul-Firmware mit Symbol-Engine | checked twice |
| `service_m17_needs_analog_history` | ⚠️ M17 transmit needs an analog channel | ⚠️ M17-Senden braucht einen Analogkanal | checked twice |
| `service_m17_needs_fw` | M17 transmit needs the module firmware with the symbol engine | M17-Senden braucht die Modul-Firmware mit Symbol-Engine | checked twice |
| `service_m17_needs_analog` | M17 transmit needs an analog channel | M17-Senden braucht einen Analogkanal | checked twice |
| `service_receive_only_channel` | Receive-only channel | Kanal nur für Empfang | checked twice |
| `service_tones_over_limit` | Longer than the transmit limit (%1$d s; Device → Longest transmission is %2$s) | Länger als die Sendezeitbegrenzung (%1$d s; Gerät → Längste Aussendung steht auf %2$s) | checked twice |
| `service_heat_stop` | ⛔ %1$s ended early: %2$s. Let the phone cool before the next long transmission. | ⛔ „%1$s“ vorzeitig beendet: %2$s. Lass das Telefon abkühlen, bevor du wieder lange sendest. | checked twice |
| `service_heat_cap` | ⛔ %1$s ended at 30 s: %2$s | ⛔ „%1$s“ nach 30 s beendet: %2$s | checked twice |
| `service_tx_module_timeout` | ⏱ The radio ended the transmission itself: its %1$d s time-out | ⏱ Das Funkgerät hat die Aussendung selbst beendet: seine Zeitbegrenzung von %1$d s | checked twice |
| `service_channel_busy` | ⚠ Channel busy | ⚠ Kanal belegt | checked twice |
| `service_sms_tx_off` | ⛔ Text not sent: transmitting is off on this phone or channel | ⛔ Nachricht nicht gesendet: Senden ist auf diesem Telefon oder Kanal aus | checked twice |
| `service_sched_skip_band` | skipped: channel %1$d is outside %2$s (this radio cannot tune it) | übersprungen: Kanal %1$d liegt außerhalb von %2$s (dieses Funkgerät kann ihn nicht einstellen) | checked twice |
| `service_sched_skipped_band` | %1$s skipped: channel %2$d is outside %3$s (this radio cannot tune it) | %1$s übersprungen: Kanal %2$d liegt außerhalb von %3$s (dieses Funkgerät kann ihn nicht einstellen) | checked twice |
| `service_sched_winlink_not_moved` | ⏰ Scheduled Winlink check: not sent, the radio did not move to channel %1$d | ⏰ Geplanter Winlink-Abruf: nicht gesendet, das Funkgerät hat nicht auf Kanal %1$d gewechselt | checked twice |
| `service_sched_no_aprs` | This radio tunes %1$s, not %2$s MHz: no APRS monitoring | Dieses Funkgerät deckt %1$s ab, nicht %2$s MHz: keine APRS-Überwachung | checked twice |
| `service_sched_channel_outside` | %1$s is outside %2$s: this radio cannot tune it | %1$s liegt außerhalb von %2$s: Dieses Funkgerät kann ihn nicht einstellen | checked twice |
| `service_tx_held` | ⏳ %1$s | ⏳ %1$s | checked twice |
| `service_sos_radio_off` | Not sent: the radio is not on | Nicht gesendet: Das Funkgerät ist nicht eingeschaltet | checked twice |
| `service_sos_receive_only` | Not sent: this channel is receive-only | Nicht gesendet: Dieser Kanal ist nur für den Empfang | checked twice |
| `service_sos_choose_recipient` | Not sent: choose who receives the emergency text | Nicht gesendet: Wähle, wer die Notfall-Nachricht bekommt | checked twice |
| `service_sos_text_sent` | Emergency text sent to %1$s | Notfall-Nachricht an %1$s gesendet | checked twice |
| `service_sos_text_sent_no_fix` | Emergency text sent to %1$s (no position fix) | Notfall-Nachricht an %1$s gesendet (ohne Position) | checked twice |
| `service_sos_no_packet` | Not sent: packet radio is not available | Nicht gesendet: Packet-Radio ist nicht verfügbar | checked twice |
| `service_sos_not_sent` | Not sent: %1$s | Nicht gesendet: %1$s | checked twice |
| `service_sos_aprs_position_sent` | Emergency APRS position sent on %1$s | APRS-Notfallposition auf %1$s gesendet | checked twice |
| `service_sos_aprs_status_sent` | Emergency APRS status (no position fix) sent on %1$s | APRS-Notfallstatus (ohne Position) auf %1$s gesendet | checked twice |
