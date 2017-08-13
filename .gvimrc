runtime! vimrc_example.vim

execute pathogen#infect()

let mapleader=","
syntax on

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
set backupdir=~/Documents/.vimtmp
set directory=~/Documents/.vimtmp
set tags=./tags;/

" color settings
" set background=dark
" let g:gruvbox_contrast_dark='soft'
colorscheme nord

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

if has('gui_macvim')
    set lines=40
    set columns=85
    set guifont=Monaco:h13

    function! InsertStatuslineColor(mode)
    if a:mode=='i'
        hi StatusLine guibg=#282828 ctermfg=6 guifg=#83a598 ctermbg=0
    elseif a:mode=='r'
        hi StatusLine guibg=#282828 ctermfg=5 guifg=#8ec07c ctermbg=0
    else
        hi StatusLine guibg=#282828 ctermfg=1 guifg=#a89984 ctermbg=0
    endif
    endfunction

    au InsertEnter * call InsertStatuslineColor(v:insertmode)
    au InsertLeave * hi StatusLine guibg=#282828 ctermfg=8 guifg=#a89984 ctermbg=15

    " TODO: Detect Visual mode and color the statusline
    " if visualmode()=='V'
    "     hi StatusLine guibg=#282828 ctermfg=6 guifg=#fe8019 ctermbg=0
    " endif

    hi StatusLine guibg=#282828 ctermfg=8 guifg=#a89984 ctermbg=15
endif


" hide dotfiles by default in netrw
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_hide=1

" UltiSnips settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" c config
augroup c
    autocmd!
    autocmd FileType c compiler gcc
    autocmd BufWritePost *.c silent make%< | silent redraw!
augroup END

" python config
augroup python
    autocmd!
    autocmd FileType python compiler pylint
    autocmd BufWritePost *.py silent make%< | silent redraw!
augroup END

" javascript config
augroup javascript
    autocmd!
    autocmd FileType javascript compiler jshint
    autocmd BufWritePost *.js silent make%< | silent redraw!
augroup END

" quickfix config
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd VimEnter        *     cwindow
augroup END

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
