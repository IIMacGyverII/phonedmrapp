# 10 — Recording, Transcription & RadioID Caller Database (DMRModHooks)

**Summary.** DMRModHooks taps the OEM audio sink (`PCMReceiveManager.writeAudioTrack`) once, before software squelch mutes anything, and fans that pre-squelch PCM out to three consumers: (1) a **REC** toggle that spools raw PCM to disk between `RECEIVE_START`/`RECEIVE_STOP` and wraps it in a WAV header (`Download/DMR/Audio/<Channel>/`), (2) a **TXT** toggle that accumulates up to 30 s of samples in memory and, at `RECEIVE_STOP`, ships them over AIDL/Binder to a separate app, **DMRTranscriptionService** (`com.macdmr.transcription`), and (3) the APRS/SSTV/NOAA decoders (other chapters). The shipped transcription engine is **Google Cloud Speech-to-Text v1 REST** (`speech.googleapis.com/v1/speech:recognize`) called from the service with OkHttp — **not** OpenAI Whisper, despite what the README/instructions say. The 41.6 MB `speech_model.tflite` bundled in the module APK is dead weight; the `hookSpeechRecognizer`/`hookSystemRecognitionService` hooks are never registered. Separately, `RadioidDatabase.java` downloads RadioID.net `user.csv` into a private SQLite DB (`dmrmod_radioid.db`) and the caller panel resolves RX DMR IDs two-tier: OEM codeplug contacts first, RadioID second.

## Source files / regions

| Area | File | Lines |
|---|---|---|
| State fields (recording, transcription, history) | `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java` | 98–135, 180–199 |
| `handleLoadPackage` hook registration list | `MainHook.java` | 349–416 |
| Legacy speech hooks (dead) | `MainHook.java` | 714–886 (`hookSpeechRecognizer`), 896–944 (`hookSystemRecognitionService`) |
| Folder + `api_key.txt` bootstrap (InterPhoneHomeActivity.onCreate hook) | `MainHook.java` | 1060–1109 |
| Transcription display box (intercom page) | `MainHook.java` | 1540–1616 |
| TXT toggle + long-press | `MainHook.java` | 2013–2124 |
| REC toggle | `MainHook.java` | 2218–2295 |
| History restore on initial channel / channel change | `MainHook.java` | 2837, 3008 |
| Device-tab RadioID status + buttons | `MainHook.java` | 4150–4216 |
| APRS monitoring forces REC/TXT off | `MainHook.java` | 4801–4817 |
| RX start/stop trigger (`ModuleStatusMessageHandler.handle`) | `MainHook.java` | 8452–8551, 8588–8624 |
| Caller lookup (personal → RadioID) and panel | `MainHook.java` | 8845–8890 (`updateCallerInfoAsync`), 8893–8937, 8956–9063, 9096–9251 |
| `dmrmod_history.db` schema/insert | `MainHook.java` | 9428–9450, 9555–9593 |
| `startRecording`/`stopRecording`/MP3/WAV helpers | `MainHook.java` | 9651–9920 |
| `hookPCMReceiveManager` (audio tap) | `MainHook.java` | 9926–10112 |
| Service bind / audio buffer | `MainHook.java` | 10865–10974 |
| `processTranscription`, API key I/O, dialog, display, history, daily log | `MainHook.java` | 11112–11563 |
| AIDL (module copy) | `DMRModHooks/app/src/main/aidl/com/macdmr/transcription/ITranscriptionService.aidl` | 1–22 |
| AIDL (service copy — identical signatures, comments differ) | `DMRTranscriptionService/app/src/main/aidl/com/macdmr/transcription/ITranscriptionService.aidl` | — |
| Service implementation | `DMRTranscriptionService/app/src/main/java/com/macdmr/transcription/TranscriptionService.java` | 1–327 |
| Service manifest / gradle / strings / key template | `DMRTranscriptionService/app/src/main/AndroidManifest.xml`, `app/build.gradle`, `res/values/strings.xml`, `local.properties.template` | — |
| RadioID DB | `DMRModHooks/app/src/main/java/com/dmrmod/hooks/RadioidDatabase.java` | 1–836 |
| Bundled model + readme | `DMRModHooks/app/src/main/assets/speech_model.tflite` (41,655,568 B), `README_MODEL.md` | — |
| OEM audio sink | `app/src/main/java/com/pri/prizeinterphone/manager/PCMReceiveManager.java` | 19–24, 66–70, 127–140, 149–166 |
| OEM recorder | `app/src/main/java/com/pri/prizeinterphone/record/AudioRecorder.java`, `record/PcmToWav.java` | — |
| History docs / scripts | `docs/TRANSCRIBING_PLAN.md`, `docs/IPC_SERVICE_IMPLEMENTATION_PLAN.md`, `docs/TODO_MODEL_DOWNLOAD.md`, `docs/whisper_android_readme.md`, `DMRModHooks/download-vosk-model.ps1`, `scripts/test-*.ps1`, `scripts/convert_*.py` | — |

---

## 1. Recording (REC)

### 1.1 Enable / persistence

| Item | Fact | Cite |
|---|---|---|
| Control | `ToggleButton` tag `DMR_RECORDING_TOGGLE`, text `⏺\nREC`, 70×52 dp, top-right of the intercom `buttonContainer`, created inside `hookTalkBackFragment` | `MainHook.java:2219–2232` |
| State flag | `isRecordingEnabled = recordToggle.isChecked()` on click; toast "Recording enabled/disabled" | `:2273–2279` |
| Persistence | **None.** `setChecked(false)` at creation; no SharedPreferences key exists for REC or TXT (grep `recording_enabled|transcription_enabled` → 0 hits). Both reset on fragment re-creation/app restart. | `:2223` |
| Late enable | If toggled on while `isReceiving`, `startRecording()` fires immediately (partial recording) | `:2287–2290` |
| Toggle off mid-RX | `stopRecording()` called at once → file finalised | `:2282–2284` |
| Forced off | Starting **APRS monitoring** unchecks REC and TXT and stops any recording. SSTV/NOAA/MON/VFO do **not** touch REC/TXT. | `:4801–4817` (only hits for `isRecordingEnabled = false`) |

### 1.2 Trigger (which hook)

`hookModuleStatusHandler` hooks `com.pri.prizeinterphone.handler.ModuleStatusMessageHandler.handle(ModuleStatusMessage)` (after) and switches on `getStatus()`:

| Status | Meaning (code comment) | Recording action | Cite |
|---|---|---|---|
| 1, 10 | `RECEIVE_START` / `MIX_CHECK_DIGITAL_RECEIVE_START` ("used for both digital AND analog") | `isReceiving=true`; `if (isRecordingEnabled) startRecording()` | `:8475–8483` |
| 2, 11 | `RECEIVE_STOP` / `MIX_CHECK_DIGITAL_RECEIVE_STOP` | `isReceiving=false`; `if (isCurrentlyRecording) stopRecording()`; then snapshot caller info and `processTranscription()` | `:8518–8544` |
| 12, 13 | `MIX_CHECK_ANALOG_RECEIVE_START/STOP` | sets `isReceiving`, updates caller panel, processes APRS buffer — **does not start/stop recording or transcription** | `:8588–8624` |

Squelch state is **not** a trigger: recording spans the whole carrier, and (see 1.6) captures unmuted audio even while soft-squelch is closed. Channel changes do not stop a recording; only status 2/11, REC-off, or APRS-start do.

### 1.3 PCM format captured (OEM source)

`PCMReceiveManager` (OEM) receives PCM from `PrizeTinyService` (`ITinyRecvCallback.onRecv(byte[], int)`), posts to a `readpcm` HandlerThread, and calls `writeAudioTrack(byte[] bArr, int i)` which does `mAudioTrack.write(bArr, 0, i)` (`PCMReceiveManager.java:127–140`). The AudioTrack is built as:

```java
// PCMReceiveManager.java:19-24, 66-70
DEFAULT_SAMPLE_RATE = 8000; DEFAULT_CHANNEL_CONFIG = 12 /*CHANNEL_OUT_STEREO*/; DEFAULT_AUDIO_FORMAT = 2 /*ENCODING_PCM_16BIT*/;
this.mAudioTrack = new AudioTrack(3, 8000, 12, 2, this.mMinBufferSize * 2, 1);
Log.d(TAG, "init audiotrack stram:3,rate:8000,chennel:12,format:2");
```

So the OEM sink is **8 000 Hz, 16-bit, 2-channel interleaved = 32 000 B/s**. The mod writes its WAV header as **16 000 Hz, mono, 16-bit = 32 000 B/s** (`MainHook.java:9726–9727`, comment "2048 bytes/64ms = 16000 samples/sec"). The byte rates are identical, so durations and pitch come out right either way; the module is effectively treating each stereo frame as two mono samples (a sample-and-hold ×2 upsample if L==R). The OEM's own `PcmToWav` writes the same bytes with an **8 000 Hz / 2 ch** header (`PcmToWav.java` `SamplesPerSec = 8000; Channels = 2`). ⚠️ The "16 kHz mono" claim in module comments/docs is an inference from byte rate, not from the AudioTrack config; the transcription service is told `sampleRate=16000` on the same basis (`MainHook.java:11148`).

### 1.4 Hook tap → file

`hookPCMReceiveManager` (`MainHook.java:9926–10112`) hooks `writeAudioTrack(byte[], int)` **before**:

1. If any consumer is active (`isAPRSMonitoringActive || isTranscriptionEnabled || isSSTVMonitoringActive || isNOAAMonitoringActive || (isRecordingEnabled && isCurrentlyRecording)`) copy `originalAudio = Arrays.copyOf(audioData, length)` (`:9949–9956`).
2. Amplitude + hybrid RSSI/RMS soft-squelch; if closed, `Arrays.fill(audioData, 0, length, 0)` mutes the **speaker** buffer only (`:9963–10058`).
3. `processingAudio = originalAudio != null ? originalAudio : audioData` (`:10069`) feeds APRS/SSTV/NOAA/transcription.
4. Recording: `pcmOutputStream.write(processingAudio, 0, length); pcmDataSize += length;` (`:10092–10097`). Write happens on the OEM `readpcm` thread; failures are logged and swallowed.

### 1.5 File lifecycle, naming, layout

`startRecording()` (`:9651–9703`):

- Folder: `Environment.DIRECTORY_DOWNLOADS/DMR/Audio/<ChannelFolder>` where `ChannelFolder = currentChannelName.replaceAll("[^a-zA-Z0-9\\s-]","").trim()` or `Channel_<currentChannelNumber>` if empty (`:9658–9665`). `mkdirs()` on demand. The `DMR/Audio` and `DMR/Transcription` roots are also pre-created in the `InterPhoneHomeActivity.onCreate` hook (`:1060–1085`).
- File: `yyyyMMdd_HHmmss.pcm` (`Locale.US`), opened as `FileOutputStream`; `pcmDataSize=0`; `isCurrentlyRecording=true` (`:9673–9689`).

`stopRecording()` (`:9708–9782`):

1. Close stream; if `pcmDataSize > 0` → `convertPCMtoWAV(pcm, wav, 16000, 1, 16)`, delete `.pcm` (`:9720–9730`).
2. Digital channels only (`currentChannelType == 0`): rename to `<ts>_<CallerName>.wav` (name stripped to `[a-zA-Z0-9-]`) else `<ts>_<dmrId>.wav`; analog stays `<ts>.wav` (`:9739–9757`). `currentCallerName` is `CallerDisplayInfo.shortName()` (`:8864`) → personal contact name, else RadioID **callsign**, else "First Last" (`:8905–8917`) — so RadioID data shows up in filenames.
3. **Minimum length:** any resulting file `< 10 000` bytes is deleted (`:9761–9764`) ≈ 0.31 s of audio at 32 kB/s. No silence trimming, no VAD.
4. `finally`: reset state, `lastRecordingPathForTranscription = currentRecordingPath` (`:9776`) — this field is written but never read by the transcription path (`saveTranscriptionToFile(…, null)` at `:11180`).

Gotcha: if `pcmDataSize == 0` the empty `.pcm` is **not** deleted (`:9720` guard skips the delete at `:9730`), leaving zero-byte `.pcm` stubs.

Resulting layout:

```
/sdcard/Download/DMR/
├── Audio/<ChannelFolder>/20260825_143012_KD9ABC.wav      # digital, RadioID/contact name
├── Audio/<ChannelFolder>/20260825_143012_3112345.wav     # digital, unknown ID
├── Audio/<ChannelFolder>/20260825_143012.wav             # analog
├── Transcription/<ChannelFolder>/transcription_20260825.txt
├── RadioID/user.csv
└── api_key.txt
```

### 1.6 WAV header (`convertPCMtoWAV`, `:9863–9898`)

```java
long fileSize = pcmLength + 36;
int byteRate = sampleRate * channels * bitsPerSample / 8;   // 32000
int blockAlign = channels * bitsPerSample / 8;              // 2
wavOut.write("RIFF"); write(intLE(fileSize)); write("WAVE");
wavOut.write("fmt "); write(intLE(16)); write(shortLE(1));  // PCM
write(shortLE(channels)); write(intLE(sampleRate)); write(intLE(byteRate));
write(shortLE(blockAlign)); write(shortLE(bitsPerSample));
wavOut.write("data"); write(intLE(dataSize));               // then 4 KB copy loop
```

`intToByteArray`/`shortToByteArray` emit little-endian (`:9903–9920`). Standard 44-byte canonical header; the service's `convertPcmToWav` produces the identical header with `ByteBuffer.LITTLE_ENDIAN` (`TranscriptionService.java:282–320`).

### 1.7 MP3 path — dead code

`convertPCMtoMP3` (`:9792–9853`) configures `MediaCodec.createEncoderByType(MIMETYPE_AUDIO_MPEG)` at 64 kbps and pumps PCM through it. It has **no call sites** (grep) and would throw at runtime anyway: AOSP ships no MP3 *encoder* in MediaCodec. Treat as dead.

### 1.8 OEM recording vs mod recording

The OEM app has its own recorder gated by the Settings pref `pref_person_ptt_record` (`DmrManager.needSaveRecordFile()`, `DmrManager.java:922–924`). On RX, `PCMReceiveManager.startPcmRead()` opens `/sdcard/interphone/record/yyyyMMdd-HHmmss.pcm` and `writeAudioTrack` appends every buffer (`PCMReceiveManager.java:127–166`); the fragment then registers it in the OEM record DB (`InterPhoneTalkBackFragment.setStopReceivePrepare`, `:650`). TX audio is captured by `PrizePcmManager`/`AudioRecorder` from the microphone (`AudioRecord(1, 16000, CHANNEL_IN_MONO(16), PCM_16BIT)`, `AudioRecorder.java:14–17, 58–59`), and `PcmToWav` wraps PCM as **8 000 Hz stereo** WAV. The mod's recorder is independent: same tap point, but per-channel folders under `Download/DMR/Audio`, caller-name filenames, WAV output, pre-squelch audio, and a 10 kB minimum — and it runs even when the OEM pref is off. If both are on, the same RX is written twice (OEM `.pcm` + mod `.wav`).

---

## 2. Transcription pipeline (shipped)

### 2.1 End-to-end

```mermaid
sequenceDiagram
    participant HW as PrizeTinyService (RX PCM)
    participant PCM as PCMReceiveManager.writeAudioTrack (hooked)
    participant MSH as ModuleStatusMessageHandler.handle (hooked)
    participant MH as MainHook (com.pri.prizeinterphone process)
    participant SVC as TranscriptionService (com.macdmr.transcription)
    participant G as speech.googleapis.com

    Note over MH: TalkBack fragment created → bindToTranscriptionService() (:2064)
    MH->>SVC: bindService(ComponentName, BIND_AUTO_CREATE)
    SVC-->>MH: onServiceConnected → isReady() → toast
    HW->>PCM: byte[] (8 kHz×2ch / "16 kHz mono", 16-bit)
    PCM->>MH: bufferAudioForTranscription(pre-squelch copy) (:10087)
    Note over MH: List<Short> audioBuffer, cap 480 000 samples (30 s); extra audio dropped
    MSH->>MH: status 2/11 RECEIVE_STOP (:8518)
    MH->>MH: snapshot caller (savedCaller*ForTranscription) (:8537)
    MH->>MH: processTranscription(appContext) → new Thread (:8543, :11131)
    MH->>SVC: transcribe(pcmBytes[≤960 000], 16000)  (blocking Binder)
    SVC->>SVC: PCM→WAV (44 B header) → Base64
    SVC->>G: POST /v1/speech:recognize?key=… {config LINEAR16/en-US, audio.content}
    G-->>SVC: {results[0].alternatives[0].transcript}
    SVC-->>MH: transcript | "" | "[error …]"
    MH->>MH: updateTranscriptionDisplay("[HH:mm:ss] Name: text") + per-channel history (≤10)
    MH->>MH: saveTranscriptionToFile → Download/DMR/Transcription/<Ch>/transcription_YYYYMMDD.txt
    MH->>MH: audioBuffer.clear()
```

**Which path is live:** the module never talks to any HTTP endpoint for transcription; the only engine is the AIDL call `transcriptionService.transcribe(pcmBytes, 16000)` (`MainHook.java:11148`). There is no in-process fallback — if the service is unbound the audio for that transmission is discarded (`:11119–11127`). The service's engine is Google Cloud STT (`TranscriptionService.java:174`). There is **no Whisper code anywhere in either project** (grep `whisper` in `DMRModHooks/app/src` and `DMRTranscriptionService/app/src` → only `strings.xml`'s description string).

### 2.2 Buffering (`bufferAudioForTranscription`, `:10948–10974`)

| Item | Value |
|---|---|
| Container | `Collections.synchronizedList(new ArrayList<Short>())` (`:182`) |
| Cap | `MAX_BUFFER_SIZE = 480000` samples = 960 000 bytes = 30 s at the assumed 16 kHz (`:183`); when full, further chunks are dropped with a log line — no mid-transmission flush |
| Conversion | bytes → `short` LE, one `List.add` per sample (boxing; ~16 k allocations/s) |
| Progress log | `audioBuffer.size() % 80000 == 0` — chunk sizes are multiples of 1 024 samples, and lcm(1024, 80000)=640 000 > cap, so the "Buffered N samples" line effectively never fires |
| Flush | Only at status 2/11 via `processTranscription` (`:8541–8544`), on TXT-off (`:2099`), or when the service is unbound at flush time (`:11123`) |
| Analog | status 13 (`MIX_CHECK_ANALOG_RECEIVE_STOP`) does not flush; if a radio emits only 12/13 for analog RX, analog is never transcribed |

### 2.3 `processTranscription` (`:11112–11194`)

- Guard: `isTranscriptionEnabled && !audioBuffer.isEmpty()`.
- Unbound → display `[Service not ready - please wait...]`, clear buffer, call `bindToTranscriptionService` (lazy reconnect). That placeholder is also pushed into channel history.
- Bound → `new Thread`: copies `bufferSize = audioBuffer.size()` (comment: avoids race while a new RX appends), packs LE bytes, synchronous `transcribe()`. Result non-blank → `currentTranscription = result`, else `[No speech detected]`.
- Display prefix (digital only, `savedChannelTypeForTranscription == 0`): `"<Name>: text"` or `"ID <dmrId>: text"` using the snapshot taken at RECEIVE_STOP (`:8537–8539`) because `clearCallerDisplay()` nulls `currentCaller*` right after (`:8549`, `:9269–9271`).
- Errors: any exception → `[IPC error: msg]` displayed; **no retry, no timeout** (Binder call blocks the worker thread up to the service's 3×30 s OkHttp timeouts). Service-side error strings (`[API error: 403]`, `[No network connection]`, …) are non-blank, so they are displayed **and appended to the daily log** as if they were speech.
- `finally audioBuffer.clear()`.
- Binder size: 960 000 B payload + parcel overhead is within but close to the 1 MB Binder transaction ceiling; a `TransactionTooLargeException` would surface as `[IPC error: …]`.

### 2.4 API key file and dialog

| Item | Fact | Cite |
|---|---|---|
| Path | `Environment.DIRECTORY_DOWNLOADS/DMR/api_key.txt` → `/sdcard/Download/DMR/api_key.txt` | `:11201–11203`, `:1088` |
| Bootstrap | Created on first `InterPhoneHomeActivity.onCreate` with first line `YOUR_GOOGLE_CLOUD_API_KEY_HERE` plus `#` comment lines (Google Cloud instructions, pricing) | `:1087–1109` |
| Read | First line, trimmed; module treats null/empty/placeholder as "not configured" | `:11199–11218`, `:2072–2073` |
| Write | `key\n\n# Google Cloud Speech-to-Text API Key …` | `:11223–11245` |
| Dialog | Title "Google Cloud API Key Required"; HTML help with link to console.cloud.google.com; `EditText` hint `AIza...`; warns (does not block) if key does not start with `AIza`; **Save & Enable** saves but deliberately does not toggle TXT on; **Edit File Manually** toasts the path; shown when TXT is tapped with no key, or on **long-press** of TXT any time | `:11250–11359`, `:2070–2078`, `:2114–2121` |
| Service side | Service reads the same file itself in `onCreate()` → `loadApiKey()`, falling back to `BuildConfig.GOOGLE_CLOUD_API_KEY` from `local.properties` | `TranscriptionService.java:58, 70–95`; `build.gradle` |

The module never transmits the key; it only gates the toggle. The service caches the key **once at `onCreate`** — rotating the file requires restarting the service process (§6.2).

### 2.5 HTTP request (service, `TranscriptionService.java:137–212`)

```java
config: {"encoding":"LINEAR16","sampleRateHertz":16000,"languageCode":"en-US","enableAutomaticPunctuation":true}
audio:  {"content": Base64.NO_WRAP( 44-byte WAV header + PCM )}
POST https://speech.googleapis.com/v1/speech:recognize?key=<apiKey>
Content-Type: application/json; charset=utf-8
OkHttpClient: connect 30 s / read 30 s / write 30 s   (new client per call)
```

Response handling: non-2xx → `[API error: <code>]`; no `results` → `""`; else `results[0].alternatives[0].transcript`. `JSONException` → `[JSON error: …]`; `IOException` → `[Network error: …]`. Pre-checks: key configured (`[API key not configured - Press TXT to configure]`), `ConnectivityManager.getActiveNetworkInfo().isConnected()` (`[No network connection]`). No language auto-detect, no model selection, no word timestamps, no retries. The synchronous `recognize` endpoint caps audio at ~1 min, so the 30 s buffer is safe. Payload on the wire ≈ 4/3 × 960 kB ≈ 1.3 MB per 30 s transmission.

### 2.6 Display panel (intercom page)

- Built in `hookTalkBackFragment` inside the `borderBox` `FrameLayout`, gravity BOTTOM, 8 dp margins, cyan 2 dp stroke `0xAA00BFFF`, fill `0x1500BFFF`, radius 8 dp, tag `DMR_TRANSCRIPTION_BOX_LAYOUT`; header `📝 Transcription` (10 sp bold cyan); inner `ScrollView` (`DMR_TRANSCRIPTION_SCROLL`) wrapping a vertical `LinearLayout` (`DMR_TRANSCRIPTION_MESSAGES`); initially `GONE` (`:1540–1616`).
- `updateTranscriptionDisplay(text)` (`:11364–11429`): prefixes `[HH:mm:ss]`, appends to `channelTranscriptionHistory[currentChannelNumber]` trimmed to `MAX_TRANSCRIPTION_HISTORY = 10` (`:198–199`), posts a white 11 sp `TextView`, shows the box, caps the ScrollView at **100 dp** and scrolls to bottom.
- TXT-off clears the views and hides the box but leaves the in-memory history intact (`:2098–2108`).

### 2.7 Per-channel history restore

`restoreChannelTranscriptionHistory(channelNumber)` (`:11434–11484`) rebuilds the message views from the `HashMap<Integer, ArrayList<String>>` and hides the box if empty. Called for the initial channel (`:2837`) and on every channel change (`:3008`). History is process-memory only — it does not survive an app restart and is not read back from the daily log files.

### 2.8 Daily log file

`saveTranscriptionToFile(transcription, recordingPath)` (`:11491–11563`), background thread, `recordingPath` unused:

- Folder `Download/DMR/Transcription/<ChannelFolder>/` (same sanitiser as recordings; note it reads `currentChannelName` at write time, so a fast channel change can file the line under the new channel).
- File `transcription_yyyyMMdd.txt`, `FileWriter(append=true)`.
- Line format: `[HH:mm:ss] ` + (`<Name>: ` | `ID <n>: ` | nothing for analog) + `<text>\n`.
- Blank/whitespace results are skipped; `[No speech detected]` and error strings are **not** skipped.

### 2.9 `dmrmod_history.db` `transcription` column

`channel_history` is created with `transcription TEXT` and an `ALTER TABLE … ADD COLUMN transcription` migration in both `loadChannelHistory` and the insert helper (`:9428–9450`, `:9555–9576`), but the `ContentValues` insert never sets it (`:9580–9588`) and the `SELECT` never reads it (`:9454`). The column is a leftover of the Phase-1 plan (`docs/TRANSCRIBING_PLAN.md:37, 129, 254–262`) — always `NULL`.

---

## 3. `DMRTranscriptionService` app

### 3.1 Manifest (`DMRTranscriptionService/app/src/main/AndroidManifest.xml`)

| Item | Value |
|---|---|
| Package / `applicationId` | `com.macdmr.transcription` (`build.gradle` namespace + applicationId), `versionName 1.0.0`, minSdk 24, target/compile 34 |
| Components | One `<service android:name=".TranscriptionService" android:enabled="true" android:exported="true" android:foregroundServiceType="microphone|dataSync">` with `<intent-filter><action android:name="com.macdmr.transcription.SERVICE"/></intent-filter>`. **No activity**, no launcher icon entry. |
| Permissions | `INTERNET`, `ACCESS_NETWORK_STATE`, `RECORD_AUDIO`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MICROPHONE`, `FOREGROUND_SERVICE_DATA_SYNC`, `POST_NOTIFICATIONS`, `READ_EXTERNAL_STORAGE`, `READ_MEDIA_AUDIO` |
| Label / icon | "DMR Transcription Service", `@android:drawable/ic_btn_speak_now`; `strings.xml` `service_description` still says "using Whisper AI" |
| Exported without permission | Any app can bind and spend the user's Google quota (the key never leaves the device, but calls do). |

`RECORD_AUDIO`/`FOREGROUND_SERVICE_MICROPHONE` are unused by the code (audio arrives over Binder); `READ_EXTERNAL_STORAGE`/`READ_MEDIA_AUDIO` are there so `loadApiKey()` can read `Download/DMR/api_key.txt` — on Android 13+ `READ_MEDIA_AUDIO` does not grant access to a `.txt`, so the file read may fail silently and the service falls back to the `BuildConfig` key (`TranscriptionService.java:88–94`).

### 3.2 AIDL (`ITranscriptionService.aidl`)

```aidl
package com.macdmr.transcription;
interface ITranscriptionService {
    String transcribe(in byte[] pcmBytes, int sampleRate);  // 16-bit LE PCM → text or "[error …]"
    boolean isReady();                                        // key configured
}
```

Both copies (module and service) declare exactly these two methods; only the Javadoc differs (`diff` output). `oneway` is not used, so `transcribe` is a blocking round-trip; the module's `processTranscription` therefore runs it on its own thread.

### 3.3 Implementation (`TranscriptionService.java`)

| Aspect | Evidence |
|---|---|
| Engine | Google Cloud Speech-to-Text v1 REST via OkHttp (`:32–36` imports, `:163–182`), class Javadoc "using Google Cloud Speech-to-Text API … $0.006 per 15 seconds" (`:38–42`). No TFLite/Vosk/Whisper imports; `build.gradle` deps are only `appcompat`, `core`, `okhttp:4.12.0`. |
| Model/assets | None. No `assets/` dir in the project tree. |
| Threading | AIDL stub methods run on Binder pool threads; the network call is made inline on that thread (`:182`). No executor, no queue — concurrent requests are simply parallel Binder threads. |
| Lifecycle | `onCreate` → `loadApiKey()`; `onBind` → `startForeground(1001, notification)` once (`:97–109`); `onStartCommand` returns `START_STICKY` (never started with `startService`, so moot); `onUnbind` logs only. Notification channel `dmr_transcription_channel`, `IMPORTANCE_LOW`, ongoing "DMR Transcription Active / Google Cloud Speech-to-Text Ready" (`:250–274`). |
| `isReady()` | `apiKey` non-null, non-empty, not `YOUR_API_KEY_HERE` (`:227–231`). Note the module's placeholder is `YOUR_GOOGLE_CLOUD_API_KEY_HERE` — if the file still holds the module's placeholder, the service loads it as a "real" key and `isReady()` returns true; the request then fails with `[API error: 400]`. |

### 3.4 How the module binds (`bindToTranscriptionService`, `MainHook.java:10865–10942`)

- Called unconditionally when the intercom fragment is built (`:2064`) — the service is bound (and thus foregrounded with its notification) whenever PriInterPhone's talk page exists and the service APK is installed, regardless of TXT state. Also called on TXT-on if unbound (`:2085`) and lazily from `processTranscription` (`:11126`).
- Intent: explicit `ComponentName("com.macdmr.transcription", "com.macdmr.transcription.TranscriptionService")` (the manifest's `com.macdmr.transcription.SERVICE` action is not used). Flags: `Context.BIND_AUTO_CREATE` only. Context: the hooked OEM app's `Context` — the binding is attributed to `com.pri.prizeinterphone`, not to the module.
- `onServiceConnected` → `Stub.asInterface`, spawns a thread calling `isReady()` and toasts "✅ Transcription ready!" / "Loading model…" (stale wording). `onServiceDisconnected` → nulls the proxy; because of `BIND_AUTO_CREATE` the system restarts the service and reconnects automatically after a crash/force-stop.
- Not installed → `bindService` returns `false` → toast "❌ Install DMRTranscriptionService first!". No further checks; TXT can still be toggled on and audio will be buffered then dropped at RECEIVE_STOP with `[Service not ready …]`.
- The module **never calls `unbindService`**; the ServiceConnection leaks across fragment recreations (a new connection object is created each time, `:10875`).

### 3.5 Build / install notes

- Service: copy `local.properties.template` → `local.properties`, optionally set `GOOGLE_CLOUD_API_KEY` (baked into `BuildConfig` as fallback), `./gradlew assembleDebug`, `adb install -r`. `.grok/rules/copilot-instructions.md:43–45`: the service alone may work without reboot; DMRModHooks always needs `adb reboot`. Practically: after installing/updating the service, kill and relaunch PriInterPhone so `hookTalkBackFragment` re-binds; after a DMRModHooks update, reboot.
- Git history: the service directory has a single commit (`77d6c34b v1.7.0: Add user-friendly API key configuration`); version has not moved since.

---

## 4. Legacy / experimental paths

### 4.1 `hookSpeechRecognizer` (`MainHook.java:714–886`)

Targets Android's on-device Google speech stack from inside the OEM process:

- `android.speech.SpeechRecognizer.createSpeechRecognizer(Context, ComponentName)` and `(Context)` — after-hooks that, if the framework returned `null` ("service blocked"), reflectively invoke the private constructor `SpeechRecognizer(Context, ComponentName)` and `setResult` it (`:723–797`).
- `android.app.ContextImpl.bindService(Intent, ServiceConnection, int)` — logs any intent whose action/component contains `speech`/`Speech`/`Recognition`/`GoogleRecognition`, and forces the return value to `true` when the framework returned `false` (`:799–879`).

### 4.2 `hookSystemRecognitionService` (`:896–944`)

Hooks `com.android.server.speech.SpeechRecognitionManagerServiceImpl.bindService(Intent, ServiceConnection)` to force `true` and bypass "serviceComponent is not RecognitionService". That class lives in **system_server**; the module's `handleLoadPackage` only acts on `TARGET_PACKAGE` (`com.pri.prizeinterphone`), so even if called it could never resolve the class.

### 4.3 Are they active?

**No.** `handleLoadPackage` registers `hookApplication`, `hookMainActivity`, `hookTalkBackFragment`, `hookLocalFragment`, `hookInformationActivity`, `hookModuleStatusHandler`, `hookDigitalAudioHandler`, `hookPCMReceiveManager`, `hookSignalMessageHandler`, `hookDmrManager`, channel/zone hooks, `hookSerialCommunication`, `registerDebugPacketReceiver`, `hookMessageDisplay`, `hookBottomNavBar`, `hookOtherFragmentBackgrounds`, `hookGenericActivityBackgrounds` (`:349–416`; `hookUpdateFirmwareActivity` and `testBootloaderAccess` are commented out). Grep for `hookSpeechRecognizer(` / `hookSystemRecognitionService(` finds only the definitions. Both are dead code from the Phase-1 "Android SpeechRecognizer" attempt.

### 4.4 `speech_model.tflite` — dead weight

- `DMRModHooks/app/src/main/assets/speech_model.tflite` = **41 655 568 bytes**; `README_MODEL.md` (same folder) claims "TFLite integration complete … `new Interpreter(modelBuffer, options)` in MainHook.java".
- Reality: grep `speech_model|tflite|Interpreter` across `DMRModHooks/app/src/main/java` and `DMRTranscriptionService/app/src` → **0 hits**; `DMRModHooks/app/build.gradle` has no `org.tensorflow:*` dependency (only `compileOnly de.robv.android.xposed:api:82`).
- Every release APK in `releases/` is ~43.3 MB (`DMRModHooks-v3.4.6.apk` = 43 347 995 B); the model is ~96 % of that. Removing it (and `PATCH14.bin`, 378 KB, belongs to the firmware chapter) would give a ~2 MB APK. It is committed in git (`f058d876 v3.0.2`).

### 4.5 Timeline of approaches (from docs/scripts)

| When (2026) | Approach | Artefacts | Outcome |
|---|---|---|---|
| Feb 26 | **Android `SpeechRecognizer`** (Google on-device/cloud) | `TRANSCRIBING_PLAN.md` Phase 1; `hookSpeechRecognizer`/`hookSystemRecognitionService` | Framework refuses third-party binding ("serviceComponent is not RecognitionService"); hooks kept but unregistered |
| Feb 26 | **Vosk** (`vosk-android:0.3.47` + JNA) | `download-vosk-model.ps1` (pushes `vosk-model-small-en-us-0.15` into `/data/data/com.pri.prizeinterphone/files/` via `run-as`) | `UnsatisfiedLinkError` — JNA cannot locate `libjnidispatch.so` under LSPosed's isolated ClassLoader; cancelled (`TRANSCRIBING_PLAN.md:11–28`) |
| Feb 26 | **TFLite in-module** (`tensorflow-lite:2.14.0`, model in assets or downloaded) | `README_MODEL.md`, `speech_model.tflite` (41.6 MB) | Code removed; asset left behind |
| Feb 26 | **IPC service + Whisper Tiny TFLite** (Sphinx4 also mentioned as a prior in-module try) | `IPC_SERVICE_IMPLEMENTATION_PLAN.md` (`WhisperTranscriber`, `TestActivity`), `test-whisper-inference.ps1`, `test-onnx-transcription.ps1`, `convert_whisper_to_tflite.py`, `convert_tf_to_tflite.py` (→ `speech_model_base.tflite`), `check_whisper_formats.py`, `search_whisper_tflite.py`, `check_tflite_repos.py`, `generate_whisper_tflite.ipynb`, `docs/whisper_android_readme.md` (vilassn/whisper_android README) | Token decoding never implemented; ONNX Whisper-base tests referenced a `TestActivity` that no longer exists |
| Feb 27 | Dynamic model download design | `TODO_MODEL_DOWNLOAD.md` | Not started |
| v1.7.0 (`77d6c34b`) | **Google Cloud Speech-to-Text via the IPC service** | `TranscriptionService.java`, API-key dialog, `api_key.txt` | **Shipped path** — the only working engine |

**Conclusion:** the shipped path is *cloud Google STT through DMRTranscriptionService over AIDL*. Nothing Whisper-based (cloud or TFLite) ever shipped.

---

## 5. RadioID.net database (`RadioidDatabase.java`)

### 5.1 Constants and storage

| Item | Value | Cite |
|---|---|---|
| Download URL | `https://www.radioid.net/static/user.csv` (GET) | `:53` |
| CSV dir | `Download/DMR/RadioID/` (`getRadioIdDir()`), default file `user.csv` | `:54–55, 719–722` |
| SQLite | `dmrmod_radioid.db`, `DATABASE_VERSION = 2`, created via `SQLiteOpenHelper` on the **hooked app's** application context → `/data/data/com.pri.prizeinterphone/databases/dmrmod_radioid.db` | `:46–47, 72–81` |
| Prefs | `dmrmod_radioid_prefs`: `last_sync_ms` (long), `entry_count` (int), `source_file` (string) | `:48–51, 445–451` |
| HTTP | `User-Agent: DMRModHooks/<VERSION> (github.com/IIMacGyverII/phonedmrapp)` (set by MainHook `:4178`), `Accept: text/csv,*/*`, connect 30 s, read 120 s, 8 KB buffer; progress text updated every ~256 KB when `Content-Length` known | `:67–68, 671–717` |
| Size expectations | None in code. README: "~17 MB, ~300k registered IDs", "Wi-Fi recommended, ~1–2 min" | `README.md:39, 53` |

### 5.2 Schema

```sql
CREATE TABLE radioid_users (
  dmr_id       INTEGER PRIMARY KEY,   -- rowid alias; the only index
  callsign     TEXT, first_name TEXT, last_name TEXT,
  city TEXT, state TEXT, country TEXT,
  display_name TEXT NOT NULL);         -- "CALL First Last"
-- onUpgrade(<2): ALTER TABLE ADD COLUMN city/state/country TEXT DEFAULT ''
```

(`:84–105`). No secondary indexes (callsign lookup is not supported). `hasLocationData()` probes `city != ''` to detect v1 imports and drives the "⚠ Names only — Download again" status line (`:196–214, 232–234`).

### 5.3 CSV parsing (`detectFormat`/`parseLine`, `:502–589`)

| Format | Detection | Column mapping |
|---|---|---|
| `RADIOID_HEADER` (official `user.csv`) | header contains `RADIO_ID` and `CALLSIGN` (case-insensitive) | `[0]=RADIO_ID, [1]=CALLSIGN, [2]=FIRST_NAME, [3]=LAST_NAME, [4]=CITY, [5]=STATE, [6]=COUNTRY`; lines whose first field contains `RADIO` skipped |
| `DMR_DATABASE` (CPS "Private Call" export) | line starts with `Private Call,` or `"Private Call"` (checked 2nd) | `id = last field` (needs ≥6 fields); callsign = `[1]` with a trailing `" <id>"` stripped; first name = `[2]`; city = `[3]` |
| `QUOTED_THREE_COL` | ≥3 fields and `[0]` is a quoted/plain int in `(0, 16777215)` (checked 3rd) | `[0]=id, [1]=callsign, [2]=name` (as first name) — fields `[3..6]` are **ignored** |
| `RADIOID_NO_HEADER` | ≥2 fields and `[0]` parses as int (checked **last**) | same positional mapping as `RADIOID_HEADER` |
| `UNKNOWN` | otherwise | import aborts with "Unrecognized CSV format" |

⚠️ Detection order matters (`detectFormat`, `:502–521`): a **headerless** 7-column RadioID-style file whose first row has a valid ID is classified `QUOTED_THREE_COL` (≥3 fields wins before the `RADIOID_NO_HEADER` check), so last name / city / state / country are silently dropped. `RADIOID_NO_HEADER` is only reached for exactly-2-field rows or an out-of-range first ID. Keep the official header line intact.

`splitCsvLine` toggles on `"` and splits on unquoted commas (no `""` escape handling); `clean()` trims and strips quotes; UTF-8 with BOM stripped (`:635–665`). Rows are dropped when `id <= 0 || id >= 16777215` or the computed `display_name` is empty (`:591–609`). `formatDisplayName` = `"CALL First Last"` | `"CALL"` | `"First Last"` (`:611–628`).

### 5.4 Import performance

`importFromCsvFile` (`:387–470`): one `beginTransaction()`, `DELETE FROM radioid_users`, a single compiled `INSERT OR REPLACE … VALUES (?,?,?,?,?,?,?,?)` `SQLiteStatement` re-bound per row (`bindRow`, `:472–481`), progress text every 20 000 lines, `setTransactionSuccessful()` at the end. On any exception the transaction is rolled back in `finally`, so a failed import **keeps the previous table contents** (but prefs are only updated on success). Reading is a `BufferedReader` over `BufferedInputStream`; whole file streamed line-by-line, no batching beyond the single transaction.

### 5.5 Manual import

`showImportDialog` (`:286–346`): lists `*.csv` in `Download/DMR/RadioID/` sorted reverse-alphabetically; needs an `Activity` context; single-choice `AlertDialog` "Import RadioID CSV" showing the current status summary; Import → `importCsvInBackground` (thread + progress holder). No CSV → toast "No CSV in Download/DMR/RadioID/ — Copy user.csv there or use Download button." Path for users: `adb push user.csv /sdcard/Download/DMR/RadioID/user.csv`.

### 5.6 Progress dialog and the `BadTokenException` fix

`ProgressDialogHolder` (`:758–836`): a non-cancelable `AlertDialog` titled "RadioID Database" shown via `activity.runOnUiThread`; enabled only if the context is an `Activity` that is neither `isFinishing()` nor `isDestroyed()` (`dialogEnabled`, re-checked by `canShowDialog()` right before `show()`), with `try/catch` around `show()`/`setMessage()`/`dismiss()`. When no usable activity exists, `show`/`update` degrade to toasts on the application context. This guard set is the "Fix RadioID download progress dialog BadTokenException" listed in commit `0f0fe397` (v3.4.4; `git log -S ProgressDialogHolder` returns only that commit); `releases/v3.4.4_RELEASE_NOTES.md:34` lists it, and both `releases/v3.4.5_RELEASE_NOTES.md:41` and the README (`:97`, under "What's New in v3.4.5") repeat it — same code, different label. Root cause was showing a dialog from a background thread against an activity window that had gone away (e.g. leaving the Device tab mid-download).

### 5.7 Device-tab UI (`MainHook.java:4150–4216`)

Appended after the Export/Import(OpenGD77) buttons: a grey 12 sp status `TextView` (`getStatusSummary`: "N global IDs loaded (full location data) / Last update: yyyy-MM-dd HH:mm / Source: radioid.net/user.csv", or "not loaded"), **🌐 Download RadioID Database** → `downloadAndImport(activity, userAgent, refreshStatus)`, and **📂 Import RadioID CSV** → `showImportDialog(activity, refreshStatus)`. Completion toasts: "✓ RadioID DB loaded: N IDs (with location)" or "❌ Download failed: …". Network gate `isNetworkAvailable` (`getActiveNetwork` + WIFI/CELLULAR/ETHERNET transport; optimistic `true` on exception, `:724–739`).

### 5.8 Lookup API and caller panel use

| API | Behaviour | Cite |
|---|---|---|
| `lookupRecord(int)` | bounds check `(0, 16777215)`, `SELECT … WHERE dmr_id = ?` → `CallerRecord{dmrId, callsign, firstName, lastName, city, state, country, displayName}` or `null` | `:147–184` |
| `lookupDisplayName(int)` | `displayName` trimmed or `null` | `:139–145` |
| `getEntryCount`, `getStatusSummary`, `hasLocationData` | prefs / probe | `:186–240` |

Two-tier resolution in `MainHook.lookupCallerDisplayInfo` (`:8985–9011`): (1) `lookupPersonalContactName` opens the OEM `contact_database.db` and queries `contact_database.contact_name WHERE contact_number = ?` (`:8956–8983`); (2) `RadioidDatabase.lookupRecord`. Both may populate one `CallerDisplayInfo` (`:8893–8937`):

- `shortName()`: personal name → callsign → "First Last" (used for `currentCallerName`, recording filenames, transcription prefixes, history).
- `headline()`: `📡 <personal name | callsign | "Voice RX">` + `sourceBadge()` `⭐` (personal) / `🌐` (global).
- Panel body (`populateCallerFieldsContainer`, `:9096–9152`): row 1 `🆔 <id>` + `👤 First Last` (suppressed when identical to the personal name); row 2 marquee `🏙️ city   🗺️ state   🌍 country` (global rows only).
- History label (`formatDmrHistoryLabel`, `:9031–9063`): `First Last · CALLSIGN` (personal name substitutes for `First Last` when RadioID has no name), else callsign, else ID.

Lookups run per RX on the `updateCallerInfoAsync` worker thread (`:8845–8890`, spawned from the `DigitalAudioMessage` hook once the DMR ID is decoded, `:8776–8778`) and again from `updateCallerDisplay()` (`:9223–9251`) using `PrizeInterPhoneApp.getContext()`; each call opens a readable DB through the singleton helper. (`queryCallerInfo`, `:8803`, only *sends* the caller-info query to the radio.)

### 5.9 Refresh / update policy

Manual only. No scheduled refresh, no ETag/If-Modified-Since, no age warning beyond the "Last update" line. Every download overwrites `user.csv` and rebuilds the table from scratch. Personal contacts are never modified by the import.

---

## 6. Practical

### 6.1 Testing without a radio signal

No script drives the module's in-process pipeline (it is gated on `ModuleStatusMessageHandler` status codes). What exists:

| Script | What it does | Usable today? |
|---|---|---|
| `scripts/test-wav-direct.ps1` | ffmpeg → 8 kHz mono s16le PCM, then prints a **manual** procedure (play the file into the radio, tap TXT) and tails logcat | Yes (manual) |
| `scripts/test-transcription-auto.ps1` | Same conversion, pushes `/sdcard/test_transcription.pcm`, then emits a Java snippet meant to bind `ITranscriptionService` and call `transcribe()` from a throw-away app | Skeleton only — you must build the harness app yourself |
| `scripts/record-test-audio.ps1` | `adb shell tinycap /sdcard/test_recording.wav -c 1 -r 8000 -b 16 -t 3` (needs root) then `adb pull` | Yes on rooted device |
| `scripts/start-transcription-logs.ps1` | `adb logcat -s TranscriptionService:* WhisperTranscriber:* AndroidRuntime:E System.err:*` (no `DMRModHooks` tag — module output goes to `XposedBridge.log`, not logcat) | Yes (the `WhisperTranscriber` tag never appears) |
| `scripts/test-whisper-inference.ps1` | Same plus `DMRModHooks:*` | Yes, same caveat |
| `scripts/test-onnx-transcription.ps1` | `am start -n com.macdmr.transcription/.TestActivity` | Dead — no such activity |

Fastest realistic loops: (a) play a known WAV into the radio on a simplex channel from a second radio/phone, watch `adb logcat | grep -E "DMRModHooks|TranscriptionService"`; (b) for the service alone, write a 20-line app that binds the exported service (no permission required) and feeds a WAV's data chunk to `transcribe(bytes, 16000)`; (c) for recording/WAV logic, `adb pull /sdcard/Download/DMR/Audio/` and check headers with `ffprobe` (expect 16000 Hz mono per header; try `-ar 8000 -ac 2` reinterpretation if speech sounds doubled).

### 6.2 Rotating the API key

1. Edit `/sdcard/Download/DMR/api_key.txt` (first line only) — via long-press TXT → dialog → Save, or `adb shell "echo AIza... > /sdcard/Download/DMR/api_key.txt"`.
2. Restart the service so `onCreate` re-reads it: `adb shell am force-stop com.macdmr.transcription`. `BIND_AUTO_CREATE` brings it back on the next Binder use; or relaunch PriInterPhone.
3. Verify: logcat `TranscriptionService` prints "API key loaded from file" and `isReady() = true`. Anyone with storage access can read the key — it is plaintext on shared storage.

### 6.3 Inspecting artefacts via adb

```sh
adb shell ls -R /sdcard/Download/DMR/Audio /sdcard/Download/DMR/Transcription
adb shell cat "/sdcard/Download/DMR/Transcription/<Channel>/transcription_$(date +%Y%m%d).txt"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/dmrmod_radioid.db \
  'select count(*), sum(city<>\"\") from radioid_users; select * from radioid_users where dmr_id=3112345;'"
adb shell su -c "cat /data/data/com.pri.prizeinterphone/shared_prefs/dmrmod_radioid_prefs.xml"
adb shell su -c "sqlite3 /data/data/com.pri.prizeinterphone/databases/dmrmod_history.db \
  'select channel_number,dmr_id,timestamp,transcription from channel_history order by id desc limit 5'"   # transcription is always NULL
adb logcat -s TranscriptionService:* | cat            # service side
adb shell su -c "tail -f /data/adb/lspd/log/modules.log" | grep DMRModHooks   # XposedBridge.log output (path varies by LSPosed build)
adb shell dumpsys activity services com.macdmr.transcription   # is it bound / foreground?
```

### 6.4 Cost / latency levers visible in code

- One request per transmission, at most 30 s of audio (`MAX_BUFFER_SIZE`); Google bills in 15 s increments (dialog text: 60 min/month free, then $0.006 / 15 s).
- Upload ≈ 1.3 MB JSON per full buffer; three 30 s OkHttp timeouts bound a failure at ≈ 90 s, during which the module's worker thread is blocked (a new RX in the meantime starts filling a freshly cleared buffer only after `finally`, so overlapping transmissions can be lost).
- `enableAutomaticPunctuation=true`, `en-US` fixed; no `model` (e.g. `phone_call`) or `useEnhanced` set — both would help AMBE-vocoded audio.

### 6.5 Known limitations

- Transmissions > 30 s are truncated; nothing is streamed.
- Requires network + Google key; no offline engine; error strings pollute the daily log.
- History is in-memory, max 10 per channel; lost on restart.
- Analog RX reported only via status 12/13 is neither recorded nor transcribed.
- Recording folder/name is decided at `RECEIVE_START` from `currentChannelName`; channel change mid-RX does not split files.
- The 16 kHz-mono assumption vs. 8 kHz-stereo AudioTrack config is unverified (§1.3).
- Service is exported with no permission; foreground notification stays as long as PriInterPhone holds the binding (never unbound).
- REC/TXT state is not persisted; APRS monitoring silently disables both.

---

## 7. Gotchas & ⚠️ Doc drift vs `.grok/rules/copilot-instructions.md` (and README)

| # | Doc says | Code says | Cite |
|---|---|---|---|
| 1 | copilot `:75` "The cloud **Whisper** API path is what works"; `:285` "cloud Whisper is the shipped path"; README `:832, 853, 877, 953` "OpenAI Whisper API" | Engine is **Google Cloud Speech-to-Text v1** (`speech.googleapis.com/v1/speech:recognize`), OkHttp, LINEAR16/en-US. No Whisper code in either project. | `TranscriptionService.java:39–42, 147–174` |
| 2 | copilot `:579` `/sdcard/DMR/api_key.txt` "OpenAI Whisper API key" | `/sdcard/Download/DMR/api_key.txt`, a **Google** key (`AIza…`), placeholder `YOUR_GOOGLE_CLOUD_API_KEY_HERE` | `MainHook.java:1088–1092, 11201–11203` |
| 3 | copilot `:574` `DMR/Recordings/[ChannelName]/` | `DMR/Audio/<ChannelName>/` (and the task brief's `DMR/Recordings/` is likewise wrong) | `MainHook.java:1064, 9665` |
| 4 | copilot `:285` lists `hookSpeechRecognizer()`/`hookSystemRecognitionService()` under Audio Processing Hooks as "integration (legacy / research)" | Neither is invoked from `handleLoadPackage`; dead code. `hookSystemRecognitionService` targets a system_server class the module can never see. | `MainHook.java:349–416` |
| 5 | copilot `:232` "Recording (WAV → transcription pipeline)" | Recording and transcription are independent consumers of the same PCM tap; transcription uses the in-memory `audioBuffer`, never the WAV (`lastRecordingPathForTranscription` is write-only). | `MainHook.java:9776, 11180` |
| 6 | copilot `:547` `channel_history … transcription` column | Column exists but is never written or read (always NULL). | `MainHook.java:9435, 9580–9588` |
| 7 | copilot `:384` "2. Make copy of audio data for decoders" *after* amplitude | Copy is made first (`:9949–9956`), then amplitude (`:9959`). Order is harmless; text is just off. | `MainHook.java:9949–9959` |
| 8 | `README_MODEL.md` "TFLite integration complete … MainHook loads `speech_model.tflite` with `new Interpreter(…)`" | No TFLite dependency or code; the 41.6 MB asset is unused and inflates every release APK to ~43 MB. | `DMRModHooks/app/build.gradle`, grep |
| 9 | `DMRTranscriptionService/res/values/strings.xml` "transcribing DMR radio audio using Whisper AI"; module toast "Loading model…" | Google STT, no model. | `strings.xml:3`, `MainHook.java:10888` |
| 10 | `docs/IPC_SERVICE_IMPLEMENTATION_PLAN.md` binds by action `com.macdmr.transcription.SERVICE`, package `com.macdmr.transcription.service`, Whisper Tiny asset | Module binds by explicit `ComponentName`; package is `com.macdmr.transcription`; no assets. | `MainHook.java:10913–10917` |
| 11 | `docs/TRANSCRIBING_PLAN.md` "display box max 3 lines" | ScrollView capped at 100 dp; 10 messages per channel retained. | `MainHook.java:199, 11415` |
| 12 | README `:97` lists the `BadTokenException` fix under v3.4.5 | Fix landed in `0f0fe397` (v3.4.4) together with `RadioidDatabase.java`. | `git show --stat 0f0fe397` |
| 13 | Module/README comments: "16 kHz mono" DMR audio | OEM `AudioTrack` is configured 8 kHz **stereo** 16-bit; equal byte rate makes the 16 k/mono header "work". | `PCMReceiveManager.java:22–23, 68` |
| 14 | copilot `:1530` "v1.7.0 … Transcription and API features" | Correct — and it is the only commit touching `DMRTranscriptionService/` (`77d6c34b`); the service has had no fixes since. | `git log -- DMRTranscriptionService` |

Additional gotchas not covered by docs: TXT/REC are wiped by starting APRS monitoring (`:4801–4817`); binding happens on fragment creation even with TXT off (`:2064`), so the service's foreground notification appears as soon as the intercom page opens; `Save & Enable` in the key dialog does not enable; zero-byte `.pcm` stubs are left when a recording captured nothing; the module's placeholder key differs from the service's (`YOUR_GOOGLE_CLOUD_API_KEY_HERE` vs `YOUR_API_KEY_HERE`), so `isReady()` can be `true` with a placeholder in the file.
