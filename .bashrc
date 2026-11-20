# Git Bash configuration for WezTerm.
# Git Bash is launched with --rcfile, so initialize the Git for Windows environment here.
if [[ -z "${GIT_BASH_PROFILE_LOADED:-}" ]]; then
    export GIT_BASH_PROFILE_LOADED=1
    [[ -f /etc/profile ]] && source /etc/profile
fi

# History: keep it across sessions without duplicate adjacent entries.
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize

# Compact fzf popup defaults. Preserve options supplied by the environment.
_fzf_defaults=(
    '--height=60%'
    '--layout=reverse'
    '--border=rounded'
    '--info=inline'
    '--margin=1'
    '--padding=1'
)
for _option in "${_fzf_defaults[@]}"; do
    _name=${_option%%=*}
    [[ " ${FZF_DEFAULT_OPTS:-} " == *" ${_name}"* ]] || FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }$_option"
done
export FZF_DEFAULT_OPTS
unset _fzf_defaults _option _name

# Ctrl+R: search recent commands, newest first.
__fzf_history() {
    local selected
    selected=$(
        history |
            sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//' |
            tac |
            awk 'NF && !seen[$0]++' |
            fzf --no-sort --query="$READLINE_LINE"
    ) || return

    if [[ -n "$selected" ]]; then
        READLINE_LINE=$selected
        READLINE_POINT=${#READLINE_LINE}
    fi
}

if command -v fzf >/dev/null 2>&1; then
    bind -x '"\C-r": __fzf_history'
fi

# Small navigation and Git shortcuts.
alias c='cd'
alias which='command -v'
alias vi='vim'

mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

g()    { git "$@"; }
gs()   { git status --short --branch "$@"; }
ga()   { git add "$@"; }
gco()  { git switch "$@"; }
gcb()  { git switch -c "$@"; }
gcm()  { git commit "$@"; }
gpl()  { git pull --ff-only "$@"; }
gps()  { git push "$@"; }
glog() { git log --oneline --graph --decorate "$@"; }

# Use lsd when available; retain standard ls otherwise.
if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd'
    ll() { lsd -l "$@"; }
    la() { lsd -la "$@"; }
    lt() { lsd --tree "$@"; }
fi

# Reuse the minimal Oh My Posh theme already used by PowerShell.
if command -v oh-my-posh >/dev/null 2>&1; then
    _omp_theme='/d/config/powershell/zen.toml'
    if [[ -f "$_omp_theme" ]]; then
        eval "$(oh-my-posh init bash --config "$_omp_theme")"
    fi
    unset _omp_theme
fi

# Persist new history before each prompt and import commands from other sessions.
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# WezTerm shell integration is optional and loaded only when its script is available.
if [[ -n "${WEZTERM_PANE:-}" ]]; then
    for _wezterm_integration in \
        '/c/Program Files/WezTerm/shell-integration/wezterm.sh' \
        '/c/Program Files/WezTerm/share/wezterm/shell-integration/wezterm.sh' \
        '/c/Program Files/WezTerm/wezterm/shell-integration/wezterm.sh'; do
        if [[ -f "$_wezterm_integration" ]]; then
            source "$_wezterm_integration"
            break
        fi
    done
    unset _wezterm_integration
fi
