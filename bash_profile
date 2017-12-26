OPT=$HOME/opt
CODE=$HOME/code
BIN=$CODE/bin
TMP=$HOME/tmp
BINS=$OPT/bins
HOMEBREW=$OPT/homebrew
LINUXBREW=$OPT/linuxbrew

BREW=$HOMEBREW
if [ -d $LINUXBREW ]; then
  BREW=$LINUXBREW
fi

add_opt() {
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

##
# Run within tmux by default
#
add_opt "$BREW"
add_opt "$BINS"
configure_tmux() {
  local shell="bash"
  if which reattach-to-user-namespace &> /dev/null; then
    shell="reattach-to-user-namespace $shell"
  fi
  alias m="tmux set -g default-command '$shell' \; new"
}
configure_tmux
if [[ $- == *i* ]] && [ "$TERM_PROGRAM" = "Apple_Terminal" -a -z "$TMUX" ]; then
  m
fi

##
# opt/
#
for d in "$OPT"/*; do
  [ "$d" = "$BREW" -o "$d" = "$BINS" ] && continue
  add_opt "$d"
done

##
# bin/
#
export PATH="$BIN:$PATH"
export CPATH="$OPT/graphicsmagick/include/GraphicsMagick:$CPATH"

##
# rbenv, etc.
#
add_xenv() {
  local name=$1
  local root=$HOME/.$name
  [ -d "$root" ] || return
  add_opt "$root"
  export PATH="$root/shims:$PATH"
  local compl="$root/completions/$name.bash"
  [ -f "$compl" ] && source "$compl"
}
add_xenv rbenv
add_xenv ndenv
add_xenv pyenv
add_xenv goenv
export PATH="node_modules/.bin:$PATH"
export GOPATH="$HOME/.go:$CODE/go"

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
# Shortcuts
#
alias r="exec bash -l"
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
alias rg="rg -g '!vendor'"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"
alias grep="grep --color=auto"
export GREP_COLORS='1;31'

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
# Neovim
#
export EDITOR="nvim"
alias vim=$EDITOR
alias vi=$EDITOR

##
# ~/tmp
#
t() {
  t_mnt && cd $TMP && ll hello_world
}
tgo() {
  t_mnt && mkdir -p $TMP/go/src && ll $TMP/hello_world && cd $TMP/go/src && {
    export GOPATH="$TMP/go" \
      && echo "Set GOPATH=$GOPATH"
  }
}
t_mnt() {
  mount-tmp check || mount-tmp
}

##
# docker-machine
#
dksetup() {
  docker-machine start
  [ "$(docker-machine status)" == Running ] \
    && eval "$(docker-machine env)" \
    && docker ps
}

##
# vol
#
vol() {
  if [ $# != 1 ]; then
    osascript -e "output volume of (get volume settings)"
    return $?
  fi
  osascript -e "set volume output volume $1"
}

##
# $PS1
#
PROMPT_COMMAND='prompt'
GIT_PS1_SHOWDIRTYSTATE=1
prompt() {
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
# Application executables
#
add_app_exes() {
  local dirs=(
    /Applications/VirtualBox.app/Contents/MacOS
  )
  for d in ${dirs[*]}; do
    [ -d "$d" ] && export PATH="$d:$PATH"
  done
}
add_app_exes

##
# fzf
#
configure_fzf() {
  local shdir="$BREW/opt/fzf/shell"
  source "$shdir/key-bindings.bash"
}
configure_fzf

##
# Bash completion
#
configure_bashcomp() {
  local f="$BREW"/etc/bash_completion
  [ -f "$f" ] && source "$f"
}
configure_bashcomp

##
# pyenv Bash completion
#
configure_pyenv_bashcomp() {
  local v=$(pyenv global 2>/dev/null)
  if [[ "$v" ]] && [ "$v" != "system" ]; then
    local d="$HOME/.pyenv/versions/$v/etc/bash_completion.d"
    if [ -d "$d" ]; then
      while read f; do
        source "$f"
      done < <(find "$d" -mindepth 1 -maxdepth 1)
    fi
  fi
}
configure_pyenv_bashcomp

##
# Local bash config
#
configure_local_bash_config() {
  if [ -d "$HOME/.bash/enabled" ]; then
    while read f; do
      source "$f"
    done < <(find "$HOME/.bash/enabled" \
      -mindepth 1 -maxdepth 1 \
      -not -type d \
      -name \*.sh \
    )
  fi
}
configure_local_bash_config

##
# gpg2
#
export GPG_TTY=$(tty)
alias gpg=gpg2

true
