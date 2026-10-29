# Atom XL progress log

Newest first. Phone: Unihertz Atom XL, `ATOMXL0000000737`, worked over Wi-Fi ADB `192.168.1.106:5555` (see
`PHASE_A_FINDINGS.md` §1). Handoff: `docs/handoff-atomxl-compat-2026-10-28.md`.

## 2026-10-28

- **19:55** Cable pass list (owner swapped the USB cable; the old one carried no data, which is why USB "never came
  back" earlier). Found and fixed (PR #76 `d3357260`): Hand back's bridge check took the still-present old port node
  for the new port, kept the stock app paused (safe) and left a ghost `ttyACM0` until a reboot; every power-up now
  waits for the old node first. Then 4 cycles: take-over drops USB in 1–2.5 s, Exit gives USB adb back in 7.5–8 s,
  Hand back in 21–21.5 s with the stock app enabled, no ghost, HAL running. Also: with the display asleep SignalDeck's
  main thread can block in SurfaceFlinger, so adb DIAG broadcasts time out (ANR); keep the screen on when benching.

- **18:55** Owner: this agent writes take-over. **SignalDeck PR #76** (`atomxl/takeover-impl`, on #73 + #72): Atom XL
  profile (untested, transmit off), take-over / Exit / Hand back through the bridge, receptions from `/dev/stmcu`,
  caller asked around the capture, App block guard; device-tested for receive (findings §12). Corrections: route 02 =
  audio-stream reports (not receive edges), `call_in` unreliable, frames cut at 12 bytes while audio streams. Found the
  15:51 force-stop: Agold App block. Open: receive audio in SignalDeck dies with an I/O error (by hand it runs fine);
  USB-to-PC check needs a data cable. Phone left clean (radio off, HAL running, stock app enabled).

- **17:55** Correction to 17:47: `0x2B` is the reply to the stock app's own query (its 12-byte write at `call_in`
  falling); the unsolicited receive frames are **route 02 `0x67 01` (start) / `0x66 01` (end)**. Owner decided this
  agent writes take-over/give-back (not Grok).

- **17:47** **DMR receive measured with the HackRF** (stock app on its own channel, synthetic calls, nothing keyed;
  `PHASE_A_FINDINGS.md` §11): TG 1 group and private-to-own-ID calls decoded (`0x2B` with the sent caller/target),
  TG 9 dropped (Armor's `groups[]` rule holds); **no `0x36`/`0x26` push on receive**, the only module push is `0x2B`
  (`rw` 00); receive start/end = `call_in` sysfs, active low (read 1/0/1). Route 02 `0x67`/`0x66` are the bridge's
  answers to the stock app's play start/stop. Design §3/§5/§9 updated: the transport synthesizes receive start/end
  from `call_in`. Take-over code still waits on the mailbox decision.

- **17:10** Owner: design go; the 15:51 force-stop was not the owner (cause not found: no DuraSpeed, `com.agui.appblock`
  holds FORCE_STOP_PACKAGES but has no data; logs rotated): a foreground service and crash recovery are required.
  HackRF is this agent's since 16:55 (handoff updated by the managing agent): cage, bench antenna only. The envelope
  codec is handed to Grok (`handoff-grok-envelope-codec.md`, owner's decision); this agent continues with the profile,
  take-over/give-back, USB audio and receive tests.

- **16:10** `TRANSPORT_DESIGN.md` written for the owner (direct `ttyACM0`, envelope codec under `RadioEngine`, take-over
  and give-back with the bridge check, USB ALSA at 32 kHz via `sdalsa`, `handle_ptt` active low). USB audio capture
  works on the direct route (494 kB in 3.9 s, idle content 0 / -32768). HAL `startPtt`/`stopPtt` = `handle_ptt` 0/1
  plus `vendor.agui.extmodule.start` 1/0. The stock app ignores `0x26` pushes; it polls its call-in line. SignalDeck was
  force-stopped by system_server at 15:51 (no trigger in the log): asked the owner. SignalDeck PRs: #60, #61, #64, #70
  (stacked in that order). No engine code until the owner has read the design.

- **15:17** Listen-only bootloader test (owner's go, cage; Phase A §10): the stock entry (off, PTT held, update mode,
  on), then 16 s of listening: 0 bytes. Never `'1'`. Both chips answer afterwards. Verdict: no read path in the stock
  software; V082 must come from a file. For the managing agent: the Agold bootloader is silent until keyed, like the
  Armor's; and the loader rule "the vendor copy is the backup" does not hold on Agold phones (vendor V076, module V067).

- **15:14** HAL `update_dmr_firmware` read statically (Phase A §9): module off (00 10 00), 4 s, `handle_ptt` 0, 2 s,
  transparent (00 08 01), 2 s, module on (00 10 01), 2 s, `'1'`, YModem. Bench: `00 10 01` outside update mode never
  brings the module back (10 s); a bridge power-cycle does. Listen-first with PTT held needs the owner's go (cage).

- **15:07** Extraction groundwork (owner's note `temp/V082-EXTRACTION-HANDOFF.md`; Phase A §8): traced the HAL's
  `startMcu` (adds `rstmcu` 0 after power; without it the bridge never enumerates after a fresh boot); the note's
  bridge commands tested one by one: module power off works, power on does not, transparent mode passes nothing; the
  module and bridge answer again after a bridge power-cycle. No PTT, no `'1'`, nothing written. SignalDeck PR for the
  report's bridge probe needs the `rstmcu` step before it is opened. Next: read the HAL's `update_dmr_firmware`
  statically for the stock updater's real sequence.

- **14:27** **Direct identity probe works** (owner-approved hand test, Phase A §7): HAL stopped, `usb_path` 1,
  `mcu_power` 1, `/dev/ttyACM0` in 0.7 s; the bridge answered `20201016161541`, the module `0x34`
  `DMR006.U4A.V067`, byte-identical to the stock app's log, checksums verified. `mcu_power` alone does not switch USB
  to host. Cleanup restored USB and the HAL; the stock app then started normally (no bridge update). Hazard: the
  stock app updates the bridge firmware if it gets no version reply in 4 s. Next: build the probe into the report,
  then `TRANSPORT_DESIGN.md` (direct route).

- **14:25** SignalDeck PR #61 (stacked on #60): draft profile in the report and `00_SUMMARY.txt`, PTT broadcasts and
  HIDL interfaces from the stock app's code, the bridge port/label/holder while the radio is on, a correct verdict
  for a bridged phone. Atom XL draft right field by field (pttKey unknown: no press during that run). Found: the
  handoff's "draft profile / report.json in main via PR 48" was not so; neither existed (W6 gaps B7/B13 open), so the
  draft is built here and `report.json` + `report_diff.py` are next. The identity probe through the envelope needs
  the radio powered without the stock app: approach to agree with the owner.

- **14:00** SignalDeck PR #60 (`atomxl/report-usb-release`): the report's stock-app watch releases the radio
  (STOP_DEVICE, wait for `mcu_power` = 0, `cmode` toggle) before its force-stop, lists USB devices and sound cards
  while the radio is on, and warns. Atom XL over Wi-Fi with the cable in: USB gone 13:58:51, back 13:59:09 by itself.
  Lesson: `/dev/ttyACM0` outlives the power-off while the HAL holds it; wait on `mcu_power`. Firmware repo PR #3
  open (V067 variant, catalogue serial 6). Next: gap items 4–12 (HAL/ttyACM detection and verdict, envelope identity
  probe, 32 kHz, PTT keycode 289, draft profile fields).

- **13:50** **USB released without a reboot** (owner-approved node test): after `STOP_DEVICE` (MCU off), `echo 0` then
  `echo 1` to `/sys/devices/platform/11201000.usb3/cmode` puts the controller back in device mode; adb over USB
  back in 2 s. Not enough on their own: `sys.usb.config` toggle, `usb_path` = 0. This is the recipe for SignalDeck's
  Exit and Hand back (Phase A §1).

- **13:40** Stock app read (jadx, APK SHA-256 `26bd68cc…05ccb`): the PTT key arrives as `android.intent.action.PTT.down`
  / `.up` / `.timeout` (the Armor's pair); clean power-off is `agui.intercom.intent.action.STOP_DEVICE` (protected,
  root only) or `agui.intent.action.AUTO_EXIT` → `stop()` → `stopCom()` → HAL `stopMcu()`. Tested STOP_DEVICE: MCU off,
  ttyACM0 gone, **but USB stayed down (controller mode "none") even after a replug; only a reboot restored it**.
  Corrected Phase A §1, the CLAUDE.md row and the firmware repo's device page.

- **13:20** Owner requirement for the transport design: SignalDeck's **Exit** and **Hand back to the stock app**
  buttons must both power the radio MCU off (HAL `stopMcu`, `mcu power 0`) so the USB port returns to device mode;
  a force-stop is not enough (Phase A §1).
- **13:17** PTT press test with the owner: side key = `mtk-kpd` code 249 → `FUNC1` → keycode 289 (Phase A §4).

- **13:15** Wrote `PHASE_A_FINDINGS.md` (USB/radio disconnection, identity, gap list, Phase B search) and the
  correction block at the top of `docs/multi-device-atomxl-findings.md`. Next: PTT press test with the owner, then
  the "image not on the phone" note on the firmware repository's device page and the firmware-work note below.
- **13:10** Rebooted over Wi-Fi to put the MCU off and USB back (force-stop had left it in host mode).
- **13:08** Controlled test over Wi-Fi with the cable plugged in: `am start` of the stock app → USB adb gone at +1 s,
  `/dev/ttyACM0` at +7 s; kernel `usb_intf_switch otg enable` / `switch_port_to_host` / `mcu power 1`. Bridge USB
  `0483:5730` (USB Audio 32 kHz stereo + CDC-ACM). `am force-stop` did not power it off (12 s, USB still gone).
- **13:07** Wi-Fi ADB made persistent (`persist.adb.tcp.port=5555`, root) and proven across a reboot.
- **12:43–12:45** Baseline report A (SignalDeck 1.0.0-beta.20 release from main `8a1420cf`, root granted via the
  Magisk policy table, `run_checks.sh`). The phone left USB at the stock-app watch; the owner rebooted it. The report
  had finished at 12:45; pulled over Wi-Fi. Module answered the stock app **`DMR006.U4A.V067`**; bridge
  `20201016161541`.
- **12:15–12:40** Phase A identity and Phase B search (read only). Root OK (Magisk 31.1). No V067/V082 image on the
  phone; only V076 (published research copy, same hash). Details in `PHASE_A_FINDINGS.md` §6.

## For the managing Claude agent (firmware side)

- The bench Atom XL runs **V067**, not V082. Neither V067 nor V082 is on the phone; the phone carries V076 (updater
  copy, already in AndroidRadio_Firmware_Project as research, `factory: false`).
- What firmware work needs, later: (1) the running image (V067 here), which can only come from the module itself
  (needs a read-back that does not exist for this module) or from another source; (2) how `updateDmr` reaches the
  module: the HAL enters the module's update mode and sends YModem (`update_dmr_firmware enter dmr update mode`,
  `Ymodem_Transmit`) through the bridge, from `/vendor/data/dmr/` or `/storage/self/primary/intercom/dmr/`; a capture
  of one stock update is the owner's decision; (3) the bridge MCU (STM32, `0483:5730`, DFU `0483:df11` via
  `/vendor/bin/auto_update`) wraps the module's UART in the `7E 96 69` envelope and carries the audio as USB Audio at
  32 kHz. Nothing was loaded; no update mode was entered.
