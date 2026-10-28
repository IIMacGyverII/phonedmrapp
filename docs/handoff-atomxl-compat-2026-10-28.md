# Handoff: Unihertz Atom XL, device report tuning and full compatibility (2026-10-28)

**For:** a new Claude Code agent. **From:** the owner, written by the Claude agent that manages the firmware bench.
**Goal:** use the Atom XL to make SignalDeck's device report as automated and complete as possible for a phone of
a new family, then make the Atom XL a fully compatible SignalDeck device. Also put the phone's module firmware into
the firmware repository, so firmware work can start later.

## 1. The phone, and the one rule about phones

| What | Value |
|---|---|
| Phone | Unihertz **Atom XL** (`Atom_XL`), MediaTek MT6771 (Helio P60), Android 11, ODM Agold |
| adb | **USB only, serial `ATOMXL0000000737`** |
| Root | Magisk, rooted by the owner (check first: `su --mount-master --context u:r:magisk:s0 -c id` must give `uid=0 … u:r:magisk:s0`) |
| Stock radio app | `com.agold.intercom` v2.0. It opens no device itself: it calls the HIDL service `vendor.mediatek.hardware.aguiextmodule@1.0::IAguiExtModule/default`, which holds `/dev/ttyACM0` (a USB CDC-ACM port to a small MCU in front of the module) and the PCM |
| Radio | DMR module `DMR006.U4A.V082` (HR-C7000 family, the Armor's relative), UHF |

**Every adb command you run carries `-s ATOMXL0000000737`. Work only with that phone.** Two other phones are on
this PC, and neither is yours:
- **Ulefone Armor 26 Ultra** (Wi-Fi ADB `192.168.1.125:5555`, sometimes USB `5006AF1020002922`): the firmware bench
  of another agent (Grok) and the managing Claude agent, under leases in `radio_firmware/HANDOFF.md`.
- **ANYSECU W6+** (USB `W6202601000904`): the owner's.

Never send either one a command, install on it, or reboot it. Never run `adb` without `-s`: with three phones attached,
a bare call fails or hits the wrong one. **No HackRF and no hotspot** for this work. Both belong to other work, and
the HackRF is leased elsewhere today. Ask the owner if a test truly needs an RF source.

## 2. Read first

1. `CLAUDE.md` in this repository (sections 2, 3, 6, 10 and 11) and the SignalDeck repository's `CLAUDE.md`.
2. **What we know about this phone:** `docs/multi-device-atomxl-findings.md` here. It covers the transport, the HAL
   interface, the MCU envelope and its checksum, and the command set (the Armor's, with the `0x2C` text-header
   difference). It is built from two owner reports and the decompiled stock app; nothing has been run on an Atom XL
   yet. Treat every line as a hypothesis to confirm on this phone, and correct the document where the phone disagrees.
3. **The device-report plan and tools the W6 agent built**, now in SignalDeck main (merged via PR 48 on 2026-10-28):
   - `docs/W6_DEVICE_REPORT_PLAN.md`: success criteria, phases, the report backlog;
   - `docs/DEVICE_SUPPORT_REQUEST.md`: the report as users see it, and the su quoting rules;
   - `docs/w6/`, and `docs/handoff-w6-device-report-2026-10-27.md` here: how that phone went from unknown to
     compatible;
   - the bench driver `run_checks.sh`, `report.json`, the draft-profile output, the `AtModuleEngine` (a second
     engine) and the `DeviceProfile`/engine selection by `profile.protocol`.
   The Atom XL is the second phone of a new family through that pipeline: it shows what the report still assumes.
4. **The firmware repository:** `D:\Documents\code\personal\AndroidRadio_Firmware_Project`. Read its `CLAUDE.md`,
   then `devices/unihertz-atom-xl/README.md` and `firmware/unihertz-atom-xl/DMR006.U4A.V076/README.md`. V076 is the
   updater copy from an owner's vendor partition (`factory: false`); the module runs V082, which nobody has yet.
5. Background: `docs/multi-device-xplore1-findings.md` (engine and profile architecture, sections 3–5) and
   `docs/multi-device-armor3wt-findings.md`.

## 3. Work, in this order

### Phase A: baseline and identity (read only)
1. Check root, record `getprop` identity (model, build, SELinux, `ro.agold.*`, `ro.agui.*`), and confirm the HAL
   service, `/dev/ttyACM0` (present only after the stock app calls `startMcu()`), and the PTT keycode. The reports
   saw `KEYCODE_F12`/142 from `mtk-kpd` at start-up; press-test it with the owner.
2. Install the SignalDeck **release** build from main (section 5), grant root once, run **Run all checks**, pull the
   report. That is baseline report A.
3. Write the gap list in `docs/atomxl/PHASE_A_FINDINGS.md` on your branch: what the report got wrong or missed on
   this phone. The known ones: no `ttyACM` probe, `ttyS0` left at 230400, no HAL detection, no MCU-envelope framing.

### Phase B: the module firmware into the firmware repository (read only, start early)
4. **Find the running image's file.** As root, read only and list before copying:
   - `/vendor/data/DMR/dmr/`, `/vendor/data/mcu/`, `/vendor/firmware*`, `/odm`, `/product`, `/system/vendor`, and any
     path the HAL binary or the stock app names for `updateDmr`. `strings` the HAL service binary and the stock APK
     for `.bin` paths.
   - Note every `DMR006*` image: path, size, SHA-256, version string. On V076 the string is at file `0x33410`; check
     the tag offset per file.
   - The module's own version reply (`0x34`) is the truth for what it runs.
5. **If a V082 (or newer) image is on the phone:** copy it byte for byte. The copy carries no personal data, but check
   anyway. Add it to the firmware repository as `firmware/unihertz-atom-xl/DMR006.U4A.V0xx/`, with the file,
   `manifest.json`, `README.md` (provenance: path, phone build, how it was read) and its `tagOffset`. It is
   `factory: true` only if its version string equals the module's `0x34` reply; otherwise research, like V076.
   Update the device page. Then `python scripts/build_catalog.py --check`, bump `serial`, sign with
   `scripts/sign_catalog.py` (the key lives outside every repository, as that repository's `catalog/KEYS.md` says), a
   `CHANGELOG.md` entry, one PR. **The owner merges.**
6. **If it is not on the phone:** say so in the device page and in your progress log, with the paths you checked.
   Do not try to get it out of the module. **Never call the HAL's `updateDmr` or `updateMcu`, never enter the module's
   update mode, never write to `/dev/ttyACM0` except the identity queries in section 4.** Reading the module's flash
   needs firmware that does not exist for this phone yet. That is the later firmware work, managed by the
   firmware-bench Claude agent, after the Armor 26's firmware work is done. Leave a short "what firmware work needs"
   note: the image, how `updateDmr` reaches the module (a capture of one stock update, owner's decision), and the
   bridge MCU's role.

### Phase C: report tuning (the owner's emphasis: automation)
7. Work the gap list into the report. Each fix is proven on the Atom XL and covered by a host test:
   - detection of the HAL transport and `ttyACM` ports;
   - an identity-only probe through the envelope (route `01`, command `0x34`, checksum verified both ways);
   - the PTT key and broadcasts;
   - the 48 kHz PCM route;
   - the draft profile's new fields.
   The whole report still runs from one adb command with no screen taps. A supported phone's report must not change.
   Show that with a diff from a report the owner provides; never take the Armor to make one.

### Phase D: full compatibility
8. **Design before code.** Write `docs/atomxl/TRANSPORT_DESIGN.md` and tell the owner before building. The command set
   is the Armor's, so SignalDeck's `RadioEngine` should work unchanged over a new transport. The design covers:
   - how SignalDeck reaches the module: the HAL over HIDL from an app (likely blocked by SELinux and service
     permissions), or `/dev/ttyACM0` directly with the HAL stopped, which is the probe's job to settle. Use the
     `su --mount-master --context u:r:magisk:s0` pattern and the Magisk sepolicy-module route the Armor uses;
   - starting and stopping the MCU (`startMcu`/`stopMcu`, the `mcu_eint` line);
   - the envelope (`route`/`rw`/BE length/Internet checksum) and the reply mapping to the Armor's `sr`;
   - audio over the HAL's PCM (48 kHz stereo) or another route;
   - PTT;
   - the 5-byte `0x2C` header, a per-module difference the engine must carry;
   - the module features this phone lacks (V076 has no `0x3D`–`0x3F`/`0x46` case; check V082 by behaviour, read
     only).
9. Build it on its own branch: a transport behind the existing engine, a `DeviceProfile` for the Atom XL, and the
   take-over and give-back of the stock app, the same as the Armor.
   - Receive is yours to test with whatever the bench air carries, or the owner's radios.
   - **Transmitting is the owner's:** prepare the script and the expected result, then ask. The owner keys in the
     Faraday cage.
   - The profile stays unverified, with transmit blocked, until the owner confirms on air, as the W6 did.

## 4. Hard rules

- **Identity queries only** until the owner says otherwise: the module's `0x34` and the MCU's own version command
  (route `00`), both through the envelope with the stock app stopped. Nothing that tunes, keys or changes module or
  MCU settings without the owner. **No firmware loading of any kind.**
- **No bootloader or partition work.** Never `adb reboot bootloader`, `fastboot`, or a partition write. A plain
  `adb -s ATOMXL0000000737 reboot` is fine; the phone is on USB. Read-only `dd` of a partition to find the image is
  fine; keep the copy outside the repositories unless it is the module image itself.
- **Vendor sysfs:** list node names first and read one node per step, logging a marker before each read. A W6 driver
  panicked the kernel on reads of unwired GPIO attributes, so never loop-`cat` a vendor directory.
- **Never `adb uninstall` SignalDeck** (the Magisk grant and the data go with the UID); use `install -r`, or
  `install -r -d` to go back a version. **Never uninstall, clear or factory-reset the stock app:** SignalDeck disables
  it at runtime only, and a reboot must always leave the phone with a working radio app.
- **Repositories.**
  - SignalDeck work goes in your own worktree:
    `git -C D:\Documents\code\personal\SignalDeck worktree add ..\SignalDeck-atomxl -b atomxl/<topic> origin/main`.
    Never touch the `SignalDeck` main checkout (Grok's), `SignalDeck-queue`, `SignalDeck-merge` (the managing agent's)
    or `SignalDeck-w6`.
  - One branch and one PR per change, and never merge your own PR.
  - In phonedmrapp commit only your own paths (`docs/atomxl/…`, corrections to `docs/multi-device-atomxl-findings.md`),
    never `git add -A`, and never anything under `radio_firmware/`.
  - The firmware repository follows its own `CLAUDE.md` (mirror `CLAUDE.md`/`GROK.md` if you edit either).
- **Every SignalDeck change ships with:**
  - its `CHANGELOG.md` row, noting whether it was device-tested;
  - in-app help (a `HelpView` topic or info texts);
  - host tests;
  - for any new page, mode, tool or transmit path, its Restricted-mode wiring (`docs/plan-restricted-mode.md`;
    Restricted mode is PR 26, not merged yet, so say in the PR how it is handled).
- **Privacy.** Nothing committed to any repository carries an IMEI, phone number, MAC, account, serial other than the
  adb serial above, callsign, DMR ID or location. Scrub reports before committing. No GPL code and no third-party
  decoder code in SignalDeck.
- **No releases.** Only the owner asks for a SignalDeck beta or release.

## 5. Build and install

- JDK 17: `C:\Users\Joshua\tools\jdk-17.0.20.1+1`.
- Copy `local.properties` from the main SignalDeck checkout into your worktree (gitignored; it points at the release
  keystore). Debug and release share the certificate.
- `./gradlew assembleRelease`, then `adb -s ATOMXL0000000737 install -r app/build/outputs/apk/release/app-release.apk`.
- The Atom XL is 64-bit (`arm64-v8a`).

## 6. Reporting to the owner

Keep a running log in `docs/atomxl/PROGRESS.md` on your branch: time, what changed, what the phone showed, what
is next. A PR is the report for a finished item: before/after lines from the Atom XL. Ask the owner directly for key
presses, keying in the cage, merges and scope. The firmware side (V082 and anything after it) is reported to the
owner and noted for the managing Claude agent in your progress log. Do not write in `radio_firmware/HANDOFF.md`.

## 7. Done means

1. The plan's success criteria hold on the Atom XL, and one adb command runs every check and pulls the folder.
2. The report's draft profile is right for the Atom XL field by field, and a supported phone's report is unchanged.
3. The firmware repository holds the module image the phone runs (or says exactly why it does not), with manifest,
   provenance and a signed catalogue, in a PR the owner merged.
4. SignalDeck drives the Atom XL: take-over and give-back, channels, receive with audio, DMR calls and texts heard, and
   transmit confirmed by the owner on air. The profile is then marked verified.

## 8. Opening prompt for the agent

> Read `docs/handoff-atomxl-compat-2026-10-28.md` in D:\Documents\code\personal\phonedmrapp and follow it. Your phone is the
> Unihertz Atom XL on USB, adb serial ATOMXL0000000737; pass `-s ATOMXL0000000737` on every adb call and never touch the
> Armor 26 Ultra (192.168.1.125:5555 or 5006AF1020002922) or the W6+ (W6202601000904). No HackRF, no hotspot.
> Start with Phase A, and start Phase B's read-only search for the module image early.
