case "$(uname)" in
  "Linux") IS_LINUX=1;;
  "Darwin") IS_OSX=1;;
esac

OPT=$HOME/opt
CODE=$HOME/code
BIN=$CODE/bin

if (( IS_OSX )); then
  HOMEBREW=$OPT/homebrew
elif (( IS_LINUX )); then
  HOMEBREW=$OPT/linuxbrew
fi

# TODO opt_dirs:
#
#   [ -d "$d/include" ] && export CPATH="$d/include:$CPATH"
#   [ -d "$d/lib" ] && {
#     export LIBRARY_PATH="$d/lib:$LIBRARY_PATH"
#     export LD_LIBRARY_PATH="$d/lib:$LD_LIBRARY_PATH"
#   }
#

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

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# opt/
for d in "$OPT"/*; do
  _add_opt "$d"
done
export CPATH="$OPT/graphicsmagick/include/GraphicsMagick:$CPATH"

# rbenv & co
_add_xenv rbenv
_add_xenv ndenv
_add_xenv pyenv

# pyenv Bash completion
v=$(pyenv global 2>/dev/null)
if [[ "$v" ]] && [ "$v" != "system" ]; then
  d="$HOME/.pyenv/versions/$v/etc/bash_completion.d"
  if [ -d "$d" ]; then
    while read f; do
      source "$f"
    done < <(find "$d" -mindepth 1 -maxdepth 1)
  fi
fi

# bin/
export PATH="$BIN:$PATH"

# Bash
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export CDPATH=".:$CODE/go/src:$CODE:$HOME"

# Vim / Neovim
if [ "$HOMEBREW" ]; then
  d="$HOMEBREW/share/vim/vim74"
  [ -d "$d" ] && export VIMRUNTIME="$d"
fi
export EDITOR="nvim"
#export EDITOR="vim"
alias vim=$EDITOR
alias vi=$EDITOR

# Node.js
export PATH="node_modules/.bin:$PATH"

# Go
export GOPATH="$HOME/.go:_vendor:$CODE/go"
(( IS_LINUX )) && export GOROOT="$OPT/go"
IFS=':' read -ra dirs <<< "$GOPATH"
for d in "${dirs[@]}"; do
  export PATH="$d/bin:$PATH"
done

# Shortcuts
alias r="exec bash -l"
alias m="tmux"
alias ll="ls -lph"
alias st="git status"
alias mst="mg status"
alias di="git diff"
alias dis="git diff --staged"
alias a="git add"
alias co="git commit"
alias prebase="git pull --rebase"
alias lg="git log --pretty=format:'%C(yellow)%h %C(white)%ci%Creset %s%C(blue)%d %C(yellow)%an%Creset' --abbrev-commit"
alias cl="git clone"
alias b="bundle exec"
alias c="b rails c"
alias sp="b rspec --format progress --colour --no-profile"

git-annex() {
  git-annex-docker git-annex "$@"
}

git-annex-docker() {
  docker run \
    -v /mnt/Volumes:/mnt/Volumes \
    -v /mnt/roman:/mnt/roman \
    -v /mnt/git-annex-data:/mnt/data \
    "$@"
}

t() {
  if (( IS_OSX )); then
    (mount-tmp check || mount-tmp) && cd $HOME/tmp && ll hello_world
  else
    (test -d $HOME/tmp || (mkdir $HOME/tmp && touch $HOME/tmp/hello_world)) \
      && cd $HOME/tmp \
      && ll hello_world
  fi
}

# Make it easier to cd: cd $go
go="$CODE/go/src"

# Colors
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'
(( IS_OSX )) && alias ls='ls -G'
(( IS_LINUX )) && alias ls='ls --color=auto'

# $PS1
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

if [ "$HOMEBREW" ]; then
  f="$HOMEBREW"/etc/bash_completion
  [ -f "$f" ] && source "$f"
fi

if (( IS_OSX )); then
  # Java
  export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

  # VirtualBox
  d="/Applications/VirtualBox.app/Contents/MacOS"
  [ -d "$d" ] && export PATH="$d:$PATH"

  # docker-machine env
  export DOCKER_TLS_VERIFY="1"
  export DOCKER_HOST="tcp://192.168.99.102:2376"
  export DOCKER_CERT_PATH="/Users/roman/.docker/machine/machines/docker-dev"
  export DOCKER_MACHINE_NAME="docker-dev"

  if [ -e /usr/local ]; then
    {
      echo "ATTENTION: /usr/local raped!"
      echo
      find /usr/local | while read line; do
        echo "  >> $line"
      done
      echo
    } >&2
  fi
fi

if (( IS_LINUX )); then
  # Git
  source /usr/share/bash-completion/completions/git

  # Postgres
  d="/usr/lib/postgresql/9.3/bin"
  if [ -d "$d" ]; then
    export PATH="$d:$PATH"
  fi
fi

# Custom
while read f; do
  source "$f"
done < <(find $HOME/.bash/enabled -mindepth 1 -maxdepth 1 -not -type d -name \*.sh)

if [ "$TERM_PROGRAM" = "Apple_Terminal" -a -z "$TMUX" ]; then
  $HOMEBREW/bin/tmux
  return
fi

true
