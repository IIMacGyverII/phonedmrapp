# Plan: M17 SMS (packet mode) in SignalDeck

Owner direction 2026-10-26: on the route list after M17 voice and the hotspot session; built now (Grok Build, overnight
2026-10-26/27, host work plus the HackRF bench), tested against an independent station when the hotspot is up. Everything
is app-side; no firmware change is expected (the symbol engine and the audio-path receiver already carry M17 stream mode).

## 1. What M17 packet mode is (verify every number against the current spec before coding)

Read `spec.m17project.org` (the M17 protocol specification, current revision) and write the exact field widths into
§1 of this file before the first line of code. What the spec says, as far as the manager recalls it:

- **One transmission** = preamble, the **link setup frame** (LSF) with the type field marking **packet mode**, then
  one or more **packet frames**, then EOT. There is no LICH in packet mode: the LSF is sent once, in full, as the
  stream mode's LSF frame is.
- **LSF type field:** bit 0 packet/stream (0 = packet), bits 2:1 data type (data), bits 4:3 encryption (none), bits
  10:7 CAN; the same 240-bit LSF with its CRC as voice uses, the same encoding (conv code, P1 puncturing).
- **Packet frame:** 25 bytes of payload plus a 6-bit field; the field's top bit marks the last frame, the other
  five carry the frame counter on inner frames and the number of payload bytes used on the last frame. 206 bits,
  convolutionally encoded, punctured with **P3** to 368 bits, interleaved and randomised like a stream frame, with
  the **packet sync word 0x75FF** in front (our `m17.py` already defines `SYNC_PKT`).
- **Payload:** the first byte is the protocol: 0x00 raw, 0x01 AX.25, 0x02 APRS, 0x03 6LoWPAN, 0x04 IPv4, **0x05 SMS**,
  0x06 Winlink; then the data; then a **CRC-16** over everything before it (the M17 CRC, polynomial 0x5935, init
  0xFFFF, the one the LSF uses). SMS data is the text, null-terminated. Maximum about 800 bytes in 33 frames.
- Destination: a callsign or `@ALL` (broadcast), as in voice; source the station callsign.

## 2. What to build (SignalDeck, branch `grok/m17-sms`, one PR)

1. **Frames, `ham/M17.java`:** `encodePacketLsf(src, dst, can)`, `encodePacket(payload)` (the 25-byte split, the
   6-bit field, P3 puncturing), `decodePacketFrame(symbols)`, CRC-16 (reuse the LSF one), `smsPayload(text)` and the
   inverse. Host tests: a round trip of several lengths (1, 25, 26, 200 bytes), the CRC against a vector from the spec,
   the last-frame count, a frame with two symbol errors still decoding (soft Viterbi as voice does).
2. **Transmit, `M17Station` / `RadioService`:** `sendSms(dest, text)` builds preamble + LSF + packet frames + EOT as
   symbols and sends them through the existing symbol-engine path (the one voice uses: op 3 reset, chunks, key when
   ready, op 7 end, unkey after status 4). Bench firmware only, like voice; stock firmware returns the same refusal
   voice gives. Nothing in the voice path changes.
3. **Receive, the audio-path receiver (`HeldPathReceiver` / `M17Receiver`):** accept the packet sync word beside the
   LSF and stream ones; after a packet-mode LSF, collect packet frames until the last-frame bit, check the CRC, hand
   the payload up; protocol 0x05 becomes a text line in the history (kind `m17`), with source, destination and the
   text; other protocols are listed by name and length. The stream receiver's state machine is untouched for voice.
4. **M17 page:** a text box with a Send button (destination from the channel's M17 destination or `@ALL`), the sent
   and received texts in the page's list, the history line on the intercom. 28 s is not a constraint (a full SMS is
   under 2 s). Help: the M17 topic gets a "Text messages" section; the CHANGELOG gets its row.
5. **Host decoder for the bench, `tools/m17-research/m17.py`:** `decode_packet_transmission(dev, fs)` beside the stream
   decoder, and an encoder for packet transmissions, so the HackRF loop below can run from the PC.

## 3. Bench (Grok owns the phone; the Faraday cage; 467.625 MHz low power; callsign N0CALL on the air)

1. **Receive:** the host encoder makes an SMS transmission (a few lengths, `N0CALL` to `@ALL`), the HackRF sends it
   at 467.625, 2.4 kHz deviation, VGA 20; the phone on the analog test channel with M17 receive on lists the text. Pass
   = the text and the source appear payload-exact for every length, on three transmissions each.
2. **Transmit:** SignalDeck sends an SMS from the M17 page; the HackRF captures; the host packet decoder reads it back
   payload-exact with the CRC good, three times. The runner's `stream` test (voice) still passes on the same image.
3. **Both ways in one go:** the phone receives a HackRF SMS and answers with its own; both decode.
4. Record in `results.md` (lengths, frames, CRC, any frame loss), the PR number and the host test count in the report.

The independent check (the hotspot's reflector sending SMS to us and seeing ours) waits for the hotspot session.

## 4. Rules

- Write from the spec. **libm17 and m17-cxx-demod are GPL-2.0-only: never read their code into ours.** Our own
  `m17.py` and `M17.java` are the references.
- No firmware change; no change to the voice path's behaviour; stock firmware stays receive-only for M17.
- Bench callsign only (`N0CALL`); nothing identifying in the repo, the captures or the report.
- Commit only your own paths in SignalDeck; host tests green before the bench; the PR body starts with "## What's
  new"; in-app help updated in the same PR.
- Report through `radio_firmware/HANDOFF.md` as always: STATUS REVIEW with the bench numbers, STUCK with what was
  tried.
