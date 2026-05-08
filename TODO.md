# TODO — Pending Improvements

## High Impact

- [ ] **Neovim LSP/completion/telescope** — Add nvim-lspconfig + mason.nvim for language servers, nvim-cmp for completion, telescope.nvim for fuzzy finding (leverages existing ripgrep + fd), gitsigns.nvim, and lualine.nvim. Currently only 2 plugins (catppuccin + treesitter).

- [ ] **tmux configuration** — tmux is installed via Brewfile but has no config. Add `config/tmux/tmux.conf` with Catppuccin Mocha theme, sensible defaults, keybindings, and symlink it in `symlinks.sh`.

## Medium Impact

- [ ] **Docker post-install config** — Docker Desktop is installed on macOS but no post-install setup exists. Consider adding docker-compose, ctop, dive, or lazydocker.

## Low Impact

- [ ] **`.shellcheckrc`** — Add a project-wide ShellCheck config at repo root (e.g., `disable=SC1091` for sourced files, `shell=bash`, `external-sources=true`).
