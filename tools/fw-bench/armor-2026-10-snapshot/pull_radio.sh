#!/bin/bash
export MSYS_NO_PATHCONV=1
export DEV=5006AF1020002922
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
"$A" -s "$DEV" shell "su --mount-master --context u:r:magisk:s0 -c 'cp /data/data/com.macdmr.radio/databases/radio.db /sdcard/Download/radio_fw1718_check.db && chmod 644 /sdcard/Download/radio_fw1718_check.db'"
"$A" -s "$DEV" pull /sdcard/Download/radio_fw1718_check.db "C:/Users/Joshua/AppData/Local/Temp/fw1718/radio_fw1718_check.db"
"$A" -s "$DEV" shell rm /sdcard/Download/radio_fw1718_check.db
