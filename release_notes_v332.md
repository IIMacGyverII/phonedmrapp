# DMRModHooks v3.3.2 Release Notes

**Release Date**: March 18, 2026  
**Type**: Major Update - Zone System Refactoring

## 🎯 What We're Attempting

**Goal**: Support multiple channels with the same channel_number in different zones

The radio app's database allows duplicate channel_number values (e.g., 8 channels all with `channel_number=1`), but the zone system was using `channel_number` as the unique identifier. This meant assigning one "Channel 1" to a zone would assign ALL channels with `number=1` to that zone.

**Solution**: Refactor zone system to use `_id` (database primary key) instead of `channel_number` for zone assignments.

---

## ✅ What Changed

### Zone System Refactoring
- **Zone storage now uses `_id`** instead of `channel_number`
  - Zones store comma-separated list of `_id` values (unique per record)
  - Each channel can be independently assigned to zones regardless of `channel_number`
  - Supports scenarios like 8 channels all having `number=1` but in different zones

### Automatic Migration
- **On first launch**, zones are automatically migrated from old format to new format
  - Reads existing zones and converts `channel_number` references to `_id` references
  - Migration is idempotent (safe to run multiple times)
  - Look for log message: `"✓ Zone database migrated to _id format"`

### OpenGD77 Compatibility Maintained
- **Export format**: Standard 28-column OpenGD77 CSV (no `_id` column)
- **Import behavior**: Clears channels, resets autoincrement, imports with new `_id` values
- **Zone preservation**: Zones.csv stores channel **names**, not IDs
  - On zone import, system looks up channels by name to find new `_id` values
  - Zone assignments automatically recreated after import

### UI Changes
- Zone navigation now uses `_id` for filtering (9+ locations in MainHook.java)
- Zone assignment dialogs use `_id` for lookups
- Channel edit page saves zones using `_id`

---

## ⚠️ Potential Problems & What to Expect

### First Launch After Update
**What happens**: Automatic migration of existing zones  
**Expected behavior**:
- Zones with duplicate `channel_number` values will map to the **first `_id`** with that number
- Example: If you have channels with `_id` 1, 10, 20, 30 all having `channel_number=1`, and a zone contains "channel 1", after migration it will only contain `_id=1`
- **Action required**: Manually reassign channels 10, 20, 30 to their correct zones after migration

**Check logs** (via LSPosed or logcat):
```
ZoneDatabase: Built channel_number→_id map: 319 channels
ZoneDatabase: Migrated zone 'Zone1': 16 → 16 channels
ZoneDatabase: Zone migration complete: converted channel_number to _id
```

### Export/Import with OpenGD77
**What changed**: CSV format reverted to 28 columns (removed `_id` column)  
**Expected behavior**:
- **Export → OpenGD77**: Works perfectly (standard format)
- **OpenGD77 → Import**: Works perfectly (clears channels, zones recreate via name lookup)
- **Round trip**: Export → Edit in OpenGD77 → Import → **Zone assignments preserved** ✅

**Potential issue**: If you have channels with identical names AND identical `channel_number` values
- Zone import matches by name, so it will pick the first match
- **Best practice**: Ensure unique channel names, especially for duplicates

### Zone Navigation
**What changed**: Up/Down arrows now filter by `_id` instead of `channel_number`  
**Expected behavior**:
- Navigation cycles through channels in the current zone correctly
- No behavior change from user perspective

### Duplicate Channel Numbers
**New capability unlocked**: You can now have multiple channels with the same `channel_number` in different zones  
**Example use case**: 8 zones with channels 1-99 each (792 total channels sharing numbers 1-99)

---

## 🔍 Testing Recommendations

### Basic Testing
1. **Launch app** → Check LSPosed logs for migration message
2. **Open Zones** → Verify existing zones still show correct channels
3. **Assign a channel to a zone** → Switch zones → Verify channel appears/disappears correctly
4. **Zone navigation** → Verify up/down arrows cycle through zone channels only

### Advanced Testing (OpenGD77 Round-Trip)
1. **Export** from app → Verify 28-column CSV in `Download/DMR/DMR_Backups/`
2. **Import to OpenGD77 CPS** → Should load without errors
3. **Edit channels** in OpenGD77 (add/remove/modify)
4. **Export from OpenGD77** → Save CSV
5. **Import to app** → Zones should recreate correctly

### Edge Cases to Test
- **Case 1**: Multiple channels with `channel_number=1` in different zones
  - Assign first "Channel 1" to Zone A
  - Assign second "Channel 1" to Zone B
  - Switch to Zone A → Up/Down should only show first "Channel 1"
  - Switch to Zone B → Up/Down should only show second "Channel 1"

- **Case 2**: Rename a channel in OpenGD77
  - Export channel "Test Channel" in zone "Zone A"
  - Rename to "Renamed Channel" in OpenGD77
  - Import back → Check if zone was recreated (should fail if name changed, channel removed from zone)

---

## 📊 Technical Details

### Files Modified
- `ZoneDatabase.java`: All API methods use `channelId` instead of `channelNumber`
- `MainHook.java`: 9+ locations updated to use `_id` field for zone operations
- `DirectDatabaseExporter.java`: Removed `_id` column from CSV export
- `DirectDatabaseImporter.java`: Simplified import logic (removed UPDATE, only INSERT)

### Database Schema
**Channel table**: `database_channel_area_default_uhf`
- `_id` INTEGER PRIMARY KEY AUTOINCREMENT (unique per record)
- `channel_number` INTEGER (can have duplicates)
- `channel_name` TEXT (should be unique for best results)

**Zone table**: `dmrmod_zones`
- `channel_list` TEXT (comma-separated `_id` values, e.g., "1,5,10,15,20")

### Migration Algorithm
```
For each zone:
  For each channel_number in zone.channel_list:
    Look up _id from database WHERE channel_number = ?
    Add _id to new_channel_list
  Save zone with new_channel_list
```

---

## 🐛 Known Issues

1. **Migration limitation**: Zones with duplicate `channel_number` values will only contain the first `_id` match
   - **Impact**: High if you have many duplicates in existing zones
   - **Workaround**: Manually reassign channels after migration

2. **Import name matching**: If multiple channels have identical names, zone import picks the first match
   - **Impact**: Low (most users have unique channel names)
   - **Workaround**: Ensure unique channel names before export

3. **OpenGD77 channel renaming**: Renaming a channel in OpenGD77 breaks zone association
   - **Impact**: Medium (manual reassignment needed)
   - **Workaround**: Don't rename channels in OpenGD77, or reassign to zones after import

---

## 🔄 Rollback Instructions

If you encounter critical issues:

1. **Downgrade to v3.3.1**:
   - Install previous APK from GitHub releases
   - Reboot phone to reload module
   - **Note**: Zones will remain in new `_id` format (migration is one-way)

2. **Restore zones manually**:
   - Export channels to CSV before downgrade
   - After downgrade, clear zones and recreate manually
   - Or restore from a pre-v3.3.2 zone backup if available

---

## 📝 Feedback & Bug Reports

**Report issues at**: https://github.com/macdaddymack/phonedmrapp/issues

**Include**:
- LSPosed logs (filter for "DMR_MOD" or "ZoneDatabase")
- Steps to reproduce
- Number of channels and zones affected
- Whether you have duplicate `channel_number` values

---

## 🙏 Acknowledgments

This refactoring enables proper support for the radio's native capability to have duplicate channel numbers across zones. Special thanks to users who identified the limitation and tested the fix!
