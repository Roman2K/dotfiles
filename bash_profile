OPT=$HOME/opt
CODE=$HOME/code
BIN=$CODE/bin
BIN2=$HOME/bin
TMP=$HOME/tmp
BINS=$OPT/bins

BREW=$OPT/homebrew
if [ ! -d $BREW ]; then
  BREW=$OPT/linuxbrew
fi

add_default_pkgconfig() {
  local d=/usr/lib/x86_64-linux-gnu/pkgconfig
  [ -d "$d" ] && export PKG_CONFIG_PATH="$d:$PKG_CONFIG_PATH"
}
add_default_pkgconfig

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

command_exists() {
  cmd=$1
  command -v $cmd > /dev/null
}

##
# Run within tmux by default
#
add_opt "$BREW"
add_opt "$BINS"
m() {
  local shell="bash"
  if command_exists reattach-to-user-namespace; then
    shell="reattach-to-user-namespace $shell"
  fi
  local args=$@
  [ $# = 0 ] && args=(new)
  tmux set -g default-command "$shell" \; "${args[@]}"
}
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
export PATH="$BIN:$BIN2:$PATH"

##
# .local
#
add_opt $HOME/.local

##
# pyenv, etc.
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
add_xenv pyenv
add_xenv goenv
export PATH="node_modules/.bin:$PATH"
export GOPATH="$HOME/.go:$CODE/go"

##
# asdf
#
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

##
# Rust
#
add_opt "$HOME/.cargo"
eval "$(rustup completions bash)"

##
# Crystal
#
configure_crystal() {
  local env=`crystal env`
  if grep -q '^CRYSTAL_PATH="/usr/local/Cellar' <<<"$env"; then
    eval "$env"
    export CRYSTAL_PATH="$BREW${CRYSTAL_PATH#/usr/local}"
  fi
}
configure_crystal

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
alias l="git log --pretty=oneline --abbrev-commit"
alias lv="git log -p"
alias lvs="git log --stat"
alias a="git add"
alias co="git commit"
alias prebase="git pull --rebase"
alias cl="git clone"
alias b="bundle exec"
alias c="b rails c"
alias rg="rg -g '!vendor'"
alias grep="grep --color=auto"
alias serve="python3 -m http.server 8000"
alias pbpaste="ssh -p2200 winpc bash -lc pbpaste"
alias pbcopy="ssh -p2200 winpc bash -lc pbcopy"
export GREP_COLORS='1;31'

# Dockerized PostgreSQL
# alias psql="docker run -it --rm --network postgres \
#   -e PGHOST=postgres -e PGUSER=postgres \
#   postgres psql"
psql() {
  (cd ~/code/services2/docker-compose \
    && ./run run --rm -e PGPASSWORD=postgres postgres \
      psql -h postgres -U postgres -v ON_ERROR_STOP=1)
}

# Dockerized Redis
redis-cli() {
  svc=$1; shift
  echo "connecting to $svc" >&2
  (cd ~/code/services2/docker-compose \
    && ./run run --rm "$svc" redis-cli -h "$svc" "$@")
}

# Dockerized InfluxDB
influx() {
  (cd ~/code/services2/docker-compose \
    && ./run run --rm influxdb2 influx -host influxdb.home -port 80 "$@")
}
influx2() {
  (cd ~/code/services2/docker-compose \
    && ./run run --rm influxdb2 influx -host influxdb2 "$@")
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
mount-tmp() {
  exe=mount-tmp
  [[ "$(uname -s)" = "Linux" ]] && exe=$exe-linux
  command $exe "$@"
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
  local paths=(
    /usr/share/bash-completion/completions/git
    /usr/lib/git-core/git-sh-prompt
    "$BREW"/etc/bash_completion
  )
  for f in "${paths[@]}"; do
    [ -f "$f" ] && source "$f"
  done
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
gpg_is_v2() {
  command_exists gpg \
    && command gpg --version | grep -q '(GnuPG) 2\.'
}
if ! gpg_is_v2; then
  alias gpg=gpg2
fi

true
