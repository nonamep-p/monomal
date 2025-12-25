#!/usr/bin/env bash

# Config file path
CONFIG_FILE="$HOME/.config/hypr/recorder.conf"

# Defaults
DEFAULT_AUDIO="default" # default output
DEFAULT_AREA="fullscreen"
DEFAULT_QUALITY="gpu" # gpu (vaapi) or cpu

# Load current settings if they exist
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Create default config
    echo "AUDIO_SOURCE=$DEFAULT_AUDIO" > "$CONFIG_FILE"
    echo "RECORD_AREA=$DEFAULT_AREA" >> "$CONFIG_FILE"
    echo "QUALITY=$DEFAULT_QUALITY" >> "$CONFIG_FILE"
    source "$CONFIG_FILE"
fi

# Rofi Theme & Options
ROFI_CMD="rofi -dmenu -theme-str 'window {width: 400px;} listview {lines: 4;}' -p"

# --- Main Menu ---
OPTIONS="1. 󰕾 Audio Source: $([ "$AUDIO_SOURCE" == "default" ] && echo "System" || ([ "$AUDIO_SOURCE" == "mic" ] && echo "Microphone" || echo "Muted"))\n2. 󰹑 Area: $([ "$RECORD_AREA" == "fullscreen" ] && echo "Fullscreen" || echo "Region"))\n3. 󰈒 Quality: $([ "$QUALITY" == "gpu" ] && echo "GPU (Efficient)" || echo "CPU (Compatible)")\n4. 󰐥 Close"

CHOICE=$(echo -e "$OPTIONS" | $ROFI_CMD "Recording Settings")

case "$CHOICE" in
    *"Audio Source"*) 
        AUDIO_OPTS="System (Default Output)\nMicrophone\nMute"
        AUDIO_CHOICE=$(echo -e "$AUDIO_OPTS" | $ROFI_CMD "Select Audio")
        case "$AUDIO_CHOICE" in
            "System"*) NEW_AUDIO="default" ;; 
            "Microphone"*) NEW_AUDIO="mic" ;; 
            "Mute"*) NEW_AUDIO="none" ;; 
            *) exit 1 ;; 
        esac
        sed -i "s/^AUDIO_SOURCE=.*/AUDIO_SOURCE=$NEW_AUDIO/" "$CONFIG_FILE"
        "$0" # Reload menu
        ;; 
    *"Area"*) 
        AREA_OPTS="Fullscreen\nRegion (Select on start)"
        AREA_CHOICE=$(echo -e "$AREA_OPTS" | $ROFI_CMD "Select Area")
        case "$AREA_CHOICE" in 
            "Fullscreen"*) NEW_AREA="fullscreen" ;; 
            "Region"*) NEW_AREA="region" ;; 
            *) exit 1 ;; 
        esac
        sed -i "s/^RECORD_AREA=.*/RECORD_AREA=$NEW_AREA/" "$CONFIG_FILE"
        "$0" # Reload menu
        ;; 
    *"Quality"*) 
        QUAL_OPTS="GPU (Intel VAAPI - Efficient)\nCPU (Software - Compatible)"
        QUAL_CHOICE=$(echo -e "$QUAL_OPTS" | $ROFI_CMD "Select Quality")
        case "$QUAL_CHOICE" in 
            "GPU"*) NEW_QUAL="gpu" ;; 
            "CPU"*) NEW_QUAL="cpu" ;; 
            *) exit 1 ;; 
        esac
        sed -i "s/^QUALITY=.*/QUALITY=$NEW_QUAL/" "$CONFIG_FILE"
        "$0" # Reload menu
        ;; 
    *"Close"*) 
        exit 0 
        ;; 
esac
