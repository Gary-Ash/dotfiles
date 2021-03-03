#!/usr/bin/env zsh
#*****************************************************************************************
# .zshenv
#
# This file contains my Z shell environment setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :   2-Mar-2021 12:11pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# module load up
#*****************************************************************************************
fpath=(
	/usr/local/share/zsh-completions
	/usr/share/zsh/site-functions
	/usr/local/lib/geedbla/zsh/lib
	/usr/local/lib/geedbla/zsh/zsh-commands
	/usr/local/lib/geedbla/zsh/zsh-completion
	"${fpath[@]}"
)

#*****************************************************************************************
# basic shell options
#*****************************************************************************************
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

setopt auto_cd
setopt auto_pushd
setopt pushdminus
setopt globdots
setopt extendedglob

setopt menucomplete
setopt auto_menu
setopt always_to_end
setopt complete_in_word

autoload -Uz zmv
autoload -Uz colors && colors

#*****************************************************************************************
# general environment setup
#*****************************************************************************************
export SHELL_SESSION_HISTORY=0
export EDITOR=(subl --wait)
export VISUAL="subl"
export LESSHISTFILE="-"
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export CLICOLOR=1
export LC_ALL="en_US.UTF-8";
export LANG=en_US.UTF-8

export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/Cellar/openssl@1.1/1.1.1j"
export GEMRC="$XDG_CONFIG_HOME/.gemrc"
export RUBY_HOME=/usr/local/opt/ruby/bin

#*****************************************************************************************
# enhance man with some color and highlighting
#*****************************************************************************************
man() {
	(export LESS_TERMCAP_mb=$'\E[01;31m'; \
	export LESS_TERMCAP_md=$'\E[01;31m'; \
	export LESS_TERMCAP_me=$'\E[0m'; \
	export LESS_TERMCAP_se=$'\E[0m'; \
	export LESS_TERMCAP_so=$'\E[01;44;33m'; \
	export LESS_TERMCAP_ue=$'\E[0m'; \
	export LESS_TERMCAP_us=$'\E[01;32m'; \
	/usr/bin/man "$@")
}

#*****************************************************************************************
# cleanhist  clean shell history an iTerm stuff too
#*****************************************************************************************
cleanhist() {
	osascript << "END" &> /dev/null
(*****************************************************************************************
 * clean iTerm2
 ****************************************************************************************)
try
    tell application "iTerm"
        activate
        delay 0.01

        tell application "System Events" to tell process "iTerm2"
            click menu item "Clear Buffer" of menu 1 of menu bar item "Edit" of menu bar 1
            click menu item "Clear Scrollback Buffer" of menu 1 of menu bar item "Edit" of menu bar 1
            if exists splitter group 1 of window 1 then
                click button 3 of splitter group 1 of window 1
                click button "OK" of window 1

                click button 6 of splitter group 1 of window 1
                click button "OK" of window 1
            end if
        end tell
    end tell
end try
END
	rm -f "${HISTFILE}" &> /dev/null;exec $SHELL -l
}

#*****************************************************************************************
# O.C.D. system cleaning function wraps the main script and clears the shell history
#*****************************************************************************************
ocd() {
	/usr/local/bin/geedbla/ocd.sh "$@"
	if [[ $? -eq 0 ]]; then
		history -p
	else 
		osascript <<"RECALL"               &> /dev/null
		try
		    tell application "iTerm" to activate
		    delay 0.01
		    tell application "System Events" to tell application process "iTerm2"
		        key code 126
		    end tell
		end try
RECALL
	fi
}
#*****************************************************************************************
# useful aliases
#*****************************************************************************************
alias regexsr="perl -pi -e "
alias mkstrings='find -E . -iregex ".*\\.(m|h|mm|swift)$" -print0 | xargs -0 genstrings -a -o Resources/en.lproj'
alias ll="exa --long -all --git --group --group-directories-first --color=always --classify --level=3"

alias brewup="brew update --greedy;brew upgrade;brew upgrade --cask --force;brew cleanup;brew doctor"

alias mute="osascript -e \"set volume output muted true\""
alias volumenormal="osascript -e \"set volume output volume 50\""
alias volumemax="osascript -e \"set volume output volume 100\""

alias show="defaults write com.apple.finder AppleShowAllFiles -bool true  &> /dev/null && killall Finder  &> /dev/null"
alias hide="defaults delete com.apple.finder AppleShowAllFiles  &> /dev/null && killall Finder  &> /dev/null"

alias edscripts='${VISUAL} /usr/local/bin/geedbla /usr/local/lib/geedbla'
alias zshrc='${EDITOR} $XDG_CONFIG_HOME/zsh/.zshenv $XDG_CONFIG_HOME/zsh/.zshrc;cleanhist'

alias perms="stat -f '%Sp %OLp %N'"

alias recordSimulator="xcrun simctl io booted recordVideo "

alias sppedtimemachine="sudo sysctl debug.lowpri_throttle_enabled=0"

