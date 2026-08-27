# 05 — Comparison with Claude’s deep dive

Claude’s series: `docs/deep-dive/00-README.md` and chapters 01–16 (15–16 uncommitted at this session). Written 2026-08-26, frozen at `14e484a2`, independently audited by a second agent.

This series: `docs/grok-deep-dive/`, 2026-08-27, live tree `ba6431cb` + uncommitted Claude docs. Claude’s files were not modified.

---

## 1. Scorecard

| Dimension | Claude | This series | Winner for that job |
|---|---|---|---|
| Serial protocol, message byte layouts, state machines | Exhaustive, code-cited, second-audited | Sampled only | **Claude** |
| OEM DB DDL, area files, SharedPreferences keys | Exhaustive | Sampled | **Claude** |
| Hook ↔ OEM cross-reference (ch. 14) | Mechanical inventory | Not repeated | **Claude** |
| DSP live vs dead class table | Complete (ch. 12) | Confirmed by grep | **Claude** |
| History / commit archaeology (ch. 13) | 356 commits, 107 scripts | Not repeated | **Claude** |
| Doc-drift vs `.grok/rules` | The point of the series | Treated as already applied on HEAD | **Claude** (then) |
| Live call sites that still implement the *old* meaning | Mentioned as drift, not always as bugs | Promoted to P0/P1 | **this series** |
| UI crowding, theme, accessibility, OEM editor UX | Almost absent (ch. 06 is an inventory) | Ch. 03 | **this series** |
| Security (exported debug RX, API key, serialization) | UART I/O noted as perf; not framed as security | P1.2–P1.5 | **this series** |
| Legal (LICENSE vs firmware-in-repo, GPL notice) | robot36 unacknowledged → fixed on HEAD | LICENSE disclaimer vs tree | **this series** |
| Product ranking (what to build) | `docs/BACKLOG.md` A–E | Ch. 06, OEM-capability first | complementary |
| APRS RX/TX redesign | Ch. 15 is the design | Agrees; insists on sample-layout dump first | **Claude 15** |
| Nearby Repeaters | Ch. 16 + research memos are the spec | Full review in [07](07-nearby-repeaters.md): sources/recipe **agree**; location `_id`, GROUP-RX copy, BM-first, dialog-vs-list **add** | **together** |
| Line-cite density | High (rots fast; they said so) | Symbol-first, fewer lines | different tools |

Claude built a **reference manual**. This series is a **product audit** that uses that manual and then reads the call sites it didn’t treat as defects.

---

## 2. What Claude got right (do not redo)

I re-checked the load-bearing claims in Claude `00-README.md` §3 and §4 against source. Confirmed, not re-derived:

- Frame structure, little-endian bodies, no inbound checksum, reader-thread death on `BufferUnderflowException`.
- `DigitalMessage` `localId` @8, `txContact` @140; no “24-bit target at bytes 5–7.”
- `CmdStateMachine` ack-by-cmd-byte; `syncChannelInfoWithData` **is** hardware write.
- RX PCM via `PrizeTinyService`; `AudioTrack` 8 kHz stereo 16-bit.
- `channel_band` = bandwidth; `encryptSw` 1/2; `interrupt` default 2; `txContact` = DMR ID.
- Module DBs in the OEM data dir.
- Importer wipe-and-insert; backups under `Download/DMR/DMR_Backups/`.
- Transcription = Google Cloud, not Whisper.
- VFO `localId` override in `BaseMessage.send()`, not `sendDigitalMessage`.
- `sq=0` force in `hookChannelNavigation`, not `hookDmrManager`.
- ~half the DSP classes dead; live SSTV is `com.example.dmrmodhooks.sstv`.
- APRS TX experiments fed mono into a stereo TX path (ch. 15) — the constraint in session-start is correctly downgraded to unresolved.

The second-agent audit table (Claude 00 §7) is credible: errors were cite drift, not invented APIs. I did not repeat that audit.

---

## 3. What Claude documented as “the notes are wrong” but left in the **code**

This is the methodological gap.

| Claude said | Live code still does | This series |
|---|---|---|
| `channel_band` is Narrow/Wide, not UHF/VHF | `determineBand()` + APRS `band=1 // VHF` + SSTV/NOAA comments treating `channelMode` as FM width | **P0.1** |
| `type` 0=digital 1=analog; `contactType` 0=person 1=group | `saveChannelData` comments and condition inverted on **both**; writes contact `_id` | **P0.2** (B7 understated) |
| Mode exclusivity “not enforced” | Three different stop-lists; APRS/VFO stop nothing | **P2.1** |
| No name-nesting guard | still none | **P2.1** |
| UART logger opens files per packet | still on, always, unbounded | **P1.3** + security |
| Geocoder on UI thread | `updateLocationDisplay` still; GPS POS already fixed | **P2.5** |
| `getCmdName` wrong | still wrong | **P3.1** |
| Pitfall 14 incomplete | still incomplete | **P2.2** |
| Pitfall 13 timer vs state machine | still a timer | **P2.3** |

Claude’s BACKLOG listed several of these as B-items. It did **not** list `determineBand()` as a radio-misprogramming bug. That is the one I would not have found from the BACKLOG alone.

---

## 4. What Claude missed (or under-weighted)

### Product / UX

- Six PTT satellites and a fake PKT RAD toggle (ch. 03).
- OEM talkback XML hardcoded ZH.
- Frequency editor in Hz; encrypt key digits 0–9 only.
- Channel list has no search.
- Use Assistant never mentions the overlay.
- `contentDescription` count = 0.
- LSPosed label v0.2.
- `CircuitBoardView` 20 fps always-on.
- Live dialogs `setCancelable(false)`.
- Location lookup by `mCurrentChannelIndex + 1` (P1.1) — not in BACKLOG.
- Channel-editor frequency help off by 10× (P0.3).
- Frequency Band help still says UHF/VHF (P0.4).
- `OemChannelTable` made channel I/O area-aware but left module DBs global — importing VHF wipes UHF extras (P1.7).
- VFO looks up a Soft SQ checkbox tag that was never created (P2.11).
- SSTV RMS gate after VIS; WAV always 16 kHz mono header; channel sprites wrap at 100.
- PDF still Pitfall 12; unquoted CSV commas; STT sends WAV bytes as LINEAR16; API-key placeholder strings don’t match.
- Information page empty gray box; APRS Xposed log every PCM chunk.

### Security / legal

- `RECEIVER_EXPORTED` debug packet (Radio Kill).
- Transcription service exported, key in Downloads and in the URL.
- `ObjectInputStream` of `/sdcard/*.dat`.
- LICENSE “we don’t redistribute OEM code” vs firmware + JADX in the same GitHub repo.
- GPL §5d: no interactive notice for robot36 (headers were added on HEAD; UI was not).

### OEM capability

Claude BACKLOG E1 is Radio Check. This series adds **TOT always 0** (the Settings row is a lie) and flags mix-check / `SET_SPK_EN` as probe-then-UI, not as a chapter in the serial doc that nobody will turn into a button.

### Repo

Claude 13 §9 noted hygiene. Under-weighted: 138 CPS zips as the largest git objects; `original-decompiled/smali` still tracked; gitignored keystore vs force-tracked `releases/*.apk`; `OpenGD77Fork/DMRModHooks-signed.apk` tflite-era leftover; root `settings.gradle` is the wrong project.

### Tests

Claude’s method was “read the code.” There is still no JUnit for the importer, CRC, or `OemChannelTable`. The audit batch on HEAD was authored without a toolchain (`CHANGELOG_DRAFT.md`).

---

## 5. What this series did *not* attempt (Claude remains canonical)

- Complete `Const` command table and checksum worked examples (01).
- All 25 outbound message layouts (02).
- `CmdStateMachine` / `TalkBackStateMachine` diagrams (03).
- Per-area DDL and `intercom_config.xml` (05).
- Every fragment view-id map (06).
- YModem / 14-patch campaign (07).
- Full 133-static-field dump (08).
- Per-mode backup key lists (09).
- 37-column CSV field map and CPS Path A/B/C (11).
- 44 DSP files live/dead with constants (12).
- 41 hook sites × 51 targets (14).

If you are hooking a new UART command, start at Claude 01–02, not here.

---

## 6. Drift of Claude’s freeze vs HEAD

| Claude freeze (`14e484a2`) | HEAD (`ba6431cb`) |
|---|---|
| Export hard-codes `default_uhf` | `OemChannelTable` (untested) |
| Soft SQ can mute DMR | analog-only gate |
| APRS WAV dump every 2 s | `DEBUG_SAVE_WAV = false` |
| Missing help-icon id | retargeted to `interphone_channel_call_name` |
| 41 MB tflite in APK | removed |
| robot36 unlicensed in-tree | GPLv3 headers |
| `.grok/rules` contradict the deep dive | rules patched from Claude §4 |
| Ch. 15–16 / BACKLOG | exist uncommitted (Claude, not this series) |

Claude 00 §8 says “these chapters describe commit `14e484a2`.” That sentence is already stale. This series does not patch it.

---

## 7. Audit of the audit

Claude 00 §7 reports ~1,300 claims checked, no fabricated APIs, errors = cite drift. I believe that for chapters 01–07 and 14.

Where the audit was weaker, from this pass:

- **It audited documentation against code, not code against radio behavior.** `determineBand` is consistent with *old docs* and inconsistent with *OEM editor + AnalogMessage*. A doc-correctness audit will not flag it.
- **Line maps for `MainHook` (ch. 08) are already a chapter of debt.** I used symbol names. Prefer that.
- **“Mode exclusivity is not enforced” was filed as a 09 open issue**, not as “APRS start will hijack an SSTV-named channel and double-wrap.” The failure mode is more specific than the note.
- **Ch. 06 inventories OEM screens but does not say they are bad.** Hz frequencies and numeric-only encryption keys are user-facing defects, not trivia.

None of that invalidates Claude’s series. It means a reference manual and a product audit are different documents. Keep both; don’t merge them.

Nearby Repeaters specifically: I had only skimmed ch. 16 during the first pass. After reading 16 + `_research-repeater-sources.md` + `_research-integration-surface.md` in full, the source matrix and OEM field recipe stand. What ch. 16 did not have to be is a product layer: the intercom location bug, area-global module DBs, GROUP vs ALL RX, 200-row `AlertDialog`s, and putting `rptrs.json` in Downloads. That is [07](07-nearby-repeaters.md).

---

## 8. Tone check

Claude’s series is careful, cited, and slightly defensive (“we audited twice because of outages”). This series is more willing to say “delete `determineBand`,” “the intercom looks like a debug overlay,” and “the LICENSE disclaimer is false as published.”

That is intentional. The radio already works. The next year of work is correctness of analog bandwidth, not another chapter on `ByteBuf` endianness.
