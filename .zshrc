
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Aliases 
alias gw='git switch'
alias python='python3'
alias r='ranger'
alias vi='nvim'
alias l='eza -l'


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

