#!/usr/bin/env python3
"""
Update latitude/longitude in Channels.csv with random Minnesota coordinates.
Minnesota bounds: Latitude 43.5-49.4°N, Longitude -97.2 to -89.5°W
"""

import csv
import random

def random_minnesota_coords():
    """Generate random coordinates within Minnesota"""
    lat = round(random.uniform(43.5, 49.4), 6)
    lon = round(random.uniform(-97.2, -89.5), 6)
    return lat, lon

# Read CSV
with open('backup_latest_channels.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    header = next(reader)
    rows = list(reader)

print(f"Total channels: {len(rows)}")

# Update first 10 channels with Minnesota coordinates
channels_to_update = min(10, len(rows))
print(f"Updating channels 1-{channels_to_update} with Minnesota coordinates...")

for i in range(channels_to_update):
    lat, lon = random_minnesota_coords()
    rows[i][25] = str(lat)   # Latitude column
    rows[i][26] = str(lon)   # Longitude column
    rows[i][27] = "No"       # Use Location
    print(f"  Channel {rows[i][0]}: {rows[i][1]} -> {lat}, {lon}")

# Write updated CSV
with open('backup_latest_channels.csv', 'w', encoding='utf-8', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(rows)

print(f"\n✓ Updated {channels_to_update} channels with Minnesota coordinates")
print("Ready to upload to phone for import")
