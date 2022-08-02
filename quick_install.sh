#!/bin/sh

set -u
set -e

if [ -d ~/dotfiles ]; then
    echo "Must already be prepared" 1>&2
    exit 1
fi

if grep -q '^ID.*=.*ubuntu' /etc/os-release ; then
    sudo apt-get install -y stow git
else
    echo "Unsupported OS" 1>&2
    exit 1
fi

git clone https://github.com/7h3f0x/dotfiles.git ~/dotfiles

[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
[ -f ~/.profile ] && mv ~/.profile ~/.profile.bak

cd ~/dotfiles || exit 1
git submodule init
git submodule update
./install.sh
