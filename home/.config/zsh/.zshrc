#!/usr/bin/env zsh
#*****************************************************************************************
# .zshrc
#
# Z shell interactive setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  29-May-2021  2:35pm
# Modified :   8-Mar-2024  1:08pm
#
# Copyright © 2021-2024 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Apple's system shell startup file fights me when it try to set the location of my files
#*****************************************************************************************
unset HISTFILE
export HISTFILE="$XDG_CACHE_HOME/zsh/history"

if [[ -z "$SHELL_SESSIONS_DISABLE" ]]; then
    source "$XDG_CONFIG_HOME/zsh/.zshenv"
fi

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

    if application "ITerm" is  running
        set myFrontMost to "iTerm"
    end if

    if application "Terminal" is  running
        set myFrontMost to "Terminal"
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

if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
    #*****************************************************************************************
    # startup banner
    #*****************************************************************************************
    perl /opt/geedbla/scripts/startup-banner.pl --light
fi
