#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   7-Dec-2024 10:08pm
# Modified :
#
# Copyright © 2024 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Apple's system shell startup file fights me when it try to set the location of my files
#*****************************************************************************************
unset HISTFILE
export HISTFILE="$XDG_CACHE_HOME/zsh/history"

#*****************************************************************************************
# center the terminal window on my screen
#*****************************************************************************************
osascript <<CENTER_WINDOW &>/dev/null
tell application "System Events"
	set myFrontMost to name of first item of ¬
		(processes whose frontmost is true)

	if (myFrontMost as text) is equal to "Terminal" or (myFrontMost as text) is equal to "iTerm" then
		try
			tell application "Finder"
				set screenSize to bounds of window of desktop
				set screenWidth to item 3 of screenSize
				set screenHeight to (item 4 of screenSize) - 200
			end tell

			tell application myFrontMost
				activate
				set windowSize to bounds of window 1
				set windowXl to item 1 of windowSize
				set windowYt to item 2 of windowSize
				set windowXr to item 3 of windowSize
				set windowYb to item 4 of windowSize

				set windowWidth to windowXr - windowXl
				set windowHeight to windowYb - windowYt
				set bounds of window 1 to {¬
					round ((screenWidth - windowWidth) / 2), ¬
					round ((screenHeight - windowHeight) / 2), ¬
					round ((screenWidth + windowWidth) / 2), ¬
					round ((screenHeight + windowHeight) / 2)}

				set the result to bounds of window 1
			end tell
		end try
	end if
end tell
CENTER_WINDOW

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
