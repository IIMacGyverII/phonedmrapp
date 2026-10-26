#!/usr/bin/env bash
# Replay one captured DMR clip through the HackRF, into the radio-under-test.
#
#   ./dmrplay.sh <name> [repeats] [gap_seconds]
#
# Replays library/<name>.iq once (default), or <repeats> times with <gap_seconds>
# between (default gap 2s). Each replay is a SEPARATE one-shot transfer.
#
# IMPORTANT (learned the hard way on this bench):
#   * NEVER use hackrf_transfer -R (repeat) in the background: a killed -R hangs
#     the USB driver and TX goes silently dead until a power-cycle. We loop in the
#     shell with fresh one-shot transfers instead.
#   * The FIRST -t after the radio has been idle is often silent, so we send a
#     short zero-IQ primer first and ignore it.
#   * This is HackRF TX: do it on the bench antenna / attenuator INSIDE the cage,
#     never the outdoor antenna.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"

name="${1:-}"; reps="${2:-1}"; gap="${3:-2}"
[ -n "$name" ] || die "usage: $0 <name> [repeats] [gap_seconds]"
clip="$DMR_LIB/$name.iq"
[ -f "$clip" ] || die "no such clip: $clip  (list: ls $DMR_LIB)"

# --- build / reuse a 0.2s zero-IQ primer (int8 interleaved I,Q = all zero) ----
primer="$DMR_LIB/.primer.iq"
if [ ! -f "$primer" ]; then
  pn=$(( DMR_SAMP_RATE / 5 * 2 ))     # 0.2s * 2 bytes/sample
  head -c "$pn" /dev/zero > "$primer"
fi

tx(){  # tx <file>
  "$DMR_HACKRF" -t "$1" \
    -f "$DMR_FREQ" -s "$DMR_SAMP_RATE" -b "$DMR_BB_FILTER" \
    -x "$DMR_TX_VGA" -a "$DMR_TX_AMP"
}

echo "== DMR replay =="; dmr_banner
echo "clip : $clip   reps=$reps gap=${gap}s  tx_vga=$DMR_TX_VGA amp=$DMR_TX_AMP"
echo "(priming...)"; tx "$primer" >/dev/null 2>&1 || true

i=1
while [ "$i" -le "$reps" ]; do
  ts="$(date '+%H:%M:%S')"
  echo "[$ts] replay $name  ($i/$reps)"
  tx "$clip"
  i=$(( i + 1 ))
  [ "$i" -le "$reps" ] && sleep "$gap"
done
echo "done."
