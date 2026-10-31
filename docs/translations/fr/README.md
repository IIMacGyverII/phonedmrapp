# SignalDeck in French (fr)

**Status: draft, awaiting native review.** Nothing here has been reviewed by a native-speaking ham yet, and no French
string exists in the app. French ships once it is translated, back-checked and screen-checked (owner, 2026-10-30); a
native review then improves it, through plain-file PRs.

**Reviewed by a native-speaking ham:** nothing yet.

- `glossary.md`: the recurring terms and their French rendering (about 300 rows), for the reviewer to agree first. It
  includes every term the German draft settled (its §8).
- `style.md`: register (*vous*), French typography (no-break spaces, « »), numbers, key legends, safety-text rules,
  plurals and regional variants.

The target is **neutral French** that hams in France, Belgium, Switzerland and Canada read naturally; REF and UBA usage
is the guide, with Québec differences noted where they matter. The French text in these files uses the real
no-break spaces (U+00A0 before `:` and units, U+202F before `;` `!` `?` and inside « »), as the app will.

The order of work, after the extraction (`../research.md` §6):
1. glossary and style guide, with a reviewer's answers if they come first;
2. draft;
3. back-check;
4. screen check (accented capitals in the title font, « », the narrow no-break space, French length);
5. ship in a beta;
6. native review improves it afterwards.

## Questions for a French-speaking ham reviewer (for the owner to forward)

Contact goes through the owner only. These are the choices the glossary can't settle without a French-speaking ham.
The rest of `glossary.md` is welcome feedback too, but these come first. The proposed term is first; alternatives
follow. A reviewer from Belgium, Switzerland or Québec is welcome to say where their usage differs.

**English**
1. **vous or tu** for addressing the user? (Proposed: *vous*, as French software and manuals do.)
2. **Decimal comma** on screen, including the big frequency readout: `467,625 MHz`, with input fields accepting comma
   and dot. OK, or keep the radio-style dot on the readout?
3. **The main page (English "Intercom"):** *Radio*, *Trafic*, or keep *Intercom*?
4. **Squelch:** *squelch* or *silencieux*?
5. **Talkgroup:** *talkgroup (TG)* or *groupe de discussion*? And **colour code**: *code couleur* or *Color Code*?
   **Time slot**: *slot (TS)* or *intervalle de temps*?
6. **Repeater:** *relais* everywhere, or *répéteur* for Canadian readers?
7. **Licence:** *licence radioamateur* everywhere, or the legal term (*certificat d'opérateur* in France and Canada)?
8. **Nets:** *réseau*, *QSO de section* or *rendez-vous*? And **check-in**: *pointage / pointer* or *inscription*?
9. **Restricted mode** (a voluntary PIN lock): *Mode verrouillé* or *Mode restreint*?
10. **Save vs Record:** Save is *Enregistrer* (Android); Record becomes *Démarrer l'enregistrement*. OK, or Save =
    *Sauvegarder*?
11. **Firmware, e-mail, pager:** *firmware* or *micrologiciel*; *courriel* or *e-mail*; *pager*, *bipeur* or
    *téléavertisseur*?
12. **Voice keyer:** *Mémoires vocales*, or another term French hams use?
13. **Roger beep:** *roger bip* or *bip de fin d'émission*? **Repeater tail:** *traîne* or *queue*?
14. **Live captions:** *Sous-titres en direct*, or Android's *Sous-titres instantanés*?
15. **Narrow no-break space before `;` `!` `?`:** keep it (France, Belgium), or drop it as Swiss and Québec texts often do?

Already decided (the reviewer may still object): the intercom key legends **SCAN, ZONE, TXT, SOFT SQ, MON** stay
English, as on French-language radios. Callsign = *indicatif*, offset = *décalage*, mode = *mode*, net control =
*station directrice*, logbook = *carnet de trafic*, fox hunt = *chasse au renard*, Parrot = *Perroquet*, take over /
hand back = *prendre la main / rendre la main*.

**Français**
1. **Vouvoiement ou tutoiement** pour s'adresser à l'utilisateur ? (Proposition : *vous*, comme les logiciels et les
   manuels en français.)
2. **Virgule décimale** partout à l'écran, y compris dans le grand affichage de fréquence : `467,625 MHz` ; les champs
   de saisie acceptent la virgule et le point. D'accord, ou garder le point comme sur un poste ?
3. **La page principale (« Intercom » en anglais) :** *Radio*, *Trafic*, ou garder *Intercom* ?
4. **Squelch :** *squelch* ou *silencieux* ?
5. **Talkgroup :** *talkgroup (TG)* ou *groupe de discussion* ? Et le **colour code** : *code couleur* ou *Color
   Code* ? Le **time slot** : *slot (TS)* ou *intervalle de temps* ?
6. **Repeater :** *relais* partout, ou *répéteur* pour les lecteurs canadiens ?
7. **Licence :** *licence radioamateur* partout, ou le terme légal (*certificat d'opérateur* en France et au Canada) ?
8. **Nets :** *réseau*, *QSO de section* ou *rendez-vous* ? Et le **check-in** : *pointage / pointer* ou
   *inscription* ?
9. **Restricted mode** (verrouillage volontaire par code PIN) : *Mode verrouillé* ou *Mode restreint* ?
10. **Save et Record :** Save = *Enregistrer* (Android) ; Record devient *Démarrer l'enregistrement*. D'accord, ou
    Save = *Sauvegarder* ?
11. **Firmware, e-mail, pager :** *firmware* ou *micrologiciel* ; *courriel* ou *e-mail* ; *pager*, *bipeur* ou
    *téléavertisseur* ?
12. **Voice keyer :** *Mémoires vocales*, ou un autre terme en usage chez les radioamateurs ?
13. **Roger beep :** *roger bip* ou *bip de fin d'émission* ? **Traîne du relais :** *traîne* ou *queue* ?
14. **Live captions :** *Sous-titres en direct*, ou *Sous-titres instantanés* comme Android ?
15. **Espace fine insécable avant `;` `!` `?` :** la garder (France, Belgique), ou la supprimer comme souvent en Suisse et
    au Québec ?

Déjà décidé (les objections sont bienvenues) : les touches **SCAN, ZONE, TXT, SOFT SQ, MON** restent en anglais, comme
sur les postes vendus en français. Callsign = *indicatif*, offset = *décalage*, mode = *mode*, net control = *station
directrice*, logbook = *carnet de trafic*, fox hunt = *chasse au renard*, Parrot = *Perroquet*, take over / hand back =
*prendre la main / rendre la main*.
