# 06 — Recommended work

Independent ranking as of the first pass. **Canonical execute list is now `docs/BACKLOG.md`** (Claude’s rewrite after reading this series). This file stays as the original grok ranking; deltas and retractions are in [09](09-claude-reconciliation.md). Do **not** duplicate IDs here — use BACKLOG R/S/U/F/H.

Do these in order. Features after row 1 are how you get a 3.4.7 that is not just “Claude’s audit compile.”

---

## 0. Gate: make HEAD real

| # | Item | Effort | Device | Why first |
|---|---|---|---|---|
| 0.1 | `cd DMRModHooks; .\gradlew assembleDebug` then `.\install.ps1` (reboot) | S | yes | `ba6431cb` never compiled. Area-aware export and analog-only squelch are unproven. |
| 0.2 | Five CHANGELOG regressions: export a non-UHF area; import then check locations/APRS/TG lists; Soft SQ analog → DMR RX still audible; APRS Soft SQ off passes audio; Call Number help icon | S | yes | If 0.1 is red, stop. |

---

## 1. Radio-wrong bugs (P0)

| # | Item | Effort | Device | Cite |
|---|---|---|---|---|
| 1.1 | **Replace `determineBand()`.** VFO gets an explicit Narrow/Wide (the unused `vfoBandWidth`). APRS: `band=1` (wide) on purpose. SSTV: default narrow, user toggle. NOAA: wide. Stop writing `channelMode` as FM width. | S–M | yes | `02` P0.1 |
| 1.2 | **Delete or rewrite `saveChannelData` before-hook.** OEM enums; never write contact `_id` into `txContact`. | S | yes | `02` P0.2 |
| 1.3 | **Fix frequency + band help text** (Hz, not ×100000; bandwidth, not UHF/VHF). | S | no | `02` P0.3, P0.4 |
| 1.4 | **BOM: strip `\uFEFF`; abort (don’t commit) if zero channels parsed.** | S | no | `02` P1.8 |

---

## 2. Stop shooting ourselves in the foot

| # | Item | Effort | Device |
|---|---|---|---|
| 2.1 | Gate UART logger + debug broadcast behind a Device-tab “Diagnostics” switch; `RECEIVER_NOT_EXPORTED`; default **off** | S | no |
| 2.2 | One `enterMode` / `leaveMode` (restore previous hijack, strip name prefixes, reset flags). APRS/SSTV/NOAA/VFO all call it | M | yes |
| 2.3 | Locations keyed by channel `_id`; `updateLocationDisplay` uses `currentChannel._id` not `index+1`. Stamp `areaKey` on module rows so VHF import does not wipe UHF extras | S–M | no |
| 2.4 | Geocoder + Open-Elevation off the UI thread; cache | S | no |
| 2.5 | `activityHistory` → synchronized deque or UI-thread only | S | no |
| 2.6 | Complete Pitfall 14 reset + name-nesting guard (falls out of 2.2) | S | no |
| 2.7 | Signature permission on `DMRTranscriptionService`; stop putting the API key in the query string | S | no |
| 2.8 | Hook self-test at startup (every `findClass` / resource id) | S | no |
| 2.9 | `strings.xml` / LSPosed label → actual version | S | no |
| 2.10 | Drop `APRSSettingsActivity` from the manifest; `exported=false` on `BackupActivity` | S | no |

---

## 3. Look like a radio app

| # | Item | Effort | Device |
|---|---|---|---|
| 3.1 | Collapse six PTT satellites → Soft SQ + Modes. PKT RAD is not a toggle | M | yes |
| 3.2 | One color class; Device-tab buttons use it | S | no |
| 3.3 | `contentDescription` on PTT and injected controls | S | no |
| 3.4 | Pause `CircuitBoardView` when idle / detached | S | no |
| 3.5 | Live screens cancelable; status chip on intercom; **stop wrapping channel names** | M | yes |
| 3.6 | Channel list search + Analog/Digital/Zone chips | M | yes |
| 3.7 | Editor: show MHz, hex encrypt key, contact picker writing `contact_number` | M | yes |
| 3.8 | Rewrite Use Assistant with overlay facts (Soft SQ, RadioID, backups, BOM, reboot) | S | no |

---

## 4. OEM capabilities that are already on the wire

| # | Item | Effort | Device |
|---|---|---|---|
| 4.1 | Radio Check / Call Alert / Remote Monitor next to Kill/Revive | M | yes |
| 4.2 | TOT: send the Settings value instead of `0` | S | yes |
| 4.3 | Probe mix-check / `SET_SPK_EN` with diagnostics (2.1) before any UI | S | yes |

---

## 5. Packet radio and Nearby Repeaters (after 0–2)

| # | Item | Effort | Device |
|---|---|---|---|
| 5.1 | Dump one `writeAudioTrack` chunk → 8 kHz stereo vs 16 kHz mono (**G1**, [08](08-packet-radio-modes.md)) | S | yes |
| 5.2 | Streaming AFSK + HDLC + JUnit harness (**F1/G2**) | M | no then yes |
| 5.3 | javAPRSlib Mic-E/messages (**A1**); passive decode (**A2**) | M | yes |
| 5.4 | APRS-IS RX iGate + phone beacon (**C1/C2**) | M | yes |
| 5.5 | KISS-over-TCP (**A4**); then stereo TX experiment (**G3**) | M | yes + 2nd RX |
| 5.6 | If G3 pass: RF beacon (**B1**). If fail: DMR position SMS (**D1**). Then SAME (**E1**), DTMF (**E2**) | M–L | yes |
| 5.7 | Nearby Repeaters — Claude 16 + grok [07](07-nearby-repeaters.md). Phase 0 BM list; **P0.6 on-air GROUP RX**; **fix location `_id` before any write**; Phase 1 BM install; RepeaterBook Phase 4 only | L | yes |

5.3–5.6 are wasted if 5.1 says the demod is running at the wrong rate.

---

## 6. Hygiene (can interleave; never blocks 0–1)

| # | Item | Effort |
|---|---|---|
| 6.1 | `.gitignore` `*.wav` `*.db` `*.txt` logcats under `DMRModHooks/`; untrack the pile | S |
| 6.2 | Keep **one** CPS zip in `OpenGD77Fork/` (newest timestamp); rest are git history | M |
| 6.3 | Point `DMRModHooks/README.md` at root README or delete it | S |
| 6.4 | Delete or quarantine dead DSP / speech hooks / `CSVExporter` after grep confirms zero callers | M |
| 6.5 | JUnit: `OemChannelTable`, importer coercions (relay 0→2, timeslot, txContact), HDLC CRC, `determineBand` replacement | M |
| 6.6 | Honest LICENSE note: decompiled OEM + firmware are in-tree for research; SSTV is GPLv3 robot36 | S |

Do not gitignore `releases/*.apk` without a different distribution story. Do not commit `release.keystore` just because clones can’t sign — that’s a documented local secret.

---

## 7. Explicitly later / never

- Split `MainHook.java` (Claude D3) — do it **after** 1.1/1.2/2.2 so you aren’t moving broken helpers. Use Claude 08’s source map as the cut list; Claude 14 as the regression check.
- Firmware flashing, LED, group-call RX, >32 TGs, on-device STT.
- A fifth channel-hijack mode.
- In-app CPS.

---

## 8. Suggested 3.4.7 vs 3.5 vs 3.6

**v3.4.7** (correctness): 0.x + 1.x + 2.1 + 2.9 + 3.3. Changelog: “analog bandwidth is actually bandwidth; frequency help is in Hz; LSPosed no longer says v0.2; debug UART is opt-in; BOM import no longer reports success on an empty table.”

**v3.5** (usable radio): 2.2, 3.1, 3.5–3.7, 4.1, 4.2. Changelog: Modes sheet, MHz editor, Radio Check, TOT works.

**v3.6** (on-air data): 5.1–5.7. Changelog: real APRS parser / maybe TX / Nearby Repeaters.

Do not skip 3.4.7. The bandwidth bug is user-visible on every analog VFO QSY between 2 m and 70 cm.
