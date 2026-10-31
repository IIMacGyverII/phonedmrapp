# Armor 3WT: the intercom app and `extmodule`, read against SignalDeck's Atom XL path

**2026-10-30, Armor 3WT agent.** Plan: `plan-support.md`. This is a reading only: there is no 3WT here, nothing was run.

**Inputs.**
- **Intercom app:** the tester's `com.agold.intercom` APK (the copy in the device report and the copy in the owner's
  Magisk module v2.2.2), decompiled with jadx 1.5.6 into a scratch folder outside the repos. **The two copies decompile to
  the same code and the same strings** (only the signatures differ), so everything below holds for both. Class names are
  `com.agold.intercom.*`; `EMM` = `module.ExtModuleManager`, `EMP` = `module.ExtModuleProtocol`, `IU` = `utils.IComUtils`.
- **`extmodule`:** the aarch64 daemon from the Magisk module, disassembled with the NDK's `llvm-objdump` (addresses below
  are its virtual addresses). Strings and the control-command switch were read; its audio and serial threads were read
  only as far as the items below need.
- **The tester's report (beta.19):** device facts and the stock app's own log lines only. No ID, call number or
  frequency from it is quoted here.
- **SignalDeck:** `origin/main` at `511c0d7e`: the Atom XL path (`AgoldEnvelope`, `AgoldFrames`, `AgoldUsb`,
  `RadioEngine`'s `agold` branches, `AlsaDirectAudio`).

**Markers.** **R** = read in the code (or seen in the tester's log, marked "log"). **I** = inferred.

## Summary

The 3WT's radio is the Atom XL's hardware family with an older module and one more layer on top:

- **Same bridge, same driver.** `extmodule` opens `/dev/ttyACM0`, `/dev/stmcu`, ALSA card 1 (`pcmC1D0c`/`pcmC1D0p`) and
  the bridge driver's sysfs files `mcu_power`, `rstmcu`, `handle_ptt`, `usb_path` under `/sys/bus/platform/drivers/mcu/`
  (R, strings at `0x906e`, `0x9295`, `0x8903`, `0x892b`, `0x91d0`, `0x9517`). Those are exactly the nodes SignalDeck's
  Atom XL path drives itself (`AgoldUsb`).
- **The app never touches them.** It talks to `extmodule` over two TCP sockets on 127.0.0.1 (9980 commands, 9985
  audio), each message behind a 12-byte header. The daemon does power, reset, PTT, the audio codec and the PCM.
- **The module speaks the older "legacy" command set** (`ver0.5.4_470M_TONE`), not the Armor/DMR09 set the Atom XL uses:
  other command numbers, other body layouts, and **no time slot**. Its receive start and end come as a module command
  (`0x04`) on the port, not from `/dev/stmcu` as on the Atom XL's V067 module.

| # | What | 3WT intercom app + `extmodule` | SignalDeck's Atom XL path | R/I |
|---|---|---|---|---|
| A1 | Who owns the hardware | `extmodule` (root daemon from `service.sh`) | SignalDeck itself, with root | R |
| A2 | Command transport | TCP 127.0.0.1:9980, 12-byte header, type 1 = MCU bytes, type 0 = daemon control | `/dev/ttyACM0` as a file | R |
| A3 | Power-up | daemon control 2 (stop), 4 s, 7 (MCU start), bridge report `0x06`, 1 (start) | `mcu_power` 1 by SignalDeck, port opened after it | R (log) |
| A4 | Envelope | `7E 96 69 \| route \| cmd \| rw \| len BE \| body \| sum BE \| 81` | the same (`AgoldEnvelope`) | R |
| A5 | Command set | legacy: `0x02` volume, `0x04` RX state, `0x07` text, `0x10` call info, `0x11` text fetch, `0x25` version, `0x35` analog, `0x36` digital | DMR09: `0x22`, `0x23`, `0x2B`–`0x2E`, `0x32`, `0x34`, `0x36` status | R |
| A6 | Digital channel | 156 bytes, IDs big-endian, **no slot** | 163 bytes (Armor layout, slots) | R |
| A7 | Analog channel | 15 bytes: band, power, rx, tx, sq, tones (type 1–4 + index) | 19 bytes (Armor layout, type 0–3) | R |
| A8 | Receive start/end | module command `0x04`, body 0/2 = start, 1/3 = end | `/dev/stmcu` edges + RSSI watchdog | R |
| A9 | Receive audio | socket 9985, 48 kHz stereo (32 kHz with `ro.agold.extmodule.32k`), 10 ms frames, opened per reception (audio control 3/4) | ALSA card 1 at 32 kHz through `sdalsa`, per reception | R |
| A10 | Transmit | daemon control 3 (PTT) + audio control 1; release: control 4 + audio control 2 | `handle_ptt` 0/1 + a property | R |
| A11 | Text body | `0x07`: type, call number (3 bytes BE), UTF-16LE, 4 zero bytes; type 2 private, 9 group | `0x2C`: type, LE32, UTF-16LE, 4 zero bytes | R |
| A12 | Signal reading | **no RSSI command in the app** | `0x32` | R |
| A13 | Frequencies | 100–470 MHz accepted by the app | 400–480 MHz (module) | R |
| A14 | Side key | scancode `0xf9` on `mtk-kpd`; `service.sh` turns it into a broadcast for the stock app only | none needed (the Atom XL's stock key) | R |

## 1. Lifecycle

**Start** (R, `IComService.onCreate` → `EMM.start`, `EMM.createCmdSocketListenThread`, `handleCmdRequest`,
`handleMcuStartFinished`; confirmed by the tester's log):

1. The service creates the manager and starts six threads: command in/out, audio in/out and two socket "listeners"
   that connect to 127.0.0.1:9980 and :9985 and reconnect every second while a socket is missing.
2. One second after the command socket connects, the app calls `resetMcu`: daemon control **2** (stop), then **4 s**
   later control **7** (MCU start). The log shows 4.0 s between them.
3. The bridge answers on route 00 with command **`0x06`** (MCU started), 1.4 s after control 7 in the log. The app then
   sends control **1** (start) and starts a 30 s start-up timeout.
4. **3 s** later it asks the bridge for its firmware build date (route 00, command `0x01`, retried at 1 s and 2 s): the
   log's answer is `20181221151755`. If the build date differs from the newest file in its MCU folder it starts an MCU
   update; otherwise it asks the module for its version (`0x25`).
5. On the version reply it writes the current channel (`setCurrChannel`). If no version reply comes within 3 s it does
   the same (`handleGetDmrTimeout`), unless a module update file is present.

**Stop** (R, `EMM.stop`, `exit`): `stopCom` (stops playback and recording, then daemon control 2), 300 ms later the
sockets are closed and the service stops. Nothing powers the MCU off except the daemon's own handling of control 2.

**The daemon's controls** (R, `extmodule` switch at `0x71d8`, ten cases):

| Control | Daemon log | What it does |
|---|---|---|
| 1 | `cmd start` | marks the command path started |
| 2 | `cmd stop` | clears it and calls the MCU stop routine (`0x4728`: power off, property `agold.extmodule.open` 0) |
| 3 | `cmd ptt start` | `start_ptt` (`0x4818`): the `handle_ptt` file and a control frame to the bridge |
| 4 | `cmd ptt stop` | `stop_ptt` (`0x4910`) |
| 5 / 6 | `cmd usb start/stop` | `usb_path` 1 / 0 (the app has the code but never sends them) |
| 7 | `cmd mcu start` | `start_mcu` (`0x4220`): property `agold.extmodule.open` 1, power and reset through sysfs, opens `ttyACM0` and the two PCM devices, codec power on (`echo 1 > /dev/ttyTTCMD`) |
| 8 | `cmd mcu stop` | the MCU stop routine (never sent by the app) |
| 9 | `cmd mcu update` | runs the MCU updater script |
| 10 | `cmd drm update` | the DMR module update thread |

**SignalDeck's Atom XL path** powers the bridge itself (`AgoldUsb.bridgeUp`), opens `ttyACM0` itself and reads
`/dev/stmcu` itself. On the 3WT `extmodule` would do the same things beside it: **two owners of one serial port**.

## 2. The socket protocol

**Header** (R, `EMM.sendFrame`, `findFrameHeader`; daemon log `put_cmd_frame`, `put_audio_frame`): 12 bytes, all
little-endian 32-bit words:

| Offset | Value |
|---|---|
| 0 | magic `0xF12FFE4F` (bytes `4F FE 2F F1`) |
| 4 | type: **0 = control**, **1 = data** |
| 8 | payload length |

- **Command socket (9980).**
  - **Control:** type 0, payload = the control number as a 32-bit LE word (R, `EMM.sendCmd`; the daemon reads it at the
    start of a 0x3C4-byte control struct, `0x7194`–`0x71d8`).
  - **MCU bytes:** type 1, payload = one complete `7E 96 69 … 81` frame (R, `createCmdInThread`; log
    `4FFE2FF1 01000000 0C000000 7E9669…`). The daemon writes the payload to `ttyACM0` (R, `0x7220` → `0x5a88`).
  - **Replies:** the daemon wraps what it reads from `ttyACM0` the same way (type 1; log). The app strips every header,
    joins the payloads and scans them for `7E 96 69` frames (R, `parseFrame`, `handleCmdResponse`), so it does not rely
    on one frame per message.
  - **Who gets replies:** the daemon accepts up to **10** clients per port (R, the accept loop at `0x7908` checks ten
    slots, then logs "Had exceed max connect number!"), but sends what it reads **only to the client that last sent
    something** (R, `g_cmd_socket_active_client` set on each read at `0x70dc`, compared before each write at `0x6cc4`).
    A second program on the port would steal the replies whenever it writes. **The stock app must be stopped while
    SignalDeck uses the daemon**, as on every other phone.
- **Keep-alive and errors:** the app sets `SO_KEEPALIVE` on the command socket; there is no application-level ping. A read
  of 0 or an exception closes the socket and the listener reconnects within a second; every reconnect triggers a new
  `resetMcu` (step 2 above) (R). The daemon logs "socket read timeout, maybe client disconnect" on its side (R, string).
- **Commands are queued:** `sendBytes` puts the frame on a list; the command thread sends one every 10 ms, and only while
  no daemon control is pending (R). Controls go first.

## 3. The legacy command table

Every request is `rw` 01; every reply `rw` 00. The app chooses this set because `ro.agold.extmodule.dmr09` is not set
(R, each `EMP` method). Body layouts (R, `EMP`, `EMM.parseCmd` and its handlers):

| Cmd | Name in the app | Request body | Reply / push body | Used by the app |
|---|---|---|---|---|
| `0x02` | `setReceiverVolume` | 1 byte, volume (default 6) | — (not parsed) | after every channel write |
| `0x04` | (push) | — | 1 byte: **0 or 2 = reception started, 1 or 3 = ended** | yes: `handleRecvSendStateChange(int)` |
| `0x06` | (push) | — | logged only (length) | no |
| `0x07` | `sendMsg` | type, call number 3 bytes **BE**, UTF-16LE text, 4 zero bytes | 1 byte: **`0x70` = a text arrived** (fetch 2 s later) | yes |
| `0x10` | `getCallInfo` | 1 byte, `01` | **never parsed** (the case is missing in `parseCmd`) | sent at each digital reception |
| `0x11` | `getMsgContent` | 1 byte, `01` | sender 3 bytes **BE**, UTF-16LE text | yes |
| `0x25` | `getModuleSoftVersion` | 1 byte, `01` | ASCII, the last byte dropped (`ver0.5.4_470M_TONE` + NUL in the log) | yes |
| `0x35` | `setAnalogGroup` | 15 bytes (§4) | 1 byte, `00` = accepted | yes |
| `0x36` | `setDigitalGroup` | 156 bytes (§4) | 1 byte, `00` = accepted (log: `7E 96 69 01 36 00 00 01 00 …`) | yes |
| `0x01`–`0x03` | — | — | ignored by the app | — |

**Route 00 (the bridge itself)** (R, `parseCmd`): `0x01` build date (ASCII), `0x04` MCU init finished, `0x05` MCU update
finished, `0x06` MCU started, `0x07` error report (byte), `0x08` state report (**2** = PTT stop complete, **3** = "pcm error",
the app resets the MCU), `0x09`/`0x0A` DMR update done/failed. The same set the Atom XL's bridge uses.

**Commands this module never sees from its app:** everything outside the table. In particular there is **no RSSI
query** (`0x32` on the Armor set), no monitor, squelch, microphone gain, interrupt, time-out or power-save command, and
**no module-side key command**: the key is the daemon's PTT line. Whether this module has any of them under other numbers
is unknown (I).

**The Armor numbers collide here.** `0x35` (Armor: interrupt, 1 byte) is the legacy analog channel, and `0x36` (Armor:
status push, and SignalDeck's ack of it) is the legacy digital channel. Sending SignalDeck's usual handshake to this
module unchanged would write channels with one-byte bodies (I: refused at best).

## 4. Channel writes

**Analog, `0x35`, 15 bytes** (R, `EMP.setAnalogGroup`; values from `ui.AddChannelActivity.handleAddDone`):

| Byte | Field | Values |
|---|---|---|
| 0 | band | **0 narrow, 128 wide** |
| 1 | power | 0 low, 1 high |
| 2–5 | rx frequency, Hz, LE | |
| 6–9 | tx frequency, Hz, LE | |
| 10 | squelch | 0–9 (spinner position) |
| 11 | rx tone type | **1 none, 2 CTCSS, 3 DCS normal, 4 DCS inverted** |
| 12 | rx tone | index into the app's list: CTCSS from 62.5 Hz (51 tones), DCS from 023 (83 codes) |
| 13, 14 | tx tone type, tx tone | as 11, 12 |

The DMR09 path of the same app subtracts 1 from the type and sends `FF` as the code when the type is none (R,
`setDmr09AnalogGroup`), so the indexes are the same in both sets and only the type is shifted by one.

**Digital, `0x36`, 156 bytes** (R, `EMP.setDigitalGroup`, `EMM.setChannel(Channel)`):

| Bytes | Field |
|---|---|
| 0 | power (0 low, 1 high) |
| 1–4 | rx frequency, Hz, LE |
| 5–8 | tx frequency, Hz, LE |
| 9–12 | own radio ID, **BE** |
| 13 | colour code |
| 14 | contact type: **1 private, 2 group, 4 all call** |
| 15–18 | call number, **BE** (all call: `0xFFFFFA`) |
| 19 | encryption: **1 on, 255 off** |
| 20–27 | key, ASCII, zero-padded |
| 28–155 | 32 receive groups, **BE** (a group channel with no list sends its call number first, then zeros) |

**No time slot anywhere** (R). The app's channel editor shows its slot and channel-mode spinners only when
`ro.agold.extmodule.dmr09` is set (R, `AddChannelActivity`: `channel_slot_mode_layout` is hidden unless the property is set). So on this phone the
stock app offers DMR **without slot selection**: the module decides the slot (I: most likely it transmits and receives
on one fixed slot, or the module is not TDMA at all; nothing in the app tells which).

**When a channel write is accepted** (R, `setChannelComplete`): the app stores it as current, then sends `0x02` volume
and stops playback. With no reply in **3 s** it resets the MCU (`onSetChannelTimeout`). It refuses to write a channel
while transmitting or before the bridge has started (`setChannel` guards).

## 5. Receive

- **Start and end:** the module's `0x04` push (R). Body 0 or 2 → `startPlay`; 1 or 3 → `stopPlay`. The app shows a
  toast ("calls in too fast") every 10th edge (R, `mCallInStateChangedCount`).
- **`/dev/stmcu`:** read by the daemon, not the app (R, `detect_audio_in_state`, string "call_in status is %d", `0x3f88`).
  Its use there (the `STATE_CALLIN_START/STOP` strings in `do_audio_control`) is to gate the audio stream (I).
- **`startPlay`** (R): on a digital channel it sends `0x10` (call info, never parsed), then 100 ms later audio control **3**
  on the audio socket, opens a recording file and plays what arrives. **`stopPlay`**: audio control **4**, closes the
  file, and fetches a text if one was announced meanwhile (500 ms later).
- **Caller ID:** none. The app has no parser for the legacy `0x10` reply (R), so the stock app never shows who is
  calling on this phone.

## 6. Audio on 9985

- **Format** (R, `EMM` constructor): 48 kHz, stereo, 16-bit, frames of **1920 bytes** (10 ms); with
  `ro.agold.extmodule.32k` set, 32 kHz and **1280-byte** frames. Both directions use the 12-byte header with type 1 and
  the frame length.
- **Receive** (R, `createAudioOutThread`, jadx partial): reads the socket, finds the header, writes each payload to an
  `AudioTrack` (music stream, the same rate, stereo) and to the recording file. A header with another length is
  treated as one frame anyway.
- **Transmit** (R, `createAudioInThread`, jadx partial): an `AudioRecord` (MIC, the same rate, stereo) read in 10 ms
  frames; optional WebRTC noise suppression, AGC and echo cancellation; each frame sent as type 1. Pacing is the
  recorder's own (blocking read), no timer.
- **Audio controls** (type 0 on the audio socket, R, `setAudioState`, `sendAudioCmd`): **1** = transmit audio on, **2** =
  off (sent right after daemon control 3 or 4), **3** = receive stream on, **4** = off.
- **Under the daemon** (R, strings): `pcm_open` on `pcmC1D0p` (out to the radio) and `pcmC1D0c` (in from it) with its own
  tinyalsa, after `echo 1 > /dev/ttyTTCMD` (codec power); "sample is not playable" when the card refuses the format.
  Which rate the daemon opens the card at is not settled here (I: the app's 48 kHz suggests 48 kHz; the Atom XL's bridge
  firmware, two years newer, runs its card at 32 kHz). `service.sh` disables Android's USB audio routing 30 s after boot
  so Android does not claim the card (R).

## 7. Transmit

**Press** (R, `IComService.handlePttStarted` → `EMM.startRecord`): refused while a screen recording runs, in child mode,
while receiving with "busy, no send" on, when the temperature check fails, before the channel write was accepted, and
without an antenna. Then, with the start tone on (property `ro.agold_intercom_tone`, default 0 = off), the tone plays and
**500 ms** later; otherwise at once:
1. the microphone thread starts sending frames;
2. daemon control **3** (PTT start);
3. audio control **1**.

**Release** (R, `EMM.stopRecord`): **500 ms** later (1 s with the end tone):
1. the microphone thread stops;
2. daemon control **4** (PTT stop);
3. audio control **2**.

A channel write is refused until the bridge's state report **2** (PTT stop complete) arrives or 2 s pass (R,
`mIsPTTStopComplete`). The key itself is the daemon's: `start_ptt` drives `handle_ptt` and sends a control frame to the
bridge (R, `0x4818`); the module gets **no key command** over the port. Limits: a UI countdown,
`ro.default.limit_send_time` (default **30 s**) (R).

## 8. Texts

- **Send** (R, `MessageActivity`, `EMP.sendMsg`): `0x07`, type **2** for a private text, **9** for a group text; the call
  number as 3 bytes BE; the text as UTF-16LE (`gbEncoding2Bytes` byte-swaps a UTF-16BE dump); 4 zero bytes.
- **Receive** (R): a `0x07` push with body `0x70` means a text is waiting; the app fetches it with `0x11` 2 s later (or at
  the end of the reception), reads the sender (3 bytes BE) and the UTF-16LE text, and files it under the channel's
  contact type.
- No sent/failed status is read for texts (R): the app never parses a text acknowledgement.

## 9. Frequencies

- The channel editor accepts **100 000 000 – 470 000 000 Hz** (480 MHz with the DMR09 module) (R,
  `handleAddDone`; strings `channel_freq_range`). Both APK copies carry it, so whether the owner or the vendor widened it
  is not visible.
- The module's own range is not measured. The version name says `470M` (I: a 400–470 MHz build). The channel write's
  reply byte (`00`) is the only test the app offers; the device report's trial writes receive-only channels at band
  edges and records it.

## 10. What differs from SignalDeck's Atom XL path, and what SignalDeck does about it

| Item | Decision (SignalDeck PR, branch `armor3wt/support`) | Why |
|---|---|---|
| A1–A3 | **Talk to `extmodule` over 9980/9985** (new transport `ExtModuleLink`), with its start order (2, 4 s, 7, bridge `0x06`, 1) and stop (2). The direct route the Atom XL uses is kept as the fallback, not built. | The daemon keeps running from the owner's Magisk module and owns `ttyACM0`, the PCM devices, the codec power and PTT; opening them beside it would make two owners. The socket route keeps the owner's module unchanged and needs no new sepolicy. |
| A5–A8, A11 | **Protocol `agold-legacy`:** a codec that translates the engine's Armor-numbered frames to the legacy set and back (`0x23`→`0x35`, `0x22`→`0x36`, `0x34`→`0x25`, `0x2E`→`0x02`, `0x2C`→`0x07`, `0x2D`→`0x11`, `0x2B`→`0x10`; `0x04` → status 1/2, `0x07` `0x70` → status 5). **Every other command is not sent at all.** | Reuses `RadioEngine` and the Agold envelope unchanged; nothing with a colliding number can reach this module. |
| A6 | Digital channels **without a slot**: the editor and the channel list hide the time slot on this phone and say "slot: chosen by the module" | The legacy body has none. |
| A9 | **Audio through the daemon socket** (`ExtModuleAudio`): 48 kHz, or 32 kHz when the property is set; receive stream opened per reception (audio control 3/4), as the stock app does | Same as the stock app; no ALSA helper needed. |
| A10, A14 | **Transmit locked** (profile unverified, no `txTestUnverified` without the owner's OK). The key path is built (daemon control 3/4, audio control 1/2) and the side key is offered as the profile's default custom PTT key (`mtk-kpd`, scancode `00f9`), read with root `getevent` | The report shows the key at `getevent` and nothing at the app. |
| A12 | `rssi = false` on this profile: no S-meter, band scope or fox hunt | No RSSI command is known for this module. |
| A13 | Bands **100–174 and 400–470 MHz**; the module's own range is not measured; the trial records the module's answer at the edges | Only the app's range is known. |
| — | `moduleLoader` off; no firmware page actions | Uncertified (PR 161); no module image exists. |

## What the next 3WT device report must bring back

1. **`extmodule` running and listening** on 9980 and 9985 (process, `ss`/`netstat` listing).
2. **The bridge build date** (route 00 `0x01`) and **the module version** (`0x25`), from SignalDeck's own trial over the
   socket, and that the stock app's start order worked for SignalDeck (bridge `0x06` seen).
3. **The commands the stock app never sends**, with this module's answers: whether `0x32` (RSSI), `0x10` (call info) and
   the others answer at all, and what. The trial sends each once, on a receive-only channel, and lists the replies raw.
4. **The receive audio path:** bytes and frames per second on 9985 during a reception, and the frame length (1920 or
   1280), so the rate is known.
5. **The band edges,** receive only: the `0x35` reply at 100, 120, 130, 136, 174, 400, 470 and 480 MHz.
6. **The key:** whether keycode 183 (`PROG_RED`) reaches an app, and the `getevent` line for the side key.
