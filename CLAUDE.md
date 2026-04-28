# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing a macOS development environment with a focus on DevOps/Cloud Engineering tooling (Kubernetes, Docker, Terraform, Ansible, Vault).

## Common Commands

### Installation & Synchronization
```bash
./install.sh              # Sync dotfiles to home directory (pulls latest, rsyncs configs)
brew bundle               # Install all packages from Brewfile
```

### Shell Configuration
```bash
source ~/.bashrc          # Reload bash configuration
# or just restart terminal for zsh changes
```

## Architecture & Key Patterns

### Modular Shell Configuration
Shell configuration is broken into functional modules:
- `.bashrc`/`.zshrc` - Shell initialization that sources other files
- `.exports` - Environment variables and language settings
- `.aliases` - Command shortcuts and tool-specific aliases
- `.functions` - Complex shell functions
- `.zplug` - Zsh plugin manager configuration
- `.private` - Local-only sensitive configs (not in git)

Both bash and zsh are supported, with zsh being the primary shell using powerlevel10k theme and modern plugins (autosuggestions, syntax highlighting, autocomplete).

### Conditional Loading Pattern
Aliases and functions check for tool existence before loading to prevent errors:
```bash
if [[ -x $(which kubectl) ]]; then
    alias k='kubectl'
fi
```

### Environment-Specific Configuration
- OS detection with `[[ "$OSTYPE" == "darwin"* ]]` for macOS-specific settings
- Apple Silicon Homebrew support via `/opt/homebrew/bin/brew`
- Lazy loading for performance-heavy tools (NVM, pyenv)

### Git Synchronization Strategy
The `install.sh` script uses rsync to sync dotfiles while excluding:
- `.git` directory and git metadata
- OS-generated files (`.DS_Store`, `Thumbs.db`)
- Sensitive files (`.private`)
- Lock files (`Brewfile.lock.json`)
- IDE metadata (`.codegpt`)

### Enterprise Tool Integration
- **Vault**: Configured with namespace support and certificate-based authentication
- **Private PyPI**: `PIP_INDEX_URL` points to `nexus.taxhawk.com`
- **SOPS**: Age encryption key at `~/.config/sops/age/keys.txt`
- **Step CA**: Custom `ssh()` function in `.functions` manages certificate validation

### Notable Custom Functions
- `ssh()` - Wraps SSH with Step CA certificate management
- `kgip()` - Find Kubernetes resources by IP using kubectl + jq
- `swap_and_push()` - Docker image repository swapping utility
- `create_iterm_ssh_window()` - Creates iTerm2 SSH session grids via AppleScript

### Kubernetes Tooling
Heavy kubectl usage with extensive aliases when kubectl is installed:
- `k` - kubectl shorthand
- `kgp`, `kgd`, `kgn` - get pods/deployments/namespaces
- `kdp`, `kdd` - describe pods/deployments
- Uses `kubecolor` automatically if installed

### Package Management
The `Brewfile` is the source of truth for installed packages and applications. It includes:
- Development tools (node, npm, pyenv, uv)
- Kubernetes ecosystem (kubectl, helm, kustomize, flux, operator-sdk)
- Infrastructure as Code (terraform via tfenv, vault, sops)
- CLI utilities (jq, eza, nmap, zsh, zplug)
- macOS applications (browsers, VS Code, iTerm2, Slack, 1Password, Rectangle)

## Important Notes

- The `.private` file is not version-controlled and should contain local-only sensitive environment variables
- Certificate bundling for Python SSL is generated on shell startup (see `.zshrc`)
- Homebrew auto-update is throttled to weekly (604800 seconds)
- Pull strategy for git is set to rebase by default
