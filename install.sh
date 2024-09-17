#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude ".osx" \
  --exclude "install.sh" \
  --exclude "README.md" \
  --exclude "LICENSE-MIT.txt" \
  -avh --no-perms shell/* ~;

source ~/.bashrc;
