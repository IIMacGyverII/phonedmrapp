# Spanish style guide (es): DRAFT, awaiting native review

**Status: draft, awaiting native review.** The rules every Spanish string follows, together with `glossary.md`. The
reviewer may change any rule; once agreed, the rules are fixed and the draft follows them.

## 1. Register: *tú*
- Address the user as **tú** (*tu equipo*, *toca*, *mantén presionado*). Android's own Spanish UI uses *tú* in both
  Spain (es-ES) and Latin America (es-419), and so do most hobby and ham apps; among hams on the air, *tú* is the
  normal register in Spain and common in Latin America.
- **A reviewer may change it:** *usted* is the alternative. It is still the polite default in parts of Latin America
  (Colombia, Central America) and reads more formal; it would change every imperative (*toque*, *mantenga*).
- **No voseo** (*tocá*, *tenés*) and **no vosotros** (*tocad*): each belongs to one region. Where a plural "you" is
  unavoidable, use *ustedes*, which every region uses.
- **Gender-neutral address:** *tú* has no gender, so most strings need nothing. Don't write "el usuario"; write "tú" or
  "quien transmite". Avoid adjectives that agree with the user ("¿Estás seguro?" becomes "¿Quieres continuar?" or
  "¿Seguro que quieres …?"). No @, x or -e endings. The generic plural *radioaficionados* is acceptable; "quienes tienen
  licencia" where it reads as well.

## 2. Variant: neutral international Spanish
- Written for hams in Spain **and** Latin America at once. Where the regions use different everyday words, choose the
  one both read without noticing, usually the more general word:

| Concept | Spain | Latin America | Use |
|---|---|---|---|
| phone | móvil | celular | **teléfono** |
| car | coche | carro / auto | **vehículo** |
| the radio (device) | la radio | el radio | **equipo**, or *radio* with no article |
| computer | ordenador | computadora | **PC** or **navegador** (SignalDeck Web) |
| settings | Ajustes | Configuración | **Ajustes** (glossary §1 ❓) |
| add | añadir | agregar | **agregar** (glossary §2 ❓) |
| long-press | mantener pulsado | mantener presionado | **mantener presionado** |
| type in (data) | introducir | ingresar | **escribir**, **configurar** |
| check | comprobar | chequear / verificar | **verificar** |
| monitor | monitorizar | monitorear | **escuchar** (glossary §8) |
| weather | el tiempo | el clima | **meteorológico** |
| live | en directo | en vivo | **en tiempo real** |
| report | informe | reporte | **informe** (*reporte* only for net check-ins) |
| file | fichero / archivo | archivo | **archivo** |
| narrow (bandwidth) | estrecha | angosta | **estrecha** |
| net | rueda | red / rueda | **rueda** (glossary §1 ❓) |
| logbook | libro de guardia | bitácora | **log** (glossary §1 ❓) |

- No regional slang or idioms (*vale*, *ahorita*, *chévere*, *guay*). Neutral connectors: *de acuerdo*, *ahora*.
- If a later reviewer finds a choice reads wrong in one region, the fix is the more neutral word, not a regional copy.
  Separate `es-ES` / `es-419` files are a last resort (twice the upkeep) and only if a reviewer finds that neutral
  wording cannot carry a screen.

## 3. Tone
- **Write it the way a Spanish-speaking ham explains it on the bench,** not as a translation. Restructure freely: Spanish
  prefers the infinitive or a gerund where English uses "to …", and joins short English sentences.
  - EN: "Hold the large round key to talk; release it to listen."
  - Literal (avoid): "Mantén la tecla grande redonda para hablar; suéltala para escuchar."
  - Natural: "Para hablar, mantén presionado el botón redondo grande; al soltarlo, escuchas."
- **Watch false friends:** *actualmente* (currently), not "actually" (*en realidad*); *eventualmente* means "possibly",
  never "eventually" (*con el tiempo*, *al final*); *aplicar* a setting is fine, but "aplicar para" is not Spanish;
  *soportar* (to bear) for "support" becomes *ser compatible con*, *funcionar con*.
- **Avoid the English passive** ("is sent by the app"): use *se* ("se envía") or the active voice.
- **Short beats complete.** Spanish runs about 20–25 % longer than English. Use the glossary's short form on buttons and
  labels. Leave out "por favor" except where the English is a request.
- **Anglicisms:** keep the international ham terms the glossary keeps (PTT, squelch, CTCSS, talkgroup, slot, APRS, S-meter,
  hotspot, codeplug). Don't keep English where a normal Spanish word exists ("Ajustes", not "Settings"; "descargar", not
  "bajar" in UI text). Kept English nouns take a gender: *el* squelch, *el* talkgroup, *el* slot, *el* hotspot,
  *el* codeplug, *el* pager, *el* log, *la* app.

## 4. Punctuation and typography
- **¿ and ¡ always open** a question or exclamation, also in all-caps labels and toasts: "¿Eliminar el canal 3?".
  The title font (Orbitron) has both.
- **Accents are kept on capitals** (RAE): "ATENCIÓN", "SEÑAL". The app upper-cases all-caps labels; the screen check
  must confirm it uses the Spanish locale and that every accented capital renders (Orbitron has Á É Í Ó Ú Ñ Ü).
- **Quotes:** “so” (curved double quotes), nested ‘so’. The RAE prefers «» first, but Latin America mostly writes “…”,
  Android's es-419 does too, and **Orbitron has no « »** (checked 2026-10-30), so “…” is the one that works everywhere.
  Never quote marks in titles. Orbitron also lacks the middle dot ·, which some English cell legends use; check those
  on screen.
- **Colon:** lower case after it, as Spanish requires ("Transmisión rechazada: este canal es solo de recepción.").
  Exceptions: a quotation, or a proper name.
- **Dash:** an em dash —like this— for an aside, or commas; a spaced en dash " – " only for ranges in prose where
  English uses one. A hyphen only inside compounds, which Spanish uses far less than German ("canal DMR", not
  "canal-DMR"; "tono CTCSS"; "botón PTT").
- **Ellipsis "…"** on buttons that open a dialog, as in English, with no space before it.
- The arrow for menu paths stays: "Dispositivo → Ajustes de radio → Diseño de la página Radio". These come from
  `{@label}` references, never typed by hand (`research.md` §4.4).
- **No exclamation marks**, except in safety warnings where the English has one.
- Abbreviations end with a full stop and keep the RAE spacing: "EE. UU.", "p. ej.", "aprox.". Symbols take none
  (MHz, W, dBm). *solo* and demonstratives without accent (RAE 2010).

## 5. Numbers, units, dates
- **Decimal comma everywhere on screen** (as German; reviewer to confirm): 12,5 kHz; 467,625 MHz in prose, lists and the
  large frequency readout. Entry fields accept both `,` and `.`, so a user may type either.
  - **Regional caveat:** Spain and most of South America write the decimal comma; **Mexico, Central America, Puerto
    Rico, the Dominican Republic and parts of the Caribbean write the decimal point**, and many Spanish-speaking hams
    everywhere read frequencies with a point from their radios. The comma is the RAE norm and the brief's rule; the
    reviewer may prefer the point on the big readout. Because input accepts both, nothing breaks either way.
- Thousands: a space (narrow if available) or none: "1200 Hz", "12 000 m"; four-digit numbers take no separator (RAE).
  Never a point or a comma as a thousands separator in a number that might be read as a frequency.
- Always a space between number and unit: "30 s", "5 W", "−85 dBm", "25 °C" (but "45°" for bearings). Use the real
  minus sign (−) for dBm. Percent with a space: "80 %" (RAE).
- Time: 24 hours, "14:05", even though everyday Latin American usage is 12-hour; radio and logging use 24-hour, and UTC
  is "14:05 UTC". Date: "30/10/2026", or "30 oct 2026" where it is short. Months and weekdays lower case.
- Weekdays: one letter "L M X J V S D" (glossary §8 ❓); three letters "lun. mar. mié. jue. vie. sáb. dom.".
- Relative time: "hace 5 min", "dentro de 2 h".
- Ranges: "de 1 a 9" in prose, "1–9" on labels.

## 6. Labels and capitalisation
- **Sentence case** everywhere: only the first word and proper names are capitalised. No English title case:
  "Ajustes de radio", "Transmisión máxima", not "Ajustes De Radio".
- Months, weekdays, languages and band names are lower case ("octubre", "lunes", "la banda de 2 m").
- **Buttons:** infinitive ("Guardar", "Tomar control", "Agregar rueda"), or a noun ("Nueva zona"). Not the imperative on
  buttons; the imperative (*toca*, *mantén*) is for instructions in prose.
- **Section titles:** noun phrases ("Ajustes de radio", "Peculiaridades conocidas").
- **All-caps labels** (`Neo.caps`, `Neo.title`, chips) are upper-cased by the app. Write them in normal case in the
  string, with accents.
- **Switch rows:** the label names the feature ("Squelch durante el escaneo"), with no "Activar".

## 7. Key legends on the intercom
- The intercom keys (**SCAN, ZONE, TXT, SOFT SQ, MON** and the six buttons) work like printed key legends on a radio,
  and Spanish-market radios print them in English too, so they **stay English** in every language (decided
  2026-10-30). The guide says "Toca SCAN".
- The text **around** them is translated: "SCAN recorre los canales de la zona actual."
- Legends are masculine nouns in a sentence: "el botón SCAN", "con MON activado".

## 8. Warnings and safety text
- **As clear as the English.** Never soften: "no está permitido", "no apagues el teléfono", "Solo puedes transmitir
  con licencia de radioaficionado".
- **The negation goes early** in the sentence, where it cannot be missed: "No apagues el teléfono mientras se carga el
  firmware", not a sentence that ends with "… sin apagarlo".
- Start with the consequence, then the reason: "Transmisión rechazada: este canal es solo de recepción."
- Address the user directly with *tú* imperatives (*no apagues*, *espera*); errors from the app are impersonal ("No se
  pudo guardar").
- Firmware loading, transmit limits, heat, licence and the restricted-mode PIN get a **second pass** and are marked in
  the back-check.
- Legal statements stay neutral. Spanish or Latin American rules (CNMC/Ministerio, IFT, ENACOM, SUBTEL …) are not
  mentioned unless the English says something country-specific. The app's US-specific text (FCC, MURS, GMRS) stays a
  statement about the US: "En EE. UU. …".

## 9. Plurals and placeholders
- Spanish plural categories in Android (CLDR): `one`, `many`, `other`. Fill `one` ("1 canal") and `other`
  ("3 canales"); `many` is only used for millions ("1 000 000 de canales") and may repeat `other`.
- Watch agreement: adjectives and participles agree with the noun ("2 imágenes guardadas", "1 canal eliminado").
  Where a placeholder's gender is unknown, rephrase so nothing agrees with it: "Eliminado: %1$s" becomes
  "Se eliminó %1$s".
- Placeholders may move anywhere in the sentence (`%1$s`, `%2$d`), and every one in the English must appear exactly
  once. Never split a sentence across two strings.
- "de" between number and unit only for spelled-out quantities ("un millón de"); never "5 de W".

## 10. What stays English
- Logs, diagnostics, the device and bench reports, file formats, protocol words, anything transmitted, the exam
  questions (`research.md` §3, §7).
- Product, mode and service names: SignalDeck, Android Auto, FM, DMR, M17, APRS, SSTV, FT8, Winlink, POCSAG, MURS,
  GMRS, BrandMeister, and channel preset names.
- The intercom key legends (§7). Captions and keyword alerts stay English speech recognition (the Vosk model is
  `en-us`); the guide says so.
