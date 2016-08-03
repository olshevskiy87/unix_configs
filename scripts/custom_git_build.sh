#!/usr/bin/env bash

if [ ! -d "$1" ]; then
    echo "err: \"$1\" is not a directory"
    exit 1
fi

pushd "$1"

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
./configure
# sudo apt-get install curl, asciidoc, docbook2x, libcurl4-gnutls-dev
make all doc info
sudo make install install-doc install-html install-info
if [ -f "contrib/completion/git-completion.bash" ]; then
    cp -f contrib/completion/git-completion.bash "$HOME/.git-completion.bash"
fi

popd

echo
echo the new git version is: $(git --version | awk '{print $3}')
echo done!
