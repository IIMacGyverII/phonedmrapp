# Armor 20WT: the stock app, read side by side with the Armor 26 Ultra's

**2026-10-30, Armor 20WT agent.** Plan: `plan-stock-app-review.md`. This is a reading only: there is no 20WT here, nothing was run.

**Inputs.**
- **20WT:** the owner-supplied `com.pri.prizeinterphone` APK (versionName `V1.0`, versionCode 31, targetSdk 31, `sharedUserId android.uid.system`), decompiled with jadx into a scratch folder outside the repos. Paths below are relative to that tree's `com/pri/prizeinterphone/` unless they start with `com/serial/`.
- **Armor 26:** the decompiled reference in `app/src/main/java/com/pri/prizeinterphone/`, plus `docs/deep-dive/01`–`06`.
- **Report:** the tester's device report (SignalDeck beta.18). Device facts only are quoted from it.

**Markers.**
- **R** = verified by reading the code.
- **I** = inferred (not read directly, or depends on behaviour the code doesn't show).
- **"26"** = the Armor 26 Ultra's stock app.

## Summary

The 20WT's app is an **older, smaller build of the same PriInterPhone app**. It has:
- no command state machine (`state/` is absent);
- no firmware updater (no `ymodem/`, no `UpdateFirmwareActivity`, no `DMR*.bin` asset);
- no XML channel config;
- no bit-error-rate test.

The things SignalDeck relies on are byte-for-byte the same as the 26's:
- the **wire protocol** (`68 … 10` framing, checksum, the `BF AA` boot banner);
- the **command numbers**;
- **every message body layout**;
- the **audio format**.

It drives the radio with **far fewer commands**. **SignalDeck's Armor 26 path is already very close.** The differences that matter are in this table.

| # | What | 20WT stock app | Armor 26 stock app | SignalDeck before this work | R/I |
|---|---|---|---|---|---|
| D1 | Command UART | `/dev/ttyS1`, 57600, flags 0, through `com.serial.port.SerialPort` + `libserial_port_app.so` | `/dev/ttyS0`, 57600, `com.pri.prizeinterphone.serial.port.SerialPort` + `libinterphone_serial_port.so` | already in profile rev 1 | R |
| D2 | `dmr009/ptt` node | **never touched** (only `pwd` is) | used only to knock the module into update mode | profile names it; used only by the firmware loader | R |
| D3 | Firmware update | **none** in the app | knock + YModem (`ymodem/`) | loader allowed on any `mcu68` profile | R |
| D4 | Boot handshake | banner → channel → `0x34` version → on the version reply `0x3B` 0. Never `0x2A` mic, `0x35` interrupt or `0x3A` SMS protocol | state machine: version, channel, interrupt/mic, TOT (deep-dive 03 §7a) | version, channel, interrupt (digital) or mic (analog), TOT 120 | R |
| D5 | Key-up order | opens the TinyService write path and the microphone, **waits 600 ms**, then `0x26` 1 | `0x26` 1, then opens the write path (deep-dive 03 RecordSoundState) | `0x26` 1, then the write path | R |
| D6 | Re-key gap | a new key waits until 2 s after the last release (2.0–2.5 s with receive in between) | none of this kind | none | R (the reason is I) |
| D7 | Analog channel volume byte | **5** (`AnalogMessage` default) | 8 | 8 | R |
| D8 | Receive audio | `openRecvPcm` at each `RECEIVE_START` (status 1), `closeRecvPcm` at status 2 | opened at start-up and held | held (TinyService phones) | R |
| D9 | Stock channel databases | `channel_database_<area>.db`, table `channel_database_<area>`, areas `Default`, `USA_FRS` … ; **no** `channel_relay` / `channel_interrupt` columns | `database_channel_area_<area>.db` (deployed app), areas `default_uhf` … | looks only for `database_channel_area_*` | R |
| D10 | Commands the app never sends | `0x2A` mic, `0x2B` caller query, `0x2E` volume, `0x2F` monitor, `0x30` squelch, `0x31` power save, `0x32` RSSI, `0x33` relay, `0x35` interrupt, `0x37` policy, `0x38` mixed check, `0x3A` SMS protocol, `0x3C` speaker | sends most of them | sends `0x2B`, `0x2F`, `0x32` (and `0x2A`/`0x35` at boot, `0x30` on some phones) | R (whether the 20WT's module answers them: unknown) |

**Unknown until a 20WT report says otherwise:**
- the module's version string;
- whether `ttyS1` really runs at 57600 through the vendor library (the report's probe could only set the speed with `stty`, which read back 9600);
- whether the module answers the D10 commands, above all `0x32` RSSI and `0x2B` caller info;
- whether a held-open receive stream works on this phone's `tinyserver`;
- the stock channel database itself (the report found no `databases/` folder: the stock app had not been opened since its data was last cleared).

## 1. Process and lifecycle

**Start-up order:**
1. `PrizeInterPhoneApp.onCreate` (R, `PrizeInterPhoneApp.java:15-39`):
   - On the first boot after an OTA (`Settings.System db_ota_or_first_boot == 1`), it **deletes its own databases and its prefs file**, then sets the flag to 0.
   - It then runs `DmrManager.init()` (opens the DBs, seeds the default areas).
2. `InterPhoneHomeActivity.onCreate` (R, `InterPhoneHomeActivity.java:91-131`):
   - binds `InterPhoneService`;
   - `init()` reads `dmr009/pwd`; when it reads `pwd :0` it writes `"1"` (`PERSON_CONTACTS_SELETED_ID_DEFAULT` = `"1"`), at once with no delay.
3. `InterPhoneService.onCreate` (R, `InterPhoneService.java:48-57`):
   - opens the serial port (`DmrManager.initSerialPort` → `SerialManager.init`);
   - takes a `PARTIAL_WAKE_LOCK` ("dmr_service");
   - is `persistent`, priority 1000 in the manifest.

The 26 powers the module 1 s after the activity starts (`mModulePowerOn`, `InterPhoneHomeActivity.java:165`) and starts PCM read at once.

**Shut-down:**
- `InterPhoneHomeActivity.onDestroy` writes `pwd` `"0"` when it reads `pwd :1` (`:145-155`).
- The Local tab's "exit app" writes `pwd` `"0"`, stops the service and calls `System.exit(0)` (R, `fragment/InterPhoneLocalFragment.java:574-580`).
- Nothing happens on screen-off. The wake lock keeps the CPU up while the service lives.
- Same as the 26 apart from the 1 s delay.

**SignalDeck:** `RadioEngine.powerOn` writes `pwd` when it is off and waits for the banner. **Same.**

## 2. The serial layer

- **Open** (R, `com/serial/port/SerialPort.java:45-70`):
  - `open("/dev/ttyS1", 57600, 0)` through `System.loadLibrary("serial_port_app")` (`:92-94`).
  - The library is in `/system/priv-app/PriInterPhone/lib/arm64/`, not in the APK (`extractNativeLibs=false`, the APK has no `lib/`).
- **Dead code:** two other open paths are never called.
  - `serial/Serial.java` loads `libdrm` and opens `ttyS1` (R, no call sites).
  - `manager/InterPhoneManager` + `SerialPortManager` (R, no call sites).
- **Reader** (R, `codec/AsyncPacketReader.java:99-135`):
  - big-endian header `68 cmd rw sr ckH ckL lenH lenL`, body, tail `10`;
  - `BF AA` is the boot banner, decoded as `MODULE_INIT_CMD`.
  - The 26's reader also skips a leading `00` or `F0` byte; the 20WT's doesn't. That's a reader detail; SignalDeck's `FrameCodec` already resyncs.
- **Checksum** (R, `codec/PacketEncoder.java`): the same ones'-complement 16-bit sum over the frame with the checksum field zeroed, as on the 26.
- **Writer** (R, `codec/AsyncPacketWriter.java`): one write per packet, no retries, no gap between writes, no ack matching. Any wait comes from the UI.
- **Acks** (R, `handler/ModuleStatusMessageHandler.java:20-32`): every `0x36` status is acknowledged with `68 36 01 01 … 01`. Same as the 26.

## 3. The command table

`protocol/Const.java` lists the same command numbers as the 26:
- `0x22` digital and `0x23` analog channel; `0x24`/`0x25` queries; `0x26` launch; `0x27` query init;
- `0x28` enhance, `0x29` encrypt, `0x2A` mic, `0x2B` caller info, `0x2C`/`0x2D` texts;
- `0x2E` volume, `0x2F` monitor, `0x30` squelch, `0x31` power save, `0x32` RSSI, `0x33` relay;
- `0x34` version, `0x35` interrupt, `0x36` status, `0x37` policy, `0x38`/`0x39` mixed check, `0x3A` SMS protocol, `0x3B` TOT, `0x3C` speaker.

The status codes 1–13 are the same too. The only difference is that the 26 adds `0x3F` (bit-error-rate test).

**Bodies.** I compared every message's field order and `put`/`get` sequence across the 26 message classes. They're **identical**, except for the default analog volume byte (D7: 5 here, 8 on the 26). So:
- `0x23` is the same 19-byte body;
- `0x22` is the same 163-byte body (with `groups[32]`);
- `0x2B` decodes the same 9 bytes (type, caller LE, target LE);
- `0x2C` is the same text header.

(R)

**Sent by the 20WT app** (R, every `new …Message()` / `.send()` outside `message/`):
- `0x22`/`0x23` (`DmrManager.sendDigitalMessage`/`sendAnalogMessage`, `:277-309`);
- `0x26` (`launchCommand`/`launchEnd`, `:669-679`);
- `0x27` (`InterPhoneTalkBackFragment.mToastInitTry`, `:82-88`);
- `0x2C` (`sendSms`, `:427-443`);
- `0x2D` (`onNewSmsNotify`, `:390-393`);
- `0x34` (`InitMessageHandler`, `:53-58`);
- `0x3B` (`VersionMessageHandler`, `:15-19`);
- `0x36` acks.

`InitMessage` (`0xAA`, `queryInitStatus`) and `SmsProtocolMessage` (`setSmsProtocol`) have **no callers**. Everything in D10 is never sent, so **whether this module implements it is unknown**.

**Channel writes:**
- **Analog:** only band, power, frequencies, sq, the tone types and codes are set. pwrSave, volume, monitor and relay keep the class defaults: 2, **5**, 2, 2.
- **Digital:** sets localId, the frequencies, power, contactType, txContact, cc, slots, mode, encryption and `groups` (only for group calls). The rest are defaults: pwrSave 1, volume 8, mic 0, relay 2. Same as the 26.

## 4. Transmit

The whole sequence is in `fragment/InterPhoneTalkBackFragment.java` (R).

**Key down:**
- **Side key.** `com.interphone.ptt.down/up` only (`onCreate` `:167-171`, receiver `:566-616`). The app has no `onKeyDown`.
  - The report shows the framework (`smartlinkkey`, keycode 301) sending **each broadcast twice** per press.
  - The app's `isPTTRecord`/`isStartRecord` flags absorb the duplicate.
- **Delay before keying.** Down posts `recordTalkRunnable` 150 ms later, or 500 ms when a reception has to be stopped first. If the last release was less than 2 s ago, it waits until about 2.2 s (2.5 s while receiving) after that release (D6).
- **`startRecordTalk`** (`:393-416`):
  - audio focus, start tone;
  - `PrizePcmManager.startPcmRecord()`:
    - `openWritePcm`;
    - `getFrameSize`;
    - `AudioRecord(MIC, 8000, CHANNEL_IN_STEREO, PCM_16BIT)`;
    - a thread copies `read` into `writeFrame` (`manager/PrizePcmManager.java:62-161`);
  - then `sendTalkRunnable` **600 ms later** → `startSendTalk` → `0x26` 1 (`:413`, `:419-428`).
  - If `openWritePcm` fails, it shows "send timeout" and never keys.
- **No GPIO.** The `ptt` sysfs node isn't used. Keying is the UART command only.

**Release** (`stopRecordTalk`, `:460-492`): stop the microphone and `closeWritePcm`, **then** `0x26` 2, then the end tone.

**Timers:**
- a 30 s UI countdown (`pref_person_limit_send_time`, default 30) ends the key;
- module status 6 (`RELAY_TIMEOUT`) shows "send timeout", stops the PCM and sends `0x26` 2 (`:713-735`);
- "busy, no send" (default on) refuses to key while receiving and ends a key when a reception starts.

**Compared with the 26:** the 26 sends `0x26` 1 **first** and opens the PCM right after (TalkBackStateMachine RecordSoundState). Its release order is the same as here. SignalDeck follows the 26 on key-down (`RadioService.ptt`: `engine.ptt(true)` then `audio.startTx()`) and this app on release. **D5 is the one real transmit difference.** On this phone the module may expect audio frames to be flowing before the key (I).

## 5. Receive

**Start and end:**
- `DmrManager.onModuleStatusReceived` (`:319-352`) turns status 1/2 into `onReceiveStart`/`onReceiveStop`.
- The fragment's `startReceive` (`:671-689`) opens `PCMReceiveManager.startPcmRead()`, which does:
  - `AudioTrack(STREAM_MUSIC, 8000, CHANNEL_OUT_STEREO, PCM_16BIT)`;
  - `openRecvPcm`, with frames from `registerRecvCallback` written to the track (`manager/PCMReceiveManager.java:50-176`).
- Status 2 closes both (D8).
- The 26 opens the read path at start-up and keeps it open.

**Format:** 8 kHz stereo 16-bit, the same as the 26 (R).

**Squelch and monitor:** the app sends no monitor or squelch command (D10). The channel's `sq` byte is the only squelch control.

**Caller info:**
- `0x2B` is registered with an **empty** handler (`handler/DigitalAudioMessageHandler.java`), and the app never asks for it.
- So the 20WT's stock app never shows who is calling (R). Whether the module answers `0x2B` is unknown.

**DMR texts:** status 5 → `0x2D` fetch → `FetchSmsMessage` (type, callID LE, UTF-16LE) → stored. Same as the 26.

## 6. Boot handshake

1. The module is powered by `pwd` 1.
2. The banner `BF AA …` → `InitMessageHandler` → `DmrManager.onModuleInited()`:
   - `syncChannelInfo()` writes the active channel (`0x22` or `0x23`);
   - `0x34` version.
3. `VersionMessageHandler` → `0x3B` TOT **0** (module timer off), then the version string is stored in prefs.
4. **Fallbacks** (`InterPhoneTalkBackFragment.onCreate:176-178`):
   - at **6 s** with no banner, `0x27` query init;
   - at **8 s**, it behaves as if the module had started and writes the channel anyway.
5. Nothing else is sent. No mic, interrupt, volume, squelch or SMS protocol.

**SignalDeck** waits up to 10 s for the banner, then sends:
- `0x34`;
- the channel;
- `0x35` (digital) or `0x2A` 4 (analog);
- `0x3B` 120.

The `0x2A`/`0x35` step has never been seen by this module (D4).

## 7. Channels and storage

**Channels** (R, `serial/data/DBChannelHelper.java:55-66`, `UtilInitChannelData.java:40-60`, `res/values/strings.xml`):
- **File and table names:**
  - one SQLite file per area, `channel_database_<name>.db`;
  - one table, `channel_database_<name>`.
- **Area names:**
  - from `local_device_area_array_db`: `Default`, `USA_FRS`, `USA_FRS_GMRS`, `EU_FRS`, `AUS_FRS`, `China_FRS`, `China_Taiwan_FRS`, `IRAN_FRS`, `JAPAN_FRS`, `KOREA_FRS`, `MALAYSIA_FRS`, `NORWAY_FRS`, `RUS_FRS`, `South_Afirca_FRS` (sic);
  - plus user areas listed in the prefs key `PREF_PERSON_DEVICE_AREA_LIST`.
- **Columns** are the 26's set without `channel_relay` and `channel_interrupt`:
  - `_id`, `channel_name`, `channel_type` (0 digital, 1 analog), `channel_number`;
  - `channel_txFreq`, `channel_rxFreq`, `channel_power`, `channel_cc`;
  - the in/out slots, the channel mode;
  - `channel_contactType`, `channel_txContact`;
  - `channel_encryptSw`, `channel_encryptKey`;
  - `channel_band`, `channel_sq`;
  - `channel_rxType`, `channel_rxSubCode`, `channel_txType`, `channel_txSubCode`;
  - `channel_active`, `channel_groups`.
- **The 26's deployed app:** `database_channel_area_<key>.db`, keys `default_uhf` … (SignalDeck `ChannelStore.importFromStock`).

**Other databases:**
- `contact_database.db`: same table and columns as the 26;
- `message_database.db`, `conversation_database.db`, `record_database.db`.

**Recordings:** `/sdcard/interphone/record/*.pcm`.

## 8. 20WT-specific

**sysfs nodes:**
- Only `dmr009/pwd` and `dmr009/debug` (read, not used for control) appear in the code.
- The report lists `debug`, `ptt`, `pwd`, `driver_override`, `modalias` and `uevent`, all `sysfs_prizefactory` or `sysfs`.
- At rest, `ptt` reads `ptt :1` and `pwd` reads `pwd :0`.
- The device tree has `ptt-gpio`, `pwd-gpio` and `3v3-gpio`.

**Audio service:** `android.os.PrizeTinyService` / `tinyserver` (the report lists `tinyservice: [android.os.ITinyService]` and the `tinyserver` process). Same as the 26.

**Debug properties:** `PrizePcmManager.initRecord` reads `debug.channel` (2), `debug.rate` (8000) and `debug.bits` (16) as overrides. The defaults match the 26.

**Other code:**
- `com.pri.androidinfraredranginglib` is in the APK. It isn't used by the radio code (I: an infrared range-finder feature of the phone).
- A `vendor.mediatek.hardware.nvram` stub is present, unused by the radio.

**No firmware update path, no firmware file (D3).**
- The module's image and update protocol are unknown on this phone.
- The `ptt` line that the 26 uses for the update knock is never driven here, so whether this module's bootloader listens to it is unknown.
- Under the loader safety contract (`radio_firmware/plan-loader-safety.md`: no patches on an undiffed variant), **SignalDeck's loader stays off for this profile**.

## What SignalDeck changes (SignalDeck PR, branch `armor20wt/stock-app-parity`)

Profile fields, built-in only for the 20WT. Every other profile keeps its behaviour (pinned by a test).

| Finding | Profile field (20WT value) | Effect |
|---|---|---|
| D3 | `moduleLoader = false` | firmware loader and symbol engine off |
| D4 | `bootMicInterrupt = false` | boot handshake without `0x2A`/`0x35` |
| D5 | `txAudioLeadMs = 600` | write path opened 600 ms before `0x26` 1 |
| D6 | `minKeyGapMs = 2000` | a key within 2 s of the last release waits for the rest |
| D7 | `analogVolume = 5` | analog channel writes carry volume 5 |
| D9 | `stockAreaPrefix = "channel_database_"`, `stockDefaultArea = "Default"` | stock import finds the 20WT's area files |
| D10 | `stockCommands` (the set in §3) | the device report lists every command SignalDeck sent that the stock app never sends, with the module's answers |

**Not changed:**
- **D8, receive held open.** The only per-reception path in SignalDeck is the Atom XL's USB-bridge capture. Opening per reception on a TinyService phone would be a new engine path built on a guess. The trial take-over already records whether the held stream delivers audio. If the 20WT report shows it doesn't, that becomes the next change.
- **TOT.** SignalDeck keeps sending 120 (the stock 0 turns the module's timer off; 120 is the module's own start-up value).

The profile stays **unverified** (no transmit outside the guided Transmit test session), and its revision goes 1 → 2.

## What the next 20WT device report must bring back

Item by item, and where SignalDeck collects it (*Device → Device report → Run all checks*, choose **Checks + trial**):

1. **Module version string (`0x34`).**
   - Collected by: the trial take-over (opens `ttyS1` through the vendor library, powers the module, handshake). The trial result now prints the version.
   - Why: lets the firmware catalogue name the variant.
2. **Serial at 57600 through `VendorSerial`.**
   - Collected by: the trial. Its result now says which library opened the port and at what speed. The stty probe's 9600 readback on `ttyS1` is flagged as "could not set the speed" rather than "no module".
   - Why: rev 1 is unproven here.
3. **Boot banner seen.**
   - Collected by: the trial result.
   - Why: D4/D6 timing.
4. **Answers to the commands the stock app never sends.**
   - Collected by: the trial's new "commands the stock app does not use" lines (sent / answered / refused per command).
   - Why: D10. Decides RSSI, caller ID, MON and the scanner on this phone.
5. **Receive stream held open.**
   - Collected by: the trial (5 s capture with monitor on, bytes and the first frames).
   - Why: D8.
6. **sysfs nodes.**
   - Collected by: the report (already).
7. **Stock channel database schema.**
   - Collected by: the report, read **again after the 15 s stock-app watch** (the watch opens the stock app, which creates its databases).
   - Why: D9. The beta.18 report found no `databases/` folder.
8. **Stock module image.**
   - Collected by: *Device → Device report → Radio firmware files* (name, size, SHA-256; files are copied only if the owner ticks them).
   - Why: D3. The APK carries none, so search `/system`, `/vendor` and storage.

The transmit checks (key order D5, re-key gap D6, the module's `0x26` answers and status 3/4) belong to the guided **Transmit test session**. A tester runs it only after the read-only report looks right.
