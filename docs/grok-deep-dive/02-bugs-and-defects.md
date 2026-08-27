# 02 — Bugs and defects (live tree)

Severity: **P0** user-visible wrong radio behavior · **P1** data loss / security · **P2** reliability / correctness landmine · **P3** hygiene / debug.

“New” means Claude’s drift table or BACKLOG either missed it, or documented the *fact* without calling the *live call site* a bug.

**2026-08-27 retractions** (Claude 17, re-verified — details in [09](09-claude-reconciliation.md)): **P0.4 is not a defect** (two different help rows). **P2.10 is not on the wire** (`DigitalMessage` tail is `pwrSave/volume/mic/relay`, no `band`). **P2.18 overstated** (Google parses WAV; real bug is the API-key placeholder). **P2.15 symptom** is “tens digit stuck ≥100,” not “shows 00.” Ranked work lives in `docs/BACKLOG.md`.

Device needed? marked. Nothing here was reproduced on the radio in this session.

---

## P0 — wrong RF programming

### P0.1 `determineBand()` writes UHF/VHF into analog **bandwidth** (new as a defect)

OEM editor (`InterPhoneChannelActivity.java:724-727`):

```
narrow string → channelData.setBand(0)
else         → channelData.setBand(1)
```

`AnalogMessage.encodeBody` sends that `band` byte as the bandwidth field (`AnalogMessage.java:60`). It is what the MCU uses for 12.5 vs 25 kHz.

`MainHook.determineBand` (`MainHook.java:16045-16056`):

```java
// 0=UHF (400-520 MHz)
// 1=VHF (136-174 MHz)
if (frequencyMHz >= 136 && frequencyMHz <= 174) return 1;  // VHF
else if (frequencyMHz >= 400 && frequencyMHz <= 520) return 0;  // UHF
else return 1;
```

Call sites that feed this into `ChannelData.band`:

| Call site | What the comments think | What the MCU gets |
|---|---|---|
| VFO apply/start (`:15190`, `:15394`) | “auto VHF/UHF” | 2 m analog → **always wide**; 70 cm analog → **always narrow** |
| SSTV start (`:6596-6597`) | `determineBand` + `channelMode = 0` “Narrow bandwidth (NFM 12.5 kHz)” | 144.5 MHz → `band = 1` **wide**. `channelMode` is **not** in `AnalogMessage` |
| NOAA start (`:8044-8045`) | `determineBand` + `channelMode = 1` “Wide FM (25 kHz)” | 137.1 MHz → `band = 1` wide (accidentally right). `channelMode = 1` is a no-op on analog wire |

APRS start does not call `determineBand`; it hard-codes `band = 1` with comment `"VHF"` (`:5488`). That happens to be wide, which is reasonable for NA 144.390, for the wrong reason. It also sets `channelMode = 0` with a leftover SSTV comment (`:5489`).

`vfoBandWidth` is declared (`:296`, comment “0=12.5kHz, 1=25kHz”) and **never written to `band`**. Copilot-instructions already say “unused — VFO has no bandwidth control.” The unused field plus `determineBand` is why.

**Fix:** delete `determineBand`. Set `band` from an explicit Narrow/Wide control (VFO) or a per-mode constant (APRS wide, SSTV configurable, NOAA wide). Analog `channelMode` is not bandwidth; stop writing it as if it were.

**Device:** yes (listen to a 12.5 kHz analog channel after VFO-to-UHF).

---

### P0.2 `saveChannelData` before-hook is inverted on **both** enums and writes a contact `_id` (Claude B7, worse than stated)

```java
// MainHook.java:14403-14464
int channelType = ... "type";
int contactType = ... "contactType";
// comments: 0=Analog 1=Digital,  0=Group 1=Private     ← both backwards
if (channelType != 1 || contactType != 0) return;       // runs on ANALOG + PERSON
...
cursor = contactDb.query(..., "contact_number=?", tgFromEditText);
int contactId = cursor.getInt(0);                       // column _id
setIntField(channelData, "txContact", contactId);       // Pitfall 12
```

OEM (`ChannelData.java:53-76`): type 0 = DIGITAL, 1 = ANALOG; contactType 0 = PERSON, 1 = GROUP.

So the “TG → contact id display fix”:

- Never runs on a DMR group channel (the intended case).
- Runs on analog private/default channels if the (possibly hidden) call-name `EditText` is non-empty.
- If it finds a contact whose `contact_number` equals that text, it overwrites `txContact` with the **row id**.

Harmless when the analog EditText is empty. A landmine if it is not. The lookup is also the opposite of Pitfall 12.

**Fix:** delete the before-hook, or rewrite it with OEM enums and write `contact_number` into `txContact`.

---

### P0.3 Channel-editor frequency help is off by 10× (new)

OEM stores Hz (`401025000`). The injected help (`MainHook.java` ~13713) says “10 Hz units,” “MHz × 100000,” and “446.0000 MHz → enter 44600000.” Following that programs **44.6 MHz**. Recv-frequency help is the same text.

**Fix:** “Hz, no decimal: 446.000 MHz → 446000000.” Or, better, do B2 in ch. 04 and show MHz.

---

### ~~P0.4 Help icon still teaches UHF/VHF for `channel_band`~~ — retracted

`interphone_channel_frequency_band` is the OEM UHF/VHF *display* row (correct). `interphone_channel_band` is Bandwidth with correct 12.5/25 kHz text (`MainHook.java:13879-13884`). See [09](09-claude-reconciliation.md) §2.1.

**Related help bug still live:** OEM squelch-row help lists levels 1–9 as distinct (`:13886-13892`). Firmware only honors 0 and 2. File as backlog **R14**.

---

## P1 — data, security, privacy

### P1.1 Location display keyed by **list index + 1**, storage keyed by `channel_number` (new)

```java
// MainHook.java:3188-3192
int channelNumber = (Integer) mCurrentChannelIndex + 1;
LocationDatabase.Location location = locationDb.getLocation(channelNumber);
```

`mCurrentChannelIndex` is `DmrManager.mChannelIndex` — position in the in-memory `channels` list (`InterPhoneTalkBackFragment.java:77, 182, 306`). Import/export store locations by CSV `channel_number` (`DirectDatabaseImporter.java:1086`, `DirectDatabaseExporter.java:435`).

These coincide only if the list is unfiltered and `channel_number` is 1-based contiguous in list order. Zone filter, duplicate numbers, or a hole in numbering shows the **wrong repeater’s** city/distance, or none.

**Fix:** key locations by channel `_id` (zones already do). Until then, read `currentChannel.number` or `_id`, not index+1.

---

### P1.2 Exported debug UART injector (new as security)

```java
// MainHook.java:11897-11898
filter = new IntentFilter("com.dmrmod.SEND_DEBUG_PACKET");
context.registerReceiver(debugReceiver, filter, Context.RECEIVER_EXPORTED);
```

Any app, or `adb shell am broadcast`, can send `CMD`/`BODY` to the MCU. `EnhanceMessage.KILL = 4` is a legal body. This is a fuzzing tool left armed in the production module.

**Fix:** `RECEIVER_NOT_EXPORTED`, or compile it out of release, or require a signature permission.

---

### P1.3 Always-on UART file logger (Claude B3, plus storage)

`hookSerialCommunication` (`:11579-11693`) on **every** TX/RX packet:

- `new Thread`
- open/append/close a `.bin` and a `.txt` under `/sdcard/DMR/uart_logs/`
- `getCmdName` mislabels (P3.2)

Status 0x36 and RSSI 0x32 traffic makes this a background disk writer for the life of the app. Logs are unbounded and world-readable.

**Fix:** gate behind a Device-tab toggle, default off; keep streams open; drop the per-packet thread.

---

### P1.4 Google API key on public storage + exported transcription service

`TranscriptionService.java:70-93` reads `Download/DMR/api_key.txt` (any file manager, any app with storage). The HTTPS call puts the key in the query string. The service is `exported=true` with no signature permission — any app can bind and spend quota. `isReady()` still means “key file exists”; the toast still says “Loading model...” (`MainHook.java:10897`).

**Fix:** signature permission on the AIDL; stop putting the key in the URL; don’t toast Whisper leftovers.

---

### P1.5 Java serialization of channel backups on `/sdcard`

`ObjectOutputStream` of a `HashMap` to `/sdcard/{aprs,sstv,noaa,vfo}_channel_backup.dat`. A planted file is a deserialization gadget next time the matching restore runs. Also world-readable copies of the user’s last channel (freqs, TG, maybe encryption key string).

**Fix:** JSON or a versioned binary in the app’s private dir.

---

### P1.6 Wipe-and-insert import still the only restore (known, still P1)

`DirectDatabaseImporter` deletes OEM contact + channel tables then inserts. Combined with Pitfall 16 (UTF-8 BOM) this has already blanked a codeplug. `OemChannelTable` (HEAD) fixes *which* area gets wiped; it does not make import additive. Nearby Repeaters (Claude 16) correctly refuses to use this path.

HEAD also moved location/APRS writes after commit — good, **untested**.

---

### P1.7 Area-aware channel I/O vs still-global module DBs (new, caused by HEAD)

`OemChannelTable` now reads/writes the **selected** OEM area. Zones, TG lists, locations, and APRS flags are still **one file for all areas**, keyed by channel `_id` or `channel_number` with no area column.

Import of the VHF area therefore `clearAllLocations()` / `clearAllTGLists()` / `clearAllZones()` on the UHF extras. The same `channel_number` in two areas shares one GPS row. This is a regression of the “fix the hard-coded area” patch until module tables are scoped.

**Fix:** key module rows by `(areaKey, channel_id)`, or refuse to import when the selected area is not the one the backup was taken from (stamp `areaKey` in the backup folder).

---

### P1.8 BOM import still reports success after wiping (Pitfall 16, still live)

`parseCSVLine` does not strip `\uFEFF`. Header `\uFEFF_id` → unknown format → wipe → every row skipped → `setTransactionSuccessful()` → `return true`. RadioID import *does* strip BOM. The channel importer does not.

**Fix:** strip BOM; if zero channels parsed, **roll back** and toast failure.

---

### P1.9 APRS “valid” packets at 0,0 (new)

`APRSPacketDecoder.decode` sets `isValid = true` after `parsePositionReport` even when that method returned early (`APRSPacketDecoder.java:112-119`). `storeStation` then writes lat/lon 0 and a GPX pin in the Gulf of Guinea.

**Fix:** `isValid` only if lat/lon actually parsed.

---

## P2 — reliability / correctness

### P2.1 Mode exclusivity is not a function (Claude 09, still live, details)

| Starter | Stops |
|---|---|
| `startAPRSMonitoring` (`:5453`) | nothing |
| `startSSTVMonitoring` (`:6556-6558`) | APRS |
| `startNOAAMonitoring` (`:8013-8014`) | APRS, SSTV |
| `applyVFOChanges` / `startVFOMode` | nothing |

Two live dialogs + two name prefixes + one `ChannelData` object is undefined behavior. Shared `softwareSquelchThreshold` (Pitfall 10) makes it worse.

**Fix:** one `enterMode(Mode)` / `leaveMode()` that always restores the previous hijack first. Name-nesting guard belongs in the same helper.

---

### P2.2 Startup reset still incomplete (Claude B2)

Reset (`:1128-1175`): four mode flags + dialog/receiver refs.

Not reset: `isMonitoringMode`, `isSoftwareSquelchEnabled`, `isAprsSoftwareSquelchEnabled`, `isRecordingEnabled`, `isTranscriptionEnabled`, zone state, `vfoLocalId`.

Zygisk keeps those across OEM force-stop.

---

### P2.3 Software squelch 300 ms vs `SetChannelState` (Claude B1 / Pitfall 13)

Re-apply still on a timer in `hookChannelNavigation` `sendAnalogMessage`. Acks match by command byte only, so a module 0x23 can complete the OEM transaction early. Workaround remains “nudge the slider.”

HEAD’s analog-only gate (`:9969-9975`) stops the “Soft SQ muted DMR” variant. The stuck-closed analog case is unchanged.

**Fix:** re-apply on `dealEvent(0x23)` / `NoDealState`, not a timer.

---

### P2.4 `activityHistory` unsynchronized `LinkedList` (Claude B5)

`updateActivityIndicator` / `loadChannelHistory` mutate from the status dispatcher and a history-load thread (`:9329-9520`). Classic CME. `MAX_ACTIVITY_HISTORY = 3` makes it rare, not impossible.

---

### P2.5 Geocoder on the UI thread (Claude B4) — GPS send already got this right

`updateLocationDisplay` (`:3201-3203`) calls `Geocoder.getFromLocation` inline during `initView`/`updateUI`. The GPS POS button (`:2705-2711`) already moved Geocoder to a worker. Copy that pattern; cache results; stop hitting Open-Elevation (`:3396-3402`) on every channel change.

---

### P2.6 APRS decoder is a 2 s batch job that drops most of APRS (Claude 15)

Not a “crash” bug. Product-false: Mic-E (`'` / `` ` ``), compressed positions, messages, objects, weather all log `"Unsupported data type"` and `isValid` stays false (`APRSPacketDecoder.java:112-117`). `findPacketBits` keeps **one** longest gap per 2 s buffer. PLL is cold-started every buffer. Input is boxed `List<Short>` then resampled ×3 to a decoder hard-wired at 48 kHz (`AFSKDecoderIQ.java:15`).

`channel_aprs.enabled` is stored and never read — the flag a passive-decode feature needs.

---

### P2.7 SSTV / NOAA DSP on the audio callback

`sstvReceiver.processAudio` and `noaaReceiver.processAudio` run inside `writeAudioTrack` beforeHook (`:10086-10092`). Budget is ~64 ms/chunk. SSTV has a bg VIS thread; NOAA AM demod + resample is still on `readpcm`. A long NOAA pass is the most likely source of RX stutter among the three.

APRS at least hops a `new Thread` every 2 s (also unbounded).

---

### P2.8 `USE_COMPOUND_KEY_ZONES` exporter false / importer true (Claude B6)

Works because the importer accepts both. One constant, please.

---

### P2.9 Manifest declares a class that does not exist

`AndroidManifest.xml:43-48` — `APRSSettingsActivity`. No `.java` file. Harmless until something calls it (`ActivityNotFoundException`). `BackupActivity` **does** exist, is `exported=true`, uses `Theme.Material.Light`, and has no in-module launcher (`BackupActivity.java:27-32` says unused).

---

### P2.10 ChannelData constructor hook forces `band = 1` on **every** new object (`:13966-13974`) — **DB only**

Intended: analog defaults to 25 kHz. Digital rows in the DB also start `band=1`. **Not a UART issue:** `DigitalMessage` has no `band` (tail = pwrSave, volume, mic, relay — Claude 17 §3, packet-layouts corrected). Fold into R1: only set the wide default when `type == 1`.

---

### P2.11 VFO Soft SQ lookup uses a tag that does not exist (new)

`applyVFOChanges` searches for `"DMR_SOFT_SQUELCH_CHECKBOX"`. The live control is a `ToggleButton` tagged `"DMR_SOFT_SQUELCH_TOGGLE"`. VFO can clear the flag and send `sq=2` while the intercom button stays visually ON.

---

### P2.12 SSTV stop does not clear Soft SQ; NOAA does (new)

Asymmetric teardown. Leave SSTV with Soft SQ stuck on analog.

---

### P2.13 SSTV drops quiet audio after VIS (new)

`SSTVReceiver.processAudio` discards chunks with RMS &lt; 80 even after VIS is locked. A quiet scan line can stall the image. Runs on the `readpcm` thread.

---

### P2.14 Recording WAV header is always 16 kHz mono (new)

Regardless of the still-unverified 8 kHz stereo vs 16 kHz mono layout. Players and STT inherit the lie. Files &lt; 10 kB are deleted — short analog bursts vanish.

---

### P2.15 Channel number sprites break at ≥ 100 (new; symptom corrected)

`digitOne = number / 10` → 10 for channel 100; `interphone_talkback_num_10` does not exist; `setNumDrawable` no-ops and the tens sprite **stays at whatever it was**. Not “shows 00.” Backlog **S12**.

---

### P2.16 PDF export still has Pitfall 12 (new vs BACKLOG)

`buildContactMapPDF` keys `_id`. Contact type string is inverted (`0 → Group`). PDF is a support artifact people actually email.

---

### P2.17 Unquoted CSV / no `""` unescape (new)

Exporter concatenates names raw. A comma in a channel or zone name shifts every later column. Importer does not decode doubled quotes.

---

### P2.18 Transcription placeholder mismatch (WAV-header claim retracted)

Google STT **parses** a WAV container; the RIFF header is not transcribed. Real first-use bug: module writes `YOUR_GOOGLE_CLOUD_API_KEY_HERE`, service only treats `YOUR_API_KEY_HERE` as empty → `isReady()==true` then HTTP 400 (**S5**). Optional: don’t send both `encoding: LINEAR16` and a WAV wrapper (**S4** note).

---

### P2.19 MCU TOT is hard-coded zero (Settings still works in software)

`sendSetTotCmdToMdl` sends `tot = 0`. The Settings “Limit send time” pref **is** enforced by a `CountDownTimer` in `InterPhoneTalkBackFragment` (message 2012). Missing piece: MCU watchdog if the **app dies mid-PTT** (no `LaunchMessage(0)`). Backlog **S1**, not “the slider is a lie.”

```java
// DmrManager.java:776-779
public void sendSetTotCmdToMdl() {
    TotMessage totMessage = new TotMessage();
    totMessage.tot = (byte) 0;
    totMessage.send();
}
```

Settings UI offers 30/60/120 s. The wire always gets 0. A one-line hook (read the pref, set `tot`) would make the existing menu real.

---

## P3 — hygiene, labels, dead weight

### P3.1 `getCmdName` (Claude B8)

```java
case 22: return "SET_DIGITAL_INFO_CMD";   // 22 decimal = 0x16; real digital cmd is 34 = 0x22
case 35: return "INTERRUPT_TRANSMIT_CMD"; // 35 decimal = 0x23 = SET_ANALOG_INFO_CMD
case 63: return "TEST_BIT_ERROR_RATE";    // this one is accidentally correct (0x3F)
```

Status bytes 1/2/10 are also mixed into a *command* namer. UART text logs are not trustworthy.

---

### P3.2 Version strings

| Place | Says |
|---|---|
| `build.gradle` / `MainHook.VERSION` | **3.4.6** (authoritative) |
| `res/values/strings.xml` | **v0.2** — LSPosed Manager label |
| `DMRModHooks/README.md` | v3.1.3 |
| Root README Quick Facts / install toast | v3.3.2 / v3.0.9 |
| Root README transcription | OpenAI Whisper, `/sdcard/DMR/api_key.txt` |

---

### P3.3 Dead DSP / dead hooks (Claude D1, still there)

Unreferenced: `AFSKDecoderPLL`, `DireWolfDecoder` + disabled NDK, `AFSKGenerator` (keep until the stereo TX experiment), `SSTVImageDecoder` (non-IQ), `SSTVFMDemodRobot36`, `SSTVFilter` (hooks package), `SSTVFFTDemodulator`, `SSTVGoertzelDemod`, `SSTVZeroCrossingDemod`, `SSTVPhaseDemod`, `FrequencyModulation`, `Complex`/`Phasor`/`Kaiser`/`ComplexConvolution` (live copies are in `sstv/`), `CSVExporter`/`CSVImporter` (no UI), `BackupActivity`, speech hooks, `UARTBootloaderProbe`, `PatchReloadHelper` path.

`fastSin` in `AFSKDecoderIQ` indexes 8 bits then calls `Math.sin` (`:37-41`). It is not a lookup table.

---

### P3.4 Repo objects that are not software

Tracked: ~29 WAV captures, logcats, personal CSVs, `database_channel_area_default_uhf.db`, **138** CPS zips, triplicate OEM trees (`app/`, `original-decompiled/` with smali, `original-extracted/`), firmware `.bin` in three places, root PNG sprites. `.gitignore` ignores `*.apk` and `*.keystore` — clones cannot sign, but `releases/*.apk` is force-tracked. `OpenGD77Fork/DMRModHooks-signed.apk` is a stale ~43 MB tflite-era build.

---

### P3.5 LICENSE vs the tree

Root LICENSE / DMRModHooks LICENSE: GPLv3 plus a claim that the project does **not** redistribute proprietary Ulefone code. The public tree contains JADX OEM sources, smali, and MCU firmware images. That disclaimer is false as published. robot36 headers on HEAD are correct for the SSTV port; the UI still has no GPLv3 notice (GPL §5d).

---

### P3.6 Zero tests

No `src/test`, no `src/androidTest` under DMRModHooks. CSV coercions, `OemChannelTable`, HDLC CRC, RadioID parse, `determineBand` replacements are all JUnit-shaped and do not need a radio.

---

### P3.7 Information page injects an empty light-gray box (new)

Firmware “patch reload” button is commented out; the container is still added at `0xFFF5F5F5` on navy and the log says the button was added. Export toast still says `Download/DMR_Backups/` (missing `DMR/`).

---

### P3.8 APRS logs every PCM chunk (new)

`bufferAudioForAPRS` `XposedBridge.log`s ~twice per 64 ms while monitoring (`MainHook.java` ~10991). WAV dump is gated; logcat spam is not. `AFSKDecoder.decode` also dumps first 100 bits / flags / hex every 2 s buffer.

---

## Already fixed on HEAD, not in a release

Do not re-fix; **do** build and regression-test (Claude A1):

- Area-aware channel table
- Import location/APRS/TG-list integrity
- Soft SQ analog-only + APRS toggle respect
- APRS debug WAV off
- Call-number help icon
- tflite removed
- robot36 headers

---

## Intentionally not bugs

Hardware LED, DMR group-call RX, >32 TGs in firmware, squelch 1/3–9, on-device STT, UART bootloader `EACCES`. APRS TX is **unresolved** pending a stereo-frame experiment (Claude 15 §1.2), not a closed constraint.
