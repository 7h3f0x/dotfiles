# Dotfiles

This is my dotfiles repository. Currently dotfiles are managed using `stow`.
Dotfiles are currently being used on Ubuntu-20.04

## Installation

- Install stow and git, curl

```sh
sudo apt install stow git curl
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

- Since stow ignores gitignore and cvsignore files if it's own ignore file is
  not present, it will not stow that file for the `git` package. To get rid of
  this issues, just create an empty ignore file for stow:

```sh
touch ~/.stow-global-ignore
```

- Finally, run the install script

```sh
./install.sh
```

or manually setup for required programs like:

```sh
stow <program name>
```

## Other things

### Update zsh plugins

```sh
git submodule update --remote
```

### Basic Glyphs

For some of them:

```sh
sudo apt install fonts-powerline fonts-font-awesome
```

or install a nerd font (preferred) from [here](https://github.com/ryanoasis/nerd-fonts/)

### Install programs

- tmux, git, vim, zsh

```sh
sudo apt install tmux git vim-gtk3 zsh
```

- For nvim, build from [source](https://github.com/neovim/neovim#install-from-source) or grab a [release](https://github.com/neovim/neovim/releases) >= 0.5

- For tldr

```sh
npm i -g tldr
```

or use `npx` to run without global install

```sh
npx tldr <query>
```
