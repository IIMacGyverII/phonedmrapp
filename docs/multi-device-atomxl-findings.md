# Unihertz Atom XL: how its stock app drives the DMR module (2026-10-24)

> **Measured on a bench Atom XL, 2026-10-28 (`docs/atomxl/PHASE_A_FINDINGS.md`):**
> - **Radio on = no USB to the PC.** The bridge MCU sits on the phone's only USB controller; powering the radio
>   (`mcu power 1`) switches that controller to host mode (`usb_intf_switch otg enable`, `switch_port_to_host`), so
>   adb over the cable, MTP and the PC link drop within ~1 s and stay down until the phone reboots: force-stopping
>   the stock app does **not** power the MCU off (the HAL keeps `/dev/ttyACM0` open), and the stock app's clean
>   power-off (`STOP_DEVICE` → HAL `stopMcu()`) leaves the USB controller in mode "none", replug or not. Release:
>   power-off, then `echo 0`, 1 s, `echo 1` > `/sys/devices/platform/11201000.usb3/cmode` (device mode back in 2 s). Work on this phone over Wi-Fi ADB (`persist.adb.tcp.port=5555`).
> - The bridge is USB `0483:5730` "Agold Audio Class": USB Audio (card 1, `pcmC1D0c`/`pcmC1D0p`, **32 kHz** stereo
>   S16) plus CDC-ACM (`/dev/ttyACM0`). The 48 kHz below is the stock app's AudioTrack/AudioRecord side.
> - The bench phone's module answers **`DMR006.U4A.V067`**, not V082 (V082 was the reporting owner's phone). Module
>   versions differ between units of the same model.

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

## Firmware files from the phone (2026-10-26)

The owner sent the phone's `/vendor/data` radio folders (`temp/Atom_XL_firmware.zip`, private). The module image is
published in AndroidRadio_Firmware_Project as a research copy (owner, 2026-10-26; `firmware/unihertz-atom-xl/DMR006.U4A.V076/`,
`factory: false`, not offered for loading, catalogue serial 5, `79fe063`); the MCU images stay private. The two device reports inside are the 2026-10-24 ones already here.

| File | Size | SHA-256 | What it is |
|---|---|---|---|
| `vendor/data/DMR/dmr/DMR006.U4A.V076.bin` | 358 100 | `4f5f287b…4d40fe` | DMR module image, version string `DMR006.U4A.V076` at `+0x33410` |
| `vendor/data/mcu/20190904034623.bin` | 54 465 | `c431f3b9…ba57aa` | USB bridge MCU |
| `vendor/data/mcu/20200423161457.bin` | 54 443 | `e95e0126…30ba7a` | USB bridge MCU |
| `vendor/data/mcu/20200508134341.bin` | 54 552 | `4eaea392…7c1d42` | USB bridge MCU |
| `vendor/data/mcu/20200812110328.bin` | 54 725 | `3b4090ee…de0aa7` | USB bridge MCU |
| `vendor/data/mcu/20201016161541.bin` | 55 011 | `76063054…d60abb` | USB bridge MCU |

- **The module image is the same family as the Armor's.** Its first 64 bytes are identical to
  `DMR003.UV4T.V022`'s (C-SKY V2 start-up code), and `tools/fw-port/find_symbols.py` (run read-only) puts it on the
  same XIP base `0x0301A000`. It finds the time-out timer idiom (struct at `0x38AF8`, Armor `0x38C64`) and the same
  ~6 KiB zero run near the end (`+0x55ED2`), but **no command dispatch thunks and no identified handlers**, so the
  thunk pattern from the Armor does not carry over as it is. That is firmware-side work (Grok), noted here only.
- **It is not the version the phone runs.** The device report's `0x34` reply is `DMR006.U4A.V082`; this file is V076,
  the copy the stock app keeps for its updater. A V082 copy would have to come from a newer stock app or ROM.
- **Command dispatch on V076 (read 2026-10-26, C-SKY objdump; `tools/fw-port/find_symbols.py --switch`, tests in
  `tools/fw-port/test_find_symbols.py`).** The same idiom as the Armor's: the command byte (frame byte 1) goes
  through `subi r3, 34; cmphsi r3, 103; lrw r2, 0x0304D274; ldr.w r3, (r2, r3 << 2); jmp r3` at `+0xA028`–`+0xA038`,
  a jump table at file `+0x33274` with 103 cases for commands 0x22–0x88 (Armor: `+0x38240`, 105 cases, to 0x8A); the
  unknown-command case is `+0x9FE0`. Each case is an 8-byte thunk `mov r0, r4; bsr handler; pop r4-r5, r15`
  (Armor: `pop r4-r8, r15`, the only reason the old finder saw nothing); 24 of them in three runs at `+0xA048`,
  `+0xA094`, `+0xA0FA`.
  - **0x3B (set time-out):** case `+0xA058` → handler `+0x9A5C`, which loads the timer struct `0x38AF8` (lrw at
    `+0x9A66`, `+0x9A7A`). Armor: case `+0xAB16` → `+0xA308`.
  - **0x34 (version):** case `+0xA09C` → handler `+0x9F18`, which loads the version string address `0x0304D410`
    (lrw at `+0x9F1E`, file `+0x33410`). Armor: `+0xA7E8` (`symbols.csv` `cmd34_version_reply`).
  - **Commands with a handler:** 0x24–0x2B, 0x2D–0x35, 0x37–0x3C and 0x88 (0x22, 0x23, 0x2C and 0x36 are inline
    cases). The Armor's 0x3D–0x3F and 0x46 fall to the unknown-command case on V076 and 0x89–0x8A are past its table, so V076 has no `0x3F` BER-pattern
    command and no `0x46`.
  - **Not for loading:** V076 is the updater copy, not what the module runs (V082). Nothing from this reading may be
    built for or loaded on an Atom XL until V082 is obtained and diffed (loader contract,
    `radio_firmware/plan-loader-safety.md`). Offsets and facts may be published; the image is not redistributed
    beyond AndroidRadio_Firmware_Project.
- **The MCU images are ARM Cortex-M** (initial stack `0x20002D58`, reset vectors in `0x0800xxxx`: an STM32-class part
  with ~11 KiB RAM). The names are build timestamps, 2019-09-04 to 2020-10-16; they are the USB bridge that presents
  `/dev/ttyACM0` and wraps the Armor command set in the `7E 96 69` envelope, not the radio itself.

## To ask the Atom XL owner

- `/vendor/bin/hw/vendor.mediatek.hardware.aguiextmodule@1.0-service` and the libraries it loads (for the PCM path),
  plus `lshal | grep -i agui` and the USB device list, taken while the stock app is running.
- Which key is the PTT key (press it once while running `getevent -l`).
