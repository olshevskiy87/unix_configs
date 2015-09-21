# colors for vimdiff
if [ ! -d ~/.vim/colors/ ]; then
    mkdir -p ~/.vim/colors
fi
if [ ! -e ~/.vim/colors/mydiffcolors.vim ]; then
    cp .vim/colors/mydiffcolors.vim ~/.vim/colors/
fi

# dot-files in HOME dir
if [ ! -e ~/.vimrc ]; then
    ln -s ~/git/unix_configs/.vimrc ~/.vimrc
fi
if [ ! -e ~/.psqlrc ]; then
    ln -s ~/git/unix_configs/.psqlrc ~/.psqlrc
fi
if [ ! -e ~/.gitconfig ]; then
    ln -s ~/git/unix_configs/.gitconfig ~/.gitconfig
fi

