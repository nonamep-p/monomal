#!/bin/bash

# Directory for wallpapers
WALL_DIR="$HOME/Wallpapers"
# Rofi Theme
THEME="$HOME/.config/rofi/configs/wallpaper.rasi"

# Check if swww is running
if ! pgrep -x "swww-daemon" > /dev/null;
then
    swww-daemon &
    sleep 0.5
fi

# Get the list of wallpapers
mapfile -t wallpapers < <(find "$WALL_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" \) -exec basename {} \;) 

# Function to display rofi
choose_wallpaper() {
    for wall in "${wallpapers[@]}"; do
        # We use the filename as the label and also as the icon
        echo -en "$wall\0icon\x1f$WALL_DIR/$wall\n"
    done | rofi -dmenu -i -p "󰸉 Wallpapers" -theme "$THEME"
}

# Execute
selected=$(choose_wallpaper)

if [ -n "$selected" ]; then
    # Set wallpaper
    swww img "$WALL_DIR/$selected" --transition-type fade --transition-step 10 --transition-fps 60
    
    # Run sync script (from waypaper config)
    sbdots-actions on_wallpaper_change "$WALL_DIR/$selected"
    
    notify-send "Wallpaper Updated" "$selected" -i "$WALL_DIR/$selected"
fi
