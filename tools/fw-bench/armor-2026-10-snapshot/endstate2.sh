#!/bin/bash
export MSYS_NO_PATHCONV=1
export DEV=5006AF1020002922
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
Q="SELECT datetime(ts/1000,'unixepoch','localtime'), channel, kind, text FROM history WHERE text LIKE '%ISS%' OR text LIKE '%Could not resume%' OR text LIKE '%Tracking%' ORDER BY ts DESC LIMIT 25;"
"$A" -s "$DEV" shell "su --mount-master --context u:r:magisk:s0 -c 'sqlite3 /data/data/com.macdmr.radio/databases/radio.db \"$Q\"'"
echo "=== active channel ==="
Q2="SELECT number, name, rxFreq, active FROM channels WHERE active=1 OR number=36;"
"$A" -s "$DEV" shell "su --mount-master --context u:r:magisk:s0 -c 'sqlite3 /data/data/com.macdmr.radio/databases/radio.db \"$Q2\"'"
