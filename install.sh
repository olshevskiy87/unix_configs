DIR="$(cd "$(dirname "${BASH_SOURCE[0]}"i)" && pwd)"

# colors for vimdiff
if [ ! -d ~/.vim/colors/ ]; then
    echo "vim colors folder doesn't exist. make it..."
    mkdir -p ~/.vim/colors
fi
if [ -e ~/.vim/colors/mydiffcolors.vim ]; then
    read -p "rewrite mydiffcolor.vim? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp -f $DIR/.vim/colors/mydiffcolors.vim ~/.vim/colors/
        echo " ok"
    else
        echo
    fi
else
    echo "mydiffcolor.vim doesn't exist. make it..."
    cp $DIR/.vim/colors/mydiffcolors.vim ~/.vim/colors/
fi

# dot-files in HOME dir
for f in .vimrc .psqlrc .gitconfig .tmux.conf
do
    echo "file [$f]"
    if [ -e ~/$f ]; then
        read -p "already exists. rewrite? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ln -sf $DIR/$f ~/$f
            echo " ok"
        else
            echo
        fi
    else
        ln -s $DIR/$f ~/$f
    fi
done

