# German style guide (de): DRAFT, awaiting native review

**Status: draft, awaiting native review.** The rules every German string follows, together with `glossary.md`. The
reviewer may change any rule; once agreed, the rules are fixed and the draft follows them.

## 1. Register: *du*
- Address the user as **du**, lower case (*du*, *dein*), as German ham apps and the DARC community do among hams.
  **A reviewer may change it:** *Sie* is the alternative; it reads stiffer in an app for hobbyists.
- Imperatives with *du*: "Tippe auf **Übernehmen**", "Halte die Sprechtaste gedrückt".
- No gendered nouns for the user: write "du", or "wer sendet", not "der Benutzer".

## 2. Tone
- **Write it the way a German ham explains it on the bench,** not as a translation. Restructure the sentence freely:
  German puts the verb at the end of subordinate clauses and prefers fewer, longer sentences where English chains short
  ones.
  - EN: "Hold the large round key to talk; release it to listen."
  - Literal (avoid): "Halte die große runde Taste, um zu sprechen; lass sie los, um zuzuhören."
  - Natural: "Zum Sprechen die große runde Taste gedrückt halten, zum Hören loslassen."
- **Short beats complete.** German is ~30 % longer. In buttons and labels use the glossary's short form; in prose, cut
  filler ("einfach", "bitte" only where the English is a request).
- **Anglicisms:** keep the international ham terms the glossary keeps (PTT, CTCSS, Colorcode, APRS …). Don't invent
  German for terms German hams don't use, and don't keep English where a normal German word exists ("Einstellungen",
  not "Settings").

## 3. Labels and capitalisation
- German grammar rules capitalisation: nouns are capitalised, everything else is not. There is no English-style title
  case: "Längste Aussendung", not "Längste Aussendung Einstellen".
- **Buttons:** infinitive verb or a noun ("Speichern", "Übernehmen", "Neue Zone").
- **Section titles:** noun phrases ("Funkeinstellungen", "Bekannte Eigenheiten").
- **All-caps labels** (`Neo.caps`, `Neo.title`, chips) are upper-cased by the app. Write them in normal case in the
  string; ß becomes SS automatically. Don't put quote marks in titles (the title font lacks „).
- **Switch rows:** the label names the feature ("Rauschsperre beim Suchlauf"), with no "Einschalten".

## 4. Punctuation and typography
- Quotes: „so“ (German low-high quotes). Nested quotes: ‚so‘.
- Dash: spaced en dash " – " for a pause; a hyphen only inside compounds.
- **Compounds with abbreviations take a hyphen:** DMR-Kanal, CTCSS-Ton, APRS-Bake, PTT-Taste, S-Meter.
- Ellipsis "…" on buttons that open a dialog, as in English.
- The arrow for menu paths stays: "Gerät → Funkeinstellungen → Intercom-Layout". These come from `{@label}` references,
  never typed by hand (`research.md` §4.4).
- No exclamation marks, except in safety warnings where the English has one.

## 5. Numbers, units, dates
- **Decimal comma everywhere on screen** (decided 2026-10-30, **reviewer to confirm**): 12,5 kHz; 467,625 MHz in prose,
  lists and the large frequency readout. Entry fields accept both `,` and `.`, so a user may type either.
- Thousands: a narrow space or none ("1 200 Hz" or "1200 Hz"); never a dot in numbers that might be read as a frequency.
- Always a space between number and unit: "30 s", "5 W", "−85 dBm". Use the real minus sign (−) for dBm.
- Time: 24 hours, "14:05". Date: "30.10.2026", or "30. Okt." where it is short; weekdays "Mo., Di. …".
- Ranges: "1 bis 9" in prose, "1–9" on labels.

## 6. Key legends on the intercom
- The intercom keys (**SCAN, ZONE, TXT, SOFT SQ, MON** and the six buttons) work like printed key legends on a radio.
  German radios print them in English, so they **stay English** (decided 2026-10-30), and the guide says "Tippe auf SCAN".
- The text **around** them is translated: "SCAN sucht die Kanäle der aktuellen Zone ab."

## 7. Warnings and safety text
- **As clear as the English.** Never soften: "darf nicht", "nicht ausschalten", "Senden ist nur mit
  Amateurfunkzulassung erlaubt".
- The negation goes early in the sentence, where it cannot be missed.
- Start with the consequence, then the reason: "Senden abgelehnt: Dieser Kanal ist nur für den Empfang."
- Firmware loading, transmit limits, heat, licence and the Sperr-PIN get a **second pass** and are marked in the
  back-check.
- Legal statements stay neutral. German rules (BNetzA, AFuV) are not mentioned unless the English says something
  country-specific. The app's US-specific text (FCC, MURS, GMRS) stays a statement about the US: "In den USA …".

## 8. Plurals and placeholders
- German has two plural forms (`one`, `other`): "1 Kanal", "3 Kanäle".
- Placeholders may move anywhere in the sentence (`%1$s`, `%2$d`), and every one in the English must appear exactly
  once. Never split a sentence across two strings.

## 9. What stays English
- Logs, diagnostics, the device and bench reports, file formats, protocol words, anything transmitted, the exam
  questions (`research.md` §3).
- Product, mode and service names: SignalDeck, Android Auto, FM, DMR, M17, APRS, SSTV, FT8, Winlink, POCSAG, MURS, GMRS.
