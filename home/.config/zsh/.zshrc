#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# ZSH interactive setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  27-Apr-2024  10:26pm
# Modified :
#
# Copyright © 2024 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# center the terminal window on my screen
#*****************************************************************************************
osascript <<CENTER_WINDOW &>/dev/null
tell application "Finder"
    set screenSize to bounds of window of desktop
    set screenWidth to item 3 of screenSize
    set screenHeight to (item 4 of screenSize) - 200
end tell

tell application "System Events"
    set myFrontMost to name of first item of ¬
        (processes whose frontmost is true)

    if (myFrontMost as text) is equal to "" then
        if application "Terminal" is running then
            set myFrontMost to "Terminal"
        else
            set myFrontMost to "iTerm"
        end if
    end if
end tell

try
    tell application myFrontMost
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
CENTER_WINDOW

#*****************************************************************************************
# Apple's system shell startup file fights me when it try to set the location of my files
#*****************************************************************************************
unset HISTFILE
export HISTFILE="$XDG_CACHE_HOME/zsh/history"

#*****************************************************************************************
# prompt setup
#*****************************************************************************************
export SNAZZY_PROMPT="cwd,235,179,235,166;git,235,219,235,40;error,235,166"

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
	perl /opt/geedbla/scripts/startup-banner.pl --light
fi
