# Phase 2 Implementation Plan: OpenGD77 CSV Export/Import

**Status**: 📋 PLANNING  
**Target**: Add backup/restore functionality with OpenGD77 CPS compatibility  
**Date**: February 19, 2026

---

## Overview

Add CSV export/import for Channels and Contacts using the exact OpenGD77 CPS format for compatibility with the open-source DMR ecosystem (opengd77.com).

---

## Database Schema Analysis (From Source Code)

### Channels Database
**Helper**: `DBChannelHelper`  
**Table**: `database_[type]` or `channel`  
**Utility**: `UtilChannelData.java`

**Fields**:
```java
_id INTEGER PRIMARY KEY
channel_name VARCHAR
channel_type INTEGER (0=Digital, 1=Analog)
channel_number INTEGER
channel_txFreq INTEGER (Hz, e.g. 401025000)
channel_rxFreq INTEGER (Hz)
channel_power INTEGER (0=Low, 1=High)
channel_cc INTEGER (Color Code 0-15)
channel_inBoundSlot INTEGER (0 or 1 for TS1/TS2)
channel_outBoundSlot INTEGER
channel_mode INTEGER
channel_contactType INTEGER (0=Person, 1=Group, 2=All)
channel_txContact INTEGER (Contact ID)
channel_encryptSw INTEGER
channel_encryptKey VARCHAR
channel_relay INTEGER
channel_interrupt INTEGER
channel_band INTEGER
channel_sq INTEGER (Squelch)
channel_rxType INTEGER
channel_rxSubCode INTEGER
channel_txType INTEGER
channel_txSubCode INTEGER
channel_active INTEGER (1=active)
channel_groups VARCHAR (comma-separated array)
```

### Contacts Database
**Helper**: `DBContactHelper`  
**Table**: `contact`  
**Utility**: `UtilContactsData.java`

**Fields**:
```java
_id INTEGER PRIMARY KEY
contact_name VARCHAR
contact_number VARCHAR (DMR ID as string)
contact_type INTEGER (0=Person/Private, 1=Group)
contact_active INTEGER
contact_icon VARCHAR (Base64 encoded bitmap)
```

---

## OpenGD77 CSV Format Specification

### Channels.csv (24 columns - EXACT HEADER REQUIRED)
```csv
Channel Number,Channel Name,Channel Type,Rx Frequency,Tx Frequency,Bandwidth kHz,Colour Code,Timeslot,Contact,TG List,DMR ID,TS1_TA_Tx,TS2_TA_Tx,RX Tone,TX Tone,Squelch,Power,Rx Only,Zone Skip,All Skip,TOT,VOX,Ch Scan List,Rx Group List,TX
```

**Column Mapping** (PriInterPhone → OpenGD77):
```
1. Channel Number:     channel_number + 1 (1-based indexing)
2. Channel Name:       channel_name
3. Channel Type:       "Digital" | "Analogue" (channel_type: 0="Digital", 1="Analogue")
4. Rx Frequency:       channel_rxFreq / 1000000 (convert Hz to MHz with 5 decimal places)
5. Tx Frequency:       channel_txFreq / 1000000
6. Bandwidth kHz:      "12.5" | "25" | "" (blank for digital, based on channel_type)
7. Colour Code:        channel_cc (0-15, blank for analogue)
8. Timeslot:           channel_inBoundSlot + 1 (1 or 2, blank for analogue)
9. Contact:            Lookup contact name by channel_txContact ID, or "None"
10. TG List:           "None" (future: parse channel_groups for TG Lists)
11. DMR ID:            "None" (can add custom ID override if needed)
12. TS1_TA_Tx:         "Off" | "APRS" | "Text" | "APRS+Text" (default "Off", blank for analogue)
13. TS2_TA_Tx:         Same as TS1_TA_Tx
14-24:                 Remaining columns - use sensible defaults or blank
```

### Contacts.csv (4 columns - EXACT HEADER REQUIRED)
```csv
Contact Name,ID,ID Type,TS Override
```

**Column Mapping** (PriInterPhone → OpenGD77):
```
1. Contact Name:  contact_name
2. ID:            contact_number (DMR ID as integer)
3. ID Type:       "Group" | "Private" (contact_type: 0="Private", 1="Group")
4. TS Override:   "Disabled" (can add logic for timeslot override if needed)
```

---

## Implementation Architecture

### 1. BackupActivity.java
**Purpose**: Full-screen activity for backup/restore operations  
**Package**: `com.dmrmod.hooks`  
**Layout**: `activity_backup.xml`

**Features**:
- Export Channels & Contacts to CSV
- Import from CSV (with validation)
- File picker integration  
- Progress indication
- Error handling & user feedback
- Permission management (WRITE_EXTERNAL_STORAGE)

**Methods**:
```java
void exportToCSV()              // Export both Channels.csv and Contacts.csv
void importFromCSV()            // Import and validate CSV files
void pickCSVFiles()             // File picker for import
void validateCSVHeaders()       // Ensure OpenGD77 format compliance
void writeChannelsCSV()         // Generate Channels.csv from database
void writeContactsCSV()         // Generate Contacts.csv from database
void importChannelsCSV()        // Parse and insert channels
void importContactsCSV()        // Parse and insert contacts
ArrayList<ChannelData> readChannelsFromDB()    // Query all channels
ArrayList<ContactData> readContactsFromDB()    // Query all contacts
String convertFreqToMHz()       // Hz to MHz converter (401025000 → 401.02500)
String getContactNameById()     // Lookup contact by ID
```

### 2. Updated MainHook.java
**Changes**:
- Add `hookSettingsActivity()` method
- Hook `FragmentLocalSettingsActivity.onCreate()`
- Dynamically add "Export/Import Backup" button above "Exit App" button
- Launch `BackupActivity` on button click

**Hook Point**:
```java
Class: com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity
Method: onCreate(Bundle)
Action: After method, add button to layout
```

### 3. CSV Utilities (CSVHelper.java)
**Purpose**: CSV read/write without external libraries  
**Package**: `com.dmrmod.hooks.util`

**Methods**:
```java
void writeCSV(String filePath, String[] headers, List<String[]> rows)
List<String[]> readCSV(String filePath)
String quote(String field)          // Escape commas and quotes
String[] parseLine(String line)     // Manual CSV parsing
```

### 4. Database Access (DBHelper.java)
**Purpose**: Access PriInterPhone databases via reflection  
**Package**: `com.dmrmod.hooks.util`

**Methods**:
```java
ArrayList<ChannelData> getAllChannels(Context targetContext)
ArrayList<ContactData> getAllContacts(Context targetContext)
void insertChannel(Context targetContext, ChannelData channel)
void insertContact(Context targetContext, ContactData contact)
void clearAllChannels()             // For full import
void clearAllContacts()
```

**Reflection Strategy**:
```java
// Access target app's database helpers via reflection
Class<?> utilChannelClass = targetContext.getClassLoader()
    .loadClass("com.pri.prizeinterphone.serial.data.UtilChannelData");
Object utilChannelInstance = utilChannelClass.getConstructor(Context.class)
    .newInstance(targetContext);
Method getAllChannels = utilChannelClass.getMethod("getAllChannels");
ArrayList<?> channels = (ArrayList<?>) getAllChannels.invoke(utilChannelInstance);
```

### 5. Layout XML (activity_backup.xml)
**Location**: `DMRModHooks/app/src/main/res/layout/activity_backup.xml`

**UI Elements**:
```xml
<LinearLayout vertical>
    <TextView id="@+id/tv_instructions" />  <!-- Instructions text -->
    <Button id="@+id/btn_export" text="Export Channels & Contacts" />
    <Button id="@+id/btn_import" text="Import from CSV" />
    <Button id="@+id/btn_browse" text="Browse Files" />
    <TextView id="@+id/tv_status" />  <!-- Status messages -->
    <ScrollView>
        <TextView id="@+id/tv_log" />  <!-- Detailed log -->
    </ScrollView>
    <Button id="@+id/btn_close" text="Close" />
</LinearLayout>
```

---

## File Locations

### Export Path
```
/sdcard/Download/DMR_Backups/
├── Channels.csv
├── Contacts.csv
├── TG_Lists.csv (future)
└── Zones.csv (future)
```

**Alternative (Scoped Storage for Android 10+)**:
```
/sdcard/Documents/DMR_Backups/
```

---

## Implementation Steps (Sequenced)

**Step 1**: ✅ Review and approve this plan

**Step 2**: Create BackupActivity.java
- Basic activity structure
- Layout inflation
- Button click handlers (stubs)

**Step 3**: Create activity_backup.xml layout
- Design UI with instructions
- Add all buttons and status views

**Step 4**: Implement CSV export logic
- Query channels from database (via reflection)
- Query contacts from database
- Convert to OpenGD77 format
- Write Channels.csv and Contacts.csv

**Step 5**: Implement CSV import logic
- File picker integration
- CSV parsing (manual, no external libs)
- Header validation
- Data insertion into database

**Step 6**: Update MainHook.java
- Add settings activity hook
- Implement button injection logic
- Handle BackupActivity launch

**Step 7**: Add AndroidManifest.xml entry
- Register BackupActivity
- Add storage permissions

**Step 8**: Handle permissions
- Runtime permission requests (Android 6+)
- Scoped storage handling (Android 10+)

**Step 9**: Testing
- Export test: Verify CSV format
- Import test: Parse and validate
- OpenGD77 compatibility: Import CSV into OpenGD77 CPS

**Step 10**: Error handling
- Database access errors
- File I/O errors
- Permission denials
- Invalid CSV format

**Step 11**: Polish
- Progress indicators
- User feedback (toasts, status text)
- Logging for debugging

---

## Data Mapping Example

### Example Channel (Database → CSV)

**Database Record**:
```
_id: 1
channel_name: "Local Repeater"
channel_type: 0 (Digital)
channel_number: 0
channel_txFreq: 446025000 (Hz)
channel_rxFreq: 446025000
channel_cc: 1
channel_inBoundSlot: 1 (TS2)
channel_txContact: 5
channel_power: 1 (High)
```

**CSV Output** (Channels.csv row):
```csv
1,Local Repeater,Digital,446.02500,446.02500,,1,2,Contact Name (ID 5),None,None,Off,Off,,,Low,,,All,All,60,,None,None,
```

### Example Contact (Database → CSV)

**Database Record**:
```
_id: 5
contact_name: "TAC 1"
contact_number: "9"
contact_type: 1 (Group)
```

**CSV Output** (Contacts.csv row):
```csv
TAC 1,9,Group,Disabled
```

---

## Permissions Required

**AndroidManifest.xml additions**:
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<!-- Android 10+ scoped storage (optional) -->
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" 
                 tools:ignore="ScopedStorage" />

<application>
    <activity
        android:name=".BackupActivity"
        android:label="DMR Backup &amp; Restore"
        android:exported="true"
        android:theme="@android:style/Theme.Material.Light" />
</application>
```

**Runtime Permission Request** (in BackupActivity):
```java
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
    if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) 
        != PackageManager.PERMISSION_GRANTED) {
        requestPermissions(
            new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 
            REQUEST_CODE_STORAGE
        );
    }
}
```

---

## Known Challenges & Solutions

### Challenge 1: Accessing Target App's Database from LSPosed Module
**Problem**: BackupActivity runs in module's process, not target app's process  
**Solution**: 
- Option A: Use hooks to call target app's UtilChannelData/UtilContactsData methods via reflection
- Option B: Direct SQLite access using target app's database file path
- **Recommended**: Option B for simplicity

```java
// Get target app's database path
String dbPath = "/data/data/com.pri.prizeinterphone/databases/channel.db";
SQLiteDatabase db = SQLiteDatabase.openDatabase(dbPath, null, SQLiteDatabase.OPEN_READONLY);
```

### Challenge 2: Frequency Conversion (Hz to MHz)
**Problem**: Database stores frequencies in Hz (401025000), OpenGD77 uses MHz (401.02500)  
**Solution**:
```java
public static String convertFreqToMHz(int freqHz) {
    double freqMHz = freq Hz / 1000000.0;
    return String.format(Locale.US, "%.5f", freqMHz);
}
```

### Challenge 3: Contact Name Lookup for Channels
**Problem**: Channels store `channel_txContact` as integer ID, CSV needs contact name  
**Solution**: Build contact ID→name map first, then lookup during export

### Challenge 4: CSV Parsing Without External Libraries
**Problem**: No commons-csv, opencsv available in LSPosed module  
**Solution**: Manual parsing with quote handling
```java
private String[] parseCSVLine(String line) {
    List<String> fields = new ArrayList<>();
    StringBuilder current = new StringBuilder();
    boolean inQuotes = false;
    
    for (int i = 0; i < line.length(); i++) {
        char c = line.charAt(i);
        if (c == '"') {
            if (i + 1 < line.length() && line.charAt(i + 1) == '"') {
                current.append('"');
                i++;
            } else {
                inQuotes = !inQuotes;
            }
        } else if (c == ',' && !inQuotes) {
            fields.add(current.toString());
            current = new StringBuilder();
        } else {
            current.append(c);
        }
    }
    fields.add(current.toString());
    return fields.toArray(new String[0]);
}
```

---

## Testing Plan

### Export Testing
1. Verify Channels.csv has exactly 24 columns
2. Verify Contacts.csv has exactly 4 columns
3. Check frequency conversion accuracy
4. Validate contact name lookups
5. Test empty database export
6. Test large database (500+ channels)

### Import Testing
1. Import OpenGD77 sample CSV
2. Verify database contains imported data
3. Test invalid CSV (wrong format)
4. Test duplicate handling
5. Test partial import (only channels or only contacts)

### OpenGD77 Compatibility Testing
1. Export from PriInterPhone
2. Import CSV into OpenGD77 CPS
3. Verify channels display correctly
4. Verify contacts display correctly
5. Export from OpenGD77 CPS
6. Import into PriInterPhone
7. Round-trip test (export → import → export → compare)

---

## Future Enhancements (Out of Scope for v1)

1. **TG Lists (Talkgroups)**:  
   - Parse `channel_groups` field
   - Generate `TG_Lists.csv` with group IDs

2. **Zones**:
   - Group channels into zones
   - Generate `Zones.csv`

3. **Advanced Settings**:
   - APRS settings (TS1_TA_Tx, TS2_TA_Tx)
   - RX Only, Zone Skip, TOT settings
   - Scan lists

4. **UI Improvements**:
   - Progress bar for large imports
   - Preview before import  
   - Conflict resolution UI

5. **Cloud Backup**:
   - Upload to Google Drive
   - Share via email/messaging

---

## Approval Checklist

Before proceeding with implementation:

- [ ] OpenGD77 CSV format verified (24 columns for Channels, 4 for Contacts)
- [ ] Database schema mapping confirmed
- [ ] File storage location approved (/sdcard/Download/DMR_Backups/)
- [ ] Implementation sequence acceptable
- [ ] UI design (button placement, BackupActivity layout) approved
- [ ] Permission strategy confirmed
- [ ] Testing plan comprehensive

---

**Once approved, I'll begin step-by-step implementation starting with BackupActivity.java.**
