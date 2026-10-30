# Plan: Armor 20WT — review the stock app and make SignalDeck do what it does

**Owner, 2026-10-30:** "plan a proper review with the intent of making the armor 20 compatible by duplicating the way the stock app uses the radio. this would at least get us to the next steps the device report could gather to get us the information it needs to be fully compatible." A dedicated agent does the work. It reports to the managing agent through `docs/armor20wt-status.md`.

## Where we stand

- SignalDeck has a profile, `ulefone-armor20wt` rev 1 (`DeviceProfile.ARMOR_20WT`, 2026-10-24), marked **unverified**:
  - `/dev/ttyS1` at 57600;
  - the stock lib `/system/priv-app/PriInterPhone/lib/arm64/libserial_port_app.so`, bound to `com.serial.port.SerialPort` through `VendorSerial`;
  - `dmr009` `pwd`/`ptt`;
  - PrizeTinyService audio;
  - keycode 301 plus `com.interphone.ptt.*`.

  It's detected by model.
- It's built from **one owner's device report** and a shallow read of the stock app: the serial port, the library, the nodes, the key. Nobody has run SignalDeck on a 20WT.
- Facts from the report:
  - `/dev/ttyS1` is `crwxrwxrwx system`; it reads as 9600 baud at rest, because the stock app sets the speed through its own library.
  - `ttyS0` is another device at 921600.
  - `dmr009` is present.
  - The module's version string was never read, because the module was powered off during the probe.
- The firmware repo's device page (`AndroidRadio_Firmware_Project/devices/ulefone-armor-20wt/README.md`) says "same command table", from the report plus a read. **This hasn't been checked line by line.**
- The 20WT's stock APK has **no** firmware asset (`DMR*.bin`) and no native libs inside. The serial lib sits in `/system/priv-app`. So the module's stock image and version must come from the phone itself.

## Inputs (private: never commit vendor code or binaries)

| What | Where |
|---|---|
| 20WT stock app and the owner's report | `D:\Documents\code\personal\SignalDeck\temp\Ulefone_Armor_20WT_20231025_075833.zip`: `com.pri.prizeinterphone_PriInterPhone.apk` plus `report.txt`. `temp/` is gitignored. The report is a tester's, so quote only device facts from it, never personal data. |
| Armor 26 Ultra stock app, decompiled (the reference) | `phonedmrapp/app/src/main/java/com/pri/prizeinterphone/` |
| Armor 26 protocol and messages | `phonedmrapp/docs/deep-dive/01-…`, `02-oem-messages-and-handlers.md`; `docs/firmware-reference/02-uart-commands-and-handlers.md` |
| SignalDeck | `D:\Documents\code\personal\SignalDeck`: `DeviceProfile.java`, `VendorSerial.java`, `RadioEngine.java`, the audio backends, `DeviceReport.java`, `FirmwareVariantCheck.java` |
| Tools | jadx at `C:\Users\Joshua\tools\jadx\bin\jadx.bat`; JDK 17 at `C:\Users\Joshua\tools\jdk-17.0.20.1+1`. Decompile into a scratch folder outside the repos. |

## The review: what to find, side by side with the Armor 26 app

1. **Process and lifecycle:** the service and activities; who opens the UART and when; the power-up order on `dmr009` (`pwd`, any other node); waits; the boot banner; what runs when the app closes or the screen goes off.
2. **The serial layer:** the `com.serial.port.SerialPort` API (open, speed, flags, read loop); the framing (`68 … 10`), checksum, escaping, acknowledgements and retries; the write gaps.
3. **The command table:** every command byte the 20WT app sends and handles, with body layouts, compared with the Armor 26. List each one that is added, missing or changed: channel writes (analog `0x23`, digital `0x22`), query version (`0x34`), RSSI (`0x32`), squelch, CTCSS/DCS, power, the time-out (`0x3B`), TX/RX status, caller info (`0x2B`), texts (`0x2C`), contacts and groups, the MCU status codes.
4. **Transmit:** the full sequence from the PTT press (key 301 / broadcasts) to the RF and back:
   - which commands and in what order;
   - the `ptt` sysfs node versus a UART command;
   - the audio route for the microphone (PrizeTinyService calls, sample rate, mono/stereo, frame size);
   - timers, the TX watchdog, the release.
5. **Receive:** how a reception starts and ends (the status codes); how the audio is opened (PrizeTinyService, `openRecvPcm`, rate and format); the squelch/monitor handling; caller-info parsing; DMR text receive.
6. **Boot handshake:** what the app sends after power-up (version, channel, interrupt/mic, TOT and others), with its waits.
7. **Channels and storage:** the database schema and areas compared with the Armor 26's, for SignalDeck's stock-app import (`ChannelStore`).
8. **Anything 20WT-specific:** other sysfs nodes, GPIOs, vendor services, a different audio service, DMR features, firmware update code (a loader path, as on the 26: knock plus YModem).

For every item, record the class/method and line in the decompiled 20WT app, the Armor 26 counterpart, and **same / different (how)**.

## What comes out of it

1. **`docs/armor20wt/stock-app-review.md`** (this repo): the findings in the order above, with a summary table of everything that differs from the Armor 26. Vendor code may be quoted in short excerpts only where needed to show a behaviour; never copied whole. Mark each finding as verified by reading or inferred.
2. **SignalDeck PR(s)** to make SignalDeck do what the 20WT app does, where it differs from the Armor 26 path:
   - **profile fields:** power order, waits, audio parameters, key handling, handshake;
   - **engine branches,** only where a profile field can't express the difference;
   - **implementation rule:** SignalDeck re-implements the behaviour from the findings; no vendor code is copied;
   - **unchanged elsewhere:** every other phone's behaviour stays the same, pinned by a test;
   - **status:** the profile stays **unverified** (no 20WT here to test on), and its revision goes up;
   - **with the code:** help and compatibility notes, a changelog row, and Restricted-mode wiring if a new path is added.
3. **What the device report must collect next.** The owner's point: the next 20WT report should bring back everything still unknown. For each open question, add the check to SignalDeck's Device report / Run all checks for this profile, read-only first. Expected:
   - the module powered and `0x34` answered (the version string, so the firmware catalogue can match the variant);
   - the serial open through `VendorSerial` with the speed set;
   - the receive audio path opened;
   - the sysfs nodes listed;
   - the stock app's channel DB schema;
   - if the module has a stock image on the phone, its hash, never the file.

   Transmit checks belong to the existing guided **Transmit test session**, which a 20WT tester runs only after the read-only report looks right.
4. **A tester request:** a short draft for the owner to post (SignalDeck Discussions or an issue). It asks a 20WT owner to install the beta with these changes, run *Device → Device report → Run all checks*, send it, then the transmit test session.
5. **Update** the firmware repo's `devices/ulefone-armor-20wt/README.md` with what was verified by reading, through a PR in its own worktree, not in the shared folder. Also update `SignalDeck/docs/compatibility.md`.

## Rules for the agent

- **No phone, no radio, no HackRF:** there is no 20WT here, so this is reading and code only. Never touch the Armor 26, the Atom XL, the W6 phones or the hotspot.
- **Report in `docs/armor20wt-status.md`:**
  - a `STATUS:` line: WORKING / REVIEW / STUCK / OWNER / IDLE;
  - newest entries first;
  - push after each update with `git fetch -q origin && git rebase -q --autostash origin/main`;
  - never `git reset --hard`.
- **SignalDeck changes:** in your own worktree (`git worktree add …` from `origin/main`), on your own branch, as a PR for the managing agent to review and merge. Never commit to the shared `SignalDeck` folder's checkout, and never push to main.
- **Vendor material** (the APK, decompiled sources, `report.txt`) stays out of every repo. If something must be kept, it goes in the owner's private Gitea `SignalDeck_Resources`; ask first.
- **Identity:** no owner callsign or DMR ID anywhere; examples use N0CALL, DMRTST-7, 1234567, TG 9. The tester's identity and any personal data in `report.txt` are never quoted.
- **Commit hygiene:** commit only your own files; match the surrounding code style; host suite `JAVA_HOME=/c/Users/Joshua/tools/jdk-17.0.20.1+1 ./gradlew -q testReleaseUnitTest`.
