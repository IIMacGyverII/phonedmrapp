# 14 — Hook / Integration Cross-Reference (DMRModHooks ↔ PriInterPhone)

Machine-verified inventory of every point where the LSPosed module (`DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`, 16,306 lines, plus helpers in the same package) touches the OEM app `com.pri.prizeinterphone` (decompiled at `app/src/main/java/com/pri/prizeinterphone/`, resources at `app/src/main/res/`). Every row was checked by opening both files.

## Summary

| Metric | Count |
|---|---|
| Hook installation sites in `MainHook.java` (`findAndHookMethod` ×40, `findAndHookConstructor` ×1) | **41** |
| Distinct hooked (class, method) targets after loop expansion (8 activities + 4 fragments) | **51** |
| …of which target OEM classes | **46** (all CONFIRMED) |
| …of which target Android framework classes | **5** — 4 speech-recognizer research hooks (never wired — no call site in `handleLoadPackage`) + `android.app.Application.onCreate` (11872, wired; fires for `PrizeInterPhoneApp` via its `super.onCreate()`) |
| …OEM hooks installed but **not wired** (`hookUpdateFirmwareActivity` commented out at MainHook.java:367) | 1 |
| Distinct `com.pri.*` classes looked up by name (`findClass` / `Class.forName`) | **40** → 39 CONFIRMED, **1 NOT FOUND** (`manager.SerialManager`) |
| Distinct reflective (OEM class, member) pairs (`get/setXField`, `callMethod`, `callStaticMethod`, `newInstance`, `java.lang.reflect`) — counted per runtime class actually accessed, hook-only members (§1) excluded | **113** → 110 CONFIRMED, **3 NOT FOUND** (all on the missing `manager.SerialManager`, dead code). Every module line cited in §3 (531 cites) was re-checked mechanically against `MainHook.java` |
| OEM resource names looked up via `getIdentifier` | **53** → 49 CONFIRMED, **4 NOT FOUND** (3 are deliberate fallback probes, 1 is a silent gap: `interphone_channel_contact`) |
| OEM SQLite table.column references | **2 DB files / 2 tables / 31 table.column pairs (30 distinct names — `_id` is in both tables)** → all CONFIRMED; DB-file name is **PARTIAL** (module hard-codes the `channel_area_default_uhf` area only) |
| OEM SharedPreferences keys | 1 (`pref_person_device_id` in `com.pri.prizeinterphone.data.person`) → CONFIRMED |
| OEM broadcast/intent actions used by module | 0 (module uses only its own `com.dmrmod.SEND_DEBUG_PACKET`) |
| ⚠️ Doc-drift callouts against `.grok/rules/copilot-instructions.md` | 9 |

**How to use this table.** Section 1 is keyed by module line (the `findAndHookMethod` call). Section 2/3 are keyed by OEM class. Section 7 (reverse index) lists, per OEM class, every module line that would need attention if that class changes. "CONFIRMED file:line" means the member was opened in the OEM source at that line; "NOT FOUND" means it does not exist in the decompiled tree and the module path will throw (`ClassNotFoundError` / `NoSuchFieldError` / `NoSuchMethodError`), caught or not as noted. All OEM paths below are relative to `app/src/main/java/com/pri/prizeinterphone/`; module paths are relative to `DMRModHooks/app/src/main/java/com/dmrmod/hooks/`.

---

## 1. Method / constructor hooks (every `findAndHookMethod` / `findAndHookConstructor`)

Legend: B = beforeHookedMethod, A = afterHookedMethod, R = `XC_MethodReplacement`. "Installer" is the enclosing `MainHook` method; "Wired" = called from `handleLoadPackage` (MainHook.java:326-415).

| # | Module line | Installer | OEM class (FQN under `com.pri.prizeinterphone`) | Method(params as passed) | Type | What the hook does | OEM confirmation / what original does |
|---|---|---|---|---|---|---|---|
| 1 | 459 | `hookBottomNavBar` (wired :404) | `InterPhoneHomeActivity` | `onCreate(Bundle)` | A | Calls `applyBottomNavStyle(activity,"talkback")` on UI thread | CONFIRMED InterPhoneHomeActivity.java:144 — inflates home layout, view pager, tap bar |
| 2 | 474 | `hookBottomNavBar` | `InterPhoneHomeActivity` | `tapOnClick(View)` | A | Re-paints the 5 tab children after OEM switches page | CONFIRMED :358 — OEM bottom-tab click handler (switches ViewPager item) |
| 3 | 600 | `hookMessageDisplay` (wired :401) | `activity.MessageContentActivity$MessageListAdapter` | `getView(int, View, ViewGroup)` | A | Reads `holder.mTvValues`, linkifies GPS coords, moves Copy/Delete dialog to long-press via `showListDialog(int)` | CONFIRMED MessageContentActivity.java:369 (`getView(final int i, View view, ViewGroup viewGroup)`); inner non-static class :338 so `this$0` exists |
| 4 | 724 | `hookSpeechRecognizer` (**NOT wired**) | `android.speech.SpeechRecognizer` (framework) | `createSpeechRecognizer(Context, ComponentName)` | A | Legacy on-device STT research | Not an OEM class; never installed |
| 5 | 766 | `hookSpeechRecognizer` (**NOT wired**) | `android.speech.SpeechRecognizer` | `createSpeechRecognizer(Context)` | A | same | Not OEM; never installed |
| 6 | 806 | `hookSystemRecognitionService` (**NOT wired**) | `android.app.ContextImpl` | `bindService(Intent, ServiceConnection, int)` | A/B | same | Not OEM; never installed |
| 7 | 908 | `hookSystemRecognitionService` (**NOT wired**) | `com.android.server.speech.SpeechRecognitionManagerServiceImpl` | `bindService(Intent, ServiceConnection)` | A | same | Not OEM; class does not exist in the app process — would throw `ClassNotFoundError` if ever wired |
| 8 | 961 | `hookApplication` (wired :350) | `PrizeInterPhoneApp` | `onCreate()` | B | Creates `shared_prefs/` and `databases/` dirs if missing; runs `ZoneDatabase` one-time migration | CONFIRMED PrizeInterPhoneApp.java:15 — inits `DmrManager`, notifications, starts `InterPhoneService` |
| 9 | 1037 | `hookMainActivity` (wired :353) | `InterPhoneHomeActivity` | `onCreate(Bundle)` | B+A | Status-bar/theme, resets APRS/SSTV/NOAA/VFO state, restores hijacked channels (`checkAndRestore*OnStartup`) | CONFIRMED :144 |
| 10 | 1229 | `hookTalkBackFragment` (wired :356) | `fragment.InterPhoneTalkBackFragment` | `initView(View)` | A | Main UI surgery: caller panel, RSSI, squelch toggle, zone button, GPS send, transcription toggle; captures `talkBackFragmentInstance` | CONFIRMED InterPhoneTalkBackFragment.java:149 — findViewById wiring of PTT screen |
| 11 | 2873 | `hookTalkBackFragment` | `fragment.InterPhoneTalkBackFragment` | `updateUI()` | A | Re-reads `mCurrentChannelData` (number/type/rxType/rxSubCode/sq/txContact) and refreshes module widgets + channel history | CONFIRMED :191 — OEM refresh of channel labels |
| 12 | 3058 | `hookTalkBackFragment` | `fragment.InterPhoneTalkBackFragment` | `setTalkbackRecordBg(int)` | **R** | Replaces PTT button drawable with module drawables `interphone_talkback_record/recording/recv` | CONFIRMED :584 (`public void setTalkbackRecordBg(final int i)`) |
| 13 | 3100 | `hookTalkBackFragment` | `fragment.InterPhoneTalkBackFragment` | `updateChannelNumber()` | **R** | Draws the 2 channel digits using module drawables `interphone_talkback_num_0..9` | CONFIRMED :365 (`private void updateChannelNumber()`) |
| 14 | 3616 | `hookInformationActivity` (wired :362) | `activity.FragmentLocalInformationActivity` | `initView()` | A | Appends `DMRModHooks vX` to `mTvSoftwareVersion`, injects "MacGyver Mod" row after `mTvDmrFirmwareVersion`, GitHub link | CONFIRMED FragmentLocalInformationActivity.java:35 (`private void initView()`) |
| 15 | 3813 | `hookUpdateFirmwareActivity` (**NOT wired**, MainHook.java:367) | `activity.UpdateFirmwareActivity` | `handleMsgFromSvc(YModemTXMsg)` | A | On YModem step 32/64: flush UART, resend `sendQueryInitializedCmdToMdl`×3 and `sendSetChannelCmdToMdl` | CONFIRMED UpdateFirmwareActivity.java:230; steps CONFIRMED ymodem/YModem.java:17 (`STEP_END=32`), :19 (`STEP_ERROR=64`). Body references missing `manager.SerialManager` (see §2) |
| 16 | 3959 | `hookLocalFragment` (wired :359) | `fragment.InterPhoneLocalFragment` | `initView(View)` | A | Adds Backup / Packet-Radio buttons next to `local_exit_app` | CONFIRMED InterPhoneLocalFragment.java:85 |
| 17 | 8459 | `hookModuleStatusHandler` (wired :370) | `handler.ModuleStatusMessageHandler` | `handle(ModuleStatusMessage)` | A | Reads `getStatus()`; drives RX/TX/idle activity indicator, caller lookup, recording start/stop | CONFIRMED ModuleStatusMessageHandler.java:19 — sends ACK packet, forwards status to `DmrManager.onModuleStatusReceived` |
| 18 | 8656 | `hookDigitalAudioHandler` (wired :371) | `handler.DigitalAudioMessageHandler` | `handle(DigitalAudioMessage)` | B+A | Reads `message.packet.body` → callType `body[0]`, caller DMR ID `body[1..3]` LE; RadioID/contact lookup; optional call-type filtering vs `getCurrentChannel().getContactType()` | CONFIRMED DigitalAudioMessageHandler.java:8 (16-line class; `handle` is empty in OEM) |
| 19 | 9938 | `hookPCMReceiveManager` (wired :374) | `manager.PCMReceiveManager` | `writeAudioTrack(byte[], int)` | B | Software squelch (mutes by zeroing/skipping), recording to PCM/MP3/WAV, transcription buffer, APRS/SSTV/NOAA decoders, sound-bar level | CONFIRMED PCMReceiveManager.java:124 — writes PCM to `AudioTrack` |
| 20 | 10472 | `hookSignalMessageHandler` (wired :377) | `handler.SignalMessageHandler` | `decode(Packet)` | A | Reads `packet.body` → RSSI; updates `currentRssi`, RSSI display | CONFIRMED SignalMessageHandler.java:12 — `new SignalMessage(packet)` |
| 21 | 10534 | `hookDmrManager` (wired :380) | `manager.DmrManager` | `sendAnalogMessage(ChannelData)` | A | Records `sq` of the channel just programmed (soft-squelch bookkeeping) | CONFIRMED DmrManager.java:369 (**private** — Xposed hooks private methods fine) — builds `AnalogMessage` from `ChannelData` and `.send()` |
| 22 | 10565 | `hookDmrManager` | `manager.DmrManager` | `sendDigitalMessage(ChannelData)` | B | In monitoring mode forces `contactType=2`, `txContact=16777215`; logs `groups` | CONFIRMED :329 (**private**) — builds `DigitalMessage`, sets `localId=getLocalId()` |
| 23 | 10619 | `hookDmrManager` | `message.DigitalMessage` | `encodeBody()` | B+A | Final force of `contactType/txContact` before serialisation; logs bytes | CONFIRMED DigitalMessage.java:129 (`protected byte[] encodeBody()`) |
| 24 | 10697 | `hookDmrManager` | `message.AnalogMessage` | `encodeBody()` | B | Logs `sq`/`monitor` before serialisation | CONFIRMED AnalogMessage.java:56 (`protected`) |
| 25 | 10744 | `hookDmrManager` | `message.BaseMessage` | `send()` | B | For `DigitalMessage` instances: ALL-mode force + **VFO `localId` override** (10801); for `AnalogMessage`: logs sq/monitor | CONFIRMED BaseMessage.java:35 — `encode()` then `SerialManager.getInstance().send(packet)` |
| 26 | 11599 | `hookSerialCommunication` (wired :395) | `serial.SerialManager` | `send(Packet)` | B | Logs TX packet (head/cmd/rw/sr/ckSum/len/body/tail) to `/sdcard/DMR/uart_logs/uart_<ts>.bin/.txt` | CONFIRMED serial/SerialManager.java:95 |
| 27 | 11620 | `hookSerialCommunication` | `serial.MessageDispatcher` | `onReceive(Packet, SerialPort)` | B | Logs RX packet | CONFIRMED serial/MessageDispatcher.java:78 (`onReceive(final Packet packet, SerialPort serialPort)`) |
| 28 | 11872 | `registerDebugPacketReceiver` (wired :398) | **`android.app.Application`** (framework — `findClass("android.app.Application")` at 11868, *not* `PrizeInterPhoneApp`) | `onCreate()` | A | Registers exported receiver for `com.dmrmod.SEND_DEBUG_PACKET` (extras CMD/RW/SR/BODY) → `handleDebugPacket` | Framework method; reached because `PrizeInterPhoneApp.onCreate()` calls `super.onCreate()` (PrizeInterPhoneApp.java:15-16). Fires for every `Application` in the process, which in the OEM process is only `PrizeInterPhoneApp` |
| 29 | 12174 | `hookChannelNavigation` (wired :383) | `fragment.InterPhoneTalkBackFragment` | `updateChannelId(boolean)` | B | Zone-filtered channel up/down: computes next `_id` within zone, sets `mCurrentChannelIndex`, lets OEM continue or replaces | CONFIRMED :288 (`public void updateChannelId(final boolean z)`) |
| 30 | 12289 | `hookChannelNavigation` | `state.TalkBackStateMachine$ReceiveSoundState` | `processMessage(android.os.Message)` | B | If `msg.what==2021` (MSG_CHANNEL_CHANGE) during RX, routes to `fragment.updateChannelId(isUp)` and returns `true` | CONFIRMED TalkBackStateMachine.java:378; inner class :360; `MSG_CHANNEL_CHANGE=2021` :9 |
| 31 | 12329 | `hookChannelNavigation` | `manager.DmrManager` | `sendAnalogMessage(ChannelData)` | B | Second hook on same method: if soft-squelch active, forces `channelData.sq=0` before hardware programming (Pitfall 2 fix) | CONFIRMED :369 |
| 32 | 12406 | `hookChannelListFilter` (wired :386) | `fragment.InterPhoneChannelFragment$DeviceAreaListAdapter` (found via `getDeclaredClasses()` name match) | `getCount()` | **R** | Returns count of `outerFragment.channels` filtered to current zone | CONFIRMED InterPhoneChannelFragment.java:187; inner class :169 |
| 33 | 12459 | `hookChannelListFilter` | `…$DeviceAreaListAdapter` | `getView(int, View, ViewGroup)` | B | Remaps filtered position → real index in `channels` | CONFIRMED :192 |
| 34 | 12527 | `hookChannelListFilter` | `fragment.InterPhoneChannelFragment` | `onItemClick(AdapterView, View, int, long)` | B | Remaps filtered position before OEM handles click | CONFIRMED :132 (`onItemClick(AdapterView<?> adapterView, View view, int i, long j)`) |
| 35 | 12603 | `hookChannelListFilter` | `fragment.InterPhoneChannelFragment` | `updateView()` | **R** | Calls `initData()` so the list reloads under the zone filter | CONFIRMED :126 (overrides BaseViewPagerFragment.updateView :52) |
| 36 | 12638 | `hookChannelListUI` (wired :389) | `fragment.InterPhoneChannelFragment` | `initData()` | A | Adds Zone selector button into `mLocalView`; stores `channelFragmentInstance` | CONFIRMED :82 |
| 37 | 13956 | `hookChannelEditActivity` (wired :392) | `serial.data.ChannelData` | **constructor `()`** | A | `setIntField(this,"band",1)` — default new channels to UHF | CONFIRMED ChannelData.java:83. Only the no-arg ctor is hooked; the 25-arg ctor (:113) and `ChannelData(Parcel)` (:371) are not |
| 38 | 13968 | `hookChannelEditActivity` | `activity.InterPhoneChannelActivity` | `onCreate(Bundle)` | A | Injects Zone + TG-List rows into `all_options` scroll view, help icons on 19 rows, TG-number relabel on `interphone_channel_call_name_set` | CONFIRMED InterPhoneChannelActivity.java:176 |
| 39 | 14373 | `hookChannelEditActivity` | `activity.InterPhoneChannelActivity` | `saveChannelData()` | B+A | Converts typed TG number → `contact_database._id` (writes `txContact`), persists zone / TG-list, writes `groups[]` and `DmrManager.updateChannel` | CONFIRMED :637 |
| 40 | 16196 (loop ×8) | `hookGenericActivityBackgrounds` (wired :410) | `activity.FragmentLocalSettingsActivity`, `FragmentLocalDeviceAreaActivity`, `FragmentLocalDeviceAreaListActivity`, `FragmentLocalUseAssistantActivity`, `MessageContentActivity`, `FragmentNewContactsActivity`, `RecordListActivity`, `FragmentLocalTestBiteErrorRateActivity` | `onCreate(Bundle)` | A | Dark navy background on `android.R.id.content` | CONFIRMED: Settings:84, DeviceArea:57, DeviceAreaList:56, UseAssistant:11, MessageContent:93, NewContacts:85, RecordList:42, TestBiteErrorRate:26 (`@Nullable Bundle`) |
| 41 | 16241 (loop ×4) | `hookOtherFragmentBackgrounds` (wired :407) | `fragment.InterPhoneChannelFragment`, `InterPhoneContactsFragment`, `InterPhoneMessageFragment`, `InterPhoneLocalFragment` | `initView(View)` | A | Circuit-board background on `mLocalView` + `mFragmentContainer` children | CONFIRMED: Channel:71, Contacts:78, Message:71, Local:85 |

No `XposedBridge.hookMethod`, `hookAllMethods`, or `hookAllConstructors` calls exist in any module file. No hooks exist outside `MainHook.java`.

---

## 2. OEM class lookups (`findClass` / `Class.forName` / `loadClass`)

| OEM class (`com.pri.prizeinterphone.`) | Module lines | OEM path | Status |
|---|---|---|---|
| `InterPhoneHomeActivity` | 454, 1033 | `InterPhoneHomeActivity.java` | CONFIRMED |
| `PrizeInterPhoneApp` | 957, 8852, 9259 | `PrizeInterPhoneApp.java` | CONFIRMED |
| `activity.FragmentLocalDeviceAreaActivity` | 16185 | `activity/FragmentLocalDeviceAreaActivity.java` | CONFIRMED |
| `activity.FragmentLocalDeviceAreaListActivity` | 16186 | `activity/FragmentLocalDeviceAreaListActivity.java` | CONFIRMED |
| `activity.FragmentLocalInformationActivity` | 3612 | `activity/FragmentLocalInformationActivity.java` | CONFIRMED |
| `activity.FragmentLocalSettingsActivity` | 16184 | `activity/FragmentLocalSettingsActivity.java` | CONFIRMED |
| `activity.FragmentLocalTestBiteErrorRateActivity` | 16191 | `activity/FragmentLocalTestBiteErrorRateActivity.java` | CONFIRMED |
| `activity.FragmentLocalUseAssistantActivity` | 16187 | `activity/FragmentLocalUseAssistantActivity.java` | CONFIRMED |
| `activity.FragmentNewContactsActivity` | 16189 | `activity/FragmentNewContactsActivity.java` | CONFIRMED |
| `activity.InterPhoneChannelActivity` | 13944 | `activity/InterPhoneChannelActivity.java` | CONFIRMED |
| `activity.MessageContentActivity` | 16188 | `activity/MessageContentActivity.java` | CONFIRMED |
| `activity.MessageContentActivity$MessageListAdapter` | 597 | `activity/MessageContentActivity.java:338` | CONFIRMED |
| `activity.RecordListActivity` | 16190 | `activity/RecordListActivity.java` | CONFIRMED |
| `activity.UpdateFirmwareActivity` | 3804 | `activity/UpdateFirmwareActivity.java` | CONFIRMED (hook not wired) |
| `fragment.InterPhoneChannelFragment` | 12386, 12633, 16232 | `fragment/InterPhoneChannelFragment.java` | CONFIRMED |
| `fragment.InterPhoneChannelFragment$DeviceAreaListAdapter` | 12390-12397 (via `getDeclaredClasses`) | `…ChannelFragment.java:169` | CONFIRMED |
| `fragment.InterPhoneContactsFragment` | 16233 | `fragment/InterPhoneContactsFragment.java` | CONFIRMED |
| `fragment.InterPhoneLocalFragment` | 3955, 16235 | `fragment/InterPhoneLocalFragment.java` | CONFIRMED |
| `fragment.InterPhoneMessageFragment` | 16234 | `fragment/InterPhoneMessageFragment.java` | CONFIRMED |
| `fragment.InterPhoneTalkBackFragment` | 1225, 12169 | `fragment/InterPhoneTalkBackFragment.java` | CONFIRMED |
| `handler.DigitalAudioMessageHandler` | 8652 | `handler/DigitalAudioMessageHandler.java` | CONFIRMED |
| `handler.ModuleStatusMessageHandler` | 8455 | `handler/ModuleStatusMessageHandler.java` | CONFIRMED |
| `handler.SignalMessageHandler` | 10467 | `handler/SignalMessageHandler.java` | CONFIRMED |
| `manager.DmrManager` | 2354, 2408, 2729, 3892, 5465, 6563, 6878, 6979, 7030, 7141, 8017, 8194, 8235, 8678, 10332, 10403, 10524, 12096, 12322, 14568, 15105, 15317, 15757, 15901, 16068; `DirectDatabaseImporter.java:1263` (`Class.forName`) | `manager/DmrManager.java` | CONFIRMED |
| `manager.PCMReceiveManager` | 9931 | `manager/PCMReceiveManager.java` | CONFIRMED |
| **`manager.SerialManager`** | **3849** (inside `hookUpdateFirmwareActivity`, nested try/catch) | — | **NOT FOUND** — the real class is `serial.SerialManager`. Throws `ClassNotFoundError`, swallowed by `catch (Throwable)` at 3872; UART flush step silently skipped. Dead code today (hook not wired) |
| `serial.SerialManager` | 11590, 11945 | `serial/SerialManager.java` | CONFIRMED |
| `message.AnalogMessage` | 2477, 5517, 6703, 10352, 10421, 10693, 10740, 15867 | `message/AnalogMessage.java` | CONFIRMED |
| `message.BaseMessage` | 10732 | `message/BaseMessage.java` | CONFIRMED |
| `message.DigitalAudioMessage` | 8659, 8806 | `message/DigitalAudioMessage.java` | CONFIRMED |
| `message.DigitalMessage` | 10615, 10736 | `message/DigitalMessage.java` | CONFIRMED |
| `message.ModuleStatusMessage` | 8462 | `message/ModuleStatusMessage.java` | CONFIRMED |
| `message.SignalMessage` | 8826, 10263 | `message/SignalMessage.java` | CONFIRMED |
| `protocol.Packet` | 10475, 11595, 11922 | `protocol/Packet.java` | CONFIRMED |
| `serial.MessageDispatcher` | 11611 | `serial/MessageDispatcher.java` | CONFIRMED |
| `serial.port.SerialPort` | 11616 | `serial/port/SerialPort.java` | CONFIRMED |
| `serial.data.ChannelData` | 5416, 10529, 12326, 13949 | `serial/data/ChannelData.java` | CONFIRMED |
| `serial.data.MessageData` | 2734 | `serial/data/MessageData.java` | CONFIRMED |
| `serial.data.PersonSharePrefData` | 14962, 15128, 15335 | `serial/data/PersonSharePrefData.java` | CONFIRMED |
| `state.TalkBackStateMachine$ReceiveSoundState` | 12285 | `state/TalkBackStateMachine.java:360` | CONFIRMED |
| `ymodem.YModemTXMsg` | 3809 | `ymodem/YModemTXMsg.java` | CONFIRMED |

Implicitly depended-on (never looked up by name, but members are accessed through instances): `serial.data.UtilChannelData` (return type of `DmrManager.getCurrentDbHelper`), `fragment.BaseViewPagerFragment` (`mFragmentContainer`), `activity.MessageContentActivity$MessageListAdapter$ViewHolder` (`mTvValues`), `state.TalkBackStateMachine` (`fragment`).

Non-OEM classes looked up: `android.speech.SpeechRecognizer` (718), `android.app.ContextImpl` (801), `com.android.server.speech.SpeechRecognitionManagerServiceImpl` (902) — research code, not wired; `android.app.Application` (11868) — wired, hooked by `registerDebugPacketReceiver` (§1 #28).

---

## 3. Reflective member access, grouped by OEM class

Variable → type mapping used for attribution: `channel/currentChannel/channelData/ch/aprsChannel/currentChannelData/param.thisObject@13961` → `ChannelData`; `packet` → `Packet`; `digitalMessage` → `DigitalMessage`; `analogMessage` → `AnalogMessage`; `signalMessage/signalMsg` → `SignalMessage`; `message@8667,8716` → `DigitalAudioMessage`; `message@8468` → `ModuleStatusMessage`; `sm` → `TalkBackStateMachine`; `holder` → `MessageListAdapter$ViewHolder`; `dbHelper` → `UtilChannelData`; `mgr/dmrManager/dmrMgrClass/dmrClass` → `DmrManager`. `aprsDb`, `listenerInfo`, `inputStream`, `tvSoftwareVersion` are module/Android objects, not OEM.

### 3.1 `serial.data.ChannelData` (`serial/data/ChannelData.java`)

| Member | Declared | Access kind | Module lines | Status |
|---|---|---|---|---|
| `_id` | `public int` :25 | getIntField | 12051, 12080, 12210, 12235, 12439, 12504, 12573, 14027, 14503 | CONFIRMED |
| `active` | `public int` :26 | setIntField | 5435 | CONFIRMED |
| `band` | `public int` :27 | get/setIntField | get 2483, 5524, 6710, 6794, 6936, 8156, 10359, 10428, 15618, 15874; set 5428, 5488, 6596, 6900, 6993, 7203, 8044, 8204, 13961, 15179, 15383, 15777 | CONFIRMED |
| `cc` | `public int` :28 | get/setIntField | 15202, 15409, 15653, 15801, 15914 | CONFIRMED |
| `channelMode` | `public int` :29 | get/setIntField | 5489, 6597, 8045, 8159, 8207 | CONFIRMED |
| `contactType` | `public int` :30 | getIntField / getObjectField / setIntField / setObjectField(Integer) | 2379, 2442, 10577, 10586, 14394, 15200, 15407, 15651, 15799, 15910 | CONFIRMED (boxed Integer set on `int` field is legal via `Field.set`) |
| `encryptKey` | `public String` :31 | setObjectField | 15244, 15451 | CONFIRMED |
| `encryptSw` | `public int` :32 | setIntField | 15243, 15450 | CONFIRMED |
| `groups` | `public int[]` :33 (length 32) | getObjectField / setObjectField | 10595, 14566, 15215, 15228, 15422, 15435 | CONFIRMED |
| `inBoundSlot` | `public int` :34 | get/setIntField | 15203, 15410, 15654, 15802 | CONFIRMED |
| `name` | `public String` :37 | get/setObjectField | get 315, 2894, 6790, 6932, 7040, 7159, 7176, 7217, 8152, 8241, 15614, 16086; set 5424, 5484, 6592, 6896, 6989, 7199, 8040, 8200, 15172, 15376, 15773 | CONFIRMED |
| `number` | `public int` :38 | get/setIntField | get 2804, 2890, 5399, 6788, 6930, 7180, 7221, 8150, 12083, 12211, 12239, 14028, 14504, 15612; set 5423, 6894, 6986, 7197, 8198, 15771 | CONFIRMED |
| `outBoundSlot` | `public int` :39 | get/setIntField | 15204, 15411, 15655, 15803, 15915 | CONFIRMED |
| `power` | `public int` :40 | get/setIntField | get 2484, 5526, 6712, 6795, 6937, 8157, 10361, 10430, 15619, 15876; set 5429, 5490, 6598, 6901, 6994, 7204, 8046, 8205, 15180, 15384, 15778 | CONFIRMED |
| `relay` | `public int` :41 | get/setIntField | 2492, 5434, 10376, 10446, 15891 | CONFIRMED |
| `rxFreq` | `public int` :42 | get/setIntField | get 2486, 5530, 6716, 6791, 6933, 7160, 7177, 7218, 8153, 10365, 10434, 15615, 15880; set 5425, 5485, 6593, 6897, 6990, 7200, 8041, 8201, 15177, 15381, 15774 | CONFIRMED |
| `rxSubCode` | `public int` :43 | get/setIntField | get 2489, 2807, 2893, 5535, 6721, 6797, 6940, 8163, 10370, 10440, 15628, 15885; set 5431, 5492, 6600, 6903, 6996, 7206, 8048, 8209, 15185, 15390, 15787 | CONFIRMED |
| `rxType` | `public int` :44 | get/setIntField | get 2488, 2806, 2892, 5533, 6719, 6796, 6939, 8162, 10368, 10438, 15627, 15883; set 5430, 5491, 6599, 6902, 6995, 7205, 8047, 8208, 15184, 15389, 15786 | CONFIRMED |
| `sq` | `public int` :45 | get/setIntField | get 2386, 2462, 2991, 6793, 6935, 8155, 10546, 12342, 15617; set 5427, 5487, 6595, 6899, 6992, 7202, 8043, 8203, 10379, 10449, 12345, 15776 | CONFIRMED |
| `txContact` | `public int` :46 | get/setIntField | get 2380, 2433, 2984, 14318, 14395, 14456, 15652, 15913; set 2443, 14453, 15201, 15408, 15800 | CONFIRMED |
| `txFreq` | `public int` :47 | get/setIntField | get 2485, 5528, 6714, 6792, 6934, 7178, 7219, 8154, 10363, 10432, 15616, 15878; set 5426, 5486, 6594, 6898, 6991, 7201, 8042, 8202, 15178, 15382, 15775 | CONFIRMED |
| `txSubCode` | `public int` :48 | get/setIntField | get 2491, 5539, 6725, 6799, 6942, 8165, 10374, 10444, 15630, 15889; set 5433, 5494, 6602, 6905, 6998, 7208, 8050, 8211, 15187, 15392, 15789 | CONFIRMED |
| `txType` | `public int` :49 | get/setIntField | get 2490, 5537, 6723, 6798, 6941, 8164, 10372, 10442, 15629, 15887; set 5432, 5493, 6601, 6904, 6997, 7207, 8049, 8210, 15186, 15391, 15788 | CONFIRMED |
| `type` | `public int` :50 | get/setIntField | get 2362, 2422, 2805, 2891, 6789, 6931, 7179, 7220, 8151, 10344, 10414, 14180, 14393, 15613, 15622; set 5422, 5481, 6588, 6895, 6987, 7198, 8039, 8199, 15170, 15374, 15772 | CONFIRMED |
| `getId()` | `public int` :142 | callMethod | 10576 | CONFIRMED |
| `getNumber()` | `public int` :166 | callMethod | 3110 | CONFIRMED |
| `getContactType()` | `public int` :230 | callMethod | 8685 | CONFIRMED |
| `getTxContact()` | `public int` :238 | callMethod | 10578 | CONFIRMED |
| `setTxContact(int)` | :242 | callMethod | 10587 | CONFIRMED |
| no-arg constructor | :83 | `Class.newInstance()` (APRS channel creation) / `findAndHookConstructor` | 5419 (`channelDataClass.newInstance()` → `aprsChannel`) / hooked 13956 | CONFIRMED |

Fields **never** touched by the module: `interrupt`, `mic`. Module never reads `localId` from `ChannelData` (it does not exist there — consistent with Pitfall 15).

### 3.2 `manager.DmrManager` (`manager/DmrManager.java`)

| Member | Declared | Module lines | Status |
|---|---|---|---|
| `static getInstance()` | :124 | 2358, 2412, 2731, 3895, 5468, 6566, 6881, 6980, 7031, 7144, 8018, 8195, 8236, 8681, 10335, 10406, 11948*, 14570, 15108, 15320, 15760, 15904, 16071; `DirectDatabaseImporter.java:1268` (`getMethod`) | CONFIRMED (*11948 is `serial.SerialManager.getInstance`, see 3.12) |
| `getCurrentChannel()` | :280 returns `ChannelData` | 2359, 2413, 5471, 6569, 6884, 6981, 7036, 7152, 8019, 8196, 8238, 8682, 10336, 10407, 15109, 15321, 15761, 16079 | CONFIRMED |
| `createChannel(String, ChannelData)` | :265 | 5439 (`"default"`, aprsChannel) | CONFIRMED |
| `updateChannel(ChannelData)` | :253 (overload `(String, ChannelData)` :259 unused) | 2446, 5501, 6605, 6908, 7000, 7225, 8052, 8213, 12106, 14571, 15838, 15908 | CONFIRMED — writes DB via `getCurrentDbHelper().updateChannel`, `updateChannelList()`, `syncChannelInfo()` |
| `syncChannelInfoWithData(ChannelData)` | :207 | 2447, 5502, 6606, 6909, 7001, 7226, 8053, 8214, 12109 | CONFIRMED — drives `CmdStateMachine` set-channel transition |
| `updateChannelList()` | :217 | 5445, 15831; `DirectDatabaseImporter.java:1274` | CONFIRMED |
| `getCurrentDbHelper()` | :245 returns `UtilChannelData` | 15828, 15829 | CONFIRMED |
| `saveSms(MessageData)` | :476 | 2742 | CONFIRMED |
| `sendQueryInitializedCmdToMdl()` | :772 | 3899 (unwired) | CONFIRMED |
| `sendSetChannelCmdToMdl()` | :792 (overload `(ChannelData)` :803) | 3910 (unwired) | CONFIRMED |
| `sendAnalogMessage(ChannelData)` | private :369 | hooked (10534, 12329) | CONFIRMED |
| `sendDigitalMessage(ChannelData)` | private :329 | hooked (10565) | CONFIRMED |

### 3.3 `serial.data.UtilChannelData`

| Member | Declared | Module lines | Status |
|---|---|---|---|
| `updateChannel(ChannelData)` | `serial/data/UtilChannelData.java:175` | 15830 (on object returned by `getCurrentDbHelper`) | CONFIRMED |

### 3.4 `message.AnalogMessage`

| Member | Declared | Module lines | Status |
|---|---|---|---|
| no-arg ctor | :27 | `Class.newInstance()` 2480, 5520, 6706, 10355, 10424, 15870 | CONFIRMED |
| `sq` | `public byte` :17 | getObjectField 10707, 10757 | CONFIRMED |
| `monitor` | `public byte` :10 | getObjectField 10708, 10758 | CONFIRMED |
| `setBand(byte)` :98, `setPower(byte)` :106, `setSq(byte)` :114, `setRxType(byte)` :122, `setRxSubCode(byte)` :130, `setTxType(byte)` :138, `setTxSubCode(byte)` :146, `setRelay(byte)` :178 | all take `byte` | callMethod with explicit `(byte)` casts: 2483-2492, 5523-5539, 6709-6725, 10358-10375, 10427-10445, 15873-15890 | CONFIRMED (module casts to `byte`; an un-cast `int` would fail `findMethodBestMatch`) |
| `setTxFreq(int)` :90, `setRxFreq(int)` :82 | `int` | same ranges | CONFIRMED |
| `send()` | inherited `BaseMessage.send()` :35 | 2495, 5542, 6727, 10382, 10452, 15894 | CONFIRMED |
| `encodeBody()` | protected :56 | hooked 10697 | CONFIRMED |

### 3.5 `message.DigitalMessage`

| Member | Declared | Module lines | Status |
|---|---|---|---|
| `contactType` | `public byte` :11 | getObjectField 10629, 10779; setObjectField `(byte)2` 10641, 10791 | CONFIRMED |
| `txContact` | `public int` :23 | get 10630, 10780; set 10642, 10792 | CONFIRMED |
| `localId` | `public int` :16 | get 10778; set 10801 (VFO override) | CONFIRMED |
| `groupList` | `public int[]` :14 | get 10781 | CONFIRMED |
| `rxFreq` / `txFreq` | `public int` :22/:24 | get 10631/10632 | CONFIRMED |
| `encodeBody()` | protected :129 | hooked 10619 | CONFIRMED |

### 3.6 `message.BaseMessage`

| Member | Declared | Module lines | Status |
|---|---|---|---|
| `packet` | `public final Packet` :7 | getObjectField via `DigitalAudioMessage` instance 8667, 8716 | CONFIRMED |
| `send()` | :35 | hooked 10744; called on Analog/DigitalAudio/Signal instances (see above) | CONFIRMED |

### 3.7 `message.SignalMessage`, `message.DigitalAudioMessage`, `message.ModuleStatusMessage`

| Class | Member | Declared | Module lines | Status |
|---|---|---|---|---|
| `SignalMessage` | no-arg ctor | :13 | 8831 (`XposedHelpers.newInstance`), 10268 (`Class.newInstance`) | CONFIRMED |
| `SignalMessage` | `fetch` | `public byte` :10 | setByteField 8832, 10269 | CONFIRMED |
| `SignalMessage` | `send()` | inherited | 8833, 10272 | CONFIRMED |
| `SignalMessage` | `rssi` | `public byte` :11 | not read reflectively (module parses `packet.body` in `decode` hook at 10485 instead) | n/a |
| `DigitalAudioMessage` | no-arg ctor | :14 | 8810 | CONFIRMED |
| `DigitalAudioMessage` | `send()` | inherited | 8811 | CONFIRMED |
| `DigitalAudioMessage` | `packet` (inherited) | BaseMessage:7 | 8667, 8716 | CONFIRMED |
| `ModuleStatusMessage` | `getStatus()` | `public byte` :29 | 8468 | CONFIRMED |

### 3.8 `protocol.Packet` (`protocol/Packet.java`, `public final class`)

| Member | Declared | Module lines | Status |
|---|---|---|---|
| `Packet(byte)` | :84 | `newInstance(packetClass,(byte)cmd)` 11927 | CONFIRMED |
| `head` | `public byte head = 104` :17 | getObjectField 11649 | CONFIRMED |
| `cmd` | `public byte` :13 | 11650 | CONFIRMED |
| `rw` | `public byte` :15 | get 11651; setByteField 11930 | CONFIRMED |
| `sr` | `public byte` :16 | get 11652; set 11931 | CONFIRMED |
| `ckSum` | `public short` :12 | 11653 | CONFIRMED |
| `len` | `public short` :14 | 11654 | CONFIRMED |
| `body` | `public byte[]` :11 | get 8668, 8717, 10485, 11655; set 11936, 11940 | CONFIRMED |
| `tail` | `public final byte tail = 16` :18 | 11656 | CONFIRMED |

### 3.9 `serial.data.MessageData`

| Member | Declared | Module lines | Status |
|---|---|---|---|
| no-arg ctor | :61 | 2736 | CONFIRMED |
| `setDirection(int)` :152, `setStatus(int)` :136, `setContent(String)` :128, `setTimestamp(long)` :144 | | 2737-2740 | CONFIRMED |

### 3.10 `serial.data.PersonSharePrefData`, `PrizeInterPhoneApp`, `ymodem.YModemTXMsg`

| Class | Member | Declared | Module lines | Status |
|---|---|---|---|---|
| `PersonSharePrefData` | `static getIntData(Context,String,int)` | :46 | 14963, 15129, 15336 with key `"pref_person_device_id"` (= `PREF_PERSON_DEVICE_ID` :28) | CONFIRMED |
| `PrizeInterPhoneApp` | `static getContext()` | :26 | 8855, 9260 | CONFIRMED |
| `YModemTXMsg` | `getStep()` | :33 | 3824 (unwired) | CONFIRMED |

### 3.11 Fragments / activities / state machine

| OEM class | Member | Declared | Module lines | Status |
|---|---|---|---|---|
| `fragment.InterPhoneTalkBackFragment` | `mLocalView` | `private View` :63 | 1244, 2907, 2943, 3003, 3014 | CONFIRMED |
| | `mCurrentChannelData` | `private ChannelData` :56 | get 2802, 2888, 3108, 12049; set 12103 | CONFIRMED |
| | `mCurrentChannelIndex` | `private int` :77 | getIntField 12205; getObjectField 3187; setIntField 12102, 12255 | CONFIRMED |
| | `mMaxChannelId` | `private int` :64 | 12206 | CONFIRMED |
| | `mImgTalkbackNumOne` / `mImgTalkbackNumTwo` | `private ImageButton` :58/:59 | 3113 / 3115 | CONFIRMED |
| | `mImgTalkbackRecord` | `private ImageButton` :61 | 3071 | CONFIRMED |
| | `channels` | `public List<ChannelData>` :78 | 12068, 12198 | CONFIRMED |
| | `updateChannelId(boolean)` | :288 | callMethod 12302; hooked 12174 | CONFIRMED |
| | `updateUI()` | :191 | callMethod 15264, 15471, 15549; hooked 2873 | CONFIRMED |
| | `getActivity()` / `getContext()` | androidx `Fragment` | 3068, 3122, 4081 / 12267 | framework, OK |
| `fragment.InterPhoneChannelFragment` | `channels` | `public List<ChannelData>` :57 | 12416, 12451, 12474, 12543 | CONFIRMED |
| | `mLocalView` | `private View` :54 | 12660 | CONFIRMED |
| | `initData()` | :82 | callMethod 12610, 12817, 14544; hooked 12638 | CONFIRMED |
| | `getContext()` | Fragment | 12651 | framework |
| `…ChannelFragment$DeviceAreaListAdapter` | `this$0` | synthetic outer ref (non-static inner :169) | 12414, 12449, 12472 | CONFIRMED |
| `fragment.InterPhoneLocalFragment` | `getContext()` / `getActivity()` | Fragment | 4000, 4080 / 4081 | framework |
| `fragment.BaseViewPagerFragment` (all 4 looped fragments) | `mFragmentContainer` | `public FrameLayout` :24 | 16261 | CONFIRMED (superclass field; Xposed `findField` walks the hierarchy) |
| `InterPhoneContactsFragment` / `InterPhoneMessageFragment` / `InterPhoneLocalFragment` | `mLocalView` | `private View` :49 / :43 / :68 | **none** — the loop hook at 16241 uses `param.args[0]` (`rootView`) and `mFragmentContainer` only; `mLocalView` is read reflectively solely on `InterPhoneTalkBackFragment` (:63) and `InterPhoneChannelFragment` (:54, line 12660) | not accessed (field exists on each class) |
| `activity.FragmentLocalInformationActivity` | `mTvSoftwareVersion` | `private TextView` :16 | 3640 | CONFIRMED |
| | `mTvDmrFirmwareVersion` | `private TextView` :14 | 3651 | CONFIRMED |
| `activity.InterPhoneChannelActivity` | `channelData` | `private ChannelData` :122 | 14021, 14386, 14501 | CONFIRMED |
| `activity.MessageContentActivity` | `showListDialog(int)` | :445 | 620 | CONFIRMED |
| `…$MessageListAdapter` | `this$0` | synthetic (non-static inner :338) | 616 | CONFIRMED |
| `…$MessageListAdapter$ViewHolder` | `mTvValues` | `private TextView` :430 | 612 | CONFIRMED |
| `state.TalkBackStateMachine` | `fragment` | `private InterPhoneTalkBackFragment` :28 | 12300 | CONFIRMED |
| `…$ReceiveSoundState` | `this$0` | synthetic (non-static inner :360) | 12299 | CONFIRMED |

### 3.12 `serial.SerialManager` vs missing `manager.SerialManager`

| OEM class | Member | Module lines | Status |
|---|---|---|---|
| `serial.SerialManager` | `static getInstance()` :20 | 11948 | CONFIRMED |
| `serial.SerialManager` | `send(Packet)` :95 | 11949; hooked 11599 | CONFIRMED |
| **`manager.SerialManager`** | `getInstance()` | 3853 | **NOT FOUND** (class missing) |
| **`manager.SerialManager`** | `mInputStream` | 3859 | **NOT FOUND** |
| **`manager.SerialManager`** | `inputStream` | 3862 | **NOT FOUND** |

Note: even if the module were corrected to `serial.SerialManager`, that class has **no** `mInputStream`/`inputStream` field (fields are the singleton + `SerialPort`, see serial/SerialManager.java:17-60; the stream lives on `serial.port.SerialPort.getInputStream()` :79). Both field probes would still fail.

Module-internal `getAdditionalInstanceField` keys (`dmrmod_selectedZoneId`, `dmrmod_selectedTGListId`, `originalOnClickListener`) are Xposed side-tables, not OEM members.

---

## 4. OEM resource lookups (`getIdentifier`)

All lookups use `context.getPackageName()` / `TARGET_PACKAGE` = `com.pri.prizeinterphone` unless marked *module*. Layout ids in the decompiled tree appear as `android:id="@id/..."`; `values/ids.xml` also declares them.

| Resource | Type | Module line(s) | OEM definition | Status |
|---|---|---|---|---|
| `interphone_tap_view` | id | 506 | `res/layout/activity_interphone_home.xml` | CONFIRMED |
| `talkback`, `channel`, `contacts`, `message`, `local` | id | 525 (loop), `channel` also 1731, 15959, 16011 | `res/layout/activity_interphone_home.xml` (`message` also in m3_alert_dialog.xml / preference_dialog_edittext.xml — harmless, `findViewById` scoped to home activity) | CONFIRMED |
| `fragment_talkback_sub`, `fragment_talkback_add` | id | 2849, 2850 | `res/layout/fragment_talkback_view.xml` | CONFIRMED |
| `fragment_talkback_send`, `fragment_talkback_recieve`, `fragment_talkback_power`, `fragment_talkback_color_or_noise`, `fragment_talkback_call_name` | id | 3027-3031 | `res/layout/fragment_talkback_view.xml` | CONFIRMED |
| `local_exit_app` | id | 4008 (first of 4 probes) | `res/layout/fragment_local_view.xml` | CONFIRMED |
| `local_exit`, `exit_app`, `fragment_local_exit_app` | id | 4008 (fallback probes) | — | NOT FOUND (by design; never reached because `local_exit_app` resolves first) |
| `interphone_channel_frequency` | id | 13667 | `res/layout/interphone_channel_activity.xml` | CONFIRMED |
| `all_options` | id | 13982 | `res/layout/interphone_channel_activity.xml` | CONFIRMED |
| `interphone_channel_group_grid` | id | 13218 | `res/layout/interphone_channel_activity.xml` | CONFIRMED |
| `interphone_channel_group_item` | layout | 13226 | `res/layout/interphone_channel_group_item.xml` | CONFIRMED |
| `interphone_channel_group_number_set` | id | 13228 | `res/layout/interphone_channel_group_item.xml` | CONFIRMED |
| `interphone_channel_call_name_set` | id | 14307, 14411 | `res/layout/interphone_channel_activity.xml` | CONFIRMED |
| Help-icon rows: `interphone_channel_name` (13772), `_type` (13781), `_frequency_band` (13787), `_power` (13797), `_relay_disconnecte` (13803), `_color` (13814), `_mode_type` (13821), `_slot_type` (13827), `_contact_type` (13834), `_encryption` (13852), `_interrupt_transmission` (13859), `_band` (13868), `_sq` (13875), `_txtype` (13883), `_txsubcode` (13892), `_rxtype` (13901), `_rxsubcode` (13909) | id | via `addIcon(...)` → 13555 | `res/layout/interphone_channel_activity.xml` | CONFIRMED (17) |
| **`interphone_channel_contact`** | id | 13841 (`addIcon("interphone_channel_contact","Call Number",…)`) | only `interphone_channel_contact_type` / `_contact_type_set` exist in `interphone_channel_activity.xml` | **NOT FOUND** — `if (id == 0) return;` at 13556, so the "Call Number" help icon is silently never added |
| `interphone_channel_group_list` | id | 13917 → 13602 | `res/layout/interphone_channel_activity.xml` | CONFIRMED |
| `interphone_channel_content_background_seletor` | drawable | 14046 | `res/drawable/interphone_channel_content_background_seletor.xml` | CONFIRMED |
| `interphone_channel_more_split` | drawable | 14091 | `res/drawable/interphone_channel_more_split.xml` | CONFIRMED |
| `interphone_channel_content_height`, `_margin_left`, `_margin_right`, `_title_size`, `_title_width`, `_title_margin_left`, `_split_margin_left`, `_sub_size` | dimen | 14053-14120, 14201, 14253 | `res/values/dimens.xml` | CONFIRMED (8) |
| `pri_text_color` | color | 14069, 14103, 14197, 14249 | `res/values/colors.xml` | CONFIRMED |
| `interphone_talkback_record`, `interphone_talkback_recording`, `interphone_talkback_recv`, `interphone_talkback_sub`, `interphone_talkback_add`, `interphone_talkback_num_0..9` | drawable (*module*, package `com.dmrmod.hooks` via `createPackageContext`) | 2000, 2847, 2848, 3078-3081, 3138-3139 | `DMRModHooks/app/src/main/res/drawable-xhdpi/` | module-owned, present |

No `string` resources are looked up from the OEM package.

---

## 5. OEM SQLite tables / columns referenced by the module

OEM schema sources: `serial/data/DBChannelHelper.java` (channel-area DBs), `serial/data/DBContactHelper.java`, `serial/data/UtilChannelData.java`, `serial/data/UtilContactsData.java`.

### 5.1 Database files

| Module reference | Module usages | OEM definition | Status |
|---|---|---|---|
| `database_channel_area_default_uhf.db` (path via `getDatabasePath(...)` or `/data/data/com.pri.prizeinterphone/databases/<db>`) | `CSVExporter.java:39,130`, `CSVImporter.java:32,115,315`, `DiagnosticDatabaseDump.java:13`, `DirectDatabaseExporter.java:265,807,853`, `DirectDatabaseImporter.java:417,1566,1612`, `PDFExporter.java:131` | `DBChannelHelper.java:59` → `"database_" + str + ".db"`; area names are OEM strings (`res/values/strings.xml:37-46`: `channel_area_aus`, `_cn`, `_default`, `_default_uhf`, `_default_vhf`, `_eu`, `_iran`, `_japan`, `_ko`, `_malaysia`, …) | **PARTIAL** — module hard-codes one area (`default_uhf`); backup/import/export/PDF ignore the currently selected area (`PersonSharePrefData.PREF_PERSON_CHANNEL_AREA_SELECTED_INDEX`). Reflection paths (`DmrManager.getCurrentDbHelper`) are area-correct; the direct-SQLite helpers are not |
| `contact_database.db` | `MainHook.java:8960,14326,14432`, `CSVExporter.java:204,282`, `CSVImporter.java:204,463`, `DirectDatabaseExporter.java:541,928`, `DirectDatabaseImporter.java:1118,1408,1668,1710`, `PDFExporter.java:298` | `DBContactHelper.java:13` (`DB_CONTACT_NAME`) | CONFIRMED |

### 5.2 Channel table `database_channel_area_default_uhf` (created at `DBChannelHelper.java:67`)

| Column | Module files | OEM definition | Match |
|---|---|---|---|
| `_id` | Direct*/CSV*/PDF/MainHook (zone + TG-list keyed on `_id`) | `DBChannelHelper.java:67` (`_id integer primary key autoincrement`), `UtilChannelData.java:24` | CONFIRMED |
| `channel_name` | CSVExporter:337, CSVImporter:391, DirectDatabaseExporter:307,817,863, DirectDatabaseImporter:534,1576,1622, PDFExporter:205 | DBChannelHelper:25/67 | CONFIRMED |
| `channel_type` | CSVExporter:341, CSVImporter:392, DDE:308, DDI:540, PDF:207 | :37/67 | CONFIRMED |
| `channel_number` | CSVExporter:333, CSVImporter:390, DDE:306,863, DDI:530,1622, PDF:204 | :26/67 | CONFIRMED |
| `channel_txFreq`, `channel_rxFreq` | CSV*/Direct*/PDF | :34,:28/67 | CONFIRMED |
| `channel_power` | CSVExporter:398, CSVImporter:399, DDE:316, DDI:711, PDF:210 | :27/67 | CONFIRMED |
| `channel_cc` | CSVExporter:363, CSVImporter:395, DDE:311, DDI:560,608, PDF:228 | :18/67 | CONFIRMED |
| `channel_inBoundSlot`, `channel_outBoundSlot` | CSV*/Direct* | `UtilChannelData.java:25,:29`; added in `onUpgrade` :74-75 | CONFIRMED |
| `channel_mode` | CSVImporter:402, DDE:329, DDI:713,916 | `UtilChannelData.java:19` (`TABLE_CHANNELMODE`); CREATE :67 via constant; `onUpgrade` :76 | CONFIRMED (note OEM `DBChannelHelper` itself has no `channel_mode` constant — it borrows `UtilChannelData.TABLE_CHANNELMODE`) |
| `channel_contactType`, `channel_txContact` | CSV*/Direct* | :19,:33/67 | CONFIRMED |
| `channel_encryptSw`, `channel_encryptKey` | CSV*/Direct* | :21,:20/67 | CONFIRMED |
| `channel_relay` | CSVImporter:406, DDE:325, DDI:715,912 | :31/67 | CONFIRMED |
| `channel_interrupt` | CSVImporter:407, DDE:326, DDI:913 | :24/67 | CONFIRMED |
| `channel_band` | CSVExporter:356, CSVImporter:409, DDE:314, DDI:616 | :17/67 | CONFIRMED |
| `channel_sq` | CSVExporter:394, CSVImporter:400, DDE:315, DDI:716,907, PDF:211 | :32/67 | CONFIRMED |
| `channel_rxType`, `channel_rxSubCode`, `channel_txType`, `channel_txSubCode` | CSV*/Direct* | :30,:29,:36,:35/67 | CONFIRMED |
| `channel_active` | CSVImporter:401, DDE:327, DDI:914,1035,1053 | :16/67 | CONFIRMED |
| `channel_groups` | CSVImporter:414, DDI:721,952 (comma-joined string, cf. `UtilChannelData.coverGroupsString` :97) | :22/67 (`varchar`) | CONFIRMED |

Module-owned tables that merely *look* like OEM ones (live in `dmrmod_*.db`, not OEM): `channel_aprs` (APRSDatabase), `channel_locations` (LocationDatabase), `channel_history` + column `channel_number` (MainHook 9581-9588, `dmrmod_history.db`), `channel_list`, `channel_tglist_assignments` + column `channel_id` (TGListDatabase:47; unrelated to OEM's unused constant `DBChannelHelper.TABLE_ID="channel_id"` :23 — the OEM CREATE uses `_id`).

### 5.3 Contact table `contact_database` (created at `DBContactHelper.java:38`)

| Column | Module usages | OEM | Match |
|---|---|---|---|
| `_id` | MainHook:14331-14332 (`SELECT _id … WHERE contact_number=?`), 14438-14439, DDI:1129-1178 | `DBContactHelper.java:38`, `UtilContactsData.java:22` | CONFIRMED |
| `contact_name` | MainHook:8960-8985 (caller name), 14332, 14439; CSV*/Direct*/PDF | :38; `UtilContactsData.java:23` | CONFIRMED |
| `contact_type` | CSVExporter:443, CSVImporter:252, DDE:585, DDI:1172,1717, PDF | :38; :25 | CONFIRMED |
| `contact_number` (`varchar`) | MainHook:14332, CSV*/Direct*/PDF | :38; :24 | CONFIRMED (module binds the DMR ID as a string — matches `varchar`) |
| `contact_active` | CSVImporter:253, DDI:1175 | :38; :20 | CONFIRMED |
| `contact_icon` | CSVImporter:254, DDI:1176 | :38; :21 | CONFIRMED |

OEM DBs **not** touched by the module: `group_database.db` (table `group_databas`, DBGroupHelper:38), `message_database.db`, `conversation_database.db`, `record_database.db`.

---

## 6. SharedPreferences, broadcasts, intents, file paths, serial constants

| Kind | Module value | Module line(s) | OEM counterpart | Status |
|---|---|---|---|---|
| SharedPreferences (OEM) | file `com.pri.prizeinterphone.data.person`, key `pref_person_device_id`, default 1 — read via `PersonSharePrefData.getIntData` | 14963, 15129, 15336 | `PersonSharePrefData.java:25` (`PREF_PERSON_DATA`), :28 (`PREF_PERSON_DEVICE_ID`), :46 | CONFIRMED |
| SharedPreferences (module-own) | `dmrmod_gps_prefs` (2700), `dmrmod_sstv_global` (5632, 5848, 6023, 6579), `dmrmod_noaa_global` (7366, 7483, 7724, 8026), `dmrmod_aprs_global` (APRSDatabase:28), `dmrmod_radioid_prefs` (RadioidDatabase:48), `dmr_import_test` (DirectDatabaseImporter:304) | | none | module-owned |
| `shared_prefs` / `databases` dir creation in OEM data dir | `hookApplication` 969-985 | | OEM data dir (`Application.getDataDir()`) | OK |
| Broadcast action (module-own, exported) | `com.dmrmod.SEND_DEBUG_PACKET` extras `CMD`,`RW`,`SR`,`BODY` | 11888-11889, 11907-11910 | none | module-owned |
| OEM broadcast constants | `InterPhoneTalkBackFragment.PTTDOWNINTER = "com.interphone.ptt.down"`, `PTTUPINTER = "com.interphone.ptt.up"` (:50-51) | not used by module | | n/a |
| Intents | `ACTION_MEDIA_SCANNER_SCAN_FILE` (6536); `com.dmrmod.hooks/.BackupActivity` with `target_package` extra (9632-9634 / BackupActivity:67); `com.macdmr.transcription/.TranscriptionService` (10913); `ACTION_VIEW` GitHub URL (3699); PatchReloadHelper:265 → OEM `UPDATE_ACTIVITY` (constant in PatchReloadHelper) | | no OEM action strings | n/a |
| File paths | `/sdcard/aprs_channel_backup.dat`, `/sdcard/sstv_channel_backup.dat`, `/sdcard/noaa_channel_backup.dat`, `/sdcard/vfo_channel_backup.dat` (6816-16057); `/sdcard/DMR/uart_logs/uart_<ts>.bin|.txt` (11572-11574); `/sdcard/DMR/PATCH14_BACKUP.bin`, `/sdcard/DMR/DMRDEBUG.bin` (PatchReloadHelper:49-50); `/sdcard/sstv_audio.wav` (SSTVReceiver:1003); `/sdcard/aprs_debug` (AFSKDecoder:428); `Download/DMR/{APRS,SSTV,api_key.txt}`; `/data/data/com.pri.prizeinterphone/databases/<db>` (CSVExporter:39, CSVImporter:32,115) | | OEM stores DBs via `SQLiteOpenHelper` in the same `databases/` dir | CONFIRMED path convention |
| UART device | module comment says `/dev/ttyS0` (11566); `UARTBootloaderProbe.java:37` uses **`/dev/ttyS1`** (probe disabled at MainHook:415) | | `serial/port/SerialPort.java:25` opens `/dev/ttyS0` @ 57600 | ⚠️ probe targets a different device than OEM uses |
| Serial command constants | module has **no** `Const.*` references. `getCmdName` (11788-11797) hard-codes cmd 1 RECEIVE_START, 2 RECEIVE_STOP, 10 MIX_CHECK_DIGITAL_RECEIVE_START, 22 SET_DIGITAL_INFO_CMD, 35 INTERRUPT_TRANSMIT_CMD, 63 TEST_BIT_ERROR_RATE; `handleDebugPacket` builds `new Packet((byte)cmd)` with caller-supplied rw/sr/body (11927-11940); default body `{1}` mirrors OEM ACK body (`ModuleStatusMessageHandler.java:29`) | | `protocol/Const.java` | not cross-checked here (see chapter 01) |
| State-machine constant | `msg.what == 2021` | 12297 | `TalkBackStateMachine.MSG_CHANNEL_CHANGE = 2021` :9 | CONFIRMED |
| YModem steps | 32 = success, 64 = failure | 3826 | `ymodem/YModem.java:17` `STEP_END=32`, :19 `STEP_ERROR=64` | CONFIRMED |

---

## 7. Reverse index — module touch points per OEM class

| OEM class | Hooks (module line) | Reflection (module lines) | Resources / other |
|---|---|---|---|
| `PrizeInterPhoneApp` | `onCreate` 961 (B); (11872 (A) hooks framework `android.app.Application.onCreate`, reached via `super.onCreate()`) | `getContext` 8855, 9260 | — |
| `InterPhoneHomeActivity` | `onCreate` 459, 1037; `tapOnClick` 474 | — | ids `interphone_tap_view`, `talkback/channel/contacts/message/local` (506, 525, 1731, 15959, 16011) |
| `fragment.InterPhoneTalkBackFragment` | `initView` 1229; `updateUI` 2873; `setTalkbackRecordBg` 3058 (R); `updateChannelNumber` 3100 (R); `updateChannelId` 12174 | fields `mLocalView`, `mCurrentChannelData`, `mCurrentChannelIndex`, `mMaxChannelId`, `mImgTalkbackNumOne/Two`, `mImgTalkbackRecord`, `channels`; methods `updateChannelId`, `updateUI`, `getActivity`, `getContext` (see 3.11) | ids `fragment_talkback_*` (2849-2850, 3027-3031); module drawables (2000, 2847-2848, 3081, 3139) |
| `state.TalkBackStateMachine` / `$ReceiveSoundState` | `processMessage` 12289 | `this$0` 12299, `fragment` 12300 | const 2021 |
| `fragment.InterPhoneChannelFragment` / `$DeviceAreaListAdapter` | `initView` 16241; `initData` 12638; `updateView` 12603 (R); `onItemClick` 12527; adapter `getCount` 12406 (R), `getView` 12459 | `channels`, `mLocalView`, `initData`, `getContext`, `this$0`, `mFragmentContainer` | — |
| `fragment.InterPhoneLocalFragment` | `initView` 3959, 16241 | `getContext`, `getActivity`, `mFragmentContainer` | id `local_exit_app` (+3 fallback probes) 4008 |
| `fragment.InterPhoneContactsFragment`, `InterPhoneMessageFragment` | `initView` 16241 | `mFragmentContainer` | — |
| `fragment.BaseViewPagerFragment` | — | `mFragmentContainer` 16261 | — |
| `activity.InterPhoneChannelActivity` | `onCreate` 13968; `saveChannelData` 14373 | `channelData` 14021, 14386, 14501 | ids `all_options`, `interphone_channel_frequency`, `interphone_channel_group_grid`, `interphone_channel_call_name_set`, 19 row ids (1 missing); layout `interphone_channel_group_item`; id `interphone_channel_group_number_set`; drawables ×2, dimens ×8, color ×1; DB `contact_database` (14326-14439) |
| `activity.MessageContentActivity` / `$MessageListAdapter` / `$ViewHolder` | `getView` 600; `onCreate` 16196 | `this$0` 616, `mTvValues` 612, `showListDialog` 620 | — |
| `activity.FragmentLocalInformationActivity` | `initView` 3616 | `mTvSoftwareVersion` 3640, `mTvDmrFirmwareVersion` 3651 | — |
| `activity.UpdateFirmwareActivity` (unwired) | `handleMsgFromSvc` 3813 | — | uses `YModemTXMsg.getStep` 3824, `DmrManager.sendQueryInitializedCmdToMdl` 3899, `sendSetChannelCmdToMdl` 3910, **missing `manager.SerialManager`** 3849-3862 |
| `activity.FragmentLocalSettingsActivity`, `FragmentLocalDeviceAreaActivity`, `FragmentLocalDeviceAreaListActivity`, `FragmentLocalUseAssistantActivity`, `FragmentNewContactsActivity`, `RecordListActivity`, `FragmentLocalTestBiteErrorRateActivity` | `onCreate` 16196 | — | — |
| `handler.ModuleStatusMessageHandler` | `handle` 8459 | `ModuleStatusMessage.getStatus` 8468 | — |
| `handler.DigitalAudioMessageHandler` | `handle` 8656 | `BaseMessage.packet` 8667/8716, `Packet.body` 8668/8717, `DmrManager.getCurrentChannel` 8682, `ChannelData.getContactType` 8685 | — |
| `handler.SignalMessageHandler` | `decode` 10472 | `Packet.body` 10485 | — |
| `manager.PCMReceiveManager` | `writeAudioTrack` 9938 | — | — |
| `manager.DmrManager` | `sendAnalogMessage` 10534, 12329; `sendDigitalMessage` 10565 | 3.2 (12 members, ~70 call sites) + `DirectDatabaseImporter.java:1263-1275` | — |
| `serial.data.UtilChannelData` | — | `updateChannel` 15830 | — |
| `serial.data.ChannelData` | ctor 13956 | 3.1 (29 members, ~330 call sites) | DB columns §5.2 |
| `serial.data.MessageData` | — | ctor + 4 setters 2736-2740 | — |
| `serial.data.PersonSharePrefData` | — | `getIntData` 14963, 15129, 15336 | pref key §6 |
| `message.BaseMessage` | `send` 10744 | `packet`, `send` | — |
| `message.AnalogMessage` | `encodeBody` 10697 | 3.4 | — |
| `message.DigitalMessage` | `encodeBody` 10619 | 3.5 | — |
| `message.DigitalAudioMessage` | — | ctor/send 8810-8811 | — |
| `message.SignalMessage` | — | ctor/`fetch`/send 8831-8833, 10267-10272 | — |
| `message.ModuleStatusMessage` | — | `getStatus` 8468 | — |
| `protocol.Packet` | — | 3.8 (9 members) | — |
| `serial.SerialManager` | `send` 11599 | `getInstance`/`send` 11948-11949 | — |
| `serial.MessageDispatcher` | `onReceive` 11620 | — | — |
| `serial.port.SerialPort` | — (only as parameter type 11616) | — | — |
| `ymodem.YModemTXMsg` | — | `getStep` 3824 | — |
| `serial.data.DBChannelHelper` / `DBContactHelper` | — | — | direct SQLite on their files/tables (§5) |
| `state.CmdStateMachine`, `serial.data.ContactData`, `message.RelayMessage` | **not touched** (only indirectly via `DmrManager.syncChannelInfoWithData` / DB rows) | | |

---

## 8. Risk assessment

### 8.1 Confirmed defects (surface these first)

| Item | Where | Effect today | Effect if enabled |
|---|---|---|---|
| `com.pri.prizeinterphone.manager.SerialManager` does not exist (real: `serial.SerialManager`) | MainHook.java:3849 (+`getInstance` 3853, `mInputStream` 3859, `inputStream` 3862) | none — `hookUpdateFirmwareActivity` is commented out at :367 | UART-flush step throws `ClassNotFoundError`, caught at 3872; module proceeds to `sendQueryInitializedCmdToMdl`. Fixing the package alone is insufficient: `serial.SerialManager` has no stream field; use `getSerial().getInputStream()` (`serial/SerialManager.java:54`, `SerialPort.java:79`) |
| Resource id `interphone_channel_contact` does not exist | MainHook.java:13841 | "Call Number" help icon silently never rendered (`id==0 → return` at 13556). Likely intended target: `interphone_channel_contact_type` row or the `interphone_channel_call_name_set` field | same |
| Channel-area DB hard-coded to `database_channel_area_default_uhf.db` | CSVExporter/CSVImporter/DirectDatabaseExporter/DirectDatabaseImporter/PDFExporter/DiagnosticDatabaseDump | Backup/restore/CSV/PDF operate on the wrong DB when the user has selected any other area (OEM ships ≥10 areas, `strings.xml:37-46`); reflection-based paths via `DmrManager.getCurrentDbHelper()` are unaffected | same |
| `UARTBootloaderProbe` opens `/dev/ttyS1` while OEM radio UART is `/dev/ttyS0` | UARTBootloaderProbe.java:37 vs SerialPort.java:25 | none (probe disabled :415) | probe would test the wrong port |

### 8.2 Fragility ranking for an OEM APK update

1. **Private field names on fragments/activities** (`mLocalView`, `mCurrentChannelData`, `mCurrentChannelIndex`, `mMaxChannelId`, `mImgTalkback*`, `mTvSoftwareVersion`, `mTvDmrFirmwareVersion`, `channelData`, `mTvValues`, `TalkBackStateMachine.fragment`) — obfuscation or rename breaks them; each access is inside try/catch → feature silently disappears (talkback UI surgery, zone navigation, channel-edit rows, info page).
2. **Synthetic `this$0` and inner-class discovery** (`MessageListAdapter`, `DeviceAreaListAdapter`, `ReceiveSoundState`) — any change to nesting/staticness breaks the zone filter and message long-press.
3. **Hard-coded resource names** (53 lookups; §4) — layout refactors break silently (`getIdentifier` returns 0, guarded everywhere).
4. **Exact method signatures** (§1) — `findAndHookMethod` throws `NoSuchMethodError` at install time, caught per-installer (`try { … } catch (Throwable)` around each `hook*`), so a whole feature group drops out but the app keeps running. Most sensitive: `writeAudioTrack(byte[],int)` (all audio features), `handle(ModuleStatusMessage)` / `handle(DigitalAudioMessage)` (caller ID), `sendAnalogMessage/sendDigitalMessage(ChannelData)` (squelch + monitoring), `updateChannelId(boolean)` + `ReceiveSoundState.processMessage` (zone nav), `DeviceAreaListAdapter.getCount/getView` (zone list).
5. **Public data-class fields** (`ChannelData` 24 fields, `Packet` 8, `DigitalMessage` 6, `AnalogMessage` 2, `SignalMessage.fetch`) — least likely to change (Parcelable/DB-backed), but `ChannelData` is touched at ~330 sites; a rename would surface as `NoSuchFieldError` in dozens of try/catch blocks.
6. **DB schema** (§5) — column renames break CSV/PDF/backup paths (SQL exceptions caught, user sees "failed").
7. **Constants** — `MSG_CHANNEL_CHANGE=2021`, YModem 32/64, cmd-id names in `getCmdName`, packet body layout (`body[0]` callType, `body[1..3]` DMR ID) — silent misbehaviour rather than exceptions.

### 8.3 Crash vs silent degradation

- Every `hook*` installer and every reflective block in `MainHook` is wrapped in `try/catch (Throwable)` with `XposedBridge.log`; no OEM-facing failure propagates as an app crash. Failures show up only in the LSPosed log.
- The four `XC_MethodReplacement` hooks on the TalkBack fragment (`setTalkbackRecordBg`, `updateChannelNumber`) and channel list (`getCount`, `updateView`) return `null`/`0` on internal error rather than falling back to the OEM body — a resource/field mismatch there leaves the PTT button / channel digits / channel list **blank**, not merely un-themed.
- `BaseMessage.send` hook (10744) runs on every outbound packet; its body is try/caught, so a `DigitalMessage` field rename would only lose the VFO `localId` override and ALL-mode forcing (transmit would revert to the channel's stored DMR ID).

---

## 9. ⚠️ Doc drift vs `.grok/rules/copilot-instructions.md`

| Doc claim | Verified reality |
|---|---|
| "Frequently-Hooked OEM Class Paths": `ui.activity.MainActivity` | No such class. Hooked class is `com.pri.prizeinterphone.InterPhoneHomeActivity` (root package) |
| `ui.fragment.TalkBackFragment`, `ui.fragment.LocalFragment` | `fragment.InterPhoneTalkBackFragment`, `fragment.InterPhoneLocalFragment` (no `ui` package exists) |
| `handler.ModuleStatusHandler`, `handler.DigitalAudioHandler` | `handler.ModuleStatusMessageHandler`, `handler.DigitalAudioMessageHandler` |
| `serial.communication.Packet`, `serial.communication.SerialPort` | `protocol.Packet`, `serial.port.SerialPort` |
| `protocol.MessageDispatcher` | `serial.MessageDispatcher` |
| `message.RelayMessage` listed as instantiated by the module | Exists (`message/RelayMessage.java`) but is never referenced by any module file |
| "`hookApplication()` — grabs the app ClassLoader and runs early init" | `hookApplication` (961) creates `shared_prefs`/`databases` dirs and runs the zone `_id` migration; the ClassLoader is stored in `handleLoadPackage` (:335), not in the hook |
| Pitfall 15: "already implemented in `hookDmrManager` → `sendDigitalMessage` `beforeHookedMethod` at line ~10458" | The `localId` override lives in the **`BaseMessage.send`** before-hook at MainHook.java:10799-10803; the `sendDigitalMessage` hook (10565) handles ALL-mode forcing only |
| Helper `getContactNameForDmrId(long, Context)` | Not present; contact lookups are `lookupPersonalContactName(Context,int)` (8956), `lookupCallerDisplayInfo` (8985), `lookupContactName` (9016) |
| Pitfall 1 (`serial.data.ChannelData`, not `data.ChannelData`) | Correct — all 4 lookups use `serial.data` |
