# Plan: Ulefone Armor 3WT — make SignalDeck drive its radio the way its intercom app does

**Owner, 2026-10-30:** "before we release beta 23, i want to get the armor 3 supported like we did for the xplore 1 and the armor 20." A dedicated agent does the work and reports to the managing agent in `docs/armor3wt-status.md`. **Beta.23 waits for it.**

## Where we stand (read `docs/multi-device-armor3wt-findings.md` first: everything below is from it)

- **No SignalDeck profile exists for the 3WT,** so on that phone SignalDeck doesn't take over the radio. This is the biggest of the three reviews, because the transport is new.
- **Phone:** MT6771, board `s62v71c2k_gq_3wt`. The one tester runs a **LineageOS 21 (Android 14) GSI** and supplies the vendor programs through their own Magisk module (`phoneicom_armor3wt` v2.2.2). Same ODM family (Agold) as the Unihertz Atom XL, and the same `com.agold.intercom` code base, an older build.
- **Transport:**
  - **The daemon:** `/system/bin/extmodule` owns `/dev/ttyACM0`, the module behind an STM32 USB MCU (`0483:5730`).
  - **The app talks to it over TCP:** 127.0.0.1, **port 9980 for commands, 9985 for audio**.
  - **Command frames:** each gets a 12-byte prefix (`4F FE 2F F1`, `01 00 00 00`, length LE32), then the MCU frame.
  - **Daemon control:** 1 start, 2 stop, 3 PTT start, 4 PTT stop, 7 MCU start, 10 DMR firmware update.
  - **Start-up:** 2 (`resetMcu`), 7, 1; then MCU `0x06` (started) and `0x01` (build date).
- **MCU envelope:** the **same as the Atom XL's**, `7E 96 69 | route | cmd | rw | len BE | body | checksum BE | 81`. SignalDeck already has it in the Atom XL engine (Agold bridge code). Reuse it; don't fork it.
- **The module's commands are the "legacy" set** (`ver0.5.4_470M_TONE`, command `0x25`), **not** the DMR09/Armor set:
  - `0x02` volume, `0x10` call info, `0x11` message content;
  - `0x35` analog channel (15 B);
  - `0x36` digital channel (156 B): **no timeslot field**, and IDs big-endian;
  - reply body `00` = accepted.
- **Audio:**
  - **Through the daemon:** socket 9985, 48 kHz stereo, or 32 kHz when `ro.agold.extmodule.32k` is set.
  - **Underneath:** the MCU is also a **USB Audio Class card 1** (`pcmC1D0c`/`pcmC1D0p`), which the daemon drives with its own tinyalsa. The owner's `service.sh` disables Android's automatic USB audio routing.
- **PTT:**
  - **The phone side:** scancode `0xf9` on `/dev/input/event1`. The owner's `service.sh` turns it into a broadcast only the stock app receives.
  - **The key layout:** maps 249 to `PROG_RED` (keycode 183) if the GSI loads it.
  - **So SignalDeck needs** keycode 183, or a root `getevent` reader for `0xf9`.
- **Frequencies:** the app accepts 100–470 MHz (owner-widened). The tester gets the best reception around 133.85 MHz, so the module may tune below 136 MHz. Unconfirmed.
- **Firmware:** no DMR module image exists anywhere (stock ROM checked). The tester asked for **no firmware changes; support the hardware as-is**. SignalDeck's loader stays **off** (PR 161: uncertified).

## Inputs (private: never commit vendor code, binaries or tester data)

| What | Where |
|---|---|
| Device report + intercom APK (`Intercom_219_privatekey.apk`) | SignalDeck issue #3 attachment (`unknown_TrebleDroid_with_GApps_20261025_094457.zip`): download with `gh` into a scratch folder outside the repos |
| The owner's Magisk module (extmodule, service.sh, extcmdtest, key layout, libs) | `phonedmrapp/temp/Magisk-phoneicom_armor3wt_223.zip` (gitignored) |
| MCU images, stock ROM | `phonedmrapp/temp/Armor_3WT_firmware.zip`, `temp/R1-Ulefone-Armor-3WT*.zip` (reference only) |
| Findings so far | `phonedmrapp/docs/multi-device-armor3wt-findings.md` |
| Atom XL (same family, already supported) | SignalDeck: the Atom XL profile and its Agold bridge code (`AgoldUsb`, the `agold` protocol engine); phonedmrapp `docs/multi-device-atomxl-findings.md`, `docs/atomxl/` |
| The Armor 20WT and Xplore 1 examples of this kind of work | `docs/armor20wt/stock-app-review.md`, `docs/xplore1/stock-app-review.md`; SignalDeck PRs 157–159 (profile fields, `stockCommands`, the session-only transmit flag `txTestUnverified`, device-report additions) |
| Tools | jadx `C:\Users\Joshua\tools\jadx\bin\jadx.bat`; JDK 17 `C:\Users\Joshua\tools\jdk-17.0.20.1+1` |

## The work

1. **Review** (`docs/armor3wt/stock-app-review.md`): the intercom app and `extmodule`, item by item, compared with what SignalDeck's Atom XL path does now:
   - **lifecycle:** the daemon start and stop order, MCU start, power;
   - **the socket protocol:** framing, replies, keep-alive, errors;
   - **the legacy command table** with body layouts;
   - **channel writes:** analog and digital, with no slots;
   - **receive:** call-info parsing, the status pushes, how the app knows a reception started and ended;
   - **audio on 9985:** format, packet size, direction, pacing;
   - **transmit:** the order of daemon PTT 3/4 against MCU commands, microphone timing;
   - **texts** (`0x11`);
   - **frequency checks.**

   Mark each finding as read (R) or inferred (I), with a summary table of what differs from the Atom XL.
2. **SignalDeck PR(s):**
   - **A new profile, `ulefone-armor3wt`, unverified,** detected by model or board (`s62v71c2k_gq_3wt`) and the presence of `extmodule`.
   - **An engine path that talks to `extmodule` over 9980/9985,** keeping the owner's Magisk module. Opening `ttyACM0` directly is the fallback only if the socket route proves impossible. Say which and why.
   - **The legacy command set,** as a protocol variant beside DMR09, with DMR **without slot selection**. The UI must not offer a time slot on this phone; say what it shows instead.
   - **PTT** via keycode 183 or a root `getevent` reader for `0xf9`.
   - **Audio** through the daemon socket, with the 48k/32k choice from the property.
   - **Profile rules:**
     - `moduleLoader` off (uncertified);
     - **transmit locked:** no Talk, nothing else;
     - `txTestUnverified` **only if the owner approves it for this phone**, as he did for the 20WT and Xplore 1 (ask through the managing agent);
     - every other phone unchanged, pinned by a test;
     - help, radio notes (`radios.json`), the changelog, and Restricted-mode wiring if a new path is added.
3. **Device report and trial for this phone:**
   - extmodule present and listening on 9980/9985;
   - MCU build date and module version (`0x25`);
   - the commands the stock app doesn't use, with the module's answers (`stockCommands`);
   - the receive audio path;
   - the band edges, including **below 136 MHz** (133.85), receive only;
   - the PTT key path (whether keycode 183 arrives).
4. **Tester request:** `docs/armor3wt/tester-request.md`, for the 3WT tester. Post in Discussions **#168** (the 3WT thread); index #170. It goes out after the beta that carries it.
5. **Docs:** a "2026-10-30 review" section in the findings doc. Update `SignalDeck/docs/compatibility.md` and the firmware repo's `devices/ulefone-armor-3wt/README.md`, the latter through a PR from your own worktree of `AndroidRadio_Firmware_Project`, never the shared folder.

## Rules

- **No phone, radio, HackRF or hotspot:** there's no 3WT here, so this is reading and code only.
- **Mailbox `docs/armor3wt-status.md`:**
  - a `STATUS:` line (WORKING / REVIEW / STUCK / OWNER / IDLE), newest entries first;
  - push after each update with `git fetch -q origin && git rebase -q --autostash origin/main`;
  - never `git reset --hard`.
- **SignalDeck changes:** in your own git worktree and branch from `origin/main`, as PRs for the managing agent; never push to main. Rebase before opening; main moves often (PRs 153–172 landed today).
- **Vendor material and tester data** (APK, decompiled code, `extmodule`, the report, the ROM) stay out of every repo. Never publish the hidden update path's entry points or file locations beyond what the findings doc already says.
- **No owner callsign or DMR ID anywhere:** examples use N0CALL, DMRTST-7, 1234567, TG 9.
- **Commits:** commit only your own files and match the surrounding code style. Host suite: `JAVA_HOME=/c/Users/Joshua/tools/jdk-17.0.20.1+1 ./gradlew -q testReleaseUnitTest`.
- **Scope:** the owner wants this **before beta.23**. Aim for a reviewable PR in one working session, and report scope problems early (STUCK/OWNER) rather than late.
