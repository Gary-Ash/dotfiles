#!/usr/bin/env zsh
#*****************************************************************************************
# functions.zsh
#
# Shell functions, language init, and utilities
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  25-Mar-2026 11:42pm
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
		cd ~/Downloads/dotfiles
	fi
}

#*****************************************************************************************
# Update system gems, pip, Homebrew, and NPM packages
#*****************************************************************************************
sysupdate() {
	source "/opt/geedbla/lib/shell/lib/get_sudo_password.sh"

	stuff=(
		"$HOME/.npm"
		"$HOME/.gem"
		"$HOME/.android"
		"$HOME/.konan"
		"$HOME/.gradle"
		"$HOME/.swiftpm"
		"$HOME/.hawtjni"
		"$HOME/.config/zsh/.zsh_history"
	)

	if command -v gh &>/dev/null; then
		gh extension upgrade --all >/dev/null
	fi

	if command -v gem &>/dev/null; then
		gem update >/dev/null
		gem update --system >/dev/null
		gem cleanup >/dev/null
	fi

	if command -v pip3 &>/dev/null; then
		pip3 install --upgrade pip >/dev/null
		pip3 install -U $(pip3 freeze | cut -d = -f 1) >/dev/null
	fi

	if command -v npm &>/dev/null; then
		npm install -g npm@latest >/dev/null
		npm update -g >/dev/null
	fi

	find "$HOME/Library/CloudStorage/Dropbox/Data" -name "Keyboard Maestro Macros \(*.kmsync" -delete &>/dev/null
	pkill -f '.*GradleDaemon.*'

	for item in "${stuff[@]}"; do
		rm -rf "$item" &>/dev/null
	done

	if command -v brew &>/dev/null; then
		brew update >/dev/null
		brew upgrade >/dev/null
		brew autoremove >/dev/null
		brew cleanup >/dev/null
		rm -rf "$(brew --cache)" &>/dev/null

		rm -rf "$XDG_CACHE_HOME/" &>/dev/null
		mkdir -p "$XDG_CACHE_HOME/zsh"
		history -p

		export SUDO_PASSWORD=$(get_sudo_password)
		echo "$SUDO_PASSWORD" | sudo --validate --stdin &>/dev/null

		sudo xattr -cr /Applications/* &>/dev/null
		sudo chown -R garyash:admin /opt/geedbla/* &>/dev/null
		sudo chown -R root:admin /Applications/* &>/dev/null
		sudo chmod -R 775 /Applications/* &>/dev/null
		setopt local_options no_monitor
	fi

	unset SUDO_PASSWORD
	setopt local_options no_monitor

	startup-banner --dark
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

#*****************************************************************************************
# macOS/Finder scripting
#*****************************************************************************************
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
