#!/bin/bash
# modules/shared/fonts.sh — Install Meslo LG Nerd Font (macOS)

install_fonts() {
    if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        echo "MesloLGS Nerd Font already installed."
        return 0
    fi

    echo "Installing MesloLGS Nerd Font via Homebrew cask..."
    brew install --cask font-meslo-lg-nerd-font
}

install_fonts
echo "Fonts installed."
