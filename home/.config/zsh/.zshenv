#!/usr/bin/env zsh
#*****************************************************************************************
# .zshenv
#
# This file contains my ZSH environment setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  17-May-2025  9:54pm
# Modified :  20-Jul-2025  8:02pm
#
# Copyright © 2024-2025 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# source my environment setup to make sure I have the proper setup regardless of how the
# ZSH gets invoked
#*****************************************************************************************
export SHELL_SESSIONS_DISABLE=1
export SHELL_SESSION_HISTORY=0

export NODE_PATH="/opt/homebrew/lib/node_modules"
export PATH="/opt/bin:/opt/geedbla/bin:/opt/geedbla/scripts:/opt/homebrew/opt/ruby/bin:/opt/homebrew/opt/python@3.13/libexec/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/bin/geedbla:/opt/homebrew/lib/node_modules/npm"

export EDITOR="/usr/local/bin/bbedit --wait"
export VISUAL="/usr/local/bin/bbedit"

export LESSHISTFILE="-"
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export CLICOLOR=1
export LC_ALL="en_US.UTF-8";
export LANG=en_US.UTF-8
export HISTSIZE=2000
export SAVEHIST=1000
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export COCOAPODS_DISABLE_STATS=1
export HOMEBREW_CASK_OPTS="--no-quarantine --no-binaries"

export SOLARGRAPH_CACHE="$XDG_CACHE_HOME/.solargraph/cache"
export SOLARGRAPH_GLOBAL_CONFIG="$HOME/.config/.solargraph/config.yml"
export RIPGREP_CONFIG_PATH="$HOME/.config/rgrc.conf"
export NODE_OPTIONS='--disable-warning=ExperimentalWarning'
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export CP_HOME_DIR="$XDG_CACHE_HOME/.cocoapods/"
#*****************************************************************************************
# module load up
#*****************************************************************************************
fpath=(
  /opt/homebrew/share/zsh-completions
  /opt/homebrew/zsh/site-functions
  /opt/geedbla/lib/zsh/lib
  /opt/geedbla/lib/zsh/zsh-completion
  "${fpath[@]}"
  )

#*****************************************************************************************
# load utilities from scripting libraries
#*****************************************************************************************
autoload get_sudo_password
autoload start_persistant_sudo
autoload stop_persistant_sudo
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

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
setopt auto_menu
setopt auto_list
setopt auto_pushd
setopt pushdminus
setopt globdots
setopt extendedglob

setopt menu_complete
setopt always_to_end
setopt complete_in_word
setopt completealiases

autoload -Uz zmv
autoload -Uz colors && colors

#*****************************************************************************************
# key bindings
#*****************************************************************************************
my-sudolast-cmd() {
	echo sudo $(fc -ln -1)
}

my-sudolast-cmd_widget() LBUFFER+=$(my-sudolast-cmd)
zle -N my-sudolast-cmd_widget
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e
bindkey "^[[H"    beginning-of-line         # home
bindkey "^[[F"    end-of-line               # end
bindkey "^[[A"    up-line-or-search         # up arrow
bindkey "^[[B"    down-line-or-search       # down arrow
bindkey "^[[3~"   delete-char               # delete key
bindkey "^[3;5~"  delete-char               # delete key
bindkey  "^O"     my-sudolast-cmd_widget	# Ctrl-O for "Oh Mu God, the last command"

#*****************************************************************************************
# completion system
#*****************************************************************************************
autoload -Uz compinit
autoload bashcompinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
bashcompinit
compdef _swift swift

source <(npm completion)
eval "$(gh completion -s zsh)"

zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' file-list all
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#*****************************************************************************************
# source my own utilities
#*****************************************************************************************
# shellcheck disable=SC2044,SC1090
for file in $(find /opt/geedbla/lib/zsh -type f -or -type l); do
  file="${file%.*}"
  autoload -U "$file"
done

#*****************************************************************************************
# Zsh-Autosuggest
#*****************************************************************************************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#AEB5B0,bg=#003743"
export ZSH_AUTOSUGGEST_USE_ASYNC="1"
export ZSH_AUTOSUGGEST_MANUAL_REBIND="1"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="1"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#*****************************************************************************************
# useful aliases
#*****************************************************************************************
alias sudo="sudo "
alias ll="eza --long -all --git --group --group-directories-first --color=always  --icons=always --classify --level=3 --sort=name"

alias edscripts='${VISUAL} /opt/geedbla'
alias zshrc='${EDITOR} $XDG_CONFIG_HOME/zsh/.zshenv $XDG_CONFIG_HOME/zsh/.zshrc;cleanhist'

alias mute="osascript -e \"set volume output muted true\""
alias volumenormal="osascript -e \"set volume output volume 50\""
alias volumemax="osascript -e \"set volume output volume 100\""

alias perms="stat -f '%Sp %OLp %N'"

alias recordSimulator="xcrun simctl io booted recordVideo "

alias afk="osascript -e 'tell app \"System Events\" to key code 12 using {control down, command down}'"

alias show-all-files="defaults write com.apple.finder AppleShowAllFiles true;killall Finder"
alias hide-all-files="defaults delete com.apple.finder AppleShowAllFiles;killall Finder"

alias gitkeep="find . -type d -empty -not -path \"./.git/*\" -exec touch {}/.gitkeep \;"

#*****************************************************************************************
# Zsh Autosuggest
#*****************************************************************************************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
export ZSH_AUTOSUGGEST_USE_ASYNC="1"
export ZSH_AUTOSUGGEST_MANUAL_REBIND="1"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="1"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#*****************************************************************************************
# change directory and list it
#*****************************************************************************************
cdl() {
  cd "$1"
  eza --long -all --git --group --group-directories-first --color=always  --icons=always --classify --level=3 --sort=name
}
#*****************************************************************************************
# setup FZF
#*****************************************************************************************
if command -v fzf &> /dev/null; then
	export FZF_DEFAULT_COMMAND="rg --files --hidden --follow"
  	export FZF_DEFAULT_OPTS="--prompt='▶' --pointer='→' --marker='✓' --border=rounded --color=fg:#6c7c80,bg:#012b36,hl:#003743 --color=fg+:#6b7f83,bg+:#003743,hl+:#003743 --color=info:#859900,prompt:#d33682,pointer:#6c71c4 --color=marker:#b58900,spinner:#6c71c4,header:#dc322f"
	source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
  	source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
fi

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

fbrdel() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git branch -D $(awk '{print $2}' <<<"$target" ) > /dev/null
}

fbr() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" ) &> /dev/null
}

fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha > /dev/null
      break;
    else
      git stash show -p $sha > /dev/null
    fi
  done
}

#*****************************************************************************************
# setup Z directory utility
#*****************************************************************************************
export _Z_DATA="$XDG_CACHE_HOME/zsh/.z"
source /opt/homebrew/etc/profile.d/z.sh

#*****************************************************************************************
# quick system update
#*****************************************************************************************
sysupdate() {
	if command -v brew &>/dev/null; then
		SUDO_PASSWORD=$(get_sudo_password)
		start_persistant_sudo "$SUDO_PASSWORD"
		sudo chmod -R 777 /Applications/* &>/dev/null
		stop_persistant_sudo

		brew update &>/dev/null
		brew upgrade &>/dev/null
		brew link --overwrie node &>/dev/null
		brew autoremove &>/dev/null
		brew cleanup &>/dev/null
		rm -rf $(brew --cache) &>/dev/null

		if command -v gem &>/dev/null; then
			gem update &>/dev/null
			gem update --system &>/dev/null
			gem cleanup &>/dev/null
		fi

		if command -v pip3 &>/dev/null; then
			pip3 install --upgrade --break-system-package pip &>/dev/null
			pip3 install -U --break-system-packages $(pip3 freeze | cut -d = -f 1) &>/dev/null
		fi

		if command -v npm &>/dev/null; then
			npm install -g npm@latest &>/dev/null
			npm update -g &>/dev/null
		fi

		SUDO_PASSWORD=$(get_sudo_password)
		start_persistant_sudo "$SUDO_PASSWORD"

		sudo xattr -cr /Applications/* &>/dev/null
		sudo chown -R garyash:admin /opt/geedbla/* &>/dev/null
		sudo chown -R root:admin /Applications/* &>/dev/null
		sudo chmod -R 775 /Applications/* &>/dev/null
		stop_persistant_sudo
	fi

	rm -rf "$XDG_CACHE_HOME/" &>/dev/null
	mkdir -p "$XDG_CACHE_HOME/zsh"
	touch "$_Z_DATA"
	history -p

	stuff=(
		"$HOME/.local"
		"$HOME/.npm"
		"$HOME/.gem"
		"$HOME/.android"
		"$HOME/.konan"
		"$HOME/.gradle"
		"$HOME/.swiftpm"
		"$HOMD/.hawtjni"
		"$HOME/.config/zsh/.zsh_history"
	)

	pkill -f '.*GradleDaemon.*'

	SUDO_PASSWORD=$(get_sudo_password)
	start_persistant_sudo "$SUDO_PASSWORD"
	for item in "${stuff[@]}"; do
		sudo rm -rf "$item" &>/dev/null
	done

	stop_persistant_sudo
	unset SUDO_PASSWORD
	setopt local_options no_monitor
	find "$HOME/Library/CloudStorage/Dropbox/Data" -name "Keyboard Maestro Macros \(*.kmsync" -delete &>/dev/null

	startup-banner.pl --dark
}

#*****************************************************************************************
# enhance man with some color and highlighting
#*****************************************************************************************
man() {
  (export LESS_TERMCAP_mb=$'\033[5m'; \
  export LESS_TERMCAP_md=$'\033[1m'; \
  export LESS_TERMCAP_so=$'\033[7m'; \
  export LESS_TERMCAP_us=$'\033[4m'; \
  export LESS_TERMCAP_me=$'\033[0m'; \
  export LESS_TERMCAP_se=$'\033[0m'; \
  export LESS_TERMCAP_ue=$'\033[0m'; \
  /usr/bin/man "$@")
}

#*****************************************************************************************
# do an OCD clean
#*****************************************************************************************
alias OCD=ocd

ocd() {
  /opt/geedbla/scripts/ocd.sh "$@"
  if [ "$?" -eq "0" ]; then
    mkdir -p "$HOME/.cache/zsh"   &> /dev/null
    exec "$SHELL" -l
  fi
}

#*****************************************************************************************
# clean shell history an iTerm stuff too
#*****************************************************************************************
cleanhist() {
  rm -f "${HISTFILE}"       	&> /dev/null
  mkdir -p "$HOME/.cache/zsh" &> /dev/null
  exec "$SHELL" -l
}


#*****************************************************************************************
# generate a UUID
#*****************************************************************************************
genuuid() {
    uuid=$(uuidgen | tr 'A-Z' 'a-z' | tr -d '\n')
    (osascript -e "display notification with title \"⌘-V to paste\" subtitle \"$uuid\"" &) >/dev/null 2>&1
    echo -n "$uuid" | pbcopy
}

#*****************************************************************************************
# make given directory and then cd into it
#*****************************************************************************************
mkcd() {
	mkdir -p "$1"
	cd "$1" || return
}
#*****************************************************************************************
#  open a finder qindow at the current directory
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
#  change terminal directory to match the finder
#*****************************************************************************************
cdf() {
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')" || return
}