# Dotfiles managed with GNU Stow.
# Each package below mirrors its path relative to $HOME.

PKGS = zsh nvim ghostty lazygit herdr ideavim pi

# These apps write logs/sockets/session files next to their config.  Create the
# target directories first so Stow links only the config files instead of folding
# the whole directory into ~/.config/<app>.
FILE_LEVEL_CONFIG_DIRS = \
	$$HOME/.config/ghostty \
	$$HOME/.config/herdr \
	$$HOME/.config/lazygit

.PHONY: stow unstow restow list prepare-file-level-dirs

stow: prepare-file-level-dirs ## Symlink all packages into $HOME
	stow --target="$$HOME" --restow --verbose $(PKGS)

prepare-file-level-dirs: ## Prevent Stow from directory-folding runtime config dirs
	@for dir in $(FILE_LEVEL_CONFIG_DIRS); do \
		if [ -L "$$dir" ]; then \
			target=$$(readlink "$$dir"); \
			case "$$target" in \
				*dotfiles*) echo "Unfolding $$dir -> $$target"; rm "$$dir" ;; \
				*) echo "Refusing to replace non-dotfiles symlink: $$dir -> $$target"; exit 1 ;; \
			esac; \
		fi; \
		mkdir -p "$$dir"; \
	done

unstow: ## Remove all package symlinks from $HOME
	stow --target="$$HOME" --delete --no-folding --verbose $(PKGS)

restow: unstow stow ## Re-link everything from scratch

list: ## Show managed packages
	@echo $(PKGS)
