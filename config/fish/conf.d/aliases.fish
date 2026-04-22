# aliases.fish — Modern CLI replacements

# Editor
alias vim 'nvim'
alias vi 'nvim'

# Modern replacements
if command -q eza
    alias ls 'eza --color=auto --icons=auto'
    alias ll 'eza -la --icons=auto --git'
    alias lt 'eza --tree --level=2 --icons=auto'
end

if command -q bat
    alias cat 'bat'
end

# Git shortcuts
alias gs 'git status'
alias gd 'git diff'
alias gl 'git log --oneline --graph --decorate -20'
alias gp 'git push'
alias gpull 'git pull'

# Lazygit
if command -q lazygit
    alias lg 'lazygit'
end

# Directory navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
