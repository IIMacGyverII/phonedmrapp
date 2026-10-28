# Task for Grok: the Agold envelope codec in SignalDeck (2026-10-28)

**From:** the Atom XL Claude agent, at the owner's request. **Scope:** one SignalDeck PR, host-tested. The Atom XL
agent does everything else in Phase D (profile, take-over/give-back, USB audio, texts) and the device tests; it will
build on this PR. No phone, HackRF or hotspot is needed for this task.

## What to build

The framing layer described in `docs/atomxl/TRANSPORT_DESIGN.md` §3 (read §2–§3 first; facts in
`docs/atomxl/PHASE_A_FINDINGS.md` §2, §7, §8):

1. A small `FrameCodec` interface in SignalDeck (`encode(Frame)`, `tryDecode(bytes, off, avail, out)` with the same
   return convention as `Frame.tryDecode`), and a default implementation that is today's `68 … 10` framing, so every
   supported phone behaves exactly as now.
2. `UartPort` takes a codec (constructor overload; the existing constructor keeps the default). `RadioEngine` picks
   the Agold codec when `profile.protocol` is `"agold"`.
3. The Agold codec, per design §3: envelope out (route 01, rw 01, length big-endian, the checksum of
   `AgoldFrames.checksum`, which `AgoldFrames.request` already builds); in, route 01 replies mapped so the engine sees
   Armor-shaped frames (set-command replies carry their result as the one body byte → `sr`; data replies keep their
   body with `sr = 0`; the data set is in §3); route 00 (the bridge's own reports) delivered to a separate listener and
   never to the engine.

## Tests (host, from bytes captured on the Atom XL)

- `0x34` request encodes to `7e 96 69 01 34 01 00 01 01 fc ca 81` (equal to `AgoldFrames.request(0x01, 0x34, 0x01)`).
- Reply `7e 96 69 01 34 00 00 10 44 4d 52 30 30 36 2e 55 34 41 2e 56 30 36 37 00 18 0d 81` → cmd 0x34, sr 0, body
  `DMR006.U4A.V067\0`.
- Reply `7e 96 69 01 22 00 00 01 00 fd dd 81` → cmd 0x22, sr 0, empty body; the same with result `01` → sr 1.
- Reply `7e 96 69 01 2e 00 00 01 00 fd d1 81` → cmd 0x2E, sr 0.
- Bridge `7e 96 69 00 01 00 00 0e "20201016161541" 8e a1 81` → the bridge listener, no engine frame.
- A wrong checksum is not a frame; a cut frame asks for more bytes; garbage before a frame is skipped.
- The default codec: the existing `Frame` tests still pass unchanged.

## Rules

- SignalDeck worktree of your own, branch `grok/agold-envelope` from `atomxl/report-polish` (the Atom XL PR stack
  #60 ← #61 ← #64 ← #70 ← #71; `AgoldFrames` there has `checksum`/`request`). One PR, based on that branch.
- `CHANGELOG.md` row (host-tested only), no help change needed (no user-facing behaviour until the profile lands).
- No phone work, no firmware, nothing under `radio_firmware/` for this task.
- When the PR is up, a line in `docs/atomxl/PROGRESS.md` is not needed: the owner tells the Atom XL agent.
