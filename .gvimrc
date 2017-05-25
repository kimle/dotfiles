runtime! vimrc_example.vim

execute pathogen#infect()

let mapleader=","
syntax on


" general settings
set number
set numberwidth=3 
set laststatus=2
set relativenumber 
set backspace=indent,eol,start
set ruler
set cursorline
set noundofile
set lazyredraw
set wildmenu
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.pdf
set path+=**

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname=GitBranch()
    return strlen(l:branchname) >0?'  '.l:branchname.' ':''
endfunction


" Define all the different modes
" let g:currentmode={
"     \ 'n'  : 'Normal',
"     \ 'no' : 'N·Operator Pending',
"     \ 'v'  : 'Visual',
"     \ 'V'  : 'V·Line',
"     \ ''   : 'V·Block',
"     \ 's'  : 'Select',
"     \ 'S'  : 'S·Line',
"     \ ''   : 'S·Block',
"     \ 'i'  : 'Insert',
"     \ 'R'  : 'Replace',
"     \ 'Rv' : 'V·Replace',
"     \ 'c'  : 'Command',
"     \ 'cv' : 'Vim Ex',
"     \ 'ce' : 'Ex',
"     \ 'r'  : 'Prompt',
"     \ 'rm' : 'More',
"     \ 'r?' : 'Confirm',
"     \ '!'  : 'Shell',
"     \}

" if version >= 700
"     au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
"     au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
" endif

hi StatusLine ctermbg=4 ctermfg=2

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\[%{mode()}\]
set statusline+=%n: 
set statusline+=%t
set statusline+=%h
set statusline+=%m
set statusline+=%r
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=

" color settings
set t_Co=256
set background=dark
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_termcolors=256
let g:rehash256=1
colorscheme gruvbox

" switch buffers without saving
set hidden

" wraps text at 80 characters
set textwidth=80
set formatoptions+=t

" Sets <TAB> to use 4 spaces 
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
    set columns=100
    set guifont=Monaco:h13
endif


" hide dotfiles by default in netrw
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_hide=1

" UltiSnips settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"


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

" utilises say
nnoremap <silent> <leader>u :<C-u>call system('say ' . expand('<cword>'))<CR>
