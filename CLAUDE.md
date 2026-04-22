# CLAUDE.md — Project Instructions for Claude Code

## Repository Purpose
Cross-platform machine bootstrap. Single script sets up a fresh macOS or Linux machine with developer tools, shell configuration (fish/zsh), terminal (Ghostty), editor (Neovim), and system defaults.

## Structure
```
machine-setup/
    bootstrap.sh            # One-liner curl entry point
    setup.sh                # Main orchestrator (OS detection, flag parsing, module sourcing)
    update.sh               # Update all managed tools
    packages/               # Brewfile (shared), Brewfile.macos, Brewfile.linux, apt.txt
    config/                 # Dotfiles (fish, zsh, ghostty, git, nvim, starship)
    modules/
        shared/             # Cross-platform modules (base, packages, shell, terminal, editor, devtools, fonts, symlinks)
        macos/              # macOS-only modules (xcode, rosetta, defaults, apps)
        linux/              # Linux-only modules (apt, defaults)
    extras/                 # Optional scripts (firefox.sh)
```

## Conventions
- **Indentation**: 4 spaces in shell scripts, tabs in Lua (Neovim config)
- **Shell scripts**: bash with `set -e` and `set -u`. Each module is idempotent — safe to run repeatedly.
- **Idempotency**: Guard installs with `command -v` checks. Guard file modifications with `grep -q` checks.
- **OS guards**: Use `$OS` (Darwin/Linux) and `$ARCH` (arm64/x86_64) globals set by setup.sh.
- **Modules are sourced**: They run in setup.sh's context and have access to all globals (`$OS`, `$ARCH`, `$SHELL_CHOICE`, `$SCRIPT_DIR`).
- **Conditional tool activation**: Always check `command -v`/`command -q` before using a tool in config files.
- **Theme**: Catppuccin Mocha across all tools.
- **Local overrides**: `config.local.fish`, `.zshrc.local`, `git/config.local` — not tracked in git.

## Running
```sh
# One-liner (fresh machine):
bash <(curl -fsSL https://raw.githubusercontent.com/bermudezcristian/machine-setup/main/bootstrap.sh)

# From cloned repo:
./setup.sh                      # Full setup with fish (default)
./setup.sh --shell zsh          # Full setup with zsh
./setup.sh --only shell,terminal
./setup.sh --skip apps,defaults

# Update everything:
./update.sh
```
