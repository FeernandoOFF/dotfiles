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
alias oc='opencode'
alias cc='claude'



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



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Android CLI

export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$HOME/.local/bin"

# Screenshot the connected device/emulator and copy it to the clipboard
adbshot() {
    local f="/tmp/adbshot.png"

    # Count connected devices (lines after the header that report "device").
    local devices count
    devices=$(adb devices | awk 'NR>1 && $2=="device" {print $1}')
    count=$(printf '%s\n' "$devices" | grep -c .)

    if [[ "$count" -eq 0 ]]; then
        echo "❌ No device connected. Plug in a device or start an emulator." >&2
        return 1
    elif [[ "$count" -gt 1 ]]; then
        echo "❌ Multiple devices connected. Pass a serial: adbshot <serial>" >&2
        printf '%s\n' "$devices" | sed 's/^/   • /' >&2
        [[ -n "$1" ]] || return 1
    fi

    local -a serial
    [[ -n "$1" ]] && serial=(-s "$1")

    # Foldables / multi-display devices expose several physical displays; the
    # inactive ones capture as black and (without -d) print a warning that
    # corrupts the PNG. Pick the powered-on display when there is more than one.
    local did
    did=$(adb "${serial[@]}" shell dumpsys display 2>/dev/null \
        | grep 'DisplayDeviceInfo{' | grep 'state ON,' \
        | grep -oE 'uniqueId="local:[0-9]+"' | grep -oE '[0-9]+' | head -1)

    if [[ -n "$did" ]]; then
        adb "${serial[@]}" exec-out screencap -d "$did" -p > "$f"
    else
        adb "${serial[@]}" exec-out screencap -p > "$f"
    fi

    # Verify the PNG magic bytes (89 50 4e 47) so a corrupt capture never
    # silently lands on the clipboard.
    if [[ "$(head -c4 "$f" 2>/dev/null | xxd -p)" != "89504e47" ]]; then
        echo "❌ Screenshot capture failed (invalid PNG)." >&2
        return 1
    fi

    osascript -e "set the clipboard to (read (POSIX file \"$f\") as «class PNGf»)" \
        && echo "📋 Screenshot copied to clipboard"
}

# JAVA
#export JAVA_HOME=$HOME/Library/Java/JavaVirtualMachines/corretto-21.0.3/Contents/Home/
#export JAVA_HOME=$HOME/Library/Java/JavaVirtualMachines/openjdk-25.0.2/Contents/Home/


# AI
export PATH=$HOME/.opencode/bin:$PATH

if command -v pass-cli >/dev/null 2>&1 && command -v ssh-add >/dev/null 2>&1; then
    if ! ssh-add -l >/dev/null 2>&1; then
        pass-cli ssh-agent load >/dev/null 2>&1
    fi
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi
export PATH=$PATH:$HOME/.maestro/bin

# Herdr
function zz {
    herdr "$@"
}

# Pi
export PATH="$HOME/.local/share/mise/installs/node/24.13.0/bin:$PATH"

# >>> railway initialize >>>
source "$HOME/.railway/env"
# <<< railway initialize <<<
