# env. variables
export PS1="[\u@\h \w]$ "
if which vim &> /dev/null; then
    export EDITOR=vim
fi

umask 0002

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "/usr/local/go/bin" ]; then
    PATH=$PATH:/usr/local/go/bin
fi
if [ -d "$HOME/go/bin" ]; then
    PATH="$HOME/go/bin:$PATH"
fi

# aliases
exa --version > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
    alias ll="exa -lag -B --time-style long-iso --sort type --git"
else
    alias ll='ls -la --group-directories-first --color=auto'
fi
alias crontab='crontab -i'
alias greps='grep -srni --color'
icdiff --version > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
   alias gicl='git difftool -y --extcmd icdiff --color=always | less -R'
fi
alias vg='vim -c "GV"'
alias vga='vim -c "GV --all"'
xclip -version > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
   alias clip='xclip -selection c'
fi

if [ -f "$HOME/.custom_aliases.sh" ]; then
    source "$HOME/.custom_aliases.sh"
fi

if which tmux &> /dev/null; then
    alias tmux='TERM=screen-256color-bce tmux'
fi

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

if [ -f "$HOME/.bashrc.custom" ]; then
    source $HOME/.bashrc.custom
fi
if [ -f "$HOME/.git-completion.bash" ]; then
    source $HOME/.git-completion.bash
fi
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
