OPT=$HOME/opt
CODE=$HOME/code
BIN=$CODE/bin
TMP=$HOME/tmp
HOMEBREW=$OPT/homebrew
if [[ $- == *i* ]]; then
  IS_INTERACTIVE=1
fi

_add_opt() {
  local d=$1
  [ -d "$d/bin" ] && export PATH="$d/bin:$PATH"
  [ -d "$d/sbin" ] && export PATH="$d/sbin:$PATH"
  [ -d "$d/share/man" ] && export MANPATH="$d/share/man:$MANPATH"
  [ -d "$d/lib/pkgconfig" ] && export PKG_CONFIG_PATH="$d/lib/pkgconfig:$PKG_CONFIG_PATH"
  [ -d "$d/include" -a -d "$d/lib" ] && {
    export CPATH="$d/include:$CPATH"
    export LIBRARY_PATH="$d/lib:$LIBRARY_PATH"
  }
}

_add_xenv() {
  local name=$1
  local root=$HOME/.$name
  [ -d "$root" ] || return
  _add_opt "$root"
  export PATH="$root/shims:$PATH"
  local compl="$root/completions/$name.bash"
  [ -f "$compl" ] && source "$compl"
}

##
# bin/
#
export PATH="$BIN:$PATH"

##
# opt/
#
for d in "$OPT"/*; do
  _add_opt "$d"
done
export CPATH="$OPT/graphicsmagick/include/GraphicsMagick:$CPATH"

##
# rbenv & co
#
_add_xenv rbenv
_add_xenv ndenv
_add_xenv pyenv
_add_xenv goenv

##
# pyenv Bash completion
#
v=$(pyenv global 2>/dev/null)
if [[ "$v" ]] && [ "$v" != "system" ]; then
  d="$HOME/.pyenv/versions/$v/etc/bash_completion.d"
  if [ -d "$d" ]; then
    while read f; do
      source "$f"
    done < <(find "$d" -mindepth 1 -maxdepth 1)
  fi
fi

##
# Go
# 
# Add ~/.go first so that an accidental `go get`s would fetch dependencies there 
# instead of polluting ~/code/go
# 
export GOPATH="$HOME/.go:$CODE/go"

##
# Node.js
#
export PATH="node_modules/.bin:$PATH"

##
# Neovim
#
export EDITOR="nvim"
alias vim=$EDITOR
alias vi=$EDITOR

##
# Locale
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

##
# Bash
#
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export CDPATH=".:$CODE:$HOME"

##
# CDPATH fix
#
# When CDPATH is defined, Bash prints the directory after cd-ing to relative
# paths. It's problematic for shims (ndenv, etc.) that use cd: directories land
# in the stdout of the script being run via the shim. Prevent that by
# suppressing cd's stdout output.
#
cd() {
  builtin cd "$@" > /dev/null
}

##
# cd aliases
#
# Defined after opt/ has been added to PATH because we need promptpath
#
shopt -s cdable_vars
while IFS=$'\t' read short long; do
  [[ "$short" =~ ^[A-Za-z] ]] || continue
  declare $short=$long
done < <(promptpath)

##
# Shortcuts
#
alias r="exec bash -l"
alias m="tmux"
alias ls='ls -G'
alias ll="ls -lph"
alias st="git status"
alias di="git diff"
alias dis="git diff --staged"
alias l="git log --stat"
alias a="git add"
alias co="git commit"
alias prebase="git pull --rebase"
alias cl="git clone"
alias b="bundle exec"
alias c="b rails c"

##
# grep colors
#
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'

##
# ~/tmp
#
t() {
  _t_mnt && cd $TMP && ll hello_world
}
tgo() {
  _t_mnt && mkdir -p $TMP/go/src && ll $TMP/hello_world && cd $TMP/go/src && {
    export GOPATH="$TMP/go" \
      && echo "Set GOPATH=$GOPATH"
  }
}
_t_mnt() {
  mount-tmp check || mount-tmp
}

##
# $PS1
#
PROMPT_COMMAND='_ps1'
GIT_PS1_SHOWDIRTYSTATE=1
_ps1() {
  local last=$?
  local RED="\[\033[31m\]"
  local GREEN="\[\033[32m\]"
  local YELLOW="\[\033[93m\]"
  local RESET="\[\033[0m\]"
  local host=""
  [ "$SSH_CONNECTION" ] && host="$(hostname):"
  local cwd=$(promptpath "$(pwd)" || pwd)
  local last_status_color
  [ $last -eq 0 ] && last_status_color=$GREEN || last_status_color=$RED
  local git=$(__git_ps1 " ${YELLOW}%s${RESET}")
  PS1="${host}${cwd}${git}${last_status_color}\$${RESET} "
  [ $last -ne 0 ] && PS1="${last_status_color}${last}${RESET} $PS1"
}

##
# VirtualBox
#
d="/Applications/VirtualBox.app/Contents/MacOS"
[ -d "$d" ] && export PATH="$d:$PATH"

##
# /usr/local sanity check
#
_check_empty() {
  local d=$1
  if [ -e $d ] && [ $(find $d | head -2 | wc -l) -gt 1 ]; then
    {
      echo "ATTENTION: non-empty $d"
      echo
      find $d | while read line; do
        echo "  found $line"
      done
      echo
    } >&2
  fi
}
_check_empty "/usr/local"

##
# Machine-specific bash config
#
if [ -d "$HOME/.bash/enabled" ]; then
  while read f; do
    source "$f"
  done < <(find "$HOME/.bash/enabled" \
    -mindepth 1 -maxdepth 1 \
    -not -type d \
    -name \*.sh \
  )
fi

##
# fzf
#
_load_fzf() {
  local shdir="$HOMEBREW/opt/fzf/shell"
  source "$shdir/key-bindings.bash"
}
_load_fzf

##
# Bash completion
#
_enable_bashcomp() {
  local f="$HOMEBREW"/etc/bash_completion
  [ -f "$f" ] && source "$f"
}
_enable_bashcomp

##
# Finally, always run within tmux
#
if (( IS_INTERACTIVE )) \
    && [ "$TERM_PROGRAM" = "Apple_Terminal" -a -z "$TMUX" ]; then
  $HOMEBREW/bin/tmux
  return
fi

true
