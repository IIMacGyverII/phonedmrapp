# SignalDeck translations: research, approach and work breakdown

Translation agent, 2026-10-30. **Research only:** no SignalDeck code changed, no branch or PR, no phone touched (owner's
narrowed scope, relayed by the managing agent). Surveyed `origin/main` at `5ab5ae71` (beta.23 candidate). Read with
`docs/plan-translations.md` (the plan) and `docs/translations/overnight-brief.md`. German drafts: `de/glossary.md`,
`de/style.md`.

## 1. Summary

- **Size.** About **4,000–4,500 user-facing strings, roughly 60,000 English words**, for each language:
  - app UI: ~25,000 words;
  - the guide (`HelpView.TOPICS`): **~31,700 words**, the biggest single piece;
  - SignalDeck Web: ~8,000 words.

  The guide alone is the length of a short novel. Native review no longer gates a release (owner, §7), so it does not
  set the pace.
- **Text from outside the app** adds ~6,000 words per language:
  - radio notes (`radios.json`): ~3,100;
  - regions (`regions.json`): ~3,000 of its ~5,500;
  - the signed advisory and firmware lists: small today.

  The proposal is per-language overlays for the bundled files and an `i18n` field for the signed lists (§4.9). The exam
  pools (~51,000 words) stay English.
- **About 1,000–1,100 sentences are built in code** (concatenation, `String.format` with units, history and
  notification lines). The guard is an inverse literal scan with a ratchet, plus a runtime audit in the pseudo-locale
  (§4.10).
- **Every string is inline in Java** today (`res/values/strings.xml` holds one string). The UI is built in code with the
  `Neo` helpers, so extraction means editing call sites across ~150 files, not moving layout XML.
- **Extraction is not one night of work.** Infrastructure, guards and the guide format fit one night. Extracting ~4,000
  strings (about 1,000 of them sentences assembled in code, 95 hand-made plurals) and checking that English is unchanged
  is **about six to seven agent-nights**, split per screen group (§6).
- **Three design problems need solving before extraction, not during it:**
  1. history lines are stored in the database as finished English text, and code parses them back;
  2. a sheet's icon is chosen by matching words in its English title;
  3. the guide names screens and buttons in prose ("Device → Radio settings → New intercom look"), and must keep
     matching the translated labels.

  Each is described with a fix in §4.
- **The biggest risk is branch conflicts:** 18 open PRs and ~25 worktrees. The plan already says extraction must run when
  no branches are open; §5.1 gives three ways to manage that.
- **Fonts are fine for the first wave:** Rajdhani and Share Tech Mono cover every German, Spanish, French, Portuguese and
  Italian letter. Orbitron (titles) lacks „ « ». Japanese falls back to the system font (§5.4).

## 2. Inventory

Counted with a heuristic scan of every string literal in `app/src/main/java` (sorted by the call it is passed to;
logs, preference keys, JSON keys, SQL, shell commands and regexes left out). The counts overstate a little: the
"unknown" sink class still holds some non-UI text. Treat them as ±20 %.

| Group | Literals | Words | Main files |
|---|---:|---:|---|
| Guide | 624 | 31,700 | `ui/HelpView.java` (34 topics, 256 sections, 143 menu paths with →) |
| Channel editor + field info | 208 | 1,660 | `ui/ChannelEditorView.java` (30 `H_*` texts), `ui/ContactEditor.java` |
| Intercom, Last heard, zones, VFO | 433 | 2,310 | `IntercomView`, `LastHeardDialog`, `ChannelHistoryDialog`, `VfoDialog`, `ZonesDialog`, `ScheduleDialog`, `NetDialog`, `EmergencyDialog` |
| Channels, import, backup, presets | 820 | 3,540 | `ChannelsView`, `CodeplugDialog`, `RepeatersDialog`, `RegionSheet`, `NetsDialog`, `ChannelPresets`, `ham/BandPlan`, `Backup`, `ChannelStore`, `ham/NetFinder` |
| Device page, diagnostics, firmware, first run | 1,116 | 7,540 | `DeviceView` (519 alone), `DiagnosticsView`, `FirmwareScreen`, `TxTestScreen`, `FirstRunCheck`, `CustomPttKey`, `Updater`, `fw/*` |
| Packet, APRS, messages, map | 1,006 | 4,590 | `PktDialog`, `AprsScreen`, `MessagesView`, `MapDialog`, `PacketEngine`, `pkt/*` |
| Other modes and tools | 987 | 4,770 | `FoxHuntDialog`, `WinlinkDialog`, `FormsDialog`, `SstvScreen`, `Ft8Screen`, `M17Screen`, `BandScopeScreen`, `SatelliteDialog`, `PotaDialog`, `LogbookDialog`, `ConditionsDialog`, `ExamDialog`, `ham/*` |
| Service: history, toasts, notifications | 597 | 2,760 | `RadioService` (418), `NetWatch`, `Scheduler`, `CarMessages`, `coverage/*`, `MainActivity`, `RadioWidget`, `About` |
| Android Auto | 66 | 370 | `car/*` |
| Web server replies | 353 | 1,470 | `web/WebHost.java` (`ok("…")`, errors shown in the browser) |
| Web pages | ~1,330 | ~8,600 | `assets/web/index.html` (~1,450 words, 75 `title`/`placeholder`), `pages.js`, `app.js`, `editor.js`, `exam.js`, `talk.js`, `morse.js` |
| Reports and bench | 1,013 | 6,400 | `DeviceReport`, `TxReport`, `DmrAudioCheck`, `TxTestSession`, `RadioProbe`, `DraftProfile`, `AgoldUsb`, `SecondRadioTest` (**recommend: stays English**, §3) |
| Smaller files | 520 | 2,530 | `RecordingsDialog`, `MorseTrainerDialog`, `KeyerDialog`, `ActivityDialog`, `PagerScreen`, `TerminalDialog`, `MediaDialogs`, … |

Other counts that size the extraction work:
- **~1,570 UI call sites** take a literal (`setText`, `Neo.button/label/sheetHint/sheetSection/sheetBody/switchRow`,
  `setTitle/setMessage`, `toast`, `history`, `host.event` …). **~500 of them build the sentence by concatenation**, and
  each becomes one format string with numbered arguments.
- **95 hand-made plurals** (`n == 1 ? "…" : "…"`) become `<plurals>`.
- Manifest labels: app `SignalDeck` (stays), activities "Set channel location" and "Import channels", the car service
  "Radio controls", the widget "Radio"; the widget layout `res/layout/widget_radio.xml`.
- Notifications are built in `RadioService`, `NetWatch`, `CarMessages` and `car/AutoTrust`.

## 3. What stays English (beyond plan §1)

Plan §1 lists code, logs, DIAG, `report.json`, file formats and anything on the air. The survey adds:
- **The device report and the bench reports** (`DeviceReport`, `TxReport`, `DmrAudioCheck`, `00_SUMMARY.txt`, the
  transmit-test session): they are written for the developer reading them, and one language there makes reports
  comparable. **Suggested:** these stay English, and the Device page's buttons and explanations around them are
  translated. (Owner question 3.)
- **Exam practice question pools:** the NCVEC/FCC pools are the US exam, which is held in English. The exam screen's own
  buttons and scores are translated; the questions stay as published. The guide topic says so.
- **Live captions:** the Vosk models are `en-us` only, so captions and keyword alerts stay English speech recognition.
  Other models are a separate feature, not part of translation.
- **Voice reply** (`ham/VoiceReply`, TTS with `Locale.US`) is **transmitted**, so it stays as it is (on-air content).
  The local spoken announcements in `RadioService` (TTS, also `Locale.US`) could follow the app language later; they are
  not in this project.
- **Proper names stay:** channel preset and service names (`MURS 3`, `GMRS`, `Blue Star`, `UHF CB`), satellite names,
  band-plan segment names that are standards, mode names (FM, DMR, M17, APRS, SSTV, FT8, POCSAG, Winlink), and units.
  The descriptions next to them are translated.
- **APRS/AX.25 strings** (`ack`, `rej`, paths like `WIDE1-1`), Winlink forms content and the CSV headers in `Backup`
  stay as they are.

## 4. Extraction approach

### 4.1 One text accessor for code that has no Activity
Much of the user-facing text comes from classes without an Activity (`RadioService` history lines and toasts,
`PacketEngine` events, `ChannelStore`, `car/*`, notifications, `WebHost`). Add one small class (e.g. `ui/Txt`):
- holds a `Context` built with `createConfigurationContext` for the chosen locale;
- rebuilt when the language changes;
- has `Txt.s(R.string.x, args…)` and `Txt.p(R.plurals.x, n, args…)`.

Activities and views use the same calls, so there is one path. This also fixes the per-app-language gap below.

### 4.2 Language choice
- `MainActivity` is an `AppCompatActivity` and the app already has appcompat 1.6.1, so
  `AppCompatDelegate.setApplicationLocales` gives a per-app language with a restart-free switch, and the system language
  setting on Android 13+.
- **On Android 10–12** (`minSdk` 29; several bench phones), appcompat applies the locale only to activities. Service text,
  notifications, the widget and Android Auto would stay in the phone's language. The `Txt` context covers them.
  - Needs `AppLocalesMetadataHolderService` with `autoStoreLocales` in the manifest.
  - Needs `res/xml/locales_config.xml` for Android 13's per-app language list.
- **Device → Language:** "Phone's language" plus each shipped language, written in its own language ("Deutsch",
  "Español" …). This follows the plan's suggested answer of both.

### 4.3 Resource naming and context notes
- `strings.xml` split by screen group (`strings_intercom.xml`, `strings_device.xml` …): fewer merge conflicts between
  PRs, and a translator works one screen at a time.
- Names are `<screen>_<purpose>`, e.g. `intercom_scan_on`, `device_takeover_failed`.
- Each string gets a comment above it with the context note and a maximum length, for the translator:
  `<!-- Intercom key label, ≤ 7 chars, all caps on screen -->`.
- Arguments are numbered (`%1$s`, `%2$d`), and plurals go in `<plurals>`.
- Text that must not be translated gets `translatable="false"` (or stays in code as a constant).

### 4.4 The three structural problems

1. **History lines are stored as finished text and parsed back.**
   - Today `RadioService.history(kind, text)` writes the English sentence into `history.text`
     (`ChannelStore.addHistory`). `LastHeardDialog.explain()` then finds the explanation with `t.contains("Channel busy")`,
     `"receive-only"`, `"30 s transmit limit"` and nine others. `isAlert` and the Web page test the leading `⛔`/`⚠`.
   - Translating the sentence as it is written would:
     - freeze old lines in whichever language was active;
     - break every `contains()` match.
   - **Fix:** store an event key and its arguments next to the text: new columns `key`, `args` (JSON). The current
     English text is still written to `text` for logs, old builds and exports.
     - The screens render `key`/`args` in the current language, and old rows with no key show their stored English.
     - `explain()` switches on the key.
   - This is the one schema change, and it should be its own PR, first.
2. **`Neo.iconFor(title)` picks a sheet's icon from words in its English title** (`"repeater"`, `"record"`,
   `"weather"`, `"setting"` …). Translated titles would all fall back to the radio icon. **Fix:** pass the icon name to
   `Neo.sheetBody` explicitly (53 call sites), as `Neo.button` already does.
3. **The guide names the UI in prose.** 143 menu paths (`Device → Radio settings → Intercom layout`) and many button
   names (Take over, Use, Make scan priority).
   - A translated guide that writes these by hand drifts from the screens the first time a label changes.
   - **Fix:** the guide references labels by string name, e.g. `{@device_radio_settings} → {@device_intercom_layout}`,
     resolved when the guide loads. The guide then always shows the label the screen shows, in every language,
     including English.

### 4.5 The guide resource
- **Format:** one JSON file per language, `assets/guide/<lang>.json`, with topics, sections and stable ids
  (`{"id": "getting-started", "group": "start", "icon": "radio", "accent": "cyan", "title": …, "summary": …,
  "sections": [{"id": "take-over", "head": …, "text": …}]}`).
  - JSON rather than XML because the website export and SignalDeck Web (`HelpView.topicsForWeb`) read it directly.
- **Fallback:** a missing topic or section falls back to English by id.
- **The export and its test have to move with it:**
  - `HelpExportTest` parses `HelpView.java`'s source text today, and its slugs come from the English titles.
  - Both must read the English JSON instead, with slugs from the ids, so the website URLs stay the same.
  - A translated guide can then be exported per language (`docs/help/de/…`) when one ships.
- **The CLAUDE.md help rule** ("update `HelpView.java` TOPICS in the same change") then points at
  `assets/guide/en.json`. That is part of the plan §3.8 rule change to propose to the managing agent.
- **`ChannelEditorView` `H_*`:** the 30 field texts go in `strings_channel_editor.xml` (they are short and tied to one
  screen), not the guide file.

### 4.6 SignalDeck Web
- **Pages:** `assets/web/i18n/<lang>.json`, a flat key → text table. HTML elements get `data-i18n="key"` (and
  `data-i18n-title`, `data-i18n-placeholder`). JS uses `t('key', {n: 3})` with named placeholders.
  - The language comes from `navigator.languages`, with the app's setting as the default the server sends.
  - `<html lang>` is set to match.
- **Server replies** (`WebHost` `ok("Deleted")`, errors): rendered with `Txt` in the request's language
  (`Accept-Language`, or the app's choice).
  - The pages never match on reply text (checked: no JS compares a reply message), so these can be translated safely.
- **The guide on the Web page** comes from the same guide JSON.

### 4.7 Numbers, dates, case
- **Numbers:** 423 of 471 `String.format` calls pass `Locale.US`. The 48 without a locale are all `Log.d` lines (checked),
  so nothing user-facing changes by accident.
  - German style writes `467,625 MHz` (plan §4). Showing that is a deliberate change: frequencies go through one
    `Txt.freq(hz)` helper.
  - Every frequency, offset and step entry field then has to accept both `,` and `.` (71 `parseDouble/parseFloat` sites
    to review).
  - Decided (§7.5): German shows the comma everywhere on screen, and entry fields accept both; reviewer to confirm.
- **Dates:** times are `HH:mm` (fine everywhere). The ~10 formats with day and month names (`"EEE d MMM, HH:mm"`) use
  `Locale.US` and must take the app's locale.
- **Upper case:** `Neo.caps/title/chip` uppercase with `Locale.US`. For German that is right (ß → SS). Turkish would need
  the app locale, but it is not planned, so no change is needed in the first wave.

### 4.8 Pseudo-localisation
- Android has it built in: `pseudoLocalesEnabled true` on the debug build type gives **en-XA** (accented, ~30–40 %
  longer, bracketed) and **ar-XB** (right-to-left).
  - It works only on strings already in resources. Any English left on an en-XA screen is a string not yet extracted,
    which makes it the extraction check as well as the layout check.
- Web: a `?lang=pseudo` table generated from `en.json` by a script.

### 4.9 Text that arrives from outside the app
These files cannot go in `strings.xml`. They are data, maintained by other agents, read by the website, or signed and
downloaded.

| Source | Where it is shown | Prose today | How it is kept up to date |
|---|---|---|---|
| Advisories in `profiles/profiles.json` (`title`, `why`) | Device, transmit refusal | none published now (0 profiles, 0 advisories on `main`); short when there are | signed (`sign_profiles.py`), downloaded, `serial` bump; builds ≤ beta.11 read phonedmrapp's copy |
| Firmware catalogue `catalog/firmware.json` (AndroidRadio_Firmware_Project): `summary`, `changes`, variant `notes` | Device → Module firmware | ~70 words | signed (`sign_catalog.py`), downloaded |
| Radio notes `assets/radios/radios.json` (`summary`, `note`, `text`, `title`, `what` …) | Device → About this radio; exported to `docs/radios` and the website by `RadioNotesExportTest` | 221 strings, ~3,100 words | bundled, edited by hand |
| Regions `assets/regions/regions.json` (`title`, `notes`, `service`) | Region sheet, presets | 386 strings, ~5,500 words | bundled |
| Exam pools `assets/exam/*.json` | Exam practice | ~51,000 words | NCVEC public domain |

**Proposal:**
- **Signed, downloaded lists (advisories, firmware catalogue): an optional `i18n` object inside each entry,** e.g.
  `"i18n": {"de": {"title": "…", "why": "…"}}`. The app picks the app language and falls back to the English fields.
  - **Backward compatible:** `ProfileRegistry` and `FirmwareCatalog` read with `optString`, so older builds ignore the new
    field. The signature covers the whole file, so the only change is to re-sign with `sign_profiles.py` /
    `sign_catalog.py` as usual and bump `serial`.
    - Advisories must also go into phonedmrapp's copy, for builds up to beta.11.
  - Inline rather than a separate file: the list has to stay one signed unit, and an advisory and its translations are
    published together.
  - **Safety rule:** advisories and firmware-loader text are safety text. A **new advisory is never held back waiting for
    a translation:** it goes out in English, and translations are added in a later serial once back-checked.
  - When a translation is shown, the Device page shows the English original under it (one tap), because a stale
    translation of a transmit restriction is worse than none.
- **Bundled, hand-edited data (radio notes, regions): a per-language overlay file,** `radios.<lang>.json` and
  `regions.<lang>.json`, holding only translated text, keyed by entry id and field path, merged over English at load.
  - The English file stays the single source and stays English-only, so the agents who edit radio notes keep editing one
    file, and the website export is unchanged.
  - The key test (§4.11) reports overlay entries whose English source changed or disappeared, which marks them as
    needing translation.
  - Region `title`s that are standard names (service and band names) are marked not translated, so only `notes` and the
    descriptive titles are translated (~3,000 of the 5,500 words).
- **Exam pools stay English** (§3).

This adds ~6,000 words per language (radio notes + regions) to §1's 60,000.

### 4.10 Text built in code
Much of the text is not a single literal handed to `setText`. Counted on `origin/main` (outside log, SQL, shell, JSON
and preference lines; ±20 %):

| Pattern | Count | Example |
|---|---:|---|
| Concatenated sentences with prose on both sides | ~1,150 lines (≈510 in `ui/`, `car/`, `web/`; the rest in `RadioService`, `PacketEngine`, `coverage/`, reports) | `host.event("📶 Keyed " + ch.name + " from here (tail " + best + " dBm, " + …)` |
| `String.format` with units or words | ~400 (about half in reports and bench text that stay English) | `String.format(Locale.US, "%.3f MHz", f)` |
| `StringBuilder.append` chains with prose | ~170 (mostly detail sheets and reports) | `r.append("  TG list ")…` |
| `history(…)` calls | 126 | `history("rx", "📻 Received " + s + " s")` |
| `event("…")` calls (packet, coverage) | 47 | |
| Toasts | 296 | |
| Hand-made plurals | 95 | `n == 1 ? "channel" : "channels"` |
| Notifications | ~15 builders | `setContentTitle("Ch " + n + " · " + name)` |

**Estimate:** about **1,000–1,100 sentences assembled in code** that become one format string each, with the values as
numbered arguments. Units go inside the string (`%1$s MHz`); numbers are formatted by `Txt` helpers (`Txt.freq`,
`Txt.db`, `Txt.secs`). That is roughly twice the 500 counted on the UI call lines alone, and §6's totals include it.

**How the guard catches it** (a plain `setText("…")` scan would miss all of the above):
1. **Inverse literal scan (the main guard).** In the user-facing code (every package except `dsp/`, `pkt/` decoders,
   `fw/` protocol and the reports), the test flags **every string literal that contains a word**, wherever it flows.
   The exceptions:
   - literals passed straight to a known non-UI sink (`Log.*`, `log(`, preference and JSON keys, SQL, `Intent` actions,
     regex, shell, `report.json` writers);
   - constants marked `// i18n: not translated` (mode names, protocol words);
   - an allow-list of units and symbols.

   The literal itself is flagged, so a sentence built from `"Keyed " + name + " from here"` fails the test on `"Keyed "`.
   So does a `String.format("%.3f MHz", f)` pattern, an `append("TG list")` and a string stored in a variable and shown
   later.
   - During migration it is a **ratchet**: a baseline file holds today's count per file, and the test fails if any count
     goes up (so a new English literal fails CI at once). Each extraction PR lowers its files' baselines to zero.
2. **No fragments.** The scan also fails on `Txt.s(…) + …`, `+ Txt.s(…)` and `append(Txt.s(…))` next to more text, so
   translated pieces cannot be glued back into a sentence. Lists use a resource separator (`Txt.join`).
3. **History, events and notifications by key.** History lines go through `Txt` with a key (§4.4), so a host test can
   render **every history key** with sample arguments in each language and in en-XA. It fails on a missing argument, an
   unused argument, or plain English left over. The same goes for toast, notification and Web-reply keys.
4. **Runtime audit in the pseudo-locale.** A debug-only hook walks the view tree of each screen, sheet and dialog in
   en-XA (and the Web pages with a `?lang=pseudo` check in the browser). It lists every visible text that holds a run of
   plain ASCII letters outside the pseudo-locale's `[…]` brackets and outside argument values. That catches text built at
   run time that no static scan sees, such as text from data files or a missed `String.valueOf` path. The output is the
   checklist for the en-XA screen pass (§6 step 12).

### 4.11 Guards (host tests)
1. **No English literal left in user-facing code:** the inverse scan and ratchet of §4.10.1, and the fragment rule of
   §4.10.2.
2. **Same keys and placeholders in every language:** `values-*/strings*.xml`, `guide/*.json`, `web/i18n/*.json`, compared
   with English (missing keys allowed while a language is a draft, but never a key English lacks, never a different
   placeholder set). The same check covers the radio-notes and region overlays and the `i18n` objects in the signed lists.
3. **Every `{@name}` in the guide resolves** to an existing string.
4. **Plurals have the quantity forms the language needs** (`one`/`other` for the first wave; Japanese only `other`).
5. **Every history, toast, notification and Web-reply key renders** in every language with sample arguments
   (§4.10.3).

## 5. Risks

### 5.1 Conflicts with open branches (high)
- Today: **18 open PRs** (#104, 94, 78, 76, 74, 73, 72, 71, 70, 64, 63, 61, 29, 28, 27, 26, 25, 14) and ~25 worktrees.
  Restricted mode (#26), POCSAG (#25, #27), band guards (#104), the Device-report series (#61–71) and the Atom XL series
  all add or change UI text in the same files extraction rewrites. `DeviceView`, `RadioService`, `PktDialog` and
  `WebHost` are hot spots.
- Every extraction PR conflicts with every branch that touches its files. Each conflict is semantic: the other branch's
  new English literal has to be extracted too, not just merged.
- **Options:**
  1. **Freeze:** after beta.23, merge or park the open PRs, then extract with nothing open. This is what the plan
     describes. Fastest and cleanest, but SignalDeck development stops for the extraction nights.
  2. **Rolling, per screen group:** one small extraction PR at a time (~300–600 strings), merged within a day, starting
     with groups no open branch touches (Android Auto, guide, tools dialogs). Other agents keep working and merge main
     often. Slower, with some conflict churn.
  3. **Infrastructure first, then extract new code as it is written:** land `Txt`, the resources and guards with the
     guard in warn-only mode, and require new strings to be extracted from then on. Then work through the backlog
     group by group. Least disruption, but the longest time to a German build.
- **Recommendation:** option 1 for the history schema change, `Txt` and the guide move (they touch central files), then
  option 2 for the screen groups.

### 5.2 History and other parsed text (high, solved by §4.4)
- If missed, translated history lines stop matching `LastHeardDialog.explain()` and the alert filters, so Alerts would
  show no explanations.
- Smaller cases: `FirmwareScreen` matches `msg.startsWith("Firmware catalogue")` on an error message, and
  `ChannelHistoryDialog`, `WinlinkDialog`, `ActivityStats` and `DmrAudioCheck` each have one or two `contains("…")` on
  text. All must switch to codes or keys.

### 5.3 Layout (medium)
- German runs ~30 % longer.
- **Tight places:**
  - the six intercom buttons (66 × 44 dp on the compact layout);
  - `Neo.chip` and `Neo.title`, which are single line with ellipsis;
  - the header subtitle (`fitSubtitle`);
  - the Android Auto rows;
  - the widget.
- **What helps:** `Neo.fit` already shrinks button labels to 10 sp instead of splitting words. German compounds
  (*Sendeleistungseinstellung*) are long single words, so `fit` shrinks them rather than wrapping, and the glossary
  prefers short forms. The compact intercom layout on 480 × 854 phones is the hardest case and is checked first.
- **Intercom key labels** (SCAN, ZONE, TXT, SOFT SQ, MON, the six buttons): the German glossary suggests keeping SCAN
  and ZONE as key legends, as German radios do. Decided (§7.6): the key legends stay English.

### 5.4 Fonts (low for wave 1, medium for Japanese)
- Rajdhani and Share Tech Mono have every letter for de/es/fr/pt-BR/it.
- Orbitron (titles, upper-cased) lacks `„` and `«»`: titles must not contain quotes (the style guides say so).
- Japanese has no glyphs in any bundled font, so Android falls back to Noto Sans CJK: a different weight beside
  Rajdhani, and the letter spacing of `caps` (0.18 em) looks wrong in CJK. For `ja`, the tracking needs to drop to 0 and
  the size to be checked. Japanese also needs line-break checks (no spaces), which `Neo.fit`'s word count does not
  handle.

### 5.5 Review effort (settled by the owner: review is not a gate)
- ~60,000 words per language, more than half of it the guide. A careful native reviewer manages perhaps 1,500–2,500
  words an hour on a technical text, so **25–40 hours per language**, before the in-context screen review.
- **Owner, 2026-10-30:** a language ships once it is translated, back-checked and screen-checked. Native review improves
  it afterwards, as plain-file PRs, so a volunteer can review one screen or one guide topic at a time.
- What that puts on the agent: the back-check and screen check are the quality gate, so they have to be thorough,
  especially for safety text (plan §4: a safety string with a back-check that is not clean stays English until fixed).
- Each language's README keeps a list of what a native ham has reviewed, so users and later reviewers can see it.

### 5.6 Ongoing cost for the other agents (medium)
- After extraction, every change with UI text edits `strings*.xml` instead of a literal, and every help change edits
  `guide/en.json`.
- Other languages must be marked as needing translation (plan §3.8). The simplest mechanism is a per-language
  `untranslated.txt` written by the key test, rather than hand-marking.
- The CLAUDE.md/GROK.md rule must say this, and the guard test enforces it.

### 5.7 Smaller items
- The website (`SignalDeckRadio.com`) reads `docs/help`; its slugs must stay stable (§4.5).
- **Accessibility:** `Neo.iconButton(…, description)` passes content descriptions as literals (TalkBack reads them).
  They are in scope.
- `ChannelPresets` and `RegionSheet` hold region-specific text (US services). Translating the description of a
  US-only service is fine, but the guide should not imply German operators may use MURS/GMRS.
  - German users need EU presets (PMR446, Freenet), which are a feature request, not a translation.

## 6. Work breakdown and effort

Agent effort is wall-clock time for one agent, including building and host tests. The device check is the in-context
screenshot pass on the Atom XL (UI only, by lease).

| # | Step | Size | Agent effort | Device check | Conflicts with |
|---|---|---|---|---|---|
| 0 | `Txt` accessor, language setting in Device, locale config, pseudo-locale build, guard tests (warn-only) | ~10 files | 3–4 h | 1 h | `DeviceView`, manifest |
| 1 | History key/args schema + `LastHeardDialog.explain()` on keys + `Neo.sheetBody` icon parameter | `RadioService`, `ChannelStore`, `LastHeardDialog`, 53 sheet sites | 4–5 h | 1 h | nearly everything (do in the freeze) |
| 2 | Guide to `assets/guide/en.json` with `{@label}` references; `HelpView`, `topicsForWeb`, `HelpExportTest` read it | 31,700 words moved by script | 3–4 h | 1 h (all 34 topics) | any branch editing the guide |
| 3 | Intercom, Last heard, zones, VFO, schedule, nets, emergency | ~430 strings | 4 h | 1 h | #104, #74, #26 |
| 4 | Channels, editor + `H_*`, contacts, import, backup, presets, repeaters, region | ~1,030 strings | 7–8 h | 1.5 h | #104, #61 |
| 5 | Device page, diagnostics, firmware, transmit test screen, first run, PTT key, updater | ~1,120 strings | 8 h | 1.5 h | #26, #28, #61–71, #76 |
| 6 | Packet, APRS, messages, map | ~1,000 strings | 6–7 h | 1 h | #63, #25 |
| 7 | Other modes and tools (fox, Winlink, forms, SSTV, FT8, M17, scope, satellites, POTA, log, conditions, exam, recordings, Morse, keyer, pager, terminal) | ~1,500 strings | 8–9 h | 2 h | #25, #27, #14 |
| 8 | Service text: history lines, toasts, notifications, widget, Android Auto | ~660 strings | 5 h | 1 h (car screens by DHU, if available) | `RadioService` everything |
| 9 | SignalDeck Web: i18n table, `data-i18n`, `t()`, server replies | ~1,700 strings | 6–7 h | 1 h (browser) | #27, #25 |
| 10 | Radio-notes and region overlays; `i18n` field read in `ProfileRegistry` and `FirmwareCatalog` (schema only, no re-signing until a translation exists) | 4 files | 3 h | 0.5 h | radio-notes edits |
| 11 | Restructuring the ~1,000 sentences built in code (§4.10), spread over steps 3–9 and counted here once more because it is the slow part | — | +8–10 h | — | — |
| 12 | Guard to fail mode; en-XA runtime audit over every screen; English identical check | — | 3 h | 2 h | — |
| | **Extraction total** | ~4,300 strings | **~68–78 h, about 6–7 agent-nights** | ~15 h | |

Per language, once extraction is merged:

| Step | German | Each later Latin language | Japanese |
|---|---|---|---|
| Glossary + style guide | drafted tonight | 2 h | 3 h |
| Draft UI (~25k words) | 6–8 h | 6–8 h | 8–10 h |
| Draft guide (~32k words) | 6–8 h | 6–8 h | 8–10 h |
| Draft Web (~8k words) | 2 h | 2 h | 3 h |
| Back-check (independent pass) | 4 h | 4 h | 5 h |
| Screen check (every screen, Atom XL + browser) + fixes | 4–5 h | 3–4 h | 6–8 h (line breaks) |
| **Agent total** | **~25–30 h** | **~25 h** | **~35–40 h** |
| Native review (human, after shipping, not a gate) | 25–40 h | 25–40 h | 25–40 h |

Radio notes and regions add ~6,000 words per language: about 3 h of drafting and 3–4 h of review.

The credits page (plan §3.7: one screen for reviewers, testers and contributors, from a data file) is about 2 h. It
belongs with the Device/About group (step 5).

**Overall:** extraction ~6–7 nights, then about 3 nights per language for the agent. Because review is not a gate, a
language can reach a beta about 3 nights after the previous one; reviews then improve it at the reviewers' pace.

## 7. Decisions

Engineering questions decided by the managing agent; questions 2, 7 and 8 decided by the owner, both on 2026-10-30.
**Nothing starts until the owner says go.**

1. **Branches during extraction** (§5.1), managing agent: **freeze only for the central steps** (§6 steps 0–2: `Txt`
   accessor, history schema, guide move), then **one screen group at a time**. The freeze starts after beta.23 is
   published, and the managing agent schedules it with the translation agent.
2. **Review** (§5.5), owner: **a language ships once it is translated** (back-checked and screen-checked). Native
   review is **not a gate**: when a reviewer proposes changes, the translation is changed. The plan's §4–5 and the brief
   now say so.
3. **Reports stay English** (§3), managing agent: the device report, transmit-test report, audio check and bench
   summaries. Only the Device page's text around them is translated.
4. **History schema** (§4.4), managing agent: **yes.**
   - Add the `key`/`args` columns, and keep old rows as English text.
   - Backups and SignalDeck Web must round-trip both kinds of row (with a key and English-only).
   - Step 1 includes a **migration test** for this.
5. **Decimal comma** (§4.7), managing agent: German drafts **the comma everywhere on screen**, the large readout
   included (`467,625 MHz`). **Every frequency, offset and step entry field accepts both `,` and `.`** (the 71 parse
   sites in §4.7). It is marked "reviewer to confirm" in `de/style.md`, and the German reviewer has the final say.
6. **Intercom key legends**, managing agent: **SCAN, ZONE, TXT, SOFT SQ and MON stay English** in every language.
7. **Credit**, owner: **one credits page** for every contribution in one place (translators and reviewers, testers,
   contributors). Names or callsigns only with permission. Added to the plan as a screen (plan §3.7).
8. **Tooling**, owner: **plain files through GitHub PRs** for German. A hosted tool (Weblate) is decided if outside
   reviewers join. §4's formats work with both.

### The German tester
Contact goes **through the owner only**, never directly from an agent. The glossary questions for the tester are listed
in `de/README.md`, for the owner to forward.
