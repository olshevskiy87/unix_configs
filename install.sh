DIR="$(cd "$(dirname "${BASH_SOURCE[0]}"i)" && pwd)"

function create_or_update_file {
    if [ ! -d $1 ]; then
        echo "$1 folder doesn't exist. make it..."
        mkdir -p $1
    fi
    if [ -e $1/$2 ]; then
        read -p "rewrite $2? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp -f $DIR/$3/$2 $1
            echo " ok"
        else
            echo
        fi
    else
        echo "$2 doesn't exist. make it..."
        cp $DIR/$3/$2 $1
    fi
}

# init git submodules
git submodule update --init --recursive

# colors for vimdiff
create_or_update_file ~/.vim/colors mydiffcolors.vim vim/colors
create_or_update_file ~/.vim/autoload pathogen.vim vim-pathogen/autoload

# dot-files in HOME dir
for f in vimrc psqlrc gitconfig tmux.conf
do
    dot_f=.$f
    echo "file [$dot_f]"
    if [ -L ~/$dot_f ]; then
        read -p "already exists. rewrite? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ln -sf $DIR/$f ~/$dot_f
            echo " ok"
        else
            echo
        fi
    else
        ln -s $DIR/$f ~/$dot_f
    fi
done

