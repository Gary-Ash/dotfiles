#!/usr/bin/env zsh
#*****************************************************************************************
# .zshenv
#
# Core environment for all shells (interactive and non-interactive)
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Mar-2026  3:30pm
# Modified :  30-Mar-2026  2:27pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# XDG Base Directory Specification
#*****************************************************************************************
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

#*****************************************************************************************
# Language and locale
#*****************************************************************************************
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#*****************************************************************************************
# Editor and pager
#*****************************************************************************************
export EDITOR="bbedit --wait --resume"
export VISUAL="bbedit"
export LESSHISTFILE="-"

#*****************************************************************************************
# Node
#*****************************************************************************************
export NODE_PATH="/opt/homebrew/lib/node_modules"
export NODE_OPTIONS='--disable-warning=ExperimentalWarning'
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"

#*****************************************************************************************
# Homebrew
#*****************************************************************************************
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_CASK_OPTS="--no-quarantine"

#*****************************************************************************************
# Ruby and CocoaPods
#*****************************************************************************************
export RBENV_ROOT="/opt/venv/ruby"
export COCOAPODS_DISABLE_STATS=1
export CP_HOME_DIR="$XDG_CACHE_HOME/.cocoapods/"

#*****************************************************************************************
# Utility configs
#*****************************************************************************************
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rgrc.conf"
export SOLARGRAPH_CACHE="$XDG_CACHE_HOME/.solargraph/cache"
export SOLARGRAPH_GLOBAL_CONFIG="$XDG_CONFIG_HOME/.solargraph/config.yml"
