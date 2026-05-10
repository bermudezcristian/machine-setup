# machine-setup

Bootstrap for setting up a fresh macOS machine with a single command.

## Quick Start

On a fresh macOS install, `git` isn't available yet. Install the Xcode Command Line Tools first (this provides `git`):

```bash
xcode-select --install
```

Then clone and run:

```bash
git clone https://github.com/bermudezcristian/machine-setup.git ~/machine-setup
cd ~/machine-setup
./setup.sh
```

## What It Does

| Module | Description |
|--------|-------------|
| **base** | Installs Xcode CLI tools, Rosetta 2, and Homebrew |
| **packages** | Installs CLI tools and apps from Brewfile |
| **shell** | Configures fish (default) or zsh with Starship prompt |
| **editor** | Configures Neovim with lazy.nvim plugin management |
| **devtools** | Installs mise (version manager), GPG, fzf + fd |
| **fonts** | Installs Meslo LG Nerd Font |
| **symlinks** | Links config files to `~/.config/` |
| **defaults** | Applies system defaults (Finder, Dock, trackpad) |
| **apps** | Installs Mac App Store apps |

## Options

```bash
./setup.sh                  # Full setup with fish
./setup.sh --shell zsh      # Use zsh instead of fish
```

## Tools Included

**Shell & Prompt**: fish, zsh, Starship, fzf, zoxide

**Modern CLI**: eza (ls), bat (cat), fd (find), ripgrep (grep), delta (diff), lazygit

**Dev Tools**: mise (Node.js, Python, AWS CLI, Terraform), Neovim, git, gh, glab

**Terminal**: Ghostty with Catppuccin Mocha theme

## Customizing

- **Packages**: Edit files in `packages/` (Brewfile, Brewfile.macos)
- **Shell config**: Edit `config/fish/` or `config/zsh/`
- **Machine-specific overrides**: Copy `*.example` files and remove the `.example` suffix
  - `config/fish/config.local.fish` — fish overrides
  - `config/git/config.local` — git name, email, signing key

## Updating

```bash
./update.sh
```

Updates Homebrew, mise, Neovim plugins, and Fisher plugins in one command.

## Supported Platforms

- macOS (Apple Silicon + Intel)
