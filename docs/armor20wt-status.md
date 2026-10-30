# Armor 20WT agent status (mailbox)

STATUS: IDLE (2026-10-30: SignalDeck PRs 157 + 158 merged; tester request goes out with beta.23; waiting for a real 20WT report)

**17:04 (manager): Armor + HackRF + hotspot granted to Grok ~60 min (FW58 first bench run). W6 agent resumes items 6, 8 and Soft SQ with a fresh lease after Grok's lease-ended line.**

**HackRF lease: W6 DMR agent (phonedmrapp-de), from 16:48 for ~2 h (managing agent's grant; owner asked): §3.7 HackRF items on the two W6 phones (deviation at 10/25, reading scale, squelch opening + levels 0-9, Soft SQ live, RX audio response, M17 RX), HackRF receive only, W6 phones in the second cage on 434.000 MHz low power. Firmware keeps priority: if the firmware agent posts "HackRF wanted", hand it over at your next safe point. The Armor is not part of this lease.**

**2026-10-30 17:0x (manager): the owner extended the watch to 17:00 tomorrow (2026-10-31) for all workers. Usual rules: leases before any phone/HackRF/hotspot use; firmware has bench priority.**

**15:49 (manager): Armor to the firmware agent (~15 min), then Armor + HackRF + hotspot to Grok (~30 min). Not available to other agents until Grok's lease-ended line.**

**15:08 (manager): Grok's Armor + HackRF + hotspot grant extended ~30 min (P1/P2 follow-up). Not available to other agents until Grok's lease-ended line.**

Newest entries first. The Armor 20WT agent writes here; the managing agent reads and answers here and by message.

**2026-10-30 (20WT agent): IDLE.** The manager merged PR 158 together with PR 153's transmit-length setting; the help conflict was resolved to keep both. The tester request goes out once beta.23 carries 157 + 158. Nothing more until a real 20WT report arrives.

**2026-10-30 (20WT agent): REVIEW. SignalDeck PR #158** (https://github.com/IIMacGyverII/SignalDeck/pull/158, branch `armor20wt/report-checks`). **The owner asked for it directly in my session:** "add those things and also enable transmit so the user can test for the device report".
- **Transmit:** new profile field `txTestUnverified`, on for the 20WT only.
  - The guided Transmit test session may key the unverified profile.
  - `RadioService` permits a key only while the session is keying.
  - Talk, the side key, packet modes and the web stay off.
- **Trial additions** (untested `mcu68` phones, receive only):
  - squelch 0 vs squelch 0 + monitor, with a verdict;
  - noise level at module volume 5 and 8, saved as WAVs;
  - signal-reading settle time over five retunes;
  - band edges 136/174/400/480 MHz and 5 kHz outside, accepted or refused from the module's `0x23` answer.
- **Tests and docs:** host suite green; help, dialog, radio notes and changelog updated.
- **Tester request:** `docs/armor20wt/tester-request.md` now covers both PRs and adds the transmit step (no special build needed).

**2026-10-30 (20WT agent): IDLE.** The manager merged SignalDeck PR 157 (main `fc17837f`). Firmware-repo PR #5 is now the firmware agent's. The tester request goes to the owner once beta.23 carries PR 157. Nothing more until a real 20WT report arrives.

**2026-10-30 (20WT agent): REVIEW — all four deliverables ready.**
- **Review:** `docs/armor20wt/stock-app-review.md`.
  - The 20WT's app is an older, smaller PriInterPhone build, with the same wire protocol, command numbers, message layouts and audio format as the 26.
  - Differences D1–D10 are in a summary table, each marked read or inferred.
  - The ones that matter:
    - its handshake is channel, version, TOT only;
    - it opens the audio path 600 ms **before** `0x26`;
    - it keys no sooner than 2 s after a release;
    - its analog volume byte is 5;
    - it never touches the `ptt` node and has no updater or image;
    - its channel files are `channel_database_<area>.db`;
    - it sends only 9 command types, so RSSI, caller info, monitor and squelch are unknown on this module.
- **SignalDeck PR #157** (https://github.com/IIMacGyverII/SignalDeck/pull/157, branch `armor20wt/stock-app-parity`):
  - 20WT profile rev 2 (still unverified), with seven new profile fields defaulting to the Armor 26 behaviour (pinned by a test);
  - Run all checks: the trial prints version, UART open and banner, plus the commands the stock app doesn't use with the module's answers; the DBs are re-read after the watch; the probe's stty speed failure is flagged;
  - help, radio notes and changelog are updated;
  - host suite green; not device-tested.
- **Firmware repo PR #5** (https://github.com/IIMacGyverII/AndroidRadio_Firmware_Project/pull/5): the device page README only; the catalogue is untouched.
- **Tester request:** `docs/armor20wt/tester-request.md`, a draft for the owner to post once #157 is in a beta.
  - The transmit step needs a build with the 20WT profile marked verified (the public beta refuses to transmit).
- **Not done, on purpose:** receive audio per reception (D8). The trial will show whether a held-open stream works on the 20WT.
- **There's no `SignalDeck/docs/compatibility.md`.** The radio notes (`radios.json` and the generated `docs/radios/ulefone-armor20wt.md`) are the compatibility page, so I updated those.

**2026-10-30 (20WT agent): started.** Order: review document (`docs/armor20wt/stock-app-review.md`), then the SignalDeck PR, then the Device-report checks and the tester request. Reading and code only.

**2026-10-30 (manager): the plan is `docs/armor20wt/plan-stock-app-review.md`.** Review the 20WT stock app against the Armor 26's, make SignalDeck do what it does (profile stays unverified), and add the Device-report checks that a 20WT tester's next report needs. Reading and code only: no phone, radio, HackRF or hotspot.
