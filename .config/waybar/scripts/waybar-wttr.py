#!/usr/bin/env python

import json
import requests
from datetime import datetime

WEATHER_CODES = {
    '113': '☀️',
    '116': '⛅️',
    '119': '☁️',
    '122': '☁️',
    '143': '🌫',
    '176': '🌦',
    '179': '🌧',
    '182': '🌧',
    '185': '🌧',
    '200': '⛈',
    '227': '🌨',
    '230': '❄️',
    '248': '🌫',
    '260': '🌫',
    '263': '🌦',
    '266': '🌦',
    '281': '🌧',
    '284': '🌧',
    '293': '🌦',
    '296': '🌦',
    '299': '🌧',
    '302': '🌧',
    '305': '🌧',
    '308': '🌧',
    '311': '🌧',
    '314': '🌧',
    '317': '🌧',
    '320': '🌨',
    '323': '🌨',
    '326': '🌨',
    '329': '❄️',
    '332': '❄️',
    '335': '❄️',
    '338': '❄️',
    '350': '🌧',
    '353': '🌦',
    '356': '🌧',
    '359': '🌧',
    '362': '🌧',
    '365': '🌧',
    '368': '🌨',
    '371': '❄️',
    '374': '🌧',
    '377': '🌧',
    '386': '⛈',
    '389': '🌩',
    '392': '⛈',
    '395': '❄️'
}

data = {}

LOCATIONS = [
    {"query": "24.8607,67.0011", "label": "🏠 Karachi"},
    {"query": "24.2000,55.7500", "label": "🌴 Al Ain"}
]

import sys

# ... (rest of imports)

def get_weather(query):
    try:
        url = f"https://wttr.in/{query}?format=j1"
        return requests.get(url).json()
    except Exception as e:
        print(f"Error fetching '{query}': {e}", file=sys.stderr)
        return None

def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind"
    }
    conditions = []
    for event, name in chances.items():
        if int(hour[event]) > 0:
            conditions.append(name)
    return ", ".join(conditions)

data = {}
all_text = []
tooltip_parts = []

for loc in LOCATIONS:
    weather = get_weather(loc["query"])
    if not weather:
        continue

    # Process Data
    current = weather['current_condition'][0]
    astronomy = weather['weather'][0]['astronomy'][0]
    
    # Location Name
    if "Al Ain" in loc["label"]:
        loc_name = "Al Ain, Abu Dhabi (UAE)"
        coords = "24.2000° N, 55.7500° E"
    else:
        loc_name = weather['nearest_area'][0]['areaName'][0]['value']
        coords = loc["query"]

    # Main Bar Text (Icon + Temp)
    icon = WEATHER_CODES[current['weatherCode']]
    temp = current['temp_C']
    all_text.append(f"{icon} {temp}°C")

    # Tooltip Section
    t_text = f"<b>📍 {loc['label']}: {loc_name}</b>\n"
    if loc["query"]:
        t_text += f"<i>{coords}</i>\n"
    
    t_text += f"<b>{current['weatherDesc'][0]['value']} {current['temp_C']}°C</b>\n"
    t_text += f"🤔 Feels like: {current['FeelsLikeC']}°C\n"
    t_text += f"💧 Humidity: {current['humidity']}%\n"
    t_text += f"💨 Wind: {current['windspeedKmph']}km/h\n"

    # Precip Chance
    current_time_int = datetime.now().hour * 100
    closest_hour = weather['weather'][0]['hourly'][0]
    min_diff = 9999
    for hour in weather['weather'][0]['hourly']:
        diff = abs(int(hour['time']) - current_time_int)
        if diff < min_diff:
            min_diff = diff
            closest_hour = hour
            
    t_text += f"☔ Precip Chance: {closest_hour['chanceofrain']}%\n"
    t_text += f"🌅 Sunrise: {astronomy['sunrise']} 🌇 Sunset: {astronomy['sunset']}\n"
    
    tooltip_parts.append(t_text)

# Final Output
data['text'] = "  |  ".join(all_text)
data['tooltip'] = "\n--------------------------------\n\n".join(tooltip_parts)

print(json.dumps(data))
