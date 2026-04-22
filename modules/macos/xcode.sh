#!/bin/bash
# modules/macos/xcode.sh — Xcode Command Line Tools

install_xcode_cli() {
    if xcode-select -p &>/dev/null; then
        echo "Xcode Command Line Tools already installed."
        return 0
    fi

    echo "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait until the CLI tools are installed
    until xcode-select -p &>/dev/null; do
        sleep 5
    done

    echo "Xcode Command Line Tools installed."
}

install_xcode_cli
