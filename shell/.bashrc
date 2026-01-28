#!/usr/bin/env bash

# If we're not running interactively then bail out
[[ -z $PS1 ]] && return

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in .{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Autocorrect typos when changing path with "cd"
shopt -s cdspell

# Check if hashed commands exist before executing
shopt -s checkhash

# Check for stopped or running jobs before exiting
shopt -s checkjobs

# Update the window size after every command
shopt -s checkwinsize

# Try and save multi-line commands as a single entry
shopt -s cmdhist

# Replace directory names with results of word expansion
shopt -s direxpand

# Try to autocorrect typos during directory completion
shopt -s dirspell

# Include hidden files and directories in expansion
shopt -s dotglob

# Enable extended pattern matching features
shopt -s extglob

# Enable support for recursive globbing via "**"
shopt -s globstar

# Append to the history file instead of overwriting
shopt -s histappend

# Keep history file private
HISTFILE=${HISTFILE:-$HOME/.bash_history}
[[ -f "$HISTFILE" ]] && chmod 600 "$HISTFILE"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

####################
### Prompt Setup ###
####################

# Default to using a colour prompt for terminal types we know are compatible
case "$TERM" in
    *-256color|xterm-color) colour_prompt=yes ;;
esac

# Force usage of a colour prompt (we'll still sanity check the terminal)
force_colour_prompt=no

# If we elected to force a colour prompt check the terminal can support it
if [[ $force_colour_prompt == "yes" ]]; then
    if [[ -x /usr/bin/tput ]] && tput setaf 1 >& /dev/null; then
        colour_prompt=yes
    fi
fi

# Configure the prompt appropriately (colour if requested & Git if available)
if [[ -n $colour_prompt ]]; then
    if typeset -F __git_ps1 > /dev/null; then
        PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\$(__git_ps1)\[\033[00m\]\$ "
    else
        PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
    fi
elif typeset -F __git_ps1 > /dev/null; then
    PS1="\u@\h:\w\$(__git_ps1)\$ "
else
    PS1="\u@\h:\w\$ "
fi
unset colour_prompt force_colour_prompt

##########################
### Command Completion ###
##########################

# Enable more powerful command completion if available
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    # shellcheck source=/dev/null
    source /etc/bash_completion
fi

# Typing "!!<space>" will replace "!!" with the previous command
bind Space:magic-space

# Preferred text editors ordered by priority (space-separated)
EDITOR_PRIORITY='vim vi nano pico'

# Locations to prefix to PATH (colon-separated)
EXTRA_PATHS=''
