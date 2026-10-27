# Plan: POCSAG receive, the Messages threads, and the web app's gaps

Owner direction 2026-10-26 (23:45): queued for Grok Build after the M17 SMS step; tested on the bench with the HackRF
now, against real pagers and the hotspot later. Two parts, two branches, two PRs, in this order. Everything is
app-side; **no firmware change**. The mock-ups the owner approved tonight are the design: one thread per contact across
DMR, M17 and pager; a receive-only monitor mode for watching several pager traffic points; a tap on any RIC opens its
thread.

## A. POCSAG receive (branch `grok/pocsag-rx`)

What is known (do not re-measure): `docs/pocsag-deep-dive-2026-10-22.md` and `radio_firmware/reviews.md` R-F.
- On the **held path** (op 6 variant 3, the M17 receiver's register hold) behind the Armor's 41 M17 taps, a 1200 bps
  DAPNET-style page slices to **0.039 bit errors per codeword**, which BCH(31,21) clears. Plain held path: 0.24.
- On **stock firmware** the audio is AC-coupled and loses the bottom octave: plain slicing gives 21-23 % errors; the
  decoder that works there is the DFE with **BCH correction inside the feedback loop** (`tools/pocsag-research/rx/blind3.py`),
  trained per phone on a random-bit calibration (`rx/equalizers/eqcal2500` for the Armor at 2.5 kHz). At the standard
  4.5 kHz deviation the module's limiter compresses and the floor is 1-2 % (partial pages); that is a limit, not a bug.
- The sync word, idle word, BCH and the address/message word layout are already in `ham/Pocsag.java` (encoder side):
  reuse `bch`, `check`, `SYNC`, `IDLE`; add the decode direction beside them.

Build:
1. **Decoder, `ham/PocsagDecoder.java`** (host-testable, 8 kHz float audio in, pages out): preamble detect (576 bits of
   alternation at 512/1200/2400, auto-rate by the preamble period), bit clock from the transitions, sync word search
   in both polarities (the radio's sense inverts a plain slicer's expectation, see the transmit bench note in `CLAUDE.md`),
   codeword slicing, BCH(31,21) correction (one or two bits), batch assembly, address words (RIC = 18 bits << 3 | frame
   position, function 0-3), message words to numeric (4-bit BCD) and alphanumeric (7-bit) text, idle word ends the
   message. Two front ends behind one interface: **held** (plain slicer behind the station's current M17 taps; the
   `HeldPath` tap table is the one to reuse, not a new fit) and **plain** (the DFE with BCH in the loop, equaliser
   coefficients shipped per profile from `rx/equalizers`, the Armor's first). Pick the front end the way `M17Station`
   does, from the version tag.
2. **Station, `PagerStation`** (like `M17Station`): starts and stops with a PKT switch and with monitor mode, holds the
   register when a stub tag is reported (reuse `setHeldPath`), feeds the decoder from the same tap `M17Station` uses,
   never alters the voice path, and runs below the squelch like the other data decoders (Soft SQ only gates the
   speaker). Every decoded page goes to a **pages store** (time, frequency, RIC, function, baud, text, corrected
   codewords, the signing callsign when the text starts with `CALLSIGN:`), to the intercom history as kind `page`, and
   raises a notification when `Station.isMyRic` matches. Keep the last 2000 pages.
3. **Threads.** A page files under the **contact that carries its RIC** (contacts already store RICs), else under the
   callsign of a signed text, else under a thread named by the RIC. The existing DMR text threads and the M17 SMS
   list (PR 24) join the same store with a transport tag, so the **Messages tab** lists one thread per contact across
   DMR, M17 and pager with unread counts and the transport chip. Inside a thread: received left, sent right, time,
   baud, check state (signed / sent / corrected codewords); the compose bar adapts to the transport (pager: RIC chips,
   speed, signing, the existing `PagerScreen` send routine; M17: destination; DMR: ID or talkgroup). A page for another
   thread shows a one-line banner at the top of the open thread. **Tap any RIC** (pages list, history line, contact
   RICs) and its thread opens, with "Save as contact" and "Mute" on an unassigned RIC thread.
4. **Monitor mode** (the switch in the Messages header): receive only, sending disabled in the tab, the "All pages
   heard" list is the front page, and a **pager scan list** of frequencies runs through the channel scanner so several
   traffic points are heard in turn (dwell long enough for a batch, about 2 s at 1200 bps; the scanner's existing
   refusals apply). Kept across restarts (pref), off by default.
5. **Help** in the same PR: a "Messages" topic (threads, monitor mode, tapping a RIC, what a signed page is), the
   Pager topic gains the receive paragraph, the M17 topic's "Text messages" section points at the Messages tab.
   `CHANGELOG.md` row. No change to `PagerScreen`'s send path beyond calling it from the thread.

Bench (HackRF; receive only, so no radio key; 2.5 kHz deviation first, 4.5 kHz second):
- `tools/pocsag-research/pocsag.py gen` makes pages (three RICs, numeric and alphanumeric, 512/1200/2400). Pass: on
  the held path every page listed payload-exact, 3/3 per rate; on the plain path (stock-tag simulation: start the
  decoder with the hold off) the 2.5 kHz pages 3/3, the 4.5 kHz pages reported with their corrected-codeword count.
- Threads: a page to a RIC on a contact lands in that contact's thread; a signed page from an unknown RIC lands under
  the callsign; a bare page under the RIC; tapping the RIC in "All pages heard" opens it. Monitor mode: two frequencies
  in the scan list, pages on both heard in turn.
- Record in `results.md`; the independent check (a real pager and the hotspot's POCSAG output) waits for the hotspot.

## B. Web app: the pager page and the other gaps (branch `grok/web-pager`)

The browser app (`assets/web/`, `web/WebHost.java`) has no pager page and no pager endpoint. Inventory of what the
phone has that the browser does not (checked 2026-10-26 23:40 against `index.html` and the `/api/` routes):
1. **POCSAG page**: a form with frequency, speed, RICs or a contact, text, signing, and Send, calling the same
   send routine `PagerScreen` uses through a new `/api/pager/send`; the firmware refusal text passes through to the
   page. Plus `/api/pager/pages` (the pages store from part A, newest first, with a RIC filter), the pages list on the
   browser's Messages page once part A lands, and the monitor-mode switch mirrored (`/api/pager/monitor`).
2. **M17 text messages** (after PR 24): the Packet page's M17 panel is receive-state only; add the text box and
   `/api/m17/sms` (destination, text), and the sent and received texts from the M17 station.
3. **Messages page**: make sure it sends DMR texts (private and group) as the phone does, and show the transport chip
   and the threads from part A's store, so the browser's Messages page is the same tab as the phone's.
4. **SAME alerts heard** and the **WX monitor** state are on no browser page: a small "Alerts" panel on the Packet
   page from the existing alert store.
5. **Device page**: none in the browser. The firmware loader stays on the phone (owner's safety contract: identity
   three ways, a hand on the device); a read-only Device panel (module tag, profile, battery and AP temperatures,
   "Own the radio at boot" state) is useful for the remote bench. Owner decides whether any switch is writable from
   the browser; default read-only.
6. **Help**: `/api/help` serves `HelpView.topicsForWeb`; every new page needs its topic in `HelpView.TOPICS` so the
   browser help stays the phone's help.

Bench: headless Chrome against `adb forward` (recipe in the SignalDeck memory "SignalDeck Web bench"): send a page from
the browser (HackRF capture, host decoder reads it), the pages list shows a HackRF page within a second of the phone,
the M17 text box sends and lists. The PIN is never logged.

## C. Rules

- Write the decoder from the POCSAG standard (ITU-R M.584) and our own research files; no third-party decoder code
  (multimon-ng is GPL: use it only as the independent check on captures, as the transmit bench did).
- Bench callsign only; RICs in fixtures are the research list's, never a real pager's.
- Commit only your own paths; host tests green before the bench; PR bodies start with "## What's new"; help and
  changelog in the same PR; never touch the firmware tree, the voice path or the send routine `PagerScreen` uses.
- Report through `radio_firmware/HANDOFF.md` after each part (STATUS REVIEW); STUCK with what was tried.
