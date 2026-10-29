# Atom XL agent: start here (state at 2026-10-29 01:10)

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
- **SignalDeck main has the whole Atom XL stack** (PR 76 merged as `432bc60b`; profile **verified, transmit on**, owner)
  plus PR 79 (APRS 6/10 → 18/20: capture tail, decoder window flush, shorter empty-open wait), PR 80 (review follow-ups
  A2–A5, R2) and PR 81 (stock-channel import per area, DMR ID). **PR 82 open** (`run_checks.sh -r`: hand back and open
  without take-over, needed on verified phones). Start new branches from `main`; worktree `SignalDeck-atomxl`.
- **Device-tested on the Atom XL:** take-over / Exit / Hand back, boot, DMR calls with caller, receive audio per
  reception with bridge recovery, the reception watchdog, DMR texts in/out, APRS in (18/20) and out, DTMF in, SSTV in
  (Robot 36 clean), REC, scanner, S-meter, FM / DMR voice transmit, stock import, a clean Device report (with `-r`).
  SAME is not applicable (UHF-only radio); POCSAG receive needs the bench firmware (not on stock modules).
- **V076:** the stock route fails on this bridge build (`00 10 01` never powers the module, findings §10,
  `firmware-update-howto.md`). The module is healthy on V067. **Grok does the load** (owner's decision, radio_firmware
  HANDOFF queue item 6); give it a clean window when it asks for a lease in the mailbox (radio off, stock app closed,
  Wi-Fi ADB up), then run the V076 retest: the same captures (SignalDeck and stock app, FM and DMR), the reception line,
  `0x36`/`0x2B`, temperatures logged; the heat test only if V076 doesn't fix the cut-outs.
- **Open:** Android Auto; the occasional empty capture open (about 1 in 10, 8 s bridge power-cycle); the stuck
  reception line's root cause (a reboot clears it).
- **Bench tools (local only, never committed; GPLv3 `dmr_utils3` in a scratchpad venv):** synthetic DMR call generator,
  4FSK DMR decoder (voice LC and data blocks), Bell 202 AFSK generator and decoder. Rebuild from these notes if the
  scratchpad is gone; a clean-room DMR generator for `tools/dmr-replay/` is approved. **Bench APK for transmit** = the
  committed source with ATOM_XL `verified` = true, built locally, never committed, never left installed.
- **Never:** another phone (the Armor `192.168.1.125:5555` / `5006AF1020002922`, the W6+ `W6202601000904`), `adb`
  without `-s`, `adb uninstall`, writing in `radio_firmware/HANDOFF.md`, loading firmware or sending `'1'` to the
  module's bootloader, leaving the transmit-enabled bench APK installed, a global setting changed and not restored.
