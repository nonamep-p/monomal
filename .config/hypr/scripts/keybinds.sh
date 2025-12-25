#!/usr/bin/env bash

CONF_DIR="$HOME/.config/hypr/configs"
ROFI_THEME="$HOME/.config/rofi/configs/launcher.rasi"

# Grep for bindings with descriptions (comments)
# Format expected: bind = MOD, KEY, exec, command # Description
grep -h "bind =" "$CONF_DIR/keybindings.conf" | \
    grep "#" | \
    sed 's/bind = //g' | \
    sed 's/exec, //g' | \
    awk -F '#' '{printf "% -40s  %s\n", $1, $2}' | \
    sed 's/SUPER/❖/g' | \
    sed 's/SHIFT/⇧/g' | \
    sed 's/CTRL/⌃/g' | \
    sed 's/ALT/⌥/g' | \
    rofi -dmenu -theme "$ROFI_THEME" -p "KEYBINDS" -i
