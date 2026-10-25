# Unihertz Atom XL: how its stock app drives the DMR module (2026-10-24)

Source: two SignalDeck 1.0.0-beta.19 device reports from an Atom XL owner (same run, the second without station
details; `report.txt` identical) and the stock app `com.agold.intercom` v2.0 they contained, decompiled locally with
jadx 1.5.6 (the APK and the reports stay out of every repository). Nothing here was run on an Atom XL by us.

## Phone

- Unihertz Atom_XL, MediaTek MT6771 (Helio P60), Android 11, build `Unihertz_Atom_XL_20210729`, SELinux enforcing,
  Magisk 29.0, bootloader unlocked (orange).
- ODM is **Agold** (`com.agold.*`, `com.agui.*`), not Prize (Ulefone) and not the Blackview/QuickChat family.
- Properties: `ro.agold.extmodule.dmr09=yes`, `ro.agold.intercom.ptt=yes`, `ro.agui.smartkey_ptt=com.agold.intercom`.
- PTT: no key reached SignalDeck during the report's capture; the stock app logged keycode 142 (`KEYCODE_F12`,
  scan code 88, from `mtk-kpd`) at start-up. Whether that is the PTT key is not yet known.

## Module

- Version reply (`0x34`): **`DMR006.U4A.V082`**, the same naming as the Armor's `DMR003.UV4T.V022` (HR-C7000
  family). The phone-side MCU reports a build date `20201016161541` (its own command `0x01`).
- Default channels from the stock app: UHF around 401 MHz (digital 1–8, analog 9–16), analog 444.800 MHz in area 2.

## Transport: a vendor HAL owns the radio

The stock app opens **no device itself**. It calls the HIDL service
`vendor.mediatek.hardware.aguiextmodule@1.0::IAguiExtModule/default`, served by
`/vendor/bin/hw/vendor.mediatek.hardware.aguiextmodule@1.0-service`, which holds **`/dev/ttyACM0`** (a USB CDC-ACM
port: the module sits behind a small MCU on USB). `/dev/ttyACM0` did not exist when the report started; it appeared
after the stock app called `startMcu()`.

Interface methods: `startMcu`, `stopMcu`, `writeTTyDevice(bytes,len)`, `readTTyDevice(callback)`,
`openPcmIn`/`closePcmIn`, `readPcmDevice(callback)`, `openPcmOut`/`closePcmOut`, `writePcmDevice(bytes,len)`,
`startPtt`/`stopPtt`, `detectAudioinState` (the app polls it every 100 ms; 1 = a call is coming in, which starts
playback), `updateMcu`, `updateDmr` (firmware loaders).

Kernel lines next to it: `mcu_eint_func data:1` and `mcu_wakelock_unlock` (an interrupt line from the MCU).

## Frame format (MCU envelope)

```
7E 96 69 | route | cmd | rw | len (2, BE) | body | checksum (2, BE) | 81
```

- `route`: `00` = the phone-side MCU's own command, `01` = passed to the DMR module.
- `rw`: `01` in requests, `00` in replies. Replies carry the result in the body (`00` = success), where the Armor
  frame has an `sr` header byte.
- Checksum: 16-bit one's-complement (Internet checksum) of the bytes from `route` to the end of the body, big-endian
  words, odd byte padded low; the same arithmetic as the Armor's, over a different span. Verified against all four
  frames in the log (e.g. reply `7E 96 69 01 22 00 00 01 00 FD DD 81`).

## Commands: the Armor's command set inside that envelope

With `ro.agold.extmodule.dmr09=yes` the app uses its "Dmr09" command set, which is the Armor's:

| cmd | Armor name | Atom XL use |
|---|---|---|
| `0x22` | SET_DIGITAL_INFO | digital channel, **163-byte body in the Armor layout** (rx, tx, local ID at 8, 32 RX groups, TX contact at 140, …) |
| `0x23` | SET_ANALOG_INFO | analog channel, 19-byte body, rx/tx LE first like the Armor |
| `0x2B` | caller info | received-call info |
| `0x2C` | send SMS | text: type (9 sent as 3), ID (4 bytes LE), UTF-16LE text, 4 zero bytes: a 5-byte header, where the Armor's firmware needs 9 (type, ID, ID again) or eats the first two characters |
| `0x2D` | fetch SMS | message content |
| `0x2E` | SET_VOL | receive volume |
| `0x34` | QUERY_VERSION | `DMR006.U4A.V082` |

An older command set (`0x02`, `0x10`, `0x11`, `0x25` version) is also in the app for phones without the DMR09 module.

So SignalDeck's `RadioEngine` message bodies would carry over; it needs a new framing (envelope + checksum span +
result in the body) and a new transport.

## Audio

Both directions go through the HAL as **48 kHz stereo 16-bit** PCM (`AudioTrack`/`AudioRecord` at 48000, channel
mask 12; transmit frames 1920 bytes = 10 ms). Receive: `openPcmIn` then `readPcmDevice` callbacks into an
`AudioTrack`. Transmit: `startPtt` + `openPcmOut`, microphone → `writePcmDevice`, then `closePcmOut` + `stopPtt`.
Which device the HAL moves this PCM over (a second USB interface, an ALSA device, the TDM capture
`mt_soc_tdmrx_pcm`?) is inside the HAL binary, which the report does not include.

## What a SignalDeck profile would need (not started; SignalDeck is on hold for other work)

1. Either talk to `IAguiExtModule` (HwBinder from the app, needs sepolicy for the hwservice and binder calls, and the
   stock app stopped) or stop the HAL and use `/dev/ttyACM0` directly (then power, PTT and PCM are ours to find).
   The HAL route is the smaller step: it already does power, PTT and audio.
2. A framing variant in the engine (envelope above).
3. Audio backend at 48 kHz stereo through the HAL.

## Device report gaps this phone showed (for SignalDeck, later)

- The radio probe tries only `/dev/ttyS*`; it never looked at `/dev/ttyACM*`/`ttyUSB*` or at ports a HAL holds, so the
  summary says the module did not answer although the stock app's log shows it answering.
- The probe changed `/dev/ttyS0` from 921600 to 230400 baud and reported "line settings put back: NO"; it should
  restore the original speed (or not touch ports nobody owns).
- No USB device list (`/sys/bus/usb/devices/*/{idVendor,idProduct,product,interface}`) and no vendor HAL binaries or
  `lshal` output; for this phone the HAL `@1.0-service` binary and `lshal | grep agui` are what is missing.

## To ask the Atom XL owner

- `/vendor/bin/hw/vendor.mediatek.hardware.aguiextmodule@1.0-service` and the libraries it loads (for the PCM path),
  plus `lshal | grep -i agui` and the USB device list, taken while the stock app is running.
- Which key is the PTT key (press it once while running `getevent -l`).
