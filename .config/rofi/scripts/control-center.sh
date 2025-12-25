#!/usr/bin/env bash

# Rofi Control Center (Dashboard Replacement)
# Based on the requested "tools" dropdown

theme="$HOME/.config/rofi/configs/launcher.rasi"

# Get current status info using wpctl (PipeWire standard)
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)"%"}')
[ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -i MUTED)" ] && vol="Muted"

mic=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)"%"}')
[ "$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -i MUTED)" ] && mic="Muted"

wifi=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
[ -z "$wifi" ] && wifi="Disconnected"

bt=$(bluetoothctl show | grep "Powered: yes" >/dev/null && echo "On" || echo "Off")

# Options
option_wifi="󰖩  Wi-Fi: $wifi"
option_bt="  Bluetooth: $bt"
option_vol="󰕾  Volume: $vol"
option_mic="󰍬  Microphone: $mic"
option_night="󰌁  Screen Shader"
option_power="  Power Menu"

options="$option_wifi\n$option_bt\n$option_vol\n$option_mic\n$option_night\n$option_power"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Quick Settings" -theme "$theme")

case $chosen in
    $option_wifi)
        ~/.config/rofi/scripts/wifi.sh
        ;;
    $option_bt)
        blueman-manager &
        ;;
    $option_vol)
        pavucontrol &
        ;;
    $option_mic)
        pavucontrol -t 4 &
        ;;
    $option_night)
        ~/.config/rofi/applets/hyprshade.sh "rofi"
        ;;
    $option_power)
        wlogout &
        ;;
esac