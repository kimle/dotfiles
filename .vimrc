let Tlist_Compact_Format=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Close_On_Select=1
nnoremap <C-1> :TlistToggle<CR>
runtime! vimrc_example.vim
let mapleader=","
syntax on

" color settings
set t_Co=256
set background=dark
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_termcolors=256
" let g:molokai_original=1
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
set colorcolumn=80
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
    let g:python3_host_prog='/usr/bin/python3'
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    set clipboard=unnamedplus
    set title
endif

filetype plugin indent on
set grepprg=grep\ -nH\ $*
" let g:tex_flavor='latex'
set backupdir=~/Documents/.vimtmp
set directory=~/Documents/.vimtmp
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after'

map <C-n> :NERDTreeToggle<CR>
nnoremap <leader>u :GundoToggle<CR>

" save session
nnoremap <leader>s :'mksession'<CR>

" Ctrl-P settings
let g:ctrlp_match_window='bottom,order:ttb'
let g:ctrlp_switch_buffer=0
let g:ctrlp_working_path_mode=0

" airline settings
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'

" enable deoplete at startup
let g:deoplete#enable_at_startup=1

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

    " neomake settings
    autocmd! BufWritePost * Neomake
augroup END

"let g:neomake_enabled_makers=['makeprg']
let g:neomake_python_enabled_makers=['python']
let g:neomake_haskell_enabled_makers=['hlint']
let g:neomake_c_enabled_makers=['clang']
let g:neomake_cpp_enabled_makers=['clang']
" let g:neomake_sh_enabled_makers=['shellcheck']
let g:neomake_tex_enabled_makers=['chktex']
let g:neomake_airline=1
let g:neomake_open_list=2
set errorformat=%f:%l:%m

" LaTeX-Box settings
"augroup latexsettings
"    autocmd FileType tex set spell
"augroup END
let g:LatexBox_Folding=1
let g:LatexBox_completion_close_braces=1
let g:LatexBox_latexmk_async=1
nnoremap <leader>ll :Latexmk <CR>
nnoremap <leader>lv :LatexView <CR>

let g:indent_guides_start_level=2

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

call plug#begin('~/.vim/plugged')

    Plug 'bling/vim-airline/'
    Plug 'bling/vim-bufferline/'
    Plug 'scrooloose/nerdtree/', { 'on': 'NERDTreeToggle' }
    Plug 'kien/ctrlp.vim/'
    Plug 'sjl/gundo.vim/'
    Plug 'majutsushi/tagbar/'
    Plug 'tpope/vim-surround/'
    Plug 'tpope/vim-fugitive/'
    Plug 'tpope/vim-commentary/'
    Plug 'morhetz/gruvbox/'
    Plug 'nathanaelkane/vim-indent-guides/'
    Plug 'benekastah/neomake'
    Plug 'LaTeX-Box-Team/LaTeX-Box'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi'
    Plug 'ervandew/supertab'
    Plug 'mattn/emmet-vim'
    Plug 'vim-airline/vim-airline-themes'
     
call plug#end()
colorscheme gruvbox
