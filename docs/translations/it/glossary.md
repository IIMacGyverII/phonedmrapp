# Italian glossary (it): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-30 from the English UI
(`SignalDeck-i18n`, `res/values/strings_*.xml` and the guide), before any Italian string was drafted. It is for an
Italian-speaking ham reviewer to agree or correct. Review does not gate the release (owner, 2026-10-30): if answers
come later, the draft is changed to match. Every later Italian string follows this table, so one English word is never
rendered three ways.

- **How to review:** for each row, keep it or write the better term in the last column. Rows marked **❓** are real
  choices where Italian ham usage is split; the reviewer decides.
- **Guide used:** the way Italian radioamatori write in ARI material (RadioRivista, ARI sections' pages, the ARI band
  plan), Italian DMR community pages (BrandMeister Italia, DMR-Italia) and the Italian manuals of Icom, Yaesu and
  Kenwood. Where Italian hams keep the English word (squelch, shift, talkgroup, beacon), the glossary keeps it too.
- **Register:** *tu* (see `style.md` §1).
- **Order:** app navigation, buttons, radio terms, DMR, digital modes, safety and licence, units and symbols, then the
  terms settled while drafting (§8, every term of the German §8 with its Italian rendering).

## 1. App structure: tabs, pages, features

| English | Italian | Why / notes | Reviewer |
|---|---|---|---|
| SignalDeck | SignalDeck | Product name, never translated. | |
| SignalDeck Web | SignalDeck Web | Product name. | |
| Intercom (tab, main page) | Radio | "Interfono" is a door or office intercom, not a radio. "Radio" is short on a tab and is what an Italian ham calls the main view. ❓ Alternatives: *Ricetrasmettitore* (too long), keep *Intercom*. | |
| Channels (tab) | Canali | Standard. | |
| Contacts (tab) | Contatti | Standard (DMR contacts too). | |
| Messages (tab) | Messaggi | Android standard. | |
| Device (tab) | Dispositivo | Matches Android's Italian UI. | |
| Settings | Impostazioni | Android standard. | |
| Radio settings | Impostazioni radio | | |
| Last heard | Ultimi ascoltati | Italian hams also keep "Last Heard" (dashboard column). "Ascoltati" is the ham verb (*ascoltare* a station), not *sentiti*. ❓ | |
| Activity | Attività | | |
| Activity statistics | Statistiche attività | | |
| Alerts (list in Last heard) | Avvisi | The list holds warnings and refusals. *Notifiche* would clash with Android notifications. | |
| Car and coverage | Auto e copertura | | |
| Guide / Help | Guida / Aiuto | "Aiuto" for the menu entry, "Guida" for the guide itself. | |
| Getting started | Primi passi | Standard in Italian software. | |
| Good to know | Buono a sapersi | | |
| Take over (the radio) | Prendi il controllo | "Prendere il controllo del modulo radio" in prose. Button: *Prendi controllo* if space is short. | |
| Hand back | Restituisci | Pairs with *Prendi il controllo*. | |
| Stock app (the phone maker's radio app) | App originale | "Stock" is used by Android modders, not by most hams. ❓ *App del produttore* is the alternative. | |
| Device report | Rapporto dispositivo | "Report" is common too; *rapporto* reads cleaner. | |
| Transmit test | Prova di trasmissione | Italian hams say *prova*, not *test*, for a quick check. | |
| First-run check | Verifica iniziale | ❓ *Controllo al primo avvio* is more literal and longer. | |
| Module firmware | Firmware del modulo | | |
| Radio module | Modulo radio | | |
| About this radio | Informazioni su questa radio | Android "About" is *Informazioni*. | |
| Live captions (TXT) | Sottotitoli in tempo reale | Android's Italian name for Live Caption. Short form *Sottotitoli*. | |
| Keywords (caption alerts) | Parole chiave | | |
| Recording(s) | Registrazione / Registrazioni | | |
| Recordings player | Lettore registrazioni | | |
| Transcript | Trascrizione | | |
| Coverage logging | Registrazione copertura | *Copertura* is natural Italian for a repeater too ("la copertura del ponte"). | |
| Coverage map | Mappa di copertura | | |
| Map | Mappa | | |
| Band scope | Band scope | Kept as in Italian Icom/Yaesu manuals; *panoramica di banda* in prose where it helps. ❓ | |
| Fox hunt | Caccia alla volpe | The established Italian term (ARDF: *radiogoniometria sportiva*). | |
| Nets | Ruote | A round-table net is a *ruota* in Italian ham speech. Emergency or traffic nets are also called *net*. ❓ | |
| Net control | Conduzione della ruota | The station is *il conduttore (della ruota)*. ❓ | |
| Logbook | Log | Italian hams say "il log" or "logbook"; *quaderno di stazione* is the old formal term. ❓ | |
| Exam practice | Esercitazione esame | The pools are the US exam in English: label the topic "Esame USA (in inglese)". | |
| Conditions (propagation) | Condizioni di propagazione | Short form on tight labels: *Propagazione*. | |
| Satellites | Satelliti | | |
| Pass (satellite) | Passaggio | | |
| Emergency | Emergenza | | |
| Restricted mode | Modalità protetta | A voluntary PIN lock. *Modalità limitata* reads like a fault. ❓ | |
| Widget | Widget | Android standard (masculine: *il widget*). | |
| Android Auto | Android Auto | Product name. | |
| Zone | Zona | The Italian manuals of DMR radios say *zona*. | |
| All channels | Tutti i canali | | |
| Favourites | Preferiti | Android standard. | |
| Priority channel | Canale prioritario | | |
| Make scan priority | Rendi prioritario | Button: short. | |
| Busiest channels (zone name) | Più attivi | A zone name the app creates. | |
| Restricted PIN | PIN di protezione | Follows *Modalità protetta*. | |

## 2. Buttons and common actions

Buttons use the *tu* imperative, as Android's Italian UI does (Annulla, Salva, Elimina). Only the first word is
capitalised.

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| OK | OK | | |
| Cancel | Annulla | | |
| Save | Salva | | |
| Delete | Elimina | | |
| Close | Chiudi | | |
| Done | Fatto | | |
| Back | Indietro | | |
| Next / Previous (guide pages) | Avanti / Indietro | | |
| Continue | Continua | | |
| Later | Più tardi | | |
| Not now | Non ora | | |
| Clear | Svuota | For lists. *Cancella* for a field. | |
| Start / Stop | Avvia / Interrompi | Android Italian. *Ferma* where the English is "Halt". | |
| End (a net, a session) | Termina | | |
| Send | Invia | Messages and data. "Transmit" in radio context is *trasmetti*; see §3. | |
| Share | Condividi | | |
| Import / Export | Importa / Esporta | | |
| Download | Scarica | | |
| Load (firmware) | Carica | "Carica firmware", never *flasha* in UI text. | |
| Connect | Connetti | | |
| Defaults | Valori predefiniti | Button: *Predefiniti*. | |
| Use (a channel) | Sintonizza | You tune the radio to the channel. | |
| Use it anyway | Usa comunque | | |
| Tune (a frequency) | Sintonizza | | |
| Edit | Modifica | | |
| Add | Aggiungi | | |
| Rename | Rinomina | | |
| Search | Cerca | | |
| Retry | Riprova | | |
| Allow | Consenti | Matches Android permission dialogs. | |
| Turn on / Turn off | Attiva / Disattiva | Switch rows: just the label, no verb. | |
| On / Off | On / Off | Android Italian switches show no text; in sentences *attivo / disattivato*. ❓ *Sì / No* on chips? | |
| Tap | tocca | Android Italian: "Tocca **Salva**". | |
| Long-press | tieni premuto | "Tieni premuto SCAN". | |
| Swipe | scorri | | |
| Put in the outbox | Metti in uscita | Winlink/messages. | |

## 3. Radio and ham terms

| English | Italian | Why / notes | Reviewer |
|---|---|---|---|
| radio (the device) | radio (la radio), apparato | *La radio* in UI text; *apparato* is the ham word in prose ("l'apparato"). Never *ricetrasmittente* on labels (too long). | |
| radio (the activity) | radio | "fare radio". | |
| ham, radio amateur | radioamatore | Gender-neutral where it matters: "chi fa radio", "chi trasmette". | |
| amateur radio | radiantismo, servizio di radioamatore | *Radiantismo* in friendly prose, *servizio di radioamatore* in legal text. | |
| callsign | nominativo | The ARI and ministry term. | |
| licence | patente di radioamatore | In Italy the exam gives the *patente*; the right to operate is the *autorizzazione generale*. Hams say "la patente". Legal sentences: "patente e autorizzazione". ❓ | |
| channel | canale (pl. canali) | | |
| frequency | frequenza | | |
| transmit (verb) | trasmettere | | |
| transmission (one over) | trasmissione | A single over in a QSO is *il cambio* in ham speech ("passo il cambio"); prose only. | |
| receive | ricevere | | |
| reception | ricezione | | |
| receive-only | solo ricezione | Badge: *SOLO RX*. | |
| talk key (the big round button) | tasto di trasmissione | ❓ *Tasto PTT* is shorter and common. | |
| PTT | PTT | Kept; "tasto PTT" in prose. | |
| side PTT button | tasto PTT laterale | | |
| squelch | squelch | Italian hams and manuals say *squelch*; *silenziamento* is rare. The feature name **Soft SQ** stays. ❓ | |
| squelch level | livello di squelch | Short form "Livello SQL". | |
| Soft SQ | Soft SQ | Feature name, kept. Explained once as "squelch software". | |
| noise squelch | squelch a rumore | Prose only. ❓ | |
| scan (verb / noun) | scansionare / scansione | Key legend stays **SCAN** (decided; `style.md` §6). | |
| zone | zona | | |
| VFO | VFO | Masculine: *il VFO*. | |
| repeater | ponte ripetitore, ponte | *Ponte* on labels and in most prose; *ponte ripetitore* the first time in a guide topic. *Ripetitore* is understood; "repeater" is used in DMR circles. ❓ | |
| repeater offset / shift | shift | What Italian hams say ("shift −600 kHz"); *offset* is also understood. ❓ | |
| simplex / duplex | simplex / duplex | Italian also says *isofrequenza* for simplex; use it only in prose. | |
| CTCSS | CTCSS | "Tono CTCSS" in prose; *subtono* is the everyday word. ❓ Which on labels? | |
| DCS | DCS | | |
| tone (CTCSS) | tono | "Tono RX" / "Tono TX". | |
| power (transmit) | potenza | | |
| high / low (power) | Alta / Bassa | | |
| bandwidth wide / narrow | Larga / Stretta | With values: 25 kHz / 12,5 kHz. | |
| channel step | passo di canalizzazione | Short label: *Passo* (Italian manuals also write *step*). | |
| mode (FM, DMR …) | modo | Italian ham usage: "in modo FM", "modi digitali". *Modalità* only for app modes (restricted mode). | |
| analog / digital | analogico / digitale | | |
| signal strength | intensità del segnale | | |
| S-meter | S-meter | Masculine. | |
| noise floor | rumore di fondo | | |
| NO SIGNAL | NESSUN SEGNALE | | |
| channel busy | canale occupato | | |
| key up (a repeater) | aprire il ponte | The Italian ham idiom ("ho aperto il ponte"). | |
| repeater tail | coda del ponte | | |
| roger beep | roger beep | Common in Italian usage; *beep di fine trasmissione* in prose. ❓ | |
| QSO, CQ, 73, QTH | unchanged | International Q-codes and ham shorthand. | |
| location | posizione | "QTH" in ham-flavoured text. | |
| locator / grid square | locatore (QTH locator) | ARI writes *locatore* and *QTH locator*. | |
| band | banda | | |
| band plan | band plan / piano di banda | ARI publishes the *band plan*; *piano di banda* in prose. ❓ | |
| VHF / UHF | VHF / UHF | Italian hams also say 2 m / 70 cm ("i due metri"); use those in prose where the band is meant. | |
| propagation | propagazione | | |
| antenna | antenna | | |
| dummy load | carico fittizio | | |
| interference | interferenza, disturbo | *Disturbo* for local noise, *interferenza* for another signal. | |
| identification (repeater ID) | identificativo | | |
| Morse | Morse / CW | ("telegrafia" in formal prose) | |
| beacon | beacon | Italian hams say *beacon* (also *radiofaro*). APRS: "beacon APRS". | |
| heard station | stazione ascoltata | | |

## 4. DMR

| English | Italian | Why / notes | Reviewer |
|---|---|---|---|
| DMR | DMR | | |
| talkgroup | talkgroup (TG) | Italian DMR users and BrandMeister Italia keep *talkgroup*, masculine (*il TG 222*). *Gruppo di conversazione* is not used. ❓ | |
| colour code | color code (CC) | Kept, as Italian DMR users write it. | |
| time slot | slot (TS) | "Slot 1 / slot 2", "TS1"; *intervallo temporale* is not used. ❓ *time slot* in full? | |
| private call / group call | chiamata privata / chiamata di gruppo | | |
| DMR ID | ID DMR | Italian word order. (Never a real ID in examples.) | |
| contact | contatto | | |
| receive group list | lista gruppi RX | Italian manuals: *lista gruppi di ricezione*. Short form on labels. ❓ | |
| hotspot | hotspot | | |
| codeplug | codeplug | Kept by Italian DMR users. | |
| CALL · PICKED | CHIAMATA · SCELTA | Intercom cell legend. | |
| promiscuous mode (MON) | ascolto di tutto (MON) | ❓ For prose; the key legend MON stays (decided). Italian manuals sometimes say *modalità promiscua*. | |

## 5. Digital modes and data

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| APRS, AX.25, iGate, digipeater | unchanged | Masculine (*il digipeater*). | |
| APRS-IS, passcode | APRS-IS, passcode | | |
| packet radio | packet radio (il packet) | | |
| position (APRS) | posizione | | |
| telemetry | telemetria | | |
| weather report | bollettino meteo | | |
| message (APRS/DMR text) | messaggio | | |
| outbox / inbox | posta in uscita / posta in arrivo | Short: *In uscita / In arrivo*. | |
| SSTV, FT8, M17, POCSAG, Winlink, DTMF | unchanged | | |
| picture (SSTV) | immagine | | |
| pager | pager (cercapersone) | Hams who decode POCSAG say *pager*; *cercapersone* explains it once. ❓ | |
| decode / decoder | decodificare / decoder | | |
| forms (Winlink) | moduli | | |

## 6. Safety, licence, heat

Safety text gets a second careful pass (plan §4). These renderings must stay this strong.

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| Warning | Avviso | Strongest cases: *Attenzione*. | |
| Caution | Attenzione | | |
| Transmitting legally | Trasmettere in regola | Guide section title. | |
| You need a licence to transmit on this frequency. | Per trasmettere su questa frequenza serve la patente di radioamatore. | The pattern for licence notes. | |
| transmit limit / time limit | limite di trasmissione / limite di tempo | | |
| Longest transmission | Trasmissione più lunga | Device setting. | |
| heat guard | protezione termica | | |
| too hot | troppo caldo | | |
| transmit refused | trasmissione rifiutata | | |
| Not sent | Non inviato | | |
| advisory (from the profile list) | avviso | | |
| firmware loader | caricatore firmware | | |
| factory image | firmware di fabbrica | | |
| do not switch off | non spegnere | Firmware loading: always in bold, never softened. | |
| emergency | emergenza | | |

## 7. Units, numbers, symbols

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| 467.625 MHz | 467,625 MHz | Decimal comma everywhere on screen, the readout included; entry fields accept `,` and `.` (as decided for German; reviewer to confirm, `style.md` §5). ❓ | |
| 12.5 kHz | 12,5 kHz | | |
| −85 dBm | −85 dBm | Unit unchanged, space before the unit. | |
| 30 s, 2 min | 30 s, 2 min | | |
| 5 W | 5 W | | |
| 24-hour time | 14:05 | | |
| date | 30/10/2026 · 30 ott 2026 | Month and weekday names lower case. | |
| → (menu path) | → | Kept: "Dispositivo → Impostazioni radio". | |
| "…" quotes | “…” | Typographic quotes; never in titles. See `style.md` §4. | |

## 8. Terms settled during the draft

Every term of the German §8, with the Italian rendering. Rows marked **❓** are real choices for the reviewer.

### App features and screens

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| the Intercom page (in prose) | la pagina Radio | The tab stays "Radio" (§1). | |
| Radio controls (car screen) | Comandi radio | "Comandi radio a schermo intero in auto". | |
| Parrot (simplex repeater) | Pappagallo | The app's feature. BrandMeister's echo service (private call 9990) stays "Parrot". ❓ Keep "Parrot" for both? | |
| Voice keyer | Memoria vocale | ❓ *Voice keyer* is also used by contesters. | |
| Net preamble / My ID (keyer slots) | Apertura ruota / Il mio identificativo | | |
| ID timer | Timer identificativo | | |
| ID reminder | Promemoria identificativo | | |
| Morse ID | Identificativo in CW | Also the DTMF command label. | |
| Fox beacon | Trasmettitore volpe | Short: *Volpe*. ❓ | |
| Be the fox | Fai la volpe | | |
| bearing / Spin for the bearing | rilevamento / Rilevamento girando su te stesso | Button short form: *Rileva girando*. ❓ | |
| mark (fox hunt) | punto | "Salva punto", "Cancella punti". One word for prose and buttons. | |
| Download terrain / Terrain | Scarica terreno / Terreno | | |
| Terrain prediction | Previsione orografica | Italian radio planning says *orografia*. ❓ *Previsione sul terreno* is plainer. | |
| Key-ups (coverage layer) | Aperture del ponte | Follows §3 "aprire il ponte". Short: *Aperture*. | |
| Mapping coverage | Rilevamento copertura in corso | Notification and widget text. | |
| Log coverage in the car | Registra la copertura in auto | | |
| Nearby repeaters | Ponti vicini | | |
| Nets near you | Ruote vicino a te | | |
| On the air near you / Elsewhere on the air | In aria vicino a te / In aria altrove | ❓ *Attivi vicino a te* reads more neutral. | |
| Nets on this channel (editor section) | Ruote su questo canale | Comment asks for one or two words: *Ruote qui*. | |
| Add a net | Aggiungi ruota | | |
| check-in (net control) | check-in, verb *fare check-in*; button "Registra presenza" | In an Italian ruota you *dai la presenza*. ❓ *Presenza* everywhere? | |
| traffic (net flag) | traffico | | |
| Late / Out (net flags) | In ritardo / Uscito | Report lines: "in ritardo", "uscito". | |
| Scheduled operations / schedule | Operazioni pianificate / Pianificazione | "Aggiungi pianificazione". Not *programmazione* (that means programming the radio). | |
| APRS monitoring | Ascolto APRS | Never *monitoraggio* (reads as surveillance). | |
| Pager monitor | Ascolto pager | | |
| Monitor APRS (button) | Ascolta APRS | | |
| Packet finder | Ricerca packet | | |
| page (POCSAG message) | messaggio pager | One rendering. | |
| Hear pages | Ricevi pager | | |
| Winlink e-mail / Check Winlink mail | E-mail Winlink / Controlla posta Winlink | | |
| Session log / Detailed diagnostic log | Log della sessione / Log diagnostico dettagliato | | |
| Two-way iGate | iGate bidirezionale | | |
| Packet lead-in | Preambolo packet | The TX delay before the frame. | |
| Beacon via ISS | Beacon via ISS | | |
| Record each pass | Registra ogni passaggio | | |
| satellite pass | passaggio del satellite | | |
| orbit data | dati orbitali | | |
| Text modes | Modi testuali | | |
| Any mode (SSTV decoder) | Qualsiasi modo | An SSTV mode (Martin, Scottie). | |
| Combine (SSTV) / In / Left out | Combina / Inclusa / esclusa | Agrees with *immagine* (feminine). | |
| Voice announcements | Annunci vocali | | |
| keyword alerts | avvisi parole chiave | | |
| Contribute | Contribuisci | | |
| Help support this phone | Aiuta a supportare questo telefono | "Help us support this phone": "Aiutaci a supportare questo telefono". | |
| Radio audio check | Verifica audio radio | | |
| Listen check / Second radio test | Prova d'ascolto / Prova con una seconda radio | | |
| Transmit test session | Sessione di prova di trasmissione | | |
| Bring radio up (diagnostics) | Avvia radio | Four buttons in a row. | |
| Probe + power pulse | Interroga + impulso alimentazione | | |
| Restore factory (firmware button) | Ripristina fabbrica | One of three buttons in a row. | |
| POTA activation / On the air now | Attivazione / Ora QRV | | |
| contact (logbook) | collegamento | Italian hams call a QSO a *collegamento*. A DMR contact stays *contatto* (§4). "Registra collegamento", "Registra di nuovo". | |
| Log heard | Registra ascoltati | | |
| Exam practice: Study a subelement / Missed | Studia una sezione / Sbagliate | Topic label per §1: "Esame USA (in inglese)". | |
| Hold to talk (M17) | Tieni premuto per parlare | | |
| Open in maps | Apri in Maps | | |

### Firmware and the phone

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| phone | telefono | Never *cellulare* in UI text (Android Italian says *telefono*). | |
| bench firmware / bench image | firmware di laboratorio / immagine di laboratorio | ❓ *firmware da banco* is the literal one, rarely used. | |
| stock firmware / factory image | firmware di fabbrica | As §6. | |
| stock version (SignalDeck Web) | versione di fabbrica | | |
| factory backup / factory copy | backup di fabbrica / copia di fabbrica | | |
| stock ROM (Android) | ROM originale | Not firmware; *ROM stock* is also common among modders. ❓ | |
| symbol engine / tone generator | motore dei simboli / generatore di toni | | |
| Own the radio at boot | Prendi il controllo della radio all'avvio | §1 "Prendi il controllo". | |
| Keep access after reboot | Mantieni l'accesso dopo il riavvio | | |
| Turn the radio off and exit | Spegni la radio ed esci | | |
| Hand back to the stock app and exit | Restituisci all'app originale ed esci | | |
| Radio busy, loading firmware | Radio occupata, caricamento firmware | | |
| Allow unlisted images | Consenti immagini non in elenco | | |
| Web access / Allow transmit from the web | Accesso web / Consenti la trasmissione dal web | | |
| amber (UI colour) | ambra | Invariable adjective ("il tasto ambra"). | |

### Channel editor and lists

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| All / Private / Group (call type choice) | Tutti / Privata / Gruppo | Short forms for pills. | |
| All call (contact type) | Chiamata generale | | |
| Relay (repeater) | Ponte (ripetitore) | | |
| Call number from / call number | Origine del numero / numero di chiamata | | |
| Channel access number (M17) | Numero di accesso al canale (CAN) | | |
| Double slot | Doppio slot | | |
| Interrupt transmission | Interruzione trasmissione | | |
| RX tone type / TX tone type | Tipo tono RX / Tipo tono TX | | |
| None (tone) | Nessuno | | |
| High / Low power (choices) | Alta / Bassa | §3. | |
| Enabled / Disabled (choices) | Attivo / Disattivo | | |
| Latitude / Longitude | Latitudine / Longitudine | | |
| Destination (@ALL or a callsign) | Destinazione (@ALL o un nominativo) | | |
| NOT TUNABLE (badge) | FUORI GAMMA | 11 characters, fits the 16-character badge. | |
| RX ONLY (badge) | SOLO RX | | |
| Not legal here | Non consentito qui | | |
| Show all lists | Mostra tutti gli elenchi | | |
| Star (button) | Preferito | The icon is *stella* in prose. | |
| Out of zone (button) | Togli da zona | Four buttons share a row. | |
| Zone name | Nome zona | | |
| Marine VHF | VHF nautico | | |
| NOAA weather | Meteo NOAA | | |
| Home (contact location) | Casa | | |

### Wording rules settled

| English | Italian | Notes | Reviewer |
|---|---|---|---|
| Stop … (button) | Interrompi … | §2 Start/Stop. *Termina* only for End (a net, a session, the app). | |
| Halt TX | Ferma TX | | |
| Try again | Riprova | §2 Retry. | |
| Loading… / Sending… | Caricamento… / Invio in corso… | No space before the ellipsis. | |
| Set your callsign first | Prima imposta il tuo nominativo | | |
| Coverage logging is on | Registrazione copertura attiva | *attiva/disattivata* in sentences (§2). | |
| No position fix yet | Posizione non ancora disponibile | | |
| Key legends SCAN, ZONE, TXT, SOFT SQ, MON, REC, VFO, PKT | unchanged | No legend is translated. Compounds keep the name: "livello Soft SQ". The car screen's own Scan button is *Scansione*. | |
| weekday buttons (one letter) | L M M G V S D | Italian calendar, Monday first, as Android's. Three-letter days: lun mar mer gio ven sab dom. | |
