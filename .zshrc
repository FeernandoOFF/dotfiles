# ---- ZSH Init configuration ----

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh


# Powerlevel10k

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


plugins=(
  git
)


# ---- Platform configuration ----

# Homebrew (MacOS)
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"


# ---- Custom Configuiration ----

# Aliases 
alias gw='git switch'
alias lz='lazygit'
alias vi='nvim'
alias f='fzf --preview "cat {}"'
alias fvi='vi $(fzf --preview "cat {}")'
alias t='sesh connect $(sesh list | fzf)'
alias e='yazi'
alias python='python3'
alias pip='pip3'
alias l='eza -l'
alias cl='clear'


# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi


# eza
if command -v eza &>/dev/null; then
    alias l='eza -l'
    alias ls='eza'
fi


 # Mise - 
eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"

# zoxide

eval "$(zoxide init zsh)"

if command -v z &>/dev/null; then
    alias cd='z'
fi



# Android CLI

export ANDROID_HOME=/Users/$USER/Library/Android/sdk

export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$HOME/.local/bin"

# JAVA
#export JAVA_HOME=/Users/fernandooff/Library/Java/JavaVirtualMachines/corretto-21.0.3/Contents/Home/
#export JAVA_HOME=/Users/fernandooff/Library/Java/JavaVirtualMachines/openjdk-25.0.2/Contents/Home/




[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fernandooff/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fernandooff/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fernandooff/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fernandooff/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH=$PATH:$HOME/.maestro/bin

# AI
export PATH=/Users/fernandooff/.opencode/bin:$PATH
alias oc='opencode'
alias cc='claude'
