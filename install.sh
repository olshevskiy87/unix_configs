# colors for vimdiff
if [ ! -d ~/.vim/colors/ ]; then
    mkdir -p ~/.vim/colors
fi
if [ ! -e ~/.vim/colors/mydiffcolors.vim ]; then
    cp .vim/colors/mydiffcolors.vim ~/.vim/colors/
fi

# dot-files in HOME dir
for f in .vimrc .psqlrc .gitconfig .tmux.conf
do
    echo "file [$f]"
    if [ ! -e ~/$f ]; then
        echo "link does not exists. try to create..."
        ln -s ~/git/unix_configs/$f ~/$f
    fi
done

