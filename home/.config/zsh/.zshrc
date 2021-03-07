#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# This file the contains the bunk of my Z shell setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :   2-Mar-2021  9:43pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# interactive environment
#*****************************************************************************************
export HISTSIZE=2000
export SAVEHIST=1000

#*****************************************************************************************
# key bindings
#*****************************************************************************************
bindkey -e
bindkey "^[[H"    beginning-of-line         # home
bindkey "^[[F"    end-of-line               # end
bindkey "^[[A"    up-line-or-search         # up arrow
bindkey "^[[B"    down-line-or-search       # down arrow
bindkey "^[[3~"   delete-char               # delete key
bindkey "^[3;5~"  delete-char               # delete key

#*****************************************************************************************
# completion setup
#*****************************************************************************************
zstyle ":completion:*" matcher-list "m:{a-zA-Z-_}={A-Za-z_-}" "r:|=*" "l:|=* r:|=*"
zstyle ':completion:*' list-colors ''x
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*:*:*:*:*" menu "select=0"
zstyle ":completion:*" completer _expand _complete _ignored _correct _approximate
zstyle ":completion:*" group-name ""
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' auto-description 'specify: %d'

autoload -Uz bashcompinit && bashcompinit
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

#*****************************************************************************************
# source utils
#*****************************************************************************************
# shellcheck disable=SC2044,SC1090
for file in $(find /usr/local/lib/geedbla/zsh/zsh-commands -type f -or -type l); do
	file="${file%.*}"
    autoload -U "$file"
done

#*****************************************************************************************
# prompt setup
#*****************************************************************************************
snazzy_prompt_precmd() {
    export SNAZZY_PROMPT="cwd,235,179,235,166;git,235,219,235,40;error,235,166"
    PS1="$(/usr/local/bin/SnazzyPrompt --error $?)"
}

install_snazzy_prompt_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "snazzy_prompt_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(snazzy_prompt_precmd)
}

install_snazzy_prompt_precmd
#*****************************************************************************************
# iTerm integration
#*****************************************************************************************
test -e ~/.config/zsh/.iterm2_shell_integration.zsh && source ~/.config/zsh/.iterm2_shell_integration.zsh || true

#*****************************************************************************************
# path setup
#*****************************************************************************************
export PATH="/usr/local/opt/openssl@1.1/bin:/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/3.0.0/bin:/usr/local/opt/python@3.9/libexec/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin/geedbla:/usr/local/bin/iterm2:/Applications/Sublime Text.app/Contents/SharedSupport/bin:/Applications/Sublime Merge.app/Contents/SharedSupport/bin"

#*****************************************************************************************
# startup banner
#*****************************************************************************************
perl /usr/local/bin/geedbla/startup-banner.pl

