
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Homebrew
export PATH="$PATH:/opt/homebrew/bin"

# Aliases 
alias gw='git switch'
alias python='python3'
alias r='ranger'
alias vi='nvim'
alias l='eza -l'
alias lz='lazygit'
alias t='sesh connect $(sesh list | fzf)'

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"


# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions

 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi



# asdf

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Powerlevel10k 

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zoxide
eval "$(zoxide init zsh)"

if command -v z &>/dev/null; then
    alias cd='z'
fi



# Android CLI

export ANDROID_HOME=/Users/$USER/Library/Android/sdk

export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
# JAVA
export JAVA_HOME=/Users/$USER/Applications/Android\ Studio.app/Contents/jbr/Contents/Home

# Wasmer
export WASMER_DIR="/Users/fernandoobregon/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

