# set prompt
export PS1="[\u@\h \w]$ "

umask 0002

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# aliases
alias ll='ls -la --color=auto'
alias greps='grep -srni --color'
alias glb='git lg --no-merges master..'
alias gsfm='git lg ^master HEAD'
alias gbra='list_git_branches_annotated'
alias gbrd='git branch --edit-description '
alias grm='git rebase master'
alias gbm='git branch --merged'
icdiff > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
   alias gic='git difftool -y --extcmd icdiff'
   alias gicl='git difftool -y --extcmd icdiff --color=always | less -R'
fi
alias vlg='vim -p $(git show --pretty="format:" --name-only)'
alias vsg='vim -p $(git status -s | awk '"'"'{print $2}'"'"')'
alias pylint='pylint --rcfile=~/.pylintrc -r n'
alias ipython='ipython --profile=dv'

function list_git_branches_annotated {
    oIFS="$IFS"
    IFS=$'\n'
    cur_br=$(git br 2>/dev/null | grep '*' | cut -b 3-);
    if [ ! "$cur_br" ]; then
        echo "err: not a git repository"
        return 1
    fi
    for br in $(git br | cut -b 3-); do
        desc=$(git config branch.$br.description | head -n1)
        if [ "$br" == "$cur_br" ]; then
            br_f="* %-12s"
        else
            br_f="  %-12s"
        fi
        if [ "$desc" ]; then
            br_f="$br_f :"
        fi
        printf "$br_f %s\n" "$br" "$desc"
    done
    IFS="$oIFS"
}

# activate python virtual environment
function act {
    activated=false
    env_folder="env"
    if [ "$1" ]; then
        env_folder="$1"
    fi
    full_env=$(readlink -f $env_folder)
    [[ "$VIRTUAL_ENV" = "$full_env" ]] && activated=true

    if [ "$2" ]; then
        case "$2" in
            "new")
                if [ -d "$env_folder" ]; then
                    echo "$full_env already exist"
                    return 1
                fi
                virtualenv "$env_folder"
                ;;
            "re")
                if [ ! -d "$env_folder" ]; then
                    echo "$full_env does not exist"
                else
                    read -p "do you really want to remove $full_env? " -n 1 -r
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        rm -rf "$env_folder"
                    else
                        return 1
                    fi
                    echo
                fi
                virtualenv "$env_folder"
                ;;
            *)
                echo "unknown command \"$2\""
                return 1
                ;;
        esac
    fi

    activate_path="$env_folder/bin/activate"
    if [ ! -f "$activate_path" ]; then
        echo "$activate_path does not exist"
        return 1
    fi
    source "$activate_path"
}

if [ -f "$HOME/.custom_aliases.sh" ]; then
    source "$HOME/.custom_aliases.sh"
fi

if which tmux &> /dev/null; then
    alias tmux='TERM=screen-256color-bce tmux'
fi

# env. variables
if which vim &> /dev/null; then
    export EDITOR=vim
fi

if which psql &> /dev/null; then
    export PGUSER=postgres
    export PGDATABASE=postgres
fi

export GOPATH=$HOME/godir

# start ssh-agent if it's not already running
if [ ! "`ps ax | grep ssh-agent | grep -ivE \"(grep|defunct)\"`" ]; then
    eval $(ssh-agent) > /dev/null 2>&1
fi

# include script to find running ssh-agent
if [ -f "$HOME/ssh-find-agent.sh" ]; then
    source "$HOME/ssh-find-agent.sh"
    set_ssh_agent_socket
fi

# close ssh-agent if it had been started in the current session
trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`' 0

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f "$HOME/.bashrc.custom" ]; then
    source $HOME/.bashrc.custom
fi
if [ -f "$HOME/.git-completion.bash" ]; then
    source $HOME/.git-completion.bash
fi
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi
