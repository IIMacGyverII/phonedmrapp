#!/usr/bin/env python3
"""
Update latitude/longitude in Channels.csv with random Colorado coordinates.
Colorado bounds: Latitude 37.0-41.0°N, Longitude -109.0 to -102.0°W
"""

import csv
import random

def random_Colorado_coords():
    """Generate random coordinates within Colorado"""
    lat = round(random.uniform(37.0, 41.0), 6)
    lon = round(random.uniform(-109.0, -102.0), 6)
    return lat, lon

# Read CSV
with open('backup_latest_channels.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    header = next(reader)
    rows = list(reader)

print(f"Total channels: {len(rows)}")

# Update first 10 channels with Colorado coordinates
channels_to_update = min(10, len(rows))
print(f"Updating channels 1-{channels_to_update} with Colorado coordinates...")

for i in range(channels_to_update):
    lat, lon = random_Colorado_coords()
    rows[i][25] = str(lat)   # Latitude column
    rows[i][26] = str(lon)   # Longitude column
    rows[i][27] = "No"       # Use Location
    print(f"  Channel {rows[i][0]}: {rows[i][1]} -> {lat}, {lon}")

# Write updated CSV
with open('backup_latest_channels.csv', 'w', encoding='utf-8', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(rows)

print(f"\n✓ Updated {channels_to_update} channels with Colorado coordinates")
print("Ready to upload to phone for import")
