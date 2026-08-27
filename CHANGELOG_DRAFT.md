# Changelog draft — unreleased (working towards v3.4.7)

Running log of changes since v3.4.6, per the feature-log convention in `.grok/rules/copilot-instructions.md`.
Not yet built or device-tested (no JDK/SDK on the authoring machine — see "Testing Notes").

## 2026-08-26 — Found-bugs batch from the deep-dive audit

### Type
- 🐛 Bug fixes · 📝 Documentation · 🔧 Technical

### Description
Fixes for defects surfaced by `docs/deep-dive/` (chapters 08, 11, 12, 14) plus the documentation
corrections that came out of the same audit.

### Changes

| Area | Change | Files |
|---|---|---|
| Backup / export / import / PDF / dump | **Area-aware channel table.** Every path used to hard-code `database_channel_area_default_uhf`; users on any other channel area (VHF default, regional, user-created) silently backed up and restored the wrong codeplug. New `OemChannelTable` resolves the OEM's selected area from its own prefs (`pref_person_channel_area_selected_index`, default per module band) and all seven classes now use it. | `OemChannelTable.java` (new), `DirectDatabaseExporter`, `DirectDatabaseImporter`, `PDFExporter`, `ZoneDatabase`, `DiagnosticDatabaseDump`, `CSVExporter`, `CSVImporter` |
| Import integrity | Locations and APRS flags are collected during the parse and applied **only after the channel table commits** (they live in separate SQLite files and cannot join the transaction). Previously `clearAllLocations()` ran before parsing, so a failed import left locations wiped. APRS flags are now written for every channel (explicit `false` too) so stale "enabled" flags cannot survive under a reused channel number; comments/symbols are preserved. | `DirectDatabaseImporter.importChannels` |
| Import integrity | `importTGLists` now clears previous TG lists **and their channel assignments** before inserting (assignments are keyed by channel `_id`, which the wipe-and-insert channel import re-creates). | `DirectDatabaseImporter.importTGLists` |
| Software squelch | Only gates analog audio: `currentChannelType == 1` or an active APRS/SSTV/NOAA mode. Previously the flag survived a switch to a digital channel and muted DMR RX with the toggle hidden. | `MainHook.hookPCMReceiveManager` |
| Software squelch | APRS mode gates only when its own Soft SQ toggle is on. Previously the live screen's persisted `aprs_squelch` threshold gated APRS audio with the toggle OFF. | `MainHook.hookPCMReceiveManager` |
| APRS | `AFSKDecoder` no longer dumps every 2 s buffer (~192 KB) to `/sdcard/aprs_debug/` while APRS runs; guarded by `AFSKDecoder.DEBUG_SAVE_WAV` (default off). | `AFSKDecoder.java` |
| Channel editor | "Call Number" help icon now targets the real row id `interphone_channel_call_name` (the old `interphone_channel_contact` id never existed, so the icon was silently skipped). | `MainHook.addChannelPropertyHelpIcons` |
| Licensing | GPLv3 attribution header for the `com.example.dmrmodhooks.sstv` package (port of xdsopl's *robot36*). | 12 files under `sstv/` |
| APK size | Removed `assets/speech_model.tflite` (41.6 MB, ~96 % of the APK) and `README_MODEL.md` — unreferenced dead weight (zero code references, no TFLite dependency). `assets/` now holds only `PATCH14.bin` and `xposed_init`. | assets |
| Docs | `.grok/rules/*.md` corrected from `docs/deep-dive/00-README.md` §4; new `CLAUDE.md` mirrors `.grok/rules/00-session-start.md` byte-for-byte (mirror rule documented in both). | `.grok/rules/`, `CLAUDE.md` |

### User impact
- Backups/restores follow the channel area you are actually using.
- A failed restore no longer half-wipes locations/APRS flags/TG lists.
- Digital channels are no longer muted by a leftover Soft SQ state; APRS monitoring respects its toggle.
- No more unbounded `/sdcard/aprs_debug/` growth.
- Help icon appears on the Call Number row.
- APK shrinks from ~43 MB to ~2 MB once the tflite asset is removed.

### Known regression risk introduced by this batch (2026-08-27, from the Grok review)
- `OemChannelTable` makes **channel** export/import follow the selected area, but the module side-tables (`dmrmod_zones.db`, `dmrmod_tglists.db`, `dmrmod_locations.db`, `dmrmod_aprs.db`) are still global: importing a backup while a *different* area is selected now clears that area's channels **and** the other area's zones/TG lists/locations; identical `_id`/`channel_number` integers across areas share rows. Mitigation before release: backlog **R7** (stamp `area_key` in the export folder, refuse/confirm cross-area import); full fix **H8** (area-scoped tables). Until then: import only into the area the backup was taken from.

### Testing notes
- **Not compiled**: the authoring machine has no JDK, Android SDK, `local.properties` or `release.keystore`. Build with `cd DMRModHooks; .\gradlew assembleDebug`, then `.\install.ps1` (includes reboot).
- Regression checks: (1) export on a non-default area and confirm `Channels.csv` matches that area; (2) import a folder, then check `dmrmod_locations.db`/`dmrmod_aprs.db` contents; (3) toggle Soft SQ on analog, switch to a DMR channel, confirm RX audio; (4) APRS mode with Soft SQ OFF — audio must pass; (5) open the channel editor and confirm the Call Number help icon.
- Version not bumped; no release created (per release policy).
