#!/bin/bash
cd /d/Documents/code/personal/phonedmrapp || exit 1
until git pull -q && grep -q '^STATUS: \(BENCH\|OWNER\)' radio_firmware/HANDOFF.md; do
  sleep 180
done
grep '^STATUS' radio_firmware/HANDOFF.md
