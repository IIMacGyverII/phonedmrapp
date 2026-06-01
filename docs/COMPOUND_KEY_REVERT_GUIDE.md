# Compound Key Zone Matching - Revert Instructions

## Overview
This feature uses compound keys (`channelNum|frequency|name`) for zone matching to fix zone scrambling when importing channels with duplicate channel numbers.

## Feature Flag Location

**Enable/Disable in TWO files** (must match):

### File 1: DirectDatabaseImporter.java (Line ~68)
```java
private static final boolean USE_COMPOUND_KEY_ZONES = true;  // ← Change to false to disable
```

### File 2: DirectDatabaseExporter.java (Line ~48)
```java
private static final boolean USE_COMPOUND_KEY_ZONES = true;  // ← Change to false to disable
```

## How To Revert

### Quick Revert (Simple Name-Only Matching)
1. Open `DirectDatabaseExporter.java`
2. Change `USE_COMPOUND_KEY_ZONES = true` to `USE_COMPOUND_KEY_ZONES = false`
3. Open `DirectDatabaseImporter.java`
4. Change `USE_COMPOUND_KEY_ZONES = true` to `USE_COMPOUND_KEY_ZONES = false`
5. Rebuild and install APK

**Result**: Exports and imports will use simple channel names (OpenGD77 compatible) but zones may scramble if you have duplicate channel numbers.

### Full Removal (Delete Compound Key Code)
If you want to completely remove the compound key code:

1. Delete these methods from `DirectDatabaseImporter.java`:
   - `buildChannelCompoundKeyMap()` (lines ~989-1040)
   
2. Delete these methods from `DirectDatabaseExporter.java`:
   - `buildChannelIdCompoundKeyMap()` (lines ~709-765)
   
3. Simplify zone import logic in `DirectDatabaseImporter.java` (lines ~905-940):
   - Remove compound key map initialization
   - Remove compound key lookup attempt
   - Keep only name-only lookup
   
4. Simplify zone export logic in `DirectDatabaseExporter.java` (lines ~590-600):
   - Remove conditional channelMap assignment
   - Use only `buildChannelIdMap(context)`

5. Remove feature flag constants from both files

6. Rebuild and install APK

## Testing After Revert

1. Export your current config → should generate name-only Zones.csv
2. Import the export → zones should still work (but may scramble on future imports with duplicate channel_numbers)
3. Test OpenGD77 round-trip → should work perfectly with name-only format

## What Changes With Each Mode

### Compound Key Enabled (Current)
- **Export Zones.csv format**: `"1|446.00625|N1CJ: CARLA 31 Sunset Ridge"`
- **Import behavior**: Tries compound key first, falls back to name
- **OpenGD77 compatibility**: ❌ Zones won't work in OpenGD77 (it doesn't understand compound keys)
- **Zone preservation**: ✅ Perfect - zones stay correct even with duplicate channel numbers

### Compound Key Disabled (Reverted)
- **Export Zones.csv format**: `"N1CJ: CARLA 31 Sunset Ridge"`
- **Import behavior**: Name-only lookup
- **OpenGD77 compatibility**: ✅ Full compatibility
- **Zone preservation**: ⚠️ Zones may scramble if channels have duplicate names or import in different order

## Recommendation

If you need OpenGD77 compatibility, consider:
- Keep compound keys disabled for now
- Use OpenGD77 as primary editor
- Only enable compound keys for app-internal backups
- OR: Add separate export buttons for each format

## Code Locations

All compound key code is marked with comments:
```java
// === COMPOUND KEY ZONE MATCHING FEATURE FLAG ===
```

Search for "COMPOUND KEY" or "USE_COMPOUND_KEY_ZONES" to find all related code.
