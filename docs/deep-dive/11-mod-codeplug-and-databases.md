# 11 — Codeplug Backup/Restore, Module Databases, PDF Export, Diagnostic Dump

**Scope.** How DMRModHooks (`com.dmrmod.hooks`, v3.4.6) serialises the PriInterPhone codeplug to OpenGD77-style CSV and back, the six SQLite databases the module owns, how zones and TG lists map onto the OEM `channel_groups` column, the PDF summary, the (dead) legacy CSV pair + `BackupActivity`, the diagnostic dump, and the round-trip contract with the OpenGD77 CPS fork.

**Summary of the mechanism.** The module runs *inside* the `com.pri.prizeinterphone` process. Export (`DirectDatabaseExporter`) opens the OEM SQLite files read-only via `context.getDatabasePath(...)`, joins them with the module's own `dmrmod_*.db` tables, and writes five CRLF CSVs + a PDF + a zip into `/sdcard/Download/DMR/DMR_Backups/<yyyyMMdd_HHmmss>/`. Import (`DirectDatabaseImporter`) is **wipe-and-insert, not upsert**: it deletes the OEM contact and channel tables inside a transaction, re-inserts rows from CSV (preserving `_id` when the 37-column Android header is present), then rebuilds zones/TG-list assignments/locations/APRS flags in the module DBs. The 32-slot `channel_groups` string that the firmware receives on channel activation is computed from `TGListDatabase.TGList.getHardwareGroups()` both at import time and every time the OEM channel editor saves.

> Citation shorthand used below: `EXP` = `DMRModHooks/app/src/main/java/com/dmrmod/hooks/DirectDatabaseExporter.java`, `IMP` = `.../DirectDatabaseImporter.java`, `MH` = `.../MainHook.java`, `OEM/` = `app/src/main/java/com/pri/prizeinterphone/`. All other module files are under `DMRModHooks/app/src/main/java/com/dmrmod/hooks/`.

## Source files

| File | Lines | Role | Status |
|---|---|---|---|
| `DirectDatabaseExporter.java` (EXP) | 976 | Active export: 5 CSVs + PDF + zip | **Active** — wired to LOCAL-tab button `MH:4113` |
| `DirectDatabaseImporter.java` (IMP) | 1944 | Active import: folder picker dialog, ordered import, wipe+insert | **Active** — `MH:4146` |
| `CSVExporter.java` | 510 | Legacy 25-col export via `su` copy of DB | Legacy; only caller is `BackupActivity` |
| `CSVImporter.java` | 580 | Legacy import via `openOrCreateDatabase` in *caller's* package | Legacy; effectively a no-op against the OEM DB (see §5) |
| `BackupActivity.java` | 527 | Standalone module Activity (export/import/log) | Declared `exported="true"` in `DMRModHooks/app/src/main/AndroidManifest.xml:36-41`; **no in-app entry point** (`openBackupActivity` `MH:9623` has zero callers) |
| `PDFExporter.java` | 611 | `Backup_Summary.pdf` via `android.graphics.pdf.PdfDocument` | Active — called from `EXP:178` |
| `ZoneDatabase.java` | 475 | `dmrmod_zones.db` | Active |
| `TGListDatabase.java` | 385 | `dmrmod_tglists.db` | Active |
| `LocationDatabase.java` | 144 | `dmrmod_locations.db` | Active |
| `APRSDatabase.java` | 307 | `dmrmod_aprs.db` + `dmrmod_aprs_global` prefs | Active |
| `APRSReceivedDatabase.java` | 524 | `dmrmod_aprs_received.db` + TXT/GPX auto-export | Active |
| `DiagnosticDatabaseDump.java` | 76 | Logcat dump of channel rows 1/8/9/16 | Only caller `BackupActivity:340` (unreachable in normal use) |
| `ToneConverter.java` | — | CTCSS/DCS ↔ CSV text | Used by EXP/IMP/PDF |
| `MainHook.java` (MH) | ~15k | Buttons (`addButtonToLayout` 4078), zone/TG-list UI (11976–13540), channel-editor save hook (13941–14604), history DB (9414–9570) | Active |
| `OEM/serial/data/DBChannelHelper.java` | 83 | OEM channel table DDL | Reference |
| `OEM/serial/data/DBContactHelper.java` | 44 | OEM contact table DDL | Reference |
| `OEM/serial/data/UtilChannelData.java` | 219 | OEM CRUD; `coverGroupsString`/`coverGroupInt` | Reference |
| `OEM/serial/data/ChannelData.java` | 487 | In-memory model, constructor defaults | Reference |
| `OEM/activity/InterPhoneChannelActivity.java` | — | `saveChannelData()` 637–800 — what the importer must mirror | Reference |
| `OEM/fragment/InterPhoneContactsFragment.java` | — | `saveSelectedData()` 219–235 — origin of Pitfall 12 | Reference |

Sample data: `DMRModHooks/OpenGD77_Backup/20260226_093618/` (full 7-file backup set in the **old 28-column** format), `DMRModHooks/backup_latest_channels.csv`, `verify_channels.csv`, `v0.8.5_Channels.csv`, `v0.8.5_Contacts.csv` (28-col era), `test_zones.csv` (standard 80-channel header, name-only cells).

---

## 1. Module databases

### 1.1 Where the files live (important — contradicts the rules docs)

Every module DB class is a `SQLiteOpenHelper` constructed with `context.getApplicationContext()` (`ZoneDatabase.java:31-43`, `TGListDatabase.java:55-65`, `LocationDatabase.java:28-40`, `APRSDatabase.java:47-60`, `APRSReceivedDatabase.java:47-56`). The `context` handed in is always the **hooked app's** context: the LOCAL-tab buttons pass the OEM `Activity` (`MH:4081`, `MH:4113`), `hookTalkBackFragment` initialises `ZoneDatabase.getInstance(context)` / `TGListDatabase.getInstance(context)` with the OEM fragment's context (`MH:1710-1711`), and the exporter uses the *same* `context` for `context.getDatabasePath("database_channel_area_default_uhf.db")` (`EXP:265`) and `LocationDatabase.getInstance(context)` (`EXP:279`). `dmrmod_history.db` is opened explicitly at `context.getApplicationInfo().dataDir + "/databases/dmrmod_history.db"` (`MH:9422`, `MH:9549`).

Therefore **all module databases sit next to the OEM databases**:

```
/data/data/com.pri.prizeinterphone/databases/      (== /data/user/0/com.pri.prizeinterphone/databases/)
    database_channel_area_default_uhf.db   ← OEM channels
    contact_database.db                    ← OEM contacts
    group_database.db                      ← OEM (unused by mod)
    dmrmod_zones.db  dmrmod_tglists.db  dmrmod_locations.db
    dmrmod_aprs.db   dmrmod_aprs_received.db  dmrmod_history.db  dmrmod_radioid.db
```

The only code that would create DBs under `/data/data/com.dmrmod.hooks/` is the legacy `CSVImporter` when driven by `BackupActivity` (§5). 

> ⚠️ **Doc drift** — `.grok/rules/copilot-instructions.md:537` ("Module's own databases — stored in `com.dmrmod.hooks` data dir") and the diagram at `:1277-1285` (`TG_Lists.csv ──► com.dmrmod.hooks /databases/...`) are wrong for the active code path. Verified on-device with the queries in §9.2.

### 1.2 `dmrmod_zones.db` — `ZoneDatabase` (version 1)

```sql
CREATE TABLE zones (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, channel_list TEXT NOT NULL)
```
(`ZoneDatabase.java:47-51`; `onUpgrade` empty `:55-57`)

| Column | Meaning |
|---|---|
| `id` | Zone PK; `-1` sentinel = "All Channels" in the UI (`MH:11990`) |
| `name` | Display name; **not UNIQUE** (duplicates allowed; `getZoneByName` returns first) |
| `channel_list` | Comma-separated OEM channel **`_id`** values, in zone order (`Zone.getChannelListString()` `:438-445`) |

Key choice: `_id`, not `channel_number`, because `channel_number` is non-unique (class Javadoc `:13-17`). A one-time migration `migrateZonesFromNumberToId()` (`:67-119`, called at startup `MH:1000-1001`) remaps any `channel_number` references to `_id` using the *lowest* `_id` per number (`:150-153`); it cannot distinguish an already-migrated list (heuristic: only rewrites when the mapping changes a value), so on a DB where `_id == channel_number` for all rows it is a no-op.

Public API (`ZoneDatabase`): `getInstance(Context)`, `migrateZonesFromNumberToId(Context)`, `saveZone(Zone)→long` (update if `id>0`, else insert), `getZone(long)`, `getZoneByName(String)`, `getAllZones()` (ORDER BY name ASC), `getChannelsInZone(long)`, `deleteZone(long)`, `clearAllZones()`, `getZoneCount()`, `zoneExists(String)`, `getZoneIdForChannel(int)` (first zone containing it, else −1), `getZoneName(long)`, `removeChannelFromAllZones(int)`, `addChannelToZone(long,int)` (idempotent). Inner `Zone(id,name,List<Integer>)` / `Zone(id,name,String csv)` / `Zone(name,List)`; `getChannelList()` (copy), `getChannelCount()`, `containsChannel(int)`, `getChannelListString()`; parser skips non-numeric and `<=0` entries (`:450-468`).

### 1.3 `dmrmod_tglists.db` — `TGListDatabase` (version 1)

```sql
CREATE TABLE tg_lists (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE, tg_ids TEXT NOT NULL DEFAULT '', description TEXT DEFAULT '')
CREATE TABLE channel_tglist_assignments (channel_id INTEGER PRIMARY KEY, tg_list_id INTEGER NOT NULL)
```
(`TGListDatabase.java:73-84`)

| Table.Column | Meaning |
|---|---|
| `tg_lists.name` | UNIQUE; `saveTGList` inserts with `CONFLICT_REPLACE` (`:201`) — a name collision on *insert* silently replaces the row (and gets a **new** `id`, orphaning assignments) |
| `tg_lists.tg_ids` | Comma-separated DMR TG IDs, unbounded length; parser drops `<=0` (`:163-175`) |
| `tg_lists.description` | Free text, never set by UI (always `""`) |
| `channel_tglist_assignments.channel_id` | OEM channel **`_id`** (PK ⇒ one list per channel) |
| `channel_tglist_assignments.tg_list_id` | FK by convention; no SQLite FK. `deleteTGList` deletes assignments manually (`:271-277`) |

`HARDWARE_MAX_GROUPS = 32` (`:51`). `TGList.getHardwareGroups()` (`:138-144`) returns an `int[32]` with the first ≤32 IDs and zeros elsewhere — this is the array written to `channel_groups` (§2).

Public API: `getInstance`, `saveTGList(TGList)→long`, `saveTGList(String name, String tgIdsRaw)→long` (upsert by name), `getTGList(long)`, `getTGListByName(String)`, `getAllTGLists()` (name ASC), `deleteTGList(long)`, `clearAllTGLists()`, `getTGListCount()`, `tgListExists(String)`, `assignTGListToChannel(int channelId, long tgListId)` (`CONFLICT_REPLACE`), `removeAssignmentForChannel(int)`, `getTGListIdForChannel(int)→long|-1`, `getTGListForChannel(int)`, `getTGListNameForChannel(int)` ("None" if unassigned — the literal exported to CSV), `buildNameMap()`. Inner `TGList`: `getTgIds()`, `size()`, `exceedsHardwareLimit()`, `getHardwareGroups()`, `getTgIdsString()`, `contains(int)`, static `parseTgIds(String)`.

### 1.4 `dmrmod_locations.db` — `LocationDatabase` (version 2)

```sql
CREATE TABLE channel_locations (channel_number INTEGER PRIMARY KEY, latitude REAL, longitude REAL, elevation REAL DEFAULT 0)
```
(`LocationDatabase.java:44-49`; v1→v2 `ALTER TABLE ... ADD COLUMN elevation REAL DEFAULT 0` `:53-59`)

Keyed by **`channel_number`** (not `_id`) — the display index the GPS panel derives as `mCurrentChannelIndex + 1` (`MH:3189`). Consequence: two channels sharing a `channel_number` share a location, and renumbering breaks the link. API: `saveLocation(int,double,double[,double])` (`CONFLICT_REPLACE`), `getLocation(int)→Location|null`, `deleteLocation(int)`, `clearAllLocations()`. `Location{latitude,longitude,elevation}`. `elevation` is never written by the importer; `MH:3372 fetchAndDisplayElevation` fills it at display time.

### 1.5 `dmrmod_aprs.db` — `APRSDatabase` (version 1)

```sql
CREATE TABLE channel_aprs (channel_number INTEGER PRIMARY KEY, enabled INTEGER DEFAULT 0, comment TEXT, symbol_table TEXT DEFAULT '/', symbol_code TEXT DEFAULT '[')
```
(`APRSDatabase.java:64-70`)

Keyed by `channel_number`. Per-channel API: `isEnabled(int)`, `setEnabled(int,boolean)` (insert-ignore then update `:197-211`), `getChannelSettings(int)` (returns defaults if absent), `saveChannelSettings(APRSSettings)`, `deleteChannelSettings(int)`, `clearAllSettings()`. Global settings are **SharedPreferences** `dmrmod_aprs_global` (`:28-34`): `getCallsign/setCallsign` (upper-cased), `getSSID/setSSID` (0–15, throws otherwise), `getDefaultSymbolTable/set…`, `getDefaultSymbolCode/set…`, `getAprsFrequency/set…` (string MHz, default `"144.390"`), `getAprsSquelch/setAprsSquelch` (0–9; also reused as the **software-squelch slider persistence**, `MH:1915-1931`).

### 1.6 `dmrmod_aprs_received.db` — `APRSReceivedDatabase` (version 2)

```sql
CREATE TABLE received_stations (id INTEGER PRIMARY KEY AUTOINCREMENT, callsign TEXT NOT NULL, ssid INTEGER NOT NULL, latitude REAL NOT NULL, longitude REAL NOT NULL, altitude INTEGER, comment TEXT, symbol_table TEXT, symbol_code TEXT, timestamp INTEGER NOT NULL, channel_number INTEGER)
```
(`APRSReceivedDatabase.java:60-73`). `onUpgrade` **drops and recreates** (`:78-81`) — any version bump wipes history. Every packet is a new row (full history, `:139-140`). API: `storeStation(APRSPacket,int)` (also appends `Download/DMR/APRS/<CALL>-<SSID>.txt` and rewrites `<CALL>-<SSID>.gpx`), `getAllStations()`, `getRecentStations()` (last hour), `clearAll()`, `getStationCount()`, `exportToTextFile(...)`, `exportSingleCallsignToGPX(String,int)`, `exportToGPX()` (`aprs_tracks.gpx`). Not part of the codeplug backup.

### 1.7 `dmrmod_history.db` — inline in `MainHook` (no helper class, no version)

```sql
CREATE TABLE IF NOT EXISTS channel_history (id INTEGER PRIMARY KEY AUTOINCREMENT, channel_number INTEGER, dmr_id TEXT, timestamp TEXT, activity_type TEXT, rssi_dbm INTEGER, transcription TEXT, created_at INTEGER)
```
(`MH:9428-9436` and duplicated `MH:9555-9563`; followed by `ALTER TABLE … ADD COLUMN rssi_dbm/transcription` inside try/catch for pre-existing files). Opened with `SQLiteDatabase.openOrCreateDatabase(dbFile, null)` on every read/write (`MH:9425`, `9552`). Keyed by `channel_number`. Not backed up by the CSV export.

### 1.8 `dmrmod_radioid.db`

`RadioidDatabase.DATABASE_NAME = "dmrmod_radioid.db"` (`RadioidDatabase.java:46`), prefs `dmrmod_radioid_prefs`. Covered in another chapter; not part of codeplug backup.

### 1.9 OEM tables the module reads/writes (for reference)

```sql
-- OEM/serial/data/DBChannelHelper.java:67  (file database_<area>.db, table database_<area>; area = channel_area_default_uhf)
create table database_channel_area_default_uhf(_id integer primary key autoincrement, channel_name varchar ,channel_type integer ,channel_number integer ,channel_txFreq integer ,channel_rxFreq integer ,channel_power integer ,channel_cc integer ,channel_inBoundSlot integer ,channel_outBoundSlot integer ,channel_mode integer ,channel_contactType integer ,channel_txContact integer ,channel_encryptSw integer ,channel_encryptKey varchar ,channel_relay integer ,channel_interrupt integer ,channel_band integer ,channel_sq integer ,channel_rxType integer ,channel_rxSubCode integer ,channel_txType integer ,channel_txSubCode integer ,channel_active integer ,channel_groups varchar )
-- OEM/serial/data/DBContactHelper.java:38
create table contact_database(_id integer primary key autoincrement, contact_name varchar ,contact_type integer ,contact_number varchar ,contact_active integer ,contact_icon varchar)
```
`ChannelData()` defaults (`OEM/serial/data/ChannelData.java:83-111`): `type=0, txFreq=rxFreq=401025000, power=1, cc=1, slots=0, channelMode=0, contactType=0, txContact=1, encryptSw=2, encryptKey="", relay=2, interrupt=2, band=0, sq=2, tones 0, active=0, groups=[1,0,…0]`. The mod's constructor hook flips the default `band` to 1/wide (`MH:13955-13960`, v3.4.6).

Pitfall 12 origin: `OEM/fragment/InterPhoneContactsFragment.java:224-230` — `mCurrentSeletedId = Integer.parseInt(contact.getNumber()); currentChannel.setTxContact(mCurrentSeletedId)`. `channel_txContact` therefore holds the **24-bit DMR ID** (`contact_number`), never the contact row `_id`.

### 1.10 Key summary

| DB / table | Key | Why |
|---|---|---|
| `zones.channel_list` | channel `_id` | numbers are non-unique; `_id` survives edits |
| `channel_tglist_assignments.channel_id` | channel `_id` | same |
| `channel_locations`, `channel_aprs`, `channel_history` | `channel_number` | written from UI display index (`mCurrentChannelIndex+1`) |
| OEM `channel_txContact` | DMR ID (`contact_number`) | Pitfall 12 |

The mixed keying is why import must preserve `_id` (zones/TG lists) **and** `channel_number` (locations/APRS) to round-trip cleanly.

---

## 2. Zones & TG-list model → `channel_groups`

### 2.1 Zones
A zone is `name + ordered list of channel _id` (§1.2). Runtime state: `currentZoneId/currentZoneName/currentZoneChannels` statics (`MH:228-230`). `showZoneSelectionDialog` (`MH:11976`) sets them; `hookChannelListFilter` (`MH:12383`) replaces `DeviceAreaListAdapter.getCount/getItem` to show only `_id ∈ currentZoneChannels` (and hides APRS channels, `:12426-12440`); `hookChannelNavigation` (`MH:12166`) hooks `InterPhoneTalkBackFragment.updateChannelId(boolean)` to step within the zone. Zone membership is edited from the channel editor: `hookChannelEditActivity` injects a "Zone" row at index 3 of the editor container (`MH:14032-14175`) whose dialog (`showChannelEditZoneDialog` `MH:13263`) offers None / existing zones (with ✏ rename → `showEditZoneNameDialog` `:13493`) / "Create New Zone…" (`:13455-13476`). On `saveChannelData` (after-hook, `MH:14495-14553`) the channel is removed from all zones and added to the selected one, then `channelFragmentInstance.initData()` is re-invoked to refresh the list.

### 2.2 TG lists → the 32-slot array
OEM model: `ChannelData.groups` is `int[32]` (`ChannelData.java:33,107-110`), persisted as `channel_groups` = comma-joined by `UtilChannelData.coverGroupsString()` (`UtilChannelData.java:97-108`) and parsed by `coverGroupInt()` (`:110-121`, which defaults to `[1,0,…]` and — note — indexes `iArr[i]` for every CSV token, so a string with >32 tokens throws `ArrayIndexOutOfBounds` when the OEM loads the channel). The OEM editor fills it from the "Group List" GridView (`InterPhoneChannelActivity.java:682 setGroups(gridAdapter.getGroupList())`) and the OEM docs call it a bitmap; in practice the mod stores **TG IDs**.

v3.3.6 architecture: no runtime hook of `sendDigitalMessage` is needed because the TG IDs are written into the row itself. Two writers:

1. **Channel editor save** (`MH:14555-14584`): reads `dmrmod_selectedTGListId` (additional instance field set by `showChannelEditTGListDialog` `MH:12986` / editor `:13157`), calls `tgDb.assignTGListToChannel(channelId, id)`, sets `channelData.groups = tgList.getHardwareGroups()` and invokes `DmrManager.getInstance().updateChannel(channelData)` → `UtilChannelData.updateChannel` → `channel_groups` (`UtilChannelData.java:201`). Selecting "None" removes the assignment (`MH:14578`) but leaves `groups` as whatever the OEM grid holds. The grid is kept in sync visually by `refreshGroupGrid(context, activity, hwGroups)` (`MH:12995`, `13160`, `14285`).
2. **Import** (`IMP:935-963`): after inserting a DMR row, if the CSV "TG List" cell names a list that exists in `dmrmod_tglists.db`, it assigns and `UPDATE … SET channel_groups = <32 ids joined>` by `_id` (`IMP:945-955`). Otherwise the row keeps the hard-coded default `"1,0,0,…,0"` (`IMP:721`).

`_part1/_part2` splitting exists only in the CSV (`EXP:666-681`); the DB row stores the full list. `getHardwareGroups()` truncates to 32 on the way to hardware; `exceedsHardwareLimit()` drives the ⚠ label in the editor (`MH:13119-13136`) and a log warning at save (`MH:14573-14575`).

Firmware consumption: the OEM sends `groups[]` in the SET_DIGITAL_INFO packet (cmd 34/0x22; see `InterPhoneChannelActivity.java:762-776` for the ack path) when a channel is activated or `syncChannelInfoWithData()` runs. Packet layout is covered in the serial-protocol chapter.

---

## 3. Export — `DirectDatabaseExporter.exportFromAppContext(Context)`

Entry points: LOCAL tab "📤 EXPORT (OpenGD77)" (`MH:4095-4132`, hooked into `InterPhoneLocalFragment.initView` `MH:3952-3984`) and the legacy unused `addBackupButton` (`MH:8324-8369`). Runs on a background thread; toast on completion (`MH:4118-4126` — the toast text still says `Download/DMR_Backups/`).

### 3.1 Folder, files, encoding, order

| Item | Value | Cite |
|---|---|---|
| Base dir | `Environment.getExternalStoragePublicDirectory(DIRECTORY_DOWNLOADS)/DMR/DMR_Backups` = `/sdcard/Download/DMR/DMR_Backups/` | `EXP:135-136` |
| Migration | old `Download/DMR_Backups/*` moved to new dir on every export | `EXP:55-111` |
| Set folder | `yyyyMMdd_HHmmss` (Locale.US); `mkdirs()` must succeed or export aborts | `EXP:142-148` |
| Files | `Channels.csv`, `Contacts.csv`, `TG_Lists.csv`, `Zones.csv`, `DTMF.csv`, then `Backup_Summary.pdf`, then `DMR_Backup_<ts>.zip` (contains the 6 files) | `EXP:155-159, 178, 187, 219-226` |
| Success | all 5 CSV writers return true; PDF/zip failures are logged but non-fatal | `EXP:168-199` |
| Encoding | `new FileWriter(file)` → platform default (UTF-8 on Android), **no BOM** | `EXP:297` |
| Line endings | explicit `"\r\n"` (CRLF) on every line of every CSV | `EXP:299, 517, 549, 575, 598, 646, 735, 903` |
| Row order | Channels: `ORDER BY channel_number ASC`; Contacts: unordered (cursor order); TG lists / Zones: name ASC | `EXP:275-276, 558`; `TGListDatabase:258`; `ZoneDatabase:253` |
| Quoting | **Channels.csv, Contacts.csv, Zones.csv are never quoted/escaped**; only TG_Lists names go through `escapeCsvField` (`EXP:695-701`). A channel or contact name containing `,` corrupts its row. | |
| Failure | Channels export returns `false` (whole export fails) if the channel DB is missing or has 0 rows (`EXP:268-271, 283-286`); missing contact DB yields a header-only Contacts.csv | |

### 3.2 `Channels.csv` — 37 columns (header `EXP:114-118`)

Source columns read: `EXP:305-330`. Common rules: name empty→`"Channel<N>"` (`:352-354`); frequencies `String.format("\t%.5f", Hz/1e6)` — **TAB-prefixed** so spreadsheets keep trailing zeros (`:357-358`; importer strips `\t` at `IMP:543,549`); `isDigital = "0".equals(channel_type)` (`:361`); relay ∉{0,1,2}→2 (`:366-369`); interrupt forced 2 digital / 0 analog (`:372-377`); bandwidth blank for digital else `band==0 ? "12.5" : "25"` (`:380`).

| # | Header | Digital value | Analogue value | Source |
|---|---|---|---|---|
| 0 | `_id` | row `_id` | same | OEM `_id` |
| 1 | `Channel Number` | `channel_number` | same | OEM |
| 2 | `Channel Name` | `channel_name` (unquoted) | same | OEM |
| 3 | `Channel Type` | `Digital` | `Analogue` (British spelling) | OEM `channel_type` |
| 4 | `Rx Frequency` | `\t443.70000` (MHz, 5 dp) | same | OEM Hz |
| 5 | `Tx Frequency` | `\t448.70000` | same | OEM Hz |
| 6 | `Bandwidth (kHz)` | empty | `12.5` / `25` | OEM `channel_band` (0/1) |
| 7 | `Colour Code` | `channel_cc` | empty | OEM |
| 8 | `Timeslot` | `channel_inBoundSlot + 1` (**1-based**) | empty | OEM (`:399`) |
| 9 | `Contact` | contact name via map keyed by `contact_number`, else `None` | empty | OEM contacts (`:402, 922-975`) |
| 10 | `TG List` | `TGListDatabase.getTGListNameForChannel(_id)` → name or `None` | empty | module |
| 11 | `DMR ID` | `channel_txContact` if >0 else `None` | empty | OEM (`:408`) |
| 12 | `TS1_TA_Tx` | `Off` | empty | hard-coded |
| 13 | `TS2_TA_Tx ID` | `Off` | empty | hard-coded |
| 14 | `RX Tone` | empty | `ToneConverter.toCSVFormat(rxType, rxSubCode)` → `None` / `67.0` / `D023N` / `D023I` | OEM (`:464`) |
| 15 | `TX Tone` | empty | same for tx | OEM (`:467`) |
| 16 | `Squelch` | `Disabled` (always) | `sq==0 ? "Disabled" : (sq*10-5)` → 1→`5`, 2→`15`, … 9→`85` (no `%`) | OEM `channel_sq` (`:416, 471`) |
| 17 | `Power` | `power==0 ? "P1" : "P9"` | same | OEM (`:419, 475`) |
| 18 | `Rx Only` | `No` | `No` | hard-coded |
| 19 | `Zone Skip` | `No` | `No` | hard-coded |
| 20 | `All Skip` | `No` | `No` | hard-coded |
| 21 | `TOT` | `0` | `0` | hard-coded |
| 22 | `VOX` | `Off` | `Off` | hard-coded |
| 23 | `No Beep` | `No` | `No` | hard-coded |
| 24 | `No Eco` | `No` | `No` | hard-coded |
| 25 | `APRS` | `APRSDatabase.isEnabled(channel_number) ? "TX" : "None"` | same | module `dmrmod_aprs.db` (`:430-432, 486-488`) |
| 26 | `Latitude` | `%.6f` from `LocationDatabase.getLocation(channel_number)` else `0.128` | same | module `dmrmod_locations.db` (`:435-444`) |
| 27 | `Longitude` | `%.6f` else `0.008` | same | module |
| 28 | `Use Location` | `No` (always) | `No` | hard-coded (`:439, 443`) |
| 29 | `Encrypt Switch` | `encryptSw==1 ? 1 : 0` (OEM 2/0 → 0) | `0` | OEM (`:450-451, 505`) |
| 30 | `Encrypt Key` | `channel_encryptKey` or empty | empty | OEM |
| 31 | `Relay` | `channel_relay` (1 or 2 after sanity) | same | OEM |
| 32 | `Interrupt` | `2` (forced) | `0` (forced) | derived |
| 33 | `Active` | `channel_active` (0/1) | same | OEM |
| 34 | `Outbound Slot` | `channel_outBoundSlot` (**0-based**, raw) | same | OEM |
| 35 | `Channel Mode` | `channel_mode==4 ? 3 : channel_mode` (OEM double-slot 4 → CPS 3) | same | OEM (`:458, 512`) |
| 36 | `Contact Type` | `channel_contactType` (0/1/2) | same | OEM |

Note the asymmetry: Timeslot is exported 1-based but Outbound Slot 0-based; the CPS fork compensates (`copilot-instructions.md:1332-1341`).

Diagnostic side-effect: for `channel_number ≤ 3, 8, 9, 16` every raw column is logged as `CH<n> ALL_FIELDS:` under tag `DMRModHooks_DirectExport` (`EXP:334-349`) — the practical replacement for `DiagnosticDatabaseDump`.

### 3.3 `Contacts.csv` (`EXP:536-620`)
Header `Contact Name,ID,ID Type,TS Override`. Row `String.format("%s,%d,%s,-", name, contact_number, type)` with `contact_type` 0→`Private`, 1→`Group`, else `All Call` (`:588-593`). Duplicate rows (identical text) are dropped via `HashSet` (`:578-601`). Column names of the table are logged on every export (`:563-570`).

### 3.4 `TG_Lists.csv` (`EXP:636-692`)
Header `TG List Name,Contact1,…,Contact32`. Cells hold **numeric TG IDs** (not contact names). Lists >32 → rows `Name_part1`, `Name_part2`, … each with 32 cells; empty list → name + 32 empty cells; names escaped.

### 3.5 `Zones.csv` (`EXP:710-793`)
Header `Zone Name,Channel1,…,Channel80`. Each zone row: name (unescaped) + up to 80 cells resolved `_id → channel_name` via `buildChannelIdMap` (`:801-838`); unknown `_id` → empty cell + warning; >80 channels silently truncated. With `USE_COMPOUND_KEY_ZONES=true` cells would be `channelNum|rxMHz(5dp)|name` (`buildChannelIdCompoundKeyMap` `:847-893`) — **the exporter flag is `false`** (`EXP:48`).

### 3.6 `DTMF.csv` (`EXP:899-912`)
Header only: `Contact Name,Code`. There is no OEM DTMF source and no importer.

### 3.7 Compound-key option
`EXP:48 USE_COMPOUND_KEY_ZONES = false` vs `IMP:71 USE_COMPOUND_KEY_ZONES = true`. Both files' comments say the flags MUST match. Because the importer only tries the compound map when the cell contains `|` and always falls back to name (`IMP:1501-1517`), the mismatch is benign today, but any exporter flip must be paired. See `docs/COMPOUND_KEY_REVERT_GUIDE.md` (its claim that both are `true` and its line numbers are stale — ⚠️ doc drift).

---

## 4. Import — `DirectDatabaseImporter`

### 4.1 Dialog & folder selection (`IMP:77-248`)
`showImportDialog(Context)` (must be an `Activity`; cast at `:153`) scans `Download/DMR/DMR_Backups/*` for directories containing `Channels.csv` (`:99-109`), sorts newest-first (`:117-128`), formats `yyyyMMdd_HHmmss` names as `MMM dd, yyyy HH:mm:ss` (`:133-150`). The list uses `BackupListAdapter` (`:1834-1943`): each row = display name + red **🗑️** button → confirm → `deleteBackupFolder` (`:1784-1829`, deletes files one level deep, toasts). Tapping a row shows "This will REPLACE all current channels and contacts…" → `performImport` (`:220-231`). (These trash icons are **not** in `BackupActivity`.)

### 4.2 `performImport` order and why (`IMP:253-399`)
1. Pre-flight: ensure `<dataDir>/databases` and `/shared_prefs` exist and write a dummy pref `dmr_import_test` (`:271-312`) — added after "Clear Storage" incidents.
2. **Contacts.csv** (`:315-316`) — first, so channel rows can resolve names → DMR IDs (Pitfall 12).
3. **TG_Lists.csv** (`:319-320`) — before channels, so `TG List` cells resolve to list ids and the TX-contact fallback (v3.4.6) can read the first TG.
4. **Channels.csv** (`:323-324`) — needs 2 and 3.
5. **Zones.csv** (`:327-328`) — needs channel names → new `_id`s.
6. **No DTMF step.** ⚠️ Doc drift: `copilot-instructions.md:1271` claims DTMF is imported.

Result toast matrix (`:331-349`): all OK → "✓ Import successful! … ⚠️ RESTART APP"; contacts fail → "partially successful"; channels fail → no refresh. Post-import directory re-check (`:353-377`). **Automatic refresh is disabled**: `if (false && shouldRefresh) refreshChannelList(context)` (`:386`). `refreshChannelList` (`:1258-1284`) would reflectively call `com.pri.prizeinterphone.manager.DmrManager.getInstance().updateChannelList()` using the app's classloader. ⚠️ The class Javadoc (`IMP:40-42`) still says it calls `getDmrManagerInstance().init()`.

### 4.3 Header detection (`IMP:427-462`) and the BOM failure mode
`parseCSVLine(header)`; then:

| Condition | Flags | minFields | Column base |
|---|---|---|---|
| `fields.length ≥ 29 && fields[0].equalsIgnoreCase("_id")` and `≥ 37` | `hasIdColumn, hasNewFields, hasFlags` | 37 | offset 1, flagOffset 7 |
| `≥ 29 && fields[0]=="_id"` but `< 37` | `hasIdColumn` only ("Android LEGACY") | 29 | offset 1, flagOffset 0 |
| `≥ 28 && fields[0].equals("Channel Number")` (case-sensitive) | `hasNewFields = length ≥ 36`, `hasFlags=false` | 36 / 28 | offset 0, flagOffset 0 |
| anything else | warning "Unknown CSV format", **all flags false, import proceeds** | 28 | offset 0 |

`parseCSVLine` (`:1218-1238`) is a minimal toggle-on-quote parser (does not un-escape `""`). Nothing strips `\uFEFF`.

**Pitfall 16 mechanics (BOM).** A BOM'd header gives `fields[0] = "\uFEFF_id"` → neither branch matches → offset 0 → for every data row `fields[3]` ("Digital"/"Analogue") is parsed as the RX frequency → `NumberFormatException` → row skipped (`:1016-1021`). The table was already emptied at `:468` and, because no exception escapes the loop, `setTransactionSuccessful()` (`:1066`) commits the empty table. `importChannels` returns `true`, the toast says success, the channel list is blank. That is the "silent wipe on header failure".

**Latent column-offset bug for non-`_id` files.** Stock OpenGD77 CSVs (and the repo's own 28-col samples) *do* contain `Rx Only … No Eco` (cols 17–23), yet the "Channel Number" branch sets `hasFlags=false`, so APRS/lat/lon are read from cols 17/18/19 (`Rx Only`, `Zone Skip`, `All Skip`) (`:968, 990-992`) and, for a 36-col file, encrypt/relay/… from cols 21–28 (`VOX`…`Encrypt Switch`) instead of 28–35. Net effect: from any file without `_id`, locations/APRS are silently dropped (the `"No"` cells fail `parseDouble`), `channel_encryptKey` is set to `"No"` (col 22 = No Beep), and every other new-field parse fails over to its default (encrypt 2, relay 2, interrupt forced, active 0 → the `_id=1` fallback). Files written by this exporter or by the CPS fork's `ExportToAndroidCsvFile` always carry `_id`, so the normal round-trip is unaffected. ⚠️ Verify with a real stock-CPS export before relying on the 36-col path.

### 4.4 `importContacts` (`IMP:1105-1213`)
Opens `contact_database.db` `OPEN_READWRITE`, `beginTransaction`, `DELETE` all rows, `DELETE FROM sqlite_sequence WHERE name='contact_database'` (ids restart at 1), then per row (≥4 fields): `contact_name=fields[0]`, `contact_number=Integer.parseInt(fields[1])`, `contact_type` Group→1 / Private→0 / else 2, `contact_active=1`, `contact_icon=""`. A non-numeric ID throws out of the loop → transaction rolled back → returns `false` (whole contacts import fails; channels still proceed with an empty name map). `PRAGMA wal_checkpoint(FULL)` afterwards.

### 4.5 `importChannels` (`IMP:404-1100`) — coercions and defaults
Opens `database_channel_area_default_uhf.db` READWRITE; **`LocationDatabase.clearAllLocations()` runs before the transaction** (`:421-422`) — a later failure leaves locations wiped. Transaction: `DELETE` all channels, reset `sqlite_sequence`, build `contactMap` (name→DMR ID, `:1662-1700`) and `contactTypeMap` (name→type, `:1705-1735`), then per row:

| Target column | Rule | Cite |
|---|---|---|
| `_id` | preserved from col 0 when `hasIdColumn` (zones/TG assignments depend on it) | `:523-526` |
| `channel_number`, `channel_name` | `Integer.parseInt`, trimmed name | `:529-534` |
| `channel_type` | `"Digital"` (case-insens.) → `"0"`, anything else → `"1"` (string; integer affinity converts) | `:538-540` |
| `channel_rxFreq/txFreq` | strip `\t`, `(long)(MHz*1e6)` | `:543-550` |
| `channel_cc` | DMR: empty→1 else int; analog 0 | `:558-560, 608` |
| `channel_inBoundSlot` | DMR: empty→1; `ts-1` (**1→0, 2→1**); analog 0 | `:564-568` |
| `channel_txContact` | DMR: (a) col 11 `DMR ID` numeric >0 → use it; (b) else `getContactId(contactMap, Contact)` (`None`/empty/unknown → 0); (c) else if `TG List` (not empty/`None`/`-`) names an existing non-empty list → its **first TG ID** (`txContactFromTgList=true`); (d) else 0. Analog 0 | `:573-605, 1768-1779` |
| `channel_band` | `parseChannelBandwidth`: DMR→1; empty→1 (wide); numeric ≤12.5→0 else 1; `"narrow"`/`"12.5…"`→0 | `:614-616, 1749-1766` |
| `channel_rxType/rxSubCode/txType/txSubCode` | `ToneConverter.parseType/parseSubCode`; errors → 0 | `:620-634` |
| `channel_sq` | `Normal`→5; empty/`None`/`Disabled`→0; else strip `%`, map ≤10→1, ≤20→2 … ≤80→8, else 9; **then `≤0 → 2`**; parse error → 2 | `:638-680` |
| `channel_power` | `P1–P4`/`Low`→0; `P5–P9`/`+W-`/`-W+`/`Master`/`High`→1; unknown → 1 | `:685-704` |
| `channel_groups` | default `"1,0,…,0"` (32 slots); overwritten by TG list after insert | `:721, 945-955` |
| `channel_encryptSw` | new-fields DMR: CSV 0→**2**, 1→1, out of range→2, parse error→2; analog always 2; legacy 2 | `:738-764, 855-863` |
| `channel_encryptKey` | DMR: CSV col; analog `""`; only `put` when non-empty or DMR (analog → NULL) | `:758, 762, 909-911` |
| `channel_relay` | CSV: **0→2**, any other value preserved unvalidated; parse error / legacy → 2 | `:766-779, 858, 864` |
| `channel_interrupt` | forced `isDMR ? 2 : 0` regardless of CSV | `:781-792` |
| `channel_active` | CSV 0/1 (else 0); **only the first `1` survives**; legacy: DMR 1 / analog 0; if none active after loop → `UPDATE … SET channel_active=1 WHERE _id=1` (fails harmlessly if no `_id=1`) | `:794-813, 868-877, 1031-1063` |
| `channel_outBoundSlot` | CSV 0–1 (else 0) — then **DMR overwritten with inbound slot** | `:815-823, 887` |
| `channel_mode` | CSV 0–10 (else 0); 3→4; then **DMR forced to 4 (double-slot)** (v3.4.5) | `:825-839, 886` |
| `channel_contactType` | CSV 0–3 (else 0); then for DMR with `txContact>0` and type 0: use `contactTypeMap[Contact]` if 0–2, else **1 (Group)** (v3.4.6) | `:841-849, 889-903` |

Insert via `db.insert` (`:921`); `rowId == -1` logged and skipped. Post-insert side tables (outside the OEM transaction semantics but inside the same loop): TG list assignment + `channel_groups` update (`:935-963`); `APRSDatabase.setEnabled(channel_number, true)` when col = `TX`/`On` (`:967-984` — **never cleared before import**, so stale `enabled=1` rows persist); `LocationDatabase.saveLocation(channel_number, lat, lon)` unless within 0.001 of the `0.128/0.008` defaults (`:990-1010`). Per-row `NumberFormatException`/`Exception` → skipped and counted (`:1016-1026`). `setTransactionSuccessful` → `endTransaction` → `PRAGMA wal_checkpoint(FULL)` (`:1066-1084`). The "ensure one active" block is duplicated verbatim (`:1031-1045` and `:1049-1063`).

**Upsert? No.** Channels are matched by nothing: full delete + insert, `_id` from CSV when present. ⚠️ `key-files.md:59` ("upsert channels by name+freq") is wrong.

### 4.6 `importTGLists` (`IMP:1318-1400`)
Optional file. Builds `contact_name→contact_number` map (`:1403-1430`). For each row: strip `_part\d+$` and merge into a `LinkedHashMap` (`:1353-1360`); cells numeric → TG ID, else resolved as contact name (warn if unknown) (`:1362-1374`); `tgListDb.saveTGList(name, csv)` (upsert by name, `:1386`). **Existing lists are not cleared** — lists absent from the CSV survive; stale `channel_tglist_assignments` rows also survive (only replaced per channel when the CSV names a list).

### 4.7 `importZonesInternal` (`IMP:1432-1552`)
Optional file. `zoneDb.clearAllZones()` first (`:1446`); `buildChannelNameMap` (name→`_id`, later duplicate names overwrite earlier, `:1560-1597`); returns `false` (→ "no zones" toast) if the channel table is empty (`:1459-1462`). Cells: compound key if flag && contains `|`, else exact name lookup; unresolved → warning; zone saved only if ≥1 channel resolved (`:1524-1533`).

### 4.8 Post-import refresh
None automatic (see 4.2). The user must restart the app; `DmrManager.getInstance().updateChannelList()` is the OEM method the (disabled) reflection path would call. The OEM's own editor path for comparison: `DmrManager.getInstance().getCurrentDbHelper().updateChannel(channelData); updateChannelList()` on ack (`InterPhoneChannelActivity.java:775-776`), or `syncChannelInfoWithData` for the active channel (`:794`).

### 4.9 Logging / errors
All under tag `DMRModHooks_DirectImport` (`IMP:65`): per-channel "✓ Inserted channel N … (ID: rowId)", coercion notices ("relay=0 … converted"), "✗ Failed to parse numeric field", counts at the end. Toasts only: folder errors (`showError` `:1243-1250`), delete confirmations, and the final result matrix.

---

## 5. Legacy `CSVExporter` / `CSVImporter` and `BackupActivity`

| Aspect | `CSVExporter` / `CSVImporter` (legacy) | `DirectDatabase*` (active) |
|---|---|---|
| Process / DB access | Designed for the **module** process: copies `/data/data/<pkg>/databases/<db>` via `/system_ext/bin/su -c "sh -c 'cat … > /sdcard/dmrmod_temp_<db>'"` then to cache (`CSVExporter.java:36-114`) | Runs in the OEM process; `context.getDatabasePath` (`EXP:265`) |
| Channels header | 25 cols: `…Bandwidth kHz,…,TS2_TA_Tx,…,Ch Scan List,Rx Group List,TX`, no `_id` (`CSVExporter.java:23-27`) | 37 cols (`EXP:114-118`) |
| Values | type `Digital`/`Analog`; freq no TAB; power `Low`/`High`; squelch raw 0–9; tones always blank; `All Skip=All`, `TOT=60`; TG List `None`; DMR ID raw (`:329-426`) | see §3.2 |
| Line endings | `writer.newLine()` (LF) | CRLF |
| Contact map | keyed by `contact_number` (v3.4.1 Pitfall 12 fix, `:295-302`); type 0→`Private` else `Group` | same key |
| Bandwidth | analog `12.5`/`25` (v3.4.6, `:355-360`) | same |
| Import target | `context.openOrCreateDatabase("contact_database.db"/"database_channel_area_default_uhf.db", MODE_PRIVATE)` on the **caller's** context (`CSVImporter.java:204, 315`). `copyDatabaseBack()` (`:112-179`) exists but is **never called** | OEM files directly, transactional |
| Import semantics | contacts: delete-all then insert; channels: **no delete** (`:322-323`) → duplicates on re-import; needs ≥24 fields; `Analog`→1; timeslot−1; `channel_mode` 4 for DMR; **`encryptSw=0`, `relay=0`, `interrupt=0`, `active=1` for every row, `channel_groups=""`** (`:389-414`) — these values are exactly what Pitfall 11 / the importer Javadoc say break activation | §4.5 |
| Reachability | only from `BackupActivity` (`:349-363`, `:441-451`) | LOCAL tab |

`BackupActivity` (`BackupActivity.java`): programmatic UI (title, instructions, Export, Import, status, scrolling log, Close). `onCreate` creates `targetContext = createPackageContext("com.pri.prizeinterphone", CONTEXT_INCLUDE_CODE|CONTEXT_IGNORE_SECURITY)` (`:74`). Export → `DiagnosticDatabaseDump.dumpMultipleChannels(targetContext)` (`:340`) then `CSVExporter.exportChannels/exportContacts(BackupActivity.this, pkg, Download/DMR/DMR_Backups/Channels.csv|Contacts.csv)` — flat files, no timestamp folder (`:346-363`). Import → `CSVImporter.importContacts/importChannels(BackupActivity.this, …)` (`:441-451`) — because the context is the **module's**, the writes land in `/data/data/com.dmrmod.hooks/databases/` and never reach the OEM app. Its own Javadoc says it is unused (`:27-31`); `MH:9623 openBackupActivity` has no callers; it can only be launched by `am start -n com.dmrmod.hooks/.BackupActivity` (manifest `exported="true"`).

**Still needed?** No. Nothing in the active path depends on the three legacy classes; `DiagnosticDatabaseDump` is the only thing that would lose its caller. They are safe to delete or to keep as reference, but should not be documented as "Backup management UI" (⚠️ `key-files.md:15`).

---

## 6. PDF export — `PDFExporter.exportBackupSummary(Context, File backupFolder)`

Library: `android.graphics.pdf.PdfDocument` + `Canvas`/`Paint` (`PDFExporter.java:6-10`). Page = A4 at 72 dpi (595×842), 40 pt margin (`:36-39`). Output `<backupFolder>/Backup_Summary.pdf` (`:71`), then zipped by the exporter. Entry: `EXP:178`.

Pages (`:63-68`):
1. **Title** — "DMR Channel Backup Summary", backup date parsed from folder name (`formatBackupDate` `:558-575`), "Format: OpenGD77 CSV", "Device: Ulefone PriInterPhone DMR Radio".
2. **Channels** (35 rows/page, `:175`) — columns `#`, `Name` (≤18 chars), `Type` (`DMR`/`FM`), `RX→TX Freq` (`%.4f→%.4f`), `Contact/Tones` (DMR: contact name; FM: tone(s) via `ToneConverter`), `CC/TS` (DMR: `cc/channel_outBoundSlot` — raw **0-based** slot), `SQ`, `P` (`L`/`H`) (`:160-262`). Ordered by `channel_number`.
3. **Contacts** — `Name`, `DMR ID`, `Type` (`:292-376`).
4. **Instructions** — CPS download URLs, import/re-import steps, notes, "Power & Squelch Conversion", footer "Generated by DMRModHooks v1.1" (`:381-520`).

Known inaccuracies in the PDF (⚠️ code-vs-behaviour drift): contact map for channel rows is keyed by contact `_id` (`buildContactMapPDF` `:592-599`), not `contact_number` → digital channels show `None` unless `_id` happens to equal the DMR ID (Pitfall 12 not applied here); contact `Type` is inverted (`type==0 ? "Group" : "Private"`, `:339` — OEM 0 = Private); instructions cite `Download/DMR_Backups/` (`:470`), "Contacts are preserved during channel import" (`:485` — they are wiped, §4.4) and "channels will be updated automatically" (`:474` — restart required, §4.2).

---

## 7. Round-trip map with the OpenGD77 CPS fork

CPS-side facts below come from `.grok/rules/copilot-instructions.md:1188-1380`, `.grok/rules/key-files.md:34-81`, and `OpenGD77Fork/RELEASE_NOTES_20260605_v1.3.0.md` / `RELEASE_NOTES_20260607_v2.0.45.md`. The fork's C# source (`C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac`) is **not present on this machine** (checked), so `ChannelsForm.cs`/`CODEBASE_DEEP_DIVE.md` could not be read; statements about CPS internals are as documented in those notes.

### 7.1 Three CPS import paths (`copilot-instructions.md:1213-1227`)
| Path | Method | Handles Android 37-col? |
|---|---|---|
| A | `ChannelsForm.import()` (grid buttons) | No — requires exact 35-col stock header (`SequenceEqual(SZ_EXPORT_HEADER_TEXT)`) |
| **B** | `ChannelsForm.ImportFromCsvFile()` (MainForm batch / F8 backup manager) | **Yes** — detects `_id`, reads all 37 cols incl. lat/lon/UseLocation since fork v1.2.0; v1.3.0 added the pre-import diff (`RELEASE_NOTES_20260605_v1.3.0.md:12-14`) |
| C | `ChannelsCsvImporter.ImportChannelsFromCsv()` | Correct logic, **never called** (dead) |

Static arrays `CsvLatitudes/CsvLongitudes/CsvUseLocations/CsvEncryptKeys` are keyed by `GetMinIndex()` slot, live only in memory/CSV, and are **lost when saving `.g77`** (`:1223-1225`).

### 7.2 Field map (Android DB → CSV → CPS → CSV → Android DB)

| Field | Android DB | → CSV (EXP) | CPS internal (per notes) | → CSV (fork export) | → Android DB (IMP) | Lossy? |
|---|---|---|---|---|---|---|
| `_id` | int | col 0 | stored; used to align | col 0 | preserved | no |
| Type | `channel_type` 0/1 | `Digital`/`Analogue` | enum | same | `Digital`→"0" else "1" | no |
| Rx/Tx freq | Hz | `\t%.5f` MHz | Hz | MHz | `(long)(MHz*1e6)` | no (5 dp = 10 Hz) |
| Bandwidth | `channel_band` 0/1 | `12.5`/`25` (analog) | kHz | same | ≤12.5→0 else 1; empty→1 | no |
| Colour code | `channel_cc` | int | int | int | int (empty→1) | no |
| Timeslot | `channel_inBoundSlot` 0/1 | **+1** | 1-based | 1/2 | **−1** | no |
| Outbound slot | `channel_outBoundSlot` 0/1 | raw 0/1 | 1-based (`+1` on import, `Max(0,v-1)` on export, `:1332-1341`) | 0/1 | ignored for DMR (forced = inbound) | overwritten |
| Contact | `channel_txContact` = DMR ID | name (col 9) + DMR ID (col 11) | 1-based index into contact list; **col 11 exported empty** (`:1250, 1297`) | name, empty ID | col 11 → name map → TG-list first ID → 0 | needs Contacts.csv |
| Contact type | 0/1/2 | int | `AndroidContactType` 0/1/2 | int | 0–3; 0→inferred 1 for DMR w/ contact | mostly no |
| TG List | `channel_tglist_assignments` | list name / `None` | TG list by name | name | assignment + `channel_groups` | needs TG_Lists.csv |
| `channel_groups` | 32 ids | *not exported as such* (derived from TG list) | — | — | rebuilt from list, else `1,0,…` | **lossy** if channel had grid-edited groups without a list |
| RX/TX tone | type+subcode | `None`/`67.0`/`D023N`/`D023I` | tone | same | parsed | no |
| Squelch | `channel_sq` 0–9 | `Disabled`/`5`…`85` | % | % | 5→1 … 85→9; `Disabled`/0%→**2** | **0 → 2** lossy |
| Power | 0/1 | `P1`/`P9` | P-level | `P1–P9` | P1–P4→0, P5–P9→1 | no |
| Rx Only…No Eco, TOT, VOX | none | constants | stored | user-edited values | **ignored** | one-way |
| APRS | `dmrmod_aprs.enabled` | `TX`/`None` | string | same | `TX`/`On`→enabled (never disabled) | stale-flag lossy |
| Lat/Lon | `dmrmod_locations` | `%.6f` or `0.128/0.008` | static arrays (CSV only) | same | saved unless default | **lost on .g77 save** |
| Use Location | none | `No` | static array | user value | ignored | one-way |
| Encrypt switch | 2/1 | 1→1, else 0 | `EncryptSwitch` always 0 (`:1299`) | 0 | 0→2 | **encryption lost** |
| Encrypt key | text | text | static array (CSV only) | text | text | lost on .g77 |
| Relay | 1/2 | raw | 0=normal,1=disconnect (`:1296`) | 0/1 | **0→2**, 1→1 | no |
| Interrupt | 2/0 | forced | stored | stored | forced by type | no |
| Active | 0/1 | raw | stored | stored | first `1` wins | no |
| Channel mode | 0/4 | 4→**3** | stored | 3 | 3→4, DMR forced 4 | no |

### 7.3 Fork versioning rule
`DMR/AboutForm.cs FORK_VERSION` must be bumped on every build attached to a DMRModHooks release (PATCH = rebuild, MINOR = new field/fix, MAJOR = CSV column-order change), tagged `fork-vX.Y.Z` (`copilot-instructions.md:1360-1380`). Current shipped: **v2.0.45**, `OpenGD77CPS-Mac_Build_20260607_210202.zip` (`OpenGD77Fork/RELEASE_NOTES_20260607_v2.0.45.md:3-14`; pinned in `releases/v3.4.6_RELEASE_NOTES.md:40`). ⚠️ `copilot-instructions.md:1211` still says "current shipped v1.2.7" and `:1356` "Latest Build … 20260601_142528".

---

## 8. `DiagnosticDatabaseDump`

`dumpChannelInfo(Context, int channelNumber)` (`DiagnosticDatabaseDump.java:11-62`): opens `database_channel_area_default_uhf.db` read-only, `SELECT * WHERE channel_number=?`, logs each column as `name: value` (ints via `getLong`, strings quoted, NULL) under tag `DMRModHooks_Diagnostic` at `Log.d`. (The `PRAGMA table_info` cursor at `:16-17` is opened and never closed/used.) `dumpMultipleChannels(Context)` dumps 1, 8, 9, 16 ("1–8 digital, 9–16 analog" assumption, `:64-75`).

Trigger: only `BackupActivity.exportToCSV` (`BackupActivity.java:340`) — i.e. `adb shell am start -n com.dmrmod.hooks/.BackupActivity`, tap Export, then `adb logcat -s DMRModHooks_Diagnostic`. In practice use the exporter's `ALL_FIELDS` lines (`adb logcat -s DMRModHooks_DirectExport`) or the sqlite queries in §9.2.

---

## 9. Practical

### 9.1 Hand-editing a backup CSV
- Edit the **37-column** `Channels.csv` from the phone; keep col 0 `_id` and the exact header text (`EXP:114-118`). Never insert/remove columns.
- **No BOM.** PowerShell `Set-Content`/`Out-File -Encoding UTF8` add one → silent wipe (§4.3). Use `[System.IO.File]::WriteAllLines($f, $lines, (New-Object System.Text.UTF8Encoding $false))` (`copilot-instructions.md:891-898`). Check: `Format-Hex file | Select -First 1` must not start with `EF BB BF`.
- Keep CRLF; leave the leading TAB in frequency cells (or remove it consistently — the importer strips it).
- Do **not** put commas in channel/zone/contact names — nothing is quoted on export; the importer's quote handling only survives simple `"…"`.
- Valid literals: type `Digital`/`Analogue`(or `Analog`); timeslot `1`/`2`; squelch `Disabled` or `5…85`; power `P1…P9`; tones `None`/`67.0`/`D023N`/`D023I`; relay `1`/`2` (write `2` for normal); encrypt switch `0`/`1`; channel mode `0`/`3`; APRS `TX`/`None`.
- Put the folder under `Download/DMR/DMR_Backups/<yyyyMMdd_HHmmss>/` with all five CSVs (`Channels.csv` is what makes the folder appear in the picker; the others are optional but their absence means "nothing imported" for that data).
- Contacts referenced by name must exist in `Contacts.csv`; TG list names in Channels must exist in `TG_Lists.csv`; zone cells must match `Channel Name` exactly (case-sensitive).

### 9.2 Verifying from adb (device is rooted; OEM app is a system app so use `su`)
```
adb shell su -c "ls -l /data/data/com.pri.prizeinterphone/databases/"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db \
  'select _id,channel_number,channel_name,channel_type,channel_rxFreq,channel_cc,channel_inBoundSlot,channel_outBoundSlot,channel_mode,channel_txContact,channel_contactType,channel_encryptSw,channel_relay,channel_interrupt,channel_active,channel_band,channel_sq,channel_groups from database_channel_area_default_uhf order by channel_number;'"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/contact_database.db 'select _id,contact_name,contact_type,contact_number from contact_database;'"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/dmrmod_zones.db 'select * from zones;'"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/dmrmod_tglists.db 'select * from tg_lists; select * from channel_tglist_assignments;'"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/dmrmod_locations.db 'select * from channel_locations;'"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/dmrmod_aprs.db 'select * from channel_aprs;'"
adb logcat -s DMRModHooks_DirectImport DMRModHooks_DirectExport DMRModHooks_TGListDB
adb shell ls /sdcard/Download/DMR/DMR_Backups/
```
Sanity checks after import: exactly one row with `channel_active=1`; every DMR row has `channel_mode=4`, `channel_interrupt=2`, `channel_relay∈{1,2}`, `channel_encryptSw∈{1,2}`; analog rows `channel_interrupt=0`; `channel_groups` has 32 tokens; `channel_txContact` values appear in `contact_number`; zone `channel_list` ids exist in the channel table. If `/data/data/com.dmrmod.hooks/databases/` contains `contact_database.db`, someone ran the legacy `BackupActivity` import (harmless, ignored by the app).

### 9.3 Adding a column to the round-trip (every touch point)
1. `EXP:114-118` header + both row builders (`:446-459` digital, `:502-513` analog) — append at the end to keep indices stable.
2. `IMP:440-457` header detection (bump 37/36 thresholds), `minFields` (`:498-503`), and the index arithmetic `offset + N + flagOffset` (`:740-849`); add validation/defaults for both new-fields and legacy branches.
3. If the value lives in a module DB: schema bump + `onUpgrade` in the helper, `clearAll…` semantics on import, and the post-insert block (`IMP:965-1010`).
4. Legacy pair `CSVExporter.java:23-27, 329-426` / `CSVImporter.java:337-414` (or delete them).
5. `PDFExporter` if it should print.
6. CPS fork: `ChannelsForm.cs` `ExportToAndroidCsvFile` + `ImportFromCsvFile` (Path B) **and** `ChannelsCsvImporter.cs` (if kept), `ChannelForm.cs` static arrays/`DispData`/`SaveData`; bump `FORK_VERSION` MINOR (MAJOR if column order changes).
7. Docs: `copilot-instructions.md` §5a and "Android CSV Format" (`:1229-1252`), `key-files.md`, this chapter, release notes.
8. Regenerate the sample sets under `DMRModHooks/` and test: export → import (same device), export → CPS Path B → export → import.

### 9.4 Failure modes

| Symptom | Likely cause | Where to look |
|---|---|---|
| "operation failed" snackbar when saving/activating a channel | `channel_relay=0`, `channel_interrupt` wrong for type, `channel_encryptSw=0`, NULL required column, or CmdStateMachine busy (`InterPhoneChannelActivity.java:786-789`) | §4.5 coercions; `sqlite3` row dump |
| Empty channel list right after a "successful" import | BOM/unknown header → all rows skipped after wipe (§4.3); or every row failed numeric parse | `logcat -s DMRModHooks_DirectImport` for "Unknown CSV format" / "✗ Failed to parse" |
| Wrong contact name shown / TX to wrong ID | contact map keyed by `_id` somewhere (PDF §6; the editor's "Group Number" fix queries `contact_database` by `_id=txContact`, `MH:14331-14335`), or Contacts.csv imported after Channels | §4.2 order; Pitfall 12 |
| Digital channel receives but **no TX** | `txContact=0` (unresolved contact, no TG list) or `contactType=0` with a group ID — fixed for imports in v3.4.6 (`IMP:589-604, 889-903`); check `channel_groups` too | `sqlite3` |
| Digital channel silent / won't tune | `channel_mode=0` (pre-v3.4.5 import) — DMR now forced to 4 | `IMP:884-887` |
| Zones empty after import | channel names changed between export/import, duplicate names, or Zones.csv imported with an empty channel table | `IMP:1459-1462, 1515` warnings |
| Locations/APRS missing after importing a stock-CPS or 28-col file | offset bug for non-`_id` files (§4.3) | re-export from the fork with `_id` |
| Locations missing after importing an Android file | rows with default `0.128/0.008`, or `channel_number` changed | §1.4 keying |
| Contacts import "Failed" | non-numeric `ID` cell (e.g. `None`) aborts the transaction | `IMP:1159` |
| Two channels active / app boot channel wrong | CSV had several `Active=1` (only first kept) or none and no `_id=1` | `IMP:804-813, 1031-1045` |
| Export toast says success but folder is elsewhere | toast text is stale; real path `Download/DMR/DMR_Backups/` | `MH:4120` |

---

## 10. Gotchas & doc drift

**Code gotchas**
- `USE_COMPOUND_KEY_ZONES` mismatch (`EXP:48` false vs `IMP:71` true).
- Channels/Contacts/Zones CSVs are unescaped; `parseCSVLine` in IMP does not decode `""`.
- `LocationDatabase.clearAllLocations()` runs outside the channel transaction; `APRSDatabase` and TG lists/assignments are never cleared on import.
- `_id` is not preserved for non-`_id` files, so zones/TG assignments only survive Android→Android round-trips (or fork exports that keep `_id`).
- Squelch 0 ("Disabled") re-imports as 2; encryption switch always returns disabled through the CPS; Outbound Slot/TOT/VOX/flags/Use Location are write-only.
- `coverGroupInt` will throw if `channel_groups` ever has >32 tokens — `getHardwareGroups()` guarantees 32, but a hand-edited DB can crash channel load.
- `TGListDatabase.saveTGList` insert uses `CONFLICT_REPLACE` on the UNIQUE name → new `id`, orphaned assignments; the by-name overload avoids this by updating.
- Duplicate "ensure active" block in IMP; duplicate `Log.i("Detected OpenGD77 format…")`.

**⚠️ Doc drift (vs `.grok/rules/copilot-instructions.md`, `key-files.md`, other docs)**

| Doc | Says | Code |
|---|---|---|
| copilot §5a `:537`, diagram `:1277-1285` | module DBs in `com.dmrmod.hooks` data dir | all `dmrmod_*.db` live in `/data/data/com.pri.prizeinterphone/databases/` (§1.1) |
| copilot §5a `:509` | `channel_encryptSw` 0=off, 1=on | OEM/importer: **2=off**, 1=on (`ChannelData.java:95`, `IMP:744-757`) |
| copilot §5a `:497` | `channel_band` 0=UHF, 1=VHF | 0=narrow 12.5 kHz, 1=wide 25 kHz (`EXP:380`, `IMP:1749-1766`, v3.4.6 notes) |
| copilot §5a `:514` | `channel_mode` importer defaults to 0 | DMR forced to 4 since v3.4.5 (`IMP:886`) |
| copilot `:573, 1194`, key-files `:58`, PDF `:470`, toast `MH:4120` | `Download/DMR_Backups/` | `Download/DMR/DMR_Backups/` (`EXP:136`) |
| copilot `:1266` | import order at "lines ~315-327" | now `IMP:314-328` (still Contacts→TG_Lists→Channels→Zones) |
| copilot `:1264, 1271, 1284`, key-files `:70` | DTMF imported / "OEM DTMF table" | no DTMF source, no importer; `DTMF.csv` is header-only |
| copilot `:1260` | Contacts `ID Type` = 0/1/2 | strings `Private`/`Group`/`All Call` (`EXP:588-589`) |
| copilot `:1263` | Zones compound key `name⟨_id⟩` | `channelNum|rxMHz|name`, and exporter has it off |
| copilot `:1250` | "CPS always exports empty" col 11 | Android exporter fills col 11; importer prefers it (`IMP:577-588`) |
| copilot `:1211, 1356` | fork v1.2.7 / build 20260601_142528 | v2.0.45 / 20260607_210202 |
| key-files `:59` | importer "upsert channels by name+freq" | wipe + insert, `_id` preserved |
| key-files `:15` | `BackupActivity` = "Backup management UI" | unused/unreachable; legacy |
| `COMPOUND_KEY_REVERT_GUIDE.md` | both flags `true`, line numbers ~68/~48/~989 | exporter `false`; importer `true`; line refs stale |
| IMP Javadoc `:40-42` | auto-refresh via `getDmrManagerInstance().init()` | disabled; would call `getInstance().updateChannelList()` |
| IMP comment `:430-434` | "OpenGD77 format does NOT include [flag] fields" | stock 28-col format includes them (sample files); causes §4.3 offset bug |
| `PDFExporter` text | contacts preserved; auto-update; v1.1 | contacts wiped; restart needed; module v3.4.6 |
| `CHANNEL_PROPERTIES_REFERENCE.md:185-190` | Group List = 0/1 bitmap | slots hold TG IDs (`MH:14565-14571`) |
| `CHANNEL_PROPERTIES_REFERENCE.md:203` | band default narrow | mod hook defaults new channels to wide (`MH:13955-13960`) |
| `releases/RELEASE_NOTES.md:175` (v0.9.26) | `channel_relay` = 1 for both types | 2 = normal, 1 = disconnect (Pitfall 11) |
