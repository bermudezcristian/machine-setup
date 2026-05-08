#!/bin/bash
# modules/shared/packages.sh — Install packages from Brewfiles

install_brew_packages() {
    local packages_dir="$SCRIPT_DIR/packages"

    # Shared Brewfile (CLI tools)
    if [[ -f "$packages_dir/Brewfile" ]]; then
        echo "Installing shared packages from Brewfile..."
        brew bundle --file="$packages_dir/Brewfile"
    fi

    # macOS-specific Brewfile
    local macos_brewfile="$packages_dir/Brewfile.macos"
    if [[ -f "$macos_brewfile" ]]; then
        echo "Installing macOS packages from Brewfile.macos..."
        brew bundle --file="$macos_brewfile"
    fi

    echo "All packages installed."
}

install_brew_packages
