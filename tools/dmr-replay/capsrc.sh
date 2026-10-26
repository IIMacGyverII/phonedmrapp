#!/usr/bin/env bash
# Trigger a transmission on the hotspot over SSH and capture it with the local
# HackRF in one shot. Capture starts first, the source is keyed ~0.5s in, so the
# clip holds the whole call.
#
#   ./capsrc.sh <name> [secs] -- <ssh-trigger-command...>
#
# <ssh-trigger-command> is whatever, run on the Pi, causes ONE transmission and
# returns when it is done (or soon after keying). Examples are per-mode and
# depend on your WPSD backend; see README "Driving the hotspot over SSH".
#
# Config (env or edit):
#   PI_SSH   user@host of the Pi running WPSD   (required)
#   SSH_OPTS extra ssh options (default: batch mode, no prompt)
#
# Examples:
#   # POCSAG page via a local DAPNET send helper you install on the Pi:
#   PI_SSH=pi@hotspot ./capsrc.sh pocsag_dapnet_2k5 8 -- sendpage 1234567 "BENCH TEST"
#   # DMR Parrot echo (key a radio into the hotspot is manual; for network Parrot
#   # you still key a source — SSH suits POCSAG/one-shot injectors best).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"

name="${1:-}"; secs="${2:-8}"
[ -n "$name" ] || die "usage: $0 <name> [secs] -- <ssh-trigger-command...>"
shift 2 || true
[ "${1:-}" = "--" ] && shift || die "expected -- before the ssh trigger command"
[ "$#" -gt 0 ] || die "no ssh trigger command given after --"
: "${PI_SSH:?set PI_SSH=user@host of the WPSD Pi}"
: "${SSH_OPTS:=-o BatchMode=yes -o ConnectTimeout=8}"

out="$DMR_LIB/$name.iq"
[ -e "$out" ] && die "$out already exists."
nsamp=$(( DMR_SAMP_RATE * secs ))

echo "== triggered capture =="; dmr_banner
echo "clip : $out (${secs}s)"
echo "pi   : $PI_SSH"
echo "tx   : $*"
echo

# start the capture in the background, let the radio settle, then key the source.
"$DMR_HACKRF" -r "$out" \
  -f "$DMR_FREQ" -s "$DMR_SAMP_RATE" -b "$DMR_BB_FILTER" \
  -l "$DMR_CAP_LNA" -g "$DMR_CAP_VGA" -a "$DMR_CAP_AMP" \
  -n "$nsamp" &
cap=$!
sleep 0.6
echo ">>> keying source over SSH..."
# shellcheck disable=SC2029
ssh $SSH_OPTS "$PI_SSH" "$@" || echo "WARN: ssh trigger returned non-zero (did it key?)"
wait "$cap"

sz=$(wc -c < "$out")
echo "captured $sz bytes -> $out"
echo "check:  python3 $HERE/iqpeek.py \"$out\""
