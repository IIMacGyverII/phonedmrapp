# 01 — Architecture rechecked against the live tree

HEAD is `ba6431cb` (unreleased 3.4.7-candidate) on top of shipped **v3.4.6**. Claude’s chapters describe commit `14e484a2`. Two documentation commits and one bug-fix commit landed after that.

---

## 1. The product, stripped of mythology

Three runnable artifacts, one radio:

```
Ulefone Armor 26 Ultra (Android 13)
├── com.pri.prizeinterphone     OEM radio app (platform-signed, cannot be rebuilt)
│     LSPosed injects ──► com.dmrmod.hooks (DMRModHooks) into the same process
├── com.macdmr.transcription    DMRTranscriptionService (separate APK, AIDL)
└── radio MCU                   DMR003.UV4T.V022 over /dev/ttyS0 @ 57600
```

Desktop: OpenGD77 CPS **fork** (not upstream) at `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac`, zip artifacts in `OpenGD77Fork/`.

The overlay exists because a rebuilt OEM APK loses the platform signature and then loses `/dev/ttyS0` + `PrizeTinyService`. That is still the right constraint.

---

## 2. Control vs voice vs data

Independently confirmed:

| Path | Mechanism | Mod tap |
|---|---|---|
| Channel program, PTT, SMS, status | UART packets, `MessageDispatcher` | `hookDmrManager`, `hookModuleStatusHandler`, `hookSerialCommunication` |
| RX voice PCM | Binder `PrizeTinyService.onRecv` → `writeAudioTrack` | `hookPCMReceiveManager` **only** |
| TX voice PCM | `AudioRecord` 8 kHz stereo → `PrizeTinyService.writeFrame` | no production hook (APRS TX experiments were uncommitted) |
| Codeplug | SQLite per area `database_<areaKey>.db` | Direct SQLite + `DmrManager` reflection |
| Module extras (zones, TG lists, APRS log, RadioID, locations) | `dmrmod_*.db` in the **OEM** data dir | own helpers |

`PCMReceiveManager` constants:

```
DEFAULT_SAMPLE_RATE = 8000
DEFAULT_CHANNEL_CONFIG = 12   // CHANNEL_OUT_STEREO
DEFAULT_AUDIO_FORMAT = 2      // PCM_16BIT
```

(`PCMReceiveManager.java:19-22, 64-67`)

The module’s DSP still comments and constants as **16 kHz mono**. Same byte rate, so nothing crashes. Frequency math for AFSK (1200/2200), SSTV (1500–2300), APT (2400 Hz) is therefore possibly off by 2× if the stream is duplicated stereo. Claude left this as open question A2. It is still open. **Do not write more DSP until one raw `writeAudioTrack` chunk is dumped.**

---

## 3. `MainHook.java` as a system

16,307 lines. 22 `hook*` methods. Registration order in `handleLoadPackage` (`MainHook.java:325-416`):

Application → HomeActivity → TalkBack → Local → Information → (firmware hook commented out) → ModuleStatus → DigitalAudio → PCM → Signal → DmrManager → ChannelNavigation → ChannelListFilter → ChannelListUI → ChannelEdit → Serial → debug broadcast → MessageDisplay → BottomNav → other fragments → generic activities.

Two speech hooks (`hookSpeechRecognizer`, `hookSystemRecognitionService`) are **defined and never registered**. Firmware update hook is commented out. UART bootloader probe is commented out.

Static state is a flat bag of `volatile` flags, dialog refs, and `LinkedList`s. Zygisk keeps that bag alive across OEM process death (Pitfall 14). Startup reset covers the four mode flags and dialogs. It does **not** reset Soft SQ, MON, REC, TXT, zone, `vfoLocalId`.

---

## 4. Channel hijack: the shared framework, as implemented

All four “modes” mutate the **current** `ChannelData` in place:

| Mode | Name wrap | Backup | Stops others? | Bandwidth field written |
|---|---|---|---|---|
| APRS | `"APRS (" + name + ")"` | `/sdcard/aprs_channel_backup.dat` | **no** | `band = 1` comment “VHF” |
| SSTV | `"SSTV (" + name + ")"` | `/sdcard/sstv_channel_backup.dat` | APRS only | `determineBand(freq)` + `channelMode = 0` comment “Narrow” |
| NOAA | `"NOAA (" + name + ")"` | `/sdcard/noaa_channel_backup.dat` | APRS + SSTV | `determineBand(freq)` + `channelMode = 1` comment “Wide FM” |
| VFO | `"VFO-…"` / `"VFO ("` | `/sdcard/vfo_channel_backup.dat` | **no** | `determineBand(vfoFrequencyMHz)` |

Crash recovery is “if the live channel name starts with this prefix, offer restore.” There is still no strip-before-wrap, so a crash during SSTV produces nested prefixes. Recovery then looks at the outer prefix only.

Backups are `ObjectOutputStream` of a `HashMap<String,Object>` on world-writable `/sdcard`. That is both a restore mechanism and a deserialization gadget surface.

---

## 5. What HEAD changed after Claude’s freeze

`CHANGELOG_DRAFT.md` / commit `ba6431cb` (not version-bumped, **not built, not device-tested**):

- `OemChannelTable` — export/import/PDF/dump follow the selected area instead of hard-coding `default_uhf`.
- Import: locations/APRS flags applied after channel commit; TG lists and assignments cleared on TG import.
- Soft SQ gates analog (or a monitoring mode) only; APRS live Soft SQ respects its own toggle.
- `AFSKDecoder.DEBUG_SAVE_WAV` default false.
- Channel-editor help icon id `interphone_channel_call_name` (was a non-existent `interphone_channel_contact`).
- robot36 GPLv3 headers.
- Deleted `assets/speech_model.tflite` (~41 MB).

Uncommitted on this checkout (Claude, not this series): `docs/BACKLOG.md`, `docs/deep-dive/15-packet-radio-review.md`, `16-repeater-directory-import.md`, two `_research-*` memos, and a one-line APRS-TX constraint tweak in the session-start rules.

---

## 6. Gradle topology (easy to open the wrong project)

Root `settings.gradle` is the abandoned OEM rebuild (`:app`, applicationId `com.macgyver.dmr` `2.0-MacDMR`). DMRModHooks and DMRTranscriptionService are **separate** Gradle trees. `install.ps1` lives under `DMRModHooks/`. Opening the repo root in Android Studio does not build the module.

---

## 7. What I am willing to treat as settled

Claude’s ch. 01–07 (serial, messages, state machines, audio, data, UI inventory, firmware update) and ch. 14 (hook cross-ref) are good enough to work from. I re-checked the facts in `00-README.md` §4 and did not find a fabricated class or command.

What I am **not** willing to treat as settled: “the notes were wrong, therefore the code is fine.” Several live call sites still implement the notes’ old meaning. That is chapter 02.
