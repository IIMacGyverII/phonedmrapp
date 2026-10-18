# Request support for your DMR phone — what to send us

DMRModHooks today only runs on the Ulefone Armor 26 Ultra, because it hooks that phone's stock
walkie-talkie app. We are working on a standalone app that talks to the radio module directly, with a
small "device profile" per phone. To write the profile for **your** phone we need a few facts that only
your phone can tell us. Nothing below changes anything on the phone; it only reads information.

**You need:** a computer with `adb` (Android platform-tools), USB debugging enabled on the phone
(Settings → About phone → tap *Build number* 7× → Developer options → *USB debugging*), and a USB cable.
Root is **not** required for steps 1–3. If the phone is rooted, step 4 adds a little more.

## 1. The stock walkie-talkie app (APK)

Find its package name, then pull the APK:

```sh
adb shell pm list packages -f | grep -iE "chat|phone|dmr|talk|radio|walkie|intercom|ptt"
```

Pick the line that is the walkie-talkie app (on the Blackview Xplore 1 it is `com.chamsion.quickchat`;
on the Ulefone it is `com.pri.prizeinterphone`), then:

```sh
adb pull "$(adb shell pm path <package.name> | sed 's/^package://' | tr -d '\r')" ./walkie-talkie.apk
```

Zip it and attach it to the GitHub issue.

## 2. One-shot information dump (copy, paste, run)

Replace `<package.name>` in the first line, paste the whole block into a terminal, then attach the
file `dmr-device-info.txt` it creates to the issue. Every command is read-only.

```sh
PKG=<package.name>
OUT=dmr-device-info.txt; : > $OUT
s(){ echo; echo "===== $*"; } >> $OUT
run(){ s "$*"; adb shell "$@" >> $OUT 2>&1; }
run getprop ro.product.manufacturer; run getprop ro.product.model; run getprop ro.product.device
run getprop ro.build.version.release; run getprop ro.build.version.sdk; run getprop ro.build.display.id
run getprop ro.hardware; run getprop ro.board.platform; run getenforce
run "pm path $PKG"
run "dumpsys package $PKG | grep -E 'versionName|codePath|userId=|sharedUser|flags=|privateFlags='"
run "ps -AZ | grep -iE '$PKG|tiny|dmr|intercom|walkie' | grep -v grep"
run "ls -lZ /dev/ttyS* /dev/ttyMT* /dev/ttyHS* /dev/ttyUSB* 2>/dev/null"
run "cat /proc/tty/drivers"
run "ls -lZ /sys/devices/platform/ | grep -iE 'dmr|intercom|walkie|ptt|uart|radio|sy88|interphone'"
run "for d in /sys/devices/platform/*dmr* /sys/devices/platform/*intercom* /sys/devices/platform/*walkie* /sys/devices/platform/*ptt*; do [ -d \"\$d\" ] && echo \"--- \$d\" && ls -lZ \"\$d\"; done 2>/dev/null"
run "for f in /sys/devices/platform/*dmr*/* /sys/devices/platform/*intercom*/*; do [ -f \"\$f\" ] && printf '%s = ' \"\$f\" && (cat \"\$f\" 2>&1 | head -c 80; echo); done 2>/dev/null"
run "service list | grep -iE 'tiny|dmr|intercom|walkie|audio'"
run "ls /system/framework /system_ext/framework /vendor/framework 2>/dev/null | grep -iE 'tiny|dmr|intercom|prize|walkie'"
run "ls /system/etc/init /vendor/etc/init 2>/dev/null | grep -iE 'tiny|dmr|intercom|walkie|serial'"
run "ls /system/lib64 /system/lib /vendor/lib64 2>/dev/null | grep -iE 'serial|uart|dmr|intercom|walkie'"
run "dumpsys package | grep -iE 'ptt|intercom|walkie' | sort -u | head -40"
echo; echo "===== done"; echo "Now press and release the PTT button once, wait 3 s, then press Enter"; read _
s "logcat after PTT press"; adb logcat -d -t 400 | grep -iE "ptt|intercom|walkie|dmr|serial|tty" >> $OUT 2>&1
echo "Wrote $OUT"
```

(Windows PowerShell users: run each `adb shell …` line by hand and paste the output into one text file.)

## 3. Tell us how the radio behaves

In the issue, add a few lines:

- Which bands/modes the stock app offers (analog FM, DMR digital, both), the frequency ranges you see,
  and whether it has a hardware PTT key.
- Whether audio comes out of the phone speaker or a dedicated radio speaker.
- Whether the phone is rooted (Magisk/KernelSU) and whether the bootloader can be unlocked
  (Developer options → *OEM unlocking* present?). Root will be required to run the standalone app; without it we
  can still prepare the profile.

## 4. Optional, rooted phones only

These show us the SELinux labels we will need to allow in a Magisk module. Still read-only.

```sh
adb shell su -c "ls -lZ /dev/ttyS0 /dev/ttyS1; ls -lZ /sys/devices/platform/*dmr* /sys/devices/platform/*intercom* 2>/dev/null; dmesg | grep -iE 'dmr|intercom|walkie|ptt|ttyS' | tail -40; magisk -v" > dmr-root-info.txt 2>&1
```

Attach `dmr-root-info.txt` too.

## What we do with it

From the APK we check whether your radio module speaks the same serial protocol as the Ulefone's
(frame `68 … 10`, same command bytes). From the dump we learn the serial device, how voice audio reaches the
phone (vendor service or a second UART), which sysfs nodes power the module and key the PTT, and which SELinux
labels a Magisk rule must cover. That is exactly one device profile. Your APK and dump are only analysed; we
never redistribute them.
