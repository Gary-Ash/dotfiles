#!/usr/bin/env zsh
#*****************************************************************************************
# functions.zsh
#
# Shell functions, language init, and utilities
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  21-Apr-2026  8:59pm
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
# Update dot files
#*****************************************************************************************
update-dotfiles() {
	if /opt/geedbla/scripts/update-dots.sh; then
		cd ~/Downloads/dotfiles
	fi
}

#*****************************************************************************************
# Update system gems, pip, Homebrew, and NPM packages (silent unless a command fails)
#*****************************************************************************************
sysupdate() {
	source "/opt/geedbla/lib/shell/lib/get_sudo_password.sh"

	_q() {
		local out
		if ! out=$("$@" 2>&1); then
			printf '%s\n' "$out" >&2
			return 1
		fi
	}

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

	command -v gh &>/dev/null && _q gh extension upgrade --all

	if command -v gem &>/dev/null; then
		_q gem update
		_q gem update --system
		_q gem cleanup
	fi

	if command -v pip3 &>/dev/null; then
		_q pip3 install --upgrade --quiet pip
		_q pip3 install -U --quiet $(pip3 freeze | cut -d = -f 1)
	fi

	if command -v npm &>/dev/null; then
		_q npm install -g --silent npm@latest
		_q npm update -g --silent
	fi

	find "$HOME/Library/CloudStorage/Dropbox/Data" -name "Keyboard Maestro Macros \(*.kmsync" -delete &>/dev/null
	pkill -f '.*GradleDaemon.*' &>/dev/null

	for item in "${stuff[@]}"; do
		_q rm -rf "$item"
	done

	if command -v brew &>/dev/null; then
		export HOMEBREW_NO_ENV_HINTS=1
		export HOMEBREW_NO_INSTALL_CLEANUP=1
		export HOMEBREW_COLOR=0

		_q brew update --quiet
		_q brew upgrade --quiet
		_q brew autoremove --quiet
		_q brew cleanup --quiet --scrub
		_q rm -rf "$(brew --cache)"

		_q rm -rf "$XDG_CACHE_HOME/"
		_q mkdir -p "$XDG_CACHE_HOME/zsh"
		history -p &>/dev/null

		export SUDO_PASSWORD=$(get_sudo_password)
		echo "$SUDO_PASSWORD" | sudo -S -v 2>/dev/null

		sudo xattr -cr /Applications/* &>/dev/null
		sudo chown -R garyash:admin /opt/geedbla/* &>/dev/null
		sudo chown -R root:admin /Applications/* &>/dev/null
		sudo chmod -R 775 /Applications/* &>/dev/null
		setopt local_options no_monitor
	fi

	unset SUDO_PASSWORD
	setopt local_options no_monitor

	startup-banner --dark &>/dev/null
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
