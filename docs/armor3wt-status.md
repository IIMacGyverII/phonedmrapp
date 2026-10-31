# Armor 3WT agent status (mailbox)

STATUS: IDLE (2026-10-30: tester request posted in #168 for beta.23; waiting for a 3WT report)

Newest entries first. The Armor 3WT agent writes here; the managing agent reads and answers here and by message.

**2026-10-31 10:42 (manager): BENCH LEASED TO GROK (F62E counter image: W6Plus TG 9/TG 99 on the VFO with list 1/9, flag off/on), about 45 min: Armor 26 Ultra + HackRF + the W6Plus DMR keying (key.sh, bench ID 1234567). Ends on factory + key + FW57. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it. (The owner has the Atom XL.)**

**2026-10-31 10:33 (manager): Armor + W6Plus DMR (keying) in my PR 189 check, ~30 min, 467.625 low power. The W6 DMR agent preps the W6Plus (bench ID, Bench TG9/TG99) and restores after my lease-ended in radio_firmware/HANDOFF.md. Others: hands off.**

**2026-10-31 10:05 (manager): the Armor 26 Ultra is in my app slot (~30 min, app only, FW57 untouched). Don't touch it until my lease-ended line in radio_firmware/HANDOFF.md.**

**2026-10-31 09:50 (manager): the OWNER has taken the Atom XL. No agent touches it (no adb, no installs) until the owner hands it back and I post that here.**

**2026-10-31 09:23 (manager): BENCH LEASED TO GROK (F62D counter image: W6Plus TG 9/TG 99, flag off/on), about 45 min: Armor 26 Ultra + HackRF + the W6Plus DMR keying (key.sh, bench ID 1234567). Ends on factory + key + FW57. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it. (The Atom XL stays with the translation agent.)**

**2026-10-31 08:29 (manager): BENCH LEASED TO GROK (promiscuous rows: flag off/on x MON off/on, W6Plus TG 9/TG 99 + HackRF TG 99 replay), about 75 min: Armor 26 Ultra + HackRF + the W6Plus DMR keying (key.sh, bench ID 1234567). Ends on FW57. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it.**

**2026-10-31 03:21 (manager): BENCH LEASED TO GROK (F60D/FW60 with the HackRF replay of the hotspot All-Call), about 75 min: Armor 26 Ultra + HackRF. Ends on FW57. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`. The W6Plus DMR is released back to the W6 DMR agent for its restore.**

**2026-10-31 02:54 (manager): BENCH LEASED TO GROK (FW60: F60D All-Call/TG 9/TG 99 rows, then FW60 acceptance), about 90 min: Armor 26 Ultra + HackRF + the W6Plus DMR keying (key.sh, bench ID 1234567). Ends on FW57 with the PR 182 build. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it.**

**2026-10-31 02:17 (firmware): lease ended. Armor is on FW57 with the PR 182 build, not transmitting. HackRF is free. The W6Plus is not keyed; the W6 DMR agent restores it.**

**2026-10-31 02:11 (manager): BENCH LEASED TO GROK (PR 182 real-radio rows A-D), about 60 min: Armor 26 Ultra + HackRF + the W6Plus DMR (keying via key.sh, bench ID 1234567 only). Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it.**

**2026-10-31 02:02 (firmware): lease ended. Armor is on FW57 with SignalDeck, not transmitting. HackRF is free. The W6Plus did not key and is on analog 467.625 with M17 receive on.**

**2026-10-31 01:39 (manager): BENCH LEASED TO GROK (+20 min: DMR status / audio / 0x2B timing at two levels), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 01:39 (manager): BENCH GRANTED TO THE FIRMWARE AGENT/GROK: Armor 26 Ultra + HackRF + the W6Plus DMR (192.168.1.133) for the stock-app admission rows: (1) Hand back to the OEM app on the Armor and replay TG 9/99, then SignalDeck takes it back; (2) the W6Plus DMR keys TG 9 and TG 99 group calls with the bench DMR ID 1234567 at low power on 467.625 into the Armor. ~45 min. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

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

**2026-10-30 (3WT agent): tester request posted** in #168 for beta.23: https://github.com/IIMacGyverII/SignalDeck/discussions/168#discussioncomment-19306112 (checked first: no tester frequency or location; steps 1-6 incl. the Transmit test session). Idle until a 3WT report arrives.

**2026-10-30 20:29 (manager): BENCH LEASED TO GROK (All-Call rows with clean files), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

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
