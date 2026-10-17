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
