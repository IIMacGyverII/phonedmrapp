> **Status (2026-10-14):** recovered from the other-computer backup (written 2026-06-16, never committed). Several recommendations have since been acted on: root `CLAUDE.md` exists (mirror of `.grok/rules/00-session-start.md`), `.grok/rules` were corrected from `docs/deep-dive/00-README.md` §4 on 2026-08-26. Kept as the audit trail.

# Agent Instructions Audit — June 16, 2026

Review of `.grok/rules/`, `.github/copilot-instructions.md`, and `.claude/` against recent session work:

- **v3.4.4** — RadioID.net global DMR ID database, caller detail panel, DMR history labels
- **v3.4.5** — OpenGD77 CSV import: force digital **double-slot** (`channel_mode=4`), squelch default **2**
- **Planned** — Repeater lookup (`docs/REPEATER_LOOKUP_PLAN.md`)

**Shipped version (authoritative):** `DMRModHooks/app/build.gradle` → **v3.4.5** / `versionCode` 345

---

## `.claude/` — Missing

| Finding | Detail |
|---------|--------|
| **No `.claude/` in phonedmrapp** | Only `OpenGD77Fork/.gitignore` references `.claude/` (fork repo, not this one) |
| **No `CLAUDE.md`** | Claude Code / Claude agents have no entry point in this repo |
| **Recommendation** | Add `.claude/CLAUDE.md` that points to `.grok/rules/00-session-start.md` + `Agents.md` (same pattern as `.github/copilot-instructions.md` header). Keep thin — full reference stays in `.grok/rules/copilot-instructions.md` |

---

## `.github/copilot-instructions.md` — Severely stale

This file is **more outdated** than the `.grok` clone:

| Line / section | Says | Should say |
|----------------|------|------------|
| Current Version | **v3.3.7** (March 2026) | v3.4.5 or “see `build.gradle`” |
| Version History | Stops at v3.3.7 | Add v3.4.0–v3.4.5 milestones |
| Module DB table | No `dmrmod_radioid.db` | Add RadioID cache DB |
| Project structure | No `RadioidDatabase.java` | Add under codeplug/database |
| `channel_mode` schema | “importer defaults to 0” | Digital import forces **4** (v3.4.5) |
| Caller lookup | `getContactNameForDmrId` only | Two-tier: OEM contacts → `RadioidDatabase` |
| OpenGD77 fork version | v1.2.7 / v1.2.0 examples | v2.0.45 zip `OpenGD77CPS-Mac_Build_20260607_210202.zip` |
| Deploy example | `DMRModHooks-v3.4.0.apk` | `v3.4.5.apk` or version-agnostic |

**Note:** `.github/copilot-instructions.md` is **gitignored** (local only). Patches should go to **`.grok/rules/copilot-instructions.md`** first; sync `.github` copy manually if desired.

---

## `.grok/rules/00-session-start.md`

| Item | Status | Recommended change |
|------|--------|-------------------|
| Shipped version hint | **Stale** — says v3.4.1 | Change to v3.4.5 or remove hardcoded version (“see `build.gradle`”) |
| Pitfall table §7 | Missing import fixes | Add **Pitfall 17 — channel_mode**: OEM `0`=Direct, `4`=Double slot; CPS exports `3`→`4`; `DirectDatabaseImporter` **forces 4** on digital import |
| Pitfall table §7 | Missing squelch import | Add **Pitfall 18 — CSV squelch**: empty/0%/None → default **2** on import |
| Pitfall table §7 | Missing RadioID | Add **Pitfall 19 — RadioID**: separate `dmrmod_radioid.db`; personal contacts win; re-download after schema bump for city/state/country |
| Doc tiers / research | Missing new docs | Add `docs/REPEATER_LOOKUP_PLAN.md`, `docs/AGENT_INSTRUCTIONS_AUDIT.md` |
| §8 OpenGD77 fork | Optional | Latest zip `OpenGD77CPS-Mac_Build_20260607_210202.zip` (fork v2.0.45) |

---

## `.grok/rules/key-files.md`

| Item | Status | Recommended change |
|------|--------|-------------------|
| Module file table | Missing | `RadioidDatabase.java` — RadioID download/import, `dmrmod_radioid.db`, Device tab UI |
| `DirectDatabaseImporter.java` row | Incomplete | Note: digital → `channel_mode=4`, `outBoundSlot=inBoundSlot`, squelch `<=0` → `2` |
| `CSVImporter.java` row | Incomplete | Legacy path: digital `channel_mode=4`, squelch default 2 |
| Documentation tiers | Missing | `docs/REPEATER_LOOKUP_PLAN.md` — repeater auto-channel feature (planned) |
| On-disk paths | Missing | `/sdcard/Download/DMR/RadioID/` (`user.csv`) |

---

## `.grok/rules/copilot-instructions.md`

### High priority (wrong or missing vs code)

| Section | Issue | Fix |
|---------|-------|-----|
| **§5a `channel_mode` row** | “importer defaults to 0” | Document OEM values `0`=Direct, `4`=Double slot; CPS `3`↔`4`; importer **forces 4** for digital; export `4`→`3` |
| **Module databases table** | No RadioID DB | Add `dmrmod_radioid.db` / `radioid_users` (dmr_id PK, callsign, names, city, state, country) |
| **On-disk artifacts** | No RadioID folder | Add `DMR/RadioID/user.csv` |
| **Project structure tree** | No `RadioidDatabase.java` | Add under codeplug/database |
| **Helper methods table** | `getContactNameForDmrId` only | Add `lookupCallerDisplayInfo()` — OEM contact first, RadioID fallback; `formatDmrHistoryLabel()` |
| **State variables** | Caller vars incomplete | Document `CallerDisplayInfo`, RadioID source badge in caller panel |
| **Version History** | Stops at v3.3.7 | Add v3.4.0–v3.4.5 bullets |
| **Deploy example** | v3.4.0.apk | Update or version-agnostic |
| **OpenGD77 FORK_VERSION** | v1.2.0 / v1.2.7 | v2.0.45 + current zip filename |
| **Pitfalls § Common** | No import mode/squelch | Add Pitfalls 17–19 (see 00-session-start) |

### Medium priority

| Section | Issue | Fix |
|---------|-------|-----|
| **OpenGD77 Integration — Relay round-trip** | OK | Cross-link new `channel_mode` + squelch import behavior |
| **hookLocalFragment** | Not listed for RadioID | Device tab: Download RadioID, Import CSV, status line |
| **ProgressDialog / Activity context** | Not documented | RadioID download uses Activity context (`ProgressDialogHolder`) — avoid `BadTokenException` |
| **Last Updated** | May 2026 | June 2026 |

### Low priority / planned

| Section | Issue | Fix |
|---------|-------|-----|
| Repeater lookup | Not mentioned | Add “Planned: see `docs/REPEATER_LOOKUP_PLAN.md`” under Feature Tracking or new § |
| BrandMeister API | Not mentioned | Brief pointer in planned section (`/v2/device`) |

---

## `.grok/skills/phonedmrapp/SKILL.md`

| Item | Recommended change |
|------|-------------------|
| Description triggers | Add: RadioID, repeater lookup, caller panel, `RadioidDatabase` |
| First action step 2 | Add: skim `key-files.md` for RadioID / import tasks |
| First action step 5 (new) | If repeater work: read `docs/REPEATER_LOOKUP_PLAN.md` |
| Doc hygiene | Already good — keep syncing `.grok` + `.github` |

---

## `.grok/rules/packet-layouts.md`

| Item | Status |
|------|--------|
| 24-bit caller ID | **Current** — matches v3.4.2+ fix |
| No change required | Unless documenting caller **lookup** (belongs in copilot-instructions, not packet layouts) |

---

## `Agents.md` (repo root)

| Item | Recommended change |
|------|-------------------|
| Minimal | OK as router to `.grok/rules/00-session-start.md` |
| Optional | One line: “Claude agents: see `.claude/CLAUDE.md`” once created |

---

## Suggested new pitfalls (copy into 00-session-start + copilot-instructions)

### Pitfall 17 — `channel_mode` (Direct vs Double slot)

- OEM UI: `channel_mode` **0** = Direct, **4** = Double slot (`InterPhoneChannelActivity`).
- OpenGD77 CPS exports double-slot as **3**; Android stores **4**.
- Value **3** in the DB silently shows as Direct — channels may not tune/RX.
- **v3.4.5+:** `DirectDatabaseImporter` forces **4** on all digital imports and aligns `outBoundSlot` with `inBoundSlot`.

### Pitfall 18 — CSV squelch default

- OpenGD77 often exports squelch as `0%`, empty, or `None`.
- Importer maps those to **0** (wide open) unless corrected.
- **v3.4.5+:** `channel_sq` defaults to **2** when parsed value `<= 0`.

### Pitfall 19 — RadioID vs personal contacts

- Global IDs live in **`dmrmod_radioid.db`** (`RadioidDatabase.java`), not OEM `contact_database`.
- Lookup order: **codeplug contact first**, RadioID second (`lookupCallerDisplayInfo`).
- DB schema v2 adds city/state/country — users who imported before v3.4.4 need **one re-download**.
- Download URL: `https://www.radioid.net/static/user.csv` → `Download/DMR/RadioID/`.

---

## Version history block to append

```markdown
- **v3.4.5** (Jun 2026) - OpenGD77 import: digital double-slot mode + squelch default 2
- **v3.4.4** (Jun 2026) - RadioID.net global DMR ID DB, caller panel, richer DMR history
- **v3.4.3** (Jun 2026) - Caller/history panel layout (250dp border box)
- **v3.4.2** (Jun 2026) - 24-bit caller DMR ID decode fix
- **v3.4.1** (Jun 2026) - (prior release — verify README)
- **v3.4.0** (Jun 2026) - (prior release — verify README)
```

---

## Apply checklist

**Status: applied June 16, 2026** (user approved full patch)

- [x] `.grok/rules/00-session-start.md` — version, pitfalls 17–19
- [x] `.grok/rules/key-files.md` — `RadioidDatabase`, import defaults, RadioID path, repeater plan link
- [x] `.grok/rules/copilot-instructions.md` — schema, DB table, structure tree, version history, pitfalls 17–19
- [x] `.grok/skills/phonedmrapp/SKILL.md` — triggers + repeater plan pointer
- [x] `.github/copilot-instructions.md` — synced from `.grok` (local, gitignored)
- [x] `.claude/CLAUDE.md` — created thin router
- [x] `Agents.md` — Claude pointer added

**Do not** force-add `.github/copilot-instructions.md` or `.docs/` to git per project policy.