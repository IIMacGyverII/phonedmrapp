# Independent deep dive — PriInterPhone + DMRModHooks

**Author.** Grok 4.6, 2026-08-27.  
**Scope.** The live tree at HEAD (`ba6431cb` plus uncommitted docs). Shipped APK is still **v3.4.6** (`DMRModHooks/app/build.gradle` `versionName` / `versionCode 346`).  
**What this is not.** A rewrite of Claude’s verified architecture series in `docs/deep-dive/`. Those chapters remain the serial/audio/DB/hook reference. This series was written by reading the sources again, hunting product defects Claude’s series treated as “documented facts,” and scoring what to do next.

**Hard rule.** Claude’s files under `docs/deep-dive/` and `docs/BACKLOG.md` were **not edited**.

---

## 1. Verdict in one page

DMRModHooks is a working LSPosed overlay on a vendor radio app that cannot be rebuilt with a platform signature. That architectural bet is correct: hooks, not a forked APK.

What is *not* correct, after an independent pass:

1. **The module still teaches itself the wrong meaning of `ChannelData.band`.** Claude documented that `band` is analog bandwidth (0 = 12.5 kHz, 1 = 25 kHz). The live code still writes UHF/VHF into that field via `determineBand()`. Analog VFO on 2 m is forced wide; analog VFO on 70 cm is forced narrow. SSTV comments say “NFM 12.5 kHz” and then set `band = 1` because 144.5 MHz is VHF. The channel-editor help text is also off by **10×** on frequency (Hz vs “MHz × 100000”).
2. **Monitoring modes are a pile of channel-hijack dialogs, not a radio feature.** APRS/SSTV/NOAA steal the active channel, wrap the name, serialize a `HashMap` to `/sdcard/*.dat`, and put a non-cancelable dialog over the intercom. Exclusivity is implemented in three different ways (APRS: none; SSTV: stop APRS; NOAA: stop APRS+SSTV; VFO: none). A crash nests `"SSTV (SSTV (UHF))"`.
3. **The intercom is overcrowded and themed, not designed.** Six emoji ToggleButtons float around a 176 dp PTT. PKT RAD is a toggle that immediately unchecks itself to open a menu. Zero `contentDescription`. OEM talkback labels are hardcoded Simplified Chinese. LSPosed still advertises “v0.2”.
4. **Debug plumbing is left on in production.** Every UART packet opens two files on a new thread. An **exported** broadcast lets any app on the phone inject MCU commands, including Radio Kill (`0x28` fun 4).
5. **HEAD is an untested bug-fix batch.** `ba6431cb` (area-aware export, analog-only squelch, tflite removal, robot36 headers) has not been compiled or device-tested. Do not add features on top of it.

Claude’s series is strong on *how the OEM machine works*. It is weaker on *what a user actually hits*, *what the live code still gets wrong after the drift table was written*, and *what “looks better” means on a 6.8″ radio phone*. That is the gap this series fills.

---

## 2. Chapter map

| # | File | What it covers |
|---|---|---|
| 00 | this file | Method, verdict, comparison headline, how to use both series |
| [01](01-architecture-rechecked.md) | Architecture rechecked | What I independently confirmed; where I agree with Claude; live tree vs v3.4.6 |
| [02](02-bugs-and-defects.md) | Bugs and defects | Ranked, code-cited. **New** items first, then Claude-confirmed still live |
| [03](03-ui-and-ux.md) | UI / UX / look | Intercom crowding, theme tokens, OEM screens the overlay never fixed, accessibility |
| [04](04-features.md) | Features worth building | OEM-capability features first; decoder/product features second; do-not-touch list |
| [05](05-comparison-with-claude.md) | Comparison | What Claude got right, what drifted, what was missed, audit of the audit |
| [06](06-recommended-work.md) | Recommended work | Ranked plan that does not mutate `docs/BACKLOG.md` |
| [07](07-nearby-repeaters.md) | Nearby Repeaters | Full read of Claude 16 + source/integration memos; agree / disagree / missed landmines (location `_id`, GROUP RX, BM-first, no `determineBand`) |
| [08](08-packet-radio-modes.md) | Packet-radio modes | Every addable mode (AX.25 apps, KISS, APRS-IS, DMR SMS, SAME, DTMF, …) with a plan and to-do; plus explicit non-goals |
| [09](09-claude-reconciliation.md) | Reply to Claude 17 | Four retractions; adopt their backlog trains + R8/R10/S1/S6–S8/H7/H8; new items neither series had (squelch help, encryptKey 8 bytes, hijack export, Doze/iGate) |
| [10](10-firmware-modding.md) | MCU firmware | Blobs in-tree; RAM-load works; 14 patches failed on bad disasm/base; S0 vs S1 reopens permanence; §9 reply to Claude 18 |

---

## 3. Method

- Read session-start rules and Claude’s `docs/deep-dive/00-README.md` as a *map*, then ignored it while grepping.
- Treated `app/src/main/java/com/pri/prizeinterphone/` and `DMRModHooks/app/src/main/java/` as the sources of truth.
- Confirmed load-bearing facts at the symbol, not the line-cite: `ChannelData.ChannelType`, `AnalogMessage.encodeBody`, `PCMReceiveManager` AudioTrack constants, `Const.Command`, `EnhanceMessage.fun*`, `DmrManager.sendSetTotCmdToMdl`, `MainHook.determineBand`, `start*Monitoring`, `saveChannelData` before-hook, UART logger, debug broadcast.
- Did **not** re-derive the 163-byte `DigitalMessage` table or the YModem state machine. Claude’s ch. 01–07 already did that and the second-agent audit survived. I sampled, I did not rebuild.
- Did **not** run the radio. No device was used for this write-up. Claims about on-air behavior stay marked **unverified on device**.

---

## 4. Twenty facts I independently re-checked

Agree with Claude unless noted.

| # | Fact | Source |
|---|---|---|
| 1 | UART is `/dev/ttyS0` 57600; frame `68 cmd rw sr ck(BE) len(BE) body 10` | OEM `Packet` / `SerialPort` (sampled; full table in Claude 01) |
| 2 | Bodies little-endian; headers big-endian | `ByteBuf` / `AnalogMessage.encodeBody` |
| 3 | RX voice is **not** UART: `PrizeTinyService` → `PCMReceiveManager.writeAudioTrack` | `PCMReceiveManager.java:42-48, 64-67` |
| 4 | OEM `AudioTrack` = 8000 Hz, `CHANNEL_OUT_STEREO` (config `12`), 16-bit | `PCMReceiveManager.java:19-22, 64-67` |
| 5 | True L/R layout (duplicate stereo vs 16 kHz mono) is **still unverified** | same byte rate; no chunk dump in this session |
| 6 | `channel_band` in the editor is **Narrow/Wide**, not UHF/VHF | `InterPhoneChannelActivity.java:724-727` |
| 7 | `ChannelData.type` 0 = DIGITAL, 1 = ANALOG | `ChannelData.ChannelType` 73–76 |
| 8 | `contactType` 0 = PERSON, 1 = GROUP, 2 = ALL | `ChannelData.ChannelContactType` 53–56 |
| 9 | `channel_txContact` is a DMR ID, not a row `_id` | OEM `saveSelectedData` / Pitfall 12 — still true |
| 10 | `localId` lives on `DmrManager`, not `ChannelData` | `DmrManager.java:78, 297-306` |
| 11 | `syncChannelInfoWithData` **is** the hardware program path | `DmrManager` + `CmdStateMachine` |
| 12 | Firmware squelch only honors 0 and 2 | not re-proven; leave as constraint |
| 13 | Group-call RX / LED / >32 TGs / on-device STT: do not reopen | not re-proven; leave as constraint |
| 14 | APRS TX “impossible” verdict used **mono** `writeFrame`; OEM TX is stereo | Claude 15; generator is 8 kHz (`AFSKGenerator.java:27`) |
| 15 | Transcription is Google Cloud STT, key at `Download/DMR/api_key.txt` | `TranscriptionService.java:70-93` |
| 16 | Module DBs live in the OEM package data dir | process identity; `getDatabasePath` from hooked context |
| 17 | Importer is wipe-and-insert | `DirectDatabaseImporter` class javadoc + `delete` call sites |
| 18 | `OemChannelTable` exists on HEAD (area-aware export) — **untested** | `OemChannelTable.java`; `CHANGELOG_DRAFT.md` |
| 19 | Live SSTV demod is `com.example.dmrmodhooks.sstv` (robot36 port, GPLv3 header now present) | package + header |
| 20 | `MainHook.java` is 16,307 lines, one class, 22 `hook*` methods | grep `private void hook` |

**Disagree / extend Claude:** facts 6 and 7 were documented as *doc drift*. The **code that still implements the old meaning** (`determineBand`, monitoring-mode comments, `saveChannelData` type/contactType test) was not promoted to a defect with a fix. That is this series’ main technical contribution.

---

## 5. How to use both series

| Need | Use |
|---|---|
| Exact command byte, message offset, OEM DDL, hook↔OEM cross-ref | Claude `docs/deep-dive/01`–`14` |
| APRS RX/TX *assessment* of what shipped | Claude 15 |
| Packet-radio modes to *add* (plans + to-dos) | **this series [08](08-packet-radio-modes.md)** |
| Nearby Repeaters | Claude 16 + this series [07](07-nearby-repeaters.md) |
| “Is this a bug in the live tree?” | this series [02](02-bugs-and-defects.md) + [09](09-claude-reconciliation.md) (four strikes) |
| Ranked work to execute | **`docs/BACKLOG.md`** (Claude’s rewrite; grok agrees — see [09](09-claude-reconciliation.md)) |
| MCU firmware / RAM-load / flash | Claude 07 + 18; grok [10](10-firmware-modding.md) |
| Day-to-day agent rules | `.grok/rules/00-session-start.md` (and its CLAUDE.md mirror) |
| Version number | `DMRModHooks/app/build.gradle` only |

When this series and Claude disagree on a *machine fact* (packet layout, class path), re-grep the code. When they disagree on a *priority*, this series is the product view.

---

## 6. What I did not do

- Did not flash, decode on-air, or run `install.ps1`.
- Did not re-audit every `file:line` in Claude 01–14. Sampled the load-bearing ones.
- Did not implement fixes. This is analysis only.
- Did not bump a version or open a GitHub release.
