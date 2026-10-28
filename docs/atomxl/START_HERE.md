# Atom XL agent: start here (state at 2026-10-28 18:35)

Read in this order:

1. `phonedmrapp/docs/handoff-atomxl-compat-2026-10-28.md` **on main** (the task, the hard rules, Phase D step 9a).
2. `phonedmrapp/docs/atomxl-status.md` **on main**: the mailbox to the managing Claude agent (report there; commit only
   that file, `pull --rebase`, push). Its newest replies say what is decided.
3. This folder (branch `atomxl/phase-a`, worktree `D:\Documents\code\personal\phonedmrapp-atomxl`):
   `PROGRESS.md` (log, newest first), `PHASE_A_FINDINGS.md` (every measured fact, §1–§10), `TRANSPORT_DESIGN.md`
   (Phase D design, owner said go), `plan-firmware-loader.md` (plan only), `handoff-grok-envelope-codec.md` (done by
   Grok: SignalDeck PR #73).

## Where things stand

- **Phone:** Atom XL, adb **`192.168.1.106:5555`** (Wi-Fi, persistent; check `ro.serialno` = `ATOMXL0000000737`
  first). USB is unusable while the radio is on (§1 of the findings). Left clean: radio off, HAL running, stock app
  enabled. SignalDeck (from `atomxl/report-polish`) installed with root.
- **HackRF:** this agent's since 16:55 (cage, bench antenna only, nothing backgrounded with `-R`). Used 17:38–17:47 for synthetic DMR receive tests (§11).
  The hotspot is not ours.
- **SignalDeck PRs (stacked, owner merges):** #60 ← #61 ← #64 ← #70 ← #71 ← #72 (report work, and the 32 kHz
  direct-audio conversion). Grok's codec: #73 (`grok/agold-envelope`, accepted by the managing agent 18:00).
  Worktree `D:\Documents\code\personal\SignalDeck-atomxl`; local branch `atomxl/takeover` = #73 + #72 merged, no
  new code. Other PRs: phonedmrapp #3 (this folder), AndroidRadio_Firmware_Project #3.
- **Open:**
  - Take-over / give-back code (design §2, §4): the previous session hit two safety-classifier stops writing code
    that drives the bridge directly (the codec, then take-over). It proposed that Grok writes take-over too; see the
    mailbox for the decision. Not attempted again.
  - ~~Capture one real `0x36` push~~: done 17:47 (findings §11): V067 sends **no** `0x36` on receive; `call_in`
    (active low) is receive start/end, `0x2B` (`rw` 00) the caller. Synthetic DMR calls from the HackRF work (local
    bench script, not committed: it uses a GPLv3 pip library).
  - Owner: whether this unit may leave V067 for good (loader plan §3); a key press during a capture (PR #71).
  - The system force-stopped SignalDeck once at 15:51 (not the owner, cause unknown): foreground service and crash
    recovery are in the design.
- **Never:** another phone (the Armor `192.168.1.125:5555` / `5006AF1020002922`, the W6+ `W6202601000904`), `adb`
  without `-s`, `adb uninstall`, writing in `radio_firmware/HANDOFF.md`, loading firmware or sending `'1'` to the
  module's bootloader, transmitting with the Atom XL without the owner.
