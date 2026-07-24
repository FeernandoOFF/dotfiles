#!/bin/bash
# Terminal editors & apps. Config symlinks are handled by `make stow`.
brew install neovim && brew install --cask ghostty && brew install yazi && \
brew install lazygit && brew install lazydocker && brew install fzf && \
brew install herdr && \
brew install television fd ripgrep bat   # deps used by nvim / fzf tooling
