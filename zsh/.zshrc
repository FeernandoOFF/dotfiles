# ---- ZSH Init configuration ----

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""            # prompt is handled by oh-my-posh, not an omz theme
plugins=(
  git
  eza
  zsh-autosuggestions
  zsh-vi-mode
  zsh-syntax-highlighting
)

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

function zvm_after_init() {
  zvm_bindkey viins '^[[1;5D' backward-word
  zvm_bindkey viins '^[[1;5C' forward-word
  zvm_bindkey viins '^[b' backward-word
  zvm_bindkey viins '^[f' forward-word
  zvm_bindkey viins '^A' beginning-of-line
  zvm_bindkey viins '^E' end-of-line
  zvm_bindkey viins '^[[3~' delete-char
  zvm_bindkey viins '^[[3;5~' kill-word
  zvm_bindkey viins '^[^?' backward-kill-word
  zvm_bindkey viins '^W' backward-kill-word
  zvm_bindkey viins '^U' backward-kill-line
}

ZVM_INIT_MODE=sourcing
source $ZSH/oh-my-zsh.sh


# ---- Prompt: oh-my-posh ----
eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/config.yaml")"


# ---- Platform configuration ----

# Homebrew (MacOS)
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"


# ---- Aliases ----

alias lz='lazygit'
alias vi='nvim'
alias e='yazi'

alias oc='opencode'
alias cc='claude'

alias gw='git switch'
alias f='fzf --preview "cat {}"'
alias fvi='vi $(fzf --preview "cat {}")'
alias cl='clear'


# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi


# ---- Tooling ----

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


# fzf
if [[ -d "$HOME/.fzf/bin" && ":$PATH:" != *":$HOME/.fzf/bin:"* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi


export PATH=$PATH:$HOME/.maestro/bin

# Herdr
function zz {
    herdr "$@"
}

# Pi
export PATH="$HOME/.local/share/mise/installs/node/24.13.0/bin:$PATH"

# Android development
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

_ai_opencode_text() {
    local -a model_args
    [[ -n "$2" ]] && model_args=(--model "$2")

    opencode run --pure --agent summary --format json "${model_args[@]}" "$1" 2>/dev/null \
        | jq -rs '[.[] | select(.type == "text") | .part.text? // empty] | join("")'
}

# Shared choice generators reused by the ZLE widgets and command_not_found_handler.
_ai_command_choices() {
    local request="$1" response
    response=$(_ai_opencode_text "You generate safe zsh commands for macOS. Do not use tools. Based on the request, return 3 to 5 useful alternatives as compact JSON only, with no markdown or commentary. Use this exact schema: [{\"title\":\"short explanation\",\"content\":\"one-line command\"}]. Do not include tabs or newlines inside values. Never execute anything. Working directory: $PWD. Request: $request" "openai/gpt-5.6-luna")
    print -r -- "$response" | jq -r '
        if type == "array" then .[] else empty end
        | select((.title | type) == "string" and (.content | type) == "string")
        | [(.content | gsub("[\\t\\r\\n]+"; " ")), (.title | gsub("[\\t\\r\\n]+"; " "))]
        | @tsv
    ' 2>/dev/null
}

_ai_answer_choices() {
    local question="$1" response
    response=$(_ai_opencode_text "Answer the user's question without using tools. Return 2 to 4 useful answer or code-snippet alternatives as compact JSON only, with no markdown outside the JSON. Use this exact schema: [{\"title\":\"short choice label\",\"content\":\"complete answer or snippet\"}]. Working directory context: $PWD. Question: $question")
    print -r -- "$response" | jq -r '
        if type == "array" then .[] else empty end
        | select((.title | type) == "string" and (.content | type) == "string")
        | [(.title | gsub("[\\t\\r\\n]+"; " ")), (.content | @base64)]
        | @tsv
    ' 2>/dev/null
}

ai-command-widget() {
    local request="$BUFFER"
    local choices selection

    if [[ -z "${request//[[:space:]]/}" ]]; then
        zle -M "Type a command request first"
        return
    fi

    zle -M "Generating commands..."
    zle -R
    choices=$(_ai_command_choices "$request")

    if [[ -z "$choices" ]]; then
        zle -M "OpenCode did not return any commands"
        zle reset-prompt
        return
    fi

    zle -I
    selection=$(print -r -- "$choices" | fzf \
        --height=60% --layout=reverse --border \
        --delimiter=$'\t' --with-nth=1,2 \
        --prompt='AI command> ' --header='Enter: insert  Esc: cancel')

    if [[ -n "$selection" ]]; then
        BUFFER="${selection%%$'\t'*}"
        CURSOR=${#BUFFER}
    fi
    zle reset-prompt
}

ai-answer-widget() {
    local question="$BUFFER"
    local choices selection encoded answer

    if [[ -z "${question//[[:space:]]/}" ]]; then
        zle -M "Type a question first"
        return
    fi

    zle -M "Asking OpenCode..."
    zle -R
    choices=$(_ai_answer_choices "$question")

    if [[ -z "$choices" ]]; then
        zle -M "OpenCode did not return an answer"
        zle reset-prompt
        return
    fi

    zle -I
    selection=$(print -r -- "$choices" | fzf \
        --height=80% --layout=reverse --border \
        --delimiter=$'\t' --with-nth=1 \
        --preview='printf %s {2} | base64 --decode' \
        --preview-window='right,65%,wrap' \
        --prompt='AI answer> ' --header='Enter: insert  Esc: cancel')

    if [[ -n "$selection" ]]; then
        encoded="${selection#*$'\t'}"
        answer=$(printf '%s' "$encoded" | base64 --decode)
        BUFFER="$answer"
        CURSOR=${#BUFFER}
    fi
    zle reset-prompt
}

zle -N ai-command-widget
zle -N ai-answer-widget
bindkey '^G' ai-command-widget
bindkey '^[g' ai-command-widget
bindkey '^[a' ai-answer-widget

# Conservative check: does an unrecognized line look like a natural-language question?
_ai_looks_like_question() {
    local line="$1"
    [[ "$line" == *[[:space:]]* ]] || return 1
    [[ "$line" == *\? ]] && return 0
    local first="${line%%[[:space:]]*}"
    case "${first:l}" in
        how|what|why|where|when|who|which|whats|\
        can|could|should|would|will|is|are|do|does|did|\
        list|show|find|explain|create|make|convert|install|remove|delete|generate|write|search)
            return 0 ;;
    esac
    return 1
}

_ai_notfound_commands() {
    local choices selection
    print -u2 "Generating commands..."
    choices=$(_ai_command_choices "$1")
    if [[ -z "$choices" ]]; then
        print -u2 "OpenCode did not return any commands"
        return
    fi
    selection=$(print -r -- "$choices" | fzf \
        --height=60% --layout=reverse --border \
        --delimiter=$'\t' --with-nth=1,2 \
        --prompt='AI command> ' --header='Enter: load  Esc: cancel')
    [[ -n "$selection" ]] && print -z "${selection%%$'\t'*}"
}

_ai_notfound_ask() {
    local choices selection encoded answer
    print -u2 "Asking OpenCode..."
    choices=$(_ai_answer_choices "$1")
    if [[ -z "$choices" ]]; then
        print -u2 "OpenCode did not return an answer"
        return
    fi
    selection=$(print -r -- "$choices" | fzf \
        --height=80% --layout=reverse --border \
        --delimiter=$'\t' --with-nth=1 \
        --preview='printf %s {2} | base64 --decode' \
        --preview-window='right,65%,wrap' \
        --prompt='AI answer> ' --header='Enter: insert  Esc: cancel')
    if [[ -n "$selection" ]]; then
        encoded="${selection#*$'\t'}"
        answer=$(printf '%s' "$encoded" | base64 --decode)
        print -z "$answer"
    fi
}

# Pass unmatched glob patterns through literally instead of aborting the line, so
# questions ending in '?' reach command_not_found_handler rather than "no matches found".
setopt nonomatch

command_not_found_handler() {
    local line="$*"
    if [[ ! -o interactive ]] || ! command -v opencode >/dev/null 2>&1 || ! _ai_looks_like_question "$line"; then
        print -u2 "zsh: command not found: $1"
        return 127
    fi
    print -u2 -P "%F{yellow}zsh:%f '$line' — looks like a question  %F{cyan}[any] commands  [a] ask  [q] ignore%f"
    local key
    read -k 1 -s key
    case "$key" in
        a|A) _ai_notfound_ask "$line" ;;
        q|Q|$'\n'|$'\r'|$'\e') : ;;
        *) _ai_notfound_commands "$line" ;;
    esac
    return 127
}

if command -v pass-cli >/dev/null 2>&1 && command -v ssh-add >/dev/null 2>&1; then
    if ! ssh-add -l >/dev/null 2>&1; then
        pass-cli ssh-agent load >/dev/null 2>&1
    fi
fi
