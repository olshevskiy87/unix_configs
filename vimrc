if version >= 700
    filetype plugin indent on
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'scrooloose/nerdcommenter'
Plug 'rhysd/committia.vim'
Plug 'airblade/vim-gitgutter'
Plug 'kopischke/vim-stay'
Plug 'tkhoa2711/vim-togglenumber'
call plug#end()

" common settings
set nowrap
set nowrapscan
set showcmd
set backspace=indent,eol,start
set scrolloff=10
set laststatus=2
set statusline=%F\ %m\ %r\ %=[%{&ff}]\ %3p%%\ [%4l,%3v]\ [%L]
set clipboard=unnamed
set nofoldenable
set sidescroll=5
set number

" colors
if version >= 700 && !has('g:syntax_on')
    syntax enable
endif
set t_Co=256
try | colorscheme seoul256 | catch | endtry

if exists('+colorcolumn')
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn="120"
endif

" indentation
set tabstop=4
set expandtab
set shiftwidth=4
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

" keys mapping
nnoremap n nzz
nnoremap N Nzz
nnoremap J gJ
nnoremap 0 ^
nnoremap <F3> :ToggleNumber<cr>
nnoremap <F6> :GitGutterToggle<cr>
nnoremap <F7> :set expandtab!<cr>

" hide highlighting of the search results
nnoremap <Tab> :noh<CR>

" tabs keys mapping
nnoremap tn :tabnew<CR>
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>

" change the encoding
if version >= 700
    set wildmenu
    set wildmode=longest:full,full
    set wcm=<Tab>
    menu Encoding.CP1251 :e ++enc=cp1251<CR>
    menu Encoding.KOI8-U :e ++enc=koi8-u<CR>
    menu Encoding.UTF-8  :e ++enc=utf-8<CR>
    nmap <F8> :emenu Encoding.<TAB>
endif

""" custom plugins settings

" vim-easy-align
xmap <Enter> <Plug>(EasyAlign)
" new tab for vim-plug
let g:plug_window = 'tabnew'
" gitgutter
let g:gitgutter_max_signs = 1000

xnoremap <silent> <Leader>jp :<C-U>call myf#JsonPrettyVisual()<CR>
nnoremap <silent> <Leader>jp :call myf#JsonPretty()<CR>
nnoremap <silent> <Leader>pm :call myf#PhpMdCheck()<CR>
nnoremap <silent> <Leader>ps :call myf#PhpStanCheck()<CR>
