# SignalDeck Web — plan

A full web application served by SignalDeck itself, so every feature of the phone app can be used from a browser on
the same network (PC, tablet, another phone). Not a screen share: its own pages, built for a large screen, talking to
the same `RadioService` the phone UI uses. Owner's request, 2026-10-20.

## Architecture

```
 browser ──HTTP(S)──► WebServer (in RadioService's process, own threads)
                       ├─ static app      /           assets/web/ (HTML, CSS, JS, fonts, icons; no CDN, works offline)
                       ├─ JSON API        /api/...    reads/writes through RadioService, ChannelStore, PacketEngine, …
                       ├─ live events     /api/events Server-Sent Events: channel, rx/tx, rssi, history, modes, captions,
                       │                              packets, SSTV lines, satellite pass state
                       └─ audio           /api/audio  WebSocket: RX audio to the browser; browser mic to TX (phase 3)
```

- **Server**: small HTTP/1.1 server on a `ServerSocket` (no library), thread pool, keep-alive, gzip for assets. Starts
  with the service when enabled, stops with it. Port 8080 (setting).
- **Off by default.** Device → **Web access** switch shows the address (`http://192.168.x.y:8080`) and the PIN.
- **Security**: a PIN (8 characters, generated, changeable) logs a browser in (session cookie, HttpOnly, SameSite=Strict,
  expires after 30 days idle); every `/api` call needs it; failed logins are rate-limited; LAN only (refuses
  non-private client addresses). Transmitting from the web is a separate permission (setting **Allow transmit from the
  web**, off by default) so a browser left open can't key the radio by accident. Secrets (APRS-IS passcode, Google key,
  callsign) are never sent to the browser in clear; settings pages show them masked and write-only.
- **HTTPS** (phase 3): browsers allow the microphone only on a secure origin. A self-signed certificate generated on the
  phone (AndroidKeyStore) for `https://…:8443`; the browser trusts it once. Plain HTTP stays for everything else.
- **One source of truth**: the web API calls the same service methods as the phone UI; the phone and any number of
  browsers stay in sync through the event stream. No second copy of radio logic.

## Pages (feature parity with the phone app)

| Page | Contents |
|---|---|
| **Intercom** | channel name/number (neon digits), frequency, mode chips, S-meter, RX/TX state, history, live captions, channel and zone steppers, SCAN, ZONE, Soft SQ slider, MON, REC, VFO, PKT; **listen** (RX audio in the browser) and **talk** (hold-to-talk with the browser mic, phase 3) |
| **Channels** | the list with search, zones, favourites, nearby repeaters; full channel editor (every field, same validation and help texts) |
| **Contacts** | DMR contacts and talkgroups, RadioID lookup, edit |
| **Messages** | DMR text threads, quick replies, send |
| **Packet** | APRS (live packets, stations, messages, map, send message/beacon/object/bulletin, settings), APRS-IS, KISS, DTMF, SAME alerts, SSTV (live picture, gallery, send), RTTY/PSK31, terminal, parrot, fox hunt, Morse trainer, voice keyer |
| **Satellites** | passes, live tracking (sky plot, Doppler), ISS APRS/SSTV, ISS frequencies |
| **Map** | OpenStreetMap tiles (Leaflet bundled): APRS stations at their positions, repeaters, channels, coverage, satellite ground track |
| **Logbook / Nets / Exam** | as on the phone, with ADIF/report export as downloads |
| **Recordings** | REC recordings and SSTV pictures: list, play, download |
| **Device** | radio link, take over / hand back, settings, diagnostics, updates; web access settings |
| **Help** | the in-app help topics, rendered as web pages |

Design: the phone app's look (dark, neon cyan, Orbitron / Rajdhani / Share Tech Mono, the same icons), laid out for a
wide screen (side navigation, intercom panel always visible on large screens, responsive down to a phone).

## API shape

- `GET /api/status` — everything the intercom shows (channel, link, rx/tx, rssi, modes, scan, zone, caption, mode bar).
- `GET/POST /api/channels`, `POST /api/channels/{n}/select`, `POST /api/channel/step`, `GET/PUT/DELETE /api/channels/{n}`.
- `GET /api/history?since=`, `GET /api/aprs/log`, `/api/aprs/stations`, `POST /api/aprs/message`, `/api/aprs/beacon`.
- `GET /api/sstv/live.png`, `/api/sstv/pictures`, `/api/sstv/pictures/{name}`.
- `GET /api/satellites/passes`, `POST /api/satellites/track`, `POST /api/iss/{aprs|sstv}`.
- `POST /api/ptt` (down/up; needs the transmit permission; refused while receive-only, during a pass, or over 28 s).
- `GET /api/events` — SSE stream; each event `{type, …}`; the browser rebuilds its state from `/api/status` on (re)connect.
- Errors as `{error}` with HTTP status; every write returns the new state.

## Phases

1. **Foundation (shipped 2026-10-20 night)**: server, PIN login, `/api/status`, events stream, intercom page (live
   state, channel/zone stepping, history), APRS live/stations/messages pages, SSTV live picture + gallery, Device switch.
2. **Parity of the read/write pages** (started 2026-10-20: messages, contacts, map, help done): channels + editor, contacts, messages, packet tools, satellites, map, logbook,
   nets, recordings, settings, help.
3. **Audio** (RX to the browser shipped 2026-10-20; browser-mic TX over HTTPS + WebSocket built 2026-10-21, on-air test pending): RX audio to the browser (8 kHz PCM over WebSocket, Web Audio playback with jitter buffer); talk from the
   browser mic over HTTPS (Opus or PCM up, injected through the same TX path as the phone mic, same 30 s guard).
4. **Polish**: installable PWA, keyboard shortcuts (space = PTT), multi-user indicator (who is connected), audit log of
   web transmissions in the history.

## Testing

- Host tests for request parsing, auth and the JSON shapes (no Android types in the server core).
- On the phone: open the site from the PC (`http://192.168.1.125:8080`), walk every page, compare with the phone UI;
  load test with several browsers on the event stream; leave it running overnight with the radio busy.
