# Handoff — ANYSECU W6: root (Grok), then SignalDeck bring-up (Claude)

**Device:** ANYSECU W6 — Amazon B0D8T6ZLT7. "4G network radio", Android 10, UHF 400–470 MHz
analog walkie-talkie, Zello / Real-PTT, WiFi, IP68. Marketplace listings put it at 2+16 GB; the SoC is
not published (expect a MediaTek part, like the other Blackview/ANYSECU network radios). This is the
owner's own device, bought for this project.

**Two agents, in order:**
1. **Grok** — roots the device. Works in its own Ubuntu VM, its own way. Claude is not involved in the
   root and does not advise on it.
2. **Claude** — takes over when the owner says the device is ready: installs SignalDeck, runs the device
   report, and uses this new, unsupported phone to improve and tune the report, and ultimately to add a
   device profile that makes the W6 compatible.

The point of the exercise is twofold: get the W6 working, and harden the Device report / bring-up flow by
running it against a phone SignalDeck has never seen.

---

## Part 1 — Grok's job: root the W6

Grok owns this part entirely: unlock, patch, flash, whatever the W6 needs. Do it in the Ubuntu VM.
When finished, root means: `su` from an adb shell returns `uid=0`, and it survives a reboot (Magisk or
equivalent). Nothing in SignalDeck's flow needs a particular root manager, only working root and the
ability to run a command as root and read `/dev`, `/sys` and other apps' APKs.

**Do not** disable, uninstall or factory-reset the stock walkie-talkie app while rooting — Claude needs it
in place (its APK carries the radio's firmware asset and the clues the profile is built from). It only
needs to be *disabled at runtime* later, which SignalDeck does itself.

Leave the phone reachable over adb (USB cable on the bench; Wi-Fi ADB does not survive a reboot).

---

## Part 2 — Claude's job: SignalDeck bring-up and compatibility

Starts only when the owner tells Claude the device is ready. Nothing here is Grok's to do.

1. **Install SignalDeck** (release build, same keystore) and grant it root (Magisk). Do **not**
   `adb uninstall` anything on this phone.
2. **Run the Device report** (Device → Device report → Run all checks, plus "Help support this phone").
   This is the whole reason for an unsupported phone: watch where the report is thin, guesses wrong, or
   crashes on a device with no profile, and fix it. Likely tuning points, from the Xplore 1 / Atom XL /
   Armor 3WT findings:
   - control port path and baud (profile does its own termios);
   - audio backend — tinyservice binder vs raw PCM on a second tty;
   - module power/PTT sysfs nodes and their value format;
   - SELinux labels on the tty/sysfs nodes (the `sepolicy.rule` lines the profile ships);
   - hardware PTT key broadcast action(s);
   - which stock app to disable at runtime;
   - the stock app's firmware asset and version (the `StockApk` + `pm path` path just added for #22/#23
     is exactly what finds these on a phone whose app the package manager hides).
3. **Feed the findings into the report**: any field the report couldn't fill, or filled wrong, becomes a
   report improvement (host test first, then device). Capture the raw probe output into the report doc.
4. **Build a `DeviceProfile` for the W6** and register it (unverified until the owner confirms on air), so
   SignalDeck recognises the W6 and drives its radio. New profile constant + `ProfileRegistry`; advisory
   rules as for the Xplore 1.
5. Changelog, in-app help and host tests for every SignalDeck change, as usual; secret grep clean; one
   branch/PR per change.

Reference: `docs/multi-device-xplore1-findings.md` §3–5 (the device-profile abstraction and the
engine/profile architecture), `docs/multi-device-atomxl-findings.md`, `docs/multi-device-armor3wt-findings.md`.

