# unix_configs
- gitconfig
- vimrc
- vim/*
- psqlrc
- tmux.conf

# git submodules
- https://github.com/tpope/vim-pathogen.git

## manage_vim_plugins.pl
Stupid vim plugins manager.

Usage:
```
perl manage_vim_plugins.pl [OPTIONS]
```
Options:
```
--bundle_path=PATH  vim bundles path (default: '~/.vim/bundle')
--plugins=FILENAME  path to the json-file with required plugins (default: 'plugins.json')
--update            update plugin if already exist
-? | --help         show this help, then exit
```

Perl-modules required:
- JSON::Parse
- Getopt::Long
- IPC::Cmd
- File::Spec
- File::HomeDir
- File::chdir
- File::Path
- English
