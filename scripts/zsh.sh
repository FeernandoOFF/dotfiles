#!/bin/bash
# Install ZSH environment: oh-my-zsh, oh-my-posh prompt, and plugins.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install jandedobbeleer/oh-my-posh/oh-my-posh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_plugin() {
  local name="$1" repository="$2"
  local directory="$ZSH_CUSTOM/plugins/$name"

  [[ -d "$directory" ]] || git clone --depth=1 "$repository" "$directory"
}

install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
install_plugin zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode.git

rm ~/.zshrc   # removed so `make stow` can symlink the repo's zsh config
