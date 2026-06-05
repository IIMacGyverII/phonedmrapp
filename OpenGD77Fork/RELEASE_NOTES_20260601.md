# OpenGD77 CPS — PriInterPhone Fork v1.2.0

## Release Date
June 1, 2026

## Current Build (use this zip)
| Item | Value |
|------|--------|
| **Fork version** | **1.2.0** (`FORK_VERSION` in `DMR/AboutForm.cs`) |
| **Package** | `OpenGD77CPS-Mac_Build_20260601_142528.zip` |
| **Paired Android release** | DMRModHooks **v3.3.8+** (README documents fork v1.2.0); phone import fixes through **v3.4.0** are in `DirectDatabaseImporter` / `DirectDatabaseExporter`, not in this CPS binary |
| **Source repo** | https://github.com/IIMacGyverII/OpenGD77CPS-Mac |
| **Prior fork notes** | [RELEASE_NOTES_20260329.md](RELEASE_NOTES_20260329.md) — relay + outbound slot (baseline before v1.1) |

---

## What this fork is

Windows **OpenGD77 CPS** patched for **Ulefone PriInterPhone / DMRModHooks** Android CSV round-trips (37-column format with `_id`). It is **not** upstream OpenGD77 CPS — do **not** use it to program a stock Radioddity GD-77.

The About dialog and window title show fork identity and a red warning block. Bump `FORK_VERSION` in `AboutForm.cs` on every build attached to a DMRModHooks release.

---

## v1.2.0 — Latitude / Longitude / Use Location import

**Build:** `OpenGD77CPS-Mac_Build_20260601_142528.zip`  
**Git (phonedmrapp):** `d72ddf83` — *fix lat/lon not imported from Android CSV*

### Problem
After exporting from the phone and importing into the fork CPS, **Latitude**, **Longitude**, and **Use Location** appeared as **0** / off even when the Android CSV contained real values (cols 26–28 in the 37-column header).

### Root cause
v1.1.0 moved lat/lon off the `ChannelOne` struct (see below) into static arrays on `ChannelForm`, but **Path B** (`ImportFromCsvFile`) was not fully wiring those columns into `CsvLatitudes` / `CsvLongitudes` / `CsvUseLocations` for display and save.

### Fix
- **Path B** (`ChannelsForm.ImportFromCsvFile`) reads Android cols 26–28 and populates the static CSV arrays keyed by `foundIndex` (`GetMinIndex()` slot — not `channelNumber - 1`).
- **Display/save** uses `DispData` / `SaveData` with `int index = num % 1024` from `base.Tag`.

### Impact
Android → CPS → edit → export → Android preserves GPS-related channel fields when working **CSV-only** (see limitation below).

---

## v1.1.0 — Crash fix, UI, stale CSV arrays

Intermediate builds on June 1, 2026 (superseded by v1.2.0; kept in `OpenGD77Fork/` for history):

| Zip | Notes |
|-----|--------|
| `OpenGD77CPS-Mac_Build_20260601_134959.zip` | First v1.1.0 build |
| `OpenGD77CPS-Mac_Build_20260601_135906.zip` | Startup crash fix |
| `OpenGD77CPS-Mac_Build_20260601_141139.zip` | Duplicate of 141144 iteration |
| `OpenGD77CPS-Mac_Build_20260601_141144.zip` | Layout overlaps + clear stale CSV arrays on import |

### 1. Startup crash (AccessViolationException)
**Problem:** CPS crashed on startup after adding lat/lon fields to the `ChannelOne` struct.

**Root cause:** `ChannelOne` is marshalled for **binary `.g77` codeplug** layout. Extending the struct broke `Marshal.PtrToStructure` binary compatibility.

**Fix:** Store lat/lon/use-location/encrypt-key in **static arrays** on `ChannelForm` (`CsvLatitudes`, `CsvLongitudes`, `CsvUseLocations`, `CsvEncryptKeys`), not in `ChannelOne`.

### 2. Layout overlaps
Channel form controls overlapped after new fields; layout adjusted in the channel editor UI.

### 3. Stale CSV arrays on import
Re-importing CSV without clearing static arrays could show previous channel’s lat/lon. Import path now clears/resets arrays appropriately.

---

## Inherited from v1.0 / March 29, 2026 build

Still documented in [RELEASE_NOTES_20260329.md](RELEASE_NOTES_20260329.md):

- **Relay** export: CPS internal `0` → Android-valid `2` (col 31).
- **Outbound Slot** export: 1-based UI → 0-based CSV (col 34).
- Android **defense-in-depth:** `DirectDatabaseImporter` still coerces `relay=0` → `2` on import.

---

## Architecture reminders (do not skip)

### Three import paths — only Path B works for Android CSV

| Path | Method | Android 37-col CSV? |
|------|--------|---------------------|
| A | `ChannelsForm.import()` (grid buttons) | No — exact 35-col OpenGD77 header only |
| **B** | **`ImportFromCsvFile()`** (menu batch import) | **Yes** — detects `_id` column |
| C | `ChannelsCsvImporter.ImportChannelsFromCsv()` | Would work — **dead code**, no call sites |

**User workflow:** Phone EXPORT → CPS **File → Import CSV** (Path B) → edit → export Android format → phone IMPORT.

### CSV vs binary `.g77`
Lat/lon/use-location/encrypt-key are **CSV-only**. Saving/loading a `.g77` binary does **not** preserve those fields. Always round-trip through the five CSV files.

### Column 11 (DMR ID)
The fork CPS export still typically leaves **DMR ID** empty; the phone app (DMRModHooks **v3.4.0+**) resolves contacts by name and col 11 on import. Do not assume the fork alone fixes Pitfall 12 on device.

### Stock OpenGD77 CPS vs this fork
Field bugs reported with **stock CPS 2025.03.23.01** are fixed on the **phone** in DMRModHooks v3.3.9 / v3.4.0 (contact type, encrypt, `channel_mode` 3↔4, `contact_number` map). This fork does not replace that layer when users import stock CPS exports.

---

## Testing recommendations

1. **Lat/lon (v1.2.0):** Export from phone with non-zero Latitude/Longitude and Use Location = Yes → import into fork CPS → confirm values in channel editor → export → re-import on phone.
2. **Relay/slot (baseline):** Relay cols are 1 or 2, not 0; digital Slot 2 survives round-trip (see March notes).
3. **No crash (v1.1.0):** Cold-start CPS after importing a large Android backup folder.
4. **Full five-file backup:** Contacts → TG_Lists → Channels → Zones → DTMF import order on phone matches `DirectDatabaseImporter` expectations.

---

## Build info

- **MSBuild:** .NET Framework 4.8  
- **Configuration:** Release  
- **Output:** `bin/ReleaseOpenGD77/OpenGD77CPS.exe`  
- **Build command** (fork repo):
  ```powershell
  cd C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac
  msbuild OpenGD77CPS.sln /p:Configuration=Release
  ```

---

## Installation

1. Download **`OpenGD77CPS-Mac_Build_20260601_142528.zip`** (v1.2.0).
2. Extract and run **`OpenGD77CPS.exe`**.
3. Confirm About dialog shows **fork v1.2.0** and PriInterPhone / DMRModHooks warning.
4. Use **menu batch CSV import** (Path B), not grid import buttons, for Android exports.

---

## Files typically modified (fork repo)

| Version | Files |
|---------|--------|
| v1.2.0 | `DMR/ChannelsForm.cs` (Path B lat/lon/use location) |
| v1.1.0 | `DMR/ChannelForm.cs`, `DMR/ChannelsForm.cs`, `DMR/AboutForm.cs` (version + branding) |
| v1.0 / Mar 29 | `DMR/ChannelsForm.cs` (relay, outbound slot) |

Deep-dive: `OpenGD77CPS-Mac/docs/CODEBASE_DEEP_DIVE.md`

---

## Related Android module

| Component | Role |
|-----------|------|
| `DirectDatabaseExporter.java` | 37-col export to `/sdcard/Download/DMR_Backups/...` |
| `DirectDatabaseImporter.java` | Import order + Pitfall 12 + channel mode (v3.4.0+) |
| `releases/DMRModHooks-v3.4.0.apk` | Current recommended phone module |

Both CPS and phone layers should be updated together when changing CSV column semantics.