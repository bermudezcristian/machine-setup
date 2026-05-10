# config.fish — Fish shell configuration

# -------------------------------------------------
# Environment
# -------------------------------------------------
set -gx EDITOR nvim
set -gx PAGER bat
set -gx LANG en_US.UTF-8

# Restrictive umask
umask 0077

# -------------------------------------------------
# Homebrew
# -------------------------------------------------
if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# -------------------------------------------------
# User-local binaries (Claude Code, pipx, etc.)
# -------------------------------------------------
if test -d $HOME/.local/bin
    fish_add_path -gp $HOME/.local/bin
end

# -------------------------------------------------
# mise (version manager)
# -------------------------------------------------
if command -q mise
    mise activate fish | source
end

# -------------------------------------------------
# zoxide (smart cd)
# -------------------------------------------------
if command -q zoxide
    zoxide init fish | source
end

# -------------------------------------------------
# fzf
# -------------------------------------------------
if command -q fzf
    fzf --fish | source
end

# Use fd as fzf backend
if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end

# Catppuccin Mocha fzf theme
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a"

# -------------------------------------------------
# Starship prompt
# -------------------------------------------------
if command -q starship
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
    starship init fish | source
end

# -------------------------------------------------
# Source conf.d/ (aliases, abbreviations)
# -------------------------------------------------
# Fish auto-sources conf.d/ from ~/.config/fish/conf.d/

# -------------------------------------------------
# Local overrides (not tracked in git)
# -------------------------------------------------
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
