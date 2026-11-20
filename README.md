# Git Bash

A minimal Bash environment for WezTerm that carries over the useful everyday tools and shortcuts from the Fish configuration.

## Startup

WezTerm launches Git Bash with this repository's `.bashrc`:

```text
C:/Program Files/Git/bin/bash.exe --rcfile /d/config/bash/.bashrc -i
```

The config initializes Git for Windows, sets missing `USER` and `LANG` defaults, and loads `ble.sh` from `~/.local/share/blesh/ble.sh` when installed. It attaches ble.sh before initializing the Fish Oh My Posh theme from `D:/config/fish/zen.toml`. This order matters: Oh My Posh detects `BLE_SESSION_ID` while generating its Bash integration and enables the transient prompt only when ble.sh is already attached.

Install `ble.sh` separately using its [official installation instructions](https://github.com/akinomyoga/ble.sh#quick-instructions). The config initially loads it with `--attach=none`, configures the rest of the shell and fzf integrations, then calls `ble-attach` immediately before Oh My Posh initialization.

When `ble.sh` is active, fzf uses the `ble.sh`-compatible `integration/fzf-completion` and `integration/fzf-key-bindings` modules instead of `fzf --bash`, which is not compatible with `ble.sh`'s line editor. Without `ble.sh`, the normal `fzf --bash` bindings are used.

## Included tools

- Oh My Posh with the shared path and Git prompt.
- fzf defaults and native Bash key bindings (Ctrl+R, Ctrl+T, Alt+C).
- eza or lsd directory listings, with system `ls` fallbacks.
- bat, fd, ripgrep, Neovim, Cargo, YAP and zoxide integrations when installed.
- Persistent Bash history.
- WezTerm shell integration when its script is available.

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
| `ls`, `ll`, `la`, `lla`, `lt`, `lta` | eza, lsd or standard listings |
| `cat`, `catp`, `catn` | bat or batcat |
| `fdh`, `fda`, `fdi`, `fdd` | fd variants |
| `grep`, `rgi`, `rga`, `rgf` | ripgrep variants |
| `c`, `cb`, `cbr`, `cr`, `ct`, `cchk` | Cargo |
| `v`, `vim`, `vi` | Neovim |
| `y`, `yap` | YAP |
| `mkcd`, `croot` | create-and-enter directory / Git root |
| `fcd`, `cproj`, `fopen`, `tfiles`, `frg` | fuzzy navigation and file/content search |
| `fbr`, `fbd`, `fshow` | interactive Git branch and commit tools |
| `fmenu` | small fzf action menu |

Optional tools are checked before their integrations are enabled. Missing tools do not prevent the shell from starting.
