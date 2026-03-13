# APRS Cleanup & RX Improvement Plan

## Phase 1: Remove APRS TX Code ❌

### Files to Modify

#### 1. APRSBeacon.java
**Remove these methods (Lines 285-1225):**
- [ ] `generateAndTransmitAPRS()` (lines 285-330)
- [ ] `transmitViaAudioRecordHook()` (lines 333-485)
- [ ] `transmitViaAudioWithPTT()` (lines 487-566)
- [ ] `transmitViaPrizePcmManager()` (lines 649-781)
- [ ] `transmitViaPrizePcmManagerInjection()` (lines 870-983)
- [ ] `transmitViaAudioTrack()` (lines 1149-1225)
- [ ] `amplifyAudio()` helper (lines 1037-1051)

**Remove these fields (Lines 38-44):**
```java
// APRS transmission state (for AudioRecord hook)
public static volatile byte[] aprsAudioBuffer = null;
public static volatile int aprsAudioPosition = 0;
public static volatile boolean isTransmittingAPRS = false;
```

**Remove these methods used by TX:**
- [ ] `injectAPRSAudio()` - AudioRecord hook injection
- [ ] `isTransmittingAPRS()` - State check

**Keep these (used for reference/testing):**
- [x] `generateAPRSPacket()` - AX.25 packet generation
- [x] `sendTestBeacon()` - Can be kept for external TNC support later
- [x] All frequency management code

#### 2. MainHook.java
**Remove AudioRecord hook (Lines 4621-4668):**
```java
private void hookAudioRecordForAPRS(XC_LoadPackage.LoadPackageParam lpparam) {
    // Entire method - was for APRS TX injection
}
```

**Remove hook initialization (Lines 212-213):**
```java
// Hook AudioRecord.read() for APRS audio injection
hookAudioRecordForAPRS(lpparam);
```

**Keep:**
- [x] All other hooks (PCM receive, APRS RX, etc.)
- [x] APRS settings UI hooks
- [x] Frequency management

#### 3. AFSKGenerator.java
**Decision: Keep entire file for reference**
- AFSK generation is mathematically perfect
- Useful for testing/validation
- Could be used with external TNC in future
- Add comment at top: "Reference implementation only - use with external TNC"

#### 4. APRS Settings UI
**Remove from layout:**
- [ ] "Transmit Test" button (if exists)
- [ ] TX power settings (if exists)
- [ ] TX path settings (if exists)

**Keep:**
- [x] Frequency field (144.390 MHz) - used for RX
- [x] Callsign field
- [x] Station info field
- [x] Beacon interval (for future external TNC)
- [x] Map display
- [x] Received packets list

**Add:**
- [ ] Note: "APRS Receive Only (TX requires external TNC)"
- [ ] Link to documentation about external TNC options

---

## Phase 2: Improve APRS RX ✅

### Current RX Status
**What works perfectly:**
- ✅ Audio capture from radio PCM
- ✅ AFSK demodulation (IQ method)
- ✅ AX.25 packet decoding
- ✅ Callsign extraction
- ✅ Position parsing
- ✅ Basic display

### Improvement Areas

#### A. Enhanced Packet Display

**Current:**
- Shows raw packet data
- Basic list view
- No formatting

**Improvements:**
1. **Better UI Layout**
   ```java
   // Packet item should show:
   - Callsign (large, bold)
   - Timestamp (relative: "2 min ago")
   - Position (if available): "12.5 mi NE"
   - Comment/status
   - Signal strength indicator (from audio level)
   - Icon based on packet type (car, house, balloon, etc.)
   ```

2. **Color Coding**
   - Weather stations: Blue
   - Mobile stations: Green
   - Fixed stations: Gray
   - Emergency beacons: Red
   - Digipeaters: Orange

3. **Packet Details View**
   - Tap packet to see full details
   - Show path (via digipeaters)
   - Show all telemetry
   - Show raw AX.25 if available

#### B. Map Integration Enhancement

**Current:**
- Basic map display (if implemented)
- Shows positions

**Improvements:**
1. **Real-time Updates**
   - Smooth marker animation
   - Trail/history for mobile stations
   - Auto-pan to newest station
   - Zoom controls

2. **Station Symbols**
   - Use APRS symbol table
   - Show proper icons (car, house, balloon, etc.)
   - Indicate direction of travel (if in packet)

3. **Range/Distance**
   - Show distance from own position (GPS)
   - Circle showing radio range estimate
   - Directional indicator ("12 mi NE")

4. **Clustering**
   - Cluster nearby stations when zoomed out
   - Show count in cluster
   - Expand on tap

#### C. Notifications

**Current:**
- Unknown/basic

**Improvements:**
1. **Smart Notifications**
   - New station heard (once per station)
   - Weather alerts (if wx packet)
   - Emergency beacons (priority notification)
   - Configurable filters

2. **Sound Alerts**
   - Different tones for different packet types
   - Volume control
   - Quiet hours

3. **Notification Content**
   - Show callsign and distance
   - Quick action: "View on Map"
   - Expandable detail view

#### D. Station Database

**Current:**
- Packets shown but not stored persistently

**Improvements:**
1. **Station History**
   ```java
   Station {
       String callsign;
       List<Position> positionHistory;
       long firstHeard;
       long lastHeard;
       int packetCount;
       String lastComment;
       double maxDistance;
   }
   ```

2. **Station List View**
   - Sortable (by callsign, distance, time)
   - Searchable
   - Filter by type
   - Show "last heard" time
   - Show packet count

3. **Station Detail**
   - Full packet history
   - Position history on map
   - Statistics (avg position, range)
   - Export to file

#### E. Weather Station Support

**Current:**
- Basic parsing (if implemented)

**Improvements:**
1. **Weather Display**
   - Temperature, pressure, humidity
   - Wind speed/direction
   - Rain data
   - Pretty icons and graphs

2. **Weather Stations List**
   - Separate tab/filter
   - Show current conditions
   - Time since last update
   - Historical data

3. **Weather Alerts**
   - Severe weather indicators
   - Temperature extremes
   - Wind speed alerts

#### F. Message Support (Future)

**Current:**
- Unknown

**Improvements:**
1. **APRS Message RX**
   - Decode message packets
   - Show in conversation view
   - Different UI from position beacons

2. **Message Notifications**
   - High priority
   - Show message preview
   - Respond action (for future TX with TNC)

#### G. Audio/Signal Quality Indicators

**Current:**
- Basic AFSK demodulation

**Improvements:**
1. **Signal Strength Display**
   - Show audio level from decoder
   - S-meter style indicator
   - Signal quality bar
   - Packet success rate

2. **Decoder Statistics**
   ```java
   Statistics {
       int packetsDecoded;
       int packetsFailed;
       double avgSignalLevel;
       long uptime;
   }
   ```

3. **Debug Mode (Advanced Users)**
   - Show bit errors
   - Show AFSK frequency deviation
   - Raw audio spectrum
   - Eye diagram (if possible)

#### H. Export & Logging

**Current:**
- Unknown

**Improvements:**
1. **Packet Logging**
   - Save all packets to file
   - CSV format with timestamp
   - Export to APRS-IS format
   - Share via email/cloud

2. **KML Export**
   - Export positions to KML
   - View in Google Earth
   - Include station data

3. **APRS-IS Gateway (Future)**
   - Option to forward RX packets to APRS-IS
   - Requires internet
   - Acts as iGate
   - Configurable filters

#### I. Settings Expansion

**Add these settings:**
1. **RX Configuration**
   - [ ] Audio threshold
   - [ ] AFC (Automatic Frequency Control)
   - [ ] Squelch correlation
   - [ ] Decoder algorithm (Goertzel vs IQ)

2. **Display Options**
   - [ ] Packet retention time (1h, 4h, 24h, forever)
   - [ ] Max stations to track
   - [ ] Auto-cleanup old stations
   - [ ] UI theme (light/dark)

3. **Notification Settings**
   - [ ] Enable/disable per type
   - [ ] Quiet hours
   - [ ] Sound selection
   - [ ] Vibration pattern

4. **Map Settings**
   - [ ] Map provider (Google, OpenStreetMap)
   - [ ] Auto-center on new station
   - [ ] Show range circles
   - [ ] Station trail length

#### J. Performance Optimization

**Areas to optimize:**
1. **Decoder Performance**
   - Profile AFSKDecoderIQ for bottlenecks
   - Consider native code (JNI) for FFT
   - Optimize buffer sizes
   - Reduce memory allocations

2. **UI Performance**
   - RecyclerView for packet list (if not already)
   - Image caching for map markers
   - Background thread for parsing
   - Efficient position updates

3. **Battery Optimization**
   - Wake lock management
   - GPS power control (if used)
   - Background service optimization
   - Doze mode compatibility

---

## Phase 3: Documentation Updates

### User Documentation

**Create: APRS_USER_GUIDE.md**
1. What is APRS
2. How to use APRS RX
3. Understanding packet display
4. Map usage
5. Why TX doesn't work (hardware)
6. External TNC options
7. Troubleshooting

### Developer Documentation

**Update: README.md**
- Document APRS RX as production feature
- Note TX hardware limitation
- Link to final report

**Create: APRS_RX_ARCHITECTURE.md**
1. Audio capture path
2. AFSK demodulation algorithm
3. AX.25 decoding
4. Packet parsing
5. UI integration
6. Performance considerations

### Code Comments

**Add to remaining APRS files:**
```java
/**
 * APRS RECEIVE ONLY IMPLEMENTATION
 * 
 * This radio supports APRS packet reception via the analog FM receiver.
 * APRS transmission is NOT supported due to hardware DSP limitations.
 * 
 * For APRS TX, use:
 * - External TNC (Mobilinkd, Argent Data, etc.)
 * - APRS-capable radio (Anytone D878UV, Yaesu FT-3D, etc.)
 * 
 * See APRS_TX_INVESTIGATION_FINAL_REPORT.md for technical details.
 */
```

---

## Implementation Priority

### High Priority (Do First)
1. ✅ **Remove all TX code** (clean up, reduce confusion)
2. ✅ **Add RX-only documentation** (user guide)
3. ✅ **Improve packet display UI** (better UX)
4. ✅ **Add basic notifications** (new stations)
5. ✅ **Station database** (persistent storage)

### Medium Priority (Do Next)
6. ✅ **Enhanced map display** (better markers)
7. ✅ **Station list view** (sortable, searchable)
8. ✅ **Weather station support** (if not implemented)
9. ✅ **Signal quality indicators** (S-meter)
10. ✅ **Export/logging** (CSV, KML)

### Low Priority (Nice to Have)
11. ⭕ **Advanced decoder stats** (debug mode)
12. ⭕ **APRS-IS gateway** (iGate mode)
13. ⭕ **Message RX** (if standard supports)
14. ⭕ **Performance optimization** (native code)
15. ⭕ **Advanced settings** (AFC, decoder tuning)

---

## Testing Plan

### After TX Removal
- [ ] Build APK and verify no crashes
- [ ] Check APRS settings UI (no TX elements)
- [ ] Verify RX still works
- [ ] Check log for removed hook errors

### After RX Improvements
- [ ] Test with real APRS traffic
- [ ] Verify all packet types decode
- [ ] Test map display with multiple stations
- [ ] Test notifications
- [ ] Test station database persistence
- [ ] Performance test (1 hour continuous RX)
- [ ] Battery drain test

---

## Code Structure After Cleanup

```
DMRModHooks/app/src/main/java/com/dmrmod/hooks/
├── aprs/
│   ├── APRSReceiver.java          [KEEP] RX decoder
│   ├── APRSPacketParser.java      [KEEP] Packet parser
│   ├── APRSStation.java           [NEW]  Station data model
│   ├── APRSDatabase.java          [NEW]  Station persistence
│   ├── APRSMapManager.java        [NEW]  Map display logic
│   ├── APRSNotifications.java     [NEW]  Notification handling
│   ├── APRSWeatherParser.java     [NEW]  Weather packet parsing
│   ├── AFSKDecoderIQ.java         [KEEP] IQ demodulation
│   └── AFSKGenerator.java         [KEEP] Reference only
├── ui/
│   ├── APRSFragment.java          [MODIFY] Remove TX UI
│   ├── APRSSettingsFragment.java  [MODIFY] RX-only settings
│   ├── APRSPacketAdapter.java     [NEW]  RecyclerView adapter
│   ├── APRSStationListFragment.java [NEW] Station list
│   ├── APRSStationDetailFragment.java [NEW] Station detail
│   └── APRSMapFragment.java       [NEW]  Map view
└── MainHook.java                  [MODIFY] Remove TX hooks

Documentation:
├── APRS_TX_INVESTIGATION_FINAL_REPORT.md    [DONE]
├── APRS_CLEANUP_AND_RX_IMPROVEMENT_PLAN.md  [THIS FILE]
├── APRS_USER_GUIDE.md                       [TODO]
├── APRS_RX_ARCHITECTURE.md                  [TODO]
└── README.md                                [UPDATE]
```

---

## Estimated Effort

### Phase 1: TX Removal
- **Time:** 2-3 hours
- **Complexity:** Low
- **Risk:** Low (just deletion)

### Phase 2: RX Improvements (Phased)
- **High Priority:** 10-15 hours
- **Medium Priority:** 15-20 hours
- **Low Priority:** 20-30 hours
- **Total:** 45-65 hours for all improvements

### Phase 3: Documentation
- **Time:** 3-5 hours
- **Complexity:** Low

---

## Success Criteria

### TX Removal Complete When:
- [ ] All TX methods removed from APRSBeacon.java
- [ ] AudioRecord hook removed from MainHook.java
- [ ] TX UI elements removed
- [ ] Build succeeds with no errors
- [ ] RX still works after changes
- [ ] No references to removed code remain

### RX Improvements Complete When:
- [ ] Packet display is clear and informative
- [ ] Map shows stations with proper symbols
- [ ] Notifications work reliably
- [ ] Station database persists across restarts
- [ ] Performance is acceptable (no lag)
- [ ] User documentation exists
- [ ] Code is well-commented

---

## Notes for Implementation

### Before Starting:
1. Create git branch: `aprs-tx-removal`
2. Commit current state
3. Make changes incrementally
4. Test after each major change

### TX Removal Order:
1. Remove TX methods from APRSBeacon.java
2. Remove AudioRecord hook from MainHook.java
3. Remove TX UI elements
4. Remove unused fields/imports
5. Clean up comments
6. Build and test

### RX Improvements Order:
1. Start with high-priority items
2. One feature at a time
3. Test thoroughly before moving to next
4. Document as you go

### If Problems:
- Git revert to last working state
- Review logs for errors
- Check for references to removed code
- Verify all imports still valid

---

## Ready to Proceed?

**Next Steps:**
1. Review this plan
2. Confirm approach
3. Start with Phase 1 (TX removal)
4. Then tackle Phase 2 improvements one by one

**Questions?**
- Any TX code you want to keep for reference?
- Any specific RX features you want prioritized?
- Any concerns about removing TX code?
