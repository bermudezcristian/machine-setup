#!/bin/bash
# modules/shared/terminal.sh — Ghostty terminal configuration
# Config is symlinked by modules/shared/symlinks.sh
# This module handles any runtime setup (themes, etc.)

install_ghostty_linux() {
    # Try system package managers in order of preference
    if command -v apt-get &>/dev/null; then
        if apt-cache show ghostty &>/dev/null 2>&1; then
            echo "Installing Ghostty via apt..."
            sudo apt-get install -y ghostty
            return 0
        fi
    fi

    if command -v dnf &>/dev/null; then
        if dnf info ghostty &>/dev/null 2>&1; then
            echo "Installing Ghostty via dnf..."
            sudo dnf install -y ghostty
            return 0
        fi
    fi

    if command -v pacman &>/dev/null; then
        if pacman -Si ghostty &>/dev/null 2>&1; then
            echo "Installing Ghostty via pacman..."
            sudo pacman -S --noconfirm ghostty
            return 0
        fi
    fi

    # Flatpak fallback
    if command -v flatpak &>/dev/null; then
        echo "Installing Ghostty via Flatpak..."
        flatpak install -y flathub com.mitchellh.ghostty 2>/dev/null && return 0
    fi

    echo "Ghostty not available in system package manager."
    echo "Install manually: https://ghostty.org/download"
    return 1
}

setup_ghostty() {
    echo "Configuring Ghostty terminal..."

    # Check if already installed
    if command -v ghostty &>/dev/null || [[ -d "/Applications/Ghostty.app" ]]; then
        echo "Ghostty configured. Config will be symlinked by the symlinks module."
        return 0
    fi

    # On Linux, attempt installation
    if [[ "$OS" == "Linux" ]]; then
        install_ghostty_linux || true
    else
        echo "Ghostty not found — it should have been installed via Brewfile. Skipping."
    fi
}

setup_ghostty
