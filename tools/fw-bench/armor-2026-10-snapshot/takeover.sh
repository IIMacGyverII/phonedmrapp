#!/bin/bash
export MSYS_NO_PATHCONV=1
export DEV=5006AF1020002922
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
cd /d/Documents/code/personal/phonedmrapp
"$A" -s "$DEV" shell am start -n com.macdmr.radio/.MainActivity >/dev/null
sleep 2
tools/fw-patch/bench/ui.sh tap "Take over"
sleep 8
"$A" -s "$DEV" shell "logcat -d -t 200 -s RadioService:I" | grep "module D" | tail -5
