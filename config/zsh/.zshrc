# .zshrc — Zsh configuration

# -------------------------------------------------
# Environment
# -------------------------------------------------
export EDITOR=nvim
export PAGER=bat
export LANG=en_US.UTF-8

# Restrictive umask
umask 0077

# -------------------------------------------------
# Homebrew
# -------------------------------------------------
if [[ -d /opt/homebrew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Cache brew prefix for plugin sourcing
_BREW_PREFIX="$(brew --prefix 2>/dev/null)"

# -------------------------------------------------
# Zsh plugins (installed via Homebrew)
# -------------------------------------------------
[[ -f "$_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# -------------------------------------------------
# fzf
# -------------------------------------------------
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use fd as fzf backend
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Catppuccin Mocha fzf theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a"

# -------------------------------------------------
# mise (version manager)
# -------------------------------------------------
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# -------------------------------------------------
# zoxide (smart cd)
# -------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# -------------------------------------------------
# Completion
# -------------------------------------------------
autoload -Uz compinit
compinit

# -------------------------------------------------
# Starship prompt
# -------------------------------------------------
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# -------------------------------------------------
# Syntax highlighting (must be sourced last)
# -------------------------------------------------
[[ -f "$_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# -------------------------------------------------
# Local overrides (not tracked in git)
# -------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
