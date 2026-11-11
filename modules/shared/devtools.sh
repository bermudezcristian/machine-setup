#!/bin/bash
# modules/shared/devtools.sh — mise, GPG, fzf, fd

# -------------------------------------------------
# mise (asdf replacement)
# -------------------------------------------------

setup_mise() {
    echo "Configuring mise version manager..."

    if ! command -v mise &>/dev/null; then
        echo "mise not found — it should have been installed via Brewfile. Skipping."
        return 0
    fi

    # Activate mise in current session
    eval "$(mise activate bash)"

    # Install tools from config file (symlinked to ~/.config/mise/config.toml)
    local mise_config="$SCRIPT_DIR/config/mise/config.toml"
    if [[ -f "$mise_config" ]]; then
        echo "mise: Installing tools from config.toml..."
        MISE_CONFIG_FILE="$mise_config" mise install --yes
    fi

    echo "mise configured."
}

# -------------------------------------------------
# GnuPG + pinentry
# -------------------------------------------------

setup_gpg() {
    echo "Configuring GnuPG..."

    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg

    local gpg_conf="$HOME/.gnupg/gpg-agent.conf"

    # Select the right pinentry for macOS
    local pinentry_path
    pinentry_path="$(command -v pinentry-mac || true)"

    if [[ -n "$pinentry_path" ]]; then
        if ! grep -q "pinentry-program" "$gpg_conf" 2>/dev/null; then
            echo "pinentry-program $pinentry_path" >> "$gpg_conf"
            echo "Added pinentry to gpg-agent.conf"
        fi

        # Passphrase caching, in gpg-agent's memory only: the key stays unlocked
        # 8 h after its last use and 12 h after the passphrase was typed, at
        # most. Long enough to sign unattended for a working day; lock early
        # with `gpgconf --kill gpg-agent`. SSH keys stay uncached.
        set_gpg_agent_option() {
            local key="$1" value="$2"
            if grep -q "^${key} " "$gpg_conf" 2>/dev/null; then
                sed "s/^${key} .*/${key} ${value}/" "$gpg_conf" > "$gpg_conf.tmp"
                mv "$gpg_conf.tmp" "$gpg_conf"
            else
                echo "${key} ${value}" >> "$gpg_conf"
            fi
        }
        set_gpg_agent_option default-cache-ttl 28800
        set_gpg_agent_option max-cache-ttl 43200
        set_gpg_agent_option default-cache-ttl-ssh 0
        set_gpg_agent_option max-cache-ttl-ssh 0
        # Older runs wrote a "no caching" comment above these lines; fix it.
        if grep -q "^# No passphrase caching whatsoever" "$gpg_conf" 2>/dev/null; then
            sed "s/^# No passphrase caching whatsoever.*/# Passphrase cache: 8 h after last use, 12 h max (memory only)/" \
                "$gpg_conf" > "$gpg_conf.tmp"
            mv "$gpg_conf.tmp" "$gpg_conf"
        fi
        echo "Set gpg-agent passphrase cache to 8 h idle / 12 h max"

        # Forbid pinentry from using external caches (e.g. macOS Keychain):
        # the passphrase is never stored on disk.
        if ! grep -q "^no-allow-external-cache" "$gpg_conf" 2>/dev/null; then
            echo "no-allow-external-cache" >> "$gpg_conf"
            echo "Forbade external passphrase caches in gpg-agent.conf"
        fi

        chmod 600 "$gpg_conf"

        # pinentry-mac: leave the "Save in Keychain" checkbox UNCHECKED by
        # default (it can't cache anyway given no-allow-external-cache above).
        if [[ "$(uname)" == "Darwin" ]] && command -v defaults >/dev/null 2>&1; then
            defaults write org.gpgtools.common UseKeychain -bool NO
            echo "Set pinentry-mac 'Save in Keychain' checkbox to unchecked by default"
        fi
    else
        echo "No pinentry found. Skipping GPG pinentry config."
    fi

    # Restart gpg-agent to apply changes
    gpgconf --kill gpg-agent 2>/dev/null || true
    echo "GPG configured."
}

# -------------------------------------------------
# fzf shell integration
# -------------------------------------------------

setup_fzf() {
    echo "Configuring fzf..."

    if ! command -v fzf &>/dev/null; then
        echo "fzf not found. Skipping."
        return 0
    fi

    # Set fd as the default fzf file finder if available
    if command -v fd &>/dev/null; then
        echo "fd detected — will be used as fzf backend via shell config."
    fi

    # Run fzf install script for key bindings and completion (zsh only)
    if [[ "$SHELL_CHOICE" == "zsh" ]]; then
        local fzf_install
        fzf_install="$(brew --prefix 2>/dev/null)/opt/fzf/install"
        if [[ -x "$fzf_install" ]]; then
            "$fzf_install" --key-bindings --completion --no-update-rc --no-bash --no-fish
        fi
    fi

    echo "fzf configured."
}

# -------------------------------------------------
# Claude Code (native installer — auto-updates itself)
# -------------------------------------------------

setup_claude_code() {
    echo "Configuring Claude Code..."

    # Check the install path directly — ~/.local/bin isn't on $PATH inside setup.sh's bash.
    if [[ -x "$HOME/.local/bin/claude" ]]; then
        echo "claude already installed ($("$HOME/.local/bin/claude" --version 2>/dev/null || echo 'unknown')). Skipping."
        return 0
    fi

    curl -fsSL https://claude.ai/install.sh | bash
    echo "Claude Code installed."
}

setup_mise
setup_gpg
setup_fzf
setup_claude_code
