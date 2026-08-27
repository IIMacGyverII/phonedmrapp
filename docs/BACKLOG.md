# Backlog — what to work on next

Ranked, release-train view of open work. Sources: the verified deep dive (`docs/deep-dive/`), the 2026-08-26 bug batch (`CHANGELOG_DRAFT.md`), and the Grok product audit (`docs/grok-deep-dive/`, reconciled item-by-item in `docs/deep-dive/17-grok-review-response.md`). Update this file when an item ships or is dropped; keep the evidence pointers.

Legend — **Effort**: S < ½ day · M 1–2 days · L 3–5 days. **Device**: needs the radio. IDs are stable; older A/B/C/D/E ids are shown in parentheses where an item was renumbered.

---

## Gates — before anything else

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **G0** (A1) | **Build + regression-test HEAD** (`ba6431cb`) | Authored without a toolchain; nothing compiled. Five checks in `CHANGELOG_DRAFT.md`. | S | yes | `CHANGELOG_DRAFT.md` |
| **G1** (A2) | **Settle the RX sample layout** — dump one `writeAudioTrack` chunk, test `s[2k]==s[2k+1]` | Every decoder's tone math and the TX frame format depend on it | S | yes | `deep-dive/00-README.md` §5, `04-…` §6 |
| **G2** (A3) | Check logs for `run error---` (`TAG_AsyncPacketReader`) | OEM reader thread dies permanently on a fragmented frame; watchdog is cheap if it happens | S | yes | `deep-dive/01-…` §10 |

---

## v3.4.7 — Correctness (radio-wrong and data-loss bugs)

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **R1** | **Delete `determineBand()`**; set `band` (= analog **bandwidth**) explicitly: VFO gets a Narrow/Wide control (the unused `vfoBandWidth`), APRS wide, SSTV configurable (default narrow), NOAA wide. Stop writing `channelMode` on analog channels (not a wire field). | `determineBand` returns 1 for VHF / 0 for UHF into the bandwidth byte: 2 m analog VFO always wide, 70 cm always narrow | S–M | yes | `17-…` §1; `MainHook.java:16045`, `:6596`, `:8044`, `:15190`, `:15394` |
| **R2** (B7) | **Delete or rewrite the `saveChannelData` before-hook** with OEM enums (type 0 = DMR, contactType 1 = GROUP); never write a contact `_id` into `txContact` | Runs on analog+person channels and writes a row id into `txContact` (Pitfall 12 in reverse) | S | yes | `MainHook.java:14403-14464` |
| **R3** | Fix frequency help text: "Hz, no decimal — 446.000 MHz → 446000000" | Current text ("MHz × 100000 → 44600000") is 10× wrong | S | no | `MainHook.java:13716`, `:13756` |
| **R4** | Importer: strip `﻿`; if zero channels parsed → **roll back and report failure** | Pitfall 16 wipes the codeplug and reports success | S | no | `DirectDatabaseImporter` header parse; RadioID has the strip at `:636` |
| **R5** | **Locations keyed by channel `_id`** (migration + read side): `updateLocationDisplay` uses `currentChannel._id`, not `mCurrentChannelIndex + 1`; exporter/importer follow | Distance chip shows the wrong repeater under a zone filter or after deletes; prerequisite for Nearby Repeaters | S–M | no | `MainHook.java:3188-3192`; `deep-dive/16-…` rev. 2 |
| **R6** | **Diagnostics gate** (Device tab, default off): UART file logger, `com.dmrmod.SEND_DEBUG_PACKET` receiver (`RECEIVER_NOT_EXPORTED` + signature permission), APRS WAV dump, verbose decoder logging | Exported receiver lets any app send MCU commands incl. Radio Kill; logger opens two files per packet forever | S | no | `MainHook.java:11897-11898`, `:11579-11693` |
| **R7** | **Area-scope regression guard**: stamp `area_key` into each export folder (`meta.json`) and refuse/confirm import into a different selected area; log the area at export/import (C2) | `OemChannelTable` made channel I/O area-aware but zones/TG lists/locations/APRS flags are global → importing area B clears area A's extras. Full fix = H8. | S | no | `17-…` §1 (P1.7); `CHANGELOG_DRAFT.md` |
| **R8** | **Auto-backup before every import** into `DMR_Backups/auto_before_import_<ts>/`; summary says where it is | Makes wipe-and-insert recoverable | S | no | `17-…` §5 |
| **R9** | Manifest: remove `APRSSettingsActivity` (no class); `BackupActivity` `exported="false"` (or delete — it is unreachable) | `ActivityNotFoundException` landmine; exported light-theme orphan | S | no | `AndroidManifest.xml:41,48` |
| **R10** | **Import preview**: per-CSV row counts "before → after"; refuse when Channels would become 0 | Same failure class as R4/R8; CPS fork already previews, phone does not | S–M | no | `17-…` §5 |
| **R11** | `strings.xml` app label → real version (LSPosed Manager shows "v0.2"); READMEs' stale version strings | First thing a user sees | S | no | `deep-dive/13-…` §9 |
| **R12** (B2) | Pitfall 14 completeness: reset `isMonitoringMode`, soft-squelch flags, recording/transcription flags, zone state, `vfoLocalId` at launch; add the name-nesting guard | Zygisk keeps statics across OEM restarts | S | no | `deep-dive/08-…` §1.3, `09-…` §1.4 |
| **R13** (B1) | **Pitfall 13** — re-apply soft squelch on `dealEvent(0x23)` / `NoDealState` instead of a 300 ms timer | Root cause identified (ack matched by cmd byte); "touch the slider" workaround since v3.3.7 | M | yes | `deep-dive/03-…` §9–10 |

Suggested v3.4.7 changelog: *analog bandwidth is actually bandwidth; frequency help is in Hz; imports back up first and refuse to wipe; debug UART/injector are opt-in; module label shows the real version; locations follow the channel.*

---

## v3.5 — Usable radio (stability, security hygiene, UX)

### Stability / security

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **S1** | **MCU TOT**: hook `sendSetTotCmdToMdl` to send `pref_person_limit_send_time` instead of `0` | The limit is enforced only in app software today; the MCU value is the backstop if the app dies mid-PTT (release is a packet the app must send) | S | yes | `DmrManager.java:776-779`; `17-…` §2 |
| **S2** (P2.1) | One `enterMode(Mode)` / `leaveMode()` for APRS/SSTV/NOAA/VFO: always restore the previous hijack, strip prefixes, reset flags, save/restore squelch | Exclusivity is implemented three different ways; nested `"SSTV (SSTV (…))"` after crashes | M | yes | `deep-dive/09-…` §1.2, §1.4 |
| **S3** | Mode backups → JSON in the app-private dir (replace `ObjectInputStream` on `/sdcard/*.dat`) | Deserialisation surface + world-readable copy of the last channel (incl. encrypt key string) | S | no | `MainHook.java:6817-6837`, `:6949-6965` |
| **S4** | `DMRTranscriptionService`: signature permission on the AIDL; send the API key as `x-goog-api-key` header; stop the "Loading model…" toast | Exported service with no permission; key in URL is Google-sanctioned but a header is cleaner | S | no | `deep-dive/10-…` §3 |
| **S5** | Align the API-key placeholder strings (module writes `YOUR_GOOGLE_CLOUD_API_KEY_HERE`, service only recognises `YOUR_API_KEY_HERE`) | `isReady()` true → HTTP 400 on first use | S | no | `deep-dive/10-…` §7 |
| **S6** | Guard `getCurrentChannel()` callers when the channel list is empty (post-failed-import); offer the R8 auto-backup | `channels.get(0)` throws on an empty area | S | no | `deep-dive/03-…` §10.9 |
| **S7** | **Diagnostics section** on the Device tab as the single home for R6's toggles, the BER page (`visibility=gone` today) and the self-test output | One place, everything default-off | S | no | `17-…` §5 |
| **S8** (C1) | **Hook self-test at startup**: resolve every `findClass` / `getIdentifier` / reflected member **and every manifest `<activity>`**; log + one toast for NOT FOUND | Two silent failures lived for months; would have caught `APRSSettingsActivity` | S | no | `deep-dive/14-…` |
| **S9** | `APRSPacketDecoder.isValid` only when a position actually parsed | Stations stored at 0,0 with a GPX pin in the Gulf of Guinea | S | no | `APRSPacketDecoder.java:112-119` |
| **S10** | VFO: use tag `DMR_SOFT_SQUELCH_TOGGLE` at `:15158`; SSTV stop clears `isSoftwareSquelchEnabled` like APRS/NOAA do | Flag and button desync; asymmetric teardown | S | no | `MainHook.java:15158`, `:6746-6785` |
| **S11** | `SSTVReceiver`: apply the RMS < 80 gate only before VIS lock | Quiet scan lines stall an image | S | yes | `SSTVReceiver.java:252` |
| **S12** | Channel-number display for ≥ 100 (third sprite or text fallback) | `number/10` ≥ 10 has no drawable; big codeplugs will hit it | S | no | `MainHook.java:3118-3119` |
| **S13** | `PDFExporter`: key contacts by `contact_number` (Pitfall 12), fix inverted type label | Support artefact people e-mail | S | no | `deep-dive/11-…` §6 |
| **S14** | Quote/escape CSV fields on export; unescape `""` on import | A comma in a name shifts every later column | S | no | `deep-dive/11-…` §10 |
| **S15** | Information page: remove the empty light-gray container (button is commented out) | Visible artefact | S | no | `MainHook.java:3739-3745` |
| **S16** | Move NOAA (and any remaining SSTV) DSP off the `readpcm` thread; **measure** RX stutter first | Budget is 64 ms/chunk | M | yes | `deep-dive/12-…` §7 |
| **S17** (B4) | `Geocoder` + Open-Elevation off the UI thread, cached (GPS-send already does this right) | Jank/ANR | S | no | `MainHook.java:3201`, `:3396` |
| **S18** (B5) | `activityHistory` under a lock / UI-thread only | Latent CME | S | no | `deep-dive/08-…` §12 |
| **S19** (B6) | One `USE_COMPOUND_KEY_ZONES` value | Exporter false / importer true | S | no | `deep-dive/11-…` §10 |
| **S20** (B8) | Fix `getCmdName` (22→34, 35→…); separate status-byte naming | UART text logs are wrong | S | no | `deep-dive/08-…` §10.2 |
| **S21** | Recording WAV header should reflect the real layout once G1 is settled; don't delete short bursts < 10 kB silently (make it a setting) | Players/STT inherit a wrong header | S | no | `deep-dive/10-…` §1 |

### UX

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **U1** | **Modes sheet**: collapse the six PTT satellites to Soft SQ (analog only) + one "Modes" control (APRS/SSTV/NOAA/VFO; REC/TXT/POS move into the sheet); PKT RAD stops being a self-unchecking toggle | The lower half of the intercom is chrome; keep the on-screen PTT untouched for hardware-PTT users | M | yes | `grok 03` §1, `MainHook.java:2529-2582` |
| **U2** | One colour class (navy / cyan accent / danger red); Device-tab buttons use it | ≥ 4 greens and 3 cyans as literals | S | no | `grok 03` §2 |
| **U3** | `contentDescription` on every injected control and the PTT | Zero today | S | no | grep |
| **U4** | Pause `CircuitBoardView` when not receiving / fragment hidden (5 fps idle) | 20 fps forever, even squelched | S | no | `CircuitBoardView.java:44-53` |
| **U5** | Encrypt key field: allow hex (`inputType=text`, `digits=0-9A-Fa-f`) | DMR keys are hex; OEM field is digits only | S | yes | `interphone_channel_activity.xml` |
| **U6** | **Editor fixes PR**: MHz display/entry on the two frequency fields, contact picker on Call Number writing `contact_number`, U5 — sharing the tone/frequency helpers Nearby Repeaters needs | Hz entry and raw IDs are how Pitfall 12 happens | M | yes | `grok 03` §3, `deep-dive/16-…` |
| **U7** | Channel list search + Analog / Digital / Zone chips | Bare `ListView`; 200 channels = linear hunt | M | yes | `grok 03` §3 |
| **U8** | Replace the intercom's Chinese XML default labels at `initView` time (or set the string resources) | Cold-start flash of `功率：` etc. | S | yes | `fragment_talkback_view.xml` |
| **U9** | (= S12) three-digit channel display | — | — | — | — |
| **U10** | Live APRS/SSTV/NOAA screens cancelable; persistent status chip on the intercom; **stop encoding mode state in the channel name** (chip/notification + S2) | `setCancelable(false)` owns the activity; name-wrapping is what confuses crash recovery and the list filter | M | yes | `deep-dive/09-…` §1.4 |
| **U11** | Rewrite Use Assistant with overlay facts (Soft SQ, zones, RadioID, backups, "never BOM a CSV", reboot after module update) | Six OEM sentences today | S | no | `grok 03` §3 |
| **U12** | Unify recordings (OEM `/sdcard/interphone/record` vs module `Download/DMR/Audio/`): one list, one player | Two piles | M | no | `deep-dive/04-…` §4, `10-…` §1 |

### OEM capabilities already on the wire

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **E1** | Radio Check / Call Alert / Remote Monitor (`0x28` fun 1–3) next to Kill/Revive, with confirmation copy | Firmware supports; OEM only exposes Kill/Revive | M | yes | `deep-dive/02-…` §3.4 |
| **E2** | Probe mix-check (`0x38`) and `SET_SPK_EN` (`0x3C`) via the Diagnostics injector **before** any UI | Builders exist; OEM never sends; MCU behaviour unknown | S | yes | `deep-dive/01-…` §5 |
| **E3** | RSSI calibration against a known level | `-(120 - raw/2)` dBm is a guess | S | yes | `deep-dive/02-…` §3.14 |

---

## v3.6 — On-air data (packet radio + Nearby Repeaters)

Design: `deep-dive/15-packet-radio-review.md` (+ addendum) and `16-repeater-directory-import.md` (+ rev. 2). Build order inside this train is in ch. 15 §5 and its addendum.

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **F0** | Test harness: pure-Java modem + JUnit vs WAV corpus with direwolf `atest` as oracle | Nothing DSP is measurable today | S–M | no | `15-…` §4 |
| **F1** | Streaming AFSK1200 + HDLC receiver at native rate (replaces 2 s batch, resampler, longest-gap) | Latency, one-packet-per-buffer, cold PLL | M | yes | `15-…` R1 |
| **F2** | javAPRSlib parsing (Mic-E, compressed, messages, objects, weather) | Most mobiles are Mic-E; all dropped today | S | yes | `15-…` R3 |
| **F3** | Passive decode on flagged analog channels (`channel_aprs.enabled` is stored, never read); APRS mode becomes optional UI | Removes the hijack from the APRS path | M | yes | `15-…` R4 |
| **F4** | APRS-IS RX-only iGate + phone position beacon | Real APRS presence regardless of RF TX | M | yes | `15-…` §3.2 |
| **F5** | KISS-over-TCP server (RX first) so APRSdroid/YAAC can use the radio as a TNC | Best product architecture; default off, localhost option | M | yes | `15-…` addendum |
| **F6** (E5) | **Stereo-frame AFSK TX experiment** (tone → packet → `AudioRecord.read` injection) | The 2026-03 "impossible" verdict used mono frames on a stereo path | S–M | yes + 2nd RX | `15-…` §1.2, §3.1 |
| **F7** | If F6 passes: RF beacon / RF messages; if it fails: DMR position SMS (`0x2C`) + optional Bluetooth KISS TNC | Either way a working "send position" | M | yes | `15-…` addendum |
| **F8** | NOAA **SAME** weather-alert decoder (162.400–162.550) on the same PCM tap | High civilian value; only needs G1 | M | yes | `15-…` addendum |
| **F9** | DTMF decode (then encode test — different spectrum from AFSK) | `DTMF.csv` is a placeholder today | M | yes | `15-…` addendum |
| **E7** | **Nearby Repeaters** phases 0–5 (with rev. 2 gates: R5 first, P0.6 on-air GROUP-RX test, area-scoped `installed`, private cache, BM-only on cellular) | Full spec exists | L | yes | `16-…` §7 + rev. 2 |

---

## Hygiene (interleave; never blocks the trains)

| # | Item | Why | Effort | Evidence |
|---|---|---|---|---|
| **H1** (D2) | `.gitignore` + untrack the ~57 loose `.wav`/`.txt`/`.db`/`.pdf` at `DMRModHooks/` root; stale `OpenGD77Fork/DMRModHooks-signed.apk` | Multi-MB logs and a personal codeplug are tracked | S | `deep-dive/13-…` §9 |
| **H2** | Keep one CPS zip in `OpenGD77Fork/` (newest); the other 137 are git history | Largest objects in the repo | M | `13-…` §6 |
| **H3** | Point `DMRModHooks/README.md` at the root README or delete it | Duplicate, stale | S | `13-…` §9 |
| **H4** (D1) | Dead-code prune after grep: ~20 DSP classes, `CSVExporter/Importer`, `BackupActivity`, speech hooks, `cpp/`, `AFSKDecoderPLL`, `DireWolfDecoder`; keep `AFSKGenerator` until F6 | ~5k misleading lines | M | `12-…` source table, `14-…` §1 |
| **H5** | JUnit: `OemChannelTable`, importer coercions, HDLC CRC, tone mapping, `band` semantics (146.94 FM → 1; 12.5 kHz source → 0) | Zero tests today | M | `17-…` §5 |
| **H6** | LICENSE honesty: state that decompiled OEM sources and firmware images are in-tree for research; keep GPLv3; add the interactive GPL notice for the robot36 port | `LICENSE:665-666` is false as published | S | `17-…` §1 |
| **H7** | **Behavioural sweep**: every module write into a `ChannelData` field vs the OEM editor's semantics; table into ch. 14 | The class of bug R1/R2 belong to | S | `17-…` §5 |
| **H8** | Area-scoped module tables: `area_key` column on zones, TG assignments, locations, APRS flags, history; migration defaults to the selected area | Completes R7 | M | `17-…` §1 |
| **H9** (D3) | Split `MainHook.java` — after R1/R2/S2 so broken helpers are not moved; ch. 08 source map is the cut list, ch. 14 the regression check | 16k lines in one class | L | `08-…` |
| **H10** (D4) | Keep `docs/deep-dive/` current: re-run the ch. 14 method after OEM-facing changes; delete drift rows from `00-README.md` §4 as `.grok/rules` are fixed | Line cites rot | S (recurring) | `00-README.md` §8 |

---

## FW — Firmware modding (parallel research track)

Full plan: `deep-dive/18-firmware-modding-plan.md`. The flash-and-test loop is safe and reversible (RAM-load via `DMRDEBUG.bin`, reverts on power-cycle); the hard part is *identifying* the setting, which the prior 14-patch campaign failed at because of a naive disassembler and an unverified base address. Does not block the app-side trains.

| # | Item | Effort | Device | Evidence |
|---|---|---|---|---|
| **FW0** | Re-import into Ghidra; determine the **true base address and core** by constraint-solving against the plaintext strings + pointer tables; validate with uC/OS-III signatures | M | no | `18-…` §5.1 |
| **FW1** | Protocol anchor: find checksum + `0x68/0x10` framing + the `cmd`-byte dispatch; map `0x22/0x23/0x2B/0x30/0x3B` handlers (replaces the useless `cmd_handler.c`) | M | no | `18-…` §5.2 |
| **FW2** | Dynamic ground truth via the (gated) debug-packet path: map each command byte's observable MCU effect | S | yes | `18-…` §5.4 |
| **FW3** | Easy win first (squelch clamp or a tone table): one-byte change → RAM-load → observe → power-cycle restore. Proves the loop. | M | yes | `18-…` §5.3 |
| **FW4** | Locate band/frequency-limit validation (**document only** unless the operator authorises TX-band changes for their own allocation — legal note §7) | M | no | `18-…` §7 |
| **FW5** | Group-call RX: anchor at the `0x2B` reporter, walk back to the RX-frame TG extraction; "constraint confirmed" is a valid outcome | L | yes | `18-…` §5.3 |
| **FW6** | Revive `PatchReloadHelper` as an opt-in firmware-dev control in Diagnostics; **stop bundling `PATCH14.bin`** (it does nothing); never auto-load a `DMRDEBUG.bin` | S | yes | `18-…` §6, R6/S7 |
| **FW7** | Only if a change is worth keeping: revisit permanent flash — **retry on `/dev/ttyS0`** (the port the update uses) after the `dmr009` GPIO knock, read-only first; the prior EACCES was on the unused `/dev/ttyS1` | L | yes | `18-…` §6/§10 |

---

## Not on the list (hard constraints — do not re-open without new evidence)

Hardware LED control · DMR group-call RX beyond the channel's own `txContact` (RX group list ignored; ALL/RECEIVE_ALL reports `0xFFFFFF`) · >32 TGs per channel · squelch levels 1/3–9 · on-device speech-to-text · Magisk/systemizer or a rebuilt OEM APK · a fifth channel-hijack mode · NDK Dire Wolf · an in-app CPS.

**Note (2026-08-27):** "permanent firmware flashing via UART" was on this list; it is now **FW7 (unproven, not blocked)** — the EACCES that closed it was a probe of `/dev/ttyS1`, but the working update uses `/dev/ttyS0` (`deep-dive/18-…` §6/§10). RAM-load firmware testing was never blocked and is safe today.
Evidence: `.grok/rules/00-session-start.md` §3, `deep-dive/07-…` §5, `deep-dive/13-…` §5, `grok-deep-dive/04` §G.

**APRS TX over the voice path** is **F6 (unresolved)**, not a constraint, until the stereo-frame experiment has been run (`deep-dive/15-…` §1.2).
