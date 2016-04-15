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
"Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/gv.vim'
"Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'
"Plug 'junegunn/vim-pseudocl'
"Plug 'junegunn/vim-oblique'
"Plug 'mhinz/vim-signify'
"Plug 'mhinz/vim-startify'
Plug 'bling/vim-airline'
"Plug 'MattesGroeger/vim-bookmarks'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"Plug 'easymotion/vim-easymotion'
Plug 'rhysd/committia.vim'
"Plug 'vim-scripts/taglist.vim', { 'on': 'TlistToggle' }
Plug 'klen/python-mode', { 'for': 'python' }
Plug 'wookiehangover/jshint.vim', { 'for': 'javascript' }
"Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'kopischke/vim-stay'

call plug#end()

" common settings
set nowrap
set nowrapscan
set ruler
set showcmd
set backspace=indent,eol,start
set scrolloff=10
set laststatus=2
set clipboard=unnamed
set nofoldenable

""" colors
if version >= 700
    syntax enable
endif
set t_Co=256
try | colorscheme seoul256 | catch | endtry

if exists('+colorcolumn')
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn="80"
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

""" commands
command! W write

""" keys mapping
nnoremap n nzz
nnoremap N Nzz
nnoremap J gJ
nnoremap <F6> :GitGutterToggle<cr>
nnoremap <F7> :set expandtab!<cr>
inoremap <F9> <esc>:TlistToggle<cr>
nnoremap <F9> :TlistToggle<cr>
inoremap <F10> <esc>:NERDTreeToggle<cr>
nnoremap <F10> :NERDTreeToggle<cr>
nnoremap <F12> :Startify<CR>

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

""" custom plugins settings

" vim-startify
"let g:startify_bookmarks = [
    "\ {'c': '~/.vimrc'},
    "\ {'g': '~/git/'},
"\ ]
"let g:startify_list_order = [
    "\ ['   Sessions'],      'sessions',
    "\ ['   MRU'],           'files',
    "\ ['   MRU '.getcwd()], 'dir',
    "\ ['   Bookmarks'],     'bookmarks',
  "\ ]
"let g:startify_session_delete_buffers = 1
"let g:startify_session_persistence = 1
" vim-peekaboo
"let g:peekaboo_window = 'vertical botright 100new'
"let g:peekaboo_delay = 0
" vim-easy-align
vmap <Enter> <Plug>(EasyAlign)
" new tab for vim-plug
let g:plug_window = 'tabnew'
" nerdtree
let NERDTreeShowHidden = 1
" vimchat
"let g:vimchat_timestampformat="[%d.%m.%y %H:%M:%S]"
"let g:vimchat_log_file_format="%(d)s"
"let g:vimchat_show_jid_resource=0
" jshint
let JSHintUpdateWriteOnly = 1
let g:JSHintHighlightErrorLine = 0
" pymode
let g:pymode_rope_complete_on_dot = 0
let g:pymode_trim_whitespaces = 0

" edit-open hook for commitia
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    if a:info.vcs !=# 'git'
        return
    end
    let git_dir = fugitive#extract_git_dir(expand('%:p'))
    let git_repo = fugitive#repo(git_dir)
    let opts = [
        \ '-3',
        \ '--date=format:%d.%m.%Y %H:%M',
        \ '--format=%cd  %s',
        \ '--no-merges'
    \ ]
    let git_args = ['log'] + opts
    let git_log_cmd = call(git_repo.git_command, git_args, git_repo)
    silent execute 'read' escape('!'.git_log_cmd, '%')
    silent 2,$s/^/# /g
    normal gg
    call append('.', '')
endfunction
