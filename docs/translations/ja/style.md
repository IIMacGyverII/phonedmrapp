# Japanese style guide (ja): DRAFT, awaiting native review

**Status: draft, awaiting native review.** The rules every Japanese string follows, together with `glossary.md`. A
Japanese-speaking ham reviewer may change any rule; until then the draft follows these. Japanese is the second wave
(plan §2) because of the layout work in §5: read that section before translating any label.

## 1. Register: です/ます in sentences, plain forms on controls

**Decision (recommended): the polite です/ます style (丁寧語) for every sentence, plain forms for buttons and labels.**

- **Sentences** (guide, dialogs, toasts, info texts, warnings, notifications): end in です/ます.
  「SCAN をタップすると、現在のゾーンのチャンネルをスキャンします。」
- **Buttons, tabs, menu entries, switch labels, section titles:** a noun or a short dictionary-form verb, no です/ます,
  no 〜してください: 「保存」「削除」「閉じる」「スキャン開始」「無線設定」.
- **Status lines and badges:** noun forms, 〜中 for ongoing states: 「送信中」「受信専用」「エリア記録中」.
- **Requests:** 〜してください. Use it only where the English asks the user to do something; don't add it elsewhere.

**Why です/ます:**
1. It is the register of Android's own Japanese UI and of every Japanese radio maker's manual (Icom, Yaesu, Kenwood)
   and app. A user reads it as "normal software"; anything else stands out.
2. The plain form (だ/である) in UI text reads either as a technical specification or as curt. It is the register of
   documents, not of an app talking to a person.
3. Japanese ham talk on the air is friendly but courteous, and です/ます sits naturally there. The guide explains the
   radio "on the bench"; です/ます keeps that tone without being stiff.
4. **No honorific keigo** (尊敬語/謙譲語): no 「〜いただけます」「〜させていただきます」「お客様」. It sounds like a
   call centre. One exception: the request in the contribution screen may use 「ご協力ください」.

**Address:** don't write あなた (unnatural in Japanese UI). Leave the subject out, as Japanese does:
「先にコールサインを設定してください」. This is gender-neutral by default; no 彼/彼女 for the user, and
「アマチュア無線家」 has no gender. 「ユーザー」 only where the English contrasts users with something else.

## 2. Tone: write it as a Japanese ham would
- **Restructure freely.** Japanese puts the verb last and prefers the condition first ("〜すると", "〜の間は").
  - EN: "Hold the large round key to talk; release it to listen."
  - Literal (avoid): 「話すために大きな丸いキーを押し続け、聞くためにそれを離してください。」
  - Natural: 「大きな丸いキーを押している間は送信、離すと受信します。」
- **No pronouns copied from English** (それ、これ for "it"): repeat the noun or drop it.
- **Short beats complete.** Labels are measured in width, not characters (§5): use the glossary's short form.
- **Ham flavour where Japanese hams have their own word:** ロールコール (net), キー局 (net control), ワッチ (monitor),
  自局 (my station), 純正 (stock), 交信 (QSO), 運用 (operating). Don't invent Japanese for terms Japanese hams keep in
  English or katakana (PTT, CTCSS, VFO, トークグループ).

## 3. Script: kanji, katakana, half-width

### 3.1 Kanji or katakana
- **Use the word Japanese hams and radio manuals use**, whatever its script. The glossary decides per term.
  - Katakana loanwords where the community uses them: スケルチ, トーン, オフセット, レピーター, トークグループ,
    カラーコード, タイムスロット, ビーコン, バンドスコープ, ロールコール.
  - Kanji where the community uses kanji: 送信, 受信, 周波数, 出力, 無線機, 交信, 混信, 伝搬, 免許, 受信専用.
  - Legal or formal kanji terms (呼出符号, 中継局, 単信, 電波型式) only where the text is about law or licensing; the UI
    uses the everyday word (コールサイン, レピーター, シンプレックス, モード).
- **On tight labels prefer kanji compounds:** they carry more meaning per width (受信専用 = 4 glyphs; レシーブオンリー =
  8). Never replace a community katakana word by an invented kanji word to save space.
- **Katakana compounds** are written as one word, no space or 中黒 ・: トークグループ, スケルチレベル. Use ・ only
  between two separate foreign names (「Martin・Scottie」 is wrong; write 「Martin、Scottie」).

### 3.2 Long vowels
- **The modern rule (final ー written):** レピーター, メーター, タイマー, スキャナー, デコーダー, プレーヤー,
  ユーザー, フィルター. Android, Microsoft and current radio manuals write this way.
- ❓ JARL and older manuals drop the final ー on some words (レピータ局, Sメータ). If the reviewer prefers JARL's
  spelling, it changes for the whole app, never word by word.

### 3.3 Full-width and half-width
- **Half-width (ASCII):** digits, Latin letters, units, mode and service names, abbreviations, callsigns, placeholders'
  values: `467.625 MHz`, `FM`, `DMR`, `APRS`, `TG 91`, `PTT`, `CTCSS 88.5 Hz`. Never full-width Ｆ Ｍ or １２.
- **Full-width:** Japanese punctuation 、。「」『』（）：！？ and the wave dash 〜.
- **Half-width katakana (ｶﾀｶﾅ): never.**
- **Spacing:** one half-width space between Japanese and a run of Latin letters or digits, as Android's Japanese UI
  does: 「APRS ワッチ」「5 W」「30 秒」「SCAN をタップ」. No space next to full-width punctuation:
  「（TG）」「DMR、FM」. ❓ (Microsoft's Japanese style puts no space; Android's does. The space also gives the line
  breaker a sensible break point, §5.)
- **Placeholders:** a placeholder that holds Latin or digits (callsign, frequency, count) gets the space:
  「%1$s に送信しました。」; one that holds Japanese text does not.

## 4. Labels and capitalisation
- Japanese has no case. Write labels in their normal form; the app's upper-casing (`Neo.caps/title/chip`) does nothing
  to kana and kanji, and only upper-cases Latin letters inside them (fine: 「SQL レベル」).
- **Buttons:** a noun or a dictionary-form verb (§1). Prefer the Sino-Japanese noun on tight buttons (保存, 追加, 開始)
  over a verb phrase (保存する, 追加する).
- **Section titles:** noun phrases: 「無線設定」「既知の不具合」. No 「〜について」 except the About entry.
- **Switch rows:** the label names the feature: 「スキャン中のスケルチ」. No 「オンにする」.
- **No quote marks in titles** (titles are drawn in Orbitron, which falls back for Japanese; keep them plain).

## 5. Layout: fonts, tracking and line breaks

These rules exist because SignalDeck's look was built for Latin text. **The translator follows the "Translators"
rules; the "Code" list is for the translation agent** (who does the engineering for `ja`), not for the translator.

### 5.1 What happens on screen
- **No Japanese glyphs in the bundled fonts.** Rajdhani, Orbitron and Share Tech Mono have none, so Android draws every
  Japanese character in the system CJK font (Noto Sans CJK on most phones). Latin letters and digits in the same string
  stay in Rajdhani or Orbitron. The two fonts differ in weight and height; mixed strings look uneven.
- **Letter spacing.** `Neo.caps` uses 0.18 em tracking (`chip` 0.12, `title` and tab labels 0.08). Tracking between
  CJK glyphs looks broken, like 「無 線 設 定」.
- **Width.** A Japanese glyph is about as wide as two Latin letters at the same size. 「保存」 (2 glyphs) ≈ "Save"
  (4 letters); 「無線設定」 (4) ≈ "Radio set". Budget **one Japanese glyph = two English letters** against the
  English string's length.
- **Line breaks.** Japanese has no spaces, so a wrapped label can break between any two glyphs, even inside a word
  (「スケル / チ」). `Neo.fit` counts words by spaces: a Japanese label counts as one word, so it never wraps and shrinks
  down to 10 sp instead, too small for kanji.

### 5.2 Translators: keep labels short and on one line
1. **Every button, tab, chip, badge, pill and title is one line.** Aim for the English length in letters ÷ 2 in
   glyphs. Six-button intercom rows and four-button rows: **4 glyphs or fewer** (ASCII letters count half).
2. **When the label is too long, shorten in this order:**
   1. drop particles and verb endings: 「設定を保存する」 → 「保存」; 「スキャンを開始」 → 「スキャン開始」;
   2. drop what the screen already says: on the Zone screen, 「ゾーン名」 → 「名前」;
   3. use the Sino-Japanese compound: 「元に戻す」 → 「復元」; 「取り除く」 → 「除外」;
   4. use the glossary's abbreviation: TG, CC, TS, SQL, GL, PTT, RX/TX only where the glossary lists them;
   5. use the one-word form the glossary gives (「範囲外」 for NOT TUNABLE, 「除外」 for Out of zone);
   6. still too long: say so in the back-check file; never cut a word in the middle or invent an abbreviation.
3. **No spaces or line breaks added for layout.** Write the label as Japanese is written. The only spaces are the
   half-width/full-width ones from §3.3.
4. **Two-line labels** (only where the English one already wraps): make the natural break fall at the space from §3.3 or
   at a 文節 (phrase) boundary, and say in the context note where it should break. Never let a line start with
   、。」）ー or a small kana (っ ゃ ゅ ょ), or end with 「（.
5. **Don't put Japanese in places drawn with Share Tech Mono** (the frequency readout, digits): those strings are
   numbers and units only.

### 5.3 Code: what `ja` will need (translation agent's job, noted here only)
- **Tracking 0 for `ja`:** `Neo.caps`, `Neo.chip`, `Neo.title`, the tab labels in `MainActivity` and the other
  `setLetterSpacing` calls (`AprsScreen`, `ChannelsView`, `CarArt` …) set 0 when the text contains CJK (or the app
  language is `ja`).
- **Line breaking:** on Android 13+ (API 33), `setLineBreakWordStyle(LineBreakConfig.LINE_BREAK_WORD_STYLE_PHRASE)`
  breaks Japanese at phrase boundaries; minSdk is 29, so older phones fall back to glyph breaks with the usual kinsoku
  rules (ICU). `Neo.fit`'s word count (`split(" +")`) must not decide the line count for Japanese: measure by width, and
  allow two lines where the English label may wrap.
- **Minimum size:** `fit`'s 10 sp floor is too small for kanji; ~11–12 sp for `ja`, to be set on the screen check.
- **Glyph locale:** when the app language is `ja` but the phone's is not, set the text locale (`setTextLocale` or the
  configuration locale) to `ja-JP`, or the fallback can draw Chinese glyph shapes (Han unification).
- **Fallback font weight:** Rajdhani Bold beside Noto Sans CJK; check whether the CJK fallback needs a bold weight, and
  whether `setIncludeFontPadding(false)` clips CJK ascenders.

## 6. Punctuation and typography
- Full stop 。 and comma 、 (never ．or ，). 「…」 for quoted words and button names in prose; 『…』 nested.
- Button and screen names in prose: 「保存」をタップします. Key legends too: 「SCAN」を長押しします, or bare SCAN.
- Colon: full-width ： after Japanese; half-width in times and ASCII runs.
- Ellipsis …: one character, at the end of a button that opens a dialog, as in English.
- Ranges: 1〜9 (wave dash).
- The arrow for menu paths stays: 「デバイス → 無線設定 → 無線画面のレイアウト」, from `{@label}` references, never typed by
  hand (`research.md` §4.4).
- No ！, except in safety warnings where the English has "!".

## 7. Numbers, units, dates
- **Decimal point**, as English: 467.625 MHz, 12.5 kHz. Japan uses the point; nothing changes from English, and
  `Txt.freq` and the entry fields need no change for `ja`.
- Thousands: a comma (1,200 Hz) or none (1200 Hz), as English.
- A space between number and unit for SI units: 30 s, 5 W, −85 dBm (real minus). Japanese counters in sentences, with the
  §3.3 space: 「30 秒」「2 分」「3 件」「2 台」. ❓ On compact labels the SI symbol (30 s).
- Time: 24 hours, 14:05. Never 午前/午後.
- Date: 2026/10/31 for full dates; 10月31日 in prose; 10/31 where it is short; weekday in full-width brackets:
  10月31日（土）. Weekday letters 日 月 火 水 木 金 土. The Japanese era (令和) is not used.
- Arabic digits everywhere, also for counts in prose (「3 チャンネル」, not 「三チャンネル」).

## 8. Key legends on the intercom
- **SCAN, ZONE, TXT, SOFT SQ, MON** (and REC, VFO, PKT) stay English in every language (decided 2026-10-30). Japanese
  radios print English key legends too. The guide writes 「SCAN をタップします」.
- The text **around** them is translated: 「SCAN は現在のゾーンのチャンネルをスキャンします。」

## 9. Warnings and safety text
- **As clear as the English; never soften.** Use 「〜しないでください」「〜できません」「必ず〜してください」, and
  「絶対に」 where the English stresses it. No 「〜かもしれません」「〜したほうがよいでしょう」 for something the
  English states as a rule.
- **The negation comes last in Japanese**, so put the warning first: a headline noun or label before the sentence, so
  the reader sees it before the verb: 「送信不可：このチャンネルは受信専用です。」「警告：書き込み中は電源を切らないでください。」
- Consequence first, then the reason, as in English.
- Firmware loading: **「書き込み中は電源を絶対に切らないでください。」** in bold, never shortened.
- Firmware loading, transmit limits, heat, licence and the restricted-mode PIN get a **second pass** and are marked in the
  back-check (plan §4).

## 10. Law, licences and the exam
- **US rules stay statements about the US.** The app's FCC, MURS, GMRS and FRS text is written as US facts:
  「米国では、MURS は免許不要です。」 Never adapt it to Japan.
- **Japan's own licence-free radio exists** (特定小電力無線, the 420/440 MHz low-power transceivers; also デジタル簡易無線,
  the 351 MHz registered service). Translators should know this, because a Japanese reader may assume "licence-free"
  means those. **Do not add any Japanese regulation to the app text**; where an English sentence could be read as
  saying something is licence-free in Japan, keep 「米国では」 explicit.
- **Licences:** Japan has an operator licence (無線従事者免許) and a station licence (無線局免許). The app's licence notes
  mean "you must be licensed": write 「アマチュア無線の免許」 (glossary §6), not one of the two.
- **The exam practice is the US exam.** Japanese hams qualify through their own national exam (国家試験, run by the
  日本無線協会) or the JARD training course (養成課程), with different questions. The NCVEC/FCC question pools stay in
  English, as published; the exam screen's buttons and scores are translated, and the guide topic says plainly:
  「この問題集は米国のアマチュア無線試験（英語）のものです。日本の国家試験とは異なります。」

## 11. Plurals and placeholders
- Japanese has **only the `other` plural form**. Write `<item quantity="other">` only; the count is still shown with a
  counter: 「%1$d 件のメッセージ」「%1$d チャンネル」.
- No 〜たち or 〜ら plural markers for things.
- Word order is SOV, so placeholders move: always numbered (`%1$s`, `%2$d`), every one in the English exactly once. Never
  split a sentence across two strings.

## 12. What stays English
- Logs, diagnostics, the device and bench reports, file formats, protocol words, anything transmitted, the exam
  questions (`research.md` §3).
- Key legends (§8), product, mode and service names: SignalDeck, Android Auto, FM, DMR, M17, APRS, SSTV, FT8, Winlink,
  POCSAG, MURS, GMRS, NOAA; preset names (MURS 3, Blue Star).
- Units and their symbols: MHz, kHz, Hz, W, dBm, s, min (§7 for counters in prose).
- International ham shorthand: QSO, CQ, 73, QTH, QRV.
