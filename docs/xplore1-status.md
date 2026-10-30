# Xplore 1 agent status (mailbox)

STATUS: REVIEW (2026-10-30: review written, SignalDeck PR 159 and firmware repo PR 6 open, tester request drafted; one decision for the owner below)

Newest entries first. The Xplore 1 agent writes here; the managing agent reads and answers here and by message.

**2026-10-30 (Xplore 1 agent): REVIEW, all five deliverables up.**
- **Review:** `docs/xplore1/stock-app-review.md`, transmit first, then every item checked line by line; a summary table X1–X16 marks each point R (read) or I (inferred).
- **Main finding: QuickChat never sends `0x26`.** It keys with `intercom_ptt_control` 0 and releases with 1.
  - The microphone opens only at the module's SEND_START (status 3); the audio is raw 160-byte PCM blocks on `ttyS1`.
  - The microphone stops 200 ms after the release; there's a 1.5 s re-key rule.
  - At boot: no `0x2A`. After each channel's acknowledgement: `0x35` 2 → `0x37` 0.
  - Texts are type + target LE32 + UTF-8 (no 9-byte header).
  - A hidden updater uses the Armor-family knock with no image.
- **SignalDeck PR 159** (`xplore1/stock-app-parity`, on main after PR 158): Xplore-only profile fields, rev 3. Every other phone is pinned by `Xplore1ParityTest`.
  - The engine keys by `txLinesOn`/`txLinesOff` (no `0x26`).
  - `txAudioOnSendStart` (no SEND_START within 2 s → no audio, history line), `txAudioTailMs` 200, `minKeyGapMs` 1500, `bootMicInterrupt` off, `politeAfterChannel` 0, `smsUtf8` (receive decodes both encodings), `moduleLoader` off, `stockCommands`.
  - The Transmit test session gains a DMR text step on `smsUtf8` phones.
  - Help, radio notes and changelog updated; host suite 655/655. Not device-tested.
- **Owner decision needed:** PR 159 sets **`txTestUnverified = true`** on the Xplore 1, so the guided Transmit test session (only it) may key, as on the 20WT. The plan asks for a tester transmit session, but the owner approved this flag for the 20WT only. If no, drop that one line and step 5 of the tester request needs a test build.
- **Firmware repo PR 6:** `devices/blackview-xplore-1/README.md`, from my own worktree.
- **Findings doc:** `docs/multi-device-xplore1-findings.md` has a short "2026-10-30 review" section (mirrored in SignalDeck through PR 159).
- **Tester request:** `docs/xplore1/tester-request.md`, to post after PR 159 is in a beta.
- **Report checks:** none new were needed. PR 158's trial (squelch, level at two volumes, settle, band edges) already runs on this untested `mcu68` phone, and `stockCommands` now fills the "commands the stock app does not use" table. The ptt line is write-only, so the app log is the readback. The transmit-specific checks (line → SEND_START delay, SEND_STOP after release, `ttyS1` audio heard, text status 8/9) are in the session.
- **Kept on purpose:** volume byte 8 (QuickChat sends 0; receive is verified at 8 and the trial measures it), pwrsave 2, `0x36` acknowledgements, `0x3B` 120, `0x2B` queries. Reasons are in the review §3.

**2026-10-30 (Xplore 1 agent): started.** Reading the plan, the earlier findings and the 20WT example; QuickChat decompiled into a scratch folder outside the repos. Order: review document (transmit first), SignalDeck PR, report checks, transmit-session steps, tester request.

**2026-10-30 (manager): the plan is `docs/xplore1/plan-stock-app-review.md`.**
- **Finish the QuickChat review:** transmit first, then everything re-checked against SignalDeck's current Xplore path.
- **Make SignalDeck do what QuickChat does:** the profile stays unverified and transmit stays locked until a tester's session.
- **Then:** the Device-report checks and transmit-session steps a tester's next report needs, and a tester request.
- **Limits:** reading and code only; no phone, radio, HackRF or hotspot.
