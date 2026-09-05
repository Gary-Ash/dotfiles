#!/usr/bin/env zsh
#*****************************************************************************************
# functions.zsh
#
# Shell functions, language init, and utilities
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  13-Sep-2026  9:42pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Language setup
#*****************************************************************************************
source /opt/venv/python3/bin/activate

if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - zsh)"
fi

#*****************************************************************************************
# Update dot files
#*****************************************************************************************
update-dotfiles() {
	if /opt/geedbla/scripts/update-dots.sh; then
		cd "$HOME/Downloads/dotfiles"
	fi
}

#*****************************************************************************************
# Work In Progress helpers
#*****************************************************************************************
mkwip() {
	mkdir -p "$HOME/Developer/WIP"
	cd "$HOME/Developer/WIP"
}

workdone() {
	if [[ "$(pwd)" == "$HOME/Developer/WIP" ]]; then
		cd "$HOME"
	fi
	rm -rf "$HOME/Developer/WIP"
}

#*****************************************************************************************
# Directory utilities
#*****************************************************************************************
mkcd() {
	mkdir -p "$1"
	z "$1" || return
}

cdf() {
	cd "$(osascript -e 'tell application "Finder" to POSIX path of (insertion location as alias)')"
}

cdl() {
	z "$1"
	eza --long -all --git --group --group-directories-first --color=always --icons=always --classify --level=3 --sort=name
}

2finder() {
	/usr/bin/osascript &>/dev/null <<"END"
tell application "Finder"
	activate
	repeat with w in (get every Finder window)
		activate w
		tell application "System Events"
			keystroke "a" using {command down}
			key code 123
			keystroke "a" using {command down, option down}
		end tell
		close w
	end repeat

	set desktopBounds to bounds of window of desktop
	set w to round (((item 3 of desktopBounds) - 1100) / 2) rounding as taught in school
	set h to round (((item 4 of desktopBounds) - 1000) / 2) rounding as taught in school
	set finderBounds to {w, h, 1100 + w, 1000 + h}

	make new Finder window to (POSIX file (system attribute "PWD"))
	set (bounds of window 1) to finderBounds
end tell
END
}

cleanup() {
	#*****************************************************************************************
	# main work
	#*****************************************************************************************
	mole optimize
	mole installer
	mole purge
	mole clean

	rm -rf .npm
	cleanhist
}

#*****************************************************************************************
# Colorized man pages
#*****************************************************************************************
man() {
	(
		export LESS_TERMCAP_mb=$'\033[01;38;2;220;50;47m'
		export LESS_TERMCAP_md=$'\033[01;38;2;181;137;0m'
		export LESS_TERMCAP_so=$'\033[38;2;0;43;54;48;2;181;137;0m'
		export LESS_TERMCAP_us=$'\033[04;38;2;42;161;152m'
		export LESS_TERMCAP_me=$'\033[0m'
		export LESS_TERMCAP_se=$'\033[0m'
		export LESS_TERMCAP_ue=$'\033[0m'
		/usr/bin/man "$@"
	)
}

#*****************************************************************************************
# Clean Zsh history
#*****************************************************************************************
cleanhist() {
	rm -f "${HISTFILE}" &>/dev/null
	mkdir -p "$HOME/.cache/zsh" &>/dev/null
	exec "$SHELL" -l
}

#*****************************************************************************************
# Generate a UUID and load it onto the paste board
#*****************************************************************************************
genuuid() {
	uuid=$(uuidgen | tr 'A-Z' 'a-z' | tr -d '\n')
	(osascript -e "display notification with title \"⌘-V to paste\" subtitle \"$uuid\"" &) >/dev/null 2>&1
	echo -n "$uuid" | pbcopy
}
