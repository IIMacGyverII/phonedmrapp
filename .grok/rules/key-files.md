# Key Files Quick Map

## DMRModHooks module (`DMRModHooks/app/src/main/java/com/dmrmod/hooks/`)

| File | Purpose |
|------|---------|
| `MainHook.java` | All Xposed hooks, UI overlays, state, VFO/APRS/SSTV/NOAA modes |
| `DirectDatabaseExporter.java` / `DirectDatabaseImporter.java` | Primary backup/restore (37-col Android + 36-col OpenGD77) |
| `CSVExporter.java` / `CSVImporter.java` | Legacy CSV paths |
| `ZoneDatabase.java` | Zone tables; keys channels by DB `_id` |
| `TGListDatabase.java` | Named TG lists; first 32 IDs → `channel_groups` |
| `AFSKDecoderIQ.java` | Production APRS RX decoder |
| `AFSKGenerator.java` | Reference only — TX does not work |
| `SSTVReceiver.java` / `SSTVImageDecoderIQ.java` | SSTV RX |
| `BackupActivity.java` | Backup management UI |

## OEM app (`app/src/main/java/com/pri/prizeinterphone/`)

| Path | Purpose |
|------|---------|
| `handler/DigitalAudioMessageHandler.java` | RX digital audio + caller info packets |
| `message/DigitalAudioMessage.java` | Packet wrapper |
| `manager/DmrManager.java` | Channel/hardware manager |
| `serial/MessageDispatcher.java` | Serial command routing |

## Build & deploy

| File | Purpose |
|------|---------|
| `DMRModHooks/install.ps1` | **Preferred:** build + install + reboot |
| `DMRModHooks/app/build.gradle` | Version, signing (`release.keystore`) |
| `DMRModHooks/release.keystore` | Shared debug+release key (password `android`) |

## OpenGD77 CPS Fork

**Two locations — don't confuse them:**

| Location | Role |
|----------|------|
| `OpenGD77Fork/` (this repo) | Compiled zip artifacts + `RELEASE_NOTES_*.md` — attach newest zip to GitHub releases |
| `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac` (separate repo) | C# source — build and edit here |

**Fork is NOT stock OpenGD77.** Android-specific patches; unsafe for real GD-77 radios.

### Key CPS source files (`OpenGD77CPS-Mac/DMR/`)

| File | Purpose |
|------|---------|
| `ChannelsForm.cs` | Android CSV export + **Path B** import (`ImportFromCsvFile`) — only working Android import |
| `ChannelsCsvImporter.cs` | Dead code — correct 37-col logic but never called |
| `ChannelForm.cs` | `ChannelOne` model, static lat/lon/encrypt arrays keyed by `GetMinIndex()` slot |
| `AboutForm.cs` | `FORK_VERSION` — bump on every build |

### Android CSV round-trip (DMRModHooks side)

| File | Role |
|------|------|
| `DirectDatabaseExporter.java` | Writes 5 CSVs to `/sdcard/Download/DMR_Backups/YYYYMMDD_HHmmss/` |
| `DirectDatabaseImporter.java` | Reads 5 CSVs; enforces import order; `relay 0→2`; upsert channels by name+freq |
| `CSVExporter.java` / `CSVImporter.java` | Legacy paths — prefer Direct* |

### Five backup CSVs

| CSV | DB destination |
|-----|----------------|
| `Contacts.csv` | OEM `contact_database.db` |
| `TG_Lists.csv` | Module `dmrmod_tglists.db` |
| `Channels.csv` | OEM channel DB + module APRS/locations DBs |
| `Zones.csv` | Module `dmrmod_zones.db` |
| `DTMF.csv` | OEM DTMF table |

### Convention traps (grep before changing)

| Field | CPS internal | Android CSV/DB |
|-------|--------------|----------------|
| Relay | 0=normal, 1=disconnect | 0 invalid→2, 1=disconnect, 2=normal |
| Outbound slot | 1-based (1=TS1) | 0-based (0=TS1) |
| Contact | 1-based index | Name string; col 11 DMR ID often empty from CPS |
| `channel_txContact` | — | Stores **24-bit DMR ID**, not contact `_id` (Pitfall 12) |

**Further reading:** `OpenGD77CPS-Mac/docs/CODEBASE_DEEP_DIVE.md` and `.grok/rules/copilot-instructions.md` § OpenGD77 Integration.

## Documentation tiers

| Tier | Path | When to read |
|------|------|--------------|
| Session start | `.grok/rules/00-session-start.md` | Every session |
| Full reference | `.grok/rules/copilot-instructions.md` | Deep work, DB schema, hooks list |
| History / dead ends | `.docs/AI_LOGS_SUMMARY.md` | Before investigating "why doesn't X work" |
| Research | `docs/*.md` | Firmware, APRS, group-call, Ghidra |
| Releases | `releases/` | Only when user asks for a release |

## Separate module

`DMRTranscriptionService/` — cloud Whisper transcription; AIDL to MainHook. Reboot optional after its install.