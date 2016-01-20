# set prompt
export PS1="[\u@\h \w]$ "

# aliases
alias ll='ls -la --color=auto'
alias greps='grep -srni --color'

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

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# start ssh-agent if it's not already running
if [ ! "`ps ax | grep ssh-agent | grep -ivE \"(grep|defunct)\"`" ]; then
    eval $(ssh-agent)
fi

# include script to find running ssh-agent
if [ -f "$HOME/ssh-find-agent.sh" ]; then
    source "$HOME/ssh-find-agent.sh"
    set_ssh_agent_socket
fi

# close ssh-agent if it had been started in the current session
trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`' 0

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
