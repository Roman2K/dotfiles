set nocompatible " Vim

""
" Vundle
" https://github.com/gmarik/vundle
"
let root='~/.vim/bundle'
let src='http://github.com/gmarik/vundle.git'
filetype off
exec 'set runtimepath+='.root.'/vundle'
call vundle#rc(root)
Bundle 'gmarik/vundle'

""
" Bundles
"
Bundle 'editorconfig/editorconfig-vim'
Bundle 'tpope/vim-eunuch'
Bundle 'kien/ctrlp.vim'
Bundle 'ervandew/supertab'
Bundle 'godlygeek/tabular'
Bundle 'bling/vim-airline'
Bundle 'airblade/vim-gitgutter'
Bundle 'mbbill/undotree'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'elzr/vim-json'
Bundle 'altercation/vim-colors-solarized'
Bundle 'w0ng/vim-hybrid'

""
" Themes
"
syntax on
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme hybrid

""
" Config
"
set number
set laststatus=2
set list
let mapleader=','
nmap <Leader>= :Tab /=<CR>
vmap <Leader>= :Tab /=<CR>
nmap <Leader>: :Tab /:\zs<CR>
vmap <Leader>: :Tab /:\zs<CR>
vmap <Leader>t :Tab /\|<CR>

""
" Vundle
" https://github.com/gmarik/vundle/issues/16#issuecomment-1044901
"
filetype plugin indent on
