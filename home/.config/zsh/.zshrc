#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   8-Feb-2025  4:41pm
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
export SNAZZY_PROMPT="cwd,15,33,15,166;git,15,219,15,40;error,15,166"

powerline_precmd() {
	PS1="$(/opt/geedbla/bin/SnazzyPrompt --error $?)"
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

if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
	#*****************************************************************************************
	# startup banner
	#*****************************************************************************************
	perl /opt/geedbla/scripts/startup-banner.pl --dark
fi
