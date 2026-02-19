#!/system/bin/sh
# Service script for Serial Access Module  
# Runs after boot is complete

MODDIR=${0%/*}

# Wait for device to fully boot
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

# Re-apply permissions to ensure they stick
chmod 666 /dev/ttyS0
chown system:system /dev/ttyS0

# Grant MacGyver DMR app access to system group (if installed)
APP_UID=$(dumpsys package com.macgyver.dmr 2>/dev/null | grep userId= | head -1 | sed 's/.*userId=\([0-9]*\).*/\1/')

if [ -n "$APP_UID" ]; then
    echo "$(date): MacGyver DMR app UID: $APP_UID" >> /data/local/tmp/serial-access.log
    # App exists, permissions should work
fi

echo "$(date): Service script completed" >> /data/local/tmp/serial-access.log
