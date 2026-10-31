# Brazilian Portuguese style guide (pt-BR): DRAFT, awaiting native review

**Status: draft, awaiting native review.** The rules every pt-BR string follows, together with `glossary.md`. The
reviewer may change any rule; once agreed, the rules are fixed and the draft follows them.

**Variant: Brazil (pt-BR).** Brazilian spelling (Acordo Ortográfico 1990), vocabulary and grammar. Not European
Portuguese: *contato* not *contacto*, *salvar* not *guardar*, *baixar* not *transferir*, *tela* not *ecrã*,
*celular* not *telemóvel*, gerund *carregando* not *a carregar*.

## 1. Register: *você*
- Address the user as **você**, as Android pt-BR, Brazilian apps and Brazilian hams on the air do. *Tu* is regional
  and *o senhor / a senhora* is far too formal for a hobby app. **A reviewer may change it**, but there is no real
  alternative in Brazil.
- Imperatives in the *você* form (third person subjunctive), as Android pt-BR: "Toque em **Assumir**",
  "Mantenha a tecla PTT pressionada", "Informe seu indicativo". Never the *tu* imperative ("Toca", "Mantém").
- Possessives: "seu indicativo", "sua repetidora", without the article on short labels ("Seu indicativo"); "o seu"
  is fine in longer prose.
- Don't repeat *você* in every clause: Portuguese drops the subject once it is clear ("Toque em Salvar. Depois, escolha
  a zona."). Keep it in licence and safety warnings, where the subject must be unmistakable ("Você precisa de licença
  de radioamador…").
- **Gender-neutral address:** Portuguese adjectives and participles agree with the person. Avoid them when they
  refer to the user: not "Você está conectado(a)" but "Conexão estabelecida"; not "Bem-vindo" but "Boas-vindas";
  not "o usuário" but "você" or "quem transmite". Never "(a)" or "@" endings.

## 2. Tone
- **Write it the way a Brazilian ham explains it at the bancada or on the repetidora,** not as a translation. Restructure
  freely; Portuguese often puts the condition or purpose first.
  - EN: "Hold the large round key to talk; release it to listen."
  - Literal (avoid): "Segure a tecla redonda grande para falar; solte-a para ouvir."
  - Natural: "Para falar, mantenha pressionada a tecla redonda grande; para ouvir, é só soltar."
- **Short beats complete.** Portuguese runs ~20–30 % longer than English. In buttons and labels use the glossary's
  short form; in prose cut filler ("simplesmente", "por favor" only where the English is a request).
- **Ham words.** Use the words Brazilian hams use: *repetidora*, *roda*, *subtom*, *indicativo*, *carga fantasma*,
  *abrir a repetidora*, *QSO*, *QRV*. Keep the international terms the community keeps (PTT, CTCSS, squelch, color
  code, talkgroup, APRS, beacon). Don't invent Portuguese for terms Brazilian hams don't use, and don't keep English
  where a normal Portuguese word exists ("Configurações", not "Settings").
- Clitics: proclisis is natural in Brazil ("Isso se aplica a…", "Se você o remover…"); avoid European mesoclisis
  ("aplicar-se-á"). On buttons avoid pronouns altogether.

## 3. Labels and capitalisation
- **Sentence case** everywhere: only the first word and proper names are capitalised. "Configurações do rádio", not
  "Configurações Do Rádio". Months and weekdays are lower case ("outubro", "segunda-feira").
- **Buttons:** infinitive verb or a short noun ("Salvar", "Assumir", "Nova zona", "Concluído").
- **Section titles:** noun phrases ("Configurações do rádio", "Peculiaridades conhecidas").
- **All-caps labels** (`Neo.caps`, `Neo.title`, chips) are upper-cased by the app: write them in normal case. Accents
  stay in capitals ("SÓ RX", "TRANSMISSÃO"); check the title font renders Ã, Ç, Ê, Ó on the screen check.
- **Switch rows:** the label names the feature ("Squelch durante a varredura"), with no "Ativar".
- **Gender of the noun on chips and pills:** a choice agrees with what it qualifies: *potência* Alta/Baixa,
  *chamada* Privada, *imagem* Incluída. The glossary marks (m)/(f).

## 4. Punctuation and typography
- Quotes: “assim” (curly double). Nested: ‘assim’. No quote marks in titles.
- Dash: spaced en dash " – " for a pause; the hyphen for compounds (*palavra-chave*, *segunda-feira*) and clitics.
- Abbreviations before a noun don't take a hyphen in Portuguese: "canal DMR", "subtom CTCSS", "beacon APRS",
  "tecla PTT" (the noun comes first, unlike German or English).
- Ellipsis "…" on buttons that open a dialog, as in English. No space before it.
- No space before `:` `;` `!` `?` (unlike French).
- The arrow for menu paths stays: "Dispositivo → Configurações do rádio". These come from `{@label}` references,
  never typed by hand (`research.md` §4.4).
- Contractions and crase are mandatory and must survive placeholders: "no canal %1$s", "na zona %1$s",
  "à repetidora". If the gender of a placeholder is unknown, rephrase ("canal: %1$s", "zona %1$s").
- No exclamation marks, except in safety warnings where the English has one.

## 5. Numbers, units, dates
- **Decimal comma everywhere on screen** (as decided for German, 2026-10-30; **reviewer to confirm**): 12,5 kHz;
  467,625 MHz in prose, lists and the large frequency readout; CTCSS "67,0 Hz". Brazilian repeater lists already use
  the comma. Entry fields accept both `,` and `.`.
- Thousands: Brazil writes a dot ("1.200"), which a ham could read as a decimal in a frequency. Write frequencies and
  Hz values without a separator ("1200 Hz"); counts over 9 999 may use the dot ("12.500 QSOs").
- Always a space between number and unit: "30 s", "5 W", "−85 dBm". Real minus sign (−) for dBm. "%" without space
  only where the English has none ("50%").
- Time: 24 hours, "14:05" (and "21h" in net times in prose, the Brazilian ham habit: "roda às 21h").
- Date: "30/10/2026", or "30 de out." where short; weekdays "seg., ter., …"; first day of the week is Sunday.
- Ranges: "de 1 a 9" in prose, "1–9" on labels.
- Ordinals: "1º", "2ª" (masculine/feminine), only where the English has an ordinal.

## 6. Key legends on the intercom
- The intercom keys (**SCAN, ZONE, TXT, SOFT SQ, MON** and the six buttons) work like printed key legends on a radio.
  Radios sold in Brazil print them in English, so they **stay English** (decided 2026-10-30), and the guide says
  "Toque em SCAN".
- The text **around** them is translated: "SCAN faz a varredura dos canais da zona atual."
- Treat a legend as a masculine noun when an article is needed ("o SCAN", "o MON"), or avoid the article.

## 7. Warnings and safety text
- **As clear as the English.** Never soften: "não desligue", "não é permitido transmitir", "você precisa de licença de
  radioamador para transmitir". Imperative, not "recomenda-se".
- The negation goes early, where it cannot be missed: "**Não** desligue o celular durante a carga do firmware."
- Start with the consequence, then the reason: "Transmissão recusada: este canal é só de recepção."
- Firmware loading, transmit limits, heat, licence and the PIN de bloqueio get a **second pass** and are marked in the
  back-check.
- Legal statements stay neutral. Brazilian rules (Anatel, the Regulamento do Serviço de Radioamador) are not mentioned
  unless the English says something country-specific. The app's US-specific text (FCC, MURS, GMRS) stays a statement
  about the US: "Nos EUA …".

## 8. Plurals and placeholders
- Android/CLDR for Portuguese uses `one` and `other` (newer CLDR adds `many` for millions: give it the `other` text).
  **In Portuguese `one` covers 0 and 1** ("0 canal" would be chosen for zero): where zero can occur, use a separate
  "Nenhum canal" string or phrase the count so it reads well ("Canais: 0").
- Placeholders may move anywhere in the sentence (`%1$s`, `%2$d`); every one in the English appears exactly once. Never
  split a sentence across two strings: the article and preposition depend on what follows.

## 9. What stays English
- Logs, diagnostics, the device and bench reports, file formats, protocol words, anything transmitted, the exam
  questions, live captions (English speech models) (`research.md` §3, §7).
- Product, mode and service names: SignalDeck, Android Auto, FM, DMR, M17, APRS, SSTV, FT8, Winlink, POCSAG, POTA,
  SOTA, MURS, GMRS, NOAA.
- The intercom key legends (§6).
