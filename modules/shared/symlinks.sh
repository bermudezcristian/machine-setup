#!/bin/bash
# modules/shared/symlinks.sh — Link config files to ~/.config/ and ~/ using GNU Stow.

# XDG packages: each lives at config/<pkg>/ and is stowed into ~/.config/<pkg>/
XDG_PACKAGES=(nvim ghostty starship mise git fish)

# Symlinks left by previous (broken) symlink runs. We remove these before stowing
# so that stow can build the correct per-file structure underneath ~/.config/<pkg>/.
# Two kinds:
#   1. Flat files at ~/.config/ from the broken stow --target=$HOME/.config invocation.
#   2. Directory-symlinks at ~/.config/<pkg> from the old manual fallback (e.g. git).
# Only removed if the link points into the machine-setup repo — never touches real files.
sweep_stray_links() {
    local stray_flat=(
        "$HOME/.config/config.fish"
        "$HOME/.config/conf.d"
        "$HOME/.config/init.lua"
        "$HOME/.config/starship.toml"
        "$HOME/.config/config.toml"
        "$HOME/.config/config"
        "$HOME/.config/config.local.fish.example"
    )
    for f in "${stray_flat[@]}"; do
        if [[ -L "$f" ]] && readlink "$f" | grep -q "machine-setup"; then
            echo "Removing stray symlink: $f"
            rm "$f"
        fi
    done

    # Directory-symlinks at ~/.config/<pkg> pointing into the repo.
    for pkg in "${XDG_PACKAGES[@]}"; do
        local target="$HOME/.config/$pkg"
        if [[ -L "$target" ]] && readlink "$target" | grep -q "machine-setup"; then
            echo "Removing directory-symlink: $target"
            rm "$target"
        fi
    done
}

stow_package() {
    local pkg="$1"
    local target="$2"
    local config_dir="$3"

    mkdir -p "$target"
    stow --dir="$config_dir" --target="$target" --restow "$pkg"
}

# -------------------------------------------------
# Run
# -------------------------------------------------
echo "Linking configuration files..."

if ! command -v stow &>/dev/null; then
    echo "ERROR: GNU Stow is required but not installed." >&2
    echo "It should have been installed via packages/Brewfile — run packages module first." >&2
    exit 1
fi

config_dir="$SCRIPT_DIR/config"

sweep_stray_links

# XDG-style configs: ~/.config/<pkg>/
for pkg in "${XDG_PACKAGES[@]}"; do
    [[ -d "$config_dir/$pkg" ]] || continue
    echo "Stowing $pkg -> ~/.config/$pkg/"
    stow_package "$pkg" "$HOME/.config/$pkg" "$config_dir"
done

# Zsh: .zshrc goes directly into $HOME. Always linked regardless of SHELL_CHOICE
# so switching shells later just works.
if [[ -d "$config_dir/zsh" ]]; then
    echo "Stowing zsh -> ~/"
    stow_package "zsh" "$HOME" "$config_dir"
fi

echo "Symlinks configured."
