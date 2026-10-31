# SignalDeck in Japanese (ja)

**Status: draft, awaiting native review.** Nothing here has been reviewed by a Japanese-speaking ham yet, and no Japanese
string exists in the app. Japanese is the second wave (plan §2). It ships once it is translated, back-checked and
screen-checked (owner, 2026-10-30); a native review then improves it, through plain-file PRs.

**Reviewed by a native-speaking ham:** nothing yet.

- `glossary.md`: the recurring terms and their Japanese rendering, for the reviewer to agree first.
- `style.md`: register (です/ます in sentences, plain forms on controls), kanji/katakana and half-width rules, the
  layout rules for labels (§5), numbers (decimal point, as English), key legends, safety text, and the US-only law and
  exam text.

The order of work, after the extraction (`../research.md` §6):
1. glossary and style guide, with a reviewer's answers if they come first;
2. **the `ja` layout code** (`style.md` §5.3: tracking 0, phrase line breaks, `Neo.fit` by width, the minimum size, the
   `ja-JP` text locale), checked with a few placeholder Japanese labels before the draft;
3. draft;
4. back-check;
5. screen check, with the extra Japanese items: CJK fallback beside Rajdhani and Orbitron, no tracking between glyphs,
   one-line labels in the six-button intercom rows on the 480 × 854 compact layout, no line starting with 、。」ー, and
   Japanese (not Chinese) glyph shapes when the phone's own language is not Japanese;
6. ship in a beta;
7. native review improves it afterwards.

## Questions for a native-speaking ham reviewer

Recruited through the Contribute page and GitHub Discussions; contact goes through the owner. These are the choices the
glossary can't settle without a Japanese ham. The proposed term is first; alternatives follow.

**English**
1. **Register:** です/ます in sentences and plain forms on buttons (proposed), or something else?
2. **The main page (English "Intercom"):** *無線*, *インターコム* or *交信*?
3. **Repeater:** *レピーター*, *レピータ* (JARL's spelling) or *中継局*? And generally: final ー (メーター, タイマー) or JARL's
   style without it?
4. **Callsign:** *コールサイン* everywhere, or *呼出符号* in the licence notes?
5. **Licence notes:** is 「この周波数で送信するには、アマチュア無線の免許が必要です。」 right, or should it name the
   operator or station licence?
6. **Net / net control / check-in:** *ロールコール* / *キー局* / *チェックイン*: OK?
7. **Monitoring** (APRS, pager): *ワッチ* or *受信* / *モニター*?
8. **Offset:** *オフセット* or *シフト*?
9. **Coverage** (logging and map): *エリア* (*エリア記録*, *エリアマップ*) or *カバレッジ*?
10. **Pager:** *ページャー* or *ポケベル*?
11. **Contacts:** *連絡先* (Android) or *コンタクト* (DMR radios)?
12. **Take over / hand back the radio:** *引き継ぐ* / *戻す*?
13. **Spacing:** a half-width space between Japanese and Latin or digits (「APRS ワッチ」「30 秒」, as Android does), or
    none (「APRSワッチ」「30秒」)?
14. **Talk key and key up:** *送信キー* and *アクセスする*, or *トークキー* / *キーアップ*?
15. **Weekday order:** Sunday first (日 月 火 …) or Monday first?

Already decided (the reviewer may still object): the intercom key legends **SCAN, ZONE, TXT, SOFT SQ, MON** stay
English, as on Japanese radios. Squelch is *スケルチ*, talkgroup *トークグループ (TG)*, colour code *カラーコード*, time slot
*タイムスロット*, stock *純正*, the exam practice is the US exam in English, numbers keep the decimal point.

**日本語**
1. **文体**：文章は です/ます、ボタンは体言止めや辞書形（案）。ほかの文体がよいでしょうか。
2. **メイン画面（英語では「Intercom」）**：「無線」「インターコム」「交信」のどれがよいですか。
3. **Repeater**：「レピーター」「レピータ」（JARL の表記）「中継局」のどれですか。また全般に、語末の長音（メーター、
   タイマー）を書くか、JARL のように省くか。
4. **Callsign**：すべて「コールサイン」でよいですか。免許に関する文では「呼出符号」にすべきですか。
5. **免許の注意文**：「この周波数で送信するには、アマチュア無線の免許が必要です。」でよいですか。従事者免許・局免許を
   書き分けるべきですか。
6. **Net**：「ロールコール」「キー局」「チェックイン」でよいですか。
7. **Monitoring（APRS、ページャー）**：「ワッチ」か「受信」「モニター」か。
8. **Offset**：「オフセット」か「シフト」か。
9. **Coverage（記録と地図）**：「エリア」（エリア記録、エリアマップ）か「カバレッジ」か。
10. **Pager**：「ページャー」か「ポケベル」か。
11. **Contacts**：「連絡先」（Android）か「コンタクト」（DMR 無線機）か。
12. **無線モジュールの Take over / Hand back**：「引き継ぐ」「戻す」でよいですか。
13. **スペース**：日本語と英数字の間に半角スペースを入れる（「APRS ワッチ」「30 秒」、Android と同じ）か、入れない
    （「APRSワッチ」「30秒」）か。
14. **送信キーとアクセス**：「送信キー」「アクセスする」か、「トークキー」「キーアップ」か。
15. **曜日の順**：日曜始まり（日 月 火 …）か月曜始まりか。

決定済み（ご意見は歓迎します）：無線画面のキー表示 **SCAN、ZONE、TXT、SOFT SQ、MON** は、日本の無線機と同じく英語のままです。
squelch は「スケルチ」、talkgroup は「トークグループ（TG）」、colour code は「カラーコード」、time slot は
「タイムスロット」、stock は「純正」。試験対策は米国の試験（英語）で、数値の小数点は「.」のままです。
