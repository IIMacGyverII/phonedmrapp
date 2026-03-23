# OpenGD77 Export Analysis & Improvement Plan

## Summary
The current OpenGD77 CSV export in `DirectDatabaseExporter.java` is **hardcoding critical field values** instead of reading them from the database. This causes data loss when exporting and re-importing channels, breaking round-trip compatibility.

## Critical Issues Found

### 1. ❌ Hardcoded Fields (Lines 404-410 & 459-465)

The following fields are hardcoded and never read from the database:

| Field | Column | Hardcoded Value | Should Be |
|-------|--------|-----------------|-----------|
| **Rx Only** | 18 | `"No"` | From `channel_rxOnly` database field |
| **Zone Skip** | 19 | `"No"` | From `channel_zoneSkip` database field |
| **All Skip** | 20 | `"No"` | From `channel_allSkip` database field |
| **TOT (Time-Out Timer)** | 21 | `"0"` | From `channel_tot` database field (seconds) |
| **VOX** | 22 | `"Off"` | From `channel_vox` database field |
| **No Beep** | 23 | `"No"` | From `channel_noBeep` database field |
| **No Eco** | 24 | `"No"` | From `channel_noEco` database field |

### 2. Current Export Code Pattern
```java
// Lines 404-410 (Digital channels)
rowBuilder.append("No,");              // 18. Rx Only (HARDCODED)
rowBuilder.append("No,");              // 19. Zone Skip (HARDCODED)
rowBuilder.append("No,");              // 20. All Skip (HARDCODED)
rowBuilder.append("0,");               // 21. TOT (HARDCODED)
rowBuilder.append("Off,");             // 22. VOX (HARDCODED)
rowBuilder.append("No,");              // 23. No Beep (HARDCODED)
rowBuilder.append("No,");              // 24. No Eco (HARDCODED)

// Same pattern repeats for Analog channels at lines 459-465
```

### 3. What Happens on Round-Trip Export/Import

**Export flow:**
```
Database (with real values) → CSV with hardcoded "No"/"Off"/"0" → Exported file
```

**Import flow:**
```
CSV file with hardcoded values → Import code parses "No"/"Off"/"0" → Database
```

**Result:** All 7 fields are reset to their "default" values on round-trip!

### 4. Missing Database Query Logic

Currently, the export code for Digital channels query:
- ✅ Color Code (`channel_cc`)
- ✅ Timeslot (`channel_inBoundSlot`)
- ✅ Contact (`channel_txContact`)
- ✅ RX/TX Tone (`channel_rxType`, `channel_txType`, `channel_rxSubCode`, `channel_txSubCode`)
- ✅ Squelch (`channel_sq`)
- ✅ Power (`channel_power`)
- ✅ APRS Setting (from `APRSDatabase`)
- ✅ Location (from `LocationDatabase`)
- ✅ Encrypt fields (`channel_encryptSw`, `channel_encryptKey`)
- ✅ Relay, Interrupt, Active, etc.

**Missing queries:**
- ❌ `channel_rxOnly`
- ❌ `channel_zoneSkip`
- ❌ `channel_allSkip`
- ❌ `channel_tot`
- ❌ `channel_vox`
- ❌ `channel_noBeep`
- ❌ `channel_noEco`

### 5. Field Definitions & Types

Based on OpenGD77 CPS CSV format and database patterns:

```
Field                Type           Range            Default    Description
==================================================================================
Rx Only              Yes/No         Yes|No           No         Cannot transmit on this channel
Zone Skip            Yes/No         Yes|No           No         Skip channel in zone scan
All Skip             Yes/No         Yes|No           No         Skip channel in all channel scan
TOT (seconds)        Integer        0-999            0          Max transmit time before auto-stop
VOX                  On/Off         On|Off           Off        Voice-activated transmit
No Beep              Yes/No         Yes|No           No         Disable beep on key
No Eco              Yes/No         Yes|No           No         Disable echo/repeater feedback
```

## Import Code Status

The import code in `DirectDatabaseImporter.java` **does NOT parse these fields** at all:
- Lines 400-650+ only handle the first 28 fields (or 37 with new encryption fields)
- Fields 18-24 (Rx Only through No Eco) are completely ignored during import
- This is acceptable since export currently doesn't write real data anyway

**However**, once export is fixed to include real values, import code MUST be updated to parse them!

## Recommended Fixes

### Phase 1: Export Code Improvement (DirectDatabaseExporter.java)

**For Digital channels (around line 404):**
```java
// BEFORE: Hardcoded values
rowBuilder.append("No,");              // 18. Rx Only
rowBuilder.append("No,");              // 19. Zone Skip
rowBuilder.append("No,");              // 20. All Skip
rowBuilder.append("0,");               // 21. TOT
rowBuilder.append("Off,");             // 22. VOX
rowBuilder.append("No,");              // 23. No Beep
rowBuilder.append("No,");              // 24. No Eco

// AFTER: Read from database
int rxOnly = cursor.getInt(cursor.getColumnIndex("channel_rxOnly"));
int zoneSkip = cursor.getInt(cursor.getColumnIndex("channel_zoneSkip"));
int allSkip = cursor.getInt(cursor.getColumnIndex("channel_allSkip"));
int tot = cursor.getInt(cursor.getColumnIndex("channel_tot"));
int vox = cursor.getInt(cursor.getColumnIndex("channel_vox"));
int noBeep = cursor.getInt(cursor.getColumnIndex("channel_noBeep"));
int noEco = cursor.getInt(cursor.getColumnIndex("channel_noEco"));

rowBuilder.append(rxOnly == 1 ? "Yes" : "No").append(",");        // 18. Rx Only
rowBuilder.append(zoneSkip == 1 ? "Yes" : "No").append(",");      // 19. Zone Skip
rowBuilder.append(allSkip == 1 ? "Yes" : "No").append(",");       // 20. All Skip
rowBuilder.append(tot).append(",");                                 // 21. TOT (seconds)
rowBuilder.append(vox == 1 ? "On" : "Off").append(",");           // 22. VOX
rowBuilder.append(noBeep == 1 ? "Yes" : "No").append(",");        // 23. No Beep
rowBuilder.append(noEco == 1 ? "Yes" : "No").append(",");         // 24. No Eco
```

**Same changes for Analog channels (around line 459)**

### Phase 2: Import Code Enhancement (DirectDatabaseImporter.java)

Once export is fixed, update import to parse these fields:

```java
// After parsing power field (line ~550), add:
try {
    String rxOnlyStr = (fields.length > offset + 17) ? fields[offset + 17].trim() : "No";
    values.put("channel_rxOnly", rxOnlyStr.equalsIgnoreCase("Yes") ? 1 : 0);
    
    String zoneSkipStr = (fields.length > offset + 18) ? fields[offset + 18].trim() : "No";
    values.put("channel_zoneSkip", zoneSkipStr.equalsIgnoreCase("Yes") ? 1 : 0);
    
    String allSkipStr = (fields.length > offset + 19) ? fields[offset + 19].trim() : "No";
    values.put("channel_allSkip", allSkipStr.equalsIgnoreCase("Yes") ? 1 : 0);
    
    String totStr = (fields.length > offset + 20) ? fields[offset + 20].trim() : "0";
    int tot = totStr.isEmpty() ? 0 : Integer.parseInt(totStr);
    values.put("channel_tot", tot);
    
    String voxStr = (fields.length > offset + 21) ? fields[offset + 21].trim() : "Off";
    values.put("channel_vox", voxStr.equalsIgnoreCase("On") ? 1 : 0);
    
    String noBeepStr = (fields.length > offset + 22) ? fields[offset + 22].trim() : "No";
    values.put("channel_noBeep", noBeepStr.equalsIgnoreCase("Yes") ? 1 : 0);
    
    String noEcoStr = (fields.length > offset + 23) ? fields[offset + 23].trim() : "No";
    values.put("channel_noEco", noEcoStr.equalsIgnoreCase("Yes") ? 1 : 0);
} catch (Exception e) {
    Log.w(TAG, "Error parsing Rx Only/Zone Skip/All Skip/TOT/VOX/No Beep/No Eco: " + e.getMessage());
    // Use safe defaults - these are safe if import fails
}
```

## Testing Strategy

### Export Test
1. Create channels with various combinations of these flags
2. Export to CSV
3. Verify CSV contains actual values (not hardcoded)
4. Sample export line should look like:
   ```
   1,Test Ch,Digital,145.750,145.750,12.5,1,1,Repeater,Local,1234567,,,,None,None,5,P9,No,Yes,No,30,On,Yes,No,None,0.128,0.008,No,0,,1,2,1,0,0,...
   ```

### Import Test
1. Export working channels
2. Import them back
3. Verify all 7 fields are preserved
4. Test round-trip multiple times

### Round-Trip Test
```
Create Ch → Export → Modify CSV values → Import → Verify Ch → Export → Verify CSV values match
```

## Field Mapping Reference

### Database Columns Used
The database should have these Integer columns (usually 0=false, 1=true):
- `channel_rxOnly` - RX only flag
- `channel_zoneSkip` - Zone scan skip
- `channel_allSkip` - All channel scan skip
- `channel_tot` - Time-out timer (0-999 seconds)
- `channel_vox` - VOX (voice-activated) flag
- `channel_noBeep` - Suppress beep flag
- `channel_noEco` - Suppress echo/feedback flag

### OpenGD77 CSV Format
Field 18-24 should match:
- Rx Only: Yes/No
- Zone Skip: Yes/No
- All Skip: Yes/No
- TOT: 0-999 (or blank for 0)
- VOX: On/Off
- No Beep: Yes/No
- No Eco: Yes/No

## Benefits of Fix

✅ **Data Preservation**: No more data loss on round-trip export/import  
✅ **Full Compatibility**: Complete OpenGD77 CPS feature support  
✅ **User Control**: Users can configure all channel flags in app and export them  
✅ **Accurate Backups**: CSV backups contain complete channel configuration  
✅ **Cross-Platform**: Edit in CPS, import, export, edit in CPS again - seamless

## Files to Modify

1. **DirectDatabaseExporter.java** - Main fix for exporting real values
2. **DirectDatabaseImporter.java** - Enhancement to import these fields
3. **DirectDatabaseExporter.java** - Update CHANNELS_HEADER (if needed)

## Backward Compatibility

The fixes maintain backward compatibility:
- Older CSV files without these fields will use safe defaults during import (all 0/false)
- Export always includes these fields in the header
- Import gracefully handles missing fields with try-catch and defaults

## Status

- ❌ Export code: BROKEN (hardcoded values)
- ❌ Import code: NOT IMPLEMENTED
- ⏳ Recommended: HIGH PRIORITY for data integrity
