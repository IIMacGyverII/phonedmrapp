> **Status (2026-10-14):** recovered from the other-computer backup (written 2026-06-16, never committed). Superseded by the fuller design in `docs/deep-dive/16-repeater-directory-import.md` and its two research memos; kept for the RepeaterBook policy/API notes and the original MVP scoping.

# Repeater Lookup & Auto-Channel Configuration — Design Plan

**Status:** Planning  
**Target module:** DMRModHooks  
**Date:** June 16, 2026  
**Related patterns:** `RadioidDatabase.java`, `DirectDatabaseImporter.java`, `ZoneDatabase.java`, `TGListDatabase.java`

---

## Goal

Let the user find nearby repeaters (DMR first, analog later), preview them, and **provision channels** into the OEM codeplug — contacts, TG list, zone assignment, and correct PriInterPhone field values (double-slot, squelch 2, relay 2, etc.) — without hand-editing every channel.

---

## Data Sources (Researched)

| Source | Auth | DMR fields | Geo search | Best for | Main drawback |
|--------|------|------------|------------|----------|---------------|
| **BrandMeister `/v2/device`** | None (public JSON) | ID, CC, RX/TX, city, lat/lng | Client-side radius filter | **DMR MVP** — BM repeaters/hotspots worldwide | Huge list (~100k+ devices); no timeslot/TG; many entries are hotspots/simplex |
| **RepeaterBook Export API** | **Approval + per-user token** (`rbuapp_…`) as of Mar 2026 | DMR ID, CC, analog tones, mode | Query by state/country/callsign — **not native lat/radius** | NA/global analog + DMR; richest metadata | Must apply for distributed-app approval; policy discourages standalone “repeater finder” UIs but **encourages radio-programming tools** |
| **RepeaterBook Connect** (Android ContentProvider) | User needs **RepeaterBook app + paid Connect subscription** | `DMRID`, `DMR_Text`, `DMRNetwork`, lat/lng, distance | Built-in (pass lat/lng in `selectionArgs`) | Users who already pay for RB; offline after sync | Paid dependency; not everyone has the app |
| **RFinder** | No public API | Mixed | App-only route/nearby search | — | **No free API**; defer unless licensed/partnered |
| **Regional society CSVs** (UK, WIA AU, etc.) | Varies | Often analog-only | — | Regional supplements | Fragmented schemas; some sites block bots |
| **RepeaterBook → OpenGD77 CSV** (existing path) | User export | Full | User picks in RB/CPS | Zero new code for data fetch | Manual multi-step; not “lookup in app” |
| **Manual CSV drop** (`Download/DMR/Repeaters/`) | None | User-defined | User-defined | Fallback / power users | User must find/build file |

### Policy notes (RepeaterBook, effective March 2026)

- Export API requires approved token; legacy open access is gone.
- **More likely approved:** codeplug / channel-management / radio-programming tools (DMRModHooks fits this).
- **Less likely approved:** public repeater maps, standalone nearby-finder products, bulk redistribution.
- Distributed apps use **per-user** tokens from [repeaterbook.com/user/api_apps.php](https://www.repeaterbook.com/user/api_apps.php) — never embed a shared `app_` token in the APK.
- Attribution required: **“Data courtesy of RepeaterBook.com.”**
- API docs: [repeaterbook.com/wiki/doku.php?id=api](https://www.repeaterbook.com/wiki/doku.php?id=api)
- Connect provider docs: [github.com/zbm2/RepeaterBookConnect](https://github.com/zbm2/RepeaterBookConnect)

---

## Recommended Strategy: Two-Track

```
Phase 1 (MVP)     BrandMeister device JSON  →  local cache  →  GPS radius filter  →  channel provisioner
Phase 2           RepeaterBook API (user token)  →  same provisioner (DMR + analog)
Phase 3 (opt.)    RepeaterBook Connect ContentProvider
Phase 4           Manual CSV + regional importers + stale-channel refresh
```

**Phase 1 rationale:** BrandMeister is free, DMR-native, and proven (see [motobm/zone.py](https://github.com/yl3im/motobm) using `https://api.brandmeister.network/v2/device`).

**Phase 2 rationale:** RepeaterBook is the richest source for NA analog + DMR metadata; apply as a distributed radio-programming client.

---

## BrandMeister API (MVP Data Model)

**Endpoint:**

```
GET https://api.brandmeister.network/v2/device
→ JSON array of devices
```

**Typical fields** (from motobm and BM network tooling):

| BM field | Use |
|----------|-----|
| `id` | 6-digit DMR repeater ID |
| `rx` / `tx` | Frequencies as strings in MHz |
| `colorcode` | `channel_cc` |
| `callsign`, `city` | Channel name |
| `lat`, `lng` | Distance filter + `LocationDatabase` |
| `last_seen` | Staleness indicator in UI |
| `pep` | Optional “has power” filter |

**Frequency mapping (critical):** In the BM device list, `rx` is the repeater **input** (what the mobile **transmits** on) and `tx` is the repeater **output** (what the mobile **receives** on). This matches motobm’s Motorola CPS mapping and must be verified against one known repeater before shipping.

| BM field | PriInterPhone column |
|----------|----------------------|
| `tx` (output) | `channel_rxFreq` |
| `rx` (input) | `channel_txFreq` |

**Not provided by BM:** timeslot, talkgroup, contact name → use configurable defaults (see Open Decisions).

---

## RepeaterBook Export API (Phase 2)

**Endpoints:**

- NA: `https://www.repeaterbook.com/api/export.php`
- ROW: `https://www.repeaterbook.com/api/exportROW.php`

**Query params:** `state_id`, `country`, `callsign`, `city`, `frequency`, `mode`, etc.

**DMR-relevant export fields:** DMR Capable, DMR ID, DMR Color Code, frequency, input frequency, PL/CTCSS, operating mode, callsign, city, state, notes.

**Integration model:** Same as RadioID — user-supplied `rbuapp_` token in Device tab settings, stored in module SharedPreferences. Required headers:

```
X-RB-App-Token: rbuapp_...
User-Agent: DMRModHooks/3.5.0 (+https://github.com/IIMacGyverII/phonedmrapp; contact@...)
```

Download by state/country → cache in `dmrmod_repeaters.db` → client-side distance filter (geocode from city/state if lat/lng absent).

---

## RepeaterBook Connect (Phase 3, Optional)

**Content URI:** `content://com.zbm2.repeaterbook.RBContentProvider/repeaters`

**Prerequisites:** RepeaterBook Android app installed + active Connect subscription.

**Android 11+ manifest** (in DMRModHooks module):

```xml
<queries>
    <package android:name="com.zbm2.repeaterbook" />
</queries>
```

**Query:** Pass `selectionArgs = { latitude, longitude }` for location-based results; filtering/sorting otherwise follows user’s RepeaterBook app settings.

**Useful columns:** `Call`, `RX`, `TX`, `CTCSS`, `Lat`, `Lng`, `DMRID`, `DMR_Text`, `DMRNetwork`, `Distance`, `Location`, `State`, `Country`.

---

## Channel Mapping (Repeater → PriInterPhone DB)

Reuse patterns from `DirectDatabaseImporter.java` and v3.4.5 import fixes.

### Digital (DMR repeater)

| Repeater field | OEM column | Rule |
|----------------|------------|------|
| Output freq (listen) | `channel_rxFreq` | Hz = MHz × 1e6 |
| Input freq (talk) | `channel_txFreq` | Hz |
| Color code | `channel_cc` | 1–15 |
| Timeslot | `channel_inBoundSlot` / `channel_outBoundSlot` | See Open Decisions |
| Mode | `channel_mode` | **4** (double slot) — required for RX/tune |
| Squelch | `channel_sq` | **2** |
| Relay | `channel_relay` | **2** (normal) |
| Interrupt | `channel_interrupt` | **2** (digital) |
| Type | `channel_type` | `"0"` |
| TX contact | `channel_txContact` | **TG DMR ID** (e.g. 9) — stores `contact_number`, **not** row `_id` (Pitfall 12) |
| Contact type | `channel_contactType` | `1` (group) |
| Band | `channel_band` | VHF 136–174 MHz → 1, else 0 |
| Groups | `channel_groups` | From `TGListDatabase` / default BM TG list |
| Name | `channel_name` | e.g. `W1ABC BM` or `W1ABC TS1` |

**Also create (if missing):**

1. Group contact for default talkgroup (e.g. `TG9 Local` → ID 9)
2. Optional per-repeater contact using repeater DMR ID
3. Zone (e.g. `Repeaters 50km`) with channel `_id` list
4. Location row in `LocationDatabase` (lat/lng per channel number)

### Analog (Phase 2 / RepeaterBook)

| Field | Mapping |
|-------|---------|
| RX/TX | From RB frequency + input frequency |
| Tones | `ToneConverter` (existing in importer) |
| Type | `channel_type` = `"1"` |
| `channel_interrupt` | `0` |
| Squelch | Default **2** when empty/0 |

---

## Architecture

New classes in `com.dmrmod.hooks` (flat package, same style as `RadioidDatabase.java`):

| Class | Responsibility |
|-------|----------------|
| `RepeaterCacheDatabase` | `dmrmod_repeaters.db` — cached BM/RB rows, sync metadata, source tag |
| `BrandmeisterRepeaterSource` | Download `v2/device`, parse JSON, upsert cache |
| `RepeaterBookApiSource` | Token-authenticated export fetch (Phase 2) |
| `RepeaterBookConnectSource` | ContentProvider query (Phase 3) |
| `RepeaterGeoFilter` | Haversine distance, band filter (VHF/UHF), dedupe |
| `RepeaterChannelProvisioner` | Build `ContentValues`, insert contacts/channels/zones/TG assignments |
| `RepeaterLookupDialog` | UI: search radius, band, preview list, multi-select, import |

**Post-import:** Call `DmrManager.updateChannelList()` (same pattern as `DirectDatabaseImporter.refreshChannelList()`).

**UI placement:** Device tab, below RadioID block:

- `📡 Download BM Repeater List` (Wi‑Fi; large JSON)
- `🔍 Find Nearby Repeaters` → list dialog
- `✅ Import Selected as Channels` → provision + zone
- Settings: default TG, max channels, radius km, RepeaterBook token (Phase 2)

**On-disk artifacts:**

```
/sdcard/Download/DMR/Repeaters/
  BM.json              # cached BrandMeister dump
  RB_*.json            # cached RepeaterBook exports (Phase 2)
  manual/*.csv         # user-supplied fallback (Phase 4)
```

---

## Phased Delivery

### Phase 1 — BrandMeister nearby DMR (target: v3.5.0)

**Scope:**

- Download/cache BM device JSON + SQLite cache
- GPS or manual lat/lng + radius (25 / 50 / 100 km)
- Filter: UHF (`tx` starts with `4`) / VHF (`1`), has coordinates, optional 6-digit ID only, dedupe by (rx, tx, callsign)
- Preview: callsign, city, distance, CC, last seen, stale warning (>30 days)
- Import selected → digital channels with v3.4.5 defaults + auto zone
- Attribution: “Repeater data via BrandMeister Network”

**Effort:** ~1–2 sessions  
**Risk:** Low — public API, no approval

### Phase 2 — RepeaterBook API token path

**Scope:**

- Apply to RepeaterBook for DMRModHooks distributed-app approval
- User token field + `X-RB-App-Token` + proper `User-Agent`
- State/country download → cache → distance filter
- DMR + analog channel provisioning
- Attribution: “Data courtesy of RepeaterBook.com”

**Effort:** ~1 session code + approval wait  
**Risk:** Medium — policy may impose scope limits

### Phase 3 — RepeaterBook Connect (optional)

**Scope:**

- Detect RB app installed
- Query ContentProvider with phone GPS
- Import DMR/analog from user's RB-curated list

**Effort:** ~0.5 session  
**Risk:** Low technically; limited audience (paid RB Connect)

### Phase 4 — Polish

- Manual repeater CSV import (`Download/DMR/Repeaters/*.csv`)
- “Update stale channels” (refresh freqs/CC by callsign match)
- OpenGD77 round-trip export of imported repeaters
- Per-network TG presets (BM TG9, TG91, DMR-MARC, etc.)

---

## UX Flow (MVP)

```
User → Find Nearby (50 km UHF)
  → Query RepeaterCacheDatabase in radius
  → If cache empty/stale: download BM v2/device, upsert cache
  → Show filtered list (distance, CC, last_seen)
User → Select repeaters → Import
  → RepeaterChannelProvisioner:
       - create contacts (TG + optional repeater ID)
       - insert channels (OEM DB)
       - create zone + TG list assignments
       - write LocationDatabase rows
  → DmrManager.updateChannelList()
  → Toast: "Imported N channels into zone 'Nearby BM UHF'"
```

---

## Project Constraints & Pitfalls

| Constraint | Impact on design |
|------------|------------------|
| `channel_txContact` = DMR ID, not `_id` | Auto-create group contacts before channels (Pitfall 12) |
| `channel_mode=4` required for RX | Always set on digital import (v3.4.5 fix) |
| `channel_groups` max 32 slots | One TG list per channel; don’t overload |
| Firmware ignores RX group list | Not a blocker for TX-to-repeater use case |
| RepeaterBook policy | Frame as **programming workflow**, not a repeater directory app |
| Channel count | BM dump is huge — **never import all**; cap preview (e.g. 64) + warn |
| BM freq field naming | Verify RX/TX mapping against one known repeater before shipping |
| LSPosed deploy | Reboot after install (`install.ps1`) |

---

## Open Decisions

These need user input before implementation:

1. **Default talkgroup** — BM local **TG 9** only, or user picks per import (TG9 / TG91 / TG3100)?
2. **Duplex repeaters** — One channel (TS1 default) or two channels (TS1 + TS2) like motobm?
3. **Hotspots / simplex** (`rx == tx`) — Include or filter out for MVP?
4. **Analog repeaters** — Wait for RepeaterBook Phase 2, or skip analog entirely?
5. **Zone naming** — Single rolling zone (`Nearby BM UHF`) or dated zones (`BM 2026-06-16 50km`)?

---

## Reference Implementations

| Project | Relevance |
|---------|-----------|
| [yl3im/motobm](https://github.com/yl3im/motobm) | BM device download, GPS radius filter, zone XML generation |
| [desertblade/OpenGD77-Repeaterbook](https://github.com/desertblade/OpenGD77-Repeaterbook) | RepeaterBook → OpenGD77 CSV + zones |
| [zbm2/RepeaterBookConnect](https://github.com/zbm2/RepeaterBookConnect) | Android ContentProvider integration |
| `DMRModHooks/RadioidDatabase.java` | Download/cache/import UI pattern to mirror |
| `DMRModHooks/DirectDatabaseImporter.java` | Channel field defaults, `refreshChannelList()` |

---

## Suggested Next Step

Start **Phase 1 (BrandMeister)** — no third-party approval, DMR-specific, reuses the RadioID “download → cache DB → provision SQLite → refresh channel list” pattern.

Resolve the five Open Decisions above, then implement as **v3.5.0**.