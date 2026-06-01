#!/usr/bin/env python3
"""
Quick fix for Channels.csv - adds missing _id to header
"""
import sys

def fix_csv_header(input_file, output_file=None):
    """Add _id to the beginning of the header line"""
    if output_file is None:
        output_file = input_file.replace('.csv', '_fixed.csv')
    
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    if not lines:
        print("Error: Empty file")
        return False
    
    # Fix header - add _id at the beginning
    header = lines[0].strip()
    if not header.startswith('_id'):
        header = '_id,' + header
        print(f"✓ Added _id to header")
    else:
        print("✓ Header already has _id")
    
    # Write fixed file
    with open(output_file, 'w', encoding='utf-8', newline='') as f:
        f.write(header + '\n')
        for line in lines[1:]:
            f.write(line)
    
    print(f"✓ Fixed CSV written to: {output_file}")
    print(f"  Total rows: {len(lines)}")
    return True

if __name__ == '__main__':
    input_file = r'C:\Users\Joshua\Downloads\My_CPS\Channels.csv'
    
    if len(sys.argv) >= 2:
        input_file = sys.argv[1]
    
    output_file = None
    if len(sys.argv) >= 3:
        output_file = sys.argv[2]
    
    print(f"Fixing: {input_file}")
    fix_csv_header(input_file, output_file)
