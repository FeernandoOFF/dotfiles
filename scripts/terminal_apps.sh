#!/bin/bash
brew install neovim mise television fd ripgrep bat &&
  mise use -g node@latest # nodejs via mise (config symlinks are handled by `make stow`)
