#!/usr/bin/env zsh
#*****************************************************************************************
# aliases.zsh
#
# Command shortcuts and aliases
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  24-Mar-2026  8:52pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Core aliases
#*****************************************************************************************
alias sudo="sudo "
alias ll="eza --long -all --git --group --group-directories-first --color=always  --icons=always --classify --level=3 --sort=name"
alias l="eza --oneline --all --icons=always"

#*****************************************************************************************
# App shortcuts
#*****************************************************************************************
alias edscripts='${VISUAL} /opt/geedbla'
alias zshrc='${EDITOR} ${ZDOTDIR}/.zshenv ${ZDOTDIR}/options.zsh ${ZDOTDIR}/aliases.zsh ${ZDOTDIR}/functions.zsh ${ZDOTDIR}/television.zsh ${ZDOTDIR}/.zshrc; cleanhist'

#*****************************************************************************************
# macOS system controls
#*****************************************************************************************
alias mute="osascript -e \"set volume output muted true\""
alias volumenormal="osascript -e \"set volume output volume 50\""
alias volumemax="osascript -e \"set volume output volume 100\""
alias perms="stat -f '%Sp %OLp %N'"
alias afk="osascript -e 'tell app \"System Events\" to key code 12 using {control down, command down}'"

#*****************************************************************************************
# Finder utilities
#*****************************************************************************************
alias show-all-files="defaults write com.apple.finder AppleShowAllFiles true;killall Finder"
alias hide-all-files="defaults delete com.apple.finder AppleShowAllFiles;killall Finder"

#*****************************************************************************************
# Dev workflow
#*****************************************************************************************
alias recordSimulator="xcrun simctl io booted recordVideo "
alias uuid="genuuid"
