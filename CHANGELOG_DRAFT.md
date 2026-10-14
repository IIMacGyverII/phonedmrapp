# Changelog draft — unreleased (working towards v3.4.7)

Running log of changes since v3.4.6, per the feature-log convention in `.grok/rules/copilot-instructions.md`.
Not yet built or device-tested (no JDK/SDK on the authoring machine — see "Testing Notes").

## 2026-10-14 — Correctness batch 2

| Backlog | Change | Files | Test |
|---|---|---|---|
| **S22** (root cause) | `enableSoftwareSquelchOnCurrentChannel()` overwrote the live `ChannelData.sq` with 0 (so VFO could read it) and the disable path then "restored" 0. The level is now saved in `softSqSavedChannelSq` before the overwrite and restored, into both the wire message and the channel object. The `sendAnalogMessage` before-hook also puts its 0 back in `afterHookedMethod`. | `MainHook` | **device**: NOAA channel level 5 → Soft SQ on → MCU `sq=0` → Soft SQ off → MCU `sq=5` |
| **S13** | PDF export: contact type label follows the OEM enum (0 person / 1 group / 2 all) and the contact map is keyed by `contact_number`, so channel contact names resolve (Pitfall 12). | `PDFExporter` | code review |
| **S15** | Information page: the empty light-gray "patch controls" container is only added when it has children. | `MainHook` | code review |
| **S17** | `updateLocationDisplay` runs its Geocoder / GPS work on a background thread and posts only the text updates. | `MainHook` | **device**: Intercom loads; location chip updates |
| **S18** | `activityHistory` guarded by `synchronized (activityHistory)` at the writer, the clear and the DB loader. | `MainHook` | code review |
| **S5** | `DMRTranscriptionService` treats both `YOUR_API_KEY_HERE` and the module's `YOUR_GOOGLE_CLOUD_API_KEY_HERE` as "no key". | `TranscriptionService` | build |
| **U8** | Intercom labels get English defaults (`Power:`, `Color Code:`, `Send:`, `Receive:`, `Contact:`) in `initView` instead of flashing the OEM layout's Chinese placeholders. | `MainHook` | **device**: UI dump after cold start |
| build | `android.suppressUnsupportedCompileSdk=34` silences the AGP 8.1 warning. | `gradle.properties` | — |

## 2026-10-14 — Correctness batch 1 (device-tested where noted)

### Type
- 🐛 Bug fixes · 🔧 Technical · ✨ Small features

### Changes

| Backlog | Change | Files | Test |
|---|---|---|---|
| **R1** | `determineBand()` deleted. It returned UHF/VHF into `channel_band`, which is the analog **bandwidth** byte. SSTV now sets narrow (0), NOAA wide (1), VFO uses `vfoBandWidth` (default wide). `channelMode` is no longer written for analog modes. | `MainHook` | code review |
| **R2** | The `saveChannelData` before-hook's "TG number → contact row `_id`" conversion removed: it tested the OEM enums inverted (ran on analog + person channels) and wrote a row id into `channel_txContact`, which holds the 24-bit DMR ID (Pitfall 12). The hook now only logs. | `MainHook` | code review |
| **R3** | Channel-editor frequency help text: Hz, no decimal, `446.0000 MHz → 446000000` (was 10× wrong). | `MainHook` | code review |
| **R9** | Manifest: removed the `APRSSettingsActivity` entry (class never existed → `ActivityNotFoundException` landmine); `BackupActivity` is `exported="false"`. | `AndroidManifest.xml` | installs |
| **R11** | App label and LSPosed description generated from `versionName` (`resValue`), strings.xml no longer says "v0.2". | `build.gradle`, `strings.xml` | `aapt dump badging` → "DMR Mod Hooks v3.4.6" |
| **R12** (part) | Launch-time reset now also clears Soft SQ / APRS Soft SQ / squelch-open flags, monitoring mode, zone auto-switch, and closes a stuck recording stream. | `MainHook` | code review |
| **S9** | APRS position packets whose coordinates fail to parse are no longer `isValid` (no more stations at 0,0). | `APRSPacketDecoder` | code review |
| **S10** | SSTV stop clears Soft SQ like APRS/NOAA do. | `MainHook` | code review |
| **S12** | Channel numbers ≥ 100 show their last two digits instead of a stale sprite. | `MainHook` | code review |
| **S20** | UART logger: full command-byte name table (hex, from `Const.java`), status names for `0x36` pushes, RSSI decode for `0x32`, and the body interpreter now actually runs (it compared with decimal 22) using the shared `McuDiagnostics` decoders (little-endian). | `MainHook`, `McuDiagnostics` | **device**: log shows `cmd=0x24 (QUERY_DIGITAL_INFO)`, `status=RECEIVE_START` |
| **S21** | Recording keeps one sample of each L==R pair and writes an **8 kHz mono** WAV (half the size, truthful header). | `MainHook` | **device**: NOAA recording → `channels=1 sampleRate=8000`, 229 376 B for 14.3 s |
| **S22** | Soft SQ off restores the channel's own squelch level. Root cause fixed too: the `sendAnalogMessage` before-hook wrote 0 into the live `ChannelData.sq` and never put it back; it now restores the field in `afterHookedMethod`. | `MainHook` | **device**: see below |
| **U4** | `CircuitBoardView` animates at 5 fps when not receiving (was 20 fps always). | `CircuitBoardView` | code review |

### Device test log (2026-10-14, Armor 26 Ultra, NOAA WX6 162.500 MHz)
- Readback via Device tab after reboot: OK; command names correct in the module log.
- Recording: three WAVs produced across RX stop/start cycles; header 8 kHz / mono / 16 000 B·s⁻¹; sizes match wall-clock.
- Soft SQ off → analog image `sq` byte: first build read back 0 (root cause above), fixed build re-tested — result recorded in `docs/grok-deep-dive/11-firmware-fw0-results.md` §18.

## 2026-10-14 — MCU diagnostics + first compile of the audit batch

### Type
- ✨ Feature (diagnostics) · 🔧 Technical

### Changes

| Area | Change | Files |
|---|---|---|
| Device tab | **🧪 Read MCU channel images** — sends `QUERY_DIGITAL_INFO` (0x24), `QUERY_ANALOG_INFO` (0x25) and `QUERY_MIX_CHECK_INFO` (0x39), captures the MCU's 163 / 19 / 169-byte replies through the existing `MessageDispatcher.onReceive` hook, decodes every field (frequencies, localId, groups[], txContact, contactType, CC, slots, mode, encrypt, tones, squelch…) and shows them in a dialog; also written to the Xposed log. Read-only. Verified by hand over adb on 2026-10-14 (`docs/grok-deep-dive/11-firmware-fw0-results.md` §15). | `McuDiagnostics.java` (new), `MainHook.addButtonToLayout`, `MainHook.hookSerialCommunication` |
| Device tab | **🔬 Probe RX audio layout** (backlog gate G1) — samples 60 `writeAudioTrack` chunks and reports whether consecutive 16-bit samples arrive as equal pairs (8 kHz stereo L==R), one silent channel, or independent samples (16 kHz mono as the module assumes). Open-squelch noise is sufficient input. | `McuDiagnostics.java`, `MainHook.hookPCMReceiveManager` |

### Build notes (2026-10-14)
- **First successful compile** of the 2026-08-26 batch: `:app:compileDebugJavaWithJavac` passes with JDK 17 (Temurin `17.0.20.1+1`, `C:\Users\Joshua\tools\jdk-17.0.20.1+1`). Gradle 8.2 in the wrapper **does not run** on the Android Studio bundled JDK (class file 69) — set `JAVA_HOME` to the JDK 17 before `gradlew`.
- `local.properties` (gitignored) created with `sdk.dir` pointing at `%LOCALAPPDATA%\Android\Sdk`.
- **`DMRModHooks/release.keystore` is absent from this machine** (gitignored, never committed, old repo path `C:\Users\Joshua\Documents\android\phonedmrapp` no longer exists). `assembleDebug` stops at `validateSigningDebug`; the installed 3.4.5 is signed with cert `9a9a4eb2…22b9` (CN=DMRModHooks). Until the keystore is found, an install needs `adb uninstall` + a new key + re-enable in LSPosed.
- Not yet device-tested; version not bumped.

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
