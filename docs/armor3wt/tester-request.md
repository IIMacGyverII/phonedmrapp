# Armor 3WT tester request (draft for the owner to post)

**Where:** the Armor 3WT's own Discussions thread, https://github.com/IIMacGyverII/SignalDeck/discussions/168 (the index of all phone threads is #170). **Post after** the beta that carries SignalDeck PR #175 is published (beta.23 if it is merged before). Fill in the beta link below.

---

### Ulefone Armor 3WT owners: help us make SignalDeck work on your phone

SignalDeck now knows the Armor 3WT's radio on paper. We read the phone's intercom app and its radio service (`extmodule`) line by line, and the new beta talks to that service the same way the intercom app does. Nobody has run it on a 3WT yet, though, so a few facts can only come from a real phone:
- whether SignalDeck's start-up reaches the radio through `extmodule`;
- the module's answers to the band edges, including below 136 MHz;
- the receive audio stream's format;
- what the side key sends.

That's what this request is for.

**You need:** an Armor 3WT with Magisk root, your Magisk module that installs the intercom app and `extmodule` (keep it as it is: SignalDeck uses it), about 15 minutes, and no other app using the radio. **Nothing is transmitted:** on the 3WT SignalDeck only listens until the phone is verified.

1. Install SignalDeck **1.0.0-beta.N** (link) over any earlier build.
2. **Open the intercom app once,** let it come up on a channel, then close it.
3. In SignalDeck, go to **Device → Device report → Run all checks** and choose **Checks + trial**.
   - When asked which walkie-talkie app to open, pick **Intercom** (`com.agold.intercom`).
   - Press the side PTT key a few times when it asks you to (10 s). Don't press it while the intercom app is open for its 15 seconds.
   - The trial takes the radio for about two minutes, listening only. It checks that `extmodule` is running, asks the radio bridge and module who they are, listens to the receive stream for 5 seconds, writes receive-only channels at the band edges (100, 120, 130, 136, 174, 400, 470 and 480 MHz) and asks the module two questions its intercom app never asks. Then it gives the radio back to the intercom app.
4. *Optional:* if you can hear a local signal, add a channel for it in SignalDeck, tap **Take over** on the Device page and listen for a minute. Then make one more **Run all checks** (Checks only is enough) so the log shows the reception.
5. Post the zip in **this thread** (https://github.com/IIMacGyverII/SignalDeck/discussions/168): tap **Send** and save or share the zip, then attach it to a reply here.
   - The report blanks radio IDs and personal details.
   - Please still check it before you share it.

Please also tell us in your reply:
- whether the intercom app still works normally afterwards;
- what SignalDeck's channel editor shows for a DMR channel (it should say the time slot is chosen by the radio module).

Thank you! Every report brings the 3WT closer to full support. Reports and questions go in this thread (Armor 3WT, #168); other phones have their own threads, listed in #170.

---

**Notes for the owner (not part of the post):**
- **What the zip should contain** (review `stock-app-review.md`, "What the next 3WT device report must bring back"):
  - the trial's **`Armor 3WT (extmodule):`** block:
    - `extmodule: running …, listening on 9980: yes, on 9985: yes`;
    - `bridge MCU build:` (expected `20181221151755`);
    - the `MCU-started report … seen`;
    - `ro.agold.extmodule.32k`;
    - `receive stream forced open 5 s: … per frame`: 1920 means 48 kHz, 1280 means 32 kHz; 0 frames means the daemon streams only during a reception;
    - the band-edge list (accepted / refused / no answer), with the lines below 136 MHz the interesting ones;
    - the raw answers to `0x32` and `0x34`;
  - `module version:` (expected `ver0.5.4_470M_TONE`);
  - `stock_serial.txt` / the intercom app's log from the 15 s watch;
  - the PTT key capture: whether keycode 183 (`PROG_RED`) reached the app, and the `getevent` line `00f9`.
- **Transmit:** the profile is unverified with `txTestUnverified` **off**, so even the Transmit test session refuses on this phone. If the owner wants the guided Transmit test session for the 3WT (as for the 20WT and the Xplore 1), it is one profile flag (`ARMOR_3WT.txTestUnverified = true`) plus a step 6 like the 20WT request's. The flag is not set until the owner approves it.
- **If the trial says the radio did not come up:** check the `extmodule` line first. On a ROM without the owner's module, nothing listens on 9980 and the profile is not even selected (detection requires `/system/bin/extmodule`).
