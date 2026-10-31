# Back-check: strings_channel_editor.xml (de)

Each German string was translated back into English without the source, then compared with the English source for
meaning, negations, numbers and units.

**Strings checked:** 150 strings + 2 plurals (4 plural forms) = 154 texts.

## Changes made after the back-check

| String | Problem found | Fix |
|---|---|---|
| `channel_editor_l_callfrom` (+ `_no_private_msg`, `_no_group_msg`) | "Rufnummer aus" + choice "Eingabe" read as "call number from input", unnatural. | Label „Quelle der Rufnummer“ ("source of the call number"), choices „Eingabe“ / „Kontakte“; the two dialog messages quote the new label. |
| `channel_editor_h_txt` | Draft said "an inaudibly low tone … CTCSS (a low tone …)": redundant. | „Ein Subton, der mit deiner Aussendung mitgesendet wird“ (the German ham term for a sub-audible tone). |

No string lost or gained a negation, and no number or unit changed (62,5 / 254,1 Hz, 12,5 / 25 kHz, ±0,6 MHz, +5 MHz,
300 MHz, 220 MHz, −90 dBm, 0–15, 1–9, 8 characters, 32 talkgroups, 16 characters, ID 16777215, 10 minutes all kept).

Nuance only:
- `channel_editor_o_private` „Einzel“ (Private): matches the contact type in strings_intercom and the glossary's
  *Einzelruf*.
- `channel_editor_sec_nets` „Funkrunden hier“ ("nets here"): short section heading.
- The `channel_editor_what_*` fragments are in the accusative (die/den/jeden …) because both `err_enter`
  („Gib %1$s ein“) and `err_not_number` („… Prüfe %2$s“) take an accusative object.

## Source issue found (English, not fixed here)

`channel_editor_h_tx` and `channel_editor_h_rx` use `%1$d`, but `ChannelEditorView.H_TX()/H_RX()` pass
`DeviceProfile.detect().bandsText()`, a String. `String.format` throws `IllegalFormatConversionException` (d != String)
when those help cards open, in English and German alike. The English should be `%1$s` (and the comment, copied from
`h_name`, describes the wrong argument). The German keeps `%1$d` so the placeholder check matches; change both together.

## SAFETY strings: checked twice

- `channel_editor_h_rxonly` (never transmits; every transmission refused; NOAA/marine/rail always receive only): checked twice
- `channel_editor_h_enc` (encryption not allowed on amateur frequencies): checked twice
- `channel_editor_h_power` (some services limit power): checked twice
- `channel_editor_h_band` (Narrow makes the receiver deaf on VHF): checked twice
- `channel_editor_h_relay` (Disconnect may not transmit at all): checked twice
- `channel_editor_l_transmit`: checked twice
- `channel_editor_o_allowed`: checked twice
- `channel_editor_o_rx_only`: checked twice
- `channel_editor_h_key` (used only when Encrypt is Enabled): checked twice
