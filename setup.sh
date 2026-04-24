#!/bin/bash
# setup.sh — Main entry point for machine-setup
# Detects OS, parses flags, and sources modules in order.

set -e
set -u

# -------------------------------------------------
# Globals
# -------------------------------------------------
OS="$(uname -s)"       # Darwin or Linux
ARCH="$(uname -m)"     # arm64 or x86_64
SHELL_CHOICE="fish"    # default shell
ONLY=""                # empty = run everything
SKIP=""                # empty = skip nothing
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------------------------------------------------
# Usage
# -------------------------------------------------
usage() {
    cat <<EOF
Usage: ./setup.sh [OPTIONS]

Options:
    --shell <fish|zsh>    Shell to configure (default: fish)
    --only <modules>      Comma-separated list of modules to run
    --skip <modules>      Comma-separated list of modules to skip
    -h, --help            Show this help message

Available modules:
    base        Homebrew install (+ Xcode CLI tools on macOS)
    packages    Install packages from Brewfile (+ apt on Linux)
    shell       Configure fish or zsh
    terminal    Ghostty terminal config
    editor      Neovim setup
    devtools    mise, GPG, fzf, fd
    ssh         SSH key generation and config
    fonts       Meslo LG Nerd Font
    symlinks    Link config files to ~/.config/
    defaults    OS-specific system defaults
    apps        macOS App Store apps (macOS only)

Examples:
    ./setup.sh                          # Full setup with fish
    ./setup.sh --shell zsh              # Full setup with zsh
    ./setup.sh --only shell,terminal    # Only configure shell and terminal
    ./setup.sh --skip apps,defaults     # Skip apps and system defaults
EOF
    exit 0
}

# -------------------------------------------------
# Flag parsing
# -------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --shell)
            SHELL_CHOICE="$2"
            if [[ "$SHELL_CHOICE" != "fish" && "$SHELL_CHOICE" != "zsh" ]]; then
                echo "Invalid shell: $SHELL_CHOICE (must be fish or zsh)"
                exit 1
            fi
            shift 2
            ;;
        --only)
            ONLY="$2"
            shift 2
            ;;
        --skip)
            SKIP="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# -------------------------------------------------
# Module runner
# -------------------------------------------------
# Check if a module should run based on --only and --skip flags
should_run() {
    local module="$1"

    # If --only is set, module must be in the list
    if [[ -n "$ONLY" ]]; then
        if ! echo ",$ONLY," | grep -q ",$module,"; then
            return 1
        fi
    fi

    # If --skip is set, module must NOT be in the list
    if [[ -n "$SKIP" ]]; then
        if echo ",$SKIP," | grep -q ",$module,"; then
            return 1
        fi
    fi

    return 0
}

# Source a module file if it exists
run_module() {
    local module_path="$1"
    if [[ -f "$module_path" ]]; then
        echo ""
        echo "--- Running: $module_path ---"
        # shellcheck source=/dev/null
        source "$module_path"
    fi
}

# -------------------------------------------------
# Main
# -------------------------------------------------
main() {
    echo "========================================"
    echo "  machine-setup"
    echo "  OS:    $OS ($ARCH)"
    echo "  Shell: $SHELL_CHOICE"
    echo "========================================"
    echo ""

    # --- OS prerequisites (before Homebrew) ---
    if [[ "$OS" == "Darwin" ]]; then
        if should_run "base"; then
            run_module "$SCRIPT_DIR/modules/macos/xcode.sh"
            run_module "$SCRIPT_DIR/modules/macos/rosetta.sh"
        fi
    elif [[ "$OS" == "Linux" ]]; then
        if should_run "base"; then
            run_module "$SCRIPT_DIR/modules/linux/apt.sh"
        fi
    fi

    # --- Shared modules ---
    if should_run "base"; then
        run_module "$SCRIPT_DIR/modules/shared/base.sh"
    fi

    if should_run "packages"; then
        run_module "$SCRIPT_DIR/modules/shared/packages.sh"
    fi

    if should_run "shell"; then
        run_module "$SCRIPT_DIR/modules/shared/shell.sh"
    fi

    if should_run "terminal"; then
        run_module "$SCRIPT_DIR/modules/shared/terminal.sh"
    fi

    if should_run "editor"; then
        run_module "$SCRIPT_DIR/modules/shared/editor.sh"
    fi

    if should_run "devtools"; then
        run_module "$SCRIPT_DIR/modules/shared/devtools.sh"
    fi

    if should_run "ssh"; then
        run_module "$SCRIPT_DIR/modules/shared/ssh.sh"
    fi

    if should_run "fonts"; then
        run_module "$SCRIPT_DIR/modules/shared/fonts.sh"
    fi

    if should_run "symlinks"; then
        run_module "$SCRIPT_DIR/modules/shared/symlinks.sh"
    fi

    # --- OS-specific modules ---
    if [[ "$OS" == "Darwin" ]]; then
        if should_run "defaults"; then
            run_module "$SCRIPT_DIR/modules/macos/defaults.sh"
        fi
        if should_run "apps"; then
            run_module "$SCRIPT_DIR/modules/macos/apps.sh"
        fi
    elif [[ "$OS" == "Linux" ]]; then
        if should_run "defaults"; then
            run_module "$SCRIPT_DIR/modules/linux/defaults.sh"
        fi
    fi

    echo ""
    echo "========================================"
    echo "  Setup complete!"
    echo "  Restart your terminal to apply changes."
    echo "========================================"
}

main
