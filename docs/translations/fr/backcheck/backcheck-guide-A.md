# Back-check: French guide, part guide-A

Part file: `scratchpad/fr-guide/partA.json` (24 topics, 155 sections, about 18,300 French words from 16,300 English).

Method: the French was read back into English section by section and compared with en.json for meaning, negations,
numbers and units. A script also compared section ids, `{@…}` references and every number with en.json (decimal comma
read as a point). The only number differences are deliberate: "60 mph" gets "environ 100 km/h" added, and "19:00" in
guide prose is written « 19 h » (style §5).

## Fixes made after the back-check

| Topic / section | Draft French (back-translated) | Problem | Fixed French |
|---|---|---|---|
| record-and-monitor / monitor | « MON demande à la radio de transmettre tous les appels » ("transmit every call") | *transmettre* can read as "transmit on the air"; the English means "pass through to you" | « laisser passer tous les appels numériques » |
| packet-radio / sstv | « le téléphone est relevé toutes les cinq secondes » ("the phone is read") | unclear what is measured | « les températures du téléphone sont relevées toutes les cinq secondes » |
| vfo / frequency-range | « l'application ne le lui envoie jamais » ("the app never sends it to it") | pronoun ambiguous | « l'application ne lui envoie donc jamais une telle fréquence » |
| packet-radio / aprs | « saisir CALL-7 … est séparé pour vous » | ungrammatical, meaning unclear | « si vous saisissez CALL-7 …, il est séparé pour vous » |
| packet-radio / morse | Morse ID setting rendered "{@morse} after my transmissions", dropping "ID" | lost a word of the setting name | « Indicatif en {@intercom_chhistory_kind_morse} après mes passages » (matches `packet_set_morse_id`) |
| fox-hunt / fox-signal | « pendant les 1,5 dernière seconde », « dans les 0,6 dernière seconde » | grammar, reads as a different duration | « pendant la dernière seconde et demie », « dans les 0,6 s qui précèdent la fin de l'émission » |
| packet-radio / packet-terminal | « Entrantes : Accepter permet … » | button name and sentence did not fit | « Avec Entrantes : acceptées, d'autres stations peuvent se connecter à vous » |

Name alignments with `values-fr/` (not meaning errors, but on-screen names that must match), done on the last check:
Commencer à vide, Enregistrer en canal, TOUS les canaux, Auto-ack / Pas d'auto-ack (UHF), acquitter, À distance /
Commande à distance DTMF, Alertes météo NOAA (button), Afficher toutes les listes, Propagation VHF/UHF, Essaims de
météores, Aurores, Émettre mon indicatif en Morse, MANIP / Manipulation, Me prévenir / Me prévenir à l'ouverture d'un
réseau, L'ajouter à mes réseaux, Animer un réseau, Partager le rapport, Envoyer en texte DMR, Lire en l'air, Nouvel
ICS-213, Lancer CQ, Envoyer texte, Émis, Arrêter FT8 / Arrêter M17, Les vôtres / Nouvelle zone avec vos canaux,
Supprimer la zone (garder ses canaux), Analog., Non autorisé ici, L'enregistrer, Marquer, Attente…, Attente du renard,
Renard seul, Calculer, Chaleur, Décaler, Recherche : oui, Noter les entendus : oui, On dirait un réseau, Direct (APRS
tab), 2 m FM simplex / 70 cm FM, Destinataire M17, Saisissez une ligne, approximative, ACTIF (ON AIR badge).

## Count
155 sections, 24 titles and 24 summaries checked; 7 meaning fixes; 0 placeholder or `{@…}` differences.

## Safety text checked twice
- getting-started / talk-and-listen: transmit limit (2 minutes) and the heat guard past 30 seconds.
- m17 / talking-back: no M17 transmit on the shipped firmware; transmit limit and heat guard apply.
- packet-radio / sstv: heat waits, start refused at 60 °C radio / 45 °C battery, cut at 70 °C / 48 °C / +2 °C in 10 s.
- packet-radio / aprs: packet, DTMF and SSTV refused on DMR channels.
- packet-radio / iss: ISS SSTV receive only, transmitting blocked; beacon only while the ISS is in view.
- packet-radio / morse and id-timer: identification rules, Morse ID skipped within 3 s of the transmit limit.
- packet-radio / dtmf-remote-control: PIN lock (3 wrong PINs, 10 minutes), PIN never logged, off by default.
- pager / sending: sends only on bench firmware FW21+, does not key on the shipped firmware; low power.
- channels / receive-only: Talk, the side key and every automatic transmission refused; NOAA, marine, railroad always receive only.
- channels / zones-and-standard-lists: "not legal here" lists, transmitting is your responsibility, GMRS and Business need a (US) licence, licence-free lists at low power.
- vfo / band-plan and frequency-range: caution where transmitting needs another licence or is not allowed; out-of-range frequencies never sent.
- scheduled-operations / when-it-runs: schedules wait while you transmit, do not run after Hand back.
- winlink-e-mail / what-it-is and account-and-password: licence needed; password never shown, logged or backed up.
- fox-hunt / marks-and-the-estimate, spin-for-the-bearing, fox-signal: marks refused while you transmit.
- band-scope / listen-and-stop: receive only, stops when you transmit.
