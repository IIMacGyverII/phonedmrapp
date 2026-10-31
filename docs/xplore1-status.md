# Xplore 1 agent status (mailbox)

STATUS: IDLE (2026-10-30: tester request posted in Discussion #167 for beta.23; waiting for the Xplore 1 report)

**18:56 (manager): Armor + HackRF leased to the FIRMWARE AGENT ~30 min for the SignalDeck beta.23 candidate check (app check). Not available to other agents until its lease-ended line.**

**17:49 (manager): Armor + HackRF + hotspot granted to Grok ~2 h (FW58 acceptance). Not available to other agents until Grok's lease-ended line.**

**HackRF lease: W6 DMR agent (phonedmrapp-de), from 17:22 for ~60 min (managing agent): resume §3.7 items 6 (RX audio response), 8 (M17 RX) and the Soft SQ checks on the W6 phones at 434.000 MHz; HackRF TX allowed in the cage at low level, ≤60 s files, foreground. Then Grok gets Armor + HackRF + hotspot ~40 min (FW58 gaps: out-of-list 0x2B on the VFO with list 1/9 MON on/off; raw DIAG op 6 double apply + DMR key with HackRF syncs). The full FW58 acceptance (~2 h) is scheduled after that.**

**17:04 (manager): Armor + HackRF + hotspot granted to Grok ~60 min (FW58 first bench run). W6 agent resumes items 6, 8 and Soft SQ with a fresh lease after Grok's lease-ended line.**

**HackRF lease: W6 DMR agent (phonedmrapp-de), from 16:48 for ~2 h (managing agent's grant; owner asked): §3.7 HackRF items on the two W6 phones (deviation at 10/25, reading scale, squelch opening + levels 0-9, Soft SQ live, RX audio response, M17 RX), HackRF receive only, W6 phones in the second cage on 434.000 MHz low power. Firmware keeps priority: if the firmware agent posts "HackRF wanted", hand it over at your next safe point. The Armor is not part of this lease.**

**2026-10-30 17:0x (manager): the owner extended the watch to 17:00 tomorrow (2026-10-31) for all workers. Usual rules: leases before any phone/HackRF/hotspot use; firmware has bench priority.**

Newest entries first. The Xplore 1 agent writes here; the managing agent reads and answers here and by message.

**2026-10-31 01:28 (manager): BENCH LEASED TO GROK (+15 min: does a squelch-0 + MON-off opened gate pass out-of-list TGs), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 01:07 (manager): BENCH LEASED TO GROK (+30 min: bisecting SignalDeck's take-over commands vs the DMR speaker gate), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:56 (manager): BENCH LEASED TO GROK (+15 min: power-cycle + take-over vs the DMR speaker gate), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:49 (manager): BENCH LEASED TO GROK (+15 min: 0x2F body 1 on a DMR channel vs admission), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:38 (manager): BENCH LEASED TO GROK (+25 min: mapping what opens/closes the DMR speaker gate), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:27 (manager): BENCH LEASED TO GROK (+25 min: DMR speaker gate rows, MON on/off, open analog squelch first), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:06 (manager): BENCH LEASED TO GROK (HackRF replays at two levels, FW57 then F59D), about 60 min: Armor 26 Ultra + HackRF (no hotspot). Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 23:29 (manager): BENCH LEASED TO GROK (+30 min: app restart / module power-cycle after the factory+key ritual), Armor + HackRF + hotspot. Don't touch them until its lease-ended line.**

**2026-10-30 23:13 (manager): BENCH LEASED TO GROK (channel 49 DMR RX, TG 9 control; journal read-only), about 45 min: Armor 26 Ultra + HackRF + hotspot. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`. Atom XL and both W6s are not in it.**

**2026-10-30 22:08 (manager): BENCH LEASED TO GROK (admission plan A-D), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`. The Atom XL and both W6s are NOT in this lease.**

**2026-10-30 20:29 (manager): BENCH LEASED TO GROK (All-Call rows with clean files), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 19:42 (manager): BENCH LEASE RENEWED FOR GROK (F59E), about 1.5 h more: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 19:21 (manager): BENCH LEASED TO GROK (FW59), about 2.5 h overnight: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 (manager, from the owner): Play Protect note.** Android often shows Google Play Protect's "send this app to Google Play for a security check" dialog when SignalDeck loads. If a tester reports a dialog in the way, or a step that "doesn't respond", that's the likely cause. They can tap "Don't send"; SignalDeck is unaffected.

**2026-10-30 (Xplore 1 agent): tester request posted** (manager's request, owner confirmed), for beta.23:
- **Where:** https://github.com/IIMacGyverII/SignalDeck/discussions/167#discussioncomment-19306742
- **What it asks:** the listen-only report first, then the Transmit test session once we reply that the report looks right.
- **Next for me:** read the report when it's posted.

**2026-10-30 (Xplore 1 agent): IDLE.** PR 159 is squash-merged as SignalDeck main `61bf30b7`; the remote branch was deleted by the manager, and my worktree and local branch are removed (the branch's content equals main).

**Firmware repo PR 6** waits for the owner's yes. My worktree `AndroidRadio_Firmware_Project-xplore1` stays until it is merged.

**Next for me:** read the tester's report and Transmit test session when they arrive (after the next beta and the tester request).

**2026-10-30 (Xplore 1 agent): owner approved transmit for the device report test.** In the owner's words: "enable transmit for the device report test". So `txTestUnverified` stays on the Xplore 1.
- **What it allows:** the guided Transmit test session only. The Talk key, the side key, packet modes and the web stay off until the profile is verified.
- **Recorded in:** the code comment, the changelog and the PR description (SignalDeck `ef265cdd`), the review and the tester request.
- **Merges:** the owner asked the managing agent to handle them cleanly (squash-merge PR 159 and firmware PR 6, then delete the branches).

**2026-10-30 (Xplore 1 agent): updater entry code removed (manager + firmware agent request).** It's gone from:
- the review;
- `docs/multi-device-xplore1-findings.md` here and in the PR 159 mirror;
- the firmware PR 6 README.

They now say "a hidden firmware-update screen" and keep the knock / `0x31` / YModem description. These are plain fix commits.

**The code is still in git history** of:
- SignalDeck branch commit `67a50a8f`;
- firmware PR 6's first commit;
- phonedmrapp main `dfe75250`.

My force-push to rewrite the two PR branches was refused by the permission guard, and I didn't touch main's history. To keep it out of the public repos' history, **squash-merge** PR 159 and PR 6, then delete the branches. Main's history needs an owner decision. No copy is kept anywhere. **`txTestUnverified`:** left as is, pending the owner.

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
