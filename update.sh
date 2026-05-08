#!/bin/bash
# update.sh — Update all managed tools in one command

set -e
set -u

echo "========================================"
echo "  machine-setup: update"
echo "========================================"
echo ""

# -------------------------------------------------
# Homebrew
# -------------------------------------------------
if command -v brew &>/dev/null; then
    echo "--- Updating Homebrew ---"
    brew update
    brew upgrade
    brew cleanup
    echo ""
fi

# -------------------------------------------------
# mise
# -------------------------------------------------
if command -v mise &>/dev/null; then
    echo "--- Updating mise ---"
    mise self-update 2>/dev/null || true
    mise upgrade
    echo ""
fi

# -------------------------------------------------
# Neovim plugins (lazy.nvim)
# -------------------------------------------------
if command -v nvim &>/dev/null; then
    echo "--- Updating Neovim plugins ---"
    nvim --headless "+Lazy! sync" +qa || true
    echo ""
fi

# -------------------------------------------------
# Fisher plugins (fish)
# -------------------------------------------------
if command -v fish &>/dev/null; then
    if fish -c "type -q fisher" 2>/dev/null; then
        echo "--- Updating Fisher plugins ---"
        fish -c "fisher update" 2>/dev/null || true
        echo ""
    fi
fi

echo "========================================"
echo "  All updates complete!"
echo "========================================"
