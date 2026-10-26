#!/usr/bin/env bash
# =============================================================================
# pi-sendpage.sh  --  runs ON the WPSD / Pi-Star hotspot (not the bench host)
# =============================================================================
# Sends ONE local POCSAG page straight through MMDVMHost -> MMDVM modem -> RF,
# with NO DAPNET network. Deterministic bench source for the DMR/mode replay
# harness: the bench host triggers it over SSH (see capsrc.sh) while the HackRF
# captures the transmitted signal.
#
#   ./pi-sendpage.sh <ric> <message>          # alphanumeric page (default)
#   ./pi-sendpage.sh -t bcd <ric> <digits>    # numeric / BCD page
#   ./pi-sendpage.sh -t a1  <ric>             # Alert1 (tone only, no text)
#   ./pi-sendpage.sh -t a2  <ric> <message>   # Alert2
#
# The page command grammar is CONFIRMED from g4klx/MMDVMHost RemoteControl.cpp:
#   page <ric> <message> | page_bcd <ric> <bcd> | page_a1 <ric> | page_a2 <ric> <msg>
#
# Transport is auto-detected (override with the env vars shown):
#   1) RemoteCommand binary present  -> UDP to the [Remote Control] Port
#                                       (legacy MMDVMHost / Pi-Star builds)
#   2) else an MQTT build            -> mosquitto_pub to the command topic
#                                       (current upstream MMDVMHost)
# Overrides:  RC_BIN  RC_PORT  MMDVM_INI  MQTT_HOST  MQTT_PORT  MQTT_CMD_TOPIC
#
# NOTE: confirm two things on the real box the first time -- the transport your
# WPSD build uses, and (MQTT only) the exact command topic. Everything else the
# script discovers from the MMDVM config.
# =============================================================================
set -euo pipefail

ptype="alnum"
if [ "${1:-}" = "-t" ]; then ptype="${2:-alnum}"; shift 2; fi
ric="${1:-}"; shift || true
msg="${*:-}"

[ -n "$ric" ] || { echo "usage: $0 [-t bcd|a1|a2] <ric> [message]" >&2; exit 2; }
case "$ptype" in
  alnum) cmd="page"      ; [ -n "$msg" ] || { echo "alphanumeric page needs a message" >&2; exit 2; } ;;
  bcd)   cmd="page_bcd"  ; [ -n "$msg" ] || { echo "bcd page needs digits" >&2; exit 2; } ;;
  a1)    cmd="page_a1"   ; msg="" ;;
  a2)    cmd="page_a2"   ; [ -n "$msg" ] || { echo "alert2 page needs a message" >&2; exit 2; } ;;
  *)     echo "unknown -t type: $ptype (use alnum|bcd|a1|a2)" >&2; exit 2 ;;
esac

# --- locate the MMDVM config -------------------------------------------------
find_ini(){
  [ -n "${MMDVM_INI:-}" ] && { echo "$MMDVM_INI"; return; }
  for p in /etc/mmdvmhost /etc/MMDVM.ini /etc/MMDVMHost.ini \
           /opt/MMDVMHost/MMDVM.ini /var/www/dashboard/../MMDVM.ini \
           "$(ls /etc/*MMDVM*.ini 2>/dev/null | head -1)"; do
    [ -n "$p" ] && [ -f "$p" ] && { echo "$p"; return; }
  done
}
ini="$(find_ini || true)"
getval(){ # getval <Section> <Key>
  [ -n "$ini" ] || return 1
  awk -v s="[$1]" -v k="$2" '
    $0==s{f=1;next} /^\[/{f=0}
    f && $0 ~ "^"k"[ \t]*=" {sub("^"k"[ \t]*=[ \t]*","");print;exit}' "$ini"
}

# --- sanity: is POCSAG enabled? ---------------------------------------------
if [ -n "$ini" ]; then
  if [ "$(getval POCSAG Enable || echo '')" != "1" ]; then
    echo "WARN: [POCSAG] Enable != 1 in $ini -- the page may not transmit." >&2
  fi
else
  echo "WARN: MMDVM .ini not found; set MMDVM_INI=/path/to/MMDVM.ini to let me check config." >&2
fi

echo "page: type=$ptype ric=$ric msg='${msg}'  (ini=${ini:-unknown})"

# --- transport 1: RemoteCommand (UDP) ---------------------------------------
RC_BIN="${RC_BIN:-$(command -v RemoteCommand || true)}"
if [ -n "$RC_BIN" ]; then
  RC_PORT="${RC_PORT:-$(getval 'Remote Control' Port 2>/dev/null || true)}"
  RC_PORT="${RC_PORT:-7642}"   # long-standing Pi-Star default
  echo "via RemoteCommand UDP port $RC_PORT"
  if [ -n "$msg" ]; then "$RC_BIN" "$RC_PORT" "$cmd" "$ric" "$msg"
  else                   "$RC_BIN" "$RC_PORT" "$cmd" "$ric"; fi
  echo "sent."; exit 0
fi

# --- transport 2: MQTT -------------------------------------------------------
if command -v mosquitto_pub >/dev/null 2>&1; then
  MQTT_HOST="${MQTT_HOST:-127.0.0.1}"; MQTT_PORT="${MQTT_PORT:-1883}"
  # Confirm this topic against your build (MMDVMHost subscribes to its command
  # topic; responses are published to ".../response").
  MQTT_CMD_TOPIC="${MQTT_CMD_TOPIC:-MMDVM/command}"
  payload="$cmd $ric"; [ -n "$msg" ] && payload="$payload $msg"
  echo "via MQTT $MQTT_HOST:$MQTT_PORT topic '$MQTT_CMD_TOPIC'"
  mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -t "$MQTT_CMD_TOPIC" -m "$payload"
  echo "sent (confirm the topic is right if nothing transmits)."; exit 0
fi

echo "ERROR: neither RemoteCommand nor mosquitto_pub found. Install one, or set RC_BIN." >&2
exit 1
