# SignalDeck translations: plan

Owner request 2026-10-28 (a tester asked for German first); scope set 2026-10-29. **Do it all in one go, at a later date, as an overnight project once the heavy firmware and Atom XL work is done. No half measures in the meantime.** The owner starts it.

## 1. Scope

- **Translate:** every piece of text the user can read: screen labels, buttons, menus, dialogs, toasts, notifications, history lines, warnings, Device-page and report text meant for the user, the in-app guide (`HelpView.TOPICS`), the per-field info texts (`ChannelEditorView` `H_*`), the SignalDeck Web pages (`assets/web/`), the Android Auto screens, and the launcher name if a language needs it.
- **Stay in English:** all code (identifiers, comments), logs and diagnostics (`log(...)`, logcat, bench and DIAG output), commit messages and PRs, developer docs, the device report's machine-readable `report.json`, protocol names and file formats (CSV headers, backup files, APRS/AX.25 fields, M17/DMR payloads), and anything sent on the air.
- **Radio terms:** keep the international ham terms most operators use in English (squelch, CTCSS, DCS, talkgroup, colour code, time slot, APRS, SSTV, FT8, VFO, PTT, S-meter), unless a language's ham community normally uses a native term; the glossary (§4) decides, per language.

## 2. Languages

English is the base. First wave, in this order: **German** (requested; the tester reviews), then **Spanish**, **French**, **Portuguese (Brazil)**, **Italian**. Second wave: **Japanese** (needs layout checks for width and line breaks). Later, on request: Polish, Dutch, Ukrainian/Russian. Each language ships only when it is complete and reviewed (§5); a missing string falls back to English, never to a raw key.

## 3. Engineering (one overnight project, then one language at a time)

1. **Extraction.** Move every user-facing string into `res/values/strings.xml` (named by screen and purpose, e.g. `intercom_scan_on`); plurals into `<plurals>`; sentences with values into format strings with numbered arguments (`%1$s`, `%2$d`) so a translator can reorder them. No sentence is built by concatenating fragments (word order differs between languages).
2. **The guide.** `HelpView.TOPICS` moves to one structured resource per language (a JSON or XML file of topics and sections), loaded at run time, so a translator works on one file and the website's guide export reads the same files.
3. **Web pages.** `assets/web/` strings into one JSON table per language, picked from the browser's language with the app's setting as the default.
4. **Language choice.** Follow the phone's language; an override in Device (the app's own list), applied without a restart where Android allows.
5. **Layout.** Every screen checked with the longest language (German runs about 30 % longer than English): no clipped buttons, no truncated neon digits or satellites, wrapping instead of overflow; pseudo-localisation build (accented, 40 % longer text) to catch this before any translation exists.
6. **Guards.** A host test fails on any user-facing string literal left in the UI code (lint rule or a scan of `setText("…")`, `toast("…")`, `history(…, "…")`); a test that every language file has the same keys and the same placeholders as English.
7. **Rule change.** After extraction, SignalDeck's CLAUDE.md help rule becomes: a change updates the English text in the same commit and marks the other languages' entries as needing translation; a release lists any untranslated strings per language.

The extraction is mechanical but touches nearly every UI file, so it runs when no other agent has SignalDeck branches open (otherwise every open branch conflicts). Split into PRs per screen group, each checked on the phone to look identical in English.

## 4. Quality: fluent, accurate, native

The owner's requirement: **the translation must read as if written by a native-speaking ham. Fluid and accurate, not a literal word-for-word rendering that reads poorly to native speakers.**

- **Glossary first.** Per language, before any screen: the 100–200 recurring terms (buttons, radio terms, units, the app's own feature names) with the chosen rendering and the reason, agreed with the reviewer. Every later string follows it, so the same English word is never translated three ways.
- **Style guide per language.** Register (German *Sie* vs *du*; most ham apps use *du*, but the reviewer decides), punctuation and quote marks, number and decimal formats (`467,625 MHz` in German), date/time formats, capitalisation of UI labels, how to address the user in warnings.
- **Translate meaning, not words.** Each string is translated with its context: the screen, what the control does, the space available (the extraction step records a short context note and a maximum length per string, visible to the translator). Idioms and sentence structure follow the target language; the English is a meaning to convey, not a sentence to copy.
- **Draft, then native review, every string.** A careful draft (from context, the glossary and the style guide), then a review by a native speaker who knows ham radio, ideally a licensed operator. Nothing ships unreviewed. For German, the tester who asked. For others, volunteers recruited through the Contribute page and GitHub Discussions ("help translate SignalDeck"), credited in the About screen.
- **Back-check.** A second, independent pass translates the reviewed text back to English and flags any string whose meaning changed (a safety warning that lost its "not", a unit that changed).
- **In-context review.** The reviewer checks the running app (screenshots of every screen in that language, and the guide) and not only the file, because many errors only show in context (a truncated label, a button whose verb doesn't fit).
- **Safety text gets extra care.** Transmit warnings, licence notes, heat and power warnings, firmware-loader steps and the restricted-mode PIN text are reviewed twice, and kept as clear as the English.

## 5. Order of work and what "done" means

1. Overnight: extraction, guide resource, web table, pseudo-localisation, guards (§3). English must look and behave exactly as before (device check of every screen, host suite, the web pages).
2. German: glossary and style guide with the tester, draft, native review, back-check, in-context review on the Armor and the Atom XL, fixes. Ships in a beta when 100 % reviewed.
3. Each following language the same way, one at a time.

A language is **done** when every string and the whole guide are reviewed by a native-speaking ham, the back-check is clean, every screen was checked in context, and the placeholder/key tests pass.

## 6. Open questions for the owner

- Override in Device: offer every shipped language, or only follow the phone? (Suggested: both.)
- Credit reviewers by name/callsign in About, or anonymously? (Callsigns only with their permission.)
- Translation tooling for volunteers: plain files through GitHub PRs, or a hosted tool (Weblate has a free tier for open-source projects)? Decide when the first outside reviewer joins.
