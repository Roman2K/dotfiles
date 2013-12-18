OPT=$HOME/opt
HOMEBREW=$LOCAL/homebrew
RBENV=$HOME/.rbenv
NDENV=$HOME/.ndenv
BIN=$HOME/code/bin

add_opt() {
	local d=$1
	[ -d "$d/bin" ] && export PATH="$d/bin:$PATH"
	[ -d "$d/sbin" ] && export PATH="$d/sbin:$PATH"
	[ -d "$d/lib" ] && {
		export LD_LIBRARY_PATH="$d/lib:$LD_LIBRARY_PATH"
		export DYLD_FALLBACK_LIBRARY_PATH="$d/lib:$DYLD_FALLBACK_LIBRARY_PATH"
	}
	[ -d "$d/include" ] && {
		export C_INCLUDE_PATH="$d/include:$C_INCLUDE_PATH"
		export CPLUS_INCLUDE_PATH="$d/include:$CPLUS_INCLUDE_PATH"
	}
}

# ~/opt
for d in "$OPT"/*
do add_opt "$d"
done

# rbenv
add_opt "$RBENV"
export PATH="$RBENV/shims:$PATH"

# ndenv
add_opt "$NDENV"
export PATH="$NDENV/shims:$PATH"

# bin/
export PATH="$BIN:$PATH"

# Vim
export EDITOR='vim'
alias vi='vim'

# Shortcuts
alias r='exec bash -l'
alias st='git status'
alias di='git diff'
alias a='git add'
alias co='git commit'

# Colors
export CLICOLOR=1
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'
