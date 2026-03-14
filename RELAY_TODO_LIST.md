# Relay/Repeater Implementation TODO List

**Project:** DMR Radio Relay Feature Integration  
**Priority:** Medium-High  
**Estimated Total Effort:** 8-15 hours  
**Status:** ✅ Analysis Complete, Implementation Pending

---

## ✅ Phase 0: Research & Analysis (COMPLETE)

- [x] Locate RelayMessage protocol implementation
- [x] Analyze DmrManager.relayCommand() method
- [x] Identify channel relay field locations
- [x] Review error handling mechanisms
- [x] Document state machine integration
- [x] Verify existing custom app support
- [x] Write comprehensive analysis document

**Result:** Feature is fully functional in original APK, ready for custom app integration.

---

## 🚀 Phase 1: Basic Integration (HIGH PRIORITY)

### 1.1: Add Relay Toggle to Custom App UI
**Status:** ⏳ TODO  
**Effort:** 2-3 hours  
**Priority:** HIGH  
**Dependencies:** None

**Tasks:**
- [ ] Design relay toggle layout
  - [ ] Add Switch widget to channel settings UI
  - [ ] Add "Relay Mode" label
  - [ ] Position near power/squelch settings
  
- [ ] Implement toggle logic
  - [ ] Read current relay state from channel
  - [ ] Update channel relay field on toggle
  - [ ] Call `dmrManager.relayCommand()` on change
  
- [ ] Add persistence
  - [ ] Save relay state to channel database
  - [ ] Load relay state on channel switch
  - [ ] Verify state survives app restart

**Code Location:** `MainHook.java` (channel settings hook)

**Acceptance Criteria:**
- [ ] Toggle visible in channel settings
- [ ] Toggle reflects current relay state
- [ ] Changes applied immediately to hardware
- [ ] Changes persist across channel switches
- [ ] Changes survive app restart

**Testing:**
- [ ] UI test: Toggle updates visually
- [ ] Database test: State persists
- [ ] Hardware test: Relay command sent to radio
- [ ] Integration test: Works with existing channels

---

### 1.2: Implement Relay Command Logging
**Status:** ⏳ TODO  
**Effort:** 1 hour  
**Priority:** HIGH  
**Dependencies:** None

**Tasks:**
- [ ] Hook `DmrManager.relayCommand()`
  - [ ] Log relay value being sent
  - [ ] Log timestamp
  - [ ] Log channel name/ID
  
- [ ] Hook RelayMessage send
  - [ ] Log packet contents
  - [ ] Log serial write confirmation
  
- [ ] Hook error handler
  - [ ] Log RELAY_ACTIVITY_TIME_OUT (0x6)
  - [ ] Log MSG_RELAY_CONNECTION_FAILED (0x7e4)
  - [ ] Log timeout duration

**Code Location:** `MainHook.java` (method hooks)

**Acceptance Criteria:**
- [ ] Relay commands logged to logcat
- [ ] Error timeouts logged
- [ ] Logs include context (channel, value)
- [ ] No performance impact

**Testing:**
- [ ] Enable relay, verify log entry
- [ ] Disable relay, verify log entry
- [ ] Trigger timeout, verify error log
- [ ] Check log format readability

---

### 1.3: Add Relay Status Indicator
**Status:** ⏳ TODO  
**Effort:** 2-3 hours  
**Priority:** MEDIUM  
**Dependencies:** 1.1, 1.2

**Tasks:**
- [ ] Add status indicator to main screen
  - [ ] TextView showing relay status
  - [ ] Color-coded (gray=off, green=active, red=error)
  - [ ] Icon (optional)
  
- [ ] Implement status tracking
  - [ ] Track relay state changes
  - [ ] Detect connection failures
  - [ ] Update indicator in real-time
  
- [ ] Add status logic
  - [ ] OFF: relay=0
  - [ ] ACTIVE: relay=1, no errors
  - [ ] ERROR: timeout detected
  - [ ] CONNECTING: transitional state (if detectable)

**Code Location:** `MainHook.java` (main screen hook)

**Acceptance Criteria:**
- [ ] Indicator visible on main screen
- [ ] Shows correct status
- [ ] Updates when relay state changes
- [ ] Color matches status
- [ ] Doesn't clutter UI

**Testing:**
- [ ] Disable relay, verify "OFF" shown
- [ ] Enable relay, verify "ACTIVE" shown
- [ ] Trigger timeout, verify "ERROR" shown
- [ ] Visual inspection of colors

---

## 🎯 Phase 2: Advanced Features (MEDIUM PRIORITY)

### 2.1: Per-Channel Relay Presets
**Status:** ⏳ TODO  
**Effort:** 3-4 hours  
**Priority:** MEDIUM  
**Dependencies:** 1.1

**Tasks:**
- [ ] Auto-apply relay on channel switch
  - [ ] Read relay field when loading channel
  - [ ] Auto-call relayCommand() if relay=1
  - [ ] Log auto-enable events
  
- [ ] Enhance CSV importer
  - [ ] Add "relay" column support
  - [ ] Default to 0 if missing
  - [ ] Validate values (0/1/2)
  
- [ ] Enhance database importer
  - [ ] Add relay to import logic
  - [ ] Support preset relay channels
  
- [ ] Add channel list indicator
  - [ ] Show relay icon in channel list
  - [ ] Filter channels by relay status (optional)

**Code Location:**  
- `MainHook.java` (channel switcher)
- `CSVImporter.java`
- `DirectDatabaseImporter.java`

**Acceptance Criteria:**
- [ ] Relay auto-enables on channel switch
- [ ] CSV import includes relay column
- [ ] Database import includes relay
- [ ] Channel list shows relay indicator

**Testing:**
- [ ] Switch to relay channel, verify auto-enable
- [ ] Switch to non-relay channel, verify disabled
- [ ] Import CSV with relay column
- [ ] Visual check channel list indicator

---

### 2.2: Relay Error Notifications
**Status:** ⏳ TODO  
**Effort:** 1-2 hours  
**Priority:** MEDIUM  
**Dependencies:** 1.2

**Tasks:**
- [ ] Hook RelayConnectionFailedState
  - [ ] Detect entry to error state
  - [ ] Show custom toast message
  - [ ] Log error details
  
- [ ] Add user-facing error messages
  - [ ] "Relay connection failed"
  - [ ] "Check repeater settings"
  - [ ] "Timeout after X seconds"
  
- [ ] Optional: Retry logic
  - [ ] Ask user to retry
  - [ ] Auto-retry after delay (optional)
  - [ ] Max retry attempts

**Code Location:** `MainHook.java` (state machine hooks)

**Acceptance Criteria:**
- [ ] Error toast shown on timeout
- [ ] Error message is clear
- [ ] User informed of issue
- [ ] No crashes on error

**Testing:**
- [ ] Enable relay with no repeater
- [ ] Verify error toast
- [ ] Check message clarity
- [ ] Verify no crash

---

### 2.3: Relay Mode Selection (Dropdown)
**Status:** ⏳ TODO  
**Effort:** 3-5 hours  
**Priority:** LOW  
**Dependencies:** 1.1, Hardware testing

**Tasks:**
- [ ] Research relay=2 mode
  - [ ] Hardware test with value 2
  - [ ] Document behavior differences
  - [ ] Determine valid use cases
  
- [ ] Replace toggle with dropdown
  - [ ] Options: Disabled / Node / Repeater
  - [ ] Map to values 0/1/2
  - [ ] Update UI accordingly
  
- [ ] Add mode descriptions
  - [ ] Tooltip/help text
  - [ ] Explain each mode
  - [ ] When to use each

**Code Location:** `MainHook.java` (channel settings)

**Acceptance Criteria:**
- [ ] Dropdown shows 3 modes
- [ ] Each mode tested on hardware
- [ ] Behavior documented
- [ ] User guide updated

**Testing:**
- [ ] Test mode 0 (known: disabled)
- [ ] Test mode 1 (known: enabled)
- [ ] Test mode 2 (unknown: requires hardware)
- [ ] Document findings

---

## 🧪 Phase 3: Hardware Testing (ONGOING)

### ⚠️ 3.0: CRITICAL - Determine Client vs Relay Node Mode
**Status:** ⏳ TODO  
**Effort:** 1-2 hours  
**Priority:** CRITICAL - DO THIS FIRST  
**Dependencies:** 1.1, 1.2  
**Required Equipment:** 1-3 radios, optional spectrum analyzer

**⚠️ THIS MUST BE DONE BEFORE OTHER TESTING**

**Purpose:** Determine if relay mode means:
- **Option A:** Connect TO a repeater (client mode)
- **Option B:** Act AS a relay node (mesh forwarding)

This fundamentally changes how we document, implement, and test the feature.

**Test Cases:**

#### Test 0A: Timeout Without Repeater (HIGHEST PRIORITY)
- [ ] Find location with NO repeater coverage
- [ ] Set channel relay=0, transmit
- [ ] Verify transmission works (baseline)
- [ ] Set channel relay=1
- [ ] Attempt to transmit
- [ ] Wait for timeout (if occurs)
- [ ] Record timeout duration: _____ seconds
- [ ] Record error message: ________________
- [ ] **Result A:** Timeout occurs → CLIENT MODE
- [ ] **Result B:** No timeout, works normally → RELAY NODE MODE
- [ ] **Conclusion:** ________________

#### Test 0B: Frequency Offset Detection
- [ ] Set channel to known frequency (e.g., 446.0000 MHz)
- [ ] Set relay=0
- [ ] Transmit, monitor TX frequency
- [ ] Record frequency with relay=0: _______ MHz
- [ ] Set relay=1
- [ ] Transmit, monitor TX frequency
- [ ] Record frequency with relay=1: _______ MHz
- [ ] Calculate offset: _______ MHz
- [ ] **Result A:** Frequency changes → CLIENT MODE (repeater offset)
- [ ] **Result B:** Same frequency → RELAY NODE MODE or needs config
- [ ] **Conclusion:** ________________

#### Test 0C: Packet Forwarding Test (if 3 radios available)
- [ ] Position Radio A with relay=1 in middle
- [ ] Position Radio B and C out of each other's range
- [ ] Verify B cannot reach C directly (test transmission)
- [ ] Verify B can reach A and A can reach C
- [ ] Radio B transmits to Radio C
- [ ] Record: Did C receive transmission? ___
- [ ] **Result A:** C did NOT receive → CLIENT MODE
- [ ] **Result B:** C DID receive → RELAY NODE MODE (A forwarded)
- [ ] **Conclusion:** ________________

#### Test 0D: UI String Interpretation
- [ ] Review UI: "Relay disconnection" + Enable/Disable
- [ ] Review Chinese: "中继脱网"
- [ ] Ask native speaker interpretation (if possible)
- [ ] Does "Enable relay disconnection" mean:
  - [ ] Enable connecting to repeater?
  - [ ] Enable the ability to drop from relay duty?
  - [ ] Something else: ________________
- [ ] **Conclusion:** ________________

**Final Determination:**
- [ ] Mode confirmed: ☐ Client Mode ☐ Relay Node Mode ☐ Hybrid/Unclear
- [ ] Confidence level: ☐ High ☐ Medium ☐ Low
- [ ] Update all docs with findings: ☐ Done
- [ ] Adjust test plan based on result: ☐ Done
- [ ] Adjust UI design based on result: ☐ Done

**Impact on remaining work:**
- If CLIENT MODE: Focus on repeater connection, frequency offsets, coverage
- If RELAY NODE MODE: Focus on mesh topology, packet forwarding, multi-hop
- Update user guide accordingly
- Revise implementation plan if needed

---

### 3.1: Basic Relay Testing
**Status:** ⏳ TODO  
**Effort:** 2-4 hours  
**Priority:** HIGH  
**Dependencies:** 1.1, 1.2, **3.0 MUST BE DONE FIRST**  
**Required Equipment:** 2 radios

**⚠️ Do not proceed until Test 3.0 is complete and mode is confirmed**

**Test Cases:**

#### Test 1: Enable/Disable Basic
- [ ] Start with relay disabled
- [ ] Enable relay via toggle
- [ ] Verify hardware responds (LED? sound?)
- [ ] Disable relay
- [ ] Verify hardware disables
- [ ] Check logs for errors

#### Test 2: Channel Switching
- [ ] Set relay=1 on channel 1
- [ ] Set relay=0 on channel 2
- [ ] Switch to channel 1
- [ ] Verify relay enabled
- [ ] Switch to channel 2
- [ ] Verify relay disabled

#### Test 3: Persistence
- [ ] Enable relay on channel
- [ ] Close app
- [ ] Reopen app
- [ ] Switch to channel
- [ ] Verify relay state preserved

**Results:** (to be filled during testing)

---

### 3.2: Timeout Testing
**Status:** ⏳ TODO  
**Effort:** 2-3 hours  
**Priority:** HIGH  
**Dependencies:** 1.1, 1.2  
**Required Equipment:** 1 radio (no repeater)

**Test Cases:**

#### Test 1: Timeout Trigger
- [ ] Enable relay with no repeater present
- [ ] Start timer
- [ ] Wait for timeout
- [ ] Record timeout duration: _____ seconds
- [ ] Verify error toast shown
- [ ] Verify state returns to idle
- [ ] Check logs for error code 0x6

#### Test 2: Timeout Recovery
- [ ] Trigger timeout
- [ ] Wait for recovery
- [ ] Try enabling relay again
- [ ] Verify second attempt works

#### Test 3: Rapid Toggle
- [ ] Enable relay
- [ ] Immediately disable
- [ ] Enable again
- [ ] Verify no crashes
- [ ] Verify hardware responds

**Results:** (to be filled during testing)

---

### 3.3: Repeater Connection Testing
**Status:** ⏳ TODO  
**Effort:** 4-6 hours  
**Priority:** MEDIUM  
**Dependencies:** 1.1, 3.1, Access to repeater  
**Required Equipment:** 2-3 radios, repeater access

**Test Cases:**

#### Test 1: Successful Connection
- [ ] Configure channel for repeater frequency
- [ ] Enable relay mode
- [ ] Verify connection established
- [ ] Verify no timeout error
- [ ] Transmit through repeater
- [ ] Verify reception on other radio
- [ ] Measure latency: _____ ms

#### Test 2: Wrong Frequency
- [ ] Set channel to wrong frequency
- [ ] Enable relay
- [ ] Verify timeout occurs
- [ ] Verify error shown

#### Test 3: Range Test
- [ ] Baseline: Direct radio-to-radio range with relay=0
  - Distance: _____ meters
- [ ] Repeater: Range with relay=1
  - Distance: _____ meters
- [ ] Calculate improvement: _____x

**Results:** (to be filled during testing)

---

### 3.4: Relay Mode 2 Investigation
**Status:** ⏳ TODO  
**Effort:** 2-4 hours  
**Priority:** LOW  
**Dependencies:** 1.1, 3.1  
**Required Equipment:** 2 radios

**Research Questions:**

1. **What does relay=2 do?**
   - [ ] Set relay=2 on channel
   - [ ] Transmit, observe behavior
   - [ ] Compare to relay=1
   - [ ] Document differences
   - Findings: ___________________

2. **Does it change frequency offset?**
   - [ ] Monitor frequency when relay=0
   - [ ] Monitor frequency when relay=1
   - [ ] Monitor frequency when relay=2
   - [ ] Compare results
   - Findings: ___________________

3. **Does it affect power?**
   - [ ] Measure power output relay=0
   - [ ] Measure power output relay=1
   - [ ] Measure power output relay=2
   - [ ] Compare results
   - Findings: ___________________

4. **Is there a status query?**
   - [ ] Enable relay
   - [ ] Monitor all incoming messages
   - [ ] Look for relay status responses
   - [ ] Document any found
   - Findings: ___________________

**Results:** (to be filled during testing)

---

## 📚 Phase 4: Documentation (ONGOING)

### 4.1: Technical Protocol Documentation
**Status:** ⏳ TODO  
**Effort:** 2-3 hours  
**Priority:** MEDIUM  
**Dependencies:** 3.1, 3.2, 3.3

**Deliverables:**
- [ ] Relay protocol specification
  - [ ] Command format (0x33)
  - [ ] Payload structure
  - [ ] Response format (if any)
  
- [ ] Packet captures
  - [ ] Relay enable packet
  - [ ] Relay disable packet
  - [ ] Timeout error packet
  - [ ] Success indication (if any)
  
- [ ] Timing measurements
  - [ ] Command latency
  - [ ] Timeout duration
  - [ ] Retry intervals
  
- [ ] Example code
  - [ ] How to enable relay
  - [ ] How to handle errors
  - [ ] How to query status

**Output File:** `RELAY_PROTOCOL_SPEC.md`

---

### 4.2: User Guide
**Status:** ⏳ TODO  
**Effort:** 1-2 hours  
**Priority:** LOW  
**Dependencies:** 4.1, Testing complete

**Sections:**
- [ ] Introduction
  - What is relay mode?
  - When to use it?
  - Benefits and limitations
  
- [ ] Configuration Guide
  - How to enable relay on channel
  - How to configure repeater settings
  - Recommended settings
  
- [ ] Troubleshooting
  - "Relay unable to connect" error
  - Timeout issues
  - Range problems
  - Audio issues through repeater
  
- [ ] Best Practices
  - Simplex vs repeater operation
  - When to use relay mode
  - Power management
  - Antenna considerations
  
- [ ] Examples
  - Hilltop relay setup
  - Mobile repeater connection
  - Multi-hop relay network

**Output File:** `RELAY_USER_GUIDE.md`

---

### 4.3: Code Documentation
**Status:** ⏳ TODO  
**Effort:** 1 hour  
**Priority:** LOW  
**Dependencies:** 1.1, 1.2, 1.3

**Tasks:**
- [ ] Add inline comments to relay code
- [ ] Document hook points
- [ ] Document relay field usage
- [ ] Add Javadoc comments
- [ ] Update README with relay info

**Files to Document:**
- `MainHook.java` (relay toggle, logging)
- `CSVImporter.java` (relay import)
- `DirectDatabaseImporter.java` (relay import)

---

## 🛡️ Phase 5: Safety & Error Handling (ONGOING)

### 5.1: Input Validation
**Status:** ⏳ TODO  
**Effort:** 1 hour  
**Priority:** HIGH  
**Dependencies:** 1.1

**Tasks:**
- [ ] Validate relay values
  - [ ] Only allow 0, 1, 2
  - [ ] Reject invalid values
  - [ ] Log validation failures
  
- [ ] Validate state transitions
  - [ ] Don't enable during TX
  - [ ] Don't change during RX
  - [ ] Safe shutdown handling
  
- [ ] Add error recovery
  - [ ] Reset to safe state on error
  - [ ] Don't leave radio in bad state
  - [ ] Clear error flags

**Code Location:** `MainHook.java` (validation logic)

**Acceptance Criteria:**
- [ ] Invalid values rejected
- [ ] State transitions safe
- [ ] No crashes on invalid input
- [ ] Radio recovers from errors

---

### 5.2: Crash Prevention
**Status:** ⏳ TODO  
**Effort:** 1 hour  
**Priority:** HIGH  
**Dependencies:** 1.1, 1.2

**Tasks:**
- [ ] Add try-catch around relay code
- [ ] Handle null channels gracefully
- [ ] Handle missing methods (old firmware)
- [ ] Log exceptions properly
- [ ] Fail safe (default to disabled)

**Code Location:** `MainHook.java` (error handling)

**Acceptance Criteria:**
- [ ] No crashes on errors
- [ ] Graceful degradation
- [ ] User informed of issues
- [ ] Safe default behavior

---

## 📊 Progress Tracking

### Overall Status

**Phase 1: Basic Integration**
- Progress: 0/3 tasks complete (0%)
- Status: ⏳ Not Started
- Blocking: No
- ETA: After analysis review

**Phase 2: Advanced Features**
- Progress: 0/3 tasks complete (0%)
- Status: ⏳ Not Started
- Blocking: Phase 1
- ETA: After Phase 1

**Phase 3: Hardware Testing**
- Progress: 0/4 tasks complete (0%)
- Status: ⏳ Not Started
- Blocking: Phase 1
- ETA: After basic UI works

**Phase 4: Documentation**
- Progress: 0/3 tasks complete (0%)
- Status: ⏳ Not Started
- Blocking: Testing
- ETA: After testing complete

**Phase 5: Safety**
- Progress: 0/2 tasks complete (0%)
- Status: ⏳ Not Started
- Blocking: No
- ETA: Parallel with Phase 1

---

## 🎯 Next Steps (Recommended Priority Order)

### 🚨 CRITICAL PATH (Must Do First)
1. **Implement relay toggle UI** (1.1) - Need this to test
2. **Add command logging** (1.2) - Need this to observe behavior  
3. **⚠️ DETERMINE CLIENT vs RELAY NODE MODE** (3.0) - CRITICAL BLOCKER
   - This changes EVERYTHING
   - Must be done before other hardware tests
   - Affects documentation, UI design, user expectations

### 📋 After Mode Determined
4. **Update docs with findings** - Revise analysis based on 3.0 results
5. **Hardware basic testing** (3.1) - Now we know what to test
6. **Add status indicator** (1.3) - Design based on confirmed mode
7. **Error notifications** (2.2) - Tailor to confirmed behavior
8. **Timeout testing** (3.2) - (Skip if Relay Node Mode)
9. **Per-channel presets** (2.1) - Label correctly based on mode
10. **Protocol documentation** (4.1) - Document actual behavior
11. **Investigate mode 2** (3.4) - Context-dependent on mode
12. **User guide** (4.2) - Write for confirmed mode

---

## 📋 Definition of Done

**For this feature to be considered "complete":**

- [x] Analysis complete and documented
- [ ] UI toggle implemented and tested
- [ ] Logging implemented
- [ ] Basic hardware testing passed
- [ ] Error handling implemented
- [ ] Documentation written
- [ ] Code reviewed
- [ ] User guide created
- [ ] All test cases passed
- [ ] No known bugs

---

## 🔗 Related Documents

- `RELAY_REPEATER_ANALYSIS.md` - Complete technical analysis
- `APRS_COMPLETE_SYSTEM_SUMMARY.md` - APRS feature (for comparison)
- `DMR_FIRMWARE_PROJECT_STATUS.md` - Overall project status

---

**Last Updated:** 2026-01-15  
**Next Review:** After Phase 1 complete  
**Owner:** TBD
