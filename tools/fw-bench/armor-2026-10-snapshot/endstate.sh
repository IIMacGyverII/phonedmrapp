#!/bin/bash
export MSYS_NO_PATHCONV=1
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
D="-s 5006AF1020002922"
"$A" $D shell "su --mount-master --context u:r:magisk:s0 -c 'grep -E \"zoneLast_4|name=\\\"zone\\\"|vfoName|vfoHz\" /data/data/com.macdmr.radio/shared_prefs/radio.xml'"
