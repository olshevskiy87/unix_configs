#!/usr/bin/env bash

dotfiles="profile bashrc vimrc psqlrc gitconfig tmux.conf pylintrc jshintrc"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}"i)" && pwd)"

mkdir -p ~/bin

function create_or_update_file {
    if [ ! -d "$1" ]; then
        echo "$1 folder doesn't exist. make it..."
        mkdir -p "$1"
    fi
    if [ -e "$1/$2" ]; then
        read -p "rewrite $2? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp -f "$DIR/$3/$2" "$1"
            echo " ok"
        else
            echo
        fi
    else
        echo "$2 doesn't exist. make it..."
        cp "$DIR/$3/$2" "$1"
    fi
}

# init git submodules
git submodule update --init --recursive

# install plugin manager
create_or_update_file ~/.vim/autoload plug.vim vim-plug
# install myf.vim
create_or_update_file ~/.vim/autoload myf.vim .
# ssh-find-agent
create_or_update_file ~ ssh-find-agent.sh ssh-find-agent

# icdiff
ln -sf "$DIR/icdiff/icdiff" ~/bin/icdiff

# dot-files in HOME dir
for f in $dotfiles
do
    dot_f=.$f
    echo "file [$dot_f]"
    if [ -L "$HOME/$dot_f" ]; then
        read -p "already exists. rewrite? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ln -sf "$DIR/$f" "$HOME/$dot_f"
            echo " ok"
        else
            echo
        fi
    else
        ln -s "$DIR/$f" "$HOME/$dot_f"
    fi
done

# install vim-plugins

read -p "update vim plugins? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    vim +PlugClean +PlugUpdate +PlugInstall +qall!
    echo " ok"
else
    echo
fi
