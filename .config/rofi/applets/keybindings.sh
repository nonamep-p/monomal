#!/bin/bash

config_file=~/.config/hypr/configs/keybindings.conf
theme=~/.config/rofi/configs/keybinds.rasi
keybinds=""
current_section="General"

if [ ! -f "$config_file" ]; then
    echo "Keybinding config file not found at $config_file."
    exit 1
fi

while IFS= read -r line; do
    # Skip empty lines
    [[ -z "$line" ]] && continue
    
    # Detect Section Headers
    # Matches lines starting with # followed by a letter (ignoring spaces)
    if [[ "$line" =~ ^#[[:space:]]*[A-Za-z] ]]; then
        # Remove # and leading spaces
        current_section=$(echo "$line" | sed 's/^#[[:space:]]*//')
        continue
    fi

    if [[ "$line" == bind* ]]; then
        # Normalize: Replace $mainMod with SUPER and remove bind=/bindm=
        clean_line=$(echo "$line" | sed -E 's/\$mainMod/SUPER/g')
        
        # Extract Description (after #)
        if [[ "$clean_line" == *"#"* ]]; then
            desc="${clean_line#*#}"
            # Trim leading/trailing whitespace
            desc=$(echo "$desc" | xargs)
        else
            desc=""
        fi
        
        # Extract Binding (before #)
        binding_part="${clean_line%%#*}"
        # Remove "bind =" or "bindm =" stuff
        binding_part=$(echo "$binding_part" | sed -E 's/bind[a-z]*[[:space:]]*=[[:space:]]*//')
        
        # Parse: MOD, KEY (we ignore the dispatcher/args for the display)
        IFS=',' read -r mod key rest <<< "$binding_part"
        mod=$(echo "$mod" | xargs)
        key=$(echo "$key" | xargs)
        
        # Format: [Section] Binding : Description
        # Color palette (Catppuccin-ish/Standard):
        # Section: Blue (#89b4fa)
        # Binding: Bold White (#cdd6f4)
        # Description: Gray (#a6adc8)
        
        entry="<span color='#89b4fa'>[${current_section}]</span> <span weight='bold' color='#cdd6f4'>${mod} + ${key}</span> <span color='#a6adc8'>${desc}</span>"
        
        keybinds+="${entry}\n"
    fi
done < "$config_file"

# Execute Rofi with markup enabled
echo -e "$keybinds" | rofi -dmenu -i -markup-rows -p "Keybinds" -theme "${theme}"