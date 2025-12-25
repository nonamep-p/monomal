#!/bin/bash

# Get current times
LOCAL_TIME=$(date +"%H:%M")
LOCAL_DATE_DAY=$(date +"%a %d/%m") # Short day, DD/MM
LOCAL_DATE_FULL=$(date +"%A, %d %B %Y") # Full date for tooltip

# Multiple Time Zones
AL_AIN_TIME=$(TZ='Asia/Dubai' date +"%H:%M")
NY_TIME=$(TZ='America/New_York' date +"%H:%M")
TOK_TIME=$(TZ='Asia/Tokyo' date +"%H:%M")
LON_TIME=$(TZ='Europe/London' date +"%H:%M")

# Icons (Direct Unicode)
ICON_CLOCK=""
ICON_GLOBE="" # World/Globe icon

# JSON for Waybar
# text: The main display on the bar (HH:MM DD/MM)
# tooltip: The hover content with world clocks and full date
cat <<EOF
{
    "text": "$LOCAL_TIME  $LOCAL_DATE_DAY",
    "tooltip": "<span size='large' weight='bold'>$LOCAL_DATE_FULL</span>\n\n<b>$ICON_CLOCK Local:</b> $LOCAL_TIME\n<b>$ICON_GLOBE Al Ain:</b> $AL_AIN_TIME\n<b>$ICON_GLOBE New York:</b> $NY_TIME\n<b>$ICON_GLOBE Tokyo:</b> $TOK_TIME\n<b>$ICON_GLOBE London:</b> $LON_TIME"
}
EOF
