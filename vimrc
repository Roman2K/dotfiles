set nocompatible " Vim

""
" Vundle
" https://github.com/gmarik/vundle
"
let root='~/.vim'
let bundle_dir=root.'/bundle'
let src='http://github.com/gmarik/vundle.git'
filetype off
exec 'set runtimepath+='.bundle_dir.'/vundle'
call vundle#rc(bundle_dir)
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
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-fugitive'
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
silent! colorscheme hybrid

""
" Config
"
exec 'set directory='.root.'/swap,.'
set modeline
set modelines=1
set bs=2
set number
set laststatus=2
set hlsearch
set cursorline
set textwidth=80
set nowrap
if exists('+colorcolumn')
  set colorcolumn=+1
endif
let mapleader=','
nmap <Leader>= :Tab /=<CR>
vmap <Leader>= :Tab /=<CR>
nmap <Leader>: :Tab /:\zs<CR>
vmap <Leader>: :Tab /:\zs<CR>
vmap <Leader>t :Tab /\|<CR>
nmap <C-l> :nohlsearch<CR>

""
" wildmenu
" http://stackoverflow.com/a/526940
"
set wildmenu
set wildmode=longest,list,full

""
" Vundle
" https://github.com/gmarik/vundle/issues/16#issuecomment-1044901
"
filetype plugin indent on
