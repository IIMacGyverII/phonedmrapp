# Blackview Xplore 1 tester request (draft for the owner to post)

**Where:** the Xplore 1's Discussions thread, https://github.com/IIMacGyverII/SignalDeck/discussions/167 (index of all phone threads: #170). **Post after** SignalDeck 1.0.0-beta.23 is published (it carries PR #159, merged as `61bf30b7`).

---

### Blackview Xplore 1 owners: one more report, then the first transmit test

Thanks to your reports, receiving already works on the Xplore 1: voice, MON, CTCSS and channel import. Transmitting has never been tried.

We've now read the Xplore's own walkie-talkie app (QuickChat) line by line, transmit first, and the new beta transmits the same way it does:
- it keys the radio with the phone's PTT line, not with a command;
- it starts the microphone only when the radio says it is transmitting;
- it sends DMR texts in QuickChat's format.

Before SignalDeck may transmit on every key, a real Xplore 1 has to confirm this.

**You need:** your Xplore 1 with Magisk root, about 20 minutes, and no other app using the radio. **Nothing is transmitted** in steps 1–4.

1. Install SignalDeck **1.0.0-beta.23** (link) over your earlier build.
2. **Open QuickChat once,** let it finish initializing, then close it. The report reads its channel files and watches its start-up for 15 seconds.
3. In SignalDeck, go to **Device → Device report → Run all checks** and choose **Checks + trial**.
   - When asked which walkie-talkie app to open, pick **QuickChat** (`com.chamsion.quickchat`).
   - Press the side PTT key a few times when it asks you to (10 s). Don't press it while QuickChat is open for its 15 seconds.
   - The trial takes the radio for about a minute and a half, **listening only**. It checks:
     - the squelch;
     - the receive level at two volume settings;
     - how fast the signal reading settles;
     - which frequencies the radio accepts at the band edges.
   - Then it gives the radio back to QuickChat.
4. Post the zip in the Xplore 1 thread, https://github.com/IIMacGyverII/SignalDeck/discussions/167: save it with **Send**, then attach it to a reply there. If you'd rather not post it publicly, send it with **Send** by e-mail, a messenger or a cloud drive, and say so in the thread.
   - The report blanks radio IDs and personal details.
   - Please still check it before you share it.

5. **Transmit test, only once we've told you the report above looks right,** and only if you're licensed for the frequency you'll use (a dummy load, or low power on a simplex frequency you may use). You'll also want a second radio to listen, ideally a DMR one.
   - In SignalDeck, tap **Take over** on the Device page.
   - Open **Device → Device report → Transmit test session**, switch on each safety rule, and follow the steps. It makes a few short keys on FM, one DMR group call, **one short DMR text** ("SignalDeck test 1") and records what the radio reports each time.
   - Tell it honestly what the other radio heard and showed, then **Send** again and post that zip in the same thread.
   - On the Xplore 1 this session is the only way SignalDeck transmits until the phone is verified. The Talk key and the side key stay off.

Thank you! These two reports are what turns the Xplore 1 into a fully supported phone. Questions and results go in the Xplore 1 thread (#167); other phones have their own threads, listed in #170.

---

**Notes for the owner (not part of the post):**
- **Transmit:** PR #159 sets `txTestUnverified` on the Xplore 1 (owner approved 2026-10-30): the Transmit test session, and only it, may key it, as on the 20WT. No special build is needed.
- **Report (steps 1–4), what the zip should contain:**
  - `module version: DMR003BN.UV4P.V016` (or a newer one);
  - `module booted` in the trial;
  - the trial's `squelch check` verdict (this phone has needed monitor before);
  - `receive level by module volume byte` with `rx_level_v8.wav` (QuickChat itself sends volume 0; we keep 8);
  - `signal reading after a retune` and the `band edges` list;
  - the "commands the stock app does not use" table: answers to `0x2B` caller info, `0x32`, and the `0x36` acknowledgements;
  - `stock_serial.txt` from the 15 s watch, which should show `0x27`, `0x34`, a channel, then `0x35` and `0x37`;
  - the app log lines `line intercom_ptt_control -> 1` at bring-up.
- **Transmit session (step 5), what to read:**
  - each key's PTT path should say `phone lines intercom_ptt_control=0 … no 0x26`;
  - a key with **no SEND_START** means the line did not key the module (stop there and tell us);
  - SEND_STOP should follow each release;
  - the FM and DMR steps' "heard" answers check the `ttyS1` transmit audio;
  - the text step shows `body type, target, UTF-8 text (QuickChat's)` and status 8 (delivered) or 9 (failed). If the other radio shows the text garbled, the module wants another body, and we'll compare with QuickChat sending the same text.
