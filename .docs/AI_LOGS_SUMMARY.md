# DMRModHooks — Comprehensive AI Chat-History Summary

**Compiled:** May 29, 2026
**Sources:** `.docs/ai-logs/copilot-2026-*.md` (10 exported Copilot chat logs, ~25 MB / ~404,000 lines combined) and supporting documentation in `DMRModHooks/*.md`.

> This document is an honest accounting of what was built, what was attempted and failed, and what was deliberately removed. Anything that was tried but didn't work is explicitly marked. Things that were *planned* but never shipped are also marked.

---

## 1. Project at a glance

- **What it is:** LSPosed/Xposed module targeting the Ulefone **PriInterPhone** DMR radio app (`com.pri.prizeinterphone`) running on the **Ulefone Armor 26 Ultra** (Android 13).
- **Why this approach:** The original APK is signed with a platform signature required for hardware access (`/dev/ttyS0` to the radio MCU). Patching the APK breaks that signature, so all modifications are done at runtime via Xposed hooks.
- **Entry point:** [DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java](DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java) — a single ~16,000-line class implementing `IXposedHookLoadPackage`. Helper classes live in the same package.
- **Currently shipped:** v3.4.0 (build.gradle versionCode 340). See GitHub releases for APKs.

---

## 2. Timeline of the chat logs

| Log file | Lines | Primary theme |
|---|---:|---|
| `copilot-2026-02-22-push_apk_to_phone.md` | 269,772 | **The origin session** — v0.9.26 through v3.1.2: build setup, OpenGD77 CSV, UI hooks (intercom/PTT), LocationDatabase, geocoding, caller info, transcription arc (Vosk→TFLite→Cloud), UART logging, firmware analysis, AFSK/APRS bring-up (RX working; TX confirmed impossible), SSTV/NOAA groundwork |
| `copilot-2026-03-12-debugging_aprs_channel_hiding_issue.md` | 217 | Removed obsolete APRS hidden-channel filtering |
| `copilot-2026-03-13-fixing_stuck_squelch_issue_and_reviewing_documentation.md` | 14,365 | Software squelch state-management, RSSI meter, backup deletion UI |
| `copilot-2026-03-14-dive_in_to_the_orignal_apks_code_and_figure_out_if.md` | 803 | LED-control investigation (none found) + RelayMessage protocol discovery |
| `copilot-2026-03-14-take_a_look_the_the_code_and_find_where_channels_a.md` | 64,049 | Channel-database and zone refactor; OpenGD77 round-trip |
| `copilot-2026-03-14-vfo_feature_implementation_plan_and_analysis.md` | 29,287 | VFO mode (Phase 1 + Phase 2), DMR all-call/group mode fix |
| `copilot-2026-03-15-examine_the_code_specific_for_the_aprs_monitoring.md` | 67,088 | APRS RX hardening, AFSK TX final-failure investigation, SSTV bring-up |
| `copilot-2026-03-19-dmr_capabilities_analysis_and_improvement_suggestions.md` | 2,347 | GPS over DMR SMS, hyperlinking received coordinates |
| `copilot-2026-03-19-enhancing_dmr_capabilities_and_group_management.md` | 3,926 | TGListDatabase, OpenGD77 TG-list round-trip |
| `copilot-2026-03-21-ui_rendering_and_customization_inquiry.md` | 14,714 | Custom PTT sprites, channel-number sprites, CircuitBoardView, sci-fi theme |

---

## 3. Features that ACTUALLY shipped

Cross-referenced against committed code in `DMRModHooks/app/src/main/java/com/dmrmod/hooks/` and the version history in `.github/copilot-instructions.md`.

### 3.1 Build/install infrastructure (Feb 22, 2026 session)
- Established `JAVA_HOME` workflow using Android Studio's bundled JBR (`C:\Program Files\Android\Android Studio\jbr`, OpenJDK 21).
- Created `local.properties` with `sdk.dir=C:\Users\Joshua\AppData\Local\Android\Sdk`.
- Resolved missing `AppTheme`/`AppTheme_Dialog`/`DeviceKilledDialog` styles by copying `styles.xml`/`colors.xml`/`dimens.xml`/`bools.xml` from `decompiled/res/values/` into `app/src/main/res/values/`.
- Locked debug & release builds to the **same** `release.keystore` (alias `dmrmodhooks`, password `android`) so `adb install -r` preserves LSPosed module state.
- `install.ps1` script with the `-r` flag.

### 3.2 OpenGD77 CSV ecosystem
- [`DirectDatabaseExporter.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/DirectDatabaseExporter.java) — exports Channels / Contacts / TG_Lists / Zones / DTMF to `/sdcard/Download/DMR_Backups/YYYYMMDD_HHmmss/` using the Android 37-column format (`_id` + 36 fields).
- [`DirectDatabaseImporter.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/DirectDatabaseImporter.java) — accepts both Android (37-col) and OpenGD77 (36-col) formats; switches via `fieldOffset`.
- [`CSVExporter.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/CSVExporter.java) / [`CSVImporter.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/CSVImporter.java) — older legacy paths kept for the previous filename layout.
- [`PDFExporter.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/PDFExporter.java) — channel summary PDFs.
- [`BackupActivity.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/BackupActivity.java) — backup-management UI; added per-backup trash-icon deletion (3/13 session, commit `660a860f`).
  - Implementation is in `DirectDatabaseImporter.showImportDialog()` (not BackupActivity), using a custom `BackupListAdapter` inner class with a `DeleteCallback` interface.
  - `deleteBackupFolder()` static method deletes all files in the folder then the folder itself.
  - Delete button focus bug: the trash button stole focus from ListView item clicks. Fixed by `deleteButton.setFocusable(false)` + `setFocusableInTouchMode(false)` so only the button itself handles button taps while list-item taps still fire the import path.
- **Defensive relay-field conversion** in both importers: `if (relay == 0) relay = 2;` to prevent "operation failed" on activation. Firmware accepts `1` (relay-disconnect on) or `2` (normal); `0` causes channel activation to fail. We also forked OpenGD77 CPS to fix the same off-by-one in `ChannelsCsvImporter.cs` (indices 28-35, not 29-36) and the `OutboundSlot` 0-vs-1-based round-trip.

### 3.3 Zone management
- [`ZoneDatabase.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/ZoneDatabase.java) — two-table schema (`zones`, `channel_zone_assignments`).
- Zone-filtered channel navigation in `hookChannelNavigation()` — Up/Down buttons wrap within the current zone instead of the entire channel list.
- Zone badge rendered in channel-list items (`hookChannelListUI`).
- **`hookChannelEditActivity` zone row** added to `InterPhoneChannelActivity.onCreate()`; value persisted via `XposedHelpers.setAdditionalInstanceField(activity, "dmrmod_selectedZoneId", …)` and saved in a `saveChannelData()` hook. Zone row inserted at container index 3 with native drawable/dimen styling.
- **Edit-icon touch-intercept bug (3/14 session):** Zone selector dialog rows had a pencil-icon TextView with `setClickable(true)` + `setFocusable(true)`. These consumed touch events for the entire row, preventing `ListView.onItemClickListener` from firing on zone rows (but "Create New Zone" worked because it had no child views). Fixed by removing `setClickable`/`setFocusable` from the icon AND adding `setClickable(false)` + `setFocusable(false)` to the zone-name TextView so all clicks pass through to the ListView.
- **Duplicate channel-number problem (3/14 session):** User had 319 channels with 8 separate channels sharing the same `channel_number` (e.g., eight different channels all numbered `1`). Zone storage used `channel_number` as the key, so selecting zone for "channel 1" would affect all 8 simultaneously. Export also built `channelMap` keyed by `channel_number` (losing duplicates) and import would re-insert with new `_id` values, breaking zone references.
- **Zone `_id` refactor (v3.3.2):** Switched `ZoneDatabase`/`channel_zone_assignments` from `channel_number` to database `_id` as the zone key. Migration code converted existing zone data. All zone navigation and channel-edit hooks updated to use `_id`.
- **Compound-key experiment (same session, then reverted):** Attempted storing zones as `"channel_number|rxFreq|channel_name"` composite strings so round-trips through OpenGD77 would preserve zone associations. Reverted immediately — OpenGD77 can't parse composite keys. Feature-flag approach (`USE_COMPOUND_KEY_EXPORT`) was added as a toggle then set back to `false`. `COMPOUND_KEY_REVERT_GUIDE.md` created.
- **Import upsert by name+freq (final solution):** Instead of DELETE-all + INSERT (which reassigns `_id` values), import now checks if a channel exists by matching `channel_name + rxFrequency`. If found, it UPDATEs the existing row (preserving `_id`); otherwise INSERTs a new one. Zones built via `name → _id` map survive the round-trip. This is OpenGD77-compatible (no format changes needed).
- Zone field stored as the channel's database `_id` (not channel number) so duplicate channel numbers across zones work correctly (3/14 session).
- **v3.3.3 bug fix:** channel import error handling — malformed/incomplete CSV rows now skipped gracefully instead of crashing the whole import.

### 3.4 TG List management
- [`TGListDatabase.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/TGListDatabase.java) — `tg_lists` (id, name, tg_ids CSV, description) + `channel_tglist_assignments` (3/19 session, shipped as v3.3.6). Named TG lists with **unlimited** entries logically; hardware still gets only the first 32.
  - **Architecture iteration mid-session:** initial implementation intercepted `DmrManager.sendDigitalMessage` in `beforeHookedMethod` and overwrote `channelData.groups[]` at runtime. This conflicted with the native firmware's own group-grid UI. v3.3.6 switched to **direct DB write at save time**: when a channel is saved with a TG list assigned, `getHardwareGroups()` serialises the first 32 IDs into `channel_groups` via `updateChannel()`, the runtime hook is gone, and the native group grid refreshes immediately on TG-list selection. Empty slots written as `0` to match native behavior.
  - **Post-release CSV-import bug + fix (same v3.3.6 cycle):** the importer only wrote the TG-list assignment to the meta-table and left `channel_groups` at the hardcoded default `"1,0,…,0"`, so the firmware never saw the TGs on imported channels. Fix mirrors `saveChannelData`: after `assignTGListToChannel(rowId, listId)`, immediately serialise `getHardwareGroups()` into `channel_groups` for the just-inserted row.
- TG List name written into CSV column 9 on export; assignments rebuilt on import.
- Group-grid refresh on TG-list change (v3.3.6).
- **Limitation that remained:** firmware hard-caps at 32 TG IDs per channel (fixed-size `ChannelData.groups = int[32]`). Software filtering for >32 was attempted but blocked — see §4.

### 3.5 Software squelch (the big one)
**Background:** Firmware forces `sq` to `2` for any value other than `0`. Levels 1, 3–9 are silently coerced to 2. Only `0` (fully open) and `2` (tight) behave differently. This was *empirically discovered* across multiple sessions (see `SQUELCH_HARDWARE_LIMITATION.md`).

**Solution (3/13 session, `SOFTWARE_SQUELCH_DESIGN.md`):**
- Force hardware to `sq=0` via `AnalogMessage.send()` (bypasses the state machine cache — same path the MON button uses).
- In `hookPCMReceiveManager().writeAudioTrack` `beforeHookedMethod`:
  1. Compute audio RMS (subsampled every 4th sample for ~4× speedup).
  2. Combine with RSSI from `SignalMessage` (hybrid gate, most reliable).
  3. Apply hysteresis (~3 dB) and 300 ms hang time.
  4. **Copy audio FIRST**, then mute the copy that goes to `AudioTrack`. Decoders (APRS/SSTV/NOAA/transcription) always receive pre-squelch audio.
- Slider 0-9. Status indicator (gray/green circle) was later **removed** from the intercom page for a cleaner look (no background box either).
- Hardware writes happen only on `onStopTrackingTouch` (no spam during drag).
- **Slider visibility:** Tagged `DMR_SQUELCH_CONTAINER`; hidden on digital channels (`currentChannelType == 0`) using `mLocalView.findViewWithTag()` inside the `updateUI` hook. Note: use `mLocalView` — field `mFragmentView` does not exist.
- **Threshold 0 = bypass:** `softwareSquelchThreshold > 0` is checked before the entire gate block; at 0 the software squelch is skipped entirely and only hardware squelch acts.
- **sq=0 is required:** `enableSoftwareSquelchOnCurrentChannel()` must send `sq=0` (same as MON button). Changing to `sq=1` breaks the receive path — PCM data stops arriving even though speaker output also doesn't pass with `sq=0` alone. The combination of `sq=0` + software gating is what works.
- **APRS monitoring slider (3/13 session):** The "Open Squelch" hardware-squelch button in the APRS dialog was replaced with a software squelch slider. Requires `currentChannelType = 1` to be explicitly set when entering APRS monitoring; otherwise the `currentChannelType == 1` guard in `hookPCMReceiveManager` fails silently and no gating occurs.
- **Soft SQ toggle button — intercom page (3/13 session):** Static ref `softwareSquelchToggleButton`; 90dp × 40dp, 12sp, positioned above TXT button on the left side of the PTT area. Default OFF (`isSoftwareSquelchEnabled` changed from `true` → `false`). ON (blue) → shows slider + calls `enableSoftwareSquelchOnCurrentChannel()`; OFF (grey) → hides slider + calls `disableSoftwareSquelchOnCurrentChannel()` (sets hardware sq=2). Only visible on analog channels.
- **APRS Soft SQ toggle (3/13 session):** Independent variable `isAprsSoftwareSquelchEnabled` (default false). Same show/hide + enable/disable behavior. The two pages have completely independent squelch state.
- **APRS button → ToggleButton (3/13 session):** Converted from a plain green `Button` to a `ToggleButton`. Static ref `aprsToggleButton`. `startAPRSMonitoring` / `stopAPRSMonitoring` flip its checked state; dialog close listeners also uncheck it. OFF color: 0x6000AA00 (light green); ON color: 0xFF00AA00 (green).
- **Button OFF-state color convention (3/13 session):** All five toggle buttons (Soft SQ, TXT, REC, MON, APRS) use **38% opacity (0x60 alpha) of their active color** for the OFF state: TXT=0x609370DB, SoftSQ=0x602196F3, REC=0x60FF0000, MON=0x60FF8C00, APRS=0x6000AA00.
- **Toast drag bug (3/13 session):** A `Toast.makeText` left in `onProgressChanged` was showing the squelch level on every drag step. The drag was never re-applying hardware squelch at each step (hardware write had already been moved to `onStopTrackingTouch`); it was visual spam only. Toast removed.
- **APRSDatabase default squelch = 1** — `DEFAULT_APRS_SQUELCH = 1` (not 2). Hardware is forced to 0 when software squelch is active; the database value is the software gate threshold.

### 3.6 APRS (RX only — TX is dead, see §4)
- [`AFSKDecoder.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/AFSKDecoder.java) — original Goertzel attempt, abandoned.
- [`AFSKDecoderIQ.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/AFSKDecoderIQ.java) — **the one currently used**. IQ mixing + FIR low-pass (Dire Wolf style).
- [`AFSKDecoderPLL.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/AFSKDecoderPLL.java) — PLL clock recovery. The Feb 22 session fixed `TICKS_PER_PLL_CYCLE` from `0x80000000L` → `0x100000000L` (was running at half speed, recovering 944 of 1905 bits).
- [`APRSPacketDecoder.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/APRSPacketDecoder.java) — AX.25 framing, bit-unstuffing, CRC-16-CCITT. Uses the **longest-gap algorithm** to find the actual data frame between FLAG runs (instead of the first FLAG pair, which yielded garbage).
- [`APRSReceiver.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/APRSReceiver.java) — circular buffer + decode pipeline.
- [`APRSDatabase.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/APRSDatabase.java) / [`APRSReceivedDatabase.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/APRSReceivedDatabase.java) — settings + received-packet storage.
- [`LocationDatabase.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/LocationDatabase.java) — GPS positions tied to received packets.
- APRS monitoring UI with green-themed RSSI meter, independent software-squelch toggle, and channel backup/restore.
- **Confirmed working:** decodes off-air packets from BG6LKK-8 and others with valid FCS.

### 3.7 SSTV (RX only) — 3/15 session
- **PKT RAD menu origin (3/15 session):** The intercom-page APRS button was renamed to "PKT RAD" and now opens `showPacketRadioMenu()` — a sub-menu dialog with APRS and SSTV entries. SSTV button was added (greyed out initially, then activated as the decoder came online). This is where the hierarchical packet-radio entry-point lives.
- [`SSTVMode.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVMode.java) — VIS-code database (Robot 36/72, Martin M1/M2, Scottie S1/S2, PD 120/180).
- [`SSTVVISDetector.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVVISDetector.java) — Goertzel-based VIS detection with leader-tone gating and parity.
- **Decoder arc (3/15 session) — multiple failed approaches before IQ:**
  1. `SSTVFFTDemodulator` (32-sample FFT peak-bin → Hz) — resolution too coarse, all-black output.
  2. `SSTVGoertzelDemod` (multi-frequency Goertzel magnitudes) — correctly detects sync tones but gives all-black image data (wrong demod for continuous FM).
  3. Phase-based demod (atan2 consecutive samples) — all-white (normalization factor wrong, output ~10× larger than expected ±1 range).
  4. Robot36 port with IQ baseband + Kaiser-FIR LPF + phase-difference FM demod — **breakthrough**: brightness range 0–255 with all 256 lines decoded. Sourced from `xdsopl/robot36` (downloaded to `C:\Users\Joshua\Downloads\robot36-2\`).
- [`SSTVFMDemodRobot36.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVFMDemodRobot36.java) and the IQ stack: [`SSTVImageDecoderIQ.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVImageDecoderIQ.java), [`Complex.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/Complex.java), [`Phasor.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/Phasor.java), [`Kaiser.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/Kaiser.java), [`ComplexConvolution.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/ComplexConvolution.java). **8 kHz is sufficient** — SSTV tones (1200–2300 Hz) are well within half Nyquist at 8 kHz.
- **Timing calibration:** HackRF was transmitting at ~83% speed (149/256 lines decoded initially). Auto-calibration measures actual sync interval and scales all timing constants dynamically. Calibration factor ~1.206× was consistently observed.
- [`SSTVAutoDetector.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVAutoDetector.java) — sync-based fallback when VIS is missed.
- [`SSTVReceiver.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVReceiver.java) — 3 MB circular buffer (~180 s @ 8 kHz), state machine, 10-s silence timeout.
- Alt demod backends kept for experimentation: [`SSTVFFTDemodulator.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVFFTDemodulator.java), [`SSTVGoertzelDemod.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVGoertzelDemod.java), [`SSTVZeroCrossingDemod.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVZeroCrossingDemod.java), [`SSTVPhaseDemod.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVPhaseDemod.java). The IQ + Kaiser-FIR stack is the production path.
- Software-squelch slider on the SSTV page (v3.3.5).
- Saves received images and provides a viewer dialog (v3.3.3).
- **v3.3.3 shipped (Mar 18, 2026):** SSTV Settings dialog (configurable frequency, VHF 136–174 MHz / UHF 400–520 MHz, default 144.500 MHz, persisted in SharedPreferences). SSTV Received Images gallery dialog (files in `Download/DMR/SSTV/`, newest-first, tap to open in device gallery). APRS + SSTV start-dialog refresh fix: saving settings now dismisses the old dialog and reopens a fresh one with the latest values.
- **Stale-state crash on app restart (3/15 session):** In Zygisk the module's static variables survive across app force-close/restart. Before this fix, `isSSTVMonitoringActive` stayed `true` across crashes; on next launch it tried to update a stale dialog reference → crash. Fix: startup block must reset ALL mode flags to `false` and nullify dialog/receiver references. Also: crash-recovery block that detects `"SSTV ("` prefix in the current channel name (same as APRS `"APRS ("`) and shows the channel-restore dialog. **Pattern: any new monitoring mode must be fully cleared in the startup hook.**
- **Channel name corruption bug (`"SSTV (null)(UHF)"`):** `startSSTVMonitoring` wrapped the channel name as `"SSTV (" + originalName + ")"`. If the backup was saved while the channel was already wrapped (previous crash), restoring gave `originalName = "SSTV (UHF)"` → re-wrap → `"SSTV (SSTV (UHF))"`. Guard added: if the name already starts with `"SSTV ("` and ends with `")"`, extract the inner name before re-wrapping.

### 3.8 NOAA APT satellite reception
- [`NOAAReceiver.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/NOAAReceiver.java) — APT demodulation (v3.3.4).
- [`SatellitePassPredictor.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/SatellitePassPredictor.java) — TLE-based pass prediction.
- [`FrequencyModulation.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/FrequencyModulation.java) — FM demod for wideband APT.
- Standalone testbed: `noaa-standalone/`.

### 3.9 VFO mode (v3.1.5 / v3.1.6, 3/14 session)
- Phase 1 (~602 lines added): VFO ToggleButton on intercom page, channel backup/restore via the APRS pattern (`saveVFOChannelBackup`, `restoreVFOChannelBackup`, `checkAndRestoreVFOChannelOnStartup`), software squelch enabled by default at threshold 3, frequency entry dialog, analog/digital mode toggle. State variable: `isVFOModeActive`.
- Phase 2: full `showVFODialog()` with mode-specific subsections (analog: freq, squelch, bandwidth; digital: freq, color code, timeslot, contact type, TX contact). Dialog uses `setNeutralButton` so tapping "Apply Changes" applies settings without auto-dismissing — an earlier `setPositiveButton` implementation auto-closed and was frustrating for quick tuning.
- **Bug fixed mid-session (v3.1.5):** `saveVFOChannelBackup`/`restoreVFOChannelBackup` crashed on analog channels when reading DMR-only fields (`colorCode`, `contactType`, `txContact`, `inBoundSlot`, `outBoundSlot`). Wrapped each field read in `try/catch` so the analog path doesn't fault.
- **`localId` preservation bug (v3.1.5):** VFO was NOT backing up or restoring the `localId` field (= the radio's device DMR ID). After VFO hijacked the channel, `localId` was left at 0, so the radio stopped receiving any calls addressed to the device ID. Fixed by explicitly saving/restoring `localId` in the backup map. **Pattern to remember**: any mode that hijacks a channel MUST preserve `localId`.
- **All-Call workaround (v3.1.5):** `contactType=2` (ALL) is NOT supported by the Ulefone firmware — the radio ignores it. Workaround: when user selects "All Call", code internally sets `contactType=1` (GROUP) and populates the 32-entry `groups` array with common TG IDs (1–50 plus 91, 93, 310, etc.) to maximize coverage. TX All-Call does work after this fix.
- **Contact type selection added to VFO dialog:** RadioGroup with 0=Private, 1=Group, 2=All; TX Contact field label updates dynamically based on selection.
- **v3.1.6 bug fixes (same session):** VFO digital mode used wrong channel-switch path (should go through state machine); premature channel modification fired on dialog open before user tapped Apply; `updateUI()` had a race condition. All fixed, bumped to 3.1.6.
- **PKT RAD button width:** APRS button labeled "PKT RAD" on intercom page; width iterated to **76dp** (started at 95dp, reduced 20% at user request), text size 11sp.

### 3.10 DMR SMS + GPS hyperlinking (v3.3.7, 3/19 session)
- 📍 POS button on intercom page (digital channels only) sends `GPS:lat,lon acc:Xm CityState` via `SendSmsMessage`. Reverse-geocoding uses Android `Geocoder` on a background thread.
- `MessageContentActivity$MessageListAdapter.getView()` hooked in `afterHookedMethod` to detect a wide variety of GPS formats in received SMS (prefixed `GPS:/Pos:/Loc:`, labeled `Lat:/Lon:`, directional `N37.x W122.x`, bare `37.1234,-122.1234`) and convert them to `ClickableSpan`s that fire a `geo:` intent.
- Custom `OnTouchListener` routes coordinate taps to maps but leaves the existing Copy/Delete/Clean-All long-press dialog intact.

### 3.11 UI customization (3/21 session)
- **Neon sci-fi restyling of the Intercom (TalkBack) screen:** dark navy root background `0xFF060D1A` (later adjusted to `0xFF0A1520`), cyan borderBox border `0x5900E5FF`, Zone button dark navy gradient + cyan stroke, per-button neon colors (teal SOFT SQ, purple TXT, red REC, amber MON, green PKT RAD / POS, gold VFO), squelch slider/label cyan.
- **Frequency display trimmed to 3 decimal places** in the `updateUI` `afterHookedMethod` hook — regex `(\d+\.\d{3})\d+` → `$1` applied to the Send/Receive TextViews, e.g. `"Send: 462.562500"` → `"TX: 462.562"`.
- Custom PTT button sprites for idle/TX/RX states. Hooked `setTalkbackRecordBg` with **`XC_MethodReplacement`** (not `afterHookedMethod`) because OEM code re-overwrites the drawable. Module resources loaded via `context.createPackageContext("com.dmrmod.hooks", CONTEXT_IGNORE_SECURITY)` + `getResources().getIdentifier()`.
- Custom 0-9 channel-number sprites via `updateChannelNumber()` hook.
- [`CircuitBoardView.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/CircuitBoardView.java) — procedural PCB-trace background (9% opacity cyan), Matrix-style falling lines at 20 fps, 18-bar audio VU meter. Amplitude always computed (moved before squelch `if` block) so bars animate regardless of Soft SQ state. `isReceiving` flag suppresses animation when there's no signal.
- `original_assets/` folder at workspace root — 59 unique OEM PNGs (xxhdpi, copied for reference/template use).
- **PTT density fix:** PNGs must be in `drawable-xxhdpi` (528px) and `drawable-xhdpi` (352px), NOT plain `drawable/` (which Android scales 3× on xxhdpi). PTT button locked to explicit 176dp×176dp layout params so WRAP_CONTENT can't inflate it.
- **`setTalkbackRecordBg` race:** `afterHookedMethod` fires before `runOnUiThread` inside OEM method → OEM drawable lands on top. Fixed by switching to `XC_MethodReplacement` which prevents OEM code from ever running.
- **Channel list empty on tab switch:** `InterPhoneChannelFragment.updateView()` (called by `onPageSelected`) overwrote the channel list with an unfiltered `getChannelList()` call. Fixed by hooking `updateView()` to call `initData()` instead.
- **Number sprites:** User provided sprite sheets; current hook is `updateChannelNumber()` with `XC_MethodReplacement` loading from module context. OEM number images still returned to default (hook was removed at user request — custom PNGs still exist in drawable folders but are not applied).
- **Channel left/right buttons blocked during RX:** `ReceiveSoundState.processMessage()` has no case for `MSG_CHANNEL_CHANGE (2021)` — message silently consumed. Fix in `hookChannelNavigation`: hook that method, grab `this$0` outer `TalkBackStateMachine`, get `fragment` field, call `fragment.updateChannelId()`.
- **Sound bar idle animation:** `audioAmplitude` was never reset when not receiving, so bars reacted to noise on silent channels. Added `isReceiving` flag to `CircuitBoardView` (synced from PCM hook in `MainHook`); when false, forces amplitude to 0. Bar max height scaled ×1.5625 (two rounds of +25%).
- Channel-list "empty after tab switch" bug fixed by hooking `InterPhoneChannelFragment.updateView()` to call `initData()`.
- Dark navy sci-fi palette: bg `0xFF0A1520`, darker `0xFF060D14`, neon green `0xFF00FF00`, cyan `0xFF00FFFF`.
- **Bottom nav bar discovered as fully custom XML** (`activity_interphone_home.xml`): horizontal LinearLayout of 5 tab children; each tab = ImageView with inline vector selector drawable + TextView label. Not a `BottomNavigationView`. OEM selector: orange `#f09700` selected / grey `#969696` unselected.
- **`hookBottomNavBar` method added**: hooks `InterPhoneHomeActivity.onCreate()` `afterHookedMethod` + `tapOnClick(View)`. Sets container bg `#060D1A`, active tab `#00E5FF` cyan + 2dp underline, inactive `#705090` muted purple. `applyBottomNavStyle(context, activeTabName)` helper updates all 5 tabs per tap.
- **Emoji icon replacement for bottom nav tabs**: OEM vector ImageViews hidden; emoji TextViews (tagged `DMR_TAB_EMOJI`) inserted at index 0 per tab. Mappings: 🎙️ Intercom, 📋 Channel, 👤 Contact, 💬 Message, 📻 Device.
- **Child-index-0 collision bug found and fixed**: after first call, index 0 is our emoji (not OEM ImageView); subsequent calls were hiding our own emoji. Fixed: check tag before hiding child 0.
- **Side button icon+label stacking (MainHook.java)**: all 7 side buttons (SOFT SQ, REC, TXT, MON, PKT RAD, VFO, POS) given `emoji\nLABEL` text, `setSingleLine(false)`, `setGravity(CENTER)`, height 40→64dp, topMargins recalculated (8/78/148dp), textSize 9→13sp.
- **`CircuitBoardView` audio sensitivity fix**: normalization changed from linear `amplitude/10000f` to sqrt curve `sqrt(clamp(amplitude,0,3000)/3000f)`. RMS 200 now maps to 26% bar height instead of 2%.
- **All four non-TalkBack fragments have `initView(View)`**: smali confirmed — `InterPhoneChannelFragment`, `InterPhoneContactsFragment`, `InterPhoneMessageFragment`, `InterPhoneLocalFragment` all expose `public initView(View)`. Positioned for future CircuitBoardView injection.
- **All four nav fragments extend `BaseViewPagerFragment`** (itself extends `androidx.fragment.app.Fragment`). `onCreateView` inflates `fragment_base_view_pager.xml` (ID `0x7f0c0037`) → stores as `mRootView`; calls `initView(mRootView)`; returns `mRootView`. Each subclass `initView` calls `super.initView()` then inflates page-specific content into `mFragmentContainer` (public `FrameLayout` field from base).
- **OEM fragment backgrounds are already dark**: `fragment_local_img_color = #000000`, `pri_title_background = #1c1c1e`. Setting dark-navy only on `mRootView` had zero visible effect because `mFragmentContainer`'s child filled all visible space with its own opaque background.
- **`hookOtherFragmentBackgrounds` fixed (Chunk 5)**: Updated to set `0xFF0A1520` on `mRootView`, `mFragmentContainer`, AND every child of `mFragmentContainer`. Build successful. Log message `✓ dark bg applied →` confirms hook fires at runtime.
- **Button height reduced**: 64dp → 52dp; topMargins row2: 78→66dp, row3: 148→124dp (12 sites patched via PowerShell regex replace).
- **CircuitBoardView injection dropped**: User clarified they only wanted the dark background color on other pages — no animated circuit board effect needed.
- **`fragment_base_view_pager.xml` layout confirmed**: Root LinearLayout → Child 0: `RelativeLayout` title bar (bg=`@color/pri_title_background` = `#1C1C1E`) → Child 1: `FrameLayout` `mFragmentContainer`. The title bar is shared by ALL 5 nav fragments (including TalkBack) because they all extend `BaseViewPagerFragment` which inflates this base layout.
- **`param.args[0]` vs `mLocalView` clarified**: In `initView(View)` hook, `param.args[0]` = `fragment_base_view_pager.xml` root; `mLocalView` = fragment-specific content inflated into `mFragmentContainer`. The background must be set on `mFragmentContainer.getChildAt(0)` (or `mLocalView`) to affect visible content, NOT the root.
- **`fragment_local_view.xml` full structure**: Root `LinearLayout` (no bg) → Child 0: `RelativeLayout` `bg="#ff000000"` (avatar image area) → Child 1: `ScrollView` → inner `LinearLayout` `bg="@color/fragment_local_background"` (#1C1C1E). The inner ScrollView LinearLayout was the one blocking background changes to the Device page.
- **`hookOtherFragmentBackgrounds` updated** to also walk into `ScrollView` children and darken the inner LinearLayout on the Device/Local page.
- **`hookGenericActivityBackgrounds` method added**: hooks `onCreate` for 9 sub-activities that previously kept `#1C1C1E` grey backgrounds. Uses `View.post()` to set `#0A1520` on root + `#060D14` on status/nav bars after layout inflates. Targets: `FragmentLocalSettingsActivity`, `FragmentLocalDeviceAreaActivity`, `FragmentLocalDeviceAreaListActivity`, `FragmentLocalUseAssistantActivity`, `MessageContentActivity`, `FragmentNewContactsActivity`, `RecordListActivity`, `FragmentLocalTestBiteErrorRateActivity`, `FragmentLocalInformationActivity`.
- **Title bar color fixes (all fragments)**: Changed `#1C1C1E` → `#060D14` on the base fragment title bar (child 0 of rootView) in `hookOtherFragmentBackgrounds`. Also added title bar darkening to `hookTalkBackFragment` (which previously missed it). TalkBack content bg corrected `#060D1A` → `#0A1520`.
- **System bar colors added**: `Window.setStatusBarColor(0xFF060D14)` + `Window.setNavigationBarColor(0xFF060D14)` added to `hookMainActivity` and all sub-activities in `hookGenericActivityBackgrounds`.
- **Edit channels page (`InterPhoneChannelActivity`) darkened** via `hookChannelEditActivity`: sets dark bg on ScrollView + container + all row children via `View.post()` runnable that runs after zone/TG rows are added.
- **Remaining un-dark pages reported at chunk end**: User still sees some pages without dark background. Subagent scan for all fragments/activities launched — chunk ends mid-investigation.
- **Chunk 7 (lines 18001–21000) — FINAL CHUNK — session continues across topics:**
- **Software squelch desync on channel load**: After a channel change, the 300 ms delayed `enableSoftwareSquelchOnCurrentChannel()` call sometimes races with the state machine, leaving squelch in an initialized-but-not-active state. Symptom: "quick blip of audio, then squelch blocks everything even though threshold is low enough." Touching the slider without changing value re-triggers `enableSoftwareSquelchOnCurrentChannel()` and fixes it. Root cause not yet fully resolved; `Pitfall 10` in copilot-instructions extended with this symptom.
- **`copilot-instructions.md` created and iterated** during this session (committed 2026-05-13): created at root then moved to `.github/`; OpenGD77 fork docs added (relay + outbound slot bugs); APK signing config expanded (debug MUST use same keystore as release); GitHub Release Process section added (7-step workflow); commit/release guardrails added ("only when explicitly requested"); Feature Tracking section added; README update guardrail added.
- **`channel_txContact` = DMR ID, NOT database `_id`**: Critical discovery. `InterPhoneContactsFragment.saveSelectedData()` stores `contactData.getNumber()` (= `contact_number` field, the actual 24-bit DMR ID) as `txContact`, NOT the database `_id`. All four export/import files (`DirectDatabaseExporter`, `DirectDatabaseImporter`, `CSVExporter`, `CSVImporter`) had the same bug: `buildContactMap` indexed contacts by `_id` instead of `contact_number`, causing all contact lookups on export to return "None" and all imports to default to contact 1. **⚠️ CORRECTION (2026-06-05):** The chat log described this as "Fixed in all four files" but that fix was never actually committed — it was only claimed in the session narrative. Verified absent on `main` through v3.3.9. **Actually fixed in v3.4.0** (commit implementing Pitfall 12): `buildContactMap`/`buildContactNameMap` now query `contact_number` instead of `_id`; exporter writes real DMR ID to col 11; importer tries col 11 (DMR ID) first with name fallback; default contact changed from 1 to 0.
- **DMR ID fallback column**: Android format (37-col) now exports the raw DMR ID to column 11 (`DMR ID`) as a fallback. Importer reads column 11 as backup when name lookup fails (cross-device or missing contact scenario). **Status: shipped v3.4.0**.
- **Contact import ordering**: Contacts CSV must be imported BEFORE channels CSV so the name→DMR-ID lookup succeeds. Commit `32f8f372` ("Fix import order: import contacts before channels").
- **ContactType semantics**: `channel_contactType` 0=PERSON, 1=GROUP, 2=ALL. Extended import (37-col) reads this from col 36; legacy OpenGD77 format defaults to 0. `channel_contactType` is exported in col 36 of Android format.
- **ADB access**: App (`com.pri.prizeinterphone`) is not debuggable; device runs production build so `adb root` fails. Cannot `run-as` or `adb pull` private data. Database access must go through app export functions or hooks that log to logcat.

### 3.12 Recording & transcription

**Transcription development arc (Session F, Feb–Mar 2026):**

- **v1.5.0 — Vosk (failed):** First attempt at offline STT. Integrated Vosk + JNA; APK swelled to 13.68 MB. Failed at runtime: JNA's `Native` class runs its own `ClassLoader` static initializer, which is isolated from the hook's `ClassLoader` and can't see `System.load()`-loaded native libraries. JNA is fundamentally incompatible with LSPosed ClassLoader isolation. Abandoned.
- **v1.5.1 — ONNX / TFLite on-device Whisper (failed):** Replaced Vosk with TFLite (7.03 MB, −49%). Downloaded Whisper vocabulary files from HuggingFace + OpenAI GPT-2 tokenizer. Mel spectrogram implementation was too simplistic — model decoded only token 11 ("the") for all audio inputs. Never accurate. See §4.10.
- **v1.6.0 — Cloud transcription (SHIPPED):** Architecture changed from in-process to a separate `DMRTranscriptionService` APK (`com.macdmr.transcription`) that communicates with the hook via Android Binder (IPC). `MainHook` binds to the service, sends raw PCM bytes + sample rate; service calls the **OpenAI Whisper API** (`api.openai.com/v1/audio/transcriptions`, model `whisper-1`) and returns transcript string. First confirmed working transcription (2026-02-27 logcat shows live test: *"It has to be DMR transcription ability."*, *"Test of monkey, don't worry."*, etc.).
  - Per-channel transcription history (up to 10 messages per channel); messages restore on channel switch.
  - Format: `[HH:mm:ss] CallerName: text` or `[HH:mm:ss] ID 123456: text` (analog = timestamp only).
  - Scrollable `ScrollView` (100dp max height). Daily log file at `/storage/emulated/0/Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`.
  - `lastRecordingPathForTranscription` and `savedCallerDmrIdForTranscription` state vars pass caller context into the async transcription callback.
- **v1.7.0 — API key management (SHIPPED):** API key file `/storage/emulated/0/DMR/api_key.txt` created automatically on first startup with inline instructions. Dialog shown if TXT pressed without a valid key. TXT button long-press lets user reconfigure the key. `TranscriptionService` reads key from the file (fallback to `BuildConfig`).

**Current production path:** Recordings triggered from `hookPCMReceiveManager` → PCM saved to `/sdcard/Download/DMR/Recordings/[ChannelName]/` → IPC to `DMRTranscriptionService` → OpenAI Whisper API → displayed on-screen and appended to daily log. On-device TFLite was researched but not productionised — see §4.10.

### 3.13 Misc tooling
- [`PatchReloadHelper.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/PatchReloadHelper.java) — assists with patch reload workflows (see `PATCH_RELOAD_TEST_RESULTS.md`).
- [`DiagnosticDatabaseDump.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/DiagnosticDatabaseDump.java) — dumps app DBs for troubleshooting.
- [`UARTBootloaderProbe.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/UARTBootloaderProbe.java) — exploratory; see §5.
- **`hookSerialCommunication()` — UART traffic logger (v1.9.0, Session F):** Hooks `SerialManager` to intercept all traffic on `/dev/ttyS0` (57,600 baud). The `libdrm.so` native library handles the actual serial I/O; the hook captures every outbound command byte and inbound response byte and logs them via `XposedBridge.log`. This session was the origin of the serial protocol command table in §7 (0x22 `SET_DIGITAL_INFO_CMD`, 0x23 `SET_ANALOG_INFO_CMD`, 0x32 `QUERY_SIGNAL_STRENGTH_CMD`, 0x33 `SET_RELAY_CMD`, etc.).

---

## 4. Features that were ATTEMPTED but FAILED (do not re-try without new hardware)

These are dead-ends documented in the logs. Marked failed means they were actually built/tested and proven not to work on this hardware.

### 4.1 APRS TX over the analog FM path — **CONFIRMED IMPOSSIBLE in software**
Full evidence in [`DMRModHooks/APRS_TX_INVESTIGATION_FINAL_REPORT.md`](DMRModHooks/APRS_TX_INVESTIGATION_FINAL_REPORT.md). Six methods tested:

| # | Method | Sample rate | Result | AFSK energy on RF |
|---|---|---|---|---|
| 1 | `PrizeTinyService.writeFrame()` @ 70% amplitude | 8 kHz | ❌ | 27 % |
| 2 | Same @ 100 % amplitude | 8 kHz | ❌ | 27 % |
| 3 | + manual FM pre-emphasis compensation | 8 kHz | ❌ worse | 15 % |
| 4 | Higher sample rate | 48 kHz | ❌ catastrophic | 3.9 % |
| 5 | `AudioTrack(STREAM_VOICE_CALL)` | 8 kHz | ❌ wrong path | played on phone speaker |
| 6 | `AudioRecord` injection | 8 kHz | ❌ never triggered | n/a |

The generator itself ([`AFSKGenerator.java`](DMRModHooks/app/src/main/java/com/dmrmod/hooks/AFSKGenerator.java)) is byte-perfect — Dire Wolf decodes the generated WAV files with `audio level = 100(29/28)`. The TYT MD-UV380 / PriInterPhone audio DSP is hardwired for voice (bandpass, AGC, de-emphasis, noise gate) and corrupts AFSK before it hits the RF stage. There is no firmware command to bypass it. The class is retained as a reference implementation only. **Future TX requires an external TNC or different hardware.**

### 4.2 Software TG-list filtering for >32 talkgroups per channel
Attempted in the 3/19 enhancement session. The plan was to set hardware `contactType = ALL`, receive everything, and drop traffic in `hookPCMReceiveManager` for TGs not in the user's list. Blocked because the `DigitalAudioMessage` body layout exposes `body[0] = callType` and `body[1..2] = caller DMR ID`, but the **destination TG offset is unknown** — could not reliably extract the called TG to filter on. Shelved; channel hardware still limited to 32 TGs per channel. (Note: 32 is a binary-protocol constraint in the `DigitalMessage` packet — `groupList` is fixed at 128 bytes = 32 × 4. Not expandable without firmware change. The named-TG-list feature in §3 ships unlimited *logical* entries but only the first 32 reach the radio.)

### 4.3 DMR group-call reception (broken at firmware level)
The radio firmware ignores the RX group list and only receives calls addressed to the radio's own DMR ID. The All-Call (broadcast) contactType is silently reverted to GROUP. Considered out of reach in software. (Note: VFO session did get **transmit** All-Call working — the RX-side bug remains a firmware issue.) This is why the version numbering jumped from 1.7.0 → 3.0.2 (skipping the planned v2.x DMR series).

### 4.4 LED / indicator-light control
Exhaustive search of the decompiled APK (3/14 LED session). No GPIO, no `/sys/class/leds/` access, no LED-specific serial commands in the 0x22–0x3C range. Hardware LEDs are controlled entirely by the radio MCU firmware, not by the Android app. **Cannot be exposed without firmware modification.**

### 4.5 Hidden APRS channel approach (replaced)
Initial APRS RX worked by creating a permanent hidden channel at 144.390 MHz and filtering it out of the channel list (`isAPRSChannel`, `createAPRSChannelIfNeeded`, getCount/getView/onItemClick filter hooks). Replaced by the in-place backup/restore approach. The 3/12 session removed all ~370 lines of dead filtering code while keeping the orphaned-channel safety check (`channelName.startsWith("APRS (")`).

### 4.6 Continuous-accumulator Goertzel for AFSK
Saturated to all-1s due to unbounded energy. Switched to sliding-window Goertzel (worked but 2× CPU), then to IQ + FIR (current). Documented in `aprs_debug/` and the Feb 22 session.

### 4.7 Metal-look channel-number sprites
Two-stage failure:
1. **Semi-transparent white BG in PNG:** `numbers0_9metal.png` (1026×618, 5×2 grid) had corner/background pixels at `rgba(255,255,255,97)` (~38% alpha). These composited grey against the dark app background. Fixed by masking R≥200, G≥200, B≥200, alpha<150 → alpha=0 (302,409 pixels removed). Still saw grey on device after this.
2. **`ImageButton` own widget background:** The OEM layout sets the number images as `android:background` on an `ImageButton`. The `ImageButton` widget itself renders an Android Material rounded-rect/ripple drawable underneath the image; both layers were visible. Fix would require also clearing the button's inherent background (`button.setBackground(null)`) — never shipped.

User reverted to OEM numbers. `updateChannelNumber()` `XC_MethodReplacement` (~55 lines) was removed. Custom PNGs remain in `drawable-xxhdpi` and `drawable-xhdpi` but are not applied. Number button layout: `fragment_talkback_num_one` (tens) / `fragment_talkback_num_two` (ones), 34dp×58dp each.

### 4.8 Channel-nav buttons during RX (reverted)
Hooked `ReceiveSoundState.processMessage()` to allow channel up/down during active receive. User asked to revert to original behavior.

### 4.9 Squelch threshold restore on APRS-mode exit
Multiple attempts in the 3/13 session. The slider visual position desynced from the actual `softwareSquelchThreshold` value because:
- `isSoftwareSquelchEnabled` controls the audio-pipeline behavior.
- `isAprsSoftwareSquelchEnabled` controls the APRS-page UI.
- `softwareSquelchThreshold` is overwritten when entering APRS mode (`MainHook.java` ~line 4219).

**Root cause confirmed by logcat (3/13 session):** After `stopAPRSMonitoring()`, software squelch was re-enabled successfully (`Re-enabled software squelch (level 1) after APRS restore`, hardware sq=0). But ~27 seconds later it was silently disabled (`Software squelch disabled - reverting to hardware squelch 2`). Cause: `softwareSquelchToggleButton` UI state was **not updated** to reflect the re-enabled state. When the user interacted with the intercom page, the `onClick` listener saw the button as OFF and fired the disable path.

**First workaround (commit `6b7f0995`):** Auto-toggle Soft SQ OFF when exiting APRS — if `softwareSquelchToggleButton.isChecked()` is true in `stopAPRSMonitoring()`, toggle it off. Simple but lossy.

**Follow-up bug (same session, chunk 5):** Even with the toggle disabled on entry, the APRS squelch level bled back to the intercom page. Specifically, `startAPRSMonitoring()` sets `softwareSquelchThreshold = aprsDb.getAprsSquelch()` (overwrites the intercom threshold). When user returns and re-enables Soft SQ on intercom, the slider shows the old intercom visual position but the actual threshold is the APRS value.

**Fix (commit `25303266`):** Added `savedIntercomSquelchThreshold` static variable. In `startAPRSMonitoring()`, save the current `softwareSquelchThreshold` before it is overwritten. In `stopAPRSMonitoring()`, restore it and update the slider (`DMR_SQUELCH_SEEKBAR` tag) and value label (`DMR_SQUELCH_VALUE` tag) via `findViewWithTag`.

**Second bug (same session):** `isSoftwareSquelchEnabled` (used by audio processing) and `isAprsSoftwareSquelchEnabled` (used by APRS-page UI) were not synchronized. When entering APRS mode the toggle was forced OFF (setting `isSoftwareSquelchEnabled = false`) then `startAPRSMonitoring()` re-set `isSoftwareSquelchEnabled = true`, but `isAprsSoftwareSquelchEnabled` stayed `false`. APRS monitoring screen showed toggle OFF; user couldn't control squelch from APRS page. Fix: in `startAPRSMonitoring()` set **both** variables; also added `softwareSquelchContainer` static reference to properly hide/show the intercom slider (commit `1a1bbd56`).

Proper full bidirectional sync between intercom and APRS squelch states remains **open** as of end of this session.

**Chunk 6 follow-ons (same 3/13 session):**

- **APRS Soft SQ toggle threshold reload bug:** After fix above, toggling APRS Soft SQ off then on reverted threshold to intercom level (200/level 1) instead of APRS level (1500/level 4). Root cause: APRS toggle's enable path didn't reload from `aprsDb.getAprsSquelch()`. Fixed: explicitly load APRS threshold from db when re-enabling.

- **Critical `if (softwareSquelchThreshold >= 1)` bug** (commit `720d2df3`): Found in **4 places** — intercom Soft SQ toggle, intercom slider `onStopTrackingTouch`, intercom page init, APRS Soft SQ toggle. All 4 guarded the `enableSoftwareSquelchOnCurrentChannel()` call behind a threshold check, meaning hardware squelch stayed at 2 when threshold = 0. Fixed all 4 to always set hardware squelch to 0 regardless of threshold. Added `ALWAYS`/`CRITICAL` banner comments at all sites and a top-of-file banner above the squelch state variable block.

- **APRS start hardware squelch problem — final resolution** (commit `b73d7cf4`): Multiple approaches all failed — immediate call, 500 ms delay, 1500 ms delay, inline AnalogMessage. Root problem: something in the state machine or audio thread init window kept reverting squelch. **Final solution: start APRS monitoring with software squelch OFF.** Hardware squelch set to 2 via direct AnalogMessage.send(). User toggles Soft SQ on manually after entering APRS (which is reliable). This sidesteps all timing issues.

- **`stopAPRSMonitoring()` flags not cleared** (commit `4396743f`): `isSoftwareSquelchEnabled` and `isAprsSoftwareSquelchEnabled` were not explicitly reset on APRS stop. Only the toggle button was unchecked. Audio pipeline continued blocking audio on return to intercom. Fix: explicitly set both flags to `false` in `stopAPRSMonitoring()`. **This was the final and decisive fix for the squelch desync family of bugs.**

### 4.10 On-device transcription — Vosk + JNA, then TFLite Whisper (both failed)

**Vosk + JNA (v1.5.0):** Vosk library requires JNA to load its native `.so`. JNA's `Native` class static initializer creates its own `ClassLoader` and attempts to extract `libjnidispatch.so` to a temp directory — but that ClassLoader is isolated from the one set by LSPosed and can't see native libraries already loaded via `System.load()`. Logcat error: `LspModuleClassLoader...couldn't find "libjnidispatch.so"`. JNA is fundamentally incompatible with LSPosed ClassLoader isolation. APK was 13.68 MB. Abandoned at v1.5.0.

**TFLite on-device Whisper (v1.5.1):** Replaced Vosk with a hand-rolled TFLite pipeline (~7 MB). Downloaded `whisper_base_merged.onnx`, converted to TFLite format. Helper scripts: `check_tflite_repos.py`, `check_vilassn_models.py`, `convert_whisper_to_tflite.py`, `generate_whisper_tflite.ipynb`. Vocabulary from HuggingFace (`whisper-base` vocab) + GPT-2 tokenizer. **Problem:** The mel spectrogram implementation was oversimplified — the model decoded only token 11 ("the") regardless of audio input. Six content tokens maximum in later iterations, still inaccurate. Never became production-ready.

**Resolution (v1.6.0):** Replaced both with the IPC + cloud path — see §3.12.

### 4.11 Firmware patches (`firmware_patch1..14`)
Numerous binary patches were generated against the radio MCU firmware to try to fix the All-Call/contactType behavior. Patches 11, 12, 14 produced partial breakthroughs (`PATCH11_BREAKTHROUGH.md`, `PATCH12_BREAKTHROUGH.md`, `PATCH14_BREAKTHROUGH.md`) but flashing is risky and these patches are **not** part of the shipped module. Documented and parked.

### 4.12 Magisk modules for signature / system-UID workarounds
`magisk_module/`, `magisk-serial-module/`, `magisk-systemizer/`, `MAGISK_SOLUTION.md`, `serial-access-module.zip`. Explored as alternatives to LSPosed during early bring-up. The LSPosed path won; these are archival.

### 4.13 Relay / repeater client-mode (researched, never built)
3/14 LED+Relay session produced two design docs — `RELAY_REPEATER_ANALYSIS.md` (18 KB) and `RELAY_TODO_LIST.md` (13 KB) — but **no code was added**. Best current understanding (~80 % confidence):
- `RelayMessage` (cmd 0x33) carries a single byte. The UI label "Relay disconnection" is misleading.
- `relay = 1` most likely means "**connect TO an external repeater**" (client mode), not "act AS a relay node". Evidence: `RELAY_ACTIVITY_TIME_OUT = 0x6` (~60 s), error path `RelayConnectionFailedState` / "Relay unable to connect", and the setting is per-channel.
- `relay = 2` is the normal-operation value the importer coerces `0` into.
- The decisive hardware test ("Test 0A: set `relay=1` on a channel with no nearby repeater and watch for the timeout") was never executed. Until that is done, treat the field semantics as unconfirmed.

### 4.14 EnhanceMessage remote-command UI (researched, never built)
3/19 DMR-capabilities session found that the firmware acknowledges five DMR remote commands via `EnhanceMessage` (function byte → ack string):

| Function | Byte | Firmware ack |
|---|---:|---|
| Radio Check | 1 | `radiochk ack` |
| Call Alert | 2 | `callprompt` |
| Remote Monitor | 3 | `callmon` |
| Radio Kill | 4 | `radioen ack` |
| Radio Revive | 5 | `radiodis ack` |

The app has **no UI** for any of them. User approved building the UI in that session, but it was never implemented — only the analysis exists.

### 4.16 APRS channel backup/restore crash on reopen (3/13 session fix)
When user closes app during APRS monitoring and reopens, `checkAndRestoreAPRSChannelOnStartup()` (called 2 s after startup via `postDelayed`) failed to restore. Fix (commit `7920620b`):
- Null checks for all backup SharedPreferences fields before casting
- Try-catch around XposedHelpers field restoration
- Try-catch around `updateChannel` / `syncChannelInfoWithData`
- Activity validity check (`isFinishing()` / `isDestroyed()`) before showing AlertDialog
- AlertDialog now has **"Restart App"** button (AlarmManager + PendingIntent 100 ms relaunch + `System.exit(0)`); "Later" option removed — restart is mandatory

### 4.17 RSSI meter in APRS live monitoring dialog (3/13 session)
Added real-time signal strength display to the APRS monitoring dialog (commit `ddb352e3`). Green theme (vs yellow on intercom page). Shows `📶 -XX dBm` or `No Signal`. Repositioned (commit `38942527`) to the **right of the green "MONITORING ACTIVE" status text** in a horizontal container (status text 60% width, RSSI meter 40%). Updates every 2 s with the dialog refresh cycle. Cleaned up (`aprsRssiDisplayTextView = null`) when dialog closes.

### 4.19 Bottom nav tab collapse on tap (Session B, open as of Chunk 4)
After `hookBottomNavBar` added emoji TextViews to each tab at index 0 and hid the OEM ImageView, tapping a tab caused all icons to disappear (tabs showed text only). Root cause: OEM `tapOnClick` (or a method it calls) resets/re-shows tab views, re-surfacing hidden OEM ImageViews and corrupting our emoji insertion order. Status: **open** at end of Session B Chunk 4 — investigation was ongoing when lines ran out. A per-call child-tag-check fix was applied but the visual regression persisted on device. May be resolved in Chunks 5–7.

### 4.18 Release v3.1.4 / signing keystore created
At end of 3/13 session, `release.keystore` created at `DMRModHooks/release.keystore` (`-alias dmrmodhooks`, storepass/keypass `android`). `build.gradle` updated: both debug and release `signingConfigs` reference `../release.keystore` so debug installs use same signature as release (prevents LSPosed module deregistration on reinstall). Version bumped to `versionCode 314` / `versionName "3.1.4"`.

### 4.15 SSTV "all black image" decode
Documented in `SSTV_DECODING_PROBLEM.md` / `SSTV_FM_DEMOD_PROBLEM.md`. The detector finds Scottie S2 / Robot 36, brightness range is 0–255, line count matches — but output is black on the device for some files even though external decoders succeed on the same WAV. Pre-FM-IQ-rewrite issue; the current `SSTVImageDecoderIQ` path is the workaround. Edge cases still possible.

---

## 5. Things that were DELETED from the codebase

(Beyond what's already covered in §4.5 / §4.7 / §4.8.)

- `isAPRSChannel()` (lines 190-208) — 3/12 session.
- `createAPRSChannelIfNeeded()` (lines 3722-3787) — dead code, never called.
- Channel-list filtering hooks (lines 7273-7554, ~280 lines) — `getCount`/`getView`/`onItemClick` position-remapping.
- `SSTVFMDemodulator.java` → renamed `.old` after the IQ rewrite.
- Old database `syncChannelInfo()` path for APRS squelch — replaced with direct `AnalogMessage.send()` (3/12 fix; documented in user-memory `aprs-squelch-investigation.md`).

---

## 6. Architectural patterns established

Stable across sessions; treat these as project conventions.

### 6.1 Hardware-write pattern
**Don't** update the channel DB and call `syncChannelInfo()`. That goes through `CmdStateMachine.transitionToSetChannelStateState()` and is subject to caching/race conditions.

**Do** construct an `AnalogMessage` (or `DigitalMessage`) directly, copy fields from `currentChannel`, set the one field you want to change, call `.send()`. The MON button uses this; APRS squelch was migrated to it; software squelch uses it. Pattern is documented in user-memory `aprs-squelch-investigation.md`.

### 6.2 Channel-change interception
Hook `DmrManager.sendAnalogMessage(channelData)` in `beforeHookedMethod`, force `channelData.sq = 0` (or whatever software field you need), then schedule a 300 ms `postDelayed` to reset squelch state and re-enable software squelch. Catches every channel-change path: button nav, list tap, zone switch, app startup.

### 6.3 Audio-pipeline pattern
`hookPCMReceiveManager.writeAudioTrack(byte[], int)` `beforeHookedMethod`:
1. Compute amplitude.
2. `Arrays.copyOf(audioData, length)` for decoders.
3. Apply software squelch decision.
4. `Arrays.fill(audioData, 0, length, (byte)0)` if squelched.
5. Update `circuitBoardView.audioAmplitude` conditionally — `0` if squelched.
6. Feed decoders the **pre-squelch copy**, never the muted version.
7. Let `writeAudioTrack` proceed normally.

### 6.4 Mode exclusivity + channel hijack/restore
All of APRS / SSTV / NOAA / VFO use the same pattern:
1. Reject if another mode is active (`isAPRSMonitoringActive || isSSTVMonitoringActive || isNOAAMonitoringActive || isVFOModeActive`).
2. `saveChannelBackup(currentChannel)` to SharedPreferences AND a backup file at `/sdcard/aprs_channel_backup.dat` (or equivalent).
3. Hijack the channel (frequency, name `"<Mode> (<OriginalName>)"`, sq=0, etc.).
4. Set the mode flag.
5. On exit (or on startup-recovery if a crashed session is detected): disable software squelch, restore from backup, clear the flag, refresh UI.

Crash recovery uses the `"APRS ("` prefix as the orphan signature — no false positives because users won't naturally type the trailing space + open-paren.

### 6.5 Hook structure template
Every hook is wrapped in `try { ... } catch (Throwable t) { XposedBridge.log(t); }`. Standard log glyphs: `✓` success, `✗` error, `◆` state change. Class paths must be looked up against decompiled smali (see e.g. `com.pri.prizeinterphone.serial.data.ChannelData` vs `com.pri.prizeinterphone.data.ChannelData` — wrong path is a common failure mode noted in user-memory).

### 6.6 UI replacement vs observation
`XC_MethodReplacement` when OEM code will overwrite your work (PTT drawable). `afterHookedMethod` when you only need to post-process a result (message-list `getView`). `beforeHookedMethod` to mutate args (audio mute, sq override).

### 6.7 OpenGD77 CSV round-trip rules
- 32 mutually exclusive fields shipped + `_id` column 0 for Android, dropped for OpenGD77.
- `relay` = `0` on import → coerce to `2` (firmware-safe normal mode).
- `OutboundSlot` is 0-based on disk, 1-based in the CPS model; convert both directions.
- `Col 11 DMR ID` always exported empty by CPS — Android importer falls back to contact-name lookup.
- AndroidContactType: 0 = PERSON, 1 = GROUP, 2 = ALL.
- **`channel_txContact` stores the DMR ID (= `contact_number`), NOT the database `_id`.** All four export/import files (`DirectDatabaseExporter`, `DirectDatabaseImporter`, `CSVExporter`, `CSVImporter`) previously indexed the contact map by `_id`, causing every contact export to return "None". Fixed: build map keyed by `contact_number`. Android format now also writes the raw DMR ID to col 11 as a fallback for cross-device imports.
- **Import ordering dependency**: contacts CSV MUST be imported before channels CSV or the name→DMR-ID lookup will fail and `channel_txContact` will be zeroed.
- **⚠️ TODO for copilot-instructions**: Add these as Pitfall 12 (contact map indexed by wrong key) and document the import-ordering requirement.

---

## 7. Hardware / firmware facts discovered

Treat these as ground truth derived from empirical testing.

| Topic | Finding |
|---|---|
| Squelch | Firmware coerces `sq` to `2` for any value 1 or 3–9; only `0` (open) and `2` (tight) behave differently. |
| Analog audio TX | Voice-optimized DSP destroys AFSK (-21 dB RMS, AFSK energy 96 % → 27 %, spurious 1001 Hz tone). No bypass command exists. |
| Serial port | `/dev/ttyS0` carries the binary protocol; `MyNotificationManager.smali` references it. |
| Protocol commands | Verified in decompiled `MessageType`/message classes (3/19 session). Core: 0x22 SET_DIGITAL_INFO · 0x23 SET_ANALOG_INFO · 0x2E SET_VOL · 0x30 SET_SQUELCH · 0x32 QUERY_SIGNAL_STRENGTH (RSSI) · 0x33 SET_RELAY (a.k.a. SET_OFFLINE_MODE). Additional: MODULE_INIT, SET_LAUNCH_INFO, SET_ENHANCE_FUNCTION (5 sub-functions, see §4.14), SET_ENCRYPT_FUNCTION, SET_GAIN_MIC, SEND_SMS/RECEIVE_SMS, QUERY_DIGITAL_AUDIO_RECEIVE_INFO, SET_LISTEN, SET_POLITE_POLICY, SET_MIX_CHECK_INFO, SET_SMS_PROTOCOL_TYPE, SET_POWER_SAVE_MODE, INTERRUPT_TRANSMIT (3 modes), TOT (0x3B), BER test (0x3F). **No LED command exists** in 0x22–0x3C. |
| `RelayMessage` | Single byte. `0` = relay disconnect OFF (normal repeater behavior). `1` = relay disconnect ON — **but the actual semantics are unconfirmed**, see §4.13 (most likely "connect to external repeater", not "act as a relay"). `RELAY_ACTIVITY_TIME_OUT = 0x6`, `RelayConnectionFailedState` handles failures. |
| `DigitalMessage` packet | 163 bytes total. `groupList` field is fixed at 128 bytes = **32 × 4-byte TG IDs**. This is the binary-protocol constraint behind the 32-TG-per-channel limit. |
| TG list | Hardware groupList is fixed `int[32]` (see above). Cannot expand without firmware change. v3.3.6 ships unlimited logical lists via `TGListDatabase`; only the first 32 entries reach the radio. |
| DMR SMS char limit | **Not enforced anywhere in the app code.** Firmware/protocol upper bound was not pinned down during the 3/19 review; ETSI sets an upper bound but the exact PriInterPhone-firmware value is undocumented. If users hit truncation in the wild, that's the place to investigate. |
| Contact types | 0 Private, 1 Group (RX broken — firmware ignores RX group list), 2 All-Call (TX now works after VFO-session fix; RX still firmware-limited). |
| Encryption | 8-byte basic + 16-byte AES per channel. `EncryptSwitch` always exported as `0` because keys can't survive the .g77 binary round-trip. |
| LSPosed module preservation | Same signing key for debug & release; `adb install -r` keeps the module enabled. |
| LEDs | Not controllable from the app. |

---

## 8. Open problems / unfinished work

- Software-squelch state synchronization between intercom page and APRS page (`isSoftwareSquelchEnabled` ↔ `isAprsSoftwareSquelchEnabled` ↔ `softwareSquelchThreshold`). Current workaround auto-toggles OFF on APRS exit.
- **Post-channel-change squelch desync** (related but distinct from above): the 300 ms delayed `enableSoftwareSquelchOnCurrentChannel()` can race with the state machine, leaving squelch initialized but not active. Symptom: audio blips then cuts; touching the slider without moving it restores correct behavior. **⚠️ TODO for copilot-instructions**: document as Pitfall 13 (post-channel-change squelch race condition and slider-touch workaround).
- AFSK FCS edge cases under high noise (Dire Wolf still decodes a few files we don't).
- SSTV "all black image" failure mode for certain WAVs even though detection succeeds.
- DMR group-call RX (firmware-level; will not be fixed in software).
- DMR text-message character-limit handling (firmware varies by model; no enforcement in our SMS UI).
- TG-list software filtering for >32 entries (blocked on unknown `DigitalAudioMessage` body layout).
- On-device Whisper TFLite (research only; cloud Whisper is the shipped path).
- `DMRModHooks/README.md` is stale (claims v3.1.3 while `copilot-instructions.md` is at v3.3.7).

---

## 9. Quick file-map of the runtime code

| Area | Files |
|---|---|
| Hook entry | `MainHook.java` |
| Audio | `Complex.java`, `ComplexConvolution.java`, `Phasor.java`, `Kaiser.java`, `FrequencyModulation.java`, `ToneConverter.java` |
| APRS RX | `AFSKDecoder.java`, `AFSKDecoderIQ.java` ⭐, `AFSKDecoderPLL.java`, `APRSPacketDecoder.java`, `APRSReceiver.java`, `APRSDatabase.java`, `APRSReceivedDatabase.java`, `DireWolfDecoder.java`, `LocationDatabase.java` |
| APRS TX (reference only — does **not** transmit successfully) | `AFSKGenerator.java` |
| SSTV | `SSTVMode.java`, `SSTVVISDetector.java`, `SSTVAutoDetector.java`, `SSTVReceiver.java`, `SSTVImageDecoder.java`, `SSTVImageDecoderIQ.java` ⭐, `SSTVFMDemodRobot36.java`, `SSTVFilter.java`, plus alt demods `SSTVFFTDemodulator.java`, `SSTVGoertzelDemod.java`, `SSTVZeroCrossingDemod.java`, `SSTVPhaseDemod.java`, `SSTVVISResult.java` |
| NOAA APT | `NOAAReceiver.java`, `SatellitePassPredictor.java` |
| Codeplug | `CSVExporter.java`, `CSVImporter.java`, `DirectDatabaseExporter.java`, `DirectDatabaseImporter.java`, `PDFExporter.java`, `BackupActivity.java`, `ZoneDatabase.java`, `TGListDatabase.java` |
| UI | `CircuitBoardView.java` |
| Tooling | `DiagnosticDatabaseDump.java`, `PatchReloadHelper.java`, `UARTBootloaderProbe.java` |

⭐ = current production decoder.

---

## 10. Caveats about this summary

**Reading status of the 10 source logs** (updated May 29, 2026 after direct re-read):

| Log | Lines | Status |
|---|---:|---|
| `copilot-2026-03-12-debugging_aprs_channel_hiding_issue.md` | 319 | ✅ read in full |
| `copilot-2026-03-14-dive_in_to_the_orignal_apks_code_and_figure_out_if.md` | 1,184 | ✅ read in full (source of §4.13, §4.14, LED-impossibility confirmation) |
| `copilot-2026-03-19-dmr_capabilities_analysis_and_improvement_suggestions.md` | 3,840 | ✅ read in full (source of expanded §7 protocol table, EnhanceMessage 5-function table, DigitalMessage 163-byte size, DMR SMS no-limit finding, GPS-POS button details) |
| `copilot-2026-03-19-enhancing_dmr_capabilities_and_group_management.md` | 6,190 | ⚠️ partial (~3,000 lines + tail spot-check); confirmed full TGListDatabase v3.3.6 implementation arc + post-release CSV-import fix. Remaining middle is heavily duplicated subagent-output transcripts. |
| `copilot-2026-03-13-fixing_stuck_squelch_issue_and_reviewing_documentation.md` | 18,972 | ❌ **not read** — needs chunked pass |
| `copilot-2026-03-21-ui_rendering_and_customization_inquiry.md` | 20,516 | ❌ **not read** — needs chunked pass |
| `copilot-2026-03-14-vfo_feature_implementation_plan_and_analysis.md` | 29,287 | ❌ **not read** — single-conversation context too small; needs grep-and-sample |
| `copilot-2026-03-14-take_a_look_the_the_code_and_find_where_channels_a.md` | 79,131 | ❌ **not read** — too large; needs grep-and-sample |
| `copilot-2026-03-15-examine_the_code_specific_for_the_aprs_monitoring.md` | 90,500 | ❌ **not read** — too large; needs grep-and-sample |
| `copilot-2026-02-22-push_apk_to_phone.md` | 269,772 | ❌ **not read** — 14.5 MB; physically larger than any single conversation context. Will only ever be grep-and-sampled. |

For the six unread logs, content above leans on the project's own status documents (`APRS_TX_INVESTIGATION_FINAL_REPORT.md`, `SOFTWARE_SQUELCH_DESIGN.md`, `VFO_IMPLEMENTATION_PLAN.md`, `SSTV_PHASE1_COMPLETE.md`, `DMR_GROUP_CALL_RESEARCH.md`, etc.) and `copilot-instructions.md`, all produced **during** those sessions and consistent with the chat snippets we have read. If a feature is mentioned in `copilot-instructions.md` (v1.0, last updated May 2026) but not described above, assume it shipped — that doc was kept in sync.

A few subagent summarisers returned partially fabricated or off-topic output and have been excluded from this synthesis. Where conflicts existed, project markdown was treated as authoritative over chat-log paraphrase.
