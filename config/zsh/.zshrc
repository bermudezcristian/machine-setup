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

# -------------------------------------------------
# Zsh plugins (installed via Homebrew)
# -------------------------------------------------
[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# -------------------------------------------------
# fzf
# -------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
# Aliases
# -------------------------------------------------
alias vim='nvim'
alias vi='nvim'

if command -v eza &>/dev/null; then
    alias ls='eza --color=auto --icons=auto'
    alias ll='eza -la --icons=auto --git'
    alias lt='eza --tree --level=2 --icons=auto'
fi

if command -v bat &>/dev/null; then
    alias cat='bat'
fi

if command -v lazygit &>/dev/null; then
    alias lg='lazygit'
fi

alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpull='git pull'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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
[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# -------------------------------------------------
# Local overrides (not tracked in git)
# -------------------------------------------------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
