let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-1> :TlistToggle<CR>
runtime! vimrc_example.vim

set t_Co=256
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
let mapleader=","
syntax enable

" switch buffers without saving
set hidden

set number
set numberwidth=3 
set laststatus=2

" wraps text at 80 characters
set textwidth=80
" set colorcolumn=80
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

" Enables incremental search and highlights results "
set incsearch
set hlsearch

nnoremap <leader><space> :nohlsearch<CR>

" Folding "
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" space open/closes folds "
nnoremap <space> za

" move vertically by visual line "
nnoremap j gj
nnoremap k gk
"
" move to beginning/end of line "
nnoremap B ^
nnoremap E $
"
nnoremap ^ <nop>
nnoremap $ <nop>

" buffer movement "
nnoremap <leader>gp :bp<CR>
nnoremap <leader>gn :bn<CR>
nnoremap <leader>l :ls<CR>

" highlight last inserted text "
nnoremap gV `[v`]

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor="latex"
set backupdir=~/Documents/.vimtmp
set directory=~/Documents/.vimtmp
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after'

map <C-n> :NERDTreeToggle<CR>
nnoremap <leader>u :GundoToggle<CR>

" save session
nnoremap <leader>s :'mksession!'<CR>

" Ctrl-P settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0

"let g:airline#extensions#tabline#enabled = 1
"let g:airline_powerline_fonts = 1
"let g:airline_theme = 'molokai'

" autoclose YCM window after insertion
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" tagbar settings
nmap <F9> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

" eclim settings
let g:EclimBrowser = 'chromium'
let g:EclimCompletionMethod = 'omnifunc'

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

call plug#begin('~/.vim/plugged')

"Plug 'bling/vim-airline'
Plug 'bling/vim-bufferline/'
Plug 'scrooloose/nerdtree/', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe/'
Plug 'kien/ctrlp.vim/'
Plug 'sjl/gundo.vim/'
Plug 'scrooloose/syntastic/'
Plug 'majutsushi/tagbar/'
Plug 'tpope/vim-surround/'
Plug 'tpope/vim-fugitive/'

call plug#end()
