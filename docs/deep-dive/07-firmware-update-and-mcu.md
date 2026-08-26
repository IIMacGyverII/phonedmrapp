# Chapter 7 — Firmware Update (YModem) and the Radio MCU

The DMR radio is a separate ARM Cortex-M microcontroller reached over UART. The OEM app
(`com.pri.prizeinterphone`) can push a new MCU firmware image to it with a sender-initiated,
1K-block YModem transfer. This chapter documents the trigger path, the wire protocol, what is
known about the MCU image, the 14-patch campaign against the group-call RX bug, and how to
safely test a modified image today.

**Bottom line up front:**
- The update is triggered by the exported intent `prize.intent.action.update.dmr.firmware`,
  or by dropping `/sdcard/DMR/DMRDEBUG.bin` (which overrides the bundled asset unconditionally).
- The transfer is a **nonstandard sender-driven YModem**: 1024-byte STX blocks, 128-byte
  header/END blocks, CCITT CRC-16, ACK/NAK/'C'/CAN control bytes, 6 retries, 15 s per-block timeout.
- The patched image lives in **MCU RAM only** — it reverts on radio power-cycle. This is
  well-evidenced empirically; the "RAM not flash" mechanism itself is inferred, not proven.
- The group-call RX bug (contactType=2 → groupId `0xFFFFFF`) was **not** fixed by any of 14 NOP
  patches. Permanent flashing via UART is blocked (`/dev/ttyS1` → EACCES).

---

## Source files

| Area | Path / doc |
|---|---|
| Update UI | `app/src/main/java/com/pri/prizeinterphone/activity/UpdateFirmwareActivity.java` |
| Update orchestration | `app/src/main/java/com/pri/prizeinterphone/ymodem/YModemManager.java` |
| YModem state machine (sender) | `.../ymodem/YModem.java` |
| Packet builder (headers, CRC, EOT/END) | `.../ymodem/YModemUtil.java` |
| CRC-16 table + calc | `.../ymodem/CRC16.java` |
| Serial read loop / write | `.../ymodem/YModemThread.java` |
| File streaming (1K reader) | `.../ymodem/FileStreamThread.java` |
| Stream source (file:// vs assets://) | `.../ymodem/InputStreamSource.java`, `SourceScheme.java` |
| Progress parcel | `.../ymodem/YModemTXMsg.java` |
| Callback interface | `.../ymodem/YModemListener.java` |
| Timeout helper / logger | `.../ymodem/TimeOutHelper.java`, `Lg.java` |
| MCU bootloader-mode GPIO poke | `.../Util/ReadFileUtils.java` |
| Version query message | `.../message/VersionMessage.java`, `.../handler/VersionMessageHandler.java` |
| Version compare / asset scan | `.../manager/DmrManager.java` (`getVersionNumberFromModule/Res`, `getVersionFromRes`, `onVersionReceived`) |
| Command IDs | `.../protocol/Const.java` |
| Update-status guard | `.../Util/Util.java` (`isDmrUpdateIdle`, nvram stubs) |
| Intent filter | `app/src/main/AndroidManifest.xml` |
| Bundled factory image | `app/src/main/assets/DMR003.UV4T.V022.bin` (378,620 B, MD5 `4426035392262CA54583C230C9E268E0`) |
| Mod: one-tap reload | `DMRModHooks/app/src/main/java/com/dmrmod/hooks/PatchReloadHelper.java` |
| Mod: bootloader probe | `DMRModHooks/.../UARTBootloaderProbe.java`, `DMRModHooks/bootloader_probe_results.txt` |
| Mod: completion hook (disabled) | `DMRModHooks/.../MainHook.java` (`hookUpdateFirmwareActivity` 3801–3946, `testBootloaderAccess` 11809–11858) |
| Mod: bundled patched image | `DMRModHooks/app/src/main/assets/PATCH14.bin` (378,620 B, MD5 `4c8afcc3e6a87480bdb307d9321b03cb`) |
| Firmware notes | `radio_firmware/README.md`, `docs/FIRMWARE_ANALYSIS_SUMMARY.md`, `docs/FIRMWARE_FLASHING_EXPLORATION.md`, `docs/DMR_FIRMWARE_RELOAD_NOTES.md` |
| Patch campaign | `docs/FIRMWARE_PATCH_RESULTS.md`, `docs/PATCH12_BREAKTHROUGH.md`, `docs/PATCH14_BREAKTHROUGH.md`, `docs/PATCH_RELOAD_TEST_RESULTS.md` |
| Constraints | `docs/DMR_GROUP_CALL_ISSUE.md`, `docs/DMR_GROUP_CALL_RESEARCH.md`, `docs/DMR_FIX_ROADMAP.md`, `docs/SQUELCH_HARDWARE_LIMITATION.md`, `docs/COMMAND_FUZZING_GUIDE.md`, `docs/APRS_TX_INVESTIGATION_FINAL_REPORT.md` |
| Ghidra | `radio_firmware/cmd_handler.c` (failed decompile), `radio_firmware/ghidra_scripts/{FindDMRBug.java,find_contacttype_bug.py,find_dmr_bug.py}`, `docs/GHIDRA_ANALYSIS_STATUS.md`, `docs/GHIDRA_NAVIGATION_GUIDE.md` |

---

## 1. When / how an update is triggered

### 1.1 Entry points

- **Intent action** `prize.intent.action.update.dmr.firmware` on the **exported** singleTask
  activity `UpdateFirmwareActivity` (`AndroidManifest.xml:10-14`).
- **OEM notification**: `MyNotificationManager` builds a `PendingIntent` for that action
  (`MyNotificationManager.java:58`) and shows it as the "update available/failed" notification
  (content4/content5 strings, `MyNotificationManager.java:95,97`).
- **Home screen**: `InterPhoneHomeActivity:412` calls `YModemManager.isNeedUpdateDmr()` to decide
  whether an update is warranted.
- **Mod**: `PatchReloadHelper` fires the activity by explicit component
  (`PatchReloadHelper.java:265-268`, `setClassName("com.pri.prizeinterphone", …UpdateFirmwareActivity)`).

Once the activity binds `InterPhoneService`, on `MSG_CONNECTED_SVC_SUCCEED` (80) it auto-starts the
transfer if **any** of these hold (`UpdateFirmwareActivity.java:78`):

```
YModemManager.isRunning() || !Util.isDmrUpdateIdle() || YModemManager.isExternalSdcardHaveFirmware()
```

So **if `/sdcard/DMR/DMRDEBUG.bin` exists, the transfer starts automatically** on entering the
activity — no version check involved.

### 1.2 How the app learns the MCU version

| Step | Code |
|---|---|
| Send query, command `QUERY_VERSION_CMD = 52` (0x34) | `DmrManager.sendQueryVersionCmdToMdl` → `new VersionMessage().send()` (`DmrManager.java:768`) |
| State machine drives it after init | `CmdStateMachine` cases 2 & 3 call `sendQueryVersionCmdToMdl()` (`CmdStateMachine.java:234,237`) |
| Reply decoded | `VersionMessage.decodeBody`: `version = LE int(bArr)`, `versionName = new String(bArr)` (`VersionMessage.java:22-25`) |
| Reply routed | `VersionMessageHandler.handle` → `DmrManager.onVersionReceived` |
| Stored | `onVersionReceived` puts `versionName` into `PREF_PERSON_DEVICE_DMR_VERSION` (`DmrManager.java:890`) |

`getVersionNumberFromModule()` (`DmrManager.java:981`) re-reads that pref, splits on `.`, and takes
`split[3]` when there are 4 fields else `split[2]` — for the 3-field `DMR003.UV4T.V022` that is
`split[2]` = `V022` — then regex-extracts the digits → `22`.
Default when unknown is `Constants.DEF_MODULE_VERSION = "DMR003.UV4T.V022"` (`Constants.java:22`).

### 1.3 How the app learns the bundled asset version

`getVersionNumberFromRes()` / `getVersionFromRes()` (`DmrManager.java:1001,1041`) list the APK's
`assets/`, pick the single entry matching `DMR*…bin`, and parse the number the same way. **Exactly
one** such asset must exist or it throws `RuntimeException("asset dir dmr firmware must only one")`.

`isNeedUpdateDmr()` = `versionFromRes > versionFromModule` (`YModemManager.java:252-257`). Equal
versions (the shipping case: both `V022`) mean no auto-update is advertised.

### 1.4 DMRDEBUG.bin override and precedence

`YModemManager` static config (`YModemManager.java:25-41`):
- `EXTERNAL_PATH_NAME = "/sdcard/DMR/DMRDEBUG.bin"`
- `CUR_ASSETS_PATH = assets://<the DMR*.bin asset name>`

`getDmrFirmwarePath()` (`YModemManager.java:73`) chooses the source:

```java
if (isExternalSdcardHaveFirmware())   // new File("/sdcard/DMR/DMRDEBUG.bin").exists()
    str = EXTERNAL_FILE_PATH;         // file:///sdcard/DMR/DMRDEBUG.bin
else
    str = CUR_ASSETS_PATH;            // assets://DMR003.UV4T.V022.bin
```

**Precedence:** the external file wins **unconditionally** — no version, size, or checksum gate on
the override itself. Version comparison (§1.2–1.3) only governs whether an update is *advertised*;
it does **not** guard the DMRDEBUG.bin path. This is the entire mechanism used to side-load test
firmware.

> ⚠️ **Doc drift.** `radio_firmware/README.md:49` says the app checks *both* `/sdcard/DMRDEBUG.bin`
> and `/sdcard/DMR/DMRDEBUG.bin`. The code checks **only** `/sdcard/DMR/DMRDEBUG.bin`
> (`YModemManager.java:28,90`).

### 1.5 Size / checksum validation

- **Per-block CRC-16** (CCITT) is appended to every block (§2.3). This is the only integrity check
  the app *sends*.
- The YModem header block carries the **file size** (`YModemUtil.getFileNamePackage`, §2.4). The MCU
  can use it to bound the receive.
- An **optional whole-file MD5** field exists (`YModem.Builder.checkMd5`), but `YModemManager` never
  calls it (`YModemManager.java:107` builds with `filePath/fileName/sendSize/callback` only), so **no
  MD5 is sent**, and the `MD5_OK`/`MD5_ERR` completion branch is effectively dead code (see Gotchas).

> ⚠️ **Doc drift.** `README.md:48` — "App won't flash corrupted firmware (size/checksum validated)".
> True only for per-block CRC-16 + the size hint in the header. There is no app-side whole-image
> checksum, and no size *rejection* logic in the app; a wrong-size or corrupt DMRDEBUG.bin is
> attempted, and acceptance is left to the MCU.

### 1.6 User prompts

`UpdateFirmwareActivity` is a bottom dialog (`setWindowLayoutParams`, gravity 80). `onBackPressed`
is overridden to do nothing. The right button confirms/starts; while running it home-keys out. On
completion (step 32) the left button becomes "restart app" → `DmrManager.restartApp()`. No
destructive confirmation beyond the single button.

---

## 2. The update protocol, step by step

### 2.1 Entering update / bootloader mode

`InterPhoneService.startUpdateFirmware()` (`InterPhoneService.java:119`) releases the normal serial
reader/writer, then calls `YModemManager.startUpdateFirmware()`. That method
(`YModemManager.java:101-219`):

1. Sets nvram status "updating" (stubbed in this build — see Gotchas).
2. Calls `ReadFileUtils.setDmrUpdateCondition()` — a **GPIO knock** over sysfs to put the MCU into
   update mode (`ReadFileUtils.java:120-141`), toggling `/sys/devices/platform/dmr009/pwd` and
   `/ptt`: `pwd↓ (50 ms) ptt↓ (50 ms) pwd↑ (1000 ms) ptt↑`.
3. Starts `YModemThread.startRead()` (serial RX loop) and `YModem.start()` (sender FSM).

There is **no ASCII "enter bootloader" command**; entry is the hardware pin sequence above.

### 2.2 Control bytes and block layout

| Symbol | Value | Where |
|---|---|---|
| SOH (128-byte block) | `0x01` | `YModemUtil.java:16` |
| STX (1024-byte block) | `0x02` | `YModemUtil.java:17` |
| EOT | `0x04` | `YModemUtil.java:15` |
| ACK | `0x06` | `YModem.java:9` |
| NAK | `0x15` (21) | `YModem.java:15` |
| CAN | `0x18` (24) | `YModem.java:10` |
| 'C' (CRC start) | `0x43` (67) | `YModem.java:24` |
| CPMEOF (pad) | `0x1A` (26) | `YModemUtil.java:13` |
| Data block size `mSize` | **1024** | `YModem.java:25`, set via `sendSize(1024)` |

Block = `[type][seq][~seq] + payload(128 or 1024) + CRC16(2)`. Type is STX when
`payload.length == 1024`, else SOH (header, END, or short tail) — `YModemUtil.getDataPackage:47`.

### 2.3 CRC-16 (CCITT, poly 0x1021, table-driven)

```java
// CRC16.java — big-endian CCITT, init 0x0000
public long calcCRC(byte[] b) {
    int i = 0;
    for (byte x : b) i = (table[(i >> 8) ^ (x & 0xFF)] ^ (i << 8)) & 0xFFFF;
    return i;
}
// written MSB-first via DataOutputStream.writeShort (YModemUtil.getDataPackage:56)
```

This is the standard XMODEM/YMODEM CRC (`table[0]=0, table[1]=4129/0x1021`).

### 2.4 Header (filename) block

```java
// YModemUtil.getFileNamePackage — 128-byte SOH block, seq 0
byte[] concat = concat(name.getBytes(), {0}, String.valueOf(fileSize).getBytes());
byte[] block  = Arrays.copyOf(concat(concat, {0}, md5OrEmpty), 128);   // NUL-padded to 128
return getDataPackage(block, 128, (byte)0);  // -> [SOH][0][0xFF] + block + CRC
```

Payload = `filename \0 <decimal size> \0 [md5]` (md5 empty here). Sequence number 0, so
`~seq = 0xFF`.

### 2.5 Sender state machine (`YModem.java`)

The app is the **sender**; the MCU is the receiver. Nonstandard: instead of waiting for the
receiver's `C`, the app first emits a one-byte "hello" (`"1"`) and waits for `C`.

| Step (const) | Sends | Expects | On success |
|---|---|---|---|
| HELLO (2) | `"1"` (`getYModelData`) | `C` (0x43) | → send filename |
| FILE_NAME (4) | 128-byte header block | `ACK C` (0x06 0x43) | → start body |
| FILE_BODY (8) | 1024-byte STX blocks | `ACK` (0x06) per block | read next 1K; report progress |
| EOT (16) | `EOT` (0x04) | `ACK`; `NAK`→resend EOT | → send END |
| END (32) | empty 128-byte block | `ACK` (or `MD5_OK`†) | `onSuccess()` |
| ERROR (64) | — | `CAN`, or 6 failures | `onFailed()` |

† `MD5_OK`/`MD5_ERR` handling is present (`YModem.java:239-252`) but unreachable — see Gotchas.

**Retries / timeouts:** each `sendPackageData` arms a 15 s timer (`PACKAGE_TIME_OUT=15000`).
Timeout or `NAK` → `handlePackageFail`, which resends the current block; after
`MAX_PACKAGE_SEND_ERROR_TIMES = 6` failures it aborts with `onFailed` (`YModem.java:272-285`).
`CAN` aborts immediately (`handleOthers`, `YModem.java:262-268`).

**RX filtering:** `YModemThread.run` reads the serial port and forwards frames; `YModem.onReceiveData`
only dispatches when `0 < len < 3` (`YModem.java:80-82`) — i.e. it expects 1–2 byte replies.

### 2.6 Progress → UI

`YModemManager`'s `YModemListener` (`YModemManager.java:107-206`) fans out to bound clients as
`MSG_UPDATE_FIRMWARE_2_CLT (130)` carrying a `YModemTXMsg{step,currentSent,total}`:
- `onProgress` → step 8 with counters → `UpdateFirmwareActivity.handleMsgFromSvc` sets the
  `NumberProgressBar` percentage (`UpdateFirmwareActivity.java:242-246`).
- steps 2/4 → notification "updating"; step 32 → success UI + `NumberProgressBar=100` + left button
  "restart"; step 64 → failure UI.
- Notifications mirrored through `MyNotificationManager.notifyUpdate2Notification`.
- On success: `Util.setDMRUpdateStatusToNvram("1")` (stubbed no-op here).

### 2.7 Completion / MCU reboot

The app does **not** reboot the MCU. Once the END block is ACKed the new image is already live in
the MCU. The app only offers to restart *itself* (`DmrManager.restartApp`, AlarmManager relaunch,
`DmrManager.java:1063+`). The mod's (disabled) completion hook additionally flushes UART and sends
3× `QUERY_INIT_STATUS_CMD` (0x27/39) to un-hang the module (`MainHook.java:3801-3946`,
`docs/DMR_FIRMWARE_RELOAD_NOTES.md:18-39`).

### 2.8 Failure recovery

On `onFailed`, the thread stops reading and nvram is set to error (`Util.DMR_UPDATE_STATUS_ERROR`,
stubbed). No automatic re-arm; the user re-enters the activity. `releaseYModem()` tears down the
thread/FSM (`YModemManager.java:234`).

### 2.9 Sequence diagram

```mermaid
sequenceDiagram
    participant UI as UpdateFirmwareActivity
    participant SVC as InterPhoneService
    participant YM as YModemManager / YModem (sender)
    participant TH as YModemThread (UART)
    participant MCU as Radio MCU (receiver)

    UI->>SVC: MSG_UPDATE_FIRMWARE_2_SVC (129)
    SVC->>YM: startUpdateFirmware()
    YM->>MCU: GPIO knock (dmr009 pwd/ptt) — enter update mode
    YM->>TH: startRead(); YModem.start()
    YM->>MCU: "1" (HELLO)
    MCU-->>YM: 'C'
    YM->>MCU: 128B header block [name\0size\0] + CRC16
    MCU-->>YM: ACK 'C'
    loop each 1024B block
        YM->>MCU: STX block + CRC16
        MCU-->>YM: ACK
        YM-->>UI: step 8 progress (NumberProgressBar)
        Note over YM,MCU: NAK/timeout → resend (≤6); CAN → abort
    end
    YM->>MCU: EOT
    MCU-->>YM: ACK
    YM->>MCU: END (empty 128B block)
    MCU-->>YM: ACK
    YM-->>UI: step 32 SUCCESS (restart offered)
    Note over MCU: new image runs from RAM (reverts on power-cycle)
```

---

## 3. Does the firmware persist?

**Observed behaviour: no — it reverts on radio power-cycle.** Confidence in the *behaviour* is
**high** (repeated empirical logs); confidence in the *"loaded to RAM, not flash"* explanation is
**medium** (inference, never directly confirmed).

Evidence:
- `docs/FIRMWARE_FLASHING_EXPLORATION.md:33-60`: five separate successful YModem loads, each lost
  after a reset. Signature: with patch `txContact=11904`; after loss `txContact=1`.
- `docs/PATCH_RELOAD_TEST_RESULTS.md:63-67`: "After app restart, patch is always lost (RAM-only
  limitation confirmed)."
- `radio_firmware/README.md:46`, `docs/DMR_FIRMWARE_RELOAD_NOTES.md:95`: state RAM-only as fact.
- Direct flash access to verify was **blocked**: `UARTBootloaderProbe` on `/dev/ttyS1` returned
  `EACCES` (`bootloader_probe_results.txt:61`), so the RAM-vs-flash question was never settled by
  reading the target address back. The claim rests on the revert-on-reset observation, not on a
  confirmed load address.

---

## 4. The MCU firmware, as known

| Property | Value | Source |
|---|---|---|
| Version string | `DMR003.UV4T.V022` | `Constants.java:22`, `README.md:10` |
| Size | 378,620 bytes | asset + `README.md:8` |
| MD5 (factory) | `4426035392262CA54583C230C9E268E0` | `README.md:11`, verified against asset |
| Architecture | ARM Cortex-M, Thumb (mixed 16/32-bit) | `README.md:12` (from docs) |
| Base address | `0x08000000` (STM32/GD32 flash map) | `README.md:13` (from docs) |
| RTOS | uC/OS-III (Micrium) | `FIRMWARE_ANALYSIS_SUMMARY.md:10` (from docs) |
| Tasks | `timer10ms`, `task init`, `cpchanscan` + uC/OS-III system tasks | `FIRMWARE_ANALYSIS_SUMMARY.md:16-28` (from docs) |
| Semaphores | `encrec_sem`, `decrec_sem`, `play_sem`, `Task Sem` | `FIRMWARE_ANALYSIS_SUMMARY.md:30` (from docs) |
| Entropy / magic | 5.4 bits (unencrypted); header bytes `2C 11 01 C0` | `FIRMWARE_ANALYSIS_SUMMARY.md:8,48` (from docs) |
| Module identity | **conflicting**: HR_C6000 / "STM32/GD32F4 clone" / (one doc) "TYT MD-UV380" | see doc-drift below |

### 4.1 `cmd_handler.c` — not a usable command handler

> ⚠️ **Doc drift / naming.** `radio_firmware/cmd_handler.c` (514 lines) is **failed Ghidra
> decompilation**, not a reconstructed serial handler. It contains two functions
> (`FUN_0800b28c`, `FUN_0801035a`) riddled with `halt_baddata()` / "Bad instruction" / decompile
> timeouts, plus a wall of "Removing unreachable block" warnings. There is **no `switch`/`case 0x`
> dispatch, no recoverable command table** — `grep "case 0x"` returns nothing.
> `GHIDRA_ANALYSIS_STATUS.md:33-49` confirms auto-analysis found only ~10 functions and most
> decompiles fail ("Bad instruction - halt_baddata", timeouts). Command internals are therefore
> **unknown from the binary**.

### 4.2 The command set the app speaks (authoritative side)

Because the firmware dispatch is unrecoverable, the known command bytes come from the **app's**
protocol definition `Const.java` (the MCU implements these):

| Byte | Name | | Byte | Name |
|---|---|---|---|---|
| 0x22 | SET_DIGITAL_INFO | | 0x30 | SET_SQUELCH |
| 0x23 | SET_ANALOG_INFO | | 0x31 | SET_POWER_SAVE_MODE |
| 0x24 | QUERY_DIGITAL_INFO | | 0x32 | QUERY_SIGNAL_STRENGTH |
| 0x25 | QUERY_ANALOG_INFO | | 0x33 | SET_OFFLINE_MODE |
| 0x26 | SET_LAUNCH_INFO | | 0x34 | QUERY_VERSION |
| 0x27 | QUERY_INIT_STATUS | | 0x35 | INTERRUPT_TRANSMIT |
| 0x28 | SET_ENHANCE_FUNCTION | | 0x36 | MODULE_PRINT_STATUS_INFO |
| 0x29 | SET_ENCRYPT_FUNCTION | | 0x37 | SET_POLITE_POLICY |
| 0x2A | SET_GAIN_MIC | | 0x38 | SET_MIX_CHECK_INFO |
| 0x2B | QUERY_DIGITAL_AUDIO_RECEIVE | | 0x39 | QUERY_MIX_CHECK_INFO |
| 0x2C | SEND_SMS | | 0x3A | SET_SMS_PROTOCOL_TYPE |
| 0x2D | RECEIVE_SMS | | 0x3B | SET_TOTO |
| 0x2E | SET_VOL | | 0x3C | SET_SPK_EN |
| 0x2F | SET_LISTEN | | 0x3F | TEST_BIT_ERROR_RATE |
|  |  | | 0xAA | MODULE_INIT |

Source: `Const.java:31-59`. Status/event bytes the MCU sends back (RECEIVE_START=1, RECEIVE_STOP=2,
SEND_START=3, …, SMS_*) are in `Const.ModuleStatus`. `VersionMessage` (0x34) is the query used in §1.2.

> ⚠️ **Doc drift.** The analysis docs label 0x22 "SET_RX_GROUP_LIST" and cite a 0x21
> "READ_RX_GROUP_LIST" (`FIRMWARE_ANALYSIS_SUMMARY.md:37-38`). Per `Const.java`, 0x22 is
> **SET_DIGITAL_INFO** and **0x21 does not exist** in the app's command set. 0x2B (called
> "CMD 0x2B status" in the patch docs) is **QUERY_DIGITAL_AUDIO_RECEIVE**.

There is **no LED command** anywhere in the `Const.java` command set — evidence for the "no LED
control" constraint (§5.5).

---

## 5. The patch campaign

### 5.1 Goal

Digital **group-call receive** is broken. In monitor/RECEIVE_ALL mode (`contactType=2`) the firmware
reports the incoming group ID as `0xFFFFFF` (16777215) instead of the real TG (e.g. 11904); the
Android app then filters it as not-in-RX-list, so no audio plays
(`FIRMWARE_PATCH_RESULTS.md:3-5,36-53`). Secondary: `contactType=1` (GROUP) ignores the RX group
list, and `contactType=2` (ALL) is rejected by hardware and reverts to GROUP
(`DMR_FIX_ROADMAP.md:10-14`). The root-cause hypothesis is that the firmware **doesn't extract the
target ID** from the DMR frame on that path — a parsing bug, not a filtering bug.

### 5.2 The 14 patches

All addresses are memory (`0x0800_0000` base); file offset = addr − `0x08000000`.

| # | Address | Change | Result |
|---|---|---|---|
| 1 | 0x0800AC7A, 0xAC88 | NOP BGT/BMI in CMD-0x22 handler | ❌ |
| 2 | 0x0800AC7A | Force BGT unconditional | ❌ |
| 3 | 0x0800AC76/7A/88 | NOP CMP + both branches | ❌ |
| 4 | 0x0801035A | NOP `cmp r7,#0x22` | ❌ |
| 5 | 0x08018F26 | NOP `cmp r2,#2` | ❌ |
| 6 | 0x080490E2 | NOP `cmp r2,#2` | ❌ |
| 7 | 0x080524E0 + 0x080524FA | NOP both | ❌ |
| 8a/8b/8c | 0x18F26 / 0x490E2 / all 5 | individual + "nuclear" | ❌ |
| 9 | 0x08018F2C | BLS→BLO (`0E D9`→`0E D3`) | ❌ (CBZ at 0xF28 still skips) |
| 10/11 | 0x08018F2C | BLS→NOP (`0E D9`→`00 BF`) | ❌ (incomplete; CBZ still skips) |
| 12 | 0x08018F28 + 0x08018F2C | CBZ **and** BLS → NOP (`40 B3`,`0E D9` → `00 BF`,`00 BF`) | ❌ (still 0xFFFFFF; may break frame-validity check) |
| 13 | 0x080490E2 | proposed fallback (BGT NOP) | not deployed |
| 14 | 0x08018F2C | **BLS→NOP only** (`0E D9`→`00 BF`) | ⚠️ inconclusive (see 5.3) |

Sources: `FIRMWARE_PATCH_RESULTS.md:9-34`, `PATCH12_BREAKTHROUGH.md:66-75`,
`PATCH14_BREAKTHROUGH.md:19-24`.

### 5.3 PATCH14 and why it is bundled

PATCH14 = the factory image with **two bytes** changed at file offset `0x18F2C`
(`0E D9` BLS → `00 BF` NOP), intended to force fall-through into the group-ID extraction code for
`contactType=2` (`PATCH14_BREAKTHROUGH.md:19-58`). Verified: `radio_firmware/DMR003.UV4T.V022-PATCH14.bin`
and `DMRModHooks/app/src/main/assets/PATCH14.bin` are byte-identical (MD5
`4c8afcc3e6a87480bdb307d9321b03cb`), 378,620 B, differing from the original only at that offset.

It is bundled in the mod's assets so the **one-tap reload** feature can re-push it after every
reboot (the patch is RAM-only, §3). Note the documented confidence (95%,
`PATCH14_BREAKTHROUGH.md:253`) is **not** backed by a confirmed fix — `DMR_FIRMWARE_RELOAD_NOTES.md:108-124`
records that after loading, group calling was **still not working** and it was never verified that
PATCH14 was actually the resident image.

> ⚠️ **Doc drift (internal).** The disassembly context differs between docs: `PATCH12` shows
> `cbz r0,+16` → 0x08018F3A and `ldr r3,[r4,#120]`; `PATCH14` shows `cbz r0,LAB_08018f7c` and
> `ldr r3,[r4,#28]`. The two accounts of the same bytes disagree — treat the exact operands as
> low-confidence.

### 5.4 `PatchReloadHelper` / `hookUpdateFirmwareActivity` — status today

**Both are currently DISABLED.**

- `MainHook` does **not** call `hookUpdateFirmwareActivity(lpparam)` — the call is commented out
  ("DISABLED 2026-03-09", `MainHook.java:364-367`) and the method body is wrapped in a
  `/* DISABLED … END DISABLED CODE */` comment (ends `MainHook.java:3946`). Likewise
  `testBootloaderAccess()` is commented out (`MainHook.java:414`) and the reload button injection
  is commented out (`MainHook.java:3744`).
- When it *was* active, the hook watched `handleMsgFromSvc`; on step 32 it waited 2 s, flushed the
  UART buffer, sent 3× `sendQueryInitializedCmdToMdl` (cmd 0x27) at 200 ms spacing, resent channel
  config, and finished the activity — the "Test 10" anti-hang sequence
  (`MainHook.java:3831-3931`, `DMR_FIRMWARE_RELOAD_NOTES.md:18-39`).
- `PatchReloadHelper` (still compiles, `403` lines): copies `SOURCE_PATH` → `DEST_PATH`, launches
  `UpdateFirmwareActivity`, polls logcat for `sendEOT` + `onSuccess`, and relies on the (now
  disabled) hook for cleanup/restart.

> ⚠️ **Code/comment mismatch.** `PatchReloadHelper`'s class comment says it copies the *embedded*
> `assets/PATCH14.bin`, but `SOURCE_PATH = "/sdcard/DMR/PATCH14_BACKUP.bin"`
> (`PatchReloadHelper.java:49-51`) — it reads a **pre-staged sdcard file**, not the APK asset. The
> asset must be manually placed there first.

### 5.5 UARTBootloaderProbe results and hard constraints

- **Bootloader probe failed.** `UARTBootloaderProbe` implements the STM32 AN3155 handshake (0x7F
  sync, 0x00/0xFF Get, 0x11 Read-Memory) against `/dev/ttyS1`, but the app-context open returns
  `EACCES` (`bootloader_probe_results.txt:58-73`, `PATCH_RELOAD_TEST_RESULTS.md:8-24`). Conclusion:
  **permanent flash via UART is not possible** from the app.
- **Group-call RX not fixable via NOP patches.** 14 attempts (incl. the "nuclear" all-locations
  patch) never moved the reported group ID off `0xFFFFFF`; the bug is believed to be in frame
  parsing, not in a single conditional (`FIRMWARE_PATCH_RESULTS.md:36-79`,
  `DMR_GROUP_CALL_ISSUE.md:341` "HARDWARE LIMITATION CONFIRMED").
- **Squelch coercion.** Firmware forces `sq→2` for every value except `sq=0`; levels 1–9 cannot be
  set at runtime (`SQUELCH_HARDWARE_LIMITATION.md:4-20`).
- **No LED command.** Not present in the `Const.java` command set (§4.2).
- **APRS TX impossible.** The analog FM path applies voice-optimized DSP that destroys AFSK tones;
  RX decodes perfectly, TX does not (`APRS_TX_INVESTIGATION_FINAL_REPORT.md:1-30`). APRS is RX-only.
- Command fuzzing of the undocumented space (0x00–0xFF, `COMMAND_FUZZING_GUIDE.md`) was built to find
  a bypass/debug command; no bypass command is documented as found.

---

## 6. Practical: safely testing a modified firmware today

These steps are the docs' procedure, **corrected against the code** where they disagree.

**Test a modified image:**
1. Build the patched `.bin` **at exactly 378,620 bytes** (same size — the header carries the size
   and the MCU expects a matching image). Keep a copy of `DMR003.UV4T.V022-ORIGINAL.bin`.
2. `adb push patched.bin /sdcard/DMR/DMRDEBUG.bin`
   (must be this exact path — §1.4; the README's second path does not exist in code).
3. Trigger the update by **launching the activity** (reliable), not merely force-stopping:
   `adb shell am start -a prize.intent.action.update.dmr.firmware`.
   With DMRDEBUG.bin present, entry auto-starts the transfer (`isExternalSdcardHaveFirmware()` true,
   §1.1). Confirm on the dialog if prompted. Wait ~2 min for the 1K-block transfer.
4. On step-32 success the new image is already resident in the MCU (no MCU reboot needed).
5. **Delete the trigger** so it isn't re-pushed on the next entry:
   `adb shell rm /sdcard/DMR/DMRDEBUG.bin`.

**Revert:**
- Remove `/sdcard/DMR/DMRDEBUG.bin` and **power-cycle the radio** (reboot the phone). Because the
  patch is RAM-only (§3), a power-cycle alone reverts to factory even if you forget to delete the
  file — but delete it anyway to stop the app re-uploading it.

**Never:**
- Don't attempt UART bootloader / flash writes — it's `EACCES` from the app and risks a brick
  (`FIRMWARE_FLASHING_EXPLORATION.md`, `PATCH_RELOAD_TEST_RESULTS.md:8-24`).
- Don't interrupt an in-flight YModem transfer (mid-flash on the MCU).
- Don't change the image size, and don't put more than one `DMR*.bin` in the APK assets
  (`getVersionFromRes` throws).

> ⚠️ **Package name — two namespaces.** `README.md:36` uses `adb shell am force-stop com.macgyver.dmr`,
> and that is **correct for the rebuilt app in this repo**: `app/build.gradle:11` sets
> `applicationId "com.macgyver.dmr"`, confirmed by the manifest's `com.macgyver.dmr.files` FileProvider
> authority and `com.macgyver.dmr.*` signature permission (`AndroidManifest.xml:4-5,38`).
> `com.pri.prizeinterphone` is the **Java/component namespace** (source packages, activity class names,
> and the literal value of `PatchReloadHelper.PACKAGE_NAME`, `PatchReloadHelper.java:51`). Use
> `com.macgyver.dmr` for `am force-stop` / `am start -n`, and the action-based
> `am start -a prize.intent.action.update.dmr.firmware` (step 3) is package-agnostic. Note the repo is
> internally inconsistent: `PatchReloadHelper.setClassName("com.pri.prizeinterphone", …)`
> (`PatchReloadHelper.java:266`) only resolves if the *target* app is installed under the original OEM
> applicationId, not under `com.macgyver.dmr`.

---

## 7. Gotchas

1. **MD5 completion path is dead code.** `YModem.handleEnd` compares replies to `"MD5_OK"`/`"MD5_ERR"`
   (6-byte strings), but `onReceiveData` only dispatches replies with `len < 3`
   (`YModem.java:80-82`). Completion therefore relies solely on the 1-byte `ACK`. The app also never
   sends an MD5 (no `checkMd5()` call), so both halves of the MD5 feature are inert.
2. **"Checksum validated" ≠ whole-image.** Only per-block CRC-16 is sent; there is no app-side image
   checksum and no size-rejection. A corrupt/oversized DMRDEBUG.bin is attempted.
3. **NVRAM status is stubbed in this build.** `Util.getDMRUpdateStatusFromNvram` always returns idle
   `"1"` and `setDMRUpdateStatusToNvram` is a no-op (`Util.java:32-42`, "requires system framework
   access"). So `isDmrUpdateIdle()` is always true and the "already updating/error" guards are inert
   — the DMRDEBUG.bin presence check is what actually gates auto-start.
4. **Nonstandard YModem.** Sender emits a `"1"` hello and waits for `C` (normal YModem has the
   *receiver* send `C` first). The MCU firmware expects this exact handshake — a stock YModem host
   won't interoperate.
5. **Odd header seq math.** `getDataHeader` computes `seq = b % 598` (`YModemUtil.java:72`); harmless
   for byte-range sequence numbers but non-idiomatic.
6. **DMRDEBUG.bin overrides unconditionally.** No version/size/signature gate on the override path;
   the only integrity checks are per-block CRC and whatever the MCU enforces.
7. **Module identity is unresolved.** Docs variously call the radio MCU an HR_C6000, an
   "STM32/GD32F4 clone", and (in `APRS_TX_INVESTIGATION_FINAL_REPORT.md`) a "TYT MD-UV380". The base
   address `0x08000000` and STM32-style AN3155 probe are guesses; none were confirmed (probe hit
   EACCES). Treat the architecture facts in §4 as "from docs", not verified against silicon.
8. **`cmd_handler.c` is not a handler.** It is broken Ghidra output; do not cite it for command
   semantics (§4.1).
9. **PatchReloadHelper needs a pre-staged file.** It reads `/sdcard/DMR/PATCH14_BACKUP.bin`, not the
   APK asset, despite its comments (§5.4).
