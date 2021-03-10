#!/usr/bin/env zsh
#*****************************************************************************************
# settings.sh
#
# Automate the some basic settings and software installation on macOS
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :  26-Feb-2021 12:26pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder AppleShowAllFiles true
defaults write com.apple.finder ShowStatusBar -bool true

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0

defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
defaults write com.apple.cups "Quit When Finished" -bool true

defaults write com.apple.dt.xcode AppleICUDateFormatStrings '{ 1 = "d-MMM-y"; }'
defaults write http://com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "ViewModel" "View" "Screen"
