# Atom XL: one capture across receptions (plan, not run)

**Status: shelved 2026-10-29 (managing agent).** The signal-polling test found the cause: with no 0x32 reading during
a reception, 12 of 12 receptions were clean (SignalDeck PR 110). Kept in case drops come back.

## Why

SignalDeck opens the bridge's USB sound card at each reception and closes it at the end. The stock HAL, as far as the
disassembly shows, opens it once and reads in a loop: on a failed read it logs `pcm_read ret=%d error=%s`, counts it,
and reads again on the same device, with no close, prepare or reopen (`HAL_SEQUENCES.md`). With the stock app the
capture pointer never stalled in 4 receptions (2026-10-29), while SignalDeck dropped 1 in 6. Two read-pattern variants
(read on after EIO for 5 s; 320-frame reads) did not close the gap. Per-reception open and close is the main
difference left.

## What we know about an idle capture

- The bridge streams only while the module puts out sound. An idle capture gets EIO after 2 s (2026-10-29).
- After EIO, re-preparing failed and reopening three times gave no period (2026-10-29), but **simply reading on did
  resume once by itself after 4 s** (variant (ii), 18:03). Whether it resumes reliably after minutes of idle is unknown.

## Design

1. `sdalsa cap` gets an "endless" EIO read-on (`-e 0` stays "end at once"; a new value, e.g. `-e -1`, means never end
   on EIO). Between failed reads it sleeps 50 ms so an idle loop costs nothing.
2. Take-over opens the capture once, after the bridge is up. Exit and Hand back stop it before the power-off.
3. Java keeps reading the pipe all the time and passes audio on only between the line's start and end (or the
   watchdog's synthetic reception), plus the existing pre-roll. Idle data is dropped in Java, never left in the pipe
   (the drop mode stays on).
4. A capture is dead only if a reception is under way, the signal is up, and no period has come for 5 s. That case
   keeps the PR 98 recovery (power-cycle, reopen once).
5. TX: the capture stays open; the transmit path is separate (play device).

## Bench steps (in order; stop at the first failure)

1. **Idle resume.** Open the capture with endless read-on, leave it idle 10 s, 60 s and 5 min, then transmit RTTY from
   the HackRF: does audio arrive within 0.5 s of RECEIVE_START each time?
2. **Drop rate.** 16 RTTY/speech receptions, against 1 in 6 (main) and the variants' 2–3 in 8.
3. **Side effects.** CPU and battery idle for 10 min with the capture open; screen off (App block off) 10 min, then a
   reception; a channel change and a DMR call during the open capture.
4. **Exit / Hand back** still give the USB port back (the capture must be closed before `mcu_power 0`).

## Risks

- If the stream never resumes after a long idle, this design fails at step 1. The fallback is to open at
  RECEIVE_START as now but never close until a 30 s idle.
- Endless EIO keeps a process spinning on a dead device; the 50 ms sleep keeps it cheap.
