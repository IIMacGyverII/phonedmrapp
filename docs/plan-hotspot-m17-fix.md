# Plan: fix the hotspot's M17 transmit (and get more out of it for M17)

**Owner, 2026-10-30:** plan the fix and do it later. Not scheduled yet.

## The fault

- **Since the SD card was re-flashed (2026-10-28), the hotspot's M17 transmission doesn't decode on any receiver here.** On 2026-10-30 08:43 an 11.6 s `m17bench` call (N0CALL, 467.625 MHz, CAN 7) was logged as sent by MMDVMHost.
  - The Atom XL heard the carrier but listed no call.
  - A HackRF capture run through `tools/m17-research` shows **no M17 frame sync** (best correlation 0.83, either polarity). The same script decodes our own HackRF M17 file 100/100.

  So the hotspot's RF is wrong, not the phones.
- **Before the re-flash it worked.** On 2026-10-27 the Armor decoded this hotspot's M17 (parrot replays at 85–94 %, 74 of 79 frames clean with CAN 7). Receive had needed `RXOffset` around −450 Hz.
- **Settings in place since the re-flash** (atomxl-status 08:53): `[Modem] TXInvert=1`, `M17TXLevel=50`, `RFLevel=20`. `TXOffset` and the modem firmware version are unknown.

The hotspot is an AURSINC duplex MMDVM board on a Pi Zero 2 W running WPSD, at `pi-star@192.168.1.194`, using the SSH key in the private-resources list.

## Fix, in order

**Bench:** the hotspot plus the HackRF (receive only), about 30–45 min, with the usual leases (firmware work has priority). Everything stays in the cage, at low power on 467.625 MHz, with bench IDs only.

1. **Record the starting state (read only).**
   - `/etc/mmdvmhost` in full.
   - The MMDVMHost version and the modem's reported protocol version and firmware description (the start-up lines of the MMDVM log).
   - The WPSD version.
   - Look for any pre-re-flash backup: `~/claude-bench/` on the hotspot, the PC's scratch folders, the bench notes in `radio_firmware/results.md` (2026-10-27 hotspot sections).
2. **Compare with the settings that worked on 2026-10-27.** Note every difference: `TXInvert`, `RXInvert`, `M17TXLevel`, `TXLevel`, `RFLevel`, `TXOffset`, `RXOffset`, `[M17] CAN`, `[M17] Enable`, `TXHang`, the modem type and port.
3. **Check the modem board firmware.**
   - If the re-flash brought an older or different MMDVM_HS firmware, or one built without M17, re-flash the board with the current MMDVM_HS release for this board, using WPSD's own flash tool.
   - Record the old and new versions.
   - This step changes the board, so do it only after step 1 has recorded everything.
4. **Measure and adjust, one change at a time.** For each change, record a 5 s hotspot M17 call (the parrot or `m17bench`) with the HackRF, then measure:
   - frame-sync correlation and decode with `tools/m17-research`;
   - deviation (p99; target about ±2.4 kHz for the outer symbols);
   - carrier offset;
   - polarity.

   Order: `TXInvert` 0/1 → `M17TXLevel` (30 / 50 / 70) → `TXOffset` from the measured carrier offset.

   **Pass:** link setup CRC good and ≥ 95 % of frames payload-exact.
5. **Independent decoder.** Run the Mobilinkd `m17-demod` on the same capture (`radio_firmware/plan-independent-m17-check.md`; Linux box, WSL, or the native build). Both decoders must agree.
6. **Phones.** Hotspot parrot → Armor and Atom XL: the M17 page lists the call with the right callsign, frame counts recorded. Hotspot → Armor on the held path (FW57) and on the DFE path (factory firmware).
7. **Keep it safe from the next re-flash.**
   - A copy of the working `/etc/mmdvmhost` and the board firmware version, in the private Gitea `SignalDeck_Resources`, with a row in its README.
   - The settings themselves (nothing secret) in `tools/hotspot-bench/README`.
8. **Close the open item** in `docs/m17-research-report.md` §9 ("the hotspot as a transmitter") and in the M17 announcement's follow-up, Discussions #155.

## Later, separate owner decisions

- **Link to an M17 reflector** through M17Gateway.
  - **What it gives:** real M17 stations' traffic comes out of the hotspot as genuine M17 from many radios, which is the independent receive test we lack. Our transmissions also reach real users who can report.
  - **What it needs:** internet on the hotspot and the owner's licensed callsign (not N0CALL); transmit stays low power into the cage.
  - **Rule:** the owner's callsign is configured only on the hotspot, never written into a repo or log.
- **The packet mode (M17 SMS) mismatch:** the hotspot recognises our packet link setup but logs "ended before its last frame".
  - After the fix, try a current MMDVMHost and M17Gateway, and decode our packet frames with the Mobilinkd tools.
  - Then decide whether our framing (metadata/last-frame field, P3 puncturing, CRC placement) or the hotspot's reader is wrong.

## Rules

- A hotspot-only fail never counts; confirm with the HackRF and our decoder, or the Atom XL (owner, 2026-10-29).
- Phone and hotspot only with a pushed lease line.
- Back up `/etc/mmdvmhost` before any change and restore what isn't part of the fix.
