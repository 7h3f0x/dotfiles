# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

add_to_path() {
    if [ -d "$1" ] ; then
        PATH="$1:$PATH"
    fi
}

# export PATH="$HOME/.cargo/bin:$PATH"
add_to_path "$HOME/.cargo/bin"
# export PATH="$HOME/go/bin:$PATH"
add_to_path "$HOME/go/bin"

if [ -d "$HOME/go" ] ; then
    export GOPATH="$HOME/go"
fi

if [ -d "$HOME/tools/john-1.9.0-jumbo-1/run" ] ; then
    export PATH=$PATH:$HOME/tools/john-1.9.0-jumbo-1/run
fi

if [ -d "$HOME/.nvm" ] ; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi
export SPICE_NOGRAB=1
