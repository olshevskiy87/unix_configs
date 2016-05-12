#!/usr/bin/env bash

PWD=$(pwd)

if [ ! -d "$1" ]; then
    echo "err: \"$1\" is not a directory"
    exit 1
fi

cd "$1"
pwd

read -p "reset and build this repository? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo bye!
    exit
fi

git clean -fd
git reset --hard HEAD
git checkout master
git pull
make distclean
make configure
make
sudo make install
if [ -f "contrib/completion/git-completion.bash" ]; then
    cp -f contrib/completion/git-completion.bash "$HOME/.git-completion.bash"
fi

cd $PWD

echo
echo the new git version is: $(git --version | awk '{print $3}')
echo done!
