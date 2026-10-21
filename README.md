

https://github.com/user-attachments/assets/c09941ab-2027-46b9-b862-79e4e7d11362

﻿# PriInterPhone DMR Radio - LSPosed Mod with OpenGD77 Integration + Advanced Features

**Status**: ✅ **FULLY FUNCTIONAL** - RadioID Caller Lookup + Export/Import + GPS + Zones + Transcription + APRS + VFO + SSTV + NOAA APT!

> **🧪 New: SignalDeck 1.0.0-beta.1** (October 21, 2026) - the standalone app as a public **beta for testing** (root required, bugs expected) - see [SignalDeck](#-signaldeck--the-standalone-app-public-beta-100-beta1) and the [pre-release](https://github.com/IIMacGyverII/phonedmrapp/releases/tag/signaldeck-v1.0.0-beta.1)  
> **🚀 Current Stable Module Release: v4.1.4** (October 20, 2026) - standard packet lead-in (HDLC flags, after v4.1.2 beacon fixes + APRS TX log and v4.1.3 APRS transmit power); see the [releases](https://github.com/IIMacGyverII/phonedmrapp/releases/latest) and [`CHANGELOG_DRAFT.md`](CHANGELOG_DRAFT.md)  
> **📦 Prior Release: v4.1.1** (October 19, 2026) - APRS transmit fixes (CALL-SSID callsign split, no packets over DMR, TX audio follows the recorder format). Built on v4.1.0: **Packet radio on air**: APRS TX/RX (messages, beacon, KISS TNC, digipeater, APRS-IS iGate), SSTV send, NOAA SAME weather alerts, DTMF send/decode, CTCSS tone decoder, **on-device live captions** (Vosk, no cloud) with keyword alerts, Last heard, voice announcements, channel search — 90 changes, all device-tested  
> **🔧 Prior Stable: v4.0.0** (October 15, 2026) - Nearby Repeaters + in-app updater (no root) + on-air **group-call RX fix** + the full October correctness/diagnostics batch (channel scanner, live S-meter, in-app help) - see [What's New in v4.0.0](#whats-new-in-v400-october-15-2026) and [`CHANGELOG_DRAFT.md`](CHANGELOG_DRAFT.md)  
> **📻 Major Feature: v3.4.5** (June 16, 2026) - **RadioID.net global DMR ID lookup** — see who's calling with callsign, name & location (~300k IDs, offline)  
> **🔧 Also in v3.4.5** — Double-slot import fix, squelch default to normal
> **🖥️ OpenGD77 CPS Fork: v2.0.45** — `OpenGD77CPS-Mac_Build_20260607_210202.zip` (unchanged since v3.4.5)  
> **🔧 Prior Release: v3.4.0** (June 5, 2026) - Pitfall 12 fix (contact DMR ID), channel mode, CSVExporter parity
> **🐛 Prior Release: v3.3.9** (June 5, 2026) - Group/Private contact type swap + encrypt defaults  
> **🗂️ Prior Release: v3.3.8** (June 1, 2026) - OpenGD77 CPS Fork v1.2.0  
> **🛰️ Prior Release: v3.3.6** (March 19, 2026) - TG List Architecture + Group Grid Refresh  
> **🛰️ Prior Release: v3.3.5** (March 19, 2026) - NOAA APT Software Squelch Slider  
> **🛰️ Prior Release: v3.3.4** (March 19, 2026) - NOAA APT Live Monitoring  
> **📺 Prior Release: v3.3.3** (March 18, 2026) - SSTV Settings + APRS/SSTV Dialog Refresh Fix  
> **📡 Prior Release: v3.3.2** (March 19, 2026) - APRS Buttons Moved to Monitoring Page  
> **🔧 Prior Release: v3.3.1** (March 18, 2026) - Crash Recovery Improvements  
> **📺 Prior Release: v3.3.0** (March 18, 2026) - SSTV Live Monitoring  
> **🛠️ Prior Release: v3.2.3** (March 16, 2026) - APRS Channel Filtering + Button Spacing  
> **🎛️ Feature Release: v3.1.5** (March 14, 2026) - VFO Mode (Variable Frequency Oscillator)  
> **🐛 Bug Fix: v3.1.4** (March 13, 2026) - Software Squelch State Fix  
> **📡 Major Feature: v3.1.0** (March 12, 2026) - APRS Live Monitoring  
> **🎙️ Stable Base: v1.7.0** (February 2026) - Transcription and API Features

## Links & Community

- **💬 XDA discussion & support thread**: [Ulefone Armor 26 Ultra — DMR walkie-talkie app mod](https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-dmr-model-new-dmr-walkie-app-mod.4780125/)
- **🔧 Armor 26 Ultra root, guides & development**: [XDA info / development thread](https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-info-guides-development.4677740/)
- **📦 Source, releases & changelog**: [github.com/IIMacGyverII/phonedmrapp](https://github.com/IIMacGyverII/phonedmrapp) · [latest release](https://github.com/IIMacGyverII/phonedmrapp/releases/latest)
- **🖥️ OpenGD77 CPS fork (desktop codeplug editor)**: [github.com/IIMacGyverII/OpenGD77CPS-Mac](https://github.com/IIMacGyverII/OpenGD77CPS-Mac)

## Demo

<video src="https://github.com/IIMacGyverII/phonedmrapp/releases/download/v3.3.8/3.3.8.mp4" controls autoplay muted loop title="DMRModHooks v3.3.8 Demo" width="800"></video>

## 📻 RadioID.net Caller Lookup (Major Feature — v3.4.5+)

**Know who's on the air.** When someone keys up on a digital channel, DMRModHooks resolves their 24-bit DMR ID to a real identity — even if they're not in your codeplug.

### How it works

1. **Device tab → Download RadioID Database** — one-time fetch of the official [RadioID.net](https://www.radioid.net/) `user.csv` (~17 MB, ~300k registered IDs)
2. On every **voice RX**, the module decodes the caller's DMR ID from the digital audio packet
3. **Two-tier lookup**: your personal codeplug contacts always win; RadioID is the fallback for unknown IDs
4. Results are cached locally in `dmrmod_radioid.db` — lookups work **offline** after download

### What you see on the intercom screen

- **Caller detail panel** over the spectrum — large callsign headline with source badge (🌐 RadioID / ⭐ personal contact)
- Registrant name, DMR ID, city · state · country
- **DMR history** lines: `First Last · CALLSIGN  HH:mm:ss 📻 Voice RX -XX dBm`

### Setup (one time)

1. Install v3.4.5+ and reboot
2. Open **Device** tab → tap **Download RadioID Database** (Wi‑Fi recommended, ~1–2 min)
3. Optional manual import: place `user.csv` in `/sdcard/Download/DMR/RadioID/`

> Your codeplug contacts are never overwritten. RadioID only fills in IDs you don't already have programmed.

---

## 🧪 SignalDeck — the standalone app (public beta: 1.0.0-beta.1)

> [!WARNING]
> **Beta, for testing only — bugs are expected.** SignalDeck needs a rooted phone and takes direct control of its radio module. It is provided as is, without warranty (GPL v3); the author is not responsible for any damage to your phone, its radio or your data, and transmitting legally is your responsibility. Read the disclaimer in the [release notes](https://github.com/IIMacGyverII/phonedmrapp/releases/tag/signaldeck-v1.0.0-beta.1) before installing.

**Download:** [SignalDeck 1.0.0-beta.1 (pre-release)](https://github.com/IIMacGyverII/phonedmrapp/releases/tag/signaldeck-v1.0.0-beta.1) → `SignalDeck-1.0.0-beta.1.apk`. It is published as a GitHub *pre-release*, so the DMRModHooks module's "latest release" and its updater are unaffected; SignalDeck's own *Device → Updates* finds later test builds.

The LSPosed module hooks the Ulefone's stock walkie-talkie app, so it only ever works on the Ulefone Armor 26 Ultra. **SignalDeck** (`DMRStandalone/`, package `com.macdmr.radio`; called "DMR Radio" before 2026-10-20) drives the radio module directly instead: one shared protocol engine plus a small **device profile** per phone (serial port and its opener, audio path, power/PTT lines, PTT key broadcasts, SELinux rules). On the Armor it does everything the module does and more, tested on the phone and most of it on the air:

- **Talk and listen:** the module's intercom page (same artwork), side PTT key, analog FM and DMR (group/private calls, RX group lists, text messages with quick replies), channels with favourites and an editor, zones, Nearby Repeaters, scanner, VFO, Soft SQ, REC, MON, live captions (on-device Vosk or Google Cloud) with keyword alerts, voice announcements, Last heard with RadioID names;
- **Packet (PKT):** APRS (passive decode, monitoring with auto-ack, messages, beacons, digipeater, objects, telemetry, weather), APRS-IS iGate, KISS TNC for APRSdroid/YAAC, satellite passes with Doppler (ISS), SSTV receive and send, NOAA SAME alerts, DTMF (decode, send, remote control), RTTY/PSK31, packet terminal, parrot repeater, Morse, voice keyer, ID timer;
- **Pages and tools:** logbook (ADIF), net control, fox hunt, exam practice, map and coverage maps, Android Auto, widget, **SignalDeck Web** (the radio in a browser on your Wi-Fi), backups in the module's five-CSV layout, boot persistence, in-app updates and in-app help for every screen.

| Phone | SignalDeck status |
|---|---|
| **Ulefone Armor 26 Ultra** (walkie-talkie model) | Tested profile — the beta's reference phone. The DMRModHooks module remains available as the stable option. |
| **Blackview Xplore 1** | **Untested profile** ([analysis](docs/multi-device-xplore1-findings.md)): same radio-module protocol, audio over a second UART. The app does not take the radio by itself there; owners, please run **Device → Run all checks** and send us the zip. |
| Oukitel WP61 Plus/Ultra/Ti, Ulefone Armor 20WT, UNIWA P2 Plus… | No profile — the app starts in discovery mode and offers **Run all checks** |

**Root (Magisk) is required** on every phone: Android's SELinux policy only lets the stock app open the radio's serial port. SignalDeck applies the rules it needs with Magisk (Device → *Keep access after reboot* makes them permanent as a small Magisk module).

**Have a different DMR phone?** Install the beta and run **Device → Run all checks** (one button, about two minutes; it only listens and hands the radio back to the stock app), then **Send** the zip or open an issue with it. Without the app: [`docs/DEVICE_SUPPORT_REQUEST.md`](docs/DEVICE_SUPPORT_REQUEST.md).

**Bugs:** open an [issue](https://github.com/IIMacGyverII/phonedmrapp/issues) with your phone model, the SignalDeck version, what happened, and the zip from *Run all checks*.

The module keeps getting releases until SignalDeck leaves beta.

---

## What's New in v4.1.1 (October 19, 2026)

A fix release after a user report that APRS beacons, messages and KISS frames transmitted but never reached aprs.fi. Verified on the radio with a HackRF capture decoded by direwolf.

- **Callsign typed with its SSID** (`N0CALL-7` in the callsign box) is split into callsign and SSID. Before, it was sent as the address itself; an AX.25 address cannot contain `-`, so every digipeater and iGate dropped the packet. Callsigns must now be 1–6 letters and digits, and one saved the old way still goes out correctly.
- **No packets over a DMR channel**: APRS, KISS, DTMF and SSTV transmissions are refused when the current channel is digital (before, a KISS session or beacon on "current channel" could send AFSK through the DMR vocoder).
- **TX audio follows the stock recorder's real format** (sample rate, channels, sample size) instead of assuming 8 kHz stereo, and each transmission is logged with its frequency, analog/digital and power, plus the mic format once.

## What's New in v4.1.0 (October 17, 2026)

Two days of on-air work with a HackRF bench. Everything below is built, installed and exercised on the test phone. Full per-change log with device evidence: [`CHANGELOG_DRAFT.md`](CHANGELOG_DRAFT.md).

### 📡 Packet radio that actually transmits
- **APRS over analog FM works** (the old "impossible" verdict was a stereo/mono frame bug): **Send APRS Message**, **Position Beacon**, **KISS TNC** (TX **and** RX — use the radio from APRSdroid/YAAC over KISS-over-TCP), **fill-in digipeater** (WIDE1-1), **APRS-IS** RX-only iGate + internet beacon, **passive APRS decode** on any analog channel, full packet parser (Mic-E, compressed, objects, messages with auto-ack, weather…), stations with distance/bearing, reply from the received list.
- **SSTV send** (Robot 24 Color / Robot BW — the firmware caps every TX at 30 s) and a corrected SSTV receiver.
- **NOAA Weather Radio SAME alerts** decoder, **DTMF** decode + send (keypad, saved sequences), **received CTCSS tone** decoder with tap-to-program.

### 🎙️ On-device live captions (no cloud)
- TXT now shows **real-time captions** from the companion app (Vosk/Kaldi, models from 40 MB to 2.3 GB, chosen on TXT long-press). No API key, nothing leaves the phone. Google Cloud STT remains available as the alternative engine.
- **Caption keyword alerts**: your word list → vibrate, spoken alert and a 🔔 history line when a transmission mentions it.
- Captions and recordings are linked from **Last heard**.

### 📻 Radio operation
- **Last heard** across all channels with go-to-channel, recordings and transcripts per channel; plain analog receptions now logged.
- **Voice announcements** (TTS) for channel changes and DMR callers; **volume-up / headset button = PTT**; **TX timer** with 25 s warning.
- **Channel page search** (name / frequency / number) with an ALL/FM/DMR chip; ZONE button moved into the search row.
- **Soft SQ**: software CTCSS/noise squelch, per-channel settings (also in the OpenGD77 CPS fork v2.0.44), several layout fixes.
- **Critical fix**: a channel-write pattern that could leave the radio transmitting **no RF at all** (survived reboots) is gone — hardware writes are single-path now.

### 📦 Install notes
- The **companion app** (`DMRTranscriptionService-v1.1.0.apk`) is back and is required for live captions. Install both APKs, reboot.
- Everything else from v4.0.0 (Nearby Repeaters, in-app updates, RadioID lookup, OpenGD77 CSV) is unchanged.

---

## What's New in v4.0.0 (October 15, 2026)

Everything below is built, installed and exercised on the test phone (Ulefone, DMR003.UV4T.V022 module). Full per-change log with device evidence: [`CHANGELOG_DRAFT.md`](CHANGELOG_DRAFT.md).

### 📡 Nearby Repeaters (new)

A **📡 Nearby Repeaters** button on the Device tab finds repeaters near your location and programs the ones you pick into the radio — no computer, no CSV.

- **Three data sources merged**: BrandMeister (DMR), RadioID (non-BrandMeister DMR) and hearham (analog FM), de-duplicated and **sorted by distance** with bearing and range
- **DMR install** creates one **listen channel per timeslot** — its RX group list holds that slot's talkgroups (up to 32), so you hear the whole slot — plus a transmit channel for any talkgroup you tick; **FM install** creates a single analog channel with the right tones and bandwidth
- Repeaters the directories list **without talkgroups** get a manual builder: add them from your saved contacts or by number
- New channels are added **switched off** and filed in a **zone you choose** (a shared "Nearby" zone by default, a new named zone, or an existing one); tap one in the channel list to go live
- **Undo** removes exactly what an install created — hand-made channels, contacts and zones are never touched
- Filter chips for **DMR / FM / in-range / hide-stale**; RadioID rows with no coordinates are **geocoded by city** for your region; everything is cached for offline use
- Attribution footer and a "data sources" dialog credit BrandMeister, RadioID and hearham

### ⬆️ In-app updates (new)

**Check for updates** on the Device tab downloads the latest release straight from GitHub and installs it.

- Quietly flags when a newer release exists, and shows its notes before you install
- Installs through Android's own package installer — **no root**, and **no new privilege on the intercom app** (the module installs itself; the one-time "install unknown apps" consent lands on the module)
- Streams the download (large APKs are fine), then reminds you to **reboot** so LSPosed loads the new version

### 🔍 Channel Scanner (new)

The OEM app has no scan. A **SCAN** button now sits between the Signal box and the Zone button on the intercom.

- Scans the selected **zone** (or all channels) through the OEM's own channel-change path, so the database, the number display and the radio module always agree
- Stops on activity (the radio's own squelch / DMR decode), stays 2.5 s after it ends, then moves on; **tap** to stop on the current channel, PTT or a manual arrow press also stops it
- **Long-press while stopped on a channel** - skip that channel for this session; **long-press while idle** - edit the persistent **scan list** (unchecked channels are never scanned)
- Channels the radio refuses to tune (see "Good to know" below) are skipped automatically with a notice
- Timing measured on the hardware: the module acks a channel write in ~0.1 s but needs ~0.9 s before its squelch can open, so the scanner listens 1.5 s per channel (~80 s for 48 channels). Soft SQ must be off while scanning.

### 📶 Live S-meter (new)

Device-tab toggle (off by default). Polls the module's RSSI once a second while idle and the screen is on, so the intercom's Signal box reads even with the squelch closed (noise floor ≈ -105 dBm on this unit, NOAA carrier -86 to -81).

### 📖 In-app help

The OEM **Use Assistant** page gained section 7, "DMR Mod features": every injected control, the Device-tab tools, and the radio limits that bite.

### 💾 Backups and import

- Each export now writes **`meta.json`** (area, time, app version) into the backup folder and zip
- **Import preview**: the confirm dialog lists rows per CSV, the backup's area and the current channel count
- Import **refuses** a backup from a different area, **aborts** if its automatic safety backup fails, refuses an empty `Channels.csv`, strips a UTF-8 BOM, and quotes/unquotes names with commas
- Export follows the **selected area** (was hard-coded to `default_uhf`)

### 🛠 Diagnostics (opt-in)

- Device-tab **Diagnostics** switch (default **off**): UART file logger + the `com.dmrmod.SEND_DEBUG_PACKET` receiver are inert until you turn it on
- **Read MCU channel images** - 0x24/0x25/0x39 readback of what the module really holds, decoded field by field
- **Probe RX audio layout** - measured the OEM audio stream as 8 kHz stereo with L == R; recordings are now true **8 kHz mono WAV** (half the size); captures under 1 s are dropped
- **Hook self-test** at startup: one log line, one toast if any hook failed to install

### 🧯 Robustness and correctness

- Serial reader: a frame split across two reads no longer kills the OEM reader thread for good; a watchdog restarts it if anything else does
- Soft SQ off restores the channel's **own** squelch level (was always 2); Soft SQ is re-applied when the module acks a foreign squelch write (Pitfall 13)
- Zone navigation now **wraps** at the zone ends and recovers when the module refuses a write
- Mode backups (APRS/SSTV/NOAA/VFO) are private JSON files, no longer serialized objects on `/sdcard`
- `channel_band` is bandwidth, not UHF/VHF: VFO has a Narrow/Wide selector, SSTV writes narrow, NOAA wide
- The `txContact` rewrite that could store a contact row id instead of the DMR ID (Pitfall 12) is gone
- Encrypt key field accepts hex `0-9 A-F`; three-digit channel numbers display; geocoder off the UI thread; 16 dead DSP files removed; 25 scratch files untracked

### Good to know

- A digital channel with **no Call Number** (TX contact) is refused by the radio module: the arrow keys show "operation failed" and the scanner skips it. The editor now warns when you save one.
- Squelch levels 1-9 behave as **one threshold** on this radio (on-air sweeps, 2026-10-14); 0 is always open.
- **Group-call receive follows the RX group list** (on-air, 2026-10-15): the radio passes a talkgroup only if it is one of the channel's 32 RX groups; the Call Number alone is not enough. Saving a digital GROUP channel now adds its Call Number to that list, and the caller panel / history show the talkgroup of each call.
- The MCU firmware is **C-SKY V2**, not ARM; disassembly tooling and findings are in `docs/grok-deep-dive/11-firmware-fw0-results.md`.

---

## What's New in v3.4.6 (June 21, 2026)

### TG List Import Fix

OpenGD77 codeplugs that use a **TG List** (not a named contact in the Contact column) were importing with `txContact=0` and `contactType=Private`, so digital channels would not TX until manually edited.

- **`DirectDatabaseImporter`** — When Contact/DMR ID resolve to 0, uses the **first TG ID** from the named TG List column (requires `TG_Lists.csv` imported before `Channels.csv`)
- Sets **Group (1)** contact type when a TX DMR ID is present but CSV left type as Private
- Looks up contact type from `contact_database` when the contact name is known

### Wide-Band Default (25 kHz)

New and imported analog channels now default to **wide band (25 kHz)** on both UHF and VHF.

- **`DirectDatabaseImporter` / `CSVImporter`** — Parse CSV bandwidth column (`25` / `12.5`); default to wide when empty (fixes old logic that treated UHF as narrow)
- **`DirectDatabaseExporter` / `CSVExporter`** — Export actual bandwidth (`12.5` or `25`) for analog channels
- **`MainHook`** — New in-app channels start at wide band via `ChannelData()` hook (Narrow still selectable in editor)

---

## What's New in v3.4.5 (June 16, 2026)

### 📻 RadioID.net Global DMR ID Lookup (major feature)

See the dedicated section above for full details. Shipped in v3.4.5:

- Offline global ID database (~300k IDs) with callsign, name, city, state, country
- Live caller panel + enriched DMR history on voice RX
- `RadioidDatabase.java` — separate from OEM contacts; codeplug always takes priority

### OpenGD77 CSV Import Fixes

- **Double-slot mode** — Digital channels import as **Double slot** (`channel_mode=4`) with outbound slot matched to the imported timeslot
- **Squelch default** — Empty, `None`, or `0%` squelch values default to **2** (normal) instead of wide-open **0**

### Bug Fixes

- Fixed crash (`BadTokenException`) when showing RadioID download progress dialog

---

## What's New in OpenGD77 CPS Fork v1.3.0 (June 5, 2026)

Desktop CPS fork ([OpenGD77CPS-Mac](https://github.com/IIMacGyverII/OpenGD77CPS-Mac)) — download zip from `OpenGD77Fork/` or [releases](https://github.com/IIMacGyverII/OpenGD77CPS-Mac/releases).

- **Pre-import diff preview** — Before Path B import, review channels that will be added, changed, or deleted vs the loaded codeplug; field-level changes (frequencies, contact, relay, lat/lon, etc.).
- **Apply / Cancel** — Cancel aborts without modifying the in-memory codeplug.
- Android backup manager shows diff summary counts when validating a phone export folder.

---

## What's New in v3.4.1 (June 5, 2026)

### CSVImporter Legacy Contact Fix (all 4 files complete)

The `BackupActivity` path uses the legacy `CSVImporter` class. Its `buildContactNameMap()` was querying the wrong table (`contact` instead of `contact_database`) and the wrong column (`_id` instead of `contact_number`), so contact name lookups always returned empty.

- Table: `contact` → `contact_database` (correct OEM table name)
- Column: `_id` → `contact_number` (24-bit DMR ID, consistent with all other files)
- All four export/import Java classes now correctly key contact maps by `contact_number`

---

## What's New in v3.4.0 (June 5, 2026)

### Pitfall 12 Fix — Contact DMR ID (all 4 export/import files)
`channel_txContact` stores the 24-bit DMR ID (`contact_number`), not the contact table `_id`. All four export/import files were keying contact maps by `_id`, causing contacts to resolve to the wrong person or default to "None"/contact 1 on import.

- **`DirectDatabaseExporter.java`, `CSVExporter.java`** — contact maps now keyed by `contact_number` (DMR ID); col 11 (DMR ID) now exports the actual DMR ID instead of hardcoded "None"
- **`DirectDatabaseImporter.java`** — map now name→DMR-ID; importer tries col 11 (DMR ID) first, falls back to name; default contact changed from `1` → `0`

### Channel Mode — Double-Slot Repeaters (field report #3)
CPS/OpenGD77 uses `channel_mode=3` for double-slot; the OEM firmware uses `4`. Import now maps 3→4 (shows "Double slot" in UI). Export maps 4→3 for correct CPS round-trips.

---

## What's New in v3.3.9 (June 5, 2026)

### OpenGD77 CPS Import Bug Fixes (field report)
- **Group/Private contacts swapped**: `DirectDatabaseImporter` had Group→0, Private→1; OEM uses 0=Private, 1=Group. Fixed in importer and exporter.
- **All DMR channels had encryption ON**: Legacy import branch defaulted `encryptSw=1`. Now defaults `2` (disabled). Parse-fail fallback also fixed.
- **Analog squelch parse failure**: Now defaults to `sq=2` (normal) instead of `sq=0`.
- **VERSION constant**: Startup toast now correctly shows v3.3.9.

---

## What's New in v3.3.8 (June 1, 2026)

### OpenGD77 CPS Fork v1.2.0
- Fixed Latitude, Longitude, and Use Location showing as 0 after Android CSV import
- Fixed startup crash (AccessViolationException) from lat/lon fields
- Fork identity: About dialog, window title, device tree root renamed for PriInterPhone

> **Note:** v3.3.8 release notes previously claimed "Contact ID Fix (Pitfall 12)" in all four Java files. That fix was not in the Java source — the actual Java fix shipped in **v3.4.0**.

---
## What's New in v3.3.7 (March 19, 2026)

### GPS Messaging over DMR SMS

**Send your GPS position as a DMR SMS with reverse-geocoded city/state; tap received GPS coordinates to open maps**

#### **Sending Your Position**
- **GPS POS button** (digital channels only): sends a formatted position message to the current contact
  - Format: `GPS:37.123456,-122.123456 acc:5m San Jose, CA`
  - Reverse geocoding runs on a background thread (no UI freeze)
  - Confirm dialog shows coordinates + accuracy before sending
  - "Don't ask again" checkbox persists preference to SharedPreferences

#### **Receiving GPS Coordinates**
- Any received DMR message containing GPS coordinates is automatically hyperlinked
- Tap the blue-underlined coordinates to open in maps app (fallback to browser)
- Supports all major radio vendor formats:
  - `GPS:lat,lon` / `Pos:lat,lon` / `Loc:lat,lon` (prefixed)
  - `Lat: N, Lon: W` (labeled)
  - `N37.123 E122.456` (directional)
  - Bare decimal pairs (e.g. `37.1234,-122.1234`)

#### **Message List UX**
- Single tap on GPS text → opens maps
- Long press → Copy / Delete / Clean All dialog (moved from single tap)
- Uses `BufferType.SPANNABLE` to ensure spans remain tappable after `setText()`

---

## What's New in v3.3.6 (March 19, 2026)

### TG List — Direct DB Write + Group Grid Refresh

**TG list assignment now writes TG IDs directly to `channel_groups` at save time; the native group grid at the bottom of the channel edit page refreshes immediately on selection**

#### **Architecture Change: No More Runtime Override**
- **Previous approach**: When a call started (`sendDigitalMessage`), a hook would intercept and overwrite `channelData.groups[]` from the TG list database at runtime — causing a dual-system conflict with the native firmware
- **New approach**: When the user saves a channel with a TG list assigned, `getHardwareGroups()` is called, written into `channelData.groups[]`, and `updateChannel()` flushes it to the channel database immediately
- **Result**: The native radio firmware reads the correct TG IDs directly from `channel_groups` — no runtime interception needed; no conflict

#### **Group Grid Live Refresh**
- Selecting a TG list in the channel editor now immediately updates the native `interphone_channel_group_grid` (4-column GridView at the bottom of the edit page) to show the new TG IDs
- Empty slots display `0` (matching native behavior) instead of blank
- The grid also refreshes after editing a TG list's contents in the editor dialog

---

## What's New in v3.3.5 (March 19, 2026)

### NOAA APT — Software Squelch Slider Added to Live Monitoring Screen

**Full software squelch control (toggle + slider) is now available on the NOAA APT live monitoring screen, matching the SSTV and APRS experience**

#### **Software Squelch Toggle + Slider**
- **🔊 Soft SQ toggle button** — shown on the NOAA live monitoring screen below the satellite info text
  - Green when ON, gray when OFF; initialized from current software squelch state
  - Enabling calls `enableSoftwareSquelchOnCurrentChannel()` + a 2.5s delayed re-apply to survive late channel state-machine updates
  - Disabling calls `disableSoftwareSquelchOnCurrentChannel()` to restore hardware squelch
- **Squelch slider** (0–9) — visible only when soft SQ is ON
  - "SQ:" label + green live value display + SeekBar (black tint, 0–9)
  - Adjusting updates `softwareSquelchThreshold` immediately (shared with APRS/SSTV)
  - Toast on release: "Software Squelch: N"
- Info text when ON: "Hybrid RSSI + Audio RMS squelch — 0=most sensitive, 9=least sensitive"
- **Auto-disable on stop**: Stopping NOAA monitoring disables soft SQ if active, preventing bleed onto the restored channel

#### **Hardware Squelch Note**
- Hardware squelch is set to `sq=2` during NOAA monitoring (same as SSTV)
- `sq=0` kills audio on this hardware — software squelch is the correct approach for open-squelch satellite monitoring
- The software squelch layer uses hybrid RSSI + audio RMS (identical to APRS/SSTV implementation)

---

## What's New in v3.3.4 (March 19, 2026)

### NOAA APT Satellite Image Reception — Live Monitoring

**Receive and decode NOAA weather satellite APT transmissions in real-time, with live image display, automatic saving, and pass prediction**

#### **NOAA Button and Live Screen**
- **🛰️ NOAA Toggle Button**: New slate-blue button on intercom page
  - Opens live monitoring screen with real-time image decode
  - Mutually exclusive with APRS, SSTV, and VFO modes
- **Live Monitoring Screen**:
  - Real-time APT image decode with live bitmap display (square preview box)
  - Timer showing elapsed decode time from first decoded line
  - Progress: decoded line count + approximate seconds elapsed
  - Color mode cycling: Gray → Thermal IR → Color (MSA)
  - Auto-updates every 2 seconds

#### **APT Decoding**
- **Sync detection**: Frame sync pattern matching locks onto the 2400 Hz sync tone
- **Line-by-line decode**: Standard 2080 samples-per-line APT format
- **Color modes**: Grayscale, thermal IR color map, and NOAA MSA false-color palette
- **Dual-channel image**: Left = Channel A (visible/near-IR), Right = Channel B (thermal IR)

#### **Image Handling**
- **Auto-Save**: Completed images saved to `/sdcard/Download/DMR/NOAA/`
  - Filename format: `NOAA_YYYYMMDD_HHmmss.png`
  - Periodic auto-save every 300 decoded lines (~5 min) prevents data loss
- **Save Now** button: Force-save current partial image at any time
- **Saved Images browser**: Browse and tap to open any saved NOAA image

#### **Pass Prediction**
- Built-in pass predictor on the NOAA settings dialog
  - Shows next visible passes for NOAA-15, NOAA-18, NOAA-19
  - AOS/LOS times, max elevation, and color-coded quality
- Uses simplified SGP4-like orbital mechanics (no external library dependency)

#### **Settings**
- Configurable receive frequency (default `137.100 MHz`)
  - Common frequencies: NOAA-15 137.620, NOAA-18 137.9125, NOAA-19 137.100 MHz
- Frequency persisted via SharedPreferences across sessions

#### **Channel Backup and Restore**
- Full channel backup before hijacking to NOAA frequency
- Automatic restoration on stop (same pattern as SSTV/APRS/VFO)
- Crash-recovery dialog on next app start if restore did not complete

---
## What's New in v3.3.3 (March 18, 2026)

### SSTV Settings & Received Images Dialogs + Dialog Refresh Fix

**Added configurable SSTV settings (frequency with VHF/UHF support), a received images browser, and fixed stale-data dialogs for both SSTV and APRS**

#### **SSTV Settings Dialog**
- New **⚙️ SSTV Settings** button on both the SSTV start dialog and SSTV live monitoring screen
- Configure SSTV frequency (supports both **VHF 136–174 MHz** and **UHF 400–520 MHz**)
- Default frequency: `144.500 MHz` (persisted across sessions via SharedPreferences)
- Frequency validated to prevent out-of-range entry
- Hint text updated to show both VHF (`144.500`) and UHF (`432.500`) examples

#### **SSTV Received Images Dialog**
- New **📸 SSTV Received** button on both the SSTV start dialog and live monitoring screen
- Lists all saved SSTV images from `Download/DMR/SSTV/`, sorted newest-first
- Tap any entry to open in the device gallery app
- Shows "no images yet" placeholder when folder is empty

#### **Dialog Refresh Fix (SSTV + APRS)**
- **Problem**: Opening Settings from a start dialog, saving a new frequency, then returning showed the old value — the start dialog was built once and never refreshed
- **Fix**: Both **SSTV** and **APRS** start dialogs now use a holder+callback pattern
  - When Settings is opened from a start dialog, saving dismisses the stale start dialog and reopens it fresh
  - The newly opened dialog reads the latest saved values from SharedPreferences / APRSDatabase
  - Live monitoring screens are unaffected (they auto-refresh via their periodic handler)

---

## What's New in v3.3.2 (March 19, 2026)

### APRS Received + APRS Settings Buttons Moved to Monitoring Page

**Relocated the `📡 APRS Received` and `⚙️ APRS Settings` buttons from the general settings/channels page directly onto the APRS Monitoring Mode dialogs for better contextual access**

#### **What Changed**
- **Removed** both buttons from the general Export/Import settings page
- **Added** both buttons to the **APRS Start Dialog** (before monitoring starts) — displayed below the packet statistics and logging note, above the Start/Close buttons
- **Added** both buttons to the **APRS Live Monitoring Screen** (while monitoring is active) — displayed below the auto-logging info footer
- A subtle visual divider separates the action buttons from the informational text on each screen

#### **Why This Improves the UX**
- `📡 APRS Received` and `⚙️ APRS Settings` are APRS-specific — they belong on the APRS page, not alongside Export/Import
- Users no longer need to leave the APRS flow to check received stations or adjust settings
- Both buttons accessible at all times during the APRS workflow: before starting and while actively monitoring

---

## What's New in v3.3.1 (March 18, 2026)

### Crash Recovery Improvements — Restart App Button + Channel Name Fix

**Hardened crash recovery for APRS, SSTV, and VFO modes with a proper Restart App button and a data-integrity fix**

#### **Crash Recovery Dialog — Restart App Button**
- All three recovery dialogs (APRS, SSTV, VFO) now show a **"Restart App"** button instead of plain "OK"
  - Tap to immediately restart the app for a clean state after channel restore
  - Dialog is non-cancellable so users can't accidentally dismiss it
  - VFO dialog upgraded to use `Handler(Looper.getMainLooper())` and activity validity check (consistent with APRS/SSTV)

#### **Channel Name Integrity Fix**
- **Bug fixed**: Backup functions were stripping `APRS (`, `SSTV (`, or `VFO-` prefixes from channel names before saving
  - Impact: A channel legitimately named `"APRS (local)"`, `"SSTV transmit"`, or `"VFO-Station"` would have its name mangled in the backup and restore incorrectly
  - Root cause: Defensive stripping was added in a prior session as a guard against double-nesting, but was applied unconditionally — not just when the name was already hijacked
  - Fix: Removed all stripping. The backup is always saved **before** the name hijack, so the live channel name is always clean at save time — no stripping was ever needed
- Affects `saveChannelBackup` (APRS), `saveSSTVChannelBackup`, `saveVFOChannelBackup`, `restoreSSTVChannelBackup`, `restoreVFOChannelBackup`, `checkAndRestoreAPRSChannelOnStartup`, `checkAndRestoreSSTVChannelOnStartup`, `checkAndRestoreVFOChannelOnStartup`

---

## What's New in v3.3.0 (March 18, 2026)

### SSTV Live Monitoring - Slow Scan TV Image Reception

**Receive and decode SSTV transmissions in real-time directly on the radio, with automatic image saving and live display**

#### **SSTV Button & Live Screen**
- **📺 SSTV Toggle Button**: New teal/cyan button on intercom page
  - Opens live monitoring screen with real-time decode display
  - Teal when active, light teal when inactive
  - Mutually exclusive with APRS and VFO modes
- **📸 Live Monitoring Screen**:
  - Real-time decode status and progress
  - Displays mode, line count, and estimated completion
  - Auto-updates every 2 seconds
  - Images saved automatically on completion

#### **Detection & Decoding**
- **🎯 VIS Tone Detection**: Goertzel algorithm detects the 300ms VIS header tone
  - Identifies all standard SSTV modes (Scottie S1/S2, Martin M1/M2, Robot 36/72, PD 90/120/160/180, etc.)
  - Runs in background thread — zero impact on audio playback
- **🔍 IQ Auto-Detect**: Blind SSTV mode detection without VIS tone
  - Analyzes spectral content to identify active transmissions
  - Warmup schedule (3/5/8/12/16s) then every 5s
- **⚡ Background Thread Architecture**: All Phase 1 detection runs off the audio write thread
  - Audio write thread stays under 2ms per call — no buffering delay
  - Eliminated prior 30+ second audio delay from open-squelch sessions

#### **Image Handling**
- **💾 Auto-Save**: Every decoded image saved to `/sdcard/Download/DMR/SSTV/`
  - Filename format: `SSTV_YYYYMMDD_HHmmss_MODE.jpg`
  - JPEG quality 95 for archival fidelity
- **📋 Session History**: Last 10 received images listed on monitoring screen
  - Tap any entry to open in gallery
  - Shows mode, timestamp, and decode quality
- **🔄 12-second backlog**: Pre-roll feeds up to 12s of buffered audio into decoder
  - Prevents top-of-image cutoff even when VIS is detected mid-stream
  - 1-second pre-roll before VIS start sample for header margin

#### **False Positive Guards**
- **🛡️ Multi-stage validation**: Cross-family checks, leader purity, vote fraction guards
  - Prevents random noise from triggering decode attempts
  - CV (coefficient-of-variation) guard on VIS code confidence
- **⚠️ Open-squelch tip**: Info note on monitoring screen about false positive risk
  - Recommends software squelch for cleaner detection

#### **Software Squelch Integration**
- Independent soft-squelch toggle on SSTV monitoring screen
- 2.5-second delayed re-apply prevents race with `syncChannelInfoWithData` state machine
  - Ensures squelch stays open even when channel state machine fires after start
- Pre-squelch audio still fed to decoder and recorder (squelch only gates speaker)

#### **Technical Details**
- **Sample rate**: 16 kHz, 16-bit mono PCM (matches radio audio pipeline)
- **Buffer**: Up to 1 MB (~32s) ring buffer with `DirectBAOS` (zero-alloc inner class)
- **Pre-allocated work buffers**: 2s VIS buffer + 16s auto-detect buffer (no GC pressure)
- **Goertzel VIS scan**: Every 250ms on background thread, < 1ms each
- **IQ auto-detect**: Every 5s steady-state, ~ 50ms each — fully off write thread
- **`imageStartSample` fix**: Auto-detect path correctly anchors start to analyzed window
  - Prevents full-image decode from defaulting to buffer start (which caused top cutoff)

#### **Usage**
1. **Intercom page** → Tap **SSTV** button (teal, beside APRS)
2. Tap **Start Monitoring** on the SSTV live screen
3. The module listens for VIS tones or auto-detects SSTV transmissions
4. When a signal is found, decoding begins automatically with progress display
5. Completed image is saved to `/sdcard/Download/DMR/SSTV/` and shown on screen
6. Tap **Stop Monitoring** to return to normal intercom operation

#### **Compatible SSTV Modes**
- Scottie S1, S2, DX
- Martin M1, M2
- Robot 36, 72
- PD 90, 120, 160, 180, 240
- Wraase SC2-120, SC2-180

---

## What's New in v3.1.5 (March 14, 2026)

### VFO Mode - Variable Frequency Oscillator

**Complete frequency control with temporary channel override for quick QSOs without saving channels**

#### **VFO Button & Dialog**
- **🎛️ VFO Toggle Button**: New orange button on intercom page (bottom-left, below TXT)
  - Orange when active, light orange when inactive
  - Opens comprehensive tuning dialog with all channel parameters
  - Temporarily hijacks current channel (restores on exit)
- **📻 Full Control Dialog**: Complete channel configuration without database changes
  - **Channel Mode**: Analog or Digital/DMR with mode-specific controls
  - **Frequency**: Numeric input with validation (136-174 MHz, 400-480 MHz)
  - **Power Level**: Low (1W) or High (5W) selection
  - **Tone Settings** (Analog): RX/TX tone type (None/CTCSS/DCS) and code selection
  - **Bandwidth** (Analog): 12.5 kHz or 25 kHz
  - **DMR Settings** (Digital): Contact type, TalkGroup ID, Color Code (0-15), Timeslot
  - **DMR ID Override**: Temporary local ID that persists across VFO sessions
  - **Apply Settings**: Instantly sends configuration to hardware via AnalogMessage/DigitalMessage
- **🔄 Automatic Restoration**: Original channel settings restored when exiting VFO mode
  - Backup system preserves all fields (frequency, tones, squelch, power, DMR settings)
  - Software squelch automatically disabled during VFO (if enabled on main channel)
  - Button state synchronized with VFO mode status

#### **Key Features**
- **✨ No Channel Creation**: Tune to any frequency without cluttering channel list
- **🎯 Quick QSO Mode**: Perfect for simplex contacts, contests, or emergency frequencies
- **💾 Non-Persistent**: All changes temporary until VFO mode exits
- **🔧 Hardware Verified**: All settings tested and confirmed working
  - Analog: Frequency, power, bandwidth, RX/TX tones all functional
  - Digital: Frequency, Color Code, DMR ID, contact type, TG, slot all functional
- **🔄 DMR ID Persistence**: Temporary DMR ID persists across VFO close/reopen (until app restart)
  - Allows testing different DMR IDs without changing system settings
  - Stored in vfoLocalId variable (independent of system DMR ID)
  - Defaults to ID 1 if not specified

#### **Critical Bug Fixes**
- **Fixed: Color Code field name** (`cc` not `colorCode`)
  - Previous bug: Color Code always transmitted as 0 regardless of UI setting
  - Impact: Unable to communicate on networks with non-zero Color Codes
  - Solution: Use correct ChannelData field name "cc"
- **Fixed: VFO reactivation logic**
  - Previous bug: Reopening VFO dialog after exit didn't send settings to hardware
  - Impact: Apply Settings button appeared to do nothing on second open
  - Solution: Check `isVFOModeActive` flag and reinitialize VFO state if needed
- **Fixed: Conflicting hardware updates**
  - Previous bug: `dmrManager.updateChannel()` was overriding `DigitalMessage.send()`
  - Impact: Settings sent via DigitalMessage were immediately overwritten
  - Solution: Removed redundant updateChannel() call, rely on direct message send
- **Fixed: DMR ID field handling**
  - Previous bug: Tried to read non-existent `localId` field from ChannelData
  - Impact: NoSuchFieldError crash when using VFO on digital channels
  - Solution: Use vfoLocalId variable directly, defaults to 1 if not set

#### **Technical Implementation**
- **Direct Hardware Control**: Uses AnalogMessage.send() and DigitalMessage.send()
  - Bypasses database and state machine for instant hardware updates
  - Same reliable pattern as MON button and APRS monitoring
- **State Management**: isVFOModeActive flag prevents conflicts with normal operations
  - VFO and APRS are mutually exclusive (can't run both simultaneously)
  - Software squelch disabled during VFO to avoid interference
- **Field Validation**: All inputs validated before sending to hardware
  - Frequency: Checked against radio's supported bands
  - Color Code: Range 0-15 enforced
  - DMR ID: Positive integer validation
  - TalkGroup: Positive integer validation

#### **Usage**
1. **Intercom page** → Tap **VFO** button (orange, bottom-left)
2. **Configure settings** in dialog:
   - Select Analog or Digital mode
   - Enter frequency (e.g., 146.520 for 2m simplex)
   - Set power level, tones/DMR settings as needed
   - Optionally override DMR ID for testing
3. Tap **Apply Settings** → Settings sent to hardware immediately
4. Use radio normally with VFO frequency
5. Tap **Stop VFO** or VFO button again → Original channel restored

#### **Use Cases**
- **Simplex Contacts**: Quick frequency entry for direct contacts
- **Contest Operation**: Rapidly tune to contest frequencies
- **Emergency Communications**: Access emergency frequencies without preset channels
- **DMR Testing**: Try different Color Codes, TalkGroups, or IDs without channel edits
- **Repeater Exploration**: Test repeater frequencies before adding to channel list
- **Travel Mode**: Tune to local frequencies in unfamiliar areas

---

## What's New in v3.1.4 (March 13, 2026)

### Critical Software Squelch State Fix

**Fixed bug where software squelch remained active after stopping APRS monitoring**

#### **Bug Fixed**
- **🔧 Squelch State Clearing**: Software squelch flags now properly cleared when exiting APRS mode
  - Previously: `isSoftwareSquelchEnabled` and `isAprsSoftwareSquelchEnabled` stayed `true` after stopping APRS
  - Result: Audio remained blocked even though UI showed Soft SQ as OFF
  - Impact: Users couldn't hear audio on intercom after using APRS with Soft SQ enabled
- **✅ Proper State Reset**: Both flags explicitly set to `false` in `stopAPRSMonitoring()`
  - Ensures audio processing allows playback when returning to intercom
  - UI state now matches internal flag state
  - No more "ghost squelch" blocking audio

#### **User Impact**
- **Before**: Enable Soft SQ in APRS → Stop APRS → Return to intercom with no audio
- **After**: Squelch properly disabled when exiting APRS, audio works immediately
- **Reliability**: State flags and UI now stay synchronized across mode transitions

---

## What's New in v3.1.3 (March 13, 2026)

### Software Squelch UI Enhancements & APRS Toggle

**Complete UI overhaul for software squelch control + APRS monitoring improvements**

#### **Intercom Page Enhancements**
- **✨ Soft SQ Toggle Button**: Control software squelch on/off
  - Light blue when OFF (hardware squelch mode)
  - Blue when ON (software squelch enabled)
  - Shows/hides slider based on toggle state
  - OFF: Hardware squelch set to 2 (default)
  - ON: Hardware squelch set to 0, software takes over
- **⚡ Performance Optimization**: Slider no longer spams hardware during drag
  - Hardware squelch only applied on release (onStopTrackingTouch)
  - Toast notification only on release (no more spam)
  - Smooth dragging without lag or repeated writes
- **🎨 Button Visual Improvements**: All toggle buttons use light-colored OFF states
  - TXT button: Light purple → Purple
  - Soft SQ button: Light blue → Blue
  - REC button: Light red → Red
  - MON button: Light orange → Orange
  - APRS button: Light green → Green
- **🔘 APRS Button Enhancement**: Converted to ToggleButton with state management
  - Auto-toggles with monitoring state
  - Unchecks when closing monitoring dialog
  - Proper state sync across app lifecycle
- **📏 UI Spacing Refinements**:
  - Slider track now colored full width (white on intercom, black on APRS)
  - Reduced spacing between SQ: label and value display
  - Tighter spacing above squelch controls
  - Vertical spacing added between SQ: label and slider (4dp)

#### **APRS Monitoring Page Enhancements**
- **✨ Soft SQ Toggle**: Independent software squelch control for APRS
  - Works identically to intercom page toggle
  - Light blue when OFF, blue when ON
  - Shows/hides slider and info text
  - OFF: Uses hardware squelch (level 2)
  - ON: Enables hybrid RSSI + Audio RMS squelch
- **🔧 Independent Control**: APRS and intercom squelch settings are separate
  - Each page has its own toggle state
  - Each can use software or hardware squelch independently
  - Squelch levels saved separately in preferences

#### **Technical Details**
- Software squelch disabled by default on both pages (user opt-in)
- Toggle states: `isSoftwareSquelchEnabled` (intercom), `isAprsSoftwareSquelchEnabled` (APRS)
- Hardware squelch control via direct `AnalogMessage.send()` calls
- UI updates optimized to reduce redundant hardware writes
- Full-width slider track using `setProgressBackgroundTintList()`

---

## What's New in v3.1.2 (March 13, 2026)

### APRS Channel Recovery & Squelch Control Improvements

**Automatic crash recovery with user guidance + hardware-aware squelch control**

#### **Crash Recovery System**
- **Automatic channel restoration** when app closes during APRS monitoring
- **AlertDialog notification** explains what happened and how to prevent future issues
- **Complete field restoration** including frequency, squelch, and all metadata
- **Comprehensive logging** for debugging crash recovery scenarios

**How It Works:**
1. Module detects orphaned APRS channel on app startup
2. Automatically restores original channel settings from backup file
3. Shows informative dialog with prevention guidance
4. Prompts to restart the app for clean state

**Backup System:**
- File: `/sdcard/aprs_channel_backup.dat`
- Saves: number, type, name, frequencies, squelch, band, power, rx/tx settings
- Auto-deletes after successful restore

#### **Squelch Control - Hardware Limitation Documentation**

**⚠️ IMPORTANT: Ulefone Armor 26 Ultra Hardware Limitation**

The radio hardware has a unique quirk that affects squelch control:
- **Only sq=0 (open) and sq=2 work reliably**
- **sq=1, sq=3-9 are forced to sq=2 by the hardware**
- This is a **hardware/firmware limitation**, not a software bug

**Impact on Design:**
- No squelch slider needed - hardware only supports two states
- **Open Squelch button** toggles between sq=0 (fully open) and sq=2 (tight)
- Button shows **green** when squelch is open (sq=0)
- Button shows **gray** when squelch is closed (sq=2)
- Button state persists across UI refreshes (monitoring page updates every 2 seconds)

**Why This Matters:**
- Previous attempts at granular squelch control (0-9 slider) were fighting hardware
- New design works **with** the hardware limitation instead of against it
- Provides predictable, reliable squelch behavior

**Technical Details:**
- Direct hardware control via `AnalogMessage.send()`
- Persistent static state variables survive UI refreshes
- Works identically to MON button pattern
- No database updates needed (direct UART communication)

---

## What's New in v3.1.1 (March 12, 2026)

### Critical APRS Bug Fixes

**Reliability improvements for APRS monitoring after crashes and fresh storage**

- **Fixed: Fresh Storage Issue**
  - APRS monitoring now works correctly after clearing app storage
  - Uses in-memory channel hijacking instead of database queries
  - No more ClassNotFoundException errors
- **Fixed: Crash Recovery**
  - Channel automatically restored after force-close during monitoring
  - File-based backup at `/sdcard/aprs_channel_backup.dat`
  - Detects orphaned APRS channels and restores original within 2 seconds
- **Fixed: Static Variable Persistence**
  - State properly resets on every app launch
  - Fixed Xposed module lifecycle issue (static vars persist across app restarts)
  - Resets `isAPRSMonitoringActive`, dialog references, and audio buffer
- **Fixed: APRS Button After Crash**
  - APRS button works correctly after crash recovery
  - Monitoring dialog displays properly after app restart
  - No more phantom audio buffering
- **Fixed: Dialog State Issues**
  - Dialog references now reset on app launch
  - Live monitoring screen appears correctly on restart

---

## 📡 APRS Live Monitoring (v3.1.0)

### Real-time APRS packet reception with live dashboard and clickable map links

- **APRS Button** on intercom page (green button below MON)
- **Live Monitoring Dashboard**:
  - Persistent screen that stays open during monitoring
  - Auto-updates every 2 seconds with new packets
  - Real-time statistics (total stations, last hour, last 5 minutes)
  - Shows up to 10 most recent packets
- **Clickable Station Links**:
  - Tap any station to open Google Maps at GPS location
  - Shows callsign, time received, and coordinates
  - Underlined cyan text indicates clickable links
- **Automatic Channel Creation**:
  - Creates hidden APRS channel automatically on first use
  - Uses frequency from APRS Settings (default: 144.390 MHz)
  - Channel hidden from UI but accessible for monitoring
- **Auto-Logging**:
  - Per-callsign text logs (append mode): `Download/DMR/APRS/CALLSIGN-SSID.txt`
  - Per-callsign GPX tracks (full movement history): `Download/DMR/APRS/CALLSIGN-SSID.gpx`
  - Full packet history in database for track visualization
- **APRS Settings Dialog**:
  - Configure callsign, SSID, and frequency
  - Access via APRS Received page or Settings
- **Channel Management**:
  - Saves previous channel and returns on stop
  - Works from both analog and digital channels
  - No manual channel creation needed

**Usage**: 
1. Intercom page → Tap APRS button (green, below MON)
2. Configure settings if needed (callsign optional for RX-only)
3. Tap "Start Monitoring" → Live dashboard appears
4. Tap any received station → Opens in Google Maps
5. Tap "Stop Monitoring" → Returns to previous channel

**Technical Details**:
- Pure RX-only operation (no transmit capability)
- Uses device's analog FM receiver tuned to APRS frequency
- Bell 202 AFSK 1200 baud decoding (AX.25 protocol)
- APRS channels automatically filtered from channel list
- Database stores full transmission history per station

## What's New in v3.0.9 (March 9, 2026)

### 🧭 GPS Distance Display Enhancements

**Directional arrows, compass bearings, and dual distance units for better situational awareness**

- **8-direction compass arrows**: ↑N, ↗NE, →E, ↘SE, ↓S, ↙SW, ←W, ↖NW
- Shows direction from your location to the channel
- Real-time bearing calculation using GPS coordinates
- **Dual distance display**: 
  - < 1km: Meters only (e.g., `↑N 250m`)
  - 1-10km: Kilometers (e.g., `→E 5.2km`)
  - > 10km: Miles + kilometers (e.g., `↘SE 96.7mi (155.6km)`)
- Improved UI layout: Widened location area from 30% to 40% width to prevent text wrapping
- No internet required (uses device location only)

**Display Examples**:
```
Echo, Minnesota (↘SE 96.7mi (155.6km))
320m (1050ft) 📍

Chicago Rptr (↗NE 5.2km)
180m (590ft) 📍

Local Simplex (↑N 250m)
210m (689ft) 📍
```

## What's New in v3.0.8 (March 9, 2026)

### 🎛️ Zone Management & Channel Edit Zone Selector

**Create, edit, and assign zones directly from the app!**

- **Zone row in channel edit screen** - Assign channels to zones while editing
- **Create new zones** - Tap "Create New Zone..." at bottom of zone list
- **Edit zone names** - Pencil icon (✏) next to each zone or long-press to rename
- **Automatic list refresh** - Channel list updates instantly after zone changes
- **Technical improvements**:
  - Fixed critical hook stacking bug (zone assignments now persistent)
  - Proper instance field management
  - Singleton database pattern
  - OpenGD77 Zones.csv import/export fully supported

**Usage**: Channel page → Edit channel → Tap Zone row → Select/Create/Rename zones

## What's New in v3.0.5 (March 9, 2026)

### 📂 Channel Zones

**Organize channels into zones (like folders)**

- **ZONE button** on main screen (below MON button)
- Import/export zones via OpenGD77 Zones.csv format
- Zone-based channel navigation (arrows filter by active zone)
- Up to 80 channels per zone (OpenGD77 limit)
- Zones stored in local database (persistent)

## What's New in v3.0.4 (March 9, 2026)

### 📍 GPS Distance Calculation

- Real-time distance from your location to channel coordinates
- Smart distance formatting (meters/kilometers/miles based on range)
- Uses device GPS/network location
- No internet required

## What's New in v3.0.3 (March 9, 2026)

### 🐛 Critical Bug Fix

- **DMR Audio Fixed**: Resolved silent receive audio and garbled transmit audio
- Call type override logic now only active during MON mode

## What's New in v3.0.2 (March 9, 2026)

### 🆕 Major Features

1. **Analog MON (Monitor) Button** ⭐
   - Squelch fully open (sq=0) for continuous monitoring
   - Visual feedback: Orange = monitoring, Gray = normal
   - Perfect for scanning and emergency monitoring

## Complete Feature List (v1.0 - v3.3.2)

### Core Features
- ✅ **APRS Button Reorganization (v3.3.2)** - APRS Received + Settings buttons moved to monitoring page
- ✅ **Crash Recovery Improvements (v3.3.1)** - Restart App button, channel name integrity fix
- ✅ **SSTV Live Monitoring (v3.3.0)** - Slow Scan TV image reception with auto-save and live display
- ✅ **VFO Mode (v3.1.5)** - Variable Frequency Oscillator with temporary channel override
- ✅ **APRS Live Monitoring (v3.1.0-v3.1.4)** - Real-time packet reception with dashboard and maps
- ✅ **OpenGD77 CSV export/import** - All 5 files (Channels, Contacts, TG_Lists, Zones, DTMF)
- ✅ **Zone management** - Create, edit, assign zones to channels from channel edit page
- ✅ **GPS navigation** - Distance, direction, bearing to channels
- ✅ **Location tracking** - Reverse geocoding, city/state display, elevation
- ✅ **RSSI signal strength** indicator
- ✅ **DMR activity history** with timestamps
- ✅ **Contact integration** - Caller ID display
- ✅ **Analog MON button** - Open squelch for continuous monitoring
- ✅ **Software Squelch** - Hybrid RSSI + Audio RMS squelch with UI controls

### SSTV Monitoring Features (v3.3.0)
- ✅ **VIS tone detection** - Goertzel algorithm identifies all standard SSTV modes
- ✅ **IQ auto-detect** - Blind detection without VIS for partial transmissions
- ✅ **Auto-save images** - JPEG to `/sdcard/Download/DMR/SSTV/` on every decode
- ✅ **12-second pre-roll backlog** - No top-of-image cutoff
- ✅ **False positive guards** - Multi-stage validation prevents noise triggers
- ✅ **Background thread decoding** - Zero audio playback delay
- ✅ **Software squelch integration** - Independent squelch control with race-condition fix
- ✅ **All major SSTV modes** - Scottie, Martin, Robot, PD, Wraase

### VFO Mode Features (v3.1.5)
- ✅ **Temporary frequency tuning** without saving channels
- ✅ **Analog & Digital/DMR support** with mode-specific controls
- ✅ **Full parameter control** - Frequency, power, tones, bandwidth, DMR settings
- ✅ **DMR ID override** - Test different DMR IDs without changing system settings
- ✅ **Automatic channel restoration** on exit
- ✅ **Direct hardware communication** - Instant settings application
- ✅ **Reactivation support** - Reopen and adjust settings without restart

### Transcription Features (v1.2 - v1.7.0)
- ✅ **Real-time speech-to-text** using Google Cloud Speech-to-Text API
- ✅ **Automatic audio recording** organized by channel
- ✅ **Per-channel transcription history** (last 3-10 messages)
- ✅ **Daily transcription logs** with timestamps and DMR IDs
- ✅ **User-friendly API key configuration**

## What is this?

LSPosed module for the Ulefone PriInterPhone DMR radio app that adds:
- **📻 RadioID.net Caller Lookup** - Resolve unknown RX DMR IDs to callsign, name & location (~300k IDs, offline after download)
- **📺 SSTV Live Monitoring** - Receive and decode Slow Scan TV images over the air
- **🎛️ VFO Mode** - Variable Frequency Oscillator for temporary frequency tuning
- **📡 APRS Live Monitoring** - Real-time packet reception with live dashboard and GPS mapping
- **🧭 GPS Navigation** - Directional arrows, compass bearings, distance to channels
- **📂 Zone Management** - Create, edit, assign channels to zones (folder organization)
- **📤 OpenGD77 CSV Export** - Export all channels/contacts to OpenGD77-compatible CSV files
- **📥 OpenGD77 CSV Import** - Import OpenGD77 codeplugs directly into the app
- **🔄 Cross-platform programming** - Edit channels in OpenGD77 CPS, import to phone
- **🗂️ Easy access** - Backups saved to Download folder (easy file transfer)
- **⚡ Direct database access** - No shell commands, fast and reliable
- **🔒 No APK modification** - Works via runtime hooks (preserves platform signature)
- **🎙️ Real-time Transcription** - Live speech-to-text powered by Google Cloud Speech-to-Text
- **📝 Automatic Logging** - Daily transcription logs organized by channel with timestamps

## Current Status ✅

**Current Release: v3.4.6** (June 21, 2026)  
**📻 RadioID.net Caller Lookup**: ✅ **Major feature** — global DMR ID → callsign/name/location; live caller panel + history (v3.4.5+)  
**TG List Import**: ✅ Fixed — TG-list codeplugs get valid TX contact + Group type on import (v3.4.6)  
**Wide-Band Default**: ✅ Fixed — new/imported channels default to 25 kHz (UHF and VHF) (v3.4.6)  
**Contact DMR ID (Pitfall 12)**: ✅ Fixed — all 4 export/import files key contacts by DMR ID, not row _id  
**Channel Mode (double-slot)**: ✅ Fixed — digital imports use OEM `4` ("Double slot") (v3.4.5)
**Contact Type (Group/Private)**: ✅ Fixed — no longer swapped on stock CPS import (v3.3.9)  
**Encrypt Default**: ✅ Fixed — DMR channels no longer import with encryption ON (v3.3.9)
**GPS Messaging**: ✅ Send position over DMR SMS with reverse geocoding + confirm dialog  
**GPS Hyperlinks**: ✅ Tap received GPS coordinates to open maps (multi-format pattern)  
**APRS UX**: ✅ APRS Received + Settings buttons moved to monitoring page  
**Crash Recovery**: ✅ Improved — Restart App button on all recovery dialogs, channel name integrity fix  
**SSTV Monitoring**: ✅ Working - VIS detection + IQ auto-detect, auto-save images, all major modes  
**VFO Mode**: ✅ Working - Complete frequency control with analog/digital support  
**APRS Monitoring**: ✅ Working - Live dashboard with GPS mapping and auto-logging  
**GPS Navigation**: ✅ Working - Directional arrows, compass bearings, distance (m/km/mi)  
**Zone Management**: ✅ Working - Create, edit, assign zones from channel edit page  
**Export**: ✅ Working - All 5 OpenGD77 CSV files + PDF summary + Zones.csv  
**Import**: ✅ Working - Full Digital & Analog support + Zones import  
**Transcription**: ✅ Working - Real-time speech-to-text with Google Cloud Speech-to-Text  
**Audio Recording**: ✅ Working - Automatic WAV recording organized by channel  
**Per-Channel History**: ✅ Working - Transcription messages persist per channel  
**Timestamps**: ✅ Working - All messages include HH:mm:ss timestamps  
**Analog MON Button**: ✅ Working - Open squelch for continuous monitoring  
**Software Squelch**: ✅ Working - Hybrid RSSI + Audio RMS squelch with UI controls  
**User Validation**: ✅ All features tested and confirmed working  
**Latest Build**: June 21, 2026

## Radio Firmware

The DMR radio module uses ARM Cortex-M firmware that handles all radio protocol operations. The original factory firmware is preserved in this repository for reference and patching experiments.

**Firmware Location**: `radio_firmware/`

- **DMR003.UV4T.V022-ORIGINAL.bin** - Factory firmware (378,620 bytes)
  - MD5: `4426035392262CA54583C230C9E268E0`
  - Base address: `0x08000000` (STM32/GD32 flash memory)
  - Architecture: ARM Cortex-M Thumb mode (mixed 16/32-bit instructions)
  - RTOS: uC/OS-III (Micrium)

**Testing Modified Firmware Safely**:

The app checks for custom firmware in `/sdcard/DMR/DMRDEBUG.bin` on startup. If found, it transfers this firmware to the radio module via YModem protocol (~2 minutes). This allows safe testing of modified firmware without permanent flashing.

```powershell
# Deploy custom firmware for testing
adb push modified_firmware.bin /sdcard/DMR/DMRDEBUG.bin

# Restart app to trigger firmware update
adb shell am force-stop com.pri.prizeinterphone

# Remove test firmware to restore original
adb shell rm /sdcard/DMR/DMRDEBUG.bin
```

**Current Firmware Reverse Engineering Status**: See [NOTES_FOR_GROK.md](NOTES_FOR_GROK.md) for ongoing work to fix the Monitor Mode (RECEIVE_ALL) group ID extraction bug.

### Quick Facts

- **Module**: com.dmrmod.hooks (LSPosed Xposed module)
- **Target App**: com.pri.prizeinterphone (Ulefone system app)
- **Transcription**: in-process Google Cloud Speech-to-Text (built into the module; no separate app)
- **Device**: Ulefone Armor 26 Ultra (Android 13)
- **LSPosed**: v1.9.2 (Zygisk)
- **Current Version**: v3.3.2 (March 19, 2026)
- **Storage Location**: `Download/DMR/` (Audio, Transcription, DMR_Backups, APRS, SSTV folders)

## Features

### ✅ Phase 1: Initial Hook Setup
- Startup toast: "✓ DMR Mod Hooks Active! v3.3.2"
- Custom version display on Device Information screen
- Confirms module is active and working

### ✅ Phase 2: OpenGD77 CSV Export (v0.7.0 - v0.8.7)
- **Export all channels** to OpenGD77-compatible CSV format
- **5 CSV files generated**: Channels, Contacts, TG_Lists, Zones, DTMF
- Direct database access from hooked app context
- Perfect format matching (TAB-prefixed frequencies, CRLF line endings)
- **User validated**: Exported data successfully imports to OpenGD77 CPS
- **Round-trip tested**: Edit in app → Export → Import to OpenGD77 → Success!

### ✅ Phase 3: OpenGD77 CSV Import (v0.9.0 - v1.1)
- **Import channels** from OpenGD77 CSV files
- Direct database write with atomic transactions
- Handles mixed VHF/UHF channel lists
- **All channels import correctly** including both Digital (DMR) and Analog (FM)
- Correct field values for Digital vs Analog channel activation
- Backup selection dialog (supports any folder name in DMR/DMR_Backups/)
- Auto-refresh after import - no app restart needed
- Import confirmation with success/failure reporting
- Files stored in user-friendly Download folder

### ✅ Phase 4: Real-time Speech-to-Text Transcription (v1.2 - v1.7.0)
- **Live transcription** of all DMR audio transmissions
- **Google Cloud Speech-to-Text** integration for accurate recognition
- **Automatic audio recording** - All transmissions saved as WAV files
- **Per-channel message history** - Each channel maintains its own scrollable message list
- **Channel switching memory** - Return to any channel and see previous messages (up to 10 messages per channel)
- **Timestamped messages** - Every transcription includes [HH:mm:ss] timestamp
- **Channel-organized storage**:
  - Audio recordings: `Download/DMR/Audio/[ChannelName]/`
  - Transcriptions: `Download/DMR/Transcription/[ChannelName]/`
- **Daily transcription logs** - Running log files with timestamps and DMR IDs
- **Format**: `[14:30:22] ID: 123456 - Transcribed text here`
- **Scrollable UI** - Message list grows dynamically with height cap at 100dp
- **Network resilience** - Connectivity checking and comprehensive error handling
- **Secure API key** - Stored in `Download/DMR/api_key.txt` (auto-created on first run)
- **Cost**: First $5/month FREE credit, then affordable per-second pricing
- **Status**: ✅ Successfully transcribing real DMR audio in production

### ✅ Phase 5: GPS Navigation & Location Tracking (v3.0.4 - v3.0.9)
- **Directional compass arrows** - 8-direction arrows (↑N, ↗NE, →E, ↘SE, ↓S, ↙SW, ←W, ↖NW)
- **Real-time bearing calculation** - Shows direction from your location to channel
- **Smart distance display**:
  - < 1km: Meters (e.g., `↑N 250m`)
  - 1-10km: Kilometers (e.g., `→E 5.2km`)
  - > 10km: Miles + kilometers (e.g., `↘SE 96.7mi (155.6km)`)
- **Reverse geocoding** - City, state display for channel coordinates
- **Elevation display** - Meters and feet via Open-Elevation API
- **Device location integration** - Uses GPS or network location
- **No internet required** for distance/bearing calculations

### ✅ Phase 6: Zone Management (v3.0.5 - v3.0.8)
- **Zone button** on main screen - Tap to select active zone
- **Zone-based navigation** - Arrow buttons filter by selected zone
- **Channel edit zone selector** - Assign channels to zones directly in edit screen
- **Create new zones** - Custom zone names via dialog
- **Edit zone names** - Pencil icon (✏) or long-press to rename
- **Automatic list refresh** - Changes apply immediately
- **OpenGD77 Zones.csv** - Full import/export support
- **Up to 80 channels per zone** - OpenGD77 limit
- **Persistent storage** - Zones saved in local SQLite database
- **Technical improvements**:
  - Fixed critical hook stacking bug
  - Proper instance field management
  - Singleton database pattern

### ✅ Phase 7: Analog MON Button (v3.0.2)
- **Continuous monitoring** - Squelch fully open (sq=0) on analog channels
- **Visual feedback** - Orange when monitoring, gray when normal
- **Auto-reset** - Returns to normal when switching channels
- **Toast notifications** - Confirms state changes
- **Perfect for scanning** - Monitor busy frequencies, emergency channels

## Why LSPosed?

The PriInterPhone app requires Ulefone's platform certificate to access:
- System UID (1000) for hardware permissions
- Custom `PrizeTinyService` framework APIs
- DMR radio module on `/dev/ttyS1`

**Traditional APK modification fails** because:
- ❌ Re-signing breaks platform signature verification
- ❌ System app placement alone doesn't grant platform UID
- ❌ Cannot obtain Ulefone's proprietary platform certificate

**LSPosed hooks the original properly-signed app** at runtime:
- ✅ Preserves platform signature and system UID
- ✅ Full access to all system APIs
- ✅ Can modify behavior without touching APK
- ✅ Reversible and update-safe

See [DMRModHooks/README.md](DMRModHooks/README.md) for complete LSPosed implementation details.

## Installation Instructions

### Requirements
- Ulefone Armor 26 Ultra (or compatible device with PriInterPhone)
  - **Root guide**: [XDA Forum - Armor 26 Ultra Root & Development](https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-info-guides-development.4677740/)
  - **Note**: Check the XDA thread for the latest root procedure specific to your ROM version
  - **Tested on**: Build number `Armor 26 Ultra_AF1_v15`
- Unlocked bootloader
- Magisk v24+ with Zygisk enabled
- LSPosed v1.9.2+ (Zygisk variant)
- [ADB tools](https://developer.android.com/tools/releases/platform-tools) (for installation and verification)

### Step 1: Install LSPosed Framework

1. **Install Magisk** (if not already installed)
   - Download from: https://github.com/topjohnwu/Magisk
   - Enable Zygisk in Magisk settings
   - Reboot device

2. **Install LSPosed Module**
   - Download: https://github.com/LSPosed/LSPosed/releases
   - Get: `LSPosed-v1.9.2-zygisk-release.zip`
   - Install via Magisk → Modules → Install from storage
   - Reboot device
   - LSPosed Manager app will appear automatically

### Step 2: Install the DMRModHooks Module

#### Option A: Download Pre-built Release (✅ Recommended for All Users)

**Use the latest GitHub release for all current features (Nearby Repeaters, in-app updates, RadioID lookup, OpenGD77 CSV, APRS/SSTV/NOAA/VFO, transcription).**

1. **Download Latest Release**:
   - Go to [Releases](https://github.com/IIMacGyverII/phonedmrapp/releases/latest)
   - Download `DMRModHooks-v4.1.1.apk` (**latest version**)
   - Download `DMRTranscriptionService-v1.1.0.apk` (companion app — needed for on-device live captions)
   - Download `OpenGD77CPS-Mac_Build_*.zip` from the same release (desktop CPS fork)

2. **Install** (reboot after — required for LSPosed):
   ```powershell
   adb install -r DMRModHooks-v4.1.1.apk
   adb install -r DMRTranscriptionService-v1.1.0.apk
   adb reboot
   ```

3. **Enable caller lookup** (recommended): Device tab → **Download RadioID Database** (one-time, ~17 MB)

> Already on v3.4.6 or later? Skip the manual download — open **Device tab → Check for updates** and update in-app, no PC needed.

#### Option B: Build from Source (For Developers & Experimenters)

**Building from source gives you access to the latest development code and experimental features.**

1. **Build & install** (then reboot so LSPosed loads the new hook code):
   ```powershell
   cd DMRModHooks
   .\install.ps1   # builds, installs, reboots automatically
   ```
   Or manually: `.\gradlew.bat assembleDebug`, then `adb install -r app\build\outputs\apk\debug\app-debug.apk` and `adb reboot`.

#### Enable in LSPosed Manager

2. **Activate Module** (after reboot):
   - Open LSPosed Manager app on device
   - Go to "Modules" tab
   - Enable "DMR Mod Hooks" checkbox
   - Tap "DMR Mod Hooks" → Application scope
   - Verify `com.pri.prizeinterphone` is selected
   - Reboot device

### Step 3: Configure Transcription (Optional)

**Note**: Transcription is optional — every other feature works without it. Speech-to-text is **built into the module** (no separate app) and uses the **Google Cloud Speech-to-Text API**.

1. **Get a Google Cloud API key**:
   - Visit https://console.cloud.google.com
   - Create a project and enable the **Cloud Speech-to-Text API**
   - **Enable billing** on the project (required even for the free 60 min/month tier)
   - Create an API key (starts with `AIza...`)

2. **Configure the key**:
   - Put it on the first line of `Download/DMR/api_key.txt` (one line, no quotes)
   - The app auto-creates this file on first run if missing
   - **Note**: File is device-local, never synced to GitHub

3. **Pricing**:
   - Free tier: 60 minutes/month
   - After the free tier: ~$0.006 per 15 seconds (~$1.44/hour)
   - Very affordable for typical DMR usage (~$0.002 per 5-second transmission)

### Step 4: Test Installation

1. **Verify Module is Active**:
   - Open PriInterPhone app
   - You should see toast: "✓ DMR Mod Hooks Active! v3.0.9"

2. **Test GPS Navigation** (if channels have coordinates):
   - Enable device location (GPS or Network)
   - Switch to a channel with GPS coordinates
   - Should see: City, State, distance with directional arrow (e.g., `↘SE 96.7mi (155.6km)`)
   - Direction arrow updates based on your location

3. **Test Zone Management**:
   - Tap ZONE button on main screen
   - Select "All Channels" or a specific zone
   - Edit a channel → Tap Zone row → Create/select zone
   - Verify zone assignment saves and list refreshes

4. **Test Export**:
   - Go to LOCAL tab
   - Tap 📤 **EXPORT (OpenGD77)** button  
   - Check `Download/DMR/DMR_Backups/` for CSV files (use any file manager)
   - Should see: Channels, Contacts, TG_Lists, Zones, DTMF CSVs with timestamps

5. **Test Import** (optional):
   - Tap 📥 **IMPORT (OpenGD77)** button
   - Select a backup timestamp from list
   - Confirm import
   - Wait for success message
   - Channels will auto-refresh and appear in app

6. **Test Transcription** (if configured):
   - Tap TXT button to enable (turns green)
   - Send or receive a DMR transmission with speech
   - Transcription appears in real-time below the channel info
   - Check `Download/DMR/Audio/[ChannelName]/` for WAV recordings
   - Check `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt` for logs

7. **Test Analog MON Button** (analog channels only):
   - Switch to an analog channel
   - Tap MON button (turns orange)
   - Squelch opens completely - hear all audio continuously
   - Tap again to disable (turns gray)

## Usage

### Using GPS Navigation

1. **Enable Location**:
   - Ensure device location is enabled (GPS or Network)
   - Grant location permissions to PriInterPhone app
   - Channels must have GPS coordinates stored

2. **View Distance & Direction**:
   - Switch to any channel with coordinates
   - Location text shows:
     - Short distances: `↑N 250m`
     - Medium distances: `→E 5.2km`
     - Long distances: `↘SE 96.7mi (155.6km)`
   - Direction arrow points from your location to the channel
   - Updates automatically when switching channels

3. **Location Information**:
   - City, State display via reverse geocoding
   - Elevation in meters and feet
   - Pin icon 📍 indicates GPS data available

### Using Zone Management

1. **Select Active Zone**:
   - Tap **ZONE** button on main screen
   - Select from list (shows channel count per zone)
   - Arrow buttons now filter by selected zone only
   - Button shows current zone: "Zone: Local Pack"

2. **Create New Zone**:
   - Edit any channel (or from zone selector)
   - Tap Zone row in edit screen
   - Scroll to bottom → "Create New Zone..."
   - Enter zone name → Newly created zone auto-selected

3. **Assign Channels to Zones**:
   - Edit channel → Tap Zone row
   - Select zone from list
   - "None" removes from all zones
   - Changes save immediately

4. **Rename Zones**:
   - In zone selector, tap pencil icon (✏) next to zone name
   - Or long-press zone name
   - Edit name in dialog
   - Zone channels preserved

5. **Import/Export Zones**:
   - Zones automatically included in OpenGD77 export/import
   - Zones.csv file contains zone definitions
   - Compatible with OpenGD77 CPS

### Using Analog MON Button

1. **Enable Monitoring** (analog channels only):
   - Switch to analog channel
   - Tap **MON** button (turns orange)
   - Squelch opens completely - hear ALL audio continuously
   - Perfect for scanning busy frequencies

2. **Disable Monitoring**:
   - Tap **MON** button again (turns gray)
   - Returns to normal squelch based on channel settings

3. **Auto-Reset**:
   - MON automatically resets to OFF when switching channels
   - Prevents accidentally leaving squelch open

### Exporting Channels to OpenGD77

1. Open PriInterPhone app
2. Go to **LOCAL** tab
3. Tap **📤 EXPORT (OpenGD77)** button
4. Export completes (toast shows: "✓ Export successful! v1.1\nCheck Download/DMR/DMR_Backups/")
5. Files created in `Download/DMR/DMR_Backups/20260223_140530/` folder containing:
   - Channels.csv, Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv
6. Transfer CSVs to PC via USB, file manager, or `adb pull /sdcard/Download/DMR/ .`
7. Open OpenGD77 CPS
8. Import → Select the folder containing all 5 CSV files
9. Program your OpenGD77 radio!

### Importing Channels from OpenGD77

1. Export channel programming from OpenGD77 CPS (all 5 CSV files)
2. Transfer CSVs to Android device `Download/DMR/DMR_Backups/`
   - Create a folder with any name (e.g., `MyBackup`, `Test`, or timestamp like `20260223_140530`)
   - Place the CSV files inside (OpenGD77 exports them as: `Channels.csv`, `Contacts.csv`, `TG_Lists.csv`, `Zones.csv`, `DTMF.csv`)
   - Via USB cable (MTP mode) or `adb push`
4. Open PriInterPhone app
5. Go to **LOCAL** tab
6. Tap **📥 IMPORT (OpenGD77)** button
7. Select backup folder from dialog (timestamp folders display as formatted dates)
8. Wait for import success notification
9. Channels auto-refresh - ready to use!

### Using Real-time Transcription

1. **Enable Transcription**:
   - Tap **TXT** button on main screen (turns green when enabled)
   - Ensure `Download/DMR/api_key.txt` contains your Google Cloud API key (long-press TXT to set it)

2. **During Transmissions**:
   - Real-time transcription appears below channel info in borderbox
   - Audio automatically recorded to `Download/DMR/Audio/[ChannelName]/`
   - Transcription appended to `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
   - Last 3-10 messages persist per channel (scroll through history)

3. **File Organization**:
   ```
   Download/DMR/
     Audio/
       Channel_1/
         20260309_143022_CallSign_Name.wav
         20260309_143155_CallSign_Name.wav
       Repeater_2/
         20260309_150330_CallSign_Name.wav
     Transcription/
       Channel_1/
         transcription_20260309.txt
         transcription_20260310.txt
       Repeater_2/
         transcription_20260309.txt
   ```

4. **Transcription Log Format**:
   ```
   [14:30:22] ID: 123456 - This is the first transmission
   [14:31:55] ID: 789012 - Second transmission from different user
   [14:35:10] ID: 123456 - Another message
   ```

5. **Disable Transcription**:
   - Tap TXT button again (turns gray)
   - Transcription service stops
   - Audio recordings will continue if recording is enabled separately

## Project Structure

```
phonedmrapp/
├── originalapk/
│   └── com.pri.prizeinterphone.apk    # Original system APK (8.1 MB)
├── app/                                # Android Gradle project
│   ├── src/main/
│   │   ├── java/                       # 280 Java source files (JADX decompiled)
│   │   │   └── com/pri/prizeinterphone/
│   │   │       ├── InterPhoneHomeActivity.java  (Main UI - 567 lines)
│   │   │       ├── manager/
│   │   │       │   ├── DmrManager.java          (DMR control)
│   │   │       │   ├── SerialPort.java          (UART /dev/ttyS1)
│   │   │       │   └── CmdStateMachine.java     (Protocol)
│   │   │       └── ... (all DMR implementation)
│   │   ├── res/
│   │   │   ├── drawable-*/interphone_app_icon.png  (Custom icon, 5 densities)
│   │   │   └── values/strings.xml                   (MacDMRUlephone name)
│   │   └── AndroidManifest.xml
│   └── build.gradle                    # Package: com.pri.prizeinterphone
├── DMRModHooks/                        # LSPosed Xposed Module
│   ├── app/src/main/java/com/dmrmod/hooks/
│   │   ├── MainHook.java              # Main hook implementation (3300+ lines)
│   │   ├── DirectDatabaseExporter.java # OpenGD77 CSV export
│   │   ├── CSVExporter.java           # CSV file generation
│   │   └── DirectDatabaseImporter.java # OpenGD77 CSV import
│   ├── build.gradle
│   └── README.md                       # Module documentation
├── DMRTranscriptionService/            # Legacy standalone STT service (folded into the module)
│   ├── app/src/main/
│   │   ├── java/com/macdmr/transcription/
│   │   │   └── TranscriptionService.java  # Google Cloud API integration
│   │   ├── aidl/com/macdmr/transcription/
│   │   │   └── ITranscriptionService.aidl # Service interface
│   │   └── AndroidManifest.xml
│   ├── local.properties               # API key (gitignored)
│   ├── local.properties.template      # Template for setup
│   └── build.gradle
├── magisk_module/
│   └── MacDMRUlephone/
│       ├── module.prop                 # Module metadata
│       ├── install.sh                  # Installation script
│       └── system/priv-app/PriInterPhone/
│           └── PriInterPhone.apk       # Custom APK (7.99 MB)
├── MacDMRUlephone-Magisk.zip          # Packaged module (6.65 MB)
├── icon.jpg                            # Custom icon source (784x1168)
├── MAGISK_SOLUTION.md                  # Magisk implementation guide
├── STATUS.md                           # Complete development timeline
├── QUICK_REFERENCE.md                  # ADB commands & debugging
└── README.md                           # This file
```

## Development Timeline

### ✅ Phase 1: Decompilation & Build
- Decompiled original APK with JADX → 280 Java source files (complete DMR stack)
- Created Android Gradle project (WSL2, Java 17, Gradle 8.2, AGP 7.4.2)
- Fixed 15+ compilation errors
- Created 10 stub classes for missing ROM APIs
- Resolved 58+ AndroidX resource attribute duplicates
- Built working APK

### ✅ Phase 2: Custom Branding
- Custom app name: MacDMRUlephone
- Custom icon from icon.jpg (all 5 Android densities)
- Package initially rebranded to `.modded` for side-by-side testing
- Resolved 5 manifest conflicts
- Fixed 4 system API compatibility issues

### ✅ Phase 3: GitHub Repository
- Created repository: https://github.com/IIMacGyverII/phonedmrapp
- Removed large files (gradle-8.2-bin.zip, jadx.zip - 197 MB)
- Pushed commit 5456fcac (16,278 files)
- Comprehensive documentation created

### ✅ Phase 4: DMR Hardware Investigation
- **Problem Discovered**: App stuck on "Module Initializing..." dialog
- **Root Cause**: Permission mismatch
  - Original app: userId=1000 (system)
  - Modded app: userId=10198 (user) - NO hardware access
- **Hardware Identified**: DMR module on `/dev/ttyS1` (system:radio permissions)
- **File Sync Issue**: Only 13 Java files in Windows vs 280 in WSL
- **Solution**: Robocopy synced all 280 files (2.36 MB)
- **Rebuild**: APK now contains complete DMR implementation

### ✅ Phase 5: System Access Solution
- **Attempted**: Direct system installation → Failed (production ROM locked)
- **Attempted**: Platform signing → Not viable (no manufacturer key)
- **Solution Found**: Magisk systemless overlay
- **Implementation**: Created Magisk module
  - Reverted package to `com.pri.prizeinterphone`
  - Built APK with custom branding
  - Packaged as Magisk module (6.65 MB)
  - Transferred to device: `/sdcard/Download/MacDMRUlephone-Magisk.zip`

### ⏳ Phase 6: Deployment (Pending User Action)
- Module ready for installation via Magisk Manager
- Awaiting user to install and reboot
- Will enable full DMR hardware access with custom branding

### ✅ Phase 7: Real-time Speech-to-Text Transcription (v1.2 - v1.5)
- **Problem**: Need speech-to-text for DMR transmissions
- **Attempted**: ONNX Whisper Base model → Failed (decoder token 0 issue, 155 MB removed)
- **Attempted**: Android SpeechRecognizer API → Failed (device blocks third-party access, error 10)
- **Attempted**: LSPosed hooks to bypass restrictions → Failed (system blocks at validation layer below hooks)
- **Solution Found**: Google Cloud Speech-to-Text API (bypasses all device restrictions)
- **Implementation**:
  - Created standalone TranscriptionService APK with AIDL interface
  - Integrated OkHttp for HTTP requests with 30-second timeouts
  - PCM to WAV conversion with proper 44-byte header
  - Base64 encoding for Google Cloud API
  - JSON request/response handling with error recovery
  - Network connectivity checking
  - Secured API key in gitignored local.properties
- **File Organization**:
  - Audio recordings organized by channel: `Download/DMR/Audio/[ChannelName]/`
  - Daily transcription logs by channel: `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
  - Running log format: `[HH:MM:SS] ID: DMRID - Transcription text`
- **Status**: ✅ Successfully transcribing real DMR audio in production

## Technical Details

### Build Environment
- **Platform**: WSL2 Ubuntu 22.04 + Windows 11
- **Java**: OpenJDK 17.0.18
- **Android SDK**: compileSdk 34, minSdk 24, targetSdk 34
- **Gradle**: 8.2, AGP 7.4.2/8.1.0
- **Tools**: JADX 1.4.7, ImageMagick, ADB
- **Device**: 5006AF1020002922 (production ROM, Magisk installed)

### Transcription Architecture
- **Live captions (default since v4.1.0)**: the companion app's `LiveCaptionService` runs Vosk behind `127.0.0.1:8002`; the module streams 16 kHz PCM and shows partials live
- **Google Cloud engine (optional)**: `TranscriptionClient` in the module, in-process
- **API**: Google Cloud Speech-to-Text v1 (`speech:recognize`)
- **HTTP Client**: `HttpURLConnection` with 30-second timeouts
- **Audio Format**: PCM 16-bit mono → WAV with proper header → Base64
- **Network**: Connectivity checking with ACCESS_NETWORK_STATE permission
- **Security**: API key in gitignored local.properties, injected via BuildConfig
- **Error Handling**: Comprehensive logging, network error recovery, API error detection
- **Storage**: Channel-organized folders for audio and transcription logs

### System API Fixes Implemented
1. **Background Service Restriction**: Disabled auto-start from Application.onCreate()
2. **WindowManager API**: Stubbed setDefaultDisplay() (system-only API)
3. **NVRAM Access**: Created stub for vendor-specific NvramUtils
4. **PCM Audio Manager**: Wrapped vendor-specific callbacks in try-catch

### DMR Implementation
- **Serial Port**: `/dev/ttyS1` (115200 baud, binary protocol)
- **Core Classes**: DmrManager, SerialPort, CmdStateMachine, PCMReceiveManager
- **Protocol Stack**: Complete implementation (280 Java files, ~45,000 lines)
- **Audio Pipeline**: Recording, codec, playback
- **Features**: Talkback, channels, contacts, messaging, settings

## Documentation

- **[MAGISK_SOLUTION.md](MAGISK_SOLUTION.md)**: Complete Magisk module guide with troubleshooting
- **[STATUS.md](STATUS.md)**: Full development timeline and technical achievements
- **[SUCCESS_REPORT.md](SUCCESS_REPORT.md)**: Initial build success documentation
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**: ADB commands and debugging tips
- **[JADX_DECOMPILATION_ERRORS.md](JADX_DECOMPILATION_ERRORS.md)**: Known JADX limitations

## GitHub Repository

**Repository**: https://github.com/IIMacGyverII/phonedmrapp  
**Latest Commit**: 5456fcac  
**Total Files**: 16,278 files committed  
**Status**: All source code available online

## Next Steps

1. **User Action Required**: Install Magisk module on device and reboot
2. **Testing**: Verify DMR hardware initialization and radio functionality
3. **Documentation**: Update with test results and user guide

## Future Plans

### Enhanced Transcription Features
- **Multi-language support**: Configure language per-channel
- **Custom vocabulary**: Add DMR-specific terms and callsigns
- **Offline transcription**: Explore local models for privacy/cost reduction
- **Voice commands**: Control radio functions via speech recognition

### Expanded DMR Functionality
- **Real-time Contact Display**: Enhanced live DMR contact receive display
- **Enhanced UI Integration**: Improved display of current DMR contact name, ID, and call status
- **Call logging**: Track incoming/outgoing DMR calls with detailed timestamps and durations
- **Statistics dashboard**: Visualize usage patterns and contact activity

### Tier 2 Support
- **Attempt Tier 2 Implementation**: Investigate and implement advanced DMR Tier 2 features
- **Enhanced talkgroup support**: Multi-talkgroup scanning and monitoring
- **IP connectivity**: Explore DMR network connectivity options

### Global DMR Database Integration
- ✅ **RadioID.net Integration** — Shipped v3.4.5: download, offline cache, caller panel, history labels
- **Automatic Updates**: Periodic contact database refresh from radioid.net (manual re-download today)

### The Sky's the Limit
With LSPosed runtime hooks and full access to the platform-signed app, **anything is possible**:
- Custom UI themes and branding
- Advanced automation and scripting
- Integration with external services and APIs
- Community-driven feature development
- Enhanced radio control and monitoring

**Last Updated**: June 21, 2026  
**Current Version**: v3.4.6  
**Major Feature**: v3.4.5 - RadioID.net global DMR ID caller lookup  
**Base Release**: v1.7.0 - Transcription & API Features
**Status**: LSPosed module fully operational - All features working perfectly!  
**GitHub**: https://github.com/IIMacGyverII/phonedmrapp

### Version History Overview

**v3.0.x Series** (Current): Advanced Features
- ✅ GPS navigation with directional arrows and bearing
- ✅ Zone management (create, edit, assign)
- ✅ Analog MON button for continuous monitoring

**v1.x Series** (Stable Base): Core Features
- ✅ OpenGD77 CSV export/import
- ✅ Real-time speech-to-text transcription
- ✅ Location tracking and RSSI display
- ✅ Audio recording and logging

**v2.x Series** (Planned): DMR Enhancements
- ⏳ DMR group calling improvements
- ⏳ DMR monitoring mode
- 🔬 Requires extensive hardware-level debugging

For detailed technical information, see [DMRModHooks/README.md](DMRModHooks/README.md), [MAGISK_SOLUTION.md](MAGISK_SOLUTION.md), and [STATUS.md](STATUS.md).

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

> **Disclaimer**: This tool hooks into the PriInterPhone app at runtime using LSPosed/Xposed. It does NOT modify or redistribute any proprietary code from Ulefone. Users must legally own the PriInterPhone app. For personal, educational, and interoperability purposes only.

