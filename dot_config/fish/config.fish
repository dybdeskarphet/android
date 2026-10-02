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

# Fastfetch on interactive session startup
if status is-interactive
    and type -q fastfetch
    fastfetch
end
