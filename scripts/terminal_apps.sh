#bin/bash
brew install neovim && brew install ranger && brew install tmux && asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git &&
	ln -s ~/dotfiles/nvim ~/.config/nvim/ &&
	ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
