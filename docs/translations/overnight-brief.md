# Translations: overnight brief for the translation agent (2026-10-30)

**Owner, 2026-10-30 evening:** a dedicated agent does the translation work overnight. There's **no expectation that it goes into beta.23.** German first, as planned. **Once every screen is verified in German, so we know the translation machinery works, move on to the other languages and verify each the same way.**

The full plan is **`docs/plan-translations.md`**: scope, languages, engineering steps, the quality rules, and what "done" means. Read it first; this brief adds tonight's arrangements and the rules that keep the shared repositories safe.

## Order of work

1. **Extraction and infrastructure** (plan §3).
   - Every user-facing string goes into `res/values/strings.xml` (plurals, numbered format arguments, a context note and a maximum length per string).
   - The guide (`HelpView.TOPICS`) becomes one structured resource per language.
   - SignalDeck Web's strings go into one JSON table per language.
   - Language choice: follow the phone, plus an override in *Device* (both, the plan's suggested answer).
   - A **pseudo-localisation** build (accented, 40 % longer).
   - The **guard tests:** no user-facing literal left in UI code; every language has the same keys and placeholders.
   - **English must look and behave exactly as before.**
2. **German:** a glossary and style guide first (`docs/translations/de/glossary.md`, `style.md`); then the draft of every string and the whole guide; then the **back-check** (translate back to English, flag every meaning change); then **verify every screen in German** (below).
3. **Only when German passes the screen check:** Spanish, French, Portuguese (Brazil), Italian, in that order, each with the same glossary → draft → back-check → screen check. Then Japanese (line breaks and width need extra care).
4. **Nothing is "done"** until a native-speaking ham has reviewed it (plan §4–5). Mark every language **"draft, awaiting native review"** in its folder's README. Tonight's work produces reviewable drafts, not shipped translations.

**Quality bar (owner):** read as if written by a native-speaking ham, fluent and accurate, never word for word. Keep the international ham terms (squelch, CTCSS, talkgroup, APRS, PTT …) unless the glossary decides otherwise. Safety text (transmit, licence, heat, firmware loader, Restricted PIN) gets a second careful pass.

## Verifying screens: how, with what

- **The pseudo-localisation build:** run it on every screen first. It catches clipping before any real language exists.
- **The phone:** use the **Unihertz Atom XL**, by **lease from the managing agent** (ask in your mailbox; it grants it in `docs/atomxl-status.md`).
  - **UI only:** set the phone or app language, then open every screen, sheet and dialog and take a screenshot.
  - **Never transmit:** no Talk, no transmit test session, no data sends. Don't change channels the bench relies on; restore the app's language and settings afterwards.
  - **Connection:** with the radio on, the Atom XL has no USB data. Use Wi-Fi ADB `192.168.1.106:5555`. Don't uninstall the app.
  - **What to install:** your branch's debug build, installed over the top (`adb install -r`, never uninstall: that loses the Magisk grant). Put back the build that was there (ask the managing agent which) when you're done.
- **The Armor 26 Ultra is the firmware bench:** don't use it unless the managing agent leases it to you.
- **Screenshots:**
  - into a scratch folder outside the repos, e.g. `%TEMP%\translations\<lang>\<screen>.png`;
  - **review each one:** no callsign, DMR ID or location in view; the bench data is N0CALL / DMRTST-7 / 1234567;
  - **per screen, note in `docs/translations/<lang>/screen-check.md`:** pass, or what's clipped or wrong, with the fix.
- **SignalDeck Web:** check the same way in a desktop browser, with the phone's web server (port 8080, through `adb forward`; check `adb forward --list` for collisions first). Never print the web PIN.

## Branches, PRs and merges: exactly how (read before your first commit)

Several agents share these folders, and the merge problems we had today came from breaking these rules. This work touches nearly every UI file, so it collides with every other open branch. That makes the rules more important here than anywhere.

**SignalDeck:**
1. **Never commit in the shared checkout** `D:\Documents\code\personal\SignalDeck`, nor in `SignalDeck-merge`, `SignalDeck-txlen`, `SignalDeck-xplore1` or `SignalDeck-3wt`.
2. **Your own worktree:**
   `git -C D:/Documents/code/personal/SignalDeck fetch origin`
   `git -C D:/Documents/code/personal/SignalDeck worktree add D:/Documents/code/personal/SignalDeck-i18n -b i18n/extraction origin/main`
   Copy `local.properties` from the shared checkout only if you need a signed release build; the debug build and tests don't need it.
3. **Branches:** one per step (`i18n/extraction`, then `i18n/de`, `i18n/es` …), each started from the previous one, so they stack.
4. **Keep up with main:** every couple of hours, run `git fetch origin && git merge origin/main`.
   - **Merge, never rebase a pushed branch, never force-push:** force-push is refused by our permission settings.
   - **Resolve conflicts keeping both sides.** Other agents' new strings must end up extracted too.
   - **Then rerun the whole host suite:** `JAVA_HOME=/c/Users/Joshua/tools/jdk-17.0.20.1+1 ./gradlew -q testReleaseUnitTest`.
5. **Generated docs:**
   - help: `./gradlew -q testReleaseUnitTest --tests '*HelpExportTest' -PexportHelp=true --rerun-tasks`;
   - radio notes: `... --tests '*RadioNotesExportTest' -PexportRadios=true --rerun-tasks`.

   Commit only the files whose content changed (`git diff --ignore-cr-at-eol --name-only docs`); `git checkout -- docs/help docs/radios` for the rest.
6. **Push your branches and open PRs against `main`** with `gh pr create`. Mark them **draft** (`--draft`), and say in the title that they're **not for beta.23**.
   - **Don't merge, close or edit anyone's PR, and never push to `main`.**
   - **The managing agent merges after beta.23 is published.** Main must not change under the beta.23 candidate, and an Armor 3WT branch is open now.
7. **Never amend a pushed commit.** Further changes go in as new commits.

**phonedmrapp (glossaries, style guides, screen checks, mailbox):**
- **Commit directly on `main`, your own files only** (`docs/translations/**`, `docs/translations-status.md`):
  `git fetch -q origin && git rebase -q --autostash origin/main && git push -q origin HEAD:main`.
- **Never `git reset --hard`; never `git checkout -- <file>`** on a file with uncommitted work.

**Commit messages** end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

**If a permission check refuses something:** stop, write it in your mailbox (STUCK) and message the managing agent. Don't work around it.

## Mailbox and reporting

`docs/translations-status.md`:
- a `STATUS:` line (WORKING / REVIEW / STUCK / OWNER / IDLE), newest entries first;
- push after each update;
- report at each milestone: extraction PR up, German draft done, German screen check passed, each further language.

**Ask for phone leases there.** Questions for the owner go through the managing agent.

## Rules

- **No callsign or DMR ID anywhere,** in strings, screenshots or examples.
- **No GPL code copied into SignalDeck.** Translations are written for SignalDeck, not taken from other projects' files.
- **Logs, diagnostics, `report.json`, file formats and protocol names stay English** (plan §1).
- **After extraction,** propose the CLAUDE.md help-rule change from plan §3.7 to the managing agent; don't edit CLAUDE.md yourself.
