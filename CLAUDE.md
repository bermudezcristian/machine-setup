# CLAUDE.md — Project Instructions for Claude Code

## Repository Purpose
macOS machine bootstrap. Single script sets up a fresh macOS machine with developer tools, shell configuration (fish/zsh), terminal (Ghostty), editor (Neovim), and system defaults.

## Structure
```
machine-setup/
    setup.sh                # Main orchestrator (arch detection, flag parsing, module sourcing)
    update.sh               # Update all managed tools
    packages/               # Brewfile (shared), Brewfile.macos
    config/                 # Dotfiles (fish, zsh, ghostty, git, nvim, starship)
    modules/
        shared/             # Shared modules (base, packages, shell, editor, devtools, fonts, symlinks)
        macos/              # macOS-only modules (defaults, apps)
    extras/                 # Optional scripts (firefox.sh)
```

## This repository is PUBLIC
Nothing identifying the owner's employment or clients may be committed here. Specifically:
- No client, employer, or project names.
- No paths under `~/Work` (or any real work directory layout), internal repo names, or hostnames.
- Applies to code, comments, examples, and commit messages alike.

Config that needs such values must read them at runtime from an untracked file outside this
repo (see **Local overrides** below) — commit the mechanism, never the values. Use neutral
placeholders (`example-org`, `/path/to/project`) in any documentation or example.

## Conventions
- **Indentation**: 4 spaces in shell scripts, tabs in Lua (Neovim config)
- **Shell scripts**: bash with `set -e` and `set -u`. Each module is idempotent — safe to run repeatedly.
- **Idempotency**: Guard installs with `command -v` checks. Guard file modifications with `grep -q` checks.
- **OS guards**: Use `$ARCH` (arm64/x86_64) global set by setup.sh.
- **Modules are sourced**: They run in setup.sh's context and have access to all globals (`$ARCH`, `$SHELL_CHOICE`, `$SCRIPT_DIR`).
- **Conditional tool activation**: Always check `command -v`/`command -q` before using a tool in config files.
- **Theme**: Catppuccin Mocha across all tools.
- **Local overrides**: `config.local.fish`, `.zshrc.local`, `git/config.local` — not tracked in git.

## Running
```sh
# From cloned repo:
./setup.sh                      # Full setup with fish (default)
./setup.sh --shell zsh          # Full setup with zsh

# Update everything:
./update.sh
```

## Pending Work
See [TODO.md](TODO.md) for planned improvements (Neovim LSP, tmux config, etc.).
