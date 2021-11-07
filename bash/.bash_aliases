#!/bin/bash
# This has all the extra stuff i want on all shells, so i update here once, have it sourced by all the repective
# shell config files like zshrc and bashrc


# Aliases

alias fun="fortune | figlet | cowsay -n | lolcat"
alias pandoc='docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex'

if command -v exa &> /dev/null; then
    alias ls="exa --color=auto"
    alias ll="exa --color=auto -lg"
    alias la="exa --color=auto -a"
    alias lla="exa --color=auto -lga"
fi

alias mv="mv -i"
alias cp="cp -i"
alias clip="xclip -sel clip"
alias pip3="python3 -m pip" # running the pip3 script says, use this instead
alias batman="env MANPAGER=\"sh -c 'col -bx | batcat -l man -p'\" man"
alias bat="batcat"

if command -v batcat &> /dev/null; then
    alias cat="batcat -pp"
fi

alias man="colored man"
alias ff='fzf --preview "batcat --color=always {}"'

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


# Exports
export BAT_THEME=TwoDark
export BAT_PAGER="less -RF"
if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden -L -g "!{.git}"'
else
    export FZF_DEFAULT_COMMAND='find . -type f'
fi
export FZF_DEFAULT_OPTS='--color dark,hl:166,hl+:166 --bind=ctrl-j:preview-down,ctrl-k:preview-up,ctrl-g:first,ctrl-a:select-all,ctrl-d:deselect-all'
export EXA_COLORS="da=38;5;36"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autoload -U +X bashcompinit && bashcompinit
# source $HOME/.local/etc/bash_completion.d/youtube-dl.bash-completion

