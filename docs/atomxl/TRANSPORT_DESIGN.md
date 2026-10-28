# Atom XL: how SignalDeck drives the radio (transport design, draft for the owner, 2026-10-28)

Phase D of `docs/handoff-atomxl-compat-2026-10-28.md`. **Design only: no engine code is written until the owner has
read this.** Every fact below was measured on the bench Atom XL (`PHASE_A_FINDINGS.md`, sections cited as §n) or read
from the stock app / HAL (marked *read*). Open questions are listed at the end; each has the test that settles it.

## 1. Decision: SignalDeck owns `/dev/ttyACM0` directly, with the HAL stopped

| Route | For | Against | Verdict |
|---|---|---|---|
| **Direct**: stop `aguiextmodule`, power the bridge ourselves, own `/dev/ttyACM0` and the USB sound card | Proven by hand and inside the report (§7, §8, PR #64): the bridge and the module answer a plain root process; the audio card opens with SignalDeck's own `sdalsa` (16:06 test). `RadioEngine` runs unchanged above a new framing. No binder work. | We take over what the HAL did: power-up order, reset, the USB host switch, the release. All of it is now known from the HAL trace and its code (§8, §9). | **Chosen** |
| HAL over HwBinder from the app | The HAL already does power, PTT, PCM. | Policy: only `system_server` and `system_app` may `find` `hal_aguiextmodule_hwservice` (*read*, the extraction note's `vendor_sepolicy.cil`); an `untrusted_app` would need new hwservice + binder rules and a HIDL client in the app. The HAL hands PCM through 1920-byte callbacks at the app's 48 kHz, plus the 100 ms `detectAudioinState` poll. | Kept as the fallback only |

## 2. Profile

A new built-in `DeviceProfile` `unihertz-atomxl`, revision 1, **`verified = false`, transmit blocked** until the owner
confirms on air (as the W6 was), matched on `Unihertz Atom_XL` plus `ro.agold.extmodule.hal=yes`.

| Field | Value | Source |
|---|---|---|
| `controlPort` | `/dev/ttyACM0`, set 115200 8N1 raw by root after it appears | HAL trace (§8) |
| `protocol` | new value `agold` = the Armor's command set (`mcu68` bodies) inside the `7E 96 69` envelope | §2, §7 |
| `audio` | new `USB_ALSA`: card 1 device 0, 32 kHz, 2 channels, both directions | `/proc/asound/card1/stream0`; capture test 16:06 |
| `stockApp` | `com.agold.intercom` | |
| `pttActions` | `android.intent.action.PTT.down` / `.up` (the Armor's pair; the framework sends them for keycode 289) | §4, the stock app's receivers |
| `pttNode` | `/sys/bus/platform/drivers/mcu/handle_ptt`, **active low** (`0` keys, idle `1`) | HAL `startPtt`/`stopPtt` (*read*) |
| `powerNode` | `/sys/bus/platform/drivers/mcu/mcu_power` (`power on = 1`) | §8 |
| `bringUp` (new: ordered writes **with delays**, `lineSetup` has none) | `usb_path` 1 → `mcu_power` 1 → 750 ms → `rstmcu` 0 → wait for the port (3 s, else the "none" retry) → 2 s | HAL trace (§8) |
| `release` (new) | `mcu_power` 0 → 1 s → `usb_path` 0 → `cmode` 0, 1 s, 1 → `start aguiextmodule` | §1 |
| `sepolicy` | `allow untrusted_app ttyACM_device chr_file { open read write ioctl getattr lock }`, `typeattribute ttyACM_device mlstrustedobject`; sysfs writes go through root as on the Xplore 1 (`sysfs_agold`) | labels (16:05) |
| `bandsHz` | 400–480 MHz until measured (UHF model; the module refuses outside its range) | stock app defaults |
| `smsHeader5` (new) | texts use the 5-byte `0x2C` header (type, ID LE, UTF-16LE, 4 zero bytes); the Armor's firmware needs 9 | `multi-device-atomxl-findings.md` (*read*) |
| `firmwareLoader` | **off**: the vendor copy (V076) is not the module's image (V067); no factory image for this unit | §6 |

`/dev/ttyACM0` is `radio:radio 0660` and is re-created at every enumeration, so bring-up also `chmod 0666`s it as
root after it appears (the Armor's `ttyS0` is fixed at boot; this one is not).

## 3. Framing: an envelope codec under `RadioEngine`

`UartPort` today frames `68 … 10` (`Frame`). For `protocol = agold` it gets an envelope codec (`AgoldEnvelope`) and
`RadioEngine` stays as it is:

- **Out:** `Frame(cmd, body)` → `7E 96 69 01 cmd 01 len(BE) body checksum(BE) 81`, the checksum of `AgoldFrames`
  (the stock app's `IComUtils.checkSum`, verified on every reply seen). The Armor frame's `sr`/`ck` fields are dropped.
- **In, route 01 (module):** reply `rw` 00. The Armor puts the result in the header (`sr`); the envelope puts it in the
  body. Mapping, per command:
  - data replies (`0x34` version, `0x32` RSSI, `0x2B` caller info, `0x2D` text, `0x25`/`0x24` read-back, `0x40`):
    `sr = 0`, body as it is;
  - **`0x36` is a module push, not a set reply** (corrected 2026-10-28 after the managing agent's review of PR #73):
    its status code (`RECEIVE_START`, `SEND_START` …) is the body, which `RadioEngine` reads from `body[0]`; it keeps
    its body with `sr = 0`. Only our own request's reply (`rw` 00) folds a one-byte result into `sr`. **Measured
    2026-10-28 (`PHASE_A_FINDINGS.md` §11): V067 sends no `0x36` (nor `0x26`) during DMR receive at all;** receive
    start/end arrive as **route 02** `0x67 01` / `0x66 01` (`rw` 00), which the codec turns into `0x36`
    `RECEIVE_START` (1) / `RECEIVE_STOP` (2) for the engine; `0x2B` is only a reply to a query;
  - set replies (`0x22`, `0x23`, `0x2E`, `0x30`, `0x31`, …): body `[result]` → `sr = result`, empty body
    (seen: `0x22` → `00`, `0x2E` → `00`);
  - unlisted commands: mapped the same way by shape (a 1-byte `rw` 00 body → `sr`, anything else data), each logged
    once. As built: SignalDeck PR #73 (Grok, branch `grok/agold-envelope`).
- **In, route 00 (bridge):** not the engine's. `0x01` version, `0x04` init finished, `0x06` start finished, `0x07`
  error, `0x08` state report (`03` = "pcm error, reset mcu" in the stock app), `0x09`/`0x0A` update results (*read*,
  `ExtModuleManager.parseCmd`). The transport logs them and, on a state report `03`, runs release + bring-up.
- **Never sent by SignalDeck:** route 00 `0x08` (update mode), `0x10` (module power: on does not come back, §8),
  `0x12`, anything route 02. The firmware loader stays off on this profile.

## 4. Take-over and give-back

**Take over** (from the stock app or from boot):
1. `pm disable-user com.agold.intercom` as on the Armor (never uninstall or clear it).
2. `stop aguiextmodule` (root). It is `class hal`; init does not restart a stopped service.
3. `bringUp` (§2); `chmod 0666 /dev/ttyACM0`; open; 115200 raw.
4. Bridge version (route 00 `0x01`) and module `0x34`, checksums checked. **No bridge answer: stop here**, release,
   restart the HAL, and tell the user to restart the phone before opening the stock app (it reflashes the bridge when
   its version query goes unanswered, §7).
5. The usual engine start (channel write, volume …) and the audio backend.

**Give back and Exit** (the owner's rule, 2026-10-28: both must release the USB port):
1. Audio streams stopped, PTT released (`handle_ptt` 1), port closed.
2. `release` (§2): power off, `usb_path` 0, `cmode` 0/1 (USB to a computer comes back in ~2 s), `start aguiextmodule`.
3. Bring-up once more, the two version queries, release again: **the bridge must answer before the stock app is
   enabled** (the stock app's `updateMcu` hazard). If it does not, the stock app stays disabled and the user is told to
   restart; a restart leaves the phone with a working stock app (the HAL powers it at the stock app's start).
4. `pm enable com.agold.intercom`.

Pass list for both buttons: adb over the USB cable answers within 5 s; `mcu_power` reads 0; the HAL runs; the stock
app opens, logs the bridge version and the module version, and does not update anything.

**Boot:** `BootReceiver` as on the Armor: either take over (only with "Own the radio at boot") or make sure the stock
app is enabled and the HAL running. Nothing at boot powers the radio unless the user asked.

**Crash or kill of SignalDeck while it owns the radio:** the radio stays powered and USB stays in host mode until the
next start or a restart. On its next start SignalDeck finds `mcu_power` = 1 with no HAL and runs release first.

## 5. Audio

- **Receive:** `sdalsa cap -c 1 -d 0 -r 32000 -n 2` (root helper already in the app; opened and read 494 080 bytes in
  3.9 s on the bench, no mixer controls needed on a USB card). A new `UsbAlsaAudio` backend decimates 32 kHz → 8 kHz
  (4:1 after a low-pass at ~3.4 kHz) into the 8 kHz stereo frames `AudioBackend.Sink` expects. The stock app plays
  at 48 kHz because that is its `AudioTrack`; the wire rate is 32 kHz.
- **Transmit:** `sdalsa play -c 1 -d 0 -r 32000 -n 2`, 8 kHz → 32 kHz interpolation.
- **Receive detection:** the stock app does not use the module's `0x26` status pushes at all (its parser has no case
  for them); it polls `detectAudioinState` every 100 ms and starts playback on 1. `call_in` (sysfs, read only) reads 1
  while idle with the radio on. Whether that is the same line, and whether the bridge forwards `0x26`, is open
  question 2. **Answered 2026-10-28 (§11 of the findings): `call_in` is that line, active low (1 idle, 0 during a
  call); the module sends no `0x36` on receive, but route 02 `0x67`/`0x66` arrive at receive start/end.** The codec
  maps those to `0x36` status 1/2, so `RadioEngine` stays unchanged; `call_in` is kept as `rxDetectNode` for the
  report and a cross-check; caller info is asked with `0x2B` at receive start, as on the Armor.

## 6. Transmit

`handle_ptt` 0 keys, 1 unkeys (the HAL's `startPtt`/`stopPtt`; they also set `vendor.agui.extmodule.start` to 1/0,
which SignalDeck sets the same way until its meaning is known). Microphone audio goes out on the USB playback
stream. The module's own time-out and the 3.5 s retune rule are assumed to be the Armor's until measured. **Nothing is
keyed by the agent:** the profile ships transmit-blocked, and the owner keys in the cage with the script in §8.

## 7. What changes in SignalDeck (each its own PR, host tests, help, changelog)

1. `AgoldEnvelope` codec + `UartPort` switch on `profile.protocol` + the reply mapping table (host tests from the
   frames captured today).
2. `DeviceProfile`: the Atom XL profile, `bringUp`/`release` sequences with delays, `USB_ALSA`, `smsHeader5`;
   `ProfileRegistry` detection.
3. `RadioService` take-over / give-back / Exit paths for the bridge (the bridge check before re-enabling the stock
   app), and the start-up release after a crash.
4. `UsbAlsaAudio` backend (32 k ↔ 8 k) on `sdalsa`.
5. `RadioEngine.sendText`: the 5-byte header when `smsHeader5`.
6. Help: an "Atom XL" note (USB to a computer is off while SignalDeck has the radio; Exit and Hand back give it back),
   the device table in the README.

Restricted mode: no new page, mode or transmit path; the existing ones apply. The firmware loader page hides itself
on this profile (`firmwareLoader` off).

## 8. Tests

**Agent (receive only, Wi-Fi ADB, phone in the cage):** take-over and give-back ten times in a row with the USB
cable in (pass list §4 each time); a crash test (kill SignalDeck while it owns the radio, start it again, release
runs); channels written and read back (`0x24`/`0x25`); RSSI on a known carrier; receive audio from a station or the
owner's radio, recorded through the backend; DMR call heard with caller ID; a text received.

**Owner (transmit, cage), prepared by the agent:** a script that keys 2 s on a low-power analog channel, then a DMR
call, then a text, each with the expected result on the owner's receiver; only after that the profile's transmit block
is lifted and it is marked verified.

## 9. Open questions (each with the test that answers it)

1. **Do module pushes reach us?** *Answered for receive (findings §11, stock app owning the port): route 02
   `0x67`/`0x66` at start/end, `rw` 00; no `0x36`/`0x26`; `0x2B` only as a reply. `0x2D` (texts) still to see.* Receive a call from the owner's radio with SignalDeck owning the port: are `0x26`,
   `0x2B`, `0x2D` frames forwarded by the bridge (route 01, `rw` 00)?
2. *Answered (§11): yes, active low.* **Receive detection:** is `call_in` the HAL's `detectAudioinState`? Read it once a second during a reception.
3. **Audio content:** the idle capture was 0 then −32768 constant. What does a real reception look like at the card,
   and does the module need a volume (`0x2E`) or the HAL's PCM-open order before audio flows?
4. **Background kill:** the system force-stopped SignalDeck at 15:51 while it was idle (`ActivityManager: Force
   stopping com.macdmr.radio … from pid 1283`); `ro.agui.appblock=on`. Before take-over is trusted, find what killed
   it (Agold's app blocker, battery manager) and how to exempt a foreground service.
5. **Bands, time-out, retune settling** on this module (measured by the owner's transmit tests).
6. **V067's command table** (no image to read): the Armor's `0x3D`–`0x3F`/`0x46` are absent on V076; SignalDeck's
   capability flags stay off for them until a behaviour test shows otherwise.
