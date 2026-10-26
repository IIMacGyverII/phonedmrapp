# Promiscuous DMR receive — plan (2026-10-24)

Goal: a **promiscuous RX mode** for the DMR module — hear every call on the tuned
channel regardless of talkgroup/ID, color code, and (stretch) timeslot — toggled
on/off **from the app over UART, no reflash**.

**Scope / coordination.** This is the receive-filter work only. It is *separate*
from the 30 s TX cap (**FW19**) and the M17 work, which the other agent owns via
`radio_firmware/HANDOFF.md` — **do not edit HANDOFF.md or the M17 items.** This
note lives outside the shared firmware docs on purpose. All firmware findings here
are from *reading* the image (`radio_firmware/fw1_csky_objdump.txt`,
`HR_C7000_user_guide.pdf`); no firmware file was modified. Bench confirmation runs
through the other agent / the owner, not unilaterally.

Test vehicle: `tools/dmr-replay/` (HackRF capture→replay A/B) + the AURSINC duplex
hotspot and the BTECH 6X2. Band/power stay in scope rules as always.

**Implementation spec:** the concrete, all-sites-pinned patch set (this plan +
CC/slot telemetry #2a) is in **`docs/promiscuous-rx-patch-spec-2026-10-24.md`**.
This doc is the architecture / evidence; that one is the edit list.

---

## Architecture: three filters, three different places

A received DMR call is admitted only if it passes all of:

| Layer | Enforced in | Lever | Confidence |
|-------|-------------|-------|-----------|
| **Talkgroup / ID** | MCU software (`groups[32]` list) | bypass the RX match | high (mechanism proven on-air; exact branch not yet located) |
| **Color code** | HR-C7000 register `LOCAL_CC` | set `cc_opt = 1` ("match any CC") | high (register + legend confirmed; firmware already writes it) |
| **Timeslot** | HR-C7000 register `WORK_MODE` | `work_slot_sel` / DCDM dual-slot | low (needs bench) |

The TG filter is MCU software — proven on-air 2026-10-15 (`docs/grok-deep-dive/11…`
§19): the radio passes a group call iff its TG is in `groups[]`; private calls to
the radio's own ID always pass; `contactType=2` reports `0xFFFFFF` and drops audio.
CC and slot are done by the C7000 modem and configured via its MMIO registers.

---

## Layer 1 — Talkgroup / ID (MCU `groups[]`)

**Body layout** (163-byte `SET_DIGITAL_INFO` cmd 0x22, from `DigitalMessage.encodeBody`):

```
0..3 rxFreq | 4..7 txFreq | 8..11 localId | 12..139 groupList[32] (int LE)
140..143 txContact | 144 contactType | 145 power | 146 cc
147 inboundSlot | 148 outboundSlot | 149 channelMode | 150 encryptSw
151..158 key | 159 pwrSave | 160 volume | 161 mic | 162 relay
```

- Parsed by `cmd22_digital_unpack` @ `0x9310`; validated + byte-swapped (32-entry
  loop `+0x9606…+0x9632`); the 163-byte image is stored at RAM **`0x38E4C`**
  (confirmed: `cmd24_query_digital` @ `0x9E3C` replies 163 B from `0x38E4C`).
- `cmd2b_caller_info` @ `0xA808` builds the 9-byte caller report (callType, caller
  ID LE, target LE) from the received-LC source at `0x3250C` — this runs *after* a
  call is admitted, so it is not the filter itself.

**Confirmed MCU-side (not C7000).** The HR-C7000 manual has **no address/TG-match
register** — only a "Group address (24-bit)" LC field description. So the C7000
delivers every decoded frame with its group address, and the **MCU** decides
pass/mute. This matches the on-air §19 result and means the TG filter is a code
patch, not a register.

**Admit path traced** (receive handler `~0xC09E…0xC256`):
- reads the received LC target at `0x3250C + 8` and compares it to `0x800099`
  (`movih 128; addi 153`), and the call type at `[r9+4]` (`cmpnei …,1` → group vs
  private branch);
- gates RECEIVE-START — `status_post` @ `0x7E08` with byte **10** (group,
  `0xC1CA`) or **11** (private, `0xC256`) — on the getter **`0x2404`**, which just
  returns the flag `0x38B5C[0xAF]`. Non-zero = admit, zero = mute (`bez r0`).

**Still one hop out:** the code that *sets* `0x38B5C[0xAF]` by comparing the
received target to the stored `groups[]` (`0x38E4C + 0x0C … +0x8B`). Pin it by
finding writers of `0x38B5C[0xAF]` and the 32-entry compare loop, or localize it on
the bench (out-of-list TG + candidate patch). Also check `0x169F8` (match-with-
retry near `0xA808`) — confirm group test vs contact-name lookup.

**Toggle design (no reflash).** Build the bypass **conditional on a runtime flag**,
not unconditional:
- *(preferred)* **sentinel in `groups[0]`** — patch the match so a reserved value
  (`0x000000`; `0xFFFFFF` is taken by the all-call path) means accept-all. The app
  writes the sentinel to enable, a normal list to disable — rides the existing
  channel write, zero new protocol.
- *(alt)* a dedicated RAM flag byte set by a spare config field or a small command.

---

## Layer 2 — Color code (C7000 `LOCAL_CC`)

Register **`LOCAL_CC` @ `0x11000384`**:
- `[3:0] cc` — local color code (default 1).
- `[9:8] cc_opt` — **receive CC match mode** (manual §10.2.2.11, legend decoded):
  - `0` = match only when received CC is correct **and equals local CC**;
  - `1` = **match any correctly-received CC** ← promiscuous CC.

**The firmware already writes cc_opt.** In the CC-apply code:
- `+0x17de6` and `+0x17e0c`: `andi r2,r2,15; bseti r2,8` → writes `cc_opt = 1`
  (match any) in some modes;
- `+0x17e1e`: `andi r2,r2,15` with no `bseti` → `cc_opt = 0` (exact match).
Branch selection depends on internal mode flags (`r3==4`; `0x34808[0x28]`), not a
body field we control.

**Plan:** force `cc_opt = 1` on the exact-match store (`+0x17e26` region) when the
promiscuous flag is set; leave stock behavior otherwise. Tiny patch, confirmed
register semantics. (Bench first: it is possible stock already uses `cc_opt=1` on
normal RX — a hotspot CC1-vs-CC2 test settles whether wrong-CC calls pass today.)

---

## Layer 3 — Timeslot (C7000 `WORK_MODE`) — stretch

Register **`WORK_MODE` @ `0x11000100`** (mirror `0x104`): `[0] work_slot_sel`
(RX slot), `[1] is_aligned`, `[2] is_repeater`, `[4:3] layermode`, `[5]
is_continuemode`. The mode table lists **DMR DCDM = `0x6b`** (Dual-Capacity Direct
Mode, both slots). So the silicon can run both slots.

**Open (bench):** true both-slots-at-once monitoring needs (a) the C7000 to decode
both bursts in normal TierII RX, and (b) the MCU caller-info/audio path to handle
two concurrent calls. Investigate `work_slot_sel` / DCDM last; may end up
"promiscuous within a chosen slot" rather than both at once.

---

## Display — SignalDeck must show the received CC (and slot) in promiscuous mode

With `cc_opt=1` the radio hears calls on **any** color code, so the operator needs
to *see* which CC each call arrived on — otherwise promiscuous mode is half-blind.
Same for slot. The current caller report does not carry them: the `0x2B`
caller-info body is 9 bytes — `[0]` callType, `[1..4]` caller ID LE, `[5..8]`
target LE — **no CC, no slot**.

**The C7000 exposes both, read-only**, in `RX_TYPE_INFO` @ **`0x11000390`**
(manual §10.2.2.14): `[7:4] cc` (received color code), `[19] current_rx_slot`,
`[3:2] recv_sync_type` (00 MS / 01 BS / 10 TDMA1 / 11 TDMA2), `[11:8] data_type`.
The firmware already reads `0x11000390` (≈10 sites), so the value is in reach.

**Firmware side (part of the promiscuous patch):** at the moment a call is
admitted, read `RX_TYPE_INFO` and surface CC + slot to the phone — either by
**appending two bytes to the `0x2B` caller-info reply** (append-only keeps old
parsers working) or by a small dedicated query SignalDeck polls on RECEIVE_START.
Prefer appending to `0x2B` so it arrives with the call, no extra round-trip.

**SignalDeck side:** parse the new CC/slot bytes and show them per call in the
caller-info line / Last Heard / history (CC, slot, and the target TG it already
has). Only meaningful in promiscuous mode (normal channels have a fixed CC/slot),
so gate the display on the promiscuous flag. This is a required companion change —
promiscuous mode ships with CC/slot visibility, not after.

## One app toggle → all layers

"Promiscuous mode" in SignalDeck flips one runtime flag that gates the TG bypass,
the `cc_opt=1` write, and (if it pans out) the slot change — on/off over UART, no
reflash. Normal channels keep filtering.

Even fully promiscuous this stays a single-channel, (single-)slot conventional
monitor, not a trunking scanner.

---

## Test methodology (`tools/dmr-replay/`)

Capture each stimulus once, replay the identical IQ against stock vs patched
firmware; the firmware is the only variable. Score from the radio: un-mute +
`0x2B` caller-info.

- **TG/ID:** BTECH captures — in-list TG (baseline), out-of-list TG, private to a
  different ID. Rows `cc1_tg9_s1`, `cc1_tg100_s1`, `cc1_priv_other`.
- **CC:** record CC1 and CC2 to the same TG (BTECH). Rows `cc1_tg9_s1`, `cc2_tg9_s1`.
- **Slot:** duplex hotspot, TS1 vs TS2 traffic. Rows `hs_cc1_ts1`, `hs_cc1_ts2`.

A/B: `./dmrtest.sh STOCK` then `./dmrtest.sh PROMISC1`, diff the logs on matching
clips.

---

## Open items / next steps

1. **Locate the RX TG-match branch** (static read) — see Layer 1 pointers; or let
   the bench localize it (out-of-list TG + candidate one-line patch).
2. **Identify the mode flag** that selects `cc_opt` (`r3`, `0x34808[0x28]`) so the
   CC patch/flag is placed correctly; confirm whether stock already matches any CC
   on normal RX.
3. **Dual-slot feasibility** — `work_slot_sel`/DCDM, bench with the duplex hotspot.
4. Draft the conditional patches into `tools/fw-patch/patches.toml` (recording
   original bytes) **only when the firmware files are free** and the owner/other
   agent are ready; coordinate, don't touch HANDOFF.md.
5. SignalDeck: a "Promiscuous / monitor" toggle that writes the chosen flag;
   **per-call CC + slot display** fed by the extended `0x2B` reply (see Display
   section) — required, ships with the mode; help text; and as a no-firmware
   stopgap, a 32-slot monitor list (fills `groups[]`).

## Doc corrections owed (separate, hold per owner)

CLAUDE.md §3 and memory `radio-30s-transmit-timeout` still say cmd `0x3B` is
`min(tot,30)`; the handler at `+0xA308` stores the byte raw (no clamp). The other
agent now owns the TX-cap area (FW19), so leave those edits to them unless asked.
