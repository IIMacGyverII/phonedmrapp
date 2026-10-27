# Plan: ATAK (CivTAK) integration

Owner direction 2026-10-27: a future project. ATAK-CIV is the civilian Android Team Awareness Kit (civtak.org): a shared
map where every station's position, markers, chat and files travel as Cursor-on-Target (CoT) events, small XML
messages with a type, a position, a callsign and details, exchanged through a TAK server or, without one, over a local
network stream. SignalDeck can feed it, take from it, and carry it over the radio where there is no network. Everything
here is app-side; no firmware change. Queued after the POCSAG/web work, Restricted mode, the range test and the new
phones; it needs two SignalDeck phones for tier 2.

## 1. What ATAK offers and takes (the surface to build against)

| Direction | What | How ATAK does it |
|---|---|---|
| We give | **Positions and markers** (own station, APRS stations heard, DMR/M17 callsigns heard with a position, nets, repeaters, POTA parks, the fox transmitter) | CoT events of type `a-f-G-U-C` (friendly ground unit) and the marker types, on the network stream ATAK listens to (SA multicast 239.2.3.1:6969 by default, or a TCP/UDP input it is configured with), or through a TAK server |
| We give | **Chat** (DMR texts, M17 texts, APRS messages, pager pages) | GeoChat CoT (`b-t-f`) to a callsign or a team |
| We give | **Alerts** (NOAA SAME alerts, SignalDeck Emergency, a station's 911/emergency beacon) | CoT alert and 911 types with the position |
| We give | **Overlays** (coverage maps, range-test results, the repeater list, the band scope's finds) | KML/KMZ data packages ATAK imports; a data package can also carry the channel plan as a file |
| We take | **Positions of ATAK users** (the team on the map) | the same stream, both ways: ATAK publishes its own position and markers |
| We take | **Chat from ATAK** to a radio contact or a team | GeoChat events addressed to a callsign SignalDeck owns |
| We take | **Markers and routes** the team drops (a rally point, a search area) | CoT marker events; SignalDeck shows them on its map and can transmit them |
| We take | **911 / emergency** raised in ATAK | the 911 CoT; SignalDeck sends the APRS/DMR emergency beacon |
| Both | **Data packages** (files, photos, forms) | ATAK's mission packages; over the radio only small ones (forms, a compressed marker set) |

What ATAK does not do and SignalDeck adds: a radio. ATAK's own off-grid options are Wi-Fi mesh, Meshtastic (through
its plugin) and audio modems on a commercial radio (the HAMMER plugin). SignalDeck's radio and its decoders are
already a packet transport (AFSK on FM, DMR texts, M17 packet data), so SignalDeck becomes a TAK transport.

## 2. Tiers (three PRs, in order; each with help and changelog; each wired into Restricted mode as a mode `tak`)

### Tier 1: the local bridge (no plugin, same phone or same Wi-Fi)

1. `tak/Cot` (pure): build and parse CoT events: position/unit, marker, GeoChat, alert/911; the fields SignalDeck has
   (callsign, position, time, stale, the radio it was heard on in `remarks`). Host tests against ATAK's documented
   event shapes and a few captured events.
2. `tak/TakLink`: a UDP multicast sender/receiver on the SA address and a TCP client/server for a configured stream
   (the TAK server with TLS comes later, behind a certificate import; not in tier 1). Runs only while enabled.
3. Outputs: own position (from the coverage logger's fix) every N seconds, APRS stations heard, callsigns heard with a
   position, SAME alerts, Emergency; DMR/M17/APRS texts and pager pages as GeoChat.
4. Inputs: ATAK positions and markers onto SignalDeck's map (the APRS map layer gains a "TAK" layer); GeoChat to one of
   SignalDeck's callsigns becomes a text to send (the user confirms the radio and contact the first time); a 911 from
   ATAK offers the Emergency beacon.
5. Exports: coverage and range-test results as KMZ into Download/DMR/TAK for import into ATAK.
6. Page: PKT → TAK bridge: on/off, the stream address, what is published, what is accepted, a live counter; help
   topic "TAK bridge"; SignalDeck Web shows the state.

### Tier 2: the radio as a TAK transport (two SignalDeck phones)

1. `tak/CotCompact`: a compact binary form of the events tier 1 handles (position with callsign and type in about 20
   bytes, GeoChat as the text plus 8 bytes, markers with a short type code), with a CRC and a sequence number; host
   tests round-trip every type and reject a damaged frame.
2. Carriers, all existing: AFSK AX.25 UI frames on FM (destination `TAK`), DMR texts (one event per text), M17
   packet data (raw type with our sub-type byte) on the bench firmware. The same lead-in and repeat rules as APRS.
3. A sending policy: positions by distance and time like the range test's beacon, chat and markers at once, 911 at
   once and repeated; a queue with priorities so a 911 never waits behind positions; air-time budget per station.
4. The far end injects what it receives into its ATAK through the tier 1 bridge; every event carries which radio it
   came over, and ATAK shows the station as stale when positions stop.
5. Bench: two phones in the cage, ATAK on both, positions and chat crossing the radio in both directions; a 911 from one
   ATAK raising the other's alert; the air-time measured for a five-station team.

### Tier 3: an ATAK plugin (optional, last)

PTT, the channel and the last-heard list on the ATAK screen, radio texts in ATAK's chat, built against the ATAK-CIV
plugin SDK as a separate module with its own licence file. Only after tiers 1 and 2 are in use.

## 3. Other things that have to be in it

- **Identity:** the TAK callsign is the station callsign; the ATAK user's UID maps to a SignalDeck contact (a contact
  gains a TAK UID field), so chat and positions file under the right person.
- **Time and staleness:** CoT carries `time`, `start` and `stale`; SignalDeck fills them from the phone clock and marks
  radio-relayed events with a longer stale window, since a position over the air arrives late.
- **Clear text on the air:** amateur rules forbid obscuring the meaning, so nothing over the radio is encrypted and the
  help says so; the bridge never forwards an event ATAK marks restricted. Data on GMRS is limited, so the TAK mode
  sits under Restricted mode like every transmit mode, and the help names the band rule.
- **Loop prevention:** an event that came over the radio is not sent back over the radio, and an event from the local
  ATAK is not re-injected into it (sequence numbers and origin tags).
- **Load:** the SA multicast on a busy TAK network can be hundreds of events a minute; the bridge filters by team and
  type before anything reaches the radio queue.
- **Testing without a TAK server:** ATAK-CIV from the Play Store or civtak.org on the bench phones, and the free
  servers (FreeTAKServer or taky) on the cage's Ubuntu box for the server path later.
- **Owner data:** fixtures and bench captures use the bench callsigns and the Denver demo location, never the owner's
  area (`no-owner-area-in-test-data`).

## 4. Rules

- Write the CoT handling from the TAK documentation and captured events; ATAK-CIV's own source may be read for the
  protocol, not copied (licence check before any plugin work).
- No firmware change; the carriers are the existing TX paths, unchanged.
- Help and changelog in the same PR; host tests green before the bench; report through the handoff.
