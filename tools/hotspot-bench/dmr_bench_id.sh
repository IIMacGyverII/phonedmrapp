#!/bin/bash
# Set SignalDeck's DMR ID to a bench ID for DMR keys through the hotspot, and put the radio's own ID back afterwards.
# The hotspot (MMDVMHost) rejects source IDs under 5 digits, and only bench IDs go on the air.
#   dmr_bench_id.sh set [1234568]   # saves radio.xml once, sets the bench ID, restarts SignalDeck
#   dmr_bench_id.sh restore         # puts the saved radio.xml back, restarts SignalDeck
# The original ID is never printed. Env: ADB (adb path), DEV (adb serial).
A=${ADB:-/c/Users/Joshua/AppData/Local/Android/Sdk/platform-tools/adb.exe}; D="-s ${DEV:-192.168.1.125:5555}"
RP=/data/data/com.macdmr.radio/shared_prefs/radio.xml
sh() { $A $D shell "$@" </dev/null | tr -d '\r'; }
case "$1" in
  set)
    ID=${2:-1234568}
    sh "am force-stop com.macdmr.radio; su -c '[ -f $RP.bench ] || cp -p $RP $RP.bench; sed -i \"s#<int name=\\\"dmrId\\\" value=\\\"[0-9]*\\\" />#<int name=\\\"dmrId\\\" value=\\\"$ID\\\" />#\" $RP; grep -c \"dmrId\\\" value=\\\"$ID\" $RP'" | sed "s/^/bench ID $ID set (want 1): /"
    sh "input keyevent KEYCODE_WAKEUP; am start -n com.macdmr.radio/.MainActivity >/dev/null 2>&1"; echo "SignalDeck restarted; allow ~50 s before keying" ;;
  restore)
    sh "am force-stop com.macdmr.radio; su -c 'if [ -f $RP.bench ]; then cp $RP.bench $RP; chown \$(stat -c %u:%g $RP.bench) $RP; rm -f $RP.bench; fi'"
    sh "am start -n com.macdmr.radio/.MainActivity >/dev/null 2>&1"
    sh "su -c 'grep -c \"dmrId\\\" value=\\\"12345\" $RP'" | sed 's/^/bench ID left (want 0): /' ;;
  *) echo "usage: $0 set [id] | restore" ;;
esac
