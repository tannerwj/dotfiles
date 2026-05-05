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

rsync --exclude ".zplug" \
  --exclude ".zshrc" \
  -a shell/ ~/;

source ~/.bashrc;

# Python CA bundle: system keychain + homebrew CAs
# Kept out of ~/Desktop because macOS TCC blocks subprocess reads there
if [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir -p ~/.config/ssl
  security find-certificate -a -p > ~/.config/ssl/python-ca-bundle.pem
  [ -f /opt/homebrew/etc/ca-certificates/cert.pem ] && \
    cat /opt/homebrew/etc/ca-certificates/cert.pem >> ~/.config/ssl/python-ca-bundle.pem
fi

# Pin ansible-core to 2.17 (community collections 10.x) — newer cores break our playbooks
# Inject Python deps required by playbook modules into ansible's isolated venv
if command -v uv >/dev/null 2>&1; then
  uv tool install --python 3.12 "ansible-core==2.17.*" \
    --with "ansible==10.*" \
    --with requests \
    --with hvac \
    --with kubernetes \
    --with jmespath \
    --with netaddr \
    --with passlib \
    --with pywinrm \
    --with zabbix-api
fi
