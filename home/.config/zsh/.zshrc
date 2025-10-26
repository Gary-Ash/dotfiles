#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   4-Aug-2025  4:27pm
# Modified :   6-Oct-2025  8:18pm
#
# Copyright © 2025 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Apple's system shell startup file fights me when it try to set the location of my files
#*****************************************************************************************
unset HISTFILE
export HISTFILE="$XDG_CACHE_HOME/zsh/history"

#*****************************************************************************************
# setup python3 virtual environment
#*****************************************************************************************
source /opt/geedbla/venv/bin/activate

#*****************************************************************************************
# prompt setup
#*****************************************************************************************
export SNAZZY_PROMPT="cwd,255,166,255,196:git,255,200,255,35:short,1,1"
export SNAZZY_PROMPT_TRUE="cwd,255;255;255,255;148;0,255;255;255,1:git,255;255;255,255;142;198,255;255;255,178;216;143:short,255;0;0,255;0;0"

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
	() {
	setopt NO_NOTIFY NO_MONITOR
  	perl /opt/geedbla/scripts/startup-banner.pl --dark &
    wait
	setopt NOTIFY MONITOR
}
fi
