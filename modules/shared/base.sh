#!/bin/bash
# modules/shared/base.sh — Install Homebrew (cross-platform, arch-aware)
# On macOS: also handled by modules/macos/xcode.sh for CLI tools

install_homebrew() {
    if command -v brew &>/dev/null; then
        echo "Homebrew already installed."
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Ensure brew is in PATH for the rest of this session
    if [[ "$OS" == "Darwin" ]]; then
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
    elif [[ "$OS" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        if ! grep -q 'brew shellenv' ~/.profile 2>/dev/null; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
        fi
    fi

    echo "Updating Homebrew..."
    brew update
    brew upgrade
    echo "Homebrew is ready."
}

install_homebrew
