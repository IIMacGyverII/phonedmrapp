# Standalone app — follow-up: the UART blocker is overcome (2026-10-17, later the same day)

Companion to `standalone-app-evaluation.md`. The user authorised live SELinux policy changes on the
(rooted, Magisk 30.6) phone to see whether an ordinary app can reach the MCU UART. It can.

## 1. UART access from an unprivileged app — proven

Two live policy statements (applied with `magiskpolicy --live --apply <file>`; they vanish on reboot):

```
allow untrusted_app ttyS_device chr_file { open read write ioctl getattr lock }
typeattribute ttyS_device mlstrustedobject
```

| Step | Result |
|---|---|
| allow rule only | read-open **OK**, write-open **EACCES** (`avc: denied { write } … tclass=chr_file`). Cause: Android's MLS constraint — the app runs at `s0:c201,c256,…`, the node at `s0`; writes need equal levels unless the object type is `mlstrustedobject`. |
| + `typeattribute … mlstrustedobject` | read-open **OK**, write-open **OK**, no denials |
| frame exchange, OEM app alive (shared port) | the probe wrote `68 32 01 01 95 BB 00 01 01 10` (RSSI query, checksum per `PacketEncoder`); the probe's own read saw nothing, but the **OEM's reader logged the MCU's answer** `cmd=32 rw=0 sr=0 len=1 body=[42]` (−99 dBm) at the moment of the third attempt, with no 0x32 transmitted by the OEM/module (live S-meter off). So the app's bytes reach the MCU and the MCU answers; the OEM's always-pending `read()` simply consumes the reply first. The port must be exclusive. |
| frame exchange, OEM app disabled | **no answer** — because disabling the OEM app powers the radio module down (next section), not because of the UART. |

Quoting gotcha: passing the rule inline through `adb shell su -c '…'` splits it into words (magiskpolicy reports
"Syntax error in: allow"); write the rules to a file and use `--apply`. Note also that in this Magisk setup
`su -c` file operations are denied under `u:r:shell:s0` even though `id` reports the `magisk` context; the
app path with the policy rules above does not have that problem.

## 2. The radio module has a power GPIO the app must drive

`Util/ReadFileUtils.java` (OEM) controls the module through sysfs nodes of the kernel driver `sy8801_dev` /
platform device `dmr009`:

| Node | Meaning | OEM use |
|---|---|---|
| `/sys/devices/platform/dmr009/pwd` | module power ("pwd :1" = on) | `pullUpPwdFoot()` 1 s after `InterPhoneHomeActivity.onCreate`; `pullDownPwdFoot()` in `onDestroy`, `InterPhoneService:82`, `DmrManager:1073` |
| `…/ptt` | PTT line ("ptt :1") | firmware-update sequencing (`setDmrUpdateCondition`) |
| `…/pd`, `…/debug` | power-down / debug | `readFile()` of `debug` |

All four are `-rw-rw-rw- root root u:object_r:sysfs_prizefactory:s0`. Reading them from the app is denied
(`sysfs_prizefactory`), and so is reading them from the root shell. After `pm disable-user` the OEM pulls
`pwd` to 0 (confirmed: the next `pullUpPwdFoot()` on re-enable rewrote the node at 15:57), so the MCU is
simply off while the OEM app is disabled. The cold-start sequence the app then has to run is documented in
`docs/deep-dive/03-…` §7a: `pwd=1` → module sends `0xBF`/`0xAA` → `VersionMessage 0x34` → set channel
(`0x22`/`0x23`) → interrupt/mic → TOT → ready.

Two more policy lines are therefore required for a standalone app (**not yet applied/tested** — the assistant's
sandbox refused to apply them; one command for the user, see §4):

```
allow untrusted_app sysfs_prizefactory file { open read write getattr }
typeattribute sysfs_prizefactory mlstrustedobject
```

## 3. Updated verdict

* **Standalone app with root: feasible, and simpler than a su-bridge.** A Magisk module whose `sepolicy.rule`
  holds the four lines above makes the UART and the module GPIOs directly accessible to the app at every boot;
  no helper daemon, no JNI for the port (plain `FileInputStream`/`FileOutputStream` work once the tty is raw at
  57600, which it already is — `stty -F /dev/ttyS0 -a`: `speed 57600 … -icanon -echo -opost min=1 time=0`;
  a one-time `stty` from the module's boot script would make that independent of the OEM).
* Audio was already proven open (`PrizeTinyService`, see the first evaluation).
* The OEM app must be disabled (`pm disable-user --user 0 com.pri.prizeinterphone`) while the standalone app
  runs; re-enable with `pm enable`.

## 4. Next step for the user (one command, reverts on reboot)

```
adb shell "printf 'allow untrusted_app sysfs_prizefactory file { open read write getattr }\ntypeattribute sysfs_prizefactory mlstrustedobject\n' > /data/local/tmp/sysfs.rule"
adb shell su -c "magiskpolicy --live --apply /data/local/tmp/sysfs.rule"
```

Then the full cold-start test (OEM off → app powers the module → boot announcement → RSSI query → OEM back):

```
adb shell pm disable-user --user 0 com.pri.prizeinterphone
adb shell am broadcast -a com.macdmr.transcription.PROBE -n com.macdmr.transcription/.ProbeReceiver --ez uart true
adb logcat -d -s StandaloneProbe
adb shell pm enable com.pri.prizeinterphone
adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity
```

The probe (`DMRTranscriptionService` → `ProbeReceiver`) reads `pwd`, writes 1 if it is 0, logs up to 8 s of
boot bytes, then sends the RSSI query and logs the reply. Expected: `boot bytes … 68 BF …`/`68 AA …`, then
`UART reply cmd=0x32 … body[0]=<raw>`.

For a permanent setup, make a Magisk module (`module.prop` + `sepolicy.rule` with the four rules, zipped at
the root, installed from the Magisk app). The LSPosed module does not need any of this.

## 5. Result of the cold-start test (2026-10-17, user-authorised, all four rules live)

Sequence: `pm disable-user` the OEM app → probe (`--ez uart true --ez powercycle true`) → `pm enable` + relaunch.

```
sysfs pwd = pwd :1 / ptt :1 / pd :1 / debug = 0          (readable + writable from the plain app now)
power-cycle: pwd now = pwd :0                            (module off)
pwd=1 (power up), waiting for the boot announcement
boot bytes (19 in 8006 ms): 00 00 BF AA BB FA B3 F5 CA BC BB AF CD EA B3 C9 0D 0A 00
UART tx: 68 32 01 01 95 BB 00 01 01 10
UART rx (10 bytes, 13 ms): 68 32 00 00 6F BC 00 01 28 10   -> RSSI raw 40 = -100 dBm
```

* The boot announcement is **not an OEM-framed packet**: two zero bytes, `BF AA`, then the GBK string
  `BB FA B3 F5 CA BC BB AF CD EA B3 C9` = "机初始化完成" ("module initialisation complete") and CR LF.
  `InitMessageHandler` keys on the `BF`/`AA` bytes. A standalone app's reader must tolerate this non-framed
  line before the first `68 … 10` frame.
* After the announcement the MCU answers queries immediately, **without** the OEM's version/set-channel/TOT
  handshake (it keeps whatever channel it last had). The handshake is still needed to program a channel, but
  the link itself needs nothing beyond `pwd=1`.
* A second run without the power-cycle (module left on by the OEM) answered in 10 ms (`body[0]=43`, −98.5 dBm).
* The OEM app re-enabled and relaunched normally afterwards (`updateModuleInit` logged) — the experiment is
  non-destructive.

**Conclusion: every hardware dependency of a standalone app is now proven from an ordinary app process on
this phone — UART (both directions, MCU replies), module power GPIO (off/on + boot capture), voice audio
(`PrizeTinyService`), hardware PTT broadcasts. Only root (Magisk, four `sepolicy.rule` lines) is required.**

## 6. Radio-engine spike — first run (2026-10-17, `DMRStandalone/`)

A separate app (`com.macdmr.radio`, no LSPosed, plain file I/O on the UART and sysfs, `PrizeTinyService` for audio,
`DeviceProfile` for the per-phone bits) drove the radio with the OEM app disabled:

```
UART /dev/ttyS0 open · module already powered (pwd :1)
TX 0x34 → RX "DMR003.UV4T.V022"                       (version query answered)
TX 0x23 [162.500 MHz, band 1, power 0, sq 0, pwrSave 2, vol 8, monitor 2, relay 2] → sr=0  (channel accepted)
RX 0x36 [01] RECEIVE_START (rw=2 push), acked          (NOAA carrier detected by the MCU)
TX 0x32 → RSSI raw 58 = −91 dBm
openRecvPcm=true → audio frames 50/100/…/300, 2048 B each (64 ms), peak ≈ 12–14k   (voice PCM flowing to our AudioTrack)
```

Gotchas found: the first channel set was **NAKed (sr=1)** because enum bytes are **1 = on / 2 = off**: the OEM
sends `pwrSave=2`, `monitor=2` (its `AnalogMessage` defaults; `DmrManager` never overrides them) and a `0` is
rejected, like `relay=0`. MCU→app pushes (0x36) arrive with `rw=2`. Everything else behaved exactly as the
deep-dive documents. Remaining for the engine: TX audio path (`openWritePcm`/`writeFrame` while 0x26 launch=1),
digital channel set, the boot handshake after a power-cycle (version → channel → interrupt/mic → TOT), and
the hardware-PTT broadcast receiver — then the feature code can move over.

### 6.1 Second run — TX, digital, cold start, hardware PTT (same day)

| Test | Result |
|---|---|
| **TX**: `0x26 launch=1` + `openWritePcm`/`writeFrame` of a 1 kHz tone for 3 s on 467.625 | MCU pushed SEND_START; **HackRF measured 78.5 dB above the noise floor** at 467.625 (same level as the module's proven TX). |
| **PTT release** | `launch=0` is **NAKed** and the transmitter stays keyed (it only stopped at the next channel write); **`launch=2` is the release** — ack sr=0, SEND_STOP immediately. Enum 1/2 again. |
| **Cold start**: pwd 0→1, then the OEM's handshake | Banner `BF AA` + "开机初始化完成" ("power-on initialisation complete"), then 0x23 ok, 0x2A mic ok, 0x3B TOT ok, RECEIVE_START. The banner takes **> 3 s** after pwd=1; the engine now waits for it (`waitBooted`) before the first command — a 0x34 sent at +3 s got no reply. |
| **Hardware PTT key** | `am broadcast -a com.interphone.ptt.down/.up` → the app keyed with the phone mic, released cleanly (ACK 0x26, SEND_STOP). |
| **Digital set** `0x22` on 467.700 (ID 1447, TGs 1/9/99, cc1) | accepted (see the run log); the MCU then answered the 0x2B caller query with zeros (no call yet). |

Every hardware function a standalone app needs on the Armor 26 Ultra is now exercised from `DMRStandalone`.
Next: carry the feature code and the intercom UI over.
