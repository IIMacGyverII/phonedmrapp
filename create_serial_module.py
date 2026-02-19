import zipfile
import os

# Create ZIP for Magisk module
zf = zipfile.ZipFile('serial-access-module.zip', 'w', zipfile.ZIP_DEFLATED)

os.chdir('magisk-serial-module')

for root, dirs, files in os.walk('.'):
    for file in files:
        file_path = os.path.join(root, file)
        # Convert to Unix path (forward slashes, remove leading ./)
        archive_name = file_path.replace('\\', '/').lstrip('./')
        print(f'Adding: {archive_name}')
        zf.write(file_path, archive_name)

zf.close()
os.chdir('..')

print('\n✓ serial-access-module.zip created with proper Unix paths')

# Verify contents
import zipfile
with zipfile.ZipFile('serial-access-module.zip', 'r') as zf:
    print('\nModule contents:')
    for info in zf.filelist:
        print(f'  {info.filename}')
