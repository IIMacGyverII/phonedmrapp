# Research: integration surface for "Nearby Repeaters + Talkgroups → codeplug (additive)"

Scope: the EXISTING code the feature must reuse or mirror. Read-only survey, 2026-08-26.
Path aliases: `OEM/` = `app/src/main/java/com/pri/prizeinterphone/`, `MH` = `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`, `IMP` = `.../DirectDatabaseImporter.java`, `RULES` = `.grok/rules/copilot-instructions.md`. Line cites are `file:line` in the working tree at commit `14e484a2`.

---

## 1. Additive channel insertion (OEM path)

### 1.1 `UtilChannelData` (`OEM/serial/data/UtilChannelData.java`)

| Member | Signature / behaviour | Cite |
|---|---|---|
| ctor | `UtilChannelData(Context, String area)` → `DBChannelHelper(context, area)`, `mDBName = "database_" + area`, `mDataName = area` | `:53-57` |
| `addChannel` | `public void addChannel(ChannelData cd)` — `INSERT` of every column except `_id` (`channel_name … channel_txSubCode` `:62-83`); **if `getActiveChannel()==null` forces `cd.active=1`** `:84-86`; puts `channel_active`, `channel_groups = coverGroupsString(cd.groups)` `:87-88`; `long insert = mDB.insert(...)` `:89`; then **overwrites `cd._id = cd.number = (int) rowid`** `:91-93` and calls `updateChannel(cd)` `:94`. **Returns void**; the new `_id` is read back from `cd.getId()`/`cd.number` after the call. Any `number` you set is discarded. | `:59-95` |
| `updateChannel` | `public void updateChannel(ChannelData cd)` — `UPDATE … WHERE _id = ?`, all columns incl. `channel_groups` (`:201`) and `channel_active` (`:200`) | `:175-205` |
| `getActiveChannel` | `SELECT * WHERE channel_active=1 LIMIT 1` | `:142-151` |
| `getAllChannels` | `ArrayList<ChannelData>`, `SELECT *`, no ORDER BY (rowid order) | `:165-173` |
| `getChannel(int id)` | `WHERE _id=? LIMIT 1` | `:153-163` |
| `coverGroupsString(int[])` | null → `[1,0×31]`; joins with `,` | `:97-108` |
| `coverGroupInt(String)` | default `[1,0×31]`; indexes `iArr[i]` per token → **>32 tokens = AIOOBE on every channel load** | `:110-121` |

Schema: `DBChannelHelper` `super(context, "database_"+area+".db", null, 2)` (`OEM/serial/data/DBChannelHelper.java:59`; `PRAGMA user_version` must stay 2), `create table database_<area>(_id integer primary key autoincrement, channel_name varchar, channel_type integer, channel_number integer, channel_txFreq integer, channel_rxFreq integer, channel_power integer, channel_cc integer, channel_inBoundSlot integer, channel_outBoundSlot integer, channel_mode integer, channel_contactType integer, channel_txContact integer, channel_encryptSw integer, channel_encryptKey varchar, channel_relay integer, channel_interrupt integer, channel_band integer, channel_sq integer, channel_rxType integer, channel_rxSubCode integer, channel_txType integer, channel_txSubCode integer, channel_active integer, channel_groups varchar)` (`:67`).

### 1.2 `DmrManager` (`OEM/manager/DmrManager.java`)

| Method | Signature | Effect | Cite |
|---|---|---|---|
| `getInstance()` | `public static DmrManager getInstance()` | singleton | `:124` |
| `createChannel` | `public void createChannel(String area, ChannelData cd)` | `mInitChannelDataDB.getCurrentDb(area).addChannel(cd); updateChannelList();` — **no serial sync**. This is the additive insert entry point. | `:265-268` |
| `updateChannel` | `public void updateChannel(ChannelData cd)` | `getCurrentDbHelper().updateChannel(cd); updateChannelList(); syncChannelInfo(cd);` | `:253-257` |
| `updateChannel` | `public void updateChannel(String area, ChannelData cd)` | same on explicit area | `:259-263` |
| `deleteChannel` | `(ChannelData)` / `(String area, ChannelData)` | delete + `updateChannelList()` | `:270-278` |
| `updateChannelList` | `public void updateChannelList()` | `this.channels = getCurrentDbHelper().getAllChannels()`; fires `UpdateListener.updateTalkBackChannelList()` on every registered listener | `:217-225` |
| `updateModuleInit` | `public void updateModuleInit()` | same reload, fires `updateModuleInit()` | `:227-235` |
| `getChannelList()` / `(String area)` | `List<ChannelData>` | fresh `getAllChannels()` (not the cache) | `:237-243` |
| `getCurrentDbHelper` | `public UtilChannelData getCurrentDbHelper()` | `mInitChannelDataDB.getCurrentDb(Constants.getSelectedChannelArea(PrizeInterPhoneApp.getContext()))` | `:245-247` |
| `getDefaultDbHelper` | `UtilChannelData` for `Constants.KEY_DEF_AREA` | | `:249-251` |
| `getInitChannelDataDB` | `public UtilInitChannelData getInitChannelDataDB()` | | `:173` |
| `syncChannelInfo(ChannelData)` | pushes **only if `cd.active == 1`** (else logs) → `syncChannelInfo()` | `:189-195` |
| `syncChannelInfo()` | `CmdStateMachine` SetChannelState with `setChannelData(null)` (uses current channel) | `:197-205` |
| `syncChannelInfoWithData(ChannelData)` | same, with explicit object | `:207-215` |
| `getCurrentChannel()` | first `active==1` in cache, else index 0 (**IndexOutOfBounds if empty**) | `:280-291` |
| `getCurrentChannelIndex()` | `mChannelIndex` set by `getCurrentChannel()` | `:293-295` |
| `sendSetChannelCmdToMdl(ChannelData)` | type 0 → `DigitalMessage`, else `AnalogMessage` | `:803-814` |
| `registerUpdateListener(UpdateListener)` | | `:822` |

Area resolution: `Constants.getSelectedChannelArea(ctx)` = pref `pref_person_channel_area_selected_index` in `com.pri.prizeinterphone.data.person`, default `KEY_DEF_AREA` (`OEM/constant/Constants.java:127-129`, `:47`). `UtilInitChannelData.getCurrentDb(String area)`: **if `area` is not a saved area it silently returns a new `UtilChannelData(ctx, KEY_DEF_AREA)`** (`OEM/serial/data/UtilInitChannelData.java:278-291`). ⚠ `MH:5438-5439` passes `"default"` and therefore lands in the default area by fallback, not the selected one. The feature must pass `OemChannelTable.areaKey(context)` (`OemChannelTable.java:41-52`) or `Constants.getSelectedChannelArea()`.

### 1.3 `ChannelData` (`OEM/serial/data/ChannelData.java`)

Fields all `public` (`:25-50`); no-arg ctor defaults (`:83-111`): `type=0, number=0, txFreq=rxFreq=401025000, power=1, cc=1, inBoundSlot=outBoundSlot=0, channelMode=0, contactType=0, txContact=1, encryptSw=2, encryptKey="", mic=0, relay=2, interrupt=2, band=0, sq=2, rxType=rxSubCode=txType=txSubCode=0, active=0, groups=int[32]{1,0…}`. **Module ctor hook flips `band` to 1 for every `new ChannelData()`** (`MH:13966-13974`), so reflection-created objects start wide.

Setters (`ChannelData.java`): `setId(int)` `:146`, `setName(String)` `:154`, `setType(int)` `:162`, `setNumber(int)` `:170`, `setTxFreq(int)` `:178`, `setRxFreq(int)` `:186`, `setPower(int)` `:194`, `setCc(int)` `:202`, `setInBoundSlot(int)` `:210`, `setOutBoundSlot(int)` `:218`, `setChannelMode(int)` `:226`, `setContactType(int)` `:234`, `setTxContact(int)` `:242`, `setEncryptSw(int)` `:250`, `setEncryptKey(String)` `:258`, `setRelay(int)` `:266`, `setInterrupt(int)` `:274`, `setBand(int)` `:282`, `setSq(int)` `:290`, `setRxType(int)` `:298`, `setRxSubCode(int)` `:306`, `setTxType(int)` `:314`, `setTxSubCode(int)` `:322`, `setActive(int)` `:330`, `setGroups(int[])` `:338`.

Field set the feature must write (mirrors `InterPhoneChannelActivity.saveChannelData`, `OEM/activity/InterPhoneChannelActivity.java:637-805`):

| Field | Analog FM repeater | DMR repeater | Editor cite |
|---|---|---|---|
| `name` | repeater callsign/label (non-empty; editor refuses empty `:564`) | same | `:641-643` |
| `type` | `1` | `0` | `:724` / `:672` |
| `txFreq` / `rxFreq` | Hz ints; `rx` = repeater output, `tx` = input. Editor range: 400 000 000–480 000 000 or 136 000 000–174 000 000 (`isParamsCorrect` `:562-591`) | same | `:657-658` |
| `power` | `1` high / `0` low | same | `:659-663` |
| `relay` | `2` (disconnect disabled, default) — never 0 (Pitfall 11) | `2` | `:664-670` |
| `band` | bandwidth: `1` wide 25 kHz / `0` narrow 12.5 kHz (**not** UHF/VHF) | ignored; keep 1 | `:725-729` |
| `sq` | `2` (editor default; only 0/2 honoured by firmware, `RULES:835-838`) | ignored | `:730` |
| `rxType`/`rxSubCode`, `txType`/`txSubCode` | type 0 none / 1 CTCSS / 2 DCS-N / 3 DCS-I; subcode = **index into the arrays.xml table** (see §1.4). Repeater: uplink tone → `txType/txSubCode`; output tone (if published) → `rxType/rxSubCode`, else 0/0 | 0/0 | `:731-755` |
| `cc` | 0 | colour code 0–15 | `:683` |
| `inBoundSlot`/`outBoundSlot` | 0 | both `0` (TS1) or both `1` (TS2) — editor always sets equal | `:713-719` |
| `channelMode` | 0 | `0` direct or `4` double-slot (importer forces 4 for DMR, `IMP:886`) | `:708-712` |
| `contactType` | 0 | `1` = Group (TG), `0` = private, `2` = all-call (then `txContact=16777215`) | `:673-682` |
| `txContact` | 1 (default) | **the TG/DMR ID itself** (Pitfall 12), e.g. 91 | `:674-678` |
| `encryptSw` / `encryptKey` | 2 / `""` | 2 / `""` (a NULL key on a digital row NPEs at send, `DmrManager.java:342`) | `:695-704` |
| `interrupt` | 2 (default; unused for analog) | `2` OFF (1 ON / 3 transmit) | `:705-711` |
| `groups` | leave default `{1,0…}` | `int[32]` of TG IDs (= `TGList.getHardwareGroups()`), transmitted only when `contactType==1` | `:682` |
| `active` | `0` (additive insert must not steal the active flag; `addChannel` only forces 1 when no active row exists) | `0` | — |
| `number` | ignored — `addChannel` sets `number = _id` | same | `UtilChannelData.java:93` |

Editor create sequence to replicate exactly (`InterPhoneChannelActivity.java`): `new ChannelData()` + `setName` (`:641-643`) → freq/power/relay (`:657-670`) → type-specific block (`:671-756`) → **new channel:** `DmrManager.getInstance().createChannel(currentAreaId, channelData); finish();` (`:802-803`). `currentAreaId` = `Constants.KEY_DEF_AREA` default (`:124`) overridden by intent extra `currentAreaId` (`:335`). (Edit path for comparison: non-active → `updateChannel(area, cd)` `:798`; active → `syncChannelInfoWithData` and DB write only after cmd 34/35 ack `:757-796`.)

### 1.4 CTCSS/DCS → subcode index

Source of truth: `app/src/main/res/values/arrays.xml:509-561` `interphone_channel_subcode_ctcsss_values` — 51 items, index 0 = `62.5Hz`, 1 = `67.0Hz`, 13 = `100.0Hz`, 50 = `254.1Hz`. The editor stores `mDataChannelTxSubCtc.indexOf(text)` (`InterPhoneChannelActivity.java:735, 748`). DCS tables `interphone_channel_subcode_fdcs_values` / `_bdcs_values` (83 each, `023N…754N`, `023l…754l`).

Module mirror: `ToneConverter` (`DMRModHooks/.../ToneConverter.java`) — `CTCSS_TONES[51]` `:22-29` (same order, strings `"62.5"…"254.1"`), `FDCS_CODES[83]` `:33-45`, `BDCS_CODES[83]` `:47-59`. API: `static int parseType(String)` `:103-131` (`"None"`/empty → 0; `\d{3}[NI]` with optional `D` → 2/3; parseable float → 1); `static int parseSubCode(String)` `:140-184` (**exact string match** after stripping `Hz` — `"100.0"` matches, `"100"` does not — **returns 0 (= 62.5 Hz) when not found**); `static String toCSVFormat(int type, int subCode)` `:66`; `static String formatForDisplay(int, int)` `:192`. Feature rule: format Hz as `String.format(Locale.US, "%.1f", hz)` before `parseSubCode`, and treat a result of 0 with input ≠ 62.5 as "no tone" (or verify with `toCSVFormat(1, idx).equals(formatted)`).

### 1.5 UI refresh after insert

| Mechanism | What happens | Cite |
|---|---|---|
| `DmrManager.createChannel` → `updateChannelList()` | reloads cache and calls `UpdateListener.updateTalkBackChannelList()` | `DmrManager.java:217-225, 265-268` |
| `InterPhoneChannelFragment.updateTalkBackChannelList()` | `mHandler.post(mUpdateChannelListRunnable)` → `initData()` (re-reads `getChannelList(area)` into field `channels`) | `OEM/fragment/InterPhoneChannelFragment.java:158-160, 61, 82-86`; registered `:78` |
| Module reflection call | `XposedHelpers.callMethod(dmrManager, "updateChannelList")` after APRS channel creation and VFO restore | `MH:5445`, `MH:15842` |
| Module fragment refresh | `XposedHelpers.callMethod(channelFragmentInstance, "initData")` on UI thread; `channelFragmentInstance` captured in `hookChannelListUI` after-hook of `initData` | `MH:14555`, `MH:12639-12657`, `MH:12826`; `channelFragmentInstance` decl `MH:227` |
| Zone-filter cache | if a zone is active, reload `currentZoneChannels = db.getZone(currentZoneId).getChannelList()` before `initData()` or new channels stay hidden | `MH:14543-14549`; filter reads `_id ∈ currentZoneChannels` `MH:12448-12449` |
| Importer | `refreshChannelList(Context)` = reflection `DmrManager.getInstance().updateChannelList()` via `context.getClassLoader()` — **disabled** (`if (false && shouldRefresh)`), user restarts app | `IMP:1278-1305`, `IMP:385-389` |
| `updateView` replacement | module replaces `InterPhoneChannelFragment.updateView()` with `initData()` so tab swipes don't blank the list | `MH:12612-12625` |

Conclusion: calling `createChannel(area, cd)` via reflection is sufficient for the OEM list; additionally post `initData()` on `channelFragmentInstance` (after refreshing `currentZoneChannels`) when the feature also assigns a zone.

---

## 2. Contacts

### 2.1 OEM API (`OEM/serial/data/UtilContactsData.java`, `OEM/serial/data/ContactData.java`, `DmrManager`)

| Member | Signature / behaviour | Cite |
|---|---|---|
| `ContactData` fields | `_id:int, type:int, name:String, number:String, active:int, bitmap:Bitmap`; `ContactType.PERSON=0`, `GROUP=1` | `ContactData.java:25-32` |
| ctors | `ContactData()` (type 0, active 0) `:39-42`; `ContactData(int id, int type, String name, String number, int active, Bitmap)` `:44-51` | |
| setters | `setId(int)` `:57`, `setName(String)` `:65`, `setBitmap` `:73`, `setNumber(String)` `:81`, `setType(int)` `:89`, `setActive(int)` `:97` | |
| `UtilContactsData(Context)` | opens `contact_database.db` via `DBContactHelper` | `UtilContactsData.java:32-34` |
| `long addContact()` | `INSERT (contact_name='')` → rowid | `:36-41` |
| `long addContact(ContactData)` | INSERT incl. explicit `_id`, name, type, number, active, icon (base64 JPEG or `""`) → rowid; **no OEM caller** | `:43-59` |
| `boolean updateContact(ContactData)` | `UPDATE _id,name,type,number,icon WHERE _id=?` (not `active`) → `update==1` | `:114-134` |
| `ContactData getContact(int type, int number)` | `WHERE contact_type=? AND contact_number=? LIMIT 1` — **`number` passed as int, compared to TEXT column** | `:136-156` |
| `ContactData getContact(int id)` | `WHERE _id=?` | `:158-178` |
| `DmrManager.saveContact(ContactData)` | `addContact()` → `cd.setId(rowid)` → `updateContact(cd)` → `notifyContactAdded` (returns `rowid > 0`) — the OEM "create" path | `DmrManager.java:612-621` |
| `DmrManager.getContact(int type, int number)` / `(int id)` | pass-through | `:600-602`, `:596-598` |
| `DmrManager.updateContact` / `deleteContact` / `getAllContacts([type])` | | `:604-610`, `:623-627`, `:572-578` |

OEM duplicate rule: `FragmentNewContactsActivity.saveData` refuses when `DmrManager.getInstance().getContact(type, Integer.parseInt(number)) != null` (`OEM/activity/FragmentNewContactsActivity.java:351-354`), then `saveContact` (`:355`). Feature should do the same per (type=1, TG id) before inserting a talkgroup contact, and (type=0, id) for private.

`contact_number` is the 24-bit DMR/TG ID as TEXT; `channel_txContact` stores the same integer, never `_id` (Pitfall 12; origin `OEM/fragment/InterPhoneContactsFragment.java:224-230`).

### 2.2 How the importer inserts (`IMP:1126-1213`)

Opens `context.getDatabasePath("contact_database.db")` `OPEN_READWRITE` (`:1138-1139`), `beginTransaction` (`:1146`), **`DELETE` all rows + `DELETE FROM sqlite_sequence WHERE name='contact_database'`** (`:1148-1156` — wipe semantics, do NOT reuse), then per row: `contact_name=fields[0].trim()`, `contact_number=Integer.parseInt(fields[1])` (int into TEXT column), `contact_type` Group→1 / Private→0 / else 2, `contact_active=1`, `contact_icon=""` (`:1170-1189`), `db.insert("contact_database", null, values)` (`:1191`), `setTransactionSuccessful`/`endTransaction` (`:1196-1203`), then `PRAGMA wal_checkpoint(FULL)`. Additive variant for the feature: same `ContentValues` shape, no delete, guarded by a `SELECT _id WHERE contact_type=? AND contact_number=?` (or `DmrManager.getContact(type, id)` + `saveContact` via reflection so `notifyContactAdded` refreshes the Contacts tab).

---

## 3. TG lists and `channel_groups`

### 3.1 `TGListDatabase` (`DMRModHooks/.../TGListDatabase.java`, `dmrmod_tglists.db`, version 1)

| API | Notes | Cite |
|---|---|---|
| `static synchronized TGListDatabase getInstance(Context)` | app-context singleton; file lives next to OEM DBs | `:60-65` |
| `HARDWARE_MAX_GROUPS = 32` | | `:51` |
| `TGList(long id, String name, String description, List<Integer>)` / `(…, String tgIdsRaw)` / `(long id, String name, String tgIdsRaw)` | immutable value object | `:102-118` |
| `TGList.getTgIds()`, `size()`, `exceedsHardwareLimit()`, `getTgIdsString()`, `contains(int)`, `static parseTgIds(String)` | parser drops `<=0` | `:120-175` |
| `int[] TGList.getHardwareGroups()` | `int[32]`, first ≤32 IDs, zeros elsewhere — **the array written to `channel_groups`** | `:138-144` |
| `long saveTGList(TGList)` | `id>0` → UPDATE; else `insertWithOnConflict(CONFLICT_REPLACE)` (name UNIQUE → collision silently replaces row with a new id, orphaning assignments) | `:188-210` |
| `long saveTGList(String name, String tgIdsRaw)` | upsert by name (looks up existing id first) — **use this** | `:214-218` |
| `getTGList(long)`, `getTGListByName(String)`, `getAllTGLists()`, `deleteTGList(long)`, `clearAllTGLists()`, `getTGListCount()`, `tgListExists(String)` | | `:221, :236, :252, :271, :280, :288, :298` |
| `void assignTGListToChannel(int channelId, long tgListId)` | `channel_tglist_assignments` PK = channel **`_id`**, `CONFLICT_REPLACE` | `:312-319` |
| `removeAssignmentForChannel(int)`, `long getTGListIdForChannel(int)` (−1), `getTGListForChannel(int)`, `String getTGListNameForChannel(int)` ("None"), `Map<String,TGList> buildNameMap()` | | `:326, :337, :354, :365, :378` |

### 3.2 Writers of `channel_groups`

1. Editor save after-hook (`MH:14563-14590`): reads additional field `dmrmod_selectedTGListId`; `tgDb.assignTGListToChannel(channelId, id)` (`:14568`); `int[] hwGroups = tgList.getHardwareGroups(); XposedHelpers.setObjectField(channelData, "groups", hwGroups);` (`:14572-14573`); `DmrManager.getInstance().updateChannel(channelData)` via `XposedHelpers.findClass("com.pri.prizeinterphone.manager.DmrManager", context.getClassLoader())` + `callStaticMethod(..., "getInstance")` + `callMethod(mgr, "updateChannel", channelData)` (`:14574-14578`) → `UtilChannelData.updateChannel` persists `channel_groups` (`UtilChannelData.java:201`) and re-syncs hardware if active. "None" → `removeAssignmentForChannel` (`:14583`).
2. Importer (`IMP:935-963`): after `db.insert`, `assignTGListToChannel((int) rowId, tgList.id)` then exact statement: `ContentValues groupsUpdate; groupsUpdate.put("channel_groups", <32 ids joined by ','>); db.update(OemChannelTable.tableName(context), groupsUpdate, "_id=?", new String[]{String.valueOf(finalRowId)});` (`:945-957`).

For the feature the cleanest path is (1)'s data shape done *before* insert: set `cd.groups = list.getHardwareGroups()` and let `addChannel` write it (`UtilChannelData.java:88`), then `assignTGListToChannel(cd.getId(), listId)` once `_id` is known.

### 3.3 Limits

* 32 slots on the wire (`DigitalMessage` groupList 32×4 bytes; `ChannelData.groups` `int[32]` `ChannelData.java:107-111`). `>32` comma tokens in `channel_groups` crash `coverGroupInt` (`UtilChannelData.java:116-118`). `getHardwareGroups()` truncates safely; `exceedsHardwareLimit()` drives the ⚠ label (`MH:14579-14581`).
* `_partN` is a **CSV-only** convention: exporter splits long lists into `name_part1`, `name_part2` rows (`DirectDatabaseExporter.java:666-681`, per `11-mod…md §2.2`), importer strips `_part\d+$` and merges (`IMP:1353-1360`). The DB row stores the full list. Not needed for direct DB writes.
* Groups are only transmitted when `contactType == 1` (`DmrManager.java:351-352`).

---

## 4. Zones

### 4.1 `ZoneDatabase` (`DMRModHooks/.../ZoneDatabase.java`, `dmrmod_zones.db`, version 1; `zones(id, name NOT NULL, channel_list TEXT)`)

| API | Notes | Cite |
|---|---|---|
| `static synchronized ZoneDatabase getInstance(Context)` | | `:38` |
| `boolean migrateZonesFromNumberToId(Context)` | one-time, called at startup | `:67` |
| `long saveZone(Zone)` | `id>0` UPDATE else INSERT → id; **name not UNIQUE** | `:174-190` |
| `Zone getZone(long)`, `Zone getZoneByName(String)` (first match), `List<Zone> getAllZones()` (name ASC), `List<Integer> getChannelsInZone(long)` | | `:196, :221, :246, :271` |
| `deleteZone(long)`, `clearAllZones()`, `int getZoneCount()`, `boolean zoneExists(String)` | | `:280, :290, :299, :315` |
| `long getZoneIdForChannel(int channelId)` (−1), `String getZoneName(long)`, `removeChannelFromAllZones(int)` | | `:324, :339, :348` |
| `boolean addChannelToZone(long zoneId, int channelId)` | idempotent append; false if zone missing | `:365-377` |
| `Zone(String name, List<Integer>)`, `Zone(long id, String name, List<Integer>)`, `Zone(long, String, String csv)` | `getChannelList()` (copy), `getChannelCount()`, `containsChannel(int)`, `getChannelListString()`; parser skips `<=0`/non-numeric | `:391-468` |

Create-or-reuse pattern for the feature: `Zone z = db.getZoneByName(name); long id = z != null ? z.id : db.saveZone(new Zone(name, new ArrayList<>()));` then `addChannelToZone(id, cd.getId())` per inserted channel. Editor precedent for "Create New Zone…" is `showChannelEditZoneDialog` (`MH:13272`, creation branch per `08-…md §9`).

### 4.2 Keying and the intercom/list filter

Membership is keyed by OEM channel **`_id`** (class Javadoc `:13-17`; migration `:67-119`). Runtime statics `currentZoneId` / `currentZoneName` / `currentZoneChannels` (`MH:228-230`), `zoneDatabase` (`:231`, initialised in `hookTalkBackFragment` `MH:1710`). `showZoneSelectionDialog(Context)` (`MH:11985-…`; `setItems` `:12013`) sets `currentZoneChannels = selectedZone.getChannelList()` (`:12032`). `hookChannelListFilter` (`MH:12392`) replaces `DeviceAreaListAdapter.getCount/getItem` and keeps a channel iff `!isAPRSChannel(cd) && currentZoneChannels.contains(XposedHelpers.getIntField(cd, "_id"))` (`:12445-12451`); `isAPRSChannel` = name starts with `"APRS ("` (`MH:311-319`) — do not name feature channels that way.

---

## 5. Locations

> **Correction (2026-08-27, see `17-grok-review-response.md`):** the save-side advice below (`saveLocation(cd.getNumber(), …)`) is only honest once the **read side** is fixed — `updateLocationDisplay` looks locations up by `mCurrentChannelIndex + 1` (`MainHook.java:3188-3192`), which diverges from `channel_number`/`_id` under a zone filter or after deletions. Backlog **R5** (key locations by `_id` end-to-end) is a prerequisite for the feature; do not add a second keying scheme.

`LocationDatabase` (`DMRModHooks/.../LocationDatabase.java`, `dmrmod_locations.db` v2, `channel_locations(channel_number INTEGER PK, latitude REAL, longitude REAL, elevation REAL DEFAULT 0)`):

| API | Cite |
|---|---|
| `static synchronized LocationDatabase getInstance(Context)` | `:35` |
| `void saveLocation(int channelNumber, double lat, double lon)` → delegates with elevation 0 | `:64-69` |
| `void saveLocation(int channelNumber, double lat, double lon, double elevation)` — `insertWithOnConflict(CONFLICT_REPLACE)` | `:71-81` |
| `Location getLocation(int channelNumber)` → `Location{latitude, longitude, elevation}` or null | `:87`, `:129-140` |
| `deleteLocation(int)`, `clearAllLocations()` | `:111`, `:121` |

Key = **`channel_number`**, and the intercom derives it as `mCurrentChannelIndex + 1` (display index), not from the row: `updateLocationDisplay(Object fragment, TextView locationText, Context ctx)` `MH:3185-3189`. After `addChannel`, `number == _id`; for a DB with no deletions and no zone filter `_id == index+1`, otherwise the link drifts (known limitation, `11-mod…md §1.4`). Save with `cd.getNumber()` after `createChannel`.

Distance/bearing helpers (all instance methods of `MainHook`, private):

| Helper | Signature | Cite |
|---|---|---|
| `getCurrentLocation` | `android.location.Location getCurrentLocation(Context)` — lazy `LocationManager` (`MH:241`), `getLastKnownLocation(GPS_PROVIDER)` then `NETWORK_PROVIDER` (`:3556-3557`, `:3574-3575`); catches `SecurityException`; caches in `static volatile currentGpsLocation` (`:240`, `:3592`). **Synchronous, last-known fix only — no `requestLocationUpdates` anywhere in the module**; called on the UI thread from `updateLocationDisplay` (`:3196`) and from the GPS-SMS button (`:2690`) | `:3539-3604` |
| `calculateDistance` | `double calculateDistance(double lat1, double lon1, double lat2, double lon2)` Haversine, metres, R=6 371 000 | `:3451-3466` |
| `calculateBearing` | `double calculateBearing(lat1, lon1, lat2, lon2)` → 0–360° | `:3476-3487` |
| `getDirectionArrow` | `String getDirectionArrow(double bearing)` → `↑N ↗NE →E ↘SE ↓S ↙SW ←W ↖NW` | `:3494-3505` |
| `formatDistance` | `String formatDistance(double m)` → `"%.0fm"` <1 km, `"%.1fkm"` <10 km, else `"%.1fmi"` | `:3355-3367` |
| `formatDistance` | `String formatDistance(double m, double fromLat, double fromLon, double toLat, double toLon)` → `"↗NE 3.2km"` / `"↗NE 12.4mi (20.0km)"` | `:3516-3533` |
| display composition | `"City, ST (↗NE 3.2km)\n📍"`, Geocoder on calling thread (`:3200-3217`), distance block `:3219-3247`; elevation via `getElevation(lat, lon)` Open-Elevation GET, 5 s timeouts, on a `new Thread` (`:3396-3441`, `:3252-3262`) | |

Permissions: module manifest declares `INTERNET`, `ACCESS_NETWORK_STATE`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` (`DMRModHooks/app/src/main/AndroidManifest.xml:10-15`), but the code executes inside the OEM process. The decompiled OEM manifest in this repo declares only `FOREGROUND_SERVICE*`/`WAKE_LOCK` (`app/src/main/AndroidManifest.xml:5-8`); RadioID download and GPS distance nevertheless work on the device — the OEM APK is installed with `sharedUserId="android.uid.system"` (`decompiled/AndroidManifest.xml:2`), so network access is a system-UID privilege rather than a manifest grant; runtime location on Android 13 is the part to verify — so check the installed package's grants (`adb shell dumpsys package com.pri.prizeinterphone | grep -i "INTERNET\|LOCATION"`) before relying on them; `getCurrentLocation` already degrades to null on `SecurityException`.

---

## 6. Network download template (`RadioidDatabase.java`) and Device-tab UI

### 6.1 Download / parse

| Item | Detail | Cite |
|---|---|---|
| Constants | `DATABASE_NAME="dmrmod_radioid.db"`, `DATABASE_VERSION=2`, `PREFS_NAME="dmrmod_radioid_prefs"` (`last_sync_ms`, `entry_count`, `source_file`), `DOWNLOAD_URL`, `RADIOID_SUBDIR="DMR/RadioID"`, `CONNECT_TIMEOUT_MS=30000`, `READ_TIMEOUT_MS=120000` | `:44-70` |
| Singleton | `getInstance(Context)` on `getApplicationContext()` | `:72-81` |
| Entry point | `public static void downloadAndImport(Context ctx, String userAgent[, Runnable onComplete])` — `new Thread(...)`: `isNetworkAvailable` gate → `ProgressDialogHolder.show(ctx, msg)` → mkdirs → `downloadCsv` → `importFromCsvFile(ctx, file, progress)` → `progress.dismiss()` → toast → `runOnComplete` (posted to main looper) ; catch → dismiss + toast | `:246-284`, `:370-374` |
| `downloadCsv(String url, File out, String userAgent, ProgressDialogHolder p)` | `HttpURLConnection`, `GET`, connect/read timeouts, `User-Agent`, `Accept: text/csv,*/*`; `getResponseCode()!=200` → `throw new Exception("HTTP "+code)`; **no explicit redirect handling** (default `HttpURLConnection` follows same-protocol 3xx only); 8 KB buffer; progress `update("Downloading… N%")` every ~256 KB when `Content-Length` known; `finally` closes streams + `disconnect()` | `:671-716` |
| Progress "interface" | not an interface — package-private `ProgressDialogHolder` with `show(Context,String)`, `update(String)`, `dismiss()` | `:758-836` |
| Parse | `importFromCsvFile`: `db.beginTransaction()` (`:410`), `DELETE`, one compiled `INSERT OR REPLACE` statement re-bound per row, `setTransactionSuccessful`, rollback in `finally`; prefs updated only on success (`:445-451`) | `:387-470` |
| `isNetworkAvailable(Context)` | `ConnectivityManager.getActiveNetwork()` + WIFI/CELLULAR/ETHERNET transport; optimistic `true` on exception | `:724-739` |
| `showToast(Context, String)` | app-context toast posted to main looper | `:745-752` |
| UA string | `"DMRModHooks/" + VERSION + " (github.com/IIMacGyverII/phonedmrapp)"` built by the button | `MH:4178` |

`ProgressDialogHolder` (the `BadTokenException` fix, `:758-836`): `dialogEnabled = activity != null && !isFinishing() && !isDestroyed()` (`:770-774`); `showInternal` runs on `activity.runOnUiThread`, re-checks `canShowDialog()` (`:831-833`), builds a non-cancelable `AlertDialog` titled "RadioID Database" inside try/catch (`:776-797`); `update`/`dismiss` also `runOnUiThread` + try/catch and guard `dialog.isShowing()` (`:799-828`); when the context is not an `Activity` everything degrades to toasts. Copy this class verbatim (rename title) rather than re-deriving it.

### 6.2 Device-tab button injection

`hookLocalFragment(lpparam)` (`MH:3952-3991`) hooks `InterPhoneLocalFragment.initView(View)` after → `addBackupButtonToFragment(Object fragment, View fragmentView)` (`:3997-4045`): resolves the exit row id from `{"local_exit_app","local_exit","exit_app","fragment_local_exit_app"}` via `getResources().getIdentifier(id,"id",TARGET_PACKAGE)` (`:4006-4013`), takes `parentLayout = exitAppView.getParent()` and `exitIndex = parentLayout.indexOfChild(exitAppView)` (`:4036-4040`), fallback `findViewGroupInHierarchy` = first `LinearLayout` with >3 children (`:4050-4073`) with index −1.

`private void addButtonToLayout(ViewGroup parentLayout, Object fragment, int index)` (`:4078-4222`): `context = callMethod(fragment,"getContext")`, `activity = callMethod(fragment,"getActivity")` (`:4080-4081`); `templateParams` cloned from `parentLayout.getChildAt(0).getLayoutParams()` else `MATCH_PARENT/WRAP_CONTENT` (`:4084-4092`). Button recipe: `new Button(context)`, `setText("📤 EXPORT (OpenGD77)")`, `setTextSize(16)`, `setAllCaps(false)`, `setPadding(20,20,20,20)`, `setLayoutParams(new ViewGroup.LayoutParams(templateParams))` (`:4095-4100`); status `TextView` 12 sp `0xFF888888` padding `(20,8,20,4)` (`:4148-4153`). Click → `new Thread(...)` for work + `activity.runOnUiThread` toast (`:4107-4129`). Insertion: `parentLayout.addView(view, index + k)` in order, or append when `index < 0` (`:4200-4214`). No duplicate guard (fresh view per `initView`). A "📡 Nearby Repeaters" button goes in as `index + 5` (after the RadioID import button at `+4`).

Theme constants used elsewhere: neon cyan `0xFF00E5FF` (`MH:531, 1691, 2145`), inactive `0xFF705090` (`:531`); `RULES:691-716` template uses `0xFFFFFFFF` on `0xFF333333`.

### 6.3 Dialog patterns

| Pattern | Cite |
|---|---|
| List picker: `new android.app.AlertDialog.Builder(context).setTitle(...).setItems(String[], listener)` | `showZoneSelectionDialog` `MH:11985-12040` (`setItems` `:12013`); `MH:12795` |
| Scrollable card list: `AlertDialog.Builder` + `ScrollView` → vertical `LinearLayout` (padding 40) → per-row `LinearLayout` (bg `0xFF2A2A2A`, padding `10,15,10,15`, bottom margin 10) with `TextView`s (title 18 sp bold `0xFF66FF66`, meta 14 sp `0xFF999999`, link 16 sp `0xFF6699FF` clickable → `Intent.ACTION_VIEW` geo/map URL), `setNegativeButton("Clear All")`, `setPositiveButton("Close", null)`, `builder.setView(scrollView); builder.show()` | `showReceivedStationsDialog(Activity)` `MH:4227-4370` |
| Table: `android.widget.TableLayout` with `setStretchAllColumns(true)`, header row helper `addPassTableHeader(TableLayout, Activity)` (11 sp bold `0xFF00AACC`), row helper `addPassTableRow(...)` with colour-coded cells, date separator row using `TableRow.LayoutParams.span` | `showNOAANextPassesDialog` `MH:7771`, `:7862-7935`, `:7902`, `:7917` |
| Settings form dialog | `showAPRSSettingsDialog(Activity[, Runnable onSaved])` `MH:4374/4378` |
| Progress | `ProgressDialogHolder` (§6.1) |

39 `AlertDialog.Builder` uses in `MainHook`; all wrap in try/catch and log `TAG + ": Error …"`.

---

## 7. Prefs

| Pref file | Opened as | Keys | Cite |
|---|---|---|---|
| `dmrmod_aprs_global` | `context.getSharedPreferences(PREFS_NAME, MODE_PRIVATE)` inside `APRSDatabase` | `callsign` (upper-cased, default `"N0CALL"`), `ssid`, `default_symbol_table`, `default_symbol_code`, `aprs_frequency`, `aprs_squelch` | `APRSDatabase.java:28-37`, `getCallsign/setCallsign` `:83-94` |
| `dmrmod_radioid_prefs` | `context.getApplicationContext().getSharedPreferences(...)` | `last_sync_ms`, `entry_count`, `source_file` | `RadioidDatabase.java:48-51`, `:186-190`, `:445-451` |
| `dmrmod_gps_prefs` | `context.getSharedPreferences("dmrmod_gps_prefs", MODE_PRIVATE)` | `gps_send_no_confirm` | `MH:2700-2702` |
| `dmrmod_sstv_global` | `activity.getSharedPreferences(...)` | SSTV settings | `MH:5632, 5848, 6023, 6579` |
| `dmrmod_noaa_global` | `activity.getSharedPreferences(...)` | NOAA settings | `MH:7366, 7483, 7724, 8026` |
| OEM `com.pri.prizeinterphone.data.person` | read-only by `OemChannelTable.areaKey` | `pref_person_channel_area_selected_index`, `pref_person_device_dmr_version` | `OemChannelTable.java:23-27, 41-52` |

Convention: `dmrmod_<feature>_global` (or `_prefs`), `MODE_PRIVATE`, opened on the hooked app's context (files land in `/data/data/<oem pkg>/shared_prefs/`). Feature: `dmrmod_repeaters_global` with e.g. `callsign` (reuse `APRSDatabase.getCallsign()` as default), `radius_km`, `source`, `last_sync_ms`.

---

## 8. Threading / UI / reflection rules

| Rule | Source |
|---|---|
| UI only on main thread: `activity.runOnUiThread(...)`; delayed via `new Handler(Looper.getMainLooper()).postDelayed`; never block UI with network/IO; background = `new Thread(() -> …).start()` | `RULES:436-454` (§4); practice `MH:4107-4129`, `RadioidDatabase.java:252, 350` |
| Every hook body and every click handler in try/catch; log `XposedBridge.log(TAG + ": ✗ …")` + `XposedBridge.log(t)` for throwables | `RULES:718-765` (§10), `MH:3985-3989`, `MH:4218-4221` |
| Log symbols: `✓` success, `✗` error, `◆` state change; `TAG = "DMRModHooks"`; view with `adb logcat | grep DMRModHooks` | `RULES:674-689` (§8), `MH:92` |
| Helper classes use `android.util.Log` with their own tag (`DMRModHooks_RadioID`, `DMRModHooks_DirectImport`) | `RadioidDatabase.java:44`, `IMP:65` |
| DB: transactions for multi-row work, close DBs, `rawQuery`/`execSQL` | `RULES:456-483` (§5) |
| Reflection into OEM classes uses the app classloader: `appClassLoader = lpparam.classLoader` (`MH:246`, `:335`) or `context.getClassLoader()` (`MH:14576`, `IMP:1281`) | |
| Worked example — build a `ChannelData` and insert: `Class<?> channelDataClass = XposedHelpers.findClass("com.pri.prizeinterphone.serial.data.ChannelData", appClassLoader); Object ch = channelDataClass.newInstance(); XposedHelpers.setIntField(ch, "type", 1); XposedHelpers.setObjectField(ch, "name", "APRS"); XposedHelpers.setIntField(ch, "rxFreq", hz); … XposedHelpers.callMethod(dmrManager, "createChannel", area, ch); XposedHelpers.callMethod(dmrManager, "updateChannelList");` | `createAPRSChannelIfNeeded(Activity, Object dmrManager, List<Object> channels)` `MH:5387-5447` (findClass `:5414-5418`, `newInstance` `:5419`, setters `:5422-5435`, `createChannel` `:5439`, refresh `:5445`) — note it sets `relay=0` and passes area `"default"`; do not copy those two lines |
| `DmrManager` handle: `XposedHelpers.callStaticMethod(XposedHelpers.findClass("com.pri.prizeinterphone.manager.DmrManager", cl), "getInstance")` | `MH:14574-14577` |
| Hardware push, if ever needed for the *active* channel: `callMethod(dmrManager, "syncChannelInfoWithData", cd)` — not needed for additive inserts (new rows are `active=0`) | `MH:2447, 5502, 8053, 12118` |
| Zone/TG DB singletons are created with the OEM fragment/activity context | `MH:1710-1711` |

---

## 9. Pitfalls that apply

| # | Rule | Why it matters here | Cite |
|---|---|---|---|
| 12 | `channel_txContact` = the DMR/TG ID, never contact `_id` | set `txContact = tgId`; contacts are looked up by `(contact_type, contact_number)` | `RULES:855-862`; `InterPhoneContactsFragment.java:224-230`; `UtilContactsData.java:136-156` |
| 11 | `relay` must be 1 or 2, never 0 (0 = "APRS/direct", channel fails to activate) | keep ctor default 2; importer coerces `0→2` (`IMP:766-779`) | `RULES:845-853`; editor `:664-670` |
| 8 / 13 | `updateChannel()+syncChannelInfo()` only programs when `active==1`, acks are matched by command byte only, and a 300 ms re-apply can race `SetChannelState` | additive inserts must stay `active=0` and never call `syncChannelInfo*`; if the user later selects the new channel the OEM path programs it | `RULES:821-833, 864-869`; `DmrManager.java:189-195` |
| — | `channel_band` is bandwidth (0 narrow / 1 wide), not UHF/VHF; UHF/VHF is derived from `txFreq` at display time | set 1 (wide) for FM repeaters unless the directory says 12.5 kHz | `05-oem…md §2, §10.1`; `InterPhoneChannelActivity.java:362-366, 725-729` |
| — | `interrupt` default 2 for every row, only transmitted for digital | leave 2 | `ChannelData.java:99`; `CmdStateMachine.java:289-301` |
| — | `channel_encryptSw ∈ {1,2}`, `encryptKey` non-NULL for digital rows | leave 2 / `""` | `DmrManager.java:342` |
| — | Exactly one `channel_active=1` per area DB; `addChannel` forces 1 only when none exists | insert with `active=0` | `UtilChannelData.java:84-86`; `DmrManager.java:280-291` |
| — | `number` is overwritten with rowid by `addChannel`; `_id` is the key for zones/TG assignments, `number` for locations | read both back from the object after `createChannel` | `UtilChannelData.java:91-94`; `11-mod…md §1.10` |
| — | `channel_groups` >32 tokens crashes every channel read | always `getHardwareGroups()` | `UtilChannelData.java:110-121` |
| — | Frequencies outside 400–480 / 136–174 MHz are refused by the editor; module behaviour unknown | filter directory results by band | `InterPhoneChannelActivity.java:562-591` |
| — | `DirectDatabaseImporter` is wipe-and-insert (`DELETE` + `sqlite_sequence` reset for channels `IMP:467-475` and contacts `IMP:1148-1156`; `LocationDatabase.clearAllLocations()` / `clearAllZones()`) | **must not be reused** for additive import; only its `ContentValues` shapes and `ToneConverter` calls are reference material | `11-mod…md §4.5` ("Upsert? No.") |
| — | Area-aware DB: the live table is `database_<area>` where area = `pref_person_channel_area_selected_index`; `getCurrentDb(unknownArea)` falls back to the default area | resolve with `OemChannelTable.areaKey(ctx)` / `tableName(ctx)` / `dbFileName(ctx)`, or `DmrManager.getCurrentDbHelper()`; pass that key to `createChannel(area, cd)` | `OemChannelTable.java:41-75`; `Constants.java:127-129`; `UtilInitChannelData.java:278-291` |
| — | `getCurrentLocation` is last-known-fix only, on the calling thread; Geocoder is synchronous | fetch position on the download thread, fall back to a typed grid/ZIP when null | `MH:3539-3604`, `:3200` |
| — | `ToneConverter.parseSubCode` returns 0 (62.5 Hz) when the string does not match exactly | format as `%.1f`, validate round-trip | `ToneConverter.java:149-156, 183` |
| — | `isAPRSChannel` hides names starting with `"APRS ("` from the channel list | avoid that prefix | `MH:311-319` |
| — | UI refresh: `updateChannelList()` refreshes the OEM fragment; the module's zone filter needs `currentZoneChannels` reloaded and `initData()` re-posted | see §1.5 | `MH:14537-14560` |
| 16 | PowerShell BOM in CSV | N/A — no CSV in this path | `RULES:905` |
