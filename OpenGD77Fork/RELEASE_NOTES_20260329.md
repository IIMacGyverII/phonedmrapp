# OpenGD77 CPS Mac - Build 20260329_093327

## Release Date
March 29, 2026

## Critical Bug Fixes

### 1. ✅ FIXED: Relay Field Export (Column 31)
**Problem**: When exporting channels to CSV, the Relay field could contain value `0` (invalid for Android firmware). Android radio firmware rejects channels with `relay=0`, causing "operation failed" errors when trying to activate channels.

**Root Cause**: 
- OpenGD77 checkbox unchecked (relay disconnect disabled) sets internal value to 0
- CSV export was writing this raw value without validation
- Android firmware interprets: 0=APRS/direct (invalid), 1=relay disconnect ON, 2=normal mode

**Fix**: Added validation in `ChannelsForm.cs` line ~1236:
```csharp
// Column 31: Relay
// FIX: Relay value 0 is invalid for Android firmware (causes "operation failed")
// Convert 0 (unchecked) to 2 (normal mode) for proper firmware operation
// Valid values: 1 = relay disconnect ON, 2 = relay disconnect OFF (normal)
int relayValue = (channelOne.Relay == 0) ? 2 : channelOne.Relay;
csvRow.Add(relayValue.ToString());
```

**Impact**: All channels now export with valid relay values, preventing activation failures.

---

### 2. ✅ FIXED: Outbound Slot Field Export (Column 34)
**Problem**: Outbound Slot was being exported as 1-based (1-2) when Android firmware expects 0-based (0-1).

**Root Cause**:
- UI stores OutboundSlot as 1-based to match user-facing "Slot 1" / "Slot 2" terminology
- CSV export was writing the internal value directly
- Android importer saw out-of-range values (1-2) and forced them to 0

**Fix**: Added conversion in `ChannelsForm.cs` line ~1247:
```csharp
// Column 34: Outbound Slot
// FIX: UI stores as 1-based (1-2), but CSV/Android expects 0-based (0-1)
// Convert 1→0 (Slot 1), 2→1 (Slot 2) for CSV export
int outboundSlotValue = Math.Max(0, channelOne.OutboundSlot - 1);
csvRow.Add(outboundSlotValue.ToString());
```

**Impact**: Digital channels now export with correct timeslot values.

---

## Other Fields Verified ✅
All other Android-specific fields were checked and confirmed correct:
- **Encrypt Switch** (Column 29): Already forces to 0 (disabled) - correct
- **Interrupt** (Column 32): Valid range 0-2 
- **Active** (Column 33): Valid range 0-1
- **Channel Mode** (Column 35): Outputs 0 or 3 (valid)
- **Contact Type** (Column 36): Valid range 0-3

---

## Testing Recommendations

1. **Export test**: Export existing codeplug to CSV, verify Relay values are 1 or 2 (not 0)
2. **Import test**: Import CSV to Android app, activate multiple channels - should work without "operation failed"
3. **Round-trip test**: Android → Export → OpenGD77 CPS → Edit → Export → Android → Test activation

---

## Files Modified
- `DMR/ChannelsForm.cs` (2 fixes)

## Build Info
- **MSBuild**: .NET Framework 4.8
- **Configuration**: Release
- **Output**: `bin/ReleaseOpenGD77/OpenGD77CPS.exe`
- **Package**: `OpenGD77CPS-Mac_Build_20260329_093327.zip`

---

## Installation
1. Extract `OpenGD77CPS-Mac_Build_20260329_093327.zip`
2. Run `OpenGD77CPS.exe`
3. Export your codeplug to CSV
4. Import to Android radio app - channels should now activate successfully!

---

## Related Android App Fix
The Android app import module (`DirectDatabaseImporter.java`) was also updated to handle relay=0 values by converting them to relay=2 during import. This provides defense-in-depth: both the CPS export AND the Android import now handle this edge case correctly.
