# Disable default greeting
set -g fish_greeting ""

# PATH and Environment
fish_add_path $HOME/.local/bin
set -gx EDITOR nvim
set -gx VISUAL nvim

# Navigation abbreviations
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ls lsd

# Package Management
abbr -a srcpac 'nala search'
abbr -a lspac 'nala list --installed'
abbr -a lsupac 'nala list --upgradable'
abbr -a uppac 'nala update && nala upgrade'
abbr -a inspac 'nala install'
abbr -a rmpac 'nala remove'
abbr -a clpac 'nala autoremove && nala clean'

# Quick exits
abbr -a :q exit
abbr -a q exit
abbr -a qq exit
abbr -a Q exit

# Utilities
abbr -a rm 'rm -i'
abbr -a cal 'cal --monday'
abbr -a date 'LANG=tr_TR.UTF-8 date'
abbr -a v nvim
abbr -a y yazi
abbr -a t 'nvim ~/doc/todo.txt'
abbr -a lg lazygit

# Git abbreviations
abbr -a gita 'git add .'
abbr -a gitc 'git commit -S'
abbr -a gitd 'git diff HEAD'
abbr -a gitp 'git push'

# Chezmoi
abbr -a ced 'cd ~/.local/share/chezmoi/ && nvim'
abbr -a cbu 'chezmoi apply -v'
abbr -a cup 'chezmoi update -v'

# Fastfetch on interactive session startup
if status is-interactive
    and type -q fastfetch
    fastfetch
    mise activate fish | source
end
