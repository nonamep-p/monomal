#!/usr/bin/env python

import os
import sys
import configparser
import colorsys
from PIL import Image
from collections import Counter

# Configuration
WAYPAPER_CONFIG = os.path.expanduser("~/.config/waypaper/config.ini")
HYPR_COLORS = os.path.expanduser("~/.config/hypr/configs/colors.conf")

def get_current_wallpaper():
    config = configparser.ConfigParser()
    config.read(WAYPAPER_CONFIG)
    try:
        path = config['Settings']['wallpaper']
        return os.path.expanduser(path)
    except KeyError:
        print("Could not find wallpaper in waypaper config")
        sys.exit(1)

def get_dominant_color(image_path):
    try:
        img = Image.open(image_path)
        img = img.resize((150, 150))  # Resize for speed
        img = img.convert('RGB')
        
        colors = img.getdata()
        valid_colors = []
        
        for r, g, b in colors:
            h, s, v = colorsys.rgb_to_hsv(r/255.0, g/255.0, b/255.0)
            
            # Filter out extreme blacks/whites
            if 0.1 < v < 0.95: 
                valid_colors.append((r, g, b))
        
        if not valid_colors:
            return (200, 200, 200) # Fallback to Silver
            
        # Find most common
        most_common = Counter(valid_colors).most_common(1)[0][0]
        return most_common
        
    except Exception as e:
        print(f"Error processing image: {e}")
        return (200, 200, 200)

def boost_color(rgb):
    """Make the color pop!"""
    r, g, b = rgb
    h, s, v = colorsys.rgb_to_hsv(r/255.0, g/255.0, b/255.0)
    
    # If unsaturated (grey), boost brightness to make it Silver/White
    if s < 0.1:
        v = max(0.8, v * 1.5) 
    else:
        # If colored, boost saturation and brightness
        s = min(1.0, s * 1.3)
        v = max(0.9, v * 1.2)
        
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    return (int(r*255), int(g*255), int(b*255))

def rgb_to_hex(rgb):
    return "0xff{:02x}{:02x}{:02x}".format(*rgb)

def update_config(hex_color):
    config_content = f"""$fg = {hex_color}
$bg = 0xff000000
"""
    with open(HYPR_COLORS, "w") as f:
        f.write(config_content)
    print(f"Updated border color to {hex_color}")

def main():
    wall_path = get_current_wallpaper()
    print(f"Analyzing: {wall_path}")
    
    base_rgb = get_dominant_color(wall_path)
    final_rgb = boost_color(base_rgb)
    final_hex = rgb_to_hex(final_rgb)
    
    update_config(final_hex)
    os.system("hyprctl reload")

if __name__ == "__main__":
    main()