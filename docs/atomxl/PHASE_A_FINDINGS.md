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

What does (found 2026-10-28 13:50, owner-approved test): **power the MCU off, then toggle the MediaTek USB
controller's cable mode.** The release sequence, as root:

```
am broadcast -a agui.intercom.intent.action.STOP_DEVICE     # stock app running: stop() -> stopCom() -> HAL stopMcu()
                                                             # (SignalDeck owning the HAL: call stopMcu() itself)
echo 0 > /sys/devices/platform/11201000.usb3/cmode           # mtu3_phone: NORMAL -> CHRG_ONLY
sleep 1
echo 1 > /sys/devices/platform/11201000.usb3/cmode           # CHRG_ONLY -> NORMAL -> switch_port_to_device
```

Kernel: `musb_cmode_store NORMAL --> CHRG_ONLY`, `CHRG_ONLY --> NORMAL`, `ssusb_set_mode = 1`,
`switch_port_to_device`, `USB_STATE=CONFIGURED`; adb over the cable answered 2 s after the second write, the radio
stayed off. `cmode` read `1` before (standard MediaTek node, not Agold's). Tried first and **not** enough:
`sys.usb.config` none → adb (gadget pull-up ran, controller stayed in "none"), and `echo 0 > …/mcu/usb_path` (already
`usb mode = 0` after the power-off; `1` while the radio is on). `mcu_power` reads `power on = 0` when off. Every node
was read once with a marker in the kernel log first; nothing else was written.

Earlier finding, kept for the record: the power-off alone (no `cmode` toggle) is not enough. The stock app's own power-off was tested 2026-10-28 13:35: the broadcast
`agui.intercom.intent.action.STOP_DEVICE` (protected: the shell user is refused, root may send it) runs
`ExtModuleManager.stop()` → `stopCom()` → HAL `stopMcu()`. The kernel logged `mcu power 0`, `mt_usbhost_disconnect`,
`usb_intf_switch otg disable` and `/dev/ttyACM0` went away, **but the controller went to mode "none"**
(`ssusb_set_mode = 2`, `switch_port_to_none`), not back to device mode: `usb_state<DISCONNECTED>` every ~5 s, and
replugging the cable did not change it, although Android's port manager saw the cable (`connected=true`,
`data_role=device`). A reboot restored USB. (At boot the controller had never left device mode: `device -> host,
it's illegal`, so the later `otg disable` left the gadget working; that is why the boot-time power cycle did not cut
USB.) Whether a write to the mtu3 mode node or the `mcu` driver's `usb_path` brings device mode back is untested:
vendor nodes, owner's decision, one node at a time.

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
  is on, recommend Wi-Fi ADB, and at the end of the watch release the radio (`STOP_DEVICE`, then the `cmode` toggle)
  instead of a force-stop.
- **SignalDeck:** while SignalDeck owns the radio on this phone, USB is unavailable (no adb, no file transfer, no USB
  audio or Android Auto over the cable; charging still works). Exit and Hand back must power the MCU off (owner,
  2026-10-28), then toggle `cmode` (the release sequence above) so USB to a computer comes back; the pass list for
  both buttons includes "adb over the cable answers within 5 s". The in-app help for the Atom XL profile says that USB
  to a computer is off while SignalDeck has the radio.

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

## 7. Direct identity probe through `/dev/ttyACM0` with the HAL stopped (owner-approved, 2026-10-28 14:27)

**The module and the bridge answer a plain process on `/dev/ttyACM0`; no HAL is needed.** Hand test as root
(`probe_acm.sh`, kept outside the repositories), sending only the stock app's own two version queries:

| Step | What | Kernel |
|---|---|---|
| 1 | `stop aguiextmodule` (init service; the HAL process exits) | |
| 2 | `echo 1 > /sys/bus/platform/drivers/mcu/usb_path` | `usb_intf_switch otg enable`, `switch_port_to_host` |
| 3 | `echo 1 > /sys/bus/platform/drivers/mcu/mcu_power` | `mcu power 1`; `cdc_acm 1-1:1.3: ttyACM0` 0.7 s later |
| 4 | wait 2 s (as the stock app does after `startMcu`), `stty raw -echo` | |
| 5 | write `7e 96 69 00 01 01 00 01 01 fd fd 81` (bridge version) | reply `7e 96 69 00 01 00 00 0e "20201016161541" 8e a1 81` |
| 6 | write `7e 96 69 01 34 01 00 01 01 fc ca 81` (module `0x34`) | reply `7e 96 69 01 34 00 00 10 "DMR006.U4A.V067" 00 18 0d 81` |
| 7 | `mcu_power` 0, `usb_path` 0, `cmode` 0 then 1, `start aguiextmodule` | USB device mode back, HAL running |

- Both replies are byte-identical to the ones the stock app logged; their checksums verify. Requests are built like
  the stock app's `IComUtils.makePackage(cmd, rw, data)`: `7E 96 69`, route, cmd, rw (`01` request), length BE, data
  (`01` for both queries), the one's-complement 16-bit sum of route…data (an odd last byte in the high half), `81`.
- **`mcu_power` alone powers the bridge but does not switch USB to host** (first try: `mcu power 1`, the bridge's
  interrupt line toggled, no `ttyACM0` in 10 s). `usb_path` = 1 first is what the stock start-up does
  (`mt_usbhost_connect`, `usb_intf_switch otg enable`, then `store_mcu_power_on`).
- Afterwards the stock app started normally: `handleRecvFirmwareVersion … 20201016161541`, module V067, no update.
- **Hazard found in its code:** if the stock app gets no bridge version reply within 4 s of start-up it calls
  `updateMcu(null)` (`ExtModuleManager.getMcuFirmwareVersion`, the 4000 ms runnable), i.e. a bridge firmware update
  from `/vendor/data/mcu/`. Anything that leaves the bridge in a bad state must be undone before the stock app runs
  again, and SignalDeck's give-back must check the bridge answers its version query before re-enabling the stock app.
- So the Phase D transport can be the direct route: stop the HAL, own `ttyACM0`, power with `usb_path` +
  `mcu_power`, release with `mcu_power` 0 + `usb_path` 0 + `cmode` toggle + restart the HAL. Audio is then ours too
  (USB Audio card 1, 32 kHz). To be designed in `TRANSPORT_DESIGN.md`.

## 8. The HAL's power-up, and the bridge commands for a boot capture (2026-10-28 15:00–15:07)

Toward a non-destructive way to read a module's image (owner: V082 was seen on a user's phone; archive it if a
simple, reliable extraction exists). Phone in the Faraday cage; no PTT, no `'1'`, nothing written to the module.

**The HAL's `startMcu`, traced** (`sdtrace -p <HAL> -f /` during a stock-app start; the trace stalled after 6.4 s
and had to be killed, so attach for a fixed short window only):

```
usb_path    <- 1                    USB to host
mcu_power   <- 1
rstmcu      <- 0     (+750 ms)      the bridge's reset released
/dev/stmcu  read 00, 00, 01 (+1.7 s)  the bridge reports ready
/dev/ttyACM0 open, 115200 8N1 raw
00/01 version, 01/34 version, 01/22 channel, 01/2E volume
```

- **After a fresh boot the bridge does not enumerate without the `rstmcu` 0 write** (two attempts, 15:00, with and
  without the cable: host up, hub with one port, no device). The earlier direct probes worked because the stock app
  had released the reset since boot. Fixed recipe: `usb_path` 1, `mcu_power` 1, 0.75 s, `rstmcu` 0, wait for
  `ttyACM0`, 2 s.
- **Device mode → host is refused** (`device -> host, it's illegal`) in some states; the HAL goes through "none"
  (power off, `otg disable`, `otg enable`). A power-up that gets no port in 3 s does that cycle and retries.

**The bridge commands from the extraction note** (`temp/V082-EXTRACTION-HANDOFF.md`, from M17's write-up), each
checked with a framed `0x34` before and after:

| Frame | Expected | Seen on bridge `20201016161541` |
|---|---|---|
| `00 10` data `00` (module power off) | module off | **yes**: `0x34` stops answering |
| `00 10` data `01` (module power on) | module on | **no**: `0x34` still silent 4 s later |
| `00 08` data `01` (transparent bridge) | raw pass-through | nothing comes back at all (module off at the time) |
| native `68 34 01 01 95 b9 00 01 01 10` while transparent | module's own reply | nothing |

None of the four is acknowledged by the bridge. After a bridge power-cycle (`mcu_power` 0 then the recipe above) the
bridge and the module answer again (`20201016161541`, `DMR006.U4A.V067`). So the note's capture sequence does not
fit this bridge build; the stock updater's real sequence is in the HAL's `update_dmr_firmware` (static reading next),
and whether the module's bootloader can send its flash at all is still unknown.

## 9. The stock updater's bootloader entry, read from the HAL (static, 2026-10-28 15:10)

`vendor.mediatek.hardware.aguiextmodule@1.0-service` (42 464 bytes, SHA-256 `a36809a5…5ec89e91`, copied from the
phone as root; disassembled with the NDK's `llvm-objdump`, strings resolved from `adrp`/`add` pairs and the
`.rela.dyn` pointer table). `update_dmr_firmware`, from `0x6e9c`:

| Step | Code | Action | Wait after |
|---|---|---|---|
| 0 | `0x66b0` | its tty/`vendor.agui.extmodule.open` set-up | 4 s, then 1 s |
| 1 | `0x6450(fd, 0)`, log "stop dmr" | bridge frame route 00 cmd **0x10** data 00 (`setDmrOnOffState`: module off) | 4 s |
| 2 | `0x5748(1, 0)`, log "start ptt" | `/sys/bus/platform/drivers/mcu/handle_ptt` ← `0` (PTT held; idle reads 1) | 2 s |
| 3 | `0x6590(fd, 1)`, log "enter dmr update mode" | bridge frame route 00 cmd **0x08** data 01 | 2 s |
| 4 | `0x6450(fd, 1)`, log "start dmr" | bridge frame route 00 cmd 0x10 data 01 (module on), sent **after** step 3 | 2 s |
| 5 | `0x70e0` | `'1'` (`0x31`) via `Send_Byte` (`0x5fd8`); read up to 60 bytes until six `'C'` | — |
| 6 | `0x4e50` | YModem-1K transmit of `/storage/self/primary/intercom/dmr/<name>`, else `/vendor/data/dmr/<name>` | |

The sysfs name table at `0xa600` is `mcu_power`, `handle_ptt`, `rstmcu`, `usb_path` (indices 0–3). The order is
the one in the extraction note (and M17's), with the timings above. Nothing in the routine reads data back from the
module beyond the `C` count; there is no receive side.

**Bench check of step 4 outside update mode** (15:13, no PTT, no transparent mode): module off, 8 s, module on,
then a framed `0x34` every second for 10 s: **no answer at all**. The module answered before the off. Only a power
cycle of the whole bridge (`mcu_power` 0, then the §8 recipe) brings it back (`DMR006.U4A.V067`). So on this bridge
build `00 10 01` does not bring the module back to a state that answers framed commands; whether it powers the module
into its bootloader when PTT is held and transparent mode is on (the only way the stock updater uses it) is untested.

**What that leaves for a non-destructive extraction:** the stock path is send-only. The open question is whether the
module's bootloader offers anything besides `'1'` (download). That is answered by listening after steps 1–4 and
sending nothing, with PTT held: a transmit risk if the bootloader is not entered (the module would boot its
application with PTT asserted), so in the cage, with the owner's go.

## 10. Listen-only bootloader test (owner's go, Faraday cage, 2026-10-28 15:17)

The stock updater's steps 1–4 (§9) with its timings, then nothing sent for 16 s; the port read from before step 1
to the end (26 s, 115200 raw, `boot_listen.sh` kept outside the repositories). Never `'1'`; a shell trap released PTT
on any exit; PTT released before the bridge was powered off.

- **0 bytes** in the whole window: no banner, no menu, no `C`.
- Before and after: bridge `20201016161541`, module `DMR006.U4A.V067` (framed `0x34`), both checksums ok; HAL
  restarted; `handle_ptt` back to 1. No HackRF was used, so whether the module keyed meanwhile was not measured.
- Reading: the bootloader, if it was entered, says nothing until it is sent a key; the stock updater sends `'1'`
  straight away without reading a menu (§9), which fits. The Armor's bootloader of the same family is also only ever
  seen answering `C` after `'1'`.

**Verdict for "extract V082 from a user's phone":** there is no read path in the stock software. The stock app and
the HAL only send; the module's application has no flash read command (V076's dispatch, §§ of
`multi-device-atomxl-findings.md`); the bootloader offers nothing unprompted. What is left is guessing other keys at
the bootloader (unknown effects, possibly erase or execute: not done), loading our own image with a read command
(erases the original first: defeats the purpose), or a physical SPI read of the module (opening the phone). So V082
has to come from a file: a newer Unihertz package or OTA, the stock app's download (its allow-list names
V067/V076/V080/V082, so builds with those files existed), or the vendor. Once one V082 file exists, a SignalDeck check
can tell a user's module apart by its `0x34` reply without reading the flash.

## 4. PTT key (press-tested with the owner, 2026-10-28 13:17)

- **The app receives it as `android.intent.action.PTT.down` / `android.intent.action.PTT.up`** (and `.PTT.timeout`),
  the same pair as the Armor's: `IComService` registers them; the manifest's `IComReceiver` starts the app on
  `PTT.down` when its service is not running. Also registered: `agui.intercom.intent.action.START_PTT` / `STOP_PTT` /
  `PTT_TIMEOUT` / `STOP_DEVICE` / `OPEN_TEST`, `agui.intent.action.AUTO_EXIT` (read from the APK, SHA-256
  `26bd68cc…05ccb`; to confirm on the phone with the stock app up).

- **The side PTT key is `mtk-kpd` (event2), Linux key code 249 (`0x00f9`).** Two presses, both seen: 0.39 s and
  0.95 s, clean DOWN/UP pairs. It is **not** the `KEY_F12` the earlier reports saw (that is `hall-kpd`, the cover
  sensor).
- Key layout `/system/usr/keylayout/mtk-kpd.kl`: `key 249 FUNC1` → Android keycode **289**, a vendor keycode
  beyond AOSP's list (Android 11 ends at 288). The framework sees it in `interceptKeyBeforeQueueing keyCode:289`.
- Agold's framework hooks it first (`AguiShortcutFunction` / `A35ShortcutFunction: <ShortcutInterceptKey> …
  mIsPTTDown:false, isPTT:0`): with the radio off and the stock app not running it was not treated as PTT. Whether
  it becomes a broadcast to the app (`ro.agui.smartkey_ptt=com.agold.intercom`) when the stock app runs, and what
  that broadcast is called, is still open (read the stock app's receivers; capture once with the stock app up).
- The HAL also has `startPtt`/`stopPtt` and the `mcu` driver a `handle_ptt` node: those key the radio, they are not
  the key.

## 5. Gap list: what baseline report A (beta.20, main `8a1420cf`) got wrong or missed

**Status (2026-10-28 16:15), SignalDeck PRs stacked #60 ← #61 ← #64 ← #70 ← #71:** 1–3 #60 (release after the
watch, warning, USB/audio while the radio is on); 4 #64 (identity probe through the bridge); 5 #71 (bridge first,
no UART sweep); 6–9 #61 (bridge port and holder, the verdict, HAL/HIDL clues, the envelope in the draft); 10 #71
(vendor keycode; press test owed); 11 #61 (32 kHz from the stream); 12 #61 (the draft names the real port, not the
`pcm` name match). `report.json` + `scripts/report_diff.py` #70.

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
10. **PTT**: the capture found no key (nobody pressed). The real key is `mtk-kpd` code 249 / keycode 289 (§4);
    the report should name a vendor keycode above the AOSP range as a PTT candidate.
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
