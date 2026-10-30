# Atom XL: scan and band scope timing (plan)

**Status:** plan, 2026-10-30. Needs one HackRF slot (about 30 min) and a phone lease; the Atom XL receives only.

**Why:** SignalDeck's scanner and band scope use the Armor's timing (the module's signal reading is 15–20 dB low until
about 0.7 s after a retune, measured 2026-10-22 on the Armor). The Atom XL's module (DMR006) sits behind a USB bridge
and has never been timed, so its scan may be slower or faster than SignalDeck assumes.

**Where the code waits:** band scope `BandScope.DEFAULT_SETTLE_MS = 700` plus ~300 ms per reading (help: "about a
second a step"); channel scanner `Scanner.SETTLE_MS = 700`, `DWELL_MS = 1500`, `HANG_MS = 2500`, tick 150 ms.

## Measurements

All on the PR 141 build (beta.21), so readings are in real dB. HackRF carrier at a fixed level (−x 30, reading about
0x5B), bench channels around 401.025 MHz, low HackRF power. Readings by the bench `scope` command and raw `0x32`
queries; nothing transmits from the Atom XL.

1. **Retune settle time** (the number everything else depends on). The HackRF holds a carrier on 401.025. The bench
   `scope` command sweeps 400.975–401.075 MHz in 25 kHz steps with `--ei settle` at 0, 100, 200, 300, 500, 700 and
   1000 ms, 3 sweeps each. The settle time is the shortest delay at which the carrier step reads within 1 dB of its
   steady value and the empty steps read the idle floor (no smear from the previous step).
2. **Reading time:** from the same logs, the time from each `0x32` query to its answer (the Armor answers only once its
   next reading is ready, 0.1–0.5 s).
3. **Band scope sweep:** with the settle from step 1, one 70 cm FM sweep (bench custom range, 81 steps) and its time
   per step, against the ~1 s per step SignalDeck shows today. Check the carrier shows at the right step and the peak
   level is right.
4. **Channel scanner:** a scan list of 10 bench channels (temporary, removed afterwards) on empty frequencies plus one
   with the HackRF carrier:
   - channels per second on the empty ones (the scanner's own step time);
   - from the carrier's channel coming up to the scanner stopping on it and the audio opening (reception line start
     plus capture), started at random points in the cycle, 5 times;
   - how long it stays after the carrier ends (HANG_MS).
5. **Line vs reading:** on the Atom XL a channel's reception is reported by the bridge's reception line, not the signal
   reading, so step 4 also shows whether the scanner stops on the line edge before the reading settles.

## What a result changes

- If the settle time is clearly shorter than 700 ms: a per-profile `scopeSettleMs` / `scanSettleMs` (as PR 141 did for
  the reading step), so band scope and scan run faster on the Atom XL; help text updated with the Atom XL numbers.
- If it is longer: the same field set higher, so readings are not 15–20 dB low.
- Results go into `compatibility.md` (Band scope, Scanning rows) and the in-app help ("How fast").

## Clean-up

Temporary scan list and channels removed, the scan off, the Atom XL back on channel 2, the HackRF free; listed in the
Atom XL mailbox.
