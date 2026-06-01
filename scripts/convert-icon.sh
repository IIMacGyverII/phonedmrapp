#!/bin/bash
# Convert icon.jpg to Android app icons in various densities

SOURCE="/mnt/c/Users/Joshua/Documents/phonedmrapp/icon.jpg"
DEST_DIR="/mnt/c/Users/Joshua/Documents/phonedmrapp/app/src/main/res"

echo "Converting icon.jpg to Android app icons..."

# Create drawablefolders if they don't exist
mkdir -p "$DEST_DIR/drawable-mdpi"
mkdir -p "$DEST_DIR/drawable-hdpi"
mkdir -p "$DEST_DIR/drawable-xhdpi"
mkdir -p "$DEST_DIR/drawable-xxhdpi"
mkdir -p "$DEST_DIR/drawable-xxxhdpi"

# Convert to square and resize for each density
# The icon will be center-cropped to square

echo "Creating mdpi icon (48x48)..."
convert "$SOURCE" -resize 48x48^ -gravity center -extent 48x48 "$DEST_DIR/drawable-mdpi/interphone_app_icon.png"

echo "Creating hdpi icon (72x72)..."
convert "$SOURCE" -resize 72x72^ -gravity center -extent 72x72 "$DEST_DIR/drawable-hdpi/interphone_app_icon.png"

echo "Creating xhdpi icon (96x96)..."
convert "$SOURCE" -resize 96x96^ -gravity center -extent 96x96 "$DEST_DIR/drawable-xhdpi/interphone_app_icon.png"

echo "Creating xxhdpi icon (144x144)..."
convert "$SOURCE" -resize 144x144^ -gravity center -extent 144x144 "$DEST_DIR/drawable-xxhdpi/interphone_app_icon.png"

echo "Creating xxxhdpi icon (192x192)..."
convert "$SOURCE" -resize 192x192^ -gravity center -extent 192x192 "$DEST_DIR/drawable-xxxhdpi/interphone_app_icon.png"

echo "Done! App icons created in all densities."
ls -lh "$DEST_DIR"/drawable-*/interphone_app_icon.png
