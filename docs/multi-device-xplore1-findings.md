# Multi-device feasibility: Blackview Xplore 1 vs. Ulefone Armor 26 Ultra (2026-10-17)

Goal: decide whether a standalone app (see `standalone-app-evaluation*.md`) could serve more than one
DMR phone. Input: the Xplore 1's stock walkie-talkie app, `QuickChatEEA.apk` (supplied by a user; analysed
offline with `aapt2`/`dexdump`, never installed), plus public specs.

## 1. The Xplore 1 app at a glance

| Item | Value |
|---|---|
| Package / label | `com.chamsion.quickchat` / "InterPhone", versionName V1.0, minSdk 29, targetSdk 36 (Android 16 tooling); phone ships DokeOS 5 / Android 15, MediaTek Dimensity 7050 |
| Signer | Blackview's own key (CN=blackview, SHA-1 `c5dd3b32…`) — not a platform test key |
| Permissions worth noting | `WRITE_SECURE_SETTINGS`, `READ_PRIVILEGED_PHONE_STATE`, `CAPTURE_AUDIO_OUTPUT`, `MANAGE_EXTERNAL_STORAGE` → almost certainly a priv-app, like PriInterPhone on the Armor |
| Radio SDK inside the APK | `com.wonder.dmr` (`DmrManager`, `AnalogCommand`, `DigitalCommand`, `DigitalVoiceReceptionInfo`, `utils/CRC`) + `com.wonder.serial` (`SerialTools`, JNI `libwonder_serialport.so`) + `me.f1reking.serialportlib` (`libserialport.so`) |
| Control UART | `/dev/ttyS0`, baud selectable (57600 / 115200 / … constants present; the Armor uses 57600) |
| **Audio** | **PCM over a second UART, `/dev/ttyS1` at 230400 baud** ("initPcmSerialPort"); `AudioTrack` 8000 Hz **mono** 16-bit for RX, `AudioRecord` 8000 Hz mono 16-bit for TX, queued in packets (`pcmPackageItem`, 160-sample ≈ 20 ms frames) |
| Module GPIOs | `/sys/devices/platform/intercom/intercom_power_control`, `…/intercom_pwd_control`, `…/intercom_ptt_control` — written 1/0 by `DmrManager.powerCtrl/pwdCtrl/pttCtrl`; power-off order in `DmrService.d()`: power → pwd → ptt all 0 |
| Hardware PTT | `PttKeyReceiver` receives the framework broadcasts **`com.android.intent.ptt.down` / `com.android.intent.ptt.up`** (1.5 s hold rule in the app) — same idea as the Armor's `com.interphone.ptt.down/up` |
| Bundled data | `assets/databases/channel.db` (Room, `channel_table`, 8 default channels 401.025–408.025 MHz: 6 digital cc1 localId 888 groupList "1-0-…", 2 analog), `contacts.db` |

## 2. Same MCU protocol — verified byte for byte

| Armor 26 Ultra (`PriInterPhone`, docs/deep-dive/01) | Xplore 1 (`com.wonder.dmr.DmrManager`) |
|---|---|
| frame `68 cmd rw sr ck(2) len(2) body 10` | `0x68` head and `0x10` tail used in every command builder |
| checksum: 16-bit one's-complement sum, odd byte `<<8`, fold, `^0xFFFF` (`PacketEncoder.pcCheckSum`) | `CRC.checkSum([B,I)` — identical algorithm (also ships CRC16-XMODEM, used for firmware upgrade packets) |
| `0x22` SET_DIGITAL_INFO (163-byte body) | `setDigitalCmd` → `0x22`; `DigitalCommand` fields rx_freq, tx_freq, localId, groupList[32], tx_contact, contactType, power, cc, inboundSlot, outboundSlot, channelMode, encryptSw, encryptKey[8], pwrsave, volume, mic, relay — the same 17 fields |
| `0x23` SET_ANALOG_INFO (19-byte body) | `setAnalogCmd` → `0x23`; `AnalogCommand` fields rx_freq, tx_freq, power, pwrsave, volume, relay, band, sq, rx_type, rx_subcode, tx_type, tx_subcode, monitor — the same 13 fields |
| `0x26` launch (PTT) | `launchCommand` → `0x26` |
| `0x28` enhance (kill/revive/…) | `setEnhancements` → `0x28` |
| `0x29` encrypt | `setEncryption` → `0x29` |
| `0x2A` mic gain | `setMicGain` → `0x2A` |
| `0x2B` caller info (callType 0 private / 1 group / 2 all) | `DigitalVoiceReceptionInfo` PERSONAL 0 / GROUP 1 / BROADCAST 2 |
| `0x2C` send SMS | `sendMsg` → `0x2C` |
| `0x2E` volume, `0x2F` monitor, `0x30` squelch, `0x31` power-save, `0x33` relay/offline, `0x35` interrupt, `0x37` polite, `0x3A` SMS protocol, `0x3B` TOT, `0x3C` SPK_EN | `setVolume 0x2E`, `setMonitor 0x2F`, `setSquelch 0x30`, `setPowerSavingMode 0x31`, `setRelayOffline 0x33`, `setTransferInterrupt 0x35`, `setPolite 0x37`, `setSmsProtocolType 0x3A`, `setTot 0x3B`, `setSpkEn 0x3C` |
| `0x32` RSSI, `0x34` version, `0x2D` SMS fetch | `getRSSI`, `getVersion`, `getSms` |
| firmware update over the UART (YModem in PriInterPhone) | `sendUpgradeFirstPackage/DataPackage/LastPackage`, `checkDmrUpgradeMode` |

Conclusion: both phones carry the **same DMR module family** (same vendor command set, same body layouts,
same checksum). Everything the module does today on the UART — channel programming, PTT, caller ID, RSSI,
SMS, kill/revive, TOT — would work unchanged on the Xplore 1.

## 3. What differs per device (the "device profile")

| Concern | Armor 26 Ultra | Xplore 1 | Abstraction |
|---|---|---|---|
| Control port | `/dev/ttyS0` 57600 (termios already raw) | `/dev/ttyS0`, baud per profile | `uartPath`, `baud`, do our own termios via a tiny JNI or `stty` in the root script |
| Voice audio | vendor binder `PrizeTinyService` → tinyalsa I2S, 8 kHz **stereo** L==R, 2048-byte frames | **raw PCM on `/dev/ttyS1` @ 230400**, 8 kHz **mono** | `AudioBackend` interface with two implementations: `TinyServiceAudio` (binder, hidden API) and `UartPcmAudio` (second tty). Everything above it (decoders, captions, AFSK TX, recording) already works on 8 kHz mono after the L/R decimation |
| Module GPIOs | `/sys/devices/platform/dmr009/{pwd,ptt,pd,debug}` ("pwd :1") | `/sys/devices/platform/intercom/intercom_{power,pwd,ptt}_control` | `powerNode`, `pttNode`, value format per profile |
| SELinux labels | `ttyS_device`, `sysfs_prizefactory` (rules proven) | unknown until someone runs `ls -lZ` on an Xplore 1; expect `ttyS_device` + some `sysfs_*` vendor label | profile carries the `sepolicy.rule` lines; detection = `ro.product.model` / `Build.DEVICE` |
| Hardware PTT key | implicit broadcast `com.interphone.ptt.down/up` | `com.android.intent.ptt.down/up` | list of actions per profile |
| Stock app to disable | `com.pri.prizeinterphone` (persistent priv-app) | `com.chamsion.quickchat` | `pm disable-user` per profile |

## 4. Feasibility verdict for the Xplore 1

* **Protocol: no work.** Same module, same bytes.
* **Audio: one new backend** (UART PCM). Lower risk than the Armor's path, in fact: a plain file on a tty,
  no hidden API. Frame boundaries/headers on `ttyS1` must be confirmed on hardware (the APK queues 20 ms
  packets; whether the MCU expects a header is not visible in the obfuscated code).
* **Root is still required** (SELinux on the tty/sysfs nodes, exactly as on the Armor). Public guides exist for
  other MediaTek Blackviews (fastboot unlock + Magisk-patched boot/init_boot), nothing Xplore 1-specific yet.
  Without root the only route is the Xplore's own app, which is signed by Blackview and not hookable without
  LSPosed anyway — so the standalone app is the *more* portable option, not less.
* **A user on an Xplore 1 can help in three commands** (adb, no root): `getprop ro.product.model`,
  `ls -lZ /dev/ttyS0 /dev/ttyS1 /sys/devices/platform/intercom/`, `ps -AZ | grep quickchat`, plus
  `dumpsys package com.chamsion.quickchat | grep -E "codePath|userId|sharedUser"`.

## 5. Recommended architecture for the standalone app

```
app (UI, captions, APRS, SSTV, history, backups)   ← unchanged feature code lifted from the module
   └── RadioEngine (protocol: frames, commands, state machine, channel programming)   ← one implementation
         ├── ControlPort      : UartPort(path, baud)                                  ← per profile
         ├── AudioBackend     : TinyServiceAudio | UartPcmAudio(path, baud)           ← per profile
         ├── ModulePower      : SysfsGpio(powerNode, pwdNode, pttNode, format)        ← per profile
         └── PttKeySource     : BroadcastActions([...])                               ← per profile
DeviceProfile = detect(Build.MANUFACTURER, Build.DEVICE, existing nodes) → {Armor26Ultra, Xplore1, Generic}
```

Profiles are data (a JSON/Kotlin object per phone); adding a phone = adding a profile + its Magisk
`sepolicy.rule` lines, not new hooks. Unknown phones fall back to probing: which `/dev/ttyS*` answers a
`0x34` version query with a `68 34 …` frame, whether `/sys/devices/platform/*` contains `dmr*`/`intercom*`.

## 6. Other candidates (public info only)

Oukitel WP61 Plus / Ultra / Ti (2 W DMR, IFA 2025), Ulefone Armor 20WT (2023 DMR), UNIWA P2 Plus / P5 —
all MediaTek rugged phones with an embedded DMR module; whether they use the same `68…10` protocol is
unknown until an APK rip is available. The same 20-minute `aapt2`/`dexdump` check used here answers it.

## 7. Sources

- Xplore 1 radio specs: [Blackview product page](https://www.blackview.hk/products/item/xplore-1-walkie-talkie) (UHF 400–480 / VHF 136–174 MHz, digital + analog, dual-slot, AES, PTT key), [GSMArena](https://m.gsmarena.com/blackview_xplore_1_walkie_talkie-ampp-14438.php) (Dimensity 7050, Android 15), [myGMRS forum thread](https://forums.mygmrs.com/topic/12029-soooi-just-bought-a-hamgmrscell-phone-combo-blackview-xplore-1/) (FM works on GMRS/ham, DMR TX works / RX "needs fiddling", APRSdroid works in AFSK mode, ~5 W high).
- Rooting MediaTek Blackviews (generic): [BV9500 Plus Magisk gist](https://gist.github.com/MrCelticFox/d96a7ebe968195b43604a183aa71709a), [BV5300 root notes](https://www.rigacci.org/wiki/doku.php/doc/appunti/hardware/blackview_bv5300), [XDA Blackview Tab 18 root](https://xdaforums.com/t/rooting-a-blackview-tab-18-with-a-helio-g99-mt6789-chip.4668892/).
- Other DMR phones: [Oukitel WP61 Plus review](https://www.techradar.com/pro/phone-communications/oukitel-wp61-plus-rugged-phone-review), [Ulefone Armor 20WT](https://www.backmarket.co.uk/en-gb/p/ulrfone-armor-20wt), [UNIWA P5](https://m.reach.dog/shop/31ba9f-3a/products/mph2097).
- DMR modules with a serial command protocol (for context): [NiceRF DMR858M](https://www.nicerf.com/walkie-talkie-module/dmr858m.html), [SR_DMR_5WU](https://www.tindie.com/products/sunrise/sr_dmr_5wu-dmr-digital-two-way-radio-module/).

How to collect the same facts from any other phone: `docs/DEVICE_SUPPORT_REQUEST.md`.

## Status 2026-10-17 (evening)

`DMRStandalone` now has the `AudioBackend` split: `TinyServiceAudio` (Ulefone, verified) and `UartPcmAudio` (raw 8 kHz mono PCM on
`/dev/ttyS1` @ 230400, 20 ms packets, RX played through an AudioTrack and handed to the DSP as stereo-duplicated frames). The
`XPLORE_1` profile selects it. **Untested on hardware** — what the first owner must confirm: the stream is headerless, byte order,
packet size/pacing, the SELinux labels of `ttyS0/ttyS1` and the `intercom_*` sysfs nodes, and the name of the stock app's serial
JNI library (`ls /system/lib64 | grep -i serial`, now in `DEVICE_SUPPORT_REQUEST.md`) so `DeviceProfile.serialLib` can be set.


## First owner dump (2026-10-21)

An Xplore 1 owner ran the §2 dump and the §4 root step of `DEVICE_SUPPORT_REQUEST.md` (an older copy without the
serial-library line). Confirmed against the profile:

| Fact | Dump | Profile |
|---|---|---|
| Model / build | `XPLORE 1 Walkie Talkie`, device `XPLORE_1_WT`, Android 15 (SDK 35), `mt6877`, build `…_EEA_F253_V1.0_A15_…20260318`, SELinux enforcing | detect() matches on `/sys/devices/platform/intercom` or "xplore" ✓ |
| Stock app | `com.chamsion.quickchat` V1.0 in `/system/app/QuickChatEEA` (plain system app, **not** priv-app, not persistent; not running when the dump was taken) | ✓ |
| UARTs | only `/dev/ttyS0` (4,64) and `/dev/ttyS1` (4,65), both `u:object_r:ttyS_device:s0`, mode **0777** | the `ttyS_device` rules cover both ✓ |
| Module nodes | `/sys/devices/platform/intercom/` holds `intercom_power_control`, `intercom_pwd_control`, `intercom_ptt_control`, `intercom_factory_test` (dir label `sysfs`); the shell user cannot even stat the files, so they carry a vendor label | **label still unknown → the profile has no sysfs rule yet**, so powering the module from the app would be denied |
| PTT key | `com.android.intent.ptt.down` / `.up` sent by `system` on a press | ✓ |
| Vendor audio service | none (no tiny/dmr service) — consistent with PCM on `ttyS1` | ✓ |
| Root | Magisk 31.0 | — |

The root step returned nothing new: `adb shell su -c "a; b; c"` only runs the first command as root (adb re-joins the
arguments; the same trap noted for the Armor), so the sysfs listing still showed `?` and `dmesg` was denied. The guide
now feeds the commands to `su` on stdin. Still needed: the `intercom_*` file labels and values, the serial JNI library
name, and a first `0x34` version query on `ttyS0` — the in-app **Radio probe (root)** collects all three.

**Second root dump (same day, via `su` on stdin):** context `u:r:magisk:s0`; the `intercom_*` files are **plain
`u:object_r:sysfs:s0`, mode 0777** (`intercom_factory_test`, `_power_control`, `_ptt_control`, `_pwd_control`); no serial
library under `/system/lib*`. The QuickChat APK carries its own: `libserialport.so` (`me.f1reking.serialportlib.SerialPortHelper`)
and `libwonder_serialport.so`, which registers its methods from `JNI_OnLoad` on `com.wonder.serial.SerialPort`
(strings: `openSerial`, `setupSerial`, `readData`, `writeData`; signatures `(Ljava/lang/String;I)I`, `(IIICI)I`, `(I[BI)I`,
`(I[BII)I`, `(I)V`). A policy rule for plain `sysfs` would open all of sysfs to every app, so SignalDeck writes these nodes
through root instead (`SysfsGpio`), and the profile stays marked **unverified** until it has run on the phone.

## First Run all checks (2026-10-21, SignalDeck 1.0.0-beta.1)

- **Works:** `ttyS0` at 57600 via the stty fallback; module powered through root (`intercom_pwd_control`); boot banner `BF AA … 0D 0A`
  ("开机初始化完成"); `0x34` version **DMR003BN.UV4P.V016** (Armor: DMR003.UV4T.V022); `0x32` RSSI answers; side key →
  `com.android.intent.ptt.down/up` (input `intercom`/`mtk-kpd` `KEY_F1`). `intercom_*` files are write-only (read back empty).
- **Lines (QuickChat `j0.a.run`, `DmrService.d`, `q0.g0.q/s`):** power-up = `power_control`, `pwd_control`, `ptt_control` all `1`;
  power-down = all `0`; **`ptt_control` 0 = transmit (`setPttLaunch`), 1 = receive (`setPttReceive`)** — the Xplore keys through
  this GPIO. The firmware-update screen sets `ptt_control 0` before powering the module (likely bootloader entry).
  beta.1 never wrote `ptt_control`, so its trial may have powered the module with the PTT line low; beta.2 sets it to 1 first and
  blocks all transmit on unverified profiles.
- **Audio (`q0.e0.onDataReceived`, `t0.g.c`, `q0.b0.run`):** RX on `ttyS1` (230400 8N1) = 167-byte packets
  `BB 00 h h h h <160 B PCM> 44`, 8 kHz mono 16-bit, 10 ms each; TX = raw 160-byte blocks, one every ≥10 ms, no header,
  `AudioRecord` source MIC. beta.1's trial got 0 bytes (no channel programmed, PTT line unset).
- **QuickChat data:** Room DBs `databases/channel_database` (`channel_table`: same fields as the module, Hz, type 0 digital / 1 analog,
  `groupList` "1-0-0-…") and contacts (`contacts_table`: type 0 private / 1 group).

## QuickChat's own startup log (beta.3 report, 2026-10-21)

Order: open `ttyS1` 230400 8N1 → lines power/pwd/ptt `0` → open `ttyS0` 57600 → lines `1` → boot banner `BF AA …` →
`0x27` (query init complete, answer `68 27 00 00 …`) → `0x34` version → `0x23` channel (446.00625, body
`01 01 05 00 00 00 00 02 00 02 02`: band 1, power 1, **sq 5**, …, pwrsave 2, volume 0, monitor 2, relay 2) → `0x35` interrupt 2 →
`0x37` polite 0 → `0x2F` monitor 2 → `0x30` squelch 5. With nobody on the channel no PCM packet arrived on `ttyS1`: audio flows
only while the squelch is open. Live database: `databases/channel_database`, table **`channels`** (311 rows, `countryId`,
`channelIdInCountry`, `smsType` + the module fields) and `countries` (15). Kernel: `state:intercom connect/disconnect` from the
intercom driver at each power change. QuickChat restarts itself after one force-stop.

## Receive audio confirmed (beta.5 trial, 2026-10-21)

With the radio on 446.00625 MHz analog and **monitor on (`0x2F` 1)**, `ttyS1` delivered **100 packets/s**, every one
`BB 00 00 A0 xx xx <160 bytes> 44` (`00 A0` = payload length 160; the last two header bytes vary per packet), 0 bytes
skipped by `PcmFramer`. Payload = 8 kHz mono 16-bit **little-endian** (squelch-open noise: RMS ≈ 3000, energy around 300 Hz,
little above 2 kHz). Before monitor the packets were all-zero. RSSI −111…−114 dBm (nobody on the channel). QuickChat's
channels imported (a digital channel was written at bring-up). Still open: transmit (QuickChat keys with `ptt_control 0` and
sends raw 160-byte PCM blocks on `ttyS1`; not tried — transmit stays off on the unverified profile).

## Listen check on beta.8 (owner, 2026-10-22, Faraday cage, a Baofeng transmitting next to the phone)

- **Receive works and sounds right.** 416.025 MHz analog: part 1 (MON, 10 s) 167,668 bytes, RMS 1595, 1 short dropout; part 2 (normal
  squelch, 50 s) 834,833 bytes (the full 8 kHz rate), RMS 1179, peak 11582, no clipping, no dropouts; owner: "heard everything …
  I could understand everything". Signal −48…−53 dBm with the Baofeng keyed.
- **The squelch stays open.** After part 1 switched MON off (`0x2F` 2), the module kept reporting a reception in every second of part 2,
  including seconds at −105/−106 dBm (no signal); the owner hears the noise all the time ("after the Step 3 test it stayed always on").
  SignalDeck's channel writes matched QuickChat's (`0x23` sq 5, monitor byte 2; `0x30` 5, acked). Working theory: firmware V016
  does not leave monitor on `0x2F` 2 (QuickChat only sends 2 at start-up, when monitor is off anyway), so once MON (or the beta.5/8
  trial, which turns MON on) has been used the squelch stays open. The report's app log ended before the listen check, so the
  frames of that minute are not in it.
- **Next (beta.11):** analog channel writes on this profile send channel → monitor → squelch like QuickChat; the radio audio check
  detects "squelch open with no signal after MON off" and tries (1) channel + `0x2F` 2 + `0x30`, (2) `0x2F` 0, reporting which closed it.



## QuickChat decompiled (jadx 1.5.6, 2026-10-22): how the stock app drives the module

Interoperability notes only (facts and values, no code). The protocol library is `com.wonder.dmr.DmrManager` ("version 1.0.9 (2025-4-27)") with `com.wonder.serial.SerialTools`; the app logic is obfuscated. Transmit was deliberately not analysed.

- **Frames:** `68 cmd 01 01 ckH ckL lenH lenL body 10`; length big-endian (body only); checksum = 16-bit ones'-complement sum of big-endian words over the frame with the checksum field 0. Reply byte 3: 0 success, 1 failure, 2 checksum error.
- **0x23 body (19 B):** rx LE32, tx LE32, band (0 narrow, 1 wide), power, sq 0–9, rxType (0 carrier, 1 CTCSS, 2 DCS N, 3 DCS I), rxSub, txType, txSub, **pwrsave (1/2), volume (QuickChat always 0), monitor (1/2), relay (1/2)**.
- **0x22 body (163 B):** rx, tx, localId (LE32 each), 32 group IDs LE32, txContact LE32 (All = 0xFFFFFF), contactType, power, cc, in slot, out slot, channelMode (0 direct, 4 double slot), encryptSw (1/2), 8-byte key, pwrsave, volume (0), mic, relay.
- **Other commands:** 0x27 init check, 0x28 remote functions (radio check, call alert, remote monitor, kill, activate), 0x31 power save (1/2), 0x35 transfer interrupt, 0x37 "polite" (**0 off / 1 on**), 0x3A SMS protocol type, 0x3C speaker enable. 0x2B and 0x32 are never used by QuickChat.
- **Start-up:** sysfs power/pwd/ptt lines 0 → 200 ms → open ttyS0 (57600) → 100 ms → lines 1; boot banner → 0x27 → 0x34 → first channel write.
- **Channel write timing:** at least **1000 ms** between channel writes (later ones dropped) and **1200 ms** between channel-button presses; **no channel change while receiving or transmitting**; after the 0x23 acknowledgement: 0x35 → (ack) 0x37, and **200 ms after the 0x23 acknowledgement 0x2F then 0x30**, whose answers are ignored. From the channel list: no 0x2F/0x30 at all.
- **Errors:** no timeouts and no retries anywhere; refusals are ignored. A 5 s version watchdog re-powers the module if 0x34 never answered (buggy: never fires after the first answer).
- **0x36 status values:** 1 RX start, 2 RX end, 3/4 TX start/end, 5 SMS waiting (→ 0x2D), 6 activation timeout, 7 re-key, 8 SMS delivered, 9 SMS failed. QuickChat **never acknowledges 0x36** and de-duplicates repeats (the module may repeat pushes; repeated value accepted again after 5 repeats or 5 s).
- **No scanner, no tone scan, no RSSI polling** in QuickChat.
- **Tones:** CTCSS index 0..50 = 62.5 … 254.1 Hz (index 0 is 62.5, "off" is type 0); DCS index into the 83-code list for both N and I (same as the Ulefone table).
- **ttyS1 audio:** 230400 8N1; each read must be exactly **167 bytes: `BB 00 xx xx xx xx` + 160 bytes PCM (80 samples, 10 ms) + `44`**; 8 kHz mono 16-bit; played as-is, not gated by 0x36.
- **SMS receive (0x2D reply):** type (0 private / 1 group), sender LE32, text (UTF-8 by default). Note for a later transmit review: QuickChat's 0x2C body has **no 9-byte header** (type, target, text), unlike what the Armor's firmware needed.
- **Shipped channels:** band 0, sq 5, monitor 2, relay 2, pwrsave 1 (SignalDeck sends pwrsave 2).

Applied in SignalDeck (2026-10-22, Xplore profile revision 2): channel writes at least 1 s apart (quick changes collapse into the last), monitor + squelch 200 ms after the channel's acknowledgement (1.5 s fallback), scan dwell 2.5 s, refused MON retried.
