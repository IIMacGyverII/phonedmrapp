#!/usr/bin/env bash
# Replay a whole library (or a named subset) against the radio-under-test and
# write a timestamped run log you can line up with the radio's response.
#
#   ./dmrtest.sh [fw_tag] [name ...]
#
#   fw_tag    free-text label for the firmware currently loaded (e.g. STOCK,
#             PROMISC1). Goes in the log filename + each row so stock-vs-patched
#             A/B runs stay separate. Default: UNKNOWN.
#   name ...  clip names to run (without .iq). Omit = every clip in the library.
#
# For each clip it: drops an optional logcat marker on the phone (so SignalDeck /
# the stock app's caller-info log can be correlated), replays the clip once, waits
# DMR_STEP_GAP (default 4s) for the radio to open/settle, and logs the row. Score
# pass/fail from the radio side (did it un-mute? what 0x2B caller-info / Last
# Heard?) and note it against the timestamp.
#
# Set ADB_MARK=1 and ADB=/path/to/adb to enable the phone-side markers.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"

fw="${1:-UNKNOWN}"; shift || true
gap="${DMR_STEP_GAP:-4}"

if [ "$#" -gt 0 ]; then
  clips=("$@")
else
  clips=()
  for f in "$DMR_LIB"/*.iq; do
    b="$(basename "$f" .iq)"; [ "$b" = ".primer" ] && continue
    clips+=("$b")
  done
fi
[ "${#clips[@]}" -gt 0 ] || die "no clips to run (capture some with dmrcap.sh)."

log="$DMR_LOG/run_$(date '+%Y%m%d_%H%M%S')_${fw}.csv"
echo "ts,fw,clip,note" > "$log"
echo "== DMR library test  fw=$fw  clips=${#clips[@]} =="; dmr_banner
echo "log: $log"
echo

mark(){ [ "${ADB_MARK:-0}" = "1" ] && "$ADB" shell log -t DMRTEST "$1" >/dev/null 2>&1 || true; }

for name in "${clips[@]}"; do
  clip="$DMR_LIB/$name.iq"
  [ -f "$clip" ] || { echo "skip (missing): $name"; continue; }
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  mark "replay fw=$fw clip=$name"
  echo "[$ts] $name"
  "$HERE/dmrplay.sh" "$name" 1 0 >/dev/null
  echo "$ts,$fw,$name," >> "$log"
  sleep "$gap"
done

echo
echo "Done. Fill the 'note' column in $log with the radio's response per clip,"
echo "then diff the STOCK log against the patched-firmware log on matching clips."
