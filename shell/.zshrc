# If we're not running interactively then bail out
[[ -z $PS1 ]] && return

# Source shell modules (.exports already loaded via .zshenv)
_dotfiles="${0:A:h}"
for file in "$_dotfiles"/.{aliases,zplug,functions,private}; do
  [[ -r $file ]] && source "$file"
done
unset _dotfiles

# Zsh options
setopt sharehistory appendhistory globassign globdots extendedglob
zstyle ':completion:*' correct true

# SSH hostname completion from config
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# History expansion with space
bindkey " " magic-space
