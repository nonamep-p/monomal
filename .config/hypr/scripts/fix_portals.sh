#!/usr/bin/env bash
# Fix Portals for Screen Sharing & Audio
sleep 1
killall -9 xdg-desktop-portal-hyprland 2>/dev/null
killall -9 xdg-desktop-portal 2>/dev/null

# Update Environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE

# Restart Services via systemd (preferred)
systemctl --user start xdg-desktop-portal-hyprland.service
sleep 1
systemctl --user start xdg-desktop-portal.service

notify-send "Portal Fixed" "Screen sharing and audio sharing enabled."