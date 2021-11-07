# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# Load version control information
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

# Check if git repo is dirty, if true set misc message to the unicode symbol
+vi-_git_is_dirty() {
    STATUS=$(git status --porcelain --ignore-submodules=all| tail -n1)
    if [[ -n $STATUS ]]; then
        hook_com[misc]="✗" # U+2717
    fi
}
zstyle ':vcs_info:git*+set-message:*' hooks _git_is_dirty

# Format the vcs_info_msg_0_ variable
# Branch Icon: '\uF126 '
zstyle ':vcs_info:git:*' formats "on branch %{$fg_bold[yellow]%} %b%{$fg_bold[red]%}%m"

# also has staged/unstaged file info
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:git:*' formats "on branch %{$fg_bold[yellow]%} %b %{$fg_bold[red]%}%c%u%m"

# unicode U+279c
# truncate the first prompt line from left, if length of this portion is
# greater than $COLUMNS (width of terminal).
# `%<<` is used to signal end of segment for which truncation is to take place
PROMPT='%${COLUMNS}<<%{$fg_bold[red]%}%n%{$fg[red]%}@%{$fg_bold[red]%}%m %{$fg[cyan]%}%~ %{$fg_bold[magenta]%}${vcs_info_msg_0_}%{$fg_bold[magenta]%} %  %<<'$'\n''%{$fg_bold[green]%}➜  %{$reset_color%}'


# vim:ft=zsh
