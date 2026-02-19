#!/system/bin/sh
# Post-fs-data script for Serial Access Module
# Runs early in boot process

MODDIR=${0%/*}

# Set permissions for /dev/ttyS0 (DMR serial port)
chmod 666 /dev/ttyS0
chown system:system /dev/ttyS0

# Log the action
echo "$(date): Serial port /dev/ttyS0 permissions set to 666" >> /data/local/tmp/serial-access.log
echo "$(date): Owner set to system:system" >> /data/local/tmp/serial-access.log
