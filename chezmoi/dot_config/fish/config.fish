set TERM xterm-256color
set EDITOR vim
set EZA_CONFIG_DIR $HOME/.config/eza
if type -q atuin
    atuin init fish | source
end
starship init fish | source
~/.local/bin/mise activate fish | source
zoxide init fish | source
fzf --fish | source
