" cd to dir containing current file.
command Cdd :cd %:p:h

" Syntax hilighting, indent
syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread

" UTF-8
if has("mult_byte")
    set enc=utf-8
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,prc
endif

" Enable line numbers
set number
" Show the cursor position all the time
set ruler

" Set LocalLeader
let maplocalleader = "\\"

" Use system clipboard
set clipboard=unnamed
vnoremap <C-C> "+y
map <C-V> "+P

" Dark style
set background=dark

" Use spaces instead of tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Use Vim defaults instead of 100% vi compatibility
set nocompatible

" more powerful backspacing
set backspace=indent,eol,start

" Keep 50 lines of command line history
set history=50
" Files with these suffixes have lower priority in wildcards
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Highlight search results
set hlsearch

" For regular expressions
set magic

if has('gui_running')
    colorscheme solarized
    set cursorline 
    " set guifont=Deja\ Vu\ Sans\ Mono\ 11
    set guifont=Source\ Code\ Pro\ 11
    set guifontwide=Unifont\ Medium\ 12
else
    " colorscheme desert256
    " colorscheme devbox-dark-256
    " colorscheme 245-jungle
    colorscheme anotherdark
    " colorscheme wombat256
endif

" Enable neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1

" Set haddock browser
let g:haddock_browser = "/usr/bin/chromium"

" Override idris settings
"let g:idris_indent_if      = 4
"let g:idris_indent_case    = 4
"let g:idris_indent_let     = 4
"let g:idris_indent_where   = 4
"let g:idris_indent_do      = 4
"let g:idris_indent_rewrite = 4

" Enable Agda filetype
au BufNewFile,BufRead *.agda setf agda

" Add Agda stdlib search path
let g:agda_extraincpaths = ["/home/fiendfan1/workspace/agda/agda-stdlib/src"]
