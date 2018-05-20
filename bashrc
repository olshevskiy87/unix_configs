# set prompt
export PS1="[\u@\h \w]$ "

umask 0002

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# aliases
exa > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
    alias ll="exa -lag -B --time-style long-iso --sort type"
else
    alias ll='ls -la --group-directories-first --color=auto'
fi
alias crontab='crontab -i'
alias greps='grep -srni --color'
icdiff > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
   alias gic='git difftool -y --extcmd icdiff'
   alias gicl='git difftool -y --extcmd icdiff --color=always | less -R'
fi
alias vlg='vim -p $(git show --pretty="format:" --name-only)'
alias vsg='vim -p $(git status -s | awk '"'"'{print $2}'"'"')'

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

export GOPATH=$HOME/godir
if [ -d "$GOPATH/bin" ]; then
    PATH="$GOPATH/bin:$PATH"
fi
export GOCACHE=off

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
