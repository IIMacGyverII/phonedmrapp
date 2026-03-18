# PriInterPhone DMR Radio - LSPosed Mod with OpenGD77 Integration + Advanced Features

**Status**: âœ… **FULLY FUNCTIONAL** - Export/Import + GPS Navigation + Zone Management + Transcription + APRS + VFO Mode + SSTV!

> **ï¿½ Current Stable Release: v3.3.3** (March 18, 2026) - SSTV Settings + APRS/SSTV Dialog Refresh Fix  
> **ðŸ“¦ Previous Release: v3.3.2** (March 19, 2026) - APRS Buttons Moved to Monitoring Page  
> **ðŸ”§ Prior Release: v3.3.1** (March 18, 2026) - Crash Recovery Improvements  
> **ðŸ“º Prior Release: v3.3.0** (March 18, 2026) - SSTV Live Monitoring  
> **ðŸŽ›ï¸ Prior Release: v3.2.3** (March 16, 2026) - APRS Channel Filtering + Button Spacing  
> **ðŸŽ›ï¸ Feature Release: v3.1.5** (March 14, 2026) - VFO Mode (Variable Frequency Oscillator)  
> **ðŸ› Bug Fix: v3.1.4** (March 13, 2026) - Software Squelch State Fix  
> **ðŸ“¡ Major Feature: v3.1.0** (March 12, 2026) - APRS Live Monitoring  
> **ðŸŽ™ï¸ Stable Base: v1.7.0** (February 2026) - Transcription & API Features

## Demo

<video src="https://github.com/user-attachments/assets/d6305a49-c8ed-47dc-a9d8-7e731aa02811" controls title="DMRModHooks v1.1 Demo" width="800"></video>

## 📺 What's New in v3.3.3 (March 18, 2026)

### SSTV Settings & Received Images Dialogs + Dialog Refresh Fix

**Added configurable SSTV settings (frequency with VHF/UHF support), a received images browser, and fixed stale-data dialogs for both SSTV and APRS**

#### **SSTV Settings Dialog**
- New **⚙️ SSTV Settings** button on both the SSTV start dialog and SSTV live monitoring screen
- Configure SSTV frequency (supports both **VHF 136–174 MHz** and **UHF 400–520 MHz**)
- Default frequency: `144.500 MHz` (persisted across sessions via SharedPreferences)
- Frequency validated to prevent out-of-range entry
- Hint text updated to show both VHF (`144.500`) and UHF (`432.500`) examples

#### **SSTV Received Images Dialog**
- New **📸 SSTV Received** button on both the SSTV start dialog and live monitoring screen
- Lists all saved SSTV images from `Download/DMR/SSTV/`, sorted newest-first
- Tap any entry to open in the device gallery app
- Shows "no images yet" placeholder when folder is empty

#### **Dialog Refresh Fix (SSTV + APRS)**
- **Problem**: Opening Settings from a start dialog, saving a new frequency, then returning showed the old value — the start dialog was built once and never refreshed
- **Fix**: Both **SSTV** and **APRS** start dialogs now use a holder+callback pattern
  - When Settings is opened from a start dialog, saving dismisses the stale start dialog and reopens it fresh
  - The newly opened dialog reads the latest saved values from SharedPreferences / APRSDatabase
  - Live monitoring screens are unaffected (they auto-refresh via their periodic handler)

---

## ðŸ“¡ What's New in v3.3.2 (March 19, 2026)

### APRS Received + APRS Settings Buttons Moved to Monitoring Page

**Relocated the `ðŸ“¡ APRS Received` and `âš™ï¸ APRS Settings` buttons from the general settings/channels page directly onto the APRS Monitoring Mode dialogs for better contextual access**

#### **What Changed**
- **Removed** both buttons from the general Export/Import settings page
- **Added** both buttons to the **APRS Start Dialog** (before monitoring starts) â€” displayed below the packet statistics and logging note, above the Start/Close buttons
- **Added** both buttons to the **APRS Live Monitoring Screen** (while monitoring is active) â€” displayed below the auto-logging info footer
- A subtle visual divider separates the action buttons from the informational text on each screen

#### **Why This Improves the UX**
- `ðŸ“¡ APRS Received` and `âš™ï¸ APRS Settings` are APRS-specific â€” they belong on the APRS page, not alongside Export/Import
- Users no longer need to leave the APRS flow to check received stations or adjust settings
- Both buttons accessible at all times during the APRS workflow: before starting and while actively monitoring

---

## ï¿½ What's New in v3.3.1 (March 18, 2026)

### Crash Recovery Improvements â€” Restart App Button + Channel Name Fix

**Hardened crash recovery for APRS, SSTV, and VFO modes with a proper Restart App button and a data-integrity fix**

#### **Crash Recovery Dialog â€” Restart App Button**
- All three recovery dialogs (APRS, SSTV, VFO) now show a **"Restart App"** button instead of plain "OK"
  - Tap to immediately restart the app for a clean state after channel restore
  - Dialog is non-cancellable so users can't accidentally dismiss it
  - VFO dialog upgraded to use `Handler(Looper.getMainLooper())` and activity validity check (consistent with APRS/SSTV)

#### **Channel Name Integrity Fix**
- **Bug fixed**: Backup functions were stripping `APRS (`, `SSTV (`, or `VFO-` prefixes from channel names before saving
  - Impact: A channel legitimately named `"APRS (local)"`, `"SSTV transmit"`, or `"VFO-Station"` would have its name mangled in the backup and restore incorrectly
  - Root cause: Defensive stripping was added in a prior session as a guard against double-nesting, but was applied unconditionally â€” not just when the name was already hijacked
  - Fix: Removed all stripping. The backup is always saved **before** the name hijack, so the live channel name is always clean at save time â€” no stripping was ever needed
- Affects `saveChannelBackup` (APRS), `saveSSTVChannelBackup`, `saveVFOChannelBackup`, `restoreSSTVChannelBackup`, `restoreVFOChannelBackup`, `checkAndRestoreAPRSChannelOnStartup`, `checkAndRestoreSSTVChannelOnStartup`, `checkAndRestoreVFOChannelOnStartup`

---

## ï¿½ðŸ“º What's New in v3.3.0 (March 18, 2026)

### SSTV Live Monitoring - Slow Scan TV Image Reception

**Receive and decode SSTV transmissions in real-time directly on the radio, with automatic image saving and live display**

#### **SSTV Button & Live Screen**
- **ðŸ“º SSTV Toggle Button**: New teal/cyan button on intercom page
  - Opens live monitoring screen with real-time decode display
  - Teal when active, light teal when inactive
  - Mutually exclusive with APRS and VFO modes
- **ðŸ“¸ Live Monitoring Screen**:
  - Real-time decode status and progress
  - Displays mode, line count, and estimated completion
  - Auto-updates every 2 seconds
  - Images saved automatically on completion

#### **Detection & Decoding**
- **ðŸŽ¯ VIS Tone Detection**: Goertzel algorithm detects the 300ms VIS header tone
  - Identifies all standard SSTV modes (Scottie S1/S2, Martin M1/M2, Robot 36/72, PD 90/120/160/180, etc.)
  - Runs in background thread â€” zero impact on audio playback
- **ðŸ” IQ Auto-Detect**: Blind SSTV mode detection without VIS tone
  - Analyzes spectral content to identify active transmissions
  - Warmup schedule (3/5/8/12/16s) then every 5s
- **âš¡ Background Thread Architecture**: All Phase 1 detection runs off the audio write thread
  - Audio write thread stays under 2ms per call â€” no buffering delay
  - Eliminated prior 30+ second audio delay from open-squelch sessions

#### **Image Handling**
- **ðŸ’¾ Auto-Save**: Every decoded image saved to `/sdcard/Download/DMR/SSTV/`
  - Filename format: `SSTV_YYYYMMDD_HHmmss_MODE.jpg`
  - JPEG quality 95 for archival fidelity
- **ðŸ“‹ Session History**: Last 10 received images listed on monitoring screen
  - Tap any entry to open in gallery
  - Shows mode, timestamp, and decode quality
- **ðŸ”„ 12-second backlog**: Pre-roll feeds up to 12s of buffered audio into decoder
  - Prevents top-of-image cutoff even when VIS is detected mid-stream
  - 1-second pre-roll before VIS start sample for header margin

#### **False Positive Guards**
- **ðŸ›¡ï¸ Multi-stage validation**: Cross-family checks, leader purity, vote fraction guards
  - Prevents random noise from triggering decode attempts
  - CV (coefficient-of-variation) guard on VIS code confidence
- **âš ï¸ Open-squelch tip**: Info note on monitoring screen about false positive risk
  - Recommends software squelch for cleaner detection

#### **Software Squelch Integration**
- Independent soft-squelch toggle on SSTV monitoring screen
- 2.5-second delayed re-apply prevents race with `syncChannelInfoWithData` state machine
  - Ensures squelch stays open even when channel state machine fires after start
- Pre-squelch audio still fed to decoder and recorder (squelch only gates speaker)

#### **Technical Details**
- **Sample rate**: 16 kHz, 16-bit mono PCM (matches radio audio pipeline)
- **Buffer**: Up to 1 MB (~32s) ring buffer with `DirectBAOS` (zero-alloc inner class)
- **Pre-allocated work buffers**: 2s VIS buffer + 16s auto-detect buffer (no GC pressure)
- **Goertzel VIS scan**: Every 250ms on background thread, < 1ms each
- **IQ auto-detect**: Every 5s steady-state, ~ 50ms each â€” fully off write thread
- **`imageStartSample` fix**: Auto-detect path correctly anchors start to analyzed window
  - Prevents full-image decode from defaulting to buffer start (which caused top cutoff)

#### **Usage**
1. **Intercom page** â†’ Tap **SSTV** button (teal, beside APRS)
2. Tap **Start Monitoring** on the SSTV live screen
3. The module listens for VIS tones or auto-detects SSTV transmissions
4. When a signal is found, decoding begins automatically with progress display
5. Completed image is saved to `/sdcard/Download/DMR/SSTV/` and shown on screen
6. Tap **Stop Monitoring** to return to normal intercom operation

#### **Compatible SSTV Modes**
- Scottie S1, S2, DX
- Martin M1, M2
- Robot 36, 72
- PD 90, 120, 160, 180, 240
- Wraase SC2-120, SC2-180

---

## ðŸŽ›ï¸ What's New in v3.1.5 (March 14, 2026)

### VFO Mode - Variable Frequency Oscillator

**Complete frequency control with temporary channel override for quick QSOs without saving channels**

#### **VFO Button & Dialog**
- **ðŸŽ›ï¸ VFO Toggle Button**: New orange button on intercom page (bottom-left, below TXT)
  - Orange when active, light orange when inactive
  - Opens comprehensive tuning dialog with all channel parameters
  - Temporarily hijacks current channel (restores on exit)
- **ðŸ“» Full Control Dialog**: Complete channel configuration without database changes
  - **Channel Mode**: Analog or Digital/DMR with mode-specific controls
  - **Frequency**: Numeric input with validation (136-174 MHz, 400-480 MHz)
  - **Power Level**: Low (1W) or High (5W) selection
  - **Tone Settings** (Analog): RX/TX tone type (None/CTCSS/DCS) and code selection
  - **Bandwidth** (Analog): 12.5 kHz or 25 kHz
  - **DMR Settings** (Digital): Contact type, TalkGroup ID, Color Code (0-15), Timeslot
  - **DMR ID Override**: Temporary local ID that persists across VFO sessions
  - **Apply Settings**: Instantly sends configuration to hardware via AnalogMessage/DigitalMessage
- **ðŸ”„ Automatic Restoration**: Original channel settings restored when exiting VFO mode
  - Backup system preserves all fields (frequency, tones, squelch, power, DMR settings)
  - Software squelch automatically disabled during VFO (if enabled on main channel)
  - Button state synchronized with VFO mode status

#### **Key Features**
- **âœ¨ No Channel Creation**: Tune to any frequency without cluttering channel list
- **ðŸŽ¯ Quick QSO Mode**: Perfect for simplex contacts, contests, or emergency frequencies
- **ðŸ’¾ Non-Persistent**: All changes temporary until VFO mode exits
- **ðŸ”§ Hardware Verified**: All settings tested and confirmed working
  - Analog: Frequency, power, bandwidth, RX/TX tones all functional
  - Digital: Frequency, Color Code, DMR ID, contact type, TG, slot all functional
- **ðŸ”„ DMR ID Persistence**: Temporary DMR ID persists across VFO close/reopen (until app restart)
  - Allows testing different DMR IDs without changing system settings
  - Stored in vfoLocalId variable (independent of system DMR ID)
  - Defaults to ID 1 if not specified

#### **Critical Bug Fixes**
- **Fixed: Color Code field name** (`cc` not `colorCode`)
  - Previous bug: Color Code always transmitted as 0 regardless of UI setting
  - Impact: Unable to communicate on networks with non-zero Color Codes
  - Solution: Use correct ChannelData field name "cc"
- **Fixed: VFO reactivation logic**
  - Previous bug: Reopening VFO dialog after exit didn't send settings to hardware
  - Impact: Apply Settings button appeared to do nothing on second open
  - Solution: Check `isVFOModeActive` flag and reinitialize VFO state if needed
- **Fixed: Conflicting hardware updates**
  - Previous bug: `dmrManager.updateChannel()` was overriding `DigitalMessage.send()`
  - Impact: Settings sent via DigitalMessage were immediately overwritten
  - Solution: Removed redundant updateChannel() call, rely on direct message send
- **Fixed: DMR ID field handling**
  - Previous bug: Tried to read non-existent `localId` field from ChannelData
  - Impact: NoSuchFieldError crash when using VFO on digital channels
  - Solution: Use vfoLocalId variable directly, defaults to 1 if not set

#### **Technical Implementation**
- **Direct Hardware Control**: Uses AnalogMessage.send() and DigitalMessage.send()
  - Bypasses database and state machine for instant hardware updates
  - Same reliable pattern as MON button and APRS monitoring
- **State Management**: isVFOModeActive flag prevents conflicts with normal operations
  - VFO and APRS are mutually exclusive (can't run both simultaneously)
  - Software squelch disabled during VFO to avoid interference
- **Field Validation**: All inputs validated before sending to hardware
  - Frequency: Checked against radio's supported bands
  - Color Code: Range 0-15 enforced
  - DMR ID: Positive integer validation
  - TalkGroup: Positive integer validation

#### **Usage**
1. **Intercom page** â†’ Tap **VFO** button (orange, bottom-left)
2. **Configure settings** in dialog:
   - Select Analog or Digital mode
   - Enter frequency (e.g., 146.520 for 2m simplex)
   - Set power level, tones/DMR settings as needed
   - Optionally override DMR ID for testing
3. Tap **Apply Settings** â†’ Settings sent to hardware immediately
4. Use radio normally with VFO frequency
5. Tap **Stop VFO** or VFO button again â†’ Original channel restored

#### **Use Cases**
- **Simplex Contacts**: Quick frequency entry for direct contacts
- **Contest Operation**: Rapidly tune to contest frequencies
- **Emergency Communications**: Access emergency frequencies without preset channels
- **DMR Testing**: Try different Color Codes, TalkGroups, or IDs without channel edits
- **Repeater Exploration**: Test repeater frequencies before adding to channel list
- **Travel Mode**: Tune to local frequencies in unfamiliar areas

---

## ðŸ› What's New in v3.1.4 (March 13, 2026)

### Critical Software Squelch State Fix

**Fixed bug where software squelch remained active after stopping APRS monitoring**

#### **Bug Fixed**
- **ðŸ”§ Squelch State Clearing**: Software squelch flags now properly cleared when exiting APRS mode
  - Previously: `isSoftwareSquelchEnabled` and `isAprsSoftwareSquelchEnabled` stayed `true` after stopping APRS
  - Result: Audio remained blocked even though UI showed Soft SQ as OFF
  - Impact: Users couldn't hear audio on intercom after using APRS with Soft SQ enabled
- **âœ… Proper State Reset**: Both flags explicitly set to `false` in `stopAPRSMonitoring()`
  - Ensures audio processing allows playback when returning to intercom
  - UI state now matches internal flag state
  - No more "ghost squelch" blocking audio

#### **User Impact**
- **Before**: Enable Soft SQ in APRS â†’ Stop APRS â†’ Return to intercom with no audio
- **After**: Squelch properly disabled when exiting APRS, audio works immediately
- **Reliability**: State flags and UI now stay synchronized across mode transitions

---

## ðŸŽ¨ What's New in v3.1.3 (March 13, 2026)

### Software Squelch UI Enhancements & APRS Toggle

**Complete UI overhaul for software squelch control + APRS monitoring improvements**

#### **Intercom Page Enhancements**
- **âœ¨ Soft SQ Toggle Button**: Control software squelch on/off
  - Light blue when OFF (hardware squelch mode)
  - Blue when ON (software squelch enabled)
  - Shows/hides slider based on toggle state
  - OFF: Hardware squelch set to 2 (default)
  - ON: Hardware squelch set to 0, software takes over
- **âš¡ Performance Optimization**: Slider no longer spams hardware during drag
  - Hardware squelch only applied on release (onStopTrackingTouch)
  - Toast notification only on release (no more spam)
  - Smooth dragging without lag or repeated writes
- **ðŸŽ¨ Button Visual Improvements**: All toggle buttons use light-colored OFF states
  - TXT button: Light purple â†’ Purple
  - Soft SQ button: Light blue â†’ Blue
  - REC button: Light red â†’ Red
  - MON button: Light orange â†’ Orange
  - APRS button: Light green â†’ Green
- **ðŸ”˜ APRS Button Enhancement**: Converted to ToggleButton with state management
  - Auto-toggles with monitoring state
  - Unchecks when closing monitoring dialog
  - Proper state sync across app lifecycle
- **ðŸ“ UI Spacing Refinements**:
  - Slider track now colored full width (white on intercom, black on APRS)
  - Reduced spacing between SQ: label and value display
  - Tighter spacing above squelch controls
  - Vertical spacing added between SQ: label and slider (4dp)

#### **APRS Monitoring Page Enhancements**
- **âœ¨ Soft SQ Toggle**: Independent software squelch control for APRS
  - Works identically to intercom page toggle
  - Light blue when OFF, blue when ON
  - Shows/hides slider and info text
  - OFF: Uses hardware squelch (level 2)
  - ON: Enables hybrid RSSI + Audio RMS squelch
- **ðŸ”§ Independent Control**: APRS and intercom squelch settings are separate
  - Each page has its own toggle state
  - Each can use software or hardware squelch independently
  - Squelch levels saved separately in preferences

#### **Technical Details**
- Software squelch disabled by default on both pages (user opt-in)
- Toggle states: `isSoftwareSquelchEnabled` (intercom), `isAprsSoftwareSquelchEnabled` (APRS)
- Hardware squelch control via direct `AnalogMessage.send()` calls
- UI updates optimized to reduce redundant hardware writes
- Full-width slider track using `setProgressBackgroundTintList()`

---

## ï¿½ What's New in v3.1.2 (March 13, 2026)

### APRS Channel Recovery & Squelch Control Improvements

**Automatic crash recovery with user guidance + hardware-aware squelch control**

#### **Crash Recovery System**
- **Automatic channel restoration** when app closes during APRS monitoring
- **AlertDialog notification** explains what happened and how to prevent future issues
- **Complete field restoration** including frequency, squelch, and all metadata
- **Comprehensive logging** for debugging crash recovery scenarios

**How It Works:**
1. Module detects orphaned APRS channel on app startup
2. Automatically restores original channel settings from backup file
3. Shows informative dialog with prevention guidance
4. Prompts to restart the app for clean state

**Backup System:**
- File: `/sdcard/aprs_channel_backup.dat`
- Saves: number, type, name, frequencies, squelch, band, power, rx/tx settings
- Auto-deletes after successful restore

#### **Squelch Control - Hardware Limitation Documentation**

**âš ï¸ IMPORTANT: Ulefone Armor 26 Ultra Hardware Limitation**

The radio hardware has a unique quirk that affects squelch control:
- **Only sq=0 (open) and sq=2 work reliably**
- **sq=1, sq=3-9 are forced to sq=2 by the hardware**
- This is a **hardware/firmware limitation**, not a software bug

**Impact on Design:**
- No squelch slider needed - hardware only supports two states
- **Open Squelch button** toggles between sq=0 (fully open) and sq=2 (tight)
- Button shows **green** when squelch is open (sq=0)
- Button shows **gray** when squelch is closed (sq=2)
- Button state persists across UI refreshes (monitoring page updates every 2 seconds)

**Why This Matters:**
- Previous attempts at granular squelch control (0-9 slider) were fighting hardware
- New design works **with** the hardware limitation instead of against it
- Provides predictable, reliable squelch behavior

**Technical Details:**
- Direct hardware control via `AnalogMessage.send()`
- Persistent static state variables survive UI refreshes
- Works identically to MON button pattern
- No database updates needed (direct UART communication)

---

## ï¿½ðŸ› What's New in v3.1.1 (March 12, 2026)

### Critical APRS Bug Fixes

**Reliability improvements for APRS monitoring after crashes and fresh storage**

- **Fixed: Fresh Storage Issue**
  - APRS monitoring now works correctly after clearing app storage
  - Uses in-memory channel hijacking instead of database queries
  - No more ClassNotFoundException errors
- **Fixed: Crash Recovery**
  - Channel automatically restored after force-close during monitoring
  - File-based backup at `/sdcard/aprs_channel_backup.dat`
  - Detects orphaned APRS channels and restores original within 2 seconds
- **Fixed: Static Variable Persistence**
  - State properly resets on every app launch
  - Fixed Xposed module lifecycle issue (static vars persist across app restarts)
  - Resets `isAPRSMonitoringActive`, dialog references, and audio buffer
- **Fixed: APRS Button After Crash**
  - APRS button works correctly after crash recovery
  - Monitoring dialog displays properly after app restart
  - No more phantom audio buffering
- **Fixed: Dialog State Issues**
  - Dialog references now reset on app launch
  - Live monitoring screen appears correctly on restart

---

## ðŸ“¡ APRS Live Monitoring (v3.1.0)

### Real-time APRS packet reception with live dashboard and clickable map links

- **APRS Button** on intercom page (green button below MON)
- **Live Monitoring Dashboard**:
  - Persistent screen that stays open during monitoring
  - Auto-updates every 2 seconds with new packets
  - Real-time statistics (total stations, last hour, last 5 minutes)
  - Shows up to 10 most recent packets
- **Clickable Station Links**:
  - Tap any station to open Google Maps at GPS location
  - Shows callsign, time received, and coordinates
  - Underlined cyan text indicates clickable links
- **Automatic Channel Creation**:
  - Creates hidden APRS channel automatically on first use
  - Uses frequency from APRS Settings (default: 144.390 MHz)
  - Channel hidden from UI but accessible for monitoring
- **Auto-Logging**:
  - Per-callsign text logs (append mode): `Download/DMR/APRS/CALLSIGN-SSID.txt`
  - Per-callsign GPX tracks (full movement history): `Download/DMR/APRS/CALLSIGN-SSID.gpx`
  - Full packet history in database for track visualization
- **APRS Settings Dialog**:
  - Configure callsign, SSID, and frequency
  - Access via APRS Received page or Settings
- **Channel Management**:
  - Saves previous channel and returns on stop
  - Works from both analog and digital channels
  - No manual channel creation needed

**Usage**: 
1. Intercom page â†’ Tap APRS button (green, below MON)
2. Configure settings if needed (callsign optional for RX-only)
3. Tap "Start Monitoring" â†’ Live dashboard appears
4. Tap any received station â†’ Opens in Google Maps
5. Tap "Stop Monitoring" â†’ Returns to previous channel

**Technical Details**:
- Pure RX-only operation (no transmit capability)
- Uses device's analog FM receiver tuned to APRS frequency
- Bell 202 AFSK 1200 baud decoding (AX.25 protocol)
- APRS channels automatically filtered from channel list
- Database stores full transmission history per station

## ðŸŽ‰ What's New in v3.0.9 (March 9, 2026)

### ðŸ§­ GPS Distance Display Enhancements

**Directional arrows, compass bearings, and dual distance units for better situational awareness**

- **8-direction compass arrows**: â†‘N, â†—NE, â†’E, â†˜SE, â†“S, â†™SW, â†W, â†–NW
- Shows direction from your location to the channel
- Real-time bearing calculation using GPS coordinates
- **Dual distance display**: 
  - < 1km: Meters only (e.g., `â†‘N 250m`)
  - 1-10km: Kilometers (e.g., `â†’E 5.2km`)
  - > 10km: Miles + kilometers (e.g., `â†˜SE 96.7mi (155.6km)`)
- Improved UI layout: Widened location area from 30% to 40% width to prevent text wrapping
- No internet required (uses device location only)

**Display Examples**:
```
Echo, Minnesota (â†˜SE 96.7mi (155.6km))
320m (1050ft) ðŸ“

Chicago Rptr (â†—NE 5.2km)
180m (590ft) ðŸ“

Local Simplex (â†‘N 250m)
210m (689ft) ðŸ“
```

## ðŸŽ‰ What's New in v3.0.8 (March 9, 2026)

### ðŸŽ›ï¸ Zone Management & Channel Edit Zone Selector

**Create, edit, and assign zones directly from the app!**

- **Zone row in channel edit screen** - Assign channels to zones while editing
- **Create new zones** - Tap "Create New Zone..." at bottom of zone list
- **Edit zone names** - Pencil icon (âœ) next to each zone or long-press to rename
- **Automatic list refresh** - Channel list updates instantly after zone changes
- **Technical improvements**:
  - Fixed critical hook stacking bug (zone assignments now persistent)
  - Proper instance field management
  - Singleton database pattern
  - OpenGD77 Zones.csv import/export fully supported

**Usage**: Channel page â†’ Edit channel â†’ Tap Zone row â†’ Select/Create/Rename zones

## ðŸŽ‰ What's New in v3.0.5 (March 9, 2026)

### ðŸ“‚ Channel Zones

**Organize channels into zones (like folders)**

- **ZONE button** on main screen (below MON button)
- Import/export zones via OpenGD77 Zones.csv format
- Zone-based channel navigation (arrows filter by active zone)
- Up to 80 channels per zone (OpenGD77 limit)
- Zones stored in local database (persistent)

## ðŸŽ‰ What's New in v3.0.4 (March 9, 2026)

### ðŸ“ GPS Distance Calculation

- Real-time distance from your location to channel coordinates
- Smart distance formatting (meters/kilometers/miles based on range)
- Uses device GPS/network location
- No internet required

## ðŸŽ‰ What's New in v3.0.3 (March 9, 2026)

### ðŸ› Critical Bug Fix

- **DMR Audio Fixed**: Resolved silent receive audio and garbled transmit audio
- Call type override logic now only active during MON mode

## ðŸŽ‰ What's New in v3.0.2 (March 9, 2026)

### ðŸ†• Major Features

1. **Analog MON (Monitor) Button** â­
   - Squelch fully open (sq=0) for continuous monitoring
   - Visual feedback: Orange = monitoring, Gray = normal
   - Perfect for scanning and emergency monitoring

## Complete Feature List (v1.0 - v3.3.2)

### Core Features
- âœ… **APRS Button Reorganization (v3.3.2)** - APRS Received + Settings buttons moved to monitoring page
- âœ… **Crash Recovery Improvements (v3.3.1)** - Restart App button, channel name integrity fix
- âœ… **SSTV Live Monitoring (v3.3.0)** - Slow Scan TV image reception with auto-save and live display
- âœ… **VFO Mode (v3.1.5)** - Variable Frequency Oscillator with temporary channel override
- âœ… **APRS Live Monitoring (v3.1.0-v3.1.4)** - Real-time packet reception with dashboard and maps
- âœ… **OpenGD77 CSV export/import** - All 5 files (Channels, Contacts, TG_Lists, Zones, DTMF)
- âœ… **Zone management** - Create, edit, assign zones to channels from channel edit page
- âœ… **GPS navigation** - Distance, direction, bearing to channels
- âœ… **Location tracking** - Reverse geocoding, city/state display, elevation
- âœ… **RSSI signal strength** indicator
- âœ… **DMR activity history** with timestamps
- âœ… **Contact integration** - Caller ID display
- âœ… **Analog MON button** - Open squelch for continuous monitoring
- âœ… **Software Squelch** - Hybrid RSSI + Audio RMS squelch with UI controls

### SSTV Monitoring Features (v3.3.0)
- âœ… **VIS tone detection** - Goertzel algorithm identifies all standard SSTV modes
- âœ… **IQ auto-detect** - Blind detection without VIS for partial transmissions
- âœ… **Auto-save images** - JPEG to `/sdcard/Download/DMR/SSTV/` on every decode
- âœ… **12-second pre-roll backlog** - No top-of-image cutoff
- âœ… **False positive guards** - Multi-stage validation prevents noise triggers
- âœ… **Background thread decoding** - Zero audio playback delay
- âœ… **Software squelch integration** - Independent squelch control with race-condition fix
- âœ… **All major SSTV modes** - Scottie, Martin, Robot, PD, Wraase

### VFO Mode Features (v3.1.5)
- âœ… **Temporary frequency tuning** without saving channels
- âœ… **Analog & Digital/DMR support** with mode-specific controls
- âœ… **Full parameter control** - Frequency, power, tones, bandwidth, DMR settings
- âœ… **DMR ID override** - Test different DMR IDs without changing system settings
- âœ… **Automatic channel restoration** on exit
- âœ… **Direct hardware communication** - Instant settings application
- âœ… **Reactivation support** - Reopen and adjust settings without restart

### Transcription Features (v1.2 - v1.7.0)
- âœ… **Real-time speech-to-text** using OpenAI Whisper API
- âœ… **Automatic audio recording** organized by channel
- âœ… **Per-channel transcription history** (last 3-10 messages)
- âœ… **Daily transcription logs** with timestamps and DMR IDs
- âœ… **User-friendly API key configuration**

## What is this?

LSPosed module for the Ulefone PriInterPhone DMR radio app that adds:
- **ðŸ“º SSTV Live Monitoring** - Receive and decode Slow Scan TV images over the air
- **ðŸŽ›ï¸ VFO Mode** - Variable Frequency Oscillator for temporary frequency tuning
- **ðŸ“¡ APRS Live Monitoring** - Real-time packet reception with live dashboard and GPS mapping
- **ðŸ§­ GPS Navigation** - Directional arrows, compass bearings, distance to channels
- **ðŸ“‚ Zone Management** - Create, edit, assign channels to zones (folder organization)
- **ðŸ“¤ OpenGD77 CSV Export** - Export all channels/contacts to OpenGD77-compatible CSV files
- **ðŸ“¥ OpenGD77 CSV Import** - Import OpenGD77 codeplugs directly into the app
- **ðŸ”„ Cross-platform programming** - Edit channels in OpenGD77 CPS, import to phone
- **ðŸ—‚ï¸ Easy access** - Backups saved to Download folder (easy file transfer)
- **âš¡ Direct database access** - No shell commands, fast and reliable
- **ðŸ”’ No APK modification** - Works via runtime hooks (preserves platform signature)
- **ðŸŽ™ï¸ Real-time Transcription** - Live speech-to-text powered by OpenAI Whisper API
- **ðŸ“ Automatic Logging** - Daily transcription logs organized by channel with timestamps

## Current Status âœ…

**Current Release: v3.3.2** (March 19, 2026)  
**APRS UX**: âœ… APRS Received + Settings buttons moved to monitoring page  
**Crash Recovery**: âœ… Improved â€” Restart App button on all recovery dialogs, channel name integrity fix  
**SSTV Monitoring**: âœ… Working - VIS detection + IQ auto-detect, auto-save images, all major modes  
**VFO Mode**: âœ… Working - Complete frequency control with analog/digital support  
**APRS Monitoring**: âœ… Working - Live dashboard with GPS mapping and auto-logging  
**GPS Navigation**: âœ… Working - Directional arrows, compass bearings, distance (m/km/mi)  
**Zone Management**: âœ… Working - Create, edit, assign zones from channel edit page  
**Export**: âœ… Working - All 5 OpenGD77 CSV files + PDF summary + Zones.csv  
**Import**: âœ… Working - Full Digital & Analog support + Zones import  
**Transcription**: âœ… Working - Real-time speech-to-text with OpenAI Whisper API  
**Audio Recording**: âœ… Working - Automatic WAV recording organized by channel  
**Per-Channel History**: âœ… Working - Transcription messages persist per channel  
**Timestamps**: âœ… Working - All messages include HH:mm:ss timestamps  
**Analog MON Button**: âœ… Working - Open squelch for continuous monitoring  
**Software Squelch**: âœ… Working - Hybrid RSSI + Audio RMS squelch with UI controls  
**User Validation**: âœ… All features tested and confirmed working  
**Latest Build**: March 18, 2026

## Radio Firmware

The DMR radio module uses ARM Cortex-M firmware that handles all radio protocol operations. The original factory firmware is preserved in this repository for reference and patching experiments.

**Firmware Location**: `radio_firmware/`

- **DMR003.UV4T.V022-ORIGINAL.bin** - Factory firmware (378,620 bytes)
  - MD5: `4426035392262CA54583C230C9E268E0`
  - Base address: `0x08000000` (STM32/GD32 flash memory)
  - Architecture: ARM Cortex-M Thumb mode (mixed 16/32-bit instructions)
  - RTOS: uC/OS-III (Micrium)

**Testing Modified Firmware Safely**:

The app checks for custom firmware in `/sdcard/DMR/DMRDEBUG.bin` on startup. If found, it transfers this firmware to the radio module via YModem protocol (~2 minutes). This allows safe testing of modified firmware without permanent flashing.

```powershell
# Deploy custom firmware for testing
adb push modified_firmware.bin /sdcard/DMR/DMRDEBUG.bin

# Restart app to trigger firmware update
adb shell am force-stop com.pri.prizeinterphone

# Remove test firmware to restore original
adb shell rm /sdcard/DMR/DMRDEBUG.bin
```

**Current Firmware Reverse Engineering Status**: See [NOTES_FOR_GROK.md](NOTES_FOR_GROK.md) for ongoing work to fix the Monitor Mode (RECEIVE_ALL) group ID extraction bug.

### Quick Facts

- **Module**: com.dmrmod.hooks (LSPosed Xposed module)
- **Target App**: com.pri.prizeinterphone (Ulefone system app)
- **Transcription Service**: com.macdmr.transcription (Standalone AIDL service)
- **Device**: Ulefone Armor 26 Ultra (Android 13)
- **LSPosed**: v1.9.2 (Zygisk)
- **Current Version**: v3.3.2 (March 19, 2026)
- **Storage Location**: `Download/DMR/` (Audio, Transcription, DMR_Backups, APRS, SSTV folders)

## Features

### âœ… Phase 1: Initial Hook Setup
- Startup toast: "âœ“ DMR Mod Hooks Active! v3.3.2"
- Custom version display on Device Information screen
- Confirms module is active and working

### âœ… Phase 2: OpenGD77 CSV Export (v0.7.0 - v0.8.7)
- **Export all channels** to OpenGD77-compatible CSV format
- **5 CSV files generated**: Channels, Contacts, TG_Lists, Zones, DTMF
- Direct database access from hooked app context
- Perfect format matching (TAB-prefixed frequencies, CRLF line endings)
- **User validated**: Exported data successfully imports to OpenGD77 CPS
- **Round-trip tested**: Edit in app â†’ Export â†’ Import to OpenGD77 â†’ Success!

### âœ… Phase 3: OpenGD77 CSV Import (v0.9.0 - v1.1)
- **Import channels** from OpenGD77 CSV files
- Direct database write with atomic transactions
- Handles mixed VHF/UHF channel lists
- **All channels import correctly** including both Digital (DMR) and Analog (FM)
- Correct field values for Digital vs Analog channel activation
- Backup selection dialog (supports any folder name in DMR/DMR_Backups/)
- Auto-refresh after import - no app restart needed
- Import confirmation with success/failure reporting
- Files stored in user-friendly Download folder

### âœ… Phase 4: Real-time Speech-to-Text Transcription (v1.2 - v1.7.0)
- **Live transcription** of all DMR audio transmissions
- **OpenAI Whisper API** integration for accurate recognition
- **Automatic audio recording** - All transmissions saved as WAV files
- **Per-channel message history** - Each channel maintains its own scrollable message list
- **Channel switching memory** - Return to any channel and see previous messages (up to 10 messages per channel)
- **Timestamped messages** - Every transcription includes [HH:mm:ss] timestamp
- **Channel-organized storage**:
  - Audio recordings: `Download/DMR/Audio/[ChannelName]/`
  - Transcriptions: `Download/DMR/Transcription/[ChannelName]/`
- **Daily transcription logs** - Running log files with timestamps and DMR IDs
- **Format**: `[14:30:22] ID: 123456 - Transcribed text here`
- **Scrollable UI** - Message list grows dynamically with height cap at 100dp
- **Network resilience** - Connectivity checking and comprehensive error handling
- **Secure API key** - Stored in `/sdcard/DMR/api_key.txt` (auto-created on first run)
- **Cost**: First $5/month FREE credit, then affordable per-second pricing
- **Status**: âœ… Successfully transcribing real DMR audio in production

### âœ… Phase 5: GPS Navigation & Location Tracking (v3.0.4 - v3.0.9)
- **Directional compass arrows** - 8-direction arrows (â†‘N, â†—NE, â†’E, â†˜SE, â†“S, â†™SW, â†W, â†–NW)
- **Real-time bearing calculation** - Shows direction from your location to channel
- **Smart distance display**:
  - < 1km: Meters (e.g., `â†‘N 250m`)
  - 1-10km: Kilometers (e.g., `â†’E 5.2km`)
  - > 10km: Miles + kilometers (e.g., `â†˜SE 96.7mi (155.6km)`)
- **Reverse geocoding** - City, state display for channel coordinates
- **Elevation display** - Meters and feet via Open-Elevation API
- **Device location integration** - Uses GPS or network location
- **No internet required** for distance/bearing calculations

### âœ… Phase 6: Zone Management (v3.0.5 - v3.0.8)
- **Zone button** on main screen - Tap to select active zone
- **Zone-based navigation** - Arrow buttons filter by selected zone
- **Channel edit zone selector** - Assign channels to zones directly in edit screen
- **Create new zones** - Custom zone names via dialog
- **Edit zone names** - Pencil icon (âœ) or long-press to rename
- **Automatic list refresh** - Changes apply immediately
- **OpenGD77 Zones.csv** - Full import/export support
- **Up to 80 channels per zone** - OpenGD77 limit
- **Persistent storage** - Zones saved in local SQLite database
- **Technical improvements**:
  - Fixed critical hook stacking bug
  - Proper instance field management
  - Singleton database pattern

### âœ… Phase 7: Analog MON Button (v3.0.2)
- **Continuous monitoring** - Squelch fully open (sq=0) on analog channels
- **Visual feedback** - Orange when monitoring, gray when normal
- **Auto-reset** - Returns to normal when switching channels
- **Toast notifications** - Confirms state changes
- **Perfect for scanning** - Monitor busy frequencies, emergency channels

## Why LSPosed?

The PriInterPhone app requires Ulefone's platform certificate to access:
- System UID (1000) for hardware permissions
- Custom `PrizeTinyService` framework APIs
- DMR radio module on `/dev/ttyS1`

**Traditional APK modification fails** because:
- âŒ Re-signing breaks platform signature verification
- âŒ System app placement alone doesn't grant platform UID
- âŒ Cannot obtain Ulefone's proprietary platform certificate

**LSPosed hooks the original properly-signed app** at runtime:
- âœ… Preserves platform signature and system UID
- âœ… Full access to all system APIs
- âœ… Can modify behavior without touching APK
- âœ… Reversible and update-safe

See [DMRModHooks/README.md](DMRModHooks/README.md) for complete LSPosed implementation details.

## Installation Instructions

### Requirements
- Ulefone Armor 26 Ultra (or compatible device with PriInterPhone)
  - **Root guide**: [XDA Forum - Armor 26 Ultra Root & Development](https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-info-guides-development.4677740/)
  - **Note**: Check the XDA thread for the latest root procedure specific to your ROM version
  - **Tested on**: Build number `Armor 26 Ultra_AF1_v15`
- Unlocked bootloader
- Magisk v24+ with Zygisk enabled
- LSPosed v1.9.2+ (Zygisk variant)
- [ADB tools](https://developer.android.com/tools/releases/platform-tools) (for installation and verification)

### Step 1: Install LSPosed Framework

1. **Install Magisk** (if not already installed)
   - Download from: https://github.com/topjohnwu/Magisk
   - Enable Zygisk in Magisk settings
   - Reboot device

2. **Install LSPosed Module**
   - Download: https://github.com/LSPosed/LSPosed/releases
   - Get: `LSPosed-v1.9.2-zygisk-release.zip`
   - Install via Magisk â†’ Modules â†’ Install from storage
   - Reboot device
   - LSPosed Manager app will appear automatically

### Step 2: Install DMRModHooks Module & Transcription Service

#### Option A: Download Pre-built Release (âœ… Recommended for All Users)

**Use v3.0.9 latest release for all current features including GPS navigation, zone management, and transcription.**

1. **Download Latest Release**:
   - Go to [Releases](https://github.com/IIMacGyverII/phonedmrapp/releases/latest)
   - Download `DMRModHooks-v3.0.9.apk` (**latest version**)
   - Download `DMRTranscriptionService-v1.0.apk` (if using transcription)

2. **Install Both APKs**:
   ```powershell
   adb install -r DMRModHooks-v3.0.9.apk
   adb install -r DMRTranscriptionService-v1.0.apk  # Optional, for transcription only
   ```

#### Option B: Build from Source (For Developers & Experimenters)

**Building from source gives you access to the latest development code and experimental features.**

1. **Build Both APKs**:
   ```powershell
   # Build DMRModHooks
   cd DMRModHooks
   .\gradlew.bat assembleDebug
   
   # Build TranscriptionService
   cd ..\DMRTranscriptionService
   .\gradlew.bat assembleDebug
   ```

2. **Install Both Modules**:
   ```powershell
   adb install -r DMRModHooks\app\build\outputs\apk\debug\app-debug.apk
   adb install -r DMRTranscriptionService\app\build\outputs\apk\debug\app-debug.apk
   ```

#### Enable in LSPosed Manager

3. **Activate Module**:
   - Open LSPosed Manager app on device
   - Go to "Modules" tab
   - Enable "DMR Mod Hooks" checkbox
   - Tap "DMR Mod Hooks" â†’ Application scope
   - Verify `com.pri.prizeinterphone` is selected
   - **Important**: Do NOT add `com.macdmr.transcription` to LSPosed scope (it works standalone)
   - Reboot device

### Step 3: Configure OpenAI API (for Transcription - Optional)

**Note**: Transcription is optional. GPS navigation, zone management, and all other features work without it.

1. **Get API Key**:
   - Visit https://platform.openai.com/api-keys
   - Create account or sign in
   - Click "Create new secret key"
   - Copy the key (starts with `sk-...`)

2. **Configure API Key**:
   - Create file: `/sdcard/DMR/api_key.txt`
   - Paste your API key on first line (one line, no quotes)
   - The app auto-creates this folder on first run if missing
   - **Note**: File is device-local, never synced to GitHub

3. **Pricing**:
   - Whisper API: $0.006 per minute
   - First $5 of usage FREE with new accounts
   - Very affordable for typical DMR usage (~$0.002 per 5-second transmission)

### Step 4: Test Installation

1. **Verify Module is Active**:
   - Open PriInterPhone app
   - You should see toast: "âœ“ DMR Mod Hooks Active! v3.0.9"

2. **Test GPS Navigation** (if channels have coordinates):
   - Enable device location (GPS or Network)
   - Switch to a channel with GPS coordinates
   - Should see: City, State, distance with directional arrow (e.g., `â†˜SE 96.7mi (155.6km)`)
   - Direction arrow updates based on your location

3. **Test Zone Management**:
   - Tap ZONE button on main screen
   - Select "All Channels" or a specific zone
   - Edit a channel â†’ Tap Zone row â†’ Create/select zone
   - Verify zone assignment saves and list refreshes

4. **Test Export**:
   - Go to LOCAL tab
   - Tap ðŸ“¤ **EXPORT (OpenGD77)** button  
   - Check `Download/DMR/DMR_Backups/` for CSV files (use any file manager)
   - Should see: Channels, Contacts, TG_Lists, Zones, DTMF CSVs with timestamps

5. **Test Import** (optional):
   - Tap ðŸ“¥ **IMPORT (OpenGD77)** button
   - Select a backup timestamp from list
   - Confirm import
   - Wait for success message
   - Channels will auto-refresh and appear in app

6. **Test Transcription** (if configured):
   - Tap TXT button to enable (turns green)
   - Send or receive a DMR transmission with speech
   - Transcription appears in real-time below the channel info
   - Check `Download/DMR/Audio/[ChannelName]/` for WAV recordings
   - Check `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt` for logs

7. **Test Analog MON Button** (analog channels only):
   - Switch to an analog channel
   - Tap MON button (turns orange)
   - Squelch opens completely - hear all audio continuously
   - Tap again to disable (turns gray)

## Usage

### Using GPS Navigation

1. **Enable Location**:
   - Ensure device location is enabled (GPS or Network)
   - Grant location permissions to PriInterPhone app
   - Channels must have GPS coordinates stored

2. **View Distance & Direction**:
   - Switch to any channel with coordinates
   - Location text shows:
     - Short distances: `â†‘N 250m`
     - Medium distances: `â†’E 5.2km`
     - Long distances: `â†˜SE 96.7mi (155.6km)`
   - Direction arrow points from your location to the channel
   - Updates automatically when switching channels

3. **Location Information**:
   - City, State display via reverse geocoding
   - Elevation in meters and feet
   - Pin icon ðŸ“ indicates GPS data available

### Using Zone Management

1. **Select Active Zone**:
   - Tap **ZONE** button on main screen
   - Select from list (shows channel count per zone)
   - Arrow buttons now filter by selected zone only
   - Button shows current zone: "Zone: Local Pack"

2. **Create New Zone**:
   - Edit any channel (or from zone selector)
   - Tap Zone row in edit screen
   - Scroll to bottom â†’ "Create New Zone..."
   - Enter zone name â†’ Newly created zone auto-selected

3. **Assign Channels to Zones**:
   - Edit channel â†’ Tap Zone row
   - Select zone from list
   - "None" removes from all zones
   - Changes save immediately

4. **Rename Zones**:
   - In zone selector, tap pencil icon (âœ) next to zone name
   - Or long-press zone name
   - Edit name in dialog
   - Zone channels preserved

5. **Import/Export Zones**:
   - Zones automatically included in OpenGD77 export/import
   - Zones.csv file contains zone definitions
   - Compatible with OpenGD77 CPS

### Using Analog MON Button

1. **Enable Monitoring** (analog channels only):
   - Switch to analog channel
   - Tap **MON** button (turns orange)
   - Squelch opens completely - hear ALL audio continuously
   - Perfect for scanning busy frequencies

2. **Disable Monitoring**:
   - Tap **MON** button again (turns gray)
   - Returns to normal squelch based on channel settings

3. **Auto-Reset**:
   - MON automatically resets to OFF when switching channels
   - Prevents accidentally leaving squelch open

### Exporting Channels to OpenGD77

1. Open PriInterPhone app
2. Go to **LOCAL** tab
3. Tap **ðŸ“¤ EXPORT (OpenGD77)** button
4. Export completes (toast shows: "âœ“ Export successful! v1.1\nCheck Download/DMR/DMR_Backups/")
5. Files created in `Download/DMR/DMR_Backups/20260223_140530/` folder containing:
   - Channels.csv, Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv
6. Transfer CSVs to PC via USB, file manager, or `adb pull /sdcard/Download/DMR/ .`
7. Open OpenGD77 CPS
8. Import â†’ Select the folder containing all 5 CSV files
9. Program your OpenGD77 radio!

### Importing Channels from OpenGD77

1. Export channel programming from OpenGD77 CPS (all 5 CSV files)
2. Transfer CSVs to Android device `Download/DMR/DMR_Backups/`
   - Create a folder with any name (e.g., `MyBackup`, `Test`, or timestamp like `20260223_140530`)
   - Place the CSV files inside (OpenGD77 exports them as: `Channels.csv`, `Contacts.csv`, `TG_Lists.csv`, `Zones.csv`, `DTMF.csv`)
   - Via USB cable (MTP mode) or `adb push`
4. Open PriInterPhone app
5. Go to **LOCAL** tab
6. Tap **ðŸ“¥ IMPORT (OpenGD77)** button
7. Select backup folder from dialog (timestamp folders display as formatted dates)
8. Wait for import success notification
9. Channels auto-refresh - ready to use!

### Using Real-time Transcription

1. **Enable Transcription**:
   - Tap **TXT** button on main screen (turns green when enabled)
   - Transcription service automatically starts
   - Ensure `/sdcard/DMR/api_key.txt` contains your OpenAI API key

2. **During Transmissions**:
   - Real-time transcription appears below channel info in borderbox
   - Audio automatically recorded to `Download/DMR/Audio/[ChannelName]/`
   - Transcription appended to `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
   - Last 3-10 messages persist per channel (scroll through history)

3. **File Organization**:
   ```
   Download/DMR/
     Audio/
       Channel_1/
         20260309_143022_CallSign_Name.wav
         20260309_143155_CallSign_Name.wav
       Repeater_2/
         20260309_150330_CallSign_Name.wav
     Transcription/
       Channel_1/
         transcription_20260309.txt
         transcription_20260310.txt
       Repeater_2/
         transcription_20260309.txt
   ```

4. **Transcription Log Format**:
   ```
   [14:30:22] ID: 123456 - This is the first transmission
   [14:31:55] ID: 789012 - Second transmission from different user
   [14:35:10] ID: 123456 - Another message
   ```

5. **Disable Transcription**:
   - Tap TXT button again (turns gray)
   - Transcription service stops
   - Audio recordings will continue if recording is enabled separately

## Project Structure

```
phonedmrapp/
â”œâ”€â”€ originalapk/
â”‚   â””â”€â”€ com.pri.prizeinterphone.apk    # Original system APK (8.1 MB)
â”œâ”€â”€ app/                                # Android Gradle project
â”‚   â”œâ”€â”€ src/main/
â”‚   â”‚   â”œâ”€â”€ java/                       # 280 Java source files (JADX decompiled)
â”‚   â”‚   â”‚   â””â”€â”€ com/pri/prizeinterphone/
â”‚   â”‚   â”‚       â”œâ”€â”€ InterPhoneHomeActivity.java  (Main UI - 567 lines)
â”‚   â”‚   â”‚       â”œâ”€â”€ manager/
â”‚   â”‚   â”‚       â”‚   â”œâ”€â”€ DmrManager.java          (DMR control)
â”‚   â”‚   â”‚       â”‚   â”œâ”€â”€ SerialPort.java          (UART /dev/ttyS1)
â”‚   â”‚   â”‚       â”‚   â””â”€â”€ CmdStateMachine.java     (Protocol)
â”‚   â”‚   â”‚       â””â”€â”€ ... (all DMR implementation)
â”‚   â”‚   â”œâ”€â”€ res/
â”‚   â”‚   â”‚   â”œâ”€â”€ drawable-*/interphone_app_icon.png  (Custom icon, 5 densities)
â”‚   â”‚   â”‚   â””â”€â”€ values/strings.xml                   (MacDMRUlephone name)
â”‚   â”‚   â””â”€â”€ AndroidManifest.xml
â”‚   â””â”€â”€ build.gradle                    # Package: com.pri.prizeinterphone
â”œâ”€â”€ DMRModHooks/                        # LSPosed Xposed Module
â”‚   â”œâ”€â”€ app/src/main/java/com/dmrmod/hooks/
â”‚   â”‚   â”œâ”€â”€ MainHook.java              # Main hook implementation (3300+ lines)
â”‚   â”‚   â”œâ”€â”€ DirectDatabaseExporter.java # OpenGD77 CSV export
â”‚   â”‚   â”œâ”€â”€ CSVExporter.java           # CSV file generation
â”‚   â”‚   â””â”€â”€ DirectDatabaseImporter.java # OpenGD77 CSV import
â”‚   â”œâ”€â”€ build.gradle
â”‚   â””â”€â”€ README.md                       # Module documentation
â”œâ”€â”€ DMRTranscriptionService/            # Speech-to-Text Service
â”‚   â”œâ”€â”€ app/src/main/
â”‚   â”‚   â”œâ”€â”€ java/com/macdmr/transcription/
â”‚   â”‚   â”‚   â””â”€â”€ TranscriptionService.java  # Google Cloud API integration
â”‚   â”‚   â”œâ”€â”€ aidl/com/macdmr/transcription/
â”‚   â”‚   â”‚   â””â”€â”€ ITranscriptionService.aidl # Service interface
â”‚   â”‚   â””â”€â”€ AndroidManifest.xml
â”‚   â”œâ”€â”€ local.properties               # API key (gitignored)
â”‚   â”œâ”€â”€ local.properties.template      # Template for setup
â”‚   â””â”€â”€ build.gradle
â”œâ”€â”€ magisk_module/
â”‚   â””â”€â”€ MacDMRUlephone/
â”‚       â”œâ”€â”€ module.prop                 # Module metadata
â”‚       â”œâ”€â”€ install.sh                  # Installation script
â”‚       â””â”€â”€ system/priv-app/PriInterPhone/
â”‚           â””â”€â”€ PriInterPhone.apk       # Custom APK (7.99 MB)
â”œâ”€â”€ MacDMRUlephone-Magisk.zip          # Packaged module (6.65 MB)
â”œâ”€â”€ icon.jpg                            # Custom icon source (784x1168)
â”œâ”€â”€ MAGISK_SOLUTION.md                  # Magisk implementation guide
â”œâ”€â”€ STATUS.md                           # Complete development timeline
â”œâ”€â”€ QUICK_REFERENCE.md                  # ADB commands & debugging
â””â”€â”€ README.md                           # This file
```

## Development Timeline

### âœ… Phase 1: Decompilation & Build
- Decompiled original APK with JADX â†’ 280 Java source files (complete DMR stack)
- Created Android Gradle project (WSL2, Java 17, Gradle 8.2, AGP 7.4.2)
- Fixed 15+ compilation errors
- Created 10 stub classes for missing ROM APIs
- Resolved 58+ AndroidX resource attribute duplicates
- Built working APK

### âœ… Phase 2: Custom Branding
- Custom app name: MacDMRUlephone
- Custom icon from icon.jpg (all 5 Android densities)
- Package initially rebranded to `.modded` for side-by-side testing
- Resolved 5 manifest conflicts
- Fixed 4 system API compatibility issues

### âœ… Phase 3: GitHub Repository
- Created repository: https://github.com/IIMacGyverII/phonedmrapp
- Removed large files (gradle-8.2-bin.zip, jadx.zip - 197 MB)
- Pushed commit 5456fcac (16,278 files)
- Comprehensive documentation created

### âœ… Phase 4: DMR Hardware Investigation
- **Problem Discovered**: App stuck on "Module Initializing..." dialog
- **Root Cause**: Permission mismatch
  - Original app: userId=1000 (system)
  - Modded app: userId=10198 (user) - NO hardware access
- **Hardware Identified**: DMR module on `/dev/ttyS1` (system:radio permissions)
- **File Sync Issue**: Only 13 Java files in Windows vs 280 in WSL
- **Solution**: Robocopy synced all 280 files (2.36 MB)
- **Rebuild**: APK now contains complete DMR implementation

### âœ… Phase 5: System Access Solution
- **Attempted**: Direct system installation â†’ Failed (production ROM locked)
- **Attempted**: Platform signing â†’ Not viable (no manufacturer key)
- **Solution Found**: Magisk systemless overlay
- **Implementation**: Created Magisk module
  - Reverted package to `com.pri.prizeinterphone`
  - Built APK with custom branding
  - Packaged as Magisk module (6.65 MB)
  - Transferred to device: `/sdcard/Download/MacDMRUlephone-Magisk.zip`

### â³ Phase 6: Deployment (Pending User Action)
- Module ready for installation via Magisk Manager
- Awaiting user to install and reboot
- Will enable full DMR hardware access with custom branding

### âœ… Phase 7: Real-time Speech-to-Text Transcription (v1.2 - v1.5)
- **Problem**: Need speech-to-text for DMR transmissions
- **Attempted**: ONNX Whisper Base model â†’ Failed (decoder token 0 issue, 155 MB removed)
- **Attempted**: Android SpeechRecognizer API â†’ Failed (device blocks third-party access, error 10)
- **Attempted**: LSPosed hooks to bypass restrictions â†’ Failed (system blocks at validation layer below hooks)
- **Solution Found**: Google Cloud Speech-to-Text API (bypasses all device restrictions)
- **Implementation**:
  - Created standalone TranscriptionService APK with AIDL interface
  - Integrated OkHttp for HTTP requests with 30-second timeouts
  - PCM to WAV conversion with proper 44-byte header
  - Base64 encoding for Google Cloud API
  - JSON request/response handling with error recovery
  - Network connectivity checking
  - Secured API key in gitignored local.properties
- **File Organization**:
  - Audio recordings organized by channel: `Download/DMR/Audio/[ChannelName]/`
  - Daily transcription logs by channel: `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
  - Running log format: `[HH:MM:SS] ID: DMRID - Transcription text`
- **Status**: âœ… Successfully transcribing real DMR audio in production

## Technical Details

### Build Environment
- **Platform**: WSL2 Ubuntu 22.04 + Windows 11
- **Java**: OpenJDK 17.0.18
- **Android SDK**: compileSdk 34, minSdk 24, targetSdk 34
- **Gradle**: 8.2, AGP 7.4.2/8.1.0
- **Tools**: JADX 1.4.7, ImageMagick, ADB
- **Device**: 5006AF1020002922 (production ROM, Magisk installed)

### Transcription Architecture
- **Service**: Standalone AIDL service (com.macdmr.transcription)
- **API**: Google Cloud Speech-to-Text v1
- **HTTP Client**: OkHttp 4.12.0 with 30-second timeouts
- **Audio Format**: PCM 16-bit mono â†’ WAV with proper header â†’ Base64
- **Network**: Connectivity checking with ACCESS_NETWORK_STATE permission
- **Security**: API key in gitignored local.properties, injected via BuildConfig
- **Error Handling**: Comprehensive logging, network error recovery, API error detection
- **Storage**: Channel-organized folders for audio and transcription logs

### System API Fixes Implemented
1. **Background Service Restriction**: Disabled auto-start from Application.onCreate()
2. **WindowManager API**: Stubbed setDefaultDisplay() (system-only API)
3. **NVRAM Access**: Created stub for vendor-specific NvramUtils
4. **PCM Audio Manager**: Wrapped vendor-specific callbacks in try-catch

### DMR Implementation
- **Serial Port**: `/dev/ttyS1` (115200 baud, binary protocol)
- **Core Classes**: DmrManager, SerialPort, CmdStateMachine, PCMReceiveManager
- **Protocol Stack**: Complete implementation (280 Java files, ~45,000 lines)
- **Audio Pipeline**: Recording, codec, playback
- **Features**: Talkback, channels, contacts, messaging, settings

## Documentation

- **[MAGISK_SOLUTION.md](MAGISK_SOLUTION.md)**: Complete Magisk module guide with troubleshooting
- **[STATUS.md](STATUS.md)**: Full development timeline and technical achievements
- **[SUCCESS_REPORT.md](SUCCESS_REPORT.md)**: Initial build success documentation
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**: ADB commands and debugging tips
- **[JADX_DECOMPILATION_ERRORS.md](JADX_DECOMPILATION_ERRORS.md)**: Known JADX limitations

## GitHub Repository

**Repository**: https://github.com/IIMacGyverII/phonedmrapp  
**Latest Commit**: 5456fcac  
**Total Files**: 16,278 files committed  
**Status**: All source code available online

## Next Steps

1. **User Action Required**: Install Magisk module on device and reboot
2. **Testing**: Verify DMR hardware initialization and radio functionality
3. **Documentation**: Update with test results and user guide

## Future Plans

### Enhanced Transcription Features
- **Multi-language support**: Configure language per-channel
- **Custom vocabulary**: Add DMR-specific terms and callsigns
- **Offline transcription**: Explore local models for privacy/cost reduction
- **Voice commands**: Control radio functions via speech recognition

### Expanded DMR Functionality
- **Real-time Contact Display**: Enhanced live DMR contact receive display
- **Enhanced UI Integration**: Improved display of current DMR contact name, ID, and call status
- **Call logging**: Track incoming/outgoing DMR calls with detailed timestamps and durations
- **Statistics dashboard**: Visualize usage patterns and contact activity

### Tier 2 Support
- **Attempt Tier 2 Implementation**: Investigate and implement advanced DMR Tier 2 features
- **Enhanced talkgroup support**: Multi-talkgroup scanning and monitoring
- **IP connectivity**: Explore DMR network connectivity options

### Global DMR Database Integration
- **RadioID.net Integration**: Add ability to download and sync global DMR contact database
- **Automatic Updates**: Periodic contact database refresh from radioid.net
- **Smart Contact Resolution**: Automatically resolve DMR IDs to callsigns and names
- **Offline Database**: Local caching for fast lookups without internet connection

### The Sky's the Limit
With LSPosed runtime hooks and full access to the platform-signed app, **anything is possible**:
- Custom UI themes and branding
- Advanced automation and scripting
- Integration with external services and APIs
- Community-driven feature development
- Enhanced radio control and monitoring

**Last Updated**: March 9, 2026  
**Current Version**: v3.0.9 - GPS Distance Enhancements  
**Major Release**: v3.0.8 - Zone Management  
**Feature Release**: v3.0.5 - Channel Zones  
**Base Release**: v1.7.0 - Transcription & API Features  
**Status**: LSPosed module fully operational - All features working perfectly!  
**GitHub**: https://github.com/IIMacGyverII/phonedmrapp

### Version History Overview

**v3.0.x Series** (Current): Advanced Features
- âœ… GPS navigation with directional arrows and bearing
- âœ… Zone management (create, edit, assign)
- âœ… Analog MON button for continuous monitoring

**v1.x Series** (Stable Base): Core Features
- âœ… OpenGD77 CSV export/import
- âœ… Real-time speech-to-text transcription
- âœ… Location tracking and RSSI display
- âœ… Audio recording and logging

**v2.x Series** (Planned): DMR Enhancements
- â³ DMR group calling improvements
- â³ DMR monitoring mode
- ðŸ”¬ Requires extensive hardware-level debugging

For detailed technical information, see [DMRModHooks/README.md](DMRModHooks/README.md), [MAGISK_SOLUTION.md](MAGISK_SOLUTION.md), and [STATUS.md](STATUS.md).

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

> **Disclaimer**: This tool hooks into the PriInterPhone app at runtime using LSPosed/Xposed. It does NOT modify or redistribute any proprietary code from Ulefone. Users must legally own the PriInterPhone app. For personal, educational, and interoperability purposes only.

