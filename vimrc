set nocompatible

""
" Plugins
"
call plug#begin('~/.vim-plug')
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', {'dir': '~/opt/homebrew/opt/fzf'}
 \ | Plug 'junegunn/fzf.vim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
" Themes
Plug 'w0ng/vim-hybrid'
" Syntax highlighting
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'elzr/vim-json'
Plug 'gabrielelana/vim-markdown'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'zaiste/tmux.vim'
Plug 'docker/docker', {'rtp': 'contrib/syntax/vim'}
call plug#end()

""
" Config
"
set encoding=utf-8
set modeline
set modelines=1
set laststatus=2
set ruler
set bs=2
set number
set hlsearch
set cursorline
set textwidth=80
set nowrap
set formatoptions=croqwan1j
set mouse=
set ignorecase
set smartcase
if exists('+colorcolumn')
  set colorcolumn=+1
endif
let mapleader=','
nmap <C-l> :nohlsearch<CR>
nmap Q <Nop>
nmap q <Nop>
nmap n nzz
nmap N Nzz
set splitbelow
set splitright

""
" wildmenu
" See http://stackoverflow.com/a/526940
"
set wildmenu
set wildmode=longest,list

""
" Theme
"
silent! colorscheme hybrid
set background=dark

""
" Filetypes
"
autocmd BufNewFile,BufRead Gemfile,Vagrantfile set filetype=ruby

""
" Markdown
"
autocmd FileType markdown set textwidth=80

""
" Fix for OS X crontab -e
" See http://calebthompson.io/crontab-and-vim-sitting-in-a-tree/
"
autocmd filetype crontab setlocal nobackup nowritebackup

""
" fzf
"
nmap <C-p> :FZF<CR>

""
" SuperTab
"
let g:SuperTabCompleteCase = "match"

""
" vim-go
" 
let g:go_bin_path = expand("~/.vim-go")
let g:go_fmt_command = "goimports"
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
