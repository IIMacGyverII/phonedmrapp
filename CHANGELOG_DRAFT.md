# Changelog draft — unreleased (working towards v3.4.7)

Running log of changes since v3.4.6, per the feature-log convention in `.grok/rules/copilot-instructions.md`.
Not yet built or device-tested (no JDK/SDK on the authoring machine — see "Testing Notes").

## 2026-10-15 — Nearby Repeaters: manual talkgroups when a repeater lists none

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7** | Many directory repeaters carry no talkgroups (6,802 of 11,495 RadioID rows, and the N0YNT/Saint Paul the user hit is one). Previously such a repeater was a dead end. Now the install dialog shows a **manual talkgroup builder**: pick a timeslot, tick talkgroups from your saved contacts, and/or type a talkgroup number, then the dialog's own button (relabeled **Use these**, always visible) commits them and hands off to the normal transmit-selection + install flow. | `NearbyRepeatersUi` (`buildManualTgUi`, `loadAllContacts`, commit via the dialog button), message wording | **device**: builder renders (TS1/TS2, number field + Add, contacts checkboxes); captured "Chosen: TG 3127 TS1, TG 3169 TS2" from a ticked contact + typed number; codeplug left clean (49 ch). The commit→install path reuses the DMR install already proven on-air (KA0KMJ) |

Also fixed: the "no talkgroups" message no longer says "on BrandMeister" (the repeater may be from RadioID), and the install dialog uses a repeater's own talkgroups and only queries BrandMeister when a BM device has none.

Note on why N0YNT showed no IDs: it has three separate RadioID listings; the Oakdale one (443.425) carries 6 talkgroups, but the Saint Paul (443.000) and Dayton (442.850) listings have an empty `talkgroups` array upstream — missing data, not a parse error.

## 2026-10-15 — Nearby Repeaters P2.1/P2.4: RadioID wired in with geocoding

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P2.1/P2.4** | **RadioID is now a live source.** The dialog fetches `rptrs.json` (cached 7 days) and merges it (BM > RadioID > hearham). RadioID rows carry no coordinates, so a second pass **geocodes** the ones in the user's region by city via the Android `Geocoder` (the user's region is reverse-geocoded once; results cached to `dmrmod_geocode_cache.json`; capped at 160 lookups per load), then re-renders. The install dialog uses a repeater's **own talkgroups** (from RadioID) and only queries BrandMeister when a BM device has none. | `NearbyRepeatersUi`, `RadioIdRepeaterSource`+`Repeater` (region field), `RepeaterCatalog` | **device, on-air**: BM 3186 + RadioID 11424 + hearham 15857 → merged 25977; user region Minnesota resolved; 173 RadioID rows geocoded; **DMR-only nearby list grew 3 → 7** (added non-BM repeaters W9YZI/N0VZC/N0YNT by city); a RadioID-only repeater opens without hitting BM; no crash |

**Phase 2 is functionally complete** — three sources (DMR via BrandMeister + RadioID, FM via hearham), merged and geocoded, with DMR and FM install both proven on-air. Before any public release: the courtesy emails to the three sources and a real contact address in the User-Agent (the ship-blockers in `16-…` §5), which are the operator's to send.

## 2026-10-15 — Nearby Repeaters P2.7: attribution footer + About data sources

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P2.7** (partial) | The dialog shows a **"Data: BrandMeister · hearham"** footer; tapping it opens an **About data sources** screen naming the sources with their URLs, stating the catalogs are cached on-device only (never re-published), and that the feature is for licensed amateurs. | `NearbyRepeatersUi` | **device**: footer shown, About dialog opens with the source list, no crash |

Still before release: the courtesy emails to hearham / RadioID / BrandMeister (the ship-blocker contacts in `16-…` §5), a real contact address in the User-Agent, and RadioID wiring (needs bulk city-geocoding, deferred — most RadioID rows have no coordinates).

## 2026-10-15 — Nearby Repeaters P2.6: mode / in-range / stale filter chips

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P2.6** | A second chip row filters the list: **DMR**, **FM**, **In-range** (default on — hides frequencies the radio can't tune, e.g. the 6 m and 927 MHz entries that used to show), and **Hide stale**. Install also refuses an out-of-range repeater outright. | `NearbyRepeatersUi`, `GeoUtil.inRadioRange` | **device**: 74 shown default → 85 with in-range off → 3 with FM off → 0 with both off; no crash |

## 2026-10-15 — Nearby Repeaters Phase 2: FM in the catalog and the FM install path

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P2.4 (FM)** | The live dialog now merges **hearham FM** into the BrandMeister catalog: hearham is fetched once (cached 30 days, Wi-Fi), filtered to FM-with-coordinates, and merged via `RepeaterCatalog`. FM and DMR repeaters list together by distance; the row shows `FM` or `DMR CCn`. | `NearbyRepeatersUi` | **device**: BM 3187 + hearham 15857 FM → merged 17962; FM rows appear sorted by distance |
| **E7 P2.5** | FM install path. `RepeaterPlanner` plans one analog channel for an FM repeater; `RepeaterProgrammer` writes it (type 1, band from bandwidth, tones via the existing `ToneConverter`, sq 2, no contacts/TG list), into a per-repeater zone, inactive. Tapping an FM repeater skips the talkgroup dialog and goes straight to the confirm. | `RepeaterPlanner`, `RepeaterProgrammer`, `NearbyRepeatersUi` | **device**: K0SCA → analog channel 145.490/144.890, band wide, CTCSS rx/tx subcode 24, active 0; **undo → baseline**, no crash; **JUnit** FM-plan test |

Phase 2 DMR + FM install both work on-device. Remaining: RadioID (non-BM DMR) into the live catalog with geocoding for coordinate-less rows (P2.1 is parsed, not yet wired), source/band/on-air filter chips (P2.6, e.g. hide the 6 m/out-of-range rows), and the attribution footer + source contacts (P2.7). `RepeaterCatalog.merge` and `RadioIdRepeaterSource` are already in and unit-tested, so wiring RadioID is mostly fetch+geocode.

## 2026-10-15 — Nearby Repeaters: Phase 1 polish + Phase 2 source parsers

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P1.7** | Install now asks for confirmation first, showing exactly what will be created and that channels start inactive. | `NearbyRepeatersUi` | **device**: confirm dialog appears before any write |
| **E7 P3.3** | Re-installing the same repeater into the same area **replaces** the previous run (its channels/zone/contacts are undone first) instead of duplicating. | `RepeaterProgrammer`, `RepeaterInstallStore` | **device**: install→51 ch, install again→still 51 (not 53), undo→49 |
| **E7 P1.6** | Best-effort channel-list refresh after install via a new `MainHook.refreshChannelListUi()` (posts the fragment's `initData` if the list has been opened). | `MainHook`, `RepeaterProgrammer` | code; createChannel already updates the module list |
| **E7 P2.1** | `RadioIdRepeaterSource`: parses `rptrs.json` (MHz freq, `+5.000` offset, `color_code`, `ipsc_network` normalised to BM/DMR+/DMR-MARC/TGIF, `ts_linked` slot, `talkgroups[]` as objects or bare ids, Maidenhead from `map_info`). Pure. | `RadioIdRepeaterSource` (new), fixture | **JUnit**: freq/offset/tgs/network/locator |
| **E7 P2.2** | `HearhamSource`: parses the FM/DMR array (Hz freq + signed offset, repeater-POV, `mode`, `encode`/`decode` tones, `CCn` colour code, `operational`). Pure. | `HearhamSource` (new), fixture | **JUnit**: FM RX/TX+tones, DMR CC, stale flag |
| **E7 P2.3** | `RepeaterCatalog.merge`: folds sources (BM > RadioID > hearham) by key — first source sets each field, coordinates from the first that has them, talkgroups unioned, `sources` bitmask ORed. Pure. | `RepeaterCatalog` (new); `Repeater` gains tone/bandwidth fields | **JUnit**: dedupe+union, distinct kept, null-safe |

Host suite now **39 tests, 0 failures**. The FM device-install path (ToneConverter is already present and will be reused) and wiring RadioID + hearham into the live multi-source catalog with geocoding are the next step; Phase 1 DMR install is complete and polished.

## 2026-10-15 — Nearby Repeaters Phase 1: install path (applier, expand/preview, undo)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P1.4 (apply)** | `RepeaterProgrammer` writes a plan through the OEM create path by reflection: reuse-or-create contacts, one TG list per slot, one `ChannelData` per spec via `DmrManager.createChannel` (channelMode 4, relay 2, encryptSw 2, groups = the slot's RX list, **active 0**), then zone, location and an `installed` run record. New channels are not live until the user taps one. | `RepeaterProgrammer`, `RepeaterInstallStore` (new) | **device**: KA0KMJ → 2 listen channels (TS1/TS2), 15 contacts, zone created; channels `active=0`; DB rows match the plan |
| **E7 P1.5** | Tapping a repeater opens a per-repeater dialog: its talkgroups grouped by slot, each a checkbox to also transmit on, a live preview (`N channels (X listen + Y talk), M contacts, 1 zone`), Install, and a result sheet with **Undo**. | `NearbyRepeatersUi` | **device**: dialog lists named TGs per slot; preview updates on tick |
| **E7 undo** | Undo removes exactly what a run created and nothing else. Contacts are tracked by **talkgroup number** and removed via `getContact`, because `saveContact` does a blank-insert-then-update whose `notifyContactAdded` listener can throw on the background thread after the row is persisted (it did, on the first contact of a run) — recording intent before the call keeps undo exact. | `RepeaterProgrammer`, `RepeaterInstallStore` | **device**: install 49→51 ch / 27→42 contacts, run tracks all 15; **undo → 49 ch, 27 contacts, 0 leftovers**, original zones intact, no crash |

Phase 1 install path proven on a live repeater with a clean undo. Remaining P1: post-install channel-list refresh so new rows show without reopening (P1.6), a channel-count confirm for large installs (P1.7), and the re-run-in-place/`installed` fingerprint (P3.3). FM install is Phase 2.

## 2026-10-15 — Nearby Repeaters Phase 1 start: talkgroup parsers + channel planner (testable)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P1.2** | `BrandMeisterSource` gains `parseDeviceTalkgroups` (`/device/{id}/talkgroup` → the repeater's static TGs with slot; drops TG 0, maps invalid slots to unknown) and `parseTalkgroupNames` (`/talkgroup` → TG id→name map). Both pure; network fetch wrappers come with the lazy-fetch wiring. | `BrandMeisterSource`, fixtures `bm_device_talkgroup.json` / `bm_talkgroup_names.json` | **3 JUnit** (slot parse, name map, garbage-safe) |
| **E7 P1.4 (planner)** | New pure `RepeaterPlanner`: a repeater + the TGs the user wants to transmit on → a list of `ChannelSpec`s under the **one-listen-channel-per-slot** model (ch16 §10). One listen channel per active timeslot whose RX group list holds the slot's TGs (≤32, truncate+warn) with `txContact` = the slot's primary TG; each ticked talk TG adds one channel sharing that RX list with its own `txContact`. Emits the contacts needed and a suggested zone name; trims names to 32 chars. The device-side applier (createChannel/zone/location/undo) is the next step. | `RepeaterPlanner` (new) | **8 JUnit** (one-per-slot, talk adds one, primary not duplicated, contacts cover all TGs, unknown-slot → TS1, >32 truncation, name trim, non-DMR empty) |

Host test suite now 29 tests, 0 failures (`./gradlew testDebugUnitTest`). No device-facing change this step — the planner and parsers are not yet wired into the dialog. Next in Phase 1: the device-side `RepeaterProgrammer` (apply a plan through the OEM createChannel path), the expanded card with TG checkboxes + live preview, and undo.

## 2026-10-15 — Nearby Repeaters Phase 0 complete (P0.5: location permission + fresh fix)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P0.5** | Confirmed the OEM process holds location at runtime: `dumpsys package com.pri.prizeinterphone` shows `ACCESS_FINE_LOCATION granted=true` with `SYSTEM_FIXED|GRANTED_BY_DEFAULT` (it is a privileged `android.uid.system` package, so the grant can't be revoked). Added a **one-shot fresh GPS/network fix** to the dialog: the last-known fix shows immediately, then a current fix (12 s timeout, removed after the first result) upgrades it and re-sorts the list. | `NearbyRepeatersUi` (fresh fix) | **device**: `fresh fix 45.222558,-93.6730501` logged, status updated from the last-known position; catalog loaded from the 24 h private cache (offline path), no refetch; no crash |

**Phase 0 is done**: nearby BrandMeister repeaters list by distance on the radio, work offline after the first fetch, with a fresh GPS fix. Next: Phase 1 (install path) under the re-scoped one-listen-channel-per-slot model (`16-…` §10).

## 2026-10-15 — Nearby Repeaters Phase 0: the Device-tab list (P0.4)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P0.4** | New Device-tab button **📡 Nearby Repeaters** opens a dialog that shows BrandMeister repeaters near you, sorted by distance. It reads the last-known GPS fix, fetches the `/device?repeater=true` catalog once over the network, caches the ~1 MB JSON in the app-private cache dir (24 h TTL; stale cache is used if a later fetch fails, so it works offline after the first run), and filters by a radius chip (10/25/50/100/200 km). Each row shows callsign, bearing+distance, RX MHz, colour code and city. A Refresh action forces a re-fetch. Nothing is written to the radio; selecting/installing is Phase 1. | `NearbyRepeatersUi` (new), `MainHook` (button) | **device, live**: fetched 1,007,940 bytes, parsed 3,187 repeaters (91 simplex dropped); location fix resolved; 50 km → 4 shown, 200 km → 23, 10 km → 0 with a widen-radius prompt; catalog cached to `cache/nearby_bm_device.json`; no crash |

Known for later phases: out-of-range frequencies (e.g. a 927 MHz 900-band repeater) are listed in Phase 0 but will be badged **not installable** in Phase 1/2 (`GeoUtil.inRadioRange`). P0.5 (confirm the runtime location permission in the OEM process and add a one-shot fresh GPS fix) is the last Phase 0 item.

## 2026-10-15 — Nearby Repeaters Phase 0: testable core (geo, HTTP, BrandMeister parser)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P0.1** | `HttpClient`: thin `HttpURLConnection` wrapper with a descriptive User-Agent, gzip, timeouts, one redirect, and conditional GET (ETag / If-Modified-Since → 304). Network-only, off the UI thread. | `HttpClient` (new) | — (device) |
| **E7 P0.2** | `BrandMeisterSource`: parses `/device?repeater=true` into `Repeater`s. tx/rx are the repeater's point of view, so BM `tx` becomes the user's RX; simplex (tx==rx) and blank-callsign rows are dropped; numbers parse whether JSON numbers or strings; a missing coordinate falls back to a Maidenhead locator in the `city` string. The parser is pure; the fetch wrapper is device-only. | `BrandMeisterSource` (new), fixture `bm_device_sample.json` | **7 JUnit** (point-of-view freq swap, string numbers, simplex/blank drop, locator fallback, stable key, garbage-safe) |
| **E7 P0.3** | `GeoUtil`: haversine, bearing, compass arrow, distance formatting, VHF/UHF band classification, MHz→Hz, and Maidenhead ↔ lat/lon with free-text locator extraction. `MainHook`'s four private geo helpers now delegate here, so the intercom location chip and the feature share one implementation. | `GeoUtil` (new), `RepeaterModels` (new), `MainHook` | **11 JUnit** (known distance, cardinals, arrows, band, Maidenhead round-trip + anchor + junk) |
| infra | Host unit tests enabled: `testImplementation junit:4.13.2` + `org.json:20240303` (org.json matches android.jar's API so parsers run off-device), `testOptions.unitTests.returnDefaultValues`. Run with `./gradlew testDebugUnitTest`. | `app/build.gradle`, `src/test/…` | **18 tests, 0 failures** |

Still to do in Phase 0: **P0.4** the Device-tab button + minimal dialog (location row, radius chips, distance-sorted BM list), **P0.5** confirm runtime location permission in the OEM process and a one-shot fresh GPS fix. Phase 0 writes nothing to the radio.

## 2026-10-15 — R5: channel locations keyed by `_id` (Nearby Repeaters prerequisite)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **R5** | The intercom's distance/location display looked up `LocationDatabase` by `mCurrentChannelIndex + 1`, which only equals the channel's key with no deletions and no zone filter — so under a zone it showed the wrong channel's location. It now resolves the displayed channel's **`_id`** from the fragment's own (zone-filtered) `channels` list. The importer stages locations by the inserted `_id` and the exporter looks them up by `_id`, so the whole path keys on `_id` (the stable key the Nearby-Repeaters installer will use). The `channel_locations` key column keeps its legacy name `channel_number` but now holds `_id` (no cache migration; the two are equal on this codeplug). | `MainHook`, `DirectDatabaseImporter`, `DirectDatabaseExporter`, `LocationDatabase` | **device**: injected a location row for the active channel's `_id` (49); the intercom resolved it to Chicago with distance and bearing (`Distance to channel id 49`), proving the read path keys by `_id`; hooks load 0 failures, no crash |

## 2026-10-15 — On-air: group-call RX follows the RX group list (E7 gate P0.6 passed)

| Backlog | Change | Files | Test |
|---|---|---|---|
| **E7 P0.6** | **Finding.** With a BTECH 6X2 (ID 64067) keyed into the Ulefone on 467.700 simplex, CC1/TS1: a private call to the radio's own ID (1447) opened; TG 1 opened while the channel's Call Number was 99 and the RX list was `[1]`; TG 9 and TG 99 stayed silent until they were added to the list, then both opened. The MCU's group filter is the 32-slot `groups[]` list, not the Call Number. The 2026-03 "firmware ignores the RX list" verdict is withdrawn. | docs (`CLAUDE.md` §3, copilot-instructions, `packet-layouts.md`, deep-dive 02/13, backlog, `grok-deep-dive/11` §19) | **device**: four `0x2B` bodies decoded, see §19 |
| **0x2B** | Caller-info body decoded: `[0]` callType, `[1..4]` caller ID LE, `[5..8]` target LE. The 30-line "try every endianness" log dump (with a hard-coded "Expected DMR ID: 64067") is replaced by one decoded line; the **caller panel headline and the history entry now show the talkgroup** ("· TG 99" / "private"). | `MainHook` (`describeCallTarget`, `currentCallerDestId/CallType`) | device: next group call |
| **RX list** | Saving a digital GROUP channel **adds its Call Number to `groups[]`** when missing (first free slot; toast), also when a TG list is applied; a full list gets a warning instead. Help text updated. | `MainHook` (`ensureTxContactInGroups`, `saveChannelData` hooks) | device: save a channel whose Call Number was missing from the list, re-read the DB |
| **U11** (cont.) | **Help pass.** All 17 channel-editor info icons, the Group List header, the Zone and TG List dialogs and the Use Assistant section rewritten against the verified behaviour: the Group List dialog described a non-existent "channel category" feature and now explains the RX group list as the receive filter; Squelch no longer claims a "firmware bug forcing 2" and states the one-threshold result; CTCSS range 67.0-254.1 (was 62.5); Transmission Interruption uses the OEM labels OFF/ON/transmit with the module values; Contact Type explains why All is not a monitor mode; Call Number range 1-16776415 and the auto-add; Zone says one zone per channel; the repeater example in the frequency dialogs had lost a digit (14520000). Use Assistant gains a Channel editor section and a caller-panel line. | `MainHook` (`addChannelPropertyHelpIcons`, `MOD_HELP_TEXT`, zone/TG-list dialogs) | **device**: editor opens with 0 icon errors; the RX Group List dialog shows the new text |
| fix | Outbound `txContact` debug log read the 4 bytes big-endian (printed 1660944384 for TG 99); now LE. Diagnostics toast named `Download/DMR/uart_logs`; the logger writes `/sdcard/DMR/uart_logs`. | `MainHook` | log |

## 2026-10-14 — Firmware track: CTCSS table located, do-nothing patch image unbundled

| Backlog | Change | Files | Test |
|---|---|---|---|
| **FW1/FW3** | The **CTCSS tone table** is at file offset `0x366B2` of the MCU image: 50 × LE16 centihertz (6700 = 67.00 Hz … 25410 = 254.10 Hz), 49/50 identical to the EIA list (index 32 is the 177.4/177.3 catalogue variant). First user-visible data table found; it is the legal, receive-side, reversible FW3 target for proving the RAM-load round trip. No literal xref and no DCS table found. | `scripts/fw1_ctcss_table.py`, `grok-deep-dive/11` §18, plan `18`, backlog | script reproduces 49/50 |
| **FW6** (part) | `PATCH14.bin` (378 KB modified MCU image that did nothing) is no longer bundled in the APK; `PatchReloadHelper` had no live callers. | `assets/` | build + install, hooks load |

## 2026-10-14 — Batch 11: private JSON mode backups (S3), import needs its safety copy

| Backlog | Change | Files | Test |
|---|---|---|---|
| **S3** | **Mode backups are private JSON.** APRS / SSTV / NOAA / VFO parked the hijacked channel as a Java-serialized HashMap at `/sdcard/<mode>_channel_backup.dat` (world-readable; read back through `ObjectInputStream`). They are now `files/dmrmod_<mode>_channel_backup.json` in the OEM app's private directory via the new `ModeBackupStore` (save / load / exists / delete). A leftover `.dat` is migrated once through a class-whitelisting `ObjectInputStream` (HashMap, boxed primitives, String, int[] only) and deleted. All call sites switched; no `.dat` path remains in `MainHook`. | `ModeBackupStore` (new), `MainHook` | **device**: NOAA APT monitoring started from PKT RAD - `files/dmrmod_noaa_channel_backup.json` appeared holding the parked channel (`NOAA WX6`, 162.500 MHz, `sq` 5); STOP + CLOSE logged `NOAA channel restored: NOAA WX6`, the file was gone and the intercom showed NOAA WX6 again; startup checks log "No ... backup file found" for APRS/SSTV/VFO |
| **R8** (cont.) | If the automatic pre-import backup fails, the import is **aborted** with a message instead of proceeding without a snapshot. | `DirectDatabaseImporter` | code review |

## 2026-10-14 — Hygiene: untracked scratch files, module README

| Backlog | Change | Files | Test |
|---|---|---|---|
| **H1** ◐ | 24 loose files at `DMRModHooks/` root — logcat dumps, test logs, a personal codeplug (`database_channel_area_default_uhf.db`), CSV/PDF backups — and the stale `OpenGD77Fork/DMRModHooks-signed.apk` are **untracked** (`git rm --cached`; they stay on disk) and gitignored by pattern. The 24 `.wav` captures stay tracked: they are the only candidate corpus for the F0 modem test harness. | `.gitignore`, index | `git status` clean; files present on disk |
| **H3** ✅ | `DMRModHooks/README.md` (1,894 lines, stopped at v3.1.3) replaced by a 40-line pointer to the root README / CLAUDE.md / changelog / deep dive, with build notes and a file map. The old text remains in git history. | `DMRModHooks/README.md` | — |
| docs | Root README gets an "Unreleased" pointer to `CHANGELOG_DRAFT.md` under the release banner (no version bump). | `README.md` | — |

## 2026-10-14 — Batch 10: in-app help, launch reset completeness

| Backlog | Change | Files | Test |
|---|---|---|---|
| **U11** | **Use Assistant rewritten for the mod.** The OEM help page (`FragmentLocalUseAssistantActivity`) gets a seventh section, "DMR Mod features": every intercom control (SCAN and its long-presses, Zone, Signal/S-meter, SOFT SQ, REC/TXT, modes), the Device-tab tools (EXPORT/IMPORT with the area and BOM caveats, RadioID, Diagnostics), and the facts that bite (squelch 1–9 one threshold, Call-Number-0 channels refused, group-call RX limit, reboot after a module update). Text lives in `MainHook.MOD_HELP_TEXT`. | `MainHook` | **device**: section appended, text readable in the UI dump |
| **R12** (cont.) | Launch reset also clears the zone filter (`currentZoneName/currentZoneChannels`, which the rebuilt Zone button already claimed was "All") and the VFO DMR-ID override (`vfoLocalId`). | `MainHook` | code review |

## 2026-10-14 — Batch 9: scan list, import preview, S-meter screen gate, short-recording filter

| Backlog | Change | Files | Test |
|---|---|---|---|
| **U13** (cont.) | **Scan list.** Long-press SCAN while idle opens a checklist of every channel in the area (`nn  name  (DMR/FM)`); unchecked channels are left out of every scan. Persisted in prefs `dmrmod_scan` / `excluded` (channel `_id`s), loaded at app start; "All" clears it. Long-press while scanning is still the one-session nuisance skip. | `ChannelScanner`, `MainHook` | **device**: unchecked channels 1–2 → prefs hold `1,2`, scan log says `45 other channel(s) in scope … 2 off the scan list`, dialog re-opens with them unchecked, "All" empties the prefs |
| **R10** | **Import preview.** The "Confirm Import" dialog now says what the backup contains (rows per CSV), which area it came from, and how many channels the selected area holds now; warns when `Channels.csv` has no rows. | `DirectDatabaseImporter` | **device**: `Backup contains: 48 channels, 27 contacts, 5 TG lists, 4 zones, 0 DTMF / Backup area: default_uhf / On the phone now (default_uhf): 48 channels` |
| **U14** (cont.) | S-meter polling pauses while the screen is off (`PowerManager.isInteractive()`). | `MainHook` | code review |
| recorder | Captures shorter than 1 s (16 000 bytes of 8 kHz mono) are discarded instead of becoming WAV files — squelch tails and kerchunks. | `MainHook` | code review |
| note | After an app restart with a carrier already present, `isReceiving` is false until the next RECEIVE_STOP/START, so a scan started right after relaunch may step off a busy channel once before it holds on the next one. Expected; the status pushes are the only source of truth. | — | device observation |

## 2026-10-14 — Batch 8: hook self-test, CSV quoting, hex keys, refused-channel warning

| Backlog | Change | Files | Test |
|---|---|---|---|
| **S8** | **Hook self-test.** Every hook-installer catch block (23 sites) bumps `hookInstallFailures`; `InterPhoneHomeActivity.onCreate` logs `Hook self-test: N installer failure(s)` and shows one toast when N > 0. | `MainHook` | **device**: `Hook self-test: 0 installer failure(s)` |
| **S14** | **CSV quoting.** Channel and contact names go through `escapeCsvField` on export (quoted when they contain `,` `"` or a newline); `parseCSVLine` turns a doubled quote inside a quoted field back into one quote. | `DirectDatabaseExporter`, `DirectDatabaseImporter` | **device**: export is byte-identical to the previous one for this codeplug (no names need quoting) |
| **U5** | **Hex encryption keys.** The editor's key field accepts `0-9 A-F a-f` (caps keyboard, no suggestions, hint "8 chars, 0-9 A-F"). Safe because the OEM sends the field's raw ASCII bytes (`getEncryptKey().getBytes()`), so any character is a valid key byte; `maxLength=8` is unchanged. | `MainHook` | **device**: hook log `U5: encrypt key field accepts hex` when the editor opens; typing not exercised (the key row only appears for a digital channel with encryption on) |
| **R14** | **Refused-channel warning.** Saving a digital channel with Call Number 0 shows a toast saying the radio will refuse to tune it (saved anyway). The `channel_txContact=0` rule comes from the batch 6 finding: Ch 45 (`txContact=1, contactType=1`) tunes, Ch 46–48 (`txContact=0, contactType=0`) are NAK'd. | `MainHook` | code review (no save performed on the user's codeplug) |
| tooling | The phone's default 256 kB logcat buffer wraps within seconds under the OEM app's per-packet logging, which is why "missing" hook-install lines kept appearing; the test scripts now run `adb logcat -G 16M` first. | scratch scripts | — |

## 2026-10-14 — Batch 7: live S-meter, SET_CHANNEL error hook, zone wrap-around

| Backlog | Change | Files | Test |
|---|---|---|---|
| **U14** (new) | **Live S-meter.** Device-tab toggle "📶 Live S-meter OFF/ON" (prefs `dmrmod_diagnostics` / `smeter`, default OFF). When ON, the mod polls `0x32` RSSI once a second while idle (not receiving, not transmitting, not scanning) and the intercom's Signal box shows the value even with the squelch closed. | `MainHook` | **device**: on a quiet NOAA channel the box showed `Signal: -105 dBm` (noise floor) with no RECEIVE_START; back on the live channel −86 dBm; toggle persisted and logged |
| **R15** | **SET_CHANNEL error hook.** `InterPhoneTalkBackFragment$2.errorEvent` (the OEM's channel-change ack listener) is hooked: the refusal is logged with the command byte, the scanner strikes the channel immediately instead of waiting 3 s, and a zone-navigation preset is undone so `mCurrentChannelIndex` goes back to the channel the radio is really on. | `MainHook`, `ChannelScanner` | **device**: three refused channels now cost ~0.15 s each (was 6 s); zone path code-reviewed |
| **R16** (new) | **Zone wrap-around fixed.** `updateChannelId()` clamps at the list ends, so the zone hook's preset of `max-1` going UP (or 0 going DOWN) was a no-op at the zone's ends. The hook now reverses the direction argument for those two steps, as the scanner does. | `MainHook` | code review (needs a zone whose first/last channel is at a list end to see it) |
| lesson | A `Handler` created in a **static initializer of `MainHook`** NPE'd in the Zygote fork (`Looper.getMainLooper()` is null there) and LSPosed dropped the whole module — no hooks, no `LSPosed-Bridge` log lines, Device tab bare. Found via `/data/adb/lspd/log/modules_*.log`. The handler is now lazy; rule added to CLAUDE.md §6. | `MainHook`, `CLAUDE.md` | **device**: module loads again |

## 2026-10-14 — Batch 6: channel scanner, serial-reader watchdog, backup area stamp

| Backlog | Change | Files | Test |
|---|---|---|---|
| **U13** (new) | **Channel scanner.** The OEM app has no scan. A "🔍 SCAN" button sits between the RSSI box and the Zone button on the intercom. It drives the OEM's own `updateChannelId()` path (so DB active flag, number display and MCU image stay consistent with a manual +/- press), honours the selected zone, listens 1.5 s after each ack (the MCU needs ~0.9 s after a retune before its squelch can open), holds while the MCU reports RECEIVE_START and for 2.5 s after it stops, and resumes. Tap again to stop on the current channel; a manual +/- or PTT also stops it. **Long-press while holding skips that channel for the session.** A channel whose SET_*_INFO write the radio refuses twice is skipped with a toast naming it. The OEM's 3 s "changing channel" ProgressDialog is suppressed during scanner steps. Requires Soft SQ off (the scan uses the radio squelch) and no APRS/SSTV/NOAA/VFO mode. | `ChannelScanner` (new), `MainHook` | **device**: 61-step loop over 48 channels; held on the NOAA carrier 0.9 s after landing; skipped NOAA and stopped on the next live NOAA channel; three rejected channels skipped; the landed channel persisted across a force-stop/relaunch; no ProgressDialog; no crash |
| **G2** | **Serial reader watchdog.** `AsyncPacketReader.decode()` now returns null (wait for more bytes) when a `0x68` frame's declared body has not fully arrived instead of throwing `BufferUnderflowException` and killing the reader thread for good; if `run()` still exits while the port is open, the thread is restarted (max 5 per minute). BER-test mode and non-0x68 heads are left to the OEM logic. | `MainHook` | **device**: hooks install; normal traffic (status pushes, 0x22/0x23 acks, readback) unaffected over ~400 channel writes; no partial frames were seen, so the wait path itself is unexercised |
| **R7** | **Backup area stamp.** Export writes `meta.json` (`area_key`, `exported_at`, OEM app version) into the backup folder and the zip; import reads it and **refuses** a backup from a different area than the one selected, with a message naming both. Pre-R7 backups (no meta.json) import as before. | `DirectDatabaseExporter`, `DirectDatabaseImporter` | **device**: export produced `meta.json` with `channel_area_default_uhf`, included in the zip; refusal path code-reviewed only |
| finding | **The radio rejects three channels on the test codeplug** (Ch 46 Medina-T2, Ch 47/48 Rockford): `CmdStateMachine` logs `MSG_SET_CHANNEL_AGAIN_FOR_FAIL` then `MSG_SET_CHANNEL_ERROR cmd34` for each. They are digital channels with **no TX contact** (Contact "None", contact type 0). The OEM +/- keys fail on them too ("operation failed"). Backlog R14. | — | device log |
| finding | The zone-navigation hook presets `mCurrentChannelIndex` the same way the scanner does; when the radio refuses the write, the fragment index is left one step ahead of the radio (the scanner now restores it; the zone hook does not yet). Backlog R15. | — | code review |

## 2026-10-14 — Batch 5: Pitfall 13 and import safety

| Backlog | Change | Files | Test |
|---|---|---|---|
| **R13** | Pitfall 13: Soft SQ is re-applied when the MCU **acknowledges** an analog write whose squelch byte was not 0 (`AnalogMessageHandler.handle` after-hook; the last-sent `sq` is tracked in the `SerialManager.send` hook). The 300 ms timer stays as a fallback. Our own `sq=0` writes cannot loop. | `MainHook` | **device**: with Soft SQ on, a foreign `sq=5` write is followed by an automatic `sq=0` and the readback shows 0 |
| **R4** | Importer strips a UTF-8 BOM from the `Channels.csv` header, and **refuses to commit an empty channel table** (throws inside the transaction → rollback, result "failed", codeplug untouched). | `DirectDatabaseImporter` | code review (import not exercised on the user's codeplug) |
| **R8** | **Automatic backup before every import** via `DirectDatabaseExporter.exportFromAppContext` (timestamped folder in `DMR_Backups/`); the success message says so. | `DirectDatabaseImporter` | code review |

## 2026-10-14 — Batch 3: Diagnostics gate

| Backlog | Change | Files | Test |
|---|---|---|---|
| **R6** (cont.) | When the app starts, `Download/DMR/uart_logs/` is pruned to the newest 40 files (it held 1,860). | `MainHook` | **device**: log line with the count |
| **R1** (cont.) | VFO dialog gains a **Bandwidth: Narrow 12.5 kHz / Wide 25 kHz** selector feeding `vfoBandWidth`, which is what `channel_band` now receives. | `MainHook` | **device**: dialog shows the control |
| **S7** | Device tab: a "Diagnostics" header groups the readback, probe and gate controls. | `MainHook` | **device**: UI dump |
| **U3** | `contentDescription` on the 14 tagged injected controls (Soft SQ, REC, MON, VFO, POS, PKT RAD, zone, squelch slider, …). | `MainHook` | **device**: UI dump shows `content-desc` |
| hygiene | Dead DSP code deleted (verified unreferenced, compile-checked): `AFSKDecoderPLL`, `DireWolfDecoder` + `cpp/`, `SSTVImageDecoder`, `SSTVGoertzelDemod`, `SSTVZeroCrossingDemod`, `SSTVFMDemodRobot36`, `SSTVFFTDemodulator`, `SSTVPhaseDemod`, `SSTVFilter`, `FrequencyModulation`, `Phasor`, `Kaiser`, `ComplexConvolution`, `Complex`, `SSTVFMDemodulator.java.old`. The live SSTV demod is the `com.example.dmrmodhooks.sstv` package; `AFSKGenerator` is kept for the TX experiment. | 16 files | compile |
| **R6** | **Diagnostics are opt-in.** New Device-tab toggle "🛠 Diagnostics OFF/ON (UART log + debug receiver)", persisted in the OEM app's `dmrmod_diagnostics` prefs, default OFF. While OFF the UART file logger writes nothing and `com.dmrmod.SEND_DEBUG_PACKET` broadcasts are ignored with a log line — an exported receiver that could make any app send MCU commands (including Radio Kill) is now inert by default. The 🧪 readback and 🔬 probe buttons do not depend on it. | `MainHook` | **device**: broadcast ignored while OFF, accepted after toggling ON; readback works in both states |

## 2026-10-14 — Correctness batch 2

| Backlog | Change | Files | Test |
|---|---|---|---|
| **S22** (root cause) | `enableSoftwareSquelchOnCurrentChannel()` overwrote the live `ChannelData.sq` with 0 (so VFO could read it) and the disable path then "restored" 0. The level is now saved in `softSqSavedChannelSq` before the overwrite and restored, into both the wire message and the channel object. The `sendAnalogMessage` before-hook also puts its 0 back in `afterHookedMethod`. | `MainHook` | **device**: NOAA channel level 5 → Soft SQ on → MCU `sq=0` → Soft SQ off → MCU `sq=5` |
| **S13** | PDF export: contact type label follows the OEM enum (0 person / 1 group / 2 all) and the contact map is keyed by `contact_number`, so channel contact names resolve (Pitfall 12). | `PDFExporter` | code review |
| **S15** | Information page: the empty light-gray "patch controls" container is only added when it has children. | `MainHook` | code review |
| **S17** | `updateLocationDisplay` runs its Geocoder / GPS work on a background thread and posts only the text updates. | `MainHook` | **device**: Intercom loads; location chip updates |
| **S18** | `activityHistory` guarded by `synchronized (activityHistory)` at the writer, the clear and the DB loader. | `MainHook` | code review |
| **S5** | `DMRTranscriptionService` treats both `YOUR_API_KEY_HERE` and the module's `YOUR_GOOGLE_CLOUD_API_KEY_HERE` as "no key". | `TranscriptionService` | build |
| **U8** | Intercom labels get English defaults (`Power:`, `Color Code:`, `Send:`, `Receive:`, `Contact:`) in `initView` instead of flashing the OEM layout's Chinese placeholders. | `MainHook` | **device**: UI dump after cold start |
| build | `android.suppressUnsupportedCompileSdk=34` silences the AGP 8.1 warning. | `gradle.properties` | — |

## 2026-10-14 — Correctness batch 1 (device-tested where noted)

### Type
- 🐛 Bug fixes · 🔧 Technical · ✨ Small features

### Changes

| Backlog | Change | Files | Test |
|---|---|---|---|
| **R1** | `determineBand()` deleted. It returned UHF/VHF into `channel_band`, which is the analog **bandwidth** byte. SSTV now sets narrow (0), NOAA wide (1), VFO uses `vfoBandWidth` (default wide). `channelMode` is no longer written for analog modes. | `MainHook` | code review |
| **R2** | The `saveChannelData` before-hook's "TG number → contact row `_id`" conversion removed: it tested the OEM enums inverted (ran on analog + person channels) and wrote a row id into `channel_txContact`, which holds the 24-bit DMR ID (Pitfall 12). The hook now only logs. | `MainHook` | code review |
| **R3** | Channel-editor frequency help text: Hz, no decimal, `446.0000 MHz → 446000000` (was 10× wrong). | `MainHook` | code review |
| **R9** | Manifest: removed the `APRSSettingsActivity` entry (class never existed → `ActivityNotFoundException` landmine); `BackupActivity` is `exported="false"`. | `AndroidManifest.xml` | installs |
| **R11** | App label and LSPosed description generated from `versionName` (`resValue`), strings.xml no longer says "v0.2". | `build.gradle`, `strings.xml` | `aapt dump badging` → "DMR Mod Hooks v3.4.6" |
| **R12** (part) | Launch-time reset now also clears Soft SQ / APRS Soft SQ / squelch-open flags, monitoring mode, zone auto-switch, and closes a stuck recording stream. | `MainHook` | code review |
| **S9** | APRS position packets whose coordinates fail to parse are no longer `isValid` (no more stations at 0,0). | `APRSPacketDecoder` | code review |
| **S10** | SSTV stop clears Soft SQ like APRS/NOAA do. | `MainHook` | code review |
| **S12** | Channel numbers ≥ 100 show their last two digits instead of a stale sprite. | `MainHook` | code review |
| **S20** | UART logger: full command-byte name table (hex, from `Const.java`), status names for `0x36` pushes, RSSI decode for `0x32`, and the body interpreter now actually runs (it compared with decimal 22) using the shared `McuDiagnostics` decoders (little-endian). | `MainHook`, `McuDiagnostics` | **device**: log shows `cmd=0x24 (QUERY_DIGITAL_INFO)`, `status=RECEIVE_START` |
| **S21** | Recording keeps one sample of each L==R pair and writes an **8 kHz mono** WAV (half the size, truthful header). | `MainHook` | **device**: NOAA recording → `channels=1 sampleRate=8000`, 229 376 B for 14.3 s |
| **S22** | Soft SQ off restores the channel's own squelch level. Root cause fixed too: the `sendAnalogMessage` before-hook wrote 0 into the live `ChannelData.sq` and never put it back; it now restores the field in `afterHookedMethod`. | `MainHook` | **device**: see below |
| **U4** | `CircuitBoardView` animates at 5 fps when not receiving (was 20 fps always). | `CircuitBoardView` | code review |

### Device test log (2026-10-14, Armor 26 Ultra, NOAA WX6 162.500 MHz)
- Readback via Device tab after reboot: OK; command names correct in the module log.
- Recording: three WAVs produced across RX stop/start cycles; header 8 kHz / mono / 16 000 B·s⁻¹; sizes match wall-clock.
- Soft SQ off → analog image `sq` byte: first build read back 0 (root cause above), fixed build re-tested — result recorded in `docs/grok-deep-dive/11-firmware-fw0-results.md` §18.

## 2026-10-14 — MCU diagnostics + first compile of the audit batch

### Type
- ✨ Feature (diagnostics) · 🔧 Technical

### Changes

| Area | Change | Files |
|---|---|---|
| Device tab | **🧪 Read MCU channel images** — sends `QUERY_DIGITAL_INFO` (0x24), `QUERY_ANALOG_INFO` (0x25) and `QUERY_MIX_CHECK_INFO` (0x39), captures the MCU's 163 / 19 / 169-byte replies through the existing `MessageDispatcher.onReceive` hook, decodes every field (frequencies, localId, groups[], txContact, contactType, CC, slots, mode, encrypt, tones, squelch…) and shows them in a dialog; also written to the Xposed log. Read-only. Verified by hand over adb on 2026-10-14 (`docs/grok-deep-dive/11-firmware-fw0-results.md` §15). | `McuDiagnostics.java` (new), `MainHook.addButtonToLayout`, `MainHook.hookSerialCommunication` |
| Device tab | **🔬 Probe RX audio layout** (backlog gate G1) — samples 60 `writeAudioTrack` chunks and reports whether consecutive 16-bit samples arrive as equal pairs (8 kHz stereo L==R), one silent channel, or independent samples (16 kHz mono as the module assumes). Open-squelch noise is sufficient input. | `McuDiagnostics.java`, `MainHook.hookPCMReceiveManager` |

### Build notes (2026-10-14)
- **First successful compile** of the 2026-08-26 batch: `:app:compileDebugJavaWithJavac` passes with JDK 17 (Temurin `17.0.20.1+1`, `C:\Users\Joshua\tools\jdk-17.0.20.1+1`). Gradle 8.2 in the wrapper **does not run** on the Android Studio bundled JDK (class file 69) — set `JAVA_HOME` to the JDK 17 before `gradlew`.
- `local.properties` (gitignored) created with `sdk.dir` pointing at `%LOCALAPPDATA%\Android\Sdk`.
- **`DMRModHooks/release.keystore` is absent from this machine** (gitignored, never committed, old repo path `C:\Users\Joshua\Documents\android\phonedmrapp` no longer exists). `assembleDebug` stops at `validateSigningDebug`; the installed 3.4.5 is signed with cert `9a9a4eb2…22b9` (CN=DMRModHooks). Until the keystore is found, an install needs `adb uninstall` + a new key + re-enable in LSPosed.
- Not yet device-tested; version not bumped.

## 2026-08-26 — Found-bugs batch from the deep-dive audit

### Type
- 🐛 Bug fixes · 📝 Documentation · 🔧 Technical

### Description
Fixes for defects surfaced by `docs/deep-dive/` (chapters 08, 11, 12, 14) plus the documentation
corrections that came out of the same audit.

### Changes

| Area | Change | Files |
|---|---|---|
| Backup / export / import / PDF / dump | **Area-aware channel table.** Every path used to hard-code `database_channel_area_default_uhf`; users on any other channel area (VHF default, regional, user-created) silently backed up and restored the wrong codeplug. New `OemChannelTable` resolves the OEM's selected area from its own prefs (`pref_person_channel_area_selected_index`, default per module band) and all seven classes now use it. | `OemChannelTable.java` (new), `DirectDatabaseExporter`, `DirectDatabaseImporter`, `PDFExporter`, `ZoneDatabase`, `DiagnosticDatabaseDump`, `CSVExporter`, `CSVImporter` |
| Import integrity | Locations and APRS flags are collected during the parse and applied **only after the channel table commits** (they live in separate SQLite files and cannot join the transaction). Previously `clearAllLocations()` ran before parsing, so a failed import left locations wiped. APRS flags are now written for every channel (explicit `false` too) so stale "enabled" flags cannot survive under a reused channel number; comments/symbols are preserved. | `DirectDatabaseImporter.importChannels` |
| Import integrity | `importTGLists` now clears previous TG lists **and their channel assignments** before inserting (assignments are keyed by channel `_id`, which the wipe-and-insert channel import re-creates). | `DirectDatabaseImporter.importTGLists` |
| Software squelch | Only gates analog audio: `currentChannelType == 1` or an active APRS/SSTV/NOAA mode. Previously the flag survived a switch to a digital channel and muted DMR RX with the toggle hidden. | `MainHook.hookPCMReceiveManager` |
| Software squelch | APRS mode gates only when its own Soft SQ toggle is on. Previously the live screen's persisted `aprs_squelch` threshold gated APRS audio with the toggle OFF. | `MainHook.hookPCMReceiveManager` |
| APRS | `AFSKDecoder` no longer dumps every 2 s buffer (~192 KB) to `/sdcard/aprs_debug/` while APRS runs; guarded by `AFSKDecoder.DEBUG_SAVE_WAV` (default off). | `AFSKDecoder.java` |
| Channel editor | "Call Number" help icon now targets the real row id `interphone_channel_call_name` (the old `interphone_channel_contact` id never existed, so the icon was silently skipped). | `MainHook.addChannelPropertyHelpIcons` |
| Licensing | GPLv3 attribution header for the `com.example.dmrmodhooks.sstv` package (port of xdsopl's *robot36*). | 12 files under `sstv/` |
| APK size | Removed `assets/speech_model.tflite` (41.6 MB, ~96 % of the APK) and `README_MODEL.md` — unreferenced dead weight (zero code references, no TFLite dependency). `assets/` now holds only `PATCH14.bin` and `xposed_init`. | assets |
| Docs | `.grok/rules/*.md` corrected from `docs/deep-dive/00-README.md` §4; new `CLAUDE.md` mirrors `.grok/rules/00-session-start.md` byte-for-byte (mirror rule documented in both). | `.grok/rules/`, `CLAUDE.md` |

### User impact
- Backups/restores follow the channel area you are actually using.
- A failed restore no longer half-wipes locations/APRS flags/TG lists.
- Digital channels are no longer muted by a leftover Soft SQ state; APRS monitoring respects its toggle.
- No more unbounded `/sdcard/aprs_debug/` growth.
- Help icon appears on the Call Number row.
- APK shrinks from ~43 MB to ~2 MB once the tflite asset is removed.

### Known regression risk introduced by this batch (2026-08-27, from the Grok review)
- `OemChannelTable` makes **channel** export/import follow the selected area, but the module side-tables (`dmrmod_zones.db`, `dmrmod_tglists.db`, `dmrmod_locations.db`, `dmrmod_aprs.db`) are still global: importing a backup while a *different* area is selected now clears that area's channels **and** the other area's zones/TG lists/locations; identical `_id`/`channel_number` integers across areas share rows. Mitigation before release: backlog **R7** (stamp `area_key` in the export folder, refuse/confirm cross-area import); full fix **H8** (area-scoped tables). Until then: import only into the area the backup was taken from.

### Testing notes
- **Not compiled**: the authoring machine has no JDK, Android SDK, `local.properties` or `release.keystore`. Build with `cd DMRModHooks; .\gradlew assembleDebug`, then `.\install.ps1` (includes reboot).
- Regression checks: (1) export on a non-default area and confirm `Channels.csv` matches that area; (2) import a folder, then check `dmrmod_locations.db`/`dmrmod_aprs.db` contents; (3) toggle Soft SQ on analog, switch to a DMR channel, confirm RX audio; (4) APRS mode with Soft SQ OFF — audio must pass; (5) open the channel editor and confirm the Call Number help icon.
- Version not bumped; no release created (per release policy).
