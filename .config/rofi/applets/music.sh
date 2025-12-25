#!/bin/bash

# Rofi Music Player
theme=~/.config/rofi/configs/keybinds.rasi

# Get current status
status=$(playerctl status 2>/dev/null)
if [ "$?" -ne 0 ] || [ -z "$status" ]; then
    echo "No music playing" | rofi -dmenu -p "Music" -theme "${theme}"
    exit 0
fi

# Get metadata
artist=$(playerctl metadata artist)
title=$(playerctl metadata title)
# Truncate title if too long
if [ ${#title} -gt 30 ]; then
    title="${title:0:27}..."
fi

prompt="♪ $title"

# Options
if [ "$status" == "Playing" ]; then
    play_pause="⏸ Pause"
else
    play_pause="▶ Play"
fi
next="⏭ Next"
prev="⏮ Previous"

# Rofi Menu
options="$play_pause\n$prev\n$next"
choice=$(echo -e "$options" | rofi -dmenu -i -p "$prompt" -mesg "$artist" -theme "${theme}")

case $choice in
    "$play_pause")
        playerctl play-pause
        ;;
    "$next")
        playerctl next
        ;;
    "$prev")
        playerctl previous
        ;;
esac
