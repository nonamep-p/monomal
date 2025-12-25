#!/usr/bin/env bash

# Paths
WALL_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper_thumbs"
ROFI_THEME="$HOME/.config/rofi/configs/wallpaper.rasi"

# Create cache dir
mkdir -p "$CACHE_DIR"

# Check if imagemagick is installed
if ! command -v convert &> /dev/null;
    then
    notify-send "Error" "ImageMagick not found. Please install it."
    exit 1
fi

# Generate list for Rofi
# Format: Name\0icon\x1fPath
list_wallpapers() {
    for img in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
        [ -e "$img" ] || continue
        
        filename=$(basename "$img")
        thumb="$CACHE_DIR/$filename"
        
        # Generate thumbnail if missing
        if [ ! -f "$thumb" ]; then
            convert "$img" -thumbnail 600x400^ -gravity center -extent 600x400 "$thumb"
        fi
        
        echo -en "$filename\0icon\x1f$thumb\n"
    done
}

# Run Rofi
SELECTED=$(list_wallpapers | rofi -dmenu -theme "$ROFI_THEME" -p "WALLPAPERS" -i)

# Apply Wallpaper
if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALL_DIR/$SELECTED"
    
    # Apply using Waypaper
    waypaper --wallpaper "$FULL_PATH"
    
    # Notify
    notify-send "Wallpaper Changed" "$SELECTED"
    
    # Sync Theme Color
    python ~/.config/hypr/scripts/wall_color_sync.py &
fi