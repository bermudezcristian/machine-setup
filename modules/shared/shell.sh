#!/bin/bash
# modules/shared/shell.sh — Configure fish (default) or zsh based on --shell flag

setup_fish() {
    echo "Configuring fish shell..."

    # Ensure fish is installed
    if ! command -v fish &>/dev/null; then
        echo "fish not found — it should have been installed via Brewfile. Skipping."
        return 1
    fi

    local fish_path
    fish_path="$(command -v fish)"

    # Add fish to /etc/shells if not present
    if ! grep -qxF "$fish_path" /etc/shells 2>/dev/null; then
        echo "Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi

    # Set fish as default shell
    if [[ "$SHELL" != "$fish_path" ]]; then
        echo "Setting fish as default shell..."
        chsh -s "$fish_path"
    fi

    # Install Fisher (fish plugin manager)
    if ! fish -c "type -q fisher" 2>/dev/null; then
        echo "Installing Fisher plugin manager..."
        fish -c "curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    else
        echo "Fisher already installed."
    fi

    echo "Fish shell configured."
}

setup_zsh() {
    echo "Configuring zsh shell..."

    local zsh_path
    zsh_path="$(command -v zsh)"

    # Set zsh as default shell (usually already is on macOS)
    if [[ "$SHELL" != "$zsh_path" ]]; then
        if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
            echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
        fi
        echo "Setting zsh as default shell..."
        chsh -s "$zsh_path"
    fi

    # Install zsh plugins via Homebrew (should already be in Brewfile)
    # zsh-autosuggestions and zsh-syntax-highlighting are brew packages

    echo "Zsh shell configured."
}

# Run the appropriate setup based on SHELL_CHOICE
if [[ "$SHELL_CHOICE" == "fish" ]]; then
    setup_fish
elif [[ "$SHELL_CHOICE" == "zsh" ]]; then
    setup_zsh
fi
