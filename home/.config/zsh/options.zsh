#!/usr/bin/env zsh
#*****************************************************************************************
# options.zsh
#
# Shell behavior, history, and completion styling
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  30-Mar-2026  2:41pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# History configuration
#*****************************************************************************************
export HISTSIZE=2000
export SAVEHIST=1000
unset HISTFILE
export HISTFILE="$XDG_CACHE_HOME/zsh/history"

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

#*****************************************************************************************
# Navigation and globbing
#*****************************************************************************************
setopt auto_cd
setopt auto_pushd
setopt pushdminus
setopt globdots
setopt extendedglob

#*****************************************************************************************
# Completion options
#*****************************************************************************************
setopt menu_complete
setopt always_to_end
setopt complete_in_word
setopt auto_list
setopt completealiases

#*****************************************************************************************
# Colors
#*****************************************************************************************
export CLICOLOR=1
export LSCOLORS=BxBxhxDxfxhxhxhxhxcxcx
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
autoload -Uz colors && colors

#*****************************************************************************************
# Completion styling
#*****************************************************************************************
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:default' list-colors "ma=48;5;3;30"
zstyle ':completion:*:descriptions' format $'\e[01;33m--- %d ---\e[00m'
zstyle ':completion:*:messages' format $'\e[01;35m--- %d ---\e[00m'
zstyle ':completion:*:warnings' format $'\e[01;31mNo matches for: %d\e[00m'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _complete _extensions _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' file-list all
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:*:z:*' group-order recent-directories
