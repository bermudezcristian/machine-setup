# aliases.fish — Modern CLI replacements

# Editor
alias vim 'nvim'
alias vi 'nvim'

# Modern replacements
if command -q eza
    alias ls 'eza --color=auto --icons=auto'
    alias ll 'eza -la --icons=auto --git'
    alias lt 'eza --tree --level=2 --icons=auto'

    # Coreutils `ls -ltr` (long, oldest first, newest last). eza spells this
    # differently: its `-t` is --time=FIELD (which timestamp to show), not
    # "sort by time", so `ls -ltr` fails with `invalid value 'r' for '--time'`.
    # --sort=modified is already oldest-first; --reverse would flip it to -lt.
    alias lr 'eza -l --icons=auto --sort=modified'
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
