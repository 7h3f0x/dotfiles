#!/bin/bash
# This has all the extra stuff i want on all shells, so i update here once, have it sourced by all the repective
# shell config files like zshrc and bashrc


# Aliases

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias fun="fortune | figlet | cowsay -n | lolcat"
alias pandoc='docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex'

alias mv="mv -i"
alias cp="cp -i"
alias clip="xclip -sel clip"
alias pip3="python3 -m pip" # running the pip3 script says, use this instead

if command -v batcat &> /dev/null; then
    alias batman="env MANPAGER=\"sh -c 'col -bx | batcat -l man -p'\" man"
    alias bat="batcat"
    alias cat="batcat -pp"
fi

alias man="colored man"
alias ff='fzf --preview "batcat --color=always {}"'
alias parrot='curl parrot.live'

# Functions

gvim() {
    if pgrep gvim; then
        command gvim --remote "$@"
    else
        command gvim "$@"
    fi
}

# https://www.howtogeek.com/683134/how-to-display-man-pages-in-color-on-linux/
colored() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[44;97m' \
    LESS_TERMCAP_se=$'\e[0m' \
    "$@"
}

check_font() {
    echo -e "\e[1mbold\e[0m"
    echo -e "\e[3mitalic\e[0m"
    echo -e "\e[3m\e[1mbold italic\e[0m"
    echo -e "\e[4munderline\e[0m"
    echo -e "\e[9mstrikethrough\e[0m"
    echo -e "\e[31mHello World\e[0m"
    echo -e "\x1B[31mHello World\e[0m"
}

soocat() {
    socat tcp-l:${2},fork,reuseaddr EXEC:${1}
}

display() {
    if [ -z "$IS_WSL" ]; then
        return
    fi
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0 # in WSL 2
        export LIBGL_ALWAYS_INDIRECT=1
    else
        unset DISPLAY
    fi
}

# Other stuff

if [[ -n "$VIRTUAL_ENV" ]]; then
    PS1="($(basename "$VIRTUAL_ENV")) $PS1"
else
    # Load Virtualenv Wrapper lazily, to reduce shell load time
    export VIRTUALENVWRAPPER_SCRIPT='/usr/share/virtualenvwrapper/virtualenvwrapper.sh'
    if [ -f "$VIRTUALENVWRAPPER_SCRIPT" ]; then
        source '/usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh'
    fi
fi
