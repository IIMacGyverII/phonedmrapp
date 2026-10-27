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
- 2026-10-25 20:25 (SignalDeck manager): **(1)** You were right about the shared checkout: the uncommitted files were the W6 session's, not yours. I kept their content (six W6 changelog entries added without dropping the newer ones, the two CLAUDE.md sections) as SignalDeck main `5245a2f9`, cleaned the shared checkout and fast-forwarded it; nothing of yours was touched. **(2)** The `Download/DMR/FoundFirmware/<model>/` folder is approved; keeping vendor files out of the loader's folder is the better design. **(3)** Item 8 (gate CW decoding off while AFSK is active) is approved as a queued item: build the gate with a host test on the APRS vectors already in the repo; the radio-recorded clips come from a phone window later. **(4)** PR 8 is merged into my integration branch and building; its device check (Run all checks on the Armor, the report unchanged apart from the new sections, no port speed altered) runs in the next phone window, then it merges. Rebase onto main `5245a2f9` first if you push more to it.
- 2026-10-25 20:40 (SignalDeck manager): **PR 8 merged** after its device check (report generated, serial speed unchanged, the six new root sections present, privacy strings absent, no crash; the opt-in firmware-files list and the Armor probe are checked in a later phone window). Main now carries PR 4–8. Next for you: item 8 (the CW gate while AFSK is active) on a fresh branch from main; then the remaining queue items in the Plan order. Rebase before every PR.
- 2026-10-26 00:08 (SignalDeck manager): main now also carries PR 9 (M17 channel type), PR 10 (POCSAG page), PR 12 (receive self-calibration) and PR 11 (promiscuous receive, MON on FW26). Rebase anything in flight onto it. Still owed from PR 8 in a later window: the opt-in firmware-files list and the Armor probe.
- 2026-10-26 07:20 (SignalDeck manager): **PR 8's two remaining device checks passed** on the Armor (the opt-in Radio firmware files list, nothing copied; the Radio probe with the serial speed unchanged). **New queue item 9 (small):** `FirmwareFinder.FOLDERS` includes `/sdcard/DMR`, so the list shows SignalDeck's own serial captures from `/sdcard/DMR/uart_logs/` (47 entries here; `.bin` captures of the version reply are even marked "contains DMR003"). Skip the app's own output folders (`uart_logs`, `Audio`, `DeviceReport`, `Firmware`, `FoundFirmware`, packet logs) and, under `/sdcard/DMR`, list only files that look like a module image (a `.bin` of at least 100 kB with a version string). Host test: a fake tree with a capture file and an image file, only the image listed. Branch from main.
- 2026-10-26 (queue agent), item 8: branch `claude/cw-gate`, commit `ac8bc842`, **PR #15**, on main `0465553e`. A streaming HDLC flag detector (`pkt/AfskPresence`, four flags whole bytes apart within six bytes, on about 33 ms into a lead-in) and `pkt/CwGate` hold the Morse decoder off while flags were heard in the last 2 s of audio or a frame was decoded in the last 2 s; what the decoder had gathered when the hold starts is dropped unreported; a closed squelch ends the audio hold. `PacketEngine.feed`/`deliverFrames` wired, `CwDecoder.discard()`, help Packet radio → Morse, changelog row. Release build OK, host tests 358 / 0 failed (new `CwGateTest` on the three direwolf benchmark files in the repo: every window the packet decoder finds a frame in has the hold on; at most 100 ms of the first 20 s reaches the Morse decoder, which reports nothing even non-strict; no hold in ~25 min of noise, voice-like audio and Morse; a Morse ID before and after packets still decodes). **Owed on the device:** APRS heard on the Armor writes no Morse line, a repeater's Morse ID still decodes; the radio-recorded APRS clips as the reproduction (phone window). A Morse ID sent within 2 s of a packet is not decoded (in the help).
- 2026-10-26 (queue agent), item 9: branch `claude/fwfind-skip`, commit `0da6b86e`, **PR #16**, on main `0465553e`. In `/sdcard/DMR` the apps' own output folders are skipped (`uart_logs`, `Audio`, `DeviceReport`, `Firmware`, `FoundFirmware`, `APRS`, `DMR_Backups`, `SSTV`, `NOAA`, `Coverage`, `Transcription`, `RadioID`: the six you named plus the other folders the module and SignalDeck write there), and elsewhere in it only a `.bin` of at least 100 kB with a version string is listed. The folder scan goes through a small file-access interface so the host test runs on a fake tree; shell commands unchanged. Help (Device report, the list's intro) and changelog row. Release build OK, host tests 353 / 0 failed (`FirmwareFinderTest`: captures small and large, a recording, a small debug file, a big file without a version, a non-.bin and a module image under `/sdcard/DMR`, plus a radio-folder file: only the image and the radio-folder file listed). **Owed on the device:** the Armor's list no longer shows the `uart_logs` captures.
- 2026-10-26 (queue agent), new item from the owner (suggestion pasted in chat, 2026-10-26): talkgroups from contacts. Branch `claude/tg-picker`, commit `7cfcb721`, **PR #19**, on main `0465553e`. (1) Channel editor, DMR: *Call number from* toggles Typed number / Contacts; the Contacts row opens the group contacts (group call) or private contacts (private call) and fills the number. (2) Intercom: long-press on the CALL cell (tap does nothing) lists the programmed call first, then the group contacts; a pick transmits group calls to that talkgroup and adds it to the receive list written to the radio, without saving anything to the channel; amber *CALL · PICKED*; cleared by another channel or the VFO, kept when the same channel is rewritten; refused while transmitting. New `TalkgroupOverride`; `RadioService` edits: `applyChannelNow`'s `setDigital` arguments, the key-up voice-contact line in `ptt`, three new methods (no firmware-side method touched). Help (Intercom → Talkgroup, Channels → Editing, editor info buttons), changelog row. Release build OK, host tests 356 / 0 failed (new `TalkgroupOverrideTest`). Not in it: SignalDeck Web and Android Auto still show the programmed call; no picker in the web editor yet (a follow-up if wanted). **Owed on the device:** the editor toggle and lists; a pick heard on that talkgroup by a second radio, a call on it received, the pick gone after a channel change. The three open PRs (#15, #16, #19) each add a changelog section at the same place, so the second and third merge needs a trivial changelog resolution.
- 2026-10-26 (queue agent), three owner UI suggestions (pasted in chat). (1) Add a zone: Your own first; (2) channel editor, phone and web: receive frequency above send. Both on branch `claude/ui-order`, commit `04b5e134`, **PR #20**, on main `0465553e`; help (Zones and standard lists) and changelog row; release build OK, host tests 351 / 0 failed. **Owed on the device:** the sheet order and the editor field order on the phone and in the browser. (3) Intercom Soft SQ slider: the owner asked for an HTML rendering before any change (padding there is risky). Proposed: the gap from SCAN / ZONE 2 dp to 14 dp, and the slider row shown only while Soft SQ is on (hidden on DMR and M17); only the activity panel resizes, the talk key does not move. Mockup sent to the owner; **not built** until the owner approves.
- 2026-10-26 (queue agent), suggestion (3) approved by the owner from the mockup and built: branch `claude/softsq-row`, commit `2390b2ba`, **PR #21**, on main `0465553e`. Slider row 14 dp under SCAN / ZONE (was 2 dp), shown only while Soft SQ is on for an FM channel (hidden on DMR/M17); only the activity panel resizes. Help (Soft SQ → The slider), changelog row; release build OK, host tests 351 / 0 failed. **Owed on the device:** the gap, the slider following SOFT SQ, hidden on DMR, the talk key unmoved.
- 2026-10-26 17:10: **PR #22** (`claude/fwfind-known`, stacked on #16, same file; merge #16 first, then retarget #22 to `main`). Radio firmware files also searches `/vendor/data/DMR` (the Atom XL keeps its module image in `/vendor/data/DMR/dmr/`; the vendor partition is case-sensitive), and files whose SHA-256 SignalDeck already has (built-in images, signed catalogue rows) are marked already known with what they are. Host 356 / 0 failed. Device check owed: on the Armor with root, the stock asset shows "Already known: DMR003.UV4T.V022, the factory image for the Armor 26 Ultra", then Copy nothing.
- 2026-10-26 17:40: PR #22 updated (`claude/fwfind-known`). Correction: the Atom XL stock app reads `/vendor/data/dmr/` (lower case); the upper-case `DMR/dmr` came from the copy we were sent and its location on the phone is unknown, so both folders are searched as a precaution. Added: a report warning for files in `/sdcard/intercom/dmr/`, which the Atom XL and Armor 3WT stock apps load into the module by themselves when the name sorts after the module version. Host 357 / 0 failed. Device check unchanged.
- 2026-10-26 18:20: **PR #23** (`claude/fw-variant-notice`, from `main`, owner request). On a profiled phone, once SignalDeck owns the radio it checks the stock module version and the stock app's firmware file hash against the signed catalogue (at most one fetch a day); an unlisted variant is offered once for the AndroidRadio_Firmware_Project "Firmware variant seen" issue form, filled in, in the browser (the app sends nothing), and an amber line under the Device page's firmware line stays until the catalogue lists it. No `fw/*` or RadioService edit. Host 356 / 0 failed. Device check owed: the Armor (V022) shows no prompt and no line; an unlisted `fwStock` shows both once.
- 2026-10-26 18:45: PR #23 updated (owner chose option 2). When the stock firmware file is new to the catalogue too, Open GitHub first copies it (SHA-256 checked) to `Download/DMR/FoundFirmware/<model>/` with a SOURCES.txt and fills the issue's attachment box with where it is; the user attaches it by hand or not (the prompt says an attachment is public). The app never uploads it. Host 360 / 0 failed. Device check adds: the copy and its SOURCES.txt appear, then delete that test copy.
- 2026-10-26 21:50 (SignalDeck manager): **device checks on the Armor, integration build of PRs 15–23 on main `0465553e` (release, 378 host tests green), under a phone lease.** PR 16 PASS (Radio firmware files: 7 entries, no `uart_logs`; Copy nothing) → merged. PR 19 PASS (channel 4 editor shows the Call number from Contacts row; intercom long-press on CALL opens the talkgroup picker, a pick shows CALL · PICKED, the cell reverts on the channel change) → merged. PR 20 PASS (Add a zone shows YOUR OWN first; the editor shows Receive above Send) → merged. PR 21 PASS (the slider appears with the SOFT SQ satellite and goes with it) → merged. PR 22: not reproduced: the stock app's firmware asset is not in the list at all (the 7 entries are `/sdcard/DMR/PATCH14_BACKUP.bin`, which carries the tag line but is not the factory image, sha `fceb2a4f…`, and five `/vendor/firmware` MCU blobs), so no Already known line could show; the stock app is disabled while SignalDeck owns the radio, which may be why its APK asset is not found; retargeted to main after PR 16, left open for the author to look at the asset path with the stock app disabled. PR 23: the listed-phone half passes (no prompt at takeover, no amber line on the Device page); the unlisted-tag half not run tonight (needs the prefs edit); left open. PR 15: not run tonight (needs packet audio); left open. The phone carries Grok's build again (`99a338db…`).
