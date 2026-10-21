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
