## Install

    $ tools/install

## Uninstall

    $ tools/uninstall

## tmux

Configure the range of ports to be displayed in `~/.tmux/conf/my-ports`.

## Vim

### Bundles

* [EditorConfig](https://github.com/editorconfig/editorconfig-vim)
* [eunuch.vim](https://github.com/tpope/vim-eunuch)
* [ctrlp.vim](https://github.com/kien/ctrlp.vim)
* [Supertab](https://github.com/ervandew/supertab)
* [Tabular.vim](https://github.com/godlygeek/tabular)
* [vim-airline](https://github.com/bling/vim-airline)
* [Vim Git Gutter](https://github.com/airblade/vim-gitgutter)
* [undotree](https://github.com/mbbill/undotree)
* [surround.vim](https://github.com/tpope/vim-surround)
* [EasyMotion](https://github.com/Lokaltog/vim-easymotion)
* [fugitive.vim](https://github.com/tpope/vim-fugitive)
* [commentary.vim](https://github.com/tpope/vim-commentary)
* [ag.vim](https://github.com/rking/ag.vim)

Notable shortcuts:

Bundle       | Trigger         | Description
------------ | -------------   | -----------
vim-eunuch   | :Remove         | Delete file
vim-eunuch   | :Move           | Rename file
ctrlp.vim    | Ctrl + P        | Fuzzy file finder
ctrlp.vim    | Ctrl + X        | Open match in horizontal split
ctrlp.vim    | Ctrl + V        | Open match in vertical split
Supertab     | Tab             | Autocomplete
Tabular.vim  | :Tab /=         | https://github.com/godlygeek/tabular
Tabular.vim  | ,=              | Align on =
Tabular.vim  | ,:              | Align on :
undotree     | :UndotreeToggle |
surround.vim | cs'"            | Replace surrounding " with '
EasyMotion   | ,,w             | Visual motion selection
fugitive.vim | :Gcommit        |
(dotfiles)   | Ctrl + L        | Clear search results
(dotfiles)   | ,r              | Run ./reload

Other features:

* vim-airline statusline (always visible)
* Configure per-filetype identation style in `.editorconfig`, see the EditorConfig [example file](http://editorconfig.org/#example-file)
* Swap files are kept in `~/.vim/swap` (see option [`directory`](http://vimdoc.sourceforge.net/htmldoc/options.html#%27directory%27)) instead of littering the file's parent directory

### Themes

* [hybrid.vim](https://github.com/w0ng/vim-hybrid)
* [Solarized](https://github.com/altercation/vim-colors-solarized)

colorscheme | Terminal.app settings
----------- | ---------------------
hybrid      | Hybrid.terminal
solarized   | Solarized Dark.terminal

### Syntax highlighting

* [vim-javascript](https://github.com/pangloss/vim-javascript)
* [vim-coffee-script](https://github.com/kchmck/vim-coffee-script)
* [vim-json](https://github.com/elzr/vim-json)
* [vim-markdown](https://github.com/plasticboy/vim-markdown)
* [nginx-vim-syntax](https://github.com/evanmiller/nginx-vim-syntax)
* [vim-jade](https://github.com/digitaltoad/vim-jade)
* [stylus.vim](https://github.com/wavded/vim-stylus)
* [vim-fish](https://github.com/dag/vim-fish)
