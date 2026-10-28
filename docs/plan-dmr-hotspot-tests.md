# Plan: DMR tests with the MMDVM hotspot (2026-10-27)

**Owner:** IIMacGyverII. **Runs the tests:** Claude (host side and bench). **Firmware work, if a test shows it is
needed:** Grok, through `radio_firmware/HANDOFF.md`. **Tools:** `tools/hotspot-bench/` (relay on the hotspot, window on
the PC). Everything stays in the Faraday cage, at low power, with bench IDs only.

## 1. What the hotspot can do for DMR

The relay takes the place of DMRGateway on MMDVMHost's local link (`[DMR Network] Type=Gateway`, UDP 62031/62032).
MMDVMHost sends a `DMRC` configuration packet every 10 s and one `DMRD` packet per burst of a call:
`DMRD`, sequence, source 3, destination 3, repeater 4, flags (bit 7 slot 2, bit 6 private call, bits 5–4 frame type,
bits 3–0 data type), stream id 4, 33-byte burst.

| Ability | Status |
|---|---|
| Log every DMR call the hotspot hears (source, destination, slot, group or private, length) | built |
| Parrot: replay each call it hears, about 1.5 s after the end | built |
| Replay the last call on demand | built |
| Replay a recorded call with a different source, destination or call type | phase 2: the IDs are also inside the call's link control (voice header, terminator and the embedded LC in the voice bursts). The relay has to re-encode those from ETSI TS 102 361-1 (BPTC(196,96), the CRC masks, the 5-bit checksum of the embedded LC). Our own code, written from the standard. |
| A different colour code | hotspot setting `[DMR] ColorCode`, one restart |
| Time slot 1 | the simplex board uses slot 2 only. Slot 1 needs `Duplex=1` and split frequencies: a SignalDeck channel with RX on the hotspot's TX frequency and TX on its RX frequency. |
| Decode DMR voice to audio on the PC | not possible: no AMBE+2 decoder on the PC. The Armor's module decodes, so the Armor is the listener. |

**IDs.** Only bench IDs go on the air: the hotspot's placeholder ID 1234567, SignalDeck's own radio ID, and the test
talkgroups 1, 9 and 99. Never another station's ID.

**Needed from the owner, once:** a SignalDeck bench DMR channel on the hotspot's frequency, 467.625 MHz, colour code 1,
time slot 2, transmit contact talkgroup 9, receive list containing 9. The existing "dmr test" channel is on 467.700 MHz
and slot 1.

## 2. Promiscuous DMR receive: the A/B test

**What exists.** FW26 and later have the promiscuous flag: opcode 15 on `0x40`, `[15, v]`, a RAM flag that is off at
every boot. While it is on, both receive-handler admit gates pass every synced call, colour-code match-any is set, and the
`0x2B` caller-info reply grows to 11 bytes, adding the received colour code and slot. Those values have not been checked
against a real DMR carrier yet. With the flag off, behaviour is byte-identical to stock. SignalDeck's side is PR 11:
MON on a digital channel sends the flag on FW26 and later. Specification:
`docs/promiscuous-rx-patch-spec-2026-10-24.md`.

**Method.** The source of every call is the Armor itself: a short key on the bench channel, recorded by the hotspot.
The hotspot then replays it, in phase 2 rewritten to the case under test, and the Armor listens with the flag off (A),
then on (B). One case per row. The Armor's log gives `RECEIVE_START`, the `0x2B` body and whether audio played.

| Case | Call as replayed | A, flag off, expected | B, flag on, expected |
|---|---|---|---|
| 1 | group, talkgroup in the channel's list | heard | heard |
| 2 | group, talkgroup not in the list | silent | heard, the `0x2B` target is the talkgroup |
| 3 | private to the Armor's own ID | heard | heard |
| 4 | private to another bench ID | silent | heard |
| 5 | colour code 2 against the channel's 1 (hotspot `ColorCode=2`) | silent | heard, `0x2B` colour code reads 2 |
| 6 | slot 1 against the channel's slot 2 (duplex mode) | silent | heard if the slot gate is open; `0x2B` slot reads 1 |
| 7 | parrot of case 1 with the flag switched off again | heard | (n/a) proves the flag clears |

Cases 1, 3 and 5 run with today's relay. Cases 2 and 4 need the phase-2 rewrite. Case 6 needs duplex.

**Pass.** Every A column matches stock behaviour, so the flag off changes nothing. Every B row is heard, with the `0x2B`
colour code and slot equal to what was sent. Record each row in `radio_firmware/results.md` with the image tag, the
SignalDeck build and the log lines.

**When firmware work is needed.** Any B row not heard, a wrong colour code or slot in `0x2B`, or any A row that
differs from stock goes to Grok as an FW task in the handoff, with the failing row, the hotspot log and the Armor log.
Claude does not change firmware. The host side (SignalDeck PR 11, the relay, the window) stays Claude's.

## 3. The DMR voice enhancer: training pairs from one phone and the hotspot

`docs/plan-dmr-voice-enhancer.md` planned training pairs from two radios. The hotspot can replace the second radio:

1. SignalDeck transmits a known clean recording on the bench DMR channel. The Armor's module encodes it to AMBE+2.
2. The hotspot receives it and the relay keeps the call's bursts unchanged. Nothing is transcoded.
3. The parrot replays the same bursts, and the Armor receives and decodes them. SignalDeck records the decoded audio.
4. The pair is the clean recording and the Armor's decoded audio: one AMBE+2 encode and one decode, as on a real link,
   plus two RF hops.

What this gives: no second radio, no AMBE software on the PC, a fully scripted loop, and signal-level variation through
the hotspot's RF level and the Armor's distance. What it does not give: two different radios' codec implementations,
since the same module encodes and decodes, or a real repeater's timing. The two-radio pairs stay useful as a second set
once a second phone is on the bench. Dataset size is limited by real time: one hour of pairs takes about two and a half
hours on the bench. Needs SignalDeck's bench `txwav` on a digital channel, and `rxclip` or the recorder, both existing
diagnostics.

## 4. Order

1. Owner creates the bench DMR channel (§1).
2. Parrot check: an Armor key is heard by the hotspot, replayed, and heard by the Armor.
3. Promiscuous cases 1, 3, 5 and 7 (A and B), with a SignalDeck build that has PR 11.
4. Phase 2 rewrite in the relay, written from ETSI TS 102 361-1 with host tests against the hotspot's own recordings,
   then cases 2 and 4.
5. Duplex set-up for case 6, if the owner wants slot 1 covered.
6. Enhancer pairs: a short pilot of 10 minutes, scored by ear and by a simple distance measure, before any long run.
