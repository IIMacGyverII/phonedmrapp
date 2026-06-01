#!/usr/bin/env python3
"""
DMR Module Command Fuzzer
Discovers undocumented commands by systematically testing CMD codes
"""

import subprocess
import time
import re
from datetime import datetime

# Known documented commands from Const.java
DOCUMENTED_COMMANDS = {
    0x22: "SET_DIGITAL_INFO_CMD",
    0x23: "SET_ANALOG_INFO_CMD",
    0x24: "QUERY_INIT_STATUS_CMD",
    0x25: "QUERY_ANALOG_INFO_CMD",
    0x26: "SET_LAUNCH_INFO_CMD",
    0x27: "QUERY_INIT_STATUS_CMD",
    0x28: "SET_ENHANCE_FUNCTION_CMD",
    0x29: "SET_ENCRYPT_FUNCTION_CMD",
    0x2A: "SET_GAIN_MIC_CMD",
    0x2B: "QUERY_DIGITAL_AUDIO_RECEIVE_INFO",
    0x2C: "SEND_SMS_CMD",
    0x2D: "RECEIVE_SMS_CMD",
    0x2E: "SET_VOL_CMD",
    0x2F: "SET_LISTEN_CMD",
    0x30: "SET_SQUELCH_CMD",
    0x31: "SET_POWER_SAVE_MODE_CMD",
    0x32: "QUERY_SIGNAL_STRENGTH_CMD",
    0x33: "SET_OFFLINE_MODE_CMD",
    0x34: "QUERY_VERSION_CMD",
    0x35: "INTERRUPT_TRANSMIT_CMD",
    0x36: "MODULE_PRINT_STATUS_INFO_CMD (QUERY_DIGITAL_INFO_CMD)",
    0x37: "SET_POLITE_POLICY_CMD",
    0x38: "SET_MIX_CHECK_INFO_CMD",
    0x39: "QUERY_MIX_CHECK_INFO_CMD",
    0x3A: "SET_SMS_PROTOCOL_TYPE_CMD",
    0x3B: "SET_TOTO_CMD",
    0x3C: "SET_SPK_EN_CMD",
    0x3F: "TEST_BIT_ERROR_RATE",
    0xAA: "MODULE_INIT_CMD",
}

def adb_shell(command):
    """Execute ADB shell command"""
    full_cmd = f'adb shell "su -c \'{command}\'"'
    result = subprocess.run(full_cmd, shell=True, capture_output=True, text=True)
    return result.stdout + result.stderr

def pull_current_uart_log():
    """Pull the most recent UART log from device"""
    # Get list of UART logs
    ls_output = adb_shell("ls -t /sdcard/DMR/uart_logs/*.txt 2>/dev/null | head -1")
    latest_log = ls_output.strip()
    
    if not latest_log:
        return None
    
    # Pull the log
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    local_path = f"uart_fuzzing_{timestamp}.txt"
    subprocess.run(f'adb pull "{latest_log}" "{local_path}"', shell=True)
    
    return local_path

def parse_uart_response(log_path, cmd_code):
    """Parse UART log to find responses for a specific command"""
    if not log_path:
        return None
    
    try:
        with open(log_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Find RX packets following our TX
        cmd_hex = f"{cmd_code:02X}"
        pattern = rf"CMD: 0x{cmd_hex}.*?RW: 0.*?Body \((\d+) bytes\):\s*\nHex: ([0-9A-F\s]+)"
        
        matches = re.findall(pattern, content, re.DOTALL)
        if matches:
            return matches[-1]  # Return most recent response
        
    except Exception as e:
        print(f"Error parsing log: {e}")
    
    return None

def send_query_command(cmd_code):
    """Send a query command (RW=1, SR=1) and check for response"""
    print(f"\n[{cmd_code:02X}] Testing command 0x{cmd_code:02X}...", end=" ")
    
    # Known documented command?
    if cmd_code in DOCUMENTED_COMMANDS:
        print(f"DOCUMENTED: {DOCUMENTED_COMMANDS[cmd_code]}")
        return
    
    # Send command via SerialManager injection
    # This would require implementing command injection in MainHook.java
    # For now, document the approach
    
    print("Querying...")
    
    # Wait for UART logging to capture response
    time.sleep(0.2)
    
    # Pull and analyze log
    log_path = pull_current_uart_log()
    response = parse_uart_response(log_path, cmd_code)
    
    if response:
        byte_count, hex_data = response
        print(f"✓ RESPONSE: {byte_count} bytes - {hex_data[:60]}")
        return {
            'cmd': cmd_code,
            'bytes': byte_count,
            'data': hex_data
        }
    else:
        print("No response")
        return None

def analyze_command_space():
    """Analyze all possible command codes"""
    print("=" * 70)
    print("DMR MODULE COMMAND SPACE ANALYSIS")
    print("=" * 70)
    
    print("\n1. DOCUMENTED COMMANDS:")
    for cmd, name in sorted(DOCUMENTED_COMMANDS.items()):
        print(f"   0x{cmd:02X} ({cmd:3d}) - {name}")
    
    print("\n2. GAPS IN COMMAND SPACE (Potential Undocumented Commands):")
    gaps = []
    for i in range(0, 256):
        if i not in DOCUMENTED_COMMANDS:
            gaps.append(i)
    
    # Group consecutive gaps
    gap_ranges = []
    start = gaps[0]
    prev = start
    
    for cmd in gaps[1:]:
        if cmd != prev + 1:
            gap_ranges.append((start, prev))
            start = cmd
        prev = cmd
    gap_ranges.append((start, prev))
    
    for start, end in gap_ranges:
        if start == end:
            print(f"   0x{start:02X} ({start:3d})")
        else:
            print(f"   0x{start:02X}-0x{end:02X} ({start:3d}-{end:3d}) - {end-start+1} commands")
    
    print("\n3. INTERESTING GAPS TO FUZZ:")
    interesting = [
        (0x00, 0x21, "Before documented range"),
        (0x3D, 0x3E, "Between standard and test commands"),
        (0x40, 0xA9, "Large gap before MODULE_INIT"),
        (0xAB, 0xFF, "After MODULE_INIT"),
    ]
    
    for start, end, description in interesting:
        print(f"   0x{start:02X}-0x{end:02X}: {description}")
    
    return gaps

def generate_fuzzing_script():
    """Generate Python script for systematic fuzzing"""
    script = '''#!/usr/bin/env python3
"""
Execute this script to fuzz all undocumented commands.
Requires UART logging enabled in the app.
"""

import subprocess
import time
from datetime import datetime

# Commands to test (full range excluding documented)
UNDOCUMENTED = [
'''
    
    gaps = []
    for i in range(0, 256):
        if i not in DOCUMENTED_COMMANDS:
            gaps.append(f"    0x{i:02X},  # {i}")
    
    script += "\n".join(gaps)
    script += '''
]

def send_uart_packet(cmd_code):
    """Send raw UART packet via SerialManager hook"""
    # This requires implementing a debug hook in MainHook.java
    # that listens for broadcast intents with packet parameters
    
    intent_cmd = (
        f'adb shell "am broadcast -a com.dmrmod.SEND_DEBUG_PACKET '
        f'--ei CMD {cmd_code} --ei RW 1 --ei SR 1"'
    )
    
    subprocess.run(intent_cmd, shell=True)
    time.sleep(0.3)  # Wait for response

def main():
    print("Starting command fuzzing...")
    print(f"Testing {len(UNDOCUMENTED)} undocumented command codes")
    
    results = {'responses': [], 'no_response': []}
    
    for i, cmd in enumerate(UNDOCUMENTED):
        print(f"[{i+1}/{len(UNDOCUMENTED)}] Testing 0x{cmd:02X}...")
        
        # Send packet
        send_uart_packet(cmd)
        
        # Check UART log for response
        # (Implementation depends on log parsing)
        
        time.sleep(0.1)
    
    print(f"\\nCompleted! Found {len(results['responses'])} responsive commands")

if __name__ == "__main__":
    main()
'''
    
    with open("command_fuzzer_executor.py", "w") as f:
        f.write(script)
    
    print("\n✓ Generated: command_fuzzer_executor.py")

def main():
    print("\nDMR Module Command Discovery Tool\n")
    
    # Analyze command space
    gaps = analyze_command_space()
    
    print(f"\n{'=' * 70}")
    print(f"SUMMARY: {len(gaps)} undocumented command codes to test")
    print(f"{'=' * 70}")
    
    # Generate fuzzing script
    generate_fuzzing_script()
    
    print("\n" + "=" * 70)
    print("NEXT STEPS:")
    print("=" * 70)
    print("""
1. Add debug broadcast receiver to MainHook.java:
   - Listen for com.dmrmod.SEND_DEBUG_PACKET intent
   - Extract CMD, RW, SR from intent extras
   - Construct and send Packet via SerialManager.send()

2. Enable UART logging in the app

3. Run command_fuzzer_executor.py to test all undocumented commands

4. Analyze uart_fuzzing_*.txt logs for responses

5. Document any commands that return non-error responses

Commands of particular interest:
- 0x00-0x21: System/initialization commands
- 0x3D-0x3E: Near test command range
- 0x61-0xA9: Largest gap - likely diagnostic/debug commands
""")

if __name__ == "__main__":
    main()
