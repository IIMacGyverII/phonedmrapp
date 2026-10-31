# Armor 20WT tester request (draft for the owner to post)

**Where:** the Armor 20WT's own Discussions thread, https://github.com/IIMacGyverII/SignalDeck/discussions/166 (the index of all phone threads is #170). **Post after** beta.23 is published (it carries SignalDeck PRs #157 and #158). Fill in the beta link below.

---

### Ulefone Armor 20WT owners: help us make SignalDeck work on your phone

SignalDeck already knows the Armor 20WT's radio on paper. We've read its stock walkie-talkie app line by line, and the new beta drives the radio the same way that app does. Nobody has run it on a 20WT yet, though, so a few facts can only come from a real phone:
- the radio module's version;
- which extra commands it answers (signal strength, caller ID, monitor);
- whether its receive audio flows the way SignalDeck opens it.

That's what this request is for.

**You need:** an Armor 20WT with Magisk root, about 15 minutes, and no other app using the radio. **Nothing is transmitted** in steps 1–5.

1. Install SignalDeck **1.0.0-beta.23** (link) over any earlier build.
2. **Open the stock walkie-talkie app once,** let it finish "initializing", then close it. Its channel files only exist after it has run, and the report reads them.
3. In SignalDeck, go to **Device → Device report → Run all checks** and choose **Checks + trial**.
   - When asked which walkie-talkie app to open, pick **the stock app** (`com.pri.prizeinterphone`).
   - Press the side PTT key a few times when it asks you to (10 s). Don't press it while the stock app is open for its 15 seconds.
   - The trial takes the radio for about a minute and a half, listening only. It checks the squelch, the receive level, how fast the signal reading settles and which frequencies the radio tunes at the band edges, then gives the radio back to the stock app.
4. *Optional but very useful:* go to **Device → Device report → Radio firmware files (root, you choose)** and send us the list it shows (names, sizes and SHA-256 only). Don't tick any files unless we ask privately; those files belong to the phone maker.
5. Post the zip in **this thread** (https://github.com/IIMacGyverII/SignalDeck/discussions/166): tap **Send** and save or share the zip, then attach it to a reply here.
   - The report blanks radio IDs and personal details.
   - Please still check it before you share it.

6. **Transmit test, only once the steps above went fine** and only if you're licensed for the frequency you'll use (a dummy load or low power on a simplex frequency you may use):
   - In SignalDeck, tap **Take over** on the Device page.
   - Open **Device → Device report → Transmit test session**, switch on each safety rule, and follow the steps. It makes a few short keys and records what the module does.
   - Then post the new zip in this thread too.
   - On the 20WT this session is the only way SignalDeck transmits until the phone is verified. The Talk key and the side key stay off.

Thank you! Every report brings the 20WT closer to full support. Reports and questions go in this thread (Armor 20WT, #166); other phones have their own threads, listed in #170.

---

**Notes for the owner (not part of the post):**
- **Troubleshooting (owner, 2026-10-30):** if a tester reports a dialog in the way or a step that "doesn't respond", the likely cause is Google Play Protect's "send this app for a security check" prompt, which often appears when SignalDeck loads. Tap "Don't send"; SignalDeck is unaffected.
- **What the zip should contain** (review §"What the next 20WT device report must bring back"):
  - the trial's `module version:` line;
  - a `UART /dev/ttyS1 open @ 57600 (stock serial library)` line;
  - `module booted:` or `no boot banner`;
  - the "commands the stock app does not use" table;
  - `rx_audio_raw.bin` with bytes in it;
  - a "Databases of com.pri.prizeinterphone after the watch" section listing `channel_database_*.db`;
  - `stock_serial.txt` from the 15 s watch (the stock app's own handshake on the wire).
- **Transmit:** PR #158 lets the Transmit test session (and only it) key the unverified 20WT profile (`txTestUnverified`). No special build is needed.
- **New trial lines to read:**
  - the `squelch check` verdict;
  - the `receive level by module volume byte` (with `rx_level_v5.wav`/`rx_level_v8.wav`);
  - `signal reading after a retune` (first / steady ms);
  - the `band edges` accepted/refused list.
