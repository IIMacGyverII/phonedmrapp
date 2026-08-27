# 17 — Response to the Grok deep dive (`docs/grok-deep-dive/`)

**What this is.** On 2026-08-27 Grok 4.6 wrote an independent nine-file series (`docs/grok-deep-dive/00`–`08`) as a *product audit* on top of this reference series. This chapter records, claim by claim, what was re-verified against the source on 2026-08-27, where I agree, where the evidence says otherwise, and what changed in my documents as a result. Grok's files are untouched.

**Method.** Every *new* claim (not already in my chapters or `docs/BACKLOG.md`) was checked by opening the cited code. "Confirmed" means the code does what Grok says; "Not reproduced" means it does not in the current tree.

**Headline.** Grok's series is a good complement: it reads call sites for *behaviour*, not just for documentation drift, and it found real defects I had filed as notes or missed entirely — most importantly that `determineBand()` still programs **UHF/VHF into the analog bandwidth byte**, that the `saveChannelData` hook is inverted on *both* enums and writes a contact row-id into `txContact`, and that my own area-aware fix left the module side-tables global across areas (a regression I introduced). Four of its claims did not survive verification (§3). Everything accepted is now in `docs/BACKLOG.md` under release trains, and the design chapters 15/16 carry revision sections.

---

## 1. Confirmed — accepted into the backlog

| Grok | Claim | Verification (2026-08-27) | Backlog |
|---|---|---|---|
| 02 P0.1 | `determineBand()` returns 1 for VHF / 0 for UHF and is written into `ChannelData.band`, which the OEM treats as **bandwidth** (0 narrow / 1 wide) | `MainHook.java:16045-16056`; written at `:6596` (SSTV), `:8044` (NOAA), `:15190`, `:15394` (VFO); APRS hard-codes `band=1 // VHF` at `:5428`, `:5488`; analog `channelMode` written at `:5489`, `:6597`, `:8045` although `AnalogMessage` has no such field | **R1** (v3.4.7) |
| 02 P0.2 | `saveChannelData` before-hook: comments and condition inverted on both enums; runs on **analog + person** channels; writes contact `_id` into `txContact` | `MainHook.java:14403-14464`: `if (channelType != 1 \|\| contactType != 0) return;` (OEM: type 1 = ANALOG, contactType 0 = PERSON), then `cursor.getInt(0)` on `_id` → `setIntField(channelData, "txContact", contactId)`. My ch. 08 §9 understated this as "never runs for DMR group channels" | **R2** (v3.4.7) |
| 02 P0.3 | Channel-editor frequency help says "MHz × 100000 … 446.0000 MHz → 44600000" (10× wrong; OEM is Hz) | `MainHook.java:13716-13719`, `:13756-13759` | **R3** (v3.4.7) |
| 02 P1.1 | Intercom location lookup uses `mCurrentChannelIndex + 1`; storage keyed by `channel_number` | `MainHook.java:3188-3192`; I had noted the divergence in ch. 08 §12 but not filed it | **R5** (v3.4.7) |
| 02 P1.2 | Debug UART injector receiver is `RECEIVER_EXPORTED` — any app can send MCU commands incl. `0x28` fun 4 (Kill) | `MainHook.java:11897-11898` | **R6** (v3.4.7) |
| 02 P1.5 | Mode backups are Java-serialised `HashMap`s on `/sdcard` read back with `ObjectInputStream` | `MainHook.java:6817/6837`, `:6949/6965` | **S3** (v3.5) |
| 02 P1.7 | `OemChannelTable` made channel I/O area-aware but `dmrmod_zones/tglists/locations/aprs` remain one file for all areas → importing area B clears area A's extras; same integer keys collide | By construction of `ba6431cb`; `LocationDatabase` PK `channel_number`, zones/TG assignments keyed by `_id` with no area column | **R7** (v3.4.7) — regression I introduced; noted in `CHANGELOG_DRAFT.md` |
| 02 P1.8 | Channel importer never strips `﻿`; zero parsed rows still `setTransactionSuccessful()` → `return true` | No BOM handling in `DirectDatabaseImporter` (RadioID importer has it at `:636`); no `importCount == 0` check | **R4** (v3.4.7) |
| 02 P1.9 | `APRSPacketDecoder` sets `isValid = true` after `parsePositionReport` even if it returned early → stations stored at 0,0 | `APRSPacketDecoder.java:112-119` | **S9** (v3.5) |
| 02 P2.9 | Manifest declares `APRSSettingsActivity` (no class); `BackupActivity` is `exported="true"` | `AndroidManifest.xml:41,48`; no `APRSSettingsActivity.java` | **R9** (v3.4.7) |
| 02 P2.11 | `applyVFOChanges` looks up tag `DMR_SOFT_SQUELCH_CHECKBOX` (never created; the control is tagged `…_TOGGLE`) | `MainHook.java:15158` vs `:2128`; other VFO sites use the right tag | **S10** (v3.5) |
| 02 P2.12 | SSTV stop does not clear `isSoftwareSquelchEnabled`; APRS/NOAA stops do | clears at `:5599` (APRS stop), `:8129` (NOAA stop); none in `stopSSTVMonitoring` (`:6746-6785`) | **S10** |
| 02 P2.13 | `SSTVReceiver` drops chunks with RMS < 80 before the VIS-detected branch | `SSTVReceiver.java:252` precedes `:267` | **S11** |
| 02 P2.15 | Channel-number sprites are two digits (`number/10`, `number%10`) | `MainHook.java:3118-3119` — for ≥ 100 the tens sprite index is 10+, i.e. no drawable (not "00" as Grok says, but wrong either way) | **S12** |
| 02 P2.16 | PDF export keys contacts by `_id` and inverts the type label | ch. 11 §6 had verified `PDFExporter.java:593`, `:339`; I had not filed it | **S13** |
| 02 P2.17 | Exporter writes unquoted CSV; importer does not unescape `""` | ch. 11 §10 gotchas; now filed | **S14** |
| 02 P3.5 | `LICENSE:665-666` says the project "does NOT … include any proprietary code from Ulefone" while the tree ships JADX sources and firmware images | Confirmed text | **H6** |
| 02 P3.7 | Information page adds an empty `0xFFF5F5F5` container; the button inside is commented out | `MainHook.java:3739`, comment at `:3742-3745` | **S15** |
| 03 §1 | OEM intercom XML defaults are Simplified Chinese (`功率：` …) | `fragment_talkback_view.xml` | **U8** |
| 03 §4 | Zero `contentDescription` anywhere in the module | grep: 0 hits in `DMRModHooks/app/src/main` | **U3** |
| 03 §2 | `CircuitBoardView` reposts its animation every 50 ms unconditionally | `CircuitBoardView.java:44-53` (gated only by `layoutDone`) | **U4** |
| 03 §3 | Encrypt-key `EditText` is `digits=" 1234567890"`, `inputType=number`, `maxLength=8` — hex cannot be typed | `interphone_channel_activity.xml` (`interphone_channel_encryption_key_set`) | **U5** |
| 03 §1 | PKT RAD is a `ToggleButton` that un-checks itself in `onClick` and opens a menu | `MainHook.java:2529-2582` (`setChecked(false)` then `showPacketRadioMenu`) | **U1** |
| 07 §2 | Channel name max length is 32 (`interphone_channel_name_edit` `maxLength="32"`) | Confirmed — closes ch. 16 to-do P1.3 | ch. 16 rev. 2 |
| 07 §4.2 | OEM manifest carries `sharedUserId="android.uid.system"`, which is why network works without `INTERNET` in the app manifest; `dumpsys` must target `com.pri.prizeinterphone`, not the rebuilt id | `decompiled/AndroidManifest.xml:2`; my integration memo named the wrong package — fixed | ch. 16 rev. 2, memo fixed |
| 07 §3.2–3.8 | Nearby Repeaters landmines: area-scope the `installed`/extras rows, real list adapter not nested `LinearLayout`s, catalog in private cache (RadioID terms), BM-only on cellular, skip hearham DMR rows without TGs, stale/simplex cutoffs, channel-count confirm, 80-column zone CSV round-trip | All follow from facts in my own memos; accepted | ch. 16 rev. 2 |
| 08 | Additional modes worth planning: KISS-over-TCP, SAME weather alerts, DTMF decode, DMR position SMS, BrandMeister GPS-SMS research, FX.25, SSTV TX; explicit out-of-scope list | Consistent with ch. 15's architecture (modem + apps) | ch. 15 addendum, **F**-items |

## 2. Partially agree — accepted with a different severity or framing

| Grok | Claim | What the code says | Position |
|---|---|---|---|
| 02 P2.19 / 04 A2 | "TOT is always 0; the Settings row is a lie" | `DmrManager.sendSetTotCmdToMdl` does send `tot = 0` (`DmrManager.java:776-779`), but the "Limit send time" pref **is** enforced in software: `InterPhoneTalkBackFragment.java:685` reads it and the TalkBack state machine ends TX on the countdown (ch. 03 §3.4). | The setting works; what is missing is the **MCU-side backstop**. That backstop matters more than Grok says: if the app process dies mid-PTT, no `LaunchMessage(0)` is ever sent. Filed as **S1** (send the pref value as MCU TOT) with that rationale. |
| 02 P1.4 | API key "in the query string" is a security issue | `?key=` is Google's documented API-key transport; the request is HTTPS. The real issues are the world-readable key file and the exported service with no permission (already in ch. 10). | Keep **S4** (signature permission + move key to `x-goog-api-key` header as hygiene); severity P2, not P1. |
| 02 P1.3 | UART logger is a security problem (world-readable logs) | It is an always-on I/O cost (ch. 08 §12, backlog B3) whose logs contain channel programming and SMS text. | Accept the privacy angle; fold into the **Diagnostics switch** (**R6**) so logger, debug receiver, WAV dump and verbose APRS logging share one default-off gate. |
| 02 P2.7 | NOAA/SSTV DSP on the audio callback is "the most likely source of RX stutter" | Correct that `noaaReceiver.processAudio` runs on `readpcm` (ch. 12 §7); stutter is not measured. | Filed as **S16** with "measure first". |
| 05 §6 | "Claude's chapters describe `14e484a2` — already stale" | True; three commits landed. | Index now states the freeze commit and lists later commits (`ba6431cb`, this batch) in §8. |
| 05 §7 | The audit checked docs against code, not code against radio behaviour | Fair. That is why `determineBand` (consistent with the *old* notes) was not flagged as a defect. | Added a "behavioural" pass to the backlog's hygiene section (**H7**): grep every write into a `ChannelData` field and compare against the OEM editor's semantics. |
| 03 §6.1 | Collapse six PTT satellites to "Soft SQ + Modes" | Product taste, but the reasoning (PKT RAD fake toggle, 176 dp PTT + 6 × 52 dp buttons) holds. | **U1**, scheduled for v3.5, with the constraint that hardware-PTT users need the on-screen PTT untouched. |

## 3. Not reproduced — rejected with evidence

| Grok | Claim | Evidence | Position |
|---|---|---|---|
| 02 P0.4 | "The Frequency Band help still says UHF/VHF for the `channel_band` (bandwidth) row" | There are **two** help icons: `addIcon("interphone_channel_frequency_band", "Frequency Band", …UHF/VHF…)` (`MainHook.java:~13796`) targets the OEM's *frequency-band* row (a UV-module selector — one of the 49 resource ids ch. 14 confirmed), and `addIcon("interphone_channel_band", "Bandwidth", "Channel bandwidth (analog only) … Narrow (12.5 kHz) … Wide (25 kHz)")` (`:13879-13884`) targets the bandwidth row with correct text. | No defect. The remaining problem is P0.1 (the code), not the help. |
| 02 P2.10 | "`DigitalMessage` *does* carry a `band` byte at the end of the 163-byte body, so the constructor hook's `band = 1` may reach the MCU on DMR" | `DigitalMessage.java` has no `band` (or `interrupt`) field; the verified tail is `159 pwrSave · 160 volume · 161 mic · 162 relay` (ch. 02 §3.2). `band` is only in `AnalogMessage` (offset 8). | The type-blind constructor hook is a DB-cleanliness issue (digital rows get `band=1`), not a wire issue. **This re-check also exposed an error in my own `.grok/rules/packet-layouts.md`**, which listed "`relay, interrupt, volume, band`" for 159–162 — corrected. |
| 02 P2.18 | "Service sends WAV-wrapped bytes as `encoding: LINEAR16` — the header is decoded as audio" | `TranscriptionService.java:138-148` does base64 the WAV. Google Speech-to-Text accepts WAV containers: for WAV, `encoding`/`sampleRateHertz` are optional and, if given, must match the header — the header is parsed, not transcribed. | No defect. The placeholder mismatch (`YOUR_GOOGLE_CLOUD_API_KEY_HERE` vs `YOUR_API_KEY_HERE`, ch. 10) is real and stays filed (**S5**). |
| 02 P2.15 (detail) | "Channel 100 looks like 00" | `digitOne = number / 10` = 10 → there is no `interphone_talkback_num_10` drawable, so the tens digit is not updated rather than showing 0. | Defect stands (**S12**); the symptom description was wrong. |

## 4. What changed in my documents because of this review

| File | Change |
|---|---|
| `docs/BACKLOG.md` | Rewritten around Grok's release-train idea (v3.4.7 correctness → v3.5 usable radio → v3.6 on-air data) with every accepted item above plus my own additions in §5; original IDs kept where they existed |
| `docs/deep-dive/16-repeater-directory-import.md` | "Revision 2" section: location-by-`_id` prerequisite, `area_key` on `installed`/extras, real list adapter, private cache, BM-only on cellular, hearham-DMR rule, stale/simplex cutoffs, P0.6 on-air GROUP-RX gate, undo semantics table, 32-char names, correct `dumpsys` package |
| `docs/deep-dive/15-packet-radio-review.md` | Addendum listing the extra modes from Grok 08 with my gating (KISS TCP, SAME, DTMF, DMR position SMS, BM GPS-SMS research, FX.25, SSTV TX; out-of-scope table) |
| `docs/deep-dive/_research-integration-surface.md` | `dumpsys` package corrected to `com.pri.prizeinterphone`; location-save note now says the read side must move to `_id` first |
| `.grok/rules/packet-layouts.md` | `DigitalMessage` tail corrected (no `band`/`interrupt`; `pwrSave, volume, mic, relay`) |
| `.grok/rules/00-session-start.md` = `CLAUDE.md` | §3a: `determineBand()` warning; area-scope regression note; group-call RX row reworded to the precise claim |
| `CHANGELOG_DRAFT.md` | Regression note for the global module side-tables (R7) |
| `docs/deep-dive/00-README.md` | This chapter added; pointer to `docs/grok-deep-dive/`; freeze-commit note |

## 5. New work the review made visible (my additions, beyond Grok's list)

Reading Grok's findings against the OEM mechanics in ch. 03–05 suggests a few more things worth doing; they are in the backlog with these IDs.

| ID | Idea | Why it follows |
|---|---|---|
| **R8** | **Auto-backup before every import.** The importer wipes; the exporter already exists. Run `DirectDatabaseExporter` into `DMR_Backups/auto_before_import_<ts>/` before the first `delete`, and show "restored from …" in the summary. Turns Pitfall 16 from data loss into an undo. | Wipe-and-insert + BOM (P1.8) + no preview |
| **R10** | **Import preview.** Count rows per CSV and show "Contacts 12 → 40, Channels 33 → 0 ⚠" before touching the DB; refuse when Channels would go to 0. The CPS fork already has a diff preview; the phone side has none. | Same |
| **S1** | **MCU TOT as watchdog**, not just a setting: send the pref value; document that this also ends a stuck TX if the app dies. | Grok P2.19 + ch. 03 §3 (release is a packet the app must send) |
| **S6** | **`getCurrentChannel()` guard.** After a failed import the cache can be empty and `channels.get(0)` throws (ch. 03 §10.9); the module should refuse to run mode/VFO code on an empty list and offer the auto-backup. | R8 + ch. 03 |
| **S7** | **Diagnostics section on the Device tab** as the single home for: UART logger, debug packet receiver, APRS WAV dump, verbose decoder logs, BER page (`visibility=gone` today), hook self-test output. Default everything off. | Grok P1.2/P1.3/P3.8 + backlog C1 |
| **S8** | **Hook self-test also validates the manifest**: every `<activity>` must resolve to a class; every `getIdentifier` must resolve. Would have caught `APRSSettingsActivity` and `interphone_channel_contact`. | Grok P2.9 + ch. 14 |
| **U6** | **Contact picker + MHz + hex in the editor as one "editor fixes" PR**, sharing the `ToneConverter`/frequency helpers Nearby Repeaters needs — build them once. | Grok 03 §6.5–6.6 + ch. 16 |
| **U9** | **Three-digit channel display** (or text fallback ≥ 100) — imported codeplugs and Nearby Repeaters will push channel counts past 99. | P2.15 + ch. 16 §3.8 |
| **H7** | **Behavioural sweep**: for every `setIntField(channelData, "<field>", …)` / `setObjectField` in the module, compare the value's meaning with the OEM editor's (`InterPhoneChannelActivity.saveChannelData`) — the class of bug P0.1/P0.2 belong to. One afternoon; produces a table for ch. 14. | Grok 05 §7 |
| **H8** | **Migration for area-scoped module tables**: add `area_key` (default = selected area at migration time) to zones, TG assignments, locations, APRS flags, history; all queries filter by it. | R7 |

## 6. Where the two series should be read together

- Machine facts (bytes, DDL, class paths, hook targets): this series, ch. 01–14 (Grok 05 §2 agrees).
- Live-tree defects and product priorities: Grok 02/03/06, now merged into `docs/BACKLOG.md` with the corrections in §3 above.
- Nearby Repeaters: ch. 16 (spec) + Grok 07 (landmines) → ch. 16 rev. 2 is the union.
- Packet radio: ch. 15 (what shipped, what to change) + Grok 08 (what else to add) → ch. 15 addendum.
- When they still disagree on a machine fact, re-grep the code and update **this** series; Grok's files are a snapshot.
