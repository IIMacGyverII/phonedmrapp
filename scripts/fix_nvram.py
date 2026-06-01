#!/usr/bin/env python3
import re

file_path = '/home/joshua/phonedmrapp/app/src/main/java/com/pri/prizeinterphone/Util/Util.java'

with open(file_path, 'r') as f:
    content = f.read()

# Replace the getDMRUpdateStatusFromNvram method - find it with try-catch block
pattern = r'public static String getDMRUpdateStatusFromNvram\(\) \{.*?catch \(Exception e\) \{.*?return "1";.*?\n    \}'

new_method = '''public static String getDMRUpdateStatusFromNvram() {
        // Disabled - NvramUtils requires system framework access
        // Always return idle status for non-system apps
        Log.d(TAG, "getDMRUpdateStatusFromNvram returning idle");
        return "1";
    }'''

content = re.sub(pattern, new_method, content, flags=re.DOTALL)

# Also stub out the set method
pattern2 = r'public static boolean setDMRUpdateStatusToNvram\(String str\) \{.*?return writeUserNvramInfo;.*?\n    \}'

new_method2 = '''public static boolean setDMRUpdateStatusToNvram(String str) {
        // Disabled - NvramUtils requires system framework access
        Log.d(TAG, "setDMRUpdateStatusToNvram (stubbed)");
        return true;
    }'''

content = re.sub(pattern2, new_method2, content, flags=re.DOTALL)

with open(file_path, 'w') as f:
    f.write(content)

print('Fixed NVRAM methods!')
