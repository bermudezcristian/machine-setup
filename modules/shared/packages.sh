#!/bin/bash
# modules/shared/packages.sh — Install packages from Brewfiles (shared + OS-specific)

install_brew_packages() {
    local packages_dir="$SCRIPT_DIR/packages"

    # Shared Brewfile (cross-platform CLI tools)
    if [[ -f "$packages_dir/Brewfile" ]]; then
        echo "Installing shared packages from Brewfile..."
        brew bundle --file="$packages_dir/Brewfile"
    fi

    # OS-specific Brewfile
    local os_brewfile=""
    if [[ "$OS" == "Darwin" ]]; then
        os_brewfile="$packages_dir/Brewfile.macos"
    elif [[ "$OS" == "Linux" ]]; then
        os_brewfile="$packages_dir/Brewfile.linux"
    fi

    if [[ -n "$os_brewfile" && -f "$os_brewfile" ]]; then
        echo "Installing OS-specific packages from $(basename "$os_brewfile")..."
        brew bundle --file="$os_brewfile"
    fi

    echo "All packages installed."
}

install_apt_packages() {
    local apt_file="$SCRIPT_DIR/packages/apt.txt"

    if [[ "$OS" != "Linux" ]]; then
        return 0
    fi

    if ! command -v apt-get &>/dev/null; then
        return 0
    fi

    if [[ ! -f "$apt_file" ]]; then
        return 0
    fi

    echo "Installing apt packages..."
    sudo apt-get update
    xargs -a "$apt_file" sudo apt-get install -y
    echo "apt packages installed."
}

# On Linux, install apt packages first (build-essential, etc.)
if [[ "$OS" == "Linux" ]]; then
    install_apt_packages
fi

install_brew_packages
