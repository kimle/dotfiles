join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(fzf_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h
unset -f bind-git-helper

bind-git-add() {
    eval "fzf-git-add() { fzf_ga; zle reset-prompt }"
    eval "zle -N fzf-git-add"
    eval "bindkey '^g^a' fzf-git-add"
}

bind-git-add
unset -f bind-git-add

bind-git-reset() {
    eval "fzf-git-reset() { fzf_gre; zle reset-prompt }"
    eval "zle -N fzf-git-reset"
    eval "bindkey '^g^s' fzf-git-reset"
}

bind-git-reset
unset -f bind-git-reset

