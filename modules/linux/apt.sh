#!/bin/bash
# modules/linux/apt.sh — Base Linux packages via apt

install_linux_base() {
    echo "Installing Linux base packages..."

    if ! command -v apt-get &>/dev/null; then
        echo "apt-get not found. Skipping (non-Debian/Ubuntu system)."
        return 0
    fi

    sudo apt-get update

    local packages=(
        build-essential
        curl
        file
        git
        procps
    )

    sudo apt-get install -y "${packages[@]}"

    echo "Linux base packages installed."
}

install_linux_base
