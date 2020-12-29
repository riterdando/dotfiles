# -----------------------------------------------------------------------------
# Bash configuration, derived from SuSe sample .bashrc.
#
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
# -----------------------------------------------------------------------------



# ----- path settings ---------------------------------------------------------
PATH="${HOME}/bin:${PATH}"



# ----- additional Bash completions -------------------------------------------
if [[ -d ~/bash_completion.d/ ]] && \
   ! find ~/bash_completion.d/. ! -name . -prune -exec false {} +
then
    for f in ~/bash_completion.d/*
    do
        source "$f"
    done
fi

# somehow the fzf completions are not loaded automatically (we fix this later...)
source /usr/share/bash-completion/completions/fzf
source /usr/share/bash-completion/completions/fzf-key-bindings

# Gradle specifics
export GRADLE_COMPLETION_UNQUALIFIED_TASKS="true"



# ----- aliases settings ------------------------------------------------------

test -s ~/.alias && . ~/.alias || true

# enable color and hyperlinks, in order to make the links work with Kitty
alias ls='ls --color=auto --hyperlink=auto'

# enable displaying pictures in the terminal
alias icat='kitty +kitten icat'

# emacs related aliases
alias et='emacsclient -t'
alias en='emacsclient -c -n'



# ----- Emacs as default editor with daemon support --------------------------
export EDITOR="emacsclient -c -n"
export ALTERNATE_EDITOR=""



# ----- Powerline-Go command line prompt for Bash -----------------------------
function _update_ps1() {
    PS1="$(/home/toex/bin/powerline-go -newline -hostname-only-if-ssh -numeric-exit-codes -cwd-max-depth 7 -error $?)"
}

if [ "$TERM" != "linux" ] && [ -f "/home/toex/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi



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

# using 'fd' as find tool...
export FZF_DEFAULT_COMMAND="fd --hidden --exclude '.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# customize the fzf default options
export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-e:execute(emacsclient -c -n {+})'
"


# source /home/toex/.config/broot/launcher/bash/br
