# 08 — DMRModHooks core: `MainHook.java` bootstrap, state, UI injection, squelch, caller ID, DmrManager, serial, zones, channel editor

**Scope.** The LSPosed module `com.dmrmod.hooks` (`DMRModHooks/app`) hooks the OEM PriInterPhone app (`com.pri.prizeinterphone`) at runtime. Almost all of it lives in one 16,306-line class, `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java` (hereafter `MainHook.java`). This chapter covers the *core*: packaging and bootstrap, the static state registry, the theme and UI injection on the main screens, the audio-pipeline/software-squelch hook, caller identification and per-channel history, RSSI, module status, the `DmrManager`/message hooks, UART logging, zones and channel navigation, and the channel-editor hooks. The monitoring modes (APRS/SSTV/NOAA/VFO), recording/transcription, codeplug import/export and the DSP decoders are documented in their own chapters and appear here only where they touch the core.

OEM sources cited below live under `app/src/main/java/com/pri/prizeinterphone/` (hereafter `OEM/`).

---

## Source map of `MainHook.java`

| Lines (approx.) | Contents | Owner |
|---|---|---|
| 1–62 | Imports (Xposed API 82, AIDL `ITranscriptionService`, JSON, IO) | core |
| 63–93 | Class Javadoc: architecture, feature phases | core |
| 92–306 | **All static state fields** (see §2) | core |
| 311–324 | `isAPRSChannel(Object)` — hides temp `"APRS ("`-prefixed hijack channels from lists | core |
| 326–416 | `handleLoadPackage` — hook registration (see §1) | core |
| 418–449 | `GPS_PATTERN` regex + `extractLatLon` | core |
| 451–498 | `hookBottomNavBar` | core |
| 500–592 | `applyBottomNavStyle` | core |
| 594–702 | `hookMessageDisplay` (GPS hyperlinking in DMR SMS) | core |
| 714–894 | `hookSpeechRecognizer` (never registered — legacy research) | transcription |
| 896–952 | `hookSystemRecognitionService` (never registered) | transcription |
| 954–1025 | `hookApplication` | core |
| 1030–1218 | `hookMainActivity` | core |
| 1222–3160 | **`hookTalkBackFragment`** (intercom page: `initView`, `updateUI`, `setTalkbackRecordBg`, `updateChannelNumber`) | core |
| 3165–3604 | Location helpers: `findLocationTextView`, `updateLocationDisplay`, `formatDistance`, `fetchAndDisplayElevation`, `getElevation`, `calculateDistance`, `calculateBearing`, `getDirectionArrow`, `getCurrentLocation` | core |
| 3609–3768 | `hookInformationActivity` | core |
| 3770–3950 | `hookUpdateFirmwareActivity` (commented out, disabled 2026-03-09) | firmware (dead) |
| 3952–4222 | `hookLocalFragment`, `addBackupButtonToFragment`, `findViewGroupInHierarchy`, `addButtonToLayout` | core / backup |
| 4227–5624 | APRS dialogs, live screen, `startAPRSMonitoring`/`stopAPRSMonitoring`, `createAPRSChannelIfNeeded` | APRS |
| 5626–6783 | SSTV dialogs, live screen, `startSSTVMonitoring`/`stopSSTVMonitoring` | SSTV |
| 6785–6925 | APRS channel backup file save/load/restore | APRS |
| 6927–7338 | SSTV channel backup + `checkAndRestoreSSTVChannelOnStartup`, `checkAndRestoreAPRSChannelOnStartup` | SSTV/APRS |
| 7340–8322 | NOAA dialogs, live screen, start/stop, backup, `checkAndRestoreNOAAChannelOnStartup` | NOAA |
| 8324–8447 | `addBackupButton`, `findButtonParentLayout`, `findExitButtonIndex` (legacy, unused) | core |
| 8452–8644 | `hookModuleStatusHandler` | core |
| 8649–8798 | `hookDigitalAudioHandler` | core |
| 8803–8840 | `queryCallerInfo`, `queryRssi` | core |
| 8845–9264 | `updateCallerInfoAsync`, `CallerDisplayInfo`, lookups (`lookupPersonalContactName`, `lookupCallerDisplayInfo`, `lookupContactName`, `formatDmrHistoryLabel`), caller-panel builders, `updateCallerDisplay` ×2, `getAppContextFromClassLoader` | core |
| 9269–9410 | `clearCallerDisplay`, `updateActivityIndicator`, `clearActivityIndicator`, `updateHistoryHeader` | core |
| 9414–9607 | `loadChannelHistory`, `saveChannelHistoryEntry` (`dmrmod_history.db`) | core |
| 9612–9646 | `bytesToHex`, `openBackupActivity` (unused) | core |
| 9651–9924 | `startRecording`, `stopRecording`, `convertPCMtoMP3`, `convertPCMtoWAV`, byte helpers | recording |
| 9926–10112 | **`hookPCMReceiveManager`** (audio pipeline + software squelch) | core |
| 10117–10459 | `updateRssiDisplay`, `hideRssiDisplay`, `calculateAudioAmplitude`, `getAudioSquelchThreshold` ×2, `getRssiThreshold`, `querySignalStrength`, `updateSquelchStatus`, `enableSoftwareSquelchOnCurrentChannel`, `disableSoftwareSquelchOnCurrentChannel` | core |
| 10464–10515 | `hookSignalMessageHandler` (RSSI) | core |
| 10521–10860 | `hookDmrManager` (+ `DigitalMessage.encodeBody`, `AnalogMessage.encodeBody`, `BaseMessage.send`) | core |
| 10865–11568 | Transcription IPC bind, audio buffering (transcription + APRS), `processAPRSBuffer`, `resample16to48`, `processTranscription`, API-key file/dialog, transcription display/history/file | transcription / APRS |
| 11570–11637 | `hookSerialCommunication` | core |
| 11643–11798 | `logPacketData`, `getCmdName` | core |
| 11809–11858 | `testBootloaderAccess` (disabled) | firmware (dead) |
| 11865–11971 | `registerDebugPacketReceiver`, `handleDebugPacket`, `hexStringToByteArray` | core |
| 11976–12161 | `showZoneSelectionDialog(Context)` (intercom variant) | core |
| 12166–12378 | `hookChannelNavigation` (+ `ReceiveSoundState.processMessage`, **the real `sendAnalogMessage` sq=0 hook**) | core |
| 12383–12625 | `hookChannelListFilter` | core |
| 12630–12759 | `hookChannelListUI` | core |
| 12764–12832 | `showZoneSelectionDialog(Context, Button, Object)` (channel-page variant) | core |
| 12837–12866 | `findRadioGroupInView`, `logViewHierarchy` (debug helpers) | core |
| 12868–13258 | **Un-named region A — TG-list dialogs**: `showChannelEditTGListDialog`, `showCreateTGListDialog`, `showTGListEditorDialog`, `refreshGroupGrid` | core (channel editor) |
| 13260–13544 | **Un-named region B — Zone dialogs for the editor**: `showChannelEditZoneDialog`, `showCreateZoneDialog`, `showEditZoneNameDialog` | core (channel editor) |
| 13549–13936 | `addChannelPropertyHelpIcons` | core |
| 13941–14604 | `hookChannelEditActivity` (+ `ChannelData()` ctor hook, `saveChannelData` hook) | core |
| 14611–15928 | VFO: `showVFODialog`, `showVFOControlDialog`, `applyVFOChanges`, `startVFOMode`, `stopVFOMode`, backup/restore, `sendVFOChannelToHardware` | VFO |
| 15930–16032 | `disableBottomNavigation`, `enableBottomNavigation` | core |
| 16034–16180 | `determineBand`, `checkAndRestoreVFOChannelOnStartup` | VFO |
| 16182–16228 | `hookGenericActivityBackgrounds` | core |
| 16230–16306 | `hookOtherFragmentBackgrounds` | core |

---

## 1. Module packaging & bootstrap

### 1.1 Manifest, scope, entry point

| Item | Value | Source |
|---|---|---|
| Package / applicationId | `com.dmrmod.hooks` | `DMRModHooks/app/src/main/AndroidManifest.xml:3`, `build.gradle:10` |
| `xposedmodule` | `true` | `AndroidManifest.xml:24` |
| `xposeddescription` | "Comprehensive modifications for PriInterPhone DMR app" | `AndroidManifest.xml:27` |
| `xposedminversion` | `93` | `AndroidManifest.xml:30` |
| `xposedscope` | `@array/xposed_scope` → `com.pri.prizeinterphone` | `AndroidManifest.xml:33`, `res/values/strings.xml:7-9` |
| Entry class | `com.dmrmod.hooks.MainHook` | `assets/xposed_init:1` |
| Permissions | WRITE/READ_EXTERNAL_STORAGE, INTERNET, ACCESS_NETWORK_STATE, ACCESS_FINE/COARSE_LOCATION | `AndroidManifest.xml:6-15` |
| Own activities | `.BackupActivity` (exported), `.APRSSettingsActivity` (not exported) | `AndroidManifest.xml:37-48` |
| SDK | minSdk 26, target/compile 34, Java 8 | `build.gradle:7-12, 85-86` |
| Version | `versionCode 346`, `versionName "3.4.6"`; mirrored by `MainHook.VERSION = "3.4.6"` | `build.gradle:13-14`, `MainHook.java:93` |
| Xposed API | `compileOnly 'de.robv.android.xposed:api:82'` | `build.gradle:92-93` |
| AIDL | enabled (transcription service `com.macdmr.transcription.ITranscriptionService`) | `build.gradle:74-75`, `MainHook.java:52` |

Note: `res/values/strings.xml` still says `app_name = "DMR Mod Hooks v0.2"` and `xposed_description = "... Version Test v0.2"` — stale labels, not used by the hooks. The description LSPosed shows comes from the manifest meta-data.

### 1.2 Signing / install policy

Both `release` and `debug` signing configs point at the **same** keystore `../release.keystore` (alias `dmrmodhooks`, password `android`) — `build.gradle:40-57`. The comment at `build.gradle:48-51` explains why: a different debug key would change the APK signature, forcing an uninstall and losing the LSPosed enable/scope state. `install.ps1` builds `assembleDebug`, installs with `adb install -r -t`, and **always `adb reboot`s on success** (`install.ps1:14-23`) because LSPosed only re-reads `xposed_init` at zygote start.

### 1.3 `handleLoadPackage` flow (`MainHook.java:326-416`)

1. `if (!lpparam.packageName.equals("com.pri.prizeinterphone")) return;` (328)
2. `appClassLoader = lpparam.classLoader;` (335) — the **only** capture of the class loader; every static helper (`enableSoftwareSquelchOnCurrentChannel`, `querySignalStrength`, `getAppContextFromClassLoader`, …) depends on it.
3. One-time APRS state reset: `isAPRSMonitoringActive=false`, `aprsAudioBuffer.clear()`, `aprsMonitoringDialog/aprsUpdateHandler/aprsUpdateRunnable/aprsRssiDisplayTextView = null` (339-347). The comment notes this runs once per zygote fork, *not* per app restart — the per-launch reset is in `hookMainActivity` (§1.5).
4. Hooks are installed in **exactly this order** (`handleLoadPackage` itself has no `try/catch`; each `hookX` method wraps its own body in one, so one failing hook does not stop the rest):

| # | Call | Line | OEM target |
|---|---|---|---|
| 1 | `hookApplication` | 350 | `PrizeInterPhoneApp.onCreate()` |
| 2 | `hookMainActivity` | 353 | `InterPhoneHomeActivity.onCreate(Bundle)` |
| 3 | `hookTalkBackFragment` | 356 | `InterPhoneTalkBackFragment.initView/updateUI/setTalkbackRecordBg/updateChannelNumber` |
| 4 | `hookLocalFragment` | 359 | `InterPhoneLocalFragment.initView(View)` |
| 5 | `hookInformationActivity` | 362 | `FragmentLocalInformationActivity.initView()` |
| — | `hookUpdateFirmwareActivity` | 367 | **commented out** |
| 6 | `hookModuleStatusHandler` | 370 | `ModuleStatusMessageHandler.handle(ModuleStatusMessage)` |
| 7 | `hookDigitalAudioHandler` | 371 | `DigitalAudioMessageHandler.handle(DigitalAudioMessage)` |
| 8 | `hookPCMReceiveManager` | 374 | `PCMReceiveManager.writeAudioTrack(byte[],int)` |
| 9 | `hookSignalMessageHandler` | 377 | `SignalMessageHandler.decode(Packet)` |
| 10 | `hookDmrManager` | 380 | `DmrManager.sendAnalogMessage/sendDigitalMessage`, `DigitalMessage.encodeBody`, `AnalogMessage.encodeBody`, `BaseMessage.send` |
| 11 | `hookChannelNavigation` | 383 | `InterPhoneTalkBackFragment.updateChannelId(boolean)`, `TalkBackStateMachine$ReceiveSoundState.processMessage(Message)`, `DmrManager.sendAnalogMessage` (2nd hook) |
| 12 | `hookChannelListFilter` | 386 | `InterPhoneChannelFragment$DeviceAreaListAdapter.getCount/getView`, `InterPhoneChannelFragment.onItemClick/updateView` |
| 13 | `hookChannelListUI` | 389 | `InterPhoneChannelFragment.initData()` |
| 14 | `hookChannelEditActivity` | 392 | `ChannelData()` ctor, `InterPhoneChannelActivity.onCreate/saveChannelData` |
| 15 | `hookSerialCommunication` | 395 | `SerialManager.send(Packet)`, `MessageDispatcher.onReceive(Packet,SerialPort)` |
| 16 | `registerDebugPacketReceiver` | 398 | `android.app.Application.onCreate()` |
| 17 | `hookMessageDisplay` | 401 | `MessageContentActivity$MessageListAdapter.getView(int,View,ViewGroup)` |
| 18 | `hookBottomNavBar` | 404 | `InterPhoneHomeActivity.onCreate(Bundle)` (2nd hook) + `tapOnClick(View)` |
| 19 | `hookOtherFragmentBackgrounds` | 407 | `initView(View)` on Channel/Contacts/Message/Local fragments |
| 20 | `hookGenericActivityBackgrounds` | 410 | `onCreate(Bundle)` on 8 sub-activities |
| — | `testBootloaderAccess` | 414 | **commented out** |

Where the same OEM method is hooked twice, do **not** rely on registration order. All hooks in this file use the default `XC_MethodHook` priority; Xposed sorts same-priority callbacks by `System.identityHashCode` (its `XCallback.compareTo` comment literally says "then randomly"), runs `before` callbacks in that sorted order and `after` callbacks in reverse. So the relative order of `hookMainActivity` vs `hookBottomNavBar` on `InterPhoneHomeActivity.onCreate` is undefined per process — harmless, since both only `runOnUiThread`/`post` their work. What *is* deterministic: for `DmrManager.sendAnalogMessage`, `hookChannelNavigation` registers the only `before` (sq forcing), and `hookDmrManager`'s `after` merely logs the (already-zeroed) `sq`; any `before` always runs before any `after`.

5. Final log: `"All hooks installed successfully"` (416).

### 1.4 `hookApplication` (`MainHook.java:954-1025`)

Hooks `PrizeInterPhoneApp.onCreate()` **before** (`OEM/PrizeInterPhoneApp.java:15` — original sets the static `mContext`, creates `AppObserver`, `DmrManager.getInstance().init()`, notification manager, starts `InterPhoneService`). The hook (a) creates `<dataDir>/shared_prefs` and `<dataDir>/databases` if missing — a recovery for the black-screen-after-force-close bug (967-996); (b) runs the one-time zone migration `ZoneDatabase.migrateZonesFromNumberToId(ctx)` (1000-1010). The success log claims `attachBaseContext()` is hooked too (1019) — it is not.

### 1.5 `hookMainActivity` (`MainHook.java:1030-1218`)

Hooks `InterPhoneHomeActivity.onCreate(Bundle)` (`OEM/InterPhoneHomeActivity.java:144`; original builds the 5-tab ViewPager and bottom tab bar).

`before` (1043-1188):
- Nulls a non-null `savedInstanceState` (`param.args[0] = null`) to force fresh fragment creation (1049-1052).
- Creates `Download/DMR/Audio`, `Download/DMR/Transcription`, and a template `Download/DMR/api_key.txt` (1062-1112).
- Startup toast `"✓ DMR Mod Hooks Active! v" + VERSION` via `runOnUiThread` (1115-1126).
- **Zygisk static-state reset (per app launch)** — because module statics survive a force-close/restart:

| Reset here | Lines |
|---|---|
| `isAPRSMonitoringActive=false`, `aprsAudioBuffer.clear()`, `aprsMonitoringDialog`, `aprsUpdateHandler`, `aprsUpdateRunnable`, `aprsRssiDisplayTextView` → null | 1129-1138 |
| `isVFOModeActive=false` (if stuck), `vfoDialog=null` | 1142-1147 |
| `isSSTVMonitoringActive=false`, `sstvMonitoringDialog`, `sstvUpdateHandler`, `sstvUpdateRunnable`, `sstvReceiver`, `sstvImageDialog`, `sstvLiveImageView`, `sstvProgressText`, `sstvImageModeText` → null | 1150-1161 |
| `isNOAAMonitoringActive=false`, `noaaMonitoringDialog`, `noaaUpdateHandler`, `noaaUpdateRunnable`, `noaaReceiver`, `noaaLiveImageView`, `noaaProgressText`, `noaaTimerText` → null, `noaaSignalStartTime=0` | 1164-1175 |

**Not** reset: `isSoftwareSquelchEnabled`, `isAprsSoftwareSquelchEnabled`, `softwareSquelchThreshold`, `isMonitoringMode`, `isRecordingEnabled`, `isTranscriptionEnabled`, zone state (`currentZoneId/Name/Channels`), `currentChannelNumber/Type`, `isReceiving`, `currentRssi`. These persist across restarts (see §12).

- Crash-recovery checks, 2 s after `onCreate`: `checkAndRestoreAPRSChannelOnStartup`, `checkAndRestoreSSTVChannelOnStartup`, `checkAndRestoreVFOChannelOnStartup`, `checkAndRestoreNOAAChannelOnStartup` (1178-1187). Each looks for an orphaned hijacked channel (name prefix `"APRS ("`, etc.) and offers restore — documented in the mode chapters.

`after` (1191-1207): `window.setStatusBarColor(0xFF060D14)` / `setNavigationBarColor(0xFF060D14)` (1202-1203).

---

## 2. State registry

All fields are `private static` on `MainHook` (`MainHook.java:92-306`, plus `GPS_PATTERN` at 419). "V" = `volatile`. Threads: **UI** = main thread, **DISP** = `MessageDispatcher` executor (packet handlers), **PCM** = `PCMReceiveManager` "readpcm" HandlerThread, **BG** = ad-hoc `new Thread`. Static views are set on the UI thread and read from DISP/PCM/BG threads without synchronisation; all UI mutation goes through `view.post(...)`.

| Field | Type / default | Purpose | Writers → Readers | Thread notes |
|---|---|---|---|---|
| `TAG` | `"DMRModHooks"` | log prefix | — | — |
| `VERSION` | `"3.4.6"` | shown in toast, Information page, export toast, RadioID UA | — | keep in sync with `build.gradle` |
| `TARGET_PACKAGE` | `"com.pri.prizeinterphone"` | package filter; DB/res lookups | — | — |
| `currentCallerDmrId` | V int 0 | last decoded 24-bit caller ID | W: `hookDigitalAudioHandler`(DISP), `clearCallerDisplay`, `updateUI`(analog) → R: `updateCallerInfoAsync`, `updateActivityIndicator` | — |
| `currentCallerName` | V String null | short display name from lookup | W: `updateCallerInfoAsync`(BG) | — |
| `isReceiving` | V bool false | RX in progress | W: `hookModuleStatusHandler`(DISP) → R: PCM hook, REC toggle, `updateCallerDisplay()` | — |
| `callerDetailPanel` | LinearLayout null | caller panel container (tag `DMR_CALLER_PANEL`) | W: `initView` | UI only via `post` |
| `callerHeadlineTextView` | TextView null | green 16sp headline | W: `initView` | |
| `callerFieldsContainer` | LinearLayout null | ID/name/location chips | W: `initView` | |
| `BORDERBOX_HEIGHT_DP` | 250 | fixed height of content box | — | |
| `dmrActivityIndicator` | TextView null | history lines (tag `DMR_ACTIVITY_INDICATOR`) | W: `initView` | |
| `activityHeaderTextView` | TextView null | "DMR History"/"Analog History" | W: `initView` | |
| `activityHistory` | `LinkedList<String>` | last 3 history lines, newest first | W: `updateActivityIndicator`(DISP/UI), `loadChannelHistory`(BG) | **unsynchronised**, mutated from two threads |
| `MAX_ACTIVITY_HISTORY` | 3 | | | |
| `currentChannelNumber` | V int −1 | channel `number` (1-based display) | W: `initView`, `updateUI` | |
| `currentChannelType` | V int 0 | 0=Digital, 1=Analog | W: `initView`, `updateUI` → R: everywhere | |
| `currentRxToneType` / `currentRxToneSubCode` | V int 0 | CTCSS/DCS type + index for display | W: `initView`, `updateUI` | |
| `appContext` | Context null | application context for DB writes | W: `initView` (1254) | |
| `isRecordingEnabled` | V bool false | REC toggle state | W: REC click(UI) → R: status handler, PCM hook | not reset on restart |
| `isCurrentlyRecording` | V bool false | a PCM file is open | W: `startRecording/stopRecording` | |
| `currentRecordingPath`, `lastRecordingPathForTranscription`, `currentRecordingTimestamp`, `currentRecordingFolder` | V String null | recording bookkeeping | recording chapter | |
| `currentChannelName` | V String "Unknown" | folder name for recordings | W: `updateUI` | |
| `savedCallerDmrIdForTranscription`, `savedCallerNameForTranscription`, `savedChannelTypeForTranscription` | V | caller snapshot taken at RECEIVE_STOP before clear | W: status handler | |
| `recordingToggleButton` | ToggleButton null | REC button | W: `initView` | |
| `pcmOutputStream` | V FileOutputStream null | open recording | W: start/stopRecording → R: PCM hook | |
| `pcmDataSize` | V long 0 | bytes written (WAV header) | W: PCM hook | |
| `currentRssi` | V int −999 | dBm; −999 = unknown | W: `hookSignalMessageHandler`(DISP), `hideRssiDisplay`, 300 ms reset | |
| `rssiDisplayTextView` | TextView null | "Signal: −xx dBm" (tag `DMR_RSSI_TEXT`) | W: `initView` | |
| `isSoftwareSquelchEnabled` | V bool false | SOFT SQ toggle | W: SOFT SQ click, mode start/stop → R: PCM hook, nav hook, `updateUI` | not reset on restart |
| `softwareSquelchThreshold` | V int 2 | level 0-9 (shared with APRS page) | W: slider, saved-pref load, `startAPRSMonitoring` | |
| `isSquelchOpen` | V bool false | gate state | W: PCM hook, 300 ms reset | |
| `previousSquelchOpen` | V bool false | edge detection for "Receiving/Signal(squelch)" text | W: PCM hook, status handler | |
| `squelchStatusIndicator` | TextView null | **never assigned** → `updateSquelchStatus` is a no-op | — | dead |
| `squelchValueTextView` | TextView null | numeric label next to "SQ:" | W: `initView` 1876 | |
| `squelchStatusTextView` | TextView null | **never assigned** | — | dead |
| `lastRssiQueryTime` | V long 0 | throttle for RSSI polls | W: `querySignalStrength` | |
| `RSSI_QUERY_INTERVAL_MS` | 500 | | | |
| `lastSquelchOpenTime` | V long 0 | hang-time reference | W: PCM hook | |
| `SQUELCH_HANG_TIME_MS` | 300 | | | |
| `HYSTERESIS_FACTOR` | 140 | close = open×100/140 (≈3 dB) | | |
| `AUDIO_SQUELCH_THRESHOLDS` | int[10] `{0,200,500,900,1500,2500,4000,6500,10000,15000}` | RMS thresholds per level | | |
| `isTranscriptionEnabled` | V bool false | TXT toggle | W: TXT click → R: PCM hook, status handler | not reset on restart |
| `currentTranscription` | V String "" | | transcription chapter | |
| `audioBuffer` | `synchronizedList<Short>` | transcription buffer | | |
| `MAX_BUFFER_SIZE` | 480000 | 30 s @16 kHz | | |
| `transcriptionService`, `serviceConnection`, `isServiceBound` | | AIDL binding | | not volatile |
| `transcriptionMessagesContainer`, `transcriptionScrollView`, `transcriptionBox` | views | transcription box in border box | W: `initView` | |
| `aprsAudioBuffer` | `synchronizedList<Short>` | APRS decode buffer | W: PCM hook → R: status handler | |
| `APRS_BUFFER_SIZE` | 32000 | | | |
| `mLocalViewObject` | Object null | intercom root view for APRS context | W: `updateUI` 2945 | |
| `transcriptionToggleButton` | ToggleButton null | TXT button | W: `initView` | |
| `channelTranscriptionHistory` | `HashMap<Integer,ArrayList<String>>` | per-channel transcript history | | not synchronised |
| `MAX_TRANSCRIPTION_HISTORY` | 10 | | | |
| `circuitBoardView` | `CircuitBoardView` null | animated spectrum background | W: `initView` → R: PCM hook (writes `audioAmplitude`,`isReceiving`) | fields on the view are `volatile` |
| `monitoringModeToggle` | CompoundButton null | MON button | W: `initView` → R: `updateUI` | |
| `gpsSendButton` | Button null | POS button | W: `initView` | |
| `isMonitoringMode` | V bool false | MON on | W: MON click, `updateUI` → R: `hookDmrManager` (3 places) | not reset on restart |
| `originalSquelchLevel` | int 2 | analog sq to restore after MON | W: MON init/click/`updateUI` | |
| `originalTxContact` | int 1 | DMR txContact to restore after MON | same | |
| `softwareSquelchToggleButton` | ToggleButton null | SOFT SQ button | W: `initView` | |
| `softwareSquelchContainer` | LinearLayout null | slider row (tag `DMR_SQUELCH_CONTAINER`) | W: `initView` | |
| `aprsMonitoringToggleButton` | ToggleButton null | PKT RAD button | W: `initView` | |
| `isAprsSoftwareSquelchEnabled` | V bool false | APRS-page soft-SQ toggle | W: APRS code (5195, 5510, 5600, 6697) → R: nav `sendAnalogMessage` hook | |
| `savedIntercomSquelchThreshold` | int 5 | intercom level saved before APRS overwrites | W: 5497 | |
| `zoneButton` | Button null | intercom "Zone: X" button | W: `initView` → R: zone dialogs, VFO nav disable | |
| `channelPageZoneButton` | Button null | channel-page zone button | W: `hookChannelListUI` | |
| `channelFragmentInstance` | Object null | `InterPhoneChannelFragment` for refresh | W: `hookChannelListUI` | |
| `currentZoneId` | V long −1 | −1 = All | W: zone dialogs | not reset on restart |
| `currentZoneName` | V String "All" | | | |
| `currentZoneChannels` | V `List<Integer>` null | channel `_id`s in zone; null = no filter | W: zone dialogs, `saveChannelData` after-hook | |
| `zoneDatabase`, `tgListDatabase` | singletons null | | W: `initView` 1710-1711 | |
| `activeTGList` | V `TGList` null | **never written** | — | dead |
| `lastUsedChannelPerZone` | `ConcurrentHashMap<Long,Integer>` | **never written** (feature commented out at 2932-2939) | — | dead |
| `talkBackFragmentInstance` | Object null | fragment ref for zone channel switch | W: `initView` 1240 | |
| `isAutoSwitchingZone` | V bool false | **never set true**; read in nav hook | — | dead |
| `currentGpsLocation` | V Location null | cached fix | W: `getCurrentLocation` | |
| `locationManager` | LocationManager null | lazily created | W: `getCurrentLocation` | |
| `isAPRSMonitoringActive` | V bool false | mode flag | APRS chapter → R: PCM hook, status handler | reset on launch |
| `previousChannelBeforeAPRS` | V Object null | | APRS | |
| `appClassLoader` | ClassLoader null | app class loader | W: `handleLoadPackage` 335 | |
| `aprsMonitoringDialog`, `aprsUpdateHandler`, `aprsUpdateRunnable`, `aprsRssiDisplayTextView` | | APRS live dialog | APRS | reset on launch |
| `isAPRSSquelchOpen` | V bool | W: 5611 | APRS | |
| `aprsStoredSquelch` | V int 1 | W: 5612 | APRS | |
| `isVFOModeActive` | V bool false | mode flag | VFO → R: `updateUI` (skip), `BaseMessage.send` hook | reset on launch |
| `vfoDialog`, `vfoModeToggleButton` | | | VFO | |
| `vfoChannelMode` 1, `vfoFrequencyMHz` 146.520, `vfoPowerLevel` 1, `vfoRxToneType/Code`, `vfoTxToneType/Code`, `vfoBandWidth` 0, `vfoContactType` 1, `vfoTxContact` 9, `vfoColorCode` 1, `vfoSlot` 1, `vfoLocalId` −1 | plain (non-volatile) | VFO parameters; `vfoLocalId>0` overrides `DigitalMessage.localId` | VFO → R: `hookDmrManager` | **not volatile** |
| `vfoChannelBackup` | HashMap null | | VFO | |
| `isSSTVMonitoringActive`, `previousChannelBeforeSTV`, `sstvMonitoringDialog`, `sstvUpdateHandler`, `sstvUpdateRunnable`, `sstvReceiver`, `sstvImageDialog`, `sstvLiveImageView`, `sstvProgressText`, `sstvImageModeText` | | SSTV | SSTV → R: PCM hook | reset on launch |
| `isNOAAMonitoringActive`, `noaaMonitoringDialog`, `noaaUpdateHandler`, `noaaUpdateRunnable`, `noaaReceiver`, `noaaLiveImageView`, `noaaProgressText`, `noaaTimerText`, `noaaColorModeButton`, `noaaSignalStartTime`, `noaaChannelBackup` | | NOAA | NOAA → R: PCM hook | reset on launch (except `noaaColorModeButton`, `noaaChannelBackup`) |
| `GPS_PATTERN` | `Pattern` | SMS coordinate matcher | R: `hookMessageDisplay` | immutable |

---

## 3. Hook catalogue

### 3.0 Theme constants ("dark navy / neon cyan")

| Colour | Used for | Examples |
|---|---|---|
| `0xFF0A1520` | page background | intercom root (1257), fragments (16263), sub-activities (16215), channel editor (14011-14016), info page (3633) |
| `0xFF060D14` | title bars, status/nav bars | 1261, 1202-1203, 14006-14007, 16291 |
| `0xFF060D1A` | bottom tab bar | 511 |
| `0xFF00E5FF` | cyan accent: active tab, info text, borders, slider, SQ value | 531, 1336, 1691, 1864 |
| `0xFF705090` | inactive tab purple | 531 |
| `0xFF00BFFF` | history header/lines, transcription border | 1513, 1531, 1571 |
| `0xFF00FF00` | caller headline green | 1488 |
| `0xFFFFFF00` / `0xAAFFFF00` | RSSI text/border | 1662, 1648 |
| Button families | SOFT SQ teal `0xFF0D3D47/0xFF00BCD4`; TXT purple `0xFF2D1060/0xFF7C4DFF`; REC red `0xFF500000/0xFFF44336`; MON amber `0xFF362500/0xFFFF8F00`; PKT RAD green `0xFF004400/0xFF00E676`; VFO amber `0xFF4A3000/0xFFFF8F00`; POS green | 2153-2168, 2037-2054, 2243-2260, 2322-2340, 2549-2567, 2613-2631, 2676-2683 |
| Zone buttons | intercom: gradient `0xFF0D1F4A→0xFF1A3680`, cyan stroke (1691-1702); channel page: royal blue `0xFF4169E1` (12700) | |

The theme is applied by: `hookMainActivity` (system bars), `hookTalkBackFragment` (intercom), `hookBottomNavBar` (tabs), `hookOtherFragmentBackgrounds` (the other 4 tab pages), `hookGenericActivityBackgrounds` (8 sub-activities), `hookInformationActivity`, `hookChannelEditActivity`. Module-owned drawables replace the OEM PTT and digit images (`res/drawable-x*hdpi/interphone_talkback_{record,recording,recv,sub,add,num_0..9}.png`) loaded through `createPackageContext("com.dmrmod.hooks", CONTEXT_IGNORE_SECURITY)`.

### 3.1 `hookBottomNavBar` / `applyBottomNavStyle` (`MainHook.java:451-592`)

| | |
|---|---|
| OEM | `InterPhoneHomeActivity.onCreate(Bundle)` (after) and `tapOnClick(View)` (after). `tapOnClick` (`OEM/InterPhoneHomeActivity.java:358-377`) maps the tapped tab's view id (`channel`, `contacts`, `local`, `message`, default=talkback) to a ViewPager index and calls `setCurrentViewPagerItem`. |
| Adds | `applyBottomNavStyle(activity, tabId)`: paints `interphone_tap_view` (`OEM/…HomeActivity.java:174`) dark; for each of the 5 tab LinearLayouts (`talkback/channel/contacts/message/local` ids) hides the OEM `ImageView` child 0, inserts an emoji `TextView` (tag `DMR_TAB_EMOJI`; 🎙️📋👤💬📻, 22sp, cyan glow shadow when active), recolours the untagged label `TextView` (cyan/purple, 10sp), and adds/updates a 2 dp underline `View` (tag `DMR_TAB_IND`). |
| Re-entry | Idempotent: finds existing views by tag before creating (545-565, 575-586). |
| Note | The bottom bar is a plain XML `LinearLayout` of 5 tabs, not a `BottomNavigationView`. `tapOnClick` is invoked via `android:onClick`, so `channelButton.performClick()` (1740) from the intercom zone button also triggers this restyle. |

### 3.2 `hookMessageDisplay` (`MainHook.java:594-702`)

| | |
|---|---|
| OEM | `MessageContentActivity$MessageListAdapter.getView(int, View, ViewGroup)` (after). Original (`OEM/MessageContentActivity.java:369-415`) inflates left/right bubble rows, sets `holder.mTvValues` to the message content and a click listener that opens `showListDialog(position)` (Copy/Delete/Clean-all). |
| Changes | Moves the dialog to **long-press** (`setOnClickListener(null)`, `setOnLongClickListener → showListDialog`), 618-623. Then runs `GPS_PATTERN` on the text; on match wraps the coordinates in a `ClickableSpan` (light-blue `0xFF4FC3F7`, underlined) that fires `ACTION_VIEW geo:lat,lon?q=lat,lon` with fallback to `https://maps.google.com/?q=` (638-665). A custom `OnTouchListener` resolves the span under `ACTION_UP` so a tap on the coordinates opens maps, elsewhere does nothing (670-692). |
| `GPS_PATTERN` (419-432) | 4 alternations: `GPS:|Pos:|Loc: lat,lon`; `Lat: x Lon: y`; `N37.1234 W122.1234` (sign from N/S/E/W); bare `dd.dddd, -ddd.dddd` (≥4 decimals). `extractLatLon` (437-449) picks whichever group set matched. |

### 3.3 `hookApplication`, `hookMainActivity` — see §1.4–1.5.

### 3.4 `hookTalkBackFragment` (`MainHook.java:1222-3160`) — the intercom page

Four hooks on `com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment`:

| Hook | Kind | Original behaviour |
|---|---|---|
| `initView(View)` | after | `OEM/…TalkBackFragment.java:149-190`: inflates `fragment_talkback_view` into `mLocalView`, binds digit `ImageButton`s, ±, PTT, progress, the 5 info `TextView`s, adds it to `mFragmentContainer`. Called from `BaseViewPagerFragment.onCreateView` (`OEM/BaseViewPagerFragment.java:81-86`), i.e. **once per fragment view creation**. |
| `updateUI()` | after | `OEM/…:191-284`: `initData()` then repaints power/CC-or-SQ/TX/RX freq/contact texts and the title (`name(UHF)`). Called on config change, channel change, etc. |
| `setTalkbackRecordBg(int)` | **replace** | `OEM/…:584-606`: `runOnUiThread` → sets PTT background to `interphone_talkback_recording` (1), `_recv` (2) or `_record` (idle). |
| `updateChannelNumber()` | **replace** | `OEM/…:365-376`: sets the two digit `ImageButton` backgrounds from `Util.FRAGMENT_TALKBACK_NUM_RES`. |

**Re-entry / duplicate prevention.** `mLocalView` is freshly inflated on every `initView`, so a re-created fragment (tab swipe far away, rotation, restart) gets a clean root and the hook rebuilds everything; static view refs are simply overwritten. Within one view the guard is the `DMR_SPACER` tag scan (1385-1398): if found, the hook `return`s — **skipping the initial-channel block at 2801-2841 too**. The first two blocks (channel-controls margin, info/location container) run *before* the guard and would re-wrap on a genuine double call. OEM's `setTalkbackRecordBg`/`updateChannelNumber` are replaced (not wrapped) so OEM drawables never flash over the module's.

**Resulting layout of `rootLayout` (`mLocalView`, vertical `LinearLayout`) after `initView`:**

| Index | View | Details / lines |
|---|---|---|
| 0 | OEM channel controls (digits, ± `ImageButton`s) | `topMargin=5dp` (1270-1280); ± buttons re-skinned with module `interphone_talkback_sub/add` (2843-2862) |
| 1 | `horizontalContainer` (new) | OEM info `LinearLayout` (child 1) moved in at weight 0.6, dividers/padding stripped, its `TextView`s cyan 11sp (1286-1354); plus `locationText` (tag `DMR_LOCATION_TEXT`, weight 0.4, white 12sp, right-aligned, default "📍") (1356-1371); `updateLocationDisplay` called (1377) |
| 2 | `rssiZoneContainer` (tag `DMR_RSSI_ZONE_CONTAINER`) | left: `rssiBox` (tag `DMR_RSSI_BOX`, yellow border, `INVISIBLE` until RSSI) containing `rssiText` (tag `DMR_RSSI_TEXT`) → `rssiDisplayTextView` (1619-1675); right: `zoneButtonWidget` (tag `DMR_ZONE_SELECTOR`, "Zone: All") → `zoneButton` (1677-1786). `ZoneDatabase`/`TGListDatabase` singletons initialised here (1710-1711). |
| 3 | `squelchContainer` (tag `DMR_SQUELCH_CONTAINER`, half screen width, negative top margin −18 dp) | "SQ:" label, value label (tag `DMR_SQUELCH_VALUE`) → `squelchValueTextView`, `SeekBar` (tag `DMR_SQUELCH_SEEKBAR`, max 9, cyan tint). Listener: `onProgressChanged(fromUser)` → `softwareSquelchThreshold=progress`; `onStopTrackingTouch` → if soft-SQ on, `enableSoftwareSquelchOnCurrentChannel()`, then `APRSDatabase.setAprsSquelch(progress)` (1800-1920). Saved level loaded from `APRSDatabase.getAprsSquelch()` (1926-1950; on failure default 5). Visibility = `isSoftwareSquelchEnabled` at creation, later `analog && soft-SQ` (1953, 2822, 2912). |
| 4 | `borderBox` (`FrameLayout`, tag `DMR_BORDERBOX`, 250 dp, cyan 35 % stroke, 12 dp radius, faint gradient) | children in z-order: **`CircuitBoardView`** (match parent, 1434-1442); **`infoPanel`** (tag `DMR_INFO_PANEL`, top, translucent black, blue stroke) containing `callerPanel` (tag `DMR_CALLER_PANEL`, GONE) → [`callerHeadline` (tag `DMR_CALLER_HEADLINE`, green bold 16sp single line), `fieldsContainer` (tag `DMR_CALLER_FIELDS`)], `activityHeader` (tag `ACTIVITY_HISTORY_HEADER`, "DMR History", `0xFF00BFFF` 13sp bold), `activityIndicator` (tag `DMR_ACTIVITY_INDICATOR`, 11sp, GONE) (1447-1538); **`transcriptionBoxLayout`** (tag `DMR_TRANSCRIPTION_BOX_LAYOUT`, gravity bottom, GONE) with header "📝 Transcription", `ScrollView` (tag `DMR_TRANSCRIPTION_SCROLL`) > messages `LinearLayout` (tag `DMR_TRANSCRIPTION_MESSAGES`) (1541-1616) |
| 5 | `spacer` (tag `DMR_SPACER`, weight 1) | 1961-1972 |
| 6 | `buttonContainer` (`FrameLayout`, bottom margin 10 dp) | OEM PTT `ImageButton` removed from root and re-added centered at 176×176 dp with module `interphone_talkback_record` idle drawable (1987-2010). Overlaid toggles (all 52 dp tall, 13sp bold, rounded 20 dp, `StateListDrawable`): |

Buttons inside `buttonContainer` (gravity/offsets in dp):

| Tag | Text | Position | Static ref | Click behaviour |
|---|---|---|---|---|
| `DMR_SOFT_SQUELCH_TOGGLE` | 🎚️ SOFT SQ | left, top 8, 80 wide | `softwareSquelchToggleButton` | `isSoftwareSquelchEnabled = checked`; ON → show slider if analog + `enableSoftwareSquelchOnCurrentChannel()`; OFF → hide slider + `disableSoftwareSquelchOnCurrentChannel()` (2178-2213). Initial checked = `isSoftwareSquelchEnabled` (2131). Hidden on digital channels (2832, 2922). |
| `DMR_TRANSCRIPTION_TOGGLE` | ✍️ TXT | left, top 66, 70 wide | `transcriptionToggleButton` | ON: if `api_key.txt` unset → uncheck + `showApiKeyConfigDialog`; else `isTranscriptionEnabled=true`, bind service. OFF: clear buffer/display. Long-press → API-key dialog (2067-2121). `bindToTranscriptionService` is called eagerly at creation (2064). |
| `DMR_VFO_TOGGLE` | 🎛️ VFO | left, top 124, 70 wide | `vfoModeToggleButton` | checked → `showVFODialog`; unchecked → `stopVFOMode` (2640-2651) |
| `DMR_RECORDING_TOGGLE` | ⏺ REC | right, top 8, 70 wide | `recordingToggleButton` | `isRecordingEnabled = checked`; stop current recording if OFF; start immediately if ON and `isReceiving` (2270-2292) |
| `DMR_MONITOR_TOGGLE` | 👁️ MON | right, top 66, 70 wide | `monitoringModeToggle` | See MON below (2398-2519). Analog channels only. |
| `DMR_GPS_SEND_BUTTON` | 📍 POS (`Button`) | right, top 66 (same slot as MON) | `gpsSendButton` | Digital channels only. Reads last known location, optional confirm dialog with "Don't ask again" (`dmrmod_gps_prefs`/`gps_send_no_confirm`), geocodes on a BG thread, builds `"GPS:%.6f,%.6f acc:%dm [City, ST]"` into a `MessageData` (direction 0, status 0) and calls `DmrManager.saveSms(msgData)` (`OEM/DmrManager.java:476` — stores SMS then `sendSms`) (2686-2786). |
| `DMR_PKT_RAD_BUTTON` | 📡 PKT RAD | right, top 124, 76 wide | `aprsMonitoringToggleButton` | Not a real toggle: unchecks itself and opens `showPacketRadioMenu` (APRS/SSTV/NOAA) (2576-2583) |

**MON button.** On creation (`monitorToggle.post`, 2349-2395) reads `DmrManager.getCurrentChannel()`; forces MON OFF; shows MON on analog / POS on digital; stores `originalTxContact` (unless 16777215) or `originalSquelchLevel` (0→2). Click (2398-2519): digital → sets `contactType` 2/`txContact` 16777215 (ON) or restores (OFF) on the live `ChannelData`, then `DmrManager.updateChannel(ch)` + `syncChannelInfoWithData(ch)` (`OEM/DmrManager.java:253-257, 207-215`: DB update + list refresh + `CmdStateMachine` set-channel). Analog → builds an `AnalogMessage` copying all channel fields with `sq = 0` (ON) or `originalSquelchLevel` (OFF) and `.send()`s it directly, bypassing the state machine (2475-2501). `updateUI` resets MON to OFF on every channel change (2963-2999).

**`updateUI` after-hook (2873-3055).** Skipped entirely when `isVFOModeActive`. Reads `mCurrentChannelData` (`number`, `type`, `rxType`, `rxSubCode`, `name`); on channel-number change: updates the `current*` statics, slider/SOFT-SQ visibility, `currentChannelName`, `mLocalViewObject`, clears caller panel if analog, resets MON, `updateHistoryHeader()`, `loadChannelHistory()`, `restoreChannelTranscriptionHistory()`. Always: `updateLocationDisplay`, recolours the 5 OEM info `TextView`s (`fragment_talkback_send/recieve/power/color_or_noise/call_name`) cyan and trims frequency strings to 3 decimals via regex `(\d+\.\d{3})\d+` (3022-3048).

### 3.5 Location helpers (`MainHook.java:3165-3604`)

`updateLocationDisplay(fragment, tv, ctx)` reads `mCurrentChannelIndex + 1` (**index+1, not `number`**) and queries `LocationDatabase.getLocation(channelNumber)`. If a location exists: `Geocoder` (synchronous, on the calling thread — UI in `initView`/`updateUI`) → "City, ST"; distance/bearing from `getCurrentLocation` (last known GPS then network fix) via Haversine `calculateDistance` (3451) and `calculateBearing` (3476) → `getDirectionArrow` (8-point ↑N…↖NW); text `"City, ST (↗NE 3.2km)\n📍"`; then a BG thread calls Open-Elevation (`https://api.open-elevation.com/api/v1/lookup?locations=lat,lon`, 5 s timeouts, 3396-3441) and rewrites the line as `"...\n1234ft (376m) 📍"`. Distance format: `<1 km` → m; `<10 km` → 0.1 km; else `mi (km)`. Requires the module's INTERNET/location permissions, but the code runs in the *app's* process, so the app must hold them.

### 3.6 `hookInformationActivity` (`MainHook.java:3609-3768`)

Hooks `FragmentLocalInformationActivity.initView()` (after; `OEM/…InformationActivity.java:35-45` binds `mTvSoftwareVersion`/`mTvDmrFirmwareVersion` and fills them). Adds dark background, appends `"\nDMRModHooks v3.4.6"` to the software-version text, inserts a "MacGyver Mod Version" row (label + underlined blue link `IIMacGyverII mod v…` → GitHub) after the DMR-firmware row, and an empty light-grey `patchContainer` (the reload button injection is commented out, 3744).

### 3.7 `hookLocalFragment` + `addBackupButtonToFragment` + `addButtonToLayout` (`MainHook.java:3952-4222`)

Hooks `InterPhoneLocalFragment.initView(View)` (after; `OEM/…LocalFragment.java:85-120` inflates `fragment_local_view` into `mLocalView`, binds menu rows incl. `local_exit_app`). The hook finds the exit row by trying ids `local_exit_app`, `local_exit`, `exit_app`, `fragment_local_exit_app` (first exists) and inserts, at the exit row's index in its parent: `📤 EXPORT (OpenGD77)` (BG thread → `DirectDatabaseExporter.exportFromAppContext`), `📥 IMPORT (OpenGD77)` (`DirectDatabaseImporter.showImportDialog`), a RadioID status `TextView`, `🌐 Download RadioID Database` (`RadioidDatabase.downloadAndImport` with UA `DMRModHooks/<ver> (github.com/IIMacGyverII/phonedmrapp)`), `📂 Import RadioID CSV`. Layout params are cloned from the parent's first child. Fallback when no id resolves: first `LinearLayout` with >3 children (`findViewGroupInHierarchy`). No duplicate guard — relies on a fresh `mLocalView` per `initView`.

`addBackupButton`/`findButtonParentLayout`/`findExitButtonIndex` (8324-8447) are an older activity-based variant (matches button text "exit"/"退出"/"关闭"); **not called anywhere**.

### 3.8 `hookModuleStatusHandler` (`MainHook.java:8452-8644`)

Hooks `ModuleStatusMessageHandler.handle(ModuleStatusMessage)` (after). Original (`OEM/handler/ModuleStatusMessageHandler.java:19-23`): logs, sends an ACK packet (`MODULE_PRINT_STATUS_INFO_CMD`=54, rw=1, sr=1, body `{1}`), then `DmrManager.onModuleStatusReceived(status)`. `status` is the first body byte (`OEM/message/ModuleStatusMessage.java:26`). Runs on the dispatcher executor thread. Switch on `Const.ModuleStatus` (`OEM/protocol/Const.java:70-84`):

| status | Name | Hook action |
|---|---|---|
| 1, 10 | RECEIVE_START / MIX_CHECK_DIGITAL_RECEIVE_START | `isReceiving=true`; `startRecording()` if enabled; `queryRssi()`; digital → `queryCallerInfo()`; analog → caller panel "📻 Receiving…" or "📡 Signal (squelch)" (+tone line) depending on `isSoftwareSquelchEnabled && !isSquelchOpen` |
| 2, 11 | RECEIVE_STOP / MIX_CHECK_DIGITAL_RECEIVE_STOP | `isReceiving=false`, `previousSquelchOpen=false`; `processAPRSBuffer()` if not APRS mode and buffer non-empty; `stopRecording()`; snapshot caller for transcription; `processTranscription()`; `hideRssiDisplay()`; `clearCallerDisplay()` |
| 3 | SEND_START | history "📻 Voice TX" |
| 4 | SEND_STOP | log only |
| 5 | SMS_RECEIVED | history "💬 SMS RX" |
| 7 | CHANNEL_BUSY | history "⚡ Channel Busy" |
| 8 / 9 | SMS_SENT_SUCCESS / FAIL | history "💬 SMS TX ✓" / "💬 SMS TX ✗" |
| 12 | MIX_CHECK_ANALOG_RECEIVE_START | history "📻 Analog RX"; clears DMR caller; `isReceiving=true`; caller panel receiving/squelch text with tone |
| 13 | MIX_CHECK_ANALOG_RECEIVE_STOP | `isReceiving=false`; `previousSquelchOpen=false`; `processAPRSBuffer()`; `clearCallerDisplay()` |
| 6 | RELAY_ACTIVITY_TIME_OUT | not handled |

### 3.9 `hookDigitalAudioHandler` (`MainHook.java:8649-8798`) — see §6.

### 3.10 `hookPCMReceiveManager` (`MainHook.java:9926-10112`) — see §4/§5.

### 3.11 `hookSignalMessageHandler` (`MainHook.java:10464-10515`)

Hooks `SignalMessageHandler.decode(Packet)` (after). Original (`OEM/handler/SignalMessageHandler.java:12-14`) just constructs `new SignalMessage(packet)`; `handle()` is empty — the OEM app never uses RSSI. The hook reads `packet.body[0]` (unsigned) and computes `currentRssi = raw > 0 ? -(120 - raw/2) : -999` (10494), so raw 0…255 → −120…+7 dBm (nominal −120…−50 for raw ≤ 140). Calls `updateRssiDisplay()` when raw > 0. Requests are sent by `queryRssi` (8823) at RECEIVE_START and by `querySignalStrength` (10256) every ≥500 ms inside the squelch loop (both: `SignalMessage` with `fetch=1` → cmd 50 `QUERY_SIGNAL_STRENGTH_CMD`).

### 3.12 `hookDmrManager` (`MainHook.java:10521-10860`) — see §7.

### 3.13 `hookSerialCommunication`, `registerDebugPacketReceiver` — see §10.

### 3.14 `hookChannelNavigation`, `hookChannelListFilter`, `hookChannelListUI` — see §8.

### 3.15 `hookChannelEditActivity` — see §9.

### 3.16 `disableBottomNavigation` / `enableBottomNavigation` (`MainHook.java:15930-16032`)

Used by VFO mode. Saves the current `OnClickListener` of `zoneButton` and the bottom `channel` tab by reading `View.getListenerInfo().mOnClickListener` via reflection into an additional instance field `originalOnClickListener`, replaces it with a toast ("Disable VFO mode to enable …"); `enable…` restores. Only the *channel* tab is blocked; other tabs still work.

### 3.17 `hookGenericActivityBackgrounds` (`MainHook.java:16182-16228`)

Hooks `onCreate(Bundle)` (after) on `FragmentLocalSettingsActivity`, `FragmentLocalDeviceAreaActivity`, `FragmentLocalDeviceAreaListActivity`, `FragmentLocalUseAssistantActivity`, `MessageContentActivity`, `FragmentNewContactsActivity`, `RecordListActivity`, `FragmentLocalTestBiteErrorRateActivity`; posts to the decor view: system bars `0xFF060D14`, `content.getChildAt(0)` background `0xFF0A1520`.

### 3.18 `hookOtherFragmentBackgrounds` (`MainHook.java:16230-16306`)

Hooks `initView(View)` (after) on `InterPhoneChannelFragment`, `InterPhoneContactsFragment`, `InterPhoneMessageFragment`, `InterPhoneLocalFragment`. `param.args[0]` is `fragment_base_view_pager` (title bar + `mFragmentContainer` `FrameLayout`, `OEM/BaseViewPagerFragment.java:88-99`). Darkens root, `mFragmentContainer`, each content child (and any nested `ScrollView` + its child for the Local page), and the title bar. Note this is a **second** hook on `InterPhoneLocalFragment.initView` (after `hookLocalFragment`) and runs after it.

---

## 4. Software squelch, in depth

**Why.** Firmware honours only `sq=0` (open) and `sq=2` (tight) on analog channels; the module opens the hardware fully and gates audio itself.

**Inputs.** `softwareSquelchThreshold` L∈0..9; `AUDIO_SQUELCH_THRESHOLDS[L]` (RMS units on 16-bit PCM); `getRssiThreshold(L)` = `{-120,-110,-100,-95,-90,-85,-80,-75,-70,-65}` dBm (10235-10246); `currentRssi` (−999 = unknown → RSSI gate bypassed).

**Per-buffer algorithm (`writeAudioTrack` before-hook, 9945-10102):**

1. `useSquelch = (isSoftwareSquelchEnabled || isAPRSMonitoringActive) && softwareSquelchThreshold > 0` (9966). Level 0 disables gating. **No channel-type check** — if SOFT SQ was enabled on analog and the user moves to a digital channel (where the button is hidden), digital audio is still RMS-gated.
2. `amplitude = calculateAudioAmplitude(buf,len)` (10171): every other 16-bit LE sample (4-byte stride, `i += 4` at 10180 — the code comment says "every 4th sample" but a sample is 2 bytes); `max(RMS, 0.7·peak)`.
3. `openThresh = AUDIO_SQUELCH_THRESHOLDS[L]`; `closeThresh = openThresh·100/140` (≈−2.9 dB hysteresis).
4. `rssiPass = (currentRssi == -999) || currentRssi >= rssiThreshold[L]`; if RSSI known and ≥500 ms since last poll → `querySignalStrength()`. (Polling therefore only starts after the first RSSI reply triggered by `queryRssi` at RECEIVE_START.)
5. `shouldOpen = rssiPass && amplitude ≥ openThresh`; `shouldClose = !rssiPass || amplitude < closeThresh`. State machine: open→close on `shouldClose`; closed→open on `shouldOpen`.
6. Hang time: if open, `lastSquelchOpenTime = now`; else if `now − lastSquelchOpenTime < 300 ms` → forced open.
7. If closed → `Arrays.fill(audioData, 0, length, 0)` — the buffer passed to `AudioTrack.write` is muted in place.
8. If receiving on analog and state changed vs `previousSquelchOpen` → caller panel text toggles "📻 Receiving…"/"📡 Signal (squelch)" (10023-10045).
9. `updateSquelchStatus` (throttled) — no-op because `squelchStatusIndicator` is null; debug log once/sec.
10. `circuitBoardView.audioAmplitude = (useSquelch && !isSquelchOpen) ? 0 : amplitude` (10064) — bars freeze when muted (Pitfall 3).

**Hardware side.** `enableSoftwareSquelchOnCurrentChannel()` (10323-10390): analog only; builds an `AnalogMessage` from `DmrManager.getCurrentChannel()` with `setSq(0)`, sets `channel.sq = 0` in memory, `.send()` (cmd 35 `SET_ANALOG_INFO_CMD`, 19-byte body `OEM/message/AnalogMessage.java:56-71`). `disableSoftwareSquelchOnCurrentChannel()` (10395-10459): same with `sq=2`. Both bypass `CmdStateMachine` (Pitfall 8). Callers of `enable…`: slider release (1909), saved-level load 500 ms after `initView` (1942), SOFT SQ ON (2198), APRS/SSTV/NOAA start (5218/5223, 6189/6197, 7608/7614), and the 300 ms post-channel-change reset (12363).

**Channel-change re-enable (`hookChannelNavigation`, 12329-12371).** `before` on `DmrManager.sendAnalogMessage(ChannelData)` (`OEM/DmrManager.java` private; copies channel fields into an `AnalogMessage` and sends): if `isSoftwareSquelchEnabled || isAprsSoftwareSquelchEnabled` → `channelData.sq = 0` before the OEM reads it, then `postDelayed(300 ms)`: `isSquelchOpen=false; previousSquelchOpen=false; lastSquelchOpenTime=0; currentRssi=-999; enableSoftwareSquelchOnCurrentChannel()`. Catches list taps, ± buttons, zone switches, startup programming, state-machine retries. Because the `ChannelData` object is mutated, the in-memory channel (and anything that persists it afterwards) now carries `sq=0`.

**Toggle/slider/MON interactions.**
- Slider move: only `softwareSquelchThreshold` changes (no hardware write); release: `enable…()` (if on) + persist via `APRSDatabase.setAprsSquelch` — the **same preference the APRS page slider uses** (Pitfall 10 root).
- SOFT SQ OFF: hardware `sq=2` regardless of the channel's stored `sq`.
- MON ON (analog): sends `sq=0` directly — identical hardware effect to SOFT SQ, but audio is not gated; MON OFF restores `originalSquelchLevel`, which may re-tighten hardware while SOFT SQ is still on (then the next channel change re-forces 0).
- `updateUI` resets MON OFF on channel change but does not touch SOFT SQ.
- APRS/SSTV/NOAA modes: `isAPRSMonitoringActive` forces gating with the shared threshold (`startAPRSMonitoring` overwrites `softwareSquelchThreshold`, saving the old one in `savedIntercomSquelchThreshold`); details in the mode chapters.

```mermaid
flowchart TD
  A[writeAudioTrack(buf,len) before-hook<br/>PCM thread] --> B{any consumer active?<br/>APRS/TXT/SSTV/NOAA/REC}
  B -- yes --> C[originalAudio = copyOf(buf,len)]
  B -- no --> D
  C --> D[amplitude = max(RMS, 0.7*peak)<br/>every 2nd sample]
  D --> E{useSquelch =<br/>(softSQ || APRS) && L>0}
  E -- no --> M[circuitBoardView.amp = amplitude]
  E -- yes --> F[open = T[L]; close = T[L]*100/140<br/>rssiPass = rssi==-999 || rssi>=R[L]]
  F --> G{isSquelchOpen?}
  G -- yes --> H{!rssiPass || amp<close}
  H -- yes --> I[isSquelchOpen=false]
  H -- no --> J[stay open]
  G -- no --> K{rssiPass && amp>=open}
  K -- yes --> L2[isSquelchOpen=true]
  K -- no --> J2[stay closed]
  I --> HT{now-lastOpen < 300ms}
  J2 --> HT
  HT -- yes --> HO[force open (hang)]
  HT -- no --> MU[Arrays.fill(buf,0)]
  J --> LO[lastOpen=now]
  L2 --> LO
  HO --> N
  LO --> N
  MU --> N[edge? update caller text<br/>Receiving / Signal(squelch)]
  N --> M2[circuitBoardView.amp = open?amplitude:0]
  M --> P
  M2 --> P[feed decoders/REC/TXT with originalAudio<br/>then OEM AudioTrack.write(buf)]
  subgraph channel change
    X[DmrManager.sendAnalogMessage before-hook] --> Y{softSQ || aprsSoftSQ}
    Y -- yes --> Z[channelData.sq=0]
    Z --> W[postDelayed 300ms:<br/>reset isSquelchOpen/prev/lastOpen, rssi=-999<br/>enableSoftwareSquelchOnCurrentChannel]
  end
```

---

## 5. Audio hook execution order (`hookPCMReceiveManager.beforeHookedMethod`, 9945-10102)

OEM `PCMReceiveManager.writeAudioTrack(byte[] bArr, int i)` (`OEM/manager/PCMReceiveManager.java:124-142`) runs on the `readpcm` HandlerThread; writes `bArr[0..i)` to an 8 kHz mono 16-bit `AudioTrack` (`DEFAULT_SAMPLE_RATE = 8000`, line 22/66) and optionally the OEM record file. Since the hook is `before`, the OEM writes whatever the hook left in `bArr`.

| Step | Consumer | Audio | Cost / note |
|---|---|---|---|
| 1 | `originalAudio = Arrays.copyOf(audioData,length)` | pre-squelch | only if APRS, TXT, SSTV, NOAA, or active REC (9952-9956) |
| 2 | `calculateAudioAmplitude` (VU + squelch) | pre-squelch | ½ of samples (4-byte stride), O(n/2) |
| 3 | Software squelch + in-place mute | mutates `audioData` | see §4 |
| 4 | `circuitBoardView.audioAmplitude/isReceiving` | post-squelch (0 when closed) | volatile write |
| 5 | `processingAudio = originalAudio ?: audioData` | | if no copy was made, later consumers get the (possibly muted) buffer — irrelevant because they are inactive then |
| 6 | `bufferAudioForAPRS(processingAudio,len)` if APRS | pre-squelch | |
| 7 | `sstvReceiver.processAudio` if SSTV | pre-squelch | DSP on the audio thread |
| 8 | `noaaReceiver.processAudio` if NOAA | pre-squelch | |
| 9 | `bufferAudioForTranscription(processingAudio)` if TXT | pre-squelch | |
| 10 | `pcmOutputStream.write(processingAudio,0,len)` if REC | pre-squelch | **synchronous file I/O on the audio thread** |
| 11 | OEM `AudioTrack.write(audioData)` | post-squelch | |

Per-callback concerns: throttled logging uses `System.currentTimeMillis() % 1000 < 50` — a window test, so log frequency depends on buffer cadence; the RSSI poll allocates a `SignalMessage` and writes to UART from the audio thread; `Geocoder`/DB never run here. The whole hook is wrapped in no `try/catch` of its own — an exception propagates into Xposed's handler and is logged, but the OEM write still happens.

---

## 6. Caller identification & history

### 6.1 Packet parsing (`hookDigitalAudioHandler`, 8649-8798)

Hooks `DigitalAudioMessageHandler.handle(DigitalAudioMessage)` before + after. The OEM handler (`OEM/handler/DigitalAudioMessageHandler.java:8-9`) is **empty**; `DigitalAudioMessage.decodeBody` is also empty (`OEM/message/DigitalAudioMessage.java:11-12`). The message is the reply to `QUERY_DIGITAL_AUDIO_RECEIVE_INFO` (cmd 43), which the module sends itself from `queryCallerInfo()` at RECEIVE_START (`new DigitalAudioMessage().send()`, `fetch=1`).

- `before`: if `body.length >= 9` and `DmrManager.getCurrentChannel().getContactType() == 2` (MON ON) → `body[0] = 2`. Otherwise pass-through (8670-8704). With the OEM handler empty this only affects the module's own logging.
- `after`: dumps hex + several candidate decodings (debug noise, 8720-8766), then **`dmrId = (body[3]<<16 | body[2]<<8 | body[1]) & 0xFFFFFF`** — 24-bit little-endian at offset 1 (8770-8771). Accepted if `0 < id < 16777215 && currentChannelType == 0` → `currentCallerDmrId = id; updateCallerInfoAsync(cl)`.

### 6.2 Two-tier lookup (`8845-9063`)

`updateCallerInfoAsync` (BG thread): `PrizeInterPhoneApp.getContext()` → `lookupCallerDisplayInfo(ctx, id)`:
1. **Personal contacts** — `lookupPersonalContactName` opens `contact_database.db`, `SELECT contact_name FROM contact_database WHERE contact_number = ?` (8960-8965; creates the table if absent). Sets `personalName`, `fromPersonal`.
2. **Global RadioID** — `RadioidDatabase.getInstance(ctx).lookupRecord(id)` → `callsign, firstName, lastName, city, state, country`; sets `fromGlobal`.
Returns null if neither hit. `CallerDisplayInfo.shortName()` = personal → callsign → "First Last"; `headline()` = "📡 <personal|callsign>" else "📡 Voice RX"; `sourceBadge()` ⭐ personal / 🌐 global. `formatDmrHistoryLabel` = "First Last · CALLSIGN" (or personal name, or callsign, or bare ID).

Then on the UI thread, **only if still `currentChannelType == 0`**: `applyCallerPanelOnUiThread(info)` and `updateActivityIndicator("📻 Voice RX")` (8869-8882). So the digital RX history line is written when the ID arrives, not at RECEIVE_START.

### 6.3 Caller panel rendering (`9065-9192`)

`applyCallerPanelOnUiThread`: headline = `headline() + "  " + badge`; `populateCallerFieldsContainer` builds row 1 = chips `🆔 <id>` (cyan, weight .38) + `👤 First Last` (weight .62, omitted if equal to the personal name); row 2 (global only) = single marquee line `🏙️ city   🗺️ state   🌍 country`; panel → VISIBLE. `updateCallerDisplay(String)` (analog/tone text) sets the headline only and clears fields. `hideCallerPanelOnUiThread`/`clearCallerDisplay` hide + clear + zero `currentCallerDmrId/Name`.

### 6.4 History DB `dmrmod_history.db` (`9414-9607`)

Path: `<app dataDir>/databases/dmrmod_history.db` (opened with `SQLiteDatabase.openOrCreateDatabase`, no helper class).

```sql
CREATE TABLE IF NOT EXISTS channel_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  channel_number INTEGER, dmr_id TEXT, timestamp TEXT,
  activity_type TEXT, rssi_dbm INTEGER, transcription TEXT, created_at INTEGER)
-- plus idempotent ALTER TABLE ADD COLUMN rssi_dbm / transcription for old DBs
```

- **Write** `saveChannelHistoryEntry` (BG thread): insert `{channel_number, dmr_id, timestamp "HH:mm:ss", activity_type, rssi_dbm, created_at=millis}`; then prune to the newest 100 rows per channel (9591-9593). `dmr_id` = decimal ID, `"-----"` (digital, unknown), or `"N/A"` (analog). `transcription` is written by the transcription code path (`saveTranscriptionToFile`), not here.
- **Read** `loadChannelHistory` (BG thread): `SELECT dmr_id,timestamp,activity_type,rssi_dbm … WHERE channel_number=? ORDER BY created_at DESC LIMIT 3`, re-formats each row (re-running the two-tier lookup per row), fills `activityHistory` newest-first and posts the joined text to `dmrActivityIndicator` (GONE if empty).

### 6.5 Activity-indicator line format (`updateActivityIndicator`, 9291-9359)

- Digital: `"<label>  HH:mm:ss <activity>[ <rssi> dBm]"` where `<label>` = `formatDmrHistoryLabel` or `-----`.
- Analog: `"HH:mm:ss <activity>[ <rssi> dBm]"`.
- `<activity>` ∈ `📻 Voice RX`, `📻 Voice TX`, `📻 Analog RX`, `💬 SMS RX`, `💬 SMS TX ✓`, `💬 SMS TX ✗`, `⚡ Channel Busy`.
- Max 3 lines, newest first; header "DMR History"/"Analog History" (`updateHistoryHeader`).

### 6.6 RSSI display

`updateRssiDisplay` (10117): `"Signal: <dBm> dBm"` and makes the yellow `rssiBox` VISIBLE; `hideRssiDisplay` (10142) at RECEIVE_STOP → INVISIBLE and `currentRssi=-999`. The box is `INVISIBLE` (reserves space) rather than GONE.

---

## 7. DmrManager hooks (`hookDmrManager`, 10521-10860)

| Target | Kind | Original does | Hook does |
|---|---|---|---|
| `DmrManager.sendAnalogMessage(ChannelData)` (private) | after | builds `AnalogMessage` from channel (band, power, tx/rx freq, **sq**, rx/tx type+subcode, relay) and `.send()`s | log only (`ChannelData sq=`). The functional sq=0 forcing is the *other* hook in `hookChannelNavigation` (§4). |
| `DmrManager.sendDigitalMessage(ChannelData)` (private) | before | builds `DigitalMessage` (`localId = getLocalId()`, freqs, power, contactType, txContact, cc, slots, mode, encryption, `groupList = channel.groups` only when `contactType==1`, mic, relay) and sends | if `isMonitoringMode`: sets `channelData.contactType=2`, `setTxContact(16777215)` **on the ChannelData itself** (10584-10591); logs group-list expectations |
| `DigitalMessage.encodeBody()` | before/after | serialises 163-byte body: rxFreq(4) txFreq(4) localId(4) groupList(32×4=128) txContact(4) contactType(1) power cc inboundSlot outboundSlot channelMode encryptSw encryptKey(8) pwrSave volume mic relay (`OEM/message/DigitalMessage.java:129-149`) | before: if MON → `contactType=2`, `txContact=16777215` on the message; after: reads back bytes 140-143 (txContact BE) and 144 (contactType) and logs success/warning |
| `AnalogMessage.encodeBody()` | before | serialises 19-byte body: rxFreq txFreq band power sq rxType rxSubCode txType txSubCode pwrSave volume monitor relay | log `sq`/`monitor` only (explicitly does not touch `monitor`) |
| `BaseMessage.send()` | before | `encode()` (rw=1, sr=1, body) then `SerialManager.getInstance().send(packet)` (`OEM/message/BaseMessage.java:35-38`) | AnalogMessage → log; DigitalMessage → if MON: force `contactType=2/txContact=16777215` again; **if `isVFOModeActive && vfoLocalId > 0` → `localId = vfoLocalId`** (10799-10804); logs first 8 groupList entries and whether any TG >1 is present |

Not in `hookDmrManager`: the `ChannelData()` constructor hook (wide-band default) lives in `hookChannelEditActivity` (13956-13965) and applies to **every** `new ChannelData()` in the process, not just the editor; TG-list "groups" are injected at save time (§9), not at send time. There is no hook on `syncChannelInfo*`, `updateChannel`, or `getCurrentChannel`.

---

## 8. Zones & channel navigation

Zone data: `ZoneDatabase` (module SQLite, zone → list of channel `_id`s, migrated from `number` at app start §1.4). Runtime filter = `currentZoneChannels` (`List<Integer>` of `_id`), null for "All".

### 8.1 Navigation filter (`hookChannelNavigation`, 12166-12280)

`before` on `InterPhoneTalkBackFragment.updateChannelId(boolean up)`. Original (`OEM/…TalkBackFragment.java:288-362`): unless `CmdStateMachine` is mid set-channel, on the UI thread computes `tmp = mCurrentChannelIndex ± 1`, clamps at 0/`mMaxChannelId-1` (**no wrap**), registers a listener for cmd 34/35 replies, `syncChannelInfoWithData(channels.get(tmp).clone())`, shows a progress dialog; the listener commits `mCurrentChannelIndex = tmp` and flips `active` in the DB on success.

Hook: returns immediately if `isAutoSwitchingZone` (never true) or no zone filter. Otherwise walks from `mCurrentChannelIndex` in the requested direction **with wrap-around**, up to `mMaxChannelId` attempts, until a channel whose `_id` is in the zone is found; then pre-sets `mCurrentChannelIndex = target ∓ 1` (wrapped) so the untouched OEM `±1` lands on the target. If nothing is found: toast "No channels in zone" and `param.setResult(null)` (cancel). Edge: because OEM clamps instead of wrapping, a preset of `maxChannelId-1` for an UP move to index 0 gets clamped — wrap-around across the list end silently fails to move.

`ReceiveSoundState.processMessage(Message)` (12284-12311): OEM's receive state (`OEM/state/TalkBackStateMachine.java:378-430`) handles 2016/2017/2018 and ignores `MSG_CHANNEL_CHANGE` (2021); the hook intercepts 2021, reads `sm.fragment`, calls `fragment.updateChannelId((Boolean) msg.obj)` and returns `true`, enabling channel changes during reception.

### 8.2 Channel list (`hookChannelListFilter`, 12383-12625)

Inner adapter located by name `DeviceAreaListAdapter` (`OEM/…ChannelFragment.java:169`).
- `getCount()` **replaced**: counts `channels` minus APRS-hijack channels, filtered by zone if set (empty zone list ≡ no filter).
- `getView(int,View,ViewGroup)` before: rewrites `args[0]` from filtered position to real index (same skip logic).
- `onItemClick(AdapterView,View,int,long)` before: rewrites `args[2]` likewise (OEM then activates `channels.get(i)`).
- `updateView()` **replaced** with `initData()`: OEM `updateView` (`OEM/…:126-129`) reassigns `channels = getChannelList()` without `notifyDataSetChanged`, which with the replaced `getCount` produced an empty list; `initData` (`OEM/…:82-108`) reloads channels, rebuilds the adapter and re-selects the active row.

### 8.3 Zone badge / buttons

- Channel page (`hookChannelListUI`, 12630-12759): after `initData()`, adds `Button` tag `DMR_CHANNEL_ZONE_BTN` ("Zone: <name>", white 12sp, royal-blue pill, 100 dp) top-right of `mLocalView` if it is a `FrameLayout`, else wraps it in an overlay `FrameLayout` added to the parent. Duplicate guard by tag (updates text). Click → `showZoneSelectionDialog(ctx, button, fragment)` (12764-12832): list "All Channels" + `name (N)`; selection updates `currentZone*`, both buttons' text, calls `fragment.initData()`.
- Intercom (`initView`, 1677-1786): "Zone: All" cyan pill. Click **does not open the dialog directly**: `performClick()` on the bottom `channel` tab, then after 300 ms `channelPageZoneButton.performClick()`; falls back to `showZoneSelectionDialog(context)` if the tab isn't found.
- `showZoneSelectionDialog(Context)` (11976-12161, intercom variant): same list; additionally, if the current channel's `_id` is not in the selected zone, 300 ms later switches to the **first** zone channel by setting `mCurrentChannelIndex`/`mCurrentChannelData` on the fragment, `DmrManager.updateChannel(target)` (DB update + `syncChannelInfo(ch)` — which only syncs if `active==1`) and `syncChannelInfoWithData(target)`. Zone with no valid channels → toast only.

### 8.4 Edge cases

- Empty zone (`currentZoneChannels.isEmpty()`) is treated as **no filter** in both navigation and list.
- "All" = `currentZoneId=-1`, `currentZoneChannels=null`.
- Zone state is static and survives app restarts (not reset in §1.5); the channel-page button re-reads `currentZoneName` on `initData`.
- After editing a channel's zone, `saveChannelData` after-hook reloads `currentZoneChannels` and calls `channelFragmentInstance.initData()` (14530-14553).
- `isAPRSChannel` (311-324) hides channels named `"APRS (…"` from the list in all modes.

---

## 9. Channel editor hooks (`hookChannelEditActivity`, 13941-14604)

| Target | Kind | Original | Hook |
|---|---|---|---|
| `ChannelData()` no-arg ctor | after ctor | `OEM/serial/data/ChannelData.java:83-111` defaults: type 0, freqs 401.025 MHz, power 1, cc 1, contactType 0, txContact 1, relay 2, **band 0**, sq 2, groups `[1,0…]` | `band = 1` (wide 25 kHz) — process-wide default |
| `InterPhoneChannelActivity.onCreate(Bundle)` | after | `OEM/activity/InterPhoneChannelActivity.java:176-182`: `setContentView`, `initView`, `initData` | injects rows + theme + help icons + TG display fix (below) |
| `InterPhoneChannelActivity.saveChannelData()` | before/after | `OEM/…:637-…`: validates, builds `channelData` from the form (txContact = parsed call-number EditText; `contactType` ALL → 16777215; `groups = gridAdapter.getGroupList()`), persists, `finish()` | before: TG→contact-id conversion (see caveat); after: zone + TG-list persistence |

**onCreate additions** (container = child 0 of `ScrollView` `all_options`):
- Dark theme post: system bars, content root, scroll view, container and every row → navy (14001-14018).
- **Zone row** at index 3 (after the channel-type row): built with OEM dimens/colours (`interphone_channel_content_height/_margin_left/_title_size/…`, `pri_text_color`, background `interphone_channel_content_background_seletor`, split drawable `interphone_channel_more_split`): title "Zone", ⓘ help icon, separator, value = `ZoneDatabase.getZoneName(getZoneIdForChannel(_id))` or "None". Click → `showChannelEditZoneDialog` (13263-13438: "None", zones with ✏ edit icon, "Create New Zone…"; long-press/✏ → rename; selection stored in `selectedZoneId[0]` and additional instance field `dmrmod_selectedZoneId`).
- **TG List row** at index 4, **digital channels only** (`type==0`): title "TG List", ⓘ, value = `TGListDatabase.getTGListNameForChannel(_id)`. Click → `showChannelEditTGListDialog` (12877-13024: "None", lists as `name (N TGs)` with ✏, "Create New TG List…"; selecting/saving stores `dmrmod_selectedTGListId` and immediately `refreshGroupGrid` rewrites the OEM 32-cell `interphone_channel_group_grid` with the list's `getHardwareGroups()`). Editor dialog (13078-13208) takes comma-separated TG IDs, warns beyond `HARDWARE_MAX_GROUPS=32`, has Delete. If the channel already has a list, the grid is auto-populated on open (14281-14288).
- `addChannelPropertyHelpIcons` (13549-13936): fixes labels ("Frequency band", "Send frequency", "Recv frequency") and inserts an `ic_menu_info_details` icon after the label in rows `interphone_channel_name/type/frequency_band/power/relay_disconnecte/color/mode_type/slot_type/contact_type/contact/encryption/interrupt_transmission/band/sq/txtype/txsubcode/rxtype/rxsubcode` (only if visible) and a header-row variant for `interphone_channel_group_list`; each opens an explanatory `AlertDialog`.
- "Group number display fix" (14302-14362): treats `channelData.txContact` as a `contact_database._id`, looks up `contact_number` and writes it into `interphone_channel_call_name_set` (the OEM `mTvChannelCallNumber` EditText, `OEM/…:248-249`).

**saveChannelData before-hook (14378-14485).** Intends to convert the typed TG number back into a contact `_id`. It only proceeds when `channelType == 1 && contactType == 0`, with comments calling that "Digital + Group" — but `ChannelData.type` is **0 = Digital, 1 = Analog** and `contactType` **0 = PERSON, 1 = GROUP** (`OEM/…TalkBackFragment.java:208, 231-240`; `OEM/…ChannelActivity.java` save path). So the conversion effectively runs only for *analog* channels with contactType 0 — i.e. never for DMR group channels; for them the OEM code stores the typed TG number directly into `txContact`, which is consistent with Pitfall 12 (txContact holds the DMR ID/TG, not `_id`). The "display fix" in `onCreate` therefore rewrites the field only when the TG number happens to collide with a contact row id.

**saveChannelData after-hook (14488-14594).** Reads `dmrmod_selectedZoneId` → `ZoneDatabase.removeChannelFromAllZones(_id)` then `addChannelToZone(zone,_id)` if >0; refreshes the channel list; reads `dmrmod_selectedTGListId` → `assignTGListToChannel` and **writes `tgList.getHardwareGroups()` into `channelData.groups` followed by `DmrManager.updateChannel(channelData)`** (persists to `channel_groups` and re-syncs hardware) or `removeAssignmentForChannel`. Runs after OEM already saved and (typically) called `finish()`.

---

## 10. Serial logging & debug packet injection

### 10.1 `hookSerialCommunication` (11570-11637)

- Log dir created at hook-install time: `/sdcard/DMR/uart_logs/`; files `uart_<yyyyMMdd_HHmmss>.bin` and `.txt`, one pair per process lifetime (11575-11584).
- Hooks (before): `SerialManager.send(Packet)` (`OEM/serial/SerialManager.java:95-99`: writes the packet to `/dev/ttyS0` @ 57600 8N1, `OEM/serial/port/SerialPort.java:25`) → "TX"; `MessageDispatcher.onReceive(Packet, SerialPort)` (`OEM/serial/MessageDispatcher.java:78-88`: looks up the handler for `packet.cmd` and runs `handler.handle(packet)` on an executor) → "RX". Packet level, after framing/checksum, not raw bytes.
- `logPacketData` (11643-11783) spawns **one thread per packet**, reflects `head, cmd, rw, sr, ckSum, len, body, tail` (`OEM/protocol/Packet.java:11-18`; head 0x68, tail 0x10) and appends:
  - `.bin`: `[dir 0x01/0x02][8-byte BE millis][head][cmd][rw][sr][ckSum BE 2][len BE 2][body…][tail]`.
  - `.txt`: human block with `CMD: 0xNN (n) <getCmdName>`, RW/SR/checksum/len/tail, 16-per-line hex body, and — only when `cmd == 22 && body.length >= 163` — a "DigitalMessage" field parse (rxFreq, txFreq, localId, 32 groups, txContact@140, contactType@144, power/cc/slot@145-147). Also `XposedBridge.log("UART TX/RX cmd=…")` per packet.

### 10.2 `getCmdName` (11788-11798) vs OEM `Const.Command` (`OEM/protocol/Const.java:32-62`) / `Packet.cmd2Str`

| `getCmdName` case | Label given | Actual OEM meaning |
|---|---|---|
| 1 | RECEIVE_START | not a command (ModuleStatus 1) |
| 2 | RECEIVE_STOP | not a command |
| 10 | MIX_CHECK_DIGITAL_RECEIVE_START | not a command |
| 22 | SET_DIGITAL_INFO_CMD | **wrong**: SET_DIGITAL_INFO_CMD = 34 (0x22). Decimal 22 is unused → the DigitalMessage parse branch never fires |
| 35 | INTERRUPT_TRANSMIT_CMD | **wrong**: 35 = SET_ANALOG_INFO_CMD; INTERRUPT_TRANSMIT_CMD = 53 (0x35) |
| 63 | TEST_BIT_ERROR_RATE | correct |
| other | UNKNOWN | use `Packet.cmd2Str(int)` (`OEM/protocol/Packet.java:20-82`) for the full table: 34 SET_DIGITAL_INFO, 35 SET_ANALOG_INFO, 36/37 QUERY_*_INFO, 39 QUERY_INIT_STATUS, 43 QUERY_DIGITAL_AUDIO_RECEIVE_INFO, 44/45 SEND/RECEIVE_SMS, 48 SET_SQUELCH, 50 QUERY_SIGNAL_STRENGTH, 53 INTERRUPT_TRANSMIT, 54 MODULE_PRINT_STATUS_INFO, −86 MODULE_INIT |

The hex-vs-decimal mix-up (0x22→22, 0x35→35) is the root cause; recommended fix is to delegate to `Packet.cmd2Str`.

### 10.3 Debug packet receiver (11865-11971)

`registerDebugPacketReceiver` hooks `android.app.Application.onCreate()` (after) and registers an **exported** `BroadcastReceiver` for action `com.dmrmod.SEND_DEBUG_PACKET` (`RECEIVER_EXPORTED`, API 33+). `handleDebugPacket` builds `new Packet((byte) CMD)`, sets `rw` (default 1), `sr` (default 1), body from hex extra `BODY` (whitespace stripped) or `{0x01}`, and calls `SerialManager.getInstance().send(packet)` — note it bypasses `BaseMessage.encode()`, so `rw/sr` are whatever you pass.

```sh
# query signal strength (cmd 50 / 0x32) with default body {01}
adb shell am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 50 --ei RW 1 --ei SR 1
# raw body
adb shell am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 0x30 --ei RW 1 --ei SR 1 --es BODY "02"
```
(`am` parses `--ei` with `Integer.decode`, so hex works.) Replies appear in the UART log and in `logcat | grep DMRModHooks`.

---

## 11. Practical section

### 11.1 Adding a hook (template as used throughout)

```java
private void hookSomething(XC_LoadPackage.LoadPackageParam lpparam) {
    try {
        Class<?> cls = XposedHelpers.findClass("com.pri.prizeinterphone.pkg.Cls", lpparam.classLoader);
        XposedHelpers.findAndHookMethod(cls, "method", ArgType.class, new XC_MethodHook() {
            @Override protected void afterHookedMethod(MethodHookParam param) {
                try { /* work; UI via activity.runOnUiThread / view.post */ }
                catch (Throwable t) { XposedBridge.log(TAG + ": ✗ hookSomething: " + t.getMessage()); }
            }
        });
        XposedBridge.log(TAG + ": ✓ hooked Cls.method");
    } catch (Throwable t) { XposedBridge.log(TAG + ": ✗ Failed to hook Cls: " + t.getMessage()); }
}
```
Then add the call to `handleLoadPackage` (append at the end; if another hook already targets the same method, do not rely on registration order — same-priority Xposed callbacks are ordered by identity hash, see §1.3 — use `XC_MethodHook(priority)` if ordering matters). Use `XC_MethodReplacement` only when OEM behaviour must not run (`setTalkbackRecordBg`, `updateChannelNumber`, `getCount`, `updateView`). Verify the exact signature in `OEM/` first; parameter classes for OEM types must be loaded via `XposedHelpers.findClass(..., lpparam.classLoader)` (e.g. `ChannelData`, `Packet`).

### 11.2 Adding a button to the intercom page safely

1. Create it inside the `initView` after-hook **after** the `alreadyModified` guard (1385-1398) and give it a unique `setTag("DMR_…")`.
2. Put it in `buttonContainer` (`FrameLayout.LayoutParams` with gravity + dp margins; existing slots: left x=8 dp, right x=16 dp; rows top 8/66/124 dp, 52 dp tall) or a new row inserted with an explicit index before `borderBox`.
3. Store the static ref (so `updateUI`/handlers can reach it) and remember it is overwritten on every fragment re-create — never keep per-view state only in statics.
4. Drive visibility from `updateUI` if it depends on channel type (see MON/POS at 2973-2979).
5. Do hardware writes on a background thread or directly (UART `send` is quick), UI only via `post`.

### 11.3 Finding OEM views/resources from the module

`int id = ctx.getResources().getIdentifier("fragment_talkback_send", "id", ctx.getPackageName()); View v = root.findViewById(id);` (3027-3035). Same with `"drawable"`, `"dimen"`, `"color"`, `"layout"` (14046-14118). OEM fragment fields: `XposedHelpers.getObjectField(fragment, "mLocalView")` (the content root) — `mRootView` is the base pager view, `mFragmentContainer` its `FrameLayout`. Module resources: `ctx.createPackageContext("com.dmrmod.hooks", Context.CONTEXT_IGNORE_SECURITY).getResources().getIdentifier(name, "drawable", "com.dmrmod.hooks")` (1999-2003).

### 11.4 Common failure modes

| Symptom | Cause | Fix |
|---|---|---|
| `NoSuchMethodError` / `ClassNotFoundError` at install, hook silently absent | wrong OEM path (`serial.data.ChannelData`, `protocol.Packet`, `serial.MessageDispatcher`, `handler.ModuleStatusMessageHandler`), wrong param types, private-method name changed | grep `OEM/` for the signature; use `findClass` for OEM param types |
| Duplicate buttons / rows | hook ran twice on the same view (e.g. `initData` called by refresh) | guard with `findViewWithTag` (see 12671-12679) |
| `CalledFromWrongThreadException` | handler hooks run on the dispatcher executor, PCM hook on `readpcm` | `view.post`/`runOnUiThread` |
| UI refs null after restart | Zygisk keeps statics; views belong to a dead activity | null-check every static view; reset in `hookMainActivity` |
| Squelch stuck closed after channel change | state machine re-sent `sq=2` after the 300 ms reset (Pitfall 13) | touch the slider (re-runs `enable…`) |
| Toggle shows OFF but feature ON | `isRecordingEnabled`/`isTranscriptionEnabled` persist while the new toggles default to unchecked (2017, 2223) | click twice, or set `setChecked(flag)` like SOFT SQ does (2131) |

### 11.5 Debugging

`adb logcat | grep DMRModHooks` (Xposed log lines are also in LSPosed's log viewer). Conventions in this file: `✓` success / step done, `✗` failure, `⚠️` recoverable anomaly, `◆`/`===` section markers in packet dumps, `🔥`/`⚡` forcing points in the MON/VFO path. OEM classes also log under their own tags (`DmrManager`, `PCMReceiveManager`, `TalkBackStateMachine`), and `sendDigitalMessage` in the decompiled source carries extra `DMRModHooks_GroupDebug` lines (`OEM/manager/DmrManager.java` sendDigitalMessage body).

---

## 12. Gotchas & doc drift (vs `.grok/rules/copilot-instructions.md`)

- ⚠️ **Doc drift — "Key Hook Methods → hookApplication grabs the app ClassLoader".** `appClassLoader` is set in `handleLoadPackage` (335); `hookApplication` only fixes directories and migrates zones.
- ⚠️ **Doc drift — "Software Squelch Architecture" / "Channel Change State Management" / Pitfall 6 place the `sendAnalogMessage` sq=0 hook in `hookDmrManager`.** The forcing + 300 ms reset lives in `hookChannelNavigation` (12329-12371); `hookDmrManager`'s `sendAnalogMessage` hook is an after-hook that only logs (10534-10560). Behaviour matches the doc's code snippet otherwise.
- ⚠️ **Doc drift — "Critical State Variables":** `savedIntercomSquelchThreshold` default is **5**, not 2 (224); the APRS-page button static is `aprsMonitoringToggleButton`, not `aprsToggleButton` (218); `softwareSquelchContainer` is a `LinearLayout`, not `View` (215); the VFO parameters (`vfoFrequencyMHz`, `vfoLocalId`, `vfoBandWidth`, …) are **not** `volatile` (262-305).
- ⚠️ **Doc drift — "Frequently-Hooked OEM Class Paths":** the real classes are `InterPhoneHomeActivity` (root package, not `ui.activity.MainActivity`), `fragment.InterPhoneTalkBackFragment`/`InterPhoneLocalFragment` (not `ui.fragment.TalkBackFragment`), `handler.ModuleStatusMessageHandler`, `protocol.Packet` (not `serial.communication.Packet`), `serial.MessageDispatcher` (not `protocol.MessageDispatcher`). `getContactNameForDmrId(long, Context)` does not exist — the lookup is `lookupContactName(Context,int)` / `lookupCallerDisplayInfo` with a RadioID second tier the doc does not mention.
- ⚠️ **Doc drift — "Audio Pipeline Hook Pattern" execution order.** Actual order: (1) conditional pre-squelch copy, (2) amplitude, (3) squelch + mute, (4) VU update, (5) decoders/transcription/recording from the copy. The copy is made only when a consumer is active; the doc lists amplitude first and does not mention the recording write happening on the audio thread.
- ⚠️ **Doc drift — Pitfall 14 reset list.** `isVFOModeActive` is only cleared when already true (cosmetic); `isMonitoringMode`, `isSoftwareSquelchEnabled`, `isAprsSoftwareSquelchEnabled`, `isRecordingEnabled`, `isTranscriptionEnabled`, zone state and `currentChannelType` are **not** reset at launch. The doc's "check for `APRS (`/`SSTV (` prefix" is implemented by the four `checkAndRestore*OnStartup` calls at +2 s.
- ⚠️ **Doc drift — Pitfall 9/slider.** Consistent: the slider only sets `softwareSquelchThreshold`; hardware is always 0 (on) or 2 (off). Note the slider value is persisted through `APRSDatabase.setAprsSquelch`, the same key as the APRS page — this is the concrete mechanism behind Pitfall 10.
- Pitfalls 2, 3, 8, 13 match the code (reset block at 12355-12360; VU gating at 10064; direct `AnalogMessage.send()` at 10382/10452; 300 ms `postDelayed` at 12353-12368).
- **Software squelch gates digital audio too** when `isSoftwareSquelchEnabled` is left on (no channel-type check at 9966), even though the toggle is hidden on digital channels.
- **`getCmdName` mislabels commands** (§10.2) and the UART "DigitalMessage" parse never triggers (checks `cmd == 22`, real value 34).
- **`saveChannelData` before-hook type/contactType test is inverted** (§9): the TG→contact-id conversion never runs for DMR group channels; the OEM stores the raw TG in `txContact` anyway (consistent with Pitfall 12), so the practical effect is nil except the misleading logs and the `onCreate` "display fix" which may overwrite a TG with an unrelated `contact_number` when ids collide.
- **Dead state:** `squelchStatusIndicator`, `squelchStatusTextView`, `activeTGList`, `lastUsedChannelPerZone`, `isAutoSwitchingZone` are never written; `addBackupButton`, `openBackupActivity`, `hookSpeechRecognizer`, `hookSystemRecognitionService`, `testBootloaderAccess`, `hookUpdateFirmwareActivity` are never called.
- **Double hooks on one method:** `InterPhoneHomeActivity.onCreate` (`hookMainActivity`, `hookBottomNavBar`), `InterPhoneLocalFragment.initView` (`hookLocalFragment`, `hookOtherFragmentBackgrounds`), `DmrManager.sendAnalogMessage` (`hookDmrManager`, `hookChannelNavigation`), `Application.onCreate` (`hookApplication` on the subclass, `registerDebugPacketReceiver` on the base class).
- `updateLocationDisplay` keys `LocationDatabase` by `mCurrentChannelIndex + 1`, whereas history/zone code uses `number`/`_id` — these diverge when channels are deleted or re-ordered.
- `Geocoder.getFromLocation` is called synchronously on the UI thread in `initView`/`updateUI` (3201) — can jank or ANR without network.
- `hookSerialCommunication` opens and closes two files on a new thread for **every** UART packet (11644-11782); for high-rate traffic (audio-adjacent status packets) this is measurable I/O.
- `activityHistory` (`LinkedList`) is mutated from the dispatcher thread and the history-load background thread without a lock.
- `strings.xml` still labels the module "v0.2"; the authoritative version is `build.gradle`/`MainHook.VERSION`.
