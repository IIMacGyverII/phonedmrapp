#!/bin/bash
# Rebuild the cage-bench hotspot from the PC after a reflash or a WPSD config-page save (README: "Rebuild after a
# reflash"). Copies the relay and tools, builds c2tool, installs the relay as a service, applies hotspot_setup.py,
# then checks the result. Password login only: give the hotspot login password in HOTSPOT_PASS (never in the repo).
#   HOTSPOT_PASS=... ./deploy.sh [host]          # host defaults to 192.168.1.194
#   HOTSPOT_PASS=... ./deploy.sh [host] check    # only the checks
set -e
H=${1:-192.168.1.194}; U=pi-star; HERE=$(cd "$(dirname "$0")" && pwd)
SD=${SIGNALDECK:-/d/Documents/code/personal/SignalDeck}     # for the Codec 2 sources (LGPL-2.1, built on the hotspot)
[ -n "$HOTSPOT_PASS" ] || { echo "set HOTSPOT_PASS"; exit 1; }
AP=$(mktemp); printf '#!/bin/sh\necho "%s"\n' "$HOTSPOT_PASS" > "$AP"; chmod +x "$AP"; trap 'rm -f "$AP"' EXIT
export SSH_ASKPASS="$AP" SSH_ASKPASS_REQUIRE=force DISPLAY=:0
O="-o PubkeyAuthentication=no -o LogLevel=ERROR -o StrictHostKeyChecking=accept-new"
r() { ssh $O $U@$H "$@"; }
check() {
  r 'echo "== services"; systemctl is-active mmdvmhost dapnetgateway m17relay dmrgateway m17gateway 2>&1 | paste -sd" "
     echo "== UDP (62031/17010 = relay, 62032/17011 = MMDVMHost)"; ss -uanp 2>/dev/null | grep -E ":(6203[12]|1701[01])\b" | sed "s/  */ /g" | cut -c1-110
     echo "== MMDVMHost"; L=/var/log/pi-star/MMDVM-$(date -u +%Y-%m-%d).log; grep -E "MMDVMHost-|description:|Color Code|M17|POCSAG" $L | tail -6 | cut -c1-140
     echo "== relay"; tail -3 ~/claude-bench/relay.log 2>/dev/null'
}
if [ "$2" = check ]; then check; exit 0; fi
echo "== copy"
r 'mkdir -p ~/claude-bench/c2'
scp $O "$HERE/m17relay.py" "$HERE/hotspot_setup.py" $U@$H:claude-bench/ >/dev/null
scp $O -r "$HERE/c2tool.c" "$SD/app/src/main/cpp/codec2" $U@$H:claude-bench/c2/ >/dev/null
echo "== build c2tool"
r 'cd ~/claude-bench/c2 && gcc -O2 -w -Icodec2 -o c2tool c2tool.c codec2/*.c -lm && ls -l c2tool | cut -c1-60'
echo "== relay service"
r "cat > /tmp/m17relay.service" <<'UNIT'
[Unit]
Description=Cage-bench relay (M17/DMR/POCSAG stand-in for the gateways)
After=network.target
Before=mmdvmhost.service dapnetgateway.service
[Service]
User=pi-star
WorkingDirectory=/home/pi-star/claude-bench
ExecStart=/usr/bin/python3 -u /home/pi-star/claude-bench/m17relay.py
StandardOutput=append:/home/pi-star/claude-bench/relay.log
StandardError=append:/home/pi-star/claude-bench/relay.log
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
UNIT
r "BENCH_PW=\"\$(cat)\"; printf '%s\n' \"\$BENCH_PW\" | sudo -S -p '' sh -c 'rpi-rw 2>/dev/null; cp /tmp/m17relay.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable m17relay >/dev/null 2>&1 && systemctl restart m17relay' && printf '%s\n' \"\$BENCH_PW\" | sudo -S -p '' python3 ~/claude-bench/hotspot_setup.py" <<< "$HOTSPOT_PASS"
sleep 12
check
