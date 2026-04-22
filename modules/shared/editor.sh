#!/bin/bash
# modules/shared/editor.sh — Neovim setup
# Config is symlinked by modules/shared/symlinks.sh
# lazy.nvim bootstraps itself on first launch — no manual clone needed.

setup_neovim() {
    echo "Configuring Neovim..."

    if ! command -v nvim &>/dev/null; then
        echo "Neovim not found — it should have been installed via Brewfile. Skipping."
        return 0
    fi

    echo "Neovim configured. lazy.nvim will auto-install plugins on first launch."
}

setup_neovim
