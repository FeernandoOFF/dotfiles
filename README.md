# Dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level package directory mirrors its path relative to `$HOME`, so stow can
symlink it into place (e.g. `nvim/.config/nvim/` → `~/.config/nvim/`).

## New mac

```sh
# One-shot bootstrap (Homebrew + tooling + clone + stow):
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/FeernandoOFF/dotfiles/master/scripts/setup.sh)"
```

Or manually:

```sh
brew install stow
git clone https://github.com/FeernandoOFF/dotfiles.git ~/dotfiles
cd ~/dotfiles
make stow
```

## Setup scripts

`scripts/setup.sh` is the remote bootstrap (Homebrew + core tooling + clone + `make stow`).
The rest are run locally after the repo is cloned, in this order:

```sh
~/dotfiles/scripts/zsh.sh            # oh-my-zsh, powerlevel10k, syntax highlighting
~/dotfiles/scripts/terminal_apps.sh  # neovim, ghostty, yazi, lazygit, lazydocker, fzf, herdr
~/dotfiles/scripts/tools.sh          # mise runtimes (node/python/go/bun), pnpm, wasmer, xcodes, zoxide
~/dotfiles/scripts/mac_defaults.sh   # macOS defaults (dock, finder) + nerd fonts
~/dotfiles/scripts/mac_apps.sh       # raycast, zen, karabiner, protonpass, homerow, ice
```

These scripts are the single source of truth for the setup steps documented in the
"My Mac Development setup" note.

## Usage

```sh
make stow     # symlink all packages into $HOME (idempotent)
make unstow   # remove all package symlinks
make restow   # unstow + stow
make list     # list managed packages
```

Add or remove a package by editing `PKGS` in the `Makefile`.

## Stow-managed packages

| Package   | Links to                    |
| --------- | --------------------------- |
| `zsh`     | `~/.zshrc`                  |
| `karabiner`    | `~/.config/karabiner/`           |
| `herdr`   | `~/.config/herdr/config.toml` |
| `nvim`    | `~/.config/nvim/`           |
| `ghostty` | `~/.config/ghostty/config`  |
| `lazygit` | `~/.config/lazygit/config.yml` |
| `ideavim` | `~/.ideavimrc`              |

Apps that keep runtime files next to their config (`herdr`, `ghostty`) are linked at
the file level, so logs/sockets/backups are left untouched.

## Manual imports (not symlink-able)

These configs live in app-specific locations or formats and must be imported by hand:

- **Raycast** — import `raycast/*.rayconfig` via Raycast → Settings → Import.
- **JetBrains** — import `jetbrains/settings.zip` / `jetbrains/android-studio-settings.zip`
  via IDE → File → Manage IDE Settings → Import Settings. (`.ideavimrc` is stow-managed — see `ideavim` above.)
- **Xcode** — copy `xcode/*.idekeybindings` to `~/Library/Developer/Xcode/UserData/KeyBindings/`.
- **Vimium C** — import `vimiumc/vimium_config.json` via the extension's options page.

## Kept for reference (not stow-managed)

`karabiner/` — key remapper that is plist-backed / not wired up via stow. See
`scripts/mac_apps.sh` for installing the related cask.

## Archive (not stow-managed)

`archive/` holds configs for tools no longer in use, kept purely for reference. Nothing
here is stowed (none of these are in the Makefile's `PKGS`):

`tmux/`, `sesh/`, `obsidian/`, `skhd/`, `VsCode/`, `warp/`, `yabai/`, `zellij/`, `amethyst/`.
