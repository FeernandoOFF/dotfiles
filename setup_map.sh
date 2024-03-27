/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&                                   ##Install Homebrew
	brew install coreutils curl git && brew install asdf &&                                                                             # Install ASDF
	git clone https://github.com/FeernandoOFF/dotfiles.git ~/dotfiles &&                                                                # Install Dotfiles
	brew install --cask raycast && brew install --cask arc && brew install --cask amethyst && brew install --cask karabiner-elements && # Install General Apps
	brew install neovim && brew install --cask warp && brew install ranger &&                                                           # Install Development Tools & Apps
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git                                                                   # Install Programming languages
