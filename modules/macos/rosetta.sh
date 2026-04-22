#!/bin/bash
# modules/macos/rosetta.sh — Rosetta 2 for Apple Silicon

install_rosetta() {
    if [[ "$ARCH" != "arm64" ]]; then
        echo "Not Apple Silicon, skipping Rosetta."
        return 0
    fi

    if /usr/bin/pgrep oahd >/dev/null 2>&1; then
        echo "Rosetta 2 already installed."
        return 0
    fi

    echo "Installing Rosetta 2..."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    echo "Rosetta 2 installed."
}

install_rosetta
