set nocompatible " Vim

let root='~/.vim'

filetype off

""
" Vim-Plug plugins
"
call plug#begin(root.'/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'kien/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'bling/vim-airline'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-eunuch'
Plug 'mbbill/undotree'
Plug 'Lokaltog/vim-easymotion'
Plug 'davidoc/taskpaper.vim'
" Org mode
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
" Gist
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
" Themes
Plug 'w0ng/vim-hybrid'
" Syntax highlighting
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'digitaltoad/vim-jade'
Plug 'wavded/vim-stylus'
Plug 'dag/vim-fish'
Plug 'zaiste/tmux.vim'
Plug 'groenewege/vim-less'
Plug 'docker/docker', {'rtp': 'contrib/syntax/vim'}
call plug#end()

""
" Ruby
"
autocmd BufNewFile,BufRead Gemfile set filetype=ruby

""
" Themes
"
syntax on
silent! colorscheme hybrid

""
" Config
"
set encoding=utf-8  " see http://unix.stackexchange.com/a/23414
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
" Fix for OS X crontab -e
" See http://calebthompson.io/crontab-and-vim-sitting-in-a-tree/
"
autocmd filetype crontab setlocal nobackup nowritebackup

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
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0

""
" Syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 2
let g:syntastic_ruby_mri_quiet_messages = { "regex": [
  \ '\m^shadowing outer local variable ',
  \ '\m`&'' interpreted as argument prefix',
  \ '\m`*'' interpreted as argument prefix'
  \ ] }

""
" wildmenu
" http://stackoverflow.com/a/526940
"
set wildmenu
set wildmode=longest,list

""
" Vagrant
"
autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby

""
" Vundle
" https://github.com/gmarik/vundle/issues/16#issuecomment-1044901
"
filetype plugin indent on
