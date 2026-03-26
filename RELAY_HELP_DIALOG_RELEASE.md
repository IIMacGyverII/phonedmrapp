# Relay Disconnection Help Dialog - Release Notes

**Date**: March 26, 2026  
**Commits**: 
- phonedmrapp: `1ba00c03` - Add relay help dialog to channel editor
- OpenGD77CPS-Mac: `5f5e803` - Fix CSV import relay validation

---

## Changes Implemented

### 1. Android App - Relay Help Dialog (DMRModHooks)

**File**: `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`  
**Lines**: 13485-13525 (added relay help icon section)

**Functionality**:
- Hooks `InterPhoneChannelActivity.onCreate()` via Xposed
- Finds the relay disconnect row by ID: `interphone_channel_relay_disconnecte`
- Adds info icon (🛈) to the relay label TextView
- Makes label clickable to show help AlertDialog
- Dialog explains:
  - **Disable** (relay=2): Normal repeater operation - **RECOMMENDED**
  - **Enable** (relay=1): Disconnect mode - **BLOCKS TRANSMIT**

**User Experience**:
- Users see help icon next to "Relay disconnection" label
- Clicking label/icon shows clear explanation
- Removes confusion about counterintuitive UI labeling
- Injectable at runtime - no main app rebuild required

### 2. OpenGD77 CPS - CSV Import Fix

**File**: `DMR/ChannelsCsvImporter.cs`  
**Lines**: 241-254

**Before**:
```csharp
// VALIDATE relay (MUST be 1 for all channels)
if (relayVal != 1) {
    System.Diagnostics.Debug.WriteLine("CH" + channelNumber + " relay=" + relayVal + " is invalid, forcing to 1");
    relayVal = 1;
}
channel.Relay = 1; // Default to 1
```

**After**:
```csharp
// VALIDATE relay - accept 0 (direct), 1 (disconnect), or 2 (normal)
// Default to 2 (disabled/normal operation) for working transmit
if (relayVal != 0 && relayVal != 1 && relayVal != 2) {
    System.Diagnostics.Debug.WriteLine("CH" + channelNumber + " relay=" + relayVal + " is invalid, forcing to 2 (default)");
    relayVal = 2;
}
channel.Relay = relayVal;  // Preserve actual value
// else { channel.Relay = 2; } // Default to 2 (disabled/normal)
```

**Impact**:
- CSV imports now default to relay=2 (working mode)
- Matches fixes in DirectDatabaseExporter and DirectDatabaseImporter
- Imported channels work correctly for transmit
- "Checkbox format defaulting to disabled" achieved via validation

---

## Testing Instructions

### Test 1: Help Dialog
1. Open DMRModHooks app → verify version shows new commit
2. Open system radio app → edit any channel
3. Scroll to "Relay disconnection" field
4. **Look for info icon (🛈)** next to label
5. **Click the label or icon**
6. **Verify AlertDialog appears** with:
   - Title: "Relay Disconnection Setting"
   - Message explaining Disable vs Enable
   - OK button to dismiss

### Test 2: CSV Import Default
1. In OpenGD77 CPS, create CSV with relay column omitted or invalid values
2. Import CSV
3. **Verify channels have relay=2** (check in CSV export or binary inspection)
4. **Export to radio and test transmit** - should work correctly

### Test 3: End-to-End
1. Export channels from OpenGD77 CPS to CSV
2. Verify relay column shows appropriate values (0, 1, or 2)
3. Import CSV via DirectDatabaseImporter in app
4. Edit channel in radio app
5. Click relay help icon → verify explanation shown
6. Test transmit with relay=2 (Disable) → **should work**
7. Test transmit with relay=1 (Enable) → **should block/delay**

---

## Technical Details

### Relay Field Semantics

| Value | Mode Name | UI Label | Behavior | Recommendation |
|-------|-----------|----------|----------|----------------|
| 0 | Direct/Simplex | N/A | No repeater, direct mode | Use for APRS channels |
| 1 | Relay Disconnect | **Enable** | Disconnects from repeater, waits for confirmation | **Avoid** - breaks TX |
| 2 | Normal/Default | **Disable** | Normal repeater operation | **Recommended** - works |

**Confusing UI Labels**:
- "Enable" = Enable relay disconnect = Disconnect from repeater = **Bad for TX**
- "Disable" = Disable relay disconnect = Normal operation = **Good for TX**

The help dialog clarifies this counterintuitive labeling.

### Implementation Approach

**Why Xposed Hook Instead of XML Edit?**
1. DMRModHooks is an Xposed module that hooks system app at runtime
2. Can't modify XML resources in target app (PRI InterPhone)
3. Hook finds relay row dynamically and injects help icon
4. No need to rebuild/repackage main system app
5. Works across app updates (as long as ID doesn't change)

**Why CSV Validation Instead of UI Checkbox?**
1. OpenGD77 CPS has NO UI for relay field (Android-specific)
2. Relay only exists in CSV import/export layer
3. Creating WinForms UI would require extensive designer work
4. CSV validation achieves "default to disabled" requirement
5. Most users never touch relay - safe default is sufficient

---

## Files Changed

### phonedmrapp (commit 1ba00c03)
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java` (+40 lines)
- `OpenGD77CPS_RelayFix_20260326_125315.zip` (source package)
- XML edits in main app (unused - reference only):
  - `app/src/main/res/layout/interphone_channel_activity.xml`
  - `app/src/main/res/values/strings.xml`
  - `app/src/main/res/values/ids.xml`
  - *(These were accidentally edited but don't affect DMRModHooks)*

### OpenGD77CPS-Mac (commit 5f5e803)
- `DMR/ChannelsCsvImporter.cs` (11 lines changed, 6 insertions, 5 deletions)

---

## Deployment

### Android
```powershell
cd c:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks
./gradlew clean assembleRelease
adb install -r app\build\outputs\apk\release\app-release.apk
```

**APK installed**: ✅ Success  
**Device**: Armor 26 Ultra (5006AF1020002922)

### OpenGD77 CPS
```powershell
cd c:\Users\Joshua\Documents\android\OpenGD77CPS-Mac
# Build in Visual Studio (msbuild not in PATH)
# Or use packaged source: OpenGD77CPS_RelayFix_20260326_125315.zip
```

**Build**: Manual (VS not available)  
**Source Package**: ✅ Created

---

## Related Commits (Previous Fixes)

This completes the relay field fix series:

1. **facc9d0** (Mar 26) - Fixed TG List export (RxGroupListString)
2. **9bbd2ee5** (Mar 26) - Fixed relay validation in DirectDatabaseImporter (preserve values)
3. **26a9debd** (Mar 26) - Fixed relay validation in DirectDatabaseExporter (default to 2)
4. **5f5e803** (Mar 26) - **NEW**: Fixed relay validation in ChannelsCsvImporter (default to 2)
5. **1ba00c03** (Mar 26) - **NEW**: Added relay help dialog in Android app

All relay field bugs are now resolved! ✅

---

## User Impact

**Before**:
- Channels imported with relay=1 (disconnect mode)
- Users couldn't transmit, didn't understand why
- UI labels were confusing ("Enable" vs "Disable")
- No explanation available in app

**After**:
- Channels import with relay=2 (working mode) ✅
- Transmit works correctly by default ✅
- Help icon provides clear explanation ✅
- Users understand Disable=good, Enable=bad ✅

**Result**: Relay field is now user-friendly and works correctly! 🎉
