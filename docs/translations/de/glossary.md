# German glossary (de): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-30 from the English UI on
`origin/main`, before any string was extracted. It is for the German reviewer (the tester who asked for German) to agree
or correct, **before any German string is drafted**. Every later German string follows this table, so one English word
is never rendered three ways.

- **How to review:** for each row, keep it or write the better term in the last column. Rows marked **❓** are real
  choices where German ham usage is split; the reviewer decides.
- **Register:** *du* (see `style.md` §1).
- **Order:** app navigation, buttons, radio terms, DMR, digital modes, safety and licence, then units and symbols.

## 1. App structure: tabs, pages, features

| English | German | Why / notes | Reviewer |
|---|---|---|---|
| SignalDeck | SignalDeck | Product name, never translated. | |
| SignalDeck Web | SignalDeck Web | Product name. | |
| Intercom (tab, main page) | Funk | "Intercom" in German means a door intercom (*Gegensprechanlage*). "Funk" is short, clear on a tab, and what a German ham calls the main radio view. ❓ Alternatives: *Sprechfunk*, keep *Intercom*. | |
| Channels (tab) | Kanäle | Standard. | |
| Contacts (tab) | Kontakte | Standard (DMR contacts too). | |
| Messages (tab) | Nachrichten | Standard Android term. | |
| Device (tab) | Gerät | Matches Android's German UI. | |
| Settings | Einstellungen | Android standard. | |
| Radio settings | Funkeinstellungen | Short compound; reads naturally. | |
| Last heard | Zuletzt gehört | Common in German DMR dashboards (BrandMeister DE shows "Zuletzt gehört"). | |
| Activity | Aktivität | | |
| Activity statistics | Aktivitätsstatistik | | |
| Alerts (list in Last heard) | Warnungen | The list holds warnings and refusals; *Meldungen* is too weak for "transmission refused". | |
| Car and coverage | Auto und Reichweite | | |
| Guide / Help | Anleitung | "Hilfe" for the menu entry, "Anleitung" for the guide itself. | |
| Getting started | Erste Schritte | Standard. | |
| Good to know | Gut zu wissen | | |
| Take over (the radio) | Übernehmen | "Funkmodul übernehmen" in prose. | |
| Hand back | Zurückgeben | Pair with *Übernehmen*. | |
| Stock app (the phone maker's radio app) | Hersteller-App | "Stock" has no good German equivalent; *Original-App* is also fine. ❓ | |
| Device report | Gerätebericht | | |
| Transmit test | Sendetest | | |
| First-run check | Ersteinrichtungs-Test | ❓ *Erstprüfung* is shorter. | |
| Module firmware | Modul-Firmware | | |
| Radio module | Funkmodul | | |
| About this radio | Über dieses Funkgerät | | |
| Live captions (TXT) | Live-Untertitel | Android uses *Automatische Untertitel*; "Live-Untertitel" is short and clear. | |
| Keywords (caption alerts) | Stichwörter | | |
| Recording(s) | Aufnahme(n) | | |
| Recordings player | Aufnahmen-Player | | |
| Transcript | Mitschrift | Natural German for a running text record. | |
| Coverage logging | Reichweiten-Protokoll | "Reichweite" is what a ham checks with a repeater; "Abdeckung" sounds like mobile networks. ❓ | |
| Coverage map | Reichweitenkarte | Follows the line above. | |
| Map | Karte | | |
| Band scope | Bandscope | Used as-is by German hams (Icom/Yaesu DE manuals say "Bandscope"); *Spektrumanzeige* in prose where it helps. | |
| Fox hunt | Fuchsjagd | The established German term (ARDF: *Amateurfunkpeilen*). | |
| Nets | Funkrunden | A net is a *Runde* in German ham speech. | |
| Net control | Rundenleitung | | |
| Logbook | Logbuch | | |
| Exam practice | Prüfungstraining | The pools are the US exam in English: label the topic "US-Prüfung (englisch)". | |
| Conditions (propagation) | Ausbreitungsbedingungen | Short form on tight labels: *Bedingungen*. | |
| Satellites | Satelliten | | |
| Pass (satellite) | Überflug | | |
| Emergency | Notfall | | |
| Restricted mode | Sperrmodus | A voluntary PIN lock; *Eingeschränkter Modus* reads like an Android system state. ❓ | |
| Widget | Widget | Android standard. | |
| Android Auto | Android Auto | Product name. | |
| Zone | Zone | Same word on German DMR radios. | |
| All channels | Alle Kanäle | | |
| Favourites | Favoriten | | |
| Priority channel | Prioritätskanal | | |
| Make scan priority | Als Prioritätskanal | Button: short. | |
| Busiest channels (zone name) | Meiste Aktivität | A zone name the app creates; reads better than *Belebteste Kanäle*. | |
| Restricted PIN | Sperr-PIN | | |

## 2. Buttons and common actions

Buttons are infinitives (Android German style), capitalised as German requires.

| English | German | Notes | Reviewer |
|---|---|---|---|
| OK | OK | | |
| Cancel | Abbrechen | | |
| Save | Speichern | | |
| Delete | Löschen | | |
| Close | Schließen | | |
| Done | Fertig | | |
| Back | Zurück | | |
| Next / Previous (guide pages) | Weiter / Zurück | | |
| Continue | Weiter | | |
| Later | Später | | |
| Not now | Nicht jetzt | | |
| Clear | Leeren | For lists. "Zurücksetzen" for fields. | |
| Start / Stop | Starten / Stoppen | | |
| End (a net, a session) | Beenden | | |
| Send | Senden | Also "transmit" in radio context; see §3. | |
| Share | Teilen | Android standard. | |
| Import / Export | Importieren / Exportieren | | |
| Download | Herunterladen | | |
| Load (firmware) | Laden | "Firmware laden", not *flashen* in UI text. | |
| Connect | Verbinden | | |
| Defaults | Standardwerte | | |
| Use (a channel) | Einstellen | You set the radio to the channel. | |
| Use it anyway | Trotzdem verwenden | | |
| Tune (a frequency) | Einstellen | | |
| Edit | Bearbeiten | | |
| Add | Hinzufügen | | |
| Rename | Umbenennen | | |
| Search | Suchen | | |
| Retry | Erneut versuchen | | |
| Allow | Zulassen | Matches Android permission dialogs. | |
| Turn on / Turn off | Einschalten / Ausschalten | Switch rows: just the label, no verb. | |
| On / Off | Ein / Aus | | |
| Tap | tippen (auf) | Android German: "Tippe auf …". | |
| Long-press | lange drücken | "Drücke lange auf SCAN". | |
| Swipe | wischen | | |
| Put in the outbox | In den Postausgang | Winlink/messages. | |

## 3. Radio and ham terms

| English | German | Why / notes | Reviewer |
|---|---|---|---|
| radio (the device) | Funkgerät | | |
| radio (the activity) | Funk | | |
| ham, radio amateur | Funkamateur | Gender-neutral alternative where it matters: "wer Amateurfunk betreibt". | |
| amateur radio | Amateurfunk | | |
| callsign | Rufzeichen | | |
| licence | Zulassung (Amateurfunkzulassung) | Germany issues a *Zulassung zur Teilnahme am Amateurfunkdienst*; "Lizenz" is common colloquially. ❓ | |
| channel | Kanal (pl. Kanäle) | | |
| frequency | Frequenz | | |
| transmit (verb) | senden | | |
| transmission (one over) | Aussendung | The German ham term; "Durchgang" for a single over in a QSO. | |
| receive | empfangen | | |
| reception | Empfang | | |
| receive-only | nur Empfang | | |
| talk key (the big round button) | Sprechtaste | | |
| PTT | PTT | Kept; "PTT-Taste" in prose. | |
| side PTT button | seitliche PTT-Taste | | |
| squelch | Rauschsperre | The term German manuals use; hams also say "Squelch". The feature name **Soft SQ** stays. ❓ | |
| squelch level | Rauschsperren-Stufe | Short form "SQL-Stufe" on tight labels. | |
| Soft SQ | Soft SQ | Feature name, kept. Explained once as "Software-Rauschsperre". | |
| noise squelch | Rausch-Squelch | ❓ Prose only. | |
| scan (verb / noun) | absuchen / Suchlauf | Key legend stays **SCAN** (decided; `style.md` §6). | |
| zone | Zone | | |
| VFO | VFO | | |
| repeater | Relais (pl. Relais) | The usual German ham word; "Repeater" is understood in DMR circles. ❓ | |
| repeater offset / shift | Ablage | Established term (*Relaisablage*). | |
| simplex / duplex | Simplex / Duplex | | |
| CTCSS | CTCSS | "CTCSS-Ton" in prose; *Subton* is also understood. | |
| DCS | DCS | | |
| tone (CTCSS) | Ton | "Empfangston" / "Sendeton" for RX/TX tone. | |
| power (transmit) | Sendeleistung | Short labels: "Leistung". | |
| high / low (power) | Hoch / Niedrig | | |
| bandwidth wide / narrow | Breit / Schmal | With values: 25 kHz / 12,5 kHz. | |
| channel step | Kanalraster | | |
| mode (FM, DMR …) | Betriebsart | The correct ham term (Bundesnetzagentur usage). | |
| analog / digital | analog / digital | | |
| signal strength | Signalstärke | | |
| S-meter | S-Meter | | |
| noise floor | Grundrauschen | | |
| NO SIGNAL | KEIN SIGNAL | | |
| channel busy | Kanal belegt | | |
| key up (a repeater) | auftasten | Established German ham verb. | |
| repeater tail | Nachlauf | | |
| roger beep | Roger-Beep | Common in German usage; *Quittungston* is the formal term. ❓ | |
| QSO, CQ, 73, QTH | unchanged | International Q-codes and ham shorthand. | |
| location | Standort | "QTH" in ham-flavoured text. | |
| locator / grid square | Locator | Germans say "QTH-Locator" or "Locator". | |
| band | Band | | |
| band plan | Bandplan | | |
| VHF / UHF | VHF / UHF | Germans also say 2 m / 70 cm: use those in prose where the band is meant. | |
| propagation | Ausbreitung | | |
| antenna | Antenne | | |
| dummy load | Kunstantenne | | |
| interference | Störung | | |
| identification (repeater ID) | Kennung | | |
| Morse | Morse / CW | | |
| beacon | Bake | APRS: "APRS-Bake". | |
| heard station | gehörte Station | | |

## 4. DMR

| English | German | Why / notes | Reviewer |
|---|---|---|---|
| DMR | DMR | | |
| talkgroup | Sprechgruppe (TG) | BrandMeister DE and DARC use *Sprechgruppe*. On tight labels "TG". | |
| colour code | Colorcode (CC) | German DMR usage keeps the English word. | |
| time slot | Zeitschlitz (TS) | | |
| private call / group call | Einzelruf / Gruppenruf | | |
| DMR ID | DMR-ID | (Never a real ID in examples.) | |
| contact | Kontakt | | |
| receive group list | Empfangsgruppenliste | Long; short form "RX-Gruppen". ❓ | |
| hotspot | Hotspot | | |
| codeplug | Codeplug | Kept by German DMR users. | |
| CALL · PICKED | RUF · GEWÄHLT | Intercom cell legend. | |
| promiscuous mode (MON) | Alle hören (MON) | ❓ For prose; the key legend MON stays (decided). | |

## 5. Digital modes and data

| English | German | Notes | Reviewer |
|---|---|---|---|
| APRS, AX.25, iGate, digipeater | unchanged | | |
| APRS-IS, passcode | APRS-IS, Passcode | | |
| packet radio | Packet-Radio | | |
| position (APRS) | Position | | |
| telemetry | Telemetrie | | |
| weather report | Wetterbericht | | |
| message (APRS/DMR text) | Nachricht | | |
| outbox / inbox | Postausgang / Posteingang | | |
| SSTV, FT8, M17, POCSAG, Winlink, DTMF | unchanged | | |
| picture (SSTV) | Bild | | |
| pager | Pager | Germans say *Pager* or *Funkmeldeempfänger*. | |
| decode / decoder | dekodieren / Decoder | | |
| forms (Winlink) | Formulare | | |

## 6. Safety, licence, heat

Safety text gets a second careful pass (plan §4). These renderings must stay this strong.

| English | German | Notes | Reviewer |
|---|---|---|---|
| Warning | Warnung | | |
| Caution | Achtung | | |
| Transmitting legally | Legal senden | Guide section title. | |
| You need a licence to transmit on this frequency. | Für das Senden auf dieser Frequenz brauchst du eine Amateurfunkzulassung. | The pattern for licence notes. | |
| transmit limit / time limit | Sendezeitbegrenzung | | |
| Longest transmission | Längste Aussendung | Device setting. | |
| heat guard | Überhitzungsschutz | | |
| too hot | zu heiß | | |
| transmit refused | Senden abgelehnt | | |
| Not sent | Nicht gesendet | | |
| advisory (from the profile list) | Warnhinweis | | |
| firmware loader | Firmware-Lader | | |
| factory image | Werks-Firmware | | |
| do not switch off | nicht ausschalten | Firmware loading: always in bold, never softened. | |
| emergency | Notfall | | |

## 7. Units, numbers, symbols

| English | German | Notes |
|---|---|---|
| 467.625 MHz | 467,625 MHz | Decimal comma everywhere on screen, the readout included; entry fields accept `,` and `.` (decided; reviewer to confirm). |
| 12.5 kHz | 12,5 kHz | |
| −85 dBm | −85 dBm | Unit unchanged, space before the unit. |
| 30 s, 2 min | 30 s, 2 min | |
| 5 W | 5 W | |
| 24-hour time | 24-Stunden-Format (14:05) | |
| date | 30.10.2026 / 30. Okt. 2026 | |
| → (menu path) | → | Kept: "Gerät → Funkeinstellungen". |
| "…" quotes | „…“ | German typographic quotes, never in titles (Orbitron lacks „). |
