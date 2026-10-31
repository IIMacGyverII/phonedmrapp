# French style guide (fr): DRAFT, awaiting native review

**Status: draft, awaiting native review.** The rules every French string follows, together with `glossary.md`. The
reviewer may change any rule; once agreed, the rules are fixed and the draft follows them.

French here is **neutral French** for readers in France, Belgium, Switzerland and Canada: no regional words where a
shared one exists, and Québec differences noted only where they matter (§10). There is one French file (`values-fr`);
no `fr-rCA` variant unless a Canadian reviewer asks for one.

## 1. Register: *vous*
- Address the user as **vous**: « Appuyez sur **Prendre la main** », « Maintenez la touche d'émission enfoncée ».
- **Why *vous*, not *tu*:** on the air French-speaking hams *tutoient* each other, but written software in French
  (Android, Google, Apple, Icom and Yaesu French manuals, the REF and UBA websites, RAQI documents) addresses the reader
  as *vous*. *Tu* in a French app reads as a game or a youth product, and Belgian, Swiss and Québec readers expect *vous*
  in instructions even more than French readers do. **A reviewer may change it:** *tu* is the alternative if the
  reviewer wants the app to sound like an OM at the bench. Mixing the two is never allowed.
- **Buttons and labels are infinitives** (Android French): "Enregistrer", "Prendre la main", "Rendre la main". Prose
  and instructions use the imperative with *vous*.
- **Gender-neutral address comes for free with *vous*.** Write "vous", or an impersonal form ("Une licence est
  obligatoire pour émettre"), not "l'utilisateur". *Radioamateur* is epicene. No *écriture inclusive* with the point
  médian (*radioamateur·e·s*): it is not accepted by the Belgian and Québec style guides, breaks screen readers and
  costs width. Where a person must be named, use an epicene word (*la station*, *l'opérateur ou l'opératrice* only in
  long prose).

## 2. Tone
- **Write it the way a French-speaking ham explains it at the club,** not as a translation. Restructure freely: French
  prefers nouns where English chains verbs, and one sentence with a relative clause where English has two short ones.
  - EN: "Hold the large round key to talk; release it to listen."
  - Literal (avoid): « Tenez la grande touche ronde pour parler ; relâchez-la pour écouter. »
  - Natural: « Maintenez la grande touche ronde enfoncée pour parler, relâchez-la pour écouter. »
  - EN: "Taking over pauses the stock app."
  - Literal (avoid): « Prendre la main met en pause l'application d'origine. »
  - Natural: « Quand SignalDeck prend la main, l'application d'origine est mise en pause. »
- **Short beats complete.** French runs about 15–20 % longer than English. On buttons and labels use the glossary's
  short form; drop articles on labels ("Puissance d'émission", not « La puissance d'émission »). In prose keep the
  articles (French needs them) and cut filler (*simplement*, *veuillez* only where the English is a request).
- **Anglicisms:** keep the international ham terms the glossary keeps (PTT, CTCSS, squelch, talkgroup, APRS, hotspot,
  firmware…). Don't keep English where a normal French word exists ("Paramètres", not "Settings"; "numérique", never
  "digital"; "télécharger", not "downloader"). Kept English nouns get a French gender (glossary) and no English plural
  form beyond the -s: « les talkgroups », « les hotspots ».
- **Faux amis to watch:** *éventuellement* (= possibly, not eventually), *actuellement* (= currently), *digital*
  (= of the fingers), *librairie* (= bookshop: a code library is a *bibliothèque*), *supporter* (= to put up with: a
  phone is *pris en charge*), *contrôler* (= to check), *définitivement* (= for good).

## 3. Labels and capitalisation
- **Sentence case everywhere:** only the first word and proper names take a capital. "Paramètres radio", "Durée
  d'émission maximale", never English title case ("Paramètres Radio").
- **Buttons:** infinitive verb or a short noun ("Enregistrer", "Prendre la main", "Nouvelle zone").
- **Section titles:** noun phrases ("Paramètres radio", "Particularités connues").
- **All-caps labels** (`Neo.caps`, `Neo.title`, chips) are upper-cased by the app. Write them in normal case in the
  string. **Capitals keep their accents** (French typography, Académie and OQLF agree): "ÉMISSION REFUSÉE", "RÉCEPTION".
  The upper-casing must use the French locale so É, È, À, Ç, Œ survive; the screen check verifies the title font draws
  them. Don't put « » in titles until the screen check shows the font has them.
- **Switch rows:** the label names the feature ("Squelch pendant le balayage"), with no "Activer".
- **Proper names** keep their own case: SignalDeck, BrandMeister, Android Auto. Mode names stay upper case: FM, DMR.

## 4. Punctuation and typography
French typography rules apply on screen, in the guide and on SignalDeck Web.

| Before / around | Space | Character | Example |
|---|---|---|---|
| `:` | no-break space | U+00A0 | « Émission refusée : canal en réception seule » |
| `;` `!` `?` | narrow no-break space | U+202F | « Supprimer le canal 3 ? » |
| inside « » | narrow no-break space | U+202F | « relais perroquet » |
| number and unit | no-break space | U+00A0 | 12,5 kHz · 30 s · 50 % |
| thousands | narrow no-break space | U+202F | 1 200 Hz |
| `.` `,` `…` `)` | none | | « Chargement… » |

- **In the string files** write the characters themselves (UTF-8), not `&#160;` entities, so a reviewer reads plain
  text. A normal space before `:` or `?` is a bug: the line can break and leave the `?` alone on the next line. The
  placeholder check (plan §3.6) should also flag a plain space before `: ; ! ?` in French.
- **Swiss and Québec readers:** both often set no space before `;` `!` `?`. The narrow space is correct in France and
  Belgium and reads naturally everywhere, so the neutral file keeps it (§10).
- **Quotes:** « ainsi » with narrow no-break spaces. Nested quotes: “ainsi”. Never "straight" quotes in French text.
- **Apostrophe:** the typographic ’ in the string files (*l’émission*). In Android XML a straight `'` must be escaped
  (`\'`), so the typographic ’ is also easier. Elision is required: *l'appareil*, *d'émission*, *qu'il*; never
  *de émission*. Before a kept English word starting with a vowel, elide too: *l'iGate*, *d'APRS*.
- **Dash:** an en dash with spaces " – " for an aside, used sparingly; French prefers a comma or parentheses.
- **Ellipsis** "…" on buttons that open a dialog, as in English: "Importer…".
- The arrow for menu paths stays: "Appareil → Paramètres radio → Disposition de la page Radio". These come from
  `{@label}` references, never typed by hand (`research.md` §4.4).
- **No exclamation marks**, except in safety warnings where the English has one.
- **Abbreviations:** "n°" for numéro (« canal n° 3 », or just « canal 3 »), "env." not "approx.", "etc." without "…".

## 5. Numbers, units, dates
- **Decimal comma everywhere on screen** (decided for German on 2026-10-30, applied to French; **reviewer to
  confirm**): 12,5 kHz; 467,625 MHz in prose, lists and the large frequency readout. Entry fields accept both `,` and
  `.`, so a user may type either.
- **Thousands:** a narrow no-break space ("1 200 Hz") or none for four digits ("1200 Hz"); never a dot or a comma
  (a comma is the decimal sign).
- Always a no-break space between number and unit: "30 s", "5 W", "−85 dBm", "50 %". The real minus sign (−) for dBm.
  Unit symbols never take a plural or a dot: "2 min", not "2 mins" or "2 mn".
- **Time:** 24 hours. On screen "14:05" (Android's French format, and fixed-width); in guide prose « 14 h 05 », « à
  14 h ». Durations: "1 h 30", "2 min 10 s".
- **Date:** let Android format dates from the locale. For text the app builds itself: "30/10/2026" or "30 oct. 2026";
  month names lower case; weekdays lower case ("lundi", short "lun."). Week starts on Monday.
- **Ordinals:** 1er, 1re, 2e, 3e (no "ème", no "ère").
- **Ranges:** « de 1 à 9 » in prose, "1–9" on labels.
- **Numbers in words** (rare in UI text): France *soixante-dix, quatre-vingt-dix*; Belgium and Switzerland say
  *septante, nonante*. Write digits so the question never comes up.

## 6. Key legends on the intercom
- The intercom keys (**SCAN, ZONE, TXT, SOFT SQ, MON** and the six buttons) work like printed key legends on a radio.
  French-language radios print them in English, so they **stay English** (decided 2026-10-30), and the guide says
  « Appuyez sur SCAN ».
- The text **around** them is translated, and the legend is used as a masculine name: « La touche SCAN balaie les
  canaux de la zone en cours », « le niveau SOFT SQ ».

## 7. Warnings and safety text
- **As clear as the English.** Never soften: "interdit", "obligatoire", « N'éteignez pas le téléphone », « Une licence
  radioamateur est obligatoire pour émettre ».
- **Both halves of the negation, always:** « ne … pas », « ne … jamais ». Spoken French drops the *ne*; written
  safety text must not.
- The negation or the obligation goes early in the sentence, where it cannot be missed.
- Start with the consequence, then the reason: « Émission refusée : ce canal est en réception seule. »
- Imperative with *vous* for instructions ("Attendez", "N'éteignez pas"); the infinitive (« Ne pas éteindre ») only
  for a short label or a step heading.
- Firmware loading, transmit limits, heat, licence and the restricted-mode PIN get a **second pass** and are marked in
  the back-check.
- Legal statements stay neutral. National rules (ANFR/ARCEP in France, IBPT in Belgium, OFCOM in Switzerland, ISDE in
  Canada) are not mentioned unless the English says something country-specific. The app's US-specific text (FCC, MURS,
  GMRS) stays a statement about the US: « Aux États-Unis, … ».

## 8. Plurals and placeholders
- **French plural categories differ from English.** In Android (CLDR) French, `one` covers **0 and 1**: « 0 canal »,
  « 1 canal », « 2 canaux ». So a French `one` string must read correctly for zero too, or the English uses a separate
  zero string. Recent Android versions also have a `many` category for French (large round numbers: « 1 000 000 de
  canaux »); give `many` the same text as `other` (with "de" where the grammar wants it) so the key/plural test passes.
- Plurals of the kept words: *canal → canaux*, *relais* and *QSO* invariable in the plural by usage ("les QSO" is also
  common, keep it invariable), *talkgroups*, *hotspots*, *zones*.
- **Agreement with placeholders:** French adjectives agree in gender and number, so a placeholder whose gender is
  unknown (`%1$s` = any name) needs a sentence built around it: « Canal ajouté : %1$s », not « %1$s ajouté(e) ».
- Placeholders may move anywhere in the sentence (`%1$s`, `%2$d`), and every one in the English must appear exactly
  once. Never split a sentence across two strings.

## 9. What stays English
- Logs, diagnostics, the device and bench reports, file formats, protocol words, anything transmitted, the exam
  questions (`research.md` §3).
- Product, mode and service names: SignalDeck, Android Auto, FM, DMR, M17, APRS, SSTV, FT8, Winlink, POCSAG, MURS, GMRS.
- The intercom key legends (§6).

## 10. Regional variants
Neutral French first; a Québec or Belgian word only replaces it where the reviewer finds the neutral one wrong there.

| Point | France / Belgium | Switzerland | Québec | The file uses |
|---|---|---|---|---|
| Space before `;` `!` `?` | narrow no-break space | often none | none (OQLF allows a thin space) | narrow no-break space |
| repeater | relais | relais | relais, *répéteur* | relais |
| e-mail | e-mail, *courriel* | e-mail | courriel | courriel ❓ |
| pager | pager, *bipeur* | pager | *téléavertisseur* | pager ❓ |
| firmware | firmware | firmware | *micrologiciel* | firmware ❓ |
| phone | téléphone, *portable* | *natel* (dated) | *cellulaire* | téléphone |
| date | 30/10/2026 | 30.10.2026 | 2026-10-30 | Android locale format |
| numbers in words | soixante-dix | septante | soixante-dix | digits only |
