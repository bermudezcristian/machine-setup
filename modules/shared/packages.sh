#!/bin/bash
# modules/shared/packages.sh — Install packages from Brewfiles

# Casks from non-official taps that Homebrew refuses to load until explicitly
# trusted. Trust is granted per-cask (not per-tap) to keep the grant narrow.
TRUSTED_CASKS=(
    "manaflow-ai/cmux/cmux"
)

trust_third_party_casks() {
    local trusted_json cask
    trusted_json="$(brew trust --json v1 2>/dev/null || true)"

    for cask in "${TRUSTED_CASKS[@]}"; do
        if grep -q "\"$cask\"" <<<"$trusted_json"; then
            continue
        fi
        echo "Trusting third-party cask: $cask"
        brew trust --cask "$cask"
    done
}

install_brew_packages() {
    local packages_dir="$SCRIPT_DIR/packages"

    trust_third_party_casks

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
