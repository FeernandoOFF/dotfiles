/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && ##Install Homebrew
	brew install coreutils curl git && brew install asdf &&                                           # Install ASDF
	git clone https://github.com/FeernandoOFF/dotfiles.git ~/dotfiles                                 # Install Dotfiles
