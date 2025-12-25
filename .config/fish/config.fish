# Fish Configuration
# by Saifullah Balghari 
# -----------------------------------------------------

# Remove the fish greetings
set -g fish_greeting

# Start neofetch
neofetch

# Sets starship as the promt
eval (starship init fish)

# Start atuin
atuin init fish | source

# List Directory
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree

# Terminal Selection Colors (Red)
set -g fish_pager_color_selected_background --background=red
set -g fish_pager_color_selected_prefix white
set -g fish_pager_color_selected_completion white
set -g fish_pager_color_selected_description white