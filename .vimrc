" common settings
set nowrap
set ruler
"set number
set showcmd
set backspace=indent,eol,start
set scrolloff=10
set laststatus=2

" colors
syntax enable
set t_Co=256
colorscheme darkblue
if exists('+colorcolumn')
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn="80,".join(range(120,999),",")
endif

" indentation
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

" show redundant whitespaces and tabs
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

