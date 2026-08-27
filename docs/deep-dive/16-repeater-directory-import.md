# 16 — Nearby Repeaters: design and to-do list

**Feature.** From the Device tab, tap **📡 Nearby Repeaters**, see every analog-FM and DMR repeater within a chosen radius of the phone's position — with distance, bearing, frequency, tone/colour code, network and talkgroups — pick the ones you want, and have the module program them into the radio *additively*: channels, group contacts, TG lists (→ `channel_groups`), one zone per DMR repeater plus an "FM nearby" zone, and per-channel locations so the intercom's distance display works. Re-running updates what you installed; nothing you programmed by hand is touched.

**Basis.** Two research memos written for this design and kept alongside it:
- [`_research-repeater-sources.md`](_research-repeater-sources.md) — endpoints, fields, auth, rate limits and terms of RepeaterBook, BrandMeister, RadioID, hearham, RadioReference and others, verified by live fetch on 2026-08-27, plus how CHIRP / RT Systems / dmrfill / qdmr do it.
- [`_research-integration-surface.md`](_research-integration-surface.md) — the exact OEM and module APIs this feature must use (`DmrManager.createChannel`, `ChannelData` field recipe, `TGListDatabase`, `ZoneDatabase`, `LocationDatabase`, the RadioID download/progress template, Device-tab button injection, dialog patterns, prefs), with `file:line` cites.

Everything below cites those two files as **[S §n]** (sources) and **[I §n]** (integration).

---

## 1. Goals and non-goals

**Goals**
1. Zero-setup happy path: press the button, allow location, see repeaters, install. No accounts, no keys.
2. Comprehensive: FM *and* DMR, worldwide, with talkgroups and timeslots for DMR (BrandMeister and non-BrandMeister networks).
3. Elegant: one well-laid-out screen that reads like the RepeaterBook app's "nearby" list — distance-sorted cards, clear badges, a live preview of what will be written, and an undo.
4. Safe: additive only; never wipes; never steals the active channel; respects the 32-TG hardware limit and the OEM's per-area database; survives no-network (cached catalog).
5. Honest provenance: every record shows its source and age; required attributions are displayed.

**Non-goals (v1)**
- RadioReference (paid per user, public-safety focus) [S §4].
- Programming other digital modes (D-STAR/YSF/P25/NXDN) — the radio does DMR + FM only.
- Editing repeater data or uploading corrections.
- Replacing the CSV/OpenGD77 backup path — this is a *source of channels*, not a codeplug manager.

---

## 2. User experience

### 2.1 Entry
Device tab → new button **📡 Nearby Repeaters**, inserted after "Download RadioID Database" via `addButtonToLayout(parent, fragment, index + 5)` [I §6.2], same style as its siblings. A small status line under it: *"Catalog: BrandMeister 3,598 · RadioID 11,028 · hearham 22,644 — updated 2 h ago"* or *"No catalog yet — tap to download (~17 MB)"*.

### 2.2 Main screen (one dialog, three zones)

```
┌─ 📡 Nearby Repeaters ─────────────────────────────────────┐
│ 📍 Springfield, IL (GPS ±12 m)         [Use GPS] [Enter…]   │  ← location row
│ Radius  [10] [25] [50●] [100] [200] km                      │
│ Modes   [FM●] [DMR●]     Bands [2 m●] [70 cm●] [other]      │  ← filter chips
│ [✓] On-air only   [✓] Open only   Sources: BM · RadioID · HH │
├─────────────────────────────────────────────────────────────┤
│ ☐ W9ABC  12.3 km ↗   DMR  443.9375 +5  CC1   BM   6 TGs  ✔installed │
│ ☐ KD9XYZ  8.1 km ↑   FM   146.940 −0.6  PL 103.5   RSGB/HH          │  ← distance-sorted cards
│ ☐ N9DMR  31.0 km ↙   DMR  444.5000 +5  CC3   DMR+  TGs: 4 ⓘ approx │
│   …                                                         │
├─────────────────────────────────────────────────────────────┤
│ Selected 3 → 9 channels · 5 contacts · 3 TG lists · 4 zones │  ← live preview
│ [Select all]  [Refresh catalog]        [Install selected ▶] │
│ Data: BrandMeister API · RadioID.net · hearham.com          │  ← attribution footer
└─────────────────────────────────────────────────────────────┘
```

- **Location row**: last-known fix immediately [I §5], then a one-shot fresh fix with a 10 s timeout; manual entry accepts "city, state", a Maidenhead locator or `lat, lon` (Android `Geocoder`, on a background thread — the existing UI-thread Geocoder call is a known jank source [I §5]). Remembered between runs.
- **Chips** persist in `dmrmod_repeaters_global` [I §7]. Radius default 50 km. "Other" band = anything outside 136–174 / 400–480 MHz, shown but flagged *out of radio range* and not installable (the OEM editor's own limits [I §1.3]).
- **Cards** (tap = expand): callsign, distance + 8-point bearing arrow (reuse `getDirectionArrow`/`formatDistance` [I §5]), mode badge, RX MHz, offset sign/size, CC (DMR) or PL/TSQ (FM), network badge (BM / DMR+ / MARC / TGIF / FM-source), TG count, **✔ installed** when already in the codeplug, **ⓘ approx** when the position is geocoded from city rather than reported [S §3, §10]. Expanded view: city, status/last-seen, all talkgroups with slot and name, per-TG checkboxes (defaults below), "Open in map", "Hide this repeater".
- **Preview strip** recomputes on every tick: exactly what will be written, plus warnings ("2 repeaters have no timeslot info — TS1 assumed", "TG list for W9ABC has 41 TGs — first 32 programmed").
- **Install** → progress dialog (the `ProgressDialogHolder` pattern, copied verbatim [I §6.1]) → summary sheet: "Added 9 channels in 4 zones … [Undo] [Open channel list]". Undo removes only what this run created (tracked in `dmrmod_repeaters.db.installed`).
- **Settings gear** (top-right): callsign (defaults from `APRSDatabase.getCallsign()` [I §7]), naming template, default TG selection policy, channels-per-repeater cap, "Connect RepeaterBook account" (v4), catalog TTLs, clear cache.

### 2.3 Defaults that make the first install good
- DMR repeater → one channel per **static** talkgroup on its slot, plus a "TS1 Local 9" and "TS2 Local 9" pair *off* by default; cap 8 channels per repeater (configurable), most-common TGs first (ordering: BM `/talkgroup` name known > lower TG number).
- FM repeater → exactly one channel; TX tone from `PL` / hearham `encode`; RX tone only if published; wide (25 kHz) unless the source says narrow.
- Zone per DMR repeater named `CALL City` (trimmed), one shared zone "FM ≤50 km" for analog; both prefixed with a discreet `»` so directory-made zones are recognisable and sortable.
- Names: template `{call} {tg}` → e.g. `W9ABC 3100`, `W9ABC TAC310`; FM: `{call} {city}`; hard-trimmed to the OEM's channel-name width (verify the editor's `maxLength` — to-do P1.3).

---

## 3. Data sources and how they combine

Verdicts from the research [S §9–10]:

| Role | Source | Why | Auth / limits |
|---|---|---|---|
| **DMR backbone** | BrandMeister v2 `GET /device?repeater=true` (≈1 MB, 3.6 k repeaters, 87 % with lat/lng), `/device/{id}/talkgroup` (static TGs + slot), `/device/{id}/profile` (timed/dynamic), `/talkgroup` (1.8 k names) [S §2] | Live status, exact RX/TX/CC, TG↔slot, names — maps 1:1 onto `ChannelData` | none for reads; 60 req/min; `/device` ≤ 1 per 15 min |
| **Cross-network DMR + TG tables** | RadioID `static/rptrs.json` (5.8 MB nightly, 11 k repeaters, 4.7 k with `talkgroups[]` incl. timeslot, `ipsc_network`) [S §3] | Only source of sysop-declared TG/TS for DMR+, DMR-MARC, c-Bridges; the app already ingests RadioID | none; "no mirroring/re-publishing" — per-user cache only |
| **Analog FM + coordinates** | hearham `GET /api/repeaters/v1` (9.5 MB, 22.6 k, coords, tones, `operational`) [S §5] | Zero-friction worldwide FM; also the geo-index for RadioID by callsign | none; "free to use in your application" (no formal licence — confirm) |
| **Opt-in enhancer** (NA FM accuracy, `Precise` coords) | RepeaterBook `export.php?state_id=` / `exportROW.php?country=` [S §1] | Best curated FM/tone data, but requires an approved app **and a per-user `rbuapp_` token**, no radius query, "minimum cache", mandatory attribution | user pastes token; unpublished rate limit; session cache only |
| TG name fallback | TGIF JSON list [S §6] | names for TGIF-network TGs | none |

**Merging** (in `RepeaterCatalog`):
1. Key = normalised callsign + RX frequency (±2.5 kHz). Same key from several sources → one record; field precedence **DMR: BM > RadioID > RepeaterBook > hearham; FM: RepeaterBook > hearham** [S §10.7].
2. Coordinates: BM `lat/lng` (if non-zero) > RepeaterBook `Lat/Long` > hearham > **geocode** of RadioID `city,state,country` (Android `Geocoder`, cached in `geocode_cache`, flagged *approx*).
3. Talkgroups: union of BM static (+ timed, marked) and RadioID `talkgroups[]`; slot from whichever has it; names from BM map > RadioID `description` > TGIF.
4. Status: BM `last_seen`/`status` is authoritative for BM repeaters; hearham `operational==0` and RepeaterBook `Operational Status != On-air` drop the record when "on-air only" is set.
5. Every record keeps `sources` (bitmask) and `fetched_at`; the card shows them.

**Caching / TTL** (files under `Download/DMR/Repeaters/`, index in `dmrmod_repeaters.db`): BM device list 24 h (never refetched within 15 min), BM talkgroup map 7 d, BM per-device TGs 24 h (fetched lazily per repeater within the radius, ≤ 60/min → batch with a 1.1 s spacing), RadioID `rptrs.json` 7 d, hearham 30 d, RepeaterBook session-only. Use `If-Modified-Since`/`ETag` where offered. Everything works offline once cached.

**User-Agent**: `DMRModHooks/<ver> (+https://github.com/IIMacGyverII/phonedmrapp; contact@…)` — RadioID and RepeaterBook require a descriptive UA with contact [S §1, §3].

---

## 4. Architecture

New classes, flat in `com.dmrmod.hooks` (project convention), all Android-free except the UI and DB classes so the parsers and mappers run in JUnit:

```
RepeaterModels.java        Repeater{key, callsign, rxHz, txHz, lat, lon, precise, fm, dmr, cc, dmrId, network,
                                    toneUpHz|dcsUp, toneDownHz|dcsDown, bandwidth, status, lastSeen, city, country,
                                    sources, fetchedAt, List<Talkgroup>}   Talkgroup{id, slot(1|2|0=unknown), name, kind}
RepeaterSource.java        interface: id(), name(), attribution(), ttl(), fetch(HttpClient, ProgressSink) → List<Repeater>
BrandMeisterSource.java    /device?repeater=true, lazy /device/{id}/talkgroup + /profile, /talkgroup names
RadioIdRepeaterSource.java rptrs.json → records (no coords), offset parsing ("+5.000"), network normalisation
HearhamSource.java         /api/repeaters/v1 → FM + DMR(CC only); mode/encode/decode normalisation
RepeaterBookSource.java    (v4) export.php / exportROW.php with X-RB-App-Token; state/country from Geocoder
RepeaterCatalog.java       merge/dedupe/geocode; SQLite dmrmod_repeaters.db; radius query (haversine); TTL logic
RepeaterProgrammer.java    Repeater(+selected TGs) → ChannelData/contacts/TG lists/zone/locations; undo; fingerprints
NearbyRepeatersUi.java     the dialog(s); owns filters, selection, preview, progress, summary
GeoUtil.java               haversine, bearing, Maidenhead↔lat/lon, band classification (moved out of MainHook)
ToneMapper.java            Hz/DCS ↔ (type, subCode) using ToneConverter tables; exact "%.1f" formatting [I §1.4]
HttpClient.java            thin HttpURLConnection wrapper: UA, timeouts, gzip, ETag/If-Modified-Since, redirect, progress
```

`MainHook` changes are limited to: the Device-tab button, a `startNearbyRepeaters(Activity)` entry, and exposing `channelFragmentInstance`/zone statics through a small refresh helper [I §1.5].

### 4.1 Database `dmrmod_repeaters.db` (module DB, lands in the OEM package dir like the others [I §7])

```sql
CREATE TABLE repeaters (key TEXT PRIMARY KEY, callsign TEXT, rx_hz INTEGER, tx_hz INTEGER,
  lat REAL, lon REAL, precise INTEGER, approx INTEGER, fm INTEGER, dmr INTEGER, cc INTEGER,
  dmr_id INTEGER, network TEXT, tone_up TEXT, tone_down TEXT, bandwidth INTEGER, status TEXT,
  last_seen TEXT, city TEXT, region TEXT, country TEXT, sources INTEGER, fetched_at INTEGER,
  hidden INTEGER DEFAULT 0);
CREATE INDEX idx_rep_geo ON repeaters(lat, lon);
CREATE TABLE repeater_talkgroups (key TEXT, tg INTEGER, slot INTEGER, name TEXT, kind TEXT, source TEXT,
  PRIMARY KEY (key, tg, slot));
CREATE TABLE talkgroup_names (tg INTEGER PRIMARY KEY, name TEXT, source TEXT);
CREATE TABLE source_cache (source TEXT PRIMARY KEY, url TEXT, etag TEXT, fetched_at INTEGER, bytes INTEGER, path TEXT);
CREATE TABLE geocode_cache (query TEXT PRIMARY KEY, lat REAL, lon REAL, resolved_at INTEGER);
CREATE TABLE installed (run_id INTEGER, key TEXT, kind TEXT, oem_channel_id INTEGER, zone_id INTEGER,
  tglist_id INTEGER, contact_id INTEGER, fingerprint TEXT, installed_at INTEGER);
```

`installed` is what makes re-runs and undo safe: a fingerprint (`callsign|rx|tx|cc|tg|slot`) per created channel; on a later install the same fingerprint → *update in place* (via `DmrManager.updateChannel(area, cd)` [I §1.2]) instead of a duplicate; undo deletes by `run_id`.

### 4.2 Programming a repeater (`RepeaterProgrammer`)

Follows the OEM editor's own create sequence [I §1.3] exactly; area from `OemChannelTable.areaKey(ctx)` (never the literal `"default"` — that silently falls back to the default area [I §1.2]).

| Step | DMR repeater (per selected TG) | FM repeater |
|---|---|---|
| Contact | `DmrManager.getContact(1, tgId)`; if absent `saveContact(name, type=1, number=tgId)` [I §2] | — |
| TG list | `TGListDatabase.saveTGList("»CALL TSn", csv of that slot's TGs)` (≤ 32 → `getHardwareGroups()`; warn if truncated) [I §3] | — |
| `ChannelData` | `new ChannelData()` via `appClassLoader`; `type 0, rxFreq=out, txFreq=in, power 1, relay 2, cc, inBoundSlot=outBoundSlot=(slot−1), channelMode 4 (double-slot, as the importer does) or 0, contactType 1, txContact=tgId (Pitfall 12), encryptSw 2, encryptKey "", interrupt 2, band 1, sq 2, groups=list.getHardwareGroups(), active 0, name` | `type 1, rxFreq/txFreq, power 1, relay 2, band (1 wide / 0 narrow), sq 2, txType/txSubCode from uplink tone, rxType/rxSubCode from downlink tone or 0/0, interrupt 2, active 0, name` |
| Insert | `DmrManager.createChannel(areaKey, cd)` → `_id` read back from `cd` [I §1.1–1.2] | same |
| Links | `TGListDatabase.assignTGListToChannel(_id, listId)`; `ZoneDatabase.addChannelToZone(zoneId, _id)` (zone created with `getZoneByName`/`saveZone`) [I §3–4]; `LocationDatabase.saveLocation(cd.number, lat, lon)` [I §5]; `installed` row | zone "»FM nearby"; location; `installed` row |
| Refresh | once per run: `DmrManager.updateChannelList()` (done by `createChannel`), reload `currentZoneChannels` if a zone filter is active, post `initData()` on `channelFragmentInstance` [I §1.5] | same |

Rules enforced in code, each with a unit test: frequencies inside the OEM editor's ranges; tone strings formatted `%.1f` before `ToneConverter.parseSubCode` and verified by round-trip (it returns 0 = 62.5 Hz on a miss) [I §1.4]; DCS `Dnnn`/`nnnN`/`nnnI` → type 2/3; never `relay 0`; never > 32 TGs in `groups`; `encryptKey` never null on a digital row; never set `active`; never name a channel `APRS (…)` (the list filter hides those) [I §4.2].

### 4.3 Threading and failure behaviour
- All network and parsing on one `ExecutorService` (single thread); UI only via `runOnUiThread`; every callback wrapped in try/catch with `XposedBridge.log(TAG + …)` (project rules [I §8]).
- Any source failing (401/429/timeout/parse) degrades to "source unavailable — showing cached data from <age>" in the footer; the feature never blocks on one source.
- No location → manual entry; no network and no cache → explain and offer "Download catalog on Wi-Fi".
- Installs run in one pass with a progress bar; a failure mid-run leaves the `installed` rows written so undo can clean up.

---

## 5. Legal / etiquette checklist (ship-blockers are bold)

- **hearham**: obtain a written OK + preferred attribution (no formal licence published) [S §5].
- **RadioID**: confirm a per-user on-device cache of `rptrs.json` is acceptable under "no mirroring / re-publishing"; use the descriptive UA they ask for; never redistribute the file [S §3].
- BrandMeister: no read-API ToS found; e-mail the team describing the ≤ 1/15 min device-list fetch and 24 h cache; never embed a user API key [S §2].
- **RepeaterBook (v4 only)**: apply for distributed-app approval; ship the user-token flow; show "Data courtesy of RepeaterBook.com" with deep links; cache session-only; confirm the non-commercial status of this project [S §1].
- Attribution footer on the main dialog listing every source that contributed to the current list; "About data sources" screen with links.
- The feature is for licensed amateurs; the settings screen says so next to the callsign field (no gate — the radio itself is the gate).

---

## 6. Testing

- **JUnit (no device)**: parsers against saved fixtures (one real response per source, checked into `DMRModHooks/app/src/test/resources/repeaters/`), merge/dedupe cases (same repeater in 3 sources; BM without coords + RadioID + hearham), offset parsing (`"+5.000"`, `-600000`), tone mapping round-trips over the whole CTCSS/DCS tables, haversine/bearing known values, Maidenhead conversion, name trimming, 32-TG truncation, `installed` fingerprint stability.
- **Instrumented/on-device checklist**: install 1 FM + 1 DMR repeater → channel appears in list and in its zone; select it → hardware programs (check `TAG_SerialManager` log for 0x22/0x23 with the right freq/CC/TG); TG list appears in the editor row; distance shows on the intercom; re-run → no duplicates; undo → all gone, hand-made channels untouched; airplane mode → cached list still works; a non-default channel area → channels land in that area (`OemChannelTable`).
- Verify before P1: the OEM process actually holds `INTERNET` and `ACCESS_FINE_LOCATION` at runtime (`adb shell dumpsys package com.pri.prizeinterphone | grep -A2 permission`) — the decompiled manifest lists neither, though the RadioID download works today [I §8].

---

## 7. Phased plan and to-do list

Effort: S < ½ day · M 1–2 days · L 3–5 days. Order within a phase is the recommended order.

### Phase 0 — Spike (prove the loop, no writes) · ~M
- [ ] P0.1 `HttpClient` (UA, timeouts, gzip, ETag, redirects, progress) — S
- [ ] P0.2 `BrandMeisterSource.fetchDeviceList()` + JSON fixture + unit test — S
- [ ] P0.3 `GeoUtil` (haversine, bearing, band) with tests; move `calculateDistance`/`calculateBearing`/`getDirectionArrow` out of `MainHook` — S
- [ ] P0.4 Device-tab button + minimal dialog: location row (last-known fix) + radius chips + distance-sorted list of BM repeaters — M
- [ ] P0.5 Confirm runtime permissions in the OEM process (`dumpsys`) and one-shot fresh GPS fix with timeout — S
- **Exit:** nearby BM repeaters listed with distance on the radio, offline after first fetch.

### Phase 1 — Install DMR (BrandMeister only) · ~L
- [ ] P1.1 `dmrmod_repeaters.db` schema + `RepeaterCatalog` (cache, TTL, radius query) — M
- [ ] P1.2 BM `/device/{id}/talkgroup` + `/profile` lazy fetch with 60/min pacing; `/talkgroup` name map — S
- [ ] P1.3 Verify OEM channel-name max length (editor `maxLength` / DB) and set the trim rule — S
- [ ] P1.4 `ToneMapper` + `RepeaterProgrammer` (DMR path): contacts, TG list, `ChannelData`, `createChannel`, zone, location, `installed` rows; unit tests for the field recipe — M
- [ ] P1.5 Expanded card with TG checkboxes; live preview strip; install progress + summary; **undo** — M
- [ ] P1.6 Post-install refresh (`updateChannelList`, zone cache, `initData`) and on-device checklist — S
- **Exit:** a BM repeater with N TGs becomes N channels in a zone, selectable and transmitting, undoable.

### Phase 2 — Comprehensive catalog · ~L
- [ ] P2.1 `RadioIdRepeaterSource` (rptrs.json, offset/network normalisation, `talkgroups[]`) + fixture/tests — M
- [ ] P2.2 `HearhamSource` (mode/encode/decode normalisation, Hz units, `operational`) + fixture/tests — S
- [ ] P2.3 Merge/dedupe/precedence in `RepeaterCatalog`; `sources` bitmask; *approx* flag — M
- [ ] P2.4 Geocoding for RadioID-only records (BM id join → hearham callsign join → `Geocoder` city lookup, cached) — S
- [ ] P2.5 FM path in `RepeaterProgrammer` (tones, bandwidth, "»FM nearby" zone) + tests over the full tone tables — S
- [ ] P2.6 Mode/band/on-air/open chips; network badges; TGIF name fallback — S
- [ ] P2.7 Legal: hearham + RadioID + BM contacts sent; attribution footer + "About data sources" — S
- **Exit:** FM and non-BM DMR repeaters appear and install; list works offline; provenance visible.

### Phase 3 — Polish and management · ~M
- [ ] P3.1 Manual location entry (city / Maidenhead / lat,lon) with background `Geocoder`; remembered — S
- [ ] P3.2 Settings gear: callsign, naming template, per-repeater cap, default TG policy, TTLs, clear cache — S
- [ ] P3.3 Re-run semantics: fingerprint match → update in place; "✔ installed" badge; "Hide repeater" — M
- [ ] P3.4 "Manage installed" list: per-run undo, remove all directory-made channels, refresh a repeater's TGs — S
- [ ] P3.5 Warnings: channel-count guidance, >32 TG truncation, unknown timeslot, out-of-range frequency — S
- [ ] P3.6 Log line at install listing area, counts and sources (backlog C2) — S
- **Exit:** feature feels finished; repeatable without side effects.

### Phase 4 — RepeaterBook (opt-in) · ~M, gated on approval
- [ ] P4.1 Apply for distributed-app approval; document the user-token flow (`/user/api_apps.php`) — S (calendar time unknown)
- [ ] P4.2 `RepeaterBookSource`: state/country resolution from location, `export.php`/`exportROW.php`, 401/429 handling with back-off, session-only cache — M
- [ ] P4.3 Settings → "Connect RepeaterBook account" (paste token, test, disconnect); precedence rules for FM fields; "Data courtesy of RepeaterBook.com" + deep links — S
- **Exit:** NA users with a token get curated FM/tone data and `Precise` coordinates.

### Phase 5 — Ship
- [ ] P5.1 `docs/deep-dive/` chapter update for the new classes/DB; `.grok/rules` DB table row; README feature section with screenshots — S
- [ ] P5.2 Release notes; bump version only when asked (release policy) — S

---

## 8. Open decisions (choose before P1)
1. **Double-slot (`channelMode 4`) for every DMR channel** as the importer does, or single-slot with `inBound=outBound=slot`? (Field reports favoured 4 for repeaters — ch. 11 §4.5; keep 4.)
2. **One zone per DMR repeater** (dmrfill/RepeaterBook convention) vs one zone per network. Default: per repeater; setting to switch.
3. **Local TG 9 channels** on by default? Default off; setting.
4. Should installs also write an OpenGD77-style backup afterwards (so the CPS round-trip sees them)? Not needed — export already reads the live DB; note it in the summary sheet instead.

---

## 9. Revision 2 (2026-08-27) — after the Grok review

`docs/grok-deep-dive/07-nearby-repeaters.md` reviewed this design in full and agreed with the source strategy, the additive `createChannel` path and the field recipe. It also found product-level landmines that §1–§8 did not cover. Each was re-checked (`17-grok-review-response.md`) and is adopted below; the earlier sections stay as written and this section overrides them where they conflict.

### 9.1 Prerequisites that move into Phase 0/1

| # | Change | Why |
|---|---|---|
| **P1.0 (new, required)** | Fix the intercom location lookup to key by channel **`_id`** (backlog R5) *before* the first install; `RepeaterProgrammer` then saves `saveLocation(_id, …)`. Do not add a second keying scheme. | The intercom reads `LocationDatabase` by `mCurrentChannelIndex + 1` (`MainHook.java:3188-3192`), which matches `channel_number` only with no deletions and no zone filter. The feature's pitch is "distance on the intercom"; it would show the wrong repeater under a zone filter. |
| **P0.6 (new, gate)** | On-air test with one hand-made GROUP channel (`contactType=1`, `txContact=<local TG>`, slot set) on a nearby BrandMeister repeater: confirm RX audio on a known-busy TG. Record pass/fail here. | The firmware ignores the RX group list (`groups[32]`) and ALL-mode reports `0xFFFFFF` (ch. 07 §5.1). If GROUP+`txContact` receives that TG, each DMR card is a listen-and-talk channel; if not, DMR installs are TX memories and the copy must say so. The card's expanded TG list is "channels that will be created", never "TGs this one channel will hear". |
| **P0.5 (amended)** | `dumpsys package com.pri.prizeinterphone` (not the abandoned rebuild id `com.macgyver.dmr`). | The OEM manifest has `sharedUserId="android.uid.system"` (`decompiled/AndroidManifest.xml:2`), which is why network works without `INTERNET`; runtime location on Android 13 still needs checking. |
| **P1.3 (closed)** | Channel names trim to **32** characters. | `interphone_channel_name_edit` `android:maxLength="32"`. |

### 9.2 Design corrections

| Area | Was | Now |
|---|---|---|
| Area scoping | `installed` had no area column; extras (zones, TG assignments, locations) are global across areas | Add `area_key` to `installed` and include it in the fingerprint (`areaKey\|callsign\|rxHz\|txHz\|cc\|tg\|slot\|type`); zone names namespaced when more than one area is in use; depends on backlog H8 for the extras tables (both areas start `_id` at 1 — integer keys collide) |
| Main list UI | "copy `showReceivedStationsDialog`" (nested `LinearLayout`s in a `ScrollView`) | A `ListView`/`RecyclerView` with a recycling adapter (inside a dialog is fine). A 50 km city search is 80–200 rows with expand + checkboxes; filtering must not rebuild 200 `LinearLayout`s |
| Catalog storage | `Download/DMR/Repeaters/` | **App-private cache** (`context.getCacheDir()`/module subdir), like `dmrmod_radioid.db`. A world-readable `rptrs.json` in Downloads is the "mirroring" RadioID forbids; attribution in the UI is what is owed |
| First-run download | "tap to download (~17 MB)" | **BrandMeister only (1 MB) on any network** for Phases 0–1; RadioID (5.8 MB) + hearham (9.5 MB) wait for Wi-Fi or an explicit "Download full catalog" |
| hearham DMR rows | merged like any other source | hearham DMR has `encode="CC4"` and **no talkgroups**. Rule: DMR channels are created only when a TG table exists (BM/RadioID) for that key; hearham-only DMR → skip DMR (install FM if the row is also FM). **Never** emit a DMR channel with the ctor default `txContact=1` (a private call to DMR ID 1) |
| On-air filter | flag only | BM `status==0` **or** `last_seen` older than 48 h → stale (treat `last_seen` as UTC); drop BM rows with `tx == rx` (429 simplex nodes carry 6-digit ids); RadioID `status` is always `ACTIVE` — ignore it |
| Mixed-mode / GMRS | one card, one install | A key that is both FM and DMR yields **two installables** (one FM channel + N DMR channels). GMRS/FRS (462–467 MHz) and anything outside 136–174 / 400–480 MHz are shown, badged, and **not installable** by default (GMRS is a separate licence); 220 MHz explicitly excluded |
| Channel-count honesty | preview counts | Preview also shows "you have N channels in this area; this adds M"; confirm when M > 40 or N+M > 200; warn that OpenGD77 `Zones.csv` keeps only 80 channels per zone (runtime zones are unbounded) |
| Coordinates for RadioID-only rows | geocode at fetch | Lazy, only for rows inside the current radius: BM id join → hearham callsign join → **Maidenhead locator parsed from BM `city` / RadioID `map_info`** (e.g. `"Banff, IO87QP"`) → Android `Geocoder`, cached. Maidenhead converter moves into P0.3 |
| Frequency parsing | implicit | BM values may be JSON numbers (`439.7125`), RadioID strings (`"440.58750"`), hearham Hz ints. Always `Math.round(mhz * 1e6)`; reject 0/negative; unit tests for `"+5.000"`, `-600000`, `439.7125` → `439712500` |
| Hardware programming | implied "live after install" | New rows stay `active=0`; nothing is programmed until the user selects a channel. Summary copy: *"Added 9 channels in 4 zones. They are not live yet — open the channel list (or the new zone) and tap one."* Never `syncChannelInfoWithData` on new rows |
| Prefix ban | `APRS (` only | Never name a channel with `APRS (`, `SSTV (`, `NOAA (` or `VFO` prefixes (crash recovery keys on them) |
| `»FM nearby` zone | radius in name | Stable name `»FM nearby`; membership is whatever the last install added (fingerprint updates in place) |
| User-Agent | `contact@…` placeholder | One constant with a real address before the first fetch |
| Bandwidth | "from source, default wide" | Explicit: never call `MainHook.determineBand()` (it writes UHF/VHF into the bandwidth byte — backlog R1); unit test 146.94 FM → `band==1`, 446.0 FM wide → `band==1`, 12.5 kHz source → `band==0` |

### 9.3 Undo semantics (were implicit)

| Object | On undo |
|---|---|
| Channel this run created | `DmrManager.deleteChannel(area, cd)` |
| Zone this run created, now empty | delete |
| Zone this run created that still holds other runs' channels | leave |
| TG list this run created, unreferenced | delete |
| Contact this run **created** (`installed.contact_created = 1`) | delete |
| Contact that already existed | leave |
| Location rows for those `_id`s | delete |
| `installed` rows for `run_id` | delete |

Re-run with the same fingerprint → `updateChannel(area, cd)` in place (incl. location refresh).

### 9.4 To-do delta

- Phase 0: **P0.3** includes Maidenhead; **P0.5** dumps `com.pri.prizeinterphone`; **P0.6** on-air GROUP-RX test (gate).
- Phase 1: **P1.0** location-by-`_id` (R5) first; **P1.3** closed (32 chars); **P1.4** fingerprint includes `areaKey`, contacts carry created-vs-reused, no `syncChannelInfo`; **P1.5** real list adapter + "not live until you tap" summary; **P1.7 (new)** channel-count confirm.
- Phase 2: **P2.1** RadioID into private cache, Wi-Fi by default; **P2.2** hearham only after written OK; **P2.2b (new)** skip hearham DMR without TGs, split mixed-mode, GMRS off by default; **P2.8 (new)** cellular stays BM-only unless opted in.
- Phase 3: **P3.7 (new)** "About RX on this radio" help: one channel per TG; ALL-mode not offered.
- Phase 5: README carries the P0.6 result sentence.

### 9.5 Open decisions (updated)

| # | Decision | Position |
|---|---|---|
| 1–4 | as in §8 | unchanged (keep `channelMode 4`, zone per repeater, Local 9 off, no extra backup) |
| 5 | Location key | **`_id`**, and fix the intercom first (R5) |
| 6 | Catalog on cellular | **BrandMeister only** |
| 7 | GROUP RX | **Measure in P0.6**; copy depends on it |
| 8 | hearham DMR without TGs | **Do not install as DMR** |
