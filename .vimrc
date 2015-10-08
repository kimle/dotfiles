let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-1> :TlistToggle<CR>
runtime! vimrc_example.vim
set t_Co=256
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
set number
set numberwidth=3 
set laststatus=2
set tabstop=4
set shiftwidth=4
set expandtab
set noundofile
set backupdir=~/Documents/.vimtmp
set directory=~/Documents/.vimtmp
map <C-n> :NERDTreeToggle<CR>

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim/'

call plug#end()
