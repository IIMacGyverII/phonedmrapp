# Armor 20WT tester request (draft for the owner to post)

**Where:** SignalDeck Discussions (Q&A or Announcements), or an issue labelled `device-support`. **Post after** SignalDeck PR #157 is merged and in a beta build. Fill in the beta number below.

---

### Ulefone Armor 20WT owners: help us make SignalDeck work on your phone

SignalDeck already knows the Armor 20WT's radio on paper. We've read its stock walkie-talkie app line by line, and the new beta drives the radio the same way that app does. Nobody has run it on a 20WT yet, though, so a few facts can only come from a real phone:
- the radio module's version;
- which extra commands it answers (signal strength, caller ID, monitor);
- whether its receive audio flows the way SignalDeck opens it.

That's what this request is for.

**You need:** an Armor 20WT with Magisk root, about 10 minutes, and no other app using the radio. **Nothing is transmitted** in steps 1–4.

1. Install SignalDeck **1.0.0-beta.N** (link) over any earlier build.
2. **Open the stock walkie-talkie app once,** let it finish "initializing", then close it. Its channel files only exist after it has run, and the report reads them.
3. In SignalDeck, go to **Device → Device report → Run all checks** and choose **Checks + trial**.
   - When asked which walkie-talkie app to open, pick **the stock app** (`com.pri.prizeinterphone`).
   - Press the side PTT key a few times when it asks you to (10 s). Don't press it while the stock app is open for its 15 seconds.
   - The trial takes the radio for about 30 seconds, listening only, then gives it back to the stock app.
4. *Optional but very useful:* go to **Device → Device report → Radio firmware files (root, you choose)** and send us the list it shows (names, sizes and SHA-256 only). Don't tick any files unless we ask privately; those files belong to the phone maker.
5. Send the zip with **Send** (e-mail, a messenger or a cloud drive), or **GitHub issue** to attach it to an issue.
   - The report blanks radio IDs and personal details.
   - Please still check it before you share it.

**Later, only if we ask:** once the report looks right, we'll send a test build for the guided **Transmit test session** (Device → Device report → Transmit test session). It keys the radio briefly at low power on a channel you choose and records what the module does. On this phone the current beta never transmits until that test has passed.

Thank you! Every report brings the 20WT closer to full support. Questions go in this thread.

---

**Notes for the owner (not part of the post):**
- **What the zip should contain** (review §"What the next 20WT device report must bring back"):
  - the trial's `module version:` line;
  - a `UART /dev/ttyS1 open @ 57600 (stock serial library)` line;
  - `module booted:` or `no boot banner`;
  - the "commands the stock app does not use" table;
  - `rx_audio_raw.bin` with bytes in it;
  - a "Databases of com.pri.prizeinterphone after the watch" section listing `channel_database_*.db`;
  - `stock_serial.txt` from the 15 s watch (the stock app's own handshake on the wire).
- **The transmit step needs a build with the 20WT profile set to verified.** The public beta refuses to transmit on an unverified profile (`TxReport.gate`). That build is the maintainer's call after reading step 3's report.
