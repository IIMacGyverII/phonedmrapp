# 07 — Nearby Repeaters: independent review of Claude’s design

**Update:** Claude adopted this chapter as [`16-repeater-directory-import.md` §9 Revision 2](../deep-dive/16-repeater-directory-import.md). Nothing below is walked back. Extra programmer constraint from [09](09-claude-reconciliation.md): digital `encryptKey` must be **exactly 8 bytes** on the wire (empty string shifts `DigitalMessage` offsets 151+).

Claude’s documents (read in full for this chapter, 2026-08-27):

| File | What it is |
|---|---|
| [`docs/deep-dive/16-repeater-directory-import.md`](../deep-dive/16-repeater-directory-import.md) | Feature design, UX, schema, programmer, 5-phase to-do |
| [`docs/deep-dive/_research-repeater-sources.md`](../deep-dive/_research-repeater-sources.md) | Live-fetched endpoints, terms, field maps (RepeaterBook, BrandMeister, RadioID, hearham, RR, others) |
| [`docs/deep-dive/_research-integration-surface.md`](../deep-dive/_research-integration-surface.md) | Exact OEM/module APIs to call, pitfalls, Device-tab injection |

Those files were **not** edited. This chapter is the delta: agree, disagree, and what they missed.

---

## 1. Bottom line

**Build it.** The source research is the best piece of work in the uncommitted batch. The integration surface is load-bearing and mostly right. RepeaterBook as Phase 4 opt-in (not v1) is the correct call.

**Do not build it as written until four product facts are in the design**, or Phase 1 will ship a pretty dialog that programs the wrong radio behavior:

1. **One channel per talkgroup is required on this radio, not a dmrfill convenience.** Firmware ignores the 32-slot RX group list. A BrandMeister repeater with 6 static TGs is 6 channels or you only TX/RX the one `txContact`.
2. **“Distance on the intercom” does not work today.** `LocationDatabase` is keyed by `channel_number`; the intercom looks up `mCurrentChannelIndex + 1`. After `createChannel`, `number == _id`, which only matches `index+1` with no deletions and no zone filter. Fix the lookup (to `_id`) as a Phase 1 prerequisite, not a footnote.
3. **`createChannel` does not load the radio.** New rows stay `active=0`. The user must tap the channel. The summary sheet must say so or the first install looks like a no-op.
4. **Group-call RX has two documented stories.** Chapter 07: ALL-mode (`contactType=2`) reports TG `0xFFFFFF` so the app drops audio; GROUP-mode ignores the *extra* RX list. Chapter 13’s hard-constraint table says “private calls to own DMR ID only.” Those are not the same claim. **P0.6 is an on-air test of one GROUP channel on a local BM repeater before writing N channels per site.** If GROUP+`txContact` hears that TG, Phase 1 is a listen feature. If it does not, DMR nearby is a TX memory bank and analog FM (Phase 2) is the listen feature — say that on the card.

Everything else below is additive.

---

## 2. What I agree with (do not redo)

### Sources

| Claude’s verdict | Agree? |
|---|---|
| BrandMeister `GET /device?repeater=true` as DMR backbone (no key, 1 MB, 60/min, TG+slot from `/device/{id}/talkgroup`) | **Yes.** Live numbers (3,598 / 87 % coords) are the reason. |
| BM `tx` = repeater output = **user RX**; BM `rx` = repeater input = **user TX** | **Yes.** Easy to invert. Fixture tests must lock this. |
| RadioID `rptrs.json` for non-BM DMR + sysop TG/TS tables; no coordinates | **Yes.** Only source for DMR+ / MARC / c-Bridge TGs. |
| hearham for worldwide FM + a geo-index; no TGs | **Yes**, gated on written OK (Claude already made that a ship-blocker). |
| RepeaterBook **not** v1: 401 without token, no radius, no TGs in the API, `rbuapp_` per user, “minimum cache”, mandatory attribution | **Yes.** Phase 4. |
| RadioReference: no | **Yes.** |
| CHIRP’s `data.chirpmyradio.com` mirror: not ours to use | **Yes.** |
| Dedupe key = normalised callsign + RX ±2.5 kHz | **Yes.** |
| Field precedence DMR: BM > RadioID > RepeaterBook > hearham; FM: RepeaterBook > hearham | **Yes.** |
| Cache TTLs (BM 24 h / never inside 15 min, RadioID 7 d, hearham 30 d, RepeaterBook session-only) | **Yes.** |
| Descriptive User-Agent with contact | **Yes** — but `contact@…` is a placeholder. Need a real address before the first fetch. |

### Programming

| Claude’s rule | Agree? |
|---|---|
| Additive `DmrManager.createChannel(area, cd)` — **never** `DirectDatabaseImporter` | **Yes.** |
| Area from `OemChannelTable.areaKey` — never the literal `"default"` | **Yes.** `createAPRSChannelIfNeeded` is the anti-pattern. |
| `txContact` = TG ID (Pitfall 12); `relay=2`; `encryptSw=2` / `encryptKey=""`; `active=0`; `interrupt=2` | **Yes.** |
| `band` = bandwidth, default wide unless the source says narrow; **not** `determineBand()` | **Yes.** Do not call `MainHook.determineBand`. |
| `ToneConverter.parseSubCode` miss → 0 = 62.5 Hz; format `%.1f` and round-trip | **Yes.** |
| `groups = getHardwareGroups()` (exactly 32) before insert so `addChannel` writes `channel_groups` | **Yes.** Truncate + warn. |
| Contacts: `getContact(1, tgId)` then `saveContact` if missing; undo must not delete a reused contact | Claude’s `installed.contact_id` needs a **created-vs-reused** flag. Principle: yes. |
| `channelMode=4` for DMR repeater channels | **Yes** (importer precedent; open decision §8.1 — keep 4). |
| Do not name channels `APRS (` | **Yes.** Also do not use `SSTV (`, `NOAA (`, `VFO` prefixes (list filter only hides APRS today). |
| Device-tab button after RadioID, not a seventh PTT satellite | **Yes.** |
| Copy `ProgressDialogHolder`, not a new progress widget | Fine for v1. |
| JUnit parsers against saved fixtures | **Yes.** First tests in the repo. |

### UX skeleton

Radius chips, FM/DMR + 2 m/70 cm, on-air/open, distance-sorted cards, live preview, undo, attribution footer, “»” zone prefix — all good. Defaults (Local 9 off, cap 8 TGs/repeater, `{call} {tg}` names) are right.

**Channel name width is 32 characters**, not an open to-do. OEM `interphone_channel_name_edit` `android:maxLength="32"` (`interphone_channel_activity.xml:14`). Close P1.3: trim to 32.

---

## 3. Where I disagree

### 3.1 Location save is specified; location **read** is not fixed

Claude [I §5]: “Save with `cd.getNumber()` after `createChannel`.” After `addChannel`, `number` is overwritten with rowid, so they save `_id` into a column named `channel_number`. The intercom then does `mCurrentChannelIndex + 1` (`MainHook.java:3188-3192`).

That is not a “known limitation” you can ship past. The feature’s pitch is distance on the intercom. Zone filter, holes in `_id`, or “All channels” vs a zone make the chip show the **wrong repeater** or none.

**Required before P1.4:** change `updateLocationDisplay` (and export/import) to key by `_id`. Then `saveLocation(_id, lat, lon)` is honest. Do not add a second keying scheme.

### 3.2 Module extras are still global across areas

`createChannel` is area-aware. `dmrmod_zones.db`, `dmrmod_tglists.db`, `dmrmod_locations.db`, `dmrmod_aprs.db` are **not**. Claude’s `installed` table has no `area_key`.

Undo in the VHF area can delete zone rows that also list UHF `_id`s if those integers collide (they will, both areas start `_id` at 1). Location PK `channel_number` will overwrite the other area’s GPS for the same integer.

**Add `area_key` to `installed`, and to location/zone/TG assignment** (or namespace zone names `»UHF W9ABC`). This is the same hole as grok `02` P1.7.

### 3.3 The main UI cannot be another `AlertDialog` + `ScrollView` of LinearLayouts

Claude’s mock is a RepeaterBook-style list; the implementation note is “copy `showReceivedStationsDialog`.” That pattern is ~10 APRS rows. A 50 km city search is 80–200 cards with expand/TG checkboxes.

Use a `ListView` or `RecyclerView` (even inside a dialog). Recycle rows. Search/filter must not rebuild 200 `LinearLayout`s. This is the one overlay feature that deserves a real scrolling adapter.

### 3.4 Catalog files do not belong in `Download/DMR/Repeaters/`

Claude puts BM/RadioID/hearham dumps next to backups. RadioID’s terms are “no mirroring / re-publishing.” A world-readable 5.8 MB `rptrs.json` in Downloads is the thing they forbid if the user shares the folder (or a backup zip picks it up).

**Store catalogs in the OEM app’s private cache** (`context.getCacheDir()` / a module subdirectory of the OEM data dir), same as `dmrmod_radioid.db`. Attribution in the UI is enough.

### 3.5 Do not fetch 17 MB on cellular as the happy path

Claude’s empty-cache copy: “tap to download (~17 MB).” BM `?repeater=true` is **1 MB** and is the whole of Phase 0–1. RadioID 5.8 + hearham 9.5 are Phase 2 and should wait for Wi-Fi (or an explicit “Download full catalog”).

Default: BM-only on any network. Full catalog: Wi-Fi, or a button.

### 3.6 Hearham DMR rows must not become DMR channels

hearham DMR has `encode="CC4"` and **no talkgroups**. A `ChannelData` with `type=0`, `txContact=1` (ctor default) is a private call to DMR ID 1, not “that repeater.”

Rules:

- hearham `mode` contains DMR **and** we have TGs from BM/RadioID for that key → DMR channels from those TGs, CC from the best source.
- hearham DMR with **no** TG table → skip DMR; if `mode` also FM (or we want analog), one FM channel only.
- Never invent `txContact=1`.

### 3.7 “On-air only” needs a stale cutoff, not just a flag

BM `status` 0 is offline/unknown; `last_seen` in the live example had no timezone (treat as UTC). `?repeater=true` is already “seen in 7 days.” Default filter: drop `status==0` and `last_seen` older than 48 h. RadioID `status` is always `ACTIVE` — useless; don’t treat it as on-air.

Also drop BM rows with `tx == rx` (Claude counted 429 simplex 6-digit IDs in the repeater list).

### 3.8 Channel-count honesty

Cap 8 TGs/repeater is good. 25 DMR repeaters × 8 = 200 channels in one sitting, on top of the user’s codeplug, in **one area**. OEM SQLite has no 1024 cap like a GD-77; the pain is the bare `ListView` and zone navigation.

Preview strip must show **“you already have N channels in this area; this adds M (total N+M)”** and a confirm if M > 40 or N+M > 200. Undo is mandatory (Claude has it).

OpenGD77 `Zones.csv` only has 80 channel columns. A `»FM nearby` zone with 90 analog repeaters **round-trips truncated**. Runtime `ZoneDatabase` is unbounded. Warn: “Zone has 90 channels; CPS export keeps 80.”

### 3.9 Do not copy `createAPRSChannelIfNeeded`

Claude already says don’t copy `relay=0` and area `"default"`. Also don’t copy `syncChannelInfo` on a new inactive row. Programmer should look like the OEM editor create path only (`InterPhoneChannelActivity` `:802-803`).

---

## 4. What Claude missed (the value of a second pass)

### 4.1 DMR RX model on *this* radio (product copy)

dmrfill/qdmr use one channel per (repeater, TG, slot) because CPS software likes it. **This firmware does not honor `groups[32]` for RX** (ch. 07 §5, hard constraint). So:

- `contactType=1`, `txContact=tgId`, `inBoundSlot=outBoundSlot=slot-1` is the listen *and* talk channel for that TG — **if** GROUP RX of `txContact` works.
- Stuffing 32 TGs into `groups` on one channel will **not** let you hear 32 TGs.
- ALL-mode (`contactType=2`) is a known firmware dead end (reports `0xFFFFFF`). Do not offer “monitor all TGs on this repeater” as a channel type.

UI: each DMR card’s expanded TG list is “channels that will be created,” not “TGs this one channel will receive.”

**P0.6** (before P1.4): one BM repeater, one TG, `createChannel`, user selects it, confirm audio on a known-busy TG (e.g. local 9 or a statewide). Write the result into this chapter. Do not skip.

### 4.2 OEM is `sharedUserId="android.uid.system"`

Decompiled `decompiled/AndroidManifest.xml:1`. That is why RadioID HTTP works with **no `INTERNET` in the app’s `<uses-permission>` list**. Network from the OEM process is a system-UID privilege, not a module-manifest grant.

Still do P0.5 `dumpsys` for **runtime** location on Android 13. `getCurrentLocation` is last-known-only and already catches `SecurityException`. One-shot `requestLocationUpdates` with a 10 s timeout (Claude’s UX) is the right addition; it may need the location permission to already be granted (Armor 26 radio apps usually have it for the OEM GPS-SMS feature).

### 4.3 Maidenhead hiding in BM `city`

Live GB7BB: `city: "Banff, IO87QP"`. When `lat/lng` are 0, parse a 4–6 char locator from `city` / RadioID `map_info` before calling Android `Geocoder`. Cheap, offline, better than geocoding “Springfield.”

Do **not** geocode the 6k RadioID-only rows at catalog fetch. Join BM id → hearham callsign → Maidenhead → Geocoder **lazily for rows inside the current radius that still have no point**.

### 4.4 Mixed-mode and GMRS

- hearham `DMR/FM`, RepeaterBook `FM Analog=Yes` + `DMR=Yes`: **two installables** from one key (one analog channel, N DMR channels), not one.
- RepeaterBook `stype=gmrs` / hearham restriction / 462–467 MHz FRS/GMRS: default **off**. This is a ham DMR/FM radio; GMRS is a different licence. Chip “GMRS” in settings, not on by default.
- Frequencies outside 136–174 / 400–480 MHz (`Constants.CHANNEL_FRQC_BAND_*`): show in the list, badge “out of radio range”, not installable. Claude has this; also exclude 220 MHz and 1.25 m explicitly.

### 4.5 Frequency raster and JSON types

BM fields may be JSON numbers (`439.7125`). RadioID `frequency` is a string `"440.58750"`. hearham is Hz int. Parser must:

- convert to integer Hz with rounding (`Math.round(mhz * 1e6)`), not `(int)` truncate;
- reject 0 / negative / TX==0;
- BM simplex already dropped.

Unit tests: `"+5.000"` → +5e6 Hz; hearham `-600000`; `439.7125` not `439712499`.

### 4.6 Prefixes the list filter does not hide

`isAPRSChannel` only. A directory channel named `NOAA Springfield` is fine; `NOAA (W9ABC)` would look like a hijack to crash recovery. Ban those four prefixes in the namer.

### 4.7 Undo semantics Claude left implicit

| Object | On undo |
|---|---|
| Channel this run created | `DmrManager.deleteChannel(area, cd)` |
| Zone this run created that is now empty | delete zone |
| Zone this run created that still has other runs’ channels | leave it |
| TG list this run created, unreferenced | delete |
| Contact this run **created** | delete |
| Contact that already existed | **leave** |
| Location row | delete for those `_id`s |
| `installed` rows for `run_id` | delete |

Fingerprint = `areaKey|callsign|rxHz|txHz|cc|tg|slot|type`. Re-run with same fingerprint → `updateChannel(area, cd)` in place (Claude), including location refresh.

### 4.8 Hardware is not programmed until select

Summary sheet copy:

> Added 9 channels in 4 zones. They are not live yet — open the channel list (or the new zone) and tap one. Undo removes only this install.

Do not `syncChannelInfoWithData` on the new rows (`active` must stay 0, Pitfall 8/13).

### 4.9 Wi-Fi, User-Agent, legal order

Phase 2 legal (Claude §5) is correct. Reorder:

1. Phase 0–1 ships **BrandMeister only**. No hearham/RadioID dump, no RepeaterBook. BM has no published read-ToS; still send the courtesy email, but it is not a code gate if the email is unanswered (document the send).
2. Phase 2: written OK from hearham **before** merging `HearhamSource`. RadioID: private cache only (not Downloads).
3. Phase 4: RepeaterBook app approval. An LSPosed module sideloaded from GitHub still fits `rbuapp_` (“installed by users, open source, cannot keep a shared token secret”). Non-commercial. Confirm Play-Store-IAP language does not apply (this app has no IAP).

User-Agent: `DMRModHooks/<versionName> (https://github.com/IIMacGyverII/phonedmrapp; <real email>)`. Put the email in one constant.

### 4.10 `»FM nearby` zone name

If the radius chip changes, either rename on re-run (`»FM ≤50 km`) or keep a stable `»FM nearby` and let the membership set be “whatever the last install added.” Stable name + fingerprint update is simpler.

### 4.11 Editor help / `determineBand` landmines

`RepeaterProgrammer` must set `band` from source bandwidth (default 1). If anyone “reuses” VFO’s `determineBand(freq)` this feature will ship UHF analog as narrow. Add a unit test: 146.94 MHz FM → `band==1`; 446.0 MHz FM wide → `band==1`; 12.5 kHz source → `band==0`.

### 4.12 Permissions dump package name

Claude [I §5] greps `com.macgyver.dmr`. Installed OEM is `com.pri.prizeinterphone` (`sharedUserId` system). Dump **that** package. The in-tree rebuild id is a trap.

---

## 5. Revised class list (small deltas)

Keep Claude’s split. Changes:

| Class | Change |
|---|---|
| `RepeaterModels` | add `areaKey` only at install time, not on the catalog row; `approx` already there; add `stale`, `simplex`, `gmrs`, `outOfRadioRange` |
| `RepeaterCatalog` | private cache dir; BM-only until Wi-Fi/full fetch; lazy geocode; Maidenhead parse; drop tx==rx |
| `RepeaterProgrammer` | `area_key` on `installed`; created-vs-reused contacts; never `txContact=1`; never `determineBand`; location by `_id` |
| `NearbyRepeatersUi` | `ListView`/`RecyclerView`; banner from P0.6 result; “not live until you tap”; channel-count confirm |
| `GeoUtil` | + Maidenhead → lat/lon (Claude already listed Maidenhead in P3.1; put the converter in P0.3) |
| `HttpClient` | UA with real email; `If-Modified-Since`; no Downloads path |
| `LocationDatabase` | **migrate PK to channel `_id`** (or add column and read `_id` first) — this is a module-wide fix, not feature-private |

`MainHook` surface: Device-tab button, `startNearbyRepeaters(Activity)`, location lookup fix. No new PTT control.

---

## 6. Phase list — what I would change

Claude’s phases stay. Insertions in **bold**.

### Phase 0 — Spike (BM list, no writes)

- P0.1–P0.5 as written.
- **P0.3 includes Maidenhead.**
- **P0.6 On-air: one hand-made (or spike-installed) GROUP channel, local BM TG, confirm RX audio.** Write pass/fail here. Gates Phase 1 copy.
- **P0.5 dumps `com.pri.prizeinterphone`, not `com.macgyver.dmr`.**
- Exit still: nearby BM cards with distance. Catalog in **private cache**.

### Phase 1 — Install DMR (BM only)

- **P1.0 Fix location lookup to `_id`** (and stop using index+1). Required.
- P1.3 is done: trim 32.
- P1.4 programmer + tests; **fingerprint includes `areaKey`**; **no `syncChannelInfo`**.
- P1.5 UI: adapter not nested LinearLayouts; summary “tap to load”; undo table in §4.7.
- **P1.7 Channel-count confirm if adding > 40.**
- Exit: N channels in a `»CALL City` zone, selectable, TX (and RX if P0.6 passed), undoable, **distance chip correct with a zone filter on**.

### Phase 2 — Catalog

- P2.1 RadioID into private cache, Wi-Fi default.
- P2.2 hearham **after** written OK.
- **P2.2b Skip hearham DMR-without-TGs; split mixed-mode into FM + DMR; GMRS off.**
- P2.3–P2.7 as written.
- **P2.8 Cellular stays BM-only unless user opts into full catalog.**

### Phase 3 — Polish

As written, plus **P3.7 “About RX”: this radio uses one channel per TG; ALL-mode is not offered.**

### Phase 4 — RepeaterBook

As written. Don’t start until Phases 0–2 are on a device. Token in `dmrmod_repeaters_global`, never in the APK.

### Phase 5 — Ship

As written. README must include the GROUP-RX sentence from P0.6.

---

## 7. Open decisions (updated)

| # | Claude | This series |
|---|---|---|
| 1 | `channelMode=4` for every DMR channel | **Keep 4.** |
| 2 | One zone per DMR repeater | **Keep.** Network-wide zone is a setting later. |
| 3 | Local TG 9 off by default | **Keep.** |
| 4 | No extra CPS backup after install | **Keep.** |
| 5 | *(new)* Location key | **`_id`, and fix the intercom.** Not optional. |
| 6 | *(new)* Catalog on cellular | **BM 1 MB only.** |
| 7 | *(new)* GROUP RX | **Measure in P0.6.** Copy depends on it. |
| 8 | *(new)* hearham DMR without TGs | **Do not install as DMR.** |

---

## 8. Mapping onto my earlier three constraints

In `04-features.md` I said: Device tab, additive `createChannel`, Geocoder on a worker, no shipping `rptrs.json`. After a full read, those still hold, and the list is longer:

- Fix location `_id` first.
- Area-scope `installed` / extras.
- Recycler/ListView.
- Private cache, BM-first on cell.
- Honest DMR RX copy + P0.6.
- No `determineBand`, no `txContact=1`, no ALL-mode channel.
- Real User-Agent email.
- Dump the OEM package name, not the abandoned rebuild id.

Claude’s source matrix and OEM field recipe remain the implementation spec. This chapter is the product and landmine layer those two memos did not have to be.
