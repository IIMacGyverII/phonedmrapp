# 01 — OEM Serial Transport & Packet Protocol (PriInterPhone)

The OEM app talks to the DMR radio MCU over `/dev/ttyS0` at 57600 baud, opened by a JNI call in `libinterphone_serial_port.so` (native source is not in this repo). A singleton `SerialManager` owns one `SerialPort`, one blocking reader thread (`AsyncPacketReader`), one single-threaded writer executor (`AsyncPacketWriter`) and one `MessageDispatcher` that maps an inbound command byte to a `MessageHandler` and runs it on a 2-thread dispatch pool. Frames are `68 | cmd | rw | sr | cksum(2,BE) | len(2,BE) | body[len] | 10` with a 16-bit one's-complement checksum computed over the whole frame (checksum field zeroed). There are no sequence numbers, no transport-level acks/retries, and inbound checksums are never verified; request/response correlation is purely "same command byte". All paths shown are relative to `app/src/main/java/com/pri/prizeinterphone/` unless stated otherwise.

## Source files

| File | Lines | Role |
|---|---|---|
| `serial/SerialManager.java` | 101 | Singleton owner of port + reader + writer + dispatcher; `send(Packet)` entry point |
| `serial/port/SerialPort.java` | 94 | JNI open/close of `/dev/ttyS0`; exposes `FileInputStream`/`FileOutputStream` |
| `serial/Serial.java` | 71 | **Dead** older port class (`libdrm`, `FileChannel`s); no callers |
| `serial/MessageDispatcher.java` | 90 | cmd-byte → handler map; hands packets to dispatch executor |
| `serial/PacketReceiver.java` | 8 | Interface `onReceive(Packet, SerialPort)` implemented by dispatcher |
| `serial/DmrListener.java` | 12 | Unrelated listener interface (status/SMS/version) — not used by transport |
| `serialport/Device.java` | 34 | **Dead** POJO (path, baudrate); no callers |
| `codec/AsyncPacketReader.java` | 178 | Reader thread, byte accumulator, frame parser (`decode`) |
| `codec/AsyncPacketWriter.java` | 50 | Wraps `PacketEncoder` in a `WriteTask` on the write executor |
| `codec/PacketEncoder.java` | 57 | Serialises `Packet` → bytes; checksum algorithm |
| `protocol/Packet.java` | 116 | Frame model (`head, cmd, rw, sr, ckSum, len, body, tail`) + `cmd2Str` |
| `protocol/Const.java` | 137 | Command bytes, module-status codes, rw/sr flags |
| `Util/ByteBuf.java` | 119 | Growable `ByteBuffer` wrapper, **little-endian by default** |
| `Util/ExecutorManager.java` | 79 | Named thread pools: write / dispatch / timer |
| `Util/NamedThreadFactory.java` | 27 | Thread naming (`serial-port-*-tN`), forces non-daemon |
| `Util/Clog.java` | 39 | Log wrapper; every call uses tag `fzc` |
| `shellexec/ExecShell.java` | 113 | `Runtime.exec` / `ProcessBuilder` helper — **no callers** in OEM tree |
| `message/BaseMessage.java` | 39 | `encode()` sets rw=1,sr=1,body; `send()` → `SerialManager.send` |
| `talkbak/BaseTalkbak.java` | 39 | Identical shape to `BaseMessage` for PTT (`SendTalkbak`) |
| `handler/BaseMessageHandler.java` | 19 | Generic `handle(Packet)` → `decode(packet)` → `msg.decode()` → `handle(T)` |
| `state/CmdStateMachine.java` | (partial) | Only place with reply timeouts/retries (channel programming) |
| `radio_firmware/cmd_handler.c` (repo root) | 514 | Ghidra output; lines 1–368 are decompiler warnings plus one truncated stub (`FUN_08000c42`, `:13-21`); the remainder is mangled function bodies — **no command dispatch table / IDs recoverable** (a lone `0x22` compare at `:401` is the only value in the command space) |

## 1. UART device discovery / open

- Device path and baud are hard-coded: `open("/dev/ttyS0", 57600, 0)` (`serial/port/SerialPort.java:25`). Third arg is an `int` "flags" parameter passed straight to JNI; its meaning lives in the native lib and is not visible in the repo (inferred: the classic `android-serialport-api` signature `open(path, baudrate, flags)`).
- JNI: `private static native FileDescriptor open(String, int, int)` and `public native void close()` (`SerialPort.java:15-17`), library `interphone_serial_port` loaded in a static initialiser (`SerialPort.java:91-93`). No `.so` is checked in (`find` for `*.so` in the repo returns only mod-side `direwolf_jni.cpp`).
- No `chmod`, no `su`, no shell exec anywhere on the open path (grep for `chmod|"su"|playRuntime|runCmd|getRuntime().exec` hits only `ExecShell.java` itself, which has no callers). Access to `/dev/ttyS0` therefore relies on the app's uid/SELinux context (inferred — the service is declared `android:persistent="true" android:priority="1000"` at `app/src/main/AndroidManifest.xml:41`).
- `open()` is idempotent: returns `true` immediately if `isConnected()` (`SerialPort.java:20-22`). On success it wraps the fd in a `FileInputStream`/`FileOutputStream` (`SerialPort.java:32-33`). On `null` fd it logs `fd == null 打开失败` (`SerialPort.java:28`); on exception it calls `close()` and returns `false` (`SerialPort.java:35-39`).
- `isConnected()` = `success && mFd != null && fis != null && fos != null` (`SerialPort.java:88`).
- `release()` closes both streams, calls native `close()`, nulls `mFd`, `fis`, `fos`, `success=false` (`SerialPort.java:45-77`).
- No reconnect logic exists. The only re-open paths are `SerialManager.init()` (`serial/SerialManager.java:31-52`) and `SerialManager.getSerial()` which calls `open()` every time it is invoked (`SerialManager.java:54-60`, used by `ymodem/YModemManager.java:104`).
- Lifecycle owner: `InterPhoneService.onCreate()` → `DmrManager.initSerialPort()` → `SerialManager.init()` (`InterPhoneService.java:61`, `manager/DmrManager.java:177-179`). Release: `DmrManager.releaseSerialPort()` → `SerialManager.release()` (`DmrManager.java:181-183`), called from `UpdateFirmwareActivity.java:197`, `fragment/InterPhoneLocalFragment.java:494`, and `DmrManager.restartApp()` (`DmrManager.java:1074`). `InterPhoneService.onDestroy()` does **not** release the port (`InterPhoneService.java:75-85`).
- `serial/Serial.java` is a leftover twin (`System.loadLibrary("drm")`, tag `zyingyong`, `FileChannel` based) with zero references in the tree. Ignore it.

## 2. Threading model

| Thread / executor | Created by | Config | Work |
|---|---|---|---|
| `serial-port-read-t<N>` | `AsyncPacketReader.startRead()` via its own `NamedThreadFactory` (`codec/AsyncPacketReader.java:26,36-41`) | plain `Thread`, non-daemon (`Util/NamedThreadFactory.java:20-26`) | Blocking `FileInputStream.read()` loop + frame parsing + `receiver.onReceive()` |
| `serial-port-write-t1` | `ExecutorManager.getWriteThread()` (`Util/ExecutorManager.java:23-29`) | `ThreadPoolExecutor(1,1,0ms, LinkedBlockingQueue(100))` | `AsyncPacketWriter.WriteTask.run()` → encode + `fos.write()` |
| `serial-port-dispatch-t<N>` | `ExecutorManager.getDispatchThread()` (`ExecutorManager.java:31-37`) | `ThreadPoolExecutor(2,4,1s, LinkedBlockingQueue(100))` | `MessageHandler.handle(packet)` |
| `serial-port-timer-t1` | `ExecutorManager.getTimerThread()` (`ExecutorManager.java:39-45`) | `ScheduledThreadPoolExecutor(1)` | **No callers** found in the OEM tree |

Details:
- Reader loop (`AsyncPacketReader.java:57-75`): `while (serial.isConnected() && !isStop)` → `read(fis, nioBuffer)` → on success `flip(); decodePacket(); compact()`; on failure `buffer.clear()`. The whole loop is wrapped in one `try/catch(Exception)` that only logs `run error----` and **lets the thread die** (`AsyncPacketReader.java:72-74`).
- `read()` blocks in `FileInputStream.read(byte[1024])` (`AsyncPacketReader.java:101-102`), returns `true` only if `readCount > 2` (`:105-112`); 1- or 2-byte reads are discarded and also trigger `buffer.clear()` in the caller.
- `stopRead()` sets `isStop=true`, `thread.interrupt()`, nulls the thread (`AsyncPacketReader.java:47-54`). `interrupt()` does not unblock a `FileInputStream.read`; the loop exits only when the read returns (typically after `SerialPort.release()` closes the fd and the read throws → `-1`).
- `isStop` is `true` after construction (`:33`) and only set `false` by `startRead()`; it is **never** set back to `true` if the thread dies from an exception, so `SerialManager.init()`'s `if (reader.isStop()) startRead()` (`SerialManager.java:47-49`) will not restart a crashed reader.
- Writer: `AsyncPacketWriter.write(packet)` just enqueues a `WriteTask` (`codec/AsyncPacketWriter.java:20-22`); the task allocates `ByteBuf.allocate(bodyLen + 8)` (grows automatically; frame is actually `bodyLen + 9`), encodes, and writes the full frame in a single `fos.write(array)` (`:36-47`). Writes are serialized by the single thread; IOExceptions are only printed.
- Dispatch: 2 core threads → handlers for successive packets can run concurrently and complete out of order (`ExecutorManager.java:34`). Max pool 4 is only reached after the 100-slot queue fills.
- Rejection: both queues use `RejectedHandler` which logs `a task was rejected r=%s…` under tag `zyingyong` and silently drops the task (`ExecutorManager.java:70-78`).
- `ExecutorManager.shutdown()` (`:47-63`) and `isMPThread()` (`:65-67`) have no callers; executors live for the process lifetime.
- `SerialManager.release()` (`SerialManager.java:62-68`) calls `releaseReader()`, `releaseWriter()`, `releaseSerial()` and then `instance = null`. `releaseWriter()` has a copy-paste bug: it nulls `this.reader` instead of `this.writer` (`SerialManager.java:88-93`).
- Firmware update path bypasses the packet layer: `InterPhoneService.startUpdateFirmware()` calls `releaseReader()` + `releaseWriter()` then `YModemManager.startUpdateFirmware()` (`InterPhoneService.java:118-122`), which grabs the raw `SerialPort` via `SerialManager.getSerial()` (`ymodem/YModemManager.java:104`) and runs `YModemThread` (also named `serial-port-read-t…`, `ymodem/YModemThread.java:21`) polling `available()` on the raw streams (`YModemThread.java:82-120`).

## 3. Wire format

### Frame layout (app → MCU, from `PacketEncoder.encode`, `codec/PacketEncoder.java:9-22`)

| Offset | Size | Field | Value / notes |
|---|---|---|---|
| 0 | 1 | `head` | `0x68` (`protocol/Packet.java:17`) |
| 1 | 1 | `cmd` | command byte (§5) |
| 2 | 1 | `rw` | app always sends `1` (`WRITE_MODE`) — set in `BaseMessage.encode()` (`message/BaseMessage.java:20`) |
| 3 | 1 | `sr` | app always sends `1` (`SRFlag.SET`) (`BaseMessage.java:21`); in replies: `0` success, `1` fail, `2` checksum error (`protocol/Const.java:94-99`) |
| 4–5 | 2 | `ckSum` | **big-endian** (`PacketEncoder.java:15-16`) |
| 6–7 | 2 | `len` | body length, **big-endian** (`PacketEncoder.java:17-19`) |
| 8 … 8+len-1 | len | `body` | message-specific; message bodies are built with `ByteBuf`, which is **little-endian** (`Util/ByteBuf.java:19,25,31`) |
| 8+len | 1 | `tail` | `0x10` (`PacketEncoder.java:21`, `Packet.java:18`) |

`Packet.HEADER_LEN = 8` (`Packet.java:10`); total frame = `9 + len`.

### Checksum (exact code, `codec/PacketEncoder.java:24-56`)

The checksum is computed over the complete frame **with the checksum field set to 0 and including the `0x10` tail**, as a 16-bit one's-complement sum (Internet-checksum style, odd trailing byte padded into the high half):

```java
private static int checkSum(Packet packet) {
    ByteBuf allocate = ByteBuf.allocate(1024);
    allocate.put(packet.head); allocate.put(packet.cmd);
    allocate.put(packet.rw);   allocate.put(packet.sr);
    allocate.putShort(0);                       // checksum placeholder
    short bodyLength = (short) packet.getBodyLength();
    allocate.put((byte) (bodyLength >> 8)); allocate.put((byte) bodyLength);
    allocate.put(packet.body);
    allocate.put((byte) 16);                    // tail is included
    return pcCheckSum(allocate);
}
private static int pcCheckSum(ByteBuf byteBuf) {
    ByteBuffer nioBuffer = byteBuf.nioBuffer(); nioBuffer.flip();
    long j = 0;
    while (nioBuffer.remaining() > 1)
        j += (((nioBuffer.get() & 0xFF) << 8) | (nioBuffer.get() & 0xFF)) & 0xFFFF;
    if (nioBuffer.hasRemaining()) j += (nioBuffer.get() & 0xFF) << 8;
    while ((j >> 16) > 0) j = (j & 0xFFFF) + (j >> 16);   // fold carries
    return ((int) j) ^ 0xFFFF;                             // one's complement
}
```

### Worked example — `VolumeMessage` (`SET_VOL_CMD` 0x2E, vol=8, `message/VolumeMessage.java:14-29`)

Bytes with checksum zeroed: `68 2E 01 01 00 00 00 01 08 10`. 16-bit words: `0x682E + 0x0101 + 0x0000 + 0x0001 + 0x0810 = 0x7140`; no carry; `~0x7140 = 0x8EBF`.

Frame on the wire: **`68 2E 01 01 8E BF 00 01 08 10`**

Other frames computed the same way (verified with a script implementing the code above):
- `InitMessage` (0xAA, body `01`): `68 AA 01 01 95 43 00 01 01 10`
- Module-status ack sent by `ModuleStatusMessageHandler.sendAck()` (0x36, body `01`, `handler/ModuleStatusMessageHandler.java:25-31`): `68 36 01 01 95 B7 00 01 01 10`
- `SquelchMessage` (0x30, sq=2): `68 30 01 01 94 BD 00 01 02 10`

### Parser (`AsyncPacketReader.decode`, `codec/AsyncPacketReader.java:115-177`)

State is held entirely in the accumulating `ByteBuffer` (direct, initial capacity 32767, `AsyncPacketReader.java:27`; the loop calls `checkCapacity(1024)` before each read so ≥1024 bytes are free, doubling capacity when they are not, `:63`, `Util/ByteBuf.java:94-104`). `decode()` is called repeatedly until it returns `null` (`:77-86`). Per call:

1. `byteBuffer.order(BIG_ENDIAN)` (`:116`). If fewer than **8** bytes remain → return `null` (`:118`). Note 8, not 9: a complete zero-body frame is 9 bytes.
2. **BER-test bypass:** if `DmrManager.isTestBitErrorRate()` (`manager/DmrManager.java:143`), the *entire* remaining buffer is wrapped as a `Packet(0x3F)` with `body = raw bytes` and returned (`:119-126`). Set by `FragmentLocalTestBiteErrorRateActivity.java:31`, cleared by `InterPhoneHomeActivity.java:156`.
3. `mark()`; read `head`. If `head == 0x00` skip one byte and re-read (`:134-137`). The next check `if (b == 240)` is dead code: `b` is a signed `byte` (max 127) compared with `int 240` (`:138-141`).
4. Read `cmd`. Special case: `head == 0xBF (-65) && cmd == 0xAA (-86)` → skip 15 more bytes (17-byte frame), return `Packet(0xAA)` with `head=0xBF`, no body (`:144-152`). Inferred: MCU boot/"module init" banner.
5. Read `rw`, `sr`, `ckSum` (BE short), `len` (BE short) (`:153-156`).
6. If `head == 0x68`: read `len` body bytes (if `len > 0`), read and **discard** the tail byte (not checked), build the `Packet` (`:158-172`). `ckSum` is stored but **never validated**.
7. Else `reset()` to the mark and return `null` (`:174`).

Resynchronisation, sizes, timeouts:
- There is **no scan-for-sync**. If the buffer starts with a byte that is neither `0x00`, `0x68`, nor the `BF AA` pair, step 7 resets and returns `null` every time; `compact()` keeps the garbage at the front, so parsing is wedged until the next read returns ≤2 bytes (which triggers `buffer.clear()`, `:64-65`) or the buffer overflows.
- If ≥8 bytes are present but the body/tail has not fully arrived, `byteBuffer.get(bArr)` / `get()` throw `BufferUnderflowException`; nothing catches it inside `decode`, so it propagates to `run()`'s catch and **terminates the reader thread** (`:72-74`). A fragmented frame is therefore fatal for RX until the service is restarted. (Whether the native layer's read semantics make fragmentation rare is not visible in the repo.)
- No parser timeouts. Max body length is what fits in a signed `short` `len` masked to 16 bits (`:156`); no upper-bound check.
- Each read logs the full 1024-byte scratch array as hex (`:104`) at `Log.i` — very chatty.

## 4. `Packet` class (`protocol/Packet.java`)

| Field | Type | Default | Notes |
|---|---|---|---|
| `head` | `byte` | `104` (0x68) | settable via `setHead` (`:92-94`); decoder sets `0xBF` for the init banner |
| `cmd` | `byte` | ctor arg | `Packet(byte cmd)` is the only constructor (`:84-86`) |
| `rw` | `byte` | 0 | `Const.RWMode`: 0 read, 1 write |
| `sr` | `byte` | 0 | `Const.SRFlag` |
| `ckSum` | `short` | 0 | only populated on decode; encoder recomputes |
| `len` | `short` | 0 | only populated on decode; encoder uses `getBodyLength()` |
| `body` | `byte[]` | `null` | `getBodyLength()` returns 0 for `null` (`:104-110`) |
| `tail` | `final byte` | `16` (0x10) | constant |
| `HEADER_LEN` | `static final int` | 8 | |

Getters/setters: `getHead/setHead`, `getCmd/setCmd`, `getBodyLength` (`:88-110`). `cmd2Str(int)` (`:20-82`) covers 0x22–0x3C and 0xAA (note: not 0x3F). `toString()` prints every field in hex plus `Arrays.toString(body)` (`:113-115`) — this is what appears in the `TAG_SerialManager` / `TAG_AsyncPacketReader` logs.

Body construction: every `XxxMessage.encodeBody()` does `ByteBuf.allocate(1024)`, `put(...)` fields, then `getArray()` (e.g. `message/VolumeMessage.java:25-29`, `message/InitMessage.java:29-33`). `ByteBuf.getArray()` flips, copies exactly the written bytes, then compacts (`Util/ByteBuf.java:35-41`). `ByteBuf.putShort/putInt/putLong` are little-endian (`ByteBuf.java:19`), so multi-byte body fields go out LE, while the frame header fields are hand-packed BE by the encoder. Decoding of bodies in messages likewise uses `ByteBuffer.wrap(bArr).order(LITTLE_ENDIAN)` (e.g. `message/VersionMessage.java:23`, `message/FetchSmsMessage.java:34`).

## 5. `Const.java` — complete constant tables

### `Const.Command` (`protocol/Const.java:32-62`)

Direction legend: A→M = app sends it (a `Message` class builds it); M→A = MCU sends it (a handler consumes a meaningful reply / unsolicited push). "Echo" = MCU answers with the same cmd byte and `sr` result; only handlers that do something with the reply are listed as M→A-meaningful.

| Hex | Dec | Constant | Direction | Message class → Handler | Meaning (from code) |
|---|---|---|---|---|---|
| 0x22 | 34 | `SET_DIGITAL_INFO_CMD` | A→M, echo used | `DigitalMessage` → `DigitalMessageHandler` → `CmdStateMachine.getCmdResultFromModule` (`handler/DigitalMessageHandler.java:19-22`) | Program active DMR channel; `sr` drives retry logic (§7) |
| 0x23 | 35 | `SET_ANALOG_INFO_CMD` | A→M, echo used | `AnalogMessage` → `AnalogMessageHandler` → state machine (`handler/AnalogMessageHandler.java:19-22`) | Program active analog channel |
| 0x24 | 36 | `QUERY_DIGITAL_INFO_CMD` | A→M (unused) | registered to `DigitalMessageHandler` (`serial/MessageDispatcher.java:47`); `DigitalMessage(byte)` accepts it (`message/DigitalMessage.java:35`) but no caller passes it | Query current digital channel (inferred) |
| 0x25 | 37 | `QUERY_ANALOG_INFO_CMD` | A→M (unused) | registered to `AnalogMessageHandler` (`:48`); no sender | Query current analog channel (inferred) |
| 0x26 | 38 | `SET_LAUNCH_INFO_CMD` | A→M | `LaunchMessage`, `talkbak/SendTalkbak` → `LaunchMessageHandler` (no-op, `handler/LaunchMessageHandler.java:8-9`) | PTT / transmit control |
| 0x27 | 39 | `QUERY_INIT_STATUS_CMD` | A→M, echo used | `QueryInitMessage` → `QueryInitMessageHandler` → state machine; `sr==0` → `MSG_INITIALIZED_FEEDBACK_FROM_MODEL` (`state/CmdStateMachine.java:128-131`) | Ask whether module finished init |
| 0x28 | 40 | `SET_ENHANCE_FUNCTION_CMD` | both (M→A can be unsolicited) | `EnhanceMessage` → `EnhanceMessageHandler`; `fun==4` stores "killed", `fun==5` clears it, then `dealEvent` (`handler/EnhanceMessageHandler.java:21-29`) | Remote functions (radio check / call alert / monitor / kill / revive) |
| 0x29 | 41 | `SET_ENCRYPT_FUNCTION_CMD` | A→M | `EncryptMessage` → `EncryptMessageHandler` (no-op) | Encryption on/off |
| 0x2A | 42 | `SET_GAIN_MIC_CMD` | A→M, echo used | `MicMessage` → `MicMessageHandler` → state machine `MSG 8` (`CmdStateMachine.java:171-175`) | Mic gain |
| 0x2B | 43 | `QUERY_DIGITAL_AUDIO_RECEIVE_INFO` | A→M | `DigitalAudioMessage` → `DigitalAudioMessageHandler` (no-op in OEM) | Query last received digital call info |
| 0x2C | 44 | `SEND_SMS_CMD` | A→M | `SendSmsMessage` → `SendSmsMessageHandler` (no-op) | Send DMR text message |
| 0x2D | 45 | `RECEIVE_SMS_CMD` | A→M query, M→A payload | `FetchSmsMessage` (sends `fetch=1`; reply decodes `type, callID(int LE), UTF-16LE text`, `message/FetchSmsMessage.java:33-57`) → `FetchSmsMessageHandler` → `DmrManager.onSmsReceived` | Fetch pending received SMS |
| 0x2E | 46 | `SET_VOL_CMD` | A→M | `VolumeMessage` → `VolumeMessageHandler` (no-op) | Volume (1 byte) |
| 0x2F | 47 | `SET_LISTEN_CMD` | A→M | `MonitorMessage` → `MonitorMessageHandler` (no-op) | Monitor / listen mode |
| 0x30 | 48 | `SET_SQUELCH_CMD` | A→M | `SquelchMessage` (uses literal `48`, `message/SquelchMessage.java:14`) → `SquelchMessageHandler` (registered with literal `48`, `MessageDispatcher.java:58`) | Squelch level (1 byte) |
| 0x31 | 49 | `SET_POWER_SAVE_MODE_CMD` | A→M | `PowerSaveMessage` → `PowerSaveMessageHandler` (no-op) | Power save |
| 0x32 | 50 | `QUERY_SIGNAL_STRENGTH_CMD` | A→M, M→A payload | `SignalMessage` (reply decodes 1 byte `rssi`, `message/SignalMessage.java:25`) → `SignalMessageHandler` (no-op in OEM) | RSSI query |
| 0x33 | 51 | `SET_OFFLINE_MODE_CMD` | A→M | `RelayMessage` → `RelayMessageHandler` (no-op) | Relay / offline (direct) mode |
| 0x34 | 52 | `QUERY_VERSION_CMD` | A→M, M→A payload | `VersionMessage` (reply decodes `int` LE, `message/VersionMessage.java:23`) → `VersionMessageHandler` → `DmrManager.onVersionReceived` + state machine `MSG 4` | Firmware version |
| 0x35 | 53 | `INTERRUPT_TRANSMIT_CMD` | A→M, echo used | `InterruptMessage` (decodes 1 byte) → `InterruptMessageHandler` → state machine `MSG 7` | Transmit-interrupt policy |
| 0x36 | 54 | `MODULE_PRINT_STATUS_INFO_CMD` | **M→A unsolicited**, A→M ack | `ModuleStatusMessage` (decodes 1 byte `status`) → `ModuleStatusMessageHandler`: sends ack `body={1}` then `DmrManager.onModuleStatusReceived(status)` (`handler/ModuleStatusMessageHandler.java:19-31`) | Module status push (see `ModuleStatus` table) |
| 0x37 | 55 | `SET_POLITE_POLICY_CMD` | A→M | `PolicyMessage` → `PolicyMessageHandler` (no-op) | Polite/impolite TX policy |
| 0x38 | 56 | `SET_MIX_CHECK_INFO_CMD` | A→M | `MixCheckMessage` → `MixCheckMessageHandler` (no-op) | Mixed digital/analog scan config |
| 0x39 | 57 | `QUERY_MIX_CHECK_INFO_CMD` | none | constant only; not registered, no message class | — |
| 0x3A | 58 | `SET_SMS_PROTOCOL_TYPE_CMD` | A→M | `SmsProtocolMessage` → `SmsProtocolMessageHandler` (no-op) | SMS protocol variant |
| 0x3B | 59 | `SET_TOTO_CMD` | A→M, echo used | `TotMessage` (literal `59`) → `TotMessageHandler` (registered with literal `59`, `MessageDispatcher.java:69`) → state machine `MSG 9` | Time-out timer |
| 0x3C | 60 | `SET_SPK_EN_CMD` | none | constant + `cmd2Str` only; not registered, no message class | Speaker enable (name only) |
| 0x3F | 63 | `TEST_BIT_ERROR_RATE` | both (raw) | `TestBiteErrorRateMessage` (literal `63`) → `TestBiteErrorRateMessageHandler` → `dealEvent(0x3F)`; reader returns raw buffer as body while BER mode is on | BER test mode |
| 0xAA | -86 | `MODULE_INIT_CMD` | A→M, M→A | `InitMessage` (body `{1}`) → `InitMessageHandler` → state machine `MSG 2`; also the `BF AA …` 17-byte banner is mapped here | Module init handshake |

### `Const.ModuleStatus` (`Const.java:71-85`) and `Const.CallBackCode` (`:15-29`) — body byte of cmd 0x36

| Value | `ModuleStatus` name | `CallBackCode` alias | `DmrManager.onModuleStatusReceived` action (`manager/DmrManager.java:392-411`) |
|---|---|---|---|
| 1 | `RECEIVE_START` | `RECEIVE_START` | `onReceiveStart()` |
| 2 | `RECEIVE_STOP` | `RECEIVE_FINISH` | `onReceiveStop()` |
| 3 | `SEND_START` | `SEND_START` | `onSendStart()` |
| 4 | `SEND_STOP` | `SEND_FINISH` | `onSendStop()` |
| 5 | `SMS_RECEIVED` | `RECEIVE_MSG` | `onNewSmsNotify()` |
| 6 | `RELAY_ACTIVITY_TIME_OUT` | `RELAY_TIMEOUT` | `onSendTimeout()` |
| 7 | `CHANNEL_BUSY` | `CHANNEL_BUSY` | `onChannelBusy()` |
| 8 | `SMS_SENT_SUCCESS` | `SEND_MSG_SUCCESS` | `onSmsSendSuccess()` |
| 9 | `SMS_SENT_FAIL` | `SEND_MSG_FAIL` | `onSmsSendFail()` |
| 10 | `MIX_CHECK_DIGITAL_RECEIVE_START` | `DA_CHECK_DIGITAL_START` | not handled |
| 11 | `MIX_CHECK_DIGITAL_RECEIVE_STOP` | `DA_CHECK_DIGITAL_FINISH` | not handled |
| 12 | `MIX_CHECK_ANALOG_RECEIVE_START` | `DA_CHECK_ANALOG_START` | not handled |
| 13 | `MIX_CHECK_ANALOG_RECEIVE_STOP` | `DA_CHECK_ANALOG_FINISH` | not handled |

`moduleStatus2Str()` (`:101-132`) maps the same values to names for logging.

### `Const.RWMode` (`:88-91`) and `Const.SRFlag` (`:94-99`)

| Group | Constant | Value | Meaning |
|---|---|---|---|
| RWMode | `READ_MODE` | 0 | replies from MCU are checked for `rw == 0` in `activity/FragmentLocalSettingsActivity.java:386` (inferred: MCU replies carry rw=0) |
| RWMode | `WRITE_MODE` | 1 | app always sends 1 |
| SRFlag | `RESULT_SUCCESS` | 0 | reply OK |
| SRFlag | `RESULT_FAIL` | 1 | reply failed |
| SRFlag | `RESULT_CK_SUM_ERROR` | 2 | MCU rejected checksum |
| SRFlag | `SET` | 1 | app request marker (same value as `RESULT_FAIL`; `sRFlag2Str` prints "SET or RESULT_FAIL", `:134-136`) |

Annotations `@AnalogCmdType` / `@DigitalCmdType` (`:9-12, 64-67`) are empty marker annotations used on the `AnalogMessage(byte)` / `DigitalMessage(byte)` constructors. **No timeouts or error-code constants live in `Const.java`**; the only timeouts are the 1000 ms values hard-coded in `CmdStateMachine` (§7).

Firmware side: `radio_firmware/cmd_handler.c` lines 1–368 (covering the requested 1–220) contain only Ghidra "unable to decompile"/"unreachable block" warnings and one truncated stub; no command IDs, sync bytes, or checksum code are recoverable from that header, so no firmware-side cross-check of the table was possible from the requested range.

## 6. `MessageDispatcher` routing (`serial/MessageDispatcher.java`)

- Registration is static, in the constructor: 27 `register(byte, MessageHandler)` calls (`:44-70`) into a plain `HashMap<Byte, MessageHandler>` (`:41`). Three use bare literals instead of constants: `(byte) 48` → `SquelchMessageHandler`, `(byte) 59` → `TotMessageHandler`, `(byte) 63` → `TestBiteErrorRateMessageHandler` (`:58, 69, 70`). `0x24`/`0x25` share handler instances with `0x22`/`0x23` (new instances each, but same classes). `0x39` and `0x3C` are not registered.
- `register()` is `public` (`:73-75`) — later registrations overwrite earlier ones for the same byte.
- Routing: `onReceive(Packet, SerialPort)` looks up `handlers.get(packet.getCmd())`, logs `onReceive: handler <obj>` under `TAG_MessageDispatcher`, and if non-null submits `messageHandler.handle(packet)` to the dispatch executor (`:78-88`). Matching is **only** on the command byte; `rw`, `sr`, `head`, `ckSum` are not consulted.
- Unknown command: silently dropped (only the log line with `handler null`).
- Threads: `onReceive` itself runs on the reader thread; `handle()` runs on `serial-port-dispatch-t1/2`.
- Generic handler flow (`handler/BaseMessageHandler.java:11-18`): `decode(packet)` constructs the typed message around the same `Packet`, `message.decode()` runs `decodeBody(body)` only if body non-empty (`message/BaseMessage.java:25-32`), then `handle(T)`.
- After the handler, app-level fan-out is `DmrManager.dealEvent(byte cmd, BaseMessage)` → `MessageListener.dealEvent` for every listener registered for that cmd (`manager/DmrManager.java:840-855`, registration `:830-838`, interface `:91-96`). Listeners are UI components (e.g. `InterPhoneHomeActivity.java:175-176`).
- The `SerialPort` parameter of `onReceive` is passed but unused by the dispatcher.

## 7. Outbound path

1. Caller sets fields on a `XxxMessage` and calls `send()` (`message/BaseMessage.java:34-38`; identical in `talkbak/BaseTalkbak.java:34-38`).
2. `encode()` forces `rw=1`, `sr=1`, `body = encodeBody()` (`BaseMessage.java:17-23`).
3. `SerialManager.getInstance().send(packet)` logs `packet = <toString>` under `TAG_SerialManager`, and if `serial.isConnected()` calls `writer.write(packet)` (`serial/SerialManager.java:95-100`). If not connected the packet is dropped silently (only the log line). If `serial` is `null` (after `release()` a fresh instance has no port until `init()`), this NPEs.
4. `AsyncPacketWriter.write` enqueues `WriteTask` (`codec/AsyncPacketWriter.java:20-22`, queue cap 100).
5. `WriteTask.run()` on `serial-port-write-t1`: `PacketEncoder.encode(packet, buffer)`, re-check `isConnected()`, log `write buffer == <hex>` (under **`TAG_AsyncPacketReader`**, `:42`), `serial.getOutputStream().write(array)` (`:36-47`).
6. The response (if any) comes back as an independent inbound frame with the same `cmd` and is routed by §6.

Ack / retry / timeout semantics:
- **Transport layer: none.** No sequence numbers, no pending-request table, no timeouts in `SerialManager`/`AsyncPacketWriter`.
- **Application layer (`state/CmdStateMachine.java`)** — only for channel programming and a few dependent commands:
  - `MSG_SET_CHANNEL (10)`: send set-channel, then `sendMessageDelayed(12, 1000)` (`:319-322`).
  - `MSG_SET_CHANNEL_AGAIN_FOR_NO_REPLY (12)`: no reply within 1 s → resend once, then arm `MSG_SET_CHANNEL_ERROR (13)` after another 1 s (`:328-343`).
  - Reply with `sr != 0` → one retry (`MSG 11`), a second failure → `MSG 13` (`:136-165`).
  - Success (`sr == 0`) for 0x22/0x23 cancels 12/13 and chains `INTERRUPT_TRANSMIT_CMD` / `SET_GAIN_MIC_CMD`, each again guarded by a 1 s `MSG 13` (`:288-307`).
  - `MSG 13` → `DmrManager.errorEvent(cmd)` → listeners' `errorEvent(Byte)` (`DmrManager.java:857-872`).
  - A 0xAA reply becomes `MSG 2` unconditionally (`:126-127`); replies for 0x27/0x34/0x2A/0x35/0x3B are turned into state-machine messages only when `sr == 0` (`:128-179`); all other cmds map to `MSG_NOTHING_DO`.
- The single hand-written ack in the app is the 0x36 status acknowledgement (§5), sent from the dispatch thread via `SerialManager.send`.

## 8. Logging

`Clog` (`Util/Clog.java`) is a thin wrapper: every level logs under the single tag **`fzc`** with message `"<callerTag>,<msg>"` (`:6-38`). Used by activities/fragments and `EnhanceMessageHandler`, not by the transport classes, which use `android.util.Log` directly.

| Tag | Where | What you see |
|---|---|---|
| `TAG_SerialManager` | `SerialManager.java:10` | `init()/release*()` with instance id; `packet = Packet{…}` for every TX |
| `SerialPort` | `SerialPort.java:9` | `/dev/ttyS0 open start/end,success=…`, `fd == null 打开失败` |
| `TAG_AsyncPacketReader` | `AsyncPacketReader.java:21` | `start read`, `readCount == N`, `read bytes == <2048 hex chars>`, `decode:…`, `read packet ==Packet{…}`, `run error---` on thread death; **also `write buffer == <hex>` for TX** (`AsyncPacketWriter.java:42`) |
| `TAG_MessageDispatcher` | `MessageDispatcher.java:39` | `onReceive: handler <HandlerClass@hash>` (or `null`) |
| `zyingyong` | `ExecutorManager.java:76` | `a task was rejected r=%s…` when a queue is full (also dead `Serial.java`) |
| `caoshaowei` | `handler/BaseTalkbakHandler.java:14` | `handle packet == …` for talkback packets |
| `fzc` | `Clog` | UI-side / `EnhanceMessageHandler` traces |
| `TAG_ModuleStatusMessageHandler`, `TAG_InitMessageHandler`, `TAG_FetchSmsMessage`, `TestBiteErrorRateMessageHandler`, `CmdStateMachine` etc. | per class | handler-level traces incl. `sr=` strings via `Const.sRFlag2Str` |
| `ExecShell` / `System.out` | `shellexec/ExecShell.java` | unused in OEM code |

Useful filter: `adb logcat -s TAG_SerialManager TAG_AsyncPacketReader TAG_MessageDispatcher SerialPort zyingyong fzc`. TX hex appears as `write buffer == 682E01018EBF00010810`; RX raw bytes appear as `read bytes == …` (uppercase hex, `Util/Util.java:23-30`) followed by the parsed `Packet{…}`.

## 9. How to add / intercept a command (hook targets)

All classes are in `com.pri.prizeinterphone.*`; the existing mod already hooks two of these (`DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java:11588-11626`).

| Goal | Hook target | Args / return | Thread | Notes |
|---|---|---|---|---|
| See/modify/drop every TX packet (typed fields already encoded) | `serial.SerialManager#send(protocol.Packet)` | `args[0]` = `Packet` with `cmd, rw, sr, body` populated | caller's thread (UI/dispatch/state-machine) | `param.setResult(null)` drops it; mutate `body` in `beforeHookedMethod`. Is *not* reached when `serial` is disconnected. |
| Modify typed fields before encoding (e.g. `AnalogMessage.sq`) | `message.XxxMessage#send()` or `message.BaseMessage#encode()` | `thisObject` = message; fields public | caller's | `encode()` is where `body` is produced; hooking `encodeBody()` (protected, returns `byte[]`) lets you rewrite the body bytes only. |
| Lowest-level TX bytes | `codec.PacketEncoder#encode(Packet, Util.ByteBuf)` (static) or `codec.AsyncPacketWriter$WriteTask#run()` | `ByteBuf` receives the frame | `serial-port-write-t1` | after `encode`, `buffer.getArray()` gives the exact wire bytes. |
| See/modify/drop every RX packet before routing | `serial.MessageDispatcher#onReceive(Packet, serial.port.SerialPort)` | `args[0]` = decoded `Packet` (`ckSum`, `len` filled, tail stripped) | `serial-port-read-tN` | `setResult(null)` drops; changing `packet.cmd` re-routes to another handler. |
| Replace/synthesise the parser output | `codec.AsyncPacketReader#decode(java.nio.ByteBuffer)` (public) | returns `Packet` or `null` | reader | `afterHookedMethod` can return a different `Packet`; be careful with buffer position. |
| Handle a **new** command byte | `serial.MessageDispatcher#register(byte, handler.MessageHandler)` on the live instance, or `afterHookedMethod` of the `MessageDispatcher` constructor | instance via `XposedHelpers.getObjectField(SerialManager.getInstance(), "receiver")` (field name `receiver`, `SerialManager.java:13`) | — | `MessageHandler` is a 1-method interface (`handler/MessageHandler.java:6`); implement with `java.lang.reflect.Proxy`. Overwrites any existing entry for that byte. |
| Per-command typed RX | `handler.XxxMessageHandler#handle(XxxMessage)` or `handler.BaseMessageHandler#handle(Packet)` | typed message / packet | dispatch pool | Runs concurrently (2 threads). |
| App-level fan-out | `manager.DmrManager#dealEvent(byte, message.BaseMessage)` / `#registerEventListener(byte, DmrManager$MessageListener)` | cmd byte + typed message | dispatch / state-machine | Only cmds that handlers forward reach here (0x22/0x23 via state machine, 0x28, 0x3F, plus SMS/version via dedicated callbacks). |
| Send a raw frame | build `new protocol.Packet((byte) cmd)`, set `rw`, `sr`, **non-null** `body`, then `SerialManager.getInstance().send(packet)` | — | any | `body == null` NPEs inside `ByteBuf.put(byte[])` (`ByteBuf.java:88-92`). Reference implementation: `MainHook.java:11927-11949`. |
| Raw stream access (bypass framing) | `serial.SerialManager#getSerial()` → `serial.port.SerialPort#getInputStream()/getOutputStream()` (fields `fis`, `fos`) | — | — | Reading concurrently with the reader thread will steal bytes. |

Field names for reflection: `SerialManager.{serial, reader, writer, receiver}`, `AsyncPacketReader.{serial, receiver, buffer, thread, isStop}`, `AsyncPacketWriter.{serial, executor}`, `MessageDispatcher.{handlers, executor}`, `SerialPort.{mFd, fis, fos, success}`, `Packet.{head, cmd, rw, sr, ckSum, len, body}`.

## 10. Gotchas / surprising behaviour

1. **Reader thread dies on partial frames.** `decode()` can throw `BufferUnderflowException` (≥8 bytes present but body/tail incomplete, or exactly 8 bytes of a zero-body frame); `run()` catches, logs `run error---`, and exits (`AsyncPacketReader.java:72-74`). `isStop` stays `false`, so `SerialManager.init()` will not restart it (`SerialManager.java:47-49`).
2. **No resync scan.** A leading garbage byte other than `0x00` wedges parsing until a ≤2-byte read clears the buffer (`AsyncPacketReader.java:64-65, 174`). Reads of 1–2 bytes are themselves discarded (`:105-112`).
3. **Inbound checksum never validated**; tail byte never checked (`AsyncPacketReader.java:163-169`).
4. **Dead `0xF0` header skip**: `b == 240` can never be true for a `byte` (`AsyncPacketReader.java:138`).
5. **`releaseWriter()` nulls `reader`, not `writer`** (`SerialManager.java:88-93`).
6. **`SerialManager.send` NPE** if called after `release()` and before `init()` (`serial` is null, `:97`); and packets are silently dropped when the port is closed.
7. **Mixed endianness**: frame header BE (hand-packed), all `ByteBuf` body fields LE (`ByteBuf.java:19`), decode uses explicit LE `ByteBuffer`s.
8. **Two dispatch threads** → handlers may run concurrently and out of order; `handlers` `HashMap` is unsynchronised (fine for read-only after construction, unsafe if `register` is called at runtime).
9. **Queue overflow drops packets silently** (100 TX / 100 RX tasks; `RejectedHandler` only logs under `zyingyong`).
10. **`sr` ambiguity**: `SET == RESULT_FAIL == 1`; `sRFlag2Str` prints `"SET or RESULT_FAIL"` (`Const.java:94-99, 134-136`).
11. **Literal command bytes** `48`, `59`, `63` are used instead of constants in the dispatcher and in `SquelchMessage`/`TotMessage`/`TestBiteErrorRateMessage`; `cmd2Str` lacks 0x3F.
12. **BER mode swallows everything**: while `isTestBitErrorRate()` is true, every read becomes a raw `0x3F` packet, so no normal replies are parsed (`AsyncPacketReader.java:119-126`).
13. **`BF AA` banner**: a 17-byte non-`0x68` frame is accepted and mapped to `MODULE_INIT_CMD` (`AsyncPacketReader.java:144-152`); its content is discarded.
14. **Very chatty logging**: 2 KB hex dump per read at `Log.i`; TX hex is logged under the *reader* tag.
15. **Firmware update shares the port** without a lock: `YModemThread` reads the same `FileInputStream` after `releaseReader()`; `SerialManager.getSerial()` re-opens the port on every call (`SerialManager.java:54-60`).
16. **Dead code**: `serial/Serial.java`, `serialport/Device.java`, `shellexec/ExecShell.java`, `ExecutorManager.getTimerThread()/shutdown()/isMPThread()` have no callers.
17. The existing mod references a non-existent class `com.pri.prizeinterphone.manager.SerialManager` at `MainHook.java:3849` (correct package is `serial`); that recovery step therefore always falls into its catch.

## ⚠️ Doc drift (vs `.grok/rules/copilot-instructions.md` "Serial Protocol Reference", lines 1461–1474)

- **0x33 name**: the doc calls it `SET_RELAY_CMD`; the code constant is `SET_OFFLINE_MODE_CMD` (`protocol/Const.java:53`, `Packet.cmd2Str` `:59-60`). The message class is `RelayMessage`, so the concept matches but the constant name does not.
- **"Full table in `.docs/AI_LOGS_SUMMARY.md` §7"**: that file does not exist in the repo (`.docs/` is absent; no `AI_LOGS_SUMMARY.md` anywhere). The complete table is now §5 of this chapter.
- **"exact hex not all pinned"**: all are pinned in code — `SET_ENHANCE_FUNCTION_CMD 0x28`, `SEND_SMS 0x2C`, `RECEIVE_SMS 0x2D`, `QUERY_DIGITAL_AUDIO_RECEIVE_INFO 0x2B`, `SET_LISTEN 0x2F`, `SET_ENCRYPT_FUNCTION 0x29`, `SET_POLITE_POLICY 0x37`, `INTERRUPT_TRANSMIT 0x35`, TOT `0x3B`, BER `0x3F` (`Const.java:33-61`).
- **"0x22–0x3C range"**: the constant space actually extends to `0x3F` (`TEST_BIT_ERROR_RATE`) plus `0xAA` (`MODULE_INIT_CMD`); `0x3D`/`0x3E` are undefined.
- **"returns `rssi` byte in dBm"**: the code only reads one raw byte into `SignalMessage.rssi` (`message/SignalMessage.java:25`); the unit is not established anywhere in the OEM source (unverified).
- The doc's statement that no LED-control command exists in the range is consistent with `Const.Command` (no such constant).
