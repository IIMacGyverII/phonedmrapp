#!/bin/bash
# Rebrand app as separate modded version

cd ~/phonedmrapp

echo "Changing package ID from com.pri.prizeinterphone to com.pri.prizeinterphone.modded..."
sed -i 's/applicationId "com.pri.prizeinterphone"/applicationId "com.pri.prizeinterphone.modded"/' app/build.gradle

echo "Changing app name to 'InterPhone Modded'..."
sed -i 's/<string name="app_name">InterPhone<\/string>/<string name="app_name">InterPhone Modded<\/string>/' app/src/main/res/values/strings.xml

echo "Changing version name to 2.0-modded..."
sed -i 's/versionName "2.0-rebuilt"/versionName "2.0-modded"/' app/build.gradle

echo ""
echo "=== Changes Applied ==="
echo ""
echo "Package ID:"
grep applicationId app/build.gradle

echo ""
echo "App Name:"
grep 'name="app_name"' app/src/main/res/values/strings.xml | head -1

echo ""
echo "Version:"
grep versionName app/build.gradle

echo ""
echo "Ready to rebuild!"
