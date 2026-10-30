# Blackview Xplore 1: QuickChat read against SignalDeck's Xplore path

**2026-10-30, Xplore 1 agent.** Plan: `plan-stock-app-review.md`. This is a reading only: there is no Xplore 1 here, nothing was run.

**Inputs.**
- **QuickChat:** the owner-supplied `com.chamsion.quickchat` APK (V1.0, protocol library `com.wonder.dmr` "1.0.9 (2025-4-27)"), decompiled with jadx 1.5.6 into a scratch folder outside the repos. Class names below are jadx's names for the obfuscated code (`q0.g0` is the PTT fragment, `a.b` its work handler, `q0.j0` the status handler, `q0.b0` the microphone reader).
- **SignalDeck:** `origin/main` at `1ee07fe6` plus the open PR 158 (`armor20wt/report-checks`), the base of this work.
- **Earlier work:** `docs/multi-device-xplore1-findings.md` (the 2026-10-22 decompile and the beta.1–18 reports). Its facts are not repeated here unless this reading changes them.
- **Tester reports** (beta.3/5/8/18): device facts only. None of them contains a QuickChat transmission, so everything about transmit below is from the code.

**Markers.**
- **R** = verified by reading the code.
- **I** = inferred (not read directly, or depends on what the module does, which the code can't show).

## Summary

**QuickChat never sends `0x26`.** The Xplore 1 keys through the GPIO line `intercom_ptt_control` alone:
- 0 = transmit, 1 = receive;
- the microphone opens only when the module answers with status 3 (SEND_START);
- the audio goes to `ttyS1` as raw 160-byte blocks.

SignalDeck's transmit path so far would have sent `0x26` and left the line at 1. Nothing shows that this module keys on `0x26` at all (`DmrManager.launchCommand` exists in the library but has no caller). That's the main finding, and the reason this review matters before any transmit test.

| # | What | QuickChat | SignalDeck before this work | R/I |
|---|---|---|---|---|
| X1 | Key | `intercom_ptt_control` ← `0` (`q0.g0.s` → `q`). **No `0x26`** anywhere in the app | `0x26` 1 on the control UART; the line stays 1 | R |
| X2 | Release | `intercom_ptt_control` ← `1` (`q0.g0.g` → `q(true)`) | `0x26` 2 | R |
| X3 | When the audio starts | at the module's status **3** (`q0.j0.a`, "openMic"): `AudioRecord` opened and the reader started then, never before | right after the key command | R |
| X4 | When the audio stops | **200 ms after** the line goes back to 1 (`q0.g0.m` posts `c0` case 3 → `w()`) | stopped before the unkey | R |
| X5 | TX audio format | `AudioRecord(MIC, 8000, mono, 16-bit, buffer 160 B)`, 160-byte blocks (80 samples, 10 ms), **no header**, at least 10 ms apart, written with `SerialPortHelper.sendHex` on `ttyS1` | the same format, same source (MIC); blocks as the recorder delivers them | R |
| X6 | Re-key rule | a press within **1.5 s** of the last release is refused ("click too fast"); the side-key broadcast is ignored within 1.5 s of the last down and the last up | none on this profile | R |
| X7 | Transmit timer | a UI countdown, default **120 s** (setting 15/30/60/120/none); at the end it releases like a key-up. `0x3B` is sent **only when the user changes the setting**, with the same seconds (0 = none), never at start-up | `0x3B` 120 at the handshake; its own transmit limit | R |
| X8 | Boot handshake | banner → `0x27` → `0x34` → channel. **Never `0x2A` mic gain**; `0x35` only after a channel's acknowledgement | `0x34`, channel, `0x2A` 4 (analog) or `0x35` (digital), `0x3B` 120 | R |
| X9 | After every channel acknowledgement | `0x35` (setting, default 2) → on its ack `0x37` polite (setting, default **0**); analog also gets `0x2F` + `0x30` 200 ms after the channel's ack | analog: `0x2F` + `0x30` 200 ms after the ack (rev 2); digital: `0x35` right after the write; **`0x37` never** | R |
| X10 | Text body (`0x2C`) | type, target LE32, text; **5-byte header, UTF-8** (`String.getBytes()`; the "message encoding" setting is stored but unused by this library version) | 9-byte header (type, id, id again / group id), **UTF-16LE** | R |
| X11 | Text received (`0x2D`) | type, sender LE32, text decoded as **UTF-8** (the 9-byte "has local id" variant is off) | decoded as UTF-16LE | R |
| X12 | Text type byte | 1 = private with confirmation, 2 = private without ("IP unconfirmed"), 3 = group; the contact page sends 2 | 1 private, 2 all, 3 group (the Armor 26's meanings) | R (QuickChat's) / I (what the module does with 2) |
| X13 | Status pushes (`0x36`) | never acknowledged; repeats de-duplicated | every push acknowledged | R |
| X14 | Caller ID | `0x2B` never asked; the PTT page shows the channel's own data, not the caller | `0x2B` asked 300 ms and 1.2 s into each DMR reception | R |
| X15 | Volume byte | 0 in every channel write (the field is never set) | analog 8, digital 8 | R |
| X16 | Exit | power, pwd, ptt lines all 0 (`MainActivity.onDestroy`, `DmrService.d`); also `pdt_play=off` / `pdt_mic=off` to `AudioManager` | the pwd line 0 only | R |

**Changed in SignalDeck** (branch `xplore1/stock-app-parity`, see the last sections): X1–X4, X6, X8, X9, X10, X11. **Left as is, with the reason:** X5, X7, X12–X16.

## 1. Transmit, end to end

### 1.1 The press

**Two ways in** (R):
- **On screen:** the PTT button's long-click → `q0.g0.l()`, refused while a phone call is ringing or active.
- **Side key:** `MainActivity` registers `com.android.intent.ptt.down/up` (`q0.i0` case 2). `onKeyDown` ignores keycodes 141/27 when `Build.MODEL` is `XPLORE 1` or `LEDEN-L1`: on this phone the key comes only as a broadcast. That matches the beta reports (`KEY_F1` → broadcast).

**The broadcast is filtered** (`q0.i0` case 2, R):
- dropped during a phone call;
- dropped when the screen is off and the "talk with the screen off" setting is off (default **on**, `j0.c.f2071a`);
- dropped while the start-up progress dialog shows;
- a **down** counts only 1.5 s after the last accepted down **and** after the last up;
- an **up** counts only while a down is open and 1.5 s after the last up.

**`q0.g0.l()`** (R):
- If "polite" is on (pref, default 0) and the radio is sending or receiving, it returns.
- It refuses a press within **1500 ms of the last release** (`f2575d0`, toast "click too fast").
- A press within 500 ms of the previous press releases instead (`g()` + `o()`).
- Otherwise, with "interrupt before transmit" off (pref `launch_interr_enable`, default **false**), it sets state 2 and calls `s()`.
- With that pref on, it sends `0x35` **3** first and keys in the `0x35` callback (`q0.e0.OnCallback`) if the key is still held. The default path sends no command at all before the key.

**`s()` → `q(false)`** writes `"0\n"` to `/sys/devices/platform/intercom/intercom_ptt_control` with a plain `FileOutputStream` (R). That's the key. There is no UART command.

### 1.2 The module answers; the audio starts

**Status 3** (`0x36` body 3) reaches `q0.j0.a(3)` ("openMic", R). It:
- marks the radio as sending;
- plays the start tone;
- starts the transmit countdown;
- then opens `new AudioRecord(1 /*MIC*/, 8000, 16 /*CHANNEL_IN_MONO*/, 2 /*PCM_16BIT*/, 160)`, starts recording and runs the reader `q0.b0` case 0 on a single-thread executor;
- `v()` also starts a second `AudioRecord` (`q0.o0`) that saves the talk to `/sdcard/quickchat/<date>.pcm` for the talk-record list. That's a local recording, not radio data.

**If status 3 never comes, the microphone never opens.** The line stays at 0 until the release (R). There's no timeout.

### 1.3 The audio on `ttyS1`

**`q0.b0` case 0** (R):
- reads 160 bytes at a time;
- turns them into hex, cuts them back into 160-byte blocks;
- at least 10 ms after the previous flush (a busy-wait on `SystemClock.uptimeMillis`), posts each block as message 1 to the work handler.
- The handler drops any block still queued when a newer one arrives (`removeMessages(1)` before `sendMessage`).

**The work handler** `a.b` case 5, message 1 → `g0.D.sendHex(block)` (R). That's `me.f1reking.serialportlib.SerialPortHelper` on `/dev/ttyS1`, opened at 230400 8N1, no flow control (`q0.g0.d`).

So a transmit block is **160 bytes of 8 kHz mono 16-bit PCM, no header, no tail, in the byte order `AudioRecord` gives (little-endian)** (R). Receive blocks carry the `BB 00 … 44` frame; transmit ones don't.

**DMR and analog transmit the same way.** Nothing in the key, the audio or the release looks at the channel type (R).

**SignalDeck's `UartPcmAudio.startTx`** sends the same format from the same source:
- `AudioRecord` MIC, 8 kHz mono 16-bit;
- blocks of up to 160 bytes, each written as it comes;
- `playPcm` paces 160-byte blocks to real time.

**Same** (X5).

### 1.4 The release

**`q0.g0.m()`** (R):
- `g()`: if the press is open and the state is 2, `q(true)` writes `"1\n"` to the ptt line;
- then, **200 ms later**, `c0` case 3: the end tone, `w()` stops and releases the `AudioRecord` (which ends the reader), `x(0)` saves the talk recording.

So **the audio runs 200 ms past the release.** Status 4 from the module only logs "closeMic" and changes nothing (R).

**Who calls `m()`:**
- the button's up/cancel;
- the side key's up;
- the countdown's `onFinish`;
- a phone call starting;
- **status 7**, which runs `m()` and then `l()`. That's a release and a new press; QuickChat's own log calls it "re-key" (R; what the module means by 7 on this phone is I. The Armor 26 names it CHANNEL_BUSY).

### 1.5 Timers

**The countdown** (`q0.f0`, R):
- `ptt_limit_send_time` index, default 3, into `type_ptt_limit_send_value` = {15, 30, 60, 120, 0} s, so **120 s**;
- at the end it calls `m()`.

**`0x3B`** is sent from the settings page (`q0.a1`) with the same seconds when the user picks a value, **0 for "No limit"** (R). Nothing sends it at start-up, so the module keeps whatever it last got, or its own start-up value.

**SignalDeck:**
- sends `0x3B` 120 at the handshake, which equals QuickChat's default;
- its own transmit limit (Device → Longest transmission) and the heat guard end the key.

**Kept** (X7): 120 is what QuickChat's default setting would store, and the module's own start-up value on the Armor's firmware.

### 1.6 Microphone

**Source:** `MIC`. **Rate:** 8000 Hz mono 16-bit. **Gain:** no gain applied in the app; `0x2A` mic gain is never sent (`DmrManager.setMicGain` has no caller). The digital channel's `mic` byte comes from the channel row (R).

**Audio routing:** `MainActivity.onDestroy` sets `AudioManager` parameters `pdt_play=off` and `pdt_mic=off`. Nothing in this build ever sets them `on` (R). A leftover of an older audio route through the phone's codec (I); the PCM-over-UART path doesn't use them.

### 1.7 What SignalDeck did before, side by side

| Step | QuickChat | SignalDeck (rev 2, transmit never reached on this phone) |
|---|---|---|
| press guard | 1.5 s after the last release | none |
| key | ptt line 0 | `0x26` 1, line untouched (stays 1 from `lineSetup`) |
| audio start | at status 3 | at once |
| audio stop | 200 ms after the line goes to 1 | before the unkey |
| unkey | ptt line 1 | `0x26` 2 |

## 2. Texts (`0x2C`, statuses 8/9)

**`DmrManager.sendMsg(type, target, text)`** (R) builds:
- `68 2C 01 01 ckH ckL lenH lenL`;
- the body: **type (1 byte), target LE32, then `text.getBytes()`** (the platform default, UTF-8 on Android);
- the tail `10`.

A detail with no effect on SignalDeck: `lenH` is `(len & 0xFF00)` cast to a byte, so it's always 0. QuickChat can't send a body over 255 bytes.

**The type byte** (R):
- The channel page sends the channel's `smsType`:
  - a private-call channel uses 1 ("IP confirmation") or 2 ("IP unconfirmed"; the `sms_type` list);
  - a group channel uses 3.
- The contact chat page always sends **2** to the contact's number.

**Results:** status 8 → "sent", status 9 → "failed" toasts (`q0.j0.a`). There are no retries (R).

**Receive** (status 5 → `0x2D`, R):
- The reply body is type, sender LE32, text.
- The text is decoded with `new String(bytes)`, which is **UTF-8**.
- The 9-byte variant (`hasSmsLocalId`) is off; nothing sets it.
- The "message encoding" setting (GB2312 default …) only goes into `DmrManager.setMessageEncode`. This library version never reads it back for text.

**SignalDeck before this work** (`RadioEngine.sendSms`):
- a 9-byte header for private and group texts (the Armor 26's firmware drops the first two characters without it, BTECH 6X2 test 2026-10-17);
- UTF-16LE;
- receive decoded as UTF-16LE.

**On the Xplore 1, all three differ from QuickChat (X10, X11).** Which body this module needs is I until a tester sends one. QuickChat's is the only one known to be used with it, so SignalDeck now sends QuickChat's on this profile. The receive side reads both encodings (§ changes).

## 3. The command table, re-checked

**Every `DmrManager` call site in the app** (R, grep over the whole decompiled tree):

| Cmd | Sent by QuickChat | When |
|---|---|---|
| `0x22` / `0x23` | yes | channel writes (`q0.g0.e`, the channel list `q0.p`) |
| `0x26` | **no** | `launchCommand` has no caller |
| `0x27` | yes | start-up, before the version |
| `0x28` | yes | the manager page (radio check, call alert, remote monitor, kill, activate) |
| `0x29` | no | `setEncryption` has no caller (the key goes in the `0x22` body) |
| `0x2A` | **no** | mic gain |
| `0x2B` | **no** | caller info |
| `0x2C` / `0x2D` | yes | texts |
| `0x2E` | no | volume |
| `0x2F` / `0x30` | yes | 200 ms after an analog channel's acknowledgement (`q0.c0` case 4) |
| `0x31` | **no** | power save goes only in the channel bodies (`pwrsave`) |
| `0x32` | **no** | RSSI (this module answers it: beta.1 onwards) |
| `0x33` | no | relay/offline |
| `0x34` | yes | version, and its 5 s watchdog |
| `0x35` | yes | after each channel's acknowledgement (setting, default 2); with value 3 before a key when "interrupt before transmit" is on; value 1 from the settings page |
| `0x36` | **no** | statuses are never acknowledged |
| `0x37` | yes | after `0x35`'s acknowledgement (setting, default 0) |
| `0x3A` | no | SMS protocol |
| `0x3B` | yes | only when the user changes the transmit limit |
| `0x3C` | no | speaker enable |

**Channel bodies** (R):
- **Analog:** frequencies, band, power, sq, the four tone fields, pwrsave, monitor and relay all come from the channel row. Volume is never set, so it's **0** (X15).
- **Digital:** the channel's localId, group list, contact, type, power, cc, slots, mode, encryption, pwrsave, mic and relay. Volume is also 0.
- **The shipped rows** (`assets/databases/channel.db` and the phone's `channels` table): band 0, sq 5, monitor 2, relay 2, pwrsave 1. Channels made in the app take pwrsave from the "save_power" setting (default **2**).

**Against SignalDeck:**
- **pwrsave:** SignalDeck sends 2, the value QuickChat uses for channels its user makes, so it's **kept**.
- **Volume:** SignalDeck sends 8. Receive at 8 is verified (beta.8: clear audio, peak 11582, no clipping). What 0 does to the `ttyS1` level is unknown, so it's **kept**, and PR 158's trial now measures the receive level at the profile's volume and at 8 on this phone too.
- **`0x2B`, `0x32`:** SignalDeck keeps asking (`0x32` is verified on this module; `0x2B` isn't). The report's "commands the stock app does not use" table, now filled for this profile, shows the answers.
- **`0x36` acknowledgements:** SignalDeck keeps acknowledging (X13). Receive on beta.17/18 worked with them, and an acknowledgement can only reduce the repeats QuickChat has to filter (I).

## 4. Receive, re-checked

- **Statuses** (R, `q0.j0.a`):
  - 1 = receiving: the PTT button turns green, the talk recording starts, sending is blocked;
  - 2 = the end;
  - 5 = fetch the text;
  - 6 = "activation timeout" toast;
  - 7 = re-key (§1.4);
  - 8/9 = text results.
  - The playback isn't gated by the statuses (audio plays whenever packets arrive).
  - De-duplication is in `DmrManager` (the 2026-10-22 reading).
  - SignalDeck handles 1–5 and 8/9 the same way. **Same.**
- **Squelch** (R): `0x30` from the channel's `sq` 200 ms after an analog channel's acknowledgement, with `0x2F` from the channel's monitor byte. SignalDeck rev 2 already does this (`globalSquelch`). **Same.**
- **Monitor:** only through the channel's monitor byte and `0x2F` after a channel (R). SignalDeck's MON button sends `0x2F` 1/2. **Same command.**
- **`ttyS1` framing** (`q0.e0.onDataReceived`, R):
  - QuickChat accepts **only reads of exactly 167 bytes**;
  - it reassembles `BB00…44` 334-hex-character packets, with a weak resync on a trailing `bb`;
  - other reads are counted as invalid and dropped.
  - SignalDeck's `PcmFramer` scans for `BB 00 00 A0 … 44` in any read size and skips bytes until it locks (beta.5: 100 packets/s, 0 bytes skipped). **SignalDeck is more tolerant: kept.**
- **Who is talking on DMR:** QuickChat never knows (X14). `DigitalVoiceReceptionInfo` is only the type of `getDigitalVoiceReceptionInfo`'s callback, which has no caller (R).

## 5. Lifecycle

- **Start-up** (R, `DmrService.onStartCommand`, `p0.a`, `j0.a`):
  1. lines power/pwd/ptt 0;
  2. 200 ms later, open `ttyS0` at 57600;
  3. 100 ms later, lines power/pwd/ptt 1 (in that order);
  4. the boot banner → `0x27` (on its answer) → `0x34`;
  5. the first channel write, retried every 500 ms for up to 5 minutes until the module reports ready;
  6. a 5 s version watchdog powers the module again if `0x34` never answered.
  - The PTT fragment opens `ttyS1` at 230400 when it starts.
  - **SignalDeck** (rev 2): `lineSetup` ptt 1, power 1, then the pwd line; the 3 s version wait with a real restart (beta.17). **Same in effect.**
- **Screen off** (R, `App`'s receiver `q0.i0` default case): only when "talk with the screen off" is **off** (default on), the module is powered off at screen-off and on again at screen-on. With the default nothing happens. SignalDeck does nothing at screen-off. **Same as the default.**
- **Exit** (R): power, pwd, ptt lines 0, in that order (X16). SignalDeck's power-off writes the pwd line only and leaves the ptt line at 1 (receive). QuickChat writes its own lines 0 → 1 at every start, so the stock app's next start is unaffected (I). **Kept.**

## 6. Channels and storage

- **Room databases** (R):
  - `channel_database` (version 5): tables `channels` (`id`, `countryId`, `channelIdInCountry`, `channelName`, `channelType` 0 digital / 1 analog, `enbale`, `smsType`, `rx_freq`, `tx_freq` in Hz, `power`, `pwrsave`, `volume`, `relay`, `localId`, `groupList` "1-0-…", `tx_contact`, `contactType`, `cc`, `inboundSlot`, `outboundSlot`, `channelMode`, `encryptSw`, `encryptKey`, `mic`, `band`, `sq`, `rx_type`, `rx_subcode`, `tx_type`, `tx_subcode`, `monitor`) and `countries` (`id`, `countryCode`, `countryName`);
  - `contacts_database` (`contacts_table`: `type` 0 private / 1 group, `name`, `number`, …);
  - `messages_database`, `channel_messages_database`, `pttrecord_database`.
- **SignalDeck's `ChannelStore.importFromQuickChat`** reads `channel_database` (falling back to the bundled `channel.db`), takes the country of the first enabled row, and reads `contacts_database` → `contacts_table`. **It matches the schema.** It ignores `smsType`, which SignalDeck has no field for (I: harmless, the text type now follows the contact).

## 7. Xplore-specific

- **`intercom_factory_test`:** never read or written by QuickChat (R).
- **Detect IRQ:** kernel only; the app logs nothing about it (R).
- **Firmware update** (`UpdateDmrAcitivity`, R):
  - **Reached by** a hidden entry the app's `KeyCodeReceiver` handles (not published here), which sets `upgrade_flag` and opens the app.
  - **The knock:**
    1. ptt line 0;
    2. 55 ms later, power and pwd 1;
    3. 1050 ms later, the ptt line back to 1;
    4. `checkDmrUpgradeMode` sends the byte `0x31` ("1").
  - **The transfer:** YModem-1K with CRC16-XMODEM:
    - first packet `01 00 FF` + "Filename.bin" + size;
    - data packets `02` of 1024 bytes;
    - `04` at the end.
  - **The image:** the user picks the file. **The APK carries no image.**
  - This is the same family as the Armor's update mode (PTT held at power-up, then `0x31`, then YModem-1K; `radio_firmware/plan-loader-safety.md`).
  - **Whether this module's image is a variant SignalDeck's loader may touch is unknown:** V016 `DMR003BN.UV4P` has never been diffed. Under the loader safety contract **the loader stays off** for this profile (`moduleLoader = false`, added here; it was on by default).
- **Remote functions `0x28`:** the manager page only (R). SignalDeck sends `0x28` from its DMR tools. **Same command.**
- **Encryption:** in the `0x22` body (`encryptSw` 1/2, 8-byte key); `0x29` unused (R). **Same as SignalDeck.**

## What SignalDeck changes (branch `xplore1/stock-app-parity`, on top of PR 158)

Profile fields, set only on the Xplore 1. Every other profile keeps its behaviour, pinned by `DeviceProfileTest`.

| Finding | Profile field (Xplore value) | Effect |
|---|---|---|
| X1, X2 | `txLinesOn` = ptt line `0`, `txLinesOff` = ptt line `1` | the engine keys by the line and sends **no `0x26`** whenever a profile has transmit lines (before, only phones with receive lines too) |
| X3 | `txAudioOnSendStart = true` | voice and SignalDeck's own transmissions (APRS, tones, SSTV …) start their audio when the module reports SEND_START; if it never does within 2 s, nothing is sent and the history says so |
| X4 | `txAudioTailMs = 200` | the microphone runs 200 ms past the release |
| X6 | `minKeyGapMs = 1500` | a key within 1.5 s of the last release waits for the rest |
| X8 | `bootMicInterrupt = false` | no `0x2A` / `0x35` at the handshake |
| X9 | `politeAfterChannel = 0` | after each channel's acknowledgement, `0x35` 2 then `0x37` 0, as QuickChat's defaults |
| X10, X11 | `smsUtf8 = true` | texts go out as type + target LE32 + UTF-8 text; received texts are read as UTF-8 unless they look like UTF-16LE |
| § 7 | `moduleLoader = false` | the firmware loader stays off (undiffed variant) |
| § 3 | `stockCommands` = {`0x22`, `0x23`, `0x27`, `0x28`, `0x2C`, `0x2D`, `0x2F`, `0x30`, `0x34`, `0x35`, `0x37`, `0x3B`} | the device report lists what SignalDeck sends beyond these (`0x26` no longer, `0x2B`, `0x32`, `0x36` acks …) with the answers |
| plan | `txTestUnverified = true` | the guided Transmit test session (only it) may key this unverified profile, as on the Armor 20WT; **approved by the owner, 2026-10-30** |

The profile stays **unverified**. Its revision goes 2 → 3.

## What the next Xplore 1 report must bring back

**Read-only** (*Device → Device report → Run all checks*, **Checks + trial**; nothing is transmitted):
1. **Module version** (`0x34`). Known: V016. A new value means a firmware update by the tester.
2. **The "commands the stock app does not use" table** (now filled for this profile): the answers to `0x2B` caller info, `0x32`, `0x2E`, `0x31`, `0x3C`, the `0x36` acknowledgements.
3. **PR 158's trial on this phone:**
   - the squelch verdict (this phone has needed monitor before);
   - the receive level at the profile's volume and at 8;
   - the time to a steady reading after a retune;
   - the band edges.
4. **The ptt line:** written at bring-up (`line intercom_ptt_control -> 1` in the app log). It reads back empty on this phone, so only the log shows it.
5. **The stock databases after the 15 s stock-app watch:** already listed; confirms `channel_database` v5.
6. **`stock_serial.txt`** from the 15 s watch: QuickChat's own handshake on the wire, including whether it sends `0x35`/`0x37` after its channel.

**Then the Transmit test session** (only after the read-only report looks right; licensed tester, low power, a dummy load or a simplex frequency they may use). On this phone each key records:
- **the line write and the module's SEND_START delay** (the session's status timeline). A key with no SEND_START means the line didn't key the module.
- **the release:** SEND_STOP after the line goes to 1.
- **the receiving radio's verdict** on the voice (the `ttyS1` audio path).
- **a DMR text step** (new, on profiles with `smsUtf8`): one short text to the channel's contact, the module's status 8 or 9, and whether the other radio shows it correctly.
