# Key Files Quick Map

## DMRModHooks module (`DMRModHooks/app/src/main/java/com/dmrmod/hooks/`)

| File | Purpose |
|------|---------|
| `MainHook.java` | All Xposed hooks, UI overlays, state, VFO/APRS/SSTV/NOAA modes (16.3k lines — line-range map in `docs/deep-dive/08-…`) |
| `DirectDatabaseExporter.java` / `DirectDatabaseImporter.java` | Primary backup/restore (37-col Android + 36-col OpenGD77); import is **wipe-and-insert**; both hard-code the `default_uhf` area |
| `CSVExporter.java` / `CSVImporter.java` | Legacy CSV paths — unreachable from the UI |
| `ZoneDatabase.java` | Zone tables; keys channels by DB `_id` |
| `TGListDatabase.java` | Named TG lists; first 32 IDs → `channel_groups` |
| `RadioidDatabase.java` | RadioID.net lookup DB (`dmrmod_radioid.db`) |
| `AFSKDecoderIQ.java` + `AFSKDecoder.java` | Production APRS RX: IQ demod + PLL (IQ) and HDLC/CRC framing (AFSKDecoder) |
| `AFSKGenerator.java` | Reference only, unreferenced — TX does not work |
| `SSTVReceiver.java` / `SSTVImageDecoderIQ.java` + `com/example/dmrmodhooks/sstv/*` | SSTV RX (the `sstv/` package is the live demod) |
| `BackupActivity.java` | Legacy, unreachable (no caller opens it) |

## OEM app (`app/src/main/java/com/pri/prizeinterphone/`)

| Path | Purpose |
|------|---------|
| `handler/DigitalAudioMessageHandler.java` | Call-metadata packet (0x2B) — caller ID only; OEM `handle()` is empty. Voice PCM does **not** pass through here (it comes from `PrizeTinyService` → `PCMReceiveManager`) |
| `message/DigitalAudioMessage.java` | Packet wrapper |
| `manager/DmrManager.java` | Channel/hardware manager; owns `localId` and the channel cache |
| `manager/PCMReceiveManager.java` | RX audio → `AudioTrack` (8 kHz stereo 16-bit); `writeAudioTrack` is the module's audio tap |
| `state/CmdStateMachine.java` | Channel-programming transaction (1 s timeout, one retry) |
| `serial/MessageDispatcher.java` | Serial command routing |
| `protocol/Const.java` | Authoritative command-byte list |

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
| `DirectDatabaseExporter.java` | Writes 5 CSVs (+PDF+zip) to `/sdcard/Download/DMR/DMR_Backups/YYYYMMDD_HHmmss/` |
| `DirectDatabaseImporter.java` | Reads 4 CSVs (DTMF ignored); enforces import order; `relay 0→2`; **wipe + insert**, `_id` preserved for 37-col files |
| `CSVExporter.java` / `CSVImporter.java` | Legacy paths — prefer Direct* |

### Five backup CSVs

| CSV | DB destination |
|-----|----------------|
| `Contacts.csv` | OEM `contact_database.db` |
| `TG_Lists.csv` | Module `dmrmod_tglists.db` |
| `Channels.csv` | OEM channel DB + module APRS/locations DBs |
| `Zones.csv` | Module `dmrmod_zones.db` |
| `DTMF.csv` | Header-only placeholder — nothing imports it |

All `dmrmod_*.db` files live in `/data/data/com.pri.prizeinterphone/databases/` (module runs inside the OEM process).

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
| Session start | `.grok/rules/00-session-start.md` (mirrored as `CLAUDE.md`) | Every session |
| **Verified architecture** | `docs/deep-dive/00-README.md` → chapters 01–14 | Before touching serial, audio, DB, UI-injection, import/export, or any hook |
| Full reference | `.grok/rules/copilot-instructions.md` | Deep work, DB schema, hooks list (corrected 2026-08-26 from the deep dive) |
| History / dead ends | `.docs/AI_LOGS_SUMMARY.md` (gitignored, often absent) → fallback `docs/deep-dive/13-…` §5 | Before investigating "why doesn't X work" |
| Research | `docs/*.md` | Firmware, APRS, group-call, Ghidra |
| Releases | `releases/` | Only when user asks for a release |

## Separate module

`DMRTranscriptionService/` — cloud Whisper transcription; AIDL to MainHook. Reboot optional after its install.