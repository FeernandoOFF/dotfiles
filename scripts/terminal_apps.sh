#!/bin/bash
brew install neovim ranger tmux mise &&
	mise use -g node@latest   # nodejs via mise (config symlinks are handled by `make stow`)
