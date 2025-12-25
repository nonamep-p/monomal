#!/usr/bin/env python3
import json
import subprocess
from datetime import datetime
from zoneinfo import ZoneInfo
import sys

def get_calendar():
    try:
        # cal with no highlighting to avoid escape code mess in tooltip if waybar doesn't handle it well
        # But user likes highlighted. Let's try raw.
        cal = subprocess.check_output(["cal"], encoding="utf-8").strip()
        # Highlight today manually if needed? 
        # Waybar's native clock uses gtk-calendar usually.
        # Let's just wrap in tt.
        return f"<tt>{cal}</tt>"
    except:
        return ""

def main():
    # Timezones
    # System local time
    now_local = datetime.now().astimezone()
    
    try:
        tz_al_ain = ZoneInfo('Asia/Dubai')
        now_al_ain = datetime.now(tz_al_ain)
    except Exception as e:
        now_al_ain = now_local # Fallback
        
    # Formats
    # Main text: 10:30 PM Mon 22
    text = now_local.strftime("%I:%M %p  %a %d")
    
    # Tooltip
    cal = get_calendar()
    
    local_str = now_local.strftime("%H:%M - %d/%m")
    al_ain_str = now_al_ain.strftime("%H:%M - %d/%m")
    
    tooltip = f"{cal}\n\n<b>Local</b>\n{local_str}\n\n<b>🌴 Al Ain</b>\n{al_ain_str}"
    
    # JSON Output
    data = {
        "text": text,
        "tooltip": tooltip,
        "class": "clock"
    }
    
    print(json.dumps(data))

if __name__ == "__main__":
    main()