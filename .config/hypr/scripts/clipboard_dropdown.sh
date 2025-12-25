#!/bin/bash
# Clipboard Dropdown Menu using Cliphist & Rofi
# Auto-closes on selection.

# 1. Check if Rofi is already running (toggle behavior)
if pgrep -x "rofi" > /dev/null; then
    pkill -x rofi
    exit 0
fi

# 2. Launch Rofi with Cliphist
# - dmenu mode to read stdin
# - decode selection
# - copy to clipboard
cliphist list | rofi -dmenu \
    -theme ~/.config/rofi/configs/clipboard_dropdown.rasi \
    -p "Copy" \
| cliphist decode | wl-copy

# Note: Rofi automatically closes after selection in -dmenu mode.
