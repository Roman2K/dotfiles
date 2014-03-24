OPT=$HOME/opt
HOMEBREW=$OPT/homebrew
RBENV=$HOME/.rbenv
NDENV=$HOME/.ndenv
CODE=$HOME/code
BIN=$CODE/bin
PYTHON=$HOME/Library/Python

add_opt() {
  local d=$1
  [ -d "$d/bin" ] && export PATH="$d/bin:$PATH"
  [ -d "$d/sbin" ] && export PATH="$d/sbin:$PATH"
  [ -d "$d/share/man" ] && export MANPATH="$d/share/man:$MANPATH"
  [ -d "$d/lib" ] && {
    # http://stackoverflow.com/a/4250665
    export LIBRARY_PATH="$d/lib:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$d/lib:$LD_LIBRARY_PATH"
  }
  [ -d "$d/etc/bash_completion.d" ] && {
    for f in "$d/etc/bash_completion.d"/*; do
      case "$f" in
        */homebrew/etc/bash_completion.d/ag.bashcomp.sh) continue ;;
      esac
      source "$f"
    done
  }
}

# ~/opt
for d in "$OPT"/*; do
  add_opt "$d"
done

# Python
# http://fvue.nl/wiki/Bash:_Piped_%60while-read'_loop_starts_subshell
[ -d "$PYTHON" ] && {
  while read dir
  do
    export PATH="$dir:$PATH"
  done < <(find "$PYTHON" -maxdepth 2 -name bin)
}

# rbenv
add_opt "$RBENV"
export PATH="$RBENV/shims:$PATH"

# ndenv
add_opt "$NDENV"
export PATH="$NDENV/shims:$PATH"

# Node.js
export PATH="node_modules/.bin:$PATH"

# Java
export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# bin/
export PATH="$BIN:$PATH"

# Neovim
export VIMRUNTIME="$HOMEBREW/share/vim/vim74"
export EDITOR="nvim"
alias vim=$EDITOR
alias vi=$EDITOR

# Shortcuts
alias r="exec bash -l"
alias ll="ls -lph"
alias st="git status"
alias di="git diff"
alias a="git add"
alias co="git commit"
alias lo="git log --graph --abbrev-commit --date=relative"
alias b="bundle exec"
alias c="b rails c"
alias sp="b rspec --format progress --colour"

# OS X copy-paste
# http://superuser.com/questions/231130/unable-to-use-pbcopy-while-in-tmux-session
alias pbcopy="reattach-to-user-namespace pbcopy"
alias pbpaste="reattach-to-user-namespace pbpaste"

# Colors
export CLICOLOR=1
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'

# $PS1
PROMPT_COMMAND='ps1'
GIT_PS1_SHOWDIRTYSTATE=1
function ps1() {
  local last=$?
  local RED="\[\033[0;31m\]"
  local GREEN="\[\033[0;32m\]"
  local YELLOW="\[\033[0;33m\]"
  local NORMAL="\[\033[0m\]"
  local cwd=$(pwd)
  local wd=${cwd#$HOME}
  [ "$wd" = "$cwd" ] || wd="~$wd"
  local last_status_color
  [ $last -eq 0 ] && last_status_color=$GREEN || last_status_color=$RED
  local git=$(__git_ps1 " ${YELLOW}%s${NORMAL}")
  PS1="${wd}${git}${last_status_color} •${NORMAL} "
}

# gist
function gist() {
  d="$OPT"/gist
  ruby -I "$d"/lib "$d"/bin/gist "$@"
}

# cddb
source "$CODE/cddb/bashcomp.sh"
