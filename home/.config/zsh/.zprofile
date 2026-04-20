#!/usr/bin/env zsh
#*****************************************************************************************
# .zprofile
#
# Login shell setup — PATH and fpath after /etc/zprofile path_helper runs
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026 10:00pm
# Modified :  24-Mar-2026 10:18pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Path management — set here so our ordering wins over path_helper
#*****************************************************************************************
typeset -U path fpath
path=(
	"/opt/homebrew/bin"
	"/opt/homebrew/sbin"
	"$HOME/.local/bin"
	"/opt/bin"
	"/opt/geedbla/scripts"
	"/opt/venv/python3/bin"
	"/usr/local/bin"
	"/usr/bin"
	"/bin"
	"/usr/sbin"
	"/sbin"
	"/opt/homebrew/lib/node_modules/npm"
	$path
)

fpath=(
	/opt/homebrew/share/zsh-completions
	/opt/homebrew/zsh/site-functions
	/opt/geedbla/lib/shell/lib
	/opt/geedbla/zsh-completions
	"${fpath[@]}"
)
