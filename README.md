# machine-setup

Cross-platform bootstrap for setting up a fresh macOS or Linux machine with a single command.

## Quick Start

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bermudezcristian/machine-setup/main/bootstrap.sh)
```

No prerequisites needed — just a terminal and internet connection.

## What It Does

| Module | Description |
|--------|-------------|
| **base** | Installs Homebrew (+ Xcode CLI tools on macOS, Rosetta on Apple Silicon) |
| **packages** | Installs CLI tools and apps from Brewfile (+ apt packages on Linux) |
| **shell** | Configures fish (default) or zsh with Starship prompt |
| **terminal** | Sets up Ghostty terminal with Catppuccin Mocha theme |
| **editor** | Configures Neovim with lazy.nvim plugin management |
| **devtools** | Installs mise (version manager), GPG, fzf + fd |
| **fonts** | Installs Meslo LG Nerd Font |
| **symlinks** | Links config files to `~/.config/` |
| **defaults** | Applies system defaults (Finder, Dock, trackpad on macOS) |
| **apps** | Installs Mac App Store apps (macOS only) |

## Options

```bash
./setup.sh                          # Full setup with fish
./setup.sh --shell zsh              # Use zsh instead of fish
./setup.sh --only shell,terminal    # Only run specific modules
./setup.sh --skip apps,defaults     # Skip specific modules
```

## Tools Included

**Shell & Prompt**: fish, zsh, Starship, fzf, zoxide

**Modern CLI**: eza (ls), bat (cat), fd (find), ripgrep (grep), delta (diff), lazygit

**Dev Tools**: mise (Node.js, Python, AWS CLI, Terraform), Neovim, git, gh, glab

**Terminal**: Ghostty with Catppuccin Mocha theme

## Customizing

- **Packages**: Edit files in `packages/` (Brewfile, Brewfile.macos, Brewfile.linux, apt.txt)
- **Shell config**: Edit `config/fish/` or `config/zsh/`
- **Machine-specific overrides**: Copy `*.example` files and remove the `.example` suffix
  - `config/fish/config.local.fish` — fish overrides
  - `config/git/config.local` — git name, email, signing key

## Updating

```bash
./update.sh
```

Updates Homebrew, mise, Neovim plugins, Fisher plugins, and apt packages in one command.

## Supported Platforms

- macOS (Apple Silicon + Intel)
- Linux (Debian/Ubuntu — apt-based)
