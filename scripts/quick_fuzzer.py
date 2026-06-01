#!/usr/bin/env python3
"""
Quick fuzzer - Test interesting command ranges
"""
import subprocess
import time

# Most interesting undocumented commands to test
PRIORITY_COMMANDS = [
    # System/init range (0x00-0x21)
    (0x00, "NULL/NOOP"),
    (0x01, "Possible init/reset"),
    (0x10, "Common system command"),
    (0x20, "Right before documented range"),
    (0x21, "Right before documented range"),
    
    # Gap commands near documented
    (0x3D, "Between standard and test"),
    (0x3E, "Between standard and test"),
    
    # Diagnostic range (0x40-0x60)
    (0x40, "Start of large gap"),
    (0x50, "Mid gap"),
    (0x60, "Near test command"),
    
    # High diagnostic range
    (0x70, "High diagnostic"),
    (0x80, "High diagnostic"),
    (0x90, "High diagnostic"),
    (0xA0, "Near MODULE_INIT"),
    (0xA9, "Right before MODULE_INIT"),
    
    # Post-INIT range
    (0xAB, "Right after MODULE_INIT"),
    (0xB0, "Post-init"),
    (0xC0, "Post-init"),
    (0xF0, "High commands"),
    (0xFF, "Max command"),
]

def send_command(cmd, desc):
    """Send command and return success"""
    print(f"Testing 0x{cmd:02X} ({cmd:3d}) - {desc}...", end=" ", flush=True)
    
    result = subprocess.run([
        'adb', 'shell',
        f'am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD {cmd} --ei RW 1 --ei SR 1'
    ], capture_output=True, text=True, timeout=5)
    
    if 'Broadcast completed' in result.stdout:
        print("✓")
        return True
    else:
        print("✗ FAILED")
        return False

def main():
    print("=" * 70)
    print("QUICK COMMAND FUZZING - Priority Targets")
    print("=" * 70)
    print(f"\nTesting {len(PRIORITY_COMMANDS)} high-priority commands\n")
    
    input("Press Enter to start (Ctrl+C to abort)...")
    
    success_count = 0
    for cmd, desc in PRIORITY_COMMANDS:
        if send_command(cmd, desc):
            success_count += 1
        time.sleep(0.2)
    
    print("\n" + "=" * 70)
    print(f"Complete! {success_count}/{len(PRIORITY_COMMANDS)} sent successfully")
    print("=" * 70)
    print("\nNext: Pull UART logs and analyze responses")
    print("  adb pull /sdcard/DMR/uart_logs/")

if __name__ == "__main__":
    main()
