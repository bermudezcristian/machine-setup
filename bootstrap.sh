#!/bin/bash
# bootstrap.sh — One-liner entry point for machine-setup
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/bermudezcristian/machine-setup/main/bootstrap.sh)
# Pass flags: bash <(curl -fsSL ...) --shell zsh

set -e

REPO_URL="https://github.com/bermudezcristian/machine-setup.git"
INSTALL_DIR="$HOME/machine-setup"

# Install git if not available
if ! command -v git &>/dev/null; then
    OS="$(uname -s)"
    echo "Git not found. Installing..."
    if [[ "$OS" == "Darwin" ]]; then
        xcode-select --install
        echo "Waiting for Xcode CLI tools to install..."
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
    elif [[ "$OS" == "Linux" ]]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get update && sudo apt-get install -y git
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y git
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm git
        else
            echo "Could not install git. Please install it manually and re-run."
            exit 1
        fi
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
fi

# Clone or update the repo
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "machine-setup already cloned. Pulling latest..."
    git -C "$INSTALL_DIR" pull --ff-only
else
    echo "Cloning machine-setup..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Run setup with any forwarded flags
cd "$INSTALL_DIR"
chmod +x setup.sh
exec ./setup.sh "$@"
