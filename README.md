# Git Bash

Minimal Git Bash configuration for WezTerm on Windows.

## What it includes

- Oh My Posh using the shared minimal theme at `D:/config/powershell/zen.toml`
- Git shortcuts matching the PowerShell setup
- Optional lsd aliases
- fzf Ctrl+R history search in a compact popup
- Persistent Bash history across sessions
- Optional WezTerm shell integration when its script is installed in a standard location

## WezTerm

The WezTerm configuration launches Git Bash directly with this repository's `.bashrc`:

```text
C:/Program Files/Git/bin/bash.exe --rcfile D:/config/bash/.bashrc -i
```

The config sources Git for Windows' `/etc/profile` before applying these settings, so PATH and MSYS environment setup are retained.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| Ctrl+R | Search recent commands with fzf |
| `gs` | Git status |
| `ga` | Git add |
| `gco` | Git switch |
| `gcb` | Create and switch branch |
| `gcm` | Git commit |
| `gpl` | Git pull --ff-only |
| `gps` | Git push |
| `glog` | Compact graph log |
| `mkcd` | Create and enter a directory |
| `v` / `vi` | Vim |

The shell remains Bash. No Vi editing mode or extra prompt decorations are enabled by this repository.
