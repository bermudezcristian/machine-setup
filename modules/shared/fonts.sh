#!/bin/bash
# modules/shared/fonts.sh — Install Meslo LG Nerd Font (cross-platform)

install_fonts_macos() {
    if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        echo "MesloLGS Nerd Font already installed."
        return 0
    fi
    echo "Installing MesloLGS Nerd Font via Homebrew cask..."
    brew install --cask font-meslo-lg-nerd-font
}

install_fonts_linux() {
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    if fc-list 2>/dev/null | grep -qi "MesloLGL.*Nerd"; then
        echo "MesloLGS Nerd Font already installed."
        return 0
    fi

    echo "Installing MesloLGS Nerd Font..."
    local base_url="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/L/Regular"
    local variants=(
        "MesloLGLNerdFont-Regular.ttf"
        "MesloLGLNerdFont-Bold.ttf"
        "MesloLGLNerdFont-Italic.ttf"
        "MesloLGLNerdFont-BoldItalic.ttf"
    )

    for variant in "${variants[@]}"; do
        curl -fLo "$font_dir/$variant" "$base_url/$variant"
    done

    if command -v fc-cache &>/dev/null; then
        fc-cache -f "$font_dir"
    fi
}

install_fonts() {
    if [[ "$OS" == "Darwin" ]]; then
        install_fonts_macos
    elif [[ "$OS" == "Linux" ]]; then
        install_fonts_linux
    fi
    echo "Fonts installed."
}

install_fonts
