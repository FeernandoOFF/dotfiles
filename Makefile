# Dotfiles managed with GNU Stow.
# Each package below mirrors its path relative to $HOME.

PKGS = zsh nvim ghostty lazygit herdr ideavim

.PHONY: stow unstow restow list

stow: ## Symlink all packages into $HOME
	stow --target="$$HOME" --restow --verbose $(PKGS)

unstow: ## Remove all package symlinks from $HOME
	stow --target="$$HOME" --delete --verbose $(PKGS)

restow: unstow stow ## Re-link everything from scratch

list: ## Show managed packages
	@echo $(PKGS)
