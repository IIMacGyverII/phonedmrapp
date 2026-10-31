# German screen check (de), round 1: 2026-10-31

**Build:** `i18n/screens` at 7cf2ddd7 (#181), debug, signed with the project key. This is the German draft before the
consistency pass.

**Phone:** Unihertz Atom XL, Android 11, 640 × 1136, compact intercom layout. UI only, by lease from the managing
agent. No transmit. The phone was restored afterwards.

**How:**
- Device → Sprache → Deutsch, then screenshots of each screen, kept outside the repositories.
- Every screenshot was reviewed: no callsign, DMR ID or location in view (only the bench's N0CALL / DMRTST-7).
- The screenshot of Device → SignalDeck Web was deleted, because it shows the web PIN.

## Result per screen

| Screen | Result | Problem → fix |
|---|---|---|
| Gerät: link card | **fix** | „Zurückgeben“ breaks inside the word („Zurückgebe / n“) → `Neo.fit` on the take-over / hand-back buttons (code) |
| Gerät: Funkeinstellungen (Region, Sprache, PTT, Soft SQ, Roger-Beep, Längste Aussendung, Funk-Ansicht, Layout, Animation, Reichweiten-Protokoll, DMR-Roaming, Android Auto rows) | pass | Chip values formatted in code keep the decimal point („1.5 s“) → number formatting through `Txt` (code). The region name „United States“ comes from `regions.json`; its language overlay is a later step. |
| Gerät: SignalDeck Web | pass (layout) | Screenshot deleted (shows the PIN) |
| Funk (intercom) | pass, with notes | The TX/RX readout keeps the dot („467.6250“): the decided decimal comma needs `Txt.freq` (code). „ZONE · ALL“ / „ZONE: ALL“: is ALL part of the key legend, or should it be „ALLE“? (reviewer) |
| Funk: history panel | pass | New lines show in German („Empfangen: 7 s“); lines stored before stay English. The `Msg` storage works on the device. |
| Funk: menu (Zone wählen, Zuletzt gehört, Funkrunden in der Nähe, Karte & Reichweite, Fuchsjagd, Notfall, Klassische Funk-Ansicht) | pass | none |
| Zonen sheet | pass | none |
| Kanäle | pass, with notes | „gehört Oct 28, 22:44“: the date uses US formatting (`Locale.US`), so it should use the app's locale (code). „ZONE ALL“ is the same question as above. |
| Kanal-Editor | **fix** | The header title is cut off („NEUER KAN…“) next to „Speichern“ → let the header title shrink, or use a shorter title (code). The RX help card opens and shows the bands („deckt 400–480 MHz ab“), so the crash fix holds on the device. |
| Kontakte | pass | none |
| Nachrichten | pass, with note | The date is US-formatted („Oct 30“), the same code fix as above. The tab label „NACHRICHTEN“ fits. |
| PKT (Packet-Radio) | pass, with notes | Frequencies inside sentences keep the dot („144.390“, „ISS-APRS 437.825“), the same code fix. `packet_pkt_auto_away`: „…, das dieses Funkgerät nicht einstellen kann“ should be „die“ (Frequenz), with MHz. Buttons wrap between words, as intended (`Neo.fit`). |
| Zuletzt gehört | **fix** | The three buttons break inside words („Aufnah / men“, „Unterti / tel“, „Aktivit / ät“) → `Neo.fit` on that row (code). Alert lines stored before this build stay English (expected). |
| Hilfe & Anleitung (home, „Erste Schritte“) | pass | Reads naturally; the titles fit. |
| Language change | pass | The screen stays on the Gerät tab after the change (fix from #181). Going back to the phone's language clears the override. |

## Code fixes from this round (for #181)
1. **No break inside a word:** `Neo.fit` for Last heard's button row and the take-over / hand-back buttons. Also check
   every other three-button row with icons.
2. **Header title:** the header title shrinks instead of being cut off („NEUER KANAL“).
3. **Dates in the app's locale:** the `Locale.US` date formats with month or day names (research §4.7).
4. **Decimal comma:** frequencies and decimal values shown on screen (`Txt.freq`, `Txt.decimal`), while entry fields
   keep accepting both separators.

## Round 1 fixes (on #181, 2026-10-31; to verify in round 2)
1. **No break inside a word.** `Neo.fit(t, keepIcon)` on every row of shared buttons:
   - Last heard, the link card, the channel selection bar and channel menu, the contact type and contact menu, the
     firmware loader, FT8, logbook, map, Morse trainer, nets, schedule, SSTV, terminal, text modes, repeaters, VFO.
   - A label that fits is unchanged.
   - Otherwise the label wraps between words onto at most two lines, then drops its icon. It shrinks only as a last
     resort (down to 10 sp), as the managing agent asked.
   - Shorter German where natural: the channel menu's „Einstellen“ became „Wählen“.
   - „Bearbeiten“ stays: it is the app-wide „Edit“, the same as Android.
   - Labels that may still shrink, to judge in round 2: Aufnahmen / Untertitel / Aktivität (Last heard), Werkszustand
     (firmware), Kombinieren (SSTV), Nachricht / Bearbeiten (contact menu).
2. **The header title** shrinks (to 11 sp) before it is cut off with „…“.
3. **Dates** follow the app's language (`Txt.dates`): English stays exactly as before, German gets „28. Okt., 22:44“.
   Files, logs and the web API keep their fixed formats.
4. **Decimal comma** on screen (`Txt.decimal`, `Txt.freqMhz`): the intercom readout, the channel list, PKT, VFO pills,
   band scope, map, satellites, POTA, Winlink, chips such as „1,5 s“.
   - Entry fields still show a point and accept a comma too (channel editor, VFO, logbook, pager).
   - Stored history text, files, shared text and the web API stay as they are.
   - Open: coordinates shown as „lat, lon“ keep the point, because a comma between them would be ambiguous. The
     reviewer decides.

## Not checked in this round (next round)
- Every sheet, dialog and toast of the tools (Fuchsjagd, Winlink, SSTV, FT8, M17, Satelliten, POTA, Logbuch,
  Prüfungstraining, Morse, Pager), the firmware loader, the first-run check, Android Auto, the widget and
  notifications.
- SignalDeck Web in a browser (needs a phone with the web server and a single checked run, not a loop).
- The terms the consistency pass changes.
