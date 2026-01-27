#!/bin/zsh

# setup brew for apple silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# If we're not running interactively then bail out
[[ -z $PS1 ]] && return

# Get the directory of the file being executed (portable on macOS)
current_dir=${0:A:h}

# Define the files to source
files=("$current_dir"/.{exports,aliases,zplug,functions,private})

# Source each file if it exists and is readable
for file in "${files[@]}"; do
  [[ -r $file ]] && source "$file"
done

# Autocorrect typos when changing path with "cd"
# setopt correct

# Check if command exists in hash table before executing
#setopt correctall

# Save multi-line commands as a single entry
setopt sharehistory

# Replace directory names with results of word expansion
setopt globassign

# Try to autocorrect typos during directory completion
zstyle ':completion:*' correct true

# Prefer longest common prefix on Tab; avoid "first match" inserts
unsetopt menu_complete
setopt auto_menu

# Faster, friendlier completion behavior
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Include hidden files and directories in expansion
setopt globdots

# Enable extended pattern matching features
setopt extendedglob

# Append to the history file instead of overwriting
setopt appendhistory

# Zsh history hygiene
setopt inc_append_history
setopt hist_ignore_space
setopt hist_reduce_blanks
HISTSIZE=32768
SAVEHIST=32768

# Typing "!!<space>" will replace "!!" with the previous command
bindkey " " magic-space

# Preferred text editors ordered by priority (space-separated)
EDITOR_PRIORITY='vim vi nano pico'
