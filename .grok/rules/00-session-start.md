# Session Start — Read This First

Mandatory checklist for every new session on **phonedmrapp** / **DMRModHooks**.

> **Mirror rule:** this file and `CLAUDE.md` at the repo root are **byte-identical copies** (one for Grok/Copilot agents, one for Claude Code). Edit either one, then copy it over the other in the same commit — never let them diverge. Verify with `git diff --no-index CLAUDE.md .grok/rules/00-session-start.md` (no output = in sync).

## 1. Orient (30 seconds)

| What | Where | Notes |
|------|-------|-------|
| **Shipped version** | `DMRModHooks/app/build.gradle` → `versionName` / `versionCode` | Authoritative; docs may lag (v3.4.6 as of 2026-08-26) |
| **Full instructions** | `.grok/rules/copilot-instructions.md` | Clone of `.github/copilot-instructions.md` |
| **Verified deep dive** | `docs/deep-dive/00-README.md` | Code-cited reference for OEM app + mod (14 chapters). **§4 lists known errors in this file and `copilot-instructions.md`** — check it before trusting a schema/class-path/audio claim here |
| **Dead ends / history** | `.docs/AI_LOGS_SUMMARY.md` (gitignored, may be absent) → fallback `docs/deep-dive/13-…` §5, `07-…` §5 | Read before retrying APRS TX, LED, group-call RX, >32 TG filtering |
| **Entry point** | `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java` | ~16k lines; all hooks live here |
| **OEM app source** | `app/src/main/java/com/pri/prizeinterphone/` | Decompiled PriInterPhone |
| **OpenGD77 CPS fork (binary)** | `OpenGD77Fork/*.zip` | Latest build zip for releases; **not** a git submodule |
| **OpenGD77 CPS fork (source)** | `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac` | Separate repo — edit/build CPS here |
| **MCU firmware RE** | `docs/grok-deep-dive/11-firmware-fw0-results.md` §12–14 | Image is **C-SKY V2**, not ARM. Disassemblers installed: `C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe` and the Ghidra C-SKY module; `scripts/fw1_ghidra_csky.ps1`. Never reuse the old `0x08xxxxxx` ARM addresses |

## 2. Trust, but verify

Instructions drift. **If docs and code disagree, the code wins — then patch the docs** (`.grok/rules/`, `.github/copilot-instructions.md`, or `DMRModHooks/README.md`).

Always grep before relying on: DB column names, `ChannelData` field names, hook signatures, packet byte layouts.

## 3. Hard constraints — do not re-investigate

| Topic | Reality |
|-------|---------|
| APRS TX over analog FM | **Unresolved, not impossible** (2026-08-26): the 2026-03 "voice DSP kills AFSK" verdict came from tests that fed `writeFrame` **mono** buffers while the OEM TX path writes 8 kHz **stereo** frames (tones double → aliasing). Do not build on TX until the stereo-frame experiment in `docs/deep-dive/15-packet-radio-review.md` §3.1 has been run; do not re-run the mono experiments. |
| Hardware LED control | MCU firmware only; no app command |
| DMR group-call RX | **Settled on-air 2026-10-15** (BTECH 6X2 → this radio, simplex, CC1/TS1, `grok-deep-dive/11-…` §19): the MCU passes a group call **iff its TG is in `groups[]`** (the 32-slot RX list). The Call Number alone does **not** admit its own TG (TG 9 with `txContact=9`, list `[1]`: silent; TG 1 with `txContact=99`, list `[1]`: heard). Private calls to the radio's own ID always pass. ALL/RECEIVE_ALL (`contactType=2`) reports `0xFFFFFF` and drops audio. The mod now adds the Call Number to `groups[]` on save. The 2026-03 "firmware ignores the RX list" verdict was wrong |
| >32 TG IDs per channel | `ChannelData.groups` is `int[32]` and the MCU drops calls outside it before `RECEIVE_START`, so a software filter cannot widen it. The `0x2B` caller-info body **does** carry the target: `[0]` callType 0 private / 1 group, `[1..4]` caller ID LE, `[5..8]` target (own ID or TG) LE |
| Squelch levels 1,3–9 | Behaviourally only `sq=0` and `sq=2` were distinct (2026-03). **The MCU stores the byte as sent** — `0x25` readback returned `sq=5` on 2026-10-14 (`docs/grok-deep-dive/11-…` §15); any coercion is in the RF-IC apply path, not the UART image. On-air sweeps 2026-10-14 (§17, §17.1): at −94 dBm levels 1–9 **all** closed, at −81 dBm levels 1–9 **all** open within 0.6 s, `sq=0` always open — 26 windows, no level ever differed. Treat 1–9 as **one threshold near −90 dBm**; use `0x32` RSSI (readable even with squelch closed) for anything finer |
| On-device speech-to-text | Not shipped; transcription is **Google Cloud STT** via `DMRTranscriptionService` (not Whisper) |

## 3a. Facts that older notes got wrong (verified 2026-08-26 — full list in `docs/deep-dive/00-README.md` §4)

| Topic | Reality |
|-------|---------|
| RX audio | Does **not** cross the UART; arrives via `android.os.PrizeTinyService`. OEM `AudioTrack` = **8 kHz stereo 16-bit** (32 kB/s, 2048 B / 64 ms chunks). **Measured 2026-10-14: L == R for 100 % of samples** (`docs/grok-deep-dive/11-…` §16), so the content is **8 kHz mono duplicated**. Module DSP still treats the buffer as 16 kHz mono — 2× redundant. New DSP: take every other sample and work at 8 kHz; TX frames must be stereo-duplicated. |
| Module DBs | All `dmrmod_*.db` live in `/data/data/com.pri.prizeinterphone/databases/` (module runs in the OEM process) |
| `channel_band` | Bandwidth (0 narrow / 1 wide), **not** UHF/VHF. `determineBand()` was deleted 2026-10-14 (backlog R1): SSTV writes narrow, NOAA wide, VFO has a Narrow/Wide selector. Always set `band` from an explicit narrow/wide choice. |
| Module side-tables vs areas | `OemChannelTable` made channel export/import follow the selected **area**, but `dmrmod_zones/tglists/locations/aprs` are still one file for all areas: importing area B clears area A's extras and equal integer keys collide (backlog R7/H8). Until fixed, only import into the area the backup came from |
| `channel_encryptSw` | 1 = on, **2 = off** |
| `channel_interrupt` | OEM default 2 for all types; "0 for analog" is a module convention |
| Channel storage | One SQLite file per **area** (`database_<areaKey>.db`, 14 default areas); export/import hard-code `default_uhf` (bug) |
| Import | `DirectDatabaseImporter` is wipe-and-insert, not upsert |
| Backups / recordings / key | `Download/DMR/DMR_Backups/`, `Download/DMR/Audio/<Channel>/`, `Download/DMR/api_key.txt` |
| OEM class names | `InterPhoneHomeActivity` (root pkg), `fragment.InterPhoneTalkBackFragment`, `handler.ModuleStatusMessageHandler`, `protocol.Packet`, `serial.MessageDispatcher` — there is no `MainActivity`/`TalkBackFragment` |
| Hook locations | `sq=0` forcing + 300 ms re-enable + ack re-apply: `hookChannelNavigation`; VFO `localId` override: `BaseMessage.send()` hook; Device-tab tools: `McuDiagnostics` + `addButtonToLayout`; diagnostics gate: `diagnosticsEnabled` (prefs `dmrmod_diagnostics`, default OFF — turn it on in the Device tab before using `SEND_DEBUG_PACKET` or expecting `uart_logs`); channel scanner: `ChannelScanner` (drives the OEM `updateChannelId()`; the zone hook bypasses it via `ChannelScanner.stepping`; needs Soft SQ off; the radio NAKs digital channels with no TX contact; scan list in prefs `dmrmod_scan`/`excluded`); serial reader guard: `hookSerialReaderWatchdog`; live S-meter: `smeterEnabled` + `smeterPoll` (prefs `dmrmod_diagnostics`/`smeter`, default OFF); channel-change refusals: `InterPhoneTalkBackFragment$2.errorEvent` hook in `hookScanSupport` |
| `syncChannelInfoWithData` | **Is** the OEM hardware-write path (`CmdStateMachine` transaction) |

## 4. Deploy workflow (mandatory for AI agents)

After **any** successful DMRModHooks APK install, **you** must reboot the device:

```powershell
cd DMRModHooks
.\install.ps1    # build + adb install -r -t + adb reboot
```

- Do **not** tell the user to reboot — run `adb reboot` yourself.
- If no device connected, say so; do not claim deploy is complete.
- DMRModHooks **always** needs reboot; DMRTranscriptionService may not.
- Debug and release share `DMRModHooks/release.keystore` — never change debug signing without coordinating install method.
- **Launch the OEM app with `adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity`, NEVER `adb shell monkey -p …`.** Monkey registers itself as the system activity controller (`isUserAMonkey()=true`); if it is interrupted/killed before exiting cleanly (reboot mid-run, adb drop, a `force-stop`/`killall` racing it) the flag sticks globally and the OEM silently refuses Channel-page Use/Edit/Delete (dialog dismisses, nothing happens) — intercom arrows still work. Recover without reflash: `printf 'q\n' | adb shell am monitor`, or reboot. Diagnose: `adb shell dumpsys activity | grep mController`.

## 5. Release policy

**Only create releases when the user explicitly asks.** Do not bump version or publish GitHub releases after routine fixes.

## 6. Coding discipline

- Change only what the task requires; no drive-by refactors.
- Match existing style in `MainHook.java` and helper classes.
- All hooks: try-catch, log via `XposedBridge.log(TAG + …)`.
- UI updates: `Handler(Looper.getMainLooper())`.
- Shared state: `volatile` static fields at top of `MainHook.java`. **Never build a `Handler`, `Looper`-bound object or anything needing a Context in a static initializer of `MainHook`**: `<clinit>` runs in the Zygote fork before the main Looper exists, and one NPE there makes LSPosed drop the whole module ("Failed to load class com.dmrmod.hooks.MainHook", 2026-10-14). Create such objects lazily from a hook.

## 7. Critical pitfalls (grep before touching)

| Pitfall | Rule |
|---------|------|
| **12 — txContact** | `channel_txContact` stores **24-bit DMR ID** (`contact_number`), NOT contact row `_id` |
| **15 — localId** | Device DMR ID is on `DmrManager` / outgoing `DigitalMessage` (body offset 8), NOT `ChannelData`; VFO override lives in the `BaseMessage.send()` hook |
| **13 — squelch race** | 300 ms re-apply can be eaten by the in-flight `SetChannelState` ack (acks matched by cmd byte only). Since 2026-10-14 the mod also re-applies `sq=0` from an `AnalogMessageHandler.handle` after-hook whenever an analog ack arrives for a write whose `sq` was not 0 (`lastSentAnalogSq`), with the timer kept as fallback |
| **8 — squelch** | Use `AnalogMessage.send()` with `sq=0`/`sq=2`; don't rely on `syncChannelInfoWithData` for hardware |
| **10 — APRS squelch** | APRS mode overwrites `softwareSquelchThreshold` |
| **11 — relay field** | OpenGD77 exports `relay=0`; Android firmware rejects 0 → importer coerces `0→2` |

## 8. OpenGD77 CPS Fork (`OpenGD77Fork/`)

**Not upstream OpenGD77.** Our fork has Android-specific patches (37-col CSV, relay coercion, 0/1-based timeslot, contact-by-DMR-ID). **Do not use it on a real Radioddity GD-77** — it will corrupt a stock codeplug.

| What | Where |
|------|-------|
| Compiled builds (zips) | `OpenGD77Fork/OpenGD77CPS-Mac_Build_*.zip` — pick **newest** by timestamp |
| Fork version | `OpenGD77CPS-Mac/DMR/AboutForm.cs` → `FORK_VERSION` (bump on every CPS build) |
| Deep dive | `OpenGD77CPS-Mac/docs/CODEBASE_DEEP_DIVE.md` — read before editing import/export |
| Full CSV/schema docs | `.grok/rules/copilot-instructions.md` § "OpenGD77 Integration" |

**Android backup = 5 CSVs** (export via `DirectDatabaseExporter`, import via `DirectDatabaseImporter`):

`Contacts.csv` → `TG_Lists.csv` → `Channels.csv` → `Zones.csv` → `DTMF.csv`

Import **in that order**. Channels-only import causes contact-id corruption and "operation failed" toasts.

**CPS three import paths** (channels) — only **Path B** handles Android CSV:

| Path | Method | Android CSV? |
|------|--------|--------------|
| A | `ChannelsForm.import()` | ❌ 35-col OpenGD77 header only |
| B | `ChannelsForm.ImportFromCsvFile()` | ✅ detects `_id` column — **the one that works** |
| C | `ChannelsCsvImporter.ImportChannelsFromCsv()` | Dead code — zero call sites |

**Build CPS (Windows):**

```powershell
cd C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac
msbuild OpenGD77CPS.sln /p:Configuration=Release
# → bin/ReleaseOpenGD77/OpenGD77CPS.exe — copy zip into phonedmrapp/OpenGD77Fork/
```

**Releases:** every DMRModHooks GitHub release must attach the latest `OpenGD77Fork/*.zip` (reuse previous zip if fork unchanged).

## 9. Packet layouts (verified)

See `.grok/rules/packet-layouts.md` for byte offsets, and `docs/deep-dive/01-…`/`02-…` for the complete command table and every message's body layout. Key fix (2026-06-12): caller DMR ID in `DigitalAudioMessage` is **24-bit LE at body[1..3]**, not 16-bit.

## 10. When you finish a change

- [ ] Build: `cd DMRModHooks; .\gradlew assembleDebug`
- [ ] If device attached: `.\install.ps1` (includes reboot)
- [ ] If you corrected stale docs: patch `.grok/rules/` and `.github/copilot-instructions.md` in the same PR/commit; if the fact is architectural, patch the relevant `docs/deep-dive/` chapter too
- [ ] If you edited this file: copy it to `CLAUDE.md` (or vice-versa) — see the mirror rule at the top
- [ ] Do **not** auto-release unless asked