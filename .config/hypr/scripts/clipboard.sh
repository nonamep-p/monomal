#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/configs/clipboard.rasi"

cliphist list | rofi -dmenu -theme "$ROFI_THEME" -p "CLIPBOARD" | cliphist decode | wl-copy
