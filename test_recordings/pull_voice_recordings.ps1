# Pull voice recordings from phone for analysis
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "Checking for voice recordings..."
& $adb shell "ls -R /sdcard/Download/DMR/Audio/"

Write-Host "`nPulling all voice recordings..."
& $adb pull /sdcard/Download/DMR/Audio/ C:\Users\Joshua\Documents\android\phonedmrapp\test_recordings\voice\

Write-Host "`nDone! Check test_recordings/voice/ folder"
