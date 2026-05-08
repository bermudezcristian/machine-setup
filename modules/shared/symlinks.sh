#!/bin/bash
# modules/shared/symlinks.sh — Link config files to ~/.config/ and ~/
# Uses GNU Stow if available, falls back to manual symlinks.

link_with_stow() {
    echo "Using GNU Stow for symlinks..."
    local config_dir="$SCRIPT_DIR/config"

    mkdir -p "$HOME/.config"

    # Stow each config directory into ~/.config/
    local configs=(nvim ghostty starship git mise)
    for dir in "${configs[@]}"; do
        if [[ -d "$config_dir/$dir" ]]; then
            echo "Stowing $dir..."
            stow --dir="$config_dir" --target="$HOME/.config" --restow "$dir" &>/dev/null || {
                # If stow fails (e.g., target dir structure mismatch), fall back to manual
                link_manual_single "$config_dir/$dir" "$HOME/.config/$dir"
            }
        fi
    done

    # Shell config needs special handling (goes to ~ or ~/.config/)
    if [[ "$SHELL_CHOICE" == "fish" && -d "$config_dir/fish" ]]; then
        echo "Stowing fish config..."
        mkdir -p "$HOME/.config/fish"
        stow --dir="$config_dir" --target="$HOME/.config" --restow fish &>/dev/null || {
            link_manual_single "$config_dir/fish" "$HOME/.config/fish"
        }
    elif [[ "$SHELL_CHOICE" == "zsh" && -f "$config_dir/zsh/.zshrc" ]]; then
        link_manual_single "$config_dir/zsh/.zshrc" "$HOME/.zshrc"
    fi
}

backup_existing() {
    local dest="$1"
    if [[ -L "$dest" ]]; then
        # Existing symlink — safe to remove, no backup needed
        return 0
    fi
    if [[ -e "$dest" ]]; then
        local backup_dir
        backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
        local name
        name="$(basename "$dest")"
        echo "Backing up $dest -> $backup_dir/$name"
        cp -a "$dest" "$backup_dir/$name"
    fi
}

link_manual_single() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" || -e "$dest" ]]; then
        backup_existing "$dest"
        echo "Removing existing $dest"
        rm -rf "$dest"
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

link_manual() {
    echo "Using manual symlinks..."

    local config_dir="$SCRIPT_DIR/config"

    mkdir -p "$HOME/.config"

    # Config directories -> ~/.config/
    local configs=(nvim ghostty starship git mise)
    for dir in "${configs[@]}"; do
        if [[ -d "$config_dir/$dir" ]]; then
            link_manual_single "$config_dir/$dir" "$HOME/.config/$dir"
        fi
    done

    # Shell config
    if [[ "$SHELL_CHOICE" == "fish" && -d "$config_dir/fish" ]]; then
        link_manual_single "$config_dir/fish" "$HOME/.config/fish"
    elif [[ "$SHELL_CHOICE" == "zsh" && -f "$config_dir/zsh/.zshrc" ]]; then
        link_manual_single "$config_dir/zsh/.zshrc" "$HOME/.zshrc"
    fi
}

# -------------------------------------------------
# Run
# -------------------------------------------------
echo "Linking configuration files..."

if command -v stow &>/dev/null; then
    link_with_stow
else
    link_manual
fi

echo "Symlinks configured."
