#!/bin/bash
# update.sh — Update all managed tools in one command.
# Note: Claude Code is intentionally not handled here — the native installer
# auto-updates itself in the background. See modules/shared/devtools.sh.

set -e
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# -------------------------------------------------
# Dotfile symlinks (pick up any new files added under config/)
# -------------------------------------------------
if [[ -f "$SCRIPT_DIR/modules/shared/symlinks.sh" ]]; then
    echo "--- Refreshing symlinks ---"
    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/modules/shared/symlinks.sh"
    echo ""
fi

echo "========================================"
echo "  All updates complete!"
echo "========================================"
