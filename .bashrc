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
# Keep inherited prompt hooks out of this shell. Terminal integrations are added below.
PROMPT_COMMAND='history -a; history -n'

# fzf shell integration: Ctrl+R, Ctrl+T, and Alt+C.
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

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

# Minmax fzf palette. Set MINMAX_DIR if the theme repository lives elsewhere.
_minmax_dir=${MINMAX_DIR:-}
if [[ -z "$_minmax_dir" ]]; then
    for _candidate in /d/projects/minmax.nvim /d/config/minmax.nvim "$HOME/projects/minmax.nvim"; do
        if [[ -r "$_candidate/ports/fzf/minmax-phosphor.sh" ]]; then
            _minmax_dir=$_candidate
            break
        fi
    done
fi

_minmax_variant=${MINMAX_FZF_VARIANT:-phosphor}
_minmax_theme="$_minmax_dir/ports/fzf/minmax-$_minmax_variant.sh"
if [[ -n "$_minmax_dir" && -r "$_minmax_theme" ]]; then
    source "$_minmax_theme"
fi
unset _minmax_dir _minmax_variant _minmax_theme _candidate

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

# Minmax file-type colors. These indexed slots are defined by the matching
# WezTerm color scheme, so directories, executables and file classes differ.
# Directories=green, executables=amber, links=string, archives=red.
# Keep the semantic indexed-color numbers identical across all Minmax variants.
export LS_COLORS='di=1;38;5;19:ex=1;38;5;22:ln=1;38;5;24:or=1;38;5;25:mi=38;5;25:pi=38;5;23:so=1;38;5;23:bd=1;38;5;20:cd=1;38;5;20:su=1;38;5;25:sg=1;38;5;22:tw=1;38;5;19:ow=1;38;5;19:*.tar=1;38;5;25:*.tgz=1;38;5;25:*.arc=1;38;5;25:*.arj=1;38;5;25:*.taz=1;38;5;25:*.lha=1;38;5;25:*.lz4=1;38;5;25:*.lzh=1;38;5;25:*.lzma=1;38;5;25:*.tlz=1;38;5;25:*.txz=1;38;5;25:*.tzo=1;38;5;25:*.t7z=1;38;5;25:*.zip=1;38;5;25:*.z=1;38;5;25:*.dz=1;38;5;25:*.gz=1;38;5;25:*.lrz=1;38;5;25:*.lz=1;38;5;25:*.lzo=1;38;5;25:*.xz=1;38;5;25:*.zst=1;38;5;25:*.tzst=1;38;5;25:*.bz2=1;38;5;25:*.bz=1;38;5;25:*.tbz=1;38;5;25:*.tbz2=1;38;5;25:*.tz=1;38;5;25:*.deb=1;38;5;25:*.rpm=1;38;5;25:*.jar=1;38;5;25:*.war=1;38;5;25:*.ear=1;38;5;25:*.sar=1;38;5;25:*.rar=1;38;5;25:*.alz=1;38;5;25:*.ace=1;38;5;25:*.zoo=1;38;5;25:*.cpio=1;38;5;25:*.7z=1;38;5;25:*.rz=1;38;5;25:*.cab=1;38;5;25:*.wim=1;38;5;25:*.swm=1;38;5;25:*.dwm=1;38;5;25:*.esd=1;38;5;25:*.jpg=38;5;23:*.jpeg=38;5;23:*.png=38;5;23:*.gif=38;5;23:*.webp=38;5;23:*.bmp=38;5;23:*.svg=38;5;23:*.mp3=38;5;18:*.flac=38;5;18:*.wav=38;5;18:*.ogg=38;5;18:*.mp4=38;5;18:*.mkv=38;5;18:*.webm=38;5;18:*.pdf=38;5;17:*.md=38;5;17:*.c=38;5;17:*.h=38;5;17:*.lua=38;5;17:*.toml=38;5;17:*.json=38;5;17'

# Directory listings: prefer eza, then lsd, then the system tools.
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza --color=auto --long --group-directories-first'
    alias la='eza --color=auto --all --group-directories-first'
    alias lla='eza --color=auto --long --all --group-directories-first'
    alias lt='eza --color=auto --tree --level=2'
    alias lta='eza --color=auto --tree --all'
elif command -v lsd >/dev/null 2>&1; then
    alias ls='lsd --color=auto --group-dirs first'
    alias ll='lsd --color=auto --long --group-dirs first'
    alias la='lsd --color=auto --almost-all --group-dirs first'
    alias lla='lsd --color=auto --long --almost-all --group-dirs first'
    alias lt='lsd --color=auto --tree --depth 2'
    alias lta='lsd --color=auto --tree --all'
else
    alias ls='command ls --color=auto --group-directories-first'
    alias ll='ls -lh'
    alias la='ls -A --color=auto'
    alias lla='ls -lah --color=auto'
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
