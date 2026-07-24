#!/bin/bash
# macOS default settings.
defaults write com.apple.dock "autohide" -bool "true" && killall Dock
defaults write com.apple.finder ShowPathbar -bool true && killall Finder
brew install --cask font-fira-code-nerd-font && brew install --cask font-jetbrains-mono-nerd-font
