#!/usr/bin/env bash
# Capture one DMR transmission from the HackRF into the clip library.
#
#   ./dmrcap.sh <name> [seconds]
#
# Records <seconds> (default 6) of IQ at DMR_FREQ into library/<name>.iq.
# Key the source (BTECH / hotspot) for the WHOLE window so the clip holds a
# complete call: voice header -> voice superframes -> terminator. A clip that
# starts mid-call may not open the radio-under-test on replay.
#
# Example:  ./dmrcap.sh cc1_tg9_s1 6
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"

name="${1:-}"; secs="${2:-6}"
[ -n "$name" ] || die "usage: $0 <name> [seconds]"
out="$DMR_LIB/$name.iq"
[ -e "$out" ] && die "$out already exists (pick another name or delete it)."

nsamp=$(( DMR_SAMP_RATE * secs ))
echo "== DMR capture =="; dmr_banner
echo "clip : $out  (${secs}s, $nsamp samples)"
echo
echo ">>> Key the source NOW and hold it until capture ends (${secs}s)."
sleep 1

"$DMR_HACKRF" -r "$out" \
  -f "$DMR_FREQ" -s "$DMR_SAMP_RATE" -b "$DMR_BB_FILTER" \
  -l "$DMR_CAP_LNA" -g "$DMR_CAP_VGA" -a "$DMR_CAP_AMP" \
  -n "$nsamp"

sz=$(wc -c < "$out")
echo
echo "captured $sz bytes -> $out"
echo "Tip: inspect level before trusting it (clipping or near-silence = redo):"
echo "  python3 $HERE/iqpeek.py \"$out\""
