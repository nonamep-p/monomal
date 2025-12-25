#!/bin/bash
# Monomal Installer - Sleek & Interactive

# --- Configuration ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.monomal_backups/$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$REPO_DIR/install.log"

# --- Colors & Styles ---
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- UI Functions ---
clear_screen() { printf "\033c"; }

banner() {
    clear_screen
    echo -e "${BOLD}${CYAN}"
    echo "  __  __  ____  _   _  ____  __  __   _    _     "
    echo " |  \/  |/ __ \| \ | |/ __ \|  \/  | | |  | |    "
    echo " | \  / | |  | |  \| | |  | | \  / | | |__| |    "
    echo " | |\/| | |  | | . \` | |  | | |\/| | |  __  |    "
    echo " | |  | | |__| | |\  | |__| | |  | | | |  | |    "
    echo " |_|  |_|\____/|_| \_|\____/|_|  |_| |_|  |_|    "
    echo -e "${NC}      ${BLUE}:: Monochromatic Hyprland Setup ::${NC}"
    echo ""
}

log() {
    local type="$1"
    local msg="$2"
    local color="$NC"
    case "$type" in
        INFO) color="$BLUE" ;; 
        SUCCESS) color="$GREEN" ;; 
        WARN) color="$YELLOW" ;; 
        ERROR) color="$RED" ;; 
    esac
    # Print to log file
    echo "[$type] $msg" >> "$LOG_FILE"
    # Print to screen
    echo -e "${color}[$type]${NC} $msg"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

section() {
    echo -e "\n${BOLD}${CYAN}:: $1 ::${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
}

confirm() {
    echo -ne "\n${YELLOW}[?] $1 [Y/n]: ${NC}"
    read -r response
    [[ -z "$response" || "$response" =~ ^[Yy]$ ]]
}

# --- Core Logic ---

check_deps() {
    section "Pre-flight Checks"
    
    # OS Check
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
            log SUCCESS "Detected Arch-based system ($PRETTY_NAME)"
        else
            log WARN "Detected $PRETTY_NAME. This script is optimized for Arch."
            confirm "Continue anyway?" || exit 1
        fi
    fi

    # AUR Helper Check
    if command -v paru &> /dev/null; then
        AUR_HELPER="paru"
    elif command -v yay &> /dev/null; then
        AUR_HELPER="yay"
    else
        log WARN "No AUR helper found."
        if confirm "Install 'paru-bin'?"; then
            sudo pacman -S --needed --noconfirm base-devel git
            git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
            (cd /tmp/paru-bin && makepkg -si --noconfirm)
            AUR_HELPER="paru"
        else
            log ERROR "AUR helper required."
            exit 1
        fi
    fi
    log SUCCESS "Using AUR helper: $AUR_HELPER"
}

install_pkgs() {
    section "Package Management"
    
    CORE_PKGS=(
        "hyprland" "waybar" "fish" "starship" "swaync"
        "pipewire" "pipewire-pulse" "pipewire-alsa" "wireplumber"
        "rofi" "grim" "slurp" "wl-clipboard"
        "python" "python-requests" "git" "base-devel"
        "wlogout" "dunst" "libnotify" "brightnessctl" "pamixer"
        "polkit-gnome" "qt5-wayland" "qt6-wayland"
        "xdg-desktop-portal-hyprland"
        "btop" "micro" "neofetch" "pavucontrol" "copyq"
    )

    AUR_PKGS=(
        "ghostty" "atuin" "hypridle" "hyprlock" 
        "ttf-jetbrains-mono-nerd" "ttf-font-awesome" 
        "swww" "hyprpicker"
    )

    if confirm "Install/Update Packages?"; then
        echo -e "${CYAN}Installing packages... (Details in install.log)${NC}"
        
        # Run in background and show spinner
        ($AUR_HELPER -Syu --needed --noconfirm "${CORE_PKGS[@]}" "${AUR_PKGS[@]}" >> "$LOG_FILE" 2>&1) &
        spinner $!
        
        if [ $? -eq 0 ]; then
            log SUCCESS "Packages installed."
        else
            log WARN "Some packages might have failed. Check $LOG_FILE."
        fi
    else
        log INFO "Skipping packages."
    fi
}

link_configs() {
    section "Configuration Linking"
    
    CONFIG_LIST=(
        "atuin" "btop" "copyq" "easyeffects" 
        "fish" "ghostty" "hypr" "micro" "neofetch" 
        "rofi" "spicetify" "starship.toml" "swaync" 
        "vesktop" "waybar"
    )

    if confirm "Link Dotfiles? (Backups will be created)"; then
        mkdir -p "$BACKUP_DIR"
        log INFO "Backup Dir: $BACKUP_DIR"
        
        for item in "${CONFIG_LIST[@]}"; do
            SRC="$REPO_DIR/.config/$item"
            DEST="$CONFIG_DIR/$item"
            
            # Skip if source missing
            [ ! -e "$SRC" ] && continue
            
            # Backup if exists and not already a link to our source
            if [ -e "$DEST" ] || [ -L "$DEST" ]; then
                if [ -L "$DEST" ] && [ "$(readlink -f "$DEST")" == "$SRC" ]; then
                    # log INFO "Skipping $item (Already linked)"
                    continue
                fi
                mv "$DEST" "$BACKUP_DIR/"
            fi
            
            # Link
            ln -sf "$SRC" "$DEST"
            echo -e "Linked: ${GREEN}$item${NC}"
        done
        
        # Wallpapers
        if [ -d "$REPO_DIR/Wallpapers" ]; then
             if [ -e "$HOME/Wallpapers" ] && [ ! -L "$HOME/Wallpapers" ]; then
                mv "$HOME/Wallpapers" "$BACKUP_DIR/"
             fi
             ln -sf "$REPO_DIR/Wallpapers" "$HOME/Wallpapers"
             echo -e "Linked: ${GREEN}Wallpapers${NC}"
        fi

        log SUCCESS "Configuration Linked."
    else
        log INFO "Skipping dotfiles."
    fi
}

post_install() {
    section "Finishing Touches"
    
    if [[ "$SHELL" != *"fish"* ]]; then
        if confirm "Make Fish the default shell?"; then
            chsh -s "$(which fish)"
        fi
    fi
    
    # Scripts executable
    find "$REPO_DIR" -name "*.sh" -exec chmod +x {} \;
    
    # Refresh fonts
    fc-cache -f >/dev/null 2>&1
    
    echo -e "\n${BOLD}${GREEN}Installation Complete!${NC}"
    echo -e "Please reboot your system to finalize changes."
    echo -e "Log file: $LOG_FILE"
}

# --- Main ---
banner
check_deps
install_pkgs
link_configs
post_install