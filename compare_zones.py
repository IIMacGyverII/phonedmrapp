#!/usr/bin/env python3
"""
Compare zones between expected and actual exports to identify discrepancies
"""
import csv
import sys

def read_zones_csv(filepath):
    """Read Zones.csv and return list of zones with their channels"""
    zones = []
    with open(filepath, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            zone_name = row['Zone Name']
            channels = []
            for i in range(1, 81):
                ch_key = f'Channel{i}'
                if ch_key in row and row[ch_key].strip():
                    channels.append(row[ch_key].strip())
            zones.append({
                'name': zone_name,
                'channels': channels
            })
    return zones

def print_zone_details(zones, title):
    """Print detailed zone information"""
    print(f"\n{'='*80}")
    print(f"{title}")
    print(f"{'='*80}")
    print(f"Total zones: {len(zones)}\n")
    
    for i, zone in enumerate(zones, 1):
        print(f"Zone {i}: {zone['name']}")
        print(f"  Channels ({len(zone['channels'])}): {', '.join(zone['channels']) if zone['channels'] else '(empty)'}")
        print()

def compare_zones(zones1, zones2, label1, label2):
    """Compare two zone lists and report differences"""
    print(f"\n{'='*80}")
    print(f"COMPARISON: {label1} vs {label2}")
    print(f"{'='*80}\n")
    
    # Create lookups
    zones1_dict = {z['name']: z for z in zones1}
    zones2_dict = {z['name']: z for z in zones2}
    
    all_zone_names = set(zones1_dict.keys()) | set(zones2_dict.keys())
    
    # Check for added/removed zones
    only_in_1 = set(zones1_dict.keys()) - set(zones2_dict.keys())
    only_in_2 = set(zones2_dict.keys()) - set(zones1_dict.keys())
    in_both = set(zones1_dict.keys()) & set(zones2_dict.keys())
    
    if only_in_1:
        print(f"✗ Zones ONLY in {label1}:")
        for name in sorted(only_in_1):
            print(f"  - {name}")
        print()
    
    if only_in_2:
        print(f"✓ Zones ONLY in {label2}:")
        for name in sorted(only_in_2):
            print(f"  - {name}")
        print()
    
    # Check for modified zones
    modified = []
    for name in sorted(in_both):
        z1 = zones1_dict[name]
        z2 = zones2_dict[name]
        
        if z1['channels'] != z2['channels']:
            modified.append(name)
            print(f"⚠ Zone '{name}' has DIFFERENT channels:")
            print(f"  {label1} ({len(z1['channels'])} channels): {', '.join(z1['channels']) if z1['channels'] else '(empty)'}")
            print(f"  {label2} ({len(z2['channels'])} channels): {', '.join(z2['channels']) if z2['channels'] else '(empty)'}")
            
            # Show channel-level differences
            only_in_z1 = set(z1['channels']) - set(z2['channels'])
            only_in_z2 = set(z2['channels']) - set(z1['channels'])
            
            if only_in_z1:
                print(f"    Channels removed: {', '.join(sorted(only_in_z1))}")
            if only_in_z2:
                print(f"    Channels added: {', '.join(sorted(only_in_z2))}")
            print()
    
    if not only_in_1 and not only_in_2 and not modified:
        print("✓ Zones are IDENTICAL!")
    
    print(f"\nSummary:")
    print(f"  Zones in {label1}: {len(zones1)}")
    print(f"  Zones in {label2}: {len(zones2)}")
    print(f"  Zones only in {label1}: {len(only_in_1)}")
    print(f"  Zones only in {label2}: {len(only_in_2)}")
    print(f"  Zones in both: {len(in_both)}")
    print(f"  Zones modified: {len(modified)}")


if __name__ == '__main__':
    # Default paths
    original_path = r'C:\Users\Joshua\Downloads\My_CPS\original_export\Zones.csv'
    current_path = r'C:\Users\Joshua\Downloads\My_CPS\Zones.csv'
    
    # Allow command line override
    if len(sys.argv) >= 3:
        original_path = sys.argv[1]
        current_path = sys.argv[2]
    
    print("Zone Comparison Tool")
    print(f"File 1: {original_path}")
    print(f"File 2: {current_path}")
    
    try:
        zones_original = read_zones_csv(original_path)
        zones_current = read_zones_csv(current_path)
        
        print_zone_details(zones_original, "FILE 1: Original Export")
        print_zone_details(zones_current, "FILE 2: Current/Fixed")
        
        compare_zones(zones_original, zones_current, "Original", "Current")
        
    except FileNotFoundError as e:
        print(f"\n✗ Error: {e}")
        print("\nUsage: python compare_zones.py [file1.csv] [file2.csv]")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
