# Plan: M17 SMS (packet mode) in SignalDeck

Owner direction 2026-10-26: on the route list after M17 voice and the hotspot session; built now (Grok Build, overnight
2026-10-26/27, host work plus the HackRF bench), tested against an independent station when the hotspot is up. Everything
is app-side; no firmware change is expected (the symbol engine and the audio-path receiver already carry M17 stream mode).

## 1. What M17 packet mode is

Read from `https://spec.m17project.org/files/M17_spec.pdf` (the PDF served as the current specification on
2026-10-26). Widths below are that document's, not the earlier recollection.

- **One transmission** (table 2.14): preamble, one **link setup frame** (LSF sync `0x55F7` plus the 240-bit LSF),
  then **1 to 33 packet frames** (packet sync `0x75FF` plus the frame), then the end-of-transmission marker.
  Packet mode has no LICH. The LSF is sent once, in full.
- **LSF** is the same 240 bits voice uses: destination 48, source 48, TYPE 16, META 112, CRC-16 16. CRC is
  polynomial `0x5935`, init `0xFFFF`, stored big-endian, over the 28 bytes before it.
- **Packet LSF TYPE** (table 3.14): only the packet/stream bit and the channel access number are defined. Every
  other bit is reserved and is 0. The packet/stream bit is 0 for packet (1 is stream, the same bit voice sets).
  The channel access number is the same four bits voice uses, TYPE bits 10:7, so the type word is `CAN << 7`.
- **Packet frame** (tables 2.15–2.17): 200 bits (25 bytes) of the packet, then a **6-bit** metadata field.
  206 type-1 bits. The metadata's first bit is end-of-frame. The other five are the frame number, 0–31, while
  more data remains, and on the last frame they are the number of valid bytes in that frame, 1–25. The frame
  counter starts at 0 and increments after each non-final frame.
- **Coding:** 206 bits plus 4 flush bits, rate-1/2 K=5, 420 type-2 bits, punctured with
  **P3 = [1, 1, 1, 1, 1, 1, 1, 0]** to 368 type-3 bits, then the same 368-bit interleaver and randomizer as a
  stream frame. The sync word in front is `0x75FF`.
- **Packet data** (section 3.3.2, table 3.15): a type byte (values 0–127 are one byte; the reserved names are
  `0x00` raw, `0x01` AX.25, `0x02` APRS, `0x03` 6LoWPAN, `0x04` IPv4, **`0x05` SMS**, `0x06` Winlink), then the
  payload. SMS is a null-terminated UTF-8 string. A CRC-16, the same polynomial, is computed over the type byte
  and the payload, including the null, and appended big-endian. That whole buffer is split into 25-byte chunks.
  One transmission carries at most 823 bytes of type-plus-payload, which is at most 33 frames.
- Destination is a callsign or `@ALL`. Source is the station callsign. META is left at zero for an SMS.

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
