# Atom XL progress log

Newest first. Phone: Unihertz Atom XL, `ATOMXL0000000737`, worked over Wi-Fi ADB `192.168.1.106:5555` (see
`PHASE_A_FINDINGS.md` §1). Handoff: `docs/handoff-atomxl-compat-2026-10-28.md`.

## 2026-10-28

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
