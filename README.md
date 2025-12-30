<div align="center">

# ⬛ M O N O M A L &nbsp; 2 . 0
### *The Definitive Monochrome Workspace*

[![Version](https://img.shields.io/badge/Version-2.1.0-white?style=for-the-badge&labelColor=111111)](https://github.com/nonamep-p/monomal)
[![License](https://img.shields.io/github/license/nonamep-p/monomal?style=for-the-badge&color=white&labelColor=111111)](LICENSE)
[![Arch](https://img.shields.io/badge/Arch_Linux-white?style=for-the-badge&logo=archlinux&logoColor=black&labelColor=111111)](https://archlinux.org)

**Monomal** is a high-performance, strictly monochromatic environment built for clarity and focus. 
<br/>
*Every pixel is sharpened. Every corner is square. Zero distractions.*

[ 🚀 Quick Start ](#-quick-start) • [ ⚡ Performance ](#-performance-engineering) • [ ⌨️ Keybindings ](#%EF%B8%8F-keybindings) • [ 🛠️ Features ](#%EF%B8%8F-features)

---
</div>

## ⚡ Performance Engineering
Monomal is not just a theme; it is a **hardware-tuned OS configuration** designed for low-power devices (Dual-Core, 8GB RAM).

*   **Anti-Freeze Memory:** Uses 150% ZRAM (12GB) with `zstd` compression to prevent system lockups.
*   **Zero-Lag Priority:** A background daemon (`window_priority.sh`) automatically boosts the CPU priority of your active window, ensuring typing never lags.
*   **App Profiles:** Includes custom "Nuclear" browser profiles for heavy web apps (WhatsApp, Discord) that reduce RAM usage by ~50%.
*   **Input Latency:** Optimized Hyprland configs with VFR (Variable Frame Rate) and direct-scanout for gaming.

👉 **[Read the full Performance Guide (PERFORMANCE.md)](PERFORMANCE.md)**

## 🛠️ Features

### 📦 Interactive Tools
*   **Ultimate Screen Recorder (`Super+Shift+R`):** A robust Rofi-based recorder with menus for Audio Source, Area Selection, Quality Settings, and Post-Recording actions (Rename/Delete). Hardware accelerated (`vaapi`).
*   **Wallpaper Gallery (`Super+Shift+W`):** A fast Rofi grid for browsing and applying wallpapers instantly.
*   **Clipboard Manager (`Super+V`):** A 400x500 popup running CopyQ, styled to match the system.

### 🎨 Visual Identity
*   **Radius:** Strictly `0px` globally.
*   **Palette:** `#000000` (Base), `#111111` (Surface), `#FFFFFF` (Text).
*   **OLED Simulation:** A custom shader (`oled-sim.glsl`) that boosts contrast and saturation to mimic OLED depth on LCD screens.

### 🔊 Audio Stack
*   **Noise Cancellation:** Pre-configured PipeWire filter chain for crystal clear mic input.
*   **Echo Cancellation:** WebRTC-grade echo removal active by default.

## 🚀 Quick Start

### Prerequisites
*   **OS:** Arch Linux (CachyOS Recommended)
*   **WM:** Hyprland
*   **Shell:** Fish / Bash

### Installation
```bash
git clone https://github.com/nonamep-p/monomal.git
cd monomal
./install.sh
```
*The installer handles backups, package installation, and dotfile linking automatically.*

## ⌨️ Keybindings

### 🪟 Window Management
| Key | Action |
| :--- | :--- |
| `Super + Q` | Close Window |
| `Super + F` | Fullscreen |
| `Super + P` | Pseudo-Tiling |
| `Super + S` | Toggle Split |
| `Super + Arrows` | Move Focus |

### 🚀 Launchers
| Key | Action |
| :--- | :--- |
| `Super + Enter` | **Ghostty** (Terminal) |
| `Super + Space` | **App Launcher** (Rofi) |
| `Super + E` | **Nautilus** (Files) |
| `Super + Shift + E` | **Emoji Picker** |

### 🛠️ Utilities
| Key | Action |
| :--- | :--- |
| `Super + V` | **Clipboard** (CopyQ) |
| `Super + Shift + R` | **Screen Recorder** (Menu) |
| `Super + Shift + W` | **Wallpaper Picker** |
| `Super + Shift + L` | **Reload Hyprland** |
| `Super + Alt + V` | **Volume Mixer** |

## 📦 Curated App Suite
Monomal is designed around these specific tools:
*   **Browser:** Zen Browser (Firefox fork)
*   **Terminal:** Ghostty
*   **Music:** Spotify (Native/AUR) or `spotify-player` (TUI)
*   **Chat:** Vesktop (Discord) & Zen Web Apps
*   **Editor:** Micro / VS Code

---
<div align="center">
  
**Developed with precision by [nonamep-p](https://github.com/nonamep-p)**
<br/>
*Stay Sharp.*

</div>