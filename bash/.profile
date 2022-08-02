# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$UID}

prepend_to_path() {
    if [ -d "$1" ] ; then
        PATH="$1:$PATH"
    fi
}

append_to_path() {
    if [ -d "$1" ] ; then
        PATH="$PATH:$1"
    fi
}

# For npm installed via apt
if command -v npm &>/dev/null ; then
    export NPM_CONFIG_PREFIX=${XDG_DATA_HOME}/npm
    export NPM_CONFIG_CACHE=${XDG_CACHE_HOME}/npm
    export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
    prepend_to_path "${NPM_CONFIG_PREFIX}/bin"
fi

prepend_to_path "$HOME/.cargo/bin"

if [ -d "$HOME/go" ] ; then
    export GOPATH="$HOME/go"
    prepend_to_path "$GOPATH/bin"
fi

# set PATH so it includes user's private bin if it exists
prepend_to_path "$HOME/.local/bin"

# set PATH so it includes user's private bin if it exists
prepend_to_path "$HOME/bin"

# Check if we are Running WSL2
if uname -a | grep microsoft &>/dev/null ; then
    export IS_WSL=1
fi

export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

export BAT_THEME=TwoDark
export BAT_PAGER="less -RF"
if command -v delta &>/dev/null; then
    export GIT_PAGER="LESS='-RF' delta"
fi

if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden -L -g "!{.git}"'
else
    export FZF_DEFAULT_COMMAND='find . -type f'
fi
export FZF_DEFAULT_OPTS='--color dark,hl:166,hl+:166 --bind=ctrl-j:preview-down,ctrl-k:preview-up,ctrl-g:first,ctrl-a:select-all,ctrl-d:deselect-all'
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if command -v nvim &> /dev/null; then
    export EDITOR=nvim
elif command -v vim &> /dev/null; then
    export EDITOR=vim
fi

export WORKON_HOME="$XDG_DATA_HOME"/virtualenvs

if command -v tldr &>/dev/null ; then
    export TLDR_COLOR_NAME="yellow underline"
    export TLDR_COLOR_DESCRIPTION="white bold"
    export TLDR_COLOR_COMMAND="green"
    export TLDR_COLOR_EXAMPLE="grey bold"
    export TLDR_COLOR_PARAMETER="cyan"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

