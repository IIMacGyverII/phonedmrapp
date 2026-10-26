# Promiscuous RX + CC/slot telemetry — implementation-ready patch spec (2026-10-24)

Consolidates firmware idea **#1 (promiscuous RX)** and **#2a (DMR CC + slot
telemetry)** into one patch set, because they share the same receive handler and
the same `0x2B` reply extension. All addresses are **file offsets** in
`radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` (XIP runtime = `0x0301A000 +
offset`), verified against `radio_firmware/fw1_csky_objdump.txt` on 2026-10-24.

> **Status: SPEC ONLY — no bytes cut.** Every finding is from *reading* the image.
> Do not modify firmware files or `radio_firmware/HANDOFF.md` until the files are
> free and the owner / other agent are ready. **`cmd 0x40` is taken by the M17 TX
> stream** (the other agent, `symbols.csv` slot `+0x382B8`) — do not reuse it.
> Band limits / TX power / RF-regulatory stay out of scope.

> **Review 2026-10-25 (Claude, owner decision: build now, bench with the hotspot).** Approved as written with five
> amendments: (1) **the toggle is a new op on command `0x40`** (the bench command with sub-ops 1–14, NAKed by stock
> firmware): one byte, 0 off / 1 on, readable back; neither the `groups[0]` sentinel nor a new `phone_dispatch` slot
> is used (§0 stays as the record of why). (2) **Measure the free stub space first:** `zero_tail` was 1,788 B before
> the M17 and generic-engine stubs; if FW25 left too little, find and record a second free region before cutting
> anything. (3) **Build on the FW25 lineage as FW26** with its tag, so one image carries everything; the flag off
> must be byte-identical behaviour. (4) **SignalDeck's `0x2B` parser accepts 9 or 11 bytes** and shows the received
> CC and slot on the caller line, Last heard and history only while the mode is on; the toggle lives beside MON on
> digital channels, with help and changelog. (5) **The A/B rows wait for the hotspot** (the replay library is empty;
> the hotspot is the controllable transmitter the capture matrix needs): the stubs, the patch set, the SignalDeck
> side and a dry run of the A/B script against a synthetic 11-byte reply are built and host-checked now. Patch C
> stays deferred. Band limits, power and transmit remain out of scope.

Technique throughout: small **stubs in the free tail space** (`zero_tail`, XIP
`0x03074EFC`, 1,788 B, where the R4m+ M17 stubs already link — coordinate the
offset so we don't overlap them) with a **handful of call sites redirected** to
them. Each stub is **conditional on one runtime promiscuous flag**, so stock
behavior is byte-identical when the flag is off, and the whole thing toggles from
the app with no reflash. Record original bytes in `tools/fw-patch/patches.toml`;
tag the version string so `0x34` reports what is in flash.

---

## 0. The toggle — one runtime flag, no reflash

One promiscuous flag gates all three patches. Two ways to carry it; pick at build:

**(A) Sentinel in `groups[]` (preferred — rides the existing channel write).**
The digital body lands at RAM `0x38E4C`; `groups[32]` starts at `+0x0C`
(`0x38E4C+0x0C`), 32 × int32 LE. The app writes a reserved value into `groups[0]`
to enable; a normal list disables.

- **Sentinel value — corrected.** The earlier plan said `groups[0]==0x000000`.
  **Do not use 0** — an unused `groups[]` slot is plausibly 0, so a channel with no
  first group would read as promiscuous by accident. Use a value **outside the
  valid 24-bit TG range** so it can never be a real talkgroup and is distinct from
  the empty-slot fill: candidate **`0x01000000`** (bit 24 set). `0xFFFFFF` is
  already the all-call marker — don't use it.
- **Open check before building:** `cmd22_digital_unpack` @ `0x9310` validates +
  byte-swaps the 32-entry list (loop `+0x9606…+0x9632`). Confirm a `0x01000000`
  entry survives that loop unchanged (not rejected, not truncated to 24-bit). If it
  is mangled, fall back to (B).

**(B) Dedicated RAM flag byte (fallback).** A spare byte in RAM set by a small new
phone command. Needs a **free `phone_dispatch` slot** (table `0x38240`, indexed
`cmd−0x22`) — **not `0x40`** (M17). Slightly more protocol, but immune to the
`groups[]` validation question.

All stubs below read "promiscuous?" the same way: **(A)** `*(u32*)(0x38E4C+0x0C) ==
SENTINEL`, or **(B)** the flag byte. Keep it one helper the other stubs call.

---

## Patch A — Talkgroup / ID bypass (Layer 1)

**Where the decision is read.** The receive handler admit gate (`0xC09E…0xC256`)
admits a call via getter **`0x2404`** = `0x38B5C[0xAF]` (the upstream `groups[]`
match result):

```
c1ba: bsr 0x2404        ; group branch: get admit flag
c1be: bez r0, 0xc2bc    ;   flag==0 -> MUTE
      ... status_post byte 10 (SEND_START group)
c244: bsr 0x2404        ; private branch
c248: bez r0, 0xc2ae    ;   flag==0 -> MUTE
      ... status_post byte 11 (SEND_START private)
```

**Why not force the getter.** `0x2404` has **13 callers** (status/caller-info
builders at `0x62a0`, `0xa0xx`, etc.). Forcing it to return 1 would corrupt those.
So patch **only the two gate sites**.

**Patch.** Build a stub `admit_or_promisc()`:

```
r0 = call 0x2404            ; real flag
if (r0 != 0) return r0      ; normal admit unchanged
return promiscuous() ? 1 : 0
```

Redirect the two `bsr 0x2404` at **`0xC1BA`** and **`0xC244`** to `bsr
admit_or_promisc`. (Each is one 32-bit `bsr`; only the target changes.) Result:
when promiscuous, every synced call admits regardless of TG/ID; when off, behavior
is identical. The 11 other `0x2404` readers are untouched.

- **Residual check:** this assumes `0x38B5C[0xAF]` is set to non-zero on *sync
  acquired* even for a non-matching TG (i.e. the flag is the match result, not the
  sync result). On-air §19 + the gate structure support it, but the writer of
  `0x38B5C[0xAF]` is in the C7000 receive-complete path and was **not** located
  statically (no plain `st.b …,0xAF`; set via computed pointer / wide store).
  **Bench-confirm:** replay an out-of-list TG with promiscuous on; if it stays
  muted, the flag is gated earlier and the stub must instead force the C7000 path /
  set the flag — localize with the `tools/dmr-replay` out-of-list clip.

---

## Patch B — Color code: force `cc_opt = 1` (Layer 2)

**Register** `LOCAL_CC` @ `0x11000384`: `cc[3:0]`, `cc_opt[9:8]` (0 = match local CC
only; **1 = match any CC**). The CC-apply code has three stores; the exact-match
one clears bit 8:

```
17e08: bez r3, 0x17e1e           ; if 0x34808[0x28]==0 -> exact-match path
17e0c: ... andi r2,r2,15; bseti r2,8; st.w -> 0x11000384   ; cc_opt=1
17e1e: lrw r3,0x11000384
17e22: ld.b r2, 0x34808[0xa]     ; cc value
17e26: andi r2,r2,15             ; <-- cc_opt=0 (NO bseti r2,8)
17e2a: st.w r2,(r3,0x0)          ; store LOCAL_CC
```

(`0x17de6` and `0x17e18` already write `cc_opt=1` in their modes — so stock
*already* matches any CC in some modes.)

**Patch.** Redirect the exact-match store so `cc_opt` bit 8 is OR'd in when
promiscuous. Cleanest: stub `store_local_cc(val)` at the `0x17E2A` store that does
`if (promiscuous()) val |= 0x100; *(u32*)0x11000384 = val;`, called in place of the
inline `st.w` at `0x17E2A` (redirect, stub tail-stores). Stock path unchanged when
off.

- **Bench precheck (may make B unnecessary):** record CC1 and CC2 to the same TG on
  the BTECH (`tools/dmr-replay` rows `cc1_tg9_s1`, `cc2_tg9_s1`) and replay against
  **stock**. If the wrong-CC call already passes, stock reaches here via a
  `cc_opt=1` path and Patch B is a no-op — skip it. Only build B if stock mutes the
  wrong CC.

---

## Patch C — Timeslot (Layer 3) — stretch, bench-gated

**Register** `WORK_MODE` @ `0x11000100` (mirror `0x104`): `work_slot_sel[0]`,
`layermode[4:3]`, `is_continuemode[5]`; mode table lists **DMR DCDM = `0x6b`**
(both slots). True both-slots-at-once needs (a) the C7000 to decode both bursts in
normal TierII RX and (b) the MCU caller/audio path to handle two concurrent calls —
**both unproven**. Defer until A/B land. Likely outcome: "promiscuous within a
chosen slot" via `work_slot_sel`, not genuine dual-slot. Bench with the duplex
hotspot (`hs_cc1_ts1` / `hs_cc1_ts2`). No static patch site committed yet.

---

## Patch D — Extend the `0x2B` caller-info reply with CC + slot (#2a)

**Current builder** `cmd2b_caller_info` @ `0xA808` assembles a **9-byte** body in
the frame at `r14+4` (callType `[0]`, caller ID LE `[1..4]`, target LE `[5..8]`),
then:

```
a886: movi r3, 9        ; body length
a888: ... 
a890: bsr 0x90b0        ; reply_build(cmd,sr,body,len)
```

The frame is `subi r14,r14,16` (16 B), body at `r9=r14+4`, so `r9+9` and `r9+10`
(= `r14+13/14`) are **in-frame and free**.

**Source of CC + slot:** `RX_TYPE_INFO` @ `0x11000390` — `cc[7:4]`,
`current_rx_slot[19]`. **Confirmed the firmware already reads this register** (10
sites; e.g. `0x1832e` `ld.w` + bit-extract), so the value is populated at receive
time.

**Patch.** Stub `finish_caller_info(...)` replacing `movi r3,9; bsr 0x90b0`
(redirect the `0xA890` call):

```
w = *(u32*)0x11000390
body[9]  = (w >> 4)  & 0x0F      ; received CC
body[10] = (w >> 19) & 0x01      ; received slot
len = promiscuous() ? 11 : 9     ; append only in promiscuous; old parsers safe
tailcall reply_build(cmd, sr, body, len)
```

Append-only + length-gated: stock 9-byte reply is unchanged when off, so no existing
parser breaks. (Confirm the exact CC/slot shift against the firmware's own
extraction at `0x1832e` before cutting bytes — use its masks, not just the manual.)

- **Free bonus (optional, from #2b):** the firmware mirrors AT1846S reg `0x1C` to
  RAM `0x3a81c`; a "configured analog tone present" ✓ bit could ride a 3rd appended
  byte. Marginal value (SignalDeck already knows the channel's tone). Skip unless
  asked — and note it can only confirm the *programmed* tone, never identify an
  unknown one (hardware limit, see the ideas doc §2b).

---

## SignalDeck side (ships with the firmware change)

- **Toggle:** a "Promiscuous / monitor" switch that writes the sentinel into
  `groups[0]` (mechanism A) on the active digital channel, normal list to disable.
  Help text: single channel, single (chosen) slot, not a trunking scanner.
- **Display (required):** parse the 2 extra `0x2B` bytes; show **CC** and **slot**
  per call in the caller line / Last Heard / history (gate the display on the
  promiscuous flag — normal channels have fixed CC/slot). This is the companion to
  #2a; promiscuous ships *with* CC/slot visibility, not after.
- **No-firmware stopgap** (already available): fill `groups[]` with up to 32
  monitored TGs.

---

## Build & bench

- **Stubs** → `zero_tail` (XIP `0x03074EFC`); coordinate the offset with the M17
  stubs already there. Record original bytes + version tag via `tools/fw-patch`
  (`patches.toml`, `build.py`). YModem load only — never raw flash; loads persist,
  restore = load `DMR003.UV4T.V022-ORIGINAL.bin`.
- **A/B** with `tools/dmr-replay`: capture each stimulus once, replay identical IQ
  against `STOCK` then `PROMISC1`, diff the run logs. Rows: `cc1_tg9_s1` (baseline),
  `cc1_tg100_s1` (out-of-list TG → Patch A), `cc2_tg9_s1` (wrong CC → Patch B),
  `cc1_priv_other` (private to other ID → A), `hs_cc1_ts1/2` (slot → C). Score =
  un-mute + the (now extended) `0x2B` reply.

## Must-confirm before cutting bytes (ordered)

1. **Patch A residual:** does `0x38B5C[0xAF]` go non-zero for an *out-of-list* TG on
   sync? (bench: out-of-list clip, promiscuous on.) Decides whether gating the two
   call sites is sufficient or the flag must be set upstream.
2. **Sentinel survives `cmd22` validation** (`0x9310` loop `+0x9606…+0x9632`) as
   `0x01000000`; else use mechanism B.
3. **Patch B necessity:** does stock already pass wrong-CC? (CC1 vs CC2 replay.)
4. **CC/slot shifts** match the firmware's own `RX_TYPE_INFO` extraction at
   `0x1832e`.
5. **Stub offset** in `zero_tail` does not collide with the M17 stubs (coordinate).
