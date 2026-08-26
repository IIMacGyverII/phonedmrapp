# 05 — OEM Data Layer (PriInterPhone)

**Scope.** Everything PriInterPhone (`com.pri.prizeinterphone`) persists or holds in memory: the per-"area" SQLite channel databases, the contact / conversation / message / audio-record databases, the in-memory `*Data` classes, the two SharedPreferences files, the optional on-SD-card XML codeplug (`/sdcard/intercom/intercom_config.xml`), and the constants that bound all of it.

**One-paragraph summary.** The app keeps one SQLite file per channel "area" (`database_<areaKey>.db`, single table of the same name, schema v2, 25 columns) plus `contact_database.db`, `conversation_database.db`, `message_database.db` (one table per conversation) and `record_database.db`. Access is through thin `Util*Data` wrappers (no transactions, no ORDER BY on channels, cursors never closed) owned by the `DmrManager` singleton. First-run initialisation is hard-coded from `res/values/arrays.xml` frequency lists (8 digital + 8 analog for the default area, analog-only lists for 12 regional areas) and can optionally be replaced by an XML file on the SD card during factory reset. A stale earlier generation of the same classes (`com.pri.prizeinterphone.data.*`, `Util/UtilContactsData`, `Util/UtilMessageData`) is still compiled in but unreachable.

Path shorthand used below: **`P/`** = `app/src/main/java/com/pri/prizeinterphone/`. Everything not marked *inferred* is read directly from code.

## Source files

| File | Lines | Role | Live? |
|---|---|---|---|
| `P/serial/data/ChannelData.java` | 487 | Channel row model (Parcelable, Cloneable) | Yes |
| `P/serial/data/ContactData.java` | 125 | Contact row model | Yes |
| `P/serial/data/MessageData.java` | 172 | SMS row model | Yes |
| `P/serial/data/MessageListData.java` | 59 | `(id,value)` pair for `message_list_database` | No callers |
| `P/serial/data/ConversationData.java` | 130 | Conversation row model | Yes |
| `P/serial/data/AudioRecordData.java` | 144 | Recording row model | Yes |
| `P/serial/data/DBChannelHelper.java` | 83 | `SQLiteOpenHelper` for `database_<area>.db` (v2) | Yes |
| `P/serial/data/DBContactHelper.java` | 44 | Helper for `contact_database.db` (v1) | Yes |
| `P/serial/data/DBGroupHelper.java` | 44 | Helper for `group_database.db` — invalid DDL | Dead |
| `P/serial/data/DBMessageHelper.java` | 50 | Helper for `message_database.db` (v1, lazy tables) | Yes |
| `P/serial/data/DBConversationHelper.java` | 44 | Helper for `conversation_database.db` (v1) | Yes |
| `P/serial/data/DBAudioRecordHelper.java` | 45 | Helper for `record_database.db` (v1) | Yes |
| `P/serial/data/UtilChannelData.java` | 219 | Channel CRUD per area DB | Yes |
| `P/serial/data/UtilInitChannelData.java` | 625 | Area registry + default codeplug + XML import | Yes |
| `P/serial/data/UtilContactsData.java` | 213 | Contact CRUD | Yes |
| `P/serial/data/UtilMessageData.java` | 202 | SMS CRUD | Yes (partly dead) |
| `P/serial/data/UtilConversationData.java` | 102 | Conversation CRUD | Yes |
| `P/serial/data/UtilRecordData.java` | 70 | Recording CRUD | Yes |
| `P/serial/data/PersonSharePrefData.java` | 86 | Prefs file `com.pri.prizeinterphone.data.person` | Yes |
| `P/serial/data/CurrentChannelSharePrefData.java` | 39 | Prefs file `com.pri.prizeinterphone.data.currentchannel` | No callers |
| `P/data/*.java` (8 files) | 450 | Gen-1 duplicates (see §1.9) | Dead |
| `P/Util/UtilContactsData.java`, `P/Util/UtilMessageData.java` | 144 / 118 | Gen-1 CRUD (people_/group_/message_ tables) | Dead |
| `P/Util/ReadFileUtils.java` | 156 | sysfs GPIO control for module (`/sys/devices/platform/dmr009/{debug,ptt,pwd}`) | Yes |
| `P/Util/Util.java` | 79 | NVRAM update-status stubs, tab ids, hex helper | Yes |
| `P/Util/Clog.java`, `ExecutorManager.java`, `NamedThreadFactory.java`, `UtilDensity.java`, `UtilPicture.java`, `UtilRecorder.java` | — | Logging (`tag "fzc"`), serial thread pools, dp/px, photo intents, empty class | Yes/—
| `P/config/ConfigXmlPullParser.java` | 206 | XML codeplug parser | Yes (reset path) |
| `P/config/data/{InsertChannel,InsertChannels,InsertConfig,ParseConfig,InValidException}.java` | 356/56/68/54/20 | Parsed-XML DTOs | Yes |
| `P/config/tag/*.java` (28 files) | — | Tag names, per-tag enable flags, validators | Yes |
| `P/constant/Constants.java` | 134 | Band limits, area keys, area registry helpers | Yes |
| `app/src/main/res/values/arrays.xml` | — | Default frequency lists, tone tables, enum labels | Yes |
| `DMRModHooks/database_channel_area_default_uhf.db` | — | Real device sample of the channel DB (inspected via Python `sqlite3`; `sqlite3` CLI not on PATH) | — |

---

## 1. SQLite databases

All files live in the app's private `databases/` directory (`Context.getDatabasePath(name)`), i.e. `/data/data/com.pri.prizeinterphone/databases/` on a stock install. **This repo rebuilds the APK as `applicationId "com.macgyver.dmr"`** (`app/build.gradle:11`, namespace stays `com.pri.prizeinterphone` at line 6), so on a device running the rebuilt app the path is `/data/data/com.macgyver.dmr/databases/`.

### 1.1 Overview

| File | Helper (version) | Table(s) | Wrapper | Created |
|---|---|---|---|---|
| `database_<areaKey>.db` (one per area, e.g. `database_channel_area_default_uhf.db`) | `DBChannelHelper` (2) | `database_<areaKey>` | `UtilChannelData` | first `getWritableDatabase()` |
| `contact_database.db` | `DBContactHelper` (1) | `contact_database` | `UtilContactsData` | `DmrManager` ctor (`P/manager/DmrManager.java:133`) |
| `conversation_database.db` | `DBConversationHelper` (1) | `conversation_database` | `UtilConversationData` | `DmrManager.java:134` |
| `message_database.db` | `DBMessageHelper` (1) | `message_db_<convType>_<target>` (lazy, N tables) | `UtilMessageData` | `DmrManager.java:132` (opened eagerly in ctor `UtilMessageData.java:35`) |
| `record_database.db` | `DBAudioRecordHelper` (1) | `record_database` | `UtilRecordData` | `DmrManager.java:135` (opened eagerly `UtilRecordData.java:29`) |
| `group_database.db` | `DBGroupHelper` (1) | `group_databas` | — | never (dead; DDL invalid) |
| `channel_database.db` | `DBChannelHelper(Context)` 1-arg ctor (`DBChannelHelper.java:53`) | — | `UtilChannelData(Context)` (`UtilChannelData.java:48`) | never called (grep: only the 2-arg ctor is used) |
| `people_database.db` | gen-1 `P/data/DBPeopleHelper` | `people_database` | gen-1 `Util/UtilContactsData` | never |

`sqlite_master` of the sample DB confirms only `android_metadata`, `database_channel_area_default_uhf`, `sqlite_sequence`; `PRAGMA user_version = 2`.

### 1.2 Channel databases — `database_<areaKey>.db`

**Naming.** `new DBChannelHelper(context, areaKey)` → `super(context, "database_" + areaKey + ".db", null, 2)` and `this.name = areaKey` (`DBChannelHelper.java:58-60`). The table name is `"database_" + name` (`:67`). `UtilChannelData(Context, areaKey)` sets `mDBName = "database_" + areaKey`, `mDataName = areaKey` (`UtilChannelData.java:53-57`).

**Area keys** (`P/constant/Constants.java:23-38`): `channel_area_default`, `channel_area_default_uhf`, `channel_area_default_vhf`, `channel_area_cn`, `channel_area_tw`, `channel_area_eu`, `channel_area_usa`, `channel_area_aus`, `channel_area_rus`, `channel_area_iran`, `channel_area_ko`, `channel_area_malaysia`, `channel_area_japan`, `channel_area_norway`, `channel_area_south_af`, plus user-created `extra_channel_area_yyyyMMdd_HHmmss` (`Constants.randExtraChannelAreaName()` `:50-53`).

**Which default area exists** depends on the module version string: `Constants.KEY_DEF_AREA` is `channel_area_default_uhf` when `DmrManager.isSupportUVFrequencyBand()` else `channel_area_default` (`Constants.java:46-48`). `isSupportUVFrequencyBand()` splits `pref_person_device_dmr_version` (default `"DMR003.UV4T.V022"`) on `.` and tests whether segment[2] (`"UV4T"`) starts with `"UV"` (`DmrManager.java:946-956, 972-982`). `initDefChannelAreas()` (`Constants.java:55-76`) puts `default_uhf` + `default_vhf` (UV module) or `default` (U/V-only module) first, then the 12 regional keys. So a UV radio has **14 area DBs** by default (`database_channel_area_default_uhf.db`, `database_channel_area_default_vhf.db`, 12 regional). There is no per-region VHF variant.

**The registry of areas** is not in SQLite: it is a JSON `LinkedHashMap<String,String>` (areaKey → display key/name) in pref `pref_person_device_area_list` (`Constants.getSavedChannelAreas` `:78-88`).

**CREATE (verbatim from `DBChannelHelper.onCreate`, `DBChannelHelper.java:67`, `<name>` = area key):**

```sql
create table database_<name>(_id integer primary key autoincrement, channel_name varchar ,channel_type integer ,channel_number integer ,channel_txFreq integer ,channel_rxFreq integer ,channel_power integer ,channel_cc integer ,channel_inBoundSlot integer ,channel_outBoundSlot integer ,channel_mode integer ,channel_contactType integer ,channel_txContact integer ,channel_encryptSw integer ,channel_encryptKey varchar ,channel_relay integer ,channel_interrupt integer ,channel_band integer ,channel_sq integer ,channel_rxType integer ,channel_rxSubCode integer ,channel_txType integer ,channel_txSubCode integer ,channel_active integer ,channel_groups varchar )
```

**onUpgrade** (`:70-78`): if `oldVersion < 2`, `alter table database_<name> add channel_inBoundSlot integer`, `... add channel_outBoundSlot integer`, `... add channel_mode integer`. Readers tolerate their absence (`getColumnIndex(...) != -1 ? ... : 0`, `UtilChannelData.java:137`). No indexes, no UNIQUE constraints, no NOT NULL, no defaults other than SQLite NULL.

**Columns** (SQL name → `ChannelData` field; constants in `UtilChannelData.java:16-40` and duplicated in `DBChannelHelper.java:16-37`, where `TABLE_ID` is wrongly `"channel_id"` — unused):

| Column | Type | Field | Meaning / valid values | Java default |
|---|---|---|---|---|
| `_id` | INTEGER PK AUTOINCREMENT | `_id` | Row id; the app sets `number = _id` right after insert | 0 (unset) |
| `channel_name` | varchar | `name` | Display name. **NULL** for factory defaults (never set by `buildDefault*Channel`); UI synthesises `"Digtal channel N"`/`"Aanalog channel N"` when empty (`P/activity/InterPhoneChannelActivity.java:645-650`) | `null` |
| `channel_type` | integer | `type` | `0` = Digital (`ChannelType.DIGITAL`), `1` = Analog (`ChannelType.ANALOG`) (`ChannelData.java:73-76`) | 0 |
| `channel_number` | integer | `number` | Display number; set to the new rowid in `addChannel` (`UtilChannelData.java:92-95`); never re-packed after delete; not unique; **never used for ordering by the OEM app** | 0 |
| `channel_txFreq` | integer | `txFreq` | Hz | 401025000 |
| `channel_rxFreq` | integer | `rxFreq` | Hz | 401025000 |
| `channel_power` | integer | `power` | `0` LOW, `1` HIGE[sic] (`:67-70`) | 1 |
| `channel_cc` | integer | `cc` | DMR colour code 0–15 (UI array `interphone_channel_color_values`) | 1 |
| `channel_inBoundSlot` | integer (v2) | `inBoundSlot` | 0 = Slot 1, 1 = Slot 2 (UI sets in/out identically, `InterPhoneChannelActivity.java:716-721`) | 0 |
| `channel_outBoundSlot` | integer (v2) | `outBoundSlot` | as above | 0 |
| `channel_mode` | integer (v2) | `channelMode` | `0` "Direct mode", **`4`** "Double slot" (`:711-714`) | 0 |
| `channel_contactType` | integer | `contactType` | `0` PERSON, `1` GROUP, `2` ALL (`:53-57`) | 0 |
| `channel_txContact` | integer | `txContact` | Target DMR ID / TG ID; `16777215` when ALL (`:680`); UI limits 1–16776415 (`:600-606`) | 1 |
| `channel_encryptSw` | integer | `encryptSw` | **`1` = enabled, `2` = disabled** (`:685, :699`) | 2 |
| `channel_encryptKey` | varchar | `encryptKey` | Key string, zero-padded to 8 chars when 2–7 long (`:686-695`); `""` when disabled; NULL possible for defaults built outside `ChannelData()` | `""` |
| `channel_relay` | integer | `relay` | "Relay disconnect": **`2` = Disable (default), `1` = Enable** (`:663-668`) | 2 |
| `channel_interrupt` | integer | `interrupt` | `1` ON (`ChannelInterrupt.OPEN`), `2` OFF, `3` "transmit" (`TRANSPORT`) (`ChannelData.java:60-64`; UI `:703-707`). Only edited for digital channels; analog rows keep whatever was there (default 2) | 2 |
| `channel_band` | integer | `band` | **Analog bandwidth: `0` Narrow, `1` Wide** (`:724-727`, labels `interphone_channel_band_narrow/wide`). Not UHF/VHF | 0 |
| `channel_sq` | integer | `sq` | Analog squelch level; UI list 1–9 (`interphone_channel_sq_values`), XML allows 0–10 | 2 |
| `channel_rxType` | integer | `rxType` | RX sub-audio: `0` Wave(none), `1` CTCSS, `2` Forward DCS, `3` Backward DCS (`:743-754`) | 0 |
| `channel_rxSubCode` | integer | `rxSubCode` | Index into the tone table selected by `rxType` (§8.3) | 0 |
| `channel_txType` | integer | `txType` | same encoding as `rxType` (`:730-741`) | 0 |
| `channel_txSubCode` | integer | `txSubCode` | Index into tone table for `txType` | 0 |
| `channel_active` | integer | `active` | `1` = selected channel of this area; app assumes at most one | 0 |
| `channel_groups` | varchar | `groups` (`int[32]`) | RX group list, comma-joined 32 ints, e.g. `"1,0,0,…,0"` (`coverGroupsString` `UtilChannelData.java:97-108`); parser pads shorter strings, **crashes (`ArrayIndexOutOfBounds`) on >32 entries** (`:110-121`) | `{1,0,…}` |

Field in class but not in DB: `mic` (`ChannelData.java:36`, always 0, not parcelled, not persisted; mic gain actually comes from prefs). DB column not in class: none.

**Sample DB observations** (`DMRModHooks/database_channel_area_default_uhf.db`, 17 rows, written by the DMRModHooks importer, not by the OEM UI): `channel_band` = 1 for VHF rows and 0 for UHF rows — that is the *module's* reinterpretation of the column; `channel_interrupt` = 0 for all analog rows and 2 for digital; `channel_relay` = 1 for 16 rows; `channel_encryptKey` is NULL on analog rows. See ⚠️ Doc drift in §2.

### 1.3 `contact_database.db`

```sql
create table contact_database(_id integer primary key autoincrement, contact_name varchar ,contact_type integer ,contact_number varchar ,contact_active integer ,contact_icon varchar)
```
(`DBContactHelper.java:38`; version 1; `onUpgrade` empty.)

| Column | Type | `ContactData` field | Meaning |
|---|---|---|---|
| `_id` | INTEGER PK | `_id` (int) | Row id (not a DMR ID) |
| `contact_name` | varchar | `name` | Display name |
| `contact_type` | integer | `type` | `0` PERSON, `1` GROUP (`ContactData.java:29-32`); only 0/1 queried by UI (`P/fragment/InterPhoneContactsFragment.java:115,123`) |
| `contact_number` | varchar (TEXT) | `number` (String) | DMR ID / TG ID as decimal text; lookups pass ints stringified (`UtilContactsData.java:140`) |
| `contact_active` | integer | `active` | Written only by `addContact(ContactData)` (`:50`), which has no callers; `updateContact` omits it (`:117-127`) → in practice always 0/NULL, so `getActiveContact()` returns null (*inferred*) |
| `contact_icon` | varchar | `bitmap` | Base64 (`Base64.DEFAULT` encode / `NO_WRAP` decode) of JPEG q100, `""` if none |

### 1.4 `group_database.db` (gen-2 copy) — dead, invalid

```sql
create table group_databas(_id integer primary key autoincrement, _id varchar UNIQUE ON CONFLICT REPLACE, contact_name varchar ,contact_icon varchar )
```
(`P/serial/data/DBGroupHelper.java:38`.) Two `_id` columns → SQLite would throw `duplicate column name`. Never instantiated (only gen-1 `Util/UtilContactsData` news a `DBGroupHelper`, and that is the gen-1 class).

### 1.5 `message_database.db`

`DBMessageHelper.onCreate` and `onUpgrade` are empty (`DBMessageHelper.java:18-24`). Tables are created lazily per conversation by `createTableIfNotExist(db, tableName)` (`:47-49`):

```sql
CREATE TABLE IF NOT EXISTS <tbl>(_id integer primary key autoincrement, message_id varchar ,message_convType integer ,message_conv_target integer ,message_from integer ,message_to integer ,message_content varchar ,message_status integer ,message_timestamp varchar ,message_direction integer)
```
`<tbl>` = `"message_db_" + convType + "_" + convTarget` (`UtilMessageData.getDbName` `:67-69`), e.g. `message_db_1_9` for group TG 9, `message_db_0_3199587` for a private chat.

| Column | Type | `MessageData` field | Meaning |
|---|---|---|---|
| `_id` | INTEGER PK | — | |
| `message_id` | varchar | `id` (long) | Written as Long (`:42`); always 0 from `new MessageData()` — read back with `getInt` |
| `message_convType` | integer | `convType` | `0` private, `1` group (= `FetchSmsMessage.type`, `DmrManager.java:456`) |
| `message_conv_target` | integer | `conv_target` | Peer DMR ID (private) or channel `txContact` (group) (`DmrManager.java:455-462`) |
| `message_from` | integer | `from` | Sender DMR ID (`fetchSmsMessage.callID` or own `pref_person_device_id`) |
| `message_to` | integer | `to` | Recipient ID |
| `message_content` | varchar | `content` | Text |
| `message_status` | integer | `status` | `0` UNREAD, `1` READ, `2` SUCCESS, `3` FAIL (`MessageData.java:37-42`) |
| `message_timestamp` | **varchar** | `timestamp` (long) | `System.currentTimeMillis()` stored into a TEXT-affinity column (SQLite converts to text); used as the row key for update/delete (`:60, :72`) and `ORDER BY message_timestamp desc` (string order — fine while all values are 13 digits) |
| `message_direction` | integer | `direction` | `0` SENT, `1` RECEIVE (`:31-34`) |

`message_list_database` (`message_list_id`, `message_list_value`) is referenced by `insertList/deleteListData/queryListData/updateListData` (`UtilMessageData.java:150-186`) but **never created** by the gen-2 helper and has no callers. Likewise `getAllSms(String)` / `getAllSms(int)` query the non-existent table `message_db` (`:81, :130`) — reachable only via `DmrManager.getAllSms(String|int)` which nothing calls.

### 1.6 `conversation_database.db`

```sql
create table conversation_database(_id integer primary key autoincrement, conver_id varchar ,conver_type integer ,conver_target integer ,conver_name varchar ,conver_timestamp  varchar ,conver_unreadcount integer)
```
(`DBConversationHelper.java:38`.)

| Column | Type | `ConversationData` field | Meaning |
|---|---|---|---|
| `_id` | INTEGER PK | — | rowid (only used as the return of `addConversation`) |
| `conver_id` | varchar | `_id` | Copy of the rowid written back by `updateConverstion` (`UtilConversationData.java:42`); this is what `getConversation` returns as `_id` (`:68`) |
| `conver_type` | integer | `convType` | 0 private / 1 group |
| `conver_target` | integer | `convTarget` | Peer ID / TG; (`type`,`target`) is the logical key (`:50, :58, :65`) |
| `conver_name` | varchar | `name` | Contact name if found, else the ID as text (`DmrManager.java:537-548`) |
| `conver_timestamp` | varchar | `timestamp` (Long) | Last message time; list is `ORDER BY conver_timestamp desc` (`:83`) |
| `conver_unreadcount` | integer | `unReadCount` | Incremented per received message (`DmrManager.java:551-561`) |

### 1.7 `record_database.db`

```sql
CREATE TABLE IF NOT EXISTS record_database(_id integer primary key autoincrement, record_name varchar ,record_channelName varchar ,record_timestamp integer ,record_direction integer ,record_filePath varchar )
```
(`DBAudioRecordHelper.java:43`.)

| Column | `AudioRecordData` field | Meaning |
|---|---|---|
| `_id` | `id` (long) | |
| `record_name` | `name` | Display name |
| `record_channelName` | `channelName` | Actually the channel **number** as text (`P/fragment/InterPhoneTalkBackFragment.java:425, 653`) |
| `record_timestamp` | `timestamp` | ms; used as delete key (`UtilRecordData.java:49`); list `ORDER BY record_timestamp desc` |
| `record_direction` | `direction` | `0` SENT, `1` RECEIVE |
| `record_filePath` | `filePath` | PCM file path under `/sdcard/interphone/record/` (`P/manager/PCMReceiveManager.java:39,156`) |

Insert pattern: `addRecordData` inserts `record_name` only, then `updateRecordData` fills every column by `_id` (`DmrManager.addRecordDb` `:155-159`). `isplay` is UI-only.

### 1.8 `android_metadata`

Every DB also has `android_metadata(locale TEXT)` (framework). `UtilMessageData.resetData()` iterates **all** `sqlite_master` tables and runs `delete from <name>` on each, including `android_metadata` and `sqlite_sequence` (`UtilMessageData.java:188-201`).

### 1.9 The `P/data/` package — dead generation 1

`grep -rn "import com.pri.prizeinterphone.data\."` hits only `P/Util/UtilContactsData.java:13-15` and `P/Util/UtilMessageData.java:10-12`; those two classes are imported/instantiated by **nothing** (grep `Util\.UtilContactsData|Util\.UtilMessageData|new UtilContactsData(` → only `DmrManager.java:132-133`, which imports the `serial.data` versions). 25 files import `serial.data.*`. The gen-1 classes also call `InterPhoneApplication.getContext()`; the manifest registers `PrizeInterPhoneApp` (`AndroidManifest.xml:9`), so `InterPhoneApplication.context` is never set → any use would NPE.

Gen-1 schemas (never created on a device running this build, but a leftover from an older APK version *could* exist under the same file names):

| Gen-1 file | Table | DDL (`P/data/...`) |
|---|---|---|
| `people_database.db` | `people_database` | `(_id integer primary key autoincrement, person_id varchar UNIQUE ON CONFLICT REPLACE, person_name varchar ,person_icon varchar )` (`DBPeopleHelper.java:38`) |
| `group_database.db` | `group_databas` | same columns as above (`DBGroupHelper.java:38`) |
| `message_database.db` | `message_db_<type>_<messageId>`, `message_list_database` | `(_id …, message_time varchar UNIQUE ON CONFLICT REPLACE, message_value varchar, message_recieve varchar)`; `(_id …, message_list_id varchar UNIQUE ON CONFLICT REPLACE, message_list_value varchar)` (`DBMessageHelper.java:39-40`) |

Gen-1 models: `ContactData(id:String,name,bitmap)`, `MessageData(time:String,value,isRecieve:int)`, `MessageListData(id,value)`; gen-1 `PersonSharePrefData` uses the **same prefs file** but different key spellings (`pref_person_contacts_seleted*`, `pref_person_message_db_version`). Verdict: earlier generation of the same design, fully superseded; safe to ignore except for the file-name collision on `message_database.db` / `group_database.db` when upgrading from an old build (gen-2 `DBMessageHelper` is v1 with no `onUpgrade`, so a gen-1 `message_db_*` table with different columns would not be migrated — *inferred*).

---

## 2. `ChannelData` in detail

Declared `P/serial/data/ChannelData.java:25-50`; defaults `:83-111` (identical block in the Parcel ctor `:372-396`); full 25-arg ctor `:113-140` used by every cursor read. `clone()` deep-copies `groups` (`:452-486`).

| Field | Type | Meaning | Range | Default | DB column | Serial consumer |
|---|---|---|---|---|---|---|
| `_id` | int | rowid | ≥1 | 0 | `_id` | — |
| `name` | String | label | any / NULL | `null` | `channel_name` | — |
| `type` | int | 0 Digital / 1 Analog | {0,1} | 0 | `channel_type` | selects `DigitalMessage` vs `AnalogMessage` (`DmrManager.sendSetChannelCmdToMdl` `:792-810`) |
| `number` | int | display number | ≥1 | 0 | `channel_number` | — (title only) |
| `txFreq` | int | Hz | U 400 000 000–480 000 000 / V 136 000 000–174 000 000 (`InterPhoneChannelActivity.isParamsCorrect` `:574-591`) | 401025000 | `channel_txFreq` | `DigitalMessage.txFreq` / `AnalogMessage.txFreq` |
| `rxFreq` | int | Hz | same | 401025000 | `channel_rxFreq` | `DigitalMessage.rxFreq` / `AnalogMessage.rxFreq` |
| `power` | int | 0 low / 1 high | {0,1} | 1 | `channel_power` | `.power` (both messages) |
| `cc` | int | colour code | 0–15 | 1 | `channel_cc` | `DigitalMessage.cc` |
| `inBoundSlot` | int | 0 TS1 / 1 TS2 | {0,1} | 0 | `channel_inBoundSlot` | `DigitalMessage.inboundSlot` |
| `outBoundSlot` | int | 0 TS1 / 1 TS2 | {0,1} | 0 | `channel_outBoundSlot` | `DigitalMessage.outboundSlot` |
| `channelMode` | int | 0 direct / 4 double-slot | {0,4} | 0 | `channel_mode` | `DigitalMessage.channelMode` |
| `contactType` | int | 0 person / 1 group / 2 all | {0,1,2} | 0 | `channel_contactType` | `DigitalMessage.contactType`; also picks SMS type 1/3/2 (`DmrManager.sendSms` `:483-490`) |
| `txContact` | int | target DMR/TG ID | 1–16776415, or 16777215 (all) | 1 | `channel_txContact` | `DigitalMessage.txContact`; `SendSmsMessage.callNumber` |
| `encryptSw` | int | 1 on / 2 off | {1,2} | 2 | `channel_encryptSw` | `DigitalMessage.encryptSw` |
| `encryptKey` | String | key text | ≤8 chars (UI pads to 8) | `""` | `channel_encryptKey` | `DigitalMessage.encryptKey = key.getBytes()` (raw ASCII, not hex-decoded) or 8 zero bytes if `""` (`DmrManager.java:342`) |
| `mic` | int | unused | — | 0 | — | — (`DigitalMessage.mic` comes from pref `pref_person_mic_gan_value`, `:360`) |
| `relay` | int | relay-disconnect: 2 disable / 1 enable | {1,2} | 2 | `channel_relay` | `DigitalMessage.relay`, `AnalogMessage.relay`, `RelayMessage.relay` (`:751`) |
| `interrupt` | int | 1 ON / 2 OFF / 3 transmit | {1,2,3} | 2 | `channel_interrupt` | `InterruptMessage.interrupt`, sent by `CmdStateMachine` **only after the digital set-channel ack** (`P/state/CmdStateMachine.java:289-301`); when 3 the machine stops early and no interrupt cmd is sent |
| `band` | int | analog bandwidth 0 narrow / 1 wide | {0,1} | 0 | `channel_band` | `AnalogMessage.band` |
| `sq` | int | squelch | UI 1–9 | 2 | `channel_sq` | `AnalogMessage.sq` |
| `rxType` | int | 0 none/1 CTCSS/2 DCS-N/3 DCS-I | 0–3 | 0 | `channel_rxType` | `AnalogMessage.rxType` |
| `rxSubCode` | int | tone-table index | 0–50 (CTCSS) / 0–82 (DCS) | 0 | `channel_rxSubCode` | `AnalogMessage.rxSubCode` |
| `txType` | int | as rxType | 0–3 | 0 | `channel_txType` | `AnalogMessage.txType` |
| `txSubCode` | int | tone index | as above | 0 | `channel_txSubCode` | `AnalogMessage.txSubCode` |
| `active` | int | selected channel | {0,1} | 0 | `channel_active` | gates `syncChannelInfo` (`DmrManager.java:189-195`) |
| `groups` | int[32] | RX group list (TG IDs) | each ≤16776415 (`:610-615`) | `{1,0×31}` | `channel_groups` | `DigitalMessage.groupList` **only when `contactType == 1`** (`:351-352`); otherwise the message default `{1,0,…}` is sent |

**Serial wire layout consumed** (all little-endian, `P/Util/ByteBuf.java:19`):
- `DigitalMessage.encodeBody` (`P/message/DigitalMessage.java:129-152`), 163-byte body: `rxFreq(4) txFreq(4) localId(4) groupList(32×4=128) txContact(4) contactType power cc inboundSlot outboundSlot channelMode encryptSw encryptKey(8) pwrSave volume mic relay`. `localId` = `DmrManager.localId` (pref `pref_person_device_id`), not a channel column.
- `AnalogMessage.encodeBody` (`P/message/AnalogMessage.java:56-71`), 19-byte body: `rxFreq(4) txFreq(4) band power sq rxType rxSubCode txType txSubCode pwrSave volume monitor relay`.

**Verification of the project notes' claims:**
- `type` `"0"`=Digital, `"1"`=Analog — **values correct, storage type wrong**: column is `integer`, written via `ContentValues.put(String, Integer)` (`UtilChannelData.java:64`). ⚠️ Doc drift: notes say "stored as text in DB".
- `relay` 1/2 — **correct** (2 = disconnect *disabled* = default; 1 = enabled). "Firmware rejects 0" cannot be verified from app code; the app simply never writes 0.
- `interrupt` "2 for digital / 0 for analog" — ⚠️ Doc drift. OEM default is **2 for every channel** (`ChannelData.java:99`); the editor only changes it on digital channels; nothing writes 0; and the value is only transmitted for digital channels. `0` on analog rows is a DMRModHooks importer convention, harmless because unused.
- `groups` int[32] — **correct** (`:107-111`).
- ⚠️ Doc drift: `channel_band` is analog **bandwidth** (narrow/wide), not UHF/VHF. The UHF/VHF selector in the editor (`mTvChannelFrqBand`) is derived from `txFreq` at display time (`InterPhoneChannelActivity.java:362-366`) and only drives range validation; it is not persisted.
- ⚠️ Doc drift: `channel_encryptSw` is `1`=on / `2`=off, not 0/1.
- ⚠️ Doc drift: `channel_mode` "double slot" is `4`, not 1.

---

## 3. Other data classes

| Class | Fields (type) | Notes |
|---|---|---|
| `ContactData` (`P/serial/data/ContactData.java`) | `_id:int, type:int, name:String, number:String, active:int, bitmap:Bitmap` | Parcelable; `ContactType.PERSON=0, GROUP=1`; ctor order `(id, type, name, number, active, bitmap)` (`:44-51`) |
| `MessageData` | `id:long, convType:int, conv_target:int, from:int, to:int, content:String, status:int, timestamp:long, direction:int` | Defaults `conv_target=from=to=1` (`:61-70`); `SmsStatus` 0 UNREAD,1 READ,2 SUCCESS,3 FAIL; `SmsDirection` 0 SENT,1 RECEIVE |
| `MessageListData` | `id:String, value:String` | dead |
| `ConversationData` | `_id:int, convType:int, convTarget:int, name:String, timestamp:Long, unReadCount:int` | package-private fields with getters; `timestamp` boxed `Long` (NPE in `writeToParcel` if null) |
| `AudioRecordData` | `id:long, name, channelName, timestamp:long, direction:int, filePath, isplay:boolean` | Parcel read uses `readInt()` for timestamp (`:70`) while write uses `writeLong` (`:80`) — Parcel round-trip bug (*read from code*) |

---

## 4. DB wrapper APIs

All wrappers call `mHelper.getWritableDatabase()` per operation (no transactions, no `cursor.close()`), so every read/write is autocommitted. `close()` closes the last obtained DB.

### 4.1 `UtilChannelData` (`P/serial/data/UtilChannelData.java`)

| Method | SQL | Returns | Callers |
|---|---|---|---|
| `UtilChannelData(Context, area)` `:53` | opens `database_<area>.db` | — | `UtilInitChannelData.java:35,40,280` |
| `addChannel(ChannelData)` `:59-95` | `INSERT` all columns except `_id`; if `getActiveChannel()==null` sets `active=1` first (`:84-86`); then sets `_id = number = rowid` and calls `updateChannel` (`:92-94`) | void | `DmrManager.createChannel` `:266`, `UtilInitChannelData.insertChannelDataToDb` `:579` |
| `updateChannel(ChannelData)` `:175-205` | `UPDATE … WHERE _id = ?` (all columns) | void | `DmrManager.updateChannel` `:254,260`; `InterPhoneChannelActivity.java:775`; `InterPhoneChannelFragment.java:382,388`; `InterPhoneTalkBackFragment.java:340,346`; init code |
| `deleteChannel(ChannelData)` `:123-128` | `DELETE WHERE _id = ?` | void | `DmrManager.deleteChannel` `:271,276` |
| `getChannel(int id)` `:153-163` / `getChannelInfo(int)` `:130-140` (identical) | `SELECT * WHERE _id=? LIMIT 1` (`InboundSmsHandler.SELECT_BY_ID`, framework constant `"_id=?"` — *inferred*) | `ChannelData` or null | `InterPhoneChannelActivity.java:341`; `insertChannelDataToDb` `:576`; `getChannelInfo` has no callers |
| `getActiveChannel()` `:142-151` | `SELECT * WHERE channel_active=1 LIMIT 1` | `ChannelData` or null | only `addChannel` |
| `getAllChannels()` `:165-173` | `SELECT *` — **no ORDER BY** (rowid order) | `ArrayList<ChannelData>` | `DmrManager.java:167,218,228,238,242,288`; area activities |
| `deleteAll()` `:214-218` | `delete from database_<area>` | void | `UtilInitChannelData` reset paths |
| `coverGroupsString(int[])` / `coverGroupInt(String)` `:97-121` | — | groups ⇄ CSV | internal |

Channel CRUD pattern: create → `DmrManager.createChannel(area, cd)` → `addChannel` + `updateChannelList()` (no serial sync). Edit → `DmrManager.updateChannel(area, cd)` → `updateChannel` + `updateChannelList()` + `syncChannelInfo(cd)` (serial push only if `cd.active==1`). Editing the **active** channel instead goes `syncChannelInfoWithData(cd)` first and only writes the row after the module acks cmd 34/35 (`InterPhoneChannelActivity.java:757-790`). Switching channel: set old `active=0`, new `active=1`, two `updateChannel` calls, after the module ack (`InterPhoneChannelFragment.java:378-390`).

### 4.2 `UtilContactsData` (`P/serial/data/UtilContactsData.java`)

| Method | SQL | Returns | Callers |
|---|---|---|---|
| `addContact()` `:36-41` | `INSERT (contact_name='')` | rowid | `DmrManager.saveContact` `:613` |
| `addContact(ContactData)` `:43-59` | `INSERT` incl. explicit `_id` | rowid | none |
| `updateContact(ContactData)` `:114-134` | `UPDATE _id,name,type,number,icon WHERE _id=?` (not `active`) | `update==1` | `DmrManager.updateContact/saveContact` `:605,615` |
| `deleteContact(ContactData)` `:61-66` | `DELETE WHERE _id=?` | void | `DmrManager.deleteContact` `:624` |
| `getAllContacts()` `:68-89` / `getAllContacts(int type)` `:91-112` | `SELECT *` / `WHERE contact_type=?` | list | `DmrManager.java:573,577` ← `InterPhoneContactsFragment.java:115,123` |
| `getContact(int type, int number)` `:136-156` | `WHERE contact_type=? AND contact_number=? LIMIT 1` | `ContactData`/null | `DmrManager.java:538,542,601` (conversation naming, duplicate check `FragmentNewContactsActivity.java:351`) |
| `getContact(int id)` `:158-178` | `WHERE _id=?` | | `DmrManager.java:597` ← `FragmentNewContactsActivity.java:167` |
| `getActiveContact()` `:180-199` | `WHERE contact_active=1 LIMIT 1` | | `DmrManager.getCurrentContact` `:326` |
| `resetData()` `:201-205` | `DELETE` all | | `DmrManager.resetData` `:910` |

`contact_number` is the 24-bit DMR ID as text; `channel_txContact` stores the same ID (as int), not the contact `_id` — matches the notes.

### 4.3 `UtilMessageData` (`P/serial/data/UtilMessageData.java`)

| Method | SQL | Callers |
|---|---|---|
| `addSms(MessageData)` `:38-52` | `CREATE TABLE IF NOT EXISTS message_db_<t>_<target>` then `INSERT` | `DmrManager.onSmsReceived` `:468`, `saveSms` `:477` |
| `updateSms(MessageData)` `:54-61` | `UPDATE message_status WHERE message_timestamp = ?` | `onSmsSendSuccess/Fail` `:502,508` |
| `deleteSms(MessageData)` `:71-73` | `DELETE WHERE message_timestamp = ?` | `DmrManager.deleteSms` `:514` |
| `deleteAllSms(t,target)` `:75-77` | `DELETE` all rows of that table (table kept) | `:520` |
| `getAllSms(t,target)` `:112-124` | `WHERE message_to=? OR message_from=? ORDER BY message_timestamp` (only if table exists) | `:589` ← `MessageContentActivity.java:147-148` |
| `getLastSms(t,target)` `:101-110` | `ORDER BY message_timestamp desc LIMIT 1` | `:593` ← `InterPhoneMessageFragment.java:336` |
| `isTableExist(name)` `:88-99` | `select name from sqlite_master where type='table' and name='<name>'` (string-concatenated) | internal |
| `resetData()` `:188-201` | `delete from <every table>` | `DmrManager.resetData` `:913` |
| `getAllSms(String)`, `getAllSms(int)`, `insertList`, `deleteListData`, `queryListData(…)`, `updateListData`, `onUpgrade` | reference tables that do not exist | dead |

### 4.4 `UtilConversationData` (`P/serial/data/UtilConversationData.java`)

| Method | SQL | Callers |
|---|---|---|
| `addConversation` `:31-37` | `INSERT (conver_type, conver_target)` → rowid | `DmrManager.updateConversationTimestamp` `:557` |
| `updateConverstion` `:39-51` | `UPDATE all cols (conver_id=_id) WHERE conver_type=? AND conver_target=?` | `:554,561,569` |
| `deleteConverstion` `:53-59` | `DELETE WHERE type AND target` | `DmrManager.deleteConverList` `:526` |
| `getConversation(t,target)` `:61-71` | `… LIMIT 1` | `:549,565` |
| `getAllConversations()` `:80-88` | `ORDER BY conver_timestamp desc` | `:630` ← message list UI, `InterPhoneHomeActivity.java:486` |
| `deleteConversation` (by `conver_id`) `:73-78` | | none |
| `resetData()` `:90-94` | `DELETE` all | `DmrManager.resetData` `:911` |

### 4.5 `UtilRecordData` (`P/serial/data/UtilRecordData.java`)

`getAllRecordFiles()` (`ORDER BY record_timestamp desc`, `:32-44`), `removeRecordFile` (`DELETE WHERE record_timestamp=?`, `:46-50`), `addRecordData` (insert name only, `:52-56`), `updateRecordData` (`UPDATE … WHERE _id=?`, `:58-69`). Callers: `DmrManager.java:148-159` only. Note `TAG` is copy-pasted as `"TAG_UtilMessageData"` and an unused `messageTables` map remains (`:19-23`).

---

## 5. `UtilInitChannelData` — area registry and default codeplug

**Lifecycle.** Constructed in `DmrManager.initChannelData()` (`DmrManager.java:162-171`), which runs from `onVersionReceived()` (`:885-892`) — i.e. only after the module has answered the version query over serial, and after `Constants.initDefChannelAreas()`. The constructor builds one `UtilChannelData` per key in `Constants.getSavedChannelAreas()` (`UtilInitChannelData.java:33-37`); on a fresh install that call also seeds pref `pref_person_device_area_list` with the default map (`Constants.java:81-84`).

**"Already initialised" test** (`DmrManager.java:167`): `mInitChannelDataDB.isDBEmpty() || getDefaultDbHelper().getAllChannels().size() == 0` → i.e. no areas registered, **or the default area DB (`KEY_DEF_AREA`) has zero rows**. Only then does `initChannelDb()` run — and it (re)populates **every** area (`:249-263`), using update-if-`_id`-exists-else-insert (`insertChannelDataToDb` `:574-582`).

**What gets created** (all values hard-coded; frequency lists in `app/src/main/res/values/arrays.xml`, no locale override — `values-zh-rCN/arrays.xml` has none of these):

| Area key | Digital channels (`buildDefaultDigitalChannel`, `:495-503`) | Analog channels (`buildDefaultAnalogChannel(f,f,i,power=1,band=1)`, `:532-542`) | Active |
|---|---|---|---|
| `channel_area_default_uhf` (UV module) | 8 × `channel_tx_digital_default_uhf`: 401.025–408.025 MHz step 1 MHz, ids 1–8 | 8 × `channel_tx_Analog_default_uhf`: 409.025–416.025 MHz, ids 9–16 | id 1 |
| `channel_area_default_vhf` (UV module) | 8 × 137.025–144.025 MHz | 8 × 145.025–152.025 MHz | id 1 |
| `channel_area_default` (U/V-only module) | 8 × 401.025–408.025 | 8 × 409.025–416.025 | id 1 |
| `channel_area_cn` | — | 20 (409.750–409.9875) | id 1 |
| `channel_area_tw` | — | 14 (467.5125–467.675) | |
| `channel_area_eu` | — | 8 PMR446 (446.00625–446.09375) | |
| `channel_area_usa` | — | 22 FRS/GMRS (462.5625 … 462.725) | |
| `channel_area_aus` | — | 40 (476.425–477.400) | |
| `channel_area_rus` | — | 8 (433.075–433.800) | |
| `channel_area_iran` | — | 14 (433.825–433.9875) | |
| `channel_area_ko` | — | 25 (448.750–449.2625) | |
| `channel_area_malaysia` | — | 38 (477.525–477.9875) | |
| `channel_area_japan` | — | 20 (`channel_tx_Analog_japan`, 422.050–422.300) | |
| `channel_area_norway` | — | 6 (444.600–444.975) | |
| `channel_area_south_af` | — | 4 (463.975–464.325) | |

Every default channel has `txFreq == rxFreq`, digital ones keep class defaults (cc 1, contactType 0, txContact 1, groups {1,…}), analog ones get `power=1, band=1` (wide), `sq=2`, no tones. Names are NULL. No default contacts are created anywhere (contacts DB starts empty).

**Public API and callers**

| Method | Behaviour | Callers |
|---|---|---|
| `isDBEmpty()` `:274` | no registered areas | `DmrManager.java:167` |
| `getCurrentDb(area)` `:278-290` | wrapper for that area; if the area is not in the saved map returns a *new* wrapper for `KEY_DEF_AREA` | `DmrManager.getCurrentDbHelper/getDefaultDbHelper` `:245-251` and area UIs |
| `initChannelDb()` / `(boolean fromSdcard)` `:245-263` | populate all areas; `fromSdcard` only affects the default(-UHF) area | `DmrManager.java:168`, `resetData` |
| `resetData(boolean fromSdcard)` `:588-599` | clear `pref_person_device_area_list`, `deleteAll()`+`deleteDatabase()` every area, re-register defaults, `initChannelDb(fromSdcard)` | `DmrManager.resetData(z)` `:909` ← `InterPhoneLocalFragment.java:465` passes **true** (factory reset tries the XML file) |
| `resetChannelDataList(area)` `:82-243` | delete that area's DB and rebuild from its array | area dialog "reset" (`FragmentLocalDeviceAreaActivity.java:337`) |
| `addChannelDataList(area, map)` `:39-42` | new wrapper (DB created on first use, empty) + save map | new user area (`:376`) |
| `removeChannelDataList(area)` `:44-80` | delete DB; then edits `pref_person_device_area_list` as if it were a comma-separated list — but the pref holds JSON, so this is a no-op (*inferred*); the caller removes the key from its own map | `:411` |
| `isCheckDbName(area)` `:601-608` | wrapper exists? | `:374` |

**Bug (read from code):** `resetChannelDataList` for `channel_area_default`/`_uhf` (cases 7 and `'\b'`, `:214-221`) first rebuilds 8 digital (ids 1–8) + 8 analog (ids 9–16), then calls `initChanneldb(analogArray)` which builds analog channels with `_id` 1–8 and — because those ids now exist — **overwrites the eight digital defaults with analog copies**. After an area "reset" the default area contains 16 analog channels and no digital ones.

---

## 6. XML config pipeline

**Source file:** `Environment.getExternalStorageDirectory() + "/intercom/intercom_config.xml"` → `/sdcard/intercom/intercom_config.xml` (`P/config/ConfigXmlPullParser.java:22`), read with `FileInputStream` + `Xml.newPullParser()` as UTF-8 (`:49-51`). No copy ships in `assets/`, `res/raw/` or `res/xml/` (those hold only the module firmware `DMR003.UV4T.V022.bin`, a Whisper model, tones, and preference/badge XML). The file is consumed only by `UtilInitChannelData.initDefaultChannelDbFromSdcard()` (`:370-431`), reached via `resetData(true)` → `initChannelDb(true)` → `initDefaultUHFChannelDb(true)` / `initDefaultChannelDb(true)`. The VHF default area ignores the flag (`:324`).

**Object model:** `ParseConfig{isError, InsertConfig}` → `InsertConfig{localNumber:int, SparseArray<InsertChannels>}` keyed by the `<Channels id>` → `InsertChannels{ArrayList<InsertChannel>}` → `InsertChannel` (19 String fields, Builder). Selection: `insertConfig.getInsertChannels().get(insertConfig.getLocalNumber())` (`UtilInitChannelData.java:375`) — **the `<Channels id="…">` block whose id equals `<localnumber>` is imported; all others are ignored.**

**Schema** (element names from `XmlTagConst.java:28-51`; parse in `ConfigXmlPullParser.parse/parseChannel` `:45-205`):

```xml
<Config>
  <localnumber>1234567</localnumber>            <!-- int; selects the Channels block -->
  <Channels id="1234567">                       <!-- first attribute must be id; int -->
    <channel name="Repeater 1">                 <!-- first attribute must be name -->
      <channeltype>0</channeltype>              <!-- 0 digital / 1 analog; required -->
      <sendfreq>446500000</sendfreq>            <!-- Hz; required; 400000000..480000000 -->
      <recfreq>446500000</recfreq>              <!-- Hz; required; same range -->
      <power>0</power>                          <!-- 0|1; NOTE inverted mapping, see below -->
      <!-- digital only -->
      <contactype type="1"/>                    <!-- attribute 'type': 0 person/1 group/2 all -->
      <number>9</number>                        <!-- target ID; must follow contactype; ignored when type=2 -->
      <recgroup>9</recgroup>                    <!-- RX group list, one DIGIT per entry (see gotcha) -->
      <!-- analog only -->
      <band>1</band>                            <!-- 0 narrow / 1 wide -->
      <squelchlevel>2</squelchlevel>            <!-- 0..10 -->
      <recvsubaudiotype>1</recvsubaudiotype>    <!-- 0..3 -->
      <recvsubaudiofreq>12</recvsubaudiofreq>   <!-- tone-table index -->
      <sendsubaudiotype>1</sendsubaudiotype>
      <sendsubaudiofreq>12</sendsubaudiofreq>
    </channel>
  </Channels>
</Config>
```

**Tag classes** (`P/config/tag/`; base `XmlTag.isAvailable(name)` = `isForceFilter() ? tag.equals(name) : isFilter(name) && tag.equals(name)` `:12-17`; every `isFilter` ignores its argument and returns a constant, so `false` means the tag is silently skipped):

| Class | Tag | isFilter | force | How parsed | Validation (`XmlTagValid.checkInvalid`, `:12-163`) | → `InsertChannel` / `ChannelData` |
|---|---|---|---|---|---|---|
| `ConfigTag` | `Config` | true | true | END_TAG commits `InsertConfig` (`:67-70`) | — | — |
| `LocalNumberTag` | `localnumber` | true | — | `nextText()` → `parseInt` | — | `InsertConfig.localNumber` |
| `ChannelsTag` | `Channels` | true | true | attribute 0 must be `id`; enters `parseChannel` | `id`: `parseInt` | key of `insertChannels` |
| `ChannelsIdTag` | `id` | true | true | attribute of `Channels` | | |
| `ChannelTag` | `channel` | true | — | attribute 0 must be `name`; END_TAG adds the built channel | `checkInvalid("channel", name)` → no case → **no check** (`"name"` case exists at `:122-126` but is never reached) | `name` → `ChannelData.name` |
| `ChannelNameTag` | `name` | true | true | attribute of `channel` | | |
| `SendFreqTag` | `sendfreq` | true | true | text | 400 000 000 ≤ v ≤ 480 000 000 (`:139-145`) | `txFreq` |
| `RecFreqTag` | `recfreq` | true | true | text | same | `rxFreq` |
| `ChannelTypeTag` | `channeltype` | true | true | text | 0 or 1 | `type` (other values skipped at import) |
| `PowerTag` | `power` | true | — | text | 0 or 1 | analog: `power = "1".equals(v) ? 0 : 1` — **XML 1 → LOW, 0 → HIGH** (`UtilInitChannelData.java:396`); digital: ignored |
| `ColorCodeTag` | `colorcode` | **false** | — | skipped | (0..3 if it were enabled) | — (digital import always cc=1) |
| `SlotModeTag` | `slotmode` | **false** | — | skipped | (0/1/2) | — |
| `ContacTypeTag` | `contactype` | true | — | attribute `type` | **none** — `"contactype"` has no case in `checkInvalid` (falls to `default`), so any integer text passes; `2` (all) is accepted and makes the parser skip `<number>` (`ConfigXmlPullParser.java:153`) | `contactType`; default "0" |
| `NumberTag` | `number` | true | — | text; reads `builder.build().getContactype()` → **NPE/NumberFormatException if `<number>` precedes `<contactype>`** | `checkDigitalTypeInvalid`: only when contactype=="1": 1..16776415 | `txContact`; default "1" |
| `RecGroupTag` | `recgroup` | true | — | text | none | `groups` via `getStrToArray` (`:614-624`): `str.split("")` → **each character becomes one int** (`"9"`→{9}, `"12"`→{1,2}); default `new int[]{1}` (length 1, later padded by `coverGroupInt`) |
| `EncryptSwitchTag` | `encryptSwitch` | **false** | — | skipped | (1 or 255) | — |
| `EncryptTextTag` | `encryptText` | **false** | — | skipped | | — |
| `GroupValueTag` | `groupvalue` | **false** | — | skipped | | — |
| `BandTag` | `band` | true | — | text | 0 or 1 | `band = "1".equals(v) ? 1 : 0` |
| `SquelchLevelTag` | `squelchlevel` | true | — | text | 0..10 | `sq` (if non-empty) |
| `RecvSubaudioTypeTag` | `recvsubaudiotype` | true | — | text | 0..3 | `rxType`; default 0 |
| `SendSubaudioTypeTag` | `sendsubaudiotype` | true | — | text | 0..3 | `txType` |
| `RecvSubaudioFreqTag` | `recvsubaudiofreq` | true | — | text; must follow its type tag | `checkAnalogTypeInvalid`: type "1" → 0..50, "2"/"3" → 0..82, else unchecked (`:165-209`) | `rxSubCode` |
| `SendSubaudioFreqTag` | `sendsubaudiofreq` | true | — | text | same | `txSubCode` |
| `XmlTagConst` | — | — | — | tag strings + unused `DEF_FILTER_*` booleans | | |
| `XmlTagManager` | — | — | — | singleton holding one instance of each tag | | |
| `XmlTagValid` | — | — | — | validators + `checkMustNotEmpty` (name, sendfreq, recfreq, channeltype) `:224-226` | | |

**Rows produced** (`initDefaultChannelDbFromSdcard` `:380-409`): channels failing `checkMustNotEmpty` are skipped; `_id = number =` running index over accepted channels; the first accepted channel gets `active=1` (`:402-404`); digital → `myBuildDefaultDigitalChannel` (`:516-530`; when contactType==2 `txContact`/`groups` keep class defaults), analog → `myBuildDefaultAnalogChannel` (`:557-572`). Rows are written to `getCurrentDb(KEY_DEF_AREA)` with `insertChannelDataToDb` (update-or-insert by `_id`).

**Error handling:** any exception in `parse()` (missing file, malformed XML, validation failure, `getAttributeName(0)` on an attribute-less element) is caught, logged at debug level as `"parse error"`, and yields `isError=true` (`:74-77`). Then, and also when the `Channels` block for `localnumber` is missing or produces zero rows, the code falls back to the built-in defaults and toasts `msg_notify_fail_load_config` ("Failed to load the local configuration file"); success toasts `msg_notify_succeed_load_config` (`:410-430`). Because the frequency validator is UHF-only, a UV radio cannot import VHF channels from XML.

---

## 7. SharedPreferences

Only two prefs files exist; grep for `getSharedPreferences` finds no other call sites, and no `PreferenceManager`/`PreferenceFragment` usage (the `res/xml/fragment_local_setting_preferences.xml` file is unreferenced). All writes use `commit()` (synchronous).

### 7.1 `com.pri.prizeinterphone.data.person` (`PersonSharePrefData`, `P/serial/data/PersonSharePrefData.java:25`)

File: `<app data>/shared_prefs/com.pri.prizeinterphone.data.person.xml`. Many call sites use the literal key string rather than the constant.

| Key | Type | Default | Meaning | Writers | Readers |
|---|---|---|---|---|---|
| `pref_person_device_id` | int | 1 | This radio's DMR ID (`DmrManager.localId`) | `DmrManager.setLocalId` `:302`; `FragmentLocalSettingsActivity.java:465`; `DmrManager.resetData` `:901` | `DmrManager.java:163,463`; `MessageContentActivity.java:218`; `FragmentLocalSettingsActivity.java:103,411` |
| `pref_person_limit_send_time` | int | 30 | PTT time-out seconds: 15/30/60/120/-1 (`local_settings_limit_send_time_value`) | `FragmentLocalSettingsActivity.java:495`; reset `:902` | `InterPhoneTalkBackFragment.java:685`; settings `:108` |
| `pref_person_ptt_start_tone` | bool | true | play start beep | settings switch; reset `:903` | `DmrManager.playStartPromptTone` `:927` |
| `pref_person_ptt_end_tone` | bool | true | play end beep | settings; reset `:904` | `:931` |
| `pref_person_ptt_record` | bool | false | save PCM of every call | settings; reset `:905` | `DmrManager.needSaveRecordFile` `:923` |
| `pref_person_busy_no_send` | bool | true | refuse PTT while channel busy | settings `:314-318`; `InterPhoneChannelActivity.java:708` (forced false when interrupt = transmit); reset `:907` | `DmrManager.getBusyNoSend` `:935` |
| `pref_person_channel_area_selected_index` | String | `Constants.KEY_DEF_AREA` | Selected area key (which `database_<area>.db` is current) | `Constants.saveSelectedChannelArea` `:132`; reset `:906` | `Constants.getSelectedChannelArea` `:128`; `InterPhoneChannelFragment.java:83,121,324` |
| `pref_person_device_area_list` | String (JSON) | `""` → seeded with `DEF_CHANNEL_AREAS` | `LinkedHashMap<areaKey, displayKeyOrName>`; registry of channel DBs | `Constants.java:82,96`; `UtilInitChannelData.java:79,589` | `Constants.java:80`; `UtilInitChannelData.java:60` |
| `pref_person_device_dmr_version` | String | `"DMR003.UV4T.V022"` | Module firmware version string; segment 2 decides U/UV/V band support | `DmrManager.onVersionReceived` `:888` | `DmrManager.java:947,984`; `FragmentLocalInformationActivity.java:67` |
| `pref_person_mic_gan_value` | int | 0 | Mic gain index 0–5 (= 0/4/8/12/16/20 dB) | `FragmentLocalSettingsActivity.java:532`; reset `:908` | `DmrManager.java:360,818` (DigitalMessage.mic, MicMessage.gain); settings `:125` |
| `pref_person_send_status` | int | 0 | 1 while PTT transmitting; UI refuses edits/reset when 1 | `DmrManager.setSendStatus` `:939` | 12 UI classes (activities, fragments, `PCMAudioPlayer`) + `DmrManager.isSendStatus` `:943` |
| `pref_person_is_already_kill` | int | 0 | 1 = radio remotely killed (cmd 40) → `DeviceKilledActivity` | `EnhanceMessageHandler.java:25,27` | `DeviceKilledActivity.java:21,38,51,59`; `AppObserver.java:39,67` |
| `pref_person_icon` | String (Base64 JPEG) | none | User avatar | `InterPhoneLocalFragment.java:343` | `:123`; `MessageContentActivity.java:200` |
| `pref_person_interrupt_transmission_value` | int | 1 | read-only gate in settings (`FragmentLocalSettingsActivity.java:310`); no writer found | — | settings |
| `pref_person_contacts_selected_id` / `_type` | int | 1 / 0 | `DmrManager.chatId/chatType` initial values (`:79-80`); no writer found | — | `DmrManager` |
| unused constants | | | `PREF_PERSON_CONTACTS_SELECTED`, `PREF_PERSON_INTERRIPT_VALUE` (`pref_person_interrupt_value`), `PERSON_*` defaults (`:11-17`) | | |

### 7.2 `com.pri.prizeinterphone.data.currentchannel` (`CurrentChannelSharePrefData`)

Key `pref_current_channel_id` (`:8`). No callers of this class anywhere (grep `CurrentChannelSharePrefData\.` → none). The active channel is tracked by `channel_active` in the DB instead.

---

## 8. Constants and enumerations

### 8.1 `P/constant/Constants.java`

| Constant | Value | Use |
|---|---|---|
| `CHANNEL_FRQC_BAND_U_LIMIT_MIN/MAX` | 400 000 000 / 480 000 000 Hz | UHF range check (`InterPhoneChannelActivity.isParamsCorrect`), XML validator (hard-coded copy) |
| `CHANNEL_FRQC_BAND_V_LIMIT_MIN/MAX` | 136 000 000 / 174 000 000 Hz | VHF range check |
| `DEF_MODULE_VERSION` | `"DMR003.UV4T.V022"` | default module version (matches asset firmware file name) |
| `MODULE_FRQC_BAND_U / UV / V` | `"U"`, `"UV"`, `"V"` | prefix test on version segment |
| `KEY_CHANNEL_AREA_*` (15 keys) | see §1.2 | area keys = DB names = string-resource names for display (`R.string.channel_area_*`, e.g. "Default UHF", "USA FRS") |
| `KEY_CHANNEL_AREA_PREFIX` | `"channel_area_"` | display-name resolution via `getIdentifier` (`:109-110`) |
| `KEY_EXTRA_AREA_CHANNEL` | `"extra_channel_area_"` | user-created areas |
| `KEY_DEF_AREA` | static-init from `DmrManager.isSupportUVFrequencyBand()` | default area; **static initialiser touches the `DmrManager` singleton** |
| `DEF_CHANNEL_AREAS` | mutable `LinkedHashMap` | filled by `initDefChannelAreas()` |

No frequency step constant exists; frequencies are free-form Hz integers typed in the editor (`InputType` numeric). No CTCSS/DCS tables exist in Java — they are string arrays in resources (below) and only their **index** is stored/transmitted.

### 8.2 Other numeric constants

| Where | Constant | Value |
|---|---|---|
| `UtilChannelData` / `UtilContactsData` / `UtilConversationData` | `ID_MIN`, `ID_MAX` | 2, 16776415 (unused) |
| same | `INSERT`, `UPDATE` | 1111, 1112 (unused; nothing references them) |
| `InterPhoneChannelActivity.java:600-615` | DMR ID / TG / group-list upper bound | 16776415 (`0xFFFC5F`) |
| `XmlTagValid.java:217` | XML group number | 1..16776415 |
| `InterPhoneChannelActivity.java:680` | all-call target | 16777215 (`0xFFFFFF`) |
| `DigitalMessage` ctor `P/message/DigitalMessage.java:34-52` | wire defaults | pwrSave 1, volume 8, contactType 1, groupList {1,0…} |
| `AnalogMessage` ctor `:31-41` | wire defaults | band 1, sq 2, pwrSave 2, volume 8, monitor 2, relay 2 |
| `Util.java:10-12` | DMR update status | idle "1", updating "2", error "3" (NVRAM access stubbed out) |
| `ReadFileUtils.java:16-18` | sysfs nodes | `/sys/devices/platform/dmr009/{debug,ptt,pwd}` |

### 8.3 Resource enumerations (`app/src/main/res/values/arrays.xml`)

| Array | Count | Values → stored int |
|---|---|---|
| `interphone_channel_type_values` | 2 | Digital → 0, Analog → 1 |
| `interphone_channel_power_values` | 2 | Low → 0, High → 1 |
| `interphone_channel_color_values` | 16 | 0–15 → `cc` |
| `interphone_channel_input_mode_values` | 2 | Direct → 0, Double slot → 4 |
| `interphone_channel_slot_mode_values` | 2 | Slot 1 → 0/0, Slot 2 → 1/1 |
| `interphone_channel_contact_type_values` | 3 | Person 0, Group 1, All 2 |
| `interphone_channel_encryption_values` | 2 | Disabled → 2, Enabled → 1 |
| `interphone_channel_relay_disconnet` | 2 | Disable → 2, Enable → 1 |
| `interphone_channel_interrupt_transmission_array` | 3 | ON 1, OFF 2, transmit 3 (default label "OFF") |
| `interphone_channel_band_values` | 2 | Narrow → 0, Wide → 1 |
| `interphone_channel_frequency_values` | 2 | UHF / VHF — display/validation only |
| `interphone_channel_sq_values` | 9 | "1"…"9" → `sq` (default "2") |
| `interphone_channel_txtype_values` (used for both TX and RX) | 4 | Wave 0, ctcsss 1, Forward DCS 2, Backward DCS 3 |
| `interphone_channel_subcode_ctcsss_values` | **51** | index 0 = 62.5 Hz, 1 = 67.0 Hz, … 50 = 254.1 Hz → `rxSubCode/txSubCode` when type 1 |
| `interphone_channel_subcode_fdcs_values` | **83** | `023N` … `754N` (index) when type 2 |
| `interphone_channel_subcode_bdcs_values` | **83** | `023l` … `754l` (inverted DCS) when type 3 |
| `interphone_channel_id_values` | 28 | 21–48 (UI picker) |
| `local_settings_limit_send_time(_value)` | 5 | 15/30/60/120/-1 s |
| `local_settings_mic_gain(_value)` | 6 | 0–5 ↔ 0–20 dB |
| `channel_tx_digital_default{,_uhf,_vhf}`, `channel_tx_Analog_*` | see §5 | default frequency lists (Hz) |

The XML validator's index bounds (0..50 for CTCSS, 0..82 for DCS) match these array sizes exactly.

---

## 9. Practical guide for an external tool / hook

**Files to touch.** `<dataDir>/databases/database_<area>.db` where `<area>` is the value of pref `pref_person_channel_area_selected_index` (default `channel_area_default_uhf` on the UV4T module). `<dataDir>` = `/data/data/com.pri.prizeinterphone` (stock) or `/data/data/com.macgyver.dmr` (this repo's build). Contacts: `contact_database.db`. The list of valid area names is the JSON in `shared_prefs/com.pri.prizeinterphone.data.person.xml` → `pref_person_device_area_list`.

**Opening.** Standard SQLite; `PRAGMA user_version` must stay 2 for channel DBs (else `onUpgrade` runs `ALTER TABLE ADD` and fails on existing columns) and 1 for the others. Journal mode is whatever the platform defaults to for `SQLiteOpenHelper` (WAL on modern Android — *inferred*; copy `-wal`/`-shm` siblings if you pull the file). The OEM code never uses transactions and holds a long-lived connection per wrapper; writers from another process should wrap bulk changes in one `BEGIN IMMEDIATE … COMMIT` and expect `SQLITE_BUSY` only during the app's own short autocommit writes. DMRModHooks already does this (`DMRModHooks/app/src/main/java/com/dmrmod/hooks/DirectDatabaseImporter.java:465-473`).

**Inserting channels.** Provide every column except `_id` (NULL columns are tolerated by readers except `channel_groups` — `coverGroupInt(null)` returns the default, so NULL is fine; `channel_encryptKey` NULL is fine for analog but `getEncryptKey().equals("")` NPEs for a *digital* row with NULL key when it is sent — `DmrManager.java:342`). Keep `channel_number = _id` to mimic the app, or any positive int. Reset `sqlite_sequence` if you want ids to restart.

**Making the app see changes.** `DmrManager` caches `channels` (`:77`). After external writes call, via reflection/Xposed on the app's `DmrManager.getInstance()`:
1. `updateChannelList()` (`DmrManager.java:217-225`) — reloads from the current area DB and fires `UpdateListener.updateTalkBackChannelList()`.
2. If the active channel's parameters changed: `syncChannelInfo()` (`:197-205`) to push it to the module, or `syncChannelInfoWithData(ChannelData)` (`:207-215`) to push a specific object. Both run the `CmdStateMachine` `SetChannelState` sequence: set channel (cmd → ack 34 digital / 35 analog) → interrupt (digital only) → mic gain → done (`P/state/CmdStateMachine.java:286-340`). Do not call while `getCurrentState() == getSetChannelState()`.
This is what `DirectDatabaseImporter.java:1262-1277` and `MainHook.java:2447,5445` do.

**Invariants to keep**

| Rule | Why |
|---|---|
| Exactly one row per area DB with `channel_active = 1` | `getActiveChannel` uses `LIMIT 1` with no order; `getCurrentChannel()` returns the first `active==1` in rowid order, else row 0 (`DmrManager.java:279-291`); zero rows → `IndexOutOfBounds` |
| `channel_type ∈ {0,1}` | anything else is treated as analog by `sendSetChannelCmdToMdl` (`!= 0`) |
| `channel_encryptSw ∈ {1,2}`; if 1 then `channel_encryptKey` is ≤ 8 bytes ASCII | key is put raw into an 8-byte slot of a fixed 163-byte body; longer keys shift every later field (`DigitalMessage.java:147`) |
| `channel_relay ∈ {1,2}` | app only writes these; module default 2 |
| `channel_interrupt ∈ {1,2,3}` for digital rows; ignored for analog | value 3 also suppresses the busy-lockout pref |
| `channel_contactType = 2` ⇒ `channel_txContact = 16777215` | UI convention; groups are only transmitted when contactType = 1 |
| `channel_groups` = at most 32 comma-separated ints | >32 entries crash every read of that row |
| `channel_band` = 0/1 bandwidth, independent of frequency | do **not** encode UHF/VHF here |
| Frequencies inside 400–480 MHz or 136–174 MHz (UV module) | editor refuses to save otherwise; module behaviour outside is unknown |
| `channel_rxSubCode/txSubCode` < 51 (type 1) or < 83 (types 2/3) | editor indexes the string arrays with `.get(index)` (`InterPhoneChannelActivity.java:465-486`) → crash if out of range |
| `channel_txContact` = DMR/TG ID (not contact `_id`); `contact_number` is TEXT | conversation naming joins on `(contact_type, contact_number)` |

---

## 10. Gotchas

1. **`channel_band` is bandwidth.** Narrow/Wide, sent as `AnalogMessage.band`. Frequency band is never stored.
2. **`interrupt` is not type-dependent** and is transmitted only for digital channels; the module never receives an interrupt command for an analog channel.
3. **`encryptSw` uses 1/2, `relay` uses 1/2, `channelMode` uses 0/4** — none of these are 0/1 booleans.
4. **No ORDER BY on channels.** Display order is rowid; `channel_number` is cosmetic and can be duplicated after deletes + re-adds (a new row gets `number = new rowid`, which may exceed the visible count).
5. **`getAllChannels()` result is cached in `DmrManager.channels`** and refreshed only by `updateChannelList()/updateModuleInit()`; direct DB writes are invisible until then.
6. **Area DBs are only initialised when the default area is empty** (`DmrManager.java:167`) — deleting `database_channel_area_default_uhf.db` alone triggers a full re-seed of every regional DB (rows with matching `_id` are overwritten).
7. **Area "reset" destroys the digital defaults** (§5 bug).
8. **`KEY_DEF_AREA` is evaluated once in a static initialiser** from the *stored* version string; the first run before any version reply uses the default `UV4T` string, so a U-only module would initially get `channel_area_default_uhf`.
9. **XML import is UHF-only, disables colour code / slot / encryption tags, inverts `power`, and parses `recgroup` per character.** It runs only during factory reset (`resetData(true)`), and only for the default(-UHF) area.
10. **`UtilMessageData.resetData()` deletes rows from `android_metadata` and `sqlite_sequence`** in `message_database.db`.
11. **`message_timestamp` and `conver_timestamp` are TEXT columns holding millisecond epochs**; comparisons are string comparisons.
12. **Cursors are never closed**; every wrapper leaks a `Cursor` per call (relies on GC finalizers).
13. **`getChannelInfo` == `getChannel`;** `deleteConversation` vs `deleteConverstion` — only the misspelt one is used.
14. **Contacts have no "active" writer**; `DmrManager.getCurrentContact()` effectively always returns null.
15. **Two generations coexist.** Anything under `P/data/` or `P/Util/Util{Contacts,Message}Data` is unreachable; do not "fix" it or hook it.
16. **`AudioRecordData` Parcel round-trip truncates `timestamp`** (`writeLong` / `readInt`).
17. **`PersonSharePrefData` keys are duplicated as literals** in `DmrManager`, `Constants`, and activities; renaming a constant does not rename the stored key.
18. **`DBChannelHelper(Context)` / `channel_database.db` and `TABLE_ID = "channel_id"`** are vestiges; the real id column is `_id`.

## ⚠️ Doc-drift summary (vs `.grok/rules/copilot-instructions.md` §5a and `.grok/rules/packet-layouts.md`)

| Note claims | Code says |
|---|---|
| `channel_band` "0=UHF, 1=VHF (derived from frequency)" | 0 = Narrow, 1 = Wide analog bandwidth (`InterPhoneChannelActivity.java:724-727`, `AnalogMessage.band`). UHF/VHF is derived from `txFreq` for display only. |
| `channel_interrupt` "must be 2 for Digital, 0 for Analog" | Default 2 for all; values 1/2/3 set only on digital channels; never 0; only sent for digital (`CmdStateMachine.java:289-301`). |
| `channel_encryptSw` "0=off, 1=on" | 1 = on, 2 = off (`InterPhoneChannelActivity.java:685,699`; default 2). |
| `channel_type` "stored as text in DB" | DDL type `integer`, written as `Integer` (`UtilChannelData.java:64`). |
| `channel_mode` "uses vary" | 0 = Direct mode, 4 = Double slot (`:711-714`). |
| `channel_number` "display order number" | Never used for ordering by the OEM app; lists are rowid-ordered (`getAllChannels` has no ORDER BY). |
| `channel_relay` "firmware rejects 0" | Not verifiable from app code; app writes only 1/2. |
| `contact_type` "2 = AllCall" | OEM `ContactData.ContactType` defines only 0/1; UI queries only 0 and 1. |
| DB owner path `/data/data/com.pri.prizeinterphone/` | True for the stock APK; this repo builds `applicationId "com.macgyver.dmr"` (`app/build.gradle:11`). |
| Valid DMR ID "1..16777214" | OEM editor/XML validator cap is 16776415 (`0xFFFC5F`); all-call is 16777215. |
| `packet-layouts.md`: DigitalMessage "Bytes 5–7 Target ID" | In the 163-byte **body** `txContact` is at offset 140–143 (after `rxFreq`, `txFreq`, `localId`, 128-byte group list); bytes 4–7 of the body are `txFreq`. Offsets 5–7 can only be correct relative to some other framing not visible in this chapter. |
