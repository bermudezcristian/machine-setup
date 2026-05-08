#!/bin/bash
# setup.sh — Main entry point for machine-setup
# Detects architecture, parses flags, and sources modules in order.

set -e
set -u

# -------------------------------------------------
# Globals
# -------------------------------------------------
ARCH="$(uname -m)"     # arm64 or x86_64
SHELL_CHOICE="fish"    # default shell
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------------------------------------------------
# Usage
# -------------------------------------------------
usage() {
    cat <<EOF
Usage: ./setup.sh [OPTIONS]

Options:
    --shell <fish|zsh>    Shell to configure (default: fish)
    -h, --help            Show this help message

Modules (run in order):
    base        Xcode CLI tools, Rosetta 2, Homebrew
    packages    Install packages from Brewfile
    shell       Configure fish or zsh
    editor      Neovim setup
    devtools    mise, GPG, fzf, fd
    fonts       Meslo LG Nerd Font
    symlinks    Link config files to ~/.config/
    defaults    macOS system defaults (Finder, Dock, trackpad)
    apps        Mac App Store apps

Examples:
    ./setup.sh                  # Full setup with fish
    ./setup.sh --shell zsh      # Full setup with zsh
EOF
    exit 0
}

# -------------------------------------------------
# Flag parsing
# -------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --shell)
            SHELL_CHOICE="$2"
            if [[ "$SHELL_CHOICE" != "fish" && "$SHELL_CHOICE" != "zsh" ]]; then
                echo "Invalid shell: $SHELL_CHOICE (must be fish or zsh)"
                exit 1
            fi
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# -------------------------------------------------
# macOS prerequisites
# -------------------------------------------------

install_xcode_cli() {
    if xcode-select -p &>/dev/null; then
        echo "Xcode Command Line Tools already installed."
        return 0
    fi

    echo "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait until installed (timeout after 60s)
    local attempts=0
    until xcode-select -p &>/dev/null; do
        attempts=$((attempts + 1))
        if [[ $attempts -ge 12 ]]; then
            echo "ERROR: Xcode CLI tools install timed out after 60s." >&2
            exit 1
        fi
        sleep 5
    done

    echo "Xcode Command Line Tools installed."
}

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

# -------------------------------------------------
# Module runner
# -------------------------------------------------

# Source a module file if it exists
run_module() {
    local module_path="$1"

    if [[ -f "$module_path" ]]; then
        echo ""
        echo "--- Running: $module_path ---"
        # shellcheck source=/dev/null
        source "$module_path"
    else
        echo "WARNING: module not found: $module_path" >&2
    fi
}

# -------------------------------------------------
# Main
# -------------------------------------------------
main() {
    echo "========================================"
    echo "  machine-setup"
    echo "  Arch:  $ARCH"
    echo "  Shell: $SHELL_CHOICE"
    echo "========================================"
    echo ""

    # --- macOS prerequisites ---
    install_xcode_cli
    install_rosetta

    # --- Shared modules ---
    run_module "$SCRIPT_DIR/modules/shared/base.sh"
    run_module "$SCRIPT_DIR/modules/shared/packages.sh"
    run_module "$SCRIPT_DIR/modules/shared/shell.sh"
    run_module "$SCRIPT_DIR/modules/shared/editor.sh"
    run_module "$SCRIPT_DIR/modules/shared/devtools.sh"
    run_module "$SCRIPT_DIR/modules/shared/fonts.sh"
    run_module "$SCRIPT_DIR/modules/shared/symlinks.sh"

    # --- macOS modules ---
    run_module "$SCRIPT_DIR/modules/macos/defaults.sh"
    run_module "$SCRIPT_DIR/modules/macos/apps.sh"

    echo ""
    echo "========================================"
    echo "  Setup complete!"
    echo "  Restart your terminal to apply changes."
    echo "========================================"
}

main
