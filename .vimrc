" common settings
set nowrap
set ruler
set showcmd
set backspace=indent,eol,start

" colors
syntax enable
colorscheme darkblue

" indentation
set autoindent
set tabstop=4
set expandtab
set shiftwidth=4

" search
set ignorecase
set hlsearch
set incsearch

" open any file with a pre-existing swapfile in readonly mode
" from (Damian Conway's .vimrc)
augroup NoSimultaneousEdits
    autocmd!
    autocmd SwapExists * let v:swapchoice = 'o'
    autocmd SwapExists * echo 'Duplicate edit session (readonly)'
    autocmd SwapExists * echohl None
    autocmd SwapExists * sleep 1
augroup END

" hide highlighting of the search results by pressing Enter
nnoremap <Enter> :noh<CR>

