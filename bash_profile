case "$(uname)" in
  "Linux") IS_LINUX=1;;
  "Darwin") IS_OSX=1;;
esac

OPT=$HOME/opt
RBENV=$HOME/.rbenv
NDENV=$HOME/.ndenv
CODE=$HOME/code
MAP=$HOME/map
BIN=$CODE/bin

[[ $IS_OSX ]] && {
  HOMEBREW=$OPT/homebrew
  PYTHON=$HOME/Library/Python
}

[[ $IS_LINUX ]] && {
  . /usr/share/git/completion/git-prompt.sh
}

add_opt() {
  local d=$1
  [ -d "$d/bin" ] && export PATH="$d/bin:$PATH"
  [ -d "$d/sbin" ] && export PATH="$d/sbin:$PATH"
  [ -d "$d/share/man" ] && export MANPATH="$d/share/man:$MANPATH"

  [[ $IS_OSX ]] && {
    [ -d "$d/lib" ] && {
      # http://stackoverflow.com/a/4250665
      export LIBRARY_PATH="$d/lib:$LIBRARY_PATH"
      export LD_LIBRARY_PATH="$d/lib:$LD_LIBRARY_PATH"
    }
  }
}

# ~/opt
for d in "$OPT"/*; do
  add_opt "$d"
done

# rbenv
add_opt "$RBENV"
export PATH="$RBENV/shims:$PATH"

# ndenv
add_opt "$NDENV"
export PATH="$NDENV/shims:$PATH"

# Node.js
export PATH="node_modules/.bin:$PATH"

# bin/
export PATH="$BIN:$PATH"

# Vim / Neovim
#export VIMRUNTIME="$HOMEBREW/share/vim/vim74"
#export EDITOR="nvim"
export EDITOR="vim"
alias vim=$EDITOR
alias vi=$EDITOR

# Shortcuts
alias r="exec bash -l"
alias ll="ls -lph"
alias st="git status"
alias di="git diff"
alias dis="git diff --staged"
alias a="git add"
alias co="git commit"
alias lg="git log --pretty=format:'%C(221)%h%Creset%C(111)%d%Creset %s %C(241)(%cd) %C(221)%an%Creset' --abbrev-commit"
alias b="bundle exec"
alias c="b rails c"
alias sp="b rspec --format progress --colour"

# cd
export CDPATH=".:$MAP:$CODE"

# Colors
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'
[[ $IS_OSX ]] && alias ls='ls -G'
[[ $IS_LINUX ]] && alias ls='ls --color=auto'

# $PS1
PROMPT_COMMAND='ps1'
GIT_PS1_SHOWDIRTYSTATE=1
ps1() {
  local last=$?
  local RED="\[\033[38;5;203m\]"
  local GREEN="\[\033[38;5;113m\]"
  local YELLOW="\[\033[38;5;221m\]"
  local NORMAL="\[\033[0m\]"
  local cwd=$(pwd)
  local wd=${cwd#$HOME}
  [ "$wd" = "$cwd" ] || wd="~$wd"
  local last_status_color
  [ $last -eq 0 ] && last_status_color=$GREEN || last_status_color=$RED
  local git=$(__git_ps1 " ${YELLOW}%s${NORMAL}")
  PS1="${wd}${git}${last_status_color} ❯${NORMAL} "
  [[ $IS_LINUX ]] && PS1="\u@\h:$PS1"
}

# gist
gist() {
  local d="$OPT"/gist
  ruby -I "$d"/lib "$d"/bin/gist "$@"
}

# JSON pretty-printing
pretty_json() {
  underscore print --color
}

[[ $IS_OSX ]] && {
  # Python
  # http://fvue.nl/wiki/Bash:_Piped_%60while-read'_loop_starts_subshell
  [ -d "$PYTHON" ] && {
    while read dir; do
      export PATH="$dir:$PATH"
    done < <(find "$PYTHON" -maxdepth 2 -name bin)
  }

  # Java
  export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

  # Homebrew
  source "$HOMEBREW"/etc/bash_completion

  # OS X copy-paste
  # http://superuser.com/questions/231130/unable-to-use-pbcopy-while-in-tmux-session
  alias pbcopy="reattach-to-user-namespace pbcopy"
  alias pbpaste="reattach-to-user-namespace pbpaste"

  # VirtualBox
  export PATH="/Applications/VirtualBox.app/Contents/MacOS:$PATH"

  # Docker
  export DOCKER_HOST="tcp://localhost:2375"
}

# Bash profile
find $HOME/.bash/ -mindepth 1 -maxdepth 1 -not -type d |
  while read f; do
    source "$f" || break
  done

true
