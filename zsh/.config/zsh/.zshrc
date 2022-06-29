# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# uncomment for profiling
# https://stevenvanbael.com/profiling-zsh-startup
# zmodload zsh/zprof

# Enable ctrl+arrow key stuff
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# CLI Tab-Completion
zstyle ':completion:*:*:*:*:*' menu select

# https://stackoverflow.com/a/24237590
# first, complete the current word exactly as its written
# handle upper and lower case interchangeable
# second (original) rule allows for partial completion before ., _ or -, e.g. f.b -> foo.bar
# third rule allows for completing on the left side of the written text, e.g. bar -> foobar
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt  autocd autopushd
autoload -U +X compinit && compinit
WORDCHARS='' # oh-my-zsh also has this, proper word boundaries
bindkey -M emacs '^[[Z' reverse-menu-complete

# use ctrl-n/p instead of tab/s-tab
bindkey -M viins '\C-n' expand-or-complete
bindkey -M viins '\C-p' reverse-menu-complete

# Use `<C-y>` to accept a menu completion and close menu
# I use this to end cycling and try to get next completion
zmodload zsh/complist
bindkey -M menuselect '\C-y' accept-search

# History Stuff
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=50000
SAVEHIST=10000

setopt    extended_history       # record timestamp of command in HISTFILE
setopt    hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt    hist_ignore_dups       # ignore duplicated commands history list
setopt    hist_ignore_space      # ignore commands that start with space
setopt    appendhistory
setopt    sharehistory
setopt    incappendhistory

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Vi Stuff:

set -o vi

# enable like ci", ci[ and others in vi-mode
autoload -U select-quoted
zle -N select-quoted
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
    for c in {a,i}{\{,\[,\(,\<}; do
        bindkey -M $m $c select-bracketed
    done
done

function vi-yank-xclip-y {
    zle vi-yank
    echo -n "$CUTBUFFER" | xclip -i -selection clipboard
}

function vi-yank-xclip-Y {
    zle vi-yank-eol
    echo -n "$CUTBUFFER" | xclip -i -selection clipboard
}

zle -N vi-yank-xclip-y
zle -N vi-yank-xclip-Y
# use our function to copy yanked text to clipboard
bindkey -M vicmd 'y' vi-yank-xclip-y
bindkey -M visual 'y' vi-yank-xclip-y
# map Y to y$ like it should be
bindkey -M vicmd "Y" vi-yank-xclip-Y
# map <C-r> like in usual emacs mode, as it as too widely known
bindkey -M viins "\C-f" history-incremental-search-backward
# bind <alt-backspace> to delete previous word (like in usual emacs mode)
bindkey -M viins "\C-w" backward-delete-word
bindkey -M viins "^[^?" backward-delete-word
bindkey -M viins "\C-u" backward-kill-line

# Use backspace to delete chars even from history search
bindkey -M viins '^?' backward-delete-char

# use delete key to delete char under cursor
bindkey -M viins '^[[3~' delete-char

# Open current command-line in $EDITOR (by default, vim)
autoload -U edit-command-line

zle -N edit-command-line
bindkey '^x^e' edit-command-line

export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

# Command Not Found, searched in repos
[[ -f /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# Decorations and plugins etc

# `print -Pn` to set terminal title
_precmd_terminal_title() {
    print -Pn "\e]2;%n@%M %~\a"
}

_precmd_ibeam() {
    echo -ne '\e[5 q'
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _precmd_terminal_title
add-zsh-hook precmd _precmd_ibeam

# FZF
FZF_KEYBIND_FILE=$HOME/tools/fzf/shell/key-bindings.zsh

[[ -f "$FZF_KEYBIND_FILE" ]] && source "$FZF_KEYBIND_FILE"

autoload -U colors && colors
MY_ZSH_THEME_FILE="$ZDOTDIR"/themes/thefox.zsh-theme
[[ -f "$MY_ZSH_THEME_FILE" ]] && source "$MY_ZSH_THEME_FILE"

ZSH_PLUGIN_DIR="$ZDOTDIR"/plugins


ZSH_AUTOSUGGESTION_FILE=$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f "$ZSH_AUTOSUGGESTION_FILE" ]]; then
    source "$ZSH_AUTOSUGGESTION_FILE"
    ZSH_AUTOSUGGEST_STRATEGY=(history)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"
fi


ZSH_HIGHLIGHTING_FILE=$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ -f "$ZSH_HIGHLIGHTING_FILE" ]]; then
    source "$ZSH_HIGHLIGHTING_FILE"

    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='underline'
    ZSH_HIGHLIGHT_STYLES[default]="fg=cyan"
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=166,bold"
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=166,bold"
    ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=magenta"
    ZSH_HIGHLIGHT_STYLES[assign]="fg=167"
    ZSH_HIGHLIGHT_STYLES[comment]="fg=8"
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=cyan"
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="fg=cyan"
fi

if [ -f "$ZDOTDIR"/.zsh_aliases ]; then
    . "$ZDOTDIR"/.zsh_aliases
fi

# uncomment for profiling
# zprof

