#!/bin/zsh

# setup brew for apple silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# If we're not running interactively then bail out
[[ -z $PS1 ]] && return

# Get the directory of the file being executed
current_dir=$(dirname "$(readlink -f "$0")")

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

# Include hidden files and directories in expansion
setopt globdots

# Enable extended pattern matching features
setopt extendedglob

# Append to the history file instead of overwriting
setopt appendhistory

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Typing "!!<space>" will replace "!!" with the previous command
bindkey " " magic-space

# Preferred text editors ordered by priority (space-separated)
EDITOR_PRIORITY='vim vi nano pico'

# Bundle all certificate CAs for use with python
security find-certificate -a -p > ~/Desktop/all_certs_for_python.pem # custom
cat /opt/homebrew/etc/ca-certificates/cert.pem >> ~/Desktop/all_certs_for_python.pem # from homebrew ca-certificates
