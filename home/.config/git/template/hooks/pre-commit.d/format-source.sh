#!/usr/bin/env bash
shopt -s extglob
#*****************************************************************************************
# pre-commit
#
# This is a git pre-commit hook script that will format source file before submitting the
# actual commit to the target repository
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   8-Feb-2026  3:37pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

swift=".*\.swift$ "
objc=".*\.(m|mm|pch|h|hh)$"
cfiles=".*\.(hpp|hxx|c|cc|cpp|cxx|cs|jav|java)$"

IFS=$'\n'

for commit in $(git diff --cached --name-only --diff-filter=ACM); do
	for filename in "${commit[@]}"; do
		if [[ $filename =~ $swift ]]; then
			if which swiftformat >/dev/null; then
				swiftformat --config "$HOME/.config/.swiftformat" "${filename}" &>/dev/null
				git update-index --really-refresh --again "${filename}" &>/dev/null
			fi
		elif [[ $filename =~ $objc ]]; then
			if which uncrustify >/dev/null; then
				uncrustify -l OC+ --replace --no-backup -c "$HOME/.config/.uncrustify" "${filename}" &>/dev/null
				git update-index --really-refresh --again "${filename}" &>/dev/null
			fi
		elif [[ $filename =~ $cfiles ]]; then
			if which uncrustify >/dev/null; then
				uncrustify --replace --no-backup -c "$HOME/.config/.uncrustify" "${filename}" &>/dev/null
				git update-index --really-refresh --again "${filename}"
			fi
		else
			read -r line <"${filename}"
			if [[ $line =~ ^\#\!.*perl ]]; then
				if which perltidyrc >/dev/null; then
					perltidy -b -bext='/' --profile="$HOME/.config/.perltidyrc" "${filename}" &>/dev/null
					git update-index --really-refresh --again "${filename}" &>/dev/null
				fi
			elif [[ $line =~ ^\#\!.*python ]]; then
				if which black >/dev/null; then
					black --config "$HOME/.config/black" --quiet "${filename}" &>/dev/null
					git update-index --really-refresh --again "${filename}" &>/dev/null
				fi
			elif [[ $line =~ ^\#\!.*(bash|zsh|sh)$ ]]; then
				if which shfmt >/dev/null; then
					shfmt -ln bash -i 0 -s -ci -w "${filename}" &>/dev/null
					git update-index --really-refresh --again "${filename}" &>/dev/null
				fi
			fi
		fi
	done
done
