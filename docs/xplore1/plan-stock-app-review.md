# Plan: Blackview Xplore 1 — finish the stock-app review and make SignalDeck do what it does

**Owner, 2026-10-30:** "do for the xplore 1 what we have done with the armor 20" (see `docs/armor20wt/plan-stock-app-review.md` and `docs/armor20wt/stock-app-review.md`). A dedicated agent does the work. It reports to the managing agent through `docs/xplore1-status.md`.

## Where we stand (read `docs/multi-device-xplore1-findings.md` first)

- **SignalDeck profile:** `blackview-xplore1` rev 2, **unverified** (`DeviceProfile.XPLORE_1`).
  - Control: `/dev/ttyS0` at 57600.
  - **Audio: PCM over a second UART,** `/dev/ttyS1` at 230400 (`Audio.UART_PCM`): 167-byte packets `BB 00 xx xx xx xx` + 160 B PCM + `44`, 8 kHz mono, 10 ms each.
  - Power/pwd/ptt: `/sys/devices/platform/intercom/intercom_*_control`. **ptt_control 0 = transmit, 1 = receive.**
  - PTT broadcasts `com.android.intent.ptt.down/up`.
  - Stock app `com.chamsion.quickchat` (QuickChat, protocol library `com.wonder.dmr`).
  - Profile settings: global squelch, channel writes ≥ 1 s apart, 2.5 s scan dwell.
- **Verified with a real tester's phone (betas 1–18, 2026-10-21 to 24):**
  - the module answers;
  - receive audio works (monitor/squelch needed);
  - MON and CTCSS work;
  - the stuck-module restart works.
- **Transmit has never been analysed or tried.** The 2026-10-22 decompile skipped it on purpose, and an unverified profile never keys. That's the biggest gap.
- **Known differences already handled:**
  - channel-write timing;
  - monitor and squelch 200 ms after the channel's acknowledgement;
  - QuickChat never acknowledges `0x36`;
  - the module may repeat status pushes;
  - no `0x2B`/`0x32` in QuickChat;
  - the version watchdog and restart;
  - the 0x2C SMS body has **no 9-byte header** (unlike the Armor). That one was noted but **not applied**.

## Inputs (private: never commit vendor code, binaries or tester data)

| What | Where |
|---|---|
| QuickChat APK | `phonedmrapp/temp/QuickChatEEA.apk.zip` (gitignored) |
| Tester reports | `phonedmrapp/temp/Blackview_XPLORE_1_Walkie_Talkie_20261024_135045.zip`, `temp/DMR.beta.3.zip`, `DMR.Beta.5.zip`, `DMR.Beta.8.zip`, `DMR.zip`. These are a tester's: quote device facts only, never personal data |
| Earlier findings | `phonedmrapp/docs/multi-device-xplore1-findings.md` (also mirrored in `SignalDeck/docs/`) |
| Armor 26 reference | `phonedmrapp/app/src/main/java/com/pri/prizeinterphone/` (decompiled), `docs/deep-dive/01-…`, `02-…`, `docs/firmware-reference/02-…` |
| Armor 20WT example of the same kind of work | `docs/armor20wt/stock-app-review.md`; SignalDeck PR 157 (profile fields such as `txAudioLeadMs`, `minKeyGapMs`, `bootMicInterrupt`, `analogVolume`, `stockCommands`, the device-report additions) |
| SignalDeck | `D:\Documents\code\personal\SignalDeck`: `DeviceProfile.java`, the UART-PCM audio backend, `RadioEngine.java`, `RadioService.java` (PTT path), `DeviceReport.java` / `FirstRunCheck.java`, `TxTestSession.java`, `ChannelStore.java` (stock import) |
| Tools | jadx at `C:\Users\Joshua\tools\jadx\bin\jadx.bat`; JDK 17 `C:\Users\Joshua\tools\jdk-17.0.20.1+1`. Decompile into a scratch folder outside the repos. |

## The review: what to find, compared with what SignalDeck does now

Focus on what's still open: **transmit first**, then everything else checked line by line.

1. **Transmit, end to end:** from the PTT broadcast (and QuickChat's 1.5 s hold rule) to RF and back.
   - **Ordering:** the `intercom_ptt_control` write (0 = TX) versus UART `0x26`.
   - **TX PCM on ttyS1:** packet format (the same 167-byte frame as receive, or raw 160 B every 10 ms?), pacing, start and stop, any lead-in, and what happens with no audio.
   - **Release:** the order, and returning the ptt line to 1.
   - **Timers:** QuickChat's own transmit timer, and the `0x3B` it sends.
   - **Microphone:** sample rate and gain.
   - **DMR versus analog** differences.
2. **SMS transmit** (`0x2C`): the exact body (type, target, text encoding; the noted lack of the 9-byte header), and the delivered/failed statuses 8/9.
3. **The command table, re-checked:** every command QuickChat sends and handles, with body layouts, compared with SignalDeck's Xplore path. Pay attention to `0x22`/`0x23` (pwrsave 1 vs SignalDeck's 2; volume 0), `0x31`, `0x35`, `0x37`, `0x3A`, `0x3C` and `0x28`.
4. **Receive, re-checked against SignalDeck:**
   - status handling and de-duplication;
   - the global `0x30` versus the per-channel squelch;
   - monitor;
   - ttyS1 framing and resynchronisation after a broken packet;
   - DMR caller info: QuickChat never uses `0x2B`, so how does it show who's talking? `DigitalVoiceReceptionInfo`?
5. **Lifecycle:** start-up, power and line order, the version watchdog, the screen off, and exit order (power → pwd → ptt). Compare each with SignalDeck's.
6. **Channels and storage:** the Room DB schema (`channels` with countryId lists, `channel_table` in the bundled DB), compared with SignalDeck's stock-app import.
7. **Xplore-specific:** `intercom_factory_test`, the detect IRQ, any firmware update code (the CRC16-XMODEM upgrade packets: an updater? its knock? its image?), DMR features (remote functions `0x28`), encryption.

For every item, record the class/method in the decompiled QuickChat, SignalDeck's current behaviour, and **same / different (how)**. Mark each finding as verified by reading or inferred.

## What comes out of it

1. **`docs/xplore1/stock-app-review.md`:** the findings in the order above, with a summary table of every difference from SignalDeck's current Xplore path. Vendor code is quoted only in short excerpts where needed; never copied whole.
2. **SignalDeck PR(s):** make SignalDeck do what QuickChat does.
   - Prefer profile fields, in the style of PR 157. Add an engine branch only where a field can't express the difference.
   - Re-implement behaviour from the findings; no vendor code copied.
   - Every other phone stays unchanged, pinned by a test.
   - **Transmit stays locked while the profile is unverified,** as now. The PR prepares the transmit path so that a tester's guided Transmit test session can verify it.
   - Raise the profile revision. Update help, compatibility notes and the changelog, and wire Restricted mode if a new path is added.
3. **What the next Xplore 1 report must collect:**
   - read-only checks added to *Device → Device report / Run all checks* for anything still unknown (likely: the ttyS1 TX framing loopback, the ptt line readback, the module version, the stock DB schema);
   - the steps of the **Transmit test session** tuned for this phone: the ptt line, the PCM TX, the SMS body. A tester runs that only after the read-only report looks right.
4. **A tester request:** a short draft for the owner (`docs/xplore1/tester-request.md`) asking the Xplore 1 tester to install the beta that carries these changes, send the report, then run the transmit test session.
5. **Device page and compatibility notes:** update the firmware repo's `devices/blackview-xplore-1/README.md` with what was verified by reading. Do it through a PR from your own worktree of `AndroidRadio_Firmware_Project`, never in the shared folder, which often sits on another branch. Also update `SignalDeck/docs/compatibility.md` and `docs/multi-device-xplore1-findings.md` (a short "2026-10-30 review" section pointing at the new doc).

## Rules for the agent

- **No phone, radio, HackRF or hotspot.** There's no Xplore 1 here: reading and code only. Never touch the Armor, the Atom XL, the W6 phones or the hotspot.
- **Mailbox `docs/xplore1-status.md`:**
  - a `STATUS:` line (WORKING / REVIEW / STUCK / OWNER / IDLE), newest entries first;
  - push after each update with `git fetch -q origin && git rebase -q --autostash origin/main`;
  - never `git reset --hard`.
- **SignalDeck changes:** in your own git worktree and branch, from `origin/main`, as PRs for the managing agent to review and merge. Never push to main, and never commit in the shared `SignalDeck` checkout.
- **Vendor material and tester data** (the APK, decompiled sources, reports) stay out of every repo. If something must be kept, it goes in the owner's private Gitea `SignalDeck_Resources`; ask first.
- **No owner callsign or DMR ID anywhere:** examples use N0CALL, DMRTST-7, 1234567, TG 9. Never quote the tester's identity, location or other personal data.
- **Commits:** commit only your own files and match the surrounding code style. Host suite: `JAVA_HOME=/c/Users/Joshua/tools/jdk-17.0.20.1+1 ./gradlew -q testReleaseUnitTest`.
- **Other agents' work in the same files:** another agent's PR 153 (the transmit-length setting) touches the voice PTT path in `RadioService`. Rebase onto main before you open the PR, and keep both behaviours.
