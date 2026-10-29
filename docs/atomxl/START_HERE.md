# Atom XL agent: start here (state at 2026-10-28 23:15)

Read in this order:

1. `phonedmrapp/docs/handoff-atomxl-compat-2026-10-28.md` **on main** (the task, the hard rules).
2. `phonedmrapp/docs/atomxl-status.md` **on main**: the mailbox to the managing Claude agent (`phonedmrapp-06`, which
   also messages this session directly). Report there; commit only that file, `pull --rebase`, push. Its newest reports
   (21:15, 21:40, 21:50) and the managing agent's ordered list (Replies, 20:05; transmit rules 20:10) are the plan.
3. This folder (branch `atomxl/phase-a`, worktree `D:\Documents\code\personal\phonedmrapp-atomxl`):
   `PROGRESS.md` (log, newest first), `PHASE_A_FINDINGS.md` (measured facts, §1–§13; **§13 = today's bridge
   audio / reception-line / transmit facts**), `TRANSPORT_DESIGN.md`, `plan-firmware-loader.md` (needs a correction, below).

## Where things stand

- **Phone:** Atom XL, adb **`192.168.1.106:5555`** (Wi-Fi, persistent) and USB `ATOMXL0000000737` (the owner put in a
  data cable at ~19:40; the old one carried no data). USB drops while the radio is on. Check `ro.serialno` first.
  Left clean at 21:50: committed PR 76 build installed (transmit off), radio off, HAL running, stock app enabled,
  `usb_audio_automatic_routing_disabled` unset (as found). App block exemptions for SignalDeck are set (findings §12).
- **HackRF:** this agent's (cage, bench antenna), idle. **The owner cleared transmitting with the Atom XL** (cage,
  401.025 MHz, low power, N0CALL / bench IDs such as DMRTST-7; stay off 467.625 MHz and the hotspot frequency; heat
  limits AP 60 °C, battery 45 °C). The hotspot is not ours.
- **SignalDeck PR #76** (`atomxl/takeover-impl`, worktree `D:\Documents\code\personal\SignalDeck-atomxl`, base
  `grok/agold-envelope` = #73, with #72 merged in), head `fd4097f7`, host suite 460 / 0:
  - Atom XL profile (untested, transmit off);
  - take-over / Exit / Hand back through the bridge (bridge check before the stock app, wait for the USB disconnect,
    full controller reset, bring-up guard);
  - receptions from `/dev/stmcu` (power-up edges ignored, empty reads reopen);
  - per-reception USB capture with automatic bridge recovery, `sdalsa -q`, a read-only reader thread;
  - USB audio routing off while owning the radio; Agold text layout; App block guard;
  - DIAG `bringup` / `exit [--ez stock]` / `web --ez tx`.
  The stack stays unmerged until the managing agent reviews it (after receive works). Earlier report PRs: #60–#72.
- **Done and device-tested (all on PR 76, head `b058ac31`, host suite 461 / 0):** take-over / Exit / Hand back with the
  cable; boot (routing restored, stock app back); DMR group and private calls with caller; receive audio per reception
  with bridge recovery (−14.0 dBFS for 1 kHz at ±3 kHz); the **reception watchdog** (the bridge's line sticks until a
  phone reboot, the stock app then misses every call: control test 22:02, 0/9; SignalDeck detects receptions from RSSI
  meanwhile); DMR texts in (`0x36 [05]` push, `rw` 00, then `0x2D`) and out; APRS in (6/10) and out; DTMF in; REC;
  scanner; S-meter; FM / DMR voice / text / APRS transmit (bench build only); a clean Device report (`run_checks.sh -s
  192.168.1.106:5555 -w auto -t`). **Mailbox status REVIEW (23:12): the stack waits for the managing agent's review**
  and its decision on marking the profile verified with transmit on.
- **Open:** SSTV / POCSAG / SAME receive untested (same audio path as APRS / DTMF; long receptions get ~6 s gaps at
  each bridge stall); Android Auto not checked; stock-app channel import not done; owner: whether this unit may leave
  V067 (loader plan §3); the clean-room DMR generator for `tools/dmr-replay/` (approved).
- **Bench tools (local only, never committed; GPLv3 `dmr_utils3` in a scratchpad venv):** synthetic DMR call generator,
  4FSK DMR decoder (voice LC and data blocks), Bell 202 AFSK generator and decoder. Rebuild from these notes if the
  scratchpad is gone; a clean-room DMR generator for `tools/dmr-replay/` is approved. **Bench APK for transmit** = the
  committed source with ATOM_XL `verified` = true, built locally, never committed, never left installed.
- **Never:** another phone (the Armor `192.168.1.125:5555` / `5006AF1020002922`, the W6+ `W6202601000904`), `adb`
  without `-s`, `adb uninstall`, writing in `radio_firmware/HANDOFF.md`, loading firmware or sending `'1'` to the
  module's bootloader, leaving the transmit-enabled bench APK installed, a global setting changed and not restored.
