#!/usr/bin/env bash

# Paths
STATUS_FILE="/tmp/recording_status"
CONFIG_FILE="$HOME/.config/hypr/recorder.conf"
VIDEOS_DIR="$HOME/Videos"
SETTINGS_SCRIPT="$HOME/.config/hypr/scripts/recorder_settings.sh"
ROFI_THEME="$HOME/.config/rofi/configs/clipboard.rasi" # Use small list theme

# --- Helper: Check if Recording ---
is_recording() {
    pgrep wf-recorder > /dev/null
}

stop_recording() {
    pid=$(pgrep wf-recorder)
    if [ -n "$pid" ]; then
        kill -SIGINT "$pid"
        sleep 1
        rm -f "$STATUS_FILE"
        notify-send -u normal -t 3000 "Recording Stopped" "Video saved to $VIDEOS_DIR"
    fi
}

# --- Menu Mode ---
if [ "$1" == "--menu" ]; then
    if is_recording;
    then
        # If recording, menu only shows STOP
        echo -en "⏹ Stop Recording\0icon\x1fmedia-record\n" | \
        rofi -dmenu -theme "$ROFI_THEME" -p "RECORDING" | \
        grep "Stop" && stop_recording
        exit 0
    else
        # Not recording: Show Start / Settings / Open
        OPTIONS="⏺ Start Recording\n⚙ Settings\n📂 Open Videos"
        CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -theme "$ROFI_THEME" -p "RECORDER")
        
        case "$CHOICE" in
                        *"Start"*) ;; # Fall through to start logic
                        *"Settings"*) bash "$SETTINGS_SCRIPT"; exit 0 ;;
                        *"Open"*) nautilus "$VIDEOS_DIR"; exit 0 ;;
                        *) exit 0 ;;        esac
    fi
fi

# --- Main Logic (Start/Stop) ---

# If already running, stop it (unless we just came from the menu start option)
if is_recording;
then
    stop_recording
    exit 0
fi

# START NEW RECORDING

# Load Config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Defaults
    AUDIO_SOURCE="default"
    RECORD_AREA="fullscreen"
    QUALITY="gpu"
fi

# 1. Define File Name
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
filename="$VIDEOS_DIR/Recording_${timestamp}.mp4"
mkdir -p "$VIDEOS_DIR"

# 2. Build Arguments (Safe Arrays)
CMD=("wf-recorder" "-f" "$filename")

# Audio
if [ "$AUDIO_SOURCE" == "default" ]; then
    CMD+=("--audio=$(pactl get-default-sink).monitor")
elif [ "$AUDIO_SOURCE" == "mic" ]; then
    CMD+=("--audio=$(pactl get-default-source)")
fi

# Area
if [ "$RECORD_AREA" == "region" ]; then
    geometry=$(slurp)
    if [ -z "$geometry" ]; then
        notify-send "Recording Cancelled" "No region selected."
        exit 1
    fi
    CMD+=("-g" "$geometry")
fi

# Codec
if [ "$QUALITY" == "gpu" ]; then
    if [ -e /dev/dri/renderD128 ]; then
        CMD+=("-c" "h264_vaapi" "-d" "/dev/dri/renderD128")
    else
        notify-send "Warning" "GPU not found, falling back to CPU."
    fi
fi

# 3. Execute
notify-send -t 3000 "Recording Started" "Saving to $filename"
"${CMD[@]}" &
echo $! > "$STATUS_FILE"
