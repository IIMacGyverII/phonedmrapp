# Handoff: the W6+ device report and a new compatible device (2026-10-27)

**For:** a new Claude Code agent. **From:** the owner, written by the Claude agent that reviews Grok's firmware bench.
**Goal:** use a phone SignalDeck has never supported to make the Device report as automated and as complete as
possible, then make that phone a compatible SignalDeck device.

## 1. The phone, and the one rule about phones

| What | Value |
|---|---|
| Phone | ANYSECU **W6+** (model string `W6+`), Unisoc SL8541E (`sp9832e`), **Android 12**, 32-bit only |
| adb | **USB only, serial `W6202601000904`** |
| Root | Magisk, working: `su --mount-master --context u:r:magisk:s0 -c id` gives `uid=0 … u:r:magisk:s0` (checked 2026-10-27 15:5x) |
| State | Bootloader unlocked (verifiedbootstate orange), SELinux **permissive** |
| Stock radio app | `com.flyscale.analogpoc` (priv-app, uid 1000), drives `/dev/ttyS2` at 9600 8N1 with SA818-class `AT+DMO…` commands |
| Radio | UHF analog FM only, 400–470 MHz. No DMR. |

**Every adb command you run carries `-s W6202601000904`. Work only with that phone.** The other phone on this PC is
the Ulefone Armor 26 Ultra (Wi-Fi ADB `192.168.1.125:5555`, sometimes also USB `5006AF1020002922`). It belongs to the
firmware bench run by another agent (Grok) and the reviewing Claude agent, under leases in
`radio_firmware/HANDOFF.md`. You never send it a command, never install on it, never reboot it, and never run a
command without `-s` (with two phones attached, a bare `adb` call fails or hits the wrong one).

## 2. Read first

1. `CLAUDE.md` in this repository, sections 2, 3, 6, 10 and 11, and the SignalDeck repository's own `CLAUDE.md`.
2. **The plan: `docs/W6_DEVICE_REPORT_PLAN.md` in the SignalDeck repository.** It sets the success criteria (section 2), the
   phases (section 3) and the report backlog (Phase 2, items 1 to 26). This handoff does not repeat it; it says
   where you start and what you must not do.
3. **The W6 notes in `D:\Documents\code\personal\SignalDeck\docs\w6\`**: `PHASE0_FINDINGS.md` (what the phone
   said unrooted, and the nine gaps baseline report A had), `REPLACEMENT.md`, `ROOT_ATTEMPT_2026-10-24.md` and
   `reports/`. They are **untracked files in Grok's main checkout**: read them there, copy (never move) the folder into
   your worktree and commit it on your first branch, minus anything the privacy rule below excludes. The phone on
   the bench is the **replacement unit**: the first W6 died during a root attempt on 2026-10-24, and
   `ROOT_ATTEMPT_2026-10-24.md` says how.
4. `docs/DEVICE_SUPPORT_REQUEST.md` (SignalDeck repository): the report as users see it, and the su quoting rules.
5. Background for other phone families: `docs/multi-device-xplore1-findings.md` (engine and profile architecture,
   sections 3 to 5), `docs/multi-device-atomxl-findings.md`, `docs/multi-device-armor3wt-findings.md` in this repository.

## 3. Where you start

Phase 0 (unrooted baseline) was done on 2026-10-24. The phone has been rooted since. **Start at Phase 1**: install the
SignalDeck release build, grant root once in Magisk, run **Run all checks**, pull baseline report B, diff it against
A, and write the list of profile facts B lacks or has wrong. That list plus the plan's Phase 2 items is your backlog.

Then work the backlog in the plan's order, highest value first. The owner's emphasis is automation: the whole report
should run from adb with no screen taps (Phase 2 item 10, the bench driver), produce `report.json` (item 9), and end
with a draft profile (item 8). Each improvement is proven on the W6 and covered by a host test.

**The end goal is a working W6 profile.** The W6's module speaks SA818-class AT commands, not the `68 … 10` DMR MCU
protocol every current profile uses. A profile alone will not drive it: SignalDeck will need a second engine (analog
only: tune, squelch, CTCSS/DCS, power, PTT, volume over `AT+DMO…`) behind the same `RadioEngine` interface, plus the W6's
audio route. Before you build the engine, write its design (command set from the stock app's sniffed traffic and its
decompiled code, which features map and which are hidden on an analog-only radio) into `docs/w6/ENGINE_DESIGN.md`
and tell the owner. Then build it on its own branch.

## 4. Hard rules

- **Never read any attribute of `/sys/devices/virtual/misc/flyscale_misc/`, and never loop-`cat` a vendor sysfs
  directory.** Reading `af_en` panics the kernel (found 2026-10-24), and so does `dmr_pwd` on the replacement unit
  (2026-10-27, `dmr_pwd_show → gpiod_get_value_cansleep`), although Phase 0 had read `dmr_pwd` safely on the first
  unit: the `misc_flyscale` driver's show handlers touch unwired GPIOs, so list the names only. Read only node names the stock app or init.rc name, one read per step, logging a
  marker before each so a panic points at its cause.
- **No bootloader or flashing work.** The phone is rooted and stays that way. Never `adb reboot bootloader`,
  `adb reboot autodloader`, `fastboot` anything, or write a partition. A dead W6 cost a unit already. A normal
  `adb -s W6202601000904 reboot` is fine when a test needs it; the phone is on USB, so adb comes back.
- **Never `adb uninstall` SignalDeck** (the Magisk grant and the data go with the UID). Use `adb install -r`, or
  `install -r -d` to go back a version. **Never uninstall, clear or factory-reset the stock app**: SignalDeck disables it
  at runtime only.
- **Transmitting is the owner's.** Anything that keys the radio is done by the owner, a licensed operator, inside the
  Faraday cage. You prepare the script and the expected result, then ask. Receive, reads and module identity queries are yours.
- **The probe only reads.** Identity queries (`AT+DMOCONNECT`, the DMR version query) are fine. Never send a write
  that tunes, keys or changes module settings without the owner.
- **Repositories.** SignalDeck changes go in **your own worktree**, for example
  `git -C D:\Documents\code\personal\SignalDeck worktree add ..\SignalDeck-w6 -b w6/<topic> origin/main`.
  Never pull, stash, reset or switch the main `SignalDeck` checkout (Grok works there) or `SignalDeck-queue`
  (the reviewing agent's). One branch and one PR per change; never merge your own PR, the owner merges.
  In phonedmrapp, commit only your own paths (never `git add -A`); `radio_firmware/` is not yours.
- **Every SignalDeck change ships with** its `CHANGELOG.md` row (note whether device-tested), in-app help
  (`HelpView` topic or info texts), host tests, and, for any new page, mode, tool or transmit path, its Restricted-mode
  wiring (`Restriction.MODES`/`ADMIN`, the service guard, PKT/Device/Web hiding, the `RestrictedDialog` switch;
  `docs/plan-restricted-mode.md`). Restricted mode is PR 26, not merged yet: if your change needs it, branch from it or
  wire it in after it merges, and say which in the PR.
- **Privacy.** Reports and docs committed to either repository carry no IMEI, phone number, Wi-Fi MAC, account name,
  serial number other than the adb serial above, callsign or location. Scrub before committing; the report itself
  must not collect what the maintainer does not need. No GPL code and no third-party decoder code in SignalDeck.
- **No releases.** Only the owner asks for a SignalDeck beta or release.

## 5. Build and install

- JDK 17 for gradle: `C:\Users\Joshua\tools\jdk-17.0.20.1+1`.
- Release signing comes from `local.properties` (it points at `DMRModHooks/release.keystore`); copy it from the main
  SignalDeck checkout into your worktree (it is gitignored). Debug and release share the certificate, so the
  root grant survives switching between them.
- `./gradlew assembleRelease`, then `adb -s W6202601000904 install -r app/build/outputs/apk/release/app-release.apk`.
- The W6 is 32-bit (`armeabi-v7a`). Check that the APK carries what SignalDeck loads natively on that ABI before
  blaming the phone.

## 6. Reporting to the owner

Keep a running log in `docs/w6/PROGRESS.md` on your branch: date and time, what you changed, what the W6 showed,
what is next. When you finish a backlog item, a PR is the report: its description says what the report gained and
shows the before/after lines from the W6. Ask the owner directly for anything that needs a key press in the cage, a
merge, or a decision about scope. The reviewing Claude agent does not manage this work.

## 7. Done means

1. The plan's success criteria (section 2) hold on the W6, unrooted and rooted.
2. One adb command runs every check and pulls the folder; `report.json` and the host diff script work on two W6 reports.
3. The summary's draft profile is right for the W6, field by field, against what you measured.
4. SignalDeck receives on the W6 through a W6 profile and the new engine (the owner keys it in the cage to confirm
   transmit), the profile marked unverified until the owner confirms on air.
5. The improvements that help every phone (the same checks on the Armor-family report) do not change what a
   supported phone's report says, shown by a report diff from a supported phone the owner provides. Do not take the Armor to produce it.

## 8. Opening prompt for the agent

> Read `docs/handoff-w6-device-report-2026-10-27.md` in D:\Documents\code\personal\phonedmrapp and follow it. Your phone
> is the ANYSECU W6+ on USB, adb serial W6202601000904; pass `-s W6202601000904` on every adb call and never touch
> the Armor 26 Ultra (192.168.1.125:5555 or 5006AF1020002922). Start at Phase 1 of the SignalDeck repository's
> `docs/W6_DEVICE_REPORT_PLAN.md`, in your own SignalDeck worktree.
