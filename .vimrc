runtime! vimrc_example.vim

let mapleader=","
filetype plugin indent on
syntax on

colorscheme OceanicNext

" general settings
set number
set numberwidth=3 
set relativenumber
set laststatus=2
set backspace=indent,eol,start
set ruler
set noundofile
set lazyredraw
set wildmenu
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.pdf,*/ENV/*
set path& | let &path.="**"
set backupdir=~/.vimtmp
set directory=~/.vimtmp
set tags=./tags;/

set statusline=
set statusline+=%n: 
set statusline+=%t
set statusline+=%m
set statusline+=%r
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=[%{strlen(&fenc)?&fenc:'none'}]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\  
set statusline+=

" switch buffers without saving
set hidden

" wraps text at 80 characters
set textwidth=80
set formatoptions+=t

" Sets <TAB> to use 4 spaces 
autocmd Filetype html setlocal ts=2 sw=2 sts=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 sts=2 expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Enables incremental search and highlights results
set incsearch
set hlsearch

" Folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" Mappings
nnoremap <leader><space> :nohlsearch<CR>

inoremap jk <esc> 
                    
" space open/closes folds 
nnoremap <space> za

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line 
nnoremap B ^
nnoremap E $
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

" find files
nnoremap <leader>f :find *

" python config
augroup python
    autocmd!
    " python autofmt with black
    autocmd BufWritePre *.py execute ':Black'
augroup END
