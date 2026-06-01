#!/usr/bin/env python3
"""
Automated quick fuzzer - runs without user interaction
"""
import subprocess
import time
import sys

# Priority commands to test
PRIORITY_COMMANDS = [
    (0x00, "NULL/NOOP"), (0x01, "Init/reset"), (0x10, "System"),
    (0x20, "Pre-doc"), (0x21, "Pre-doc"),
    (0x3D, "Gap-1"), (0x3E, "Gap-2"),
    (0x40, "Diag start"), (0x50, "Diag mid"), (0x60, "Diag end"),
    (0x70, "High diag"), (0x80, "High diag"), (0x90, "High diag"),
    (0xA0, "Pre-INIT"), (0xA9, "Pre-INIT"),
    (0xAB, "Post-INIT"), (0xB0, "Post-INIT"),
    (0xC0, "High"), (0xF0, "Max-1"), (0xFF, "Max"),
]

def send_command(cmd):
    """Send command, return True if successful"""
    import os
    try:
        # Windows adb path
        adb_path = os.path.join(os.environ.get('LOCALAPPDATA', ''), 'Android', 'Sdk', 'platform-tools', 'adb.exe')
        if not os.path.exists(adb_path):
            adb_path = 'adb'  # Fallback to PATH
        
        result = subprocess.run([
            adb_path, 'shell',
            f'am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD {cmd} --ei RW 1 --ei SR 1'
        ], capture_output=True, text=True, timeout=5)
        return 'Broadcast completed' in result.stdout
    except:
        return False

def main():
    print("=" * 70)
    print("AUTO FUZZER - Testing priority commands")
    print("=" * 70)
    print(f"Commands: {len(PRIORITY_COMMANDS)}\n")
    
    results = []
    for i, (cmd, desc) in enumerate(PRIORITY_COMMANDS):
        pct = int((i / len(PRIORITY_COMMANDS)) * 100)
        print(f"[{pct:3d}%] 0x{cmd:02X} {desc:12s}", end=" ", flush=True)
        
        if send_command(cmd):
            print("✓")
            results.append(cmd)
        else:
            print("✗")
        
        time.sleep(0.15)
    
    print(f"\n{'=' * 70}")
    print(f"✓ {len(results)}/{len(PRIORITY_COMMANDS)} sent")
    print(f"{'=' * 70}")
    print("\nPull UART logs: adb pull /sdcard/DMR/uart_logs/\n")

if __name__ == "__main__":
    main()
