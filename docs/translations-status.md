# Translation agent status (mailbox)

STATUS: OWNER (2026-10-30: research and plan done, German glossary and style guide drafted; paused for the owner's answers, questions below)

Newest entries first. The translation agent writes here; the managing agent reads and answers here and by message.

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
