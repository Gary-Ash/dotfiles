#!/usr/bin/env zsh
#*****************************************************************************************
# fzf.zsh
#
# fzf theme, file discovery, search functions, and key bindings
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  20-Oct-2026  8:14pm
# Modified :  20-Oct-2026  8:22pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Solarized dark palette
#*****************************************************************************************
typeset -gr SOL_BASE03="#002b36"
typeset -gr SOL_BASE02="#073642"
typeset -gr SOL_BASE01="#586e75"
typeset -gr SOL_BASE00="#657b83"
typeset -gr SOL_BASE0="#839496"
typeset -gr SOL_BASE1="#93a1a1"

typeset -gr SOL_YELLOW="#b58900"
typeset -gr SOL_ORANGE="#cb4b16"
typeset -gr SOL_RED="#dc322f"
typeset -gr SOL_MAGENTA="#d33682"
typeset -gr SOL_VIOLET="#6c71c4"
typeset -gr SOL_BLUE="#268bd2"
typeset -gr SOL_CYAN="#2aa198"
typeset -gr SOL_GREEN="#859900"

#*****************************************************************************************
# File discovery
#*****************************************************************************************
if command -v fd &>/dev/null; then
	export FZF_DEFAULT_COMMAND="
		fd \
		--type f \
		--hidden \
		--follow \
		--exclude .git \
		--exclude node_modules \
		--exclude DerivedData \
		--exclude .build
	"

	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

#*****************************************************************************************
# Base theme
#*****************************************************************************************
export FZF_DEFAULT_OPTS="
--height=85%
--layout=reverse
--border=rounded
--margin=1
--padding=1

--prompt='󰍉  '
--pointer=''
--marker='󰄲'

--info=inline-right
--cycle

--separator='─'
--scrollbar='│'

--preview-window=right:65%:border-left

--color=bg:${SOL_BASE03}
--color=bg+:#0b3a47
--color=fg:${SOL_BASE0}
--color=fg+:${SOL_BASE1}

--color=hl:${SOL_BLUE}
--color=hl+:${SOL_CYAN}

--color=prompt:${SOL_GREEN}
--color=pointer:${SOL_ORANGE}
--color=marker:${SOL_GREEN}
--color=spinner:${SOL_YELLOW}

--color=info:${SOL_CYAN}
--color=header:${SOL_VIOLET}
--color=border:${SOL_BASE01}
"

#*****************************************************************************************
# Native fzf walker (fzf >= 0.48)
#*****************************************************************************************
export FZF_DEFAULT_OPTS="
$FZF_DEFAULT_OPTS
--walker=file,dir,follow,hidden
--walker-skip=.git,node_modules,DerivedData,.build
"

#*****************************************************************************************
# Ctrl-T
#*****************************************************************************************
export FZF_CTRL_T_OPTS="
--header='󰈔  Files'
--preview '
	bat \
		--style=numbers \
		--color=always \
		--line-range=:500 {}
'
"

#*****************************************************************************************
# Alt-C
#*****************************************************************************************
export FZF_ALT_C_OPTS="
--header='󰉋  Directories'
--preview '
	eza \
		--tree \
		--icons \
		--level=3 \
		--color=always {}
'
"

#*****************************************************************************************
# Ctrl-R
#*****************************************************************************************
export FZF_CTRL_R_OPTS="
--exact
--header='󰋚  History'
"

#*****************************************************************************************
# Ripgrep live search
#*****************************************************************************************
rgf() {
	local rg_prefix

	rg_prefix='rg --column --line-number --no-heading --color=always --smart-case'

	FZF_DEFAULT_COMMAND="$rg_prefix ''" \
		fzf \
		--ansi \
		--disabled \
		--query "${*:-}" \
		--header='󰱼  Live Ripgrep Search' \
		--delimiter=: \
		--bind "start:reload:$rg_prefix {q} || true" \
		--bind "change:reload:$rg_prefix {q} || true" \
		--preview '
			bat \
				--color=always \
				--style=numbers \
				--highlight-line {2} \
				{1}
		' \
		--preview-window=right:65% \
		--bind "enter:become(${EDITOR:-nvim} {1} +{2})"
}

#*****************************************************************************************
# Grep alias
#*****************************************************************************************
alias fg='rgf'

#*****************************************************************************************
# File browser
#*****************************************************************************************
ff() {
	local file

	file=$(
		fzf \
			--header='󰈔  Files' \
			--preview '
				bat \
					--style=numbers \
					--color=always \
					--line-range=:500 {}
			'
	) || return

	[[ -n $file ]] && "${EDITOR:-nvim}" "$file"
}

#*****************************************************************************************
# Zoxide integration
#*****************************************************************************************
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi

zi() {
	local dir

	dir=$(
		zoxide query -l |
			fzf \
				--header='󰉋  Jump To Directory' \
				--height=40%
	) || return

	cd "$dir" || return
}

#*****************************************************************************************
# tmux popup integration
#*****************************************************************************************
if [[ -n $TMUX ]]; then
	export FZF_TMUX_OPTS="-p 85%,80%"
fi

#*****************************************************************************************
# Aliases
#*****************************************************************************************
alias fzf-preview='fzf --preview "bat --style=numbers --color=always {}"'
alias ffiles='ff'
alias fgrep='rgf'

#*****************************************************************************************
# Key bindings
#*****************************************************************************************
bindkey '^G' fzf-file-widget 2>/dev/null || true
