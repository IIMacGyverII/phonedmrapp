#!/usr/bin/env bash
# Shared config for the DMR record/replay bench harness.
# Source this from the other scripts; override any value in your shell before running.
#
#   export DMR_FREQ=438000000        # before calling the scripts, or edit below
#
# Every value here can also be set as an environment variable of the same name.

set -euo pipefail

# --- RF ---------------------------------------------------------------------
# Center frequency, Hz. Must be one BOTH the source (hotspot/BTECH) AND the
# radio-under-test (DMR module: 400-480 MHz UHF) can use. 438 MHz is inside the
# ham 70cm band the AURSINC hotspot is tuned for and inside the module's range.
# The repo's standing bench default is 467.625 MHz; use that only if the hotspot
# actually tunes there (many ADF7021 boards top out ~475 but are happiest 430-440).
: "${DMR_FREQ:=438000000}"

# Sample rate, Hz. DMR occupies ~12.5 kHz; 2 Msps is plenty and matches past
# benches. Record and replay MUST use the same rate (and the same HackRF, so the
# crystal error cancels). ~2 bytes/sample * rate * seconds = file size.
: "${DMR_SAMP_RATE:=2000000}"

# Baseband filter, Hz (hackrf -b). 0 lets hackrf pick from the sample rate.
: "${DMR_BB_FILTER:=0}"

# Capture gains (hackrf -l LNA 0-40 step 8, -g VGA 0-62 step 2). The source is
# close in a cage, so modest gain avoids clipping the recording.
: "${DMR_CAP_LNA:=24}"
: "${DMR_CAP_VGA:=20}"
: "${DMR_CAP_AMP:=0}"          # -a: RX amp, 0 off / 1 on. Off for a close source.

# Replay TX gain (hackrf -x TXVGA 0-47). Start LOW in a cage and raise until the
# radio-under-test opens cleanly; too hot overloads its front end and it won't
# decode. Past SSTV benches needed ~47 over a longer path; a cage bench is closer.
: "${DMR_TX_VGA:=20}"
: "${DMR_TX_AMP:=0}"           # -a: TX amp (+~11 dB). Leave off unless too weak.

# --- paths ------------------------------------------------------------------
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${DMR_LIB:=$HERE/library}"     # captured .iq clips live here
: "${DMR_LOG:=$HERE/logs}"        # run logs land here
: "${DMR_HACKRF:=hackrf_transfer}"
: "${ADB:=adb}"                   # optional; used only to drop logcat markers

mkdir -p "$DMR_LIB" "$DMR_LOG"

die(){ echo "ERROR: $*" >&2; exit 1; }
have(){ command -v "$1" >/dev/null 2>&1; }

have "$DMR_HACKRF" || die "$DMR_HACKRF not on PATH (install hackrf tools, or set DMR_HACKRF)."

# Human-readable banner the other scripts print once.
dmr_banner(){
  echo "freq=$DMR_FREQ Hz  rate=$DMR_SAMP_RATE  lib=$DMR_LIB"
}
