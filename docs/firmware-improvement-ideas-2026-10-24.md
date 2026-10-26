# Firmware improvement candidates (2026-10-24)

Grounded ideas for the DMR module firmware, beyond promiscuous RX
(`promiscuous-rx-plan-2026-10-24.md`). All are *reading*-based proposals — no
firmware file was modified. Scope rules hold: **band limits (136–174 / 400–480
MHz), TX power and RF-regulatory protection are out of scope**; TX/RX audio,
receive telemetry and operator settings are in.

**Owned elsewhere — do not take these:** the 30 s TX time-out (**FW19**), the M17
TX/RX routes, and the generic waveform engines are the other agent's, tracked in
`radio_firmware/HANDOFF.md`. Listed here only so we don't duplicate them.

Priority = value × confidence ÷ effort, best first.

| # | Candidate | Value | Effort | Risk | Notes |
|---|-----------|-------|--------|------|-------|
| 1 | Promiscuous RX (TG/CC/slot) | high | M | med | plan + **patch spec** (`promiscuous-rx-patch-spec-2026-10-24.md`, all sites pinned, built with 2a) |
| 2a | RX telemetry — **DMR CC + slot** | high | S | low | **confirmed 2026-10-24**: firmware already reads `RX_TYPE_INFO`; append to `0x2B` |
| 2b | RX telemetry — analog CTCSS/DCS **received code** | — | — | — | **investigated — not feasible**: AT1846S has no readback for an unknown tone/code |
| 3 | ~~Real per-level squelch 1–9 (firmware)~~ | low | — | — | **investigated — not worth it; do app-side** |
| 4 | Channel-write "no RF" hardening | med | M–L | med | latent wedge bug |
| 5 | True all-call monitor audio | med | S | low | folds into promiscuous |
| — | Wide/flat audio user mode | med | M | med | overlaps M17 agent; coordinate |
| — | Faster RSSI after retune | low | ? | — | likely RF-settling bound |

---

## 2. RX telemetry enrichment — report what the hardware already knows

Today the `0x2B` caller-info reply is 9 bytes (callType, caller ID, target) — no
CC, slot, or sub-audible code. Investigated both halves at the register level on
2026-10-24. They split: the DMR half is a real, low-risk win; the analog
"received code" half is confirmed **not feasible** on this hardware.

### 2a. DMR color code + slot — confirmed feasible, low risk

`RX_TYPE_INFO` @ `0x11000390` holds received `cc [7:4]`, `current_rx_slot [19]`,
`recv_sync_type [3:2]`, `data_type [11:8]`. **Verified the firmware already reads
it** — 10 reference sites; e.g. at `0x1832e` it `ld.w`s the full 32-bit word into a
temp and bit-extracts fields at runtime (`lsri …,22; andi …,1`), keeping derived
state in RAM (`0x4c7bc` region). So CC and slot are sitting in a word the firmware
already has in hand at receive time.

**Shape:** at the moment a call is admitted, read `RX_TYPE_INFO`, mask CC `[7:4]`
and slot `[19]`, and **append two bytes to the `0x2B` caller-info reply**
(append-only keeps old parsers working). SignalDeck shows per-call CC/slot in the
caller line / Last Heard / history. This is the same read the promiscuous plan's
Display section needs, so build the two together. Low risk — the register is
already populated and already read.

### 2b. Analog CTCSS/DCS received code — investigated, NOT feasible

The goal was to display the **received** (unknown) CTCSS tone / DCS code — turning
CLAUDE.md's "DCS code display from audio infeasible" into a feature by reading the
AT1846S directly instead of the audio. **The hardware does not support it**, proven
from the AT1846S programming guide (v1.4) and the firmware:

- The datasheet's **"Only read register"** section exposes exactly four quantities:
  `0x1B` RSSI + noise (`rssi_db`/`noise_db`), `0x1A` vox + mic. **There is no
  register that outputs a measured incoming CTCSS frequency or a decoded DCS code.**
- Register `0x1C` ("Flag") is **compare-result bits only**: `ctcss1_cmp`/
  `ctcss2_cmp`, `cdcss1_cmp` (positive-code match), `cdcss2_cmp` (negative-code
  match), `invert_det`, `sq_cmp`. It tells you whether the sub-audio matches the
  tone/code you **programmed** into `0x4A–0x4E` — never what an unknown incoming
  tone/code *is*. (The firmware reads `0x1C` 8× in the squelch decision path
  `0x3790–0x3c76`, masking exactly these bits — `andi …,0x100`/`0x300`/`0x20` — and
  mirrors the raw word to RAM `0x3a81c`.)
- OpenGD77 (DCS on this same chip) confirms RX is "handled as with CTCSS":
  program-and-match, and the chip doesn't even do the Golay(23,12) decode.

To *identify* an unknown tone/code you would have to **scan** — program each of ~50
CTCSS tones / ~104 DCS codes (×2 inverted) into `0x4A–0x4E` and watch `0x1C` — which
is slow and, worse, those registers are owned by the live squelch, so scanning
breaks reception while it runs. Not worth it. The earlier "infeasible from audio"
verdict holds for a deeper reason: the silicon itself only confirms a programmed
code, it never decodes an unknown one.

**The one free scrap:** since the firmware already mirrors `0x1C` to RAM `0x3a81c`,
a "configured tone present" lock flag (CTCSS/DCS match ✓/✗ for the channel's *own*
tone) is trivial to surface. Marginal value — SignalDeck already knows the channel's
configured tone, so this only confirms presence — so it is an optional nicety that
can ride 2a's extra bytes, not a feature on its own.

## 3. Per-level squelch (1–9) — investigated 2026-10-24: NOT worth it in firmware

**Conclusion: do not patch the firmware; do it app-side in SignalDeck instead.**

Traced the full path. One writer of AT1846S reg `0x49` (`at1846_set_squelch`
`0x30A4`), called from one place (`0x30D8`):
- `0x30A4` *can* graduate — it builds a 16-bit open/close threshold with
  hysteresis, so the register is not the limit.
- `0x30D8` computes that threshold from a per-band **calibration table**
  (`0x3CD94`, the same cal table as the deviation constants), indexed by a
  signal/mode-derived value, with a small adjustment and a **fixed +2 hysteresis**
  (`open = close + 2`, `0x3136 addi r1,r0,2`). There is **no 9-entry level→threshold
  table**; the user's 1–9 byte does not select a graduated threshold.

So the on-air result (CLAUDE.md §3: levels 1–9 all behave as one threshold near
−90 dBm) is exactly what the code predicts. Why a patch isn't worth it:
1. Making 1–9 distinct means injecting `level×step` into a **shared RF-cal path**
   (`0x3CD94`) — mistakes ripple across bands.
2. The AT1846S RSSI squelch is coarse near −90 dBm: the on-air sweep showed a
   ~13 dB window (−94 closed → −81 open) where it flips nearly binary. Distinct
   register values buy a few dB per level, not a clean 9-step ladder.
3. **Redundant** — SignalDeck already reads RSSI (`0x32`, accurate ~0.7 s after
   retune) and uses `sq=0` + software decode for data modes.

**Better path:** extend SignalDeck's existing Soft SQ into a real 9-level software
squelch mapped to dBm thresholds off `0x32` RSSI. Predictable, per-level, no
firmware patch, no cal-path risk.

**Could we just edit the cal table `0x3CD94`?** Evidence says it's a **static,
read-only shared default** baked into the image: it lives in IRAM
(`0x10000–0x50000`), all 18 code refs are address-loads feeding `ld` reads (no
runtime writer found), and the firmware never reads the protected factory flash
region (`0x03000000–0x03019FFF`). So it is one table for every unit — the vendor's
conservative "works across all radios without per-unit trim" value, which is likely
*why* the levels don't graduate. Editing it is possible but a bad idea: (1) confirm
first it isn't written by the AT1846S self-cal at boot (`at1846_init 0x2BAC`) or a
patch won't stick; (2) it is the **same table the deviation / TX-limit constants
use** (read by the analog-apply path), so a wrong value risks TX deviation and RF
behavior, not just squelch; (3) squelch cal interacts with RSSI/AGC, so a bad value
makes the radio deaf or noisy. High blast radius, coarse payoff — don't.

## 4. Channel-write "no RF" hardening

CLAUDE.md §3a: sending `syncChannelInfoWithData()` and a direct `AnalogMessage`
back-to-back intermittently leaves the MCU reporting `SEND_START`/`SEND_STOP`
normally but **radiating no RF**, and the state survives reboots (recovered only by
a single-path channel write). SignalDeck already avoids the pattern, so this is
hardening, not a live bug — but a firmware fix that makes the two apply paths
mutually safe (or ignores a redundant second write mid-transaction) removes a
latent foot-gun for any client. Needs the two apply paths (`apply_analog_config`
`0x7A30` + the direct `AnalogMessage` handler) understood and the race identified;
medium–large and bench-heavy, so lower than 2/3 despite the value.

## 5. True all-call monitor audio

CLAUDE.md §3: `contactType = 2` (ALL/RECEIVE_ALL) reports `0xFFFFFF` and **drops
audio** — so the existing "monitor" path gives metadata but no sound. A small fix
to pass audio on all-call would be a no-flag "hear everything" that is weaker than
full promiscuous (still CC/slot-bound) but trivial. Likely folds into the
promiscuous work (same receive handler), so build it there.

---

## Deferred / probably not worth it

- **Faster RSSI after a retune** (the ~0.7 s settle, CLAUDE.md §3): the module only
  answers `0x32` once its next reading is ready and reads are 15–20 dB low for
  ~0.6 s. This is most likely AT1846S RF/AGC settling, not a software delay, so a
  firmware change probably can't shorten it. Measure before investing.
- **Scanner NAK on digital channels with no TX contact** (CLAUDE.md §7 scanner
  note): a small quirk the app works around; low value.

## Next steps

Pick any of 2/3/5 as a quick, low-risk win (2 is the most useful). Each needs the
firmware files free and a bench pass, coordinated with the other agent — none
touch `HANDOFF.md`, FW19, or the M17 routes.
