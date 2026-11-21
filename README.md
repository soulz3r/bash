# Git Bash

A minimal Bash environment for WezTerm that carries over the useful everyday tools and shortcuts from the Fish configuration.

## Startup

WezTerm launches Git Bash with this repository's `.bashrc`:

```text
C:/Program Files/Git/bin/bash.exe --rcfile /d/config/bash/.bashrc -i
```

The config keeps Bash history, Git shortcuts, fzf workflows and optional tool integrations. It initializes fzf's native Bash key bindings when fzf is installed, loads the selected Minmax fzf palette when available, and then loads Oh My Posh from the repository's `zen.toml` at `/d/config/bash/zen.toml`.

## Included tools

- Oh My Posh with the shared path and Git prompt.
- fzf defaults, Minmax palette integration, and native Bash key bindings (Ctrl+R, Ctrl+T, Alt+C).
- lsd directory listings, with a system `ls` fallback.
- fd, ripgrep, bat, Neovim, YAP and zoxide integrations when installed.
- Persistent Bash history.
- Minimal Vim config in `.vimrc` (symlink it to `~/.vimrc`).

## Terminal colors

The shell uses a green-dominant `LS_COLORS` mapping: directories are bold bright green, executables are bold green, and source/configuration files use softer green. Amber is reserved for documentation and secondary emphasis; red marks errors and archives. The mapping uses standard ANSI color slots and does not require WezTerm-specific palette indexes.

When `minmax.nvim` is present, Bash loads its phosphor fzf palette by default. Set `MINMAX_DIR` if the theme repository is outside the detected locations, or set `MINMAX_FZF_VARIANT` to `mono`, `amber`, or `oxide` to select another fzf variant. The fzf theme files live in `minmax.nvim/ports/fzf/`.

## Vim configuration

The repository includes a minimal `.vimrc` adapted from CVIM's core options and keymaps. Link it on Git Bash with:

```bash
ln -sfn /d/config/bash/.vimrc ~/.vimrc
```

The Vim config includes relative/absolute line numbers, two-space indentation, search behavior, split/window navigation, centered search results, line movement, and the shared `,,` escape mapping. Neovim-only LSP, DAP, plugin, and UI mappings are not copied because plain Vim does not provide those CVIM features.

## Git shortcuts

Bash does not have Fish-style abbreviation expansion. The same command names are provided as small functions instead.

| Command | Expansion |
| --- | --- |
| `g` | `git` |
| `ga` / `gaa` / `gap` | add / add --all / add --patch |
| `gb` / `gba` / `gbd` | branch / branch --all / branch --delete |
| `gsw` / `gswc` | switch / switch --create |
| `gc` / `gcm` / `gca` / `gcan` | commit / commit --message / amend / amend --no-edit |
| `gs` / `gss` | short status / full status |
| `gd` / `gds` | diff / diff --staged |
| `gl` / `gll` | compact graph log / graph log |
| `gf` / `gp` / `gps` / `gpsu` | fetch / pull / push / push with upstream |
| `gcl` | clone |
| `gr` / `grs` | restore / restore --staged |
| `gst` / `gstl` / `gsta` / `gstp` | stash push / list / apply / pop |

## Other shortcuts

| Command | Action |
| --- | --- |
| `ls`, `ll`, `la`, `lla`, `lt`, `lta` | lsd or standard listings |
| `v` | Neovim |
| `y`, `yap` | YAP |
| `fcd`, `cproj`, `fopen`, `tfiles`, `frg` | fuzzy navigation and file/content search |
| `fbr`, `fbd`, `fshow` | interactive Git branch and commit tools |
| `fmenu` | small fzf action menu |

Optional tools are checked before their integrations are enabled. Missing tools do not prevent the shell from starting. `fd` is preferred for file discovery, with ripgrep or standard utilities used where supported. `lsd` is preferred for directory listings, with the system `ls` as a fallback.
