#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive shell entry point
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  24-Mar-2026  3:30pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Load modular configs
#*****************************************************************************************
source "$XDG_CONFIG_HOME/zsh/options.zsh"
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
source "$XDG_CONFIG_HOME/zsh/functions.zsh"
source "$XDG_CONFIG_HOME/zsh/television.zsh"

#*****************************************************************************************
# Initialize completions
#*****************************************************************************************
autoload -Uz compinit bashcompinit zmv
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
bashcompinit
compdef _swift swift

source <(npm completion)
eval "$(gh completion -s zsh)"

# TV completions with channel name support
_tv_channels() {
	local -a channels
	channels=("${(@f)$(tv list-channels 2>/dev/null)}")
	_describe 'channel' channels
}
eval "$(tv completions zsh 2>/dev/null | sed 's/shall we watch?:_default/shall we watch?:_tv_channels/')"

#*****************************************************************************************
# Key mapping and editing setup
#*****************************************************************************************
my-sudolast-cmd() {
	echo sudo $(fc -ln -1)
}

my-sudolast-cmd_widget() LBUFFER+=$(my-sudolast-cmd)
zle -N my-sudolast-cmd_widget
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e
bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[A"    up-line-or-search
bindkey "^[[B"    down-line-or-search
bindkey "^[[3~"   delete-char
bindkey "^O"      my-sudolast-cmd_widget

#*****************************************************************************************
# Autosuggestions
#*****************************************************************************************
export ZSH_AUTOSUGGEST_USE_ASYNC="1"
export ZSH_AUTOSUGGEST_MANUAL_REBIND="1"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="1"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#*****************************************************************************************
# Setup Zoxide directory changer
#*****************************************************************************************
_ZO_DATA_DIR="$HOME/Library/Application Support"
eval "$(zoxide init zsh)"

# Override zoxide completion to query its database instead of local dirs
function __zoxide_z_complete() {
	[[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

	if [[ "${#words[@]}" -eq 2 ]]; then
		# Query zoxide database for matches
		local -a dirs
		dirs=("${(@f)$(\command zoxide query --list -- "${words[2]}" 2>/dev/null)}")
		if [[ ${#dirs[@]} -gt 0 ]]; then
			compadd -U -Q -- "${dirs[@]}"
		fi
		return 0

	elif [[ "${words[-1]}" == '' ]]; then
		__zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''
		compadd -Q ""
		\builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
		\builtin printf '\e[5n'
		return 0
	fi
}

#*****************************************************************************************
# Setup my own snazzy powerline style prompt
#*****************************************************************************************
export SNAZZY_PROMPT="cwd,255,166,255,196:git,255,200,255,35:short,1,1"
export SNAZZY_PROMPT_TRUE="cwd,255;255;255,255;148;0,255;255;255,1:git,255;255;255,255;142;198,255;255;255,178;216;143:short,255;0;0,255;0;0"

powerline_precmd() {
	PS1="$(/opt/bin/Prompt --error $?)"
}

install_powerline_precmd() {
	for s in "${precmd_functions[@]}"; do
		if [ "$s" = "powerline_precmd" ]; then
			return
		fi
	done
	precmd_functions+=(powerline_precmd)
}

install_powerline_precmd

#*****************************************************************************************
# Startup banner
#*****************************************************************************************
if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
	() {
		startup-banner --dark
	}
fi
