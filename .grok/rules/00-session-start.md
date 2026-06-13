# Session Start — Read This First

Mandatory checklist for every new session on **phonedmrapp** / **DMRModHooks**.

## 1. Orient (30 seconds)

| What | Where | Notes |
|------|-------|-------|
| **Shipped version** | `DMRModHooks/app/build.gradle` → `versionName` / `versionCode` | Authoritative; docs may lag (currently **v3.4.1**) |
| **Full instructions** | `.grok/rules/copilot-instructions.md` | Clone of `.github/copilot-instructions.md` |
| **Dead ends / history** | `.docs/AI_LOGS_SUMMARY.md` | Read before retrying APRS TX, LED, group-call RX, >32 TG filtering |
| **Entry point** | `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java` | ~16k lines; all hooks live here |
| **OEM app source** | `app/src/main/java/com/pri/prizeinterphone/` | Decompiled PriInterPhone |
| **OpenGD77 CPS fork (binary)** | `OpenGD77Fork/*.zip` | Latest build zip for releases; **not** a git submodule |
| **OpenGD77 CPS fork (source)** | `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac` | Separate repo — edit/build CPS here |

## 2. Trust, but verify

Instructions drift. **If docs and code disagree, the code wins — then patch the docs** (`.grok/rules/`, `.github/copilot-instructions.md`, or `DMRModHooks/README.md`).

Always grep before relying on: DB column names, `ChannelData` field names, hook signatures, packet byte layouts.

## 3. Hard constraints — do not re-investigate

| Topic | Reality |
|-------|---------|
| APRS TX over analog FM | Impossible on this hardware (voice DSP kills AFSK) |
| Hardware LED control | MCU firmware only; no app command |
| DMR group-call RX | Firmware ignores RX group list; private calls to own ID only |
| >32 TG IDs per channel | `ChannelData.groups` is `int[32]`; firmware limit |
| Squelch levels 1,3–9 | Firmware coerces to `2`; only `sq=0` and `sq=2` are distinct |

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

## 5. Release policy

**Only create releases when the user explicitly asks.** Do not bump version or publish GitHub releases after routine fixes.

## 6. Coding discipline

- Change only what the task requires; no drive-by refactors.
- Match existing style in `MainHook.java` and helper classes.
- All hooks: try-catch, log via `XposedBridge.log(TAG + …)`.
- UI updates: `Handler(Looper.getMainLooper())`.
- Shared state: `volatile` static fields at top of `MainHook.java`.

## 7. Critical pitfalls (grep before touching)

| Pitfall | Rule |
|---------|------|
| **12 — txContact** | `channel_txContact` stores **24-bit DMR ID** (`contact_number`), NOT contact row `_id` |
| **15 — localId** | Device DMR ID is on `DmrManager` / outgoing `DigitalMessage`, NOT `ChannelData` |
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

See `.grok/rules/packet-layouts.md` for byte offsets. Key fix (2026-06-12): caller DMR ID in `DigitalAudioMessage` is **24-bit LE at body[1..3]**, not 16-bit.

## 10. When you finish a change

- [ ] Build: `cd DMRModHooks; .\gradlew assembleDebug`
- [ ] If device attached: `.\install.ps1` (includes reboot)
- [ ] If you corrected stale docs: patch `.grok/rules/` and `.github/copilot-instructions.md` in the same PR/commit
- [ ] Do **not** auto-release unless asked