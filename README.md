## Install

    $ cd
    $ mkdir -p .vim/{bundle,swap}
    $ git clone https://github.com/gmarik/vundle .vim/bundle/vundle
    $ vim +BundleInstall +BundleClean +qa

## Bundles

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

Other features:

* vim-airline statusline (always visible)
* Configure per-filetype identation style in `.editorconfig`, see the EditorConfig [example file](http://editorconfig.org/#example-file).
* Swap files are kept in `~/.vim/swap` (see option [`directory`](http://vimdoc.sourceforge.net/htmldoc/options.html#%27directory%27)) instead of littering the file's parent directory.

## Themes

* [Solarized](https://github.com/altercation/vim-colors-solarized)
* [hybrid.vim](https://github.com/w0ng/vim-hybrid)

colorscheme | Terminal.app settings
----------- | ---------------------
solarized   | Solarized Dark.terminal
hybrid      | Hybrid.terminal

## Syntax highlighting

* [vim-javascript](https://github.com/pangloss/vim-javascript)
* [vim-coffee-script](https://github.com/kchmck/vim-coffee-script)
* [vim-json](https://github.com/elzr/vim-json)
