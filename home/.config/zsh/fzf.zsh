#!/usr/bin/env zsh
#*****************************************************************************************
# fzf.zsh
#
# fzf theme, file discovery, search functions, and key bindings
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  20-Oct-2026  8:14pm
# Modified :  11-Nov-2026  8:34pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Solarized Dark Palette
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
# File Discovery
#*****************************************************************************************
if command -v fd >/dev/null 2>&1; then
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
# Base Theme
#*****************************************************************************************
export FZF_DEFAULT_OPTS="
--height=85%
--layout=reverse
--border=rounded
--margin=1
--padding=1

--prompt='󰍉  '
--pointer='▶'
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
# Native Walker (fzf >= 0.48)
#*****************************************************************************************
export FZF_DEFAULT_OPTS="
${FZF_DEFAULT_OPTS}
--walker=file,dir,follow,hidden
--walker-skip=.git,node_modules,DerivedData,.build
"

#*****************************************************************************************
# Preview Helper
#*****************************************************************************************
_fzf_preview() {
	local target="$1"

	[[ -z $target ]] && return

	if [[ -d $target ]]; then

		if command -v eza >/dev/null; then
			eza \
				--tree \
				--icons \
				--level=4 \
				--color=always \
				"$target"
		else
			ls -lah "$target"
		fi

	elif command -v file >/dev/null &&
		file --mime "$target" 2>/dev/null | grep -q 'image/'; then

		if command -v chafa >/dev/null; then
			chafa \
				-f symbols \
				-s "${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" \
				"$target"
		else
			file "$target"
		fi

	else

		if command -v bat >/dev/null; then
			bat \
				--style=numbers \
				--color=always \
				--line-range=:500 \
				"$target"
		else
			sed -n '1,500p' "$target"
		fi

	fi
}

#*****************************************************************************************
# Ctrl-T
#*****************************************************************************************
export FZF_CTRL_T_OPTS="
--header='󰈔 Files'
--bind='ctrl-/:change-preview-window(hidden|)'
--preview '_fzf_preview {}'
"

#*****************************************************************************************
# Alt-C
#*****************************************************************************************
export FZF_ALT_C_OPTS="
--header='󰉋 Directories'
--bind='ctrl-/:change-preview-window(hidden|)'
--preview '
	if command -v eza >/dev/null; then
		eza \
			--tree \
			--icons \
			--level=4 \
			--color=always {}
	else
		find {} -maxdepth 3
	fi
'
"

#*****************************************************************************************
# Ctrl-R
#*****************************************************************************************
export FZF_CTRL_R_OPTS="
--exact
--header='󰋚 History'
"

#*****************************************************************************************
# Ripgrep Live Search
#*****************************************************************************************
rgf() {
	local rg_prefix

	rg_prefix='rg --column --line-number --no-heading --color=always --smart-case'

	FZF_DEFAULT_COMMAND="$rg_prefix ''" \
		fzf \
		--ansi \
		--disabled \
		--query "${*:-}" \
		--header='󰱼 Live Ripgrep Search' \
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
# File Browser
#*****************************************************************************************
ff() {
	local file

	file=$(
		fzf \
			--header='󰈔 Files' \
			--preview '_fzf_preview {}'
	) || return

	[[ -n $file ]] && "${EDITOR:-nvim}" "$file"
}

#*****************************************************************************************
# Git Branch Switcher
#*****************************************************************************************
gb() {
	git rev-parse --git-dir >/dev/null 2>&1 || return

	local branch

	branch=$(
		git for-each-ref \
			--sort=-committerdate \
			--format='%(committerdate:relative)|%(authorname)|%(refname:short)' \
			refs/heads refs/remotes |
			grep -v 'origin/HEAD' |
			fzf \
				--delimiter='|' \
				--with-nth=1,2,3 \
				--header=' Git Branches' \
				--preview '
				git log \
					--graph \
					--decorate \
					--oneline \
					--color=always \
					{3} | head -200
			'
	) || return

	branch="${branch##*|}"

	[[ -z $branch ]] && return

	if [[ $branch == origin/* ]]; then
		git switch \
			-c "${branch#origin/}" \
			--track "$branch"
	else
		git switch "$branch"
	fi
}

#*****************************************************************************************
# Safe Branch Delete
#*****************************************************************************************
gbd() {
	local branches

	branches=$(
		git branch --format='%(refname:short)' |
			grep -v "^$(git branch --show-current)$" |
			fzf \
				--multi \
				--header='Delete Branches'
	) || return

	echo "$branches" | xargs -r git branch -d
}

#*****************************************************************************************
# Force Branch Delete
#*****************************************************************************************
gbD() {
	local branches

	branches=$(
		git branch --format='%(refname:short)' |
			grep -v "^$(git branch --show-current)$" |
			fzf \
				--multi \
				--header='Force Delete Branches'
	) || return

	echo "$branches" | xargs -r git branch -D
}

#*****************************************************************************************
# Remote Branch Delete
#*****************************************************************************************
gbrd() {
	local branches

	branches=$(
		git branch -r |
			sed 's/^[[:space:]]*//' |
			grep '^origin/' |
			grep -v 'HEAD' |
			fzf \
				--multi \
				--header='Delete Remote Branches'
	) || return

	while read -r branch; do
		[[ -z $branch ]] && continue
		git push origin --delete "${branch#origin/}"
	done <<<"$branches"
}

#*****************************************************************************************
# Git History Browser
#*****************************************************************************************
glf() {
	git log \
		--graph \
		--decorate \
		--all \
		--color=always \
		--pretty='format:%C(auto)%h %d %s %C(green)(%cr) %C(cyan)<%an>' |
		fzf \
			--ansi \
			--no-sort \
			--header='󰜘 Git History' \
			--preview '
			echo {} |
			grep -o "[a-f0-9]\{7,\}" |
			head -1 |
			xargs git show --color=always
		'
}

#*****************************************************************************************
# Process Browser
#*****************************************************************************************
fkill() {
	local selected

	selected=$(
		ps -ef |
			fzf \
				--multi \
				--header='󰍹 Processes'
	) || return

	echo "$selected" |
		awk '{print $2}' |
		xargs -r kill -9
}

#*****************************************************************************************
# SSH Host Browser
#*****************************************************************************************
fssh() {
	local host

	host=$(
		grep '^Host ' ~/.ssh/config 2>/dev/null |
			awk '{print $2}' |
			grep -v '\*' |
			sort -u |
			fzf \
				--header='󰣀 SSH Hosts'
	) || return

	ssh "$host"
}

#*****************************************************************************************
# Environment Browser
#*****************************************************************************************
fenv() {
	env |
		sort |
		fzf \
			--header='󰘳 Environment Variables'
}

#*****************************************************************************************
# Manual Page Browser
#*****************************************************************************************
fman() {
	man -k . |
		fzf \
			--prompt='Manual > ' \
			--preview '
			man {1} |
			col -bx |
			head -400
		' |
		awk '{print $1}' |
		xargs -r man
}

#*****************************************************************************************
# Directory Stack Browser
#*****************************************************************************************
fdirs() {
	local dir

	dir=$(
		dirs -v |
			fzf \
				--header='󰉋 Directory Stack' |
			awk '{print $2}'
	) || return

	cd "$dir" || return
}

#*****************************************************************************************
# Zoxide Integration
#*****************************************************************************************
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh)"
fi

zi() {
	local dir

	dir=$(
		zoxide query -l |
			fzf \
				--header='󰉋 Jump To Directory' \
				--height=40%
	) || return

	cd "$dir" || return
}

#*****************************************************************************************
# tmux Integration
#*****************************************************************************************
if [[ -n $TMUX ]]; then
	export FZF_TMUX_OPTS="-p 90%,85%"
fi

#*****************************************************************************************
# Git Branch Widget
#*****************************************************************************************
fzf-git-branch-widget() {
	local branch

	branch=$(
		git branch \
			-a \
			--format='%(refname:short)' |
			fzf \
				--header=' Git Branches'
	) || return

	LBUFFER+="$branch"
}

zle -N fzf-git-branch-widget

#*****************************************************************************************
# Aliases
#*****************************************************************************************
alias fg='rgf'
alias fgrep='rgf'

alias ffiles='ff'
alias fk='fkill'
alias fs='fssh'
alias fe='fenv'
alias fm='fman'

# Git
alias gbs='gb'
alias gbdl='gbd'
alias gbdf='gbD'
alias gbrm='gbrd'
alias ghl='glf'

alias fzf-preview='fzf --preview "_fzf_preview {}"'

#*****************************************************************************************
# Key Bindings
#*****************************************************************************************
bindkey '^G' fzf-file-widget 2>/dev/null || true
bindkey '^G^B' fzf-git-branch-widget
