# 08 — Packet-radio modes: plans and to-dos

**What this is.** Every packet (and packet-adjacent) mode worth considering on this radio, each with a plan and a checkbox list. Complements Claude [`docs/deep-dive/15-packet-radio-review.md`](../deep-dive/15-packet-radio-review.md) (RX/TX assessment of *shipped* APRS). Does not edit that file.

**Update:** Claude 15 §7 addendum adopted this catalogue (KISS = F5, SAME = F8, DTMF = F9, DMR SMS fallback = F7; connected AX.25 not in-app). Build order there matches the table at the bottom. Extra: APRS-IS and SAME must ride the OEM `InterPhoneService` wakelock/Doze (see [09](09-claude-reconciliation.md) §5.5).

**Architecture.** Stop adding named channel-hijack “modes.” Add a **modem** that emits/consumes AX.25 frames, then apps (APRS, KISS, iGate, mailbox) sit on top. SSTV/NOAA stay image pipelines. SAME/DTMF are extra demodulators on the same `writeAudioTrack` tap.

**Gates (do these once; everything below depends on them).**

| Gate | Why | Effort | Device |
|---|---|---|---|
| **G0** Build + install HEAD (`ba6431cb`) | Unreleased audio/squelch changes | S | yes |
| **G1** Dump one `writeAudioTrack` chunk: `s[2k]==s[2k+1]`? | 8 kHz stereo vs 16 kHz mono; all tone math | S | yes |
| **G2** Pure-Java modem + JUnit harness vs WAV corpus + Dire Wolf `atest` | Makes later DSP measurable | M | no |
| **G3** Stereo-frame AFSK TX experiment (tone → packet → `AudioRecord.read` inject) | Unblocks RF TX apps or confirms the hard constraint | S–M | yes + 2nd RX |

Status: none started. G3 may fail; items marked **TX** then fall back to APRS-IS / DMR SMS / external TNC.

Legend — **Effort**: S &lt; ½ day · M 1–2 days · L 3–5 days. **Layer**: PHY (modem) · APP (protocol/UI) · NET (internet) · DMR (UART SMS).

---

## Shared foundation (not optional)

### F1 — Streaming AFSK1200 + HDLC (the modem)

**What.** Replace 2 s `List<Short>` + `resample16to48` + “longest gap” with a stateful demod at native rate and an HDLC state machine that delivers **every** FCS-good frame.

**Depends on.** G1, G2.

**Plan.** `AfskModem` + `HdlcReceiver` with no Android deps. Feed from `hookPCMReceiveManager` via an SPSC queue onto `HandlerThread("ax25-modem")`. Keep PLL/NRZI; drop boxcar later (F1b). Output: `onFrame(byte[] ax25)` including FCS.

**To-do**
- [ ] Confirm G1 layout; set `SAMPLE_RATE` (8000 after drop-one-channel, or 16000)
- [ ] `HdlcReceiver`: flag, unstuff, abort-on-seven-1s, FCS-16-CCITT, back-to-back frames — JUnit
- [ ] `AfskModem`: IQ mix, LPF, PLL (`2^32`), NRZI; persistent state across chunks — JUnit vs corpus
- [ ] Wire hook → queue → one thread; delete `bufferAudioForAPRS` / `processAPRSBuffer` / `resample16to48`
- [ ] Baseline `ours/direwolf` decode counts on committed WAVs + TNC Test CD
- [ ] Kill per-chunk `XposedBridge.log`; DCD from PLL lock for the live UI
- [ ] Remove dead: `AFSKDecoderPLL`, `DireWolfDecoder`, NDK stub, `findPacketBits`

**Effort.** M. **TX?** no.

### F1b — Demod quality (after F1)

**Plan.** Kaiser/sinc LPF vs 32-tap boxcar; sine LUT; hysteresis slicer; optional dual profile (flat / de-emph). Measure each vs G2 harness.

**To-do**
- [ ] Swap LPF; record `ours/direwolf` before/after
- [ ] LUT `sin`/`cos` (current `fastSin` still calls `Math.sin`)
- [ ] Adaptive threshold / dual profile
- [ ] Optional later: single-bit “fix bits”

**Effort.** S–M each.

---

## A. Same modem, different apps

### A1 — Full APRS parsing (Mic-E, compressed, messages, objects, weather)

**What.** Today only uncompressed `! = / @`. Most mobiles are Mic-E.

**Depends on.** F1 (or today’s batch decoder as a stopgap).

**Plan.** Add **javAPRSlib** (LGPL-2.1, APRSdroid’s parser). Feed TNC2 `src>dest,path:info`. Keep `APRSPacketDecoder` only as a thin adapter or delete it. Store typed fields; show messages as a thread.

**To-do**
- [ ] Vendor javAPRSlib (or git subtree); confirm GPL-3 project compatibility (LGPL ok)
- [ ] Convert AX.25 UI frame → TNC2 string (addresses, H-bits, dest — Mic-E needs dest)
- [ ] Map `PositionField` / `MessageField` / `ObjectField` / weather / telemetry into `APRSReceivedDatabase`
- [ ] Schema: `kind` (pos/msg/obj/wx/other), `dest`, `path`, `acked`
- [ ] UI: received stations keep working; add message list; “Unsupported” only for true junk
- [ ] Fixtures: Mic-E, compressed `/YYYYXXXX$csT`, `:CALL    :hello{001`, `;OBJECT  *`, `_` weather

**Effort.** S–M. **TX?** no.

### A2 — Passive decode (no channel hijack)

**What.** Decode on any analog channel with `channel_aprs.enabled`. APRS “mode” becomes optional (tune 144.390 + live screen).

**Depends on.** F1. Uses existing `dmrmod_aprs.db` flag (written, never read).

**Plan.** Start/stop modem on channel change if analog && (flag || monitoring UI). History line like DMR caller. No name wrap, no `.dat` backup for decode-only.

**To-do**
- [ ] Read `channel_aprs.enabled` for current `channel_number` / `_id` (prefer `_id` — see grok `02` P1.1)
- [ ] Editor row or long-press: “Decode APRS on this channel”
- [ ] Feed modem from PCM hook whenever flag or live UI is on
- [ ] `updateActivityIndicator` for new stations; optional notification (`APRSReceiver` TODO)
- [ ] Keep 144.390 convenience UI; decoding must not depend on it
- [ ] Do not require `setCancelable(false)` dialog for decode

**Effort.** M. **TX?** no.

### A3 — APRS messages / bulletins

**What.** Two-way messaging (`:CALLSIGN:text{msgid`).

**Depends on.** A1. **Send** needs G3 pass **or** APRS-IS (C1).

**Plan.** Thread UI like DMR SMS. RX always. TX: RF UI frame if G3 ok, else APRS-IS `send` line.

**To-do**
- [ ] RX path from A1 into a `messages` table (from, to, body, msgid, acked, ts)
- [ ] Intercom or PKT sheet: inbox, compose (to callsign-SSID, 67-char body)
- [ ] Generate `{nnn` message IDs; parse acks
- [ ] TX: if RF available, UI frame to `APRS` dest with path `WIDE1-1`; else C1 `send` packet
- [ ] Bulletins `:BLN*` display-only at first

**Effort.** M. **TX?** RF optional.

### A4 — KISS TNC over TCP

**What.** Phone is a TNC. APRSdroid / YAAC / PinPoint do APRS. Best product architecture.

**Depends on.** F1. TX frames need G3 or stay RX-only KISS (still useful for iGate apps).

**Plan.** Listen `0.0.0.0:8001` (or USB accessory later). KISS: `C0` FEND, `DB DC` escape, port 0 data. Host FEND-DATA-FEND → `onFrame`; `onFrame` → KISS to client. Optional: TCP keepalive, one client, notification “TNC on :8001”.

**To-do**
- [ ] `KissTcpServer` (no Xposed in the class); unit tests for FEND/escape
- [ ] Start/stop from Device tab or PKT sheet; default off (security)
- [ ] RX: modem `onFrame` → KISS data frame to clients
- [ ] TX: KISS data from client → AFSK generator + stereo TX path **if G3 passed**; else NAK/log
- [ ] Document APRSdroid: “TCP TNC, this phone’s IP, port 8001”
- [ ] Firewall: localhost-only option; LSPosed module is in OEM process — bind preferences
- [ ] Do not enable in release until bind is localhost or user-toggled

**Effort.** M. **TX?** optional.

### A5 — Connected AX.25 (keyboard / PBBS)

**What.** SABM/UA/I/RR/DISC. Classic packet, 2026-niche.

**Depends on.** F1 + G3 (must TX). KISS (A4) lets **external** apps do this without us writing a connected stack.

**Plan.** Prefer A4 + existing clients. In-app connected mode only if someone needs a PBBS with no laptop.

**To-do**
- [ ] After A4+G3: verify a PC client can SABM a known BBS through our KISS port
- [ ] **Do not** write an in-app AX.25 connected stack unless that test is wanted as a first-class UI
- [ ] If yes later: `Ax25Link` state machine, 256-byte I frames, T1/T3, UI for call/connect/disconnect

**Effort.** L if in-app; S if “KISS is enough.” **TX?** yes.

### A6 — FX.25 / IL2P (FEC)

**What.** Fewer lost frames in noise. Dire Wolf FX.25 correlation tags.

**Depends on.** F1, G2.

**Plan.** RX-only first: detect FX.25 tag, RS decode, emit AX.25. TX only after G3.

**To-do**
- [ ] Read Dire Wolf FX.25; port correlation + RS to Java
- [ ] JUnit with Dire Wolf-generated FX.25 WAVs
- [ ] Parallel to plain HDLC (try FX.25, fall back)
- [ ] TX FX.25: after G3, optional

**Effort.** L. **TX?** later. **Priority.** After A1/A4.

### A7 — UNPROTO / UI beacon (non-APRS)

**What.** Beacon arbitrary UI text. Subset of APRS TX.

**Depends on.** G3.

**Plan.** One settings field + interval. Don’t bother until APRS beacon (C2 or G3) exists.

**To-do**
- [ ] Fold into APRS RF beacon (B1); no separate mode

**Effort.** S (as part of B1).

---

## B. RF transmit (AFSK)

### B1 — APRS RF beacon + full RF iGate

**What.** Phone GPS → 144.390 UI frame. If iGate: internet packets → RF (licensed, gated).

**Depends on.** G3 pass, F1, A1, C1 for iGate RX side.

**Plan.** Follow Claude 15 §3.1. Only if tones survive stereo frames: `AFSKGenerator` stereo-duplicated, paced at 32 kB/s, `AudioRecord.read` overwrite during analog PTT **or** `writeFrame` with OEM open/close. SmartBeacon. Path `WIDE1-1,WIDE2-1`. Digipeater-TX (full iGate) is a **settings opt-in** with a “I am a licensed gate” checkbox.

**To-do**
- [ ] G3 tone test 1200 / 2200 Hz stereo L=R; record 2nd RX spectrum
- [ ] G3 packet test; direwolf on 2nd RX
- [ ] If fail: mark RF TX dead in `.grok/rules` **with the stereo evidence**; keep generator; stop B1
- [ ] If pass: hook `AudioRecord.read(byte[],int,int)` afterHook; analog PTT only
- [ ] Deviation/level: start ~3 kHz; don’t clip
- [ ] Beacon: uncompressed `!` first; then Mic-E
- [ ] SmartBeacon (speed/heading)
- [ ] Full iGate TX: only after C1 RX iGate is stable; default **off**

**Effort.** M after G3. **TX?** yes.

### B2 — External TNC (Mobilinkd KISS)

**What.** If G3 fails: Bluetooth KISS TNC does RF; module is UI / APRS-IS.

**Depends on.** A4 protocol (KISS), not our AFSK TX.

**Plan.** Bluetooth SPP to Mobilinkd; same KISS framing as A4. Optional.

**To-do**
- [ ] Only schedule if G3 failed **or** a user asks
- [ ] BT classic SPP; KISS in/out
- [ ] Share station DB with RF-internal path

**Effort.** M. **TX?** via TNC.

---

## C. Internet (no RF required)

### C1 — APRS-IS RX-only iGate

**What.** Every decoded RF frame → `rotate.aprs2.net:14580`. Packets appear on aprs.fi.

**Depends on.** F1 + A1 (need a full TNC2 line). Callsign + passcode.

**Plan.** TCP, login `user CALL-SSID pass NNNNN vers DMRModHooks ver`, then `CALL>DEST,PATH,qAR,MYCALL:info`. Filter third-party. RX-only gates are welcome. UI: enable, callsign, passcode (computed, shown), status.

**To-do**
- [ ] Passcode algorithm (standard hash); never ship a shared pass
- [ ] `AprsIsClient`: connect, login, keepalive `# javAPRSSrvr`, reconnect with backoff
- [ ] On each RF frame: TNC2 + `qAR` + our call
- [ ] Do not gate packets already from TCPIP / our call
- [ ] Device-tab toggle; amateur-licence disclaimer
- [ ] Test: hear a packet on RF, see it on aprs.fi within a minute

**Effort.** M. **TX?** no (RF TX not used).

### C2 — Phone GPS beacon over APRS-IS

**What.** APRSdroid-style. No radio.

**Depends on.** C1 login. GPS already in the module.

**Plan.** SmartBeacon → `CALL>APDM01,TCPIP*:!lat/lon-comment`. SSID `-7` or `-9` for handheld. Independent of G3.

**To-do**
- [ ] Reuse `getCurrentLocation`; one-shot/fresh fix; don’t beacon 0,0
- [ ] Uncompressed `!` position; symbol from `APRSDatabase`
- [ ] SmartBeacon intervals (stopped 30 min, moving 1–2 min, corner peg)
- [ ] Comment: `DMRModHooks` + optional free text
- [ ] Same disclaimer as C1

**Effort.** S–M. **TX?** internet only.

### C3 — APRS-IS messaging (no RF)

**What.** Send/receive `:CALL:` over the IS socket.

**Depends on.** C1, A3 UI.

**Plan.** Subscribe to messages to our call (`filter m/CALL`). Send as IS lines. Share A3 inbox.

**To-do**
- [ ] IS filter `m/CALLSIGN` (and range if we want)
- [ ] Parse incoming messages into A3 table (`via=IS`)
- [ ] Compose → IS `send`
- [ ] Acks

**Effort.** M. **TX?** internet.

---

## D. DMR as packet (UART, works today)

### D1 — Periodic position SMS

**What.** Poor-man’s APRS on a TG. OEM `SendSmsMessage` (0x2C) already works; POS button is one-shot.

**Depends on.** Nothing DSP. Digital channel + contact/TG.

**Plan.** Interval or SmartBeacon; same body as current POS (`GPS:lat,lon` or APRS-ish). Don’t steal analog hijack.

**To-do**
- [ ] Prefs: enable, interval, only-when-moving, dest = current `txContact` or fixed TG
- [ ] Reuse POS message builder (background Geocoder)
- [ ] `DmrManager.saveSms` / send path; respect analog-hidden POS
- [ ] Don’t send on analog; don’t send without a fix
- [ ] Battery: min interval 1–5 min moving, 30 min stopped

**Effort.** S–M. **TX?** DMR SMS.

### D2 — BrandMeister APRS via SMS/GPS

**What.** Many BM masters parse a GPS SMS into APRS-IS. Format is master-specific (NMEA `$GPRMC`, `APRS:…`, etc.).

**Depends on.** D1. **Research first** (one evening): current BM GPS/APRS SMS template.

**Plan.** If a documented template exists, add “Format: BrandMeister APRS” next to D1. If not, don’t guess.

**To-do**
- [ ] Document the live BM expected SMS body (wiki / selfcare / a test hotspot)
- [ ] Template in prefs; default off
- [ ] Test: SMS to BM → aprs.fi
- [ ] If no stable template: drop D2; users use C2

**Effort.** S research + S code. **TX?** DMR.

### D3 — DMR SMS mailbox polish

**What.** Not a new PHY. Threaded canned messages, last-heard, status 8/9 (send ok/fail).

**Depends on.** OEM SMS UI; `hookMessageDisplay` already does GPS links.

**Plan.** Optional. Don’t block A/C.

**To-do**
- [ ] Canned phrases
- [ ] Delivery icon from status 8/9 if not shown
- [ ] Last-heard DMR ID in composer (RadioID lookup)

**Effort.** S–M.

---

## E. Analog signaling (not AX.25)

### E1 — NOAA SAME weather alerts

**What.** 1050 Hz + AFSK header on **162.400–162.550** (WX1–WX7). Not APT (137 MHz satellites). High civilian value.

**Depends on.** G1 (tone freqs). Same PCM tap. Separate from `NOAAReceiver` APT.

**Plan.** Tune convenience like NOAA mode **or** flag a WX analog channel (passive, A2-style). Goertzel 1050 Hz preamble; decode SAME `ZCZC-ORG-EEE-PSSCCC+TTTT-…`. Notification + optional voice unmute (Soft SQ).

**To-do**
- [ ] SAME spec: origins, event codes, FIPS
- [ ] Demod on analog when freq in 162.4–162.55 **or** channel flag `wx_same`
- [ ] Preamble detect without 2 s batching
- [ ] Parse header; map EEE → text (TOR, SVR, RWT…)
- [ ] Notification + history; optional keep squelch open for 5 min voice
- [ ] Do not confuse UI with APT “NOAA” button — rename APT to “NOAA APT / satellite”
- [ ] Fixtures: recorded SAME bursts

**Effort.** M. **TX?** no.

### E2 — DTMF decode (and later encode)

**What.** OEM `DTMF.csv` is header-only. Decode from RX; encode for autopatch if G3-like TX tones work.

**Depends on.** G1. TX encode ~ G3 (DTMF is not AFSK; voice DSP may pass DTMF even if AFSK dies).

**Plan.** Dual-tone Goertzel 697–1633 Hz, 50 ms. Show digits in history. TX: generate stereo frames on PTT or a “send tone” button.

**To-do**
- [ ] RX Goertzel; debounce; `*` `#` A–D
- [ ] Intercom overlay or history `DTMF: 123*`
- [ ] Optional: match against a small code table (remote commands — keep conservative, no “kill radio on 999”)
- [ ] TX: generate pairs; stereo duplicate; test if DSP passes (independent of AFSK G3)
- [ ] If TX works: DTMF.csv import actually means something

**Effort.** M RX, S–M TX. **TX?** optional.

### E3 — SSTV TX

**Not packet.** Reverse of robot36 TX + same stereo `writeFrame` as G3.

**To-do**
- [ ] After G3: 1900 Hz leader + VIS + Robot36 line timings as stereo PCM
- [ ] Pick image from gallery; progress UI
- [ ] If G3 AFSK failed, still try SSTV (different spectrum); separate go/no-go

**Effort.** L. **Priority.** After packet modem.

### E4 — POCSAG / Selcall / MDC-1200

**Plan.** Don’t. Low ham value; 8 kHz is marginal for POCSAG 1200/2400.

**To-do**
- [ ] Explicitly out of scope unless a user brings a pager-on-2 m use case

---

## F. Explicitly out of scope (this radio)

Do not put on the roadmap without new hardware (SSB, 9600 discriminator, another PHY).

| Mode | Why |
|---|---|
| FT8, JS8Call, WSPR, PSK31, RTTY, Olivia, Contestia | Need SSB |
| HF 300 baud packet, Winlink HF (ARDOP/WINMOR) | No HF |
| VARA FM | Closed, Windows, needs a clean sound card |
| 9600 G3RUH / GMSK | Discriminator / flat TX; 8 kHz voice PCM will not carry it |
| D-STAR, YSF, M17, NXDN, P25 data | Wrong PHY |
| AIS, ADS-B | Wrong band |
| LoRa APRS | Different radio |
| Winlink over 1200 packet | Possible **after** A4+G3 as a *client on KISS*, not a mode we implement |

---

## Recommended build order

Do **not** start these until G0 (HEAD on device). Nearby Repeaters is a separate track (`07`).

| Step | Item | Unlocks |
|---|---|---|
| 0 | G1 sample layout | All tone math |
| 1 | G2 harness + F1 streaming modem | Frames |
| 2 | A1 javAPRSlib | Useful RX |
| 3 | A2 passive decode | Kills hijack for APRS |
| 4 | C1 iGate + C2 phone beacon | Real APRS presence |
| 5 | A4 KISS TCP (RX first) | APRSdroid |
| 6 | G3 stereo TX experiment | Go/no-go RF TX |
| 7a | If G3 **pass**: B1 RF beacon, A3 RF messages, A5 via KISS | Full TNC |
| 7b | If G3 **fail**: D1 position SMS, B2 optional Mobilinkd, A3 via IS only | Still useful |
| 8 | E1 SAME | Weather radio |
| 9 | E2 DTMF RX | Nice-to-have |
| 10 | A6 FX.25, E3 SSTV TX, C3 IS messages | Later |

**v3.6-ish packet slice:** steps 0–4. **v3.7:** 5–7. **v3.8:** SAME + DTMF.

---

## Dependency graph (short)

```
G1 sample layout
 └─ F1 streaming HDLC ─ G2 harness
      ├─ A1 APRS parse ─ A2 passive ─ A3 messages UI
      │                      └─ C1 iGate ─ C2 phone beacon ─ C3 IS msg
      ├─ A4 KISS TCP ─┬─ APRSdroid
      │               └─ A5 connected (needs G3)
      └─ A6 FX.25
G3 stereo TX ─┬─ pass → B1 RF beacon / RF iGate / A3 RF
              └─ fail → D1 SMS beacon, C2, B2 TNC
D1 ─ D2 BM APRS (research)
E1 SAME, E2 DTMF  (only need G1)
```
