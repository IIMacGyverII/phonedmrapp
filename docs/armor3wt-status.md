# Armor 3WT agent status (mailbox)

STATUS: IDLE (2026-10-30: PRs #175, #176 and #177 merged; the tester request goes to #168 only when the managing agent says beta.23 is published)

Newest entries first. The Armor 3WT agent writes here; the managing agent reads and answers here and by message.

**2026-10-30 (3WT agent): idle.** #177 merged; the beta.23 candidate is being rebuilt with all three PRs. Waiting for the word that beta.23 is published, then I post `docs/armor3wt/tester-request.md` in #168 with the beta link filled in. Firmware repo PR 7 is still open for the firmware agent and the managing agent.

**2026-10-30 (3WT agent): SignalDeck PR #177 for review** (branch `armor3wt/ptt-stop-hold`; `origin/main` with #176 merged in; whole suite green; not device-tested).
- **What:** on the 3WT a channel write waits after an unkey for the bridge's state report 02, or 2 s at most, as the intercom app's `mIsPTTStopComplete` does.
- **Other phones:** a no-op, pinned by a test (`holdsWritesAfterUnkey`).
- **Last one:** this is the last 3WT PR planned before beta.23.

**2026-10-30 (3WT agent): SignalDeck PR #176 for review** (branch `armor3wt/tx-test` from `b1783e79`, whole host suite green, not device-tested).
- **Owner decision, given to me directly:** transmit unlocked for the device report's tests. `txTestUnverified = true`, so only the guided Transmit test session keys.
- **Release hold:** new field `txReleaseHoldMs` = 500 on the 3WT (key and microphone run on 500 ms after the release, as the intercom app does). 0 on every other phone.
- **Report text:** the session's report names the extmodule key path instead of `0x26`.
- **Tester request:** step 6 (Transmit test session) added.
- **133.85 MHz:** removed everywhere (SignalDeck in #175, firmware PR 7 `c52bbcb`, phonedmrapp `25e8725d`).

**2026-10-30 19:42 (manager): BENCH LEASE RENEWED FOR GROK (F59E), about 1.5 h more: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 19:21 (manager): BENCH LEASED TO GROK (FW59), about 2.5 h overnight: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 (3WT agent): SignalDeck PR #175 for review** (https://github.com/IIMacGyverII/SignalDeck/pull/175, branch `armor3wt/support`; `origin/main` `5ab5ae71` merged in; whole host suite green; not device-tested).
- **Profile:** `ulefone-armor3wt`, unverified, transmit locked, no loader. Detected by model, board or vendor build, and only with `/system/bin/extmodule`.
- **Transport:** `extmodule` sockets 9980/9985 (`ExtModuleLink`); the direct route stays the fallback.
- **Commands:** legacy set via `AgoldLegacyCodec`; commands with no equivalent are never sent.
- **Audio:** socket audio (`ExtModuleAudio`, 48/32 kHz).
- **UI and PTT:** no time slot in the UI on this phone; side key `00f9` as the default custom PTT key.
- **Report:** trial checks for the daemon, the bridge, the stream, band edges 100-480 MHz and two raw queries.
- **Docs:** help, radio notes, changelog.
- **For the owner (through the managing agent):** may the 3WT get `txTestUnverified` (the guided Transmit test session only), as the 20WT and Xplore 1 did? It is off in the PR. If yes, it is one line plus a step in the tester request.
- **Tester request:** `docs/armor3wt/tester-request.md`, to post in #168 after the beta that carries PR #175. **Not posted.**
- **Findings doc:** "2026-10-30 review" section added.
- **Firmware repo:** AndroidRadio_Firmware_Project PR #7 (`armor3wt/device-page`, README only, no catalogue change), for the firmware agent's review.
- **No compatibility page in SignalDeck:** `SignalDeck/docs/compatibility.md` does not exist on `main`. The radio notes (`docs/radios/ulefone-armor3wt.md`, generated from `radios.json`) are the compatibility page and are in the PR.

**2026-10-30 (3WT agent): review done, `docs/armor3wt/stock-app-review.md`.**
- Both APK copies (report and Magisk module) are the same code. `extmodule` disassembled (NDK llvm-objdump): controls 1-10 confirmed, up to 10 clients, replies go only to the client that last wrote (so the stock app must be stopped).
- Corrections to the findings doc: the legacy text send is `0x07` (`0x11` is the fetch); receive start/end is the module's `0x04` push; there is no RSSI command in the app; the 100 MHz floor is in both APK copies.
- Decision: the socket route (keeps the owner's module); the direct route (as on the Atom XL) stays the fallback. Next: the SignalDeck PR.

**2026-10-30 (3WT agent): started.** Read CLAUDE.md, the plan, the findings, the Atom XL notes and the 20WT/Xplore 1 reviews. Worktree `SignalDeck-3wt` on `armor3wt/support` from `origin/main` `511c0d7e`. Next: decompile the intercom APK and read `extmodule`, write `docs/armor3wt/stock-app-review.md`.

**2026-10-30 (manager): the plan is `docs/armor3wt/plan-support.md`.**
- Review the 3WT intercom app and its `extmodule` daemon against SignalDeck's Atom XL path.
- Add an unverified `ulefone-armor3wt` profile that talks to `extmodule` over 127.0.0.1:9980/9985 with the legacy command set (DMR without time slots). Transmit stays locked.
- Add the device-report checks a 3WT tester's next report needs, and write a tester request for Discussions #168.
- Reading and code only. Beta.23 waits for this.
