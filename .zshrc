
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Homebrew
export PATH="$PATH:/opt/homebrew/bin"

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

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"


# Plugins
plugins=(
  git
  asdf
#  zsh-autosuggestions
  #zsh-syntax-highlighting
  #zsh-bat
)

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

# eza
if command -v eza &>/dev/null; then
    alias l='eza -l'
    alias ls='eza'
fi

# Sesh / TMUX
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '^F' sesh-sessions
bindkey -M vicmd '^F' sesh-sessions
bindkey -M viins '^F' sesh-sessions


# Android CLI

export ANDROID_HOME=/Users/$USER/Library/Android/sdk


export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$HOME/.local/bin"

# JAVA
#export JAVA_HOME=/Users/fernandooff/Library/Java/JavaVirtualMachines/corretto-21.0.3/Contents/Home/
export JAVA_HOME=/Users/fernandooff/Library/Java/JavaVirtualMachines/openjdk-25.0.2/Contents/Home/


# Wasmer
export WASMER_DIR="/Users/fernandooff/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
# if command -v pass-cli >/dev/null 2>&1; then
# pass-cli ssh-agent load && ssh-add -l
# fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fernandooff/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fernandooff/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fernandooff/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fernandooff/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH=$PATH:$HOME/.maestro/bin

#
# opencode
export PATH=/Users/fernandooff/.opencode/bin:$PATH
alias oc='opencode'
