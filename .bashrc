# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server


test -s ~/.alias && . ~/.alias || true


PATH="${HOME}/bin:${PATH}"


# ----- specific aliases -----------------------------------------------------

alias ls='ls --color=auto --hyperlink=auto'
alias icat='kitty +kitten icat'
alias et='emacsclient -t'
alias en='emacsclient -c -n'

# ----- Gradle Bash Completion -----------------------------------------------
source ${HOME}/bash_completion.d/gradle-completion.bash
export GRADLE_COMPLETION_UNQUALIFIED_TASKS="true"



# ----- Git specific command prompt ------------------------------------------
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#PS1="\[[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[[0;31m\]\342\234\227\[[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[[0;31m\]\h'; else echo '\[[0;33m\]\u\[[0;37m\]@\[[0;96m\]\h'; fi)\[[0;37m\]]\342\224\200[\[[0;32m\]\w\[[0;37m\]]
#\[[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[[0m\]"
# PS1="\[[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[[0;31m\]\342\234\227\[[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[[0;31m\]\h'; else echo '\[[0;33m\]\u\[[0;37m\]@\[[0;96m\]\h'; fi)\[[0;37m\]]\342\224\200[\[[0;32m\]\w\[[0;37m\]]\[[00m\]\$(parse_git_branch)\[[00m\]
# \[[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[[0m\]"



function _update_ps1() {
    PS1="$(/home/toex/bin/powerline-go -newline -hostname-only-if-ssh -numeric-exit-codes -cwd-max-depth 7 -error $?)"
}

if [ "$TERM" != "linux" ] && [ -f "/home/toex/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi



# ----- Emacs as default editor with daemon support --------------------------
export EDITOR="emacsclient -c -n"
export ALTERNATE_EDITOR=""




# ----- Fuzzy Finder (fzf) ---------------------------------------------------

# Available keybindings:
#     CTRL-T - Paste the selected files and directories onto the command-line
#         Set FZF_CTRL_T_COMMAND to override the default command
#         Set FZF_CTRL_T_OPTS to pass additional options
#     CTRL-R - Paste the selected command from history onto the command-line
#         If you want to see the commands in chronological order, press CTRL-R again which toggles sorting by relevance
#         Set FZF_CTRL_R_OPTS to pass additional options
#     ALT-C - cd into the selected directory
#         Set FZF_ALT_C_COMMAND to override the default command
#         Set FZF_ALT_C_OPTS to pass additional options


# fe [FUZZY PATTERN] - Open the selected file with sublime_text (via alias)
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'
' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && st "${files[@]}"
}


# fuzzy grep open via ag with line number
fago() {
  local file
  local line

  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     st $file:$line
  fi
}


# fd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}


# fh - repeat history
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}


# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source /home/toex/.config/broot/launcher/bash/br

