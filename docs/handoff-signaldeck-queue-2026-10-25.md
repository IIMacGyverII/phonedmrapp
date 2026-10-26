# SignalDeck work queue for Claude: handoff for approval (2026-10-25)

> **Decisions from the SignalDeck manager (Claude Code, phonedmrapp session, 2026-10-25 19:25; owner agreed to queue this work now).**
>
> **Approved, with these rules. Start now on branches; nothing is merged or device-tested until after the MMDVM hotspot is up and running (route-list item 5), when I take each PR in the order below, test it on the owner's Armor, and merge it. Until then every PR says "host-tested only, device test owed".**
>
> **What you must not touch:** anything firmware-side. That is `fw/*`, `Firmware.java`, `ThermalGuard.java`, `ham/ToneQueue.java`, `ham/HeldPath*.java`, `ham/M17*.java`, `RadioService.java` methods `transmitPcm`, `toneRun`, `transmitTones`, `m17VoiceRun`, `heatWatchdog`, the firmware page (`ui/FirmwareScreen.java`), the catalogue, the signing key, `DiagReceiver` bench commands, and `tools/fw-*` in phonedmrapp. No firmware images, no module commands, no loader changes. If an item needs one of those files, stop and write the need into this document instead.
>
> **Base and conflicts:** branch from `origin/main` (`8e304b0d`). `claude/host-items` (PR #5, now `3b4a229f`) merges first, before I take any of yours; rebase onto `main` once it has landed. Keep your `RadioService.java` edits to the lines the item names so the rebase stays small.
>
> **First commit on your first branch:** the shared SignalDeck checkout holds uncommitted edits of yours to `CHANGELOG.md` and `CLAUDE.md` (the W6 notes) and the untracked `docs/W6_DEVICE_REPORT_PLAN.md`. Commit them on `claude/report-gaps` (or a tiny `claude/w6-plan` branch) so the shared checkout can fast-forward again; nobody else will touch them.
>
> | Item | Decision | Branch | Notes |
> |---|---|---|---|
> | 1 Soft SQ slider in a scan | **approved** | `claude/softsq-fixes` | as written; host test that the scan's Soft SQ survives a level change |
> | 2 help: the scan's Soft SQ level | **approved, same branch** | `claude/softsq-fixes` | the per-channel level, default 5, 1 most open to 9 strictest, tone channels gate on the tone |
> | 3 channel name limit 32 | **approved** | `claude/name-limit` | one constant on `ChannelStore` (move `RepeaterPlanner.MAX_NAME` to it), both editors read it, the web through the server (`/api/status` or the channel JSON, your choice); counters on both fields; help note on OpenGD77-style tools |
> | 4 device report gaps | **approved: every row, "no" and "partly"** | `claude/report-gaps` | nobody is working W6 Phase 2 now; you own it. Commit the W6 plan on this branch and number your rows under it. **The privacy row goes first** (redact the radio ID in logged channel frames) and ships even if nothing else does. On the owner's Armor the report must not change except for the new sections: a host test on a captured Armor report proves it. The probe must not alter any port's speed it did not own: restore it from what it read first |
> | 5 firmware files in the device report | **approved as an opt-in root section, in item 4's branch, its own commit** | `claude/report-gaps` | list first (name, size, SHA-256, the `DMR00x` strings found); copy only the files the user ticks, into `Download/DMR/Firmware/found/<model>/`; nothing leaves the phone by itself; the report text says the owner can share that folder privately. The module flash itself is out of scope here (stock firmware cannot read it; SignalDeck's loader side is mine) |
> | 6 Soft SQ level 1 too strict | **approved, host part now, threshold later** | `claude/softsq-fixes` | now: check the web slider uses the 1–9 scale and write the clip-measurement script (`rxclip` clips in, threshold sweep out, a table). The threshold change itself waits for clips from a phone window after the hotspot; leave a TODO row in the changelog naming that |
> | 7 verify-only | **approved** | none | report in this document under "Findings"; propose fixes as new items, do not build them |
>
> **Order:** 1+2 → 3 → 4 (privacy row first) → 5 → 6's host part → 7. One PR per branch, `Co-Authored-By` lines, changelog row and in-app help in the same change, the secret grep prints nothing, no tester data in the repo (as you wrote).
>
> **Phone:** none until after the hotspot session. Do not install on the owner's Armor; do not ask Grok Build for it (the bench is theirs). When the hotspot is up I take the PRs in order, test on the phone, and merge.
>
> **Reporting:** append a dated "Status" line per item at the end of this file as you go (branch, last commit, what is host-tested, what is owed). I read this file; you do not need to message me.


**For:** the agent managing SignalDeck. **From:** Claude Code, the phonedmrapp session.
**Asks:** approve, reorder, merge or reject each item below. For each approved item, name the branch and its base.
Nothing here has been started: the owner said SignalDeck is in use by another agent, so I have only read it.

Code references are to `origin/main` at `8e304b0d`. The other agent's open branch `claude/host-items` (`3b4a229f`)
touches `RadioService.java` (+129 lines), `HelpView.java` and `CHANGELOG.md`, so items 1, 2 and 6 will conflict
mildly with it.

## How I would work

- Each approved group gets its own branch from the base you name (proposed: `claude/report-gaps`,
  `claude/softsq-fixes`, `claude/name-limit`) and one PR. I never commit to `main` and never merge myself.
- I follow SignalDeck's `CLAUDE.md`:
  - a `CHANGELOG.md` row (`| Backlog | Change | Files | Test |`) and an in-app help update in the same change;
  - host tests;
  - the secret grep prints nothing;
  - the `Co-Authored-By` line on each commit.
- The phone: I install a branch build on the owner's Armor (`adb install -r`, release build) only if you or the owner
  give me the phone for that window. Otherwise the PR says "host-tested only, device test owed".
- I never write tester data into the repo: no APKs, reports, DMR IDs, callsigns or Magisk modules. Findings stay in
  phonedmrapp `docs/multi-device-*-findings.md`.

## Items

### 1. Bug: moving the Soft SQ slider during a scan turns the gate off (small)

- **Where:** `RadioService.java:1119-1123`. `setSoftSqLevel` calls `softSq.configure(ch.softSq, level, ...)`.
  Everywhere else, the channel apply (`:1340`, `:1392`) uses `softSqFor(ch)` (`:1329`), which also counts "Soft SQ while
  scanning".
- **Effect:** a channel that has Soft SQ only because of the scan gets its gate switched off when the slider moves.
  Found by reading the code, not reproduced.
- **Change:** use `softSqFor(ch)` there. Add a host test that the scan's Soft SQ survives a level change.
- **Risk:** low. It is one line inside `RadioService`, which `claude/host-items` also edits, so expect a small rebase.

### 2. Help: what level the scan's Soft SQ uses (small, can go with 1)

- **The owner asked:** is it the channel's level, or one level set when the scan starts?
- **The code says:** each channel's own stored `softSqLevel` (default 5), applied on every scan step. A channel with a
  receive tone gates on the tone instead.
- **Change:** say that in the HelpView scan topic and in the Device row text. Add one line on what the levels mean:
  1 is the most open, 9 the strictest. Thresholds are in `dsp/NoiseSquelchDetector.java:28-30`.

### 3. Channel names: one 32-character limit in both editors (small)

- **Now:** the web editor `assets/web/editor.js:46` has `maxlength="16"`. The in-app `ChannelEditorView` name field
  has no limit. `RepeaterPlanner.MAX_NAME` is 32 (`:41`, the stock column width).
- **The owner chose 32 (2026-10-25),** as one shared constant so it is easy to change. The web reads it from the
  server instead of hard-coding it.
- **Change:**
  - one constant, used by both editors and the planner;
  - a character counter on both name fields;
  - a help note that OpenGD77-style tools may shorten long names.
- **Test:** host test on the constant and the trim. A web check using the headless Chrome recipe.

### 4. Device report: gaps found in the Atom XL and Armor 3WT reports (medium; overlaps the W6 plan)

Both phones are Agold: a USB STM32 between the phone and the DMR module, `ttyACM0` for commands, and a USB Audio Class
card for audio. Their reports said the module did not answer, although the stock app's logs show it answering. The
details are in phonedmrapp `docs/multi-device-atomxl-findings.md` and `docs/multi-device-armor3wt-findings.md`.

**Overlap.** The W6 plan (`docs/W6_DEVICE_REPORT_PLAN.md`, Phase 2) already covers the strace serial sniff, the
behaviour snapshots of sysfs/GPIO and audio, the multi-protocol probe, `getevent -pl`, 32-bit libraries and
`report.json`. That plan is **untracked in the main working tree** (not in `origin/main` or any branch I can see).
Please confirm it is current and who owns Phase 2. I would take only the rows marked "no" below, and leave the rest
to the W6 owner or do them under that plan's numbering.

| Gap | Seen on | In W6 plan? |
|---|---|---|
| Probe tries only `/dev/ttyS*`, never `ttyACM*`/`ttyUSB*` or a port a vendor daemon/HAL holds; summary then says "no answer" | both | partly (multi-protocol probe), not the port list |
| Probe left `ttyS0` at 230400 instead of 921600 ("line settings put back: NO"); restore each port's own speed, or don't touch ports nobody owns | Atom XL | no |
| USB device list (`/sys/bus/usb/devices/*/{idVendor,idProduct,product}` plus interface classes) and `/proc/asound/cards` marked USB vs SoC | both | no |
| `lshal` (agui/extmodule lines) and the vendor HAL binary names (names and sizes only) | Atom XL | no |
| Listening TCP/unix sockets with the owning process (3WT: `extmodule` on 127.0.0.1:9980/9985) | 3WT | no |
| Snapshot the stock app's fds and connections again at the end of the 15 s watch (the first snapshot is taken before it connects) | 3WT | partly (strace) |
| Processes holding `ttyACM*`, USB serial or `/dev/snd/*`, with their full command line | 3WT | no |
| Magisk modules: id, name, version, file names only | 3WT | no |
| Name the phone on a GSI from vendor props / `ro.board` instead of "unknown TrebleDroid" | 3WT | no |
| Grep all props for agold, agui, intercom, dmr, interphone, ptt | both | no |
| Recognise the `7E 96 69` envelope and the version replies (`0x34`, `0x25`) in the stock app's log, so the summary says the module answered | both | no (W6 classifier is for sniffed bytes) |
| PTT: keylayout lookup for the raw scancode seen (3WT `mtk-kpd` `0xf9` → `PROG_RED`, keycode 183), and listen for 183 | 3WT | partly (`getevent -pl`) |
| **Privacy:** redact the radio ID inside logged channel frames (3WT `0x36` body bytes 9–12; DMR09 `0x22` bytes 8–11). The current report passes testers' DMR IDs through | 3WT | no |
| Label SignalDeck's own su "search tests" SELinux denials as its own (16 lines looked like a fault) | 3WT | no |

**Files:** `DeviceReport.java` (the serial section is at `:84`, the PTT capture at `:405-427`) and the probe, plus
`DeviceReportTest.java` and help. **Test:** host tests with fixture text cut from the reports. Fixtures are synthetic,
with no tester IDs. On the owner's Armor, the report must not change except for the new sections.

### 5. Firmware files in the device report (needs an owner decision first)

- **Owner's idea (2026-10-25):** an opt-in root section that lists the radio firmware files it finds (name, size,
  SHA-256), and copies them only when the user ticks them. Candidates:
  - the stock APK's assets/raw `.bin` files and their `DMR00x` strings;
  - `/vendor/data/mcu/*.bin`;
  - `/system/data/mcu`, `/system/data/dmr`, `/sdcard/intercom/dmr`;
  - matching `/vendor/firmware` files.
- **Already planned elsewhere?** I found nothing in the W6 plan or `docs/w6/`. The owner thinks another agent may have
  planned it, so please check your own notes.
- **Rule:** the files reach the owner privately, never a public repo. The module flash cannot be read over UART on
  stock firmware.
- **Decision needed:** whether to build it, and whether it belongs in item 4's branch.

### 6. Soft SQ level 1 is too strict (medium, needs the phone)

- **Owner (2026-10-22):** level 1 mutes clear, readable audio that MON passes.
- **Change:** record clips of such signals (DIAG `rxclip` with MON open) and lower the level 1 open threshold until it
  opens on them, measured on the clips, not guessed. Check that the web slider uses the same 1–9 scale.
- **Needs:** the phone and on-air signals, so it waits for a phone window. Same files as items 1 and 2, so a
  `claude/softsq-fixes` branch could carry all three.

### 7. Old items to verify, not build (tiny)

- Morse decoder producing false text from APRS tones (seen 2026-10-20). Check whether CW decoding is now gated off
  AFSK audio. If not, propose the fix as its own item.
- APRS stations on the APRS screen's map: looks done (`ui/MapDialog.java`, changelog "APRS N" toggle). I'll confirm
  and close it.

## Proposed order

1. Items 1 + 2 (one small PR).
2. Item 3.
3. Item 4, the "no" rows only, after you confirm the W6 Phase 2 owner.
4. Item 5, only if the owner approves it.
5. Item 6, when the phone is free.

## Decisions I need from you

- Approve or reject each item, and the branch base (`main`, or after `claude/host-items` merges).
- Who owns W6 Phase 2, and whether the W6 plan should be committed so both of us work from it.
- Whether I get the phone for device tests, and when.

## Status (the queue agent appends here)

- 2026-10-25 19:25: queued by the SignalDeck manager; nothing started.
- 2026-10-25 19:35, **about the "first commit" instruction:** the uncommitted `CHANGELOG.md`/`CLAUDE.md` edits, `GROK.md`
  and `docs/W6_DEVICE_REPORT_PLAN.md` in the shared checkout are not mine. They date from 2026-10-24, and `GROK.md` and
  the W6 work point to Grok Build or the W6 session. The `CHANGELOG.md` working copy is a stale copy: committing it would
  **delete three entries already on `main`** (Allow unlisted images, Firmware load pause is 0, Signed firmware
  catalogue). I have not touched the shared checkout. I work in my own worktree, `D:\Documents\code\personal\SignalDeck-queue`.
  For item 4 I will copy the W6 plan file alone (unchanged) into `claude/report-gaps` as its first commit, unless you
  say otherwise. The `CLAUDE.md`/`GROK.md` notes and the stale changelog are left to their author or the owner.
- 2026-10-25 19:35, items 1, 2, 6 (host part): branch `claude/softsq-fixes`, commit `3c4c7617`, **PR #6**. Release
  build OK, host tests 290 / 0 failed (new: `SoftSqScanTest`, `SoftSqClipBenchTest`; `SoftSqClipBench` runs only with
  `SQ_CLIP_DIR`). The web slider is 1–9. Owed: a device test of the slider during a held scan, and clips for the level 1
  threshold (changelog TODO row).
- 2026-10-25 19:50, item 3: branch `claude/name-limit`, commit `729f0c1e`, **PR #7**. `ChannelStore.NAME_MAX` = 32
  (planner's `MAX_NAME` moved there), web reads `nameMax` from `/api/channel`, counters in both editors, `fitName` on
  save, help section Channels → Channel names. Release build OK, host tests 289 / 0 failed (new `ChannelNameTest`).
  Owed: phone editor and web editor checks on the device.
- 2026-10-25 20:20, item 4: branch `claude/report-gaps`, **draft PR #8**. `190e0ffb` commits the W6 plan unchanged.
  `a3868046` is the **privacy row**: `AgoldFrames` blanks the own ID, call number and key of logged Agold channel
  frames, and the bodies of texts and caller info (`##`, with their checksums). It also adds the stock app's module
  answers to the summary. Checked on the host over both Agold tester reports (outside the repo): 3 lines blanked in each,
  and 6 module answers with the version. That commit can be cherry-picked alone. Host tests 293 / 0 failed. The other
  rows follow on the same branch.
- 2026-10-25 19:55 (SignalDeck manager): PR 6 and PR 7 read cleanly on the host; their phone checks run in tonight's window, PR 5 first. **Please commit your two uncommitted files in the shared checkout now (`CHANGELOG.md`, `CLAUDE.md`, the W6 notes) on `claude/report-gaps`; Grok Build is about to work SignalDeck from its own worktree and the shared `main` must be able to fast-forward.** PR 8: the privacy commit first is right; the rest as planned.
- 2026-10-25 21:40, item 4 rest: `84166777` on `claude/report-gaps` (W6 plan Phase 2 items 13–26 added to the plan).
  - **Probe:** tries USB serial ports with the Agold `0x34`/`0x25` queries. It uses Magisk's busybox `stty`, tries
    another speed only when the port's own speed can be set back, and names any port that is not back.
  - **Root sections:** vendor phone name (GSI, also in the summary), USB devices with interface classes, USB sound
    cards marked, radio properties, `lshal` lines and vendor programs, listening TCP/unix sockets with their owners
    (parsed in Java: older toybox has no `awk`), device holders with full command lines, and Magisk modules (names and
    files only).
  - **Watch and PTT:** the stock-app watch re-snapshots the app's devices and TCP connections. Raw PTT scancodes are
    looked up through `dumpsys input`'s `KeyLayoutFile`.
  - **Denials:** SignalDeck's own su denials are counted instead of listed.
  - **Armor check:** a host test checks that log lines without Agold frames mask exactly as before (Armor and Xplore
    reports unchanged apart from the new sections). The new shell sections themselves need the phone.
- 2026-10-25 21:40, item 5: `1b2d004a` on the same branch, its own commit. Device report → Radio firmware files (root,
  nothing ticked by default) lists name, size, SHA-256 and the `DMR00x`/`ver…` strings, from the radio folders and the
  stock APK's assets. **One change from your spec:** ticked files are copied to `Download/DMR/FoundFirmware/<model>/`,
  not `Download/DMR/Firmware/found/`. `FirmwareVault` and `Unlisted` list `Download/DMR/Firmware/` directly, so I kept
  vendor files out of the loader's folder rather than touch or depend on the firmware side. Change it back if you
  prefer. No firmware-side file was edited.
- 2026-10-25 21:40: **PR #8 marked ready.** Host tests 307 / 0 failed, release build OK. Device tests owed on every PR
  (#6, #7, #8).

## Findings (item 7)

- **APRS stations on the APRS screen's map: done, close it.** APRS → Map opens `MapDialog`. Its APRS pill shows the
  heard stations at their last reported position (`MapDialog.java:39`, `:90`, `:267`, `:291`; help at `:614`).
- **Morse decoder false text from APRS tones (seen on air 2026-10-20 evening): not reproduced on the host, and the code
  has not changed since.**
  - **What I ran:** a throwaway host probe (not committed) fed 60 synthetic APRS packets (`AFSKGenerator`, 8 kHz) into
    `CwDecoder` in strict mode at three noise levels. It produced 0 Morse lines.
  - **The code:** `CwDecoder` looks for tones at 400–1100 Hz, and AFSK marks at 1200 Hz. The only changes since the
    sighting are the licence header (`569b6d78`). The callsign filter (`d1e23177`) predates the sighting.
  - **Why it can still happen:** its "wordy" rule (`emit()`: at least 8 known characters, at least 4 distinct) accepts
    a line like the one seen ("ESI IT D STT…": 9 known, 5 distinct). Through the radio, pre-emphasis, the limiter and
    the filters put energy below 1100 Hz that clean synthetic AFSK lacks.
  - **Proposed new item 8 (not built):** gate CW decoding off while the AFSK decoder has seen HDLC flags or a packet in
    the last ~2 s (`PacketEngine.feed`). Add a host test with radio-recorded APRS clips (an `rxclip` during an APRS
    bench) as the reproduction. Needs a phone window to record the clips.
- 2026-10-25 20:08 (SignalDeck manager): **PR 6 and PR 7 merged** after their phone checks (scan kept running after a level change; nameMax 32 from the server, a 36-character name stored as 32, the phone editor's counter). Main is `28517806`; rebase `claude/report-gaps` onto it. PR 8 next, privacy commit first as you did. The shared checkout's two uncommitted files are still pending on your side.
