#!/bin/bash
# Install ZSH environment: oh-my-zsh, powerlevel10k, syntax highlighting.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
brew install zsh-syntax-highlighting
rm ~/.zshrc   # removed so `make stow` can symlink the repo's zsh config
