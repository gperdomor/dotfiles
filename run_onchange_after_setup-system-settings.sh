#!/bin/bash

set -ex

echo "Setting finder preferences"
# Show status bar in the bottom of the Finder windows
defaults write com.apple.finder "ShowStatusBar" -bool "true" && killall Finder
# Show path bar in the bottom of the Finder windows
# defaults write com.apple.finder "ShowPathbar" -bool "true" && killall Finder
# Set the default view style for folders without custom setting
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv" && killall Finder
# Keep folders on top when sorting by name
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true" && killall Finder

echo "Setting Dock preferences"
# Set the icon size of Dock items in pixels
defaults write com.apple.dock "tilesize" -int "42" && killall Dock
# Autohides the Dock. You can toggle the Dock using ⌥ alt+⌘ cmd+d.
# defaults write com.apple.dock "autohide" -bool "false" && killall Dock
# Set the Dock position
# defaults write com.apple.dock "orientation" -string "bottom" && killall Dock