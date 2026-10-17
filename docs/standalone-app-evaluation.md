# Standalone app instead of an LSPosed module — feasibility (2026-10-17)

Question: can the DMR features move out of the Xposed/LSPosed hook on the OEM `PriInterPhone` app into
an app of our own that drives the radio directly? Everything below was measured on the Armor 26 Ultra
(Android 13, Magisk 30.6, SELinux enforcing) with a probe inside the companion app
(`DMRTranscriptionService` → `ProbeReceiver`, an ordinary `untrusted_app` process):

```
adb shell am broadcast -a com.macdmr.transcription.PROBE -n com.macdmr.transcription/.ProbeReceiver [--ez deep true]
adb logcat -d -s StandaloneProbe
```

## 1. What the OEM app actually depends on

| Dependency | How the OEM gets it | Can a normal app get it? |
|---|---|---|
| **MCU UART** `/dev/ttyS0` @ 57600 (every command: channel programming, PTT, caller info, RSSI, SMS…) | Opened by JNI from a process with **uid 1000 / `system_app` domain** (`/system/priv-app/PriInterPhone`, `sharedUserId=android.uid.system`, platform-signed) | **No.** DAC is `crw-rw-rw-` but SELinux denies: `avc: denied { read write } … scontext=u:r:untrusted_app … tcontext=u:object_r:ttyS_device`. The live policy allows only `system_app`, `system_server`, `atcid`, `factory`, `meta_tst`. |
| **Voice audio RX/TX** | `android.os.PrizeTinyService` (framework class in `framework.jar`, hidden API) → binder `tinyservice` served by `/system/bin/tinyserver` (uid audioserver, tinyalsa device 8 / card 0, I2S2 in, I2S1 out, 8 kHz stereo 16-bit, 2048-byte frames) | **Yes.** The service is labelled `audioserver_service` (findable by apps) and does **no caller check**: from the companion app `openRecvPcm()=true`, `openWritePcm()=true`, `getFrameSize()=2048`, `startRecvPcm()=0`, close calls fine. The class members are hidden-API blocked, but `org.lsposed.hiddenapibypass` 4.3 unlocks them (tested, `addHiddenApiExemptions("")`). RX callback = subclass `android.os.ITinyRecvCallback.Stub` (needs a compile-time stub jar; the runtime class is in the boot class path). |
| **Service-side serial port** | `ITinyService.openSerialPort(int,int)` / `closeSerialPort()` exist in the AIDL | `openSerialPort(57600,0)` returned **−2** from the app: tinyserver (audioserver domain) cannot open `ttyS_device` either. Dead end. |
| **Hardware PTT key** | `PhoneWindowManager.interceptKeyBeforeQueueing` sends implicit broadcasts `com.interphone.ptt.down` / `.up` via `sendBroadcastAsUser`, no `setPackage` | **Yes**, any app with a *dynamically registered* receiver gets them (same as the module's hardware-PTT feature today). |
| **Platform signature** | Prize/koobee key (`SHA-1 ef770abe…`, same as `framework-res.apk`) | **No.** Not the AOSP test key, so we can never get `android.uid.system` / `system_app` by signing. |
| Persistent, boot-started process | `android:persistent="true"` in a priv-app | Not needed; a foreground service + BOOT_COMPLETED is enough. The OEM app must be **disabled** (`pm disable-user --user 0 com.pri.prizeinterphone`, from adb or root) or it keeps the UART open and reconfigures the MCU. |

## 2. Verdict

* **No-root standalone app: impossible on this phone.** The single blocker is the UART SELinux label. Audio, PTT key and everything else are reachable from a plain app.
* **Standalone app with root: feasible**, two ways to bridge the UART (both reversible, both need Magisk):
  1. **Root helper**: the app starts a tiny bridge via `su` (libsu) that opens `/dev/ttyS0` and relays bytes over a local socket. Proven: `su -c 'head -c 0 /dev/ttyS0'` opens fine (`magisk` domain).
  2. **Policy rule**: a Magisk module runs `magiskpolicy --live 'allow untrusted_app ttyS_device chr_file { open read write ioctl getattr lock }'` at boot; the app then opens the device directly. *Not yet tested* (the assistant's sandbox declined to apply a live SELinux change); one command to verify on the device.
* **Keeping LSPosed** is still a root dependency, so "root-required standalone" is not a step backwards in requirements; it removes the OEM-process constraints (its `AudioTrack` path, `isUserAMonkey` refusals, hook ordering, 16k-line `MainHook`) and gives us our own UI and threads.

## 3. What a standalone app has to re-implement

| Area | Status |
|---|---|
| UART framing + command table + every message body | Documented in `docs/deep-dive/01-…`, `02-…`; builders already exist in the module (`AnalogMessage`/`DigitalMessage` usage, `applyAnalogChannelDirect`, `transmitRawAx25`, diag `tune`/`chanset`) |
| MCU boot / init handshake, state machines, acks (`CmdStateMachine`) | Documented in `docs/deep-dive/03-…`; must be re-written and verified on air |
| Audio RX (decoders, captions, recording) and TX (AFSK, SSTV, tones, voice) | Trivial port: the module already works on raw 8 kHz stereo PCM; feed it from `PrizeTinyService` instead of the hooked `AudioTrack`/`AudioRecord` |
| Channel/contact/zone/TG-list storage | OEM uses per-area SQLite `database_<area>.db`; we would own a new schema (our side tables `dmrmod_*` already exist) and keep CSV import/export |
| UI | All of it: intercom, channel list/editor, contacts, SMS, device settings — today the module rides on OEM screens |
| Baseline OEM features we do not touch today (SMS, encryption settings, kill/revive, VFO, areas, MCU firmware update) | Re-implement or drop |

Rough effort for parity with *module + OEM baseline*: several weeks. A **radio-engine spike** (1–2 days) settles the only real unknown, the MCU init sequence: a bare test app that, with the OEM app disabled, opens the UART through a root bridge, runs the boot handshake, programs one analog channel, receives audio through `PrizeTinyService` and keys PTT.

## 4. Recommendation

1. Keep shipping on the module for now (it works and the user base is one phone).
2. If/when going standalone: do the radio-engine spike first, as a separate app (`DMRRadioEngine`) built from the module's protocol code; keep the module as the reference implementation while the engine is validated on air.
3. Design the engine as a library with a socket/AIDL surface so the UI can be replaced independently, and so the existing companion (captions) keeps working.

## 5. Raw evidence

```
pm path com.pri.prizeinterphone → /system/priv-app/PriInterPhone/PriInterPhone.apk
dumpsys package: userId=1000, sharedUser=android.uid.system, flags=[SYSTEM …], PRIVILEGED
ls -lZ /dev/ttyS0 → crw-rw-rw- system system u:object_r:ttyS_device:s0
ps -AZ → u:r:system_app:s0 com.pri.prizeinterphone ; u:r:audioserver:s0 tinyserver
service list → tinyservice: [android.os.ITinyService] ; plat_service_contexts: tinyservice u:object_r:audioserver_service:s0
magiskpolicy --print-rules | grep ttyS_device → allow {atcid,factory,meta_tst,system_app,system_server} ttyS_device chr_file {…}
Probe (untrusted_app): UART open EACCES + avc denied; getService(tinyservice) OK; after HiddenApiBypass:
  openRecvPcm()=true closeRecvPcm() openWritePcm()=true getFrameSize()=2048 closeWritePcm()
  ITinyService.openSerialPort(57600,0)=-2 ; startRecvPcm()=0 ; stopRecvPcm()
tinyserver log on openWritePcm: initWritePcm, device:8 card:0, channels:2 rate:8000 bits:16 period 256x2, setMixSend, I2S1_CH1 DL8_CH1
services.jar classes2.dex PhoneWindowManager.interceptKeyBeforeQueueing: new Intent("com.interphone.ptt.down"); sendBroadcastAsUser(intent, user)
apksigner: PriInterPhone.apk and framework-res.apk both SHA-1 ef770abe9a0698e6ae8491406f974870a6e41c57 (CN=koobee, O=Prize) — not the AOSP test key
```
