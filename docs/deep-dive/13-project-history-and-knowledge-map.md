# 13 — Project History, Repository Map & Knowledge Index

This chapter is the historical and organizational reference for **phonedmrapp**: how the project
evolved, what every top-level directory and notable file is, where the OEM app's behaviour is
authoritatively read, an indexed summary of all 83 research docs, the consolidated list of proven
dead ends, the OpenGD77 CPS fork's version history, a scripts index, the working agreements, and
hygiene observations. Other chapters (01–07) document the code and protocols; this one documents the
*repository* and its *history*.

Facts are cited by file path and, for events, by git short hash. Authoritative version is always
`DMRModHooks/app/build.gradle` (`versionName`/`versionCode`) — currently **3.4.6 / 346**. The repo
has **356 commits**, all by one author (`IIMacGyverII`, `git shortlog -sn`), spanning
**2026-02-17 → 2026-06-21**. Last commit `14e484a2` (2026-06-21).

---

## 1. Project Evolution Timeline

The project began as an attempt to rebuild and re-sign the OEM DMR app, hit an unsolvable
platform-signature wall, pivoted to an LSPosed runtime-hook module, and then accreted feature after
feature (codeplug CSV → transcription → DMR/firmware RE → analog features → APRS → VFO → SSTV/NOAA →
OpenGD77 round-trip → RadioID). Dates below are commit dates (`git log --date=short`).

### Phase table

| Phase | Dates | Key commits | What it unlocked / concluded |
|---|---|---|---|
| **P0 — Decompile & rebuild/rebrand** | Feb 17–18 2026 | `4017f154` first commit; `5c85cc2f`; `b24f8650` "Fresh start: reset repo with original APK only"; `4d7633da` (Gradle project, AAPT2/Windows blocker); `48232cdd` (WSL2 + JADX pivot); `0b39daa7` "complete Java source (280 files)" | Decompiled `com.pri.prizeinterphone` to Java, rebuilt as `com.macgyver.dmr` "2.0-MacDMR". **Failed:** re-signed APK can't access `PrizeTinyService` (platform cert). See §3. |
| **P1 — Magisk / systemizer / serial-permission experiments** | Feb 17–18 2026 | `ca401f1d` Magisk module; `6d4f2eeb` standalone `com.macgyver.dmr`; `5daace6e` serial-access Magisk module; `3e03d002` "FAILED: Systemization via Magisk — caused bootloop (signature verification)" | Confirmed: system-app placement does **not** grant system UID without the platform key. All dead ends. |
| **P2 — LSPosed module v0.1 → v0.3** | Feb 18 2026 | `73a9535c` "LSPosed Module Working — MacGyver v0.3"; `90683978` "Release v0.3 + docs + cleanup plan" | **The pivot that worked.** Hooks the original signed app in-process (system UID kept). First shipped module. |
| **P3 — OpenGD77 CSV export/import** | Feb 19–24 2026 | `970059cc` Phase-2 plan; `9b255c41`..`7a76edad` (v0.9.26–v0.9.41); `1da8410f` "v1.0 first stable release" | 5-file CSV backup/restore (Channels/Contacts/TG_Lists/Zones/DTMF); OpenGD77 CPS compatibility; digital+analog activation fixes. v0.9.26 = "74 builds, 100% import success". |
| **P4 — Location / RSSI / caller ID / transcription** | Feb 24 – Feb 27 2026 | `1fdc6b3d` v1.1; `da849803`..`a60c2673` (v1.3.x location/geocode/elevation); `79fe0852` v1.3.7 caller ID; `6a229176` v1.4.0 activity history; `d7225447` v1.4.8 RSSI; `eec22aae` v1.6.0 transcription history; `77d6c34b` v1.7.0 API-key config | GPS/city-state/elevation display, DMR caller ID (24-bit LE decode), activity history DB, RSSI, real-time Whisper transcription (cloud) via `DMRTranscriptionService`. v1.7.0 = the stable base. |
| **P5 — DMR firmware / group-call RE (the "v2.x" that never shipped)** | Feb 27 – Mar 6 2026 | docs only + `radio_firmware/`; `V2.0.0_CALL_TYPE_OVERRIDE_FIX.md`; `V3.0.1_DEVELOPMENT_SUMMARY.md`; `PATCH14_BREAKTHROUGH.md` | UART logging (v1.9.0), call-type override (v2.0.0), command fuzzing (v3.0.1), 14 firmware patches, full Ghidra decompile. **All failed** — group-call RX unfixable in SW/patch. This is why versioning jumped v1.7 → v3.0 (v2.x reserved for DMR fixes that never landed). |
| **P6 — Analog features + branding (v3.0.2–v3.0.9)** | Mar 4–9 2026 | `f058d876` v3.0.2 Analog MON + MacGyver branding; `ce1a8b5a` v3.0.3 DMR audio fix; `fecbdfea` v3.0.4 GPS distance; `c2e09b4c`/`80241076` v3.0.7/8 zones; `fe66ef0f` v3.0.9 | Analog MON button (open squelch), GPS distance/bearing, zone management. |
| **P7 — APRS live monitoring (v3.1.0–v3.1.4)** | Mar 12–13 2026 | `09c25215` v3.1.0; `37873583` v3.1.1; `43dbd7ed` v3.1.2; `4955ce23` v3.1.3; `ef198979` v3.1.4; `af471f83` squelch HW-limit docs | RX-only APRS AFSK decode + live dashboard + GPX/text logs. Software-squelch UI (hybrid RSSI+RMS on `sq=0`). **APRS TX abandoned** (§5). |
| **P8 — VFO mode (v3.1.5–v3.2.3)** | Mar 13–14 2026 | `3d2e928c` VFO plan; `3ef94e31`/`f8edff2e` v3.1.5; `068e72f9` v3.1.6; `2a4e49dc` v3.2.2; `f60a5377` v3.2.3 | Variable-frequency tuning w/ temporary channel hijack; DMR-ID override via `DigitalMessage.localId` (Pitfall 15). |
| **P9 — SSTV / NOAA / TG-lists / GPS-SMS (v3.3.0–v3.3.7)** | Mar 18–19 2026 | `d286d984` v3.3.0 SSTV; `de26331f` v3.3.5 NOAA; `edae3724` v3.3.6 TG-list direct DB write; `2c6560ba` v3.3.7 GPS messaging | SSTV RX (IQ decoder ported from robot36-2), NOAA APT RX + pass predictor, named TG lists → `channel_groups[32]`, GPS-over-DMR-SMS with reverse geocoding. |
| **P10 — OpenGD77 round-trip hardening + repo reorg (v3.3.8–v3.4.1)** | Mar 20 – Jun 5 2026 | `95ba06ba` add `OpenGD77Fork/`; `ffa0e5de` "Reorganize repo: docs/, scripts/, radio_firmware/"; `2073d751` v3.3.8; `e66fa78c` v3.3.9; `d3e4670b` v3.4.0 (Pitfall 12); `95e6e554` v3.4.1 | Codeplug round-trip bugs (relay 0→2, timeslot 0/1-based, contact-by-DMR-ID, channel_mode 3→4, contact-type swap, encrypt default). Repo reorganized into `docs/`/`scripts/`/`radio_firmware/`. `.docs/` + `.github/copilot-instructions.md` untracked (`3623ba8f`). |
| **P11 — RadioID caller lookup + import fixes (v3.4.2–v3.4.6)** | Jun 12–21 2026 | `272023b2` v3.4.2 (24-bit caller ID); `17ec79cc` v3.4.3; `0f0fe397` v3.4.4 RadioID DB; `56fcb574` v3.4.5; `d87b67b8` v3.4.6 | 24-bit caller-ID decode fix, offline RadioID.net global DMR-ID DB (~300k IDs, `dmrmod_radioid.db`), TG-list import fix, wide-band default. `.grok/` agent rules added (`272023b2`). |

### DMRModHooks release table (version → date → headline → APK present in `releases/`?)

Dates from `git log`/release-notes. "APK in `releases/`?" = whether a `DMRModHooks-vX.apk`
currently sits in the tracked `releases/` folder (only v3.3.8+ do — earlier APKs live only on GitHub
Releases / git tags). Git **tags** exist for most versions (`git tag`).

| Version | Date | Headline | APK in `releases/`? |
|---|---|---|---|
| v0.1 / v0.2 / v0.3 | Feb 18 2026 | First LSPosed hook; info-page hooks; module version display (first working release) | No |
| v0.9.26 | Feb 2026 | "FINAL" working OpenGD77 CSV export/import (digital+analog activate) | No |
| v0.9.27–v0.9.41 | Feb 23–24 2026 | Folder backups, squelch/CTCSS/DCS/contact-name/PDF/zip, OpenGD77 power/squelch conversions | No |
| v1.0 | Feb 24 2026 | First stable, branding removed | No |
| v1.1 | Feb 24 2026 | Flexible import folder names | No |
| v1.3.1–v1.3.7 | Feb 26 2026 | Location display, reverse geocode, elevation, dup-contact fix, DMR caller ID | No |
| v1.4.0 / v1.4.8 / v1.4.9 | Feb 26 2026 | Activity history; RSSI display; RSSI persistence | No |
| v1.6.0 | Feb 27 2026 | Per-channel transcription history | No |
| **v1.7.0** | Feb 27 2026 | User-friendly API-key config (**stable base**) | No |
| v1.9.0 | Feb 27 2026 | UART serial logging (`/dev/ttyS0`) — firmware-RE tooling | No |
| v2.0.0 | Feb 2026 | Call-type override fix (firmware always reports callType=0) — **never a public release** | No |
| v3.0.1 | Mar 4 2026 | Undocumented-command fuzzing infra (dev build) | No |
| v3.0.2 | Mar 4 2026 | Analog MON button + MacGyver branding (jumps past v2.x) | No |
| v3.0.3 | Mar 9 2026 | DMR audio fix (MON removed from DMR channels) | No |
| v3.0.4–v3.0.9 | Mar 9 2026 | GPS distance/bearing; zones (create/edit/assign); dual-unit distance | No |
| v3.1.0 | Mar 12 2026 | **APRS live monitoring** (RX dashboard, GPX logs) | No |
| v3.1.1–v3.1.4 | Mar 12–13 2026 | APRS crash recovery; software-squelch UI; state fixes | No |
| v3.1.5 / v3.1.6 | Mar 14 2026 | **VFO mode** + digital-mode state-machine fix | No |
| v3.2.2 / v3.2.3 | Mar 14 2026 | VFO SharedPrefs corruption fix; APRS channel filtering | No |
| v3.3.0–v3.3.3 | Mar 18 2026 | **SSTV live monitoring**; crash recovery; zone `_id` refactor; SSTV settings/received dialogs | No |
| v3.3.4 / v3.3.5 | Mar 18–19 2026 | **NOAA APT** reception (`cb590e30`, Mar 18); NOAA software-squelch slider (Mar 19) | No |
| v3.3.6 / v3.3.7 | Mar 19 2026 | TG-list direct DB write; GPS-over-SMS messaging | No |
| **v3.3.8** | Jun 1 2026 | OpenGD77 CPS fork v1.2.0 (lat/lon import, startup-crash fix) | ✅ |
| v3.3.9 | Jun 5 2026 | Group/Private swap fix, encrypt defaults | ✅ |
| v3.4.0 | Jun 5 2026 | Pitfall 12 (contact by DMR ID), channel-mode 3→4 | ✅ |
| v3.4.1 | Jun 5 2026 | CSVImporter legacy contact fix (4th file) | ✅ |
| v3.4.2 | Jun 12 2026 | 24-bit caller DMR-ID decode fix | ✅ |
| v3.4.3 | Jun 15 2026 | Caller/history panel layout | ✅ |
| v3.4.4 | Jun 16 2026 | RadioID.net global DMR-ID DB | ✅ |
| v3.4.5 | Jun 16 2026 | Double-slot import fix; squelch default; RadioID panel | ✅ |
| **v3.4.6** | Jun 21 2026 | TG-list import fix; wide-band default (**current**) | ✅ |

`releases/` also holds `3.3.8.mp4` (demo video), `RELEASE_NOTES.md` (cumulative, ends at v3.1.1 +
v0.9.26/v0.3 history), `v3.0.2_RELEASE_NOTES.md`, `XDA_v3.0.2_ANNOUNCEMENT.md`, and
`v3.4.2`–`v3.4.6` notes. A stray `DMRModHooks/releases/v3.0.9_RELEASE_NOTES.md` also exists.

---

## 2. Repository Map

Sizes are working-tree sizes (`du -sh`). `.git` pack is **~561 MB** (large binary history — APKs and
274 tracked OpenGD77 build zips). Tracked-file counts from `git ls-files`.

| Path | Size | Files (tracked) | What it is | Role |
|---|---|---|---|---|
| `DMRModHooks/` | 78 MB | 174 | The LSPosed/Xposed module — the actual product. `app/src/main/java/com/dmrmod/hooks/` (45 `.java` files; `MainHook.java` = 16,306 lines). | **Source of truth (product).** But ~57 loose junk files at its root (see §9). |
| `app/` | 72 MB | 1,177 | JADX-decompiled OEM app, rebranded `com.macgyver.dmr` "2.0-MacDMR" (versionCode 35). 246 `.java`. Bundles `DMR003.UV4T.V022.bin` + `whisper-tiny.en.tflite` (39 MB). | **Reference** (readable OEM Java). Pre-LSPosed rebuild era; still a Gradle module (`:app`) but not part of shipping. See §3. |
| `decompiled/` | 4.9 MB | 1,031 | apktool output of `com.pri.prizeinterphone.apk`, **versionName V1.0 / versionCode 33** (`decompiled/apktool.yml`). smali removed by `.gitignore`; keeps res + AndroidManifest. | **Reference** (resources/manifest of stock V1.0). |
| `original-decompiled/` | 110 MB | 8,805 | apktool output of `original-system.apk`, **versionName 2.0-MacDMR / versionCode 35** — the *rebuilt* APK re-decompiled. Full smali present (`smali`..`smali_classes4`). | **Reference** (smali of the rebuilt app). Largest tree. |
| `original-extracted/` | 6.3 MB | 1,820 | Raw unzipped APK contents (`resources.arsc`, `com/`, `android/`, assets). | **Reference/generated.** |
| `original_assets/` | 403 KB | 59 | PNGs pulled from the original APK (app icon, talkback sprites, AppCompat 9-patches). | **Reference asset dump.** |
| `radio_firmware/` | 34 MB | 21 | MCU firmware + RE artifacts: `DMR003.UV4T.V022-ORIGINAL.bin` (378,620 B, MD5 `4426…268E0`), `-PATCH14.bin`, `cmd_handler.c`, `firmware_decompiled.c`, `firmware_disassembly.txt` (32 MB), `ghidra_scripts/`, `ghidra_decompiled/project/`. | **Reference (RE).** ARM Cortex-M, uC/OS-III, base `0x08000000`. |
| `OpenGD77Fork/` | 752 MB | 276 | Compiled **binary** artifacts of the CPS fork: 138 `OpenGD77CPS-Mac_Build_*.zip`, 134 `RELEASE_NOTES_*.md`, one extracted build dir, and `DMRModHooks-signed.apk` (43.8 MB). | **Generated binaries.** Source lives in a *separate* repo (§6). Biggest disk hog. |
| `releases/` | 375 MB | 18 | Shipped APKs (v3.3.8–v3.4.6), demo mp4, release notes. | **Distribution artifacts.** |
| `docs/` | 2.0 MB | 84 | 83 research/design markdown + `MONITORING_MODE_DIAGRAM.txt` + the `deep-dive/` chapters. | **Knowledge base** (§4). |
| `scripts/` | 617 KB | 107 | Python/PowerShell/shell/cmd analysis, test & build scripts (§7). | **Tooling** (mostly historical). |
| `DMRTranscriptionService/` | 100 KB | 14 | Standalone AIDL transcription service (`com.macdmr.transcription`, v1.0.0). `TranscriptionService.java` calls **Google Cloud** `speech.googleapis.com` (see §9 contradiction). | **Source of truth (companion app).** |
| `.grok/` | — | 5 | AI agent rules + skill (§8). `copilot-instructions.md` (1,568 lines) is the full reference. | **Authoritative agent docs** (the tracked replacement for the untracked `.github/copilot-instructions.md`). |
| `.vscode/` | — | 1 | `settings.json` — Java auto-build config only. | Config. |
| Root loose files | — | — | `README.md` (77 KB, 1,546 lines), `AGENTS.md`, `LICENSE` (GPL-3.0), `build.gradle`/`settings.gradle`/`gradle.properties` (for the `:app` module), `gradlew*`, and **3 stray PNGs** (`0_9Spritesheet.png`, `0_9_NeonSprite.png`, `numbers0_9metal.png`). | Mixed. PNGs are UI-sprite scratch (only `numbers0_9metal.png` is used, copied into `DMRModHooks/app/.../res/drawable`, commit `7a8f623a`). |
| `.docs/` | **absent** | 0 (gitignored) | AI session logs / audit (`AI_LOGS_SUMMARY.md`, `PROJECT_AND_DOC_AUDIT_FOR_REVIEW.md`). Untracked by design; **does not exist on this checkout** yet `AGENTS.md`, `.grok/`, and `copilot-instructions.md` all point at it. | Missing dead reference (§9). |

**Gitignored (per `.gitignore`):** all `*.apk`/`*.aab`/`*.dex`/`*.class`, `build/`, `.gradle/`,
`*.keystore` (so `DMRModHooks/release.keystore` is untracked — `git check-ignore` confirms — and it is
**absent on this checkout**, even though `DMRModHooks/app/build.gradle` requires it for both debug and release signing),
`decompiled/smali*`, `local.properties`, `jadx*`, `.docs/`, `.ai-logs/`,
`.github/copilot-instructions.md`, `terminals/`, `temp/`. Note APKs in `releases/`/`OpenGD77Fork/`
are force-added despite `*.apk` being ignored.

### "What to read for X"

| Goal | Read |
|---|---|
| Orient a new session | `.grok/rules/00-session-start.md`, then `AGENTS.md` |
| Full project reference (schema, hooks, pitfalls) | `.grok/rules/copilot-instructions.md` (1,568 lines) |
| Shipped version (authoritative) | `DMRModHooks/app/build.gradle` |
| User-facing feature history | root `README.md` (per-version "What's New") |
| Module dev history & failed approaches | `DMRModHooks/README.md` (§ Development History) |
| OEM app Java behaviour | `app/src/main/java/com/pri/prizeinterphone/` (§3) |
| OEM resources/manifest (stock V1.0) | `decompiled/` |
| Firmware behaviour | `radio_firmware/` + `docs/FIRMWARE_*`, `docs/GHIDRA_*` |
| Codeplug CSV round-trip | `.grok/rules/key-files.md` + `docs/CHANNEL_PROPERTIES_REFERENCE.md` |
| Why a feature is impossible | §5 here, and (when present) `.docs/AI_LOGS_SUMMARY.md` §4 |
| Packet byte layouts | `.grok/rules/packet-layouts.md` |

---

## 3. Decompilation Provenance

Four decompiled/extracted trees exist because the project decompiled the app **twice** (once from the
stock APK, once from its own rebuild) via two tools (apktool + JADX):

| Tree | Source APK | versionName / code | package | Tooling | Contents |
|---|---|---|---|---|---|
| `decompiled/` | `com.pri.prizeinterphone.apk` | **V1.0 / 33** | `com.pri.prizeinterphone` | apktool 2.12.1 (`decompiled/apktool.yml`) | res + manifest + assets; smali gitignored |
| `original-decompiled/` | `original-system.apk` (the rebuilt one) | **2.0-MacDMR / 35** | (rebuilt) | apktool 2.7.0 (`original-decompiled/apktool.yml`) | full smali + res |
| `original-extracted/` | raw APK unzip | — | — | `unzip` | `resources.arsc`, dex-derived dirs, assets |
| `app/src/main/java/` | JADX of the APK, then Gradle-ized | build.gradle: **2.0-MacDMR / 35**, `applicationId com.macgyver.dmr`, `namespace com.pri.prizeinterphone` | `com.macgyver.dmr` | JADX 1.4.7→1.5.0 | 246 readable `.java` |

**Authoritative tree for reading OEM behaviour: `app/src/main/java/com/pri/prizeinterphone/`** —
it is the only *readable Java*, and the `.grok` rules and `DMRModHooks/README.md` both direct hook
authors there (e.g. `handler/DigitalAudioMessageHandler.java`, `manager/DmrManager.java`,
`serial/MessageDispatcher.java`, `serial/data/ChannelData.java`). Use `decompiled/`/`original-*`
smali only to confirm class paths or resources JADX mangled. Note `app/` also contains **stubs**
(e.g. `manager/PrizePcmManager.java`, `manager/PCMReceiveManager.java`) created to make the rebuild
compile — they are not the real OEM implementations.

**Known decompilation errors** (`docs/JADX_DECOMPILATION_ERRORS.md`): JADX produced broken control
flow in 5 methods, stubbed to compile — `FragmentNewContactsActivity.doInBackground()` (~L569) and
`InterPhoneLocalFragment.doInBackground()` (~L302) both `return null;` (contact/profile photos
won't load); `StateMachine.removeState()` lambda → `return false;` (state cleanup may leak);
`UtilInitChannelData` findFirst() needed an explicit cast; `AnimationViewBehavior` float→long cast.
Without stubs the tree had 18 compile errors. **Implication:** treat `app/` as a *reading* reference,
not a buildable/faithful copy of OEM logic in those methods.

### Why `app/` was rebranded, and why it was abandoned

`docs/SIGNATURE_ISSUE.md`, `docs/MACGYVER_MOD_STATUS.md`, `docs/STATUS.md`,
`docs/SUCCESS_REPORT.md`, and `DMRModHooks/README.md` § Development History document the arc:

1. The team JADX-decompiled the OEM app, fixed 56 compile errors, and rebuilt it — first as
   `com.pri.prizeinterphone.modded` (`SUCCESS_REPORT.md`, `scripts/rebrand-app.sh` sets `.modded`),
   then as `com.macgyver.dmr` "2.0-MacDMR" (versionCode 35) to add a "MacGyver Mod Version" field.
   `scripts/remove-system-uid.sh` strips `android:sharedUserId="android.uid.system"` to allow
   side-by-side user-app install.
2. **It could not access the DMR hardware.** The OEM app needs Ulefone's **platform certificate** to
   call the custom `PrizeTinyService` framework API and to run as system UID 1000 (hardware on
   `/dev/ttyS1`, `system:radio`). A re-signed APK gets a user UID and crashes with
   `NoSuchMethodError: PrizeTinyService.openRecvPcm()` (`DMRModHooks/README.md` Attempt 2).
3. **Systemization also failed:** placing the APK in `/system/priv-app/` grants location but not the
   platform-key UID (`3e03d002` "FAILED: Systemization via Magisk — caused bootloop";
   `docs/MAGISK_SOLUTION.md`, `docs/SIGNATURE_ISSUE.md` `INSTALL_FAILED_UPDATE_INCOMPATIBLE`).
   `scripts/create_systemizer_module.py` / `create_serial_module.py` built the (failed) Magisk zips.
4. **Pivot to LSPosed** (`docs/LSPOSED_SUCCESS.md`, `73a9535c`): hook the *original, untouched,
   properly-signed* app in-process — it keeps its platform signature and system UID, so
   `PrizeTinyService` works. No APK re-signing.

So `app/` is a **historical dead-end reference tree**, kept because its readable Java is the best way
to see OEM internals. The root `build.gradle` (`plugins { id 'com.android.application' version
'7.4.2' apply false }`), `settings.gradle` (`rootProject.name = "PrizeInterphone"; include ':app'`)
still wire it as a Gradle module and it *may* still assemble, but it is **reference-only** — it can
never run against real hardware and is not part of any release. `local.properties` is absent (needs
regenerating to build).

---

## 4. Knowledge Index of `docs/`

83 `.md` files (+ `MONITORING_MODE_DIAGRAM.txt`), grouped by theme. "First tracked" dates from `git log --diff-filter=A`. Status reflects
whether the doc still describes current reality.

### Firmware / Ghidra RE (all superseded by the "hard constraints", kept as evidence)

| File | Summary | Status | Related |
|---|---|---|---|
| `DMR_GROUP_CALL_ISSUE.md` / `DMR_GROUP_CALL_RESEARCH.md` | Radio receives only private calls to its own DMR ID; group calls ignored despite RX group list. "HARDWARE LIMITATION CONFIRMED." | Historical / dead end | firmware, `hookDigitalAudioHandler` |
| `MONITORING_MODE_INVESTIGATION.md` / `_IMPLEMENTATION.md` / `_TESTING.md` / `_QUICK_START.md` / `_DIAGRAM.txt` | contactType=2 ("ALL") toggle to bypass group filter; firmware ignores it. | Dead end | MON mode |
| `DMR_FIX_ROADMAP.md` | Ranks workarounds by feasibility after hardware rejected ALL mode; UART logging was priority #1 (became v1.9.0), firmware patch the high-impact option (70% est.). | Historical | firmware |
| `FIRMWARE_ANALYSIS_SUMMARY.md`, `DMR_FIRMWARE_PROJECT_STATUS.md`, `FIRMWARE_FLASHING_EXPLORATION.md` | Firmware = ARM Cortex-M, uC/OS-III, 378 KB, base `0x08000000`; bug at `0x08018F2C` (BLS skips group-ID extraction). Flashing explored. | Historical | `radio_firmware/` |
| `FIRMWARE_PATCH_RESULTS.md`, `PATCH9_ANALYSIS.md`, `PATCH12_BREAKTHROUGH.md`, `PATCH14_BREAKTHROUGH.md`, `CONTACTTYPE_LOCATIONS_ANALYSIS.md` | 14 patch attempts (CBZ/BLS/BGT NOPs at 5 contactType locations); **0/14 worked**. | Dead end | `DMR003…-PATCH14.bin` |
| `PATCH_RELOAD_TEST_RESULTS.md`, `DMR_FIRMWARE_RELOAD_NOTES.md`, `INTEGRATION_GUIDE.md` | Runtime firmware reload via DMRDEBUG.bin/YModem; UART bootloader probe → **EACCES on `/dev/ttyS1`** (Xposed can't open /dev). Reload feature disabled 2026-03-09. | Dead end / disabled | `PatchReloadHelper.java`, `UARTBootloaderProbe.java` |
| `GHIDRA_ANALYSIS_PLAN.md` / `_STATUS.md` / `_NAVIGATION_GUIDE.md`, `QUICK_GHIDRA_GUIDE.md`, `RUN_AUTOMATED_ANALYSIS.md`, `DECOMPILATION_README.md`, `DECOMPILATION_STATUS.md` | How to Ghidra the firmware; Locations 1 & 3 proven NOT in RX path. | Historical | `ghidra_scripts/` |
| `QUICKSTART.md` | Firmware-decompilation quick start (install Java + Ghidra, then `run_ghidra.ps1`); header says "BLOCKED: need Java + Ghidra". | Historical setup guide | `FILE_INDEX.md`, `run_ghidra.ps1` |
| `COMMAND_FUZZING_GUIDE.md`, `V3.0.1_DEVELOPMENT_SUMMARY.md` | Fuzz 227 undocumented serial commands to bypass filter. | Historical / dead end | fuzzer scripts |
| `V2.0.0_CALL_TYPE_OVERRIDE_FIX.md` | Firmware always reports callType=0 in CMD 0x2B; hook override of the response is ignored (HW filters before RECEIVE_START). | Historical | UART hook |
| `V1.9.0_UART_LOGGING.md` | UART logging on `/dev/ttyS0` (v1.9.0) — the tooling that enabled all serial RE. | Active (feature shipped) | `hookSerialCommunication` |
| `IMMEDIATE_ACTIONS.md`, `PHASE2_ANALYSIS_ACTION_PLAN.md` | Ulefone support email; hunt for DMR003 chip docs (found none). | Historical | — |
| `FILE_INDEX.md` | Index of the firmware-RE doc set (Feb 28). | Historical index | docs |

### APRS

| File | Summary | Status | Related |
|---|---|---|---|
| `APRS_TX_INVESTIGATION_FINAL_REPORT.md` | **Definitive:** APRS TX impossible — radio voice-DSP destroys AFSK (96%→27% energy); 6 methods, 0/6. AFSK gen is perfect (direwolf decodes the WAV). | **Active constraint** | `AFSKGenerator.java` (ref only) |
| `APRS_TX_PROBLEM.md`, `APRS_FREQUENCY_AND_TX_INJECTION.md` | Earlier TX-injection attempts (writeFrame/PrizeTinyService). | Superseded by TX final report | — |
| `APRS_DECODING_ISSUES.md`, `APRS_DECODING_STATUS.md`, `APRS_FIXES_APPLIED.md`, `APRS_ANDROID_INTEGRATION_FIXES.md`, `DECODER_TESTING_GUIDE.md` | RX AFSK decode debugging; 5 NRZI/bit-stuff fixes; direwolf decodes 3/5. | Historical (RX now works) | `AFSKDecoderIQ.java`, `APRSPacketDecoder.java` |
| `ANDROID_APRS_RECEIVER_IMPLEMENTATION.md`, `APRS_COMPLETE_SYSTEM_SUMMARY.md`, `APRS_CLEANUP_AND_RX_IMPROVEMENT_PLAN.md` | RX architecture; plan to strip TX code (kept for reference). | Historical / active reference | APRS classes |
| `DIREWOLF_INTEGRATION.md` | Abandoned NDK/JNI direwolf port (too complex) → pure-Java PLL instead. | Dead end | `DireWolfDecoder.java` (unused) |
| `REAL_RADIO_TESTING_GUIDE.md` | How to record real APRS audio for testing. | Active reference | `record_real_aprs.py` |

### SSTV

| File | Summary | Status | Related |
|---|---|---|---|
| `SSTV_IMPLEMENTATION_RESEARCH.md` | Feasibility (FM tones 1500±400 Hz); ~2–3 wk estimate. | Historical | SSTV classes |
| `SSTV_DECODING_PROBLEM.md`, `SSTV_FM_DEMOD_PROBLEM.md` | Phase-1 VIS detection 100%, image decode = noise at 8 kHz. | Superseded by IQ rewrite | — |
| `ROBOT36_ANALYSIS.md`, `ROBOT36_AUTO_DETECTION.md`, `SSTV_REFERENCE_DECODER_ANALYSIS.md` | Studied robot36-2 (IQ) + colaclanth/sstv (FFT) reference decoders. | Reference | `com.example.dmrmodhooks.sstv.*` |
| `SSTV_IQ_REWRITE_SUMMARY.md`, `SSTV_PHASE1_COMPLETE.md` | Complete IQ-baseband rewrite ported from robot36-2 → the shipping SSTV decoder (v3.3.0). | Active reference | `SSTVImageDecoderIQ.java` |

### NOAA / squelch / MON / relay / VFO / transcription / codeplug

| File | Summary | Status | Related |
|---|---|---|---|
| `SQUELCH_HARDWARE_LIMITATION.md` | Firmware coerces sq 1,3–9 → 2; only sq=0/sq=2 distinct. | **Active constraint** | `enableSoftwareSquelchOnCurrentChannel` |
| `SOFTWARE_SQUELCH_DESIGN.md` | SDR-style software squelch on sq=0 (RSSI+RMS gate in PCM hook). | Active reference | `hookPCMReceiveManager` |
| `ANALOG_MON_FEATURE.md` | MON opens squelch on analog; hidden on DMR (ALL mode broken). | Active reference | MON button |
| `RELAY_REPEATER_ANALYSIS.md`, `RELAY_TODO_LIST.md`, `RELAY_HELP_DIALOG_RELEASE.md`, `COMPOUND_KEY_REVERT_GUIDE.md` | Relay/repeater is a working OEM feature; relay=0 invalid (import coerces 0→2); help dialog (Mar 26); zone compound-key toggle. | Active reference | `DirectDatabaseImporter`, importer |
| `VFO_IMPLEMENTATION_PLAN.md` | Full VFO design (channel-hijack pattern). | Active reference (shipped v3.1.5) | VFO code in `MainHook` |
| `CHANNEL_PROPERTIES_REFERENCE.md` | Complete channel-field reference (types, valid values, analog/digital visibility). | **Active reference** | `ChannelData`, channel editor |
| `TRANSCRIBING_PLAN.md` | Vosk incompatible with LSPosed (JNA/ClassLoader); pivot to TFLite. | Historical | transcription |
| `IPC_SERVICE_IMPLEMENTATION_PLAN.md` | Plan for on-device TFLite Whisper-Tiny via AIDL bound service. | **Partially superseded** — the AIDL service shipped as `DMRTranscriptionService` but the shipped path is **cloud** Whisper, not on-device TFLite. | `DMRTranscriptionService/` |
| `TODO_MODEL_DOWNLOAD.md`, `whisper_android_readme.md` | Runtime model-download plan; upstream whisper-android README. | Not started / reference | assets |

### History / status / hygiene / decompilation

| File | Summary | Status | Related |
|---|---|---|---|
| `STATUS.md`, `MACGYVER_MOD_STATUS.md`, `SUCCESS_REPORT.md`, `SIGNATURE_ISSUE.md`, `MAGISK_SOLUTION.md`, `LSPOSED_SUCCESS.md`, `SESSION_SUMMARY.md`, `CONTINUATION_NOTES.md`, `QUICK_REFERENCE.md` | The rebuild→Magisk→LSPosed narrative (Feb 17–18). `QUICK_REFERENCE.md` still references the abandoned `com.pri.prizeinterphone.modded`. | Historical | §3 |
| `PUSH_TO_GITHUB.md`, `REPO_CLEANUP_TODO.md` | Old push guide (WSL git); cleanup list of failed APK/Magisk artifacts — "NOT YET EXECUTED" but those files are already gone from the tree. | Stale/historical | §9 |
| `JADX_DECOMPILATION_ERRORS.md`, `DECOMPILATION_README.md`, `DECOMPILATION_STATUS.md` | JADX broken-method list; firmware-decompile how-to/status. | Reference | §3 |
| `PHASE2_PLAN.md`, `RELEASE_V3.0.1.md`, `release_notes_v332.md`, `release_notes_v334.md` | OpenGD77 CSV plan; misc release notes. | Historical | codeplug |

`docs/deep-dive/` holds this chapter set (00-README plus chapters 01–14; 13 = this file).

---

## 5. Dead Ends & Hard Constraints

Consolidated from `.grok/rules/00-session-start.md` §3, `copilot-instructions.md` § Hard Constraints,
and the evidence docs. **Do not re-investigate without new hardware evidence.**

| Constraint | Reality | Evidence |
|---|---|---|
| **APRS TX over analog FM** | Impossible. Voice-DSP destroys AFSK (96%→27% energy, spurious 1001 Hz); 6 TX methods (writeFrame @8/48 kHz, pre-emphasis, AudioTrack, AudioRecord inject) all failed. AFSK gen itself is perfect. Needs external TNC. `AFSKGenerator.java` kept as reference only. | `docs/APRS_TX_INVESTIGATION_FINAL_REPORT.md`, `APRS_TX_PROBLEM.md` |
| **Hardware LED control** | No GPIO/sysfs/serial command in app or 0x22–0x3C range; MCU-only. | `copilot-instructions.md` §Serial Protocol |
| **DMR group-call RX** | Firmware ignores RX group list; receives only private calls to own DMR ID. contactType=2 accepted but still filtered (HW filters before RECEIVE_START). | `DMR_GROUP_CALL_ISSUE.md`, `MONITORING_MODE_INVESTIGATION.md`, `V2.0.0_CALL_TYPE_OVERRIDE_FIX.md`, `V3.0.1_DEVELOPMENT_SUMMARY.md` |
| **>32 TG IDs per channel** | `ChannelData.groups` is `int[32]`; and `DigitalAudioMessage` body doesn't expose the destination-TG offset, so SW filtering of overflow TGs is blocked. | `.grok/rules/packet-layouts.md`, session-start §3 |
| **Squelch levels 1,3–9** | Firmware coerces every non-zero sq to 2; only sq=0 (open) and sq=2 (tight) are distinct. Hence software squelch runs on top of sq=0. | `docs/SQUELCH_HARDWARE_LIMITATION.md`, `SOFTWARE_SQUELCH_DESIGN.md` |
| **Firmware patching (group-call fix)** | 14 patches at 5 contactType/CBZ/BLS locations, 0/14. Locations 1 & 3 proven not in RX path. Ghidra full decompile did not yield a working patch. | `FIRMWARE_PATCH_RESULTS.md`, `PATCH9/12/14_*`, `DECOMPILATION_STATUS.md` |
| **Permanent firmware flash / bootloader** | `/dev/ttyS1` returns EACCES to Xposed (runs in app ctx, can't open /dev); HR_C6000 bootloader undocumented. Runtime reload via DMRDEBUG.bin worked but was disabled 2026-03-09. | `PATCH_RELOAD_TEST_RESULTS.md`, `DMR_FIRMWARE_RELOAD_NOTES.md` |
| **On-device Whisper (TFLite)** | Researched, prototyped (39 MB `whisper-tiny.en.tflite` bundled in `app/assets`), not shipped. Vosk incompatible with LSPosed (JNA/ClassLoader). Shipped path = **cloud** Whisper API. | `TRANSCRIBING_PLAN.md`, `IPC_SERVICE_IMPLEMENTATION_PLAN.md`, `TODO_MODEL_DOWNLOAD.md` |
| **IPC transcription service (on-device)** | The AIDL bound-service *shell* shipped (`DMRTranscriptionService`), but the planned on-device TFLite inference never became the production path — cloud API is used instead. | `IPC_SERVICE_IMPLEMENTATION_PLAN.md` vs shipped code |

---

## 6. OpenGD77 CPS Fork History

A Windows/.NET WinForms fork of OpenGD77 CPS (codeplug editor), **patched specifically for the
PriInterPhone/DMRModHooks Android CSV round-trip** (37-col CSV with `_id`, relay 0→2 coercion,
0/1-based timeslot, contact-by-DMR-ID). It is **NOT** upstream and **will corrupt a real Radioddity
GD-77 codeplug** — the About dialog carries a red warning.

- **Source location:** a **separate git repo**, not in this tree —
  `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac`, published at
  `https://github.com/IIMacGyverII/OpenGD77CPS-Mac` (`.grok/rules/key-files.md`, release notes).
  Built with `msbuild OpenGD77CPS.sln /p:Configuration=Release` → `OpenGD77CPS.exe`. Despite
  "-Mac" in the name the builds are **Windows** binaries (WinForms + `WeifenLuo…Docking.dll`).
- **In this repo:** only compiled `OpenGD77CPS-Mac_Build_YYYYMMDD_HHMMSS.zip` artifacts (138 of them,
  752 MB) + `RELEASE_NOTES_*.md` (134). Not a submodule. Latest attached to releases:
  `OpenGD77CPS-Mac_Build_20260607_210202.zip` = **fork v2.0.45**.
- **Fork version source of truth:** `DMR/AboutForm.cs` → `FORK_VERSION`. Rule: bump PATCH on every
  build attached to a DMRModHooks release; re-attach the same zip if unchanged
  (`copilot-instructions.md` §Fork Versioning).

### Versioning rule tying fork ↔ DMRModHooks (quoted)

- `RELEASE_NOTES_20260601.md` (fork v1.2.0): "**Paired Android release** | DMRModHooks **v3.3.8+**
  … phone import fixes through **v3.4.0** are in `DirectDatabaseImporter`/`DirectDatabaseExporter`,
  not in this CPS binary."
- `RELEASE_NOTES_..._v1.2.3.md`: pairs with DMRModHooks v3.4.0. `..._v1.3.0.md`: "**Pair with**
  DMRModHooks **v3.4.0+**."
- `copilot-instructions.md`: "**every DMRModHooks GitHub release must attach the latest
  `OpenGD77Fork/*.zip`** … reuse previous zip if fork unchanged." Confirmed in the v3.4.2–v3.4.6
  release notes, which all ship the same unchanged v2.0.45 zip.

There is **no fixed numeric mapping** (fork 1.x/2.x does not equal module 3.3.x/3.4.x); the fork
versions independently and is simply pinned per release.

### Condensed fork version history (by minor)

| Minor | Date range | Release-notes files | Headline changes |
|---|---|---|---|
| (baseline) `20260329` | Mar 29 2026 | 1 | First fork build: relay 0→2 export, outbound-slot 1→0-based export (`ChannelsForm.cs`). Ships with DMRModHooks v3.3.7. |
| **1.1.x** | May 31 – Jun 1 2026 | no notes file (mentioned in `RELEASE_NOTES_20260601.md`) | Startup-crash fix, layout, clear stale CSV arrays on import (build zips 20260531/20260601). |
| **1.2.x** | Jun 1–5 2026 | 4 | Lat/lon/UseLocation import (v1.2.0, w/ v3.3.8); UI Tier-1 (welcome/theme/Advanced menu/health, v1.2.2); File-menu fix (v1.2.7). |
| **1.3.x** | Jun 5 2026 | 7 | Pre-import diff preview (v1.3.0); MTP folder picker; ADB pull/push backups; integrity checker (unresolved-ID/relay=0 flags). |
| **1.4.x** | Jun 5 2026 | 10 | RadioID.net DMR-ID lookup (v1.4.5); contacts-grid fixes; codeplug health panel (v1.4.9). |
| **1.5.x** | Jun 5 2026 | 10 | Menu declutter/help; Segoe UI; channel-editor Android grouping; toolbar/grid polish; WebView2 hybrid spike (v1.5.9). |
| **1.6.x** | Jun 5–6 2026 | 10 | Visible WebView2 HTML health reports; grid badges; health drill-down; single-click editors. |
| **1.7.x** | Jun 6 2026 | 10 | Contacts-grid crash fixes; channel/contact/zone/scan/DTMF editor DPI passes; F7 health click-to-open + auto-refresh. |
| **1.8.x** | Jun 6–7 2026 | 10 | Zones/TG/Rx/Scan overview grids; CSV UTF-8 guard; General/Menu/Button/stock editor DPI. |
| **1.9.x** | Jun 7 2026 | 28 | VFO+utility editor DPI milestone; **Codeplug Studio** MVP → polish/redesign/`--studio` launch; import health in report; F8↔Studio parity. |
| **2.0.x** | Jun 7–8 2026 | 44 (v2.0.43/44 have no notes file) | Thin Codeplug Studio launcher (`CodeplugStudio.cmd`, v2.0.0 MAJOR); Ctrl+Shift+F tree filter everywhere; post-import F7 health cues/badges; pre-import diff status chips; footer layout modernization (v2.0.45, shipped w/ v3.4.2–v3.4.6). |

The fork's post-v1.4 work is almost entirely **desktop UX** (DPI, grids, health reports, Studio) —
the CSV round-trip *logic* had largely stabilized by v1.3.x; later Android import fixes live in the
DMRModHooks Java side, not the CPS binary.

`OpenGD77Fork/DMRModHooks-signed.apk` (43.8 MB) is a stale signed module build parked in the fork
folder (comparable in size to `releases/DMRModHooks-v3.3.8.apk`); the release process now keeps APKs
in `releases/`, so this one is a leftover.

---

## 7. Scripts Index (`scripts/`, 107 files)

Overwhelmingly **historical single-use RE/analysis tooling**; almost none are part of the current
build/deploy flow (that's `DMRModHooks/install.ps1`). Many hard-code
`C:\Users\Joshua\Documents\android\...` absolute paths and an `adb.exe` under `%LOCALAPPDATA%`.

| Category | Scripts | Purpose (one-line) | Status |
|---|---|---|---|
| **Firmware / Ghidra / patches** | `decompile_firmware.ps1`, `decompile_firmware_simple.ps1` | Automated Ghidra headless decompile | **BROKEN** — PowerShell/Java-embedding syntax errors (`docs/FILE_INDEX.md`, `DECOMPILATION_STATUS.md`) |
| | `run_ghidra.ps1`, `quick_decompile.cmd` | Simple Ghidra automation + batch launcher | Working (per FILE_INDEX) |
| | `arm_disasm.py`, `ghidra_disassemble.py` | ARM-Thumb disassembler / Ghidra script | Working tool |
| | `analyze_cmp_locations.ps1`, `detailed_location_analysis.ps1`, `find_contacttype_bug.ps1` | Locate/decode `cmp r2,#2` contactType sites | Working |
| | `create_patch11.ps1`, `create_patch14.ps1`, `create_patch14_simple.ps1` | Build firmware patch .bin (NOP CBZ/BLS) | Working; patches themselves 0/14 effective |
| | `fix_nvram.py`, `bootloader_tester.ps1`, `payload_tester.ps1`, `payload_tester_simple.ps1` | NVRAM stub patch; UART bootloader/payload probes | Historical (bootloader = EACCES dead end) |
| **Command fuzzing** | `command_fuzzer_executor.py`, `quick_fuzzer.py`, `quick_fuzzer_auto.py`, `undocumented_command_fuzzer.py` | Enumerate 227 undocumented serial commands | Historical |
| **APRS audio analysis** | `analyze_aprs_audio.py`, `analyze_audio.py`, `analyze_our_audio.py`, `analyze_working_aprs.py`, `analyze_direwolf_reference.py`, `analyze_test_gen.py`, `aprs_generator_fixed.py`, `aprs_generator_test.py`, `record_real_aprs.py`, `parse_full_packet.py`, `decode_gen_audio.py`, `decode_our_audio.py`, `decode_working_file.py`, `extract_nrzi_bits.py`, `debug_nrzi.py`, `count_syncs.py`, `count_syncs2.py`, `verify_phase_increments.py`, `find_initial_phase.py`, `examine_closing_flag.py`, `improved_tone_detect.py`, `simple_tone_test.py`, `test_goertzel.py`, `detailed_bit_analysis.py`, `check_*` (amplitude/audio_length/flag_stuffing/our_audio_start/specific_samples), `compare_*` (bit_patterns/direwolf_vs_ours/first_flag/samples_detail/wav_files/waveforms), `test_*` (all_encodings/android_audio/bit_stuffing/flags_only/minimal_aprs/minimal_flags/pure_tones/ultra_minimal) | AFSK gen/decode debugging vs direwolf reference | Historical (APRS RX shipped; TX abandoned) |
| **SSTV** | `gen_martin_m1.py`, `gen_robot72.py`, `regenerate_scottiedx.py`, `check_scottiedx_wav.py`, `analyze_sstv_decoded.py`, `analyze_sstv_detection.py` | Generate/validate SSTV test signals & diagnose decode | Historical |
| **Transcription / model conversion** | `convert_tf_to_tflite.py`, `convert_whisper_to_tflite.py`, `generate_model_vilassn.py` (**0 bytes — empty**), `generate_whisper_tflite.ipynb`, `find_base_models.py`, `check_tflite_repos.py`, `check_vilassn_models.py`, `check_whisper_formats.py`, `search_issues_for_models.py`, `search_whisper_tflite.py`, `wrap_tryatch.py` | Whisper→TFLite conversion & model hunting | Historical (on-device Whisper dropped) |
| **Transcription test (device)** | `test-onnx-transcription.ps1`, `test-whisper-inference.ps1`, `test-transcription-auto.ps1`, `test-wav-direct.ps1`, `test-fft-performance.ps1`, `start-transcription-logs.ps1`, `automated-test-loop.ps1`, `iterate-until-success.ps1`, `quick-test.ps1`, `record-test-audio.ps1` | Rebuild/install/test transcription until output matches | Historical |
| **Build / deploy / debug** | `install-and-debug.sh`, `install-debug.ps1`, `monitor-logs.ps1`, `debug-monitor.cmd`, `live_call_monitor.ps1`, `convert-icon.sh` | Install APK, tail logcat, monitor calls, gen icons | Superseded by `DMRModHooks/install.ps1` |
| **Pre-LSPosed legacy tooling** | `rebrand-app.sh`, `remove-system-uid.sh`, `create_systemizer_module.py`, `create_serial_module.py` | See below | Historical dead ends |
| **DB / CSV utilities** | `check_contact.py`, `check_db.py`, `update_channel.py`, `compare_zones.py`, `fix_csv_header.py`, `validate_csv.py`, `add_id_column_skip.ps1` | Inspect channel/contact DBs, fix/validate CSV headers | Utility (some target the CPS `.cs` source path) |

**Legacy tooling detail** (all part of the abandoned rebuild era, §3):
- `rebrand-app.sh` — sed-rewrites `app/build.gradle` applicationId to `com.pri.prizeinterphone.modded`,
  changes app name/versionName, for a side-by-side user-app install.
- `remove-system-uid.sh` — strips `android:sharedUserId="android.uid.system"` from the rebuilt
  manifest, rebuilds, copies APK out — the attempt to run as a plain user app.
- `create_systemizer_module.py` — zips `magisk-systemizer/` into `MacGyverDMR-Systemizer.zip` (Magisk
  systemization, bootlooped).
- `create_serial_module.py` — zips `magisk-serial-module/` into `serial-access-module.zip` (Magisk
  module to grant `/dev/ttyS1` access, failed).

**Absolute-path note:** many scripts write/read hard-coded machine paths outside the repo
(`C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac\...`, `/home/joshua/phonedmrapp/...`,
`C:\Users\Joshua\.cache\huggingface\...`), so they are not portable and are effectively personal
history.

---

## 8. Working Agreements (from `.grok/` and `AGENTS.md`)

Source: `AGENTS.md`, `.grok/rules/00-session-start.md`, `.grok/skills/phonedmrapp/SKILL.md`,
`.grok/rules/copilot-instructions.md`.

- **Session start:** read `.grok/rules/00-session-start.md` first every session (`AGENTS.md`).
- **Version truth:** `DMRModHooks/app/build.gradle` `versionName`/`versionCode` — "docs may lag";
  "if docs and code disagree, the code wins — then patch the docs."
- **Deploy/reboot rule (mandatory):** after any successful DMRModHooks install, the agent must run
  `adb reboot` itself (LSPosed loads hooks at boot). Preferred: `cd DMRModHooks; .\install.ps1`
  (builds `assembleDebug`, `adb install -r -t`, then `adb reboot` on success). Never tell the user
  to reboot instead. DMRTranscriptionService alone may not need reboot.
- **Release policy:** only create releases when the user explicitly asks; do not auto-bump versions
  or publish after routine fixes. Every module GitHub release must attach the latest
  `OpenGD77Fork/*.zip` (reuse the previous zip if unchanged).
- **Signing:** debug and release share `DMRModHooks/release.keystore` (store/key pass `android`,
  alias `dmrmodhooks`). Never change debug signing — a mismatch disables the LSPosed module and
  forces a manual re-enable. Always install with `-r` (never uninstall).
- **Doc hygiene:** when a fix contradicts written docs, patch `.grok/rules/` (and
  `.github/copilot-instructions.md` if it exists locally) in the same change; grep before trusting DB
  column names, `ChannelData` fields, hook signatures, packet layouts.
- **Gitignored private docs:** never `git add -f` or otherwise commit `.docs/` or
  `.github/copilot-instructions.md`; if accidentally tracked, `git rm --cached` them (they were
  untracked in `3623ba8f`). The `.grok/rules/copilot-instructions.md` clone **is** tracked and is
  the public reference.
- **Coding discipline:** change only what the task needs; match `MainHook.java` style; wrap hooks in
  try-catch + `XposedBridge.log(TAG…)`; UI on `Handler(Looper.getMainLooper())`; shared state as
  `volatile static`.
- **OpenGD77 fork safety:** it is not upstream — do not use it on a real GD-77; source is the
  separate `OpenGD77CPS-Mac` repo, only zips live here.

---

## 9. Hygiene Observations (factual)

1. **Two READMEs disagree on current version.** Root `README.md` is current (v3.4.6);
   `DMRModHooks/README.md` header still says "**Current Version: v3.1.3**" (its "What's New" sections stop at
   v3.1.3) — deeply stale for the module's own README.
2. **Stale version strings elsewhere:** `.grok/rules/00-session-start.md` says "currently **v3.4.1**"
   while build.gradle is 3.4.6; `copilot-instructions.md` §Version History ends at v3.3.7 and quotes
   fork "current shipped v1.2.7"; root README install/test steps still show a "v3.0.9" verification
   toast, and its "Quick Facts" block (~L915) plus the "Prior Release" banner still say v3.3.2. The build.gradle is the
   only reliable source.
3. **~57 loose binaries/logs at `DMRModHooks/` root are tracked and don't belong in git** (65 root files minus the 8 legitimate gradle/LICENSE/README ones): 29 `.wav`
   (`aprs_*`, `hackrf_*`, `latest_*`, `rx_test.wav`), multi-MB logcat/debug dumps
   (`logcat_test2.txt` 4.5 MB, `import_full_log.txt` 4.7 MB, `blackscreen_*` 2.6/2.4 MB,
   `final_test.txt` 3 MB, `attachbase_test.txt` 1.7 MB), `.db` files (`temp_channels.db` and
   `verify_db.db` are 0 bytes), CSVs, a `backup_summary_v935.pdf`, plus stray helper scripts
   (`install.ps1`, `download-vosk-model.ps1`, `update_locations.py`, `test_*bootloader*.ps1`). These
   are debugging scratch that predate the `docs/`/`scripts/` reorg and were never cleaned up.
4. **`DMRModHooks/OpenGD77_Backup/20260226_093618/`** (a full CSV+PDF+zip codeplug backup, 1.1 MB) is
   tracked — a personal backup snapshot, not project source.
5. **Dead package `com.example.dmrmodhooks`:** `DMRModHooks/app/.../com/example/dmrmodhooks/sstv/`
   holds the SSTV IQ helpers (real), but there is also a **stray duplicate**
   `DMRModHooks/src/main/java/com/example/dmrmodhooks/sstv/SSTVPhaseDemod.java` outside the `app/`
   module — an orphan file in a non-source path.
6. **`.docs/` is referenced but absent.** `.grok/rules/*` and `copilot-instructions.md` send readers to
   `.docs/AI_LOGS_SUMMARY.md` (dead-end history) and `.docs/PROJECT_AND_DOC_AUDIT_FOR_REVIEW.md`, but
   `.docs/` is gitignored and does not exist on this checkout (it was tracked, then removed in
   `3623ba8f`). `AGENTS.md` now flags it as "absent on some checkouts" and points to this chapter
   (§5) as the in-repo substitute; the `.grok` rules do not yet carry that caveat.
7. **Repo weight:** `.git` pack ≈ 561 MB, dominated by `OpenGD77Fork/` (752 MB working tree, 274
   tracked files incl. 138 build zips) and `releases/` (375 MB of APKs + a 2.3 MB mp4). `*.apk` is in
   `.gitignore` yet release/fork APKs are force-added, so the ignore rule is effectively bypassed for
   distribution.
8. **`REPO_CLEANUP_TODO.md` / `PUSH_TO_GITHUB.md` are stale:** they describe a Magisk/WSL era and a
   cleanup "NOT YET EXECUTED", but the failed artifacts they list are already gone and the workflow
   they describe (WSL `git`, systemizer zips) no longer applies.
9. **Empty/placeholder files:** `scripts/generate_model_vilassn.py` is 0 bytes;
   `DMRModHooks/temp_channels.db` and `verify_db.db` are 0 bytes.

### Contradictions found between documents

- **Transcription backend:** root `README.md` and `DMRModHooks/README.md` say transcription uses the
  **OpenAI Whisper API** ("$0.006/min"), but `DMRTranscriptionService/.../TranscriptionService.java`
  actually calls **Google Cloud** `https://speech.googleapis.com/v1/speech:recognize`, and the older
  README "Transcription Architecture" section also says "Google Cloud Speech-to-Text v1." The user-
  facing docs (OpenAI) contradict the shipped service code (Google) — the code is authoritative.
- **On-device vs cloud Whisper:** `IPC_SERVICE_IMPLEMENTATION_PLAN.md` commits to on-device TFLite
  Whisper-Tiny via AIDL, and `app/src/main/assets/whisper-tiny.en.tflite` (39 MB) is bundled, but the
  shipped path is a cloud API. On-device inference was never the production path.
- **APRS RX status flips within the doc set:** `APRS_DECODING_ISSUES.md` states "APRS TX works
  perfectly, RX completely failing"; `APRS_TX_INVESTIGATION_FINAL_REPORT.md` concludes the exact
  opposite ("RX 100% functional, TX impossible"). The final report is the correct, later verdict —
  the earlier doc predates the TX hardware finding.
- **Target radio identity:** `APRS_TX_INVESTIGATION_FINAL_REPORT.md`/`APRS_TX_PROBLEM.md` name the
  radio "**TYT MD-UV380 DMR Handheld**", and the same name recurs in `DMR_FIX_ROADMAP.md`,
  `MONITORING_MODE_INVESTIGATION/QUICK_START/TESTING.md`, `PATCH12_BREAKTHROUGH.md` and
  `QUICK_GHIDRA_GUIDE.md` (8 docs total), while both READMEs, `FIRMWARE_FLASHING_EXPLORATION.md` and
  the `.grok` rules name the device the **Ulefone Armor 26 Ultra** (integrated PriInterPhone DMR
  module). The MD-UV380 references are a mislabel (probably from a generic HR_C6000/AFSK writeup);
  the actual hardware is the Ulefone.
- **v3.3.8 Pitfall-12 claim:** the v3.3.8 notes originally claimed the contact-DMR-ID fix landed in
  all four Java files, but the current README explicitly corrects this — the Java fix actually shipped
  in **v3.4.0** (root `README.md` "What's New in v3.3.8" note).
- **Version strings:** see hygiene items 1–2 (module README v3.1.3, session-start v3.4.1,
  copilot-instructions v3.3.7, README toast v3.0.9) all disagree with build.gradle v3.4.6.
