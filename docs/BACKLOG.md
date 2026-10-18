# Backlog — what to work on next

Ranked, release-train view of open work. Sources: the verified deep dive (`docs/deep-dive/`), the 2026-08-26 bug batch (`CHANGELOG_DRAFT.md`), and the Grok product audit (`docs/grok-deep-dive/`, reconciled item-by-item in `docs/deep-dive/17-grok-review-response.md`). Update this file when an item ships or is dropped; keep the evidence pointers.

Legend — **Effort**: S < ½ day · M 1–2 days · L 3–5 days. **Device**: needs the radio. IDs are stable; older A/B/C/D/E ids are shown in parentheses where an item was renumbered.

---

## Gates — before anything else

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **G0** (A1) ◐ | **Build + regression-test HEAD** | **Built and installed 2026-10-14** (JDK 17, keystore recovered); hooks load, Device tab renders. Regression checks: (1) export verified 2026-10-14 for the selected `default_uhf` area (48 channels, exporter opened that DB; only one area is in use on the test phone); (2) import side-tables, (3) Soft SQ on digital, (4) APRS Soft SQ off, (5) Call Number help icon are **still to run by hand** — (5) needs the channel editor, which an unattended tap on a list row could confuse with a channel change. | S | yes | `CHANGELOG_DRAFT.md` |
| **G1** (A2) ✅ | **Settled 2026-10-14: 8 kHz stereo, L == R for 100 % of 30,720 pairs** (Device tab → 🔬 Probe RX audio layout). Follow-ups: decimate to 8 kHz mono in every consumer, fix recorder WAV header (S21), write the APRS TX experiment with stereo-duplicated frames. | S | yes | `grok-deep-dive/11-…` §16 |
| **G2** (A3) ✅ | Check logs for `run error---` (`TAG_AsyncPacketReader`) | **Done 2026-10-14**: `decode()` before-hook waits for the rest of a split `0x68` frame instead of throwing; `run()` after-hook restarts a dead reader while the port is open (≤ 5/min). Normal traffic verified on device; the wait path has not been seen firing yet | S | yes | `CHANGELOG_DRAFT.md` batch 6 |

---

## v3.4.7 — Correctness (radio-wrong and data-loss bugs)

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **R1** | **Delete `determineBand()`**; set `band` (= analog **bandwidth**) explicitly: VFO gets a Narrow/Wide control (the unused `vfoBandWidth`), APRS wide, SSTV configurable (default narrow), NOAA wide. Stop writing `channelMode` on analog channels (not a wire field).  **✅ done 2026-10-14** — `determineBand` deleted; SSTV narrow, NOAA wide, VFO `vfoBandWidth` (wide default) | `determineBand` returns 1 for VHF / 0 for UHF into the bandwidth byte: 2 m analog VFO always wide, 70 cm always narrow | S–M | yes | `17-…` §1; `MainHook.java:16045`, `:6596`, `:8044`, `:15190`, `:15394` |
| **R2** (B7) | **Delete or rewrite the `saveChannelData` before-hook** with OEM enums (type 0 = DMR, contactType 1 = GROUP); never write a contact `_id` into `txContact`  **✅ done 2026-10-14** — conversion block removed, hook only logs | Runs on analog+person channels and writes a row id into `txContact` (Pitfall 12 in reverse) | S | yes | `MainHook.java:14403-14464` |
| **R3** | Fix frequency help text: "Hz, no decimal — 446.000 MHz → 446000000"  **✅ done 2026-10-14** — Hz wording and examples | Current text ("MHz × 100000 → 44600000") is 10× wrong | S | no | `MainHook.java:13716`, `:13756` |
| **R4** | Importer: strip `﻿`; if zero channels parsed → **roll back and report failure**  **✅ done 2026-10-14** — BOM strip + zero-row rollback (code review) | Pitfall 16 wipes the codeplug and reports success | S | no | `DirectDatabaseImporter` header parse; RadioID has the strip at `:636` |
| **R5** ✅ | **Done 2026-10-15. Locations keyed by channel `_id`.** `updateLocationDisplay` resolves the displayed channel's `_id` from `fragment.channels.get(index)` (robust under zone filters) instead of `mCurrentChannelIndex + 1`; importer stages by inserted `_id`, exporter looks up by `_id`. `channel_locations` key column keeps its legacy name but holds `_id` (no cache migration; equal on this codeplug). Device-verified: injected a location for `_id` 49 and the intercom read it back. | Was: distance chip showed the wrong repeater under a zone filter. Unblocks Nearby Repeaters P1.0 | S–M | no | `MainHook.java` ~3537, importer/exporter |
| **R6** | **Diagnostics gate** (Device tab, default off): UART file logger, `com.dmrmod.SEND_DEBUG_PACKET` receiver (`RECEIVER_NOT_EXPORTED` + signature permission), APRS WAV dump, verbose decoder logging  **✅ done 2026-10-14** — Device-tab Diagnostics toggle gates the UART logger and the debug receiver (default OFF, device-verified); old logs pruned to 40 files | Exported receiver lets any app send MCU commands incl. Radio Kill; logger opens two files per packet forever | S | no | `MainHook.java:11897-11898`, `:11579-11693` |
| **R7** ✅ | **Area-scope regression guard**: stamp `area_key` into each export folder (`meta.json`) and refuse/confirm import into a different selected area; log the area at export/import (C2) | **Done 2026-10-14**: `meta.json` written (and zipped) on export, verified on device; import refuses a different area with a message naming both. Full fix = H8. | S | no | `CHANGELOG_DRAFT.md` batch 6 |
| **R8** | **Auto-backup before every import** into `DMR_Backups/auto_before_import_<ts>/`; summary says where it is  **✅ done 2026-10-14** — auto-backup via exportFromAppContext before import (code review) | Makes wipe-and-insert recoverable | S | no | `17-…` §5 |
| **R9** | Manifest: remove `APRSSettingsActivity` (no class); `BackupActivity` `exported="false"` (or delete — it is unreachable)  **✅ done 2026-10-14** — APRSSettingsActivity entry removed, BackupActivity unexported | `ActivityNotFoundException` landmine; exported light-theme orphan | S | no | `AndroidManifest.xml:41,48` |
| **R10** ✅ | **Import preview**: per-CSV row counts "before → after"; refuse when Channels would become 0 | **Done 2026-10-14**: confirm dialog shows backup rows per CSV, backup area, current channel count; empty Channels.csv is already refused by R4 and the preview says so | S–M | no | `CHANGELOG_DRAFT.md` batch 9 |
| **R11** | `strings.xml` app label → real version (LSPosed Manager shows "v0.2"); READMEs' stale version strings  **✅ done 2026-10-14** — label/description from `versionName` via `resValue` | First thing a user sees | S | no | `deep-dive/13-…` §9 |
| **R12** (B2) ◐ | Pitfall 14 completeness: reset `isMonitoringMode`, soft-squelch flags, recording/transcription flags, zone state, `vfoLocalId` at launch; add the name-nesting guard | **Flags, zone state, `vfoLocalId`, scanner reset 2026-10-14.** Still open: the channel-name nesting guard (S2/U10 territory) | S | no | `CHANGELOG_DRAFT.md` batches 1, 10 |
| **R13** (B1) | **Pitfall 13** — re-apply soft squelch on `dealEvent(0x23)` / `NoDealState` instead of a 300 ms timer  **✅ done 2026-10-14** — ack-driven re-apply added, timer kept as fallback | Root cause identified (ack matched by cmd byte); "touch the slider" workaround since v3.3.7 | M | yes | `deep-dive/03-…` §9–10 |

Suggested v3.4.7 changelog: *analog bandwidth is actually bandwidth; frequency help is in Hz; imports back up first and refuse to wipe; debug UART/injector are opt-in; module label shows the real version; locations follow the channel.*

---

## v3.5 — Usable radio (stability, security hygiene, UX)

### Stability / security

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **S1** | **MCU TOT**: hook `sendSetTotCmdToMdl` to send `pref_person_limit_send_time` instead of `0` | The limit is enforced only in app software today; the MCU value is the backstop if the app dies mid-PTT (release is a packet the app must send) | S | yes | `DmrManager.java:776-779`; `17-…` §2 |
| **S2** (P2.1) | One `enterMode(Mode)` / `leaveMode()` for APRS/SSTV/NOAA/VFO: always restore the previous hijack, strip prefixes, reset flags, save/restore squelch | Exclusivity is implemented three different ways; nested `"SSTV (SSTV (…))"` after crashes | M | yes | `deep-dive/09-…` §1.2, §1.4  **APRS done 2026-10-17** (hijack/restore hardware-only) |
| **S3** ✅ | Mode backups → JSON in the app-private dir (replace `ObjectInputStream` on `/sdcard/*.dat`) | **Done 2026-10-14**: `ModeBackupStore`; legacy `.dat` migrated once through a whitelisting reader, then deleted | S | no | `CHANGELOG_DRAFT.md` batch 11 |
| **S4** | `DMRTranscriptionService`: signature permission on the AIDL; send the API key as `x-goog-api-key` header; stop the "Loading model…" toast | Exported service with no permission; key in URL is Google-sanctioned but a header is cleaner | S | no | `deep-dive/10-…` §3 |
| **S5** | Align the API-key placeholder strings (module writes `YOUR_GOOGLE_CLOUD_API_KEY_HERE`, service only recognises `YOUR_API_KEY_HERE`)  **✅ done 2026-10-14** — service accepts both placeholders (compiled, not reinstalled: different debug signer on the phone) | `isReady()` true → HTTP 400 on first use | S | no | `deep-dive/10-…` §7 |
| **S6** | Guard `getCurrentChannel()` callers when the channel list is empty (post-failed-import); offer the R8 auto-backup | `channels.get(0)` throws on an empty area | S | no | `deep-dive/03-…` §10.9 |
| **S7** | **Diagnostics section** on the Device tab as the single home for R6's toggles, the BER page (`visibility=gone` today) and the self-test output  **✅ done 2026-10-14** — "Diagnostics" header groups readback / probe / gate on the Device tab | One place, everything default-off | S | no | `17-…` §5 |
| **S8** (C1) ◐ | **Hook self-test at startup**: resolve every `findClass` / `getIdentifier` / reflected member **and every manifest `<activity>`**; log + one toast for NOT FOUND | **Partly done 2026-10-14**: installer catch blocks counted, one log line + toast on failure. Still open: `getIdentifier` lookups and manifest activities are not enumerated | S | no | `CHANGELOG_DRAFT.md` batch 8 |
| **S9** | `APRSPacketDecoder.isValid` only when a position actually parsed  **✅ done 2026-10-14** — position must parse | Stations stored at 0,0 with a GPX pin in the Gulf of Guinea | S | no | `APRSPacketDecoder.java:112-119` |
| **S10** | VFO: use tag `DMR_SOFT_SQUELCH_TOGGLE` at `:15158`; SSTV stop clears `isSoftwareSquelchEnabled` like APRS/NOAA do  **✅ done 2026-10-14** — SSTV stop clears Soft SQ | Flag and button desync; asymmetric teardown | S | no | `MainHook.java:15158`, `:6746-6785` |
| **S11** | `SSTVReceiver`: apply the RMS < 80 gate only before VIS lock | Quiet scan lines stall an image | S | yes | `SSTVReceiver.java:252` |
| **S12** | Channel-number display for ≥ 100 (third sprite or text fallback)  **✅ done 2026-10-14** — last two digits for ≥ 100 | `number/10` ≥ 10 has no drawable; big codeplugs will hit it | S | no | `MainHook.java:3118-3119` |
| **S13** | `PDFExporter`: key contacts by `contact_number` (Pitfall 12), fix inverted type label  **✅ done 2026-10-14** — type label + `contact_number` key | Support artefact people e-mail | S | no | `deep-dive/11-…` §6 |
| **S14** ✅ | Quote/escape CSV fields on export; unescape `""` on import | **Done 2026-10-14** for channel and contact names (zones/TG lists already used `escapeCsvField`) | S | no | `CHANGELOG_DRAFT.md` batch 8 |
| **S15** | Information page: remove the empty light-gray container (button is commented out)  **✅ done 2026-10-14** — empty patch container no longer added | Visible artefact | S | no | `MainHook.java:3739-3745` |
| **S16** | Move NOAA (and any remaining SSTV) DSP off the `readpcm` thread; **measure** RX stutter first | Budget is 64 ms/chunk | M | yes | `deep-dive/12-…` §7 |
| **S17** (B4) | `Geocoder` + Open-Elevation off the UI thread, cached (GPS-send already does this right)  **✅ done 2026-10-14** — Geocoder + GPS lookup on a background thread, text posted to UI | Jank/ANR | S | no | `MainHook.java:3201`, `:3396` |
| **S18** (B5) | `activityHistory` under a lock / UI-thread only  **✅ done 2026-10-14** — `synchronized (activityHistory)` at all three sites | Latent CME | S | no | `deep-dive/08-…` §12 |
| **S19** (B6) | One `USE_COMPOUND_KEY_ZONES` value | Exporter false / importer true | S | no | `deep-dive/11-…` §10 |
| **S20** (B8) | Fix `getCmdName` (22→34, 35→…); separate status-byte naming  **✅ done 2026-10-14** — hex table + status names + working body interpreter (device-verified) | UART text logs are wrong | S | no | `deep-dive/08-…` §10.2 |
| **S21** | Recording WAV header should reflect the real layout once G1 is settled; don't delete short bursts < 10 kB silently (make it a setting)  **✅ done 2026-10-14** — 8 kHz mono WAV, decimated capture (device-verified) | Players/STT inherit a wrong header | S | no | `deep-dive/10-…` §1 |
| **S22** | `disableSoftwareSquelchOnCurrentChannel()` must restore the channel's own `sq`, not a hard-coded `2` | NOAA channel set to 5 reaches the MCU as 2 when Soft SQ is turned off (`grok-deep-dive/11-…` §17). Cosmetic: levels 1–9 behave alike on-air (§17.1) | S | yes | `MainHook.java:~4852` |

### UX

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **U1** | **Modes sheet**: collapse the six PTT satellites to Soft SQ (analog only) + one "Modes" control (APRS/SSTV/NOAA/VFO; REC/TXT/POS move into the sheet); PKT RAD stops being a self-unchecking toggle | The lower half of the intercom is chrome; keep the on-screen PTT untouched for hardware-PTT users | M | yes | `grok 03` §1, `MainHook.java:2529-2582` |
| **U2** | One colour class (navy / cyan accent / danger red); Device-tab buttons use it | ≥ 4 greens and 3 cyans as literals | S | no | `grok 03` §2 |
| **U3** | `contentDescription` on every injected control and the PTT  **✅ done 2026-10-14** — contentDescription on the 14 tagged injected controls | Zero today | S | no | grep |
| **U4** | Pause `CircuitBoardView` when not receiving / fragment hidden (5 fps idle)  **✅ done 2026-10-14** — 5 fps idle | 20 fps forever, even squelched | S | no | `CircuitBoardView.java:44-53` |
| **U5** ✅ | Encrypt key field: allow hex (`inputType=text`, `digits=0-9A-Fa-f`) | **Done 2026-10-14**. Note: the OEM sends the 8 ASCII bytes of the field, not a parsed number, and a shorter key shortens the frame body (OEM bug, not touched) | S | yes | `CHANGELOG_DRAFT.md` batch 8 |
| **U6** | **Editor fixes PR**: MHz display/entry on the two frequency fields, contact picker on Call Number writing `contact_number`, U5 — sharing the tone/frequency helpers Nearby Repeaters needs | Hz entry and raw IDs are how Pitfall 12 happens | M | yes | `grok 03` §3, `deep-dive/16-…` |
| **U7** ✅ | **Shipped 2026-10-17** — search box + ALL/FM/DMR chip + ZONE in one row above the list | Bare `ListView`; 200 channels = linear hunt | M | yes | `grok 03` §3 |
| **U8** | Replace the intercom's Chinese XML default labels at `initView` time (or set the string resources)  **✅ done 2026-10-14** — English defaults set in initView | Cold-start flash of `功率：` etc. | S | yes | `fragment_talkback_view.xml` |
| **U9** | (= S12) three-digit channel display | — | — | — | — |
| **U10** | Live APRS/SSTV/NOAA screens cancelable; persistent status chip on the intercom; **stop encoding mode state in the channel name** (chip/notification + S2) | `setCancelable(false)` owns the activity; name-wrapping is what confuses crash recovery and the list filter | M | yes | `deep-dive/09-…` §1.4 |
| **U11** ✅ | Rewrite Use Assistant with overlay facts (Soft SQ, zones, RadioID, backups, "never BOM a CSV", reboot after module update) | **Done 2026-10-14**: section 7 "DMR Mod features" appended to the OEM page (`MOD_HELP_TEXT`); update it when controls change | S | no | `CHANGELOG_DRAFT.md` batch 10 |
| **U12** | Unify recordings (OEM `/sdcard/interphone/record` vs module `Download/DMR/Audio/`): one list, one player | Two piles | M | no | `deep-dive/04-…` §4, `10-…` §1 |
| **U13** ✅ | **Channel scanner** (zone-aware, hold/hang, long-press nuisance skip, rejected-channel skip, persistent scan list) | **Done 2026-10-14** — `ChannelScanner` drives the OEM `updateChannelId()` path; scan list via long-press while idle (batch 9). Follow-ups: dwell is a constant 1.5 s (measured 0.9 s to RECEIVE_START after landing); no priority channel; scanning needs Soft SQ off | M | yes | `CHANGELOG_DRAFT.md` batches 6–9 |
| **R14** ◐ | **Editor guard for channels the radio refuses**: warn (or refuse to save) a digital channel with no TX contact; show the OEM "operation failed" reason | **Warning toast done 2026-10-14** (`txContact == 0` on a digital channel). Still open: the H7 sweep of every field the MCU validates; surfacing the OEM "operation failed" cause; fixing Ch 46–48 on the test codeplug (they need a TG) | S | yes | `CHANGELOG_DRAFT.md` batch 8 |
| **R15** ✅ | Zone-navigation hook: restore `mCurrentChannelIndex` when the preset step is NAK'd | **Done 2026-10-14**: `InterPhoneTalkBackFragment$2.errorEvent` hook undoes the preset (`zonePresetFrom`) and gives the scanner an immediate strike | S | yes | `CHANGELOG_DRAFT.md` batch 7 |
| **R16** ✅ | Zone navigation never wrapped at the zone's ends (`updateChannelId()` clamps) | **Done 2026-10-14** (code review): direction argument reversed for the two end steps | S | yes | `CHANGELOG_DRAFT.md` batch 7 |

### OEM capabilities already on the wire

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **E1** | Radio Check / Call Alert / Remote Monitor (`0x28` fun 1–3) next to Kill/Revive, with confirmation copy | Firmware supports; OEM only exposes Kill/Revive | M | yes | `deep-dive/02-…` §3.4 |
| **E2** | Probe mix-check (`0x38`) and `SET_SPK_EN` (`0x3C`) via the Diagnostics injector **before** any UI | Builders exist; OEM never sends; MCU behaviour unknown | S | yes | `deep-dive/01-…` §5 |
| **E3** | RSSI calibration against a known level | `-(120 - raw/2)` dBm is a guess. Data points 2026-10-14 (live S-meter): quiet VHF channel raw 31 → −105 "dBm" (noise floor), NOAA WX6 carrier −86 to −81 | S | yes | `deep-dive/02-…` §3.14 |
| **U14** ✅ | **Live S-meter** (idle RSSI polling, Device-tab toggle, default OFF) | **Done 2026-10-14** | S | yes | `CHANGELOG_DRAFT.md` batch 7 |

---

## v3.6 — On-air data (packet radio + Nearby Repeaters)

Design: `deep-dive/15-packet-radio-review.md` (+ addendum) and `16-repeater-directory-import.md` (+ rev. 2). Build order inside this train is in ch. 15 §5 and its addendum.

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **F0** | Test harness: pure-Java modem + JUnit vs WAV corpus with direwolf `atest` as oracle | Nothing DSP is measurable today | S–M | no | `15-…` §4 |
| **F1** | Streaming AFSK1200 + HDLC receiver at native rate (replaces 2 s batch, resampler, longest-gap) | Latency, one-packet-per-buffer, cold PLL | M | yes | `15-…` R1 |
| **F2** | ~~javAPRSlib parsing~~ → hand-rolled: Mic-E, compressed, messages, objects/items, status, NMEA, weather, third-party, H-bit path  **✅ done 2026-10-17** (`APRSPacketDecoder` rewrite + 19 host tests vs direwolf; message log + notifications). Auto-ack TX (APRS monitoring only, setting default on) also done 2026-10-17 | Most mobiles are Mic-E; all dropped before | S | yes | `15-…` R3 |
| **F3** | Passive decode on analog channels  **✅ done 2026-10-17** (APRS Settings: Off / flagged channels / all analog, default all; per-channel flag checkbox in the APRS dialog reads/writes `channel_aprs.enabled`). APRS monitoring mode remains for parking on 144.390 + auto-ack | Removes the hijack from the APRS path | M | yes | `15-…` R4 |
| **F4** | APRS-IS RX-only iGate + phone position beacon + IS messages for us  **✅ done 2026-10-17** (`AprsIsClient`, APRS Settings section; receive-only login verified on device, verified gating needs the passcode) | Real APRS presence regardless of RF TX | M | yes | `15-…` §3.2 |
| **F5** | KISS-over-TCP server (RX first) so APRSdroid/YAAC can use the radio as a TNC | Best product architecture; default off, localhost option | M | yes | `15-…` addendum |
| **F6** (E5) | **Stereo-frame AFSK TX experiment** (tone → packet → `AudioRecord.read` injection) | The 2026-03 "impossible" verdict used mono frames on a stereo path | S–M | yes + 2nd RX | `15-…` §1.2, §3.1 |
| **F7** | If F6 passes: RF beacon / RF messages; if it fails: DMR position SMS (`0x2C`) + optional Bluetooth KISS TNC | Either way a working "send position" | M | yes | `15-…` addendum |
| **F8** | NOAA **SAME** weather-alert decoder (162.400–162.550) on the same PCM tap  **✅ done 2026-10-17** (`SAMEDecoder`, PKT RAD → NOAA Weather Alerts) | High civilian value; only needs G1 | M | yes | `15-…` addendum |
| **F10** | Fill-in digipeater (WIDE1-1 → MYCALL*)  **✅ done 2026-10-17** (APRS Settings, default off; HackRF-verified) | Lets mobiles reach wide-area digis | S | yes | — |
| **F9** | DTMF decode  **✅ done 2026-10-17** (`DTMFDecoder`, PKT RAD → DTMF Decoder, Analog History entries; 7 host tests + HackRF). **TX done 2026-10-17** (keypad send, saved sequences, DTMF.csv export/import, HackRF-verified) | `DTMF.csv` now carries the saved sequences | M | yes | `15-…` addendum |
| **E7** | **Nearby Repeaters** phases 0–5. Re-scoped 2026-10-15 (`16-…` §10, rev. 3): DMR repeater = **one listen channel per slot** (RX list holds the slot's TGs, up to 32) + opt-in talk channels, not one-per-TG. **P1.0 (R5) done**; **Phase 0 core landed 2026-10-15** — `GeoUtil`/`RepeaterModels`/`HttpClient`/`BrandMeisterSource` with 18 host unit tests green (`./gradlew testDebugUnitTest`). **Phase 0 done 2026-10-15** (device-verified, live BM catalog): P0.1-P0.3 tested core, P0.4 button + distance-sorted dialog + 24 h private cache, P0.5 location permission confirmed (ACCESS_FINE_LOCATION SYSTEM_FIXED) + one-shot fresh GPS fix. **Phase 1 started 2026-10-15**: P1.2 talkgroup parsers + P1.4 pure `RepeaterPlanner` (one listen channel per slot + opt-in talk channels), 29 host tests green. **P1.4/P1.5 + undo done 2026-10-15** (device-verified, clean install→undo on a live repeater: 49→51 ch / 27→42 contacts → back to 49/27, 0 leftovers). **P1.6/P1.7/P3.3 done 2026-10-15** (device: confirm step; re-install replaces not duplicates; best-effort list refresh). **Phase 2 parsers done**: `RadioIdRepeaterSource` (P2.1), `HearhamSource` (P2.2), `RepeaterCatalog.merge` (P2.3) — 39 host tests. **P2.4(FM)/P2.5 done 2026-10-15** (device: hearham FM merged into the live list; FM install → analog channel with tones, undo clean). **P2.6 done 2026-10-15** (DMR/FM/In-range/Hide-stale chips; in-range default on hides untunable frequencies; install refuses out-of-range). **P2.7 attribution + P2.1/P2.4 RadioID done 2026-10-15** (on-air): RadioID fetched, merged (BM>RadioID>hearham) and **geocoded by city** for the user's region (Android Geocoder, cached, capped); nearby DMR list grew 3→7 with non-BM repeaters. **Phase 2 functionally complete** (3 sources, DMR+FM install both proven); plus a **manual talkgroup builder** for repeaters the directories list without talkgroups (pick from contacts or type, commit via the always-visible dialog button). Before release: courtesy emails to BrandMeister/RadioID/hearham + a real UA contact address (operator's call). Area-scoped `installed`, private cache, BM-only on cellular. | Full spec + rev. 3 | L | yes | `16-…` §7, §9, §10 |

---

## Candidates noted 2026-10-17 (after the live-captions / search work)

| # | Item | Notes |
|---|------|-------|
| **N1** (= E1) | Radio Check / Call Alert / Remote Monitor for DMR (`0x28` fun 1–3) next to Kill/Revive | Firmware supports; needs BTECH 6X2 on-air verification |
| **N2** | Favourites row on the intercom: one-tap switching to pinned channels | Uses `jumpToChannelNumber`; pins in prefs |
| **N3** | DMR SMS canned phrases (quick-send list in the Message tab) | |
| **N4** (= S22) | NOAA squelch: `disableSoftwareSquelchOnCurrentChannel()` must restore the channel's own `sq`, not a hard-coded 2 | |
| **N5** | Scan priority channel (checked every N steps while scanning) | `ChannelScanner` |
| **N6** | Caption keyword alerts: per-keyword actions (record / switch channel), regex option | Follows the 2026-10-17 feature |
| **N7** ✅ | Evaluate: standalone app instead of an LSPosed module (own UART + audio path) | **Feasible with root — proven 2026-10-17** (`docs/standalone-app-evaluation.md`, `-followup.md`): 4 sepolicy rules, UART + dmr009 power GPIO + PrizeTinyService audio all driven from a plain app |
| **N8** | **Multi-device standalone app**: RadioEngine (shared protocol) + per-device profile (control port, audio backend TinyService/UART-PCM, sysfs GPIOs, PTT broadcast) | Motivation: Blackview Xplore 1 user; its app uses the **same MCU protocol** (`docs/multi-device-xplore1-findings.md`). First milestone **done 2026-10-17**: `DMRStandalone/` spike tuned NOAA, got RECEIVE_START/RSSI and streamed RX audio with the OEM app disabled (`standalone-app-evaluation-followup.md` §6). TX (HackRF-verified), PTT, boot handshake, hardware PTT key done the same day. **Intercom page ported** (`ui/IntercomView`, drawn seven-segment digits, PTT key, satellites, panel) over a `RadioService`; 51 channels imported from the stock DB; NOAA received in the new app. Channels (list/search/editor), Contacts, Messages (DMR SMS), Device tab (take-over/hand-back, Magisk boot module, DMR ID, re-import), in-app Help, launcher icon, Soft SQ, REC, MON, scanner, zones all done 2026-10-17 (device-verified). TXT captions, VFO, boot persistence and the PKT suite (APRS passive/monitor/message/beacon/auto-ack/digipeater/KISS, DTMF, SAME) done and bench-verified the same day. SSTV RX/TX also done (Robot 36 decoded off the HackRF, Robot 8 BW TX decoded 120/120). Next: APRS-IS, Last heard, voice announcements, keyword alerts, OpenGD77 CSV backup/import, Nearby Repeaters |

## Analog squelch (Soft SQ) — follow-ups

Recent work (2026-10-15, all device-tested): Soft SQ busy-lockout bypass, own persisted level + on/off, RMS-only carrier gating, **software CTCSS tone squelch** (voice-robust ratio + adjacent-standard-tone rejection), and an **FM noise squelch** for non-tone channels (absolute 3.3–3.75 kHz noise, replaces the amplitude gate). See `CHANGELOG_DRAFT.md`.

| # | Item | Why | Effort | Device | Evidence |
|---|---|---|---|---|---|
| **SQ1** | **Re-tune the FM noise squelch** (operator flagged 2026-10-15: "much better," may need revisiting). The per-level `NoiseSquelchDetector.OPEN_THRESH` table, the EMA (0.5) and 250 ms window were calibrated from a handful of on-air captures on one radio; confirm across more signals/strengths/radios and adjust. Telemetry `nsqHigh=<value>` is logged. Consider a faster/asymmetric attack if the ~0.25–0.5 s open delay bothers. | Marginal headroom at 8 kHz — no clean noise band above voice, sibilants share the high band; works well now but thresholds/attack are first-pass | S | yes | `NoiseSquelchDetector`, `CHANGELOG_DRAFT.md` |
| **SQ2** | **Received-tone decoder display** (operator request): scan all 51 CTCSS tones (Goertzel bank) and show the detected tone in the channel panel; then **DCS decode** for the display. **Phase A (CTCSS display): DONE 2026-10-16** — `CtcssDecoderBank` over all 51 tones, caller-panel readout; on-air verified at 100.0/79.7/254.1 Hz (ratios 440–660). **Phase B (DCS display): NOT FEASIBLE from audio — abandoned 2026-10-16.** On-air captures of 023N/047N/114N/023I showed the sub-audible band at ~1.5% of voiceband with no 134-baud structure (negative bit-rate autocorrelation), while CTCSS tones pass the same path at huge amplitude. The OEM delivers only processed 8 kHz voice audio (via `PrizeTinyService`), which high-passes/distorts the DCS data below recoverable; steady tones survive via the Goertzel's narrowband gain, an arbitrary 23-bit stream does not. DCS channels are **already squelched by the MCU in hardware** — only the code *display* is missing, and the only possible route is a firmware/UART query (no known command; speculative). See [[dcs-decode-from-audio-infeasible]]. | — | — | `CtcssDecoderBank`, `ToneConverter` |
| **SQ3** | **Per-channel Soft SQ** (operator request 2026-10-15): two channel-editor controls — Soft SQ **on/off** and **level (1–9)** — stored per channel (`SoftSqDatabase`, keyed by channel `_id`, like `LocationDatabase`); **applied on channel load** (updateUI: set `isSoftwareSquelchEnabled`/`softwareSquelchThreshold`, enable/disable); **saved in export/import** (two new `Channels.csv` columns, backward-compatible default when absent). **OpenGD77 fork (`OpenGD77CPS-Mac`): DONE v2.0.44** — `SoftSQ`/`SoftSQLevel` round-trip via CSV-only static arrays (`ChannelForm.CsvSoftSQ`/`CsvSoftSQLevels`), parsed in `ImportFromCsvFile`, written by the exporter, **and editable** in the channel editor (checkbox + 1-9 dropdown in the Android group, wired into Load/Save + Ctrl+Z revert). | Soft SQ is global today; operator wants it remembered per channel so the right squelch/level is set on load | M | yes | `MainHook` editor hook + updateUI, `DirectDatabaseExporter/Importer`, `OpenGD77CPS-Mac/docs/CODEBASE_DEEP_DIVE.md` |

---

## Hygiene (interleave; never blocks the trains)

| # | Item | Why | Effort | Evidence |
|---|---|---|---|---|
| **H1** (D2) ◐ | `.gitignore` + untrack the ~57 loose `.wav`/`.txt`/`.db`/`.pdf` at `DMRModHooks/` root; stale `OpenGD77Fork/DMRModHooks-signed.apk` | **Logs, DBs, CSVs, PDF and the APK untracked 2026-10-14.** The 24 `.wav` captures are kept on purpose until F0 decides whether they become `testdata/` or go | S | `CHANGELOG_DRAFT.md` hygiene |
| **H2** | Keep one CPS zip in `OpenGD77Fork/` (newest); the other 137 are git history | Largest objects in the repo | M | `13-…` §6 |
| **H3** ✅ | Point `DMRModHooks/README.md` at the root README or delete it | **Done 2026-10-14**: pointer README with build notes and a file map | S | `CHANGELOG_DRAFT.md` hygiene |
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
| **FW3** ◐ | Easy win first: one-byte change → RAM-load → observe → power-cycle restore. **Target found 2026-10-14: CTCSS tone table at `+0x366B2`** (50 × LE16 centihertz; `scripts/fw1_ctcss_table.py`, `grok-deep-dive/11-…` §18). Edit one tone, confirm the decode shifts, power-cycle restore. Needs a device + a tone source. | M | yes | `grok-deep-dive/11-…` §18 |
| **FW4** | Locate band/frequency-limit validation (**document only** unless the operator authorises TX-band changes for their own allocation — legal note §7) | M | no | `18-…` §7 |
| **FW5** | ~~Group-call RX firmware patch~~ **Dropped 2026-10-15**: group RX works through the RX list (on-air §19 + static read §20, `grok-deep-dive/11-…`); the listing shows the 32-entry list lookup, the `bmaski 24` all-call sentinel and the `0x2B` reply builder, all matching the on-air result. 32-slot ceiling is in the copy loop; not worth firmware surgery | — | — | `grok-deep-dive/11-…` §19/§20 |
| **FW6** ◐ | Revive `PatchReloadHelper` as an opt-in firmware-dev control in Diagnostics; ~~stop bundling `PATCH14.bin`~~ (**removed from assets 2026-10-14**, −378 KB APK); never auto-load a `DMRDEBUG.bin` | S | yes | `18-…` §6, R6/S7 |
| **FW7** | Only if a change is worth keeping: revisit permanent flash — **retry on `/dev/ttyS0`** (the port the update uses) after the `dmr009` GPIO knock, read-only first; the prior EACCES was on the unused `/dev/ttyS1` | L | yes | `18-…` §6/§10 |

---

## Not on the list (hard constraints — do not re-open without new evidence)

Hardware LED control · DMR group-call RX beyond the 32-slot RX group list (**the list is the filter**, on-air 2026-10-15; ALL/RECEIVE_ALL still reports `0xFFFFFF`) · >32 TGs per channel · squelch levels 1/3–9 · on-device speech-to-text · Magisk/systemizer or a rebuilt OEM APK · a fifth channel-hijack mode · NDK Dire Wolf · an in-app CPS.

**Note (2026-08-27):** "permanent firmware flashing via UART" was on this list; it is now **FW7 (unproven, not blocked)** — the EACCES that closed it was a probe of `/dev/ttyS1`, but the working update uses `/dev/ttyS0` (`deep-dive/18-…` §6/§10). RAM-load firmware testing was never blocked and is safe today.
Evidence: `.grok/rules/00-session-start.md` §3, `deep-dive/07-…` §5, `deep-dive/13-…` §5, `grok-deep-dive/04` §G.

**APRS TX over the voice path** — **F6 RESOLVED 2026-10-16: it WORKS.** The stereo-frame experiment (`deep-dive/15-…` §3.1) was run on-air with a HackRF: 8 kHz **stereo-duplicated** frames injected via an `AudioRecord.read` after-hook (riding the OEM PTT) TX'd 1200/2200 Hz tones at the correct frequencies, and direwolf decoded a full AFSK packet 3/3 with valid FCS. The old mono frames doubled every tone (1200→2400, 2200→3600) — the entire cause of the 2026-03 "impossible" result. This **unblocks** the APRS-TX side of F5 (KISS TX), the RF beacon, and APRS message TX. Next step is a real TX feature (frame builder + modem + PTT sequencing + UI), not another experiment. See [[aprs-tx-works-stereo-frames]].
