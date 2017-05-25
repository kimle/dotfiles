#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -Gp'
alias grep='grep --color=auto'
export CLICOLOR=1
# export PATH='/usr/local/bin:$PATH'
PS1='\[\033[0;32m\]\h\[\033[0m\] \[\033[0;34m\]\w\[\033[0m\] \$ '
