## strings_common.xml, strings.xml, strings_channel_editor.xml

Checked: 173 strings (20 common, 1 strings.xml, 150 strings + 2 plurals in the channel editor).

| String | Was | Now | Why |
|---|---|---|---|
| channel_editor_h_rxonly | … réponses et toute autre émission (poste d’écoute, canal pour lequel vous n’avez pas de licence, fréquence qui doit rester silencieuse). | … réponses et toute autre émission. Utile pour un poste d’écoute, un canal pour lequel vous n’avez pas de licence ou une fréquence qui doit rester silencieuse. | Back-translation read the parenthesis as a list of things refused; in English it lists uses of the setting. |
| channel_editor_h_sq | De 1 à 9, il se ferme ; … toutes ces valeurs … | Les valeurs de 1 à 9 le ferment ; … elles agissent toutes … | Back-translation: "from 1 to 9 it closes (gradually)"; English: values 1–9 close it. |
| channel_editor_h_name | Les logiciels de codeplug … gardent des noms plus courts | … n’acceptent que des noms plus courts | "gardent" read back as "keep (choose to use)"; the meaning is that they only take 16 characters. |
| channel_editor_h_callfrom | choisit un autre talkgroup pour un moment | choisit temporairement un autre talkgroup | Calque; same meaning, clearer. |

Safety strings checked twice: channel_editor_h_rxonly (receive only, refusal of every transmission, NOAA/marine/railroad always RX only), channel_editor_h_enc (« Le chiffrement est interdit sur les fréquences radioamateur »), channel_editor_h_relay (« risque de ne pas émettre du tout »), channel_editor_o_rx_only, channel_editor_l_transmit / o_allowed, channel_editor_h_power (service power limits), channel_editor_h_tx / h_rx / err_band (tuning range, frequencies that cannot be saved), channel_editor_h_band (Narrow deaf on VHF).
