#!/bin/bash
# Bench helper (ch. 19 §14). Loads an image into the radio module through the stock app updater
# (ch. 07 §6) while SignalDeck hands the radio back, then takes it back and prints the 0x34 answer.
# DEV=<adb serial> selects the phone (default Wi-Fi 192.168.1.125:5555). Never pass an image with a
# functional change unless the plan step says so; images go to flash and persist (ch. 19 §13-§14).
# fwload.sh <image> : hand back -> push DMRDEBUG.bin -> stock updater -> delete -> take over -> print 0x34 answer
set -e
export MSYS_NO_PATHCONV=1
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"; D="-s ${DEV:-192.168.1.125:5555}"
S=$(dirname "$0")
"$A" $D shell "am start -n com.macdmr.radio/.MainActivity" >/dev/null 2>&1; sleep 2
"$S/ui.sh" tap Device >/dev/null; sleep 2
"$S/ui.sh" tap "Hand back"; sleep 3
"$S/ui.sh" dump | grep -q "The stock app owns the radio" || { echo "hand back failed"; exit 1; }
"$A" $D push "$1" /sdcard/DMR/DMRDEBUG.bin >/dev/null
echo "pushed md5 $("$A" $D shell md5sum /sdcard/DMR/DMRDEBUG.bin | cut -d' ' -f1)"
"$A" $D shell "am force-stop com.pri.prizeinterphone; logcat -c; am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity" >/dev/null
R=""
for i in $(seq 1 60); do R=$("$A" $D shell "logcat -d -s YModemManager:*" | grep -E "onSuccess|onFail|rror" | head -1); [ -n "$R" ] && break; sleep 5; done
"$A" $D shell "rm -f /sdcard/DMR/DMRDEBUG.bin"
echo "updater: ${R:-TIMEOUT}"; echo "$R" | grep -q onSuccess || exit 1
"$A" $D shell "logcat -c; am start -n com.macdmr.radio/.MainActivity" >/dev/null 2>&1; sleep 3
"$S/ui.sh" tap "Take over" >/dev/null
for i in $(seq 1 20); do V=$("$A" $D shell "logcat -d" | grep "RadioService: module D" | tail -1); [ -n "$V" ] && break; sleep 2; done
echo "0x34: $V"
