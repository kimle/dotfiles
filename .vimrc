runtime! vimrc_example.vim
let mapleader=","
syntax on

" color settings
set t_Co=256
set background=dark
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_termcolors=256
let g:rehash256 = 1

" switch buffers without saving
set hidden

" general settings
set number
set numberwidth=3 
set laststatus=2
set relativenumber 

" wraps text at 80 characters
set textwidth=80
set formatoptions+=t

" Sets <TAB> to use 4 spaces 
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cindent
    
set cursorline
set noundofile
set wildmenu
set lazyredraw

" Enables incremental search and highlights results
set incsearch
set hlsearch

nnoremap <leader><space> :nohlsearch<CR>

inoremap jk <esc> 

" Folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
                    
" space open/closes folds 
nnoremap <space> za

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line 
nnoremap B ^
nnoremap E $
"
nnoremap ^ <nop>
nnoremap $ <nop>

" buffer movement
nnoremap <leader>gp :bp<CR>
nnoremap <leader>gn :bn<CR>
nnoremap <leader>l :ls<CR>

" highlight last inserted text
nnoremap gV `[v`]

" copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y

" paste from clipboard
vnoremap <leader>p "+p
vnoremap <leader>P "+P
nnoremap <leader>p "+p
nnoremap <leader>P "+P

nnoremap <leader>w :w<CR>
nnoremap <leader><leader> V

if has('nvim')
    " neovim terminal settings
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l

    let g:python2_host_prog='/usr/bin/python2.7'
    let g:python3_host_prog='/usr/bin/python3.6'
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    set clipboard=unnamedplus
    set title
    if exists('&inccommand')
      set inccommand=split
    endif
endif

set grepprg=grep\ -nH\ $*
" let g:tex_flavor='latex'
set backupdir=~/Documents/.vimtmp
set directory=~/Documents/.vimtmp
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after'

nnoremap <leader>u :GundoToggle<CR>

let g:indent_guides_start_level=2

" let g:netrw_list_hide='^\./$'
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_hide=1

" Ctrl-P settings
let g:ctrlp_match_window='bottom,order:ttb'
let g:ctrlp_switch_buffer=0
let g:ctrlp_working_path_mode=0

" airline settings
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'

" neocomplete settings
let g:acp_enable_AtStartup=0
let g:neocomplete#enable_at_startup=1
" let g:neocomplete#sources#dictionary#dictionaries = {
"     \ 'default' : '',
"     \ 'vimshell' : $HOME.'/.vimshell_hist',
"     \ 'scheme' : $HOME.'/.gosh_completions'
"         \ }
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" " enable omni completion
" autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

" tagbar settings
nmap <F9> :TagbarToggle<CR>
let g:tagbar_autofocus=1
let g:tagbar_autoclose=1

" eclim settings
let g:EclimBrowser='chromium'
let g:EclimCompletionMethod='omnifunc'

augroup myvimrc
    " close preview window on leaving the insert mode
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " F5 bindings for different filetypes 
    autocmd FileType python nmap <silent> <buffer> <F5> :!python % <CR>
    autocmd FileType java nmap <buffer> <F5> :Java % <CR>
    autocmd FileType c nmap <buffer> <F5> :!gcc -Wall % -o %< && ./%< <CR>
    autocmd FileType cpp nmap <buffer> <F5> :!g++ -Wall % -o %< && ./%< <CR>

augroup END

let g:LatexBox_Folding=1
let g:LatexBox_completion_close_braces=1
let g:LatexBox_latexmk_async=1
nnoremap <leader>ll :Latexmk <CR>
nnoremap <leader>lv :LatexView <CR>

" allows cursor change in tmux mode

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" ALE settings

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8'],
\   'c': ['clang'],
\   'latex': ['chktex'],
\}
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

" ultisnips settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"


call plug#begin('~/.vim/plugged')

    Plug 'bling/vim-airline/'
    Plug 'bling/vim-bufferline/'
    Plug 'kien/ctrlp.vim/'
    Plug 'sjl/gundo.vim/'
    Plug 'majutsushi/tagbar/'
    Plug 'tpope/vim-surround/'
    Plug 'tpope/vim-commentary/'
    Plug 'morhetz/gruvbox/'
    Plug 'LaTeX-Box-Team/LaTeX-Box'
    Plug 'Shougo/neocomplete.vim'
    Plug 'mattn/emmet-vim'
    Plug 'w0rp/ale'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
     
call plug#end()

colorscheme gruvbox
