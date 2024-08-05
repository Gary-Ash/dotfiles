#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  19-Mar-2025  8:31pm
# Modified :
#
# Copyright © 2024-2025 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Apple's system shell startup file fights me when it try to set the location of my files
#*****************************************************************************************
unset HISTFILE
export HISTFILE="$XDG_CACHE_HOME/zsh/history"

#*****************************************************************************************
# prompt setup
#*****************************************************************************************
export SNAZZY_PROMPT="cwd,255,166,255,196:git,255,35,255,200:err,255,166"
export SNAZZY_PROMPT_TRUE="cwd,255;255;255,255;148;0,255;255;255,1:git,255;255;255,178;216;143,255;255;255,147;196;124:err,255;255;255,128;0;0"

powerline_precmd() {
	PS1="$(/opt/geedbla/bin/Prompt --error $?)"
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

if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
	#*****************************************************************************************
	# startup banner
	#*****************************************************************************************
	perl /opt/geedbla/scripts/startup-banner.pl --dark
fi
