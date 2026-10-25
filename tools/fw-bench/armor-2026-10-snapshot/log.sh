#!/bin/bash
export MSYS_NO_PATHCONV=1
export DEV=5006AF1020002922
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
cd /d/Documents/code/personal/phonedmrapp
"$A" -s "$DEV" shell "logcat -d -t 120 -s RadioService:I" | tail -40
echo "---- UI ----"
tools/fw-patch/bench/ui.sh dump | head -20
