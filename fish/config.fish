set OPT $HOME/opt
set HOMEBREW $OPT/homebrew
set RBENV $HOME/.rbenv
set NDENV $HOME/.ndenv
set CODE $HOME/code
set BIN $CODE/bin

function add_opt
  set -l d $argv[1]
  if not test -d $d
    echo "add_opt: not a directory: $d" ^-
    return 1
  end
  prepend_valid_dir PATH            $d/bin
  prepend_valid_dir PATH            $d/sbin 
  prepend_valid_dir MANPATH         $d/share/man
  prepend_valid_dir LIBRARY_PATH    $d/lib
  prepend_valid_dir LD_LIBRARY_PATH $d/lib
end

function prepend_valid_dir
  set -l var $argv[1]
  set -l dir $argv[2]
  test -d $dir; or return 1
  set -x $var $dir $$var
end

# ~/opt
for d in $OPT/*
  add_opt $d
end

# rbenv
add_opt $RBENV
prepend_valid_dir PATH $RBENV/shims

# ndenv
add_opt $NDENV
prepend_valid_dir PATH $NDENV/shims

# Node.js
prepend_valid_dir PATH node_modules/.bin

# Java
set -x JAVA_HOME "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# bin/
prepend_valid_dir PATH $BIN

# Neovim
set -x VIMRUNTIME $HOMEBREW/share/vim/vim74
set -x EDITOR nvim
alias vim $EDITOR
alias vi $EDITOR

# Shortcuts
alias r "exec bash -l"
alias ll "ls -lph"
alias st "git status"
alias di "git diff"
alias a "git add"
alias co "git commit"
alias lo "git log --graph --abbrev-commit --date=relative"
alias b "bundle exec"
alias c "b rails c"
alias sp "b rspec --format progress --colour"

# OS X copy-paste
# http://superuser.com/questions/231130/unable-to-use-pbcopy-while-in-tmux-session
alias pbcopy "reattach-to-user-namespace pbcopy"
alias pbpaste "reattach-to-user-namespace pbpaste"

# Colors
set -x CLICOLOR 1
set -x GREP_OPTIONS "--color=auto"
set -x GREP_COLOR "1;31"
