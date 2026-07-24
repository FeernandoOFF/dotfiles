#!/bin/bash
# Language runtimes (via mise) and dev tools.
mise use -g node@latest
mise use -g python@latest
mise use -g go@latest
mise use -g bun@latest
brew install pnpm
brew install wasmer
brew install xcodesorg/made/xcodes
brew install zoxide
