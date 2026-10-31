# Italian style guide (it): DRAFT, awaiting native review

**Status: draft, awaiting native review.** The rules every Italian string follows, together with `glossary.md`. The
reviewer may change any rule; once agreed, the rules are fixed and the draft follows them.

Target: standard Italian as Italian radioamatori write it (ARI material, Italian DMR community pages, the Italian
manuals of the big radio makers). One variant serves Italy, Ticino and San Marino; no regional words.

## 1. Register: *tu*
- Address the user as **tu** (*tu*, *tuo*, imperatives *tocca*, *tieni premuto*). Italian hams use *tu* with each other
  from the first QSO, and Android's and Google's Italian UI moved to *tu* years ago.
  **A reviewer may change it:** *Lei* is the alternative; it reads like a bank or a ministry in a hobby app.
- Possessives only where they help: "Imposta il nominativo" is better than "Imposta il tuo nominativo" when the
  sentence is already clear. Italian drops subject pronouns: "Puoi …", not "Tu puoi …".
- Buttons are imperatives in the *tu* form, as Android: "Salva", "Annulla", "Prendi il controllo".

## 2. Tone
- **Write it the way an Italian ham explains it at the section meeting,** not as a translation. Restructure freely:
  Italian links clauses where English chains short sentences, and puts the important information first.
  - EN: "Hold the large round key to talk; release it to listen."
  - Literal (avoid): "Tieni il grande tasto rotondo per parlare; rilascialo per ascoltare."
  - Natural: "Per parlare tieni premuto il tasto rotondo grande, poi rilascialo per ascoltare."
- **Short beats complete.** Italian runs ~15–25 % longer than English. In buttons and labels use the glossary's short
  form; in prose cut filler ("semplicemente", "per favore" only where the English is a request).
- **Anglicisms:** keep the international ham terms Italian hams keep (PTT, squelch, shift, talkgroup, color code,
  beacon, CTCSS, APRS). Don't invent Italian for them, and don't keep English where a normal Italian word exists
  (*Impostazioni*, not *Settings*; *scarica*, not *download*). English nouns kept in Italian take no plural -s: "i
  talkgroup", "due beacon", "i ponti DMR".
- Gender of kept English nouns: masculine by default (*il PTT, il beacon, il talkgroup, il log, il widget*); *la* where
  the Italian equivalent is feminine and usage agrees (*la radio, l'app, la mail*).

## 3. Labels and capitalisation
- **Sentence case** everywhere: only the first word and proper names are capitalised. "Impostazioni radio", never
  "Impostazioni Radio".
- Weekdays, months and language names are lower case ("lunedì", "ottobre", "inglese").
- **Buttons:** imperative verb or a short noun ("Salva", "Rendi prioritario", "Nuova zona").
- **Section titles:** noun phrases ("Impostazioni radio", "Particolarità note").
- **All-caps labels** (`Neo.caps`, `Neo.title`, chips) are upper-cased by the app. Write them in normal case in the
  string. Accented capitals are real letters: write *è*, the app shows **È**. Never write "E'" for *è* or "PERCHE'"
  for *perché*.
- **Switch rows:** the label names the feature ("Squelch durante la scansione"), with no "Attiva".

## 4. Punctuation and typography
- **Accents:** use the correct ones: *è* (is), *perché, poiché, né* (acute), *più, già, può, così*. *Qual è* has no
  apostrophe.
- **Apostrophe:** the typographic ’ (U+2019) in all strings: "l’antenna", "dell’app", "un’ora". It needs no escaping
  in Android XML and avoids the `\'` mistakes. ❓ Reviewer: straight ' is also acceptable if preferred, but one form
  only.
- **Quotes:** “così” (English-style curly double quotes), as Android's and most Italian software use; ‘così’ for
  nested quotes. Caporali « » are correct Italian but rare on phone screens. ❓ No quote marks in titles (the title
  font lacks them).
- Dash: spaced en dash " – " for a pause; hyphen only inside compounds.
- Compounds with abbreviations: Italian writes them as separate words, noun first: *canale DMR*, *tono CTCSS*,
  *beacon APRS*, *tasto PTT*, *ID DMR*. No hyphen.
- Ellipsis "…" on buttons that open a dialog, as in English. No space before it.
- The arrow for menu paths stays: "Dispositivo → Impostazioni radio → Aspetto della pagina Radio". These come from
  `{@label}` references, never typed by hand (`research.md` §4.4).
- Colon with no space before it (unlike French). No exclamation marks, except in safety warnings where the English has
  one.

## 5. Numbers, units, dates
- **Decimal comma everywhere on screen** (as decided for German; **reviewer to confirm**): 12,5 kHz; 467,625 MHz in
  prose, lists and the large frequency readout. Entry fields accept both `,` and `.`, so a user may type either.
  Italian hams sometimes write frequencies with a dot ("145.500") after radio displays; the comma is the language's
  convention and what ARI's band plan uses.
- Thousands: a dot is the Italian separator, but never use it where a number might be read as a frequency; write
  "1200 Hz", "12 000 voci" with a (narrow) space or nothing.
- Always a space between number and unit: "30 s", "5 W", "−85 dBm". Real minus sign (−) for dBm. Percent: "50%" with
  no space, as Android Italian.
- Time: 24 hours, "14:05". Date: "30/10/2026", or "30 ott" where it is short; weekdays "lun, mar, …" (no full stop).
- Ranges: "da 1 a 9" in prose, "1–9" on labels.
- Ordinals: "1°", "2ª" only where needed; prefer words in prose.

## 6. Key legends on the intercom
- The intercom keys (**SCAN, ZONE, TXT, SOFT SQ, MON** and the six buttons) work like printed key legends on a radio.
  Radios sold in Italy print them in English, so they **stay English** (decided 2026-10-30, every language), and the
  guide says "Tocca SCAN".
- The text **around** them is translated: "SCAN scansiona i canali della zona attuale."
- Italian articles before a legend follow its sound as read aloud: "lo SCAN" is awkward, so prefer "il tasto SCAN",
  "il tasto MON".

## 7. Warnings and safety text
- **As clear as the English.** Never soften: "non devi", "non spegnere", "è vietato", "per trasmettere serve la
  patente di radioamatore". No conditional politeness ("sarebbe meglio non …") where the English says don't.
- The negation goes early in the sentence, where it cannot be missed: "Non spegnere il telefono durante il caricamento
  del firmware."
- Start with the consequence, then the reason: "Trasmissione rifiutata: questo canale è solo in ricezione."
- Firmware loading, transmit limits, heat, licence and the restricted-mode PIN get a **second pass** and are marked in
  the back-check.
- Legal statements stay neutral. Italian rules (MIMIT, Codice delle comunicazioni elettroniche) are not mentioned
  unless the English says something country-specific. The app's US-specific text (FCC, MURS, GMRS) stays a statement
  about the US: "Negli Stati Uniti …".

## 8. Gender-neutral address
- Italian adjectives and participles agree with the person; English-style "you are connected" would force *connesso/a*.
  Rephrase around the action or the object instead:
  - "You're connected" → "Connessione riuscita"; "Welcome" → "Ti diamo il benvenuto" (or a neutral title,
    "Primi passi").
  - "Are you sure?" → "Confermi?" rather than "Sei sicuro?".
- For people in general use *chi* ("chi trasmette", "chi conduce la ruota") rather than "l'utente" or "il
  radioamatore". Never "o/a", slashes or schwa.

## 9. Plurals and placeholders
- Italian uses `one` and `other` ("1 canale", "3 canali"). Recent Android (CLDR 38+) also has a `many` form for
  millions ("1 milione di …"); give it the same text as `other`, so lint stays quiet.
- Watch agreement with the number: "1 messaggio inviato", "3 messaggi inviati"; "1 registrazione salvata", "3
  registrazioni salvate".
- Placeholders may move anywhere in the sentence (`%1$s`, `%2$d`), and every one in the English must appear exactly
  once. Never split a sentence across two strings. Watch articles in front of a placeholder ("il %1$s" breaks if the
  value starts with a vowel or *s* + consonant): rephrase with a noun ("il canale %1$s").

## 10. What stays English
- Logs, diagnostics, the device and bench reports, file formats, protocol words, anything transmitted, the exam
  questions (`research.md` §3).
- Product, mode and service names: SignalDeck, Android Auto, FM, DMR, M17, APRS, SSTV, FT8, Winlink, POCSAG, MURS, GMRS.
- The key legends (§6) and the international ham terms the glossary keeps.
