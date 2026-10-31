# German glossary (de): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-30 from the English UI on
`origin/main`, before any string was extracted. It is for the German reviewer (the tester who asked for German) to agree
or correct, ideally **before any German string is drafted**. Review does not gate the release (owner, 2026-10-30): if
answers come later, the draft is changed to match. Every later German string follows this table, so one English word
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

## 8. Terms settled during the draft (2026-10-31)

Added after the German draft: the terms the eleven translators needed beyond §1–7, and the choices made in the
consistency pass where they had rendered one English term in several ways. The draft now uses the German in the second
column everywhere (screens, SignalDeck Web, the guide). Rows marked **❓** are real choices for the reviewer.

### App features and screens

| English | German | Notes | Reviewer |
|---|---|---|---|
| the Intercom page (in prose) | Funkseite | One word, never "Funk-Seite". The tab stays "Funk" (§1). | |
| Radio controls (car screen) | Funkbedienung | Also "Vollbild-Funkbedienung im Auto". | |
| Parrot (simplex repeater) | Papagei | The app's feature. BrandMeister's echo service (private call 9990) stays "Parrot". ❓ Keep "Parrot" for both? | |
| Voice keyer | Sprachspeicher | | |
| Net preamble / My ID (keyer slots) | Rundeneröffnung / Meine Kennung | | |
| ID timer | Kennungs-Timer | Never "ID-Timer". | |
| ID reminder | Kennungs-Erinnerung | | |
| Morse ID | Morse-Kennung | Also the DTMF command label. | |
| Fox beacon | Fuchssender | The established German fox-hunt word; an exception to §3 "beacon → Bake". ❓ | |
| Be the fox | Selbst Fuchs sein | | |
| bearing / Spin for the bearing | Peilung / Drehpeilung | | |
| mark (fox hunt) | Markierung (prose) · Punkt (buttons: „Punkt speichern“, „Punkte löschen“) | The buttons are a third of a row wide. ❓ One word for both? | |
| Download terrain / Terrain | Gelände herunterladen / Gelände | "Herunterladen" per §2 (Download). | |
| Terrain prediction | Geländevorhersage | Never "Geländeprognose". | |
| Key-ups (coverage layer) | Auftasten | | |
| Mapping coverage | Reichweite wird erfasst | Notification and widget text. | |
| Log coverage in the car | Reichweite im Auto protokollieren | | |
| Nearby repeaters | Relais in der Nähe | | |
| Nets near you | Funkrunden in der Nähe | Short form "Runde" only where the net is already named. | |
| On the air near you / Elsewhere on the air | In deiner Nähe auf Sendung / Anderswo auf Sendung | | |
| Nets on this channel (editor section) | Funkrunden hier | Comment asks for one or two words. | |
| Add a net | Funkrunde hinzufügen | | |
| check-in (net control) | Check-in, verb einchecken; button „Einchecken“ | "Anmeldung" also means log-in on SignalDeck Web. ❓ "Anmeldung" is the older German net word. | |
| traffic (net flag) | Verkehr | | |
| Late / Out (net flags) | Verspätet / Abgemeldet | Report lines: "verspätet", "abgemeldet". | |
| Scheduled operations / schedule | Geplante Aktionen / Zeitplan | „Zeitplan hinzufügen“. | |
| APRS monitoring | APRS-Mithören (das) | Never "Überwachung" (reads as surveillance). | |
| Pager monitor | Pager-Mithören | | |
| Monitor APRS (button) | APRS mithören | Verb form on buttons only. | |
| Packet finder | Packet-Suche | | |
| page (POCSAG message) | Funkruf / Pager-Nachricht | Both are in the draft. ❓ Pick one. | |
| Hear pages | Pager empfangen | | |
| Winlink e-mail / Check Winlink mail | Winlink-E-Mail / Winlink-Mail abrufen | Never "Winlink-Post". | |
| Session log / Detailed diagnostic log | Sitzungsprotokoll / Ausführliches Diagnoseprotokoll | | |
| Two-way iGate | Zwei-Wege-iGate | | |
| Packet lead-in | Packet-Vorlauf | | |
| Beacon via ISS | Bake über die ISS | | |
| Record each pass | Jeden Überflug aufnehmen | | |
| satellite pass | Satellitenüberflug | One word. | |
| orbit data | Bahndaten | | |
| Text modes | Textbetriebsarten | | |
| Any mode (SSTV decoder) | Jeder Modus | An SSTV mode (Martin, Scottie), not a §3 Betriebsart. | |
| Combine (SSTV) / In / Left out | Kombinieren / Dabei / ausgelassen | | |
| Voice announcements | Sprachansagen | | |
| keyword alerts | Stichwort-Alarme | | |
| Contribute | Mitwirken | | |
| Help support this phone | Hilf mit, dieses Telefon zu unterstützen | "Help us support this phone" (first-launch title): „Hilf uns, dieses Telefon zu unterstützen“. | |
| Radio audio check | Funkaudio-Prüfung | | |
| Listen check / Second radio test | Hörprüfung / Test mit zweitem Funkgerät | | |
| Transmit test session | Sendetest-Sitzung | | |
| Bring radio up (diagnostics) | Funk starten | Four buttons in a row. | |
| Probe + power pulse | Abfrage + Stromimpuls | | |
| Restore factory (firmware button) | Werkszustand | One of three buttons in a row. | |
| POTA activation / On the air now | Aktivierung / Jetzt QRV | | |
| contact (logbook) | Verbindung | A DMR contact stays "Kontakt" (§4); „Verbindung eintragen“, „Erneut loggen“. | |
| Log heard | Gehörte loggen | | |
| Exam practice: Study a subelement / Missed | Abschnitt lernen / Falsch | Topic label per §1: "US-Prüfung (englisch)". | |
| Hold to talk (M17) | Zum Sprechen halten | | |
| Open in maps | In Maps öffnen | | |

### Firmware and the phone

| English | German | Notes | Reviewer |
|---|---|---|---|
| phone | Telefon | Never "Handy" (§3 follows Android's German UI). | |
| bench firmware / bench image | Labor-Firmware / Labor-Image | Never "Bench-" or "Prüfstand-Firmware". "auf dem Prüfstand" stays for measurements. ❓ | |
| stock firmware / factory image | Werks-Firmware | As §6 "factory image". | |
| stock version (SignalDeck Web) | Werksversion | | |
| factory backup / factory copy | Werks-Sicherung / Werks-Kopie | With hyphen. | |
| stock ROM (Android) | Original-ROM | Not firmware; "Stock-ROM" is also common. ❓ | |
| symbol engine / tone generator | Symbol-Engine / Tongenerator | | |
| Own the radio at boot | Funkmodul beim Start übernehmen | §1 "Funkmodul übernehmen". | |
| Keep access after reboot | Zugriff nach Neustart behalten | | |
| Turn the radio off and exit | Funkmodul ausschalten und beenden | | |
| Hand back to the stock app and exit | An die Hersteller-App zurückgeben und beenden | | |
| Radio busy, loading firmware | Funkgerät belegt, Firmware wird geladen | | |
| Allow unlisted images | Nicht gelistete Images erlauben | | |
| Web access / Allow transmit from the web | Web-Zugriff / Senden aus dem Web erlauben | | |
| amber (UI colour) | orange | "orangefarben" where an inflected adjective is needed. | |

### Channel editor and lists

| English | German | Notes | Reviewer |
|---|---|---|---|
| All / Private / Group (call type choice) | Alle / Einzel / Gruppe | Short forms of §4 Gruppenruf / Einzelruf, for pills. | |
| All call (contact type) | Sammelruf | | |
| Relay (repeater) | Relais (Repeater) | | |
| Call number from / call number | Quelle der Rufnummer / Rufnummer | | |
| Channel access number (M17) | Kanalzugangsnummer | | |
| Double slot | Doppelslot | | |
| Interrupt transmission | Sendeunterbrechung | | |
| RX tone type / TX tone type | Empfangston-Art / Sendeton-Art | | |
| None (tone) | Kein | | |
| High / Low power (choices) | Hoch / Niedrig | §3. | |
| Enabled / Disabled (choices) | Aktiviert / Deaktiviert | | |
| Latitude / Longitude | Breitengrad / Längengrad | | |
| Destination (@ALL or a callsign) | Ziel (@ALL oder Rufzeichen) | | |
| NOT TUNABLE (badge) | AUSSERHALB | Badge cut off at 16 characters on a 480 px screen. ❓ | |
| RX ONLY (badge) | NUR RX | | |
| Not legal here | Hier nicht erlaubt | | |
| Show all lists | Alle Listen zeigen | | |
| Star (button) | Favorit | The icon is still "Stern" in prose. | |
| Out of zone (button) | Aus Zone | Four buttons share a row. | |
| Zone name | Zonenname | | |
| Marine VHF | Seefunk (UKW) | | |
| NOAA weather | NOAA-Wetterfunk | | |
| Home (contact location) | Zuhause | | |

### Wording rules settled

| English | German | Notes | Reviewer |
|---|---|---|---|
| Stop … (button) | … stoppen | §2 Start/Stop. "Beenden" only for End (a net, a session, the app). | |
| Halt TX | TX stoppen | | |
| Try again | Erneut versuchen | §2 Retry. | |
| Loading… / Sending… | Wird geladen… / wird gesendet… | No space before the ellipsis, as in English. | |
| Set your callsign first | Trage zuerst dein Rufzeichen ein | "Trage", not "Trag" or "Stelle … ein". | |
| Coverage logging is on | Reichweiten-Protokoll ist an | "an/aus" in sentences, "Ein/Aus" on switch labels (§2). | |
| No position fix yet | Noch keine Position | | |
| Key legends SCAN, ZONE, TXT, SOFT SQ, MON, REC, VFO, PKT | unchanged | Checked across all files: no legend is translated. "Soft-SQ-Stufe" keeps the name in a compound (style §4). The car screen's own Scan button is "Suchlauf". | |
| weekday buttons (one letter) | M D M D F S S | German calendar convention, as Android's. Three-letter days: Mo. Di. Mi. Do. Fr. Sa. So. | |
