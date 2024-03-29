# Dotfiles

This is my dotfiles repository. Currently dotfiles are managed using `stow`.
Dotfiles are currently being used on Ubuntu 22.04 on WSL2.

## Installation

- Install stow and git

```sh
sudo apt install stow git
```

```sh
git clone git@github.com:7h3f0x/dotfiles.git
```

or

```sh
git clone https://github.com/7h3f0x/dotfiles.git
```

- If `.bashrc` or `.profile` already exists

```sh
mv ~/.bashrc ~/.bashrc.bak
mv ~/.profile ~/.profile.bak
```

Similarly for any other such files/directories as well

- Loading zsh plugin's submodules

```sh
git submodule init
git submodule update
```

- Finally, run the install script

```sh
./install.sh
```

or manually setup for required programs like:

```sh
stow <program name>
```

- For nvim, install [packer.nvim](https://github.com/wbthomason/packer.nvim), then execute `:PackerSync` inside.
Currently, this method works:
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

## Other things

### Update zsh plugins

```sh
git submodule update --remote
```

### Basic Glyphs

Methods available:

- For some of them:

```sh
sudo apt install fonts-powerline fonts-font-awesome
```

- Install a nerd font (preferred) from [here](https://github.com/ryanoasis/nerd-fonts/)

E.g., for Ubuntu Mono:

```sh
mkdir -p ~/.local/share/fonts/UbuntuMono
cd ~/.local/share/fonts/UbuntuMono
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf"
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular-Italic/complete/Ubuntu%20Mono%20Italic%20Nerd%20Font%20Complete.ttf"
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Bold/complete/Ubuntu%20Mono%20Bold%20Nerd%20Font%20Complete.ttf"
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Bold-Italic/complete/Ubuntu%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete.ttf"
```

for Hack (Monospace glyphs)
```sh
mkdir -p ~/.local/share/fonts/Hack
cd ~/.local/share/fonts/Hack
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/complete/Hack%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
```

**NOTE** For Windows Terminal, get fonts from [here](https://github.com/adam7/delugia-code/releases), install all files included in zip file from release

- Use fontconfig to prepend nerd icons

```sh
mkdir -p ~/.local/share/fonts/
cd ~/.local/share/fonts/
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-2048-em%20Nerd%20Font%20Complete.ttf"

mkdir -p ~/.config/fontconfig
cd ~/.config/fontconfig

cat << EOF > fonts.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match>
        <test qual="any" name="family">
            <string>Ubuntu Mono</string>
            <!-- other fonts here -->
        </test>
        <edit name="family" mode="prepend" binding="strong">
            <string>Symbols Nerd Font</string>
        </edit>
    </match>
</fontconfig>
EOF
fc-cache -fv
```

### Install programs

- tmux, git, vim, zsh

```sh
sudo apt install tmux git vim-gtk3 zsh
```

- For nvim, build from
  [source](https://github.com/neovim/neovim#install-from-source) / grab a
  [release](https://github.com/neovim/neovim/releases) / use one provided by
  package manager

- For tldr

Use `pip` (or better `pipx`)

```sh
pipx install tldr
```
OR
```sh
pip3 install tldr
```

## `xdg-open` on WSL2

Save the following into `~/bin/xdg-open`

```sh
#!/bin/sh

exec powershell.exe -c start "$@"
```

Opens files from WSL in default programs for that file format
