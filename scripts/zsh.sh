#!/bin/bash
# Install ZSH environment: oh-my-zsh, oh-my-posh prompt, syntax highlighting.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install zsh-syntax-highlighting
rm ~/.zshrc   # removed so `make stow` can symlink the repo's zsh config
