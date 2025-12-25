#!/usr/bin/env bash

# Screenshot script for Monomal
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
filename="$DIR/Screenshot_${timestamp}.png"

# Select region and capture
geometry=$(slurp)
if [ -n "$geometry" ]; then
    grim -g "$geometry" "$filename"
    wl-copy < "$filename"
    notify-send "Screenshot Captured" "Saved to $filename and copied to clipboard"
fi
