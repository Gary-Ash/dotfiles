#!/usr/bin/env zsh
#*****************************************************************************************
# bootstrap.sh
#
# Boot strap a new Mac setup
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :   2-Mar-2021 10:05pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

setZDOTDIR() {
	cat <<'EOF' | sudo tee -a "$HOME/Downloads/etc/zshenv" &> /dev/null
if [[ -d "$HOME/.config/zsh" ]]; then
	export ZDOTDIR="$HOME/.config/zsh"
	export XDG_CONFIG_HOME="$HOME/.config/"
	export XDG_CACHE_HOME="$HOME/.cache/"
fi
EOF
sudo chmod 444 "$HOME/Downloads/etc/zshenv"
sudo chown root:wheel "$HOME/Downloads/etc/zshenv"
}


if ! git clone --quiet --recurse-submodules git@github.com:Gary-Ash/UtilityScripts.git "$HOME/Downloads/dotfiles/geedbla" &> /dev/null; then
	echo "Unable to update the repository"
	exit 2
fi

mkdir -p "$HOME/.cache/zsh"
find . -type f -exec chmod 600 {} \;
find . -type d -exec chmod 755 {} \;
find geedbla -type f  -not -name "*.md"  -exec chmod 755 {} \;

rsync -rz -delete  home/* "$HOME"
rsync -rz -delete  scripts/bin/ "/usr/local/bin"
rsync -rz -delete  scripts/lib/ "/usr/local/lib"
rsync -rz -delete  "Sublime Text/Local/" "$HOME/Library/Application Support/Sublime Text/Local"
rsync -rz -delete  "Sublime Text/Packages/" "$HOME/Library/Application Support/Sublime Text/Packages"
rsync -rz -delete  "xcode/" "$HOME/Library/Developer/Xcode/"

rsync -rz preferences/* "$HOME/Library/Preferences"

if ! command -v brew >/dev/null; then
    curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
fi

pushd brew || exit 1
brew bundle

SHELL_PATH="$(command -v bash)"
if ! grep "$SHELL_PATH" /etc/shells > /dev/null 2>&1 ; then
    sudo sh -c "echo $SHELL_PATH >> /etc/shells"
fi

SHELL_PATH="$(command -v zsh)"
if ! grep "$SHELL_PATH" /etc/shells > /dev/null 2>&1 ; then
    sudo sh -c "echo $SHELL_PATH >> /etc/shells"
fi
sudo chsh -s "$SHELL_PATH" "$USER"

# shellcheck disable=SC2162
while read p; do
  gem install "$p"
done < gems.txt

# shellcheck disable=SC2162
while read p; do
  pip3 install "$p"
done < python-modules.txt


if [[ -e "$HOME/Downloads/etc/zshenv" ]]; then
	if ! grep -Fq 'export ZDOTDIR' "$HOME/Downloads/etc/zshenv"; then
		setZDOTDIR
	fi
else
	sudo touch "$HOME/Downloads/etc/zshenv"
	setZDOTDIR
fi

for file (/usr/local/lib/geedbla/zsh/**/^*.zwc(N.)); do
	zcompile $file
done
