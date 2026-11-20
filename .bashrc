export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export MANPAGER="${MANPAGER:-less -R}"
export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"

# History.
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# FZF defaults. Do not overwrite options supplied by the user.
_fzf_defaults=(
    '--height=60%'
    '--layout=reverse'
    '--border=rounded'
    '--info=inline'
)
for _option in "${_fzf_defaults[@]}"; do
    _name=${_option%%=*}
    [[ " ${FZF_DEFAULT_OPTS:-} " == *" ${_name}"* ]] || FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }$_option"
done
export FZF_DEFAULT_OPTS
unset _fzf_defaults _option _name

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-fd --type f --hidden --exclude .git}"
    export FZF_CTRL_T_COMMAND="${FZF_CTRL_T_COMMAND:-$FZF_DEFAULT_COMMAND}"
    export FZF_ALT_C_COMMAND="${FZF_ALT_C_COMMAND:-fd --type d --hidden --exclude .git}"
elif command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-rg --files --hidden -g '!.git'}"
    export FZF_CTRL_T_COMMAND="${FZF_CTRL_T_COMMAND:-$FZF_DEFAULT_COMMAND}"
fi


# Navigation and editor.
alias which='command -v'
alias v='nvim'
alias vim='nvim'
alias vi='nvim'


g()    { git "$@"; }
ga()   { git add "$@"; }
gaa()  { git add --all "$@"; }
gap()  { git add --patch "$@"; }
gb()   { git branch "$@"; }
gba()  { git branch --all "$@"; }
gbd()  { git branch --delete "$@"; }
gsw()  { git switch "$@"; }
gswc() { git switch --create "$@"; }
gc()   { git commit "$@"; }
gcm()  { git commit --message "$@"; }
gca()  { git commit --amend "$@"; }
gcan() { git commit --amend --no-edit "$@"; }
gs()   { git status --short --branch "$@"; }
gss()  { git status "$@"; }
gd()   { git diff "$@"; }
gds()  { git diff --staged "$@"; }
gl()   { git log --oneline --graph --decorate "$@"; }
gll()  { git log --graph --decorate "$@"; }
gf()   { git fetch "$@"; }
gp()   { git pull "$@"; }
gps()  { git push "$@"; }
gpsu() { git push --set-upstream origin HEAD "$@"; }
gcl()  { git clone "$@"; }
gr()   { git restore "$@"; }
grs()  { git restore --staged "$@"; }
gst()  { git stash push "$@"; }
gstl() { git stash list "$@"; }
gsta() { git stash apply "$@"; }
gstp() { git stash pop "$@"; }

# Directory listings: prefer eza, then lsd, then the system tools.
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
    alias ll='eza --long --group-directories-first'
    alias la='eza --all --group-directories-first'
    alias lla='eza --long --all --group-directories-first'
    alias lt='eza --tree --level=2'
    alias lta='eza --tree --all'
elif command -v lsd >/dev/null 2>&1; then
    alias ls='lsd --group-dirs first'
    alias ll='lsd --long --group-dirs first'
    alias la='lsd --almost-all --group-dirs first'
    alias lla='lsd --long --almost-all --group-dirs first'
    alias lt='lsd --tree --depth 2'
    alias lta='lsd --tree --all'
else
    alias ll='ls -lh'
    alias la='ls -A'
    alias lla='ls -lah'
fi


if command -v yap >/dev/null 2>&1; then
    y() { yap "$@"; }
elif [[ -x "$HOME/projects/yap/bin/yap" ]]; then
    yap() { "$HOME/projects/yap/bin/yap" "$@"; }
    y() { yap "$@"; }
fi

# Smart cd plus z/zi, if zoxide is installed.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
fi

# Fuzzy navigation and file workflows.
__require_fzf() {
    command -v fzf >/dev/null 2>&1 || {
        printf '%s: fzf is not installed\n' "$1" >&2
        return 127
    }
}

fcd() {
    __require_fzf fcd || return
    command -v zoxide >/dev/null 2>&1 || {
        printf 'fcd: zoxide is not installed\n' >&2
        return 127
    }
    local directory
    directory=$(zoxide query --list | fzf --prompt='jump > ' \
        --preview='lsd --tree --depth 2 --color=always {} 2>/dev/null || find {} -maxdepth 2 -print 2>/dev/null | head -80') || return
    [[ -n "$directory" ]] && cd -- "$directory"
}

__project_dirs() {
    local root=$1
    if command -v fd >/dev/null 2>&1; then
        fd --type d --hidden --exclude .git --exclude node_modules --exclude .cache \
            --exclude target --exclude dist --exclude build --max-depth 5 . "$root"
    else
        find "$root" -mindepth 1 -maxdepth 5 -type d \
            -not -path '*/.git/*' -not -path '*/node_modules/*' -not -path '*/.cache/*' \
            -not -path '*/target/*' -not -path '*/dist/*' -not -path '*/build/*'
    fi
}

cproj() {
    __require_fzf cproj || return
    local root=${PROJECTS_DIR:-"$HOME/projects"} directory
    [[ -d "$root" ]] || { printf 'cproj: project directory not found: %s\n' "$root" >&2; return 1; }
    directory=$(__project_dirs "$root" | fzf --prompt='project > ' \
        --preview='lsd --tree --depth 2 --color=always {} 2>/dev/null || find {} -maxdepth 2 -print 2>/dev/null | head -80') || return
    [[ -n "$directory" ]] && cd -- "$directory"
}

fopen() {
    __require_fzf fopen || return
    command -v nvim >/dev/null 2>&1 || { printf 'fopen: nvim is not installed\n' >&2; return 127; }
    local root=${1:-.} file
    [[ -d "$root" ]] || { printf 'fopen: directory not found: %s\n' "$root" >&2; return 1; }
    if command -v fd >/dev/null 2>&1; then
        file=$(fd --type f --hidden --exclude .git . "$root" |
            fzf --prompt='open > ' --preview='bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null || sed -n "1,200p" {}') || return
    else
        file=$(rg --files --hidden -g '!.git' "$root" 2>/dev/null |
            fzf --prompt='open > ' --preview='bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null || sed -n "1,200p" {}') || return
    fi
    [[ -n "$file" ]] && nvim -- "$file"
}
tfiles() { fopen "$@"; }

frg() {
    __require_fzf frg || return
    command -v rg >/dev/null 2>&1 || { printf 'frg: ripgrep is not installed\n' >&2; return 127; }
    command -v nvim >/dev/null 2>&1 || { printf 'frg: nvim is not installed\n' >&2; return 127; }
    local query="$*" match file line
    if [[ -z "$query" ]]; then
        read -r -p 'search > ' query
    fi
    [[ -n "$query" ]] || return 0
    match=$(rg --line-number --column --no-heading --color=never --smart-case --hidden \
        -g '!.git' -g '!node_modules' -- "$query" . 2>/dev/null |
        fzf --delimiter=: --with-nth='1,2,4..' --prompt='search > ' \
        --preview='bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || sed -n "1,160p" {1}' \
        --preview-window=down,55%,border-top) || return
    IFS=: read -r file line _ <<< "$match"
    [[ -n "$file" && "$line" =~ ^[0-9]+$ ]] && nvim "+$line" -- "$file"
}

# Interactive Git tools.
fbr() {
    __require_fzf fbr || return
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { printf 'fbr: not inside a Git repository\n' >&2; return 1; }
    local branch
    branch=$(git branch --format='%(refname:short)' |
        fzf --prompt='branch > ' --preview='git log --oneline --decorate --color=always -12 {}') || return
    [[ -n "$branch" ]] && git switch -- "$branch"
}

fbd() {
    __require_fzf fbd || return
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { printf 'fbd: not inside a Git repository\n' >&2; return 1; }
    local current branch
    current=$(git branch --show-current)
    branch=$(git branch --format='%(refname:short)' | awk -v current="$current" '$0 != current' |
        fzf --prompt='delete branch > ' --preview='git log --oneline --decorate --color=always -12 {}') || return
    [[ -n "$branch" ]] || return
    read -r -p "Delete branch '$branch' with git branch -d? [y/N] " answer
    [[ "$answer" == [yY] ]] && git branch --delete -- "$branch" || printf 'Cancelled. Branch left untouched.\n'
}

fshow() {
    __require_fzf fshow || return
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { printf 'fshow: not inside a Git repository\n' >&2; return 1; }
    local entry hash
    entry=$(git log -80 --format='%h %s' |
        fzf --prompt='commit > ' --preview='git show --color=always --stat --patch {1}') || return
    hash=${entry%% *}
    [[ -n "$hash" ]] && git show "$hash"
}

# A small action menu for the common interactive workflows.
fmenu() {
    __require_fzf fmenu || return
    local choice
    choice=$(printf '%s\n' \
        'Browse files' 'Search project contents' 'Open a project' 'Jump to a directory' \
        'Switch Git branch' 'Delete Git branch' 'Inspect recent commits' |
        fzf --prompt='actions > ' --height=60%) || return
    case "$choice" in
        'Browse files') fopen ;;
        'Search project contents') frg ;;
        'Open a project') cproj ;;
        'Jump to a directory') fcd ;;
        'Switch Git branch') fbr ;;
        'Delete Git branch') fbd ;;
        'Inspect recent commits') fshow ;;
    esac
}

# WezTerm integration is optional.
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

# fzf: Bash key bindings and completion (Ctrl+R, Ctrl+T, Alt+C).
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

# Oh My Posh: the only prompt provider.
if command -v oh-my-posh >/dev/null 2>&1; then
    _omp_theme='/d/config/bash/zen.toml'
    if [[ -r "$_omp_theme" ]]; then
        eval "$(oh-my-posh init bash --config "$_omp_theme")"
    else
        printf 'bash: Oh My Posh theme not found: %s\\n' "$_omp_theme" >&2
    fi
    unset _omp_theme
fi
