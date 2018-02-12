"
" vim-plug
"

call plug#begin('~/.cache/vim-plug')

" Plugins
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" File Tree
Plug 'scrooloose/nerdtree'
" Executing build/syntax checking for projects
Plug 'neomake/neomake'
" JavaScript syntax
Plug 'pangloss/vim-javascript'
" Agda syntax
Plug 'derekelkins/agda-vim'
" Rust syntax
Plug 'rust-lang/rust.vim'
" Idris syntax
Plug 'idris-hackers/idris-vim'
" JSX syntax
Plug 'mxw/vim-jsx'
" Reason syntax + helpers
Plug 'reasonml-editor/vim-reason-plus'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Optional 'multi-entry selection UI' for LanguageClient
Plug 'junegunn/fzf'
" Color schemes
Plug 'frankier/neovim-colors-solarized-truecolor-only'

call plug#end()

"
" General Config
"

" Custom Leader
let mapleader = ","

" Syntax highlighing
syntax enable

" Indent
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" Show cursor line and column number
set ruler
" Show line number at beginning of each line
set number

" Syntax highlighing
syntax enable

" Indent
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" Color scheme
set termguicolors
colorscheme solarized
set background=dark

" Color scheme
set termguicolors
colorscheme solarized
set background=dark

" Recognize .vue as .html
au BufRead,BufNewFile *.vue setfiletype html

" Use system clipboard
set clipboard=unnamedplus

" Allow use of the mouse
set mouse=a

" Resizing buffers/splits shortcuts
nnoremap <silent> <Leader>h :vertical resize -5<CR>
nnoremap <silent> <Leader>j :resize -5<CR>
nnoremap <silent> <Leader>k :resize +5<CR>
nnoremap <silent> <Leader>l :vertical resize +5<CR>

"
" deoplete.nvim
"

call deoplete#enable()

"
" Neomake
"

autocmd! BufWritePost * Neomake

let g:neomake_javascript_enabled_makers = ['eslint']

"
" Language Client
"

let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }

nnoremap <silent> gd :call LanguageClient_textDocument_definition()<cr>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<cr>
nnoremap <silent> <cr> :call LanguageClient_textDocument_hover()<cr>

"
" Language / filetype recognition
"

" Prolog is not perl
au BufRead,BufNewFile *.pl setfiletype prolog
" Agda
au BufNewFile,BufRead *.agda setf agda
" Use JSX in .js files
let g:jsx_ext_required = 0
