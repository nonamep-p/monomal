#!/bin/bash

# Rofi Volume Control
theme=~/.config/rofi/configs/keybinds.rasi

# Options
option_mute="󰖁 Mute"
option_25="󰕾 25%"
option_50="󰕾 50%"
option_75="󰕾 75%"
option_100="󰕾 100%"
option_150="󰕾 150% (Boost)"
option_settings="󰍰 Settings"

# Rofi Menu
options="$option_mute\n$option_25\n$option_50\n$option_75\n$option_100\n$option_150\n$option_settings"
choice=$(echo -e "$options" | rofi -dmenu -i -p "Volume" -theme "${theme}")

case $choice in
    $option_mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    $option_25)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 25%
        ;;
    $option_50)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 50%
        ;;
    $option_75)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 75%
        ;;
    $option_100)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 100%
        ;;
    $option_150)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 150%
        ;;
    $option_settings)
        pavucontrol &
        ;;
esac
