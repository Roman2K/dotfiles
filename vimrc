set nocompatible

""
" Plugins
"
call plug#begin("~/.vim-plug")
Plug 'editorconfig/editorconfig-vim'
if isdirectory($HOME."/opt/homebrew")
  Plug '~/opt/homebrew/opt/fzf'
else
  Plug '~/opt/linuxbrew/opt/fzf'
endif
Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'JMcKiern/vim-venter'
" Themes
Plug 'w0ng/vim-hybrid'
Plug 'morhetz/gruvbox'
" Syntax highlighting
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'elzr/vim-json'
Plug 'cespare/vim-toml'
Plug 'gabrielelana/vim-markdown'
Plug 'chr4/nginx.vim'
Plug 'digitaltoad/vim-jade'
Plug 'zaiste/tmux.vim'
Plug 'docker/docker', {'rtp': 'contrib/syntax/vim'}
Plug 'elmcast/elm-vim'
Plug 'rhysd/vim-crystal'
Plug 'digitaltoad/vim-pug'
Plug 'elixir-editors/vim-elixir'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
call plug#end()

""
" Config
"
set encoding=utf-8
set modeline modelines=1
set number
set laststatus=2
set ruler
set bs=2
set hlsearch
set cursorline
set textwidth=80
set nowrap
set formatoptions=croq
set mouse=
if exists("+colorcolumn")
  set colorcolumn=+1
endif
let mapleader=","
nmap Q <nop>
nmap q <nop>
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
" Unprintable characters
"
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<

""
" Theme
"
silent! colorscheme hybrid
set background=dark

""
" Filetypes
"
autocmd BufNewFile,BufRead Gemfile,Vagrantfile,*.jbuilder set filetype=ruby

""
" Markdown
"
autocmd FileType markdown set textwidth=80

""
" Per-directory config
" https://stackoverflow.com/a/18933951
"
set exrc

""
" Fix for OS X crontab -e
" See http://calebthompson.io/crontab-and-vim-sitting-in-a-tree/
"
autocmd FileType crontab setlocal nobackup nowritebackup

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
let g:go_term_enabled = 1

""
" Key bindings
"
nmap <c-l> :nohlsearch<cr>
nmap <c-p> :FZF<cr>
nmap <leader>s :wa<cr>
nmap <leader>n :cnext<cr>
nmap <leader>x :silent exec "!echo \| nc -U /tmp/execod.sock"<cr>
autocmd FileType go nmap <leader><leader> <Plug>(go-build)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType ruby nmap <leader><leader> :!ruby -c %<cr>
