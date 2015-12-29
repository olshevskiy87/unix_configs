if version >= 700
    filetype plugin indent on
endif
if filereadable($HOME.'/.vim/autoload/pathogen.vim')
    execute pathogen#infect()
endif

" common settings
set nowrap
set nowrapscan
set ruler
set showcmd
set backspace=indent,eol,start
set scrolloff=10
set laststatus=2
set clipboard=unnamed

""" colors
if version >= 700
    syntax enable
endif

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
set smartindent
set pastetoggle=<F4>

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
nnoremap n nzz
nnoremap N Nzz
nnoremap J gJ

" hide highlighting of the search results by pressing Enter
nnoremap <Tab> :noh<CR>

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

" change the encoding
if version >= 700
    set wildmenu
    set wildmode=longest:full,full
    set wcm=<Tab>
    menu Encoding.CP1251 :e ++enc=cp1251<CR>
    menu Encoding.KOI8-U :e ++enc=koi8-u<CR>
    menu Encoding.UTF-8  :e ++enc=utf-8<CR>
    map <F8> :emenu Encoding.<TAB>
endif

""" plugins settings
" vim-startify
let g:startify_bookmarks = [
    \ {'c': '~/.vimrc'},
    \ {'g': '~/git/'},
\ ]
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence = 1
" ctrl-p
let g:ctrlp_by_filename = 1
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:20,results:20'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
