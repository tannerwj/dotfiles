#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude ".osx" \
  --exclude "install.sh" \
  --exclude "README.md" \
  --exclude "LICENSE-MIT.txt" \
  --exclude "Brewfile" \
  --exclude "Brewfile.lock.json" \
  --exclude ".gitignore" \
  -avh --no-perms .gitconfig ~;

rsync --exclude ".private" \
  --exclude ".zplug" \
  --exclude ".zshrc" \
  -a shell/ ~/;

source ~/.bashrc;

# Pin ansible-core to 2.17 (community collections 10.x) — newer cores break our playbooks
if command -v uv >/dev/null 2>&1; then
  uv tool install --python 3.12 "ansible-core==2.17.*" --with "ansible==10.*"
fi
