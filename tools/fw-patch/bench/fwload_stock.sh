#!/bin/bash
# Bench helper (ch. 19 §14). Loads an image into the radio module through the stock app updater
# (ch. 07 §6), then returns the radio to SignalDeck and prints the 0x34 answer.
# DEV=<adb serial> selects the phone (default Wi-Fi 192.168.1.125:5555). Never pass an image with a
# functional change unless the plan step says so; images go to flash and persist (ch. 19 §13-§14).
#
# The old path tapped Hand back in the SignalDeck UI. uiautomator dump fails while the screen is
# asleep ("could not get idle state") and a stale dump then looks like a successful hand-back, so
# the stock activity never starts. This path does not use the UI: force-stop releases the UART,
# pm enable brings the stock app back, and the next SignalDeck launch takes the radio again.
# fwload.sh <image> : release -> push DMRDEBUG.bin -> stock updater -> delete -> take over -> print 0x34
set -e
export MSYS_NO_PATHCONV=1
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"; D="-s ${DEV:-192.168.1.125:5555}"
"$A" $D shell "input keyevent 224" >/dev/null 2>&1 || true
"$A" $D shell "am force-stop com.macdmr.radio"
sleep 1
"$A" $D shell "pm enable com.pri.prizeinterphone" >/dev/null
"$A" $D shell "dumpsys package com.pri.prizeinterphone" | grep -q "enabled=1" || { echo "stock app stayed disabled"; exit 1; }
"$A" $D push "$1" /sdcard/DMR/DMRDEBUG.bin >/dev/null
echo "pushed md5 $("$A" $D shell md5sum /sdcard/DMR/DMRDEBUG.bin | cut -d' ' -f1)"
"$A" $D shell "am force-stop com.pri.prizeinterphone; logcat -c; am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity" >"$TEMP/fwload_start.txt" 2>&1 || true
if grep -q "does not exist" "$TEMP/fwload_start.txt"; then echo "stock activity did not start"; cat "$TEMP/fwload_start.txt"; "$A" $D shell "rm -f /sdcard/DMR/DMRDEBUG.bin"; exit 1; fi
R=""
for i in $(seq 1 100); do R=$("$A" $D shell "logcat -d -s YModemManager:D" | grep -E "onSuccess|onFail|rror" | head -1 || true); [ -n "$R" ] && break; sleep 2; done
"$A" $D shell "rm -f /sdcard/DMR/DMRDEBUG.bin"
echo "updater: ${R:-TIMEOUT}"; echo "$R" | grep -q onSuccess || exit 1
sleep 2
"$A" $D shell "am force-stop com.pri.prizeinterphone; logcat -c; am start -n com.macdmr.radio/.MainActivity" >/dev/null 2>&1 || true
# After a key the first takeover often sees 0x29050000, restarts the module, and
# the process can die before the banner. A later activity start brings it up.
# An empty line is not a version; the caller checks the token.
poll_version() {
  local n="$1" i
  V=""
  for i in $(seq 1 "$n"); do
    V=$("$A" $D shell "logcat -d" | grep "RadioService: module D" | tail -1 || true)
    [ -n "$V" ] && return 0
    sleep 2
  done
  return 1
}
if ! poll_version 25; then
  echo "no 0x34 yet; starting SignalDeck again"
  "$A" $D shell "am start -n com.macdmr.radio/.MainActivity" >/dev/null 2>&1 || true
  poll_version 40 || true
fi
echo "0x34: $V"
