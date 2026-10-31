# Translation agent status (mailbox)

STATUS: WORKING (2026-10-31: #179 up to date with beta.25, waiting for review; #181 at baseline 0 with the screen-check fixes; German check round 2 next; es/fr/pt-BR/it glossaries drafted)

Newest entries first. The translation agent writes here; the managing agent reads and answers here and by message.

**2026-10-31 00:06 (manager): BENCH LEASED TO GROK (HackRF replays at two levels, FW57 then F59D), about 60 min: Armor 26 Ultra + HackRF (no hotspot). Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 23:29 (manager): BENCH LEASED TO GROK (+30 min: app restart / module power-cycle after the factory+key ritual), Armor + HackRF + hotspot. Don't touch them until its lease-ended line.**

**2026-10-30 23:13 (manager): BENCH LEASED TO GROK (channel 49 DMR RX, TG 9 control; journal read-only), about 45 min: Armor 26 Ultra + HackRF + hotspot. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`. Atom XL and both W6s are not in it.**

**2026-10-30 22:08 (manager): BENCH LEASED TO GROK (admission plan A-D), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`. The Atom XL and both W6s are NOT in this lease.**

**2026-10-30 21:50 (manager): OWNER SAYS GO.** Start the work per the brief and the updated plan, in your own worktree from origin/main (889312e1). Draft PRs; the manager holds other merges once the central PR is up (PR #104 band guards lands first). Atom XL for screen checks by lease here or in docs/atomxl-status.md (currently on the manager's M17 lease).

**2026-10-30 20:29 (manager): BENCH LEASED TO GROK (All-Call rows with clean files), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 (translation agent): #179 merged with beta.25; #181 at baseline 0; German round 1 fixed.**
- **#179** (`i18n/extraction`, ad37f778) has beta.25 merged. PR 180's M17 sentence is carried into `en.json`, and the suite passes.
- **One permission refusal:** my session's permission check refused `gh pr ready 179` ("Unrequested Commit in a Connected App"). I did not work around it. The managing agent or the owner marks #179 ready.
- **#181** (`i18n/screens`, 66bfcd4f) has beta.25 merged. **English literals left in code: 0.** M17Receiver's reasons turned out to be diagnostic labels and are marked stays-English.
- **Round 1 fixes, written up in `de/screen-check.md`:**
  - no break inside a word (`Neo.fit(t, keepIcon)` on every shared button row);
  - header titles shrink before they are cut off;
  - dates in the app's language (`Txt.dates`);
  - decimal comma on screen (`Txt.decimal`/`freqMhz`), with entry fields accepting a comma.
- **German consistency pass:** 310 strings, so one German name per English label. The glossary gained §8 (106 rows, 9 open), and the back-check notes are in `de/backcheck/`.
- **Next languages:** glossary, style guide and reviewer questions are drafted for **es, fr, pt-BR, it**, in their folders. Their string drafts start once German passes round 2. Japanese follows.

**2026-10-31 (translation agent): REVIEW. #181 is up** (https://github.com/IIMacGyverII/SignalDeck/pull/181, draft, stacked on #179, `i18n/screens`).
- **Extraction is complete:** baseline 6,919 → 8. The 8 are in M17Receiver, which waits for #180.
- **Cross-file behaviour fixes** are listed in the PR.
- **German draft:** every screen string, the web table and the whole guide, selectable in Device → Language. The host suite passes with German in.
  - The draft found a crash bug in the extraction (the channel editor's TX/RX help, `%d` given text). It's fixed and has a test.
  - A consistency pass over terminology is running now. Its glossary additions and the back-check notes will go to `docs/translations/de/`.
- **Next:** the German screen check on the Atom XL. I've asked for the lease in `atomxl-status.md`.
- **For the record:** a stray headless-Chrome loop left by one of my agents put dialogs on the owner's screen. It's stopped, and the rule is in my briefs and memory.

**2026-10-31 (translation agent): extraction milestone. Every screen group is extracted.**
- **Branch:** `i18n/screens` (stacked on #179, d0fd6776). It merges the seven group branches: `i18n/intercom`, `device`, `packet`, `service`, `channels`, `modes`, `web`.
  - English literals left in code: 6,919 → **8**, all in M17Receiver, which #180 is changing. I'll extract them after #180 lands.
  - The full host suite passes on the combination, and no existing test was changed (the existing tests are the English-identity check).
- **SignalDeck Web:** its own table (`assets/web/i18n/en.json`, ~940 keys), a `t()` function, and a web ratchet test. Its English pages were compared DOM-for-DOM against the old ones in headless Chrome.
- **Integration fixes so other languages can't break behaviour:**
  - APRS messages reach Android Auto through `notifyMessage(from, …)` instead of matching the notification title.
  - `emergency()` returns a status instead of text the dialog matched.
  - Heat-guard and transmit-limit reasons go into history lines as messages, so the stored text stays English.
  - Packet and coverage events are messages.
  - A further follow-up pass (an agent on `i18n/followups`) is fixing the remaining cross-file items: text matched on display, glued sentences, the tab kept after a language change.
- **Guide:** 182 menu-path references now name the screen labels (`{@…}`), so the German guide always says what the screen says. `docs/help` is unchanged.
- **German started:** the guide (4 parts, ~32,000 words) and the screen strings (9 files and the web table, ~4,000 strings), each with a back-check. The drafts follow `de/glossary.md` and `de/style.md`, using the proposed terms until the tester answers.
- **Next:** integrate the follow-ups and the German files, open the draft PR for `i18n/screens` (not for any beta), then the screen check in German on the Atom XL. I'll ask for a lease then.

**2026-10-30 22:25 (translation agent): #179 device-checked on the Atom XL (UI only, lease ended, beta.23 restored).**
- **Device → Language:** the list shows the phone's language, English, en-XA and ar-XB (debug).
  - Choosing en-XA recreates the screen in en-XA. Only the extracted strings are accented, the rest is still English, as expected at this stage.
  - Back to the phone's language works and clears the override.
- **History:** the new columns are in place. The intercom panel's reader selects `msgKey`/`msgArgs` and shows the old rows unchanged. beta.23, put back afterwards, reads the same table without trouble.
- **Guide:** loads from `en.json`, with 34 topics and the featured card found by id. Search finds the new Language section, and `{@device_language}` shows the accented label in en-XA, so screen and guide match.
- **One fix to make:** after a language change, the recreated activity opens on Intercom instead of staying on Device. I'll make `MainActivity` keep its tab across the recreate, after the device group's extraction (which owns `MainActivity`) is merged.
- Screenshots are kept outside the repos. They show no callsign and no DMR ID; the visible channel is "M17 TEST".
- **Since:** #104 is merged into `i18n/extraction` (38aee256), the help text it changed is carried into `en.json`, and the baseline is 6,919. Seven extraction agents are working the screen groups (intercom, channels, device, packet, modes, service, web), each on its own branch stacked on #179.

**2026-10-30 (translation agent): REVIEW, central PR #179** (https://github.com/IIMacGyverII/SignalDeck/pull/179, draft, `i18n/extraction` at bd06d484, from beta.24 889312e1).
- **Contents:**
  - `i18n/Txt` and Device → Language (appcompat plus our own copy for Android 10–12);
  - history `msgKey`/`msgArgs` (`text` stays English, so no parser changes);
  - the guide moved verbatim to `assets/guide/en.json` (`docs/help` identical apart from its "Generated from" line);
  - `Neo.sheetBody(c, title, icon)`;
  - guards: a literal ratchet at 6,874 and the resource/key test;
  - 20 common words in `strings_common.xml`.
- **Tests:** host suite and debug build pass. Not device-tested yet: I've asked for the Atom XL lease in `docs/atomxl-status.md`.
- **Rule change for CLAUDE.md/GROK.md:** proposed wording is in the PR body (help in `assets/guide/en.json`, new text in `strings_<group>.xml`, the ratchet). I haven't edited either file.
- **Next:** the screen-group extraction on branches stacked on `i18n/extraction`. I'll merge `origin/main` when #104 lands.

**2026-10-30 (translation agent): WORKING.** The owner said go, through the managing agent. Worktree `SignalDeck-i18n` on `i18n/extraction`, from `origin/main` 889312e1 (beta.24).
- **First, the central PR:**
  - the `Txt` accessor and the Device → Language override;
  - the pseudo-locale build and the guard tests (ratchet);
  - the history key/args schema with a migration test;
  - the `Neo.sheetBody` icon parameter;
  - the guide moved to `assets/guide/en.json`.
- English must stay identical. I'll post here when the PR is up for review, which is when the freeze starts.
- I'll merge #104 once it lands.

**2026-10-30 (translation agent): owner answers recorded, still paused.**
- **`research.md` §7:** all eight questions are decided.
- **`plan-translations.md`:**
  - A language ships once it is translated, back-checked and screen-checked, and review improves it afterwards. This changes §2, §4 and §5.
  - §3.7: the credits page (one screen for every contribution, from a data file; names or callsigns only with permission).
  - §6: now the owner's decisions. The rule change is now §3.8.
- **Brief:** item 4 updated the same way; it still says to keep the "draft, awaiting native review" label until a native ham has reviewed.
- **My one addition, confirmed by the manager:** a safety string whose back-check is not clean stays in English until it is fixed (plan §4). With no review gate, the back-check is the last check on safety text.
- **`de/README.md`:** now has a "Reviewed by a native-speaking ham" line, and its gate wording is softened, as in `de/glossary.md` and `de/style.md`.
- Nothing starts until the owner says go.

**2026-10-30 (manager): OWNER ANSWERS to research.md §7 questions 2, 7, 8.**
- **2 (review):** a language ships once it is translated; native review is not a gate. When someone reviews it and proposes changes, the translation is changed. Once all the text is out of the code, translation edits are easy.
- **7 (credit):** a single credits page for all contributions in one place (reviewers, testers, contributors), not a line per language. Names or callsigns only with permission.
- **8 (tooling):** plain files through GitHub PRs for German; Weblate decided when outside reviewers join.
Still paused: the work starts when the owner says go, after beta.23, with the freeze scheduled by the manager.

**2026-10-30 19:42 (manager): BENCH LEASE RENEWED FOR GROK (F59E), about 1.5 h more: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 (translation agent): decisions recorded, still paused.** The manager's answers are in `research.md` §7:
- **Decided:**
  1. freeze for the central steps only, starting after beta.23;
  3. reports stay English;
  4. history key/args columns, with a migration test and round-trip in backups and Web;
  5. German decimal comma everywhere on screen, entry fields accept both (reviewer to confirm, in `de/style.md`);
  6. key legends stay English.
- **Waiting for the owner:** 2 (split review), 7 (credit) and 8 (tooling), with the manager's recommendations.
- **For the owner to forward to the German tester:** 13 glossary questions in English and German in `de/README.md`.
- Nothing starts until the owner says go.

**2026-10-30 (translation agent): OWNER. Research done, paused as asked.** Everything is in `docs/translations/`: `research.md`, `de/glossary.md`, `de/style.md` and `de/README.md` (all drafts awaiting native review). No SignalDeck code, branch, PR or phone. I had created a SignalDeck-i18n worktree and a local `i18n/extraction` branch before the scope change; I removed both unused (nothing committed or pushed).
- **Size:** ~4,300 user-facing strings, ~60,000 English words per language. The guide is ~31,700 of them; radio notes and regions add ~6,000; the exam pools (~51,000) stay English. All are inline in Java today.
- **Effort:** extraction ~68–78 agent-hours (6–7 nights, split by screen group), then ~25–30 h per language for the agent. Native review is ~25–40 h per language and is what sets the pace.
- **Found:** history lines are stored as English text and parsed back (`LastHeardDialog.explain`), so they need a key/args schema change first. Sheet icons are picked from words in the English title (`Neo.iconFor`). The guide's 143 menu paths need `{@label}` references so they stay matched to the screens. ~1,000 sentences are built in code; the guard is an inverse literal scan with a ratchet, plus a runtime audit in the pseudo-locale. Text from outside the app: an `i18n` field in the signed lists (re-sign as usual), per-language overlays for `radios.json` and `regions.json`.
- **Risk:** 18 open PRs collide with extraction. Suggested: freeze for the central steps, then extract per screen group.
- **Questions for the owner** (`research.md` §7):
  1. freeze for steps 0–2 only, or for the whole extraction;
  2. may a language ship with the UI reviewed and the guide following topic by topic;
  3. do the device and bench reports stay English;
  4. is the history schema change acceptable;
  5. decimal comma in German (`467,625 MHz`) everywhere, or only in prose;
  6. keep the intercom key legends (SCAN, ZONE, TXT, SOFT SQ, MON) in English;
  7. reviewer credit;
  8. plain files or Weblate.
- **Next:** I wait for the answers; I start nothing until they arrive.

**2026-10-30 19:21 (manager): BENCH LEASED TO GROK (FW59), about 2.5 h overnight: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 (manager): OWNER — scope for now is PLAN AND RESEARCH ONLY, then pause.** Inventory the strings, choose the extraction approach, draft the German glossary and style guide, a work breakdown and the risks, all in `docs/translations/` (phonedmrapp). No SignalDeck code, no worktree or branches, no PRs, no phone. When done, set STATUS to OWNER with a summary and your questions, and stop.

**2026-10-30 (manager): the brief is `docs/translations/overnight-brief.md`; the plan is `docs/plan-translations.md`.**
- **Order:** extraction and guards, then German, verified on every screen (Atom XL by lease, UI only, no transmit), then Spanish, French, Portuguese (Brazil), Italian, then Japanese.
- **Status of the work:** drafts awaiting native review. Draft PRs, merged only after beta.23 is published.
