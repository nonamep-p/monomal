#!/bin/bash
# CopyQ Toggle Script
# Toggles the main CopyQ window. 
# Hyprland window rules handle the positioning to make it look like a dropdown.

if ! pgrep -x "copyq" > /dev/null; then
    copyq &
    sleep 0.5
fi

copyq toggle