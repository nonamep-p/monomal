#!/usr/bin/env bash

dir="$HOME/Pictures/Screenshots"
file="Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

# Ensure directory exists
if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

notify_view() {
	notify-send -u low --replace=699 "Screenshot Saved" "Saved to $dir"
}

shotnow() {
	hyprshot -m output -o "$dir" -f "$file"
	notify_view
}

shotarea() {
	hyprshot -m region -z -o "$dir" -f "$file"
	notify_view
}

shotwin() {
	hyprshot -m window -z -o "$dir" -f "$file"
	notify_view
}

shot5() {
	notify-send -t 1000 "Taking shot in: 5 seconds"
	sleep 5
	shotnow
}

shot10() {
	notify-send -t 1000 "Taking shot in: 10 seconds"
	sleep 10
	shotnow
}

# Rofi Menu
show_menu() {
	mesg="Destination: $dir"
	list_col='1'
	list_row='5'
	win_width='400px'
	theme="$HOME/.config/rofi/configs/dmenu.rasi"

	option_1="  Capture Desktop"
	option_2=" 󰩭 Capture Area"
	option_3="  Capture Window"
	option_4=" 󱎫 Capture in 5s"
	option_5=" 󱎫 Capture in 10s"

	# Rofi CMD
	rofi_cmd() {
		rofi -theme-str "window {width: $win_width;}" \
			-theme-str "listview {columns: $list_col; lines: $list_row;}" \
			-theme-str 'textbox-prompt-colon {str: " ";}' \
			-dmenu \
			-p "Screenshot Menu" \
			-mesg "$mesg" \
			-markup-rows \
			-theme ${theme}
	}

	# Pass variables to rofi dmenu
	run_rofi() {
		echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
	}

	chosen="$(run_rofi)"
	case ${chosen} in
		$option_1)
			shotnow
			;;
		$option_2)
			shotarea
			;;
		$option_3)
			shotwin
			;;
		$option_4)
			shot5
			;;
		$option_5)
			shot10
			;;
	esac
}

# Argument Handling
if [[ "$1" == "--menu" ]]; then
	show_menu
else
	shotarea
fi