# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# Load version control information
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info

# https://github.com/zsh-users/zsh/blob/f9e9dce5443f323b340303596406f9d3ce11d23a/Misc/vcs_info-examples#L155-L170
# git: Show marker (?) if there are untracked files in repository
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        hook_com[staged]+='?'
    fi
}

# also has staged/unstaged file info
zstyle ':vcs_info:*' check-for-changes true

# Format the vcs_info_msg_0_ variable
# Branch Icon: '\uF126 '
zstyle ':vcs_info:*' formats "%{$fg_bold[magenta]%}on branch %{$fg_bold[yellow]%} %b(%s)%{$fg_bold[red]%} %u%c%m"

function _reg_prompt {
    PROMPT_MODE='[I]'
}

function _register_start_time {
    start_time=${start_time:-$SECONDS}
}

function _time_elapsed {
    if [ $start_time ];then
        elapsed=$(($SECONDS - $start_time))
        h=$(($elapsed / 3600))
        m=$(($elapsed % 3600 / 60))
        s=$(($elapsed % 60))

        declare -a parts
        if [ $h -gt 0 ]; then
            parts+=("${h}h")
        fi
        if [ $m -gt 0 ]; then
            parts+=("${m}m")
        fi
        parts+=("${s}s")
        fmt=${(j: :)parts}

        TIME_ELAPSED="%{$fg_bold[white]%}took $fmt %{$reset_color%}"
        unset start_time
    else
        unset TIME_ELAPSED
    fi
}

# unicode U+279c
# truncate the first prompt line from left, if length of this portion is
# greater than $COLUMNS (width of terminal).
# `%<<` is used to signal end of segment for which truncation is to take place
PROMPT='%${COLUMNS}<<%{$fg_bold[red]%}%n%{$fg[red]%}@%{$fg_bold[red]%}%m %{$fg[cyan]%}%~ ${vcs_info_msg_0_}%{$reset_color%} %  %<<'$'\n''$PROMPT_MODE %{$fg_bold[green]%}➜ %{$reset_color%}'
RPROMPT='$TIME_ELAPSED %(?.%{$fg[green]%}.%{$fg[red]%}$? ↲)%{$reset_color%}'

function keymap_select_hook {
    case "${KEYMAP}" in
        vicmd) PROMPT_MODE='[N]'
            ;;
        viins|main) PROMPT_MODE='[I]'
            ;;
    esac
    zle reset-prompt
}

autoload -Uz add-zle-hook-widget
add-zsh-hook precmd _reg_prompt
add-zsh-hook preexec _register_start_time
add-zsh-hook precmd _time_elapsed
add-zle-hook-widget keymap-select keymap_select_hook

# vim:ft=zsh
