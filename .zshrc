# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1500
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kim/.zshrc'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

autoload -U colors && colors 
PROMPT="%{$fg_bold[green]%}%n%{$reset_color%}@%{$fg_bold[red]%}%m %{$fg_bold[magenta]%}% → %{$fg_bold[green]%}%1~ "
# RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

autoload -U compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# source /usr/share/tmux/site-contrib/powerline.zsh


DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
#chpwd() {
#  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
#}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

## This reverts the +/- operators.
setopt pushdminus
