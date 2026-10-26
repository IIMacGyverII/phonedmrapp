# FW27 — receive-RAM stream (R-C reopened)

Approved 2026-10-26 with the keepalive, the half-complete poll, and the phone-audio check. The audio-path receiver stays the default. Nothing in the image keys at boot.

Facts used. RC20: op 5 saves `WORK_MODE` (`0x11000100`), stores `0x80`, copies the half `FM_ADDR_SW` is not pointing at (`1` → `0x160006E0`, `2` → `0x160004E0`, 256 big-endian samples), then restores `WORK_MODE`. The mirror fills only in that `0x80` state. RC40: with the variant-4 registers held for the copy, that baseband is flat; plain M17 (no equaliser) was the right decoder and did not pass on the captured halves. RE10: op 6 variant 4 saves `WORK_MODE` at `0x4B000` and the bandwidth word at `0x4B004`, sets `0x4B008` to `0x484F4C44` while applied, and restores both words plus AT1846S `0x58` = `0x8405`. Op 5 returns `sr=1` while that marker is set, so it cannot read during a hold. The 01:41 mode-0 dump was an idle RAM for that reason, not a measurement of the mirror. A channel write stores `0x58` = `0x8405` on its own; the hold does not survive it. UART: boot programs the DesignWare UART from the 48 MHz clock, divisor for 57600, actual 57692 Hz (+0.160%). The same clock and a divisor of 13 is 230769 Hz, also +0.160%. A 514-byte half is 89 ms at 57600 and 22 ms at 230400. The half is 32 ms of 8 kHz audio. `RadioEngine.open` passes `profile.baud` (57600 on the Armor) to `VendorSerial.openPort`. The Xplore profile already opens a port at 230400 through that JNI.

## 1. The RAM fill beside the hold

One new op 6 variant, mode 5. It is not variant 3 or 4, and channel 56 does not apply it.

Action 1 saves `WORK_MODE` and the bandwidth word in the same two words variant 4 uses, then sets a different marker at `0x4B008` so the existing op 5 refusal does not fire. It writes AT1846S `0x58` = `0xBCFD` (the bypass the hold uses), `WORK_MODE` = `0x80`, and clears `FM_BANDWIDTH` (`0x11000500`) bits 4 and 6, the FM band-pass bits the FM key-up already clears. It does not write PTT.

Action 0 writes the two saved words back, writes `0x58` = `0x8405`, and clears the marker. Same end state as a variant-4 restore.

A channel write (`0x23`) already puts `0x58` back to `0x8405`. The same path clears this marker and stops a stream, so a retune cannot leave `0x80` set. The host re-applies mode 5 only when it still wants the stream. The audio-path hold is a separate re-send and is not changed.

Op 5 is allowed while mode 5 is up. It copies a half and does not save or restore `WORK_MODE` on the way through, because the stream state is already `0x80`. Mode 4 of op 5, which applies variant 4 for the length of one copy, is not used in this state.

## 2. The UART speed switch

Op 16 on `0x40`. Body `[16, rate]`, `rate` 0 = 57600 and 1 = 230400. Anything else is `sr=1` and the divisor is not written. The FW26 opcode gate admits through 15; FW27 raises it through 17.

The module checks the frame at the current rate, sends the ack at that rate (`sr=0`, body echoes the rate it is about to use, including a switch back to 57600), and only then writes the divisor. The host waits for that ack, closes the port, and opens the new rate. `profile.baud` stays 57600. The open is a session override passed to `VendorSerial.openPort`, dropped on process death so the next open is 57600 again.

The first command after the reopen is `0x34`. The tag must be `DMR003.FW27.V022`. If it does not arrive, the host closes, opens 57600, and sends `0x34` again.

Fallback. Boot's existing UART init keeps writing the 57600 divisor, so a reboot is 57600 before any command. While running, if no valid host frame arrives for 30 s, the module writes the 57600 divisor itself. Thirty seconds covers the 10 s bench stream, during which the host is quiet, and the idle test waits 35 s. Any valid host frame, including the stop, resets the timer.

The loader is never entered at 230400. The update knock is NAKed while the 230400 divisor is in force, and the module does not switch on its own to accept it. The host sends op 16 rate 0, reopens at 57600, checks `0x34`, and only then starts a load.

## 3. The stream

Op 17. Body `[17, action]`. Action 1 starts, action 0 stops, action 2 is a keepalive. A start with mode 5 not applied returns `sr=1` and sends no samples. The op does not touch the registers; mode 5 did. The keepalive resets the 30 s silence timer and does not start, stop, or skip a half. The host sends it every 10 s while a stream is running. The timer keeps running during a stream, so a host that has died still falls back. Every other command still ends the stream.

A half is sent when a poll of `FM_ADDR_SW` shows it has moved to the other buffer. That is the same test op 5 already spins on. The image's command path does not hook `SYS_INTERP_LIST` bit 14 for this copy, so the stream does not add that interrupt. The poll sits in the op 17 handler after the start ack, beside a poll of the UART receive register. One trip is a few dozen instructions, under a tenth of a millisecond, so it does not spend the 9.2 ms margin. The margin stays available for a status frame.

Each completed half is one unsolicited `0x40` frame. Body: opcode 17, sequence low, sequence high, the half id op 5 already appends (the observed 0/1 alternation), then the 512 big-endian sample bytes. The sequence counts halves from 0 at the start and wraps at 65536. A skipped sequence, or two frames in a row with the same half id, is a missed half. The half that `FM_ADDR_SW` is not pointing at is the one sent, the same choice as op 5.

The first valid host frame ends the stream after the current half, unless it is action 2. Op 17 action 0 acks `sr=0`. Any other command is then executed, not dropped, and mode 5 is restored before that command runs. This is not the loader's path, which drops inbound frames so a load runs to the end. A channel write therefore clears mode 5 on its way through.

Wire time at 230769 bit/s and 10 bits per byte. The frame is 9 bytes around a 516-byte body, 525 bytes, 22.8 ms. The half is 32 ms, so 9.2 ms is spare. A module status push (`0x36`, about 10 bytes, 0.4 ms) is sent in that gap, before the next half, when one is pending. One or two fit. The status command is edge-triggered, not periodic. If a half is not on the wire before the next half completes, the sequence skips and the radio is not stalled to catch up.

## 4. Bench, after the review

USB adb. FW26 stays loaded until this page is accepted. Then FW27, tag in the version string, nothing keyed at boot, no band-limit or power patch.

(a) At 57600, op 16 rate 1, ack at 57600, reopen, `0x34` reads `DMR003.FW27.V022`. Idle with no host frame for 35 s. `0x34` at 57600 reads the same tag. An update knock sent at 230400 is NAKed and the tag is unchanged.

(b) Mode 5 on, op 16 to 230400, op 17 start. A 1 kHz HackRF tone at 467.625 MHz, low power, 2.5 kHz deviation, dummy burst first, 10 s. The line's frequency in the stream is the sample rate (8000 Hz if the half really is 32 ms). Sequence gaps and repeated half ids: 0. During that same tone, one phone `rxclip`. If the clip contains the 1 kHz line, mode 5 leaves the speaker path up and (c) can use one transmission. If it does not, the stream has the speaker and (c) needs a second copy of the file with mode 5 off. Then one 45 s stream of the same tone with a keepalive every 10 s. The rate must still be 230400 at the end, and the gap count still 0. Mode 5 off, rate back to 57600, `0x34` again.

(c) The same setup. One 30-frame M17 transmission at −88 dBm, bench callsign, 0.5 s of carrier after the end frame. Decode the stream plain, no equaliser, and record the payload-exact count. Decode it again with the shipped taps. If (b) heard the tone on the phone, compare those counts with channel 56's listing of that same transmission. If it did not, play the file once more with mode 5 off and compare with that listing. The route passes when (b) has 0 gaps and the plain count is at least the audio-path count.

(d) The runner's `all`, at 57600, mode 5 off. The audio-path numbers are the regression. The stream is not the default.

## 5. Out of scope

Band limits, transmit power, and the transmit path. Variant 3 and variant 4 keep today's behaviour. The live receiver on channel 56 keeps using the phone audio and the hold. The stream is a second receiver the host turns on for this measurement.

SignalDeck's side (profile-rate override and reopen, the frame parser, the stream receiver beside the audio one, help, changelog) is Claude's, on `claude/ram-stream`, after FW27's bench. The phone is Grok's for that bench.
