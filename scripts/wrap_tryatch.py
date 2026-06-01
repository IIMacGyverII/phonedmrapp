#!/usr/bin/env python3
import re

file_path = '/home/joshua/phonedmrapp/app/src/main/java/com/pri/prizeinterphone/InterPhoneHomeActivity.java'

with open(file_path, 'r') as f:
    lines = f.readlines()

# Find the line with PCMReceiveManager.getInstance() (around line 163)
# and the section with system-dependent initialization
# Wrap from line 155 to line 173 in a try-catch

# Lines 155-173 contain the problematic code
# Add try before line 155 (DmrManager.getInstance().registerUpdateListener)
# Add catch after the closing brace of the else block

# Find line with "DmrManager.getInstance().registerUpdateListener"
start_idx = None
end_idx = None

for i, line in enumerate(lines):
    if 'DmrManager.getInstance().registerUpdateListener' in line:
        start_idx = i
    if start_idx is not None and i > start_idx and 'this.mLlInterPhoneTapView' in line:
        # Found the end - it's the line before this
        end_idx = i
        break

if start_idx is not None and end_idx is not None:
    # Insert try block
    indent = '        '
    lines[start_idx] = indent + 'try {\n' + lines[start_idx]
    
    # Add catch block at end_idx (before the mLlInterPhoneTapView line)
    catch_block = f'''{indent}}} catch (Throwable e) {{
{indent}    // System API errors - this app requires system privileges
{indent}    android.util.Log.e("InterPhoneHomeActivity", "System API not available", e);
{indent}    android.widget.Toast.makeText(this, "This modded app has limited functionality due to missing system APIs", android.widget.Toast.LENGTH_LONG).show();
{indent}}}
'''
    lines.insert(end_idx, catch_block)
    
    with open(file_path, 'w') as f:
        f.writelines(lines)
    
    print(f'Wrapped system API calls in try-catch block (lines {start_idx+1} to {end_idx+1})')
else:
    print(f'Could not find target lines. start_idx={start_idx}, end_idx={end_idx}')
