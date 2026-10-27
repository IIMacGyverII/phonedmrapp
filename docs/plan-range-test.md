# Plan: Range test with two SignalDeck radios (base and rover)

Owner idea 2026-10-27: one SignalDeck radio stays put with its GPS on (the **base**); the other travels and transmits
every so often (the **rover**); the base hears it, measures the signal and answers with the level it heard; the rover
records the level and its position; the result is a measured coverage map with a projected range and distances.
Queued after the new phones are made compatible (it needs two SignalDeck phones) and after the hotspot session; it
goes to whichever agent is free then, through the usual handoff. Everything is app-side; no firmware change.

## 1. Design (agreed 2026-10-27)

- **Both legs on packets, not DTMF or Morse.** The radio needs a 1.6 s lead-in before anything decodes
  (`CLAUDE.md` §3, APRS TX timing), so an exchange costs about 2 s each way whatever the payload; a packet carries a
  whole record with a CRC in 0.3 s. The rover's beacon is the existing APRS **Position Beacon**; the base's reply is a
  short AX.25 UI frame from the same encoder (`txAfskFrame`); the APRS decoder already runs below the squelch on any
  analog channel. On a DMR channel the same exchange rides on DMR texts (verified on air 2026-10-17).
- **One exchange, both directions.** The base reports the level it heard (the uplink). The rover reads the module's
  signal level (`0x32`, `RadioService.lastRssi()`) while the reply arrives (the downlink). Both radios are the same
  hardware at the same power, so the path is reciprocal; the two legs differ by the local noise at each site, which is
  why the reply also carries the **base's noise floor** (its reading between pages).
- **Misses are data.** A beacon with no reply is logged as "nothing heard" at that position; a reply heard but not
  decoded (carrier, no frame) is logged as such. The edge of range is where decoding fails.
- **Beacon by distance with a time floor** (default every 100 m, at least 10 s apart, at most every 60 s when
  stationary), so the map fills where the rover goes.
- **Projected range stays honest.** The existing `coverage/Prediction`, `Predictor`, `Propagation` and `Terrain` give
  a model; this feature calibrates it with the measured points (fit the path-loss line per bearing sector, show the
  fitted radius at the decode threshold) and draws the estimate as a shaded band over the measured points, never
  instead of them.

## 2. What to build (SignalDeck, one branch `range-test`, one PR)

1. **Reply frame.** `pkt/RangeFrame`: AX.25 UI frame, destination `RANGE`, info `!R seq=<n> rx=<dBm> nf=<dBm>
   pos=<lat,lon>` (the base's fixed position from its GPS fix, 4 decimals), under the station callsign; the parser for
   the rover. Host tests: round trip, a damaged frame rejected, a frame with no position.
2. **Base role** (`RangeStation`, like `PagerStation`): on an analog channel with squelch 0, listens for APRS position
   beacons from the rover's callsign (the pairing: the rover's callsign-SSID, typed or picked from contacts), takes
   `lastRssi()` at the decode, waits the lead-in and replies once per beacon; keeps a session log (seq, time, rx, nf).
   Holds the mode wake lock (`updateModeWake`, the decoders stop in deep sleep otherwise). On a DMR channel the beacon
   is a DMR text `!R …` and the reply a DMR text back.
3. **Rover role**: beacons with the distance/time rule, then listens up to 6 s for the reply (lead-in plus frame plus
   margin); logs one record per beacon into the **coverage store** (`coverage/CoverageStore`, new kind `range`):
   time, rover position, seq, uplink dBm (reported), downlink dBm (own reading of the reply), base noise floor, base
   position, distance and bearing (`CoverageMath`), outcome (decoded / carrier only / nothing).
4. **Pairing step**: once per session at a known short distance the two radios compare readings; the offset between
   the modules (uncalibrated between units) is stored with the session and applied to the uplink numbers.
5. **Map**: the Coverage pill gains a Range layer: points coloured by uplink level, a second toggle for downlink, hollow
   markers for misses, the base as a pin, the fitted range band per sector; a session list with distance travelled,
   points, farthest decoded distance per direction, and export (`CoverageExport`, CSV + GPX).
6. **Page**: PKT → Range test: role switch (Base / Rover), the partner callsign, the channel in use, the beacon rule,
   live counters (beacons, replies, last uplink/downlink, farthest), Start/Stop; in SignalDeck Web the same page and
   `/api/range` (state, session records). Help topic "Range test" and a paragraph in Coverage maps; `CHANGELOG.md`.

## 3. Bench and field

- **Cage, functional:** two SignalDeck phones on the same low-power analog channel; rover beacons through a fixed
  attenuator (or by placing the phones at the cage's ends), the base replies; pass = every beacon logged with a reply,
  seq matched, both levels within a few dB of the HackRF-measured levels, misses logged when the attenuation is
  raised past the decode threshold; the DMR variant once.
- **Field:** one drive with the base at a fixed spot; pass = a map with points along the route, misses at the edge,
  the fitted band drawn, export opens in a GPX viewer. The field data stays out of the repositories (owner location).

## 4. Rules

- The APRS-settings callsign is the station identity on the air; bench runs use the bench callsigns only, and no
  recording, log or fixture with the owner's area goes into a repository (`no-owner-area-in-test-data`).
- Squelch 0 and decode below the squelch at both ends (levels 1–9 are one threshold near −90 dBm).
- No firmware change; the beacon and reply use the existing TX paths (lead-in, send twice) unchanged.
- Help and changelog in the same PR; host tests green before the bench; report through the handoff.
