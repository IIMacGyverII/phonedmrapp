# SignalDeck work queue for Claude: handoff for approval (2026-10-25)

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
