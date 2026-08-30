#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive shell entry point
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :   4-Aug-2026  8:00pm
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

# Cache generated completions so we don't spawn npm/gh/tv on every startup;
# regenerate when a cache file is missing, empty, or older than 7 days (168h).
_comp_cache="$XDG_CACHE_HOME/zsh/completions"
[[ -d $_comp_cache ]] || mkdir -p "$_comp_cache"

_load_completion() {
	local file="$_comp_cache/$1.zsh"
	shift
	if [[ ! -s $file || -n $file(#qN.mh+168) ]]; then
		"$@" >| "$file" 2>/dev/null
	fi
	source "$file"
}

# TV completions with channel name support
_tv_channels() {
	local -a channels
	channels=("${(@f)$(tv list-channels 2>/dev/null)}")
	_describe 'channel' channels
}
_gen_tv_completion() {
	tv completions zsh 2>/dev/null | sed 's/shall we watch?:_default/shall we watch?:_tv_channels/'
}

_load_completion npm npm completion
_load_completion gh  gh completion -s zsh
_load_completion tv  _gen_tv_completion

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
		startup-banner --dark --image /opt/geedbla/pictures/apple-logo.png
	}
fi
