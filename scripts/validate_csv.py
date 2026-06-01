#!/usr/bin/env python3
"""
Validate all fields in the exported Channels.csv match the expected Android format
"""
import csv
import sys

# Expected column headers (37 total WITH _id for Android export, 36 WITHOUT for PC CPS export)
EXPECTED_HEADERS_ANDROID = [
    "_id",                 # 0 (Android only)
    "Channel Number",      # 1
    "Channel Name",        # 2
    "Channel Type",        # 3
    "Rx Frequency",        # 4
    "Tx Frequency",        # 5
    "Bandwidth (kHz)",     # 6
    "Colour Code",         # 7
    "Timeslot",            # 8
    "Contact",             # 9
    "TG List",             # 10
    "DMR ID",              # 11
    "TS1_TA_Tx",           # 12
    "TS2_TA_Tx ID",        # 13
    "RX Tone",             # 14
    "TX Tone",             # 15
    "Squelch",             # 16
    "Power",               # 17
    "Rx Only",             # 18
    "Zone Skip",           # 19
    "All Skip",            # 20
    "TOT",                 # 21
    "VOX",                 # 22
    "No Beep",             # 23
    "No Eco",              # 24
    "APRS",                # 25
    "Latitude",            # 26
    "Longitude",           # 27
    "Use Location",        # 28
    "Encrypt Switch",      # 29
    "Encrypt Key",         # 30
    "Relay",               # 31
    "Interrupt",           # 32
    "Active",              # 33
    "Outbound Slot",       # 34
    "Channel Mode",        # 35
    "Contact Type",        # 36
]

EXPECTED_HEADERS_CPS = [
    "Channel Number",      # 0
    "Channel Name",        # 1
    "Channel Type",        # 2
    "Rx Frequency",        # 3
    "Tx Frequency",        # 4
    "Bandwidth (kHz)",     # 5
    "Colour Code",         # 6
    "Timeslot",            # 7
    "Contact",             # 8
    "TG List",             # 9
    "DMR ID",              # 10
    "TS1_TA_Tx",           # 11
    "TS2_TA_Tx ID",        # 12
    "RX Tone",             # 13
    "TX Tone",             # 14
    "Squelch",             # 15
    "Power",               # 16
    "Rx Only",             # 17
    "Zone Skip",           # 18
    "All Skip",            # 19
    "TOT",                 # 20
    "VOX",                 # 21
    "No Beep",             # 22
    "No Eco",              # 23
    "APRS",                # 24
    "Latitude",            # 25
    "Longitude",           # 26
    "Use Location",        # 27
    "Encrypt Switch",      # 28
    "Encrypt Key",         # 29
    "Relay",               # 30
    "Interrupt",           # 31
    "Active",              # 32
    "Outbound Slot",       # 33
    "Channel Mode",        # 34
    "Contact Type",        # 35
]

def validate_channels_csv(filepath):
    """Validate Channels.csv structure and field values"""
    print(f"Validating: {filepath}\n")
    print("="*80)
    
    errors = []
    warnings = []
    
    with open(filepath, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        headers = next(reader)
        
        # Auto-detect format
        has_id = headers[0] == "_id"
        expected_headers = EXPECTED_HEADERS_ANDROID if has_id else EXPECTED_HEADERS_CPS
        format_name = "Android (with _id)" if has_id else "PC CPS (without _id)"
        
        # Check header count
        print(f"✓ Found {len(headers)} columns")
        print(f"✓ Detected format: {format_name}")
        
        if len(headers) != len(expected_headers):
            errors.append(f"Expected {len(expected_headers)} columns, found {len(headers)}")
            print(f"✗ COLUMN COUNT MISMATCH!")
        else:
            print(f"✓ Column count correct ({len(headers)} columns)")
        
        # Check each header
        print("\nHeader Validation:")
        for i, (expected, actual) in enumerate(zip(expected_headers, headers)):
            if expected != actual:
                errors.append(f"Column {i}: Expected '{expected}', found '{actual}'")
                print(f"  ✗ Column {i}: Expected '{expected}', found '{actual}'")
            else:
                print(f"  ✓ Column {i}: {actual}")
        
        # Show extra columns if any
        if len(headers) > len(expected_headers):
            print("\n⚠ EXTRA COLUMNS:")
            for i in range(len(expected_headers), len(headers)):
                print(f"  Column {i}: {headers[i]}")
                warnings.append(f"Extra column {i}: {headers[i]}")
        
        # Missing columns
        if len(headers) < len(expected_headers):
            print("\n✗ MISSING COLUMNS:")
            for i in range(len(headers), len(expected_headers)):
                print(f"  Column {i}: {expected_headers[i]}")
                errors.append(f"Missing column {i}: {expected_headers[i]}")
        
        # Calculate column offsets based on format
        col_offset = 1 if has_id else 0
        
        # Sample field validation
        print("\n" + "="*80)
        print("Sample Data Validation (first 3 rows):")
        print("="*80)
        
        for row_num, row in enumerate(reader, 1):
            if row_num > 3:
                break
            
            channel_name_col = 1 + col_offset
            print(f"\nRow {row_num}: {row[channel_name_col] if len(row) > channel_name_col else '(no name)'}")
            
            # Check critical fields
            if len(row) >= len(expected_headers):
                channel_type = row[2 + col_offset] if len(row) > 2 + col_offset else ""
                timeslot = row[7 + col_offset] if len(row) > 7 + col_offset else ""
                encrypt_switch = row[28 + col_offset] if len(row) > 28 + col_offset else ""
                encrypt_key = row[29 + col_offset] if len(row) > 29 + col_offset else ""
                
                print(f"  Channel Type: {channel_type}")
                print(f"  Timeslot: {timeslot}")
                print(f"  Encrypt Switch: {encrypt_switch}")
                print(f"  Encrypt Key: '{encrypt_key}'")
                
                # Validate Digital channel timeslot
                if channel_type == "Digital" and timeslot not in ["1", "2"]:
                    warnings.append(f"Row {row_num}: Digital channel has invalid Timeslot='{timeslot}' (should be 1 or 2)")
                    print(f"  ⚠ Invalid Timeslot for Digital channel")
                
                # Validate encryption fields
                if encrypt_switch == "1" and not encrypt_key:
                    warnings.append(f"Row {row_num}: Encrypt Switch enabled but Encrypt Key is empty")
                    print(f"  ⚠ Encryption enabled but no key")
                
                # Check column count
                if len(row) != len(headers):
                    errors.append(f"Row {row_num}: Expected {len(headers)} columns, found {len(row)}")
                    print(f"  ✗ Column count mismatch: {len(row)} vs {len(headers)}")
            else:
                errors.append(f"Row {row_num}: Insufficient columns ({len(row)})")
                print(f"  ✗ Insufficient columns: {len(row)}")
    
    # Final summary
    print("\n" + "="*80)
    print("VALIDATION SUMMARY")
    print("="*80)
    
    if errors:
        print(f"\n✗ ERRORS ({len(errors)}):")
        for error in errors:
            print(f"  - {error}")
    else:
        print("\n✓ No critical errors found")
    
    if warnings:
        print(f"\n⚠ WARNINGS ({len(warnings)}):")
        for warning in warnings:
            print(f"  - {warning}")
    else:
        print("\n✓ No warnings")
    
    if not errors and not warnings:
        print("\n✓✓✓ Perfect! CSV is valid and ready for import ✓✓✓")
        return 0
    elif errors:
        print("\n✗✗✗ CSV has critical errors that must be fixed ✗✗✗")
        return 1
    else:
        print("\n⚠ CSV has warnings but may still work")
        return 0


if __name__ == '__main__':
    filepath = r'C:\Users\Joshua\Downloads\My_CPS\Channels.csv'
    
    if len(sys.argv) >= 2:
        filepath = sys.argv[1]
    
    try:
        sys.exit(validate_channels_csv(filepath))
    except FileNotFoundError:
        print(f"\n✗ Error: File not found: {filepath}")
        print("\nUsage: python validate_csv.py [Channels.csv]")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
