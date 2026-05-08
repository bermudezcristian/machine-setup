#!/bin/bash
# modules/shared/base.sh — Install Homebrew (macOS, arch-aware)

install_homebrew() {
    if command -v brew &>/dev/null; then
        echo "Homebrew already installed."
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Ensure brew is in PATH for the rest of this session
    local brew_prefix
    if [[ "$ARCH" == "arm64" ]]; then
        brew_prefix="/opt/homebrew"
    else
        brew_prefix="/usr/local"
    fi
    eval "$("${brew_prefix}/bin/brew" shellenv)"

    # Persist to shell profile
    if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
        echo "eval \"\$(${brew_prefix}/bin/brew shellenv)\"" >> ~/.zprofile
    fi

    echo "Homebrew is ready."
}

install_homebrew
