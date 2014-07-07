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
Bundle 'kien/ctrlp.vim'
Bundle 'ervandew/supertab'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-commentary'
Bundle 'rking/ag.vim'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-eunuch'
Bundle 'mbbill/undotree'
Bundle 'Lokaltog/vim-easymotion'

Bundle 'w0ng/vim-hybrid'

Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'elzr/vim-json'
Bundle 'plasticboy/vim-markdown'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'digitaltoad/vim-jade'
Bundle 'wavded/vim-stylus'
Bundle 'dag/vim-fish'
Bundle 'zaiste/tmux.vim'
Bundle 'groenewege/vim-less'

""
" Go
"
set runtimepath+=$GOROOT/misc/vim

""
" Themes
"
syntax on
set background=dark
silent! colorscheme hybrid

""
" Config
"
exec 'set directory='.root.'/swap,.'
runtime macros/matchit.vim
set modeline
set modelines=1
set bs=2
set number
set laststatus=2
set hlsearch
set cursorline
set textwidth=80
set nowrap
set formatoptions-=t  " disable line wrapping
if exists('+colorcolumn')
  set colorcolumn=+1
endif
let mapleader=','
nmap <C-l> :nohlsearch<CR>
let g:vim_markdown_folding_disabled=1

""
" ,r Run ./reload
"
command Reload execute "let _ = system('./reload')"
nmap <Leader>r :Reload<CR>

""
" CtrlP
"
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_user_command = 'ag %s -l -g "" --nocolor'

""
" Syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1

""
" wildmenu
" http://stackoverflow.com/a/526940
"
set wildmenu
set wildmode=longest,list

""
" Vundle
" https://github.com/gmarik/vundle/issues/16#issuecomment-1044901
"
filetype plugin indent on
