# French glossary (fr): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-30 from the English source
(`strings_*.xml` with their context comments, and the guide `assets/guide/en.json`), before any French string was
drafted. It is for a French-speaking ham reviewer to agree or correct, ideally **before any French string is drafted**.
Review does not gate the release (owner, 2026-10-30): if answers come later, the draft is changed to match. Every later
French string follows this table, so one English word is never rendered three ways.

- **Who it is for:** neutral French that radio amateurs in France, Belgium, Switzerland and Canada read naturally. The
  guide is REF (France) and UBA (Belgium) usage, with RAQI (Québec) usage noted where it differs.
- **How to review:** for each row, keep it or write the better term in the last column. Rows marked **❓** are real
  choices where French ham usage is split; the reviewer decides.
- **Register:** *vous* (see `style.md` §1).
- **Typography:** the French cells use the real characters the app will use: a no-break space (U+00A0) before `:` and
  between a number and its unit, a narrow no-break space (U+202F) before `;` `!` `?` and inside « » (`style.md` §4).
- **Gender and plural** are given where they are not obvious: (m.) masculine, (f.) feminine, (inv.) invariable.
- **Order:** app navigation, buttons, radio terms, DMR, digital modes, safety and licence, units and symbols, then the
  terms settled for the German draft (§8), each with its French rendering.

## 1. App structure: tabs, pages, features

| English | French | Why / notes | Reviewer |
|---|---|---|---|
| SignalDeck | SignalDeck | Product name, never translated. | |
| SignalDeck Web | SignalDeck Web | Product name. | |
| Intercom (tab, main page) | Radio | French *interphone* is a door or motorcycle intercom, which misleads. "Radio" is short and says what the page is. ❓ Alternatives: *Trafic* (very ham: « faire du trafic »), keep *Intercom*. | |
| Channels (tab) | Canaux | *canal* (m.), pl. *canaux*. French radio manuals also say *mémoires*; "canaux" matches the app's model (a channel is more than a memory). | |
| Contacts (tab) | Contacts | Also DMR contacts. | |
| Messages (tab) | Messages | | |
| Device (tab) | Appareil | Android's French UI ("À propos de l'appareil"). | |
| Settings | Paramètres | Android standard (France and Québec). | |
| Radio settings | Paramètres radio | No hyphen, no "de la". | |
| Last heard | Derniers entendus | Short; French DMR dashboards say "Dernières stations entendues", too long for a tab. ❓ | |
| Activity | Activité | | |
| Alerts (list in Last heard) | Alertes | Holds warnings and refusals. | |
| Car and coverage | Voiture et couverture | | |
| Guide / Help | Guide / Aide | "Aide" for the menu entry, "Guide" for the guide itself. | |
| Start here (guide group) | Pour commencer | | |
| On the intercom (guide group) | Sur la page Radio | Follows the tab name. | |
| Getting started | Premiers pas | Standard French UI title. | |
| Good to know | Bon à savoir | | |
| Take over (the radio) | Prendre la main | Idiomatic, short on a button. In prose: « prendre la main sur la radio ». | |
| Hand back | Rendre la main | Pairs with *Prendre la main*. | |
| Stock app (the phone maker's radio app) | application d'origine | "Appli d'origine" where space is tight. *Application du fabricant* is also clear. ❓ | |
| Device report | Rapport d'appareil | | |
| Transmit test | Test d'émission | | |
| First-run check | Vérification initiale | ❓ *Premier contrôle* is shorter. | |
| Module firmware | Firmware du module | See §8 "firmware". | |
| Radio module | Module radio | (m.) | |
| About this radio | À propos de cette radio | *radio* (f.) for the device, see §3. | |
| Live captions (TXT) | Sous-titres en direct | Android's own Live Caption is *Sous-titres instantanés*; a different name avoids confusing the two features. ❓ | |
| Keywords (caption alerts) | Mots-clés | | |
| Recording(s) | Enregistrement(s) | | |
| Transcript | Transcription | | |
| Coverage logging | Relevé de couverture | « La couverture d'un relais » is the usual ham phrase; *relevé* is the act of measuring it. | |
| Coverage map | Carte de couverture | | |
| Band scope | Scope de bande | French Icom/Yaesu manuals say *scope* or *affichage du spectre*; « le scope » is what hams say. ❓ *Analyseur de spectre* is a lab instrument. | |
| Fox hunt | Chasse au renard | The established term; the sport is *radiogoniométrie sportive* (ARDF). | |
| Nets | Réseaux | Québec usage (*réseau d'urgence*) and REF usage agree. ❓ French hams also say *QSO de section* or *rendez-vous*. | |
| Net control | Station directrice | The French term for the station that runs a net. | |
| Logbook | Carnet de trafic | The French ham term; "log" in casual speech. | |
| Exam practice | Entraînement à l'examen | The pools are the US exam in English: topic label "Examen américain (en anglais)". | |
| Conditions (propagation) | Conditions de propagation | Short form on tight labels: *Propagation*. | |
| Pass (satellite) | Passage | | |
| Emergency | Urgence | | |
| Restricted mode | Mode verrouillé | A voluntary PIN lock; *mode restreint* reads like an Android system state. ❓ | |
| Restricted PIN | Code PIN de verrouillage | Short form "PIN" on tight labels. | |
| Zone | Zone | (f.) Same word on French-language DMR radios. | |
| All channels | Tous les canaux | | |
| Favourites | Favoris | | |
| Priority channel | Canal prioritaire | | |
| Make scan priority | Rendre prioritaire | Button: short. | |
| Busiest channels (zone name) | Les plus actifs | A zone name the app creates. | |
| Advisories for this phone | Avis pour ce téléphone | See §6 "advisory". | |

## 2. Buttons and common actions

Buttons are infinitives, as in Android's French UI ("Enregistrer", "Annuler"), with a capital on the first word only.

| English | French | Notes | Reviewer |
|---|---|---|---|
| OK | OK | | |
| Cancel | Annuler | | |
| Save | Enregistrer | Android standard. Clashes with "Record": see the next row. | |
| Record (audio) | Enregistrer l'audio · noun *enregistrement* | Where "Save" and "Record" share a screen, Record becomes "Démarrer l'enregistrement" and the key legend REC stays. ❓ Or Save = *Sauvegarder* (but that is "Back up", below). | |
| Back up / Restore | Sauvegarder / Restaurer | Backup (noun): *sauvegarde* (f.). | |
| Delete | Supprimer | | |
| Close | Fermer | | |
| Done | Terminé | | |
| Back | Retour | | |
| Continue | Continuer | | |
| Later | Plus tard | | |
| Not now | Pas maintenant | | |
| Clear | Effacer | For lists and fields. "Réinitialiser" for a setting back to its default. | |
| Start / Stop | Démarrer / Arrêter | | |
| End (a net, a session) | Terminer | Also "Clore le réseau" in prose. | |
| Send | Envoyer | For messages. On the radio, "émettre" (§3). | |
| Share | Partager | Android standard. | |
| Import / Export | Importer / Exporter | | |
| Download | Télécharger | | |
| Load (firmware) | Charger | « Charger le firmware », never *flasher* in UI text. | |
| Connect | Se connecter | "Connecter" when the object is named (« connecter le hotspot »). | |
| Defaults | Valeurs par défaut | | |
| Use (a channel) | Utiliser | | |
| Use it anyway | Utiliser quand même | | |
| Tune (a frequency) | Régler | « Régler sur 145,500 MHz ». | |
| Edit | Modifier | | |
| Add | Ajouter | | |
| Retry | Réessayer | | |
| Allow | Autoriser | Matches Android permission dialogs. | |
| Turn on / Turn off (a feature) | Activer / Désactiver | Switch rows: just the label, no verb. | |
| Turn on / Turn off (the radio) | Allumer / Éteindre | | |
| On / Off | Activé / Désactivé | Android French switches. Where very short: "Oui / Non". ❓ "ON / OFF" is also common on French radios. | |
| Tap | appuyer (sur) | Android French: « Appuyez sur Prendre la main ». Never *taper*, *cliquer*. | |
| Long-press | appuyer de manière prolongée | Android French. Noun: *appui long* (« appui long sur SCAN »). | |
| Swipe | balayer | | |
| Put in the outbox | Mettre dans la boîte d'envoi | Winlink/messages. | |

## 3. Radio and ham terms

| English | French | Why / notes | Reviewer |
|---|---|---|---|
| radio (the device) | radio (f.) | « La radio ». In ham prose *le poste* or *l'émetteur-récepteur* also fit; "la radio" stays clear for the phone's module. ❓ | |
| radio (the activity) | radio · trafic | « Faire du trafic » = to operate. | |
| ham, radio amateur | radioamateur | One word, epicene (*un* or *une radioamateur*). "OM" in casual text only. | |
| amateur radio | radioamateurisme · service d'amateur | "Radioamateurisme" in prose; the regulatory term is *service d'amateur*. | |
| callsign | indicatif | | |
| licence | licence radioamateur | Understood everywhere. France's legal term is *certificat d'opérateur* plus an *indicatif*, Canada's *certificat d'opérateur radioamateur*, Belgium says *licence*. ❓ | |
| channel | canal (pl. canaux) | | |
| frequency | fréquence | | |
| transmit (verb) | émettre | | |
| transmission (one over) | émission | "Passage" or "prise de parole" for one over in a QSO, in prose only. | |
| receive | recevoir | | |
| reception | réception | | |
| receive-only | réception seule | | |
| talk key (the big round button) | touche d'émission | « La grande touche ronde » in the guide. | |
| PTT | PTT | Kept: what French hams and manuals print. The traditional French word is *alternat*; use it once in the guide (« PTT (alternat) »). | |
| side PTT button | touche PTT latérale | | |
| squelch | squelch (m.) | What French hams say; manuals say *silencieux*. The feature name **Soft SQ** stays. ❓ | |
| squelch level | niveau de squelch | Short form "Niveau SQL" on tight labels. | |
| Soft SQ | Soft SQ | Feature name, kept. Explained once as « squelch logiciel ». | |
| noise squelch | squelch sur le bruit | ❓ Prose only. | |
| scan (verb / noun) | balayer / balayage | Key legend stays **SCAN** (decided; `style.md` §6). French manuals say *scan* or *balayage*. | |
| zone | zone (f.) | | |
| VFO | VFO (m.) | | |
| repeater | relais (m., inv.) | REF/UBA usage. Québec also says *répéteur*; "relais" is understood there. ❓ | |
| repeater offset / shift | décalage | Also *shift* in speech; "décalage" on screen. | |
| simplex / duplex | simplex / duplex | | |
| CTCSS | CTCSS | « Tonalité CTCSS » in prose; *sous-tonalité* is also understood. | |
| DCS | DCS | | |
| tone (CTCSS) | tonalité | "Tonalité RX" / "Tonalité TX" on labels; « tonalité de réception / d'émission » in prose. | |
| power (transmit) | puissance d'émission | Short labels: "Puissance". | |
| high / low (power) | Haute / Basse | As French radio menus print it. | |
| bandwidth wide / narrow | Large / Étroite | With values: 25 kHz / 12,5 kHz. | |
| channel step | pas | « Pas de 12,5 kHz ». | |
| mode (FM, DMR …) | mode (m.) | The regulatory term *classe d'émission* is too formal for an app. | |
| analog / digital | analogique / numérique | Never *digital* in French. | |
| signal strength | force du signal | | |
| S-meter | S-mètre | | |
| noise floor | bruit de fond | | |
| NO SIGNAL | AUCUN SIGNAL | | |
| channel busy | canal occupé | | |
| key up (a repeater) | déclencher (le relais) | Also « ouvrir le relais ». | |
| repeater tail | traîne | Also *queue*. ❓ | |
| roger beep | roger bip | Common in French usage; formal *bip de fin d'émission*. ❓ | |
| QSO, CQ, 73, QTH, QRV | unchanged | International Q-codes and ham shorthand. QSO (m.). | |
| location | position · emplacement | "Position" for GPS, "emplacement" for a place you set. "QTH" in ham-flavoured text. | |
| locator / grid square | locator (m.) | French hams say "locator" or "QRA-locator". | |
| band | bande (f.) | | |
| band plan | plan de bandes | | |
| VHF / UHF | VHF / UHF | French hams also say 2 m / 70 cm: use those in prose where the band is meant. | |
| dummy load | charge fictive | | |
| interference | brouillage | "Interférences" for the general phenomenon. | |
| identification (repeater ID) | identification | | |
| Morse | Morse / CW | (m.) « en Morse ». | |
| beacon | balise | APRS: "balise APRS". | |

## 4. DMR

| English | French | Why / notes | Reviewer |
|---|---|---|---|
| DMR | DMR (m.) | | |
| talkgroup | talkgroup (m.) · TG | French DMR users and BrandMeister France say "TG" and "talkgroup". ❓ *Groupe de discussion* is the descriptive alternative. | |
| colour code | code couleur (CC) | French DMR pages use both *Color Code* and *code couleur*. ❓ | |
| time slot | slot (m.) · TS | « Slot 1 », « TS2 ». *Intervalle de temps* exists but no ham says it. ❓ | |
| private call / group call | appel privé / appel de groupe | *Appel individuel* also fits. | |
| DMR ID | ID DMR (m.) | French word order. (Never a real ID in examples.) | |
| contact | contact | | |
| receive group list | liste de groupes RX | Short form "Groupes RX". ❓ *Liste de réception* | |
| hotspot | hotspot (m.) | | |
| codeplug | codeplug (m.) | Kept by French DMR users. | |
| CALL · PICKED | APPEL · CHOISI | Intercom cell legend. | |
| promiscuous mode (MON) | Tout écouter (MON) | ❓ For prose; the key legend MON stays (decided). | |

## 5. Digital modes and data

| English | French | Notes | Reviewer |
|---|---|---|---|
| APRS, AX.25, iGate, digipeater | unchanged | « un digipeater » (m.); *digi* in speech. | |
| APRS-IS, passcode | APRS-IS, passcode | (m.) | |
| packet radio | packet radio (m.) | « le packet ». | |
| position (APRS) | position | | |
| telemetry | télémétrie | Used by French APRS pages. | |
| weather report | bulletin météo | | |
| message (APRS/DMR text) | message | | |
| outbox / inbox | boîte d'envoi / boîte de réception | | |
| SSTV, FT8, M17, POCSAG, Winlink, DTMF | unchanged | | |
| pager | pager (m.) | The POCSAG hobby says "pager"; France's official term is *bipeur*, Québec's *téléavertisseur*. ❓ | |
| decode / decoder | décoder / décodeur | | |
| forms (Winlink) | formulaires | | |

## 6. Safety, licence, heat

Safety text gets a second careful pass (plan §4). These renderings must stay this strong.

| English | French | Notes | Reviewer |
|---|---|---|---|
| Warning | Avertissement | | |
| Transmitting legally | Émettre en toute légalité | Guide section title. | |
| You need a licence to transmit on this frequency. | Une licence radioamateur est obligatoire pour émettre sur cette fréquence. | The pattern for licence notes: the obligation first, impersonal, not softened. | |
| transmit limit / time limit | limite de durée d'émission | | |
| Longest transmission | Durée d'émission maximale | Device setting. | |
| heat guard | protection thermique | | |
| too hot | trop chaud | | |
| transmit refused | Émission refusée | | |
| Not sent | Non envoyé | | |
| Too long to send | Trop long pour être émis | | |
| advisory (from the profile list) | avis | "Avis SignalDeck : %1$s". | |
| firmware loader | chargeur de firmware | | |
| factory image | firmware d'usine | | |
| do not switch off | ne pas éteindre | Firmware loading: always in bold, never softened; « N'éteignez pas le téléphone ». | |

## 7. Units, numbers, symbols

| English | French | Notes |
|---|---|---|
| 467.625 MHz | 467,625 MHz | Decimal comma everywhere on screen, the readout included; entry fields accept `,` and `.` (decided for German; reviewer to confirm for French). No-break space before the unit. |
| 12.5 kHz | 12,5 kHz | |
| −85 dBm | −85 dBm | Real minus sign, no-break space before the unit. |
| 30 s, 2 min | 30 s, 2 min | Never "30 sec" or "2 mn". |
| 5 W | 5 W | |
| 50% | 50 % | French puts a no-break space before %. |
| 1,200 Hz | 1 200 Hz | Thousands: narrow no-break space. Or "1200 Hz" for four-digit tones. |
| 24-hour time | 14:05 on screen · 14 h 05 in prose | `style.md` §5. |
| date | 30/10/2026 · 30 oct. 2026 | Android follows the locale (fr-CA shows 2026-10-30). |
| → (menu path) | → | Kept: "Appareil → Paramètres radio". |
| "…" quotes | « … » | With narrow no-break spaces inside; never in titles until the screen check shows the title font has «. |

## 8. Terms settled during the German draft (2026-10-31), in French

The terms the German translators needed beyond §1–7, given here so French has them before its draft starts. Rows
marked **❓** are real choices for the reviewer.

### App features and screens

| English | French | Notes | Reviewer |
|---|---|---|---|
| the Intercom page (in prose) | la page Radio | The tab is "Radio" (§1). | |
| Radio controls (car screen) | Commandes radio | Also « commandes radio plein écran en voiture ». | |
| Parrot (simplex repeater) | Perroquet | French hams already call a simplex echo repeater a *relais perroquet*. BrandMeister's echo service (private call 9990) stays "Parrot". | |
| Voice keyer | Mémoires vocales | The function that replays recorded voice messages. ❓ *Manipulateur vocal* is a literal calque. | |
| Net preamble / My ID (keyer slots) | Ouverture du réseau / Mon indicatif | | |
| ID timer | Minuterie d'identification | | |
| ID reminder | Rappel d'identification | | |
| Morse ID | Indicatif en Morse | Also the DTMF command label. | |
| Fox beacon | Balise renard | French fox hunts call the hidden transmitter *la balise* or *le renard*. | |
| Be the fox | Être le renard | | |
| bearing / Spin for the bearing | relèvement / Relèvement en tournant | | |
| mark (fox hunt) | repère | Buttons: "Enregistrer le repère", "Effacer les repères". ❓ "Point" is shorter. | |
| Download terrain / Terrain | Télécharger le relief / Relief | | |
| Terrain prediction | Prévision selon le relief | | |
| Key-ups (coverage layer) | Déclenchements | Follows §3 "key up". | |
| Mapping coverage | Relevé de couverture en cours | Notification and widget text. | |
| Log coverage in the car | Relever la couverture en voiture | | |
| Nearby repeaters | Relais à proximité | | |
| Nets near you | Réseaux près de vous | | |
| On the air near you / Elsewhere on the air | Actifs près de vous / Actifs ailleurs | « En l'air » is not French in this sense; *QRV* is an alternative. ❓ | |
| Nets on this channel (editor section) | Réseaux ici | Comment asks for one or two words. | |
| Add a net | Ajouter un réseau | | |
| check-in (net control) | pointage, verb *pointer*; button "Pointer" | The net controller takes a roll call. ❓ *Inscription / Inscrire* is the alternative; Québec nets say *s'enregistrer*, which clashes with recording. | |
| traffic (net flag) | Trafic | Here: a station with traffic to pass. | |
| Late / Out (net flags) | En retard / Parti | Report lines: "en retard", "parti". | |
| Scheduled operations / schedule | Opérations programmées / Programmation | « Ajouter une programmation ». | |
| APRS monitoring | Écoute APRS | Never *surveillance*. | |
| Pager monitor | Écoute pager | | |
| Monitor APRS (button) | Écouter l'APRS | | |
| Packet finder | Recherche packet | | |
| page (POCSAG message) | message pager | | |
| Hear pages | Recevoir les messages pager | | |
| Winlink e-mail / Check Winlink mail | Courriel Winlink / Relever le courrier Winlink | *Courriel* is official in France and Québec. ❓ *E-mail* is more common in France and Belgium. | |
| Session log / Detailed diagnostic log | Journal de session / Journal de diagnostic détaillé | | |
| Two-way iGate | iGate bidirectionnel | | |
| Packet lead-in | Préambule packet | | |
| Beacon via ISS | Balise via l'ISS | | |
| Record each pass | Enregistrer chaque passage | | |
| satellite pass | passage de satellite | | |
| orbit data | données orbitales | Also *paramètres orbitaux* (TLE). | |
| Text modes | Modes texte | | |
| Any mode (SSTV decoder) | Tous modes | An SSTV mode (Martin, Scottie), not a §3 mode. | |
| Combine (SSTV) / In / Left out | Combiner / Inclus / exclu | | |
| Voice announcements | Annonces vocales | | |
| keyword alerts | alertes par mot-clé | | |
| Contribute | Contribuer | | |
| Help support this phone | Aidez à prendre en charge ce téléphone | First-launch title "Help us support this phone": « Aidez-nous à prendre en charge ce téléphone ». | |
| Radio audio check | Vérification audio de la radio | | |
| Listen check / Second radio test | Test d'écoute / Test avec une seconde radio | | |
| Transmit test session | Session de test d'émission | | |
| Bring radio up (diagnostics) | Démarrer la radio | Four buttons in a row. | |
| Probe + power pulse | Sonde + impulsion | Four buttons in a row: "d'alimentation" in prose. | |
| Restore factory (firmware button) | Usine | One of three buttons in a row; « Restaurer le firmware d'usine » in prose. | |
| POTA activation / On the air now | Activation / QRV maintenant | | |
| contact (logbook) | QSO (m.) | A DMR contact stays "contact" (§4): « Ajouter un QSO », « Noter à nouveau ». | |
| Log heard | Noter les entendus | | |
| Exam practice: Study a subelement / Missed | Étudier une section / Erreurs | Topic label per §1: "Examen américain (en anglais)". | |
| Hold to talk (M17) | Maintenir pour parler | | |
| Open in maps | Ouvrir dans Maps | | |

### Firmware and the phone

| English | French | Notes | Reviewer |
|---|---|---|---|
| phone | téléphone | Neutral. Never *portable* (France) or *cellulaire* (Québec) alone. | |
| firmware | firmware (m.) | What French hams and phone forums say. Québec's OQLF term is *micrologiciel*. ❓ | |
| bench firmware / bench image | firmware de labo / image de labo | "Au banc" stays for measurements. ❓ | |
| stock firmware / factory image | firmware d'usine | As §6. | |
| stock version (SignalDeck Web) | version d'usine | | |
| factory backup / factory copy | sauvegarde d'usine / copie d'usine | | |
| stock ROM (Android) | ROM d'origine | Not firmware. | |
| symbol engine / tone generator | moteur de symboles / générateur de tonalités | | |
| Own the radio at boot | Prendre la main au démarrage | §1. | |
| Keep access after reboot | Conserver l'accès après redémarrage | | |
| Turn the radio off and exit | Éteindre la radio et quitter | | |
| Hand back to the stock app and exit | Rendre la main à l'application d'origine et quitter | | |
| Radio busy, loading firmware | Radio occupée, chargement du firmware | | |
| Allow unlisted images | Autoriser les images non répertoriées | | |
| Web access / Allow transmit from the web | Accès web / Autoriser l'émission depuis le web | | |
| amber (UI colour) | orange | *ambre* is rarer in UI text. | |

### Channel editor and lists

| English | French | Notes | Reviewer |
|---|---|---|---|
| All / Private / Group (call type choice) | Tous / Privé / Groupe | Short forms of §4, for pills. | |
| All call (contact type) | Appel général | | |
| Relay (repeater) | Relais | | |
| Call number from / call number | Source du numéro d'appel / Numéro d'appel | | |
| Channel access number (M17) | Numéro d'accès au canal (CAN) | | |
| Double slot | Double slot | | |
| Interrupt transmission | Interruption d'émission | | |
| RX tone type / TX tone type | Type de tonalité RX / TX | | |
| None (tone) | Aucune | Agrees with *tonalité* (f.). | |
| High / Low power (choices) | Haute / Basse | §3. | |
| Enabled / Disabled (choices) | Activé / Désactivé | | |
| Latitude / Longitude | Latitude / Longitude | | |
| Destination (@ALL or a callsign) | Destinataire (@ALL ou un indicatif) | | |
| NOT TUNABLE (badge) | HORS PLAGE | Badge cut off at 16 characters on a 480 px screen. ❓ | |
| RX ONLY (badge) | RX SEULE | Agrees with *réception* (f.). ❓ "RX SEUL" if read as "le RX". | |
| Not legal here | Non autorisé ici | | |
| Show all lists | Afficher toutes les listes | | |
| Star (button) | Favori | The icon is still *étoile* in prose. | |
| Out of zone (button) | Hors zone | Four buttons share a row. | |
| Zone name | Nom de la zone | « Nouvelle zone » for the button. | |
| Marine VHF | VHF marine | | |
| NOAA weather | Météo NOAA | | |
| Home (contact location) | Domicile | | |

### Wording rules settled

| English | French | Notes | Reviewer |
|---|---|---|---|
| Stop … (button) | Arrêter … | §2 Start/Stop. "Terminer" only for End (a net, a session); "Quitter" for the app. | |
| Halt TX | Couper l'émission | | |
| Try again | Réessayer | §2 Retry. | |
| Loading… / Sending… | Chargement… / Envoi… | No space before the ellipsis. | |
| Set your callsign first | Saisissez d'abord votre indicatif | *Saisir* for typed input, as in Android French. | |
| Coverage logging is on | Relevé de couverture activé | "activé/désactivé" in sentences and on switches (§2). | |
| No position fix yet | Pas encore de position | | |
| Key legends SCAN, ZONE, TXT, SOFT SQ, MON, REC, VFO, PKT | unchanged | No legend is translated. In prose, the legend is a name: « la touche SCAN », « le niveau SOFT SQ ». The car screen's own Scan button is "Balayage". | |
| weekday buttons (one letter) | L M M J V S D | French calendar convention, week starts on Monday. Three-letter days: lun. mar. mer. jeu. ven. sam. dim. | |
| months (short) | janv. févr. mars avr. mai juin juil. août sept. oct. nov. déc. | As Android's French locale. | |

## 9. Terms settled during the draft

Added on 2026-10-31 after the French draft (strings, web table, guide) and its consistency pass: the terms the
translators needed beyond §1–8, and the splits settled so that one English label has one French rendering on the
phone, in SignalDeck Web and in the guide. Rows marked **❓** are real choices for the reviewer.

### Settled in the consistency pass

| English | French | Notes | Reviewer |
|---|---|---|---|
| Last heard (contact sheet line, channel history, parrot tile) | Dernière réception | « Dernière écoute » read as "when you listened" and was dropped. The tab and the car list stay « Derniers entendus » (§1). | |
| Heard (coverage map layer) | Réception | Layer name, also in the guide. A heard station elsewhere is « entendu(e) ». ❓ | |
| ✓✓ delivered (message mark) | ✓✓ remis | Phone, web and guide; « distribué » dropped. ❓ | |
| ✓ sent (message mark) | ✓ envoyé | FT8's own list of what you sent is « Émis ». | |
| End / End the net / End {name}? | Terminer / Terminer le réseau / Terminer {name} ? | §2 (End a net = Terminer); « Clore » dropped from the buttons, the dialog, the web and the guide. ❓ « Clore le réseau » is also natural. | |
| Call CQ (FT8 button) | Lancer un CQ | Phone, web and guide. | |
| TX 1st (:00 :30) / TX 2nd (:15 :45) | TX 1 (:00 :30) / TX 2 (:15 :45) | A bare ordinal (« TX 1re ») lacks its noun; third of a row on the phone, so no « période ». ❓ | |
| VHF/UHF conditions | Propagation VHF/UHF | Screen title, PKT tile, web heading and guide head now agree. ❓ « Conditions VHF/UHF » | |
| Aurora (card, tile) | Aurores | Plural on the phone and the web. | |
| Meteor showers | Essaims de météores | | |
| New intercom look (setting) | Nouvelle page Radio | The dialog button "New look" is « Nouvelle page »; the classic one « Page Radio classique ». « nouveau design / nouveau look / nouvel aspect » dropped. ❓ | |
| Radios that do less (guide section) | Radios aux fonctions réduites | Named so in the VFO topic too. | |
| FT8 over FM | FT8 en FM | Never « sur FM ». | |
| DTMF heard | DTMF entendus | « les DTMF entendus » in prose. | |
| Morse trainer | Entraînement au Morse | « l'apprentissage du Morse » dropped. | |
| ISS frequencies | Fréquences de l'ISS | | |
| Talk key (in prose) | touche d'émission | As §3. The Talk button of the car screen, media app and widget is « Parler » / « PARLER ». | |
| Type (into a field) | saisir | « Saisissez … » as Android French (§8); « Tapez » dropped from the Morse trainer, the packet terminal and the web. | |
| stock firmware | firmware d'usine | §6 and §8; five « firmware d'origine » aligned. | |
| stock version (module firmware sheet) | version d'usine | As SignalDeck Web (§8). | |
| stock app | application d'origine · appli d'origine | §1, unchanged: « appli » only on tight labels. | |
| Band (channel editor field) | Largeur de bande | The web editor follows the phone; the scope's band choice stays « Bande ». | |
| High power / Low power (choices) | Haute / Basse | Web choices aligned with the phone pills (§8). | |
| Narrow band / Wide band (choices) | Étroite / Large | Same. | |
| Location (channel editor section) | Emplacement | Web aligned (was « Position »). GPS position stays « position » (§3). | |
| Channel access number (field) | Numéro d'accès au canal | Phone and web without "(CAN)"; « (CAN) » only in prose (§8). | |
| Encrypt key (8 characters) | Clé de chiffrement (8 caractères) | Error: « doit comporter exactement 8 caractères ». | |
| Check the numbers | Vérifiez les valeurs | Toasts and web errors; « nombres » and « valeurs numériques » dropped. | |
| Frequencies must be inside %1$s | Les fréquences doivent être comprises dans %1$s | | |
| Not while transmitting | Impossible pendant l'émission | | |
| No map app | Aucune application de cartographie | | |
| Not listening | Écoute arrêtée | Phone and web text-mode list. | |
| Pager monitor off | Écoute pager désactivée | | |
| Parrot on / Parrot off | Perroquet activé / Perroquet désactivé | Toast and DTMF command. | |
| ID timer idle | Minuterie d'ID inactive | Section titles keep « minuterie d'identification » (§8). | |
| ISS SSTV stopped | SSTV ISS arrêtée | *la SSTV* (f.) throughout. | |
| repeater identification | identification du relais | History kind and sheet title. | |
| Stop when I stop talking | Arrêter quand je ne parle plus | Phone setting and web setting. | |
| The channel the radio is on | Le canal sur lequel est la radio | | |
| Via digipeaters (optional) | Via des digipeaters (facultatif) | | |
| Mission statement | Mission du projet | « Notre mission » did not fit the first-person text. | |
| New ICS-213 | Nouvel ICS-213 | Elision before a vowel sound. | |
| No forms yet | Aucun formulaire | | |
| No list imported yet | Aucune liste importée | | |
| No zones yet | Aucune zone pour l'instant | | |
| No such zone | Cette zone n'existe pas | | |
| No position fix on the phone | Pas de position sur le téléphone | | |
| Sending to %1$d RICs | Envoi à %1$d RIC | RIC is invariable. | |
| Disconnect (terminal button) | Se déconnecter | The DMR relay option stays « Déconnexion ». | |
| Upload / Uploaded | Importer / Importé | « Envoyé » means "sent". | |
| What (schedule form field) | Action | | |
| quiet (nothing received) | calme · CALME | Volume state, S-meter text, Kp class. | |
| best before dawn (meteors) | au mieux avant l'aube | | |
| Captions are made on the phone | Les sous-titres sont générés sur le téléphone | | |
| %1$d days ago | il y a %1$d jours | | |

### Terms the translators added

| English | French | Notes | Reviewer |
|---|---|---|---|
| DMR roaming | Itinérance DMR | (f.): activée / désactivée. History line « Itinérance ». | |
| Start empty (first import) | Commencer à vide | | |
| Save as channel (VFO) | Enregistrer en canal | | |
| ALL channels (built-in zone) | TOUS les canaux | Capitals mark the built-in zone, as in English. | |
| Auto-ack / acknowledge (APRS) | Auto-ack / acquitter | | |
| DTMF remote control | Commande à distance DTMF | History prefix « Commande DTMF : ». | |
| NOAA weather alerts | Alertes météo NOAA | | |
| NOAA Weather (zone list name), NOAA Weather Radio | NOAA Weather · NOAA Weather Radio | US service names kept; the car message and scope preset say « Météo NOAA » (§8). | |
| Send my callsign in Morse | Émettre mon indicatif en Morse | | |
| Morse ID after I talk (setting) | Indicatif en Morse après mes passages | | |
| KEY (Morse key legend) | MANIP | Short for *manipulateur*. ❓ | |
| Run a net | Animer un réseau | | |
| Report (net) | Compte rendu | | |
| Share the report / Share the report zip | Partager le rapport / Partager le zip du rapport | | |
| %1$d following (net) | abonnés : %1$d | A count in a non-plural string goes after a colon, so it reads right for 0 and 1 (also « trouvées : %1$d », « nouveaux : %1$d »). | |
| Talking: %1$s (car, the caller) | Au micro : %1$s | « En émission » read as you transmitting. | |
| RADIO OFF (car art badge) | ÉTEINTE | Badge of about 12 characters. | |
| Send text (FT8) | Envoyer texte | | |
| Sent (FT8 list) | Émis | | |
| Stop FT8 / Stop M17 | Arrêter FT8 / Arrêter M17 | | |
| Your own (zone list group) | Les vôtres | | |
| Analog (quick share pill) | Analog. | Abbreviated in a pill; « Analogique » elsewhere. ❓ | |
| Mark / Waiting… / Waiting for the fox (fox hunt) | Marquer / Attente… / Attente du renard | | |
| Heat / heat map (fox layer) | Chaleur / carte de chaleur | | |
| Bearings / Fox estimate | Relèvements / Estimation du renard | | |
| Live (APRS list) | DIRECT | The web's live indicator is « En direct ». ❓ | |
| M17 destination | Destinataire M17 | | |
| Type a line (terminal hint) | Saisissez une ligne | | |
| Position is approximate | Position approximative | | |
| ON AIR (channel badge) | ACTIF | ❓ « QRV » | |
| Incoming: accept / refuse (packet terminal) | Entrantes : acceptées / Entrantes : refusées | | |
| Packet terminal | Terminal packet | | |
| Gateways (Winlink) | Passerelles | | |
| Message forms | Formulaires de message | | |
| Satellite passes | Passages de satellites | | |
| ARISS status | État ARISS | | |
| Custom range (scope) | Plage personnalisée | | |
| waterfall | cascade | Scope and FT8. | |
| Volume-up transmits | Volume + pour émettre | | |
| Custom PTT key / Side PTT key | Touche PTT personnalisée / Touche PTT latérale | | |
| Animated panel when quiet | Panneau animé au repos | | |
| Run all checks | Lancer tous les tests | « les tests » in prose, not « vérifications ». | |
| Diagnostics | Diagnostic | | |
| Check for updates | Rechercher des mises à jour | | |
| Stable / Beta (update paths) | Stable / Bêta | | |
| Captions / Recordings / Activity (Last heard buttons) | Sous-titres / Enregistrements / Activité | | |
| Start the activation / End the activation | Démarrer l'activation / Terminer l'activation | | |
| Shift (keyboard key) | Maj | As French keyboards. | |
| Previous / Next (widget, car) | Précédent / Suivant | | |
| classic intercom page | page Radio classique | | |
| e-mail address | adresse e-mail | The service stays « Courriel Winlink » (§8). ❓ « adresse électronique » | |
| DMR text | texte DMR (labels) · message DMR (prose) | History kind and message type say « texte DMR »; guide prose « un message DMR ». ❓ One of the two everywhere. | |
| ON / OFF (channel editor interrupt pills, capitals) | ON / OFF | §2 allows it; switches elsewhere say « Activé / Désactivé ». ❓ | |
| ON / OFF (packet sheet state pills) | OUI / NON | Very short pills. | |
| Monitor (APRS, pager button) / monitoring (chip) | Écouter / Écoute | Never *surveillance* (§8). | |
| uploaded (recording, web) | importé | « %1$s importé, décodage en cours ». | |
| skipped (restore) | non restaurés : %1$d | | |
| duplicates (preset add) | en double | Invariable. | |
| Got it (button) | J'ai compris | The PTT-learn sentence "Got it." is « C'est noté. » | |
