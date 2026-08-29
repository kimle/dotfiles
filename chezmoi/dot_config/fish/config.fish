set TERM xterm-256color
set EDITOR vim
set EZA_CONFIG_DIR $HOME/.config/eza
set -gx FORGIT_PREVIEW_PAGER 'delta --width=$FZF_PREVIEW_COLUMNS'
if type -q atuin
    atuin init fish | source
end
starship init fish | source
~/.local/bin/mise activate fish | source
zoxide init fish | source
fzf --fish | source
