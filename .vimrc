" common settings
set nowrap
set ruler
set showcmd
set backspace=indent,eol,start
set scrolloff=10
set laststatus=2
set clipboard=unnamed

""" colors
syntax enable

set t_Co=256

if &diff " if vim used as git diff tool (vimdiff)
    try | colorscheme mydiffcolors | catch /.*/ | echo v:exception | endtry
else " normal mode
    try | colorscheme darkblue | catch /.*/ | echo v:exception | endtry
endif

if exists('+colorcolumn')
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn="80,".join(range(120,999),",")
endif

" indentation
set tabstop=4
set expandtab
set shiftwidth=4

" show redundant whitespaces and tabs
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

" search
set ignorecase
set hlsearch
set incsearch

" open any file with a pre-existing swapfile in readonly mode
" from Damian Conway's .vimrc
if version > 730
    augroup NoSimultaneousEdits
        autocmd!
        autocmd SwapExists * let v:swapchoice = 'o'
        autocmd SwapExists * echo 'Duplicate edit session (readonly)'
        autocmd SwapExists * echohl None
        autocmd SwapExists * sleep 1
    augroup END
endif

""" keys mapping
" hide highlighting of the search results by pressing Enter
nnoremap <Enter> :noh<CR>

" tabs keys mapping
nnoremap tn :tabnew<CR>
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>

" no arrows in any mode
" normal mode
no <down>  <Nop>
no <left>  <Nop>
no <right> <Nop>
no <up>    <Nop>
" insert mode
ino <down>  <Nop>
ino <left>  <Nop>
ino <right> <Nop>
ino <up>    <Nop>
" visual mode
vno <down>  <Nop>
vno <left>  <Nop>
vno <right> <Nop>
vno <up>    <Nop>

