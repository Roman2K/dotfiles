case "$(uname)" in
  "Linux") IS_LINUX=1;;
  "Darwin") IS_OSX=1;;
esac

OPT=$HOME/opt
CODE=$HOME/code
MAP=$HOME/map
BIN=$CODE/bin

[ $IS_OSX ] && {
  HOMEBREW=$OPT/homebrew
}

_add_opt() {
  local d=$1
  [ -d "$d/bin" ] && export PATH="$d/bin:$PATH"
  [ -d "$d/sbin" ] && export PATH="$d/sbin:$PATH"
  [ -d "$d/share/man" ] && export MANPATH="$d/share/man:$MANPATH"

  [ $IS_OSX ] && {
    [ -d "$d/lib" ] && {
      # http://stackoverflow.com/a/4250665
      export LIBRARY_PATH="$d/lib:$LIBRARY_PATH"
      export LD_LIBRARY_PATH="$d/lib:$LD_LIBRARY_PATH"
    }
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

_build_cdpath() {
  local p="."
  for d in "$MAP" "$CODE"; do
    [ -d "$d" ] && p="$p:$d"
  done
  echo "$p"
}

# opt/
for d in "$OPT"/*; do
  _add_opt "$d"
done

# rbenv & co
_add_xenv rbenv
_add_xenv ndenv
_add_xenv pyenv

# bin/
export PATH="$BIN:$PATH"

# Bash
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export CDPATH=$(_build_cdpath)

# Vim / Neovim
#export VIMRUNTIME="$HOMEBREW/share/vim/vim74"
#export EDITOR="nvim"
export EDITOR="vim"
alias vim=$EDITOR
alias vi=$EDITOR

# Node.js
export PATH="node_modules/.bin:$PATH"

# Go
export GOROOT=$(go env GOROOT)

# Shortcuts
alias r="exec bash -l"
alias m="tmux"
alias ll="ls -lph"
alias st="git status"
alias di="git diff"
alias dis="git diff --staged"
alias a="git add"
alias co="git commit"
alias lg="git log --pretty=format:'%C(yellow)%h %C(white)%ci%Creset %s%C(blue)%d %C(yellow)%an%Creset' --abbrev-commit"
alias b="bundle exec"
alias c="b rails c"
alias sp="b rspec --format progress --colour"

# Colors
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'
[ $IS_OSX ] && alias ls='ls -G'
[ $IS_LINUX ] && alias ls='ls --color=auto'

# $PS1
PROMPT_COMMAND='_ps1'
GIT_PS1_SHOWDIRTYSTATE=1
_ps1() {
  local last=$?
  local RED="\[\033[31m\]"
  local GREEN="\[\033[32m\]"
  local YELLOW="\[\033[93m\]"
  local RESET="\[\033[0m\]"
  local cwd=$(pwd)
  local wd=${cwd#$HOME}
  [ "$wd" = "$cwd" ] || wd="~$wd"
  local last_status_color
  [ $last -eq 0 ] && last_status_color=$GREEN || last_status_color=$RED
  local git=$(__git_ps1 " ${YELLOW}%s${RESET}")
  PS1="${wd}${git}${last_status_color} ❯${RESET} "
  [ $IS_LINUX ] && PS1="\u@\h:$PS1"
}

[ $IS_OSX ] && {
  # Homebrew
  [ "$HOMEBREW" ] && {
    source "$HOMEBREW"/etc/bash_completion
  }

  # Java
  export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

  # OS X copy-paste
  # http://superuser.com/questions/231130/unable-to-use-pbcopy-while-in-tmux-session
  alias pbcopy="reattach-to-user-namespace pbcopy"
  alias pbpaste="reattach-to-user-namespace pbpaste"

  # VirtualBox
  d="/Applications/VirtualBox.app/Contents/MacOS"
  [ -d "$d" ] && export PATH="$d:$PATH"

  # Docker
  export DOCKER_HOST="tcp://localhost:2375"
}

[ $IS_LINUX ] && {
  # Git
  source /usr/share/git/completion/git-prompt.sh
}

# Custom
find $HOME/.bash/enabled -mindepth 1 -maxdepth 1 -not -type d \
  | while read f; do
    source "$f" || break
  done

true
