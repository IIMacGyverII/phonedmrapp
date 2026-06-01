#!/usr/bin/env python3
import zipfile
import os

# Create systemizer module ZIP
print("Creating MacGyver DMR Systemizer module...")

with zipfile.ZipFile('MacGyverDMR-Systemizer.zip', 'w', zipfile.ZIP_DEFLATED) as zf:
    # Change to module directory
    os.chdir('magisk-systemizer')
    
    # Add all files with Unix paths
    for root, dirs, files in os.walk('.'):
        for file in files:
            file_path = os.path.join(root, file)
            # Convert to Unix path
            archive_name = file_path.replace('\\', '/').lstrip('./')
            print(f"  Adding: {archive_name}")
            zf.write(file_path, archive_name)
    
    os.chdir('..')

print("\n✓ MacGyverDMR-Systemizer.zip created successfully!")
print(f"  Size: {os.path.getsize('MacGyverDMR-Systemizer.zip'):,} bytes")
