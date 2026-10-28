# Atom XL, Phase A: baseline and identity (2026-10-28)

Bench phone: Unihertz Atom XL, adb serial `ATOMXL0000000737` (USB) / `192.168.1.106:5555` (Wi-Fi ADB, see §1).
Everything here was measured on this phone. Handoff: `docs/handoff-atomxl-compat-2026-10-28.md`.

## 1. The radio and USB adb cannot run at the same time (hardware)

**When the radio is powered, the phone's USB port stops being a USB device: adb over the cable, MTP and the PC
link all drop, and they stay down until the radio is powered off again (or the phone reboots).**

The phone has one USB controller (MediaTek `mtu3` + `xhci`). The radio's bridge MCU is a USB device on that same
controller, so powering the radio switches the controller from device (gadget) mode to host mode. Kernel log at the
stock app's start (2026-10-28, over Wi-Fi ADB with the cable still plugged in):

```
mt_usbhost_connect
usb_intf_switch otg enable
mtu3_phone musb-hdrc: switch_port_to_host
mcu power 1
xhci-mtk-phone usb3_xhci: xHCI Host Controller ... new USB bus registered
usb 1-1: 0483:5730 'Agold_WX' 'Agold Audio Class'   (snd-usb-audio + cdc_acm → /dev/ttyACM0)
```

and on power-off: `mcu power 0`, `mt_usbhost_disconnect`, `usb_intf_switch otg disable`, then the gadget comes back.

Timing measured over Wi-Fi ADB (`am start` of `com.agold.intercom`, polled once a second):

| t | USB adb | `/dev/ttyACM0` |
|---|---|---|
| before | present | absent |
| +1 s | **gone** (Windows sees no device at all, not even MTP) | absent |
| +7 s | gone | present |

Things that do **not** bring USB back:
- closing the stock app from recents, or `am force-stop com.agold.intercom`: the HAL
  (`vendor.mediatek.hardware.aguiextmodule@1.0-service`, pid 611) keeps `/dev/ttyACM0` open and the MCU powered,
  so the port stays in host mode (checked 12 s after force-stop: `ttyACM0` still there, USB still gone);
- unplugging and replugging the cable.

What does: the HAL's `stopMcu()` (the stock app's own exit path; `mcu power 0` in the log), or a reboot.

Who powers it: the `mcu power 1` call came from a HwBinder thread of pid 607, `vendor.mediatek.hardware.agolddaemon@1.0-service`,
not the extmodule HAL; the sysfs side is the `mcu` platform driver (`/sys/bus/platform/drivers/mcu/`: `mcu_power`,
`rstmcu`, `usb_path`, `handle_ptt`, `call_in`; names only, none read).

Consequences:
- **Bench rule: work on the Atom XL over Wi-Fi ADB.** `persist.adb.tcp.port=5555` is set as root (2026-10-28) and
  survived a reboot (adbd listened on `192.168.1.106:5555` at boot with no pairing). Keep the cable for charging and
  as the fallback when the radio is off. Address the phone by its Wi-Fi serial and check `ro.serialno` =
  `ATOMXL0000000737` at the start of each session.
- **Device report:** the stock-app watch (`am force-stop` at the end) leaves the radio powered and the phone off USB.
  `run_checks.sh` over USB loses the phone mid-run and reports "no result" although the checks finished (the
  12:43 run wrote its folder at 12:45). The report must say up front that this phone family drops USB while the radio
  is on, recommend Wi-Fi ADB, and power the radio back off (through the stock app's own stop, not a force-stop) at
  the end of the watch.
- **SignalDeck:** while SignalDeck owns the radio on this phone, USB is unavailable (no adb, no file transfer, no USB
  audio or Android Auto over the cable; charging still works). Give-back must power the MCU off, or the phone stays
  in host mode. The in-app help for the Atom XL profile must say this.

## 2. Module and bridge identity

| What | Value | Source |
|---|---|---|
| Module version (`0x34`) | **`DMR006.U4A.V067`** (not V082: that was the other owner's phone) | stock app's log, raw reply `7E 96 69 01 34 00 00 10 44 4D 52 30 30 36 2E 55 34 41 2E 56 30 36 37 00 18 0D 81` |
| Bridge MCU version (route `00`, cmd `0x01`) | `20201016161541` | raw reply `7E 96 69 00 01 00 00 0E 32 30 32 30 31 30 31 36 31 36 31 35 34 31 8E A1 81`; matches `/vendor/data/mcu/20201016161541.bin` |
| Bridge USB device | `0483:5730` "Agold_WX / Agold Audio Class", full speed | `/sys/bus/usb/devices/1-1` |
| Interfaces | 1.0 audio control, 1.1 audio capture, 1.2 audio playback (`snd-usb-audio`), 1.3 + 1.4 CDC-ACM (`cdc_acm` → `/dev/ttyACM0`) | sysfs |
| Radio audio | ALSA card 1 "Agold Audio Class", `pcmC1D0c` / `pcmC1D0p`, **S16_LE, 2 channels, 32000 Hz** both ways | `/proc/asound/card1/stream0` |
| Holder of `/dev/ttyACM0` | the extmodule HAL, pid 611 (`u:r:hal_aguiextmodule:s0`) | `/proc/611/fd` |

The 48 kHz in `multi-device-atomxl-findings.md` is the stock app's `AudioTrack`/`AudioRecord` side; the module's PCM
on the wire is 32 kHz (`ro.agold.extmodule.32k=yes`). The HAL opens `/dev/snd/pcmC1D0c` and `pcmC1D0p` with tinyalsa.

## 3. Phone identity

- `Unihertz/Atom_XL/Atom_XL:11/RP1A.200720.011/root.20210729.112847:user/release-keys`, MT6771, SELinux enforcing,
  verified boot orange, Magisk 31.1 (`su --mount-master --context u:r:magisk:s0` gives `uid=0 … u:r:magisk:s0`).
- `persist.sys.agui_version` / `ro.agui.real_version` = `Atom_XL_20230918_1659` (newer than the build date).
- Props: `ro.agold.extmodule.dmr09=yes`, `ro.agold.extmodule.hal=yes`, `ro.agold.extmodule.32k=yes`,
  `ro.agold.intercom.ptt=yes`, `ro.agui.smartkey_ptt=com.agold.intercom`, `ro.cam.key_control_plan=ptt`,
  `ro.agui.keymap=VOLUMEUP,VOLUMEDOWN,FUNC1,APPSWITCH,BACK`.
- Services: `init.svc.aguiextmodule` and `init.svc.agolddaemon` running; `lshal` lists
  `IAguiExtModule/default` and `IAgoldDaemon/default`.
- Stock app `com.agold.intercom` 2.0 (`/system/app/Intercom`), launch activity `.IComActivity`.
- `/dev/stmcu` (`agui_device`, 0666), `/vendor/bin/dfu-util`, `/vendor/bin/auto_update` (DFU to `0483:df11` at
  `0x08000000`: the bridge MCU's updater; never run).

## 4. PTT key

Not pressed yet (needs the owner). Input devices: `mtk-kpd` (event2: HOME, VOLUME±, POWER, `00f9`, RESTART),
`hall-kpd` (event1: `KEY_F12`), `fingerprint_key` (event3: … `KEY_F11` …), `ACCDET`, `mtk-tpd(-kpd)`. The F12 the
earlier reports saw is on `hall-kpd`, not `mtk-kpd`. The HAL has `startPtt`/`stopPtt`, and the mcu driver a
`handle_ptt` node.

## 5. Gap list: what baseline report A (beta.20, main `8a1420cf`) got wrong or missed

Report A: run 2026-10-28 12:43 with `scripts/w6/run_checks.sh`, watch = auto. Kept unscrubbed outside the repositories.

1. **USB loss not foreseen** (§1). The run lost the phone at the watch; the script gave up after 600 s while the
   report was already written. The report should warn, the script should accept a Wi-Fi serial, and the watch should
   end with the radio powered off.
2. **The watch leaves the MCU powered** (force-stop, §1): the phone is left without USB until a reboot.
3. **Audio devices and USB devices "(not readable)"**: both sections were read as the app, before the radio was on;
   they need root and must be taken again while the stock app runs (card 1 and `0483:5730` exist only then).
4. **The probe lists `/dev/ttyACM0` only after the watch** and skips it as held by the HAL (correct and safe), but
   offers no way to ask the module: an identity probe through the HAL's own path, or with the HAL stopped, is Phase C.
5. **The probe still sweeps `/dev/ttyS1` and `/dev/ttyS2`** at four speeds and sends `0x34` and `AT+DMO…` on them.
   Settings were restored ("line settings put back: yes"), but on a phone whose radio is known to be on `ttyACM` this
   is noise; when a vendor HAL holds a `ttyACM` port the summary should name it as the radio port.
6. **The stock-app serial trace saw nothing** (`sdtrace` on the app: 0 bytes) because the app talks HwBinder to the
   HAL; the trace has to follow the HAL process (pid of `…aguiextmodule@1.0-service`, `/dev/ttyACM0`), or read the
   app's `parseCmd` log lines, which the report already parses.
7. **The summary's verdict is misleading**: "radio module answered the version query: no … SignalDeck's probe did
   not reach the port it is on". It should say: radio behind a USB bridge on `/dev/ttyACM0`, held by HAL
   `IAguiExtModule`, module `DMR006.U4A.V067`, bridge `20201016161541`.
8. **No HAL detection in the draft profile**: `lshal` lines are listed, but nothing ties the HAL to the radio
   (HAL binary strings name `/dev/ttyACM0`, `/dev/snd/pcmC1D%u`, `/dev/stmcu`, `/sys/bus/platform/drivers/mcu/%s`).
9. **No MCU-envelope framing** in the draft profile (`7E 96 69 … 81`, route, checksum); the frames are only used for
   the "module answered" line.
10. **PTT**: the capture found no key (nobody pressed); input device list is good. The `hall-kpd` F12 needs a press
    test with the owner.
11. **The 32 kHz wire rate** is not found (the clue scanner reads the app's 48000).
12. **Platform devices**: it picked `mt_soc_tdmrx_pcm` as "looks like a radio module" (a name match on `pcm`); the
    real one is the `mcu` platform driver.

## 6. Phase B: is the running image on the phone?

No. Searched read-only as root on 2026-10-28:

- `/vendor/data/dmr/`: only `DMR006.U4A.V076.bin` (358 100 B, SHA-256 `4f5f287b…4d40fe`, the published research copy).
  `/vendor/data/mcu/`: the five bridge images (hashes as in `multi-device-atomxl-findings.md`).
- `find` for `*DMR0*`, `*U4A*`, `*intercom*` over `/`, `/vendor`, `/odm`, `/product`, `/system`, `/system_ext`,
  `/data`, `/mnt/vendor`, `/cache`, `/metadata`: nothing else. The HAL's other update path,
  `/storage/self/primary/intercom/dmr/`, does not exist. `/data/ota_package` is empty.
- The stock APK has no image (assets are three `.ogg` files).
- `grep -c "DMR006.U4A.V0"` over every named partition except `userdata` (read only): only `super` matches, three
  times: the V076 file name and its version string in the vendor image, and a string
  `DMR006.U4A.V067,DMR006.U4A.V076,DMR006.U4A.V080,DMR006.U4A.V082` in a factory-test app's resources
  ("DMR version" list), not an image.

The module runs V067, older than the V076 the phone carries for its updater. The stock updater did not offer an
update (`getLastestDmrFirware isDmrUpdate:0 … mDMRFirmwareDir:null`). Nothing was loaded and nothing will be.
