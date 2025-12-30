# Monomal 2.0 - Performance & Optimization Guide

This configuration is strictly optimized for **Low-End Hardware** (Dual-Core CPUs, Integrated Graphics, 8GB RAM).
It prioritizes **responsiveness** and **stability** over visual flair, while maintaining the strict "Pitch Black" aesthetic.

## 🧠 Memory Management (Anti-Freeze)
The system is tuned to prevent "Thrashing" (Total System Freeze) when RAM fills up.

### 1. ZRAM (Compressed RAM)
*   **Size:** `12GB` (150% of Physical RAM).
*   **Algorithm:** `zstd` (Fast compression).
*   **Function:** Compresses active memory instead of writing to slow disk swap.
*   **Effect:** Effectively provides ~12-16GB of working memory on an 8GB stick.
*   **Config:** `/etc/systemd/zram-generator.conf`

### 2. Swappiness
*   **Value:** `60` (Balanced).
*   **Reason:** Prevents the kernel from panicking and dumping memory to disk too early or too late.

## ⚡ Graphics & Compositor (Anti-Lag)
Optimized for **Intel HD 620** (Integrated Graphics).

### 1. Hyprland Optimization
*   **VFR (Variable Frame Rate):** `Enabled`. Renders 0 FPS when screen is static.
*   **Animations:**
    *   **Focus:** `easeInOutCirc` (0.2s) - Snappy feedback.
    *   **Windows:** `overshot` (Smooth but fast).
*   **Blur/Shadows:** Disabled or Minimal (via `decoration.conf`).

### 2. Application Sandboxing
*   **Ozone Platform:** Forced `Wayland` on Electron apps (Vesktop, Spotify) to bypass XWayland overhead.
*   **Shader:** Custom `oled-sim.glsl` (Saturation 1.15, Gamma 1.10) for visual pop without performance cost.

## 🌐 Browser Isolation (Zen Browser)
We use **Dedicated Profiles** for heavy web apps to isolate memory usage.

### WhatsApp Profile (`whatsapp-app`)
*   **Process Limit:** Locked to `1` helper process.
*   **History:** Disabled.
*   **Cache:** Capped at 32MB RAM / 500MB Disk.
*   **Debloat:** PDF Viewer, Pocket, SafeBrowsing, and Accessibility services stripped out.
*   **Result:** Uses ~300MB RAM vs standard 600MB+.

## 🛠️ Custom Scripts

### `window_priority.sh`
*   **What it does:** Automatically `renice` (boost priority) of the **Active Window** to `-10`.
*   **Why:** Ensures the app you are typing in never lags, even if background apps are compiling/updating.

### `screen_record.sh` (Ultimate Recorder)
*   **Backend:** `wf-recorder` with `h264_vaapi` (Hardware Encoding).
*   **Impact:** Near-zero CPU usage while recording.
*   **Features:** Interactive Menu, Auto-save, Health Monitor (Disk/Process watchdog).
