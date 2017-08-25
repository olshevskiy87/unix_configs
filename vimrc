if version >= 700
    filetype plugin indent on
endif

if has('nvim')
    call plug#begin('~/.config/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'scrooloose/nerdcommenter'
Plug 'rhysd/committia.vim'
if has('python') || has('python3')
    Plug 'klen/python-mode', { 'for': 'python' }
endif
Plug 'Shutnik/jshint2.vim', { 'for': 'javascript' }
Plug 'airblade/vim-gitgutter'
Plug 'kopischke/vim-stay'
Plug 'tkhoa2711/vim-togglenumber'
Plug 'fatih/vim-go', { 'for': 'go' }

call plug#end()

" common settings
set nowrap
set nowrapscan
set ruler
set showcmd
set backspace=indent,eol,start
set scrolloff=10
set laststatus=2
set statusline=%F\ %m\ %r\ %=[%{&ff}]\ %3p%%\ [%4l,%3v]\ [%L]
set clipboard=unnamed
set nofoldenable
set sidescroll=5
set number
set norelativenumber

""" colors
if version >= 700
    syntax enable
endif
set t_Co=256
try | colorscheme seoul256 | catch | endtry

if exists('+colorcolumn')
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn="100"
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
command! Q quit

""" keys mapping
nnoremap n nzz
nnoremap N Nzz
nnoremap J gJ
nnoremap 0 ^
nnoremap <F3> :ToggleNumber<cr>
nnoremap <F6> :GitGutterToggle<cr>
nnoremap <F7> :set expandtab!<cr>

" hide highlighting of the search results by pressing Enter
nnoremap <Tab> :noh<CR>

" tabs keys mapping
nnoremap tn :tabnew<CR>
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tmr :tabmove +1<CR>
nnoremap tml :tabmove -1<CR>
nnoremap tmR :$tabmove<CR>
nnoremap tmL :0tabmove<CR>

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

" vim-easy-align
vmap <Enter> <Plug>(EasyAlign)
" new tab for vim-plug
let g:plug_window = 'tabnew'
" jshint
let JSHintUpdateWriteOnly = 1
let g:JSHintHighlightErrorLine = 0
" pymode
let g:pymode_rope_complete_on_dot = 0
let g:pymode_trim_whitespaces = 0
let g:pymode_lint_ignore = "W191,C901,E501"
let g:pymode_lint_sort = ['E', 'C', 'I']
" gitgutter
let g:gitgutter_max_signs = 1000

" edit-open hook for commitia
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    if a:info.vcs !=# 'git'
        return
    end
    let git_dir = fugitive#extract_git_dir(expand('%:p'))
    let git_repo = fugitive#repo(git_dir)
    let git_repo_user = git_repo.config('user.name').' <'.git_repo.config('user.email').'>'

    let git_log_date_fmt = 'format:%d.%m.%Y %H:%M'
    if fugitive#git_version() =~# '^0\|^1\.\|^2\.[1-6]\.'
        let git_log_date_fmt = 'iso'
    endif

    let opts = [
        \ '-3',
        \ '--date=' . git_log_date_fmt,
        \ '--format=%cd  %s (%cn)',
        \ '--no-merges'
    \ ]
    let git_args = ['log'] + opts
    let git_log_cmd = call(git_repo.git_command, git_args, git_repo)
    normal gg
    let head_comment = map(split(system(git_log_cmd), '\n'), "'# '.v:val")
        \ + ["\n# as " . git_repo_user . "\n"]
    silent 0put =head_comment
    normal 1j
    silent .put =fugitive#head()
endfunction

vnoremap <silent> <Leader>jp :<C-U>call myf#JsonPrettyVisual()<CR>
nnoremap <silent> <Leader>jp :call myf#JsonPretty()<CR>
nnoremap <silent> <Leader>pm :call myf#PhpMdCheck()<CR>
