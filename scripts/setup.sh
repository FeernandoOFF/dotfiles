#!/bin/bash
# Bootstrap a fresh mac.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  # Install Homebrew
brew install coreutils curl git mise stow                                                        # Core tooling + mise + stow
git clone https://github.com/FeernandoOFF/dotfiles.git ~/dotfiles                                # Clone dotfiles
cd ~/dotfiles && make stow                                                                       # Symlink configs
